Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B3B445AA1
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 20:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhKDTk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 15:40:59 -0400
Received: from mail.xenproject.org ([104.130.215.37]:55058 "EHLO
        mail.xenproject.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhKDTk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 15:40:58 -0400
X-Greylist: delayed 1578 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2021 15:40:58 EDT
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1mii9I-0002gZ-11; Thu, 04 Nov 2021 19:11:44 +0000
Received: from host86-165-42-146.range86-165.btcentralplus.com ([86.165.42.146] helo=debian.home)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1mii9H-0003yn-Og; Thu, 04 Nov 2021 19:11:43 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH RESEND] KVM: x86: Make sure KVM_CPUID_FEATURES really are KVM_CPUID_FEATURES
Date:   Thu,  4 Nov 2021 19:11:37 +0000
Message-Id: <20211104191137.4409-1-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently when kvm_update_cpuid_runtime() runs, it assumes that the
KVM_CPUID_FEATURES leaf is located at 0x40000001. This is not true,
however, if Hyper-V support is enabled. In this case the KVM leaves will
be offset.

This patch introdues as new 'kvm_cpuid_base' field into struct
kvm_vcpu_arch to track the location of the KVM leaves and function
kvm_update_cpuid_base() (called from kvm_update_cpuid_runtime()) to locate
the leaves using the 'KVMKVMKVM\0\0\0' signature. Adjustment of
KVM_CPUID_FEATURES will hence now target the correct leaf.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 50 +++++++++++++++++++++++++++++----
 2 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88fce6ab4bbd..21133ffa23e9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -725,6 +725,7 @@ struct kvm_vcpu_arch {
 
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
+	u32 kvm_cpuid_base;
 
 	u64 reserved_gpa_bits;
 	int maxphyaddr;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2d70edb0f323..2cfb8ec4f570 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -99,11 +99,46 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
 	return 0;
 }
 
+static void kvm_update_cpuid_base(struct kvm_vcpu *vcpu)
+{
+	u32 function;
+
+	for (function = 0x40000000; function < 0x40010000; function += 0x100) {
+		struct kvm_cpuid_entry2 *best = kvm_find_cpuid_entry(vcpu, function, 0);
+
+		if (best) {
+			char signature[12];
+
+			*(u32 *)&signature[0] = best->ebx;
+			*(u32 *)&signature[4] = best->ecx;
+			*(u32 *)&signature[8] = best->edx;
+
+			if (!memcmp(signature, "KVMKVMKVM\0\0\0", 12))
+				break;
+		}
+	}
+	vcpu->arch.kvm_cpuid_base = function;
+}
+
+static inline bool kvm_get_cpuid_base(struct kvm_vcpu *vcpu, u32 *function)
+{
+	if (vcpu->arch.kvm_cpuid_base < 0x40000000 ||
+	    vcpu->arch.kvm_cpuid_base >= 0x40010000)
+		return false;
+
+	*function = vcpu->arch.kvm_cpuid_base;
+	return true;
+}
+
 void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 {
+	u32 base;
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
+	if (!kvm_get_cpuid_base(vcpu, &base))
+		return;
+
+	best = kvm_find_cpuid_entry(vcpu, base + KVM_CPUID_FEATURES, 0);
 
 	/*
 	 * save the feature bitmap to avoid cpuid lookup for every PV
@@ -116,6 +151,7 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
+	u32 base;
 
 	best = kvm_find_cpuid_entry(vcpu, 1, 0);
 	if (best) {
@@ -142,10 +178,14 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
-	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
-	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
-		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
-		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
+	kvm_update_cpuid_base(vcpu);
+
+	if (kvm_get_cpuid_base(vcpu, &base)) {
+		best = kvm_find_cpuid_entry(vcpu, base + KVM_CPUID_FEATURES, 0);
+		if (kvm_hlt_in_guest(vcpu->kvm) && best &&
+		    (best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
+			best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
+	}
 
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
 		best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
-- 
2.20.1


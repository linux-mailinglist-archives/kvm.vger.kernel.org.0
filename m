Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96955447C74
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 10:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237165AbhKHJFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 04:05:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235592AbhKHJFo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 04:05:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636362179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DIt0yiHFSDrbNWT83YFxJ3NTN2gTGuSvPTfTKTC9zLQ=;
        b=G5DppNTtfg2RQvg4pI3WqLWAfL50I2gOeYpERoMA6BnHeGTzSMWcL1GHq5hDayEYVOPcwo
        ElKnchCgmxLabbldHqIbXHeV3h++GCKehXiD7d4brbKSJ5BaY0ppmDHkVNM1r6uTr6ub/W
        Yapjc9vY5hghDYfHB4F+vtx1MeQL3G8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-uL-OogzLMC6KIedenxW0BA-1; Mon, 08 Nov 2021 04:02:56 -0500
X-MC-Unique: uL-OogzLMC6KIedenxW0BA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BBCE1572B;
        Mon,  8 Nov 2021 09:02:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB71519C79;
        Mon,  8 Nov 2021 09:02:46 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Maxim Levitsky <mlevitsk@redhat.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v4] KVM: x86: inhibit APICv when KVM_GUESTDBG_BLOCKIRQ active
Date:   Mon,  8 Nov 2021 11:02:45 +0200
Message-Id: <20211108090245.166408-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_GUESTDBG_BLOCKIRQ relies on interrupts being injected using
standard kvm's inject_pending_event, and not via APICv/AVIC.

Since this is a debug feature, just inhibit APICv/AVIC while
KVM_GUESTDBG_BLOCKIRQ is in use on at least one vCPU.

Fixes: 61e5f69ef0837 ("KVM: x86: implement KVM_GUESTDBG_BLOCKIRQ")

Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/avic.c         |  3 ++-
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 arch/x86/kvm/x86.c              | 20 ++++++++++++++++++++
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88fce6ab4bbd7..8f6e15b95a4d8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1034,6 +1034,7 @@ struct kvm_x86_msr_filter {
 #define APICV_INHIBIT_REASON_IRQWIN     3
 #define APICV_INHIBIT_REASON_PIT_REINJ  4
 #define APICV_INHIBIT_REASON_X2APIC	5
+#define APICV_INHIBIT_REASON_BLOCKIRQ	6
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 8052d92069e01..affc0ea98d302 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -904,7 +904,8 @@ bool svm_check_apicv_inhibit_reasons(ulong bit)
 			  BIT(APICV_INHIBIT_REASON_NESTED) |
 			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
-			  BIT(APICV_INHIBIT_REASON_X2APIC);
+			  BIT(APICV_INHIBIT_REASON_X2APIC) |
+			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
 
 	return supported & BIT(bit);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 71f54d85f104c..e4fc9ff7cd944 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7565,7 +7565,8 @@ static void hardware_unsetup(void)
 static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 {
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
-			  BIT(APICV_INHIBIT_REASON_HYPERV);
+			  BIT(APICV_INHIBIT_REASON_HYPERV) |
+			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
 
 	return supported & BIT(bit);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b0..6064ac47c8a37 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10703,6 +10703,24 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static void kvm_arch_vcpu_guestdbg_update_apicv_inhibit(struct kvm *kvm)
+{
+	bool inhibit = false;
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	down_write(&kvm->arch.apicv_update_lock);
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ) {
+			inhibit = true;
+			break;
+		}
+	}
+	__kvm_request_apicv_update(kvm, !inhibit, APICV_INHIBIT_REASON_BLOCKIRQ);
+	up_write(&kvm->arch.apicv_update_lock);
+}
+
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg)
 {
@@ -10755,6 +10773,8 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 
 	static_call(kvm_x86_update_exception_bitmap)(vcpu);
 
+	kvm_arch_vcpu_guestdbg_update_apicv_inhibit(vcpu->kvm);
+
 	r = 0;
 
 out:
-- 
2.26.3


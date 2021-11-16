Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516274533C7
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 15:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237221AbhKPOOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 09:14:14 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:40732 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbhKPON5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 09:13:57 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 076851FD29;
        Tue, 16 Nov 2021 14:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637071860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tjy1v3vITNPwlNOSQc088H+Lg3ARv2JRHzBDzbf0ttw=;
        b=WiJzx+hNhCEeO+55fKFOz4pL3UrZ+NbTtzPpdrjjnQLjlRW79v/KNunUfrUHN/tfsC2Ugs
        jDQ70Tqk0Qn9ANDgp79L6V9Xrml4ea1OcK9IRCe98LnVzat8Ek7dBCS8Ud+DlafpUpHGEf
        SrHEWz7d6yEesMtUeusVi9QU+DvI3vg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8AF8F13BAE;
        Tue, 16 Nov 2021 14:10:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AE+VIPO7k2ExEQAAMHmgww
        (envelope-from <jgross@suse.com>); Tue, 16 Nov 2021 14:10:59 +0000
From:   Juergen Gross <jgross@suse.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 3/4] x86/kvm: add max number of vcpus for hyperv emulation
Date:   Tue, 16 Nov 2021 15:10:53 +0100
Message-Id: <20211116141054.17800-4-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211116141054.17800-1-jgross@suse.com>
References: <20211116141054.17800-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When emulating Hyperv the theoretical maximum of vcpus supported is
4096, as this is the architectural limit for sending IPIs via the PV
interface.

For restricting the actual supported number of vcpus for that case
introduce another define KVM_MAX_HYPERV_VCPUS and set it to 1024, like
today's KVM_MAX_VCPUS. Make both values unsigned ones as this will be
needed later.

The actual number of supported vcpus for Hyperv emulation will be the
lower value of both defines.

This is a preparation for a future boot parameter support of the max
number of vcpus for a KVM guest.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
V3:
- new patch
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/hyperv.c           | 15 ++++++++-------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 886930ec8264..8ea03ff01c45 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -38,7 +38,8 @@
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
-#define KVM_MAX_VCPUS 1024
+#define KVM_MAX_VCPUS 1024U
+#define KVM_MAX_HYPERV_VCPUS 1024U
 #define KVM_MAX_VCPU_IDS kvm_max_vcpu_ids()
 /* memory slots that are not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 3
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 4a555f32885a..c0fa837121f1 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -41,7 +41,7 @@
 /* "Hv#1" signature */
 #define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
 
-#define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, 64)
+#define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_HYPERV_VCPUS, 64)
 
 static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
 				bool vcpu_kick);
@@ -166,7 +166,7 @@ static struct kvm_vcpu *get_vcpu_by_vpidx(struct kvm *kvm, u32 vpidx)
 	struct kvm_vcpu *vcpu = NULL;
 	int i;
 
-	if (vpidx >= KVM_MAX_VCPUS)
+	if (vpidx >= min(KVM_MAX_VCPUS, KVM_MAX_HYPERV_VCPUS))
 		return NULL;
 
 	vcpu = kvm_get_vcpu(kvm, vpidx);
@@ -1446,7 +1446,8 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 		struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
 		u32 new_vp_index = (u32)data;
 
-		if (!host || new_vp_index >= KVM_MAX_VCPUS)
+		if (!host ||
+		    new_vp_index >= min(KVM_MAX_VCPUS, KVM_MAX_HYPERV_VCPUS))
 			return 1;
 
 		if (new_vp_index == hv_vcpu->vp_index)
@@ -1729,7 +1730,7 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
 		return (unsigned long *)vp_bitmap;
 	}
 
-	bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
+	bitmap_zero(vcpu_bitmap, min(KVM_MAX_VCPUS, KVM_MAX_HYPERV_VCPUS));
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (test_bit(kvm_hv_get_vpindex(vcpu), (unsigned long *)vp_bitmap))
 			__set_bit(i, vcpu_bitmap);
@@ -1757,7 +1758,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
 	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
-	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
+	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_HYPERV_VCPUS);
 	unsigned long *vcpu_mask;
 	u64 valid_bank_mask;
 	u64 sparse_banks[64];
@@ -1880,7 +1881,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	struct hv_send_ipi_ex send_ipi_ex;
 	struct hv_send_ipi send_ipi;
 	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
-	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
+	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_HYPERV_VCPUS);
 	unsigned long *vcpu_mask;
 	unsigned long valid_bank_mask;
 	u64 sparse_banks[64];
@@ -2505,7 +2506,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 		case HYPERV_CPUID_IMPLEMENT_LIMITS:
 			/* Maximum number of virtual processors */
-			ent->eax = KVM_MAX_VCPUS;
+			ent->eax = min(KVM_MAX_VCPUS, KVM_MAX_HYPERV_VCPUS);
 			/*
 			 * Maximum number of logical processors, matches
 			 * HyperV 2016.
-- 
2.26.2


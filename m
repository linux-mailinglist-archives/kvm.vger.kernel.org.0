Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFF6351966
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235554AbhDARxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:53:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236489AbhDARpM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:45:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rztrNb6F5ahzxv+jumwK22AuA2Li0uSe6XJqrnEVx5A=;
        b=aMjXIHOaevWVV0Vuj6pnRzSRjnoVGyvz3DKCU4QJs8YCpiS2vRhQT4lLbEaVwaaSjUgJkm
        0kPHq3qzPbomSH4l9wdu7QPAJ+esiKxlZIQHx6BMp8wCIMju2s1SAsNd8P22NtwrxZekmM
        4zocmwuxK7Q375bwOrVBrUNvLLYsS+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-Juh8RkciPdK-t7F2Gk2pnw-1; Thu, 01 Apr 2021 07:16:29 -0400
X-MC-Unique: Juh8RkciPdK-t7F2Gk2pnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9A311005D65;
        Thu,  1 Apr 2021 11:16:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9743B1378E;
        Thu,  1 Apr 2021 11:16:24 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/2] KVM: nSVM: improve SYSENTER emulation on AMD
Date:   Thu,  1 Apr 2021 14:16:14 +0300
Message-Id: <20210401111614.996018-3-mlevitsk@redhat.com>
In-Reply-To: <20210401111614.996018-1-mlevitsk@redhat.com>
References: <20210401111614.996018-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently to support Intel->AMD migration, if CPU vendor is GenuineIntel,
we emulate the full 64 value for MSR_IA32_SYSENTER_{EIP|ESP}
msrs, and we also emulate the sysenter/sysexit instruction in long mode.

(Emulator does still refuse to emulate sysenter in 64 bit mode, on the
ground that the code for that wasn't tested and likely has no users)

However when virtual vmload/vmsave is enabled, the vmload instruction will
update these 32 bit msrs without triggering their msr intercept,
which will lead to having stale values in kvm's shadow copy of these msrs,
which relies on the intercept to be up to date.

Fix/optimize this by doing the following:

1. Enable the MSR intercepts for SYSENTER MSRs iff vendor=GenuineIntel
   (This is both a tiny optimization and also ensures that in case
   the guest cpu vendor is AMD, the msrs will be 32 bit wide as
   AMD defined).

2. Store only high 32 bit part of these msrs on interception and combine
   it with hardware msr value on intercepted read/writes
   iff vendor=GenuineIntel.

3. Disable vmload/vmsave virtualization if vendor=GenuineIntel.
   (It is somewhat insane to set vendor=GenuineIntel and still enable
   SVM for the guest but well whatever).
   Then zero the high 32 bit parts when kvm intercepts and emulates vmload.

Thanks a lot to Paulo Bonzini for helping me with fixing this in the most
correct way.

This patch fixes nested migration of 32 bit nested guests, that was
broken because incorrect cached values of SYSENTER msrs were stored in
the migration stream if L1 changed these msrs with
vmload prior to L2 entry.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 99 +++++++++++++++++++++++++++---------------
 arch/x86/kvm/svm/svm.h |  6 +--
 2 files changed, 68 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 271196400495..6c39b0cd6ec6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -95,6 +95,8 @@ static const struct svm_direct_access_msrs {
 } direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
 	{ .index = MSR_STAR,				.always = true  },
 	{ .index = MSR_IA32_SYSENTER_CS,		.always = true  },
+	{ .index = MSR_IA32_SYSENTER_EIP,		.always = false },
+	{ .index = MSR_IA32_SYSENTER_ESP,		.always = false },
 #ifdef CONFIG_X86_64
 	{ .index = MSR_GS_BASE,				.always = true  },
 	{ .index = MSR_FS_BASE,				.always = true  },
@@ -1258,16 +1260,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm);
 
-	/*
-	 * If hardware supports Virtual VMLOAD VMSAVE then enable it
-	 * in VMCB and clear intercepts to avoid #VMEXIT.
-	 */
-	if (vls) {
-		svm_clr_intercept(svm, INTERCEPT_VMLOAD);
-		svm_clr_intercept(svm, INTERCEPT_VMSAVE);
-		svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
-	}
-
 	if (vgif) {
 		svm_clr_intercept(svm, INTERCEPT_STGI);
 		svm_clr_intercept(svm, INTERCEPT_CLGI);
@@ -2133,9 +2125,11 @@ static int vmload_vmsave_interception(struct kvm_vcpu *vcpu, bool vmload)
 
 	ret = kvm_skip_emulated_instruction(vcpu);
 
-	if (vmload)
+	if (vmload) {
 		nested_svm_vmloadsave(vmcb12, svm->vmcb);
-	else
+		svm->sysenter_eip_hi = 0;
+		svm->sysenter_esp_hi = 0;
+	} else
 		nested_svm_vmloadsave(svm->vmcb, vmcb12);
 
 	kvm_vcpu_unmap(vcpu, &map, true);
@@ -2677,10 +2671,14 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = svm->vmcb01.ptr->save.sysenter_cs;
 		break;
 	case MSR_IA32_SYSENTER_EIP:
-		msr_info->data = svm->sysenter_eip;
+		msr_info->data = (u32)svm->vmcb01.ptr->save.sysenter_eip;
+		if (guest_cpuid_is_intel(vcpu))
+			msr_info->data |= (u64)svm->sysenter_eip_hi << 32;
 		break;
 	case MSR_IA32_SYSENTER_ESP:
-		msr_info->data = svm->sysenter_esp;
+		msr_info->data = svm->vmcb01.ptr->save.sysenter_esp;
+		if (guest_cpuid_is_intel(vcpu))
+			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
 		break;
 	case MSR_TSC_AUX:
 		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
@@ -2885,12 +2883,19 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->vmcb01.ptr->save.sysenter_cs = data;
 		break;
 	case MSR_IA32_SYSENTER_EIP:
-		svm->sysenter_eip = data;
-		svm->vmcb01.ptr->save.sysenter_eip = data;
+		svm->vmcb01.ptr->save.sysenter_eip = (u32)data;
+		/*
+		 * We only intercept the MSR_IA32_SYSENTER_{EIP|ESP} msrs
+		 * when we spoof an Intel vendor ID (for cross vendor migration).
+		 * In this case we use this intercept to track the high
+		 * 32 bit part of these msrs to support Intel's
+		 * implementation of SYSENTER/SYSEXIT.
+		 */
+		svm->sysenter_eip_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
 		break;
 	case MSR_IA32_SYSENTER_ESP:
-		svm->sysenter_esp = data;
-		svm->vmcb01.ptr->save.sysenter_esp = data;
+		svm->vmcb01.ptr->save.sysenter_esp = (u32)data;
+		svm->sysenter_esp_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
 		break;
 	case MSR_TSC_AUX:
 		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
@@ -4009,24 +4014,50 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
 	}
 
-	if (!kvm_vcpu_apicv_active(vcpu))
-		return;
+	if (kvm_vcpu_apicv_active(vcpu)) {
+		/*
+		 * AVIC does not work with an x2APIC mode guest. If the X2APIC feature
+		 * is exposed to the guest, disable AVIC.
+		 */
+		if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
+			kvm_request_apicv_update(vcpu->kvm, false,
+						 APICV_INHIBIT_REASON_X2APIC);
 
-	/*
-	 * AVIC does not work with an x2APIC mode guest. If the X2APIC feature
-	 * is exposed to the guest, disable AVIC.
-	 */
-	if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
-		kvm_request_apicv_update(vcpu->kvm, false,
-					 APICV_INHIBIT_REASON_X2APIC);
+		/*
+		 * Currently, AVIC does not work with nested virtualization.
+		 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
+		 */
+		if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
+			kvm_request_apicv_update(vcpu->kvm, false,
+						 APICV_INHIBIT_REASON_NESTED);
+	}
 
-	/*
-	 * Currently, AVIC does not work with nested virtualization.
-	 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
-	 */
-	if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
-		kvm_request_apicv_update(vcpu->kvm, false,
-					 APICV_INHIBIT_REASON_NESTED);
+	if (guest_cpuid_is_intel(vcpu)) {
+		/*
+		 * We must intercept SYSENTER_EIP and SYSENTER_ESP
+		 * accesses because the processor only stores 32 bits.
+		 * For the same reason we cannot use virtual VMLOAD/VMSAVE.
+		 */
+		svm_set_intercept(svm, INTERCEPT_VMLOAD);
+		svm_set_intercept(svm, INTERCEPT_VMSAVE);
+		svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 0, 0);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 0, 0);
+	} else {
+		/*
+		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
+		 * in VMCB and clear intercepts to avoid #VMEXIT.
+		 */
+		if (vls) {
+			svm_clr_intercept(svm, INTERCEPT_VMLOAD);
+			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
+			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+		}
+		/* No need to intercept these MSRs */
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
+	}
 }
 
 static bool svm_has_wbinvd_exit(void)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8e276c4fb33d..fffdd5fb446d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -28,7 +28,7 @@ static const u32 host_save_user_msrs[] = {
 };
 #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
 
-#define MAX_DIRECT_ACCESS_MSRS	18
+#define MAX_DIRECT_ACCESS_MSRS	20
 #define MSRPM_OFFSETS	16
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
@@ -116,8 +116,8 @@ struct vcpu_svm {
 	struct kvm_vmcb_info *current_vmcb;
 	struct svm_cpu_data *svm_data;
 	u32 asid;
-	uint64_t sysenter_esp;
-	uint64_t sysenter_eip;
+	u32 sysenter_esp_hi;
+	u32 sysenter_eip_hi;
 	uint64_t tsc_aux;
 
 	u64 msr_decfg;
-- 
2.26.2


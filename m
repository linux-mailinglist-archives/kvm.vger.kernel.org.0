Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A6D44D97C
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 16:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbhKKPwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 10:52:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234016AbhKKPw3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 10:52:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636645779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4GMtMseNmc7+Q3zOd1HDu/O9BGn0tIL7Pv+r+PijehA=;
        b=ZjL0K5blPJAeSzYmuC50ckW4bRZmJag2Gn2l91hEGC/54OIXN736sLhMU8DOD0/sMLTZlC
        gUZ9WQqq/gT5WaxVT4Fu3Te1FK1hoT+HSHhUT0+KzpRij9Rvg2G8WIvJMsejByLi9X/3DS
        xyUIvcKDWc1v5r+Q4O1pPwQUaBdxVtA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-_WwJgVf4MsSaksJpdYvk6g-1; Thu, 11 Nov 2021 10:49:36 -0500
X-MC-Unique: _WwJgVf4MsSaksJpdYvk6g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDAA61B2C997;
        Thu, 11 Nov 2021 15:49:33 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68E5060C4B;
        Thu, 11 Nov 2021 15:49:31 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/7] KVM: SEV: Refactor out sev_es_state struct
Date:   Thu, 11 Nov 2021 10:49:24 -0500
Message-Id: <20211111154930.3603189-2-pbonzini@redhat.com>
In-Reply-To: <20211111154930.3603189-1-pbonzini@redhat.com>
References: <20211111154930.3603189-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Gonda <pgonda@google.com>

Move SEV-ES vCPU metadata into new sev_es_state struct from vcpu_svm.

Signed-off-by: Peter Gonda <pgonda@google.com>
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Message-Id: <20211021174303.385706-2-pgonda@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 83 +++++++++++++++++++++---------------------
 arch/x86/kvm/svm/svm.c |  8 ++--
 arch/x86/kvm/svm/svm.h | 26 +++++++------
 3 files changed, 61 insertions(+), 56 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3e2769855e51..d53f71054475 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -590,7 +590,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	 * traditional VMSA as it has been built so far (in prep
 	 * for LAUNCH_UPDATE_VMSA) to be the initial SEV-ES state.
 	 */
-	memcpy(svm->vmsa, save, sizeof(*save));
+	memcpy(svm->sev_es.vmsa, save, sizeof(*save));
 
 	return 0;
 }
@@ -612,11 +612,11 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	 * the VMSA memory content (i.e it will write the same memory region
 	 * with the guest's key), so invalidate it first.
 	 */
-	clflush_cache_range(svm->vmsa, PAGE_SIZE);
+	clflush_cache_range(svm->sev_es.vmsa, PAGE_SIZE);
 
 	vmsa.reserved = 0;
 	vmsa.handle = to_kvm_svm(kvm)->sev_info.handle;
-	vmsa.address = __sme_pa(svm->vmsa);
+	vmsa.address = __sme_pa(svm->sev_es.vmsa);
 	vmsa.len = PAGE_SIZE;
 	return sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
 }
@@ -2026,16 +2026,16 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 	svm = to_svm(vcpu);
 
 	if (vcpu->arch.guest_state_protected)
-		sev_flush_guest_memory(svm, svm->vmsa, PAGE_SIZE);
-	__free_page(virt_to_page(svm->vmsa));
+		sev_flush_guest_memory(svm, svm->sev_es.vmsa, PAGE_SIZE);
+	__free_page(virt_to_page(svm->sev_es.vmsa));
 
-	if (svm->ghcb_sa_free)
-		kfree(svm->ghcb_sa);
+	if (svm->sev_es.ghcb_sa_free)
+		kfree(svm->sev_es.ghcb_sa);
 }
 
 static void dump_ghcb(struct vcpu_svm *svm)
 {
-	struct ghcb *ghcb = svm->ghcb;
+	struct ghcb *ghcb = svm->sev_es.ghcb;
 	unsigned int nbits;
 
 	/* Re-use the dump_invalid_vmcb module parameter */
@@ -2061,7 +2061,7 @@ static void dump_ghcb(struct vcpu_svm *svm)
 static void sev_es_sync_to_ghcb(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct ghcb *ghcb = svm->ghcb;
+	struct ghcb *ghcb = svm->sev_es.ghcb;
 
 	/*
 	 * The GHCB protocol so far allows for the following data
@@ -2081,7 +2081,7 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct ghcb *ghcb = svm->ghcb;
+	struct ghcb *ghcb = svm->sev_es.ghcb;
 	u64 exit_code;
 
 	/*
@@ -2128,7 +2128,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	struct ghcb *ghcb;
 	u64 exit_code = 0;
 
-	ghcb = svm->ghcb;
+	ghcb = svm->sev_es.ghcb;
 
 	/* Only GHCB Usage code 0 is supported */
 	if (ghcb->ghcb_usage)
@@ -2246,33 +2246,34 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
-	if (!svm->ghcb)
+	if (!svm->sev_es.ghcb)
 		return;
 
-	if (svm->ghcb_sa_free) {
+	if (svm->sev_es.ghcb_sa_free) {
 		/*
 		 * The scratch area lives outside the GHCB, so there is a
 		 * buffer that, depending on the operation performed, may
 		 * need to be synced, then freed.
 		 */
-		if (svm->ghcb_sa_sync) {
+		if (svm->sev_es.ghcb_sa_sync) {
 			kvm_write_guest(svm->vcpu.kvm,
-					ghcb_get_sw_scratch(svm->ghcb),
-					svm->ghcb_sa, svm->ghcb_sa_len);
-			svm->ghcb_sa_sync = false;
+					ghcb_get_sw_scratch(svm->sev_es.ghcb),
+					svm->sev_es.ghcb_sa,
+					svm->sev_es.ghcb_sa_len);
+			svm->sev_es.ghcb_sa_sync = false;
 		}
 
-		kfree(svm->ghcb_sa);
-		svm->ghcb_sa = NULL;
-		svm->ghcb_sa_free = false;
+		kfree(svm->sev_es.ghcb_sa);
+		svm->sev_es.ghcb_sa = NULL;
+		svm->sev_es.ghcb_sa_free = false;
 	}
 
-	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, svm->ghcb);
+	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, svm->sev_es.ghcb);
 
 	sev_es_sync_to_ghcb(svm);
 
-	kvm_vcpu_unmap(&svm->vcpu, &svm->ghcb_map, true);
-	svm->ghcb = NULL;
+	kvm_vcpu_unmap(&svm->vcpu, &svm->sev_es.ghcb_map, true);
+	svm->sev_es.ghcb = NULL;
 }
 
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
@@ -2302,7 +2303,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
-	struct ghcb *ghcb = svm->ghcb;
+	struct ghcb *ghcb = svm->sev_es.ghcb;
 	u64 ghcb_scratch_beg, ghcb_scratch_end;
 	u64 scratch_gpa_beg, scratch_gpa_end;
 	void *scratch_va;
@@ -2338,7 +2339,7 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 			return false;
 		}
 
-		scratch_va = (void *)svm->ghcb;
+		scratch_va = (void *)svm->sev_es.ghcb;
 		scratch_va += (scratch_gpa_beg - control->ghcb_gpa);
 	} else {
 		/*
@@ -2368,12 +2369,12 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 		 * the vCPU next time (i.e. a read was requested so the data
 		 * must be written back to the guest memory).
 		 */
-		svm->ghcb_sa_sync = sync;
-		svm->ghcb_sa_free = true;
+		svm->sev_es.ghcb_sa_sync = sync;
+		svm->sev_es.ghcb_sa_free = true;
 	}
 
-	svm->ghcb_sa = scratch_va;
-	svm->ghcb_sa_len = len;
+	svm->sev_es.ghcb_sa = scratch_va;
+	svm->sev_es.ghcb_sa_len = len;
 
 	return true;
 }
@@ -2492,15 +2493,15 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
 
-	if (kvm_vcpu_map(vcpu, ghcb_gpa >> PAGE_SHIFT, &svm->ghcb_map)) {
+	if (kvm_vcpu_map(vcpu, ghcb_gpa >> PAGE_SHIFT, &svm->sev_es.ghcb_map)) {
 		/* Unable to map GHCB from guest */
 		vcpu_unimpl(vcpu, "vmgexit: error mapping GHCB [%#llx] from guest\n",
 			    ghcb_gpa);
 		return -EINVAL;
 	}
 
-	svm->ghcb = svm->ghcb_map.hva;
-	ghcb = svm->ghcb_map.hva;
+	svm->sev_es.ghcb = svm->sev_es.ghcb_map.hva;
+	ghcb = svm->sev_es.ghcb_map.hva;
 
 	trace_kvm_vmgexit_enter(vcpu->vcpu_id, ghcb);
 
@@ -2523,7 +2524,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = kvm_sev_es_mmio_read(vcpu,
 					   control->exit_info_1,
 					   control->exit_info_2,
-					   svm->ghcb_sa);
+					   svm->sev_es.ghcb_sa);
 		break;
 	case SVM_VMGEXIT_MMIO_WRITE:
 		if (!setup_vmgexit_scratch(svm, false, control->exit_info_2))
@@ -2532,7 +2533,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = kvm_sev_es_mmio_write(vcpu,
 					    control->exit_info_1,
 					    control->exit_info_2,
-					    svm->ghcb_sa);
+					    svm->sev_es.ghcb_sa);
 		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
@@ -2582,8 +2583,8 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 	if (!setup_vmgexit_scratch(svm, in, svm->vmcb->control.exit_info_2))
 		return -EINVAL;
 
-	return kvm_sev_es_string_io(&svm->vcpu, size, port,
-				    svm->ghcb_sa, svm->ghcb_sa_len / size, in);
+	return kvm_sev_es_string_io(&svm->vcpu, size, port, svm->sev_es.ghcb_sa,
+				    svm->sev_es.ghcb_sa_len / size, in);
 }
 
 void sev_es_init_vmcb(struct vcpu_svm *svm)
@@ -2598,7 +2599,7 @@ void sev_es_init_vmcb(struct vcpu_svm *svm)
 	 * VMCB page. Do not include the encryption mask on the VMSA physical
 	 * address since hardware will access it using the guest key.
 	 */
-	svm->vmcb->control.vmsa_pa = __pa(svm->vmsa);
+	svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
 
 	/* Can't intercept CR register access, HV can't modify CR registers */
 	svm_clr_intercept(svm, INTERCEPT_CR0_READ);
@@ -2670,8 +2671,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/* First SIPI: Use the values as initially set by the VMM */
-	if (!svm->received_first_sipi) {
-		svm->received_first_sipi = true;
+	if (!svm->sev_es.received_first_sipi) {
+		svm->sev_es.received_first_sipi = true;
 		return;
 	}
 
@@ -2680,8 +2681,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
 	 * non-zero value.
 	 */
-	if (!svm->ghcb)
+	if (!svm->sev_es.ghcb)
 		return;
 
-	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 21bb81710e0f..1143b4ac900d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1450,7 +1450,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
 	if (vmsa_page)
-		svm->vmsa = page_address(vmsa_page);
+		svm->sev_es.vmsa = page_address(vmsa_page);
 
 	svm->guest_state_loaded = false;
 
@@ -2833,11 +2833,11 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->ghcb))
+	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->sev_es.ghcb))
 		return kvm_complete_insn_gp(vcpu, err);
 
-	ghcb_set_sw_exit_info_1(svm->ghcb, 1);
-	ghcb_set_sw_exit_info_2(svm->ghcb,
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 1);
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
 				X86_TRAP_GP |
 				SVM_EVTINJ_TYPE_EXEPT |
 				SVM_EVTINJ_VALID);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0d7bbe548ac3..80048841cad9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -123,6 +123,20 @@ struct svm_nested_state {
 	bool initialized;
 };
 
+struct vcpu_sev_es_state {
+	/* SEV-ES support */
+	struct vmcb_save_area *vmsa;
+	struct ghcb *ghcb;
+	struct kvm_host_map ghcb_map;
+	bool received_first_sipi;
+
+	/* SEV-ES scratch area support */
+	void *ghcb_sa;
+	u64 ghcb_sa_len;
+	bool ghcb_sa_sync;
+	bool ghcb_sa_free;
+};
+
 struct vcpu_svm {
 	struct kvm_vcpu vcpu;
 	/* vmcb always points at current_vmcb->ptr, it's purely a shorthand. */
@@ -186,17 +200,7 @@ struct vcpu_svm {
 		DECLARE_BITMAP(write, MAX_DIRECT_ACCESS_MSRS);
 	} shadow_msr_intercept;
 
-	/* SEV-ES support */
-	struct vmcb_save_area *vmsa;
-	struct ghcb *ghcb;
-	struct kvm_host_map ghcb_map;
-	bool received_first_sipi;
-
-	/* SEV-ES scratch area support */
-	void *ghcb_sa;
-	u64 ghcb_sa_len;
-	bool ghcb_sa_sync;
-	bool ghcb_sa_free;
+	struct vcpu_sev_es_state sev_es;
 
 	bool guest_state_loaded;
 };
-- 
2.27.0



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD47436999
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 19:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhJURrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 13:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbhJURrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 13:47:01 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B98C0432C7
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:43:09 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id g73-20020a62524c000000b0044dfaec37c7so820851pfb.6
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=l3vWjzyfVMSaVY9jnZJTJ5KFnHzwc9BXiUB7dQu8kk0=;
        b=Pop8g632/KzHNOww53q0I9OB8LiYpyX7zKU9YTIC+po/DaArz27ZYDOdWvRDFdl6Ns
         SgBZR30hRdTk3gqUvDpb03yAkZR6WprfuIgmJoBkfCoaNk682+G6ryg0EArZjnTo6nSe
         9bl+6m7hUBPIVmLhzPG3c7A/wi0DHqo0FEDbnl9VogCu3fzkzC3Ji/5cZJSDnihfZBDz
         3UaUS3VR04bqqTnYsnRKuhgsbZzCT7geH6d46uNt7h8NyciCtH0NAsFQ5QwupzbeWwKG
         G8PyCn/B8FWI5o726i5j1rJ/dNifWakmXsmyZ9ZlgBFv3XBXER+V7BkHqRa5Ve/JnaqT
         W/OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=l3vWjzyfVMSaVY9jnZJTJ5KFnHzwc9BXiUB7dQu8kk0=;
        b=lZY3xDnF5zTNV18kK7BXFtgZpE+kFVLMguMpplUJc1AjhrGD0cBFbp4NmzkewX4Uy7
         NVho9QQ70Ra1+J0N8hSaGM8SOSpeiAv1KWPmQRZLu9BNo12w2uViQSndjAkQUtDzmKO3
         1sB41JIl9oy6Nggp5UkOLSdcGgDb8o/p30J70fzwLdU0IkK/BfVolUHrHUfUCjNdpA+n
         jAXe6OK/7fdOsF92hGPuwM/vOKw1pXV+wmikUcwQF+sl14hbueoVNfEXqf3FLARXBEpt
         jUTqeiBQevyqeINKGGqvd42JG2zBQ0dJ/QVv4MG6PdZcydNwylpF4llGbmwP7JLS7nys
         wc1g==
X-Gm-Message-State: AOAM532NBiErwrZ02v6i85C394YIPKtX1RGDgZQvPPwWsDSfUZ//+jEy
        9f6yRVYY97fCW70kTi3LvvllUU0Knf1D5YaRP1HUKCZOOCnfOCNUqLM4YOq6OMBBllhz2x5Fjen
        fEqIWnVnyEHnQ0rzwic386Clq1ja8GhKAqQnlC17iVFlnUPB7vuEtFqpgug==
X-Google-Smtp-Source: ABdhPJxqWqFV/bP+jY2N1zns3eqfolyGwtGA//b6FeCnrZqggyLxg7D4+d1ktCRm7YhysBKtULocml4cHHE=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:da2d:dcb2:6:add9])
 (user=pgonda job=sendgmr) by 2002:a17:902:e848:b0:13e:f908:155a with SMTP id
 t8-20020a170902e84800b0013ef908155amr6531137plg.13.1634838188442; Thu, 21 Oct
 2021 10:43:08 -0700 (PDT)
Date:   Thu, 21 Oct 2021 10:42:59 -0700
In-Reply-To: <20211021174303.385706-1-pgonda@google.com>
Message-Id: <20211021174303.385706-2-pgonda@google.com>
Mime-Version: 1.0
References: <20211021174303.385706-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH 1/5 V11] KVM: SEV: Refactor out sev_es_state struct
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move SEV-ES vCPU metadata into new sev_es_state struct from vcpu_svm.

Signed-off-by: Peter Gonda <pgonda@google.com>
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
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
---
 arch/x86/kvm/svm/sev.c | 83 +++++++++++++++++++++---------------------
 arch/x86/kvm/svm/svm.c |  8 ++--
 arch/x86/kvm/svm/svm.h | 26 +++++++------
 3 files changed, 61 insertions(+), 56 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0d21d59936e5..109b223c0b58 100644
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
 	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
 	if (ret)
@@ -2031,16 +2031,16 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
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
@@ -2066,7 +2066,7 @@ static void dump_ghcb(struct vcpu_svm *svm)
 static void sev_es_sync_to_ghcb(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct ghcb *ghcb = svm->ghcb;
+	struct ghcb *ghcb = svm->sev_es.ghcb;
 
 	/*
 	 * The GHCB protocol so far allows for the following data
@@ -2086,7 +2086,7 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct ghcb *ghcb = svm->ghcb;
+	struct ghcb *ghcb = svm->sev_es.ghcb;
 	u64 exit_code;
 
 	/*
@@ -2133,7 +2133,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	struct ghcb *ghcb;
 	u64 exit_code = 0;
 
-	ghcb = svm->ghcb;
+	ghcb = svm->sev_es.ghcb;
 
 	/* Only GHCB Usage code 0 is supported */
 	if (ghcb->ghcb_usage)
@@ -2251,33 +2251,34 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 
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
@@ -2307,7 +2308,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
-	struct ghcb *ghcb = svm->ghcb;
+	struct ghcb *ghcb = svm->sev_es.ghcb;
 	u64 ghcb_scratch_beg, ghcb_scratch_end;
 	u64 scratch_gpa_beg, scratch_gpa_end;
 	void *scratch_va;
@@ -2343,7 +2344,7 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 			return false;
 		}
 
-		scratch_va = (void *)svm->ghcb;
+		scratch_va = (void *)svm->sev_es.ghcb;
 		scratch_va += (scratch_gpa_beg - control->ghcb_gpa);
 	} else {
 		/*
@@ -2373,12 +2374,12 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
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
@@ -2497,15 +2498,15 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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
 
@@ -2528,7 +2529,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = kvm_sev_es_mmio_read(vcpu,
 					   control->exit_info_1,
 					   control->exit_info_2,
-					   svm->ghcb_sa);
+					   svm->sev_es.ghcb_sa);
 		break;
 	case SVM_VMGEXIT_MMIO_WRITE:
 		if (!setup_vmgexit_scratch(svm, false, control->exit_info_2))
@@ -2537,7 +2538,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = kvm_sev_es_mmio_write(vcpu,
 					    control->exit_info_1,
 					    control->exit_info_2,
-					    svm->ghcb_sa);
+					    svm->sev_es.ghcb_sa);
 		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
@@ -2587,8 +2588,8 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 	if (!setup_vmgexit_scratch(svm, in, svm->vmcb->control.exit_info_2))
 		return -EINVAL;
 
-	return kvm_sev_es_string_io(&svm->vcpu, size, port,
-				    svm->ghcb_sa, svm->ghcb_sa_len / size, in);
+	return kvm_sev_es_string_io(&svm->vcpu, size, port, svm->sev_es.ghcb_sa,
+				    svm->sev_es.ghcb_sa_len / size, in);
 }
 
 void sev_es_init_vmcb(struct vcpu_svm *svm)
@@ -2603,7 +2604,7 @@ void sev_es_init_vmcb(struct vcpu_svm *svm)
 	 * VMCB page. Do not include the encryption mask on the VMSA physical
 	 * address since hardware will access it using the guest key.
 	 */
-	svm->vmcb->control.vmsa_pa = __pa(svm->vmsa);
+	svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
 
 	/* Can't intercept CR register access, HV can't modify CR registers */
 	svm_clr_intercept(svm, INTERCEPT_CR0_READ);
@@ -2675,8 +2676,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/* First SIPI: Use the values as initially set by the VMM */
-	if (!svm->received_first_sipi) {
-		svm->received_first_sipi = true;
+	if (!svm->sev_es.received_first_sipi) {
+		svm->sev_es.received_first_sipi = true;
 		return;
 	}
 
@@ -2685,8 +2686,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
index 989685098b3e..68294491c23d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1372,7 +1372,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
 
 	if (vmsa_page)
-		svm->vmsa = page_address(vmsa_page);
+		svm->sev_es.vmsa = page_address(vmsa_page);
 
 	svm->guest_state_loaded = false;
 
@@ -2762,11 +2762,11 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
index 5d30db599e10..6d8d762d208f 100644
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
+	u32 ghcb_sa_len;
+	bool ghcb_sa_sync;
+	bool ghcb_sa_free;
+};
+
 struct vcpu_svm {
 	struct kvm_vcpu vcpu;
 	/* vmcb always points at current_vmcb->ptr, it's purely a shorthand. */
@@ -183,17 +197,7 @@ struct vcpu_svm {
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
-	u32 ghcb_sa_len;
-	bool ghcb_sa_sync;
-	bool ghcb_sa_free;
+	struct vcpu_sev_es_state sev_es;
 
 	bool guest_state_loaded;
 };
-- 
2.33.0.1079.g6e70778dc9-goog


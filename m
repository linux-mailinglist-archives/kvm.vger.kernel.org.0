Return-Path: <kvm+bounces-3008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F8D7FFAF0
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 20:14:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B31E21F21016
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 702D83A286;
	Thu, 30 Nov 2023 19:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NTjpiMu1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9793106
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 11:13:48 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9cb79eb417so1716677276.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 11:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701371628; x=1701976428; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e+W+1lsPcrFNkkglDJA/1kIS/C9M7C7ste9mmX6izE0=;
        b=NTjpiMu1l4qpZpRzAPmyFqIzPXEfU5myFPLURh9Wf2nj55V4++M5MnPeNYQY25pM1/
         yFwdpnOuDQk9e6iyTFbtgrHK+X8h9d4jOVrjYJ7aYixEQwDd7EHo/paJf+rk7ZmRqBZw
         oJwUWTtwKSI44noBro6wV7K14/GsH6D7fo3L8ILK6SzkkptM7kjVbVBoQ2rF6yZsHKq2
         XdsmxYIorY5RT3Vqwl4zGPOMMmrUs34pGDzYMXrFtdtAuiudGvh7rZ92scBU99tHTq0G
         uY/SaOXx4gcB1B98iofo0T4WWWk9KHq94zot5rq4+ztk39QsoCojLQGO2dUYhCjRtY/6
         hlug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701371628; x=1701976428;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e+W+1lsPcrFNkkglDJA/1kIS/C9M7C7ste9mmX6izE0=;
        b=lTbiqdQezZ+gVphKRDkheRiiJsCINIVGNCt/TcmVTkiA19j2gmUOpRZMDko8EQZkh1
         oysU7fTKD4RkROv07hj+YzQW0kpV75JrNURg5AL5jduVKLDdk3zWgvgcdB0NvrGfmG3N
         nHJof9Fj5vjOFsTTNksL0mY6tsb2wNGTWIwCfTRJgRGBHCL5WBWSwNFcGyfuEpyhcyza
         4D4bs+9Kx9cW2jpZ7lkvzv/vHw3B4VR3HorRcJls6xqR/5HMh2OpbRjN6OZyHDAN3/Ns
         p3SXRJ943uAxqEo3PmxNwnJ8fRLs1gUk/bK6/LKtaRUH83HxkbZ029KWdJJIcNCRAPsr
         1LGw==
X-Gm-Message-State: AOJu0YxsjacJAaFqqLYztxRPeHev5AXzMgt9j35hZR6MOjHJEruD/CPq
	VpTC9LQ57Q4WU2c0JBxvnPV+/thZ2tw=
X-Google-Smtp-Source: AGHT+IEBFLmxm4Y5BdkxfRoLEp4j1TjuAhX6X1Q80dQbXNoABEOnBBvqKsimYdvN2O17/arFVyW7an8vCoA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4b02:0:b0:d9a:6007:223a with SMTP id
 y2-20020a254b02000000b00d9a6007223amr579265yba.8.1701371628090; Thu, 30 Nov
 2023 11:13:48 -0800 (PST)
Date: Thu, 30 Nov 2023 11:13:46 -0800
In-Reply-To: <20231025152406.1879274-12-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231025152406.1879274-1-vkuznets@redhat.com> <20231025152406.1879274-12-vkuznets@redhat.com>
Message-ID: <ZWje6mjCMDG5swG_@google.com>
Subject: Re: [PATCH 11/14] KVM: nVMX: hyper-v: Introduce nested_vmx_evmptr12()
 and nested_vmx_is_evmptr12_valid() helpers
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 25, 2023, Vitaly Kuznetsov wrote:
>  #ifdef CONFIG_KVM_HYPERV
> +static inline gpa_t nested_vmx_evmptr12(struct vcpu_vmx *vmx) { return vmx->nested.hv_evmcs_vmptr; }
> +static inline bool nested_vmx_is_evmptr12_valid(struct vcpu_vmx *vmx)
> +{
> +	return evmptr_is_valid(vmx->nested.hv_evmcs_vmptr);
> +}

...

> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d0d735974b2c..b45586588bae 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -179,7 +179,7 @@ static int nested_vmx_failValid(struct kvm_vcpu *vcpu,
>  	 * VM_INSTRUCTION_ERROR is not shadowed. Enlightened VMCS 'shadows' all
>  	 * fields and thus must be synced.
>  	 */
> -	if (to_vmx(vcpu)->nested.hv_evmcs_vmptr != EVMPTR_INVALID)
> +	if (nested_vmx_evmptr12(to_vmx(vcpu)) != EVMPTR_INVALID)
>  		to_vmx(vcpu)->nested.need_vmcs12_to_shadow_sync = true;
>  
>  	return kvm_skip_emulated_instruction(vcpu);
> @@ -194,7 +194,7 @@ static int nested_vmx_fail(struct kvm_vcpu *vcpu, u32 vm_instruction_error)
>  	 * can't be done if there isn't a current VMCS.
>  	 */
>  	if (vmx->nested.current_vmptr == INVALID_GPA &&
> -	    !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +	    !nested_vmx_is_evmptr12_valid(vmx))

Hrm, this results in a bit of a mess, because it's essentially a half-baked
conversion, and the existing evmptr_is_valid() makes it extra confusing.

Specifically, I don't think nested_vmx_evmptr12() should exist.  The only code
that should ever care about the evmptr12 _value_ should be guarded with
CONFIG_KVM_HYPERV, everything else should simply be checking for validity.

I don't know what names would be best, but we should end up with two helpers:
one that checks "evmptr != INVALID && evmptr != MAP_PENDING" and another that
checks "evmptr != INVALID".

And the inner helpers, e.g. evmptr_is_valid(), should also have stubs.  I doubt
it will matter in practice, but I see no reason not to make it super duper obvious
that evmptr_is_valid() can never be %true if CONFIG_KVM_HYPERV=n.

> @@ -30,6 +38,8 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
>  bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu);
>  void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
>  #else
> +static inline gpa_t nested_vmx_evmptr12(struct vcpu_vmx *vmx) { return EVMPTR_INVALID; }
> +static inline bool nested_vmx_is_evmptr12_valid(struct vcpu_vmx *vmx) { return false; }
>  static inline u64 nested_get_evmptr(struct kvm_vcpu *vcpu) { return EVMPTR_INVALID; }
>  static inline void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata) {}
>  static inline bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu) { return false; }

Pretty much all of these stubs are gratuitous.  They either have single users
that can be wrapped with CONFIG_KVM_HYPERV, or can be eliminated by the adding
the extra helper as above.

Oh, and switching back to a topic that I think I brought up in a different response,
the stubs for nested_get_evmcs_page() is *really* nasty, as it returns %true when
eVMCS is disabled.  It's functionally correct for vmx_get_nested_state_pages(), but
super odd because obviously KVM was unable to get any eVMCS pages.  That's one of
the reasons why my preference is to avoid most stubs and instead either handle
things entirely within the eVMCS helpers or use #ifdefs at the call sites (when
there is only 1, maybe 2, callers).

Pulling in another goof, hyperv_enabled and hyperv in struct kvm_vcpu_arch should
be #ifdef'd away.

Last thought, my fairly strong preference is to not squish any of these helpers
into a single line, i.e. do

	static inline bool evmptr_is_valid(u64 evmptr)
	{
		return false;
	}

which IMO is much easier to read.  It's quite easy to trim this down to five stubs,
at which point making the code as dense as possible is a net negative, e.g. even
with the multi-line stubs, the entirety of arch/x86/kvm/vmx/hyperv.h fits on my
monitor without scrolling.

This is what I ended up with after a bit of hacking.  It compiles, but otherwise
is untested.  As above, I have no idea what to call evmptr_is_tbd() :-)

---
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/vmx/hyperv.h       | 57 ++++++++++++++++++-------
 arch/x86/kvm/vmx/nested.c       | 73 +++++++++++++++++++++------------
 arch/x86/kvm/vmx/nested.h       |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  2 +
 arch/x86/kvm/vmx/vmx.h          | 10 -----
 6 files changed, 94 insertions(+), 52 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 394dc11bf232..0ecfb16c611c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -937,8 +937,10 @@ struct kvm_vcpu_arch {
 	/* used for guest single stepping over the given code position */
 	unsigned long singlestep_rip;
 
+#ifdef CONFIG_KVM_HYPERV
 	bool hyperv_enabled;
 	struct kvm_vcpu_hv *hyperv;
+#endif
 #ifdef CONFIG_KVM_XEN
 	struct kvm_vcpu_xen xen;
 #endif
diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index 92bde3b75ca0..ce2b03ea2d30 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -9,11 +9,6 @@
 #define EVMPTR_INVALID (-1ULL)
 #define EVMPTR_MAP_PENDING (-2ULL)
 
-static inline bool evmptr_is_valid(u64 evmptr)
-{
-	return evmptr != EVMPTR_INVALID && evmptr != EVMPTR_MAP_PENDING;
-}
-
 enum nested_evmptrld_status {
 	EVMPTRLD_DISABLED,
 	EVMPTRLD_SUCCEEDED,
@@ -21,18 +16,41 @@ enum nested_evmptrld_status {
 	EVMPTRLD_ERROR,
 };
 
-struct vcpu_vmx;
-
 #ifdef CONFIG_KVM_HYPERV
-static inline gpa_t nested_vmx_evmptr12(struct vcpu_vmx *vmx) { return vmx->nested.hv_evmcs_vmptr; }
+static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * eVMCS is exposed to the guest if Hyper-V is enabled in CPUID and
+	 * eVMCS has been explicitly enabled by userspace.
+	 */
+	return vcpu->arch.hyperv_enabled &&
+	       to_vmx(vcpu)->nested.enlightened_vmcs_enabled;
+}
+static inline gpa_t nested_vmx_evmptr12(struct vcpu_vmx *vmx)
+{
+	return vmx->nested.hv_evmcs_vmptr;
+}
+static inline bool evmptr_is_valid(u64 evmptr)
+{
+	return evmptr != EVMPTR_INVALID && evmptr != EVMPTR_MAP_PENDING;
+}
 static inline bool nested_vmx_is_evmptr12_valid(struct vcpu_vmx *vmx)
 {
 	return evmptr_is_valid(vmx->nested.hv_evmcs_vmptr);
 }
+static inline bool evmptr_is_tbd(u64 evmptr)
+{
+	return evmptr != EVMPTR_INVALID;
+}
+static inline bool nested_vmx_is_evmptr12_tbd(struct vcpu_vmx *vmx)
+{
+	return evmptr_is_tbd(vmx->nested.hv_evmcs_vmptr);
+}
 static inline struct hv_enlightened_vmcs *nested_vmx_evmcs(struct vcpu_vmx *vmx)
 {
 	return vmx->nested.hv_evmcs;
 }
+
 u64 nested_get_evmptr(struct kvm_vcpu *vcpu);
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
@@ -42,17 +60,26 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
 bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu);
 void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
 #else
-static inline gpa_t nested_vmx_evmptr12(struct vcpu_vmx *vmx) { return EVMPTR_INVALID; }
-static inline bool nested_vmx_is_evmptr12_valid(struct vcpu_vmx *vmx) { return false; }
+static inline bool evmptr_is_valid(u64 evmptr)
+{
+	return false;
+}
+static inline bool nested_vmx_is_evmptr12_valid(struct vcpu_vmx *vmx)
+{
+	return false;
+}
+static inline bool evmptr_is_tbd(u64 evmptr)
+{
+	return false;
+}
+static inline bool nested_vmx_is_evmptr12_tbd(struct vcpu_vmx *vmx)
+{
+	return false;
+}
 static inline struct hv_enlightened_vmcs *nested_vmx_evmcs(struct vcpu_vmx *vmx)
 {
 	return NULL;
 }
-static inline u64 nested_get_evmptr(struct kvm_vcpu *vcpu) { return EVMPTR_INVALID; }
-static inline void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata) {}
-static inline bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu) { return false; }
-static inline int nested_evmcs_check_controls(struct vmcs12 *vmcs12) { return 0; }
 #endif
 
-
 #endif /* __KVM_X86_VMX_HYPERV_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4777d867419c..0045d6a2da54 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -179,7 +179,7 @@ static int nested_vmx_failValid(struct kvm_vcpu *vcpu,
 	 * VM_INSTRUCTION_ERROR is not shadowed. Enlightened VMCS 'shadows' all
 	 * fields and thus must be synced.
 	 */
-	if (nested_vmx_evmptr12(to_vmx(vcpu)) != EVMPTR_INVALID)
+	if (nested_vmx_is_evmptr12_tbd(to_vmx(vcpu)))
 		to_vmx(vcpu)->nested.need_vmcs12_to_shadow_sync = true;
 
 	return kvm_skip_emulated_instruction(vcpu);
@@ -245,6 +245,34 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
 #endif
 }
 
+static bool nested_evmcs_handle_vmclear(struct kvm_vcpu *vcpu, gpa_t vmptr)
+{
+#ifdef CONFIG_KVM_HYPERV
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	/*
+	 * When Enlightened VMEntry is enabled on the calling CPU we treat
+	 * memory area pointer by vmptr as Enlightened VMCS (as there's no good
+	 * way to distinguish it from VMCS12) and we must not corrupt it by
+	 * writing to the non-existent 'launch_state' field. The area doesn't
+	 * have to be the currently active EVMCS on the calling CPU and there's
+	 * nothing KVM has to do to transition it from 'active' to 'non-active'
+	 * state. It is possible that the area will stay mapped as
+	 * vmx->nested.hv_evmcs but this shouldn't be a problem.
+	 */
+	if (!guest_cpuid_has_evmcs(vcpu) ||
+	    !evmptr_is_valid(nested_get_evmptr(vcpu)))
+		return false;
+
+	if (nested_vmx_evmcs(vmx) && vmptr == nested_vmx_evmptr12(vmx))
+		nested_release_evmcs(vcpu);
+
+	return true;
+#else
+	return false;
+#endif
+}
+
 static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
 				     struct loaded_vmcs *prev)
 {
@@ -1574,9 +1602,9 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 	vmcs_load(vmx->loaded_vmcs->vmcs);
 }
 
-#ifdef CONFIG_KVM_HYPERV
 static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields)
 {
+#ifdef CONFIG_KVM_HYPERV
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
 	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(&vmx->vcpu);
@@ -1817,10 +1845,12 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 	 */
 
 	return;
+#endif
 }
 
 static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 {
+#ifdef CONFIG_KVM_HYPERV
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
 	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
 
@@ -1991,6 +2021,7 @@ static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 	evmcs->guest_bndcfgs = vmcs12->guest_bndcfgs;
 
 	return;
+#endif
 }
 
 /*
@@ -2000,6 +2031,7 @@ static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	struct kvm_vcpu *vcpu, bool from_launch)
 {
+#ifdef CONFIG_KVM_HYPERV
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	bool evmcs_gpa_changed = false;
 	u64 evmcs_gpa;
@@ -2081,11 +2113,10 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	}
 
 	return EVMPTRLD_SUCCEEDED;
+#else
+	return EVMPTRLD_DISABLED;
+#endif
 }
-#else /* CONFIG_KVM_HYPERV */
-static inline void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields) {}
-static inline void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx) {}
-#endif /* CONFIG_KVM_HYPERV */
 
 void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
 {
@@ -2890,8 +2921,10 @@ static int nested_vmx_check_controls(struct kvm_vcpu *vcpu,
 	    nested_check_vm_entry_controls(vcpu, vmcs12))
 		return -EINVAL;
 
+#ifdef CONFIG_KVM_HYPERV
 	if (guest_cpuid_has_evmcs(vcpu))
 		return nested_evmcs_check_controls(vmcs12);
+#endif
 
 	return 0;
 }
@@ -3191,8 +3224,6 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
 
 	return true;
 }
-#else
-static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu) { return true; }
 #endif
 
 static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
@@ -3285,6 +3316,7 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 
 static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
 {
+#ifdef CONFIG_KVM_HYPERV
 	/*
 	 * Note: nested_get_evmcs_page() also updates 'vp_assist_page' copy
 	 * in 'struct kvm_vcpu_hv' in case eVMCS is in use, this is mandatory
@@ -3301,7 +3333,7 @@ static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
 
 		return false;
 	}
-
+#endif
 	if (is_guest_mode(vcpu) && !nested_get_vmcs12_pages(vcpu))
 		return false;
 
@@ -3564,13 +3596,11 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-#ifdef CONFIG_KVM_HYPERV
 	evmptrld_status = nested_vmx_handle_enlightened_vmptrld(vcpu, launch);
 	if (evmptrld_status == EVMPTRLD_ERROR) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
-#endif
 
 	kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
 
@@ -4743,6 +4773,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
 	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
+#ifdef CONFIG_KVM_HYPERV
 		/*
 		 * KVM_REQ_GET_NESTED_STATE_PAGES is also used to map
 		 * Enlightened VMCS after migration and we still need to
@@ -4750,6 +4781,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		 * the first L2 run.
 		 */
 		(void)nested_get_evmcs_page(vcpu);
+#endif
 	}
 
 	/* Service pending TLB flush requests for L2 before switching to L1. */
@@ -5302,18 +5334,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 	if (vmptr == vmx->nested.vmxon_ptr)
 		return nested_vmx_fail(vcpu, VMXERR_VMCLEAR_VMXON_POINTER);
 
-	/*
-	 * When Enlightened VMEntry is enabled on the calling CPU we treat
-	 * memory area pointer by vmptr as Enlightened VMCS (as there's no good
-	 * way to distinguish it from VMCS12) and we must not corrupt it by
-	 * writing to the non-existent 'launch_state' field. The area doesn't
-	 * have to be the currently active EVMCS on the calling CPU and there's
-	 * nothing KVM has to do to transition it from 'active' to 'non-active'
-	 * state. It is possible that the area will stay mapped as
-	 * vmx->nested.hv_evmcs but this shouldn't be a problem.
-	 */
-	if (likely(!guest_cpuid_has_evmcs(vcpu) ||
-		   !evmptr_is_valid(nested_get_evmptr(vcpu)))) {
+	if (likely(!nested_evmcs_handle_vmclear(vcpu, vmptr))) {
 		if (vmptr == vmx->nested.current_vmptr)
 			nested_release_vmcs12(vcpu);
 
@@ -5330,8 +5351,6 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 					   vmptr + offsetof(struct vmcs12,
 							    launch_state),
 					   &zero, sizeof(zero));
-	} else if (nested_vmx_evmcs(vmx) && vmptr == nested_vmx_evmptr12(vmx)) {
-		nested_release_evmcs(vcpu);
 	}
 
 	return nested_vmx_succeed(vcpu);
@@ -6218,11 +6237,13 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
 		 * Handle L2's bus locks in L0 directly.
 		 */
 		return true;
+#ifdef CONFIG_KVM_HYPERV
 	case EXIT_REASON_VMCALL:
 		/* Hyper-V L2 TLB flush hypercall is handled by L0 */
 		return guest_hv_cpuid_has_l2_tlb_flush(vcpu) &&
 			nested_evmcs_l2_tlb_flush_enabled(vcpu) &&
 			kvm_hv_is_tlb_flush_hcall(vcpu);
+#endif
 	default:
 		break;
 	}
@@ -6445,7 +6466,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 			kvm_state.size += sizeof(user_vmx_nested_state->vmcs12);
 
 			/* 'hv_evmcs_vmptr' can also be EVMPTR_MAP_PENDING here */
-			if (nested_vmx_evmptr12(vmx) != EVMPTR_INVALID)
+			if (nested_vmx_is_evmptr12_tbd(vmx))
 				kvm_state.flags |= KVM_STATE_NESTED_EVMCS;
 
 			if (is_guest_mode(vcpu) &&
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 0cedb80c5c94..891cc1df6a60 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -58,7 +58,7 @@ static inline int vmx_has_valid_vmcs12(struct kvm_vcpu *vcpu)
 
 	/* 'hv_evmcs_vmptr' can also be EVMPTR_MAP_PENDING here */
 	return vmx->nested.current_vmptr != -1ull ||
-		nested_vmx_evmptr12(vmx) != EVMPTR_INVALID;
+	       nested_vmx_is_evmptr12_tbd(vmx);
 }
 
 static inline u16 nested_get_vpid02(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6e0ff015c5ff..942e10166777 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2048,6 +2048,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
 				    &msr_info->data))
 			return 1;
+#ifdef CONFIG_KVM_HYPERV
 		/*
 		 * Enlightened VMCS v1 doesn't have certain VMCS fields but
 		 * instead of just ignoring the features, different Hyper-V
@@ -2058,6 +2059,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!msr_info->host_initiated && guest_cpuid_has_evmcs(vcpu))
 			nested_evmcs_filter_control_msr(vcpu, msr_info->index,
 							&msr_info->data);
+#endif
 		break;
 	case MSR_IA32_RTIT_CTL:
 		if (!vmx_pt_mode_is_host_guest())
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 55addb8eef01..8fe6eb2b4a34 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -747,14 +747,4 @@ static inline bool vmx_can_use_ipiv(struct kvm_vcpu *vcpu)
 	return  lapic_in_kernel(vcpu) && enable_ipiv;
 }
 
-static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * eVMCS is exposed to the guest if Hyper-V is enabled in CPUID and
-	 * eVMCS has been explicitly enabled by userspace.
-	 */
-	return vcpu->arch.hyperv_enabled &&
-	       to_vmx(vcpu)->nested.enlightened_vmcs_enabled;
-}
-
 #endif /* __KVM_X86_VMX_H */

base-commit: 3f84682d96d3d77f35f661a3787ddb90c0477b75
-- 



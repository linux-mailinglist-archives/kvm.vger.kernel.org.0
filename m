Return-Path: <kvm+bounces-2014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 97EFF7F080A
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 18:09:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F2627B20A90
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 17:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2D6E18B14;
	Sun, 19 Nov 2023 17:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aWEtn7iP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10357BA
	for <kvm@vger.kernel.org>; Sun, 19 Nov 2023 09:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700413735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HaT6hl+qvTXuLiCHSyvbrzSYomv57amwYqln/M0ynv8=;
	b=aWEtn7iPL3t5w/Ji3pUUmOJCeW4tCy9YgbSR5Lo2xsdTO2iLqIloL9RwujJcUbgqMCpVYZ
	iaKyE26mpU+huY1hxramMA2po7YU3x6myl+lZBk1CvKallHwhJhGBBR6/9VFXVWQvS0Mjq
	5/iYlqVtG6/ZeNm5AVBczUK2whceSe8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-vYNirw8eOcGBq6httW-h0w-1; Sun, 19 Nov 2023 12:08:53 -0500
X-MC-Unique: vYNirw8eOcGBq6httW-h0w-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-332c50f4d98so178805f8f.1
        for <kvm@vger.kernel.org>; Sun, 19 Nov 2023 09:08:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700413732; x=1701018532;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HaT6hl+qvTXuLiCHSyvbrzSYomv57amwYqln/M0ynv8=;
        b=ExMNjjhNC8AHWn/uf1wypIyLbpStCfet/1hQTKh88+QXtL/B3G4i7tTOqJEfVLcLxl
         vL5VOoX+lgGHhuU5AEY63wBBWCUInDyO0td1g+vM6+MUbhWgjvIJfhAwqu8hZfmfyxtb
         RWxVxUuNbnTPyhzZuv4okmKL5uBv6HamnUKXClF4gaTQ21oGcZYuZowuuzmjNilG9VQ/
         yWaqObalKw/cb/o3bb5g7OPnTdEjsJKjDd28V/4yNzS3PTDyjV42uoEIjUYHskSuOrLr
         gCNT/QKa9CCyn5NEZrEIHkaEr8nx3e+StNo7haz25kwQz6SnGrLm8eOPkVIagOK9+Pog
         Gdbg==
X-Gm-Message-State: AOJu0YwEhKCgKumtz1aFNZUfUUt8Ih1UdXviY/Px4qGMt8BMeghlJlBQ
	hw2d/RUGzWMmiZSN58FKbLadeWJnaVPhxf/F/5bkntE6ShkHK/YDuEmI/tYaB8ZNDoqBtYxiEOc
	Dbq2y2oA/ezBF
X-Received: by 2002:a5d:6c6b:0:b0:332:c3fc:47ab with SMTP id r11-20020a5d6c6b000000b00332c3fc47abmr1527248wrz.9.1700413732121;
        Sun, 19 Nov 2023 09:08:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFnAgFDxNmT5YzGX1EPKHB5D0Pcd29WG3PKYaqkRrpUHhdnTsq3UNVG3u5N0Ivow1rpJVl/Sg==
X-Received: by 2002:a5d:6c6b:0:b0:332:c3fc:47ab with SMTP id r11-20020a5d6c6b000000b00332c3fc47abmr1527227wrz.9.1700413731668;
        Sun, 19 Nov 2023 09:08:51 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id p17-20020a5d48d1000000b003316ad360c1sm7798609wrs.24.2023.11.19.09.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Nov 2023 09:08:51 -0800 (PST)
Message-ID: <397b607fcea1116f6409b5fb9b81a5b594c3ad6d.camel@redhat.com>
Subject: Re: [PATCH 1/9] KVM: x86: Rename "governed features" helpers to use
 "guest_cpu_cap"
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 19 Nov 2023 19:08:49 +0200
In-Reply-To: <20231110235528.1561679-2-seanjc@google.com>
References: <20231110235528.1561679-1-seanjc@google.com>
	 <20231110235528.1561679-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-10 at 15:55 -0800, Sean Christopherson wrote:
> As the first step toward replacing KVM's so-called "governed features"
> framework with a more comprehensive, less poorly named implementation,
> replace the "kvm_governed_feature" function prefix with "guest_cpu_cap"
> and rename guest_can_use() to guest_cpu_cap_has().
> 
> The "guest_cpu_cap" naming scheme mirrors that of "kvm_cpu_cap", and
> provides a more clear distinction between guest capabilities, which are
> KVM controlled (heh, or one might say "governed"), and guest CPUID, which
> with few exceptions is fully userspace controlled.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c      |  2 +-
>  arch/x86/kvm/cpuid.h      | 12 ++++++------
>  arch/x86/kvm/mmu/mmu.c    |  4 ++--
>  arch/x86/kvm/svm/nested.c | 22 +++++++++++-----------
>  arch/x86/kvm/svm/svm.c    | 26 +++++++++++++-------------
>  arch/x86/kvm/svm/svm.h    |  4 ++--
>  arch/x86/kvm/vmx/nested.c |  6 +++---
>  arch/x86/kvm/vmx/vmx.c    | 14 +++++++-------
>  arch/x86/kvm/x86.c        |  4 ++--
>  9 files changed, 47 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index dda6fc4cfae8..4f464187b063 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -345,7 +345,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	allow_gbpages = tdp_enabled ? boot_cpu_has(X86_FEATURE_GBPAGES) :
>  				      guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);
>  	if (allow_gbpages)
> -		kvm_governed_feature_set(vcpu, X86_FEATURE_GBPAGES);
> +		guest_cpu_cap_set(vcpu, X86_FEATURE_GBPAGES);
>  
>  	best = kvm_find_cpuid_entry(vcpu, 1);
>  	if (best && apic) {
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 0b90532b6e26..245416ffa34c 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -254,7 +254,7 @@ static __always_inline bool kvm_is_governed_feature(unsigned int x86_feature)
>  	return kvm_governed_feature_index(x86_feature) >= 0;
>  }
>  
> -static __always_inline void kvm_governed_feature_set(struct kvm_vcpu *vcpu,
> +static __always_inline void guest_cpu_cap_set(struct kvm_vcpu *vcpu,
>  						     unsigned int x86_feature)
>  {
>  	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
> @@ -263,15 +263,15 @@ static __always_inline void kvm_governed_feature_set(struct kvm_vcpu *vcpu,
>  		  vcpu->arch.governed_features.enabled);
>  }
>  
> -static __always_inline void kvm_governed_feature_check_and_set(struct kvm_vcpu *vcpu,
> -							       unsigned int x86_feature)
> +static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
> +							unsigned int x86_feature)
>  {
>  	if (kvm_cpu_cap_has(x86_feature) && guest_cpuid_has(vcpu, x86_feature))
> -		kvm_governed_feature_set(vcpu, x86_feature);
> +		guest_cpu_cap_set(vcpu, x86_feature);
>  }
>  
> -static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
> -					  unsigned int x86_feature)
> +static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
> +					      unsigned int x86_feature)
>  {
>  	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b0f01d605617..cfed824587b9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4801,7 +4801,7 @@ static void reset_guest_rsvds_bits_mask(struct kvm_vcpu *vcpu,
>  	__reset_rsvds_bits_mask(&context->guest_rsvd_check,
>  				vcpu->arch.reserved_gpa_bits,
>  				context->cpu_role.base.level, is_efer_nx(context),
> -				guest_can_use(vcpu, X86_FEATURE_GBPAGES),
> +				guest_cpu_cap_has(vcpu, X86_FEATURE_GBPAGES),
>  				is_cr4_pse(context),
>  				guest_cpuid_is_amd_or_hygon(vcpu));
>  }
> @@ -4878,7 +4878,7 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
>  	__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
>  				context->root_role.level,
>  				context->root_role.efer_nx,
> -				guest_can_use(vcpu, X86_FEATURE_GBPAGES),
> +				guest_cpu_cap_has(vcpu, X86_FEATURE_GBPAGES),
>  				is_pse, is_amd);
>  
>  	if (!shadow_me_mask)
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 3fea8c47679e..ea0895262b12 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -107,7 +107,7 @@ static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
>  
>  static bool nested_vmcb_needs_vls_intercept(struct vcpu_svm *svm)
>  {
> -	if (!guest_can_use(&svm->vcpu, X86_FEATURE_V_VMSAVE_VMLOAD))
> +	if (!guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_V_VMSAVE_VMLOAD))
>  		return true;
>  
>  	if (!nested_npt_enabled(svm))
> @@ -603,7 +603,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>  		vmcb_mark_dirty(vmcb02, VMCB_DR);
>  	}
>  
> -	if (unlikely(guest_can_use(vcpu, X86_FEATURE_LBRV) &&
> +	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
>  		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
>  		/*
>  		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
> @@ -660,7 +660,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	 * exit_int_info, exit_int_info_err, next_rip, insn_len, insn_bytes.
>  	 */
>  
> -	if (guest_can_use(vcpu, X86_FEATURE_VGIF) &&
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_VGIF) &&
>  	    (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK))
>  		int_ctl_vmcb12_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
>  	else
> @@ -698,7 +698,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  
>  	vmcb02->control.tsc_offset = vcpu->arch.tsc_offset;
>  
> -	if (guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR) &&
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_TSCRATEMSR) &&
>  	    svm->tsc_ratio_msr != kvm_caps.default_tsc_scaling_ratio)
>  		nested_svm_update_tsc_ratio_msr(vcpu);
>  
> @@ -719,7 +719,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	 * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
>  	 * prior to injecting the event).
>  	 */
> -	if (guest_can_use(vcpu, X86_FEATURE_NRIPS))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
>  		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
>  	else if (boot_cpu_has(X86_FEATURE_NRIPS))
>  		vmcb02->control.next_rip    = vmcb12_rip;
> @@ -729,7 +729,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  		svm->soft_int_injected = true;
>  		svm->soft_int_csbase = vmcb12_csbase;
>  		svm->soft_int_old_rip = vmcb12_rip;
> -		if (guest_can_use(vcpu, X86_FEATURE_NRIPS))
> +		if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
>  			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
>  		else
>  			svm->soft_int_next_rip = vmcb12_rip;
> @@ -737,18 +737,18 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  
>  	vmcb02->control.virt_ext            = vmcb01->control.virt_ext &
>  					      LBR_CTL_ENABLE_MASK;
> -	if (guest_can_use(vcpu, X86_FEATURE_LBRV))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV))
>  		vmcb02->control.virt_ext  |=
>  			(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK);
>  
>  	if (!nested_vmcb_needs_vls_intercept(svm))
>  		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
>  
> -	if (guest_can_use(vcpu, X86_FEATURE_PAUSEFILTER))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PAUSEFILTER))
>  		pause_count12 = svm->nested.ctl.pause_filter_count;
>  	else
>  		pause_count12 = 0;
> -	if (guest_can_use(vcpu, X86_FEATURE_PFTHRESHOLD))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PFTHRESHOLD))
>  		pause_thresh12 = svm->nested.ctl.pause_filter_thresh;
>  	else
>  		pause_thresh12 = 0;
> @@ -1035,7 +1035,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	if (vmcb12->control.exit_code != SVM_EXIT_ERR)
>  		nested_save_pending_event_to_vmcb12(svm, vmcb12);
>  
> -	if (guest_can_use(vcpu, X86_FEATURE_NRIPS))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
>  		vmcb12->control.next_rip  = vmcb02->control.next_rip;
>  
>  	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
> @@ -1074,7 +1074,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	if (!nested_exit_on_intr(svm))
>  		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
>  
> -	if (unlikely(guest_can_use(vcpu, X86_FEATURE_LBRV) &&
> +	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
>  		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
>  		svm_copy_lbrs(vmcb12, vmcb02);
>  		svm_update_lbrv(vcpu);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1855a6d7c976..8a99a73b6ee5 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1046,7 +1046,7 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
>  	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
> -			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
> +			    (is_guest_mode(vcpu) && guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
>  			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
>  
>  	if (enable_lbrv == current_enable_lbrv)
> @@ -2835,7 +2835,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	switch (msr_info->index) {
>  	case MSR_AMD64_TSC_RATIO:
>  		if (!msr_info->host_initiated &&
> -		    !guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR))
> +		    !guest_cpu_cap_has(vcpu, X86_FEATURE_TSCRATEMSR))
>  			return 1;
>  		msr_info->data = svm->tsc_ratio_msr;
>  		break;
> @@ -2985,7 +2985,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  	switch (ecx) {
>  	case MSR_AMD64_TSC_RATIO:
>  
> -		if (!guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR)) {
> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_TSCRATEMSR)) {
>  
>  			if (!msr->host_initiated)
>  				return 1;
> @@ -3007,7 +3007,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  
>  		svm->tsc_ratio_msr = data;
>  
> -		if (guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR) &&
> +		if (guest_cpu_cap_has(vcpu, X86_FEATURE_TSCRATEMSR) &&
>  		    is_guest_mode(vcpu))
>  			nested_svm_update_tsc_ratio_msr(vcpu);
>  
> @@ -4318,11 +4318,11 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
>  	    boot_cpu_has(X86_FEATURE_XSAVES) &&
>  	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
> -		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
> +		guest_cpu_cap_set(vcpu, X86_FEATURE_XSAVES);
>  
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_NRIPS);
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LBRV);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_NRIPS);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_LBRV);
>  
>  	/*
>  	 * Intercept VMLOAD if the vCPU mode is Intel in order to emulate that
> @@ -4330,12 +4330,12 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	 * SVM on Intel is bonkers and extremely unlikely to work).
>  	 */
>  	if (!guest_cpuid_is_intel(vcpu))
> -		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
> +		guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
>  
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PAUSEFILTER);
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VGIF);
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VNMI);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_PAUSEFILTER);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VGIF);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VNMI);
>  
>  	svm_recalc_instruction_intercepts(vcpu, svm);
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index be67ab7fdd10..e49af42b4a33 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -443,7 +443,7 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
>  
>  static inline bool nested_vgif_enabled(struct vcpu_svm *svm)
>  {
> -	return guest_can_use(&svm->vcpu, X86_FEATURE_VGIF) &&
> +	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_VGIF) &&
>  	       (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK);
>  }
>  
> @@ -495,7 +495,7 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
>  
>  static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
>  {
> -	return guest_can_use(&svm->vcpu, X86_FEATURE_VNMI) &&
> +	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_VNMI) &&
>  	       (svm->nested.ctl.int_ctl & V_NMI_ENABLE_MASK);
>  }
>  
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index c5ec0ef51ff7..4750d1696d58 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6426,7 +6426,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  	vmx = to_vmx(vcpu);
>  	vmcs12 = get_vmcs12(vcpu);
>  
> -	if (guest_can_use(vcpu, X86_FEATURE_VMX) &&
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_VMX) &&
>  	    (vmx->nested.vmxon || vmx->nested.smm.vmxon)) {
>  		kvm_state.hdr.vmx.vmxon_pa = vmx->nested.vmxon_ptr;
>  		kvm_state.hdr.vmx.vmcs12_pa = vmx->nested.current_vmptr;
> @@ -6567,7 +6567,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  		if (kvm_state->flags & ~KVM_STATE_NESTED_EVMCS)
>  			return -EINVAL;
>  	} else {
> -		if (!guest_can_use(vcpu, X86_FEATURE_VMX))
> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
>  			return -EINVAL;
>  
>  		if (!page_address_valid(vcpu, kvm_state->hdr.vmx.vmxon_pa))
> @@ -6601,7 +6601,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  		return -EINVAL;
>  
>  	if ((kvm_state->flags & KVM_STATE_NESTED_EVMCS) &&
> -	    (!guest_can_use(vcpu, X86_FEATURE_VMX) ||
> +	    (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX) ||
>  	     !vmx->nested.enlightened_vmcs_enabled))
>  			return -EINVAL;
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index be20a60047b1..6328f0d47c64 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2050,7 +2050,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			[msr_info->index - MSR_IA32_SGXLEPUBKEYHASH0];
>  		break;
>  	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
> -		if (!guest_can_use(vcpu, X86_FEATURE_VMX))
> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
>  			return 1;
>  		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
>  				    &msr_info->data))
> @@ -2358,7 +2358,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
>  		if (!msr_info->host_initiated)
>  			return 1; /* they are read-only */
> -		if (!guest_can_use(vcpu, X86_FEATURE_VMX))
> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
>  			return 1;
>  		return vmx_set_vmx_msr(vcpu, msr_index, data);
>  	case MSR_IA32_RTIT_CTL:
> @@ -4567,7 +4567,7 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
>  												\
>  	if (cpu_has_vmx_##name()) {								\
>  		if (kvm_is_governed_feature(X86_FEATURE_##feat_name))				\
> -			__enabled = guest_can_use(__vcpu, X86_FEATURE_##feat_name);		\
> +			__enabled = guest_cpu_cap_has(__vcpu, X86_FEATURE_##feat_name);		\
>  		else										\
>  			__enabled = guest_cpuid_has(__vcpu, X86_FEATURE_##feat_name);		\
>  		vmx_adjust_secondary_exec_control(vmx, exec_control, SECONDARY_EXEC_##ctrl_name,\
> @@ -7757,9 +7757,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	 */
>  	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
>  	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
> -		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_XSAVES);
> +		guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_XSAVES);
>  
> -	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VMX);
> +	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VMX);
>  
>  	vmx_setup_uret_msrs(vmx);
>  
> @@ -7767,7 +7767,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  		vmcs_set_secondary_exec_control(vmx,
>  						vmx_secondary_exec_control(vmx));
>  
> -	if (guest_can_use(vcpu, X86_FEATURE_VMX))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
>  		vmx->msr_ia32_feature_control_valid_bits |=
>  			FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
>  			FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
> @@ -7776,7 +7776,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  			~(FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
>  			  FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX);
>  
> -	if (guest_can_use(vcpu, X86_FEATURE_VMX))
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
>  		nested_vmx_cr_fixed1_bits_update(vcpu);
>  
>  	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2c924075f6f1..04a77b764a36 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1025,7 +1025,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>  		if (vcpu->arch.xcr0 != host_xcr0)
>  			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
>  
> -		if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
> +		if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
>  		    vcpu->arch.ia32_xss != host_xss)
>  			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
>  	}
> @@ -1056,7 +1056,7 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>  		if (vcpu->arch.xcr0 != host_xcr0)
>  			xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
>  
> -		if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
> +		if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
>  		    vcpu->arch.ia32_xss != host_xss)
>  			wrmsrl(MSR_IA32_XSS, host_xss);
>  	}


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




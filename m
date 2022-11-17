Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7554362E4C9
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 19:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbiKQSyN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 13:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235001AbiKQSyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 13:54:11 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7449A86A54
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 10:54:10 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so6217975pjs.4
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 10:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7tuTPYaip0buFm1R2LuQQeQrPhqmlAkfQwU5all+C98=;
        b=YrWkEshLI0itsiLecKhk4dwkmRm2FcGLQhVSYFiiCVDxfQPf7xMnX3wL0UWBXt4/yZ
         75bcxHlIJDWBaLf32PBaCMOQT4RUdEBw9ynjAVisMNySTa8TaOUUsq8aozrDZ/4ZRLXM
         UhnL7EyhuxfvwSDMjKYPNvDtZac1Bi3dXaPIuYzc7Khn3Kc263Fxr0cPG6RBbPXrIgJT
         lCV341NG9BWzUcbaqSpT4exu3kb232urOIoCuE0cnX+H5OeB+CelCrPpbLm4Z10nPBcu
         7//7r9IntV8SKhai7dClyJRDymY3MHN4RIv50ZmrBbtq4XKH4s2D/mwO1dpubo8O/6Oa
         Z0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7tuTPYaip0buFm1R2LuQQeQrPhqmlAkfQwU5all+C98=;
        b=nGWPR8k/i/9JtaK13CiWZAYSPlPcezi1KI0To3Dwktg2KmdzXIGltIu8WlkeSzuBVY
         DlV2iNKcyHlAizHqScL+2Sspdp2QCLiNui5JtOAZ7zef7+OmlzUGVCKhNUOr4k6gb/X7
         Pps3zyOpWUCzLarhTMI4WcdDDmnZSFohPzxvjmCw6vAsbO5G1Q31qX7vbRlHHImZ9GMT
         U1NWKdpItD3GO6Nahn90uhLXTRScjQrXXdggL7QYo9M+uElMuzZVRQRLhc5u9NQtr0VL
         +5z7HYaA0nyRT4+sCZBnUcjOFXmThkXME+5BlezlBqYbthJmoem7FkNF+ffqw5KQa1ui
         2NqQ==
X-Gm-Message-State: ANoB5pklMW8VqFpFjqBdLgGcNVdM1QLB9TIEvYdxG9yQA0FOlTr/p314
        HEyN+6rP9mf9QlLrEuD8ef2LuA==
X-Google-Smtp-Source: AA0mqf6iD6Di3oz2avNhbgCCtvr0vmOmmX5lTTYWd5gW61sbaegZZur6x2lLj1Zso+P8PGZFpbvJOw==
X-Received: by 2002:a17:902:f78c:b0:188:5d24:87e with SMTP id q12-20020a170902f78c00b001885d24087emr4089103pln.87.1668711249805;
        Thu, 17 Nov 2022 10:54:09 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l11-20020a170903120b00b001769e6d4fafsm1801632plh.57.2022.11.17.10.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 10:54:09 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:54:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: Re: [PATCH 07/13] KVM: SVM: Add VNMI support in get/set_nmi_mask
Message-ID: <Y3aDTvglaSfhG8Tg@google.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
 <20221117143242.102721-8-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117143242.102721-8-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022, Maxim Levitsky wrote:
> From: Santosh Shukla <santosh.shukla@amd.com>
> 
> VMCB intr_ctrl bit12 (V_NMI_MASK) is set by the processor when handling
> NMI in guest and is cleared after the NMI is handled. Treat V_NMI_MASK
> as read-only in the hypervisor except for the SMM case where hypervisor
> before entring and after leaving SMM mode requires to set and unset
> V_NMI_MASK.
> 
> Adding API(get_vnmi_vmcb) in order to return the correct vmcb for L1 or
> L2.
> 
> Maxim:
>    - made set_vnmi_mask/clear_vnmi_mask/is_vnmi_mask warn if called
>      without vNMI enabled
>    - clear IRET intercept in svm_set_nmi_mask even with vNMI
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c | 18 ++++++++++++++-
>  arch/x86/kvm/svm/svm.h | 52 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 69 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 08a7b2a0a29f3a..c16f68f6c4f7d7 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3618,13 +3618,29 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>  
>  static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
>  {
> -	return !!(vcpu->arch.hflags & HF_NMI_MASK);
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (is_vnmi_enabled(svm))
> +		return is_vnmi_mask_set(svm);
> +	else
> +		return !!(vcpu->arch.hflags & HF_NMI_MASK);
>  }
>  
>  static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> +	if (is_vnmi_enabled(svm)) {
> +		if (masked)
> +			set_vnmi_mask(svm);

I believe not setting INTERCEPT_IRET is correct, but only because the existing
code is unnecessary.  And this all very subtly relies on KVM_REQ_EVENT being set
and/or KVM already being in kvm_check_and_inject_events().

When NMIs become unblocked, INTERCEPT_IRET can be cleared, but KVM should also
pending KVM_REQ_EVENT.  AFAICT, that doesn't happen when this is called via the
emulator.  Ah, because em_iret() only handles RM for Intel's restricted guest
crap.  I.e. it "works" only because it never happens.  All other flows set
KVM_REQ_EVENT when toggling NMI blocking, e.g. the RSM path of kvm_smm_changed().

And when NMIs become blocked, there's no need to force INTERCEPT_IRET in this
code because kvm_check_and_inject_events() will request an NMI window and set the
intercept if necessary, and all paths that set NMI blocking are guaranteed to
reach kvm_check_and_inject_events() before entering the guest.

  1. RSM => kvm_smm_changed() sets KVM_REQ_EVENT
  2. enter_smm() is only called from within kvm_check_and_inject_events(),
     before pending NMIs are processed (yay priority)
  3. emulator_set_nmi_mask() never blocks NMIs, only does the half-baked IRET emulation
  4. kvm_vcpu_ioctl_x86_set_vcpu_event() sets KVM_REQ_EVENT

So, can you add a prep patch to drop the forced INTERCEPT_IRET?  That way the
logic for vNMI and !vNMI is the same.

> +		else {
> +			clear_vnmi_mask(svm);

This is the only code that sets/clears the vNMI mask, so rather than have set/clear
helpers, what about a single helper to do the dirty work? 

> +			if (!sev_es_guest(vcpu->kvm))
> +				svm_clr_intercept(svm, INTERCEPT_IRET);
> +		}
> +		return;
> +	}
> +
>  	if (masked) {
>  		vcpu->arch.hflags |= HF_NMI_MASK;
>  		if (!sev_es_guest(vcpu->kvm))
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index f5383104d00580..bf7f4851dee204 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -35,6 +35,7 @@ extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  extern bool npt_enabled;
>  extern int vgif;
>  extern bool intercept_smi;
> +extern bool vnmi;
>  
>  enum avic_modes {
>  	AVIC_MODE_NONE = 0,
> @@ -531,6 +532,57 @@ static inline bool is_x2apic_msrpm_offset(u32 offset)
>  	       (msr < (APIC_BASE_MSR + 0x100));
>  }
>  
> +static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
> +{
> +	if (!vnmi)
> +		return NULL;
> +
> +	if (is_guest_mode(&svm->vcpu))
> +		return svm->nested.vmcb02.ptr;
> +	else
> +		return svm->vmcb01.ptr;
> +}
> +
> +static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
> +{
> +	struct vmcb *vmcb = get_vnmi_vmcb(svm);
> +
> +	if (vmcb)
> +		return !!(vmcb->control.int_ctl & V_NMI_ENABLE);
> +	else
> +		return false;

Maybe just this?

	return vmcb && (vmcb->control.int_ctl & V_NMI_ENABLE);

Or if an inner helper is added:

	return vmcb && __is_vnmi_enabled(vmcb);

> +}
> +
> +static inline bool is_vnmi_mask_set(struct vcpu_svm *svm)
> +{
> +	struct vmcb *vmcb = get_vnmi_vmcb(svm);
> +
> +	if (!WARN_ON_ONCE(!vmcb))

Rather than WARN, add an inner __is_vnmi_enabled() that takes the vnmi_vmcb.
Actually, if you do that, the test/set/clear helpers can go away entirely.

> +		return false;
> +
> +	return !!(vmcb->control.int_ctl & V_NMI_MASK);
> +}
> +
> +static inline void set_vnmi_mask(struct vcpu_svm *svm)
> +{
> +	struct vmcb *vmcb = get_vnmi_vmcb(svm);
> +
> +	if (!WARN_ON_ONCE(!vmcb))
> +		return;
> +
> +	vmcb->control.int_ctl |= V_NMI_MASK;
> +}
> +
> +static inline void clear_vnmi_mask(struct vcpu_svm *svm)
> +{
> +	struct vmcb *vmcb = get_vnmi_vmcb(svm);
> +
> +	if (!WARN_ON_ONCE(!vmcb))
> +		return;
> +
> +	vmcb->control.int_ctl &= ~V_NMI_MASK;
> +}

These helpers can all go in svm.  There are no users oustide of svm.c, and
unless I'm misunderstanding how nested works, there should never be oustide users.

E.g. with HF_NMI_MASK => svm->nmi_masked, the end result can be something like:

static bool __is_vnmi_enabled(struct *vmcb)
{
	return !!(vmcb->control.int_ctl & V_NMI_ENABLE);
}

static bool is_vnmi_enabled(struct vcpu_svm *svm)
{
	struct vmcb *vmcb = get_vnmi_vmcb(svm);

	return vmcb && __is_vnmi_enabled(vmcb);
}

static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
{
	struct vcpu_svm *svm = to_svm(vcpu);
	struct vmcb *vmcb = get_vnmi_vmcb(svm);

	if (vmcb && __is_vnmi_enabled(vmcb))
		return !!(vmcb->control.int_ctl & V_NMI_MASK);
	else
		return !!(vcpu->arch.hflags & HF_NMI_MASK);
}

static void svm_set_or_clear_vnmi_mask(struct vmcb *vmcb, bool set)
{
	if (set)
		vmcb->control.int_ctl |= V_NMI_MASK;
	else
		vmcb->control.int_ctl &= ~V_NMI_MASK;
}

static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
{
	struct vcpu_svm *svm = to_svm(vcpu);
	struct vmcb *vmcb = get_vnmi_vmcb(svm);

	if (vmcb && __is_vnmi_enabled(vmcb)) {
		if (masked)
			vmcb->control.int_ctl |= V_NMI_MASK;
		else
			vmcb->control.int_ctl &= ~V_NMI_MASK;
	} else {
		svm->nmi_masked = masked;
	}

	if (!masked)
		svm_disable_iret_interception(svm);
}

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D44685C1E
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 01:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbjBAAWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 19:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjBAAWq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 19:22:46 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F0F4237
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 16:22:44 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id n2so11449948pfo.3
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 16:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CuOoy+/Js2oVfzgZZT9zL9WAM0yR6EU6wAmxakT75FU=;
        b=BiiK9fHkGIaYEdI7w97f2x4LombSeOx0ZP1e210j4wX90NQRab3ZseVzGcY3Z4pBvS
         iFPQochfu2sEpWbAa8ahkyZtBmJ3nerkNW1oUu9YDpBeH71PmsD0O1mcnY2T4rUTb8/Q
         cGqeyQw+m531goiLG64eHYDF47of5xh4agzg5kTclt1wnErNyTI+fYjK9fdMgO7wnO1f
         s5dTy7RppTaFPJhD4YfX+Q5An3BxDkDRazMMzRJqzEw+cKaor66pPBubeWLv8nnfy9Rm
         OuHxRld5ENG/cUEOynuvwnm/86sB97b6qOXOAMrEhdpcRyqxwNcs/VxwhCjH6Ci3WPfh
         vaHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CuOoy+/Js2oVfzgZZT9zL9WAM0yR6EU6wAmxakT75FU=;
        b=sHD/uUnlTVYs/uqEjBm9OT/1SkLkv5Q+2aw5w/7UrBuwXGTIC1fXMWJXf+olBMTYn6
         beqlXvCeeVXK6hlnSbmSuyI2OI5Rt7AT/WIM6FzPj6ZsDnrTrSgt1sTCdJtdpLxeE8EF
         e8fRngpzK1loF5D+aeQH8jVJ8xWCwNP1z60/sI2j/Kwjzb6ippOKfDFjO5xC1U8qA2ny
         k/A5N9qqptRxy2twQHcQrjjkIB0Scsg1PrOeZzWaNqeHAZ1OUzRVDpr2CNQpUq3d92rd
         kcp06X6N43JkNsUAxKMrAJmWvpTS2SIomJsoM7gVdlaBzFy+64DlC1lAbR2qlbQwHUI0
         W0Zg==
X-Gm-Message-State: AO0yUKWyFgMenhOfr0OptXAe0NeZ+pIQlGnikqSDMPVjkfC0yOIRp9gc
        WYp6FbGlrL1sDQhdbsKgvOxJAg==
X-Google-Smtp-Source: AK7set9GY33Es6xoeQ+3td0vhHBDBT+cmrMg/ATnLBvoc7KiZ9npsD5nt4WUgiUh42mUFYeJ5aH+tQ==
X-Received: by 2002:a62:1c4e:0:b0:590:7627:91b with SMTP id c75-20020a621c4e000000b005907627091bmr220524pfc.0.1675210964054;
        Tue, 31 Jan 2023 16:22:44 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b2-20020aa79502000000b0058da92f7c8dsm10378709pfp.17.2023.01.31.16.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 16:22:43 -0800 (PST)
Date:   Wed, 1 Feb 2023 00:22:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: Re: [PATCH v2 10/11] KVM: SVM: implement support for vNMI
Message-ID: <Y9mwz/G6+G8NSX3+@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-11-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129193717.513824-11-mlevitsk@redhat.com>
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

On Tue, Nov 29, 2022, Maxim Levitsky wrote:
> This patch implements support for injecting pending
> NMIs via the .kvm_x86_set_hw_nmi_pending using new AMD's vNMI

Wrap closer to 75 chars, and please try to be consistent in how your format
things like changelogs and comments.  It's jarring as a reader when the wrap
column is constantly changing.

> feature.

Please combine the introduction, usage, and implementation of the hew kvm_x86_ops,
i.e. introduce and use the ops in this patch.  It's extremely difficult to review
the common x86 code that uses the ops without seeing how they're implemented in
SVM.  I believe the overall size/scope of the patch can be kept reasonable by
introducing some of the common changes in advance of the new ops, e.g. tweaking
the KVM_SET_VCPU_EVENTS flow.

> Note that the vNMI can't cause a VM exit, which is needed
> when a nested guest intercepts NMIs.

I can't tell if this is saying "SVM doesn't allow intercepting virtual NMIs", or
"KVM never enables virtual NMI interception".

> Therefore to avoid breaking nesting, the vNMI is inhibited while
> a nested guest is running and instead, the legacy NMI window
> detection and delivery method is used.

State what KVM does, don't describe the effects.  E.g. "Disable vNMI while running
L2".  When a changelog describes the effects, it's unclear whether the effects are
new behavior introduced by the patch, hardware behavior, etc...

> While it is possible to passthrough the vNMI if a nested guest
> doesn't intercept NMIs, such usage is very uncommon, and it's
> not worth to optimize for.

Can you elaborate on why not?  It's not obvious to me that the code will end up
more complex, and oftentimes omitting code increases the cognitive load on readers,
i.e. makes things more complex in a way.  vNMI is mutually exclusive with NMI
passthrough, i.e. KVM doesn't need to handle NMI passthrough and vNMI simultaneously.

> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

SoB chain is wrong.  Maxim is credited as the sole Author, i.e. Santosh shouldn't
have a SoB.  Assuming the intent is to attribute both of ya'll this needs to be

 Co-developed-by: Santosh Shukla <santosh.shukla@amd.com>
 Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
 Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

if Maxim is the primary author, or this if Santosh is the primary author

 From: Santosh Shukla <santosh.shukla@amd.com>

 <blah blah blah>

 Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
 Developed-by: Maxim Levitsky <mlevitsk@redhat.com>
 Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

> ---
>  arch/x86/kvm/svm/nested.c |  42 +++++++++++++++
>  arch/x86/kvm/svm/svm.c    | 111 ++++++++++++++++++++++++++++++--------
>  arch/x86/kvm/svm/svm.h    |  10 ++++
>  3 files changed, 140 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index e891318595113e..5bea672bf8b12d 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -623,6 +623,42 @@ static bool is_evtinj_nmi(u32 evtinj)
>  	return type == SVM_EVTINJ_TYPE_NMI;
>  }
>  
> +static void nested_svm_save_vnmi(struct vcpu_svm *svm)

Please avoid save/restore names.  KVM (selftests in particular) uses save/restore
to refer to a saving and restoring state across a migration.  "sync" is probably
the best option, or just open code the flows.

> +{
> +	struct vmcb *vmcb01 = svm->vmcb01.ptr;
> +
> +	/*
> +	 * Copy the vNMI state back to software NMI tracking state
> +	 * for the duration of the nested run
> +	 */
> +
> +	svm->nmi_masked = vmcb01->control.int_ctl & V_NMI_MASK;
> +	svm->vcpu.arch.nmi_pending += vmcb01->control.int_ctl & V_NMI_PENDING;

This is wrong.  V_NMI_PENDING is bit 11, i.e. the bitwise-AND does not yield a
boolean value and will increment nmi_pending by 2048 instead of by 1.

	if (vmcb01->control.int_ctl & V_NMI_PENDING)
		svm->vcpu.arch.nmi_pending++;

And this needs a KVM_REQ_EVENT to ensure KVM processes the newly pending NMI.

> +}
> +
> +static void nested_svm_restore_vnmi(struct vcpu_svm *svm)
> +{
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct vmcb *vmcb01 = svm->vmcb01.ptr;
> +
> +	/*
> +	 * Restore the vNMI state from the software NMI tracking state
> +	 * after a nested run
> +	 */
> +
> +	if (svm->nmi_masked)
> +		vmcb01->control.int_ctl |= V_NMI_MASK;
> +	else
> +		vmcb01->control.int_ctl &= ~V_NMI_MASK;

As proposed, this needs to clear nmi_masked to avoid false positives.  The better
approach is to not have any open coded accesses to svm->nmi_masked outside of
flows that specifically need to deal with vNMI logic.

E.g. svm_enable_nmi_window() reads the raw nmi_masked.

> +
> +	if (vcpu->arch.nmi_pending) {
> +		vcpu->arch.nmi_pending--;
> +		vmcb01->control.int_ctl |= V_NMI_PENDING;
> +	} else

Curly braces on all paths if any path needs 'em.

> +		vmcb01->control.int_ctl &= ~V_NMI_PENDING;
> +}

...

> + static bool svm_set_hw_nmi_pending(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (!is_vnmi_enabled(svm))
> +		return false;
> +
> +	if (svm->vmcb->control.int_ctl & V_NMI_PENDING)
> +		return false;
> +
> +	svm->vmcb->control.int_ctl |= V_NMI_PENDING;
> +	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
> +
> +	/*
> +	 * NMI isn't yet technically injected but
> +	 * this rough estimation should be good enough

Again, wrap at 80 chars, not at random points.

> +	 */
> +	++vcpu->stat.nmi_injections;
> +
> +	return true;
> +}
> +

...

>  bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -3725,10 +3772,16 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>  	/*
>  	 * Something prevents NMI from been injected. Single step over possible
>  	 * problem (IRET or exception injection or interrupt shadow)
> +	 *
> +	 * With vNMI we should never need an NMI window
> +	 * (we can always inject vNMI either by setting VNMI_PENDING or by EVENTINJ)

Please honor the soft limit and avoid pronouns.  There's also no need to put the
blurb in parantheses on its own line.

As for the code, I believe there are bugs.  Pulling in the context...

	if (svm->nmi_masked && !svm->awaiting_iret_completion)
		return; /* IRET will cause a vm exit */

Checking nmi_masked is wrong, this should use the helper.  Even if this code can
only be reached on error, it should still try its best to not make things worse.

	if (!gif_set(svm)) {
		if (vgif)
			svm_set_intercept(svm, INTERCEPT_STGI);
		return; /* STGI will cause a vm exit */
	}

	/*
	 * Something prevents NMI from been injected. Single step over possible
	 * problem (IRET or exception injection or interrupt shadow)
	 *
	 * With vNMI we should never need an NMI window
	 * (we can always inject vNMI either by setting VNMI_PENDING or by EVENTINJ)
	 */
	if (WARN_ON_ONCE(is_vnmi_enabled(svm)))
		return;

This is flawed, where "this" means handling of NMI windows when vNMI is enabled.

IIUC, if there are back-to-back NMIs, the intent is to set V_NMI for one and
inject the other.  I believe there are multiple bugs svm_inject_nmi().  The one
that's definitely a bug is setting svm->nmi_masked.  The other suspected bug,
which is related to the above WARN, is setting the IRET intercept.  The resulting
IRET interception will set awaiting_iret_completion, and then the above WARN is
reachable (even if the masking check is fixed).

I don't think KVM needs to ever intercept IRET.  One NMI gets injected, and the
other is sitting in INT_CTL.V_NMI_PENDING, i.e. there's no need for KVM to regain
control.  If another NMI comes along before V_NMI_PENDING is handled, it will
either get injected or dropped.

So I _think_ KVM can skip the intercept code when injecting an NMI, and this WARN
can be hoisted to the top of svm_enable_nmi_window(), because as stated above, KVM
should never need to request an NMI window.

Last thought, unless there's something that will obviously break, it's probably
better to WARN and continue than to bail.  I.e. do the single-step and hope for
the best.  Bailing at this point doesn't seem like it would help.

>  	 */
> +	if (WARN_ON_ONCE(is_vnmi_enabled(svm)))
> +		return;
> +
>  	svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
> -	svm->nmi_singlestep = true;
>  	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
> +	svm->nmi_singlestep = true;
>  }

...

> @@ -553,6 +554,15 @@ static inline bool is_x2apic_msrpm_offset(u32 offset)
>  	       (msr < (APIC_BASE_MSR + 0x100));
>  }
>  
> +static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
> +{
> +	/* L1's vNMI is inhibited while nested guest is running */
> +	if (is_guest_mode(&svm->vcpu))

I would rather check the current VMCB.  I don't see any value in hardcoding the
"KVM doesn't support vNMI in L2" in multiple places.  And I find the above comment
about "L1's vNMI is inhibited" confusing.  vNMI isn't inhibited/blocked, KVM just
doesn't utilize vNMI while L2 is active (IIUC, as proposed).

> +		return false;
> +
> +	return !!(svm->vmcb01.ptr->control.int_ctl & V_NMI_ENABLE);
> +}
> +
>  /* svm.c */
>  #define MSR_INVALID				0xffffffffU
>  
> -- 
> 2.26.3
> 

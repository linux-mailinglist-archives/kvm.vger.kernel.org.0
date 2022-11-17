Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4017162E3FE
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 19:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240377AbiKQSVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 13:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbiKQSVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 13:21:43 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193225130B
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 10:21:43 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id io19so2382832plb.8
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 10:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lr78Yau/0ZuciclKD/43OciuX+84fm0DnfS4/ZC/c4g=;
        b=rwaeeJv+REvrzu7YQOJHP/Jgm2kagbxlHbxA1RNjHOwWOa4z/pMRJiQU+oYDpWp1vZ
         Wyn+VRj9wHdsl+80FEin+j+CqflwHsXmjL3XnFpkGFEvJniERReiPH5xB/tO0sf4fjUw
         EiziwfL+XagvxGAT+7BoKZru64lJiQSiaD+DSDGZfmi21Dk7oYzH/7GNwXZshgJmuBWb
         13AD3PWY4MOkWB94I9YNxSuG9Q1zGtEiWZtZD+e2Ia4uK7HIAs9sbW2y5PQ2Qob0zLbA
         hIC9e9XXwBa6PaWrzdr+EfKp6sHMbM/5gFnGB0SKLI/4LRB426oGxYmgjfZpDxY9HkHE
         k+ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lr78Yau/0ZuciclKD/43OciuX+84fm0DnfS4/ZC/c4g=;
        b=qVNlxrr7sVvun+ckD4wtYDx7hWMbB3YE2ACjKeXRGebi2M7mp3rupXBc4yB5VchX9X
         hhK6bKvXJKJV17riNmZOU7IukaPPV6LMPWgPPc105/f1g//I6pFKPvtk1eTru320l8cr
         am690GS4cyoL+5FzKB5WQu8Nlh6Qw9TbDr88fhgKMdX39GrNvIlqxJenFfOy1NFOnrw/
         zDV8TtN/wOcBvOS4Bv4JCPgikUVA76tlGTfh3xYVHtcmG+1T8+pCJAowU3jCVxO+kG2U
         oCO2/Z8u7dp24T6E6AoSC52Kfg4bqJJ56QbPGzJNYjxyZkeQrjn52KYaloRVr+Gmt1XC
         iaQA==
X-Gm-Message-State: ANoB5pmTHZVFCk08HS+cBI9puHv5s4pAM5mTroSwSOLY1WqbhkVS+a6Z
        zuJLtlLUSvr5GUVLsjT3xY6Ip9Ef6N2uDA==
X-Google-Smtp-Source: AA0mqf7cDSanTtq4Yh/w4RJLWRS/t+yEgzpSP16QAMWCntRgJR/xadL5skrX0bzvJp3Dco0KVfw3DA==
X-Received: by 2002:a17:902:b414:b0:186:7fda:4d4a with SMTP id x20-20020a170902b41400b001867fda4d4amr3994779plr.66.1668709302378;
        Thu, 17 Nov 2022 10:21:42 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y65-20020a626444000000b0056d73ef41fdsm1481643pfb.75.2022.11.17.10.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 10:21:42 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:21:38 +0000
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
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: Re: [PATCH 09/13] KVM: SVM: allow NMI window with vNMI
Message-ID: <Y3Z7sq42Ao/qRn0u@google.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
 <20221117143242.102721-10-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117143242.102721-10-mlevitsk@redhat.com>
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
> When the vNMI is enabled, the only case when the KVM will use an NMI
> window is when the vNMI injection is pending.
> 
> In this case on next IRET/RSM/STGI, the injection has to be complete
> and a new NMI can be injected.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cfec4c98bb589b..eaa30f8ace518d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2477,7 +2477,10 @@ static int iret_interception(struct kvm_vcpu *vcpu)
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
>  	++vcpu->stat.nmi_window_exits;
> -	vcpu->arch.hflags |= HF_IRET_MASK;
> +
> +	if (!is_vnmi_enabled(svm))
> +		vcpu->arch.hflags |= HF_IRET_MASK;

Ugh, HF_IRET_MASK is such a terrible name/flag.  Given that it lives with GIF
and NMI, one would naturally think that it means "IRET is intercepted", but it
really means "KVM just intercepted an IRET and is waiting for NMIs to become
unblocked".

And on a related topic, why on earth are GIF, NMI, and IRET tracked in hflags?
They are 100% SVM concepts.  IMO, this code would be much easier to follow if
by making them bools in vcpu_svm with more descriptive names.

> +
>  	if (!sev_es_guest(vcpu->kvm)) {
>  		svm_clr_intercept(svm, INTERCEPT_IRET);
>  		svm->nmi_iret_rip = kvm_rip_read(vcpu);

The vNMI interaction with this logic is confusing, as nmi_iret_rip doesn't need
to be captured for the vNMI case.  SEV-ES actually has unrelated reasons for not
reading RIP vs. not intercepting IRET, they just got bundled together here for
convenience.

This is also an opportunity to clean up the SEV-ES interaction with IRET interception,
which is splattered all over the place and isn't documented anywhere.

E.g. (with an HF_IRET_MASK => awaiting_iret_completion change)

/*
 * For SEV-ES guests, KVM must not rely on IRET to detect NMI unblocking as
 * #VC->IRET in the guest will result in KVM thinking NMIs are unblocked before
 * the guest is ready for a new NMI.  Architecturally, KVM is 100% correct to
 * treat NMIs as unblocked on IRET, but the guest-host ABI for SEV-ES guests is
 * that KVM must wait for an explicit "NMI Complete" from the guest.
 */
static void svm_disable_iret_interception(struct vcpu_svm *svm)
{
	if (!sev_es_guest(svm->vcpu.kvm))
		svm_clr_intercept(svm, INTERCEPT_IRET);
}

static void svm_enable_iret_interception(struct vcpu_svm *svm)
{
	if (!sev_es_guest(svm->vcpu.kvm))
		svm_set_intercept(svm, INTERCEPT_IRET);
}

static int iret_interception(struct kvm_vcpu *vcpu)
{
	struct vcpu_svm *svm = to_svm(vcpu);

	++vcpu->stat.nmi_window_exits;

	/*
	 * No need to wait for the IRET to complete if vNMIs are enabled as
	 * hardware will automatically process the pending NMI when NMIs are
	 * unblocked from the guest's perspective.
	 */
	if (!is_vnmi_enabled(svm)) {
		svm->awaiting_iret_completion = true;

		/*
		 * The guest's RIP is inaccessible for SEV-ES guests, just
		 * assume forward progress was made on the next VM-Exit.
		 */
		if (!sev_es_guest(vcpu->kvm))
			svm->nmi_iret_rip = kvm_rip_read(vcpu);
	}

	svm_disable_iret_interception(svm);

	kvm_make_request(KVM_REQ_EVENT, vcpu);
	return 1;
}

> @@ -3735,9 +3738,6 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	if (is_vnmi_enabled(svm))
> -		return;
> -
>  	if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
>  		return; /* IRET will cause a vm exit */

As much as I like incremental patches, in this case I'm having a hell of a time
reviewing the code as the vNMI logic ends up being split across four patches.
E.g. in this particular case, the above requires knowing that svm_inject_nmi()
never sets HF_NMI_MASK when vNMI is enabled.

In the next version, any objection to squashing patches 7-10 into a single "Add
non-nested vNMI support" patch?

As for this code, IMO some pre-work to change the flow would help with the vNMI
case.  The GIF=0 logic overrides legacy NMI blocking, and so can be handled first.
And I vote to explicitly set INTERCEPT_IRET in the above case instead of relying
on INTERCEPT_IRET to already be set by svm_inject_nmi().

That would yield this as a final result:

static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
{
	struct vcpu_svm *svm = to_svm(vcpu);

	/*
	 * GIF=0 blocks NMIs irrespective of legacy NMI blocking.  No need to
	 * intercept or single-step IRET if GIF=0, just intercept STGI.
	 */
	if (!gif_set(svm)) {
		if (vgif)
			svm_set_intercept(svm, INTERCEPT_STGI);
		return;
	}

	/*
	 * NMI is blocked, either because an NMI is in service or because KVM
	 * just injected an NMI.  If KVM is waiting for an intercepted IRET to
	 * complete, single-step the IRET to wait for NMIs to become unblocked.
	 * Otherwise, intercept the guest's next IRET.
	 */
	if (svm->awaiting_iret_completion) {
		svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
		svm->nmi_singlestep = true;
		svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
	} else {
		svm_set_intercept(svm, INTERCEPT_IRET);
	}
}

>  
> @@ -3751,9 +3751,14 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>  	 * Something prevents NMI from been injected. Single step over possible
>  	 * problem (IRET or exception injection or interrupt shadow)
>  	 */
> -	svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
> -	svm->nmi_singlestep = true;
> -	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
> +
> +	if (is_vnmi_enabled(svm)) {
> +		svm_set_intercept(svm, INTERCEPT_IRET);

This will break SEV-ES.  Per commit 4444dfe4050b ("KVM: SVM: Add NMI support for
an SEV-ES guest"), the hypervisor must not rely on IRET interception to detect
NMI unblocking for SEV-ES guests.  As above, I think we should provide helpers to
toggle NMI interception to reduce the probability of breaking SEV-ES.

> +	} else {
> +		svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
> +		svm->nmi_singlestep = true;
> +		svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
> +	}
>  }
>  
>  static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
> -- 
> 2.34.3
> 

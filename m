Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E232A6C8642
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 20:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbjCXTzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 15:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbjCXTzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 15:55:41 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBD84EC7
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:55:39 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id m12-20020a6562cc000000b0050bdfabc8e2so1044290pgv.9
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679687739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gwAMwKNYK8mvB0QRTLrq3l6TIs49tvXgKprVbt/H0pM=;
        b=d2sl3/FFKvcnXq41I2rP6U96012X/17lXLXaRpV24welFHhVHgGF4iUg+psc83Bh4z
         xWFuJQhftV9bg9gMxd/aiJrX9zzLMT3YVOapSqjPu5aCpg2DXONIVUXCiwB097uSPhjS
         O+kgbZhxRnNh0qEH6cIZN1QdXGO4hl0nn1KWX4/MfYyAHevoAsHsMaKi8EumqgXkxYp5
         rrgtrGMXSy8cKyTjrreN1qY5XMfLFWZVJlLBFZtYfliCAnHuXzrRCIpWQjNbifOOWJAw
         vR7R36m+DPOjkK6EQcGg+KvcYSTjiQcLIvAOaKbx2KJEqRia97GvI83oz+X3FpTZ5pK+
         GU2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679687739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gwAMwKNYK8mvB0QRTLrq3l6TIs49tvXgKprVbt/H0pM=;
        b=hKCf3fLxbB3yiNck85fNirBto0E+eFXVVNMhzDG+mUaxWhrrf9d+qy5pjRyUs7PRZ+
         tttAXTkk5+xiJEcgPzDTKSDJy3brPgYWA90NBwIjha/jUk/ybEqsgYs+zEsObGmMBzZ5
         61117mcwL1v72GIpHlo9VrXTYLY39qtG4RFFdFDUr9XvYKeW23Z2KJ3smdiNyd5ege5y
         IgZ7cUgeIOaBsWYsO4boc92u/yFCYedIubNHUivT9FSW1jNOv+3MwHfpVoRmkG2Cy3ZC
         hfEF1R4CiKXk3DswfRKJee89EG73fpvIgByRQipzYTlgZI1K3DiSTL0c+2RBaJQrhnyX
         SCMA==
X-Gm-Message-State: AAQBX9ex2hj/L/T3byqFJHPGFKPh+nabf2foZ+I4UbNb6GZOCNXGZOKf
        GV+K0iYc2ccl6LMPqHC7ihLSpn5iM58=
X-Google-Smtp-Source: AKy350apNVmfJIIACqmiTxH/P4JPeajcD53Kgthj47G59NwP6TNuqyKtWY4v3Wk3jkgFmz8PyWK1OhXZlG4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e88e:b0:1a1:d366:b0bd with SMTP id
 w14-20020a170902e88e00b001a1d366b0bdmr1351931plg.9.1679687739366; Fri, 24 Mar
 2023 12:55:39 -0700 (PDT)
Date:   Fri, 24 Mar 2023 12:55:37 -0700
In-Reply-To: <20230206060545.628502-3-manali.shukla@amd.com>
Mime-Version: 1.0
References: <20230206060545.628502-1-manali.shukla@amd.com> <20230206060545.628502-3-manali.shukla@amd.com>
Message-ID: <ZB4AOaLRwSB0ClIH@google.com>
Subject: Re: [RFC PATCH kernel 2/2] KVM: SEV: PreventHostIBS enablement for
 SEV-ES and SNP guest
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, jolsa@kernel.org,
        namhyung@kernel.org, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com,
        jpoimboe@kernel.org, pawan.kumar.gupta@linux.intel.com,
        babu.moger@amd.com, sandipan.das@amd.com, jmattson@google.com,
        thomas.lendacky@amd.com, nikunj@amd.com, ravi.bangoria@amd.com,
        eranian@google.com, irogers@google.com, kvm@vger.kernel.org,
        x86@kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06, 2023, Manali Shukla wrote:
> Currently, the hypervisor is able to inspect instruction based samples
> from a guest and gather execution information. SEV-ES and SNP guests
> can disallow the use of instruction based sampling by hypervisor by
> enabling the PreventHostIBS feature for the guest.  (More information
> in Section 15.36.17 APM Volume 2)
> 
> The MSR_AMD64_IBSFETCHCTL[IbsFetchEn] and MSR_AMD64_IBSOPCTL[IbsOpEn]
> bits need to be disabled before VMRUN is called when PreventHostIBS
> feature is enabled. If either of these bits are not 0, VMRUN will fail
> with VMEXIT_INVALID error code.
> 
> Because of an IBS race condition when disabling IBS, KVM needs to
> indicate when it is in a PreventHostIBS window. Activate the window
> based on whether IBS is currently active or inactive.
> 
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h |  1 +
>  arch/x86/kvm/svm/sev.c             | 10 ++++++++
>  arch/x86/kvm/svm/svm.c             | 39 ++++++++++++++++++++++++++++--
>  arch/x86/kvm/svm/svm.h             |  1 +
>  4 files changed, 49 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 61012476d66e..1812e74f846a 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -425,6 +425,7 @@
>  #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
>  #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
>  #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
> +#define X86_FEATURE_PREVENT_HOST_IBS	(19*32+15) /* "" AMD prevent host ibs */
>  
>  /*
>   * BUG word(s)
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 86d6897f4806..b348b8931721 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -569,6 +569,12 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  	if (svm->vcpu.guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_1))
>  		return -EINVAL;
>  
> +	if (sev_es_guest(svm->vcpu.kvm) &&
> +	    guest_cpuid_has(&svm->vcpu, X86_FEATURE_PREVENT_HOST_IBS)) {
> +		save->sev_features |= BIT(6);
> +		svm->prevent_hostibs_enabled = true;
> +	}
> +
>  	/*
>  	 * SEV-ES will use a VMSA that is pointed to by the VMCB, not
>  	 * the traditional VMSA that is part of the VMCB. Copy the
> @@ -2158,6 +2164,10 @@ void __init sev_set_cpu_caps(void)
>  		kvm_cpu_cap_clear(X86_FEATURE_SEV);
>  	if (!sev_es_enabled)
>  		kvm_cpu_cap_clear(X86_FEATURE_SEV_ES);
> +
> +	/* Enable PreventhostIBS feature for SEV-ES and higher guests */
> +	if (sev_es_enabled)
> +		kvm_cpu_cap_set(X86_FEATURE_PREVENT_HOST_IBS);

Uh, you can't just force a cap, there needs to be actual hardware support.  Just
copy what was done for X86_FEATURE_SEV_ES.


>  }
>  
>  void __init sev_hardware_setup(void)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9a194aa1a75a..47c1e0fff23e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3914,10 +3914,39 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
>  
>  	guest_state_enter_irqoff();
>  
> -	if (sev_es_guest(vcpu->kvm))
> +	if (sev_es_guest(vcpu->kvm)) {
> +		bool ibs_fetch_active, ibs_op_active;
> +		u64 ibs_fetch_ctl, ibs_op_ctl;
> +
> +		if (svm->prevent_hostibs_enabled) {
> +			/*
> +			 * With PreventHostIBS enabled, IBS profiling cannot
> +			 * be active when VMRUN is executed. Disable IBS before
> +			 * executing VMRUN and, because of a race condition,
> +			 * enable the PreventHostIBS window if IBS profiling was
> +			 * active.

And the race can't be fixed because...?

> +			 */
> +			ibs_fetch_active =
> +				amd_disable_ibs_fetch(&ibs_fetch_ctl);
> +			ibs_op_active =
> +				amd_disable_ibs_op(&ibs_op_ctl);
> +
> +			amd_prevent_hostibs_window(ibs_fetch_active ||
> +						   ibs_op_active);
> +		}
> +
>  		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
> -	else
> +
> +		if (svm->prevent_hostibs_enabled) {
> +			if (ibs_fetch_active)
> +				amd_restore_ibs_fetch(ibs_fetch_ctl);
> +
> +			if (ibs_op_active)
> +				amd_restore_ibs_op(ibs_op_ctl);

IIUC, this adds up to 2 RDMSRs and 4 WRMSRs to the VMRUN path.  Blech.  There's
gotta be a better way to implement this.  Like PeterZ said, this is basically
exclude_guest.

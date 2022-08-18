Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759CD598A25
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 19:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344595AbiHRRSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 13:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245130AbiHRRSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 13:18:07 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D93CD51C
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 10:15:20 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id s31-20020a17090a2f2200b001faaf9d92easo5321476pjd.3
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 10:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=AlJnMdRWI5BfRSyUR23BkFHHxdszN/7rAb7ygL3qrCk=;
        b=o+lqsJCfXfg+vynKuUuyjFpXEfqn9Y+A106ruxFvLRUwtBdTNH05yFa8A2ATCQcaye
         z4ARc5TQYJAkXospOYm7nTvEKY3XJkh2IOoo65D2ppK6Xorik9nePYebCEK3e8k7WZSv
         75qUgaovud2XubudtlzZaE2nf/Rnuj5si3HcXsgB+JjkZLyChqg4x/s2w4QNWp6SB31q
         QAz5Jwo9k2YC6HdaKQgEyTKpH/kz86Pn4FRiLgbtP/7YsuXki2xvGzfhpBTbtAhdwYPq
         fTHVMWyQrsaQTTy4vBzP6E2FW3QYTxMls+ixd3WvmMTVzfhCthYGC9XSiEI4ibaD+S+G
         jw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=AlJnMdRWI5BfRSyUR23BkFHHxdszN/7rAb7ygL3qrCk=;
        b=mBeKYDxxA2vRho0UKNaRJbF9B1KhFX8novFqTKW4DDDmLPKH03weHbiOoS4IpdoTlN
         6T75qMKkJMIoLvRcqxmv9JLTmTIqyoiZQ3vzNYjc9E6ayBNNrMiR3PzcQn+F2TU06tIb
         AFpMMWKhIYwe88rKpCDlQ8Ra1/QWgSgdmOg3p75Otn7Wl5JKdcsxj64zUg+KOL+d5H8/
         Gd8/OcX2NhnWMbNNl+HLXwF4c2sI8OcPvCEmzkduWP2JtY3kBrBklazmE5RDnXfQY/mx
         EwYhbeaxQCd+8Ofh9YW2IhB7oWzQVrq0zZfta5DAgy9VBa2zc/8TJ2t3iD94cQlyIV58
         7WkA==
X-Gm-Message-State: ACgBeo2RqVmzeYhMtasHLlmlogqhekcYDViYRaobd7tXA6RBJkzm96lZ
        1JEMShELsPy75VCuVeBp0AH2Xg==
X-Google-Smtp-Source: AA6agR6SWLeIMPfA+g5+b+GAooz6Q15ZOPcSVfSeG/41tKMIUHqFuOVplKXS1tcNL03im/i3eDbI0w==
X-Received: by 2002:a17:90a:1b65:b0:1f7:4725:aa6e with SMTP id q92-20020a17090a1b6500b001f74725aa6emr3926169pjq.179.1660842919544;
        Thu, 18 Aug 2022 10:15:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p18-20020a170902ead200b0016a6caacaefsm1632016pld.103.2022.08.18.10.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:15:16 -0700 (PDT)
Date:   Thu, 18 Aug 2022 17:15:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 09/26] KVM: VMX: nVMX: Support TSC scaling and
 PERF_GLOBAL_CTRL with enlightened VMCS
Message-ID: <Yv5zn4qTl0aiaQvh@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-10-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802160756.339464-10-vkuznets@redhat.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
> Enlightened VMCS v1 got updated and now includes the required fields
> for TSC scaling and loading PERF_GLOBAL_CTRL upon VMENTER/VMEXIT
> features. For Hyper-V on KVM enablement, KVM can just observe VMX control
> MSRs and use the features (with or without eVMCS) when
> possible. Hyper-V on KVM case is trickier because of live migration:
> the new features require explicit enablement from VMM to not break
> it. Luckily, the updated eVMCS revision comes with a feature bit in
> CPUID.0x4000000A.EBX.

The refactor to implement the 2-d array should go in a prep patch.  Unless you
(or anyone else) objects to the feedback below, I'll do the split myself, post v6,
and queue this up (without patch 1, and assuming there're no major issues in the
back half of the series).

> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c     |  2 +-
>  arch/x86/kvm/vmx/evmcs.c  | 88 +++++++++++++++++++++++++++++++--------
>  arch/x86/kvm/vmx/evmcs.h  | 17 ++------
>  arch/x86/kvm/vmx/nested.c |  2 +-
>  arch/x86/kvm/vmx/vmx.c    |  2 +-
>  5 files changed, 78 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 1098915360ae..8a2b24f9bbf6 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2552,7 +2552,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  		case HYPERV_CPUID_NESTED_FEATURES:
>  			ent->eax = evmcs_ver;
>  			ent->eax |= HV_X64_NESTED_MSR_BITMAP;
> -
> +			ent->ebx |= HV_X64_NESTED_EVMCS1_2022_UPDATE;
>  			break;
>  
>  		case HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS:
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 8bea5dea0341..e8497f9854a1 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -368,7 +368,60 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
> +enum evmcs_revision {
> +	EVMCSv1_2016,
> +	EVMCSv1_2022,
> +	EVMCS_REVISION_MAX,

"MAX" is technically wrong, the "max" entry is usually the last valid entry.  This
should be NR_EVMCS_REVISIONS, and then NR_EVMCS_CTRLS below.

> +};
> +
> +enum evmcs_unsupported_ctrl_type {

I think drop the "unsupported" here, because the naming gets weird when trying to
use it for something other than indexing evmcs_unsupported_ctls (see bottom).

> +	EVMCS_EXIT_CTLS,
> +	EVMCS_ENTRY_CTLS,

s/CTLS/CTRLS for consistency.

> +	EVMCS_2NDEXEC,
> +	EVMCS_PINCTRL,
> +	EVMCS_VMFUNC,
> +	EVMCS_CTRL_MAX,
> +};
> +
> +static u32 evmcs_unsupported_ctls[EVMCS_CTRL_MAX][EVMCS_REVISION_MAX] = {

This can be "const".  And s/ctls/ctrls for consistency.

> +	[EVMCS_EXIT_CTLS] = {
> +		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_VMEXIT_CTRL | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,
> +		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_VMEXIT_CTRL,
> +	},
> +	[EVMCS_ENTRY_CTLS] = {
> +		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_VMENTRY_CTRL | VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
> +		[EVMCSv1_2022] =  EVMCS1_UNSUPPORTED_VMENTRY_CTRL,
> +	},
> +	[EVMCS_2NDEXEC] = {
> +		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_2NDEXEC | SECONDARY_EXEC_TSC_SCALING,
> +		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_2NDEXEC,
> +	},
> +	[EVMCS_PINCTRL] = {
> +		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_PINCTRL,
> +		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_PINCTRL,
> +	},
> +	[EVMCS_VMFUNC] = {
> +		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_VMFUNC,
> +		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_VMFUNC,
> +	},
> +};
> +
> +static u32 evmcs_get_unsupported_ctls(struct kvm_vcpu *vcpu,
> +				      enum evmcs_unsupported_ctrl_type ctrl_type)
> +{
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +	enum evmcs_revision evmcs_rev = EVMCSv1_2016;
> +
> +	if (!hv_vcpu)

This is a functiontal change, and I don't think it's correct either.  Previously,
KVM would apply the EVMCSv1_2016 filter irrespective of whether or not
vcpu->arch.hyperv is non-NULL.  nested_enable_evmcs() doesn't require a Hyper-V
vCPU, and AFAICT nothing requires a Hyper-V vCPU to use eVMCS.

So I believe this should be:

	if (hv_vcpu &&
	    hv_vcpu->cpuid_cache.nested_ebx & HV_X64_NESTED_EVMCS1_2022_UPDATE)
		evmcs_rev = EVMCSv1_2022;

> +		return 0;
> +
> +	if (hv_vcpu->cpuid_cache.nested_ebx & HV_X64_NESTED_EVMCS1_2022_UPDATE)
> +		evmcs_rev = EVMCSv1_2022;
> +
> +	return evmcs_unsupported_ctls[ctrl_type][evmcs_rev];
> +}
> +

...

> -int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
> +int nested_evmcs_check_controls(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  {
>  	int ret = 0;
>  	u32 unsupp_ctl;
>  
>  	unsupp_ctl = vmcs12->pin_based_vm_exec_control &
> -		EVMCS1_UNSUPPORTED_PINCTRL;
> +		evmcs_get_unsupported_ctls(vcpu, EVMCS_PINCTRL);
>  	if (unsupp_ctl) {
>  		trace_kvm_nested_vmenter_failed(
> -			"eVMCS: unsupported pin-based VM-execution controls",
> +			"eVMCS: unsupported pin-based VM-execution controls: ",
>  			unsupp_ctl);

Egad!  This is all broken, at least in theory.  The second param to
trace_kvm_nested_vmenter_failed() is the error code, not the bad value.  It mostly
works because __print_symbolic() falls back to printing the hex value on error,
but that relies on there being no collisions/matches between unsupp_ctl and the
set of VMX_VMENTER_INSTRUCTION_ERRORS.  E.g. if there's a collision then the
tracepoint will pretty print a string and cause confusion.

And checking every control even after one fails seems unnecessary subtle.  It
provides marginal benefit while increasing the probability that we screw up and
squash "ret" to zero.  Yeah, it might save some onion peeling, but if that happens
during production and now during initial development of a feature, then someone
has much bigger problems to worry about.

Unless there are objections, I'll fold in a patch to yield:

#define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK

static bool nested_evmcs_is_valid_controls(enum evmcs_ctrl_type type, u32 val)
{
	return val & evmcs_get_unsupported_ctls(type);
}

int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
{
	if (CC(!nested_evmcs_is_valid_controls(EVMCS_PINCTRL,
					       vmcs12->pin_based_vm_exec_control)))
		return -EINVAL;

	if (CC(!nested_evmcs_is_valid_controls(EVMCS_2NDEXEC,
					       vmcs12->secondary_vm_exec_control)))
		return -EINVAL;

	if (CC(!nested_evmcs_is_valid_controls(EVMCS_EXIT_CTRLS,
					       vmcs12->vm_exit_controls)))
		return -EINVAL;

	if (CC(!nested_evmcs_is_valid_controls(EVMCS_ENTRY_CTRLS,
					       vmcs12->vm_entry_controls)))
		return -EINVAL;

	if (CC(!nested_evmcs_is_valid_controls(EVMCS_VMFUNC,
					       vmcs12->vm_function_control)))
		return -EINVAL;

	return 0;
}

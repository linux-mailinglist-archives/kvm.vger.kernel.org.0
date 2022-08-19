Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992805996E0
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 10:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347367AbiHSIHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 04:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347338AbiHSIG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 04:06:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5EEE42EA
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 01:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660896417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ViBdorV9HHdkaicf8ipSaMCTXuZ8iW7SXUz2nBhSHsk=;
        b=FLsWw1NEzKDw9s/gbHWKAcFuIJ+1keMTOuEiTciOMlFO+QE0uWqC5PPnca+oG6bf/pwd8O
        cLguEm1edHQr6g0POvPHJbsi9w5Shhisg4nalttIAzzIqbc5ghcRrf9X60zEOgximSkGHB
        nHTkq2fBvGZf/MYpl4V0gax6lONnfFs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-297-R40zFWILNGGWLDnwboh2zw-1; Fri, 19 Aug 2022 04:06:55 -0400
X-MC-Unique: R40zFWILNGGWLDnwboh2zw-1
Received: by mail-ed1-f70.google.com with SMTP id q32-20020a05640224a000b004462f105fa9so1314277eda.4
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 01:06:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=ViBdorV9HHdkaicf8ipSaMCTXuZ8iW7SXUz2nBhSHsk=;
        b=Glh+8UuSIKX2qMQ+uxoe7mFw2g1TY0CvYJ62PyD/ciOhHHwAmL6sREyfwpmVrzai6s
         CtXAX1IQfW4NV8XyihTEbUK/JaXco94vB/vvYtCZLvBIZLX5ChWZvRxCzQjL1bbPUzoe
         Ml+w4/7N2iWfDs4Hsa9voA9tVcQajQPnhioBbkpXNqc7GU+0hrnVx/R2FXaqIqIXPAh3
         ZpBr4q/AavK1O3iA470gEfbNneihuitohrUKOapgGk3tE1TNyN5QsXtIDy1JGCLp3Bw2
         9OeKN5I+FkzyJZqHyXR/0ZfExmgmfwbOsXvXSu5AzaqGGMUhRIzFq8KUYQ+GWHbLcJL+
         qtSw==
X-Gm-Message-State: ACgBeo3YixQMI3fmVk3LG4VUa0Tjkze14Xl954JdMgqfjMIHHUUmnpol
        HhSwO2j0HMMB2HPemH4ahFDnQrTCb4UnWChJg3y9wPMYt4Q8kv3Y0lOD1Sz07eABboYHzCM9Fig
        571JTMGl0QJho
X-Received: by 2002:a05:6402:280f:b0:43d:f946:a895 with SMTP id h15-20020a056402280f00b0043df946a895mr5333947ede.229.1660896414688;
        Fri, 19 Aug 2022 01:06:54 -0700 (PDT)
X-Google-Smtp-Source: AA6agR66HslBjqXKMQNjZGcLezcYfvoiIaBEzB14b1r1qYBlm4B5HmhbpmbIZA381cwsCHOjbk563A==
X-Received: by 2002:a05:6402:280f:b0:43d:f946:a895 with SMTP id h15-20020a056402280f00b0043df946a895mr5333931ede.229.1660896414459;
        Fri, 19 Aug 2022 01:06:54 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id d7-20020a170906304700b00715a02874acsm1966120ejd.35.2022.08.19.01.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 01:06:53 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
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
In-Reply-To: <Yv5zn4qTl0aiaQvh@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-10-vkuznets@redhat.com>
 <Yv5zn4qTl0aiaQvh@google.com>
Date:   Fri, 19 Aug 2022 10:06:53 +0200
Message-ID: <87sflssllu.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
>> Enlightened VMCS v1 got updated and now includes the required fields
>> for TSC scaling and loading PERF_GLOBAL_CTRL upon VMENTER/VMEXIT
>> features. For Hyper-V on KVM enablement, KVM can just observe VMX control
>> MSRs and use the features (with or without eVMCS) when
>> possible. Hyper-V on KVM case is trickier because of live migration:
>> the new features require explicit enablement from VMM to not break
>> it. Luckily, the updated eVMCS revision comes with a feature bit in
>> CPUID.0x4000000A.EBX.
>
> The refactor to implement the 2-d array should go in a prep patch.  Unless you
> (or anyone else) objects to the feedback below, I'll do the split myself, post v6,
> and queue this up (without patch 1, and assuming there're no major issues in the
> back half of the series).

No objections from me, thanks!

>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/hyperv.c     |  2 +-
>>  arch/x86/kvm/vmx/evmcs.c  | 88 +++++++++++++++++++++++++++++++--------
>>  arch/x86/kvm/vmx/evmcs.h  | 17 ++------
>>  arch/x86/kvm/vmx/nested.c |  2 +-
>>  arch/x86/kvm/vmx/vmx.c    |  2 +-
>>  5 files changed, 78 insertions(+), 33 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index 1098915360ae..8a2b24f9bbf6 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -2552,7 +2552,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>>  		case HYPERV_CPUID_NESTED_FEATURES:
>>  			ent->eax = evmcs_ver;
>>  			ent->eax |= HV_X64_NESTED_MSR_BITMAP;
>> -
>> +			ent->ebx |= HV_X64_NESTED_EVMCS1_2022_UPDATE;
>>  			break;
>>  
>>  		case HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS:
>> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
>> index 8bea5dea0341..e8497f9854a1 100644
>> --- a/arch/x86/kvm/vmx/evmcs.c
>> +++ b/arch/x86/kvm/vmx/evmcs.c
>> @@ -368,7 +368,60 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
>>  	return 0;
>>  }
>>  
>> -void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
>> +enum evmcs_revision {
>> +	EVMCSv1_2016,
>> +	EVMCSv1_2022,
>> +	EVMCS_REVISION_MAX,
>
> "MAX" is technically wrong, the "max" entry is usually the last valid entry.  This
> should be NR_EVMCS_REVISIONS, and then NR_EVMCS_CTRLS below.
>
>> +};
>> +
>> +enum evmcs_unsupported_ctrl_type {
>
> I think drop the "unsupported" here, because the naming gets weird when trying to
> use it for something other than indexing evmcs_unsupported_ctls (see bottom).
>
>> +	EVMCS_EXIT_CTLS,
>> +	EVMCS_ENTRY_CTLS,
>
> s/CTLS/CTRLS for consistency.
>
>> +	EVMCS_2NDEXEC,
>> +	EVMCS_PINCTRL,
>> +	EVMCS_VMFUNC,
>> +	EVMCS_CTRL_MAX,
>> +};
>> +
>> +static u32 evmcs_unsupported_ctls[EVMCS_CTRL_MAX][EVMCS_REVISION_MAX] = {
>
> This can be "const".  And s/ctls/ctrls for consistency.
>
>> +	[EVMCS_EXIT_CTLS] = {
>> +		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_VMEXIT_CTRL | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,
>> +		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_VMEXIT_CTRL,
>> +	},
>> +	[EVMCS_ENTRY_CTLS] = {
>> +		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_VMENTRY_CTRL | VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
>> +		[EVMCSv1_2022] =  EVMCS1_UNSUPPORTED_VMENTRY_CTRL,
>> +	},
>> +	[EVMCS_2NDEXEC] = {
>> +		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_2NDEXEC | SECONDARY_EXEC_TSC_SCALING,
>> +		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_2NDEXEC,
>> +	},
>> +	[EVMCS_PINCTRL] = {
>> +		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_PINCTRL,
>> +		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_PINCTRL,
>> +	},
>> +	[EVMCS_VMFUNC] = {
>> +		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_VMFUNC,
>> +		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_VMFUNC,
>> +	},
>> +};
>> +
>> +static u32 evmcs_get_unsupported_ctls(struct kvm_vcpu *vcpu,
>> +				      enum evmcs_unsupported_ctrl_type ctrl_type)
>> +{
>> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>> +	enum evmcs_revision evmcs_rev = EVMCSv1_2016;
>> +
>> +	if (!hv_vcpu)
>
> This is a functiontal change, and I don't think it's correct either.  Previously,
> KVM would apply the EVMCSv1_2016 filter irrespective of whether or not
> vcpu->arch.hyperv is non-NULL.  nested_enable_evmcs() doesn't require a Hyper-V
> vCPU, and AFAICT nothing requires a Hyper-V vCPU to use eVMCS.

Indeed, this *is* correct after PATCH11 when we get rid of VMX feature
MSR filtering for KVM-on-Hyper-V as the remaining use for
evmcs_get_unsupported_ctls() is Hyper-V on KVM and hv_vcpu is not NULL
there. As of this patch, this is incorrect as we're breaking e.g. Linux
guests on KVM on Hyper-V.

>
> So I believe this should be:
>
> 	if (hv_vcpu &&
> 	    hv_vcpu->cpuid_cache.nested_ebx & HV_X64_NESTED_EVMCS1_2022_UPDATE)
> 		evmcs_rev = EVMCSv1_2022;

This looks good to me, thanks!

>
>> +		return 0;
>> +
>> +	if (hv_vcpu->cpuid_cache.nested_ebx & HV_X64_NESTED_EVMCS1_2022_UPDATE)
>> +		evmcs_rev = EVMCSv1_2022;
>> +
>> +	return evmcs_unsupported_ctls[ctrl_type][evmcs_rev];
>> +}
>> +
>
> ...
>
>> -int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
>> +int nested_evmcs_check_controls(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>>  {
>>  	int ret = 0;
>>  	u32 unsupp_ctl;
>>  
>>  	unsupp_ctl = vmcs12->pin_based_vm_exec_control &
>> -		EVMCS1_UNSUPPORTED_PINCTRL;
>> +		evmcs_get_unsupported_ctls(vcpu, EVMCS_PINCTRL);
>>  	if (unsupp_ctl) {
>>  		trace_kvm_nested_vmenter_failed(
>> -			"eVMCS: unsupported pin-based VM-execution controls",
>> +			"eVMCS: unsupported pin-based VM-execution controls: ",
>>  			unsupp_ctl);
>
> Egad!  This is all broken, at least in theory.  The second param to
> trace_kvm_nested_vmenter_failed() is the error code, not the bad value.  It mostly
> works because __print_symbolic() falls back to printing the hex value on error,
> but that relies on there being no collisions/matches between unsupp_ctl and the
> set of VMX_VMENTER_INSTRUCTION_ERRORS.  E.g. if there's a collision then the
> tracepoint will pretty print a string and cause confusion.
>
> And checking every control even after one fails seems unnecessary subtle.  It
> provides marginal benefit while increasing the probability that we screw up and
> squash "ret" to zero.  Yeah, it might save some onion peeling, but if that happens
> during production and now during initial development of a feature, then someone
> has much bigger problems to worry about.
>
> Unless there are objections, I'll fold in a patch to yield:
>
> #define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
>
> static bool nested_evmcs_is_valid_controls(enum evmcs_ctrl_type type, u32 val)
> {
> 	return val & evmcs_get_unsupported_ctls(type);
> }
>
> int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
> {
> 	if (CC(!nested_evmcs_is_valid_controls(EVMCS_PINCTRL,
> 					       vmcs12->pin_based_vm_exec_control)))
> 		return -EINVAL;
>
> 	if (CC(!nested_evmcs_is_valid_controls(EVMCS_2NDEXEC,
> 					       vmcs12->secondary_vm_exec_control)))
> 		return -EINVAL;
>
> 	if (CC(!nested_evmcs_is_valid_controls(EVMCS_EXIT_CTRLS,
> 					       vmcs12->vm_exit_controls)))
> 		return -EINVAL;
>
> 	if (CC(!nested_evmcs_is_valid_controls(EVMCS_ENTRY_CTRLS,
> 					       vmcs12->vm_entry_controls)))
> 		return -EINVAL;
>
> 	if (CC(!nested_evmcs_is_valid_controls(EVMCS_VMFUNC,
> 					       vmcs12->vm_function_control)))
> 		return -EINVAL;
>
> 	return 0;
> }


Well, it's actually nice to see all the controls where KVM screwed up
without the need to instrument kernel, this way when someone comes with
an issue you can immediately see what's wrong in the trace
log. Honestly, I don't remember these firing outside of my development
environment, your patch to make things correct looks good to me.

-- 
Vitaly


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54235A0DD8
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 12:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240583AbiHYKYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 06:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240803AbiHYKYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 06:24:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45985ABF1E
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 03:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661423072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G4cy4jtZkb0ms88nzoSMcie/Qhn5cYMVuSiBB4TMzZE=;
        b=Py/8y7rxolzpkf7TUrtjy8nv8jGsWsY+3Zek5ZNdV02m67J3dbHbUHiogLwdtuPLwnf0g/
        DZuUcgFwgGZ4mg/xI1GiWMpugWA5uCSg9MQOMC+ZJgMkUSMv8Lam5mktoYq1QHTvcltAn5
        HXqd3rhMgcWTudx9Z0xBjeJFfHf5YJI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-235-qsuFUnsqO2Kjr_bjIwN4YQ-1; Thu, 25 Aug 2022 06:24:30 -0400
X-MC-Unique: qsuFUnsqO2Kjr_bjIwN4YQ-1
Received: by mail-ej1-f70.google.com with SMTP id ne1-20020a1709077b8100b0073d957e2869so3244970ejc.1
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 03:24:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=G4cy4jtZkb0ms88nzoSMcie/Qhn5cYMVuSiBB4TMzZE=;
        b=KPoehpFR2mUNqi4MmXHSC6V1wNjSkkchkh8QTqbX9ht4VZpuJWSt2aGLuxYvR5MFV4
         GLeFaZw0pkau1egGLEFOZYEaO8gUieJMO7UN0DTt/HZ2q+Mwlf7UwmERIqIqbjVmW6tJ
         xmQaBqnRY8jyNyEmyZA7TaOacYoqsfJsCXO/GP6MlTFAKGwh2nxCaginggoRvjQ0aU+T
         aXs+W6DMK4dN2zofmNfi5yydpwPpmbretmi91aNHX+NWHqNDprMpohjL0VBovaR2ZGYs
         k3Kya+Q5MAwS2Yx5h6IW6rQEDqmg8KYYVN/rQllGrj3Sd4UaRY70u+ANm9c3cswWQpsk
         a25w==
X-Gm-Message-State: ACgBeo0kg4kxSmqcgy1KhhHu079wVOhfnfCtNf9FDENEYmi+sRP3Jx+6
        pPMLxJAidwBZpeJCqoc29Zkp7RGmJwSz9WhWYJhGhf9xOoy6d9JemKwC+mbjNDY9It8rxoI3icZ
        Qh0nLuhnSDLGiIuZP9iJT6OTzT1EkacMQFiAfz7jOlUpv9/BAVyrcGKiU+X9xY58H
X-Received: by 2002:a05:6402:5108:b0:447:592:7ba5 with SMTP id m8-20020a056402510800b0044705927ba5mr2624230edd.156.1661423069385;
        Thu, 25 Aug 2022 03:24:29 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5KjzggwQOB2bjFxd+yXUqLLzNijvr1hrBexhcZozfHTWHuCDmdRojwSl2GaTIa8ZRFBsrI4w==
X-Received: by 2002:a05:6402:5108:b0:447:592:7ba5 with SMTP id m8-20020a056402510800b0044705927ba5mr2624210edd.156.1661423069059;
        Thu, 25 Aug 2022 03:24:29 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x24-20020aa7cd98000000b0044792480994sm1969451edv.68.2022.08.25.03.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 03:24:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [RFC PATCH v6 07/36] KVM: nVMX: Refactor unsupported eVMCS
 controls logic to use 2-d array
In-Reply-To: <20220824030138.3524159-8-seanjc@google.com>
References: <20220824030138.3524159-1-seanjc@google.com>
 <20220824030138.3524159-8-seanjc@google.com>
Date:   Thu, 25 Aug 2022 12:24:27 +0200
Message-ID: <87o7w8wrhg.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> From: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> Refactor the handling of unsupported eVMCS to use a 2-d array to store
> the set of unsupported controls.  KVM's handling of eVMCS is completely
> broken as there is no way for userspace to query which features are
> unsupported, nor does KVM prevent userspace from attempting to enable
> unsupported features.  A future commit will remedy that by filtering and
> enforcing unsupported features when eVMCS, but that needs to be opt-in
> from userspace to avoid breakage, i.e. KVM needs to maintain its legacy
> behavior by snapshotting the exact set of controls that are currently
> (un)supported by eVMCS.
>
> No functional change intended.
>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> [sean: split to standalone patch, write changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/evmcs.c | 60 +++++++++++++++++++++++++++++++++-------
>  1 file changed, 50 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 9139c70b6008..10fc0be49f96 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -345,6 +345,45 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +enum evmcs_revision {
> +	EVMCSv1_LEGACY,
> +	NR_EVMCS_REVISIONS,
> +};
> +
> +enum evmcs_ctrl_type {
> +	EVMCS_EXIT_CTRLS,
> +	EVMCS_ENTRY_CTRLS,
> +	EVMCS_2NDEXEC,
> +	EVMCS_PINCTRL,
> +	EVMCS_VMFUNC,
> +	NR_EVMCS_CTRLS,
> +};
> +
> +static const u32 evmcs_unsupported_ctrls[NR_EVMCS_CTRLS][NR_EVMCS_REVISIONS] = {
> +	[EVMCS_EXIT_CTRLS] = {
> +		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_VMEXIT_CTRL | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,
> +	},
> +	[EVMCS_ENTRY_CTRLS] = {
> +		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_VMENTRY_CTRL | VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
> +	},
> +	[EVMCS_2NDEXEC] = {
> +		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_2NDEXEC | SECONDARY_EXEC_TSC_SCALING,

By the time of this patch, VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,
VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL, SECONDARY_EXEC_TSC_SCALING are
still in 'EVMCS1_UNSUPPORTED_*' lists.

> +	},
> +	[EVMCS_PINCTRL] = {
> +		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_PINCTRL,
> +	},
> +	[EVMCS_VMFUNC] = {
> +		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_VMFUNC,
> +	},
> +};
> +
> +static u32 evmcs_get_unsupported_ctls(enum evmcs_ctrl_type ctrl_type)
> +{
> +	enum evmcs_revision evmcs_rev = EVMCSv1_LEGACY;
> +
> +	return evmcs_unsupported_ctrls[ctrl_type][evmcs_rev];
> +}
> +
>  void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
>  {
>  	u32 ctl_low = (u32)*pdata;
> @@ -357,21 +396,21 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
>  	switch (msr_index) {
>  	case MSR_IA32_VMX_EXIT_CTLS:
>  	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
> -		ctl_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
> +		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_EXIT_CTRLS);
>  		break;
>  	case MSR_IA32_VMX_ENTRY_CTLS:
>  	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
> -		ctl_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
> +		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_ENTRY_CTRLS);
>  		break;
>  	case MSR_IA32_VMX_PROCBASED_CTLS2:
> -		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
> +		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_2NDEXEC);
>  		break;
>  	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
>  	case MSR_IA32_VMX_PINBASED_CTLS:
> -		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
> +		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_PINCTRL);
>  		break;
>  	case MSR_IA32_VMX_VMFUNC:
> -		ctl_low &= ~EVMCS1_UNSUPPORTED_VMFUNC;
> +		ctl_low &= ~evmcs_get_unsupported_ctls(EVMCS_VMFUNC);
>  		break;
>  	}
>  
> @@ -384,7 +423,7 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
>  	u32 unsupp_ctl;
>  
>  	unsupp_ctl = vmcs12->pin_based_vm_exec_control &
> -		EVMCS1_UNSUPPORTED_PINCTRL;
> +		evmcs_get_unsupported_ctls(EVMCS_PINCTRL);
>  	if (unsupp_ctl) {
>  		trace_kvm_nested_vmenter_failed(
>  			"eVMCS: unsupported pin-based VM-execution controls",
> @@ -393,7 +432,7 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
>  	}
>  
>  	unsupp_ctl = vmcs12->secondary_vm_exec_control &
> -		EVMCS1_UNSUPPORTED_2NDEXEC;
> +		evmcs_get_unsupported_ctls(EVMCS_2NDEXEC);
>  	if (unsupp_ctl) {
>  		trace_kvm_nested_vmenter_failed(
>  			"eVMCS: unsupported secondary VM-execution controls",
> @@ -402,7 +441,7 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
>  	}
>  
>  	unsupp_ctl = vmcs12->vm_exit_controls &
> -		EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
> +		evmcs_get_unsupported_ctls(EVMCS_EXIT_CTRLS);
>  	if (unsupp_ctl) {
>  		trace_kvm_nested_vmenter_failed(
>  			"eVMCS: unsupported VM-exit controls",
> @@ -411,7 +450,7 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
>  	}
>  
>  	unsupp_ctl = vmcs12->vm_entry_controls &
> -		EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
> +		evmcs_get_unsupported_ctls(EVMCS_ENTRY_CTRLS);
>  	if (unsupp_ctl) {
>  		trace_kvm_nested_vmenter_failed(
>  			"eVMCS: unsupported VM-entry controls",
> @@ -419,7 +458,8 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
>  		ret = -EINVAL;
>  	}
>  
> -	unsupp_ctl = vmcs12->vm_function_control & EVMCS1_UNSUPPORTED_VMFUNC;
> +	unsupp_ctl = vmcs12->vm_function_control &
> +		evmcs_get_unsupported_ctls(EVMCS_VMFUNC);
>  	if (unsupp_ctl) {
>  		trace_kvm_nested_vmenter_failed(
>  			"eVMCS: unsupported VM-function controls",

-- 
Vitaly


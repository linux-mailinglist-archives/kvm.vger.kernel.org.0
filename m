Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BA957D661
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 23:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbiGUV7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 17:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbiGUV7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 17:59:04 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB5193C38
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:59:03 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id z3so3069216plb.1
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LR0b4Qmg7kFuIY0NZ5e4svjYAGOAs6o4oip5NbZ+xbY=;
        b=VvjxnbQ6I6nWNe1l9PLuhN/Q79sF57n2duMsDL0uyiVLtGUsXBr6HVZggvJEZWgO+Q
         UvuuOyekg7DeXfdQmav8YMiaEJU1GWHcrQaWTdNuUh9w9pj6H8GEnxhDWRKHnoKgff9R
         lG8x/DCp4X+LL/yJ7kXnyv5ugJ1m/TGTsh9stp+0fgM7G/3FzULcIGFQ1LdJ9F0cYXjv
         QI35bL7fkfDMdh/tq03VdZLslCFe1BISnF1Rrf0wt3jqhKQFwo0yV++MRImsiNMFl8lI
         vAnYObU0+WGQmbmjB4XZZU1m+a6tR4a8GpBGHgmpPRqYXNJmcnpn6SXJqN8j/COPstrk
         RAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LR0b4Qmg7kFuIY0NZ5e4svjYAGOAs6o4oip5NbZ+xbY=;
        b=exQxdghwbUGPLYw6oM4Xl/ujE3l7pqjZLzZew56pl+3eVpSVKQHE3NuhEdT0VO1kIb
         +fDD3cjRxfyDNhdVwNhiomQ15iMsAXI72qYaLYOHpdsKdrTHebR2ZPN6P/OeUf4Eg8Cc
         g7MubAs+mtH9FxU+Eqt61kDSUE4pDeZMCqoKl2zXrn+eEjVdB+q5QirGthF4EZN1tnfo
         wJxF6drwL0HZAB2C2ntVpk7O1uW57h1AWBrua7A1V4NmD0GcJvHiZTtaCA7Gwt02aXGu
         uGbKMH03ZfRQvn3auHqZ3r2TPZkYdUJj4gHdKmJwfDODXZ6Q2alvbK60zRE79P83hYig
         mQPw==
X-Gm-Message-State: AJIora/9pA9APl/InyjcZcWoe+jTvdhR+snkIOC4I5fUojhUZAY0c0az
        5cpO+R4yKPSHwsd4VOJ3xYFxmA==
X-Google-Smtp-Source: AGRyM1txzQvw5nlLLhAZBbspwLFdj2AjQdk/wVrmCaP5yLNxHA2DqoRexLUiA3aDxzPfeHCheEypcg==
X-Received: by 2002:a17:90b:1a8b:b0:1f0:817:3afc with SMTP id ng11-20020a17090b1a8b00b001f008173afcmr13744261pjb.213.1658440742632;
        Thu, 21 Jul 2022 14:59:02 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id cp1-20020a170902e78100b0016d2540c098sm2181404plb.231.2022.07.21.14.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 14:59:02 -0700 (PDT)
Date:   Thu, 21 Jul 2022 21:58:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/25] KVM: VMX: nVMX: Support TSC scaling and
 PERF_GLOBAL_CTRL with enlightened VMCS
Message-ID: <YtnMIkFI469Ub9vB@google.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-10-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714091327.1085353-10-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit of all nits, just "KVM: nVMX:" in the shortlog.

On Thu, Jul 14, 2022, Vitaly Kuznetsov wrote:
> Enlightened VMCS v1 got updated and now includes the required fields
> for TSC scaling and loading PERF_GLOBAL_CTRL upon VMENTER/VMEXIT
> features. For Hyper-V on KVM enablement, KVM can just observe VMX control
> MSRs and use the features (with or without eVMCS) when
> possible. Hyper-V on KVM case is trickier because of live migration:
> the new features require explicit enablement from VMM to not break
> it. Luckily, the updated eVMCS revision comes with a feature bit in
> CPUID.0x4000000A.EBX.

Mostly out of curiosity, what happens if the VMM parrots back the results of
kvm_get_hv_cpuid()?

> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
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
> index a8e4944ca110..995d3ab1443e 100644
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
> index 8bea5dea0341..52a53debd806 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -368,7 +368,60 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
> +enum evmcs_v1_revision {
> +	EVMCSv1_2016,
> +	EVMCSv1_2022,
> +};

Why bother with the enums?  They don't make life any easier, e.g. if there's a
2023 update then it's easy to do:

		unsupported = <baseline>;
		if (!has_evmcs_2022_features)
			unsupported |= <2022 features>;
		if (!has_evmcs_2023_features)
			unsupported |= <2023 features>;
		return unsupported;

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index b5cfbf7d487b..7b348a03e096 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -355,11 +355,6 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
        return 0;
 }

-enum evmcs_v1_revision {
-       EVMCSv1_2016,
-       EVMCSv1_2022,
-};
-
 enum evmcs_unsupported_ctrl_type {
        EVMCS_EXIT_CTLS,
        EVMCS_ENTRY_CTLS,
@@ -372,29 +367,29 @@ static u32 evmcs_get_unsupported_ctls(struct kvm_vcpu *vcpu,
                                      enum evmcs_unsupported_ctrl_type ctrl_type)
 {
        struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
-       enum evmcs_v1_revision evmcs_rev = EVMCSv1_2016;
+       bool has_evmcs_2022_features;

        if (!hv_vcpu)
                return 0;

-       if (hv_vcpu->cpuid_cache.nested_ebx & HV_X64_NESTED_EVMCS1_2022_UPDATE)
-               evmcs_rev = EVMCSv1_2022;
+       has_evmcs_2022_features = hv_vcpu->cpuid_cache.nested_ebx &
+                                 HV_X64_NESTED_EVMCS1_2022_UPDATE;

        switch (ctrl_type) {
        case EVMCS_EXIT_CTLS:
-               if (evmcs_rev == EVMCSv1_2016)
+               if (!has_evmcs_2022_features)
                        return EVMCS1_UNSUPPORTED_VMEXIT_CTRL |
                                VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
                else
                        return EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
        case EVMCS_ENTRY_CTLS:
-               if (evmcs_rev == EVMCSv1_2016)
+               if (!has_evmcs_2022_features)
                        return EVMCS1_UNSUPPORTED_VMENTRY_CTRL |
                                VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
                else
                        return EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
        case EVMCS_2NDEXEC:
-               if (evmcs_rev == EVMCSv1_2016)
+               if (!has_evmcs_2022_features)
                        return EVMCS1_UNSUPPORTED_2NDEXEC |
                                SECONDARY_EXEC_TSC_SCALING;
                else

> +
> +enum evmcs_unsupported_ctrl_type {
> +	EVMCS_EXIT_CTLS,
> +	EVMCS_ENTRY_CTLS,
> +	EVMCS_2NDEXEC,
> +	EVMCS_PINCTRL,
> +	EVMCS_VMFUNC,
> +};

Same question here, it just makes life more difficult.  I.e. do

  static u32 evmcs_get_unsupported_ctls(struct kvm_vcpu *vcpu, int msr_index)

and then

  void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
  {
	u32 ctl_low = (u32)*pdata;
	u32 ctl_high = (u32)(*pdata >> 32);

	/*
	 * Hyper-V 2016 and 2019 try using unsupported features when eVMCS is
	 * enabled but there are no corresponding fields.
	 */
	ctl_high &= ~evmcs_get_unsupported_ctls(vcpu, msr_index);

	*pdata = ctl_low | ((u64)ctl_high << 32);
  }


  int nested_evmcs_check_controls(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
  {
	int ret = 0;
	u32 unsupp_ctl;

	unsupp_ctl = vmcs12->pin_based_vm_exec_control &
		evmcs_get_unsupported_ctls(vcpu, MSR_IA32_VMX_TRUE_PINBASED_CTLS);

	<and so on and so forth>
  }

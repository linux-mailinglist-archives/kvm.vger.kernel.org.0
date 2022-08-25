Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA3C5A0DCE
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 12:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240685AbiHYKVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 06:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238031AbiHYKVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 06:21:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499D09925E
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 03:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661422869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4zT0TyILO7qNzAE30zZrA1MIcTyMwwFaamJHjGvYj8c=;
        b=KbQRj03QDbi2IZaqbFeNSZh/Sh5C1S/g5FhmRaFNoQNhbrnOG86qZY/Ljs1SXwxS1JeHvq
        UVEuir+gqyHUUFoJWXbj+DMPPmP5VnNpD4CQ+y5oSrU7sIBnKSlFw1ojS05KnyPGf1i2hY
        F74IW9Bxzycu2oTBfA8A7SWrWSHvT2A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-675-riUiAtX_MhCxulySzRnwDw-1; Thu, 25 Aug 2022 06:21:08 -0400
X-MC-Unique: riUiAtX_MhCxulySzRnwDw-1
Received: by mail-ed1-f70.google.com with SMTP id z6-20020a05640240c600b0043e1d52fd98so12827640edb.22
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 03:21:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=4zT0TyILO7qNzAE30zZrA1MIcTyMwwFaamJHjGvYj8c=;
        b=zTwXu4LB6uDVYetfIum8w7SkLrfkzu9LkoVVm+acScn1hRSfZwD6fb0+GoqcMCGEYD
         O/BljuARA0Y3Bfe9h9WKPO57AywqbQne2q5S/nx2pHIq+H7dyOmJrdDSFq24oMvF4zkb
         0nDO2spukYqlHj6PuESe3QTkHy322raDbD4692vieQnYsW9KW1chJqbfmc3fCGfeX3nW
         M80S5mzMMKhWLp4uWzzMYNziXomYNTwxQt1L7/ZzFnWqTAo0TmTTUW5K96zU7hWTnTmc
         lVSpYzAedY5i0iAKj+kwUVCYnKfcMxWySAn8uEqv9CaWhw660veGUZFdiX43eE1x13d8
         XTBg==
X-Gm-Message-State: ACgBeo2TkYDgwT18Vhnf6CRMJ87RKlpbL3XmNoh6EORKR3juK3ohZM/1
        bkg6Hy35sE1Wiv8j42LX+F0pgeElzI698LCmIlrsEX2hdUqFxnf7Dd3bYjixMgtOVoIgvOHGsJE
        Hi+YjcO1aBSzpuxlDyF0bAax2qHPN6F2hrljQsr5ZbLvrHPqA4CePITJ3lpgVWre7
X-Received: by 2002:a17:906:6a1d:b0:73d:8bb4:94aa with SMTP id qw29-20020a1709066a1d00b0073d8bb494aamr1958616ejc.249.1661422867196;
        Thu, 25 Aug 2022 03:21:07 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6y8Fm1PTGA0gd0z97YGJdjFHVtUT2sEFHYqKUCiTW/HYeuyVLhC6NftLJ+5lxDwsylb/loVA==
X-Received: by 2002:a17:906:6a1d:b0:73d:8bb4:94aa with SMTP id qw29-20020a1709066a1d00b0073d8bb494aamr1958598ejc.249.1661422866855;
        Thu, 25 Aug 2022 03:21:06 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k1-20020a17090632c100b0073cf8e0355fsm2203197ejk.208.2022.08.25.03.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 03:21:06 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [RFC PATCH v6 06/36] KVM: nVMX: Treat eVMCS as enabled for
 guest iff Hyper-V is also enabled
In-Reply-To: <20220824030138.3524159-7-seanjc@google.com>
References: <20220824030138.3524159-1-seanjc@google.com>
 <20220824030138.3524159-7-seanjc@google.com>
Date:   Thu, 25 Aug 2022 12:21:05 +0200
Message-ID: <87r114wrn2.fsf@redhat.com>
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

> When querying whether or not eVMCS is enabled on behalf of the guest,
> treat eVMCS as enable if and only if Hyper-V is enabled/exposed to the
> guest.
>
> Note, flows that come from the host, e.g. KVM_SET_NESTED_STATE, must NOT
> check for Hyper-V being enabled as KVM doesn't require guest CPUID to be
> set before most ioctls().
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/evmcs.c  |  3 +++
>  arch/x86/kvm/vmx/nested.c |  8 ++++----
>  arch/x86/kvm/vmx/vmx.c    |  3 +--
>  arch/x86/kvm/vmx/vmx.h    | 10 ++++++++++
>  4 files changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 6a61b1ae7942..9139c70b6008 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -334,6 +334,9 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
>  	 * versions: lower 8 bits is the minimal version, higher 8 bits is the
>  	 * maximum supported version. KVM supports versions from 1 to
>  	 * KVM_EVMCS_VERSION.
> +	 *
> +	 * Note, do not check the Hyper-V is fully enabled in guest CPUID, this
> +	 * helper is used to _get_ the vCPU's supported CPUID.
>  	 */
>  	if (kvm_cpu_cap_get(X86_FEATURE_VMX) &&
>  	    (!vcpu || to_vmx(vcpu)->nested.enlightened_vmcs_enabled))
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ddd4367d4826..28f9d64851b3 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1982,7 +1982,7 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
>  	bool evmcs_gpa_changed = false;
>  	u64 evmcs_gpa;
>  
> -	if (likely(!vmx->nested.enlightened_vmcs_enabled))
> +	if (likely(!guest_cpuid_has_evmcs(vcpu)))
>  		return EVMPTRLD_DISABLED;
>  
>  	if (!nested_enlightened_vmentry(vcpu, &evmcs_gpa)) {
> @@ -2863,7 +2863,7 @@ static int nested_vmx_check_controls(struct kvm_vcpu *vcpu,
>  	    nested_check_vm_entry_controls(vcpu, vmcs12))
>  		return -EINVAL;
>  
> -	if (to_vmx(vcpu)->nested.enlightened_vmcs_enabled)
> +	if (guest_cpuid_has_evmcs(vcpu))
>  		return nested_evmcs_check_controls(vmcs12);
>  
>  	return 0;
> @@ -3145,7 +3145,7 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
>  	 * L2 was running), map it here to make sure vmcs12 changes are
>  	 * properly reflected.
>  	 */
> -	if (vmx->nested.enlightened_vmcs_enabled &&
> +	if (guest_cpuid_has_evmcs(vcpu) &&
>  	    vmx->nested.hv_evmcs_vmptr == EVMPTR_MAP_PENDING) {
>  		enum nested_evmptrld_status evmptrld_status =
>  			nested_vmx_handle_enlightened_vmptrld(vcpu, false);
> @@ -5067,7 +5067,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
>  	 * state. It is possible that the area will stay mapped as
>  	 * vmx->nested.hv_evmcs but this shouldn't be a problem.
>  	 */
> -	if (likely(!vmx->nested.enlightened_vmcs_enabled ||
> +	if (likely(!guest_cpuid_has_evmcs(vcpu) ||
>  		   !nested_enlightened_vmentry(vcpu, &evmcs_gpa))) {
>  		if (vmptr == vmx->nested.current_vmptr)
>  			nested_release_vmcs12(vcpu);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c9b49a09e6b5..d4ed802947d7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1930,8 +1930,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		 * sanity checking and refuse to boot. Filter all unsupported
>  		 * features out.
>  		 */
> -		if (!msr_info->host_initiated &&
> -		    vmx->nested.enlightened_vmcs_enabled)
> +		if (!msr_info->host_initiated && guest_cpuid_has_evmcs(vcpu))
>  			nested_evmcs_filter_control_msr(msr_info->index,
>  							&msr_info->data);
>  		break;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 24d58c2ffaa3..35c7e6aef301 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -626,4 +626,14 @@ static inline bool vmx_can_use_ipiv(struct kvm_vcpu *vcpu)
>  	return  lapic_in_kernel(vcpu) && enable_ipiv;
>  }
>  
> +static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * eVMCS is exposed to the guest if Hyper-V is enabled in CPUID and
> +	 * eVMCS has been explicitly enabled by userspace.
> +	 */
> +	return vcpu->arch.hyperv_enabled &&
> +	       to_vmx(vcpu)->nested.enlightened_vmcs_enabled;

I don't quite like 'guest_cpuid_has_evmcs' name as it makes me think
we're checking if eVMCS was exposed in guest CPUID but in fact we don't
do that. eVMCS can be enabled on a vCPU even if it is not exposed in
CPUID (and we should probably keep that to not mandate setting CPUID
before enabling eVMCS).

What about e.g. vcpu_has_evmcs_enabled() instead?

On a related not, any reason to put this to vmx/vmx.h and not
vmx/evmcs.h?


> +}
> +
>  #endif /* __KVM_X86_VMX_H */

-- 
Vitaly


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F7377B192
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 08:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbjHNG3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 02:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbjHNG32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 02:29:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79AD114;
        Sun, 13 Aug 2023 23:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691994567; x=1723530567;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HdDsgAarp07yE61iJIUsRq3mUM9DSa054TYhGuq71hU=;
  b=SYEk/zAPJ1g1GbQYjuByHayHYnTIb7agwbViLV66hCmIE8nMvOmDI4n6
   rQJATa2aHWxFtobSdTG1/XUxKjugDn+X9nolI/dMthcS2nsmb8BrVj8Iz
   Cx/ZX0uj40NJzUQqBgL6RnzXrUAdxyBc+SJInfcXPrvVrlMaYzYLs/9/q
   G19TlNk1o7KVkQ8znAxHab64l3TA8P+1omjH30ebg/iNYWG07rZl6n1KN
   Tid877hIIwx9SjdSikXp2vPImU4OIRjS9ElGkUaW+9JOZJFKlRGil89vm
   tI4zBZs+jG04lMRFi1BuntrJmjHaI6kJr/7Zkm4iwGdgqOt0pvCh9CYdU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="362121242"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="362121242"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2023 23:29:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="762839430"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="762839430"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.255.29.128]) ([10.255.29.128])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2023 23:29:09 -0700
Message-ID: <fa15cd52-b10a-6aad-d63f-3d809d16f591@intel.com>
Date:   Mon, 14 Aug 2023 14:28:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 12/21] KVM: x86: Use KVM-governed feature framework to
 track "XSAVES enabled"
Content-Language: en-US
To:     "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20230729011608.1065019-1-seanjc@google.com>
 <20230729011608.1065019-13-seanjc@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <20230729011608.1065019-13-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/29/2023 9:15 AM, Sean Christopherson wrote:
> Use the governed feature framework to track if XSAVES is "enabled", i.e.
> if XSAVES can be used by the guest.  Add a comment in the SVM code to
> explain the very unintuitive logic of deliberately NOT checking if XSAVES
> is enumerated in the guest CPUID model.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/governed_features.h |  1 +
>   arch/x86/kvm/svm/svm.c           | 17 ++++++++++++++---
>   arch/x86/kvm/vmx/vmx.c           | 32 ++++++++++++++++++--------------
>   arch/x86/kvm/x86.c               |  4 ++--
>   4 files changed, 35 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
> index b29c15d5e038..b896a64e4ac3 100644
> --- a/arch/x86/kvm/governed_features.h
> +++ b/arch/x86/kvm/governed_features.h
> @@ -6,6 +6,7 @@ BUILD_BUG()
>   #define KVM_GOVERNED_X86_FEATURE(x) KVM_GOVERNED_FEATURE(X86_FEATURE_##x)
>   
>   KVM_GOVERNED_X86_FEATURE(GBPAGES)
> +KVM_GOVERNED_X86_FEATURE(XSAVES)
>   
>   #undef KVM_GOVERNED_X86_FEATURE
>   #undef KVM_GOVERNED_FEATURE
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 64092df06f94..d5f8cb402eb7 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4204,9 +4204,20 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   	struct kvm_cpuid_entry2 *best;
>   
> -	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> -				    boot_cpu_has(X86_FEATURE_XSAVE) &&
> -				    boot_cpu_has(X86_FEATURE_XSAVES);
> +	/*
> +	 * SVM doesn't provide a way to disable just XSAVES in the guest, KVM
> +	 * can only disable all variants of by disallowing CR4.OSXSAVE from
> +	 * being set.  As a result, if the host has XSAVE and XSAVES, and the
> +	 * guest has XSAVE enabled, the guest can execute XSAVES without
> +	 * faulting.  Treat XSAVES as enabled in this case regardless of
> +	 * whether it's advertised to the guest so that KVM context switches
> +	 * XSS on VM-Enter/VM-Exit.  Failure to do so would effectively give
> +	 * the guest read/write access to the host's XSS.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
> +	    boot_cpu_has(X86_FEATURE_XSAVES) &&
> +	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
> +		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
>   
>   	/* Update nrips enabled cache */
>   	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a0a47be2feed..3100ed62615c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4518,16 +4518,19 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
>    * based on a single guest CPUID bit, with a dedicated feature bit.  This also
>    * verifies that the control is actually supported by KVM and hardware.
>    */
> -#define vmx_adjust_sec_exec_control(vmx, exec_control, name, feat_name, ctrl_name, exiting) \
> -({									 \
> -	bool __enabled;							 \
> -									 \
> -	if (cpu_has_vmx_##name()) {					 \
> -		__enabled = guest_cpuid_has(&(vmx)->vcpu,		 \
> -					    X86_FEATURE_##feat_name);	 \
> -		vmx_adjust_secondary_exec_control(vmx, exec_control,	 \
> -			SECONDARY_EXEC_##ctrl_name, __enabled, exiting); \
> -	}								 \
> +#define vmx_adjust_sec_exec_control(vmx, exec_control, name, feat_name, ctrl_name, exiting)	\
> +({												\
> +	struct kvm_vcpu *__vcpu = &(vmx)->vcpu;							\
> +	bool __enabled;										\
> +												\
> +	if (cpu_has_vmx_##name()) {								\
> +		if (kvm_is_governed_feature(X86_FEATURE_##feat_name))				\
> +			__enabled = guest_can_use(__vcpu, X86_FEATURE_##feat_name);		\
> +		else										\
> +			__enabled = guest_cpuid_has(__vcpu, X86_FEATURE_##feat_name);		\
> +		vmx_adjust_secondary_exec_control(vmx, exec_control, SECONDARY_EXEC_##ctrl_name,\
> +						  __enabled, exiting);				\
> +	}											\
>   })
>   
>   /* More macro magic for ENABLE_/opt-in versus _EXITING/opt-out controls. */
> @@ -4587,10 +4590,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>   	if (!enable_pml || !atomic_read(&vcpu->kvm->nr_memslots_dirty_logging))
>   		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
>   
> -	if (cpu_has_vmx_xsaves())
> -		vmx_adjust_secondary_exec_control(vmx, &exec_control,
> -						  SECONDARY_EXEC_ENABLE_XSAVES,
> -						  vcpu->arch.xsaves_enabled, false);
> +	vmx_adjust_sec_exec_feature(vmx, &exec_control, xsaves, XSAVES);
>   
>   	/*
>   	 * RDPID is also gated by ENABLE_RDTSCP, turn on the control if either
> @@ -4609,6 +4609,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>   						  SECONDARY_EXEC_ENABLE_RDTSCP,
>   						  rdpid_or_rdtscp_enabled, false);
>   	}
> +
>   	vmx_adjust_sec_exec_feature(vmx, &exec_control, invpcid, INVPCID);
>   
>   	vmx_adjust_sec_exec_exiting(vmx, &exec_control, rdrand, RDRAND);
> @@ -7722,6 +7723,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   				    boot_cpu_has(X86_FEATURE_XSAVE) &&
>   				    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
>   				    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES);
> +	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
> +	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
> +		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_XSAVES);
>   
>   	vmx_setup_uret_msrs(vmx);
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5a14378ed4e1..201fa957ce9a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1012,7 +1012,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>   		if (vcpu->arch.xcr0 != host_xcr0)
>   			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
>   
> -		if (vcpu->arch.xsaves_enabled &&
> +		if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
>   		    vcpu->arch.ia32_xss != host_xss)
>   			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
>   	}
> @@ -1043,7 +1043,7 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>   		if (vcpu->arch.xcr0 != host_xcr0)
>   			xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
>   
> -		if (vcpu->arch.xsaves_enabled &&
> +		if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
>   		    vcpu->arch.ia32_xss != host_xss)
>   			wrmsrl(MSR_IA32_XSS, host_xss);
>   	}

"xsaves_enabled" can be removed from struct kvm_vcpu_arch as VMX/SVM doesn't reference it anymore.


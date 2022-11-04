Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D396190FF
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 07:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiKDGXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 02:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbiKDGXM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 02:23:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723022B27D;
        Thu,  3 Nov 2022 23:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667542954; x=1699078954;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dpPYB6O0Iym/jBFRwx8/3NauFKj5Z5IV2Uq06/9dUi0=;
  b=HJHNOlLDKYROR5BFNk9a+3WW+ijpbZ3KmOtJ2aJMjsiosPXAalu56m4q
   6LR7o2JrZkWwA1riwxun8wHI8vOH8oGn/BS2kmDfUFqDe+rdDJCMqP86y
   i1J00fSb39auoR6enGJcwZVk9EgHWpnVlt8YovuvWMFcSr9zE8Vmp/uR8
   eOo849xNtIjGyIt18IME4btaR4p3qy/VJMSRQjPIpz6jAN+HeMiBBoJbs
   i7lYEDUxk7ecsij4xLoAQLJI7NdXPtE9TuuoB16eW/9mHYth3hEzmWAMW
   zVJT2TVrsR56jSR4oFCjfZ+XwryBJ7BDTIJh7SjOKcDhkzbKH7nEu6lOt
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="311630024"
X-IronPort-AV: E=Sophos;i="5.96,136,1665471600"; 
   d="scan'208";a="311630024"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 23:22:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="698531026"
X-IronPort-AV: E=Sophos;i="5.96,136,1665471600"; 
   d="scan'208";a="698531026"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 03 Nov 2022 23:22:23 -0700
Date:   Fri, 4 Nov 2022 14:22:23 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 08/44] KVM: x86: Move hardware setup/unsetup to init/exit
Message-ID: <20221104062223.7kcrbt66mlmqxk7f@yy-desk-7060>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-9-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102231911.3107438-9-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022 at 11:18:35PM +0000, Sean Christopherson wrote:
> Now that kvm_arch_hardware_setup() is called immediately after
> kvm_arch_init(), fold the guts of kvm_arch_hardware_(un)setup() into
> kvm_arch_{init,exit}() as a step towards dropping one of the hooks.
>
> To avoid having to unwind various setup, e.g registration of several
> notifiers, slot in the vendor hardware setup before the registration of
> said notifiers and callbacks.  Introducing a functional change while
> moving code is less than ideal, but the alternative is adding a pile of
> unwinding code, which is much more error prone, e.g. several attempts to
> move the setup code verbatim all introduced bugs.
>
> Add a comment to document that kvm_ops_update() is effectively the point
> of no return, e.g. it sets the kvm_x86_ops.hardware_enable canary and so
> needs to be unwound.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 121 +++++++++++++++++++++++----------------------
>  1 file changed, 63 insertions(+), 58 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9a7702b1c563..80ee580a9cd4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9252,6 +9252,24 @@ static struct notifier_block pvclock_gtod_notifier = {
>  };
>  #endif
>
> +static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
> +{
> +	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
> +
> +#define __KVM_X86_OP(func) \
> +	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
> +#define KVM_X86_OP(func) \
> +	WARN_ON(!kvm_x86_ops.func); __KVM_X86_OP(func)
> +#define KVM_X86_OP_OPTIONAL __KVM_X86_OP
> +#define KVM_X86_OP_OPTIONAL_RET0(func) \
> +	static_call_update(kvm_x86_##func, (void *)kvm_x86_ops.func ? : \
> +					   (void *)__static_call_return0);
> +#include <asm/kvm-x86-ops.h>
> +#undef __KVM_X86_OP
> +
> +	kvm_pmu_ops_update(ops->pmu_ops);
> +}
> +
>  int kvm_arch_init(void *opaque)
>  {
>  	struct kvm_x86_init_ops *ops = opaque;
> @@ -9325,6 +9343,24 @@ int kvm_arch_init(void *opaque)
>  		kvm_caps.supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
>  	}
>
> +	rdmsrl_safe(MSR_EFER, &host_efer);
> +
> +	if (boot_cpu_has(X86_FEATURE_XSAVES))
> +		rdmsrl(MSR_IA32_XSS, host_xss);
> +
> +	kvm_init_pmu_capability();
> +
> +	r = ops->hardware_setup();
> +	if (r != 0)
> +		goto out_mmu_exit;

The failure case of ops->hardware_setup() is unwound
by kvm_arch_exit() before this patch, do we need to
keep that old behavior ?

> +
> +	/*
> +	 * Point of no return!  DO NOT add error paths below this point unless
> +	 * absolutely necessary, as most operations from this point forward
> +	 * require unwinding.
> +	 */
> +	kvm_ops_update(ops);
> +
>  	kvm_timer_init();
>
>  	if (pi_inject_timer == -1)
> @@ -9336,8 +9372,32 @@ int kvm_arch_init(void *opaque)
>  		set_hv_tscchange_cb(kvm_hyperv_tsc_notifier);
>  #endif
>
> +	kvm_register_perf_callbacks(ops->handle_intel_pt_intr);
> +
> +	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> +		kvm_caps.supported_xss = 0;
> +
> +#define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
> +	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
> +#undef __kvm_cpu_cap_has
> +
> +	if (kvm_caps.has_tsc_control) {
> +		/*
> +		 * Make sure the user can only configure tsc_khz values that
> +		 * fit into a signed integer.
> +		 * A min value is not calculated because it will always
> +		 * be 1 on all machines.
> +		 */
> +		u64 max = min(0x7fffffffULL,
> +			      __scale_tsc(kvm_caps.max_tsc_scaling_ratio, tsc_khz));
> +		kvm_caps.max_guest_tsc_khz = max;
> +	}
> +	kvm_caps.default_tsc_scaling_ratio = 1ULL << kvm_caps.tsc_scaling_ratio_frac_bits;
> +	kvm_init_msr_list();
>  	return 0;
>
> +out_mmu_exit:
> +	kvm_mmu_vendor_module_exit();
>  out_free_percpu:
>  	free_percpu(user_return_msrs);
>  out_free_x86_emulator_cache:
> @@ -9347,6 +9407,8 @@ int kvm_arch_init(void *opaque)
>
>  void kvm_arch_exit(void)
>  {
> +	kvm_unregister_perf_callbacks();
> +
>  #ifdef CONFIG_X86_64
>  	if (hypervisor_is_type(X86_HYPER_MS_HYPERV))
>  		clear_hv_tscchange_cb();
> @@ -9362,6 +9424,7 @@ void kvm_arch_exit(void)
>  	irq_work_sync(&pvclock_irq_work);
>  	cancel_work_sync(&pvclock_gtod_work);
>  #endif
> +	static_call(kvm_x86_hardware_unsetup)();
>  	kvm_x86_ops.hardware_enable = NULL;
>  	kvm_mmu_vendor_module_exit();
>  	free_percpu(user_return_msrs);
> @@ -11922,72 +11985,14 @@ void kvm_arch_hardware_disable(void)
>  	drop_user_return_notifiers();
>  }
>
> -static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
> -{
> -	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
> -
> -#define __KVM_X86_OP(func) \
> -	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
> -#define KVM_X86_OP(func) \
> -	WARN_ON(!kvm_x86_ops.func); __KVM_X86_OP(func)
> -#define KVM_X86_OP_OPTIONAL __KVM_X86_OP
> -#define KVM_X86_OP_OPTIONAL_RET0(func) \
> -	static_call_update(kvm_x86_##func, (void *)kvm_x86_ops.func ? : \
> -					   (void *)__static_call_return0);
> -#include <asm/kvm-x86-ops.h>
> -#undef __KVM_X86_OP
> -
> -	kvm_pmu_ops_update(ops->pmu_ops);
> -}
> -
>  int kvm_arch_hardware_setup(void *opaque)
>  {
> -	struct kvm_x86_init_ops *ops = opaque;
> -	int r;
> -
> -	rdmsrl_safe(MSR_EFER, &host_efer);
> -
> -	if (boot_cpu_has(X86_FEATURE_XSAVES))
> -		rdmsrl(MSR_IA32_XSS, host_xss);
> -
> -	kvm_init_pmu_capability();
> -
> -	r = ops->hardware_setup();
> -	if (r != 0)
> -		return r;
> -
> -	kvm_ops_update(ops);
> -
> -	kvm_register_perf_callbacks(ops->handle_intel_pt_intr);
> -
> -	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> -		kvm_caps.supported_xss = 0;
> -
> -#define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
> -	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
> -#undef __kvm_cpu_cap_has
> -
> -	if (kvm_caps.has_tsc_control) {
> -		/*
> -		 * Make sure the user can only configure tsc_khz values that
> -		 * fit into a signed integer.
> -		 * A min value is not calculated because it will always
> -		 * be 1 on all machines.
> -		 */
> -		u64 max = min(0x7fffffffULL,
> -			      __scale_tsc(kvm_caps.max_tsc_scaling_ratio, tsc_khz));
> -		kvm_caps.max_guest_tsc_khz = max;
> -	}
> -	kvm_caps.default_tsc_scaling_ratio = 1ULL << kvm_caps.tsc_scaling_ratio_frac_bits;
> -	kvm_init_msr_list();
>  	return 0;
>  }
>
>  void kvm_arch_hardware_unsetup(void)
>  {
> -	kvm_unregister_perf_callbacks();
>
> -	static_call(kvm_x86_hardware_unsetup)();
>  }
>
>  int kvm_arch_check_processor_compat(void *opaque)
> --
> 2.38.1.431.g37b22c650d-goog
>

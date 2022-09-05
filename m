Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E12E5AC9D2
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 07:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbiIEFnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 01:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbiIEFnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 01:43:05 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816502D1E6;
        Sun,  4 Sep 2022 22:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662356584; x=1693892584;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FfaurS8Eqj1F9kuGI61H90o+/5niy1dzQ3FNUYnyU6M=;
  b=hpdjKovCjw7FB6xthJyWbJueiYLnR0AB6RDQok9zHnjgxG9r22v3/ii9
   q2j+16xBYNDRH9OFzv7lG5owZ3J971sfjLBUg3umlWXISqt0WZucu86W8
   iBRXZbxu9aqv4jv0oWpkUNrOniS7+PjM+LPiprOdyh6teAIDTr+vNmx6X
   7+j46p9CySJ5m2l0WDGribSvm9A1C1ZZKTD5OYF2u/4aFND94hPzOB/Uq
   xO01cOAm50o3c5KP2S+W6ZMw35tc66EuJk0hG4Pf7w7ZymdB29dQVSCqr
   ssxT3OO9qK1mdi2Alu76bTnQD2gjgswg3sviGtViu78E1QTjRISL1SYzR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="322476004"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="322476004"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 22:43:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="675134595"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 04 Sep 2022 22:42:57 -0700
Date:   Mon, 5 Sep 2022 13:42:57 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 03/22] KVM: x86: Move check_processor_compatibility
 from init ops to runtime ops
Message-ID: <20220905054257.swzn4r4rrz762lxc@yy-desk-7060>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <aadf5be7c89994792c3efe853328f6a08dd68919.1662084396.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aadf5be7c89994792c3efe853328f6a08dd68919.1662084396.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 07:17:38PM -0700, isaku.yamahata@intel.com wrote:
> From: Chao Gao <chao.gao@intel.com>
>
> so that KVM can do compatibility checks on hotplugged CPUs. Drop __init
> from check_processor_compatibility() and its callees.
>
> use a static_call() to invoke .check_processor_compatibility.
>
> Opportunistically rename {svm,vmx}_check_processor_compat to conform
> to the naming convention of fields of kvm_x86_ops.
>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Link: https://lore.kernel.org/r/20220216031528.92558-2-chao.gao@intel.com
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  2 +-
>  arch/x86/kvm/svm/svm.c             |  4 ++--
>  arch/x86/kvm/vmx/vmx.c             | 14 +++++++-------
>  arch/x86/kvm/x86.c                 |  3 +--
>  5 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 51f777071584..3bc45932e2d1 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -129,6 +129,7 @@ KVM_X86_OP(msr_filter_changed)
>  KVM_X86_OP(complete_emulated_msr)
>  KVM_X86_OP(vcpu_deliver_sipi_vector)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> +KVM_X86_OP(check_processor_compatibility)
>
>  #undef KVM_X86_OP
>  #undef KVM_X86_OP_OPTIONAL
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2c96c43c313a..5df5d88d345f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1445,6 +1445,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
>  struct kvm_x86_ops {
>  	const char *name;
>
> +	int (*check_processor_compatibility)(void);
>  	int (*hardware_enable)(void);
>  	void (*hardware_disable)(void);
>  	void (*hardware_unsetup)(void);
> @@ -1655,7 +1656,6 @@ struct kvm_x86_nested_ops {
>  struct kvm_x86_init_ops {
>  	int (*cpu_has_kvm_support)(void);
>  	int (*disabled_by_bios)(void);
> -	int (*check_processor_compatibility)(void);
>  	int (*hardware_setup)(void);
>  	unsigned int (*handle_intel_pt_intr)(void);
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f3813dbacb9f..371300f03f55 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4134,7 +4134,7 @@ svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
>  	hypercall[2] = 0xd9;
>  }
>
> -static int __init svm_check_processor_compat(void)
> +static int svm_check_processor_compatibility(void)
>  {
>  	return 0;
>  }
> @@ -4740,6 +4740,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.name = "kvm_amd",
>
>  	.hardware_unsetup = svm_hardware_unsetup,
> +	.check_processor_compatibility = svm_check_processor_compatibility,
>  	.hardware_enable = svm_hardware_enable,
>  	.hardware_disable = svm_hardware_disable,
>  	.has_emulated_msr = svm_has_emulated_msr,
> @@ -5122,7 +5123,6 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
>  	.cpu_has_kvm_support = has_svm,
>  	.disabled_by_bios = is_disabled,
>  	.hardware_setup = svm_hardware_setup,
> -	.check_processor_compatibility = svm_check_processor_compat,
>
>  	.runtime_ops = &svm_x86_ops,
>  	.pmu_ops = &amd_pmu_ops,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d7f8331d6f7e..3cf7f18a4115 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2495,8 +2495,8 @@ static bool cpu_has_sgx(void)
>  	return cpuid_eax(0) >= 0x12 && (cpuid_eax(0x12) & BIT(0));
>  }
>
> -static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
> -				      u32 msr, u32 *result)
> +static int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
> +			       u32 msr, u32 *result)
>  {
>  	u32 vmx_msr_low, vmx_msr_high;
>  	u32 ctl = ctl_min | ctl_opt;
> @@ -2514,7 +2514,7 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
>  	return 0;
>  }
>
> -static __init u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
> +static u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
>  {
>  	u64 allowed;
>
> @@ -2523,8 +2523,8 @@ static __init u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
>  	return  ctl_opt & allowed;
>  }
>
> -static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> -				    struct vmx_capability *vmx_cap)
> +static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> +			     struct vmx_capability *vmx_cap)
>  {
>  	u32 vmx_msr_low, vmx_msr_high;
>  	u32 min, opt, min2, opt2;
> @@ -7417,7 +7417,7 @@ static int vmx_vm_init(struct kvm *kvm)
>  	return 0;
>  }
>
> -static int __init vmx_check_processor_compat(void)
> +static int vmx_check_processor_compatibility(void)
>  {
>  	struct vmcs_config vmcs_conf;
>  	struct vmx_capability vmx_cap;
> @@ -8015,6 +8015,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>
>  	.hardware_unsetup = vmx_hardware_unsetup,
>
> +	.check_processor_compatibility = vmx_check_processor_compatibility,
>  	.hardware_enable = vmx_hardware_enable,
>  	.hardware_disable = vmx_hardware_disable,
>  	.has_emulated_msr = vmx_has_emulated_msr,
> @@ -8404,7 +8405,6 @@ static __init int hardware_setup(void)
>  static struct kvm_x86_init_ops vmx_init_ops __initdata = {
>  	.cpu_has_kvm_support = cpu_has_kvm_support,
>  	.disabled_by_bios = vmx_disabled_by_bios,
> -	.check_processor_compatibility = vmx_check_processor_compat,
>  	.hardware_setup = hardware_setup,
>  	.handle_intel_pt_intr = NULL,
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fd021581ca60..5f12a7ed6f94 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12001,7 +12001,6 @@ void kvm_arch_hardware_unsetup(void)
>  int kvm_arch_check_processor_compat(void *opaque)
>  {
>  	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> -	struct kvm_x86_init_ops *ops = opaque;
>
>  	WARN_ON(!irqs_disabled());
>
> @@ -12009,7 +12008,7 @@ int kvm_arch_check_processor_compat(void *opaque)
>  	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
>  		return -EIO;
>
> -	return ops->check_processor_compatibility();
> +	return static_call(kvm_x86_check_processor_compatibility)();
>  }
>
>  bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
> --
> 2.25.1
>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B56682E50
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 14:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbjAaNri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 08:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbjAaNrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 08:47:36 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B09D1709
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 05:47:34 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A34E42F4;
        Tue, 31 Jan 2023 05:48:16 -0800 (PST)
Received: from [10.57.78.39] (unknown [10.57.78.39])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87F7B3F71E;
        Tue, 31 Jan 2023 05:47:32 -0800 (PST)
Message-ID: <b7dbe85e-c7f8-48ad-e1af-85befabd8509@arm.com>
Date:   Tue, 31 Jan 2023 13:47:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v8 01/69] arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230131092504.2880505-1-maz@kernel.org>
 <20230131092504.2880505-2-maz@kernel.org>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20230131092504.2880505-2-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc

On 31/01/2023 09:23, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> Add a new ARM64_HAS_NESTED_VIRT feature to indicate that the
> CPU has the ARMv8.3 nested virtualization capability, together
> with the 'kvm-arm.mode=nested' command line option.
> 
> This will be used to support nested virtualization in KVM.
> 
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> [maz: moved the command-line option to kvm-arm.mode]

Should this be separate kvm-arm mode ? Or can this be tied to
is_kernel_in_hyp_mode() ? Given this mode (from my limited
review) doesn't conflict with normal VHE mode (and RME support),
adding this explicit mode could confuse the user.

In case we need a command line to turn the NV mode on/off,
we could always use the id-override and simply leave this out ?

Cheers
Suzuki


> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   .../admin-guide/kernel-parameters.txt         |  7 +++++-
>   arch/arm64/include/asm/kvm_host.h             |  5 ++++
>   arch/arm64/kernel/cpufeature.c                | 25 +++++++++++++++++++
>   arch/arm64/kvm/arm.c                          |  5 ++++
>   arch/arm64/tools/cpucaps                      |  1 +
>   5 files changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 6cfa6e3996cf..b7b0704e360e 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2553,9 +2553,14 @@
>   			protected: nVHE-based mode with support for guests whose
>   				   state is kept private from the host.
>   
> +			nested: VHE-based mode with support for nested
> +				virtualization. Requires at least ARMv8.3
> +				hardware.
> +
>   			Defaults to VHE/nVHE based on hardware support. Setting
>   			mode to "protected" will disable kexec and hibernation
> -			for the host.
> +			for the host. "nested" is experimental and should be
> +			used with extreme caution.
>   
>   	kvm-arm.vgic_v3_group0_trap=
>   			[KVM,ARM] Trap guest accesses to GICv3 group-0
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index b14a0199eba4..186f1b759763 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -60,9 +60,14 @@
>   enum kvm_mode {
>   	KVM_MODE_DEFAULT,
>   	KVM_MODE_PROTECTED,
> +	KVM_MODE_NV,
>   	KVM_MODE_NONE,
>   };
> +#ifdef CONFIG_KVM
>   enum kvm_mode kvm_get_mode(void);
> +#else
> +static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
> +#endif
>   
>   DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>   
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index a77315b338e6..3fc14ee86239 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1956,6 +1956,20 @@ static void cpu_copy_el2regs(const struct arm64_cpu_capabilities *__unused)
>   		write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);
>   }
>   
> +static bool has_nested_virt_support(const struct arm64_cpu_capabilities *cap,
> +				    int scope)
> +{
> +	if (kvm_get_mode() != KVM_MODE_NV)
> +		return false;
> +
> +	if (!has_cpuid_feature(cap, scope)) {
> +		pr_warn("unavailable: %s\n", cap->desc);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>   #ifdef CONFIG_ARM64_PAN
>   static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
>   {
> @@ -2215,6 +2229,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>   		.matches = runs_at_el2,
>   		.cpu_enable = cpu_copy_el2regs,
>   	},
> +	{
> +		.desc = "Nested Virtualization Support",
> +		.capability = ARM64_HAS_NESTED_VIRT,
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches = has_nested_virt_support,
> +		.sys_reg = SYS_ID_AA64MMFR2_EL1,
> +		.sign = FTR_UNSIGNED,
> +		.field_pos = ID_AA64MMFR2_EL1_NV_SHIFT,
> +		.field_width = 4,
> +		.min_field_value = ID_AA64MMFR2_EL1_NV_IMP,
> +	},
>   	{
>   		.capability = ARM64_HAS_32BIT_EL0_DO_NOT_USE,
>   		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 698787ed87e9..4e1943e3aa42 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2325,6 +2325,11 @@ static int __init early_kvm_mode_cfg(char *arg)
>   		return 0;
>   	}
>   
> +	if (strcmp(arg, "nested") == 0 && !WARN_ON(!is_kernel_in_hyp_mode())) {
> +		kvm_mode = KVM_MODE_NV;
> +		return 0;
> +	}
> +
>   	return -EINVAL;
>   }
>   early_param("kvm-arm.mode", early_kvm_mode_cfg);
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index dfeb2c51e257..1af77a3657f7 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -31,6 +31,7 @@ HAS_GENERIC_AUTH_IMP_DEF
>   HAS_IRQ_PRIO_MASKING
>   HAS_LDAPR
>   HAS_LSE_ATOMICS
> +HAS_NESTED_VIRT
>   HAS_NO_FPSIMD
>   HAS_NO_HW_PREFETCH
>   HAS_PAN


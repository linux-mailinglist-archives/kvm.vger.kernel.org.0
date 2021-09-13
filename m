Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B895409F51
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 23:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344519AbhIMVpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 17:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244923AbhIMVpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 17:45:11 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB5CC061760
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 14:43:55 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id j6so9832380pfa.4
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 14:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sG2eyH9Bgb1L/y1jzf6CQp6ymvgMkzFT8CFUJyXDBcQ=;
        b=TWS+2rX8IxtjrkxvQtcSH/ADskq5QVzTpyXa/gp84aAP+wRjMIAzVdqhgRvPzuL4mo
         ChskmWITqBwQR4TyWlFo7HszU3Tk/JmS55gCwXHHKOJ1FARnRAHMIJwTLcvr3agz6NMS
         XtT+97h0KqDF2lHmoQ9/AfAAqJ6Lk0q9ywzmHxHD/uRQdXVAAWVwHgCdsCRK7klJ9Er3
         XOGXQq1QSDafboUYWUSM8EHRLgHYORG2Mrw7xS4IFqpOCsi/U3PvonrnEe+0i7wIBB0i
         gIqkd49tlbo/10Xd4fShNYZ0ZGaM7NXx0v+hBiPlkMdeF6rd+IHT0FHevBm1eqxhjAC2
         1UGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sG2eyH9Bgb1L/y1jzf6CQp6ymvgMkzFT8CFUJyXDBcQ=;
        b=qoYEyrpiiUpiR8LMmm/j3lJ/N3aegoKpPAa3R/wY0bbgb29wroi5ucAKpwNvguPCIR
         ESOgTJ5uZJKfER1z+mqVTSeKd9OwI50Wew2bdkeZaj5FYVYkNkYLv9ICx0bs+gm5Fgjz
         Y4EieIKGDlVz9YvSy7MqGKIs7P82ujGlzn//Kgv3cJYeT8pDEy7bXeGQE6TOYWJu2gIp
         Hnu7i2mLCajuS7tRQLGVgdsAFtQOU6q4kgwtQKOQGc4IZBF/baLsNwDkaUX70tZoQ+D9
         mY1RSM+LnAh6CH7HuitMaFQMjuLRtI/nYFK+75p6UVfI4Y5MvICdfPizujo4KiushL8R
         KL+g==
X-Gm-Message-State: AOAM531xnADEkkWrlKHvUZE1O7cgisH2mt4QOpyeg5pnisxoc3twYXcg
        WQqDt0IBJlV1X/gmq+007wzrAQ==
X-Google-Smtp-Source: ABdhPJwgblB3hOcn7bN2z+YFe7ozcUxqKzo3wlKfTkc5oVOZHVQhtOLvuw4PrXPWus8czkAZNPgAWg==
X-Received: by 2002:aa7:8387:0:b029:395:a683:a0e6 with SMTP id u7-20020aa783870000b0290395a683a0e6mr1441934pfm.12.1631569434793;
        Mon, 13 Sep 2021 14:43:54 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id u15sm8384455pfl.14.2021.09.13.14.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 14:43:54 -0700 (PDT)
Date:   Mon, 13 Sep 2021 14:43:50 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 04/14] KVM: arm64: selftests: Introduce
 ARM64_SYS_KVM_REG
Message-ID: <YT/GFj9GVv6ZD8I5@google.com>
References: <20210913204930.130715-1-rananta@google.com>
 <20210913204930.130715-5-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913204930.130715-5-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 08:49:20PM +0000, Raghavendra Rao Ananta wrote:
> With the inclusion of sysreg.h, that brings in system register
> encodings, it would be redundant to re-define register encodings
> again in processor.h to use it with ARM64_SYS_REG for the KVM
> functions such as set_reg() or get_reg(). Hence, add helper macro,
> ARM64_SYS_KVM_REG, that converts SYS_* definitions in sysreg.h
> into ARM64_SYS_REG definitions.
> 
> Also replace all the users of ARM64_SYS_REG, relying on
> the encodings created in processor.h, with ARM64_SYS_KVM_REG and
> remove the definitions.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c  |  2 +-
>  .../selftests/kvm/aarch64/psci_cpu_on_test.c  |  2 +-
>  .../selftests/kvm/include/aarch64/processor.h | 20 ++++++++++---------
>  .../selftests/kvm/lib/aarch64/processor.c     | 16 +++++++--------
>  4 files changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> index 11fd23e21cb4..ea189d83abf7 100644
> --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> @@ -190,7 +190,7 @@ static int debug_version(struct kvm_vm *vm)
>  {
>  	uint64_t id_aa64dfr0;
>  
> -	get_reg(vm, VCPU_ID, ARM64_SYS_REG(ID_AA64DFR0_EL1), &id_aa64dfr0);
> +	get_reg(vm, VCPU_ID, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
>  	return id_aa64dfr0 & 0xf;
>  }
>  
> diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
> index 018c269990e1..4c5f6814030f 100644
> --- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
> @@ -91,7 +91,7 @@ int main(void)
>  	init.features[0] |= (1 << KVM_ARM_VCPU_POWER_OFF);
>  	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
>  
> -	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
> +	get_reg(vm, VCPU_ID_TARGET, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &target_mpidr);
>  	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
>  	vcpu_run(vm, VCPU_ID_SOURCE);
>  
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 7989e832cafb..93797783abad 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -16,15 +16,17 @@
>  #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
>  			   KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
>  
> -#define CPACR_EL1               3, 0,  1, 0, 2
> -#define TCR_EL1                 3, 0,  2, 0, 2
> -#define MAIR_EL1                3, 0, 10, 2, 0
> -#define MPIDR_EL1               3, 0,  0, 0, 5
> -#define TTBR0_EL1               3, 0,  2, 0, 0
> -#define SCTLR_EL1               3, 0,  1, 0, 0
> -#define VBAR_EL1                3, 0, 12, 0, 0
> -
> -#define ID_AA64DFR0_EL1         3, 0,  0, 5, 0
> +/*
> + * KVM_ARM64_SYS_REG(sys_reg_id): Helper macro to convert
> + * SYS_* register definitions in asm/sysreg.h to use in KVM
> + * calls such as get_reg() and set_reg().
> + */
> +#define KVM_ARM64_SYS_REG(sys_reg_id)			\
> +	ARM64_SYS_REG(sys_reg_Op0(sys_reg_id),		\
> +			sys_reg_Op1(sys_reg_id),	\
> +			sys_reg_CRn(sys_reg_id),	\
> +			sys_reg_CRm(sys_reg_id),	\
> +			sys_reg_Op2(sys_reg_id))
>  
>  /*
>   * Default MAIR
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 632b74d6b3ca..db64ee206064 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -232,10 +232,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
>  	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
>  	 * registers, which the variable argument list macros do.
>  	 */
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(CPACR_EL1), 3 << 20);
> +	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_CPACR_EL1), 3 << 20);
>  
> -	get_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), &sctlr_el1);
> -	get_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), &tcr_el1);
> +	get_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), &sctlr_el1);
> +	get_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TCR_EL1), &tcr_el1);
>  
>  	switch (vm->mode) {
>  	case VM_MODE_P52V48_4K:
> @@ -273,10 +273,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
>  	tcr_el1 |= (1 << 8) | (1 << 10) | (3 << 12);
>  	tcr_el1 |= (64 - vm->va_bits) /* T0SZ */;
>  
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), sctlr_el1);
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), tcr_el1);
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(MAIR_EL1), DEFAULT_MAIR_EL1);
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(TTBR0_EL1), vm->pgd);
> +	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), sctlr_el1);
> +	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TCR_EL1), tcr_el1);
> +	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
> +	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TTBR0_EL1), vm->pgd);
>  }
>  
>  void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
> @@ -362,7 +362,7 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
>  {
>  	extern char vectors;
>  
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(VBAR_EL1), (uint64_t)&vectors);
> +	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_VBAR_EL1), (uint64_t)&vectors);
>  }
>  
>  void route_exception(struct ex_regs *regs, int vector)
> -- 
> 2.33.0.309.g3052b89438-goog
> 

Reviewed-by: Ricardo Koller <ricarkol@google.com>

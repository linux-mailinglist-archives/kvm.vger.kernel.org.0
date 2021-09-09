Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C0B405817
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 15:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358225AbhIINqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 09:46:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358727AbhIINja (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 09:39:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631194699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mIEy4vU6He4mxZAyPtvCnUdjgbnJN+ExybQr7N/yeGA=;
        b=Y2d5hyFuuhjEU10iD+mnqVSvYfD9p76ViWMSMaSzxvfoRIoXk53NgobJNOWp5O9OdK4Frn
        5c8Rrl2LpeerUCV9DvmKZTcR88ZhiJ/Aet7U8niwMQxbb4D3pFwXv52++PJJS8Tq4sCqzA
        zF6pQmnq+u8Usxlxx6xYAmejbN5hk6o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-L5HKXoNPOZOZAxzs7I8BXw-1; Thu, 09 Sep 2021 09:38:18 -0400
X-MC-Unique: L5HKXoNPOZOZAxzs7I8BXw-1
Received: by mail-wr1-f72.google.com with SMTP id m18-20020adfe952000000b0015b0aa32fd6so516140wrn.12
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 06:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mIEy4vU6He4mxZAyPtvCnUdjgbnJN+ExybQr7N/yeGA=;
        b=6GDdR1Cv8E7GxYjGDLQckoVX53Z9/8TnGG/YWkjYYyJOWXrlaetRnswEGAfCQXPb2w
         yHG/II/Br+uQw29TgEXg+Qhv6oX9JDqSfG9VqbRWy6Z4uautXVjSN3VgTuGN7lDn3kcb
         wjBCo2Oy+Huk8S13+NAa/1zWku/q+VLwL8rVX0biHO7r/W6xJikL+Gpn5+R4jNrQNctC
         8ZQ+knpFlvO4PdIKWRN9czZq8TD9L6BgFmTqbKHqu1rSL6TuTvfuHOdX6z7HakeiqBbb
         yxSrdKKOyNCYz3MxfXXoXOnAWnIwlRCsHAAyNBH2B4ZlWo7jkmnjwJejkmJc6jXTu65G
         KPkw==
X-Gm-Message-State: AOAM530rHJmbQIhSar/nbhOObJB9F9i+WmhbKYps8Y5k2K4GjEiIBxEl
        CPjkV0365nMV0t5BKsv/Pa51QaFs9buaIDMSo8E51UA5bG8WxcPzvkLVeoatxwNIEZwZXASI4ik
        fzTo+1XloCmV5
X-Received: by 2002:a05:6000:104e:: with SMTP id c14mr3672035wrx.130.1631194696911;
        Thu, 09 Sep 2021 06:38:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYhoRxlLOsZDoSKadFGu59kuAkRGfRF4uFoBJKfJmIsL3BnpQOfPdzBLXTxUvq41MnfbZmzg==
X-Received: by 2002:a05:6000:104e:: with SMTP id c14mr3672010wrx.130.1631194696645;
        Thu, 09 Sep 2021 06:38:16 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id t11sm1667345wmi.23.2021.09.09.06.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 06:38:16 -0700 (PDT)
Date:   Thu, 9 Sep 2021 15:38:14 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 17/18] KVM: arm64: selftests: Replace ARM64_SYS_REG
 with ARM64_SYS_KVM_REG
Message-ID: <20210909133814.wsua43ya2erfw6gm@gator>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-18-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909013818.1191270-18-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 01:38:17AM +0000, Raghavendra Rao Ananta wrote:
> With the introduction of ARM64_SYS_KVM_REG, that takes the
> system register encodings from sysreg.h directly, replace
> all the users of ARM64_SYS_REG, relyiing on the encodings
> created in processor.h, with ARM64_SYS_KVM_REG.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c     |  2 +-
>  .../selftests/kvm/aarch64/psci_cpu_on_test.c     |  3 ++-
>  .../selftests/kvm/include/aarch64/processor.h    | 10 ----------
>  .../selftests/kvm/lib/aarch64/processor.c        | 16 ++++++++--------
>  4 files changed, 11 insertions(+), 20 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> index 11fd23e21cb4..b28b311f4dd7 100644
> --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> @@ -190,7 +190,7 @@ static int debug_version(struct kvm_vm *vm)
>  {
>  	uint64_t id_aa64dfr0;
>  
> -	get_reg(vm, VCPU_ID, ARM64_SYS_REG(ID_AA64DFR0_EL1), &id_aa64dfr0);
> +	get_reg(vm, VCPU_ID, ARM64_SYS_KVM_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
>  	return id_aa64dfr0 & 0xf;
>  }
>  
> diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
> index 018c269990e1..4c8aa7b8a65d 100644
> --- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
> @@ -91,7 +91,8 @@ int main(void)
>  	init.features[0] |= (1 << KVM_ARM_VCPU_POWER_OFF);
>  	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
>  
> -	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
> +	get_reg(vm, VCPU_ID_TARGET,
> +		ARM64_SYS_KVM_REG(SYS_MPIDR_EL1), &target_mpidr);

nit: I'd just leave this on one line. We don't mind long lines in this
part of town.

>  	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
>  	vcpu_run(vm, VCPU_ID_SOURCE);
>  
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 150f63101f4c..ee81dd3db516 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -16,16 +16,6 @@
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
> -
>  /*
>   * ARM64_SYS_KVM_REG(sys_reg_id): Helper macro to convert
>   * SYS_* register definitions in sysreg.h to use in KVM
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 9844b62227b1..d7b89aa092f5 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -240,10 +240,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
>  	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
>  	 * registers, which the variable argument list macros do.
>  	 */
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(CPACR_EL1), 3 << 20);
> +	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_CPACR_EL1), 3 << 20);
>  
> -	get_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), &sctlr_el1);
> -	get_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), &tcr_el1);
> +	get_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_SCTLR_EL1), &sctlr_el1);
> +	get_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_TCR_EL1), &tcr_el1);
>  
>  	switch (vm->mode) {
>  	case VM_MODE_P52V48_4K:
> @@ -281,10 +281,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
>  	tcr_el1 |= (1 << 8) | (1 << 10) | (3 << 12);
>  	tcr_el1 |= (64 - vm->va_bits) /* T0SZ */;
>  
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), sctlr_el1);
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), tcr_el1);
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(MAIR_EL1), DEFAULT_MAIR_EL1);
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(TTBR0_EL1), vm->pgd);
> +	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_SCTLR_EL1), sctlr_el1);
> +	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_TCR_EL1), tcr_el1);
> +	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
> +	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_TTBR0_EL1), vm->pgd);
>  }
>  
>  void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
> @@ -370,7 +370,7 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
>  {
>  	extern char vectors;
>  
> -	set_reg(vm, vcpuid, ARM64_SYS_REG(VBAR_EL1), (uint64_t)&vectors);
> +	set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_VBAR_EL1), (uint64_t)&vectors);
>  }
>  
>  void route_exception(struct ex_regs *regs, int vector)
> -- 
> 2.33.0.153.gba50c8fa24-goog
>

I also agree with Oliver that this patch may be squashed into the one that
introduces ARM64_SYS_KVM_REG.

Thanks,
drew 


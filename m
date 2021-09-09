Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29881404692
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 09:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhIIH57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 03:57:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44524 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229492AbhIIH55 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 03:57:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631174208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DSEA+5xU2vlC9SUWNvr+eh8PoV/LhwkdeZwEDORiMCU=;
        b=AGAfmtCjtwV2dmRG8iNgapUI63u7D29FEPgv9HPE00Li5ZN+HQc8bCbT/UWi1ogu/Mvlxv
        nLDAM3+1WSjmtIJE8ilSC1zRJZglORATj20n2JuVoISlvMnF2ot5o4GMLCo2fmmvgAaqRB
        OGPHBPDPT4BlmK53QVmM0lgZ4Ry3Qus=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-MUn8IZprNliweunx24ZURg-1; Thu, 09 Sep 2021 03:56:47 -0400
X-MC-Unique: MUn8IZprNliweunx24ZURg-1
Received: by mail-ed1-f71.google.com with SMTP id j13-20020aa7ca4d000000b003c44c679d73so556307edt.8
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 00:56:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DSEA+5xU2vlC9SUWNvr+eh8PoV/LhwkdeZwEDORiMCU=;
        b=q+n4bBkYNSRxZZ766SDwtgmbV5tmGd0My8QegAQTAhlp4DuXeKw7TN15hgobFXLc6Z
         vBgZoakE6FXNyIoFjizRF90YTsKFdtcbbmwNFO7iLF31HzsKu8VpLaublrztY/dQYK+4
         HT9a3SI5qLKNGX5lM5a2io5SKAqyV5y19tLdCPOBJtalu+UwkpJnF8kzYiGwwk7XIbfI
         FHhwr8dLJ0L4dJedZJ3w8XedAe76K08bSEi1FeEXmSHlUWMWtE3AW7QZD0G2lzLYfNn7
         i95h9WRQcTZ7i/orOBD/hWZNUaxPufqTPvnyHcb8CNzYb5+G2GwEQ99m/E7mmN5gZrk9
         yplA==
X-Gm-Message-State: AOAM531NlsKXqRTWM4P0F6FWzAx1+9i2DEK8uh/O7+7dmJhMagxGBAKU
        e40HS8mfJA9yQVdI0ZY3PGWF3HEPgE4T+3AfLEV0zV/IVvb4Hk6IKR/hqVLInnH/Op+w4E7MlSN
        Lm7L2kfykxLAu
X-Received: by 2002:a50:ba84:: with SMTP id x4mr1815017ede.376.1631174206267;
        Thu, 09 Sep 2021 00:56:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkGYsx/RAY6AzwtOPUUyAvV/De1R1elKEVvSfqgLm+6tIk6nO17neKE2kawODlb+X6rzkAMw==
X-Received: by 2002:a50:ba84:: with SMTP id x4mr1814997ede.376.1631174205988;
        Thu, 09 Sep 2021 00:56:45 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id x9sm596593edj.95.2021.09.09.00.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 00:56:45 -0700 (PDT)
Date:   Thu, 9 Sep 2021 09:56:43 +0200
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
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
Message-ID: <20210909075643.fhngqu6tqrpe33gl@gator>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-10-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909013818.1191270-10-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 01:38:09AM +0000, Raghavendra Rao Ananta wrote:
> At times, such as when in the interrupt handler, the guest wants
> to get the vcpuid that it's running on. As a result, introduce
> get_vcpuid() that returns the vcpuid of the calling vcpu. At its
> backend, the VMM prepares a map of vcpuid and mpidr during VM
> initialization and exports the map to the guest for it to read.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h |  3 ++
>  .../selftests/kvm/lib/aarch64/processor.c     | 46 +++++++++++++++++++
>  2 files changed, 49 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index b6088c3c67a3..150f63101f4c 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -133,6 +133,7 @@ void vm_install_exception_handler(struct kvm_vm *vm,
>  		int vector, handler_fn handler);
>  void vm_install_sync_handler(struct kvm_vm *vm,
>  		int vector, int ec, handler_fn handler);
> +void vm_vcpuid_map_init(struct kvm_vm *vm);
>  
>  static inline void cpu_relax(void)
>  {
> @@ -194,4 +195,6 @@ static inline void local_irq_disable(void)
>  	asm volatile("msr daifset, #3" : : : "memory");
>  }
>  
> +int get_vcpuid(void);
> +
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 632b74d6b3ca..9844b62227b1 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -13,9 +13,17 @@
>  #include "processor.h"
>  
>  #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN	0xac0000
> +#define VM_VCPUID_MAP_INVAL			-1
>  
>  static vm_vaddr_t exception_handlers;
>  
> +struct vm_vcpuid_map {
> +	uint64_t mpidr;
> +	int vcpuid;
> +};

I'd prefer we create an arch neutral map structure that has arch specific
vm_vcpuid_map_add() functions to populate them. So, instead of calling the
'mpidr' member mpidr, we should call it 'cpuid'. On x86, for example,
cpuid would be the APIC ID.

> +
> +static struct vm_vcpuid_map vcpuid_map[KVM_MAX_VCPUS];
> +
>  static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
>  {
>  	return (v + vm->page_size) & ~(vm->page_size - 1);
> @@ -426,3 +434,41 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
>  	assert(vector < VECTOR_NUM);
>  	handlers->exception_handlers[vector][0] = handler;
>  }
> +
> +void vm_vcpuid_map_init(struct kvm_vm *vm)
> +{
> +	int i = 0;
> +	struct vcpu *vcpu;
> +	struct vm_vcpuid_map *map;
> +
> +	list_for_each_entry(vcpu, &vm->vcpus, list) {
> +		map = &vcpuid_map[i++];
> +		map->vcpuid = vcpu->id;
> +		get_reg(vm, vcpu->id,
> +			ARM64_SYS_KVM_REG(SYS_MPIDR_EL1), &map->mpidr);
> +		map->mpidr &= MPIDR_HWID_BITMASK;
> +	}

Here we should assert that i is no longer zero. If it is, then we should
complain that vcpus need to be added before this call is made.

But, rather than providing an init function that inits the whole map
after all vcpus are created, I think we should add each vcpu's map entry
as we add vcpus to the vm. So we need to call the arch-specific
vm_vcpuid_map_add() from vm_vcpu_add(). We can just create stubs
for x86 and s390 for now. Also, in vm_vcpu_rm() we should find the
corresponding entry in the vcpuid map and set it to VM_VCPUID_MAP_INVAL
in order to remove it.

> +
> +	if (i < KVM_MAX_VCPUS)
> +		vcpuid_map[i].vcpuid = VM_VCPUID_MAP_INVAL;
> +
> +	sync_global_to_guest(vm, vcpuid_map);

We can't do this synch part for the test code at vcpu add time since we
don't know if the guest page tables are ready. I think it's OK to require
the test code to do this when the guest code needs it though. We should
document that requirement above the vm_vcpuid_map struct declaration,
which will be in kvm_util.h.

> +}
> +
> +int get_vcpuid(void)
> +{
> +	int i, vcpuid;
> +	uint64_t mpidr = read_sysreg(mpidr_el1) & MPIDR_HWID_BITMASK;
> +
> +	for (i = 0; i < KVM_MAX_VCPUS; i++) {
> +		vcpuid = vcpuid_map[i].vcpuid;
> +		GUEST_ASSERT_1(vcpuid != VM_VCPUID_MAP_INVAL, mpidr);

We don't want this assert if it's possible to have sparse maps, which
it probably isn't ever going to be, but...

> +
> +		if (mpidr == vcpuid_map[i].mpidr)
> +			return vcpuid;
> +	}
> +
> +	/* We should not be reaching here */
> +	GUEST_ASSERT_1(0, mpidr);

...this assert should be good enough to sanity check the map by itself
anyway.

Also, the only arch-specific aspect of get_vcpuid() is the looking up
the cpuid. So we should make get_vcpuid arch-neutral and call an arch-
specific get_cpuid() from it.

> +	return -1;
> +}
> -- 
> 2.33.0.153.gba50c8fa24-goog
>

Thanks,
drew 


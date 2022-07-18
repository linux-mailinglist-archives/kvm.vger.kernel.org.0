Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E94C5789A6
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 20:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbiGRSkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 14:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiGRSkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 14:40:13 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE0F2CDF7
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 11:40:11 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v16so18306927wrd.13
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 11:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vOTJ/lOx9mo2l0Gz+DyY71rr5IPjlKh/vGfexlPa874=;
        b=aAUR32Vi33B2hsq115RzuvLz/D7BjNUvxtVUSii/FBxfRLg9mPQlqH9J/50pGs78cH
         ZTb0xdBzMzYsUotLjxMs3x9/2xroeTmLJP8jxDcFlQLHW0bY6FCMgkU0e6NTqfWAZbgA
         qY6iZQUJRazqJe1QD5BpUzFkJqdKS28BzeLdFCDp4yuOTPx87VISpNrVJGfKOJ7yGux9
         CGOXRrJ/KfFPBCyBtDb+3APpoNYOBoMwTqb/JPLmS14Lmk7d87FZGlr8JSHhirPHMvvk
         5zHBcR/+T8xebXco7mLZGlUGu26l4rALZVHOu+X0NDcE3N6NOx/00nwBjDZISKyklI6o
         JhSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vOTJ/lOx9mo2l0Gz+DyY71rr5IPjlKh/vGfexlPa874=;
        b=iJlebuMPPyBd+nf4O9qyZUOyHAsTm1eQ9xKRvB8DIEkFUJbbT0KpcdSN9E+vX4YuwQ
         Iym8AGp0npwnk8ujgfhfqKMvSzSj+h9MA53U1s8irPFC1/UvHr0wB5EPlVSpjCN+laKk
         l/ecX2Qk9lFp8uSB525Wmc/ek2ZAoTWtUxsQWHxiw7PRB/gLPQ9Mk6mBkidjtNzuqCXg
         s/IyZVsrDKFwsha56U4qmaZjvsxoSg0yXVUoWW7S9qfL/1mOLMND4nfwIBh8sclZuilo
         vz9Z7sBo1TvgdHvPTMUbo0jBfEe8Rrm8HsSB6n5zMS7F8E+fehxSRhXBigSiVkPPt8NA
         5quw==
X-Gm-Message-State: AJIora9UhCnKlg0wLIBe+bJZ1eJzk/+U5le+yUIBFANy8Ob8XJyDgap1
        IrMo5aQy6CyHaBiN46Gzuu0kkA==
X-Google-Smtp-Source: AGRyM1u0er/ihy9AUSKP+mIbbum/WRRNpoD31ruQt0QF6/la8uKPSIA+5jiz0p3FIioRmUsfqeY6hg==
X-Received: by 2002:a5d:6c6b:0:b0:1ea:77ea:dde8 with SMTP id r11-20020a5d6c6b000000b001ea77eadde8mr24293592wrz.690.1658169610335;
        Mon, 18 Jul 2022 11:40:10 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id y11-20020adfc7cb000000b0021d6924b777sm11977778wrg.115.2022.07.18.11.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 11:40:09 -0700 (PDT)
Date:   Mon, 18 Jul 2022 19:40:05 +0100
From:   Vincent Donnefort <vdonnefort@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 12/24] KVM: arm64: Introduce shadow VM state at EL2
Message-ID: <YtWpBYPrBcdyp9r6@google.com>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-13-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630135747.26983-13-will@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[...]

> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 9f339dffbc1a..2d6b5058f7d3 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -288,6 +288,14 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
>   */
>  u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
>  
> +/*

/** ?

> + * kvm_pgtable_stage2_pgd_size() - Helper to compute size of a stage-2 PGD
> + * @vtcr:	Content of the VTCR register.
> + *
> + * Return: the size (in bytes) of the stage-2 PGD
> + */
> +size_t kvm_pgtable_stage2_pgd_size(u64 vtcr);
> +
>  /**
>   * __kvm_pgtable_stage2_init() - Initialise a guest stage-2 page-table.
>   * @pgt:	Uninitialised page-table structure to initialise.
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index 8f7b8a2314bb..11526e89fe5c 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -9,6 +9,9 @@
>  #include <linux/memblock.h>
>  #include <asm/kvm_pgtable.h>
>  
> +/* Maximum number of protected VMs that can be created. */
> +#define KVM_MAX_PVMS 255
> +
>  #define HYP_MEMBLOCK_REGIONS 128
>  
>  extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
> @@ -40,6 +43,11 @@ static inline unsigned long hyp_vmemmap_pages(size_t vmemmap_entry_size)
>  	return res >> PAGE_SHIFT;
>  }
>  
> +static inline unsigned long hyp_shadow_table_pages(void)
> +{
> +	return PAGE_ALIGN(KVM_MAX_PVMS * sizeof(void *)) >> PAGE_SHIFT;
> +}
> +
>  static inline unsigned long __hyp_pgtable_max_pages(unsigned long nr_pages)
>  {
>  	unsigned long total = 0, i;
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 3bea816296dc..3a0817b5c739 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -11,6 +11,7 @@
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_pgtable.h>
>  #include <asm/virt.h>
> +#include <nvhe/pkvm.h>
>  #include <nvhe/spinlock.h>
>  
>  /*
> @@ -68,10 +69,12 @@ bool addr_is_memory(phys_addr_t phys);
>  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
>  int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
>  int kvm_host_prepare_stage2(void *pgt_pool_base);
> +int kvm_guest_prepare_stage2(struct kvm_shadow_vm *vm, void *pgd);
>  void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
>  
>  int hyp_pin_shared_mem(void *from, void *to);
>  void hyp_unpin_shared_mem(void *from, void *to);
> +void reclaim_guest_pages(struct kvm_shadow_vm *vm);
>  
>  static __always_inline void __load_host_stage2(void)
>  {
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> new file mode 100644
> index 000000000000..1d0a33f70879
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -0,0 +1,60 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2021 Google LLC
> + * Author: Fuad Tabba <tabba@google.com>
> + */
> +
> +#ifndef __ARM64_KVM_NVHE_PKVM_H__
> +#define __ARM64_KVM_NVHE_PKVM_H__
> +
> +#include <asm/kvm_pkvm.h>
> +
> +/*
> + * Holds the relevant data for maintaining the vcpu state completely at hyp.
> + */
> +struct kvm_shadow_vcpu_state {
> +	/* The data for the shadow vcpu. */
> +	struct kvm_vcpu shadow_vcpu;
> +
> +	/* A pointer to the host's vcpu. */
> +	struct kvm_vcpu *host_vcpu;
> +
> +	/* A pointer to the shadow vm. */
> +	struct kvm_shadow_vm *shadow_vm;

IMHO, those declarations are already self-explanatory. The comments above don't
bring much.

> +};
> +
> +/*
> + * Holds the relevant data for running a protected vm.
> + */
> +struct kvm_shadow_vm {
> +	/* The data for the shadow kvm. */
> +	struct kvm kvm;
> +
> +	/* The host's kvm structure. */
> +	struct kvm *host_kvm;
> +
> +	/* The total size of the donated shadow area. */
> +	size_t shadow_area_size;
> +
> +	struct kvm_pgtable pgt;
> +
> +	/* Array of the shadow state per vcpu. */
> +	struct kvm_shadow_vcpu_state shadow_vcpu_states[0];
> +};
> +
> +static inline struct kvm_shadow_vcpu_state *get_shadow_state(struct kvm_vcpu *shadow_vcpu)
> +{
> +	return container_of(shadow_vcpu, struct kvm_shadow_vcpu_state, shadow_vcpu);
> +}
> +
> +static inline struct kvm_shadow_vm *get_shadow_vm(struct kvm_vcpu *shadow_vcpu)
> +{
> +	return get_shadow_state(shadow_vcpu)->shadow_vm;
> +}
> +
> +void hyp_shadow_table_init(void *tbl);
> +int __pkvm_init_shadow(struct kvm *kvm, unsigned long shadow_hva,
> +		       size_t shadow_size, unsigned long pgd_hva);
> +int __pkvm_teardown_shadow(unsigned int shadow_handle);
> +
> +#endif /* __ARM64_KVM_NVHE_PKVM_H__ */
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 3cea4b6ac23e..a1fbd11c8041 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -15,6 +15,7 @@
>  
>  #include <nvhe/mem_protect.h>
>  #include <nvhe/mm.h>
> +#include <nvhe/pkvm.h>
>  #include <nvhe/trap_handler.h>
>  
>  DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
> @@ -191,6 +192,24 @@ static void handle___pkvm_vcpu_init_traps(struct kvm_cpu_context *host_ctxt)
>  	__pkvm_vcpu_init_traps(kern_hyp_va(vcpu));
>  }
>  
> +static void handle___pkvm_init_shadow(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(struct kvm *, host_kvm, host_ctxt, 1);
> +	DECLARE_REG(unsigned long, host_shadow_va, host_ctxt, 2);
> +	DECLARE_REG(size_t, shadow_size, host_ctxt, 3);
> +	DECLARE_REG(unsigned long, pgd, host_ctxt, 4);
> +
> +	cpu_reg(host_ctxt, 1) = __pkvm_init_shadow(host_kvm, host_shadow_va,
> +						   shadow_size, pgd);
> +}
> +
> +static void handle___pkvm_teardown_shadow(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(unsigned int, shadow_handle, host_ctxt, 1);
> +
> +	cpu_reg(host_ctxt, 1) = __pkvm_teardown_shadow(shadow_handle);
> +}
> +
>  typedef void (*hcall_t)(struct kvm_cpu_context *);
>  
>  #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
> @@ -220,6 +239,8 @@ static const hcall_t host_hcall[] = {
>  	HANDLE_FUNC(__vgic_v3_save_aprs),
>  	HANDLE_FUNC(__vgic_v3_restore_aprs),
>  	HANDLE_FUNC(__pkvm_vcpu_init_traps),
> +	HANDLE_FUNC(__pkvm_init_shadow),
> +	HANDLE_FUNC(__pkvm_teardown_shadow),
>  };
>  
>  static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index e2e3b30b072e..9baf731736be 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -141,6 +141,20 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
>  	return 0;
>  }
>  
> +int kvm_guest_prepare_stage2(struct kvm_shadow_vm *vm, void *pgd)
> +{
> +	vm->pgt.pgd = pgd;
> +	return 0;
> +}
> +
> +void reclaim_guest_pages(struct kvm_shadow_vm *vm)
> +{
> +	unsigned long nr_pages;
> +
> +	nr_pages = kvm_pgtable_stage2_pgd_size(vm->kvm.arch.vtcr) >> PAGE_SHIFT;
> +	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(vm->pgt.pgd), nr_pages));
> +}
> +
>  int __pkvm_prot_finalize(void)
>  {
>  	struct kvm_s2_mmu *mmu = &host_kvm.arch.mmu;
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 99c8d8b73e70..77aeb787670b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -7,6 +7,9 @@
>  #include <linux/kvm_host.h>
>  #include <linux/mm.h>
>  #include <nvhe/fixed_config.h>
> +#include <nvhe/mem_protect.h>
> +#include <nvhe/memory.h>

I don't think this one is necessary, it is already included in mm.h.

> +#include <nvhe/pkvm.h>
>  #include <nvhe/trap_handler.h>
>  
>  /*
> @@ -183,3 +186,398 @@ void __pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
>  	pvm_init_traps_aa64mmfr0(vcpu);
>  	pvm_init_traps_aa64mmfr1(vcpu);
>  }
> +
> +/*
> + * Start the shadow table handle at the offset defined instead of at 0.
> + * Mainly for sanity checking and debugging.
> + */
> +#define HANDLE_OFFSET 0x1000
> +
> +static unsigned int shadow_handle_to_idx(unsigned int shadow_handle)
> +{
> +	return shadow_handle - HANDLE_OFFSET;
> +}
> +
> +static unsigned int idx_to_shadow_handle(unsigned int idx)
> +{
> +	return idx + HANDLE_OFFSET;
> +}
> +
> +/*
> + * Spinlock for protecting the shadow table related state.
> + * Protects writes to shadow_table, nr_shadow_entries, and next_shadow_alloc,
> + * as well as reads and writes to last_shadow_vcpu_lookup.
> + */
> +static DEFINE_HYP_SPINLOCK(shadow_lock);
> +
> +/*
> + * The table of shadow entries for protected VMs in hyp.
> + * Allocated at hyp initialization and setup.
> + */
> +static struct kvm_shadow_vm **shadow_table;
> +
> +/* Current number of vms in the shadow table. */
> +static unsigned int nr_shadow_entries;
> +
> +/* The next entry index to try to allocate from. */
> +static unsigned int next_shadow_alloc;
> +
> +void hyp_shadow_table_init(void *tbl)
> +{
> +	WARN_ON(shadow_table);
> +	shadow_table = tbl;
> +}
> +
> +/*
> + * Return the shadow vm corresponding to the handle.
> + */
> +static struct kvm_shadow_vm *find_shadow_by_handle(unsigned int shadow_handle)
> +{
> +	unsigned int shadow_idx = shadow_handle_to_idx(shadow_handle);
> +
> +	if (unlikely(shadow_idx >= KVM_MAX_PVMS))
> +		return NULL;
> +
> +	return shadow_table[shadow_idx];
> +}
> +
> +static void unpin_host_vcpus(struct kvm_shadow_vcpu_state *shadow_vcpu_states,
> +			     unsigned int nr_vcpus)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_vcpus; i++) {
> +		struct kvm_vcpu *host_vcpu = shadow_vcpu_states[i].host_vcpu;

IIRC, checkpatch likes an empty line after declarations.

> +		hyp_unpin_shared_mem(host_vcpu, host_vcpu + 1);
> +	}
> +}
> +
> +static int set_host_vcpus(struct kvm_shadow_vcpu_state *shadow_vcpu_states,
> +			  unsigned int nr_vcpus,
> +			  struct kvm_vcpu **vcpu_array,
> +			  size_t vcpu_array_size)
> +{
> +	int i;
> +
> +	if (vcpu_array_size < sizeof(*vcpu_array) * nr_vcpus)
> +		return -EINVAL;
> +
> +	for (i = 0; i < nr_vcpus; i++) {
> +		struct kvm_vcpu *host_vcpu = kern_hyp_va(vcpu_array[i]);
> +
> +		if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1)) {
> +			unpin_host_vcpus(shadow_vcpu_states, i);
> +			return -EBUSY;
> +		}
> +
> +		shadow_vcpu_states[i].host_vcpu = host_vcpu;
> +	}
> +
> +	return 0;
> +}
> +
> +static int init_shadow_structs(struct kvm *kvm, struct kvm_shadow_vm *vm,
> +			       struct kvm_vcpu **vcpu_array,
> +			       unsigned int nr_vcpus)
> +{
> +	int i;
> +
> +	vm->host_kvm = kvm;
> +	vm->kvm.created_vcpus = nr_vcpus;
> +	vm->kvm.arch.vtcr = host_kvm.arch.vtcr;
> +
> +	for (i = 0; i < nr_vcpus; i++) {
> +		struct kvm_shadow_vcpu_state *shadow_vcpu_state = &vm->shadow_vcpu_states[i];
> +		struct kvm_vcpu *shadow_vcpu = &shadow_vcpu_state->shadow_vcpu;
> +		struct kvm_vcpu *host_vcpu = shadow_vcpu_state->host_vcpu;
> +
> +		shadow_vcpu_state->shadow_vm = vm;
> +
> +		shadow_vcpu->kvm = &vm->kvm;
> +		shadow_vcpu->vcpu_id = READ_ONCE(host_vcpu->vcpu_id);
> +		shadow_vcpu->vcpu_idx = i;
> +
> +		shadow_vcpu->arch.hw_mmu = &vm->kvm.arch.mmu;

In the end, we don't seem to use much from the struct kvm_cpu. Is it for
convinience that a smaller struct kvm_shadow_cpu hasn't been created, or we do
anticipate a later wider usage?

> +	}
> +
> +	return 0;
> +}
> +
> +static bool __exists_shadow(struct kvm *host_kvm)
> +{
> +	int i;
> +	unsigned int nr_checked = 0;
> +
> +	for (i = 0; i < KVM_MAX_PVMS && nr_checked < nr_shadow_entries; i++) {
> +		if (!shadow_table[i])
> +			continue;
> +
> +		if (unlikely(shadow_table[i]->host_kvm == host_kvm))
> +			return true;
> +
> +		nr_checked++;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Allocate a shadow table entry and insert a pointer to the shadow vm.
> + *
> + * Return a unique handle to the protected VM on success,
> + * negative error code on failure.
> + */
> +static unsigned int insert_shadow_table(struct kvm *kvm,
> +					struct kvm_shadow_vm *vm,
> +					size_t shadow_size)
> +{
> +	struct kvm_s2_mmu *mmu = &vm->kvm.arch.mmu;
> +	unsigned int shadow_handle;
> +	unsigned int vmid;
> +
> +	hyp_assert_lock_held(&shadow_lock);
> +
> +	if (unlikely(nr_shadow_entries >= KVM_MAX_PVMS))
> +		return -ENOMEM;
> +
> +	/*
> +	 * Initializing protected state might have failed, yet a malicious host
> +	 * could trigger this function. Thus, ensure that shadow_table exists.
> +	 */
> +	if (unlikely(!shadow_table))
> +		return -EINVAL;
> +
> +	/* Check that a shadow hasn't been created before for this host KVM. */
> +	if (unlikely(__exists_shadow(kvm)))
> +		return -EEXIST;
> +
> +	/* Find the next free entry in the shadow table. */
> +	while (shadow_table[next_shadow_alloc])
> +		next_shadow_alloc = (next_shadow_alloc + 1) % KVM_MAX_PVMS;

Couldn't it be merged with __exists_shadow which already knows the first free
shadow_table idx?

> +	shadow_handle = idx_to_shadow_handle(next_shadow_alloc);
> +
> +	vm->kvm.arch.pkvm.shadow_handle = shadow_handle;
> +	vm->shadow_area_size = shadow_size;
> +
> +	/* VMID 0 is reserved for the host */
> +	vmid = next_shadow_alloc + 1;
> +	if (vmid > 0xff)

Couldn't the 0xff be found with get_vmid_bits() or even from host_kvm.arch.vtcr?
Or does that depends on something completely different?

Also, appologies if this has been discussed already and I missed it, maybe
KVM_MAX_PVMS could be changed for that value - 1. Unless we think that archs
supporting 16 bits would waste way too much memory for that?

> +		return -ENOMEM;
> +
> +	atomic64_set(&mmu->vmid.id, vmid);
> +	mmu->arch = &vm->kvm.arch;
> +	mmu->pgt = &vm->pgt;
> +
> +	shadow_table[next_shadow_alloc] = vm;
> +	next_shadow_alloc = (next_shadow_alloc + 1) % KVM_MAX_PVMS;
> +	nr_shadow_entries++;
> +
> +	return shadow_handle;
> +}
> +

[...]

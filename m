Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33872FE124
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 05:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731546AbhAUDxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 22:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731271AbhAUDAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 22:00:17 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24668C0613C1
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 18:59:26 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id q1so1212238ion.8
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 18:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qz8ZjLOShljMc95QkDXlls/h7vHkfwkdKWmbz+iSbrQ=;
        b=SA+uipEQZkXChdqljPRyaEWbIAjOTQH7eiz4MkKaPH0ANiyfnl2vkPyxY5Y3DV5FKu
         Mb4fPegdpoUwSv8+H+cW/o3ZzQlZTQ0q0K/xf23qLfgm5qOCGEMgX+gRkzzgZ2yOT0RN
         nReC7MgNVEOZxrvwcKRCoXYluWPpmDt+RwqQvjQiN09hrUYtD23c4Eo7X0iASHlfTqfu
         RPZp5fNv2PRU9WxYegyInlctggnYTUPLODVWVmaGKuPmEwR7eC08KUXdTBxyiLvZGwZR
         W8/Gq5ESSwqCPTJ4cTNl8lE9iLBwIrhblvJWPsMEWRqo4k8AILpV3j4nPnGQBWiMPlWq
         zdQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qz8ZjLOShljMc95QkDXlls/h7vHkfwkdKWmbz+iSbrQ=;
        b=BEUMzGmx6sCj5UhVD4fyzTaYXtcyWO3APi8v73IetCWlTGPiu6z6xTYTLlcjtf/COM
         fDOZEjT4DG2P0AFSVMaafB9zdtiXCi2FMfqZMCx+GKULXOq6BuBOOuP4ggOElylAAFj7
         j+szIfpb8HnN9JWDR2lx3AB9YhNx9pOm9snPm95WobFbNkyQCJZkqJICPrSvhyDw+mYH
         tI1Tx6/ZC/tP6Ky5QgGoZ59uIK6hJO7oNQQg1AnjFmrBHEDkdd1RYr7QNapIAsO1gkaQ
         To7ha4BVfmK3LZLa9vuoEfPvelFr/tm+I9oNXHRk4fW2pisGB2E2fnYV0I8g5zzS3L/K
         mUHg==
X-Gm-Message-State: AOAM530aX7ntCspu1dRkLl8Qb9IOQ8rtfkBE6bnrmQ6LQp/AjSa73AJQ
        ZN8eEefIMxTIEhqxrZGOke7bwk4qA4ksp/E9x6PC
X-Google-Smtp-Source: ABdhPJy4NKuGap+Qu3E2Ud1tLAbJPfqdhwLKexUnV2Hhm81czqtpLSglmsUTncsgsFDR5zBP7yiCafFNJW/ZK4CSZFY=
X-Received: by 2002:a6b:7e02:: with SMTP id i2mr8970870iom.185.1611197965405;
 Wed, 20 Jan 2021 18:59:25 -0800 (PST)
MIME-Version: 1.0
References: <20201210160002.1407373-1-maz@kernel.org> <20201210160002.1407373-34-maz@kernel.org>
In-Reply-To: <20201210160002.1407373-34-maz@kernel.org>
From:   Haibo Xu <haibo.xu@linaro.org>
Date:   Thu, 21 Jan 2021 10:59:13 +0800
Message-ID: <CAJc+Z1F5rvhWkWzbi2JrfSaETUg_qxiiLBVhrVcw7Da5=Yo2GQ@mail.gmail.com>
Subject: Re: [PATCH v3 33/66] KVM: arm64: nv: Support multiple nested Stage-2
 mmu structures
To:     Marc Zyngier <maz@kernel.org>
Cc:     arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>, kvm@vger.kernel.org,
        kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Dec 2020 at 00:04, Marc Zyngier <maz@kernel.org> wrote:
>
> Add Stage-2 mmu data structures for virtual EL2 and for nested guests.
> We don't yet populate shadow Stage-2 page tables, but we now have a
> framework for getting to a shadow Stage-2 pgd.
>
> We allocate twice the number of vcpus as Stage-2 mmu structures because
> that's sufficient for each vcpu running two translation regimes without
> having to flush the Stage-2 page tables.
>
> Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h   |  29 +++++
>  arch/arm64/include/asm/kvm_mmu.h    |   8 ++
>  arch/arm64/include/asm/kvm_nested.h |   7 ++
>  arch/arm64/kvm/arm.c                |  16 ++-
>  arch/arm64/kvm/mmu.c                |  18 ++-
>  arch/arm64/kvm/nested.c             | 183 ++++++++++++++++++++++++++++
>  6 files changed, 250 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index d731cf7a56cb..d99e51e7cbee 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -95,14 +95,43 @@ struct kvm_s2_mmu {
>         int __percpu *last_vcpu_ran;
>
>         struct kvm *kvm;
> +
> +       /*
> +        * For a shadow stage-2 MMU, the virtual vttbr programmed by the guest
> +        * hypervisor.  Unused for kvm_arch->mmu. Set to 1 when the structure
> +        * contains no valid information.
> +        */
> +       u64     vttbr;
> +
> +       /* true when this represents a nested context where virtual HCR_EL2.VM == 1 */
> +       bool    nested_stage2_enabled;
> +
> +       /*
> +        *  0: Nobody is currently using this, check vttbr for validity
> +        * >0: Somebody is actively using this.
> +        */
> +       atomic_t refcnt;
>  };
>
> +static inline bool kvm_s2_mmu_valid(struct kvm_s2_mmu *mmu)
> +{
> +       return !(mmu->vttbr & 1);
> +}
> +
>  struct kvm_arch_memory_slot {
>  };
>
>  struct kvm_arch {
>         struct kvm_s2_mmu mmu;
>
> +       /*
> +        * Stage 2 paging stage for VMs with nested virtual using a virtual
> +        * VMID.
> +        */
> +       struct kvm_s2_mmu *nested_mmus;
> +       size_t nested_mmus_size;
> +       int nested_mmus_next;
> +
>         /* VTCR_EL2 value for this VM */
>         u64    vtcr;
>
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 76a8a0ca45b8..ec39015bb2a6 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -126,6 +126,7 @@ alternative_cb_end
>  #include <asm/cacheflush.h>
>  #include <asm/mmu_context.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_nested.h>
>
>  void kvm_update_va_mask(struct alt_instr *alt,
>                         __le32 *origptr, __le32 *updptr, int nr_inst);
> @@ -184,6 +185,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>                              void **haddr);
>  void free_hyp_pgds(void);
>
> +void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
>  void stage2_unmap_vm(struct kvm *kvm);
>  int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu);
>  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
> @@ -306,5 +308,11 @@ static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
>         asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
>  }
>
> +static inline u64 get_vmid(u64 vttbr)
> +{
> +       return (vttbr & VTTBR_VMID_MASK(kvm_get_vmid_bits())) >>
> +               VTTBR_VMID_SHIFT;
> +}
> +
>  #endif /* __ASSEMBLY__ */
>  #endif /* __ARM64_KVM_MMU_H__ */
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 026ddaad972c..473ecd1d60d0 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -61,6 +61,13 @@ static inline u64 translate_cnthctl_el2_to_cntkctl_el1(u64 cnthctl)
>                 (cnthctl & (CNTHCTL_EVNTI | CNTHCTL_EVNTDIR | CNTHCTL_EVNTEN)));
>  }
>
> +extern void kvm_init_nested(struct kvm *kvm);
> +extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
> +extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
> +extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr);
> +extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
> +extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
> +
>  int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
>  extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
>                             u64 control_bit);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 6e637d2b4cfb..1656dd80bbc4 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -35,6 +35,7 @@
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_nested.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/sections.h>
>
> @@ -142,6 +143,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>         if (ret)
>                 return ret;
>
> +       kvm_init_nested(kvm);
> +
>         ret = create_hyp_mappings(kvm, kvm + 1, PAGE_HYP);
>         if (ret)
>                 goto out_free_stage2_pgd;
> @@ -385,6 +388,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>         struct kvm_s2_mmu *mmu;
>         int *last_ran;
>
> +       if (nested_virt_in_use(vcpu))
> +               kvm_vcpu_load_hw_mmu(vcpu);
> +
>         mmu = vcpu->arch.hw_mmu;
>         last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
>
> @@ -426,6 +432,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>         kvm_vgic_put(vcpu);
>         kvm_vcpu_pmu_restore_host(vcpu);
>
> +       if (nested_virt_in_use(vcpu))
> +               kvm_vcpu_put_hw_mmu(vcpu);
> +
>         vcpu->cpu = -1;
>  }
>
> @@ -1026,8 +1035,13 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>
>         vcpu->arch.target = phys_target;
>
> +       /* Prepare for nested if required */
> +       ret = kvm_vcpu_init_nested(vcpu);
> +
>         /* Now we know what it is, we can reset it. */
> -       ret = kvm_reset_vcpu(vcpu);
> +       if (!ret)
> +               ret = kvm_reset_vcpu(vcpu);
> +
>         if (ret) {
>                 vcpu->arch.target = -1;
>                 bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1f41173e6149..2f0302211af3 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -113,7 +113,7 @@ static bool kvm_is_device_pfn(unsigned long pfn)
>   * does.
>   */
>  /**
> - * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
> + * kvm_unmap_stage2_range -- Clear stage2 page table entries to unmap a range
>   * @mmu:   The KVM stage-2 MMU pointer
>   * @start: The intermediate physical base address of the range to unmap
>   * @size:  The size of the area to unmap
> @@ -136,7 +136,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>                                    may_block));
>  }
>
> -static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
> +void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
>  {
>         __unmap_stage2_range(mmu, start, size, true);
>  }
> @@ -391,6 +391,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>         mmu->pgt = pgt;
>         mmu->pgd_phys = __pa(pgt->pgd);
>         mmu->vmid.vmid_gen = 0;
> +
> +       kvm_init_nested_s2_mmu(mmu);
> +
>         return 0;
>
>  out_destroy_pgtable:
> @@ -435,7 +438,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
>
>                 if (!(vma->vm_flags & VM_PFNMAP)) {
>                         gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
> -                       unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
> +                       kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
>                 }
>                 hva = vm_end;
>         } while (hva < reg_end);
> @@ -1360,7 +1363,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>
>         spin_lock(&kvm->mmu_lock);
>         if (ret)
> -               unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr, mem->memory_size);
> +               kvm_unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr, mem->memory_size);
>         else if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
>                 stage2_flush_memslot(kvm, memslot);
>         spin_unlock(&kvm->mmu_lock);
> @@ -1377,11 +1380,6 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
>  {
>  }
>
> -void kvm_arch_flush_shadow_all(struct kvm *kvm)
> -{
> -       kvm_free_stage2_pgd(&kvm->arch.mmu);
> -}
> -
>  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>                                    struct kvm_memory_slot *slot)
>  {
> @@ -1389,7 +1387,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>         phys_addr_t size = slot->npages << PAGE_SHIFT;
>
>         spin_lock(&kvm->mmu_lock);
> -       unmap_stage2_range(&kvm->arch.mmu, gpa, size);
> +       kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
>         spin_unlock(&kvm->mmu_lock);
>  }
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 9fb44bc7db3f..8e85d2ef24d9 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -19,12 +19,177 @@
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>
> +#include <asm/kvm_arm.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
>  #include <asm/kvm_nested.h>
>  #include <asm/sysreg.h>
>
>  #include "sys_regs.h"
>
> +void kvm_init_nested(struct kvm *kvm)
> +{
> +       kvm->arch.nested_mmus = NULL;
> +       kvm->arch.nested_mmus_size = 0;
> +}
> +
> +int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm *kvm = vcpu->kvm;
> +       struct kvm_s2_mmu *tmp;
> +       int num_mmus;
> +       int ret = -ENOMEM;
> +
> +       if (!test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features))
> +               return 0;
> +
> +       if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
> +               return -EINVAL;

nit: returning a "not supported" kind of errno?

> +
> +       mutex_lock(&kvm->lock);
> +
> +       /*
> +        * Let's treat memory allocation failures as benign: If we fail to
> +        * allocate anything, return an error and keep the allocated array
> +        * alive. Userspace may try to recover by intializing the vcpu
> +        * again, and there is no reason to affect the whole VM for this.
> +        */
> +       num_mmus = atomic_read(&kvm->online_vcpus) * 2;
> +       tmp = krealloc(kvm->arch.nested_mmus,
> +                      num_mmus * sizeof(*kvm->arch.nested_mmus),
> +                      GFP_KERNEL | __GFP_ZERO);
> +       if (tmp) {
> +               if (kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 1]) ||
> +                   kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2])) {
> +                       kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
> +                       kvm_free_stage2_pgd(&tmp[num_mmus - 2]);
> +               } else {
> +                       kvm->arch.nested_mmus_size = num_mmus;
> +                       ret = 0;
> +               }
> +
> +               kvm->arch.nested_mmus = tmp;
> +       }
> +
> +       mutex_unlock(&kvm->lock);
> +       return ret;
> +}
> +
> +/* Must be called with kvm->lock held */
> +struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr)
> +{
> +       bool nested_stage2_enabled = hcr & HCR_VM;
> +       int i;
> +
> +       /* Don't consider the CnP bit for the vttbr match */
> +       vttbr = vttbr & ~VTTBR_CNP_BIT;
> +
> +       /*
> +        * Two possibilities when looking up a S2 MMU context:
> +        *
> +        * - either S2 is enabled in the guest, and we need a context that
> +         *   is S2-enabled and matches the full VTTBR (VMID+BADDR), which
> +         *   makes it safe from a TLB conflict perspective (a broken guest
> +         *   won't be able to generate them),
> +        *
> +        * - or S2 is disabled, and we need a context that is S2-disabled
> +         *   and matches the VMID only, as all TLBs are tagged by VMID even
> +         *   if S2 translation is enabled.
> +        */
> +       for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +               struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +               if (!kvm_s2_mmu_valid(mmu))
> +                       continue;
> +
> +               if (nested_stage2_enabled &&
> +                   mmu->nested_stage2_enabled &&
> +                   vttbr == mmu->vttbr)
> +                       return mmu;
> +
> +               if (!nested_stage2_enabled &&
> +                   !mmu->nested_stage2_enabled &&
> +                   get_vmid(vttbr) == get_vmid(mmu->vttbr))
> +                       return mmu;
> +       }
> +       return NULL;
> +}
> +
> +static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm *kvm = vcpu->kvm;
> +       u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
> +       u64 hcr= vcpu_read_sys_reg(vcpu, HCR_EL2);
> +       struct kvm_s2_mmu *s2_mmu;
> +       int i;
> +
> +       s2_mmu = lookup_s2_mmu(kvm, vttbr, hcr);
> +       if (s2_mmu)
> +               goto out;
> +
> +       /*
> +        * Make sure we don't always search from the same point, or we
> +        * will always reuse a potentially active context, leaving
> +        * free contexts unused.
> +        */
> +       for (i = kvm->arch.nested_mmus_next;
> +            i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
> +            i++) {
> +               s2_mmu = &kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
> +
> +               if (atomic_read(&s2_mmu->refcnt) == 0)
> +                       break;
> +       }
> +       BUG_ON(atomic_read(&s2_mmu->refcnt)); /* We have struct MMUs to spare */
> +
> +       /* Set the scene for the next search */
> +       kvm->arch.nested_mmus_next = (i + 1) % kvm->arch.nested_mmus_size;
> +
> +       if (kvm_s2_mmu_valid(s2_mmu)) {
> +               /* Clear the old state */
> +               kvm_unmap_stage2_range(s2_mmu, 0, kvm_phys_size(kvm));
> +               if (s2_mmu->vmid.vmid_gen)
> +                       kvm_call_hyp(__kvm_tlb_flush_vmid, s2_mmu);
> +       }
> +
> +       /*
> +        * The virtual VMID (modulo CnP) will be used as a key when matching
> +        * an existing kvm_s2_mmu.
> +        */
> +       s2_mmu->vttbr = vttbr & ~VTTBR_CNP_BIT;
> +       s2_mmu->nested_stage2_enabled = hcr & HCR_VM;
> +
> +out:
> +       atomic_inc(&s2_mmu->refcnt);
> +       return s2_mmu;
> +}
> +
> +void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
> +{
> +       mmu->vttbr = 1;
> +       mmu->nested_stage2_enabled = false;
> +       atomic_set(&mmu->refcnt, 0);
> +}
> +
> +void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
> +{
> +       if (is_hyp_ctxt(vcpu)) {
> +               vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
> +       } else {
> +               spin_lock(&vcpu->kvm->mmu_lock);
> +               vcpu->arch.hw_mmu = get_s2_mmu_nested(vcpu);
> +               spin_unlock(&vcpu->kvm->mmu_lock);
> +       }
> +}
> +
> +void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
> +{
> +       if (vcpu->arch.hw_mmu != &vcpu->kvm->arch.mmu) {
> +               atomic_dec(&vcpu->arch.hw_mmu->refcnt);
> +               vcpu->arch.hw_mmu = NULL;
> +       }
> +}
> +
>  /*
>   * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
>   * the virtual HCR_EL2.TWX is set. Otherwise, let the host hypervisor
> @@ -43,6 +208,24 @@ int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
>         return -EINVAL;
>  }
>
> +void kvm_arch_flush_shadow_all(struct kvm *kvm)
> +{
> +       int i;
> +
> +       for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +               struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +               WARN_ON(atomic_read(&mmu->refcnt));
> +
> +               if (!atomic_read(&mmu->refcnt))
> +                       kvm_free_stage2_pgd(mmu);
> +       }
> +       kfree(kvm->arch.nested_mmus);
> +       kvm->arch.nested_mmus = NULL;
> +       kvm->arch.nested_mmus_size = 0;
> +       kvm_free_stage2_pgd(&kvm->arch.mmu);
> +}
> +
>  #define FEATURE(x)     (GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
>
>  /*
> --
> 2.29.2
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

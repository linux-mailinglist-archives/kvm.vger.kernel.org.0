Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEA4752FDE
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 05:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbjGNDTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 23:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjGNDTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 23:19:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88261119;
        Thu, 13 Jul 2023 20:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12FBC61BDF;
        Fri, 14 Jul 2023 03:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8F0C433D9;
        Fri, 14 Jul 2023 03:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689304758;
        bh=P0psRK+QOFDnuMph/ZrlunRH6to8AwgWMRPqn/8UI4k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=swRGIme3cBV2AHvc43I5bXml2pbxlaJew2kQexGlZ40jdhkEkw/Wb+60/qDYKCjhV
         ro1C45MgvoEQJ7/VjS7RJfOSNICiRaxt7/fgzzuBqewlU9TMeMTkcboXQ4sIVBDg+d
         Cgr7fcEYX86XOLmhpnHR75pmCRt8BS63YnvDbvf4+CzPlV0WtLFvmYe3jy7uAFLFy/
         KKG3YDV+appXUVAiwJftKPPuj49cyN5oKwik83bHGI/yY0A5tfInkAeNyYOkC53BKT
         6CQjlNW2dl3CElAHzURqKMMW/uaw7SVJyKyzFCWHFpmXZTZCVwtQCHlLm7SPmM4y/k
         ylRmtftME5dZA==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-992ace062f3so192577666b.2;
        Thu, 13 Jul 2023 20:19:18 -0700 (PDT)
X-Gm-Message-State: ABy/qLYuHBtkliTbZ0+kVeDe/3KcCh3MPIfpo+5Qec5Jsc9Gol08+Jju
        6ESUfq2oWTmSlvPyyfkPujb8nRzN0A1QzvAGyfQ=
X-Google-Smtp-Source: APBJJlFXNG7uxFyvIDLE4/HnCvyy8IQjDGtR7CUsWQo4Dv2nmL6TRPhoWmC2+QaeG7izNC1qptOcz6NPVGhQFl3xrjA=
X-Received: by 2002:a50:fb06:0:b0:51e:2a56:91d6 with SMTP id
 d6-20020a50fb06000000b0051e2a5691d6mr3201948edq.19.1689304756330; Thu, 13 Jul
 2023 20:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230629075538.4063701-1-zhaotianrui@loongson.cn> <20230629075538.4063701-20-zhaotianrui@loongson.cn>
In-Reply-To: <20230629075538.4063701-20-zhaotianrui@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Fri, 14 Jul 2023 11:19:05 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5T6LdY5vWR+OXaAw5=ZX1bDKW6RjFT=wYREO65Jv9Jtg@mail.gmail.com>
Message-ID: <CAAhV-H5T6LdY5vWR+OXaAw5=ZX1bDKW6RjFT=wYREO65Jv9Jtg@mail.gmail.com>
Subject: Re: [PATCH v16 19/30] LoongArch: KVM: Implement kvm mmu operations
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, tangyouling@loongson.cn,
        hejinyang@loongson.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Tianrui,

Via offline discussion now I know that the level2_xxx functions are
used to translate GPA to HPA, but the level2_ prefix is very confusing
that the first image may be "two level page tables (PMD+PTE, or
something like that)".

So to make things clear, I think a gpa2hpa_ prefix may be better, and
if it is too long, we can use g2hpa_. As an alternative, use
hypervisor_ as the prefix may also be considerable.

Huacai

On Thu, Jun 29, 2023 at 3:56=E2=80=AFPM Tianrui Zhao <zhaotianrui@loongson.=
cn> wrote:
>
> Implement LoongArch kvm mmu, it is used to switch gpa to hpa when
> guest exit because of address translation exception. This patch
> implement allocate gpa page table, search gpa from it and flush guest
> gpa in the table.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/kvm/mmu.c | 725 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 725 insertions(+)
>  create mode 100644 arch/loongarch/kvm/mmu.c
>
> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> new file mode 100644
> index 000000000000..d75446139546
> --- /dev/null
> +++ b/arch/loongarch/kvm/mmu.c
> @@ -0,0 +1,725 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#include <linux/highmem.h>
> +#include <linux/page-flags.h>
> +#include <linux/kvm_host.h>
> +#include <linux/uaccess.h>
> +#include <asm/mmu_context.h>
> +#include <asm/pgalloc.h>
> +#include <asm/tlb.h>
> +
> +/*
> + * KVM_MMU_CACHE_MIN_PAGES is the number of GPA page table translation l=
evels
> + * for which pages need to be cached.
> + */
> +#define KVM_MMU_CACHE_MIN_PAGES (CONFIG_PGTABLE_LEVELS - 1)
> +
> +/**
> + * kvm_pgd_alloc() - Allocate and initialise a KVM GPA page directory.
> + *
> + * Allocate a blank KVM GPA page directory (PGD) for representing guest =
physical
> + * to host physical page mappings.
> + *
> + * Returns:    Pointer to new KVM GPA page directory.
> + *             NULL on allocation failure.
> + */
> +pgd_t *kvm_pgd_alloc(void)
> +{
> +       pgd_t *pgd;
> +
> +       pgd =3D (pgd_t *)__get_free_pages(GFP_KERNEL, 0);
> +       if (pgd)
> +               pgd_init((void *)pgd);
> +
> +       return pgd;
> +}
> +
> +/**
> + * kvm_walk_pgd() - Walk page table with optional allocation.
> + * @pgd:       Page directory pointer.
> + * @addr:      Address to index page table using.
> + * @cache:     MMU page cache to allocate new page tables from, or NULL.
> + *
> + * Walk the page tables pointed to by @pgd to find the PTE corresponding=
 to the
> + * address @addr. If page tables don't exist for @addr, they will be cre=
ated
> + * from the MMU cache if @cache is not NULL.
> + *
> + * Returns:    Pointer to pte_t corresponding to @addr.
> + *             NULL if a page table doesn't exist for @addr and !@cache.
> + *             NULL if a page table allocation failed.
> + */
> +static pte_t *kvm_walk_pgd(pgd_t *pgd, struct kvm_mmu_memory_cache *cach=
e,
> +                               unsigned long addr)
> +{
> +       p4d_t *p4d;
> +       pud_t *pud;
> +       pmd_t *pmd;
> +
> +       pgd +=3D pgd_index(addr);
> +       if (pgd_none(*pgd)) {
> +               /* Not used yet */
> +               BUG();
> +               return NULL;
> +       }
> +       p4d =3D p4d_offset(pgd, addr);
> +       pud =3D pud_offset(p4d, addr);
> +       if (pud_none(*pud)) {
> +               pmd_t *new_pmd;
> +
> +               if (!cache)
> +                       return NULL;
> +               new_pmd =3D kvm_mmu_memory_cache_alloc(cache);
> +               pmd_init((void *)new_pmd);
> +               pud_populate(NULL, pud, new_pmd);
> +       }
> +       pmd =3D pmd_offset(pud, addr);
> +       if (pmd_none(*pmd)) {
> +               pte_t *new_pte;
> +
> +               if (!cache)
> +                       return NULL;
> +               new_pte =3D kvm_mmu_memory_cache_alloc(cache);
> +               clear_page(new_pte);
> +               pmd_populate_kernel(NULL, pmd, new_pte);
> +       }
> +       return pte_offset_kernel(pmd, addr);
> +}
> +
> +/* Caller must hold kvm->mm_lock */
> +static pte_t *kvm_pte_for_gpa(struct kvm *kvm,
> +                               struct kvm_mmu_memory_cache *cache,
> +                               unsigned long addr)
> +{
> +       return kvm_walk_pgd(kvm->arch.gpa_mm.pgd, cache, addr);
> +}
> +
> +/*
> + * level2_flush_{pte,pmd,pud,pgd,pt}.
> + * Flush a range of guest physical address space from the VM's GPA page =
tables.
> + */
> +static int level2_flush_pte(pmd_t *pmd, unsigned long addr, unsigned lon=
g end)
> +{
> +       pte_t *pte;
> +       unsigned long next, start;
> +       int ret;
> +
> +       ret =3D 0;
> +       start =3D addr;
> +       pte =3D pte_offset_kernel(pmd, addr);
> +       do {
> +               next =3D addr + PAGE_SIZE;
> +               if (!pte_present(*pte))
> +                       continue;
> +
> +               set_pte(pte, __pte(0));
> +               ret =3D 1;
> +       } while (pte++, addr =3D next, addr !=3D end);
> +
> +       if (start + PMD_SIZE =3D=3D end) {
> +               pte =3D pte_offset_kernel(pmd, 0);
> +               pmd_clear(pmd);
> +               pte_free_kernel(NULL, pte);
> +       }
> +       return ret;
> +}
> +
> +static int level2_flush_pmd(pud_t *pud, unsigned long addr, unsigned lon=
g end)
> +{
> +       pmd_t *pmd;
> +       unsigned long next, start;
> +       int ret;
> +
> +       ret =3D 0;
> +       start =3D addr;
> +       pmd =3D pmd_offset(pud, addr);
> +       do {
> +               next =3D pmd_addr_end(addr, end);
> +               if (!pmd_present(*pmd))
> +                       continue;
> +
> +               ret |=3D level2_flush_pte(pmd, addr, next);
> +       } while (pmd++, addr =3D next, addr !=3D end);
> +
> +       if (start + PUD_SIZE =3D=3D end) {
> +               pmd =3D pmd_offset(pud, 0);
> +               pud_clear(pud);
> +               pmd_free(NULL, pmd);
> +       }
> +       return ret;
> +}
> +
> +static int level2_flush_pud(pgd_t *pgd, unsigned long addr, unsigned lon=
g end)
> +{
> +       p4d_t *p4d;
> +       pud_t *pud;
> +       unsigned long next, start;
> +       int ret;
> +
> +       ret =3D 0;
> +       start =3D addr;
> +       p4d =3D p4d_offset(pgd, addr);
> +       pud =3D pud_offset(p4d, addr);
> +       do {
> +               next =3D pud_addr_end(addr, end);
> +               if (!pud_present(*pud))
> +                       continue;
> +
> +               ret |=3D level2_flush_pmd(pud, addr, next);
> +       } while (pud++, addr =3D next, addr !=3D end);
> +
> +       if (start + PGDIR_SIZE =3D=3D end) {
> +               pud =3D pud_offset(p4d, 0);
> +               pgd_clear(pgd);
> +               pud_free(NULL, pud);
> +       }
> +       return ret;
> +}
> +
> +static int level2_flush_pgd(pgd_t *pgd, unsigned long addr, unsigned lon=
g end)
> +{
> +       unsigned long next;
> +       int ret;
> +
> +       ret =3D 0;
> +       if (addr > end - 1)
> +               return ret;
> +       pgd =3D pgd + pgd_index(addr);
> +       do {
> +               next =3D pgd_addr_end(addr, end);
> +               if (!pgd_present(*pgd))
> +                       continue;
> +
> +               ret |=3D level2_flush_pud(pgd, addr, next);
> +       }  while (pgd++, addr =3D next, addr !=3D end);
> +
> +       return ret;
> +}
> +
> +/**
> + * level2_flush_range() - Flush a range of guest physical addresses.
> + * @kvm:       KVM pointer.
> + * @start_gfn: Guest frame number of first page in GPA range to flush.
> + * @end_gfn:   Guest frame number of last page in GPA range to flush.
> + *
> + * Flushes a range of GPA mappings from the GPA page tables.
> + *
> + * The caller must hold the @kvm->mmu_lock spinlock.
> + *
> + * Returns:    Whether its safe to remove the top level page directory b=
ecause
> + *             all lower levels have been removed.
> + */
> +static bool level2_flush_range(struct kvm *kvm, gfn_t start_gfn, gfn_t e=
nd_gfn)
> +{
> +       return level2_flush_pgd(kvm->arch.gpa_mm.pgd, start_gfn << PAGE_S=
HIFT,
> +                               end_gfn << PAGE_SHIFT);
> +}
> +
> +typedef int (*level2_pte_ops)(void *pte);
> +/*
> + * level2_mkclean_pte
> + * Mark a range of guest physical address space clean (writes fault) in =
the VM's
> + * GPA page table to allow dirty page tracking.
> + */
> +static int level2_mkclean_pte(void *pte)
> +{
> +       pte_t val;
> +
> +       val =3D *(pte_t *)pte;
> +       if (pte_dirty(val)) {
> +               *(pte_t *)pte =3D pte_mkclean(val);
> +               return 1;
> +       }
> +       return 0;
> +}
> +
> +static int level2_ptw_pte(pmd_t *pmd, unsigned long addr, unsigned long =
end,
> +                       level2_pte_ops func)
> +{
> +       pte_t *pte;
> +       unsigned long next;
> +       int ret;
> +
> +       ret =3D 0;
> +       pte =3D pte_offset_kernel(pmd, addr);
> +       do {
> +               next =3D addr + PAGE_SIZE;
> +               if (!pte_present(*pte))
> +                       continue;
> +
> +               ret |=3D func(pte);
> +       } while (pte++, addr =3D next, addr !=3D end);
> +
> +       return ret;
> +}
> +
> +static int level2_ptw_pmd(pud_t *pud, unsigned long addr, unsigned long =
end,
> +                       level2_pte_ops func)
> +{
> +       pmd_t *pmd;
> +       unsigned long next;
> +       int ret;
> +
> +       ret =3D 0;
> +       pmd =3D pmd_offset(pud, addr);
> +       do {
> +               next =3D pmd_addr_end(addr, end);
> +               if (!pmd_present(*pmd))
> +                       continue;
> +
> +               ret |=3D level2_ptw_pte(pmd, addr, next, func);
> +       } while (pmd++, addr =3D next, addr !=3D end);
> +
> +       return ret;
> +}
> +
> +static int level2_ptw_pud(pgd_t *pgd, unsigned long addr, unsigned long =
end,
> +                       level2_pte_ops func)
> +{
> +       p4d_t *p4d;
> +       pud_t *pud;
> +       unsigned long next;
> +       int ret;
> +
> +       ret =3D 0;
> +       p4d =3D p4d_offset(pgd, addr);
> +       pud =3D pud_offset(p4d, addr);
> +       do {
> +               next =3D pud_addr_end(addr, end);
> +               if (!pud_present(*pud))
> +                       continue;
> +
> +               ret |=3D level2_ptw_pmd(pud, addr, next, func);
> +       } while (pud++, addr =3D next, addr !=3D end);
> +
> +       return ret;
> +}
> +
> +static int level2_ptw_pgd(pgd_t *pgd, unsigned long addr, unsigned long =
end,
> +                       level2_pte_ops func)
> +{
> +       unsigned long next;
> +       int ret;
> +
> +       ret =3D 0;
> +       if (addr > end - 1)
> +               return ret;
> +       pgd =3D pgd + pgd_index(addr);
> +       do {
> +               next =3D pgd_addr_end(addr, end);
> +               if (!pgd_present(*pgd))
> +                       continue;
> +
> +               ret |=3D level2_ptw_pud(pgd, addr, next, func);
> +       }  while (pgd++, addr =3D next, addr !=3D end);
> +
> +       return ret;
> +}
> +
> +/*
> + * kvm_mkclean_gpa_pt() - Make a range of guest physical addresses clean=
.
> + * @kvm:       KVM pointer.
> + * @start_gfn: Guest frame number of first page in GPA range to flush.
> + * @end_gfn:   Guest frame number of last page in GPA range to flush.
> + *
> + * Make a range of GPA mappings clean so that guest writes will fault an=
d
> + * trigger dirty page logging.
> + *
> + * The caller must hold the @kvm->mmu_lock spinlock.
> + *
> + * Returns:    Whether any GPA mappings were modified, which would requi=
re
> + *             derived mappings (GVA page tables & TLB enties) to be
> + *             invalidated.
> + */
> +static int kvm_mkclean_gpa_pt(struct kvm *kvm, gfn_t start_gfn, gfn_t en=
d_gfn)
> +{
> +       return level2_ptw_pgd(kvm->arch.gpa_mm.pgd, start_gfn << PAGE_SHI=
FT,
> +                               end_gfn << PAGE_SHIFT, level2_mkclean_pte=
);
> +}
> +
> +/*
> + * kvm_arch_mmu_enable_log_dirty_pt_masked() - write protect dirty pages
> + * @kvm:       The KVM pointer
> + * @slot:      The memory slot associated with mask
> + * @gfn_offset:        The gfn offset in memory slot
> + * @mask:      The mask of dirty pages at offset 'gfn_offset' in this me=
mory
> + *             slot to be write protected
> + *
> + * Walks bits set in mask write protects the associated pte's. Caller mu=
st
> + * acquire @kvm->mmu_lock.
> + */
> +void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> +               struct kvm_memory_slot *slot,
> +               gfn_t gfn_offset, unsigned long mask)
> +{
> +       gfn_t base_gfn =3D slot->base_gfn + gfn_offset;
> +       gfn_t start =3D base_gfn +  __ffs(mask);
> +       gfn_t end =3D base_gfn + __fls(mask) + 1;
> +
> +       kvm_mkclean_gpa_pt(kvm, start, end);
> +}
> +
> +void kvm_arch_commit_memory_region(struct kvm *kvm,
> +                                  struct kvm_memory_slot *old,
> +                                  const struct kvm_memory_slot *new,
> +                                  enum kvm_mr_change change)
> +{
> +       int needs_flush;
> +
> +       /*
> +        * If dirty page logging is enabled, write protect all pages in t=
he slot
> +        * ready for dirty logging.
> +        *
> +        * There is no need to do this in any of the following cases:
> +        * CREATE:      No dirty mappings will already exist.
> +        * MOVE/DELETE: The old mappings will already have been cleaned u=
p by
> +        *              kvm_arch_flush_shadow_memslot()
> +        */
> +       if (change =3D=3D KVM_MR_FLAGS_ONLY &&
> +           (!(old->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
> +            new->flags & KVM_MEM_LOG_DIRTY_PAGES)) {
> +               spin_lock(&kvm->mmu_lock);
> +               /* Write protect GPA page table entries */
> +               needs_flush =3D kvm_mkclean_gpa_pt(kvm, new->base_gfn,
> +                                       new->base_gfn + new->npages);
> +               if (needs_flush)
> +                       kvm_flush_remote_tlbs(kvm);
> +               spin_unlock(&kvm->mmu_lock);
> +       }
> +}
> +
> +void kvm_arch_flush_shadow_all(struct kvm *kvm)
> +{
> +       /* Flush whole GPA */
> +       level2_flush_range(kvm, 0, kvm->arch.gpa_size >> PAGE_SHIFT);
> +       /* Flush vpid for each vCPU individually */
> +       kvm_flush_remote_tlbs(kvm);
> +}
> +
> +void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> +               struct kvm_memory_slot *slot)
> +{
> +       int ret;
> +
> +       /*
> +        * The slot has been made invalid (ready for moving or deletion),=
 so we
> +        * need to ensure that it can no longer be accessed by any guest =
vCPUs.
> +        */
> +       spin_lock(&kvm->mmu_lock);
> +       /* Flush slot from GPA */
> +       ret =3D level2_flush_range(kvm, slot->base_gfn,
> +                       slot->base_gfn + slot->npages);
> +       /* Let implementation do the rest */
> +       if (ret)
> +               kvm_flush_remote_tlbs(kvm);
> +       spin_unlock(&kvm->mmu_lock);
> +}
> +
> +void _kvm_destroy_mm(struct kvm *kvm)
> +{
> +       /* It should always be safe to remove after flushing the whole ra=
nge */
> +       level2_flush_range(kvm, 0, kvm->arch.gpa_size >> PAGE_SHIFT);
> +       pgd_free(NULL, kvm->arch.gpa_mm.pgd);
> +       kvm->arch.gpa_mm.pgd =3D NULL;
> +}
> +
> +/*
> + * Mark a range of guest physical address space old (all accesses fault)=
 in the
> + * VM's GPA page table to allow detection of commonly used pages.
> + */
> +static int level2_mkold_pte(void *pte)
> +{
> +       pte_t val;
> +
> +       val =3D *(pte_t *)pte;
> +       if (pte_young(val)) {
> +               *(pte_t *)pte =3D pte_mkold(val);
> +               return 1;
> +       }
> +       return 0;
> +}
> +
> +bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> +{
> +       return level2_flush_range(kvm, range->start, range->end);
> +}
> +
> +bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> +{
> +       gpa_t gpa =3D range->start << PAGE_SHIFT;
> +       pte_t hva_pte =3D range->pte;
> +       pte_t *ptep =3D kvm_pte_for_gpa(kvm, NULL, gpa);
> +       pte_t old_pte;
> +
> +       if (!ptep)
> +               return false;
> +
> +       /* Mapping may need adjusting depending on memslot flags */
> +       old_pte =3D *ptep;
> +       if (range->slot->flags & KVM_MEM_LOG_DIRTY_PAGES && !pte_dirty(ol=
d_pte))
> +               hva_pte =3D pte_mkclean(hva_pte);
> +       else if (range->slot->flags & KVM_MEM_READONLY)
> +               hva_pte =3D pte_wrprotect(hva_pte);
> +
> +       set_pte(ptep, hva_pte);
> +
> +       /* Replacing an absent or old page doesn't need flushes */
> +       if (!pte_present(old_pte) || !pte_young(old_pte))
> +               return false;
> +
> +       /* Pages swapped, aged, moved, or cleaned require flushes */
> +       return !pte_present(hva_pte) ||
> +              !pte_young(hva_pte) ||
> +              pte_pfn(old_pte) !=3D pte_pfn(hva_pte) ||
> +              (pte_dirty(old_pte) && !pte_dirty(hva_pte));
> +}
> +
> +bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> +{
> +       return level2_ptw_pgd(kvm->arch.gpa_mm.pgd, range->start << PAGE_=
SHIFT,
> +                               range->end << PAGE_SHIFT, level2_mkold_pt=
e);
> +}
> +
> +bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> +{
> +       gpa_t gpa =3D range->start << PAGE_SHIFT;
> +       pte_t *ptep =3D kvm_pte_for_gpa(kvm, NULL, gpa);
> +
> +       if (ptep && pte_present(*ptep) && pte_young(*ptep))
> +               return true;
> +
> +       return false;
> +}
> +
> +/**
> + * kvm_map_page_fast() - Fast path GPA fault handler.
> + * @vcpu:              vCPU pointer.
> + * @gpa:               Guest physical address of fault.
> + * @write:     Whether the fault was due to a write.
> + *
> + * Perform fast path GPA fault handling, doing all that can be done with=
out
> + * calling into KVM. This handles marking old pages young (for idle page
> + * tracking), and dirtying of clean pages (for dirty page logging).
> + *
> + * Returns:    0 on success, in which case we can update derived mapping=
s and
> + *             resume guest execution.
> + *             -EFAULT on failure due to absent GPA mapping or write to
> + *             read-only page, in which case KVM must be consulted.
> + */
> +static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa,
> +                                  bool write)
> +{
> +       struct kvm *kvm =3D vcpu->kvm;
> +       gfn_t gfn =3D gpa >> PAGE_SHIFT;
> +       pte_t *ptep;
> +       kvm_pfn_t pfn =3D 0;
> +       bool pfn_valid =3D false;
> +       int ret =3D 0;
> +
> +       spin_lock(&kvm->mmu_lock);
> +
> +       /* Fast path - just check GPA page table for an existing entry */
> +       ptep =3D kvm_pte_for_gpa(kvm, NULL, gpa);
> +       if (!ptep || !pte_present(*ptep)) {
> +               ret =3D -EFAULT;
> +               goto out;
> +       }
> +
> +       /* Track access to pages marked old */
> +       if (!pte_young(*ptep)) {
> +               set_pte(ptep, pte_mkyoung(*ptep));
> +               pfn =3D pte_pfn(*ptep);
> +               pfn_valid =3D true;
> +               /* call kvm_set_pfn_accessed() after unlock */
> +       }
> +       if (write && !pte_dirty(*ptep)) {
> +               if (!pte_write(*ptep)) {
> +                       ret =3D -EFAULT;
> +                       goto out;
> +               }
> +
> +               /* Track dirtying of writeable pages */
> +               set_pte(ptep, pte_mkdirty(*ptep));
> +               pfn =3D pte_pfn(*ptep);
> +               mark_page_dirty(kvm, gfn);
> +               kvm_set_pfn_dirty(pfn);
> +       }
> +
> +out:
> +       spin_unlock(&kvm->mmu_lock);
> +       if (pfn_valid)
> +               kvm_set_pfn_accessed(pfn);
> +       return ret;
> +}
> +
> +/**
> + * kvm_map_page() - Map a guest physical page.
> + * @vcpu:              vCPU pointer.
> + * @gpa:               Guest physical address of fault.
> + * @write:     Whether the fault was due to a write.
> + *
> + * Handle GPA faults by creating a new GPA mapping (or updating an exist=
ing
> + * one).
> + *
> + * This takes care of marking pages young or dirty (idle/dirty page trac=
king),
> + * asking KVM for the corresponding PFN, and creating a mapping in the G=
PA page
> + * tables. Derived mappings (GVA page tables and TLBs) must be handled b=
y the
> + * caller.
> + *
> + * Returns:    0 on success
> + *             -EFAULT if there is no memory region at @gpa or a write w=
as
> + *             attempted to a read-only memory region. This is usually h=
andled
> + *             as an MMIO access.
> + */
> +static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool w=
rite)
> +{
> +       bool writeable;
> +       int srcu_idx, err =3D 0, retry_no =3D 0;
> +       unsigned long hva;
> +       unsigned long mmu_seq;
> +       unsigned long prot_bits;
> +       pte_t *ptep, new_pte;
> +       kvm_pfn_t pfn;
> +       gfn_t gfn =3D gpa >> PAGE_SHIFT;
> +       struct vm_area_struct *vma;
> +       struct kvm *kvm =3D vcpu->kvm;
> +       struct kvm_memory_slot *memslot;
> +       struct kvm_mmu_memory_cache *memcache =3D &vcpu->arch.mmu_page_ca=
che;
> +
> +       /* Try the fast path to handle old / clean pages */
> +       srcu_idx =3D srcu_read_lock(&kvm->srcu);
> +       err =3D kvm_map_page_fast(vcpu, gpa, write);
> +       if (!err)
> +               goto out;
> +
> +       memslot =3D gfn_to_memslot(kvm, gfn);
> +       hva =3D gfn_to_hva_memslot_prot(memslot, gfn, &writeable);
> +       if (kvm_is_error_hva(hva) || (write && !writeable))
> +               goto out;
> +
> +       mmap_read_lock(current->mm);
> +       vma =3D find_vma_intersection(current->mm, hva, hva + 1);
> +       if (unlikely(!vma)) {
> +               kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
> +               mmap_read_unlock(current->mm);
> +               err =3D -EFAULT;
> +               goto out;
> +       }
> +       mmap_read_unlock(current->mm);
> +
> +       /* We need a minimum of cached pages ready for page table creatio=
n */
> +       err =3D kvm_mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PA=
GES);
> +       if (err)
> +               goto out;
> +
> +retry:
> +       /*
> +        * Used to check for invalidations in progress, of the pfn that i=
s
> +        * returned by pfn_to_pfn_prot below.
> +        */
> +       mmu_seq =3D kvm->mmu_invalidate_seq;
> +       /*
> +        * Ensure the read of mmu_invalidate_seq isn't reordered with PTE=
 reads in
> +        * gfn_to_pfn_prot() (which calls get_user_pages()), so that we d=
on't
> +        * risk the page we get a reference to getting unmapped before we=
 have a
> +        * chance to grab the mmu_lock without mmu_invalidate_retry() not=
icing.
> +        *
> +        * This smp_rmb() pairs with the effective smp_wmb() of the combi=
nation
> +        * of the pte_unmap_unlock() after the PTE is zapped, and the
> +        * spin_lock() in kvm_mmu_invalidate_invalidate_<page|range_end>(=
) before
> +        * mmu_invalidate_seq is incremented.
> +        */
> +       smp_rmb();
> +
> +       /* Slow path - ask KVM core whether we can access this GPA */
> +       pfn =3D gfn_to_pfn_prot(kvm, gfn, write, &writeable);
> +       if (is_error_noslot_pfn(pfn)) {
> +               err =3D -EFAULT;
> +               goto out;
> +       }
> +
> +       spin_lock(&kvm->mmu_lock);
> +       /* Check if an invalidation has taken place since we got pfn */
> +       if (mmu_invalidate_retry(kvm, mmu_seq)) {
> +               /*
> +                * This can happen when mappings are changed asynchronous=
ly, but
> +                * also synchronously if a COW is triggered by
> +                * gfn_to_pfn_prot().
> +                */
> +               spin_unlock(&kvm->mmu_lock);
> +               kvm_set_pfn_accessed(pfn);
> +               kvm_release_pfn_clean(pfn);
> +               if (retry_no > 100) {
> +                       retry_no =3D 0;
> +                       schedule();
> +               }
> +               retry_no++;
> +               goto retry;
> +       }
> +
> +       /*
> +        * For emulated devices such virtio device, actual cache attribut=
e is
> +        * determined by physical machine.
> +        * For pass through physical device, it should be uncachable
> +        */
> +       prot_bits =3D _PAGE_PRESENT | __READABLE;
> +       if (vma->vm_flags & (VM_IO | VM_PFNMAP))
> +               prot_bits |=3D _CACHE_SUC;
> +       else
> +               prot_bits |=3D _CACHE_CC;
> +
> +       if (writeable) {
> +               prot_bits |=3D _PAGE_WRITE;
> +               if (write) {
> +                       prot_bits |=3D __WRITEABLE;
> +                       mark_page_dirty(kvm, gfn);
> +                       kvm_set_pfn_dirty(pfn);
> +               }
> +       }
> +
> +       /* Ensure page tables are allocated */
> +       ptep =3D kvm_pte_for_gpa(kvm, memcache, gpa);
> +       new_pte =3D pfn_pte(pfn, __pgprot(prot_bits));
> +       set_pte(ptep, new_pte);
> +
> +       err =3D 0;
> +       spin_unlock(&kvm->mmu_lock);
> +       kvm_release_pfn_clean(pfn);
> +       kvm_set_pfn_accessed(pfn);
> +out:
> +       srcu_read_unlock(&kvm->srcu, srcu_idx);
> +       return err;
> +}
> +
> +int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long gpa, bool w=
rite)
> +{
> +       int ret;
> +
> +       ret =3D kvm_map_page(vcpu, gpa, write);
> +       if (ret)
> +               return ret;
> +
> +       /* Invalidate this entry in the TLB */
> +       return kvm_flush_tlb_gpa(vcpu, gpa);
> +}
> +
> +void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *me=
mslot)
> +{
> +
> +}
> +
> +int kvm_arch_prepare_memory_region(struct kvm *kvm,
> +                                  const struct kvm_memory_slot *old,
> +                                  struct kvm_memory_slot *new,
> +                                  enum kvm_mr_change change)
> +{
> +       return 0;
> +}
> +
> +void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> +                                       const struct kvm_memory_slot *mem=
slot)
> +{
> +       kvm_flush_remote_tlbs(kvm);
> +}
> --
> 2.39.1
>
>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10F775304E
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 06:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbjGNEDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 00:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjGNEDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 00:03:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8101FD8;
        Thu, 13 Jul 2023 21:03:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F121161BEF;
        Fri, 14 Jul 2023 04:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4CEC433C8;
        Fri, 14 Jul 2023 04:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689307429;
        bh=Y2KhF3mKxxEYPROuDYbIiUoZ/ca+2N6BZCYMoR567nM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ac7DRhtYc7e78MskAxDdQu9zs4RDCCDgxaTVM1NtXc6iCMgY4otN7vNfgo0TLsWTj
         fmClJbDBlq5q6yHlA+7Hmz2IR4A9XzmiD5h8b3eGJxAprqHF7u7Ggg4D/9QoEJdige
         yuOfIgQlZOO9g1cXn/Wbx9oBmIIpdeY0hfYeSVyoomlaCqXSNdERUgDfWuruy2JJfe
         pxsD6DfWuGdEH0MGpx1pRpTAIZrXQFSslbf7OMBo9ygF/XR8YpYUSgGWmWuecWkmY0
         l/01DhlZl6aXGkPsewiwl1hytqcvzbgv8i+wryiZMMUO3zixNadRS7/mwyXgsIWMRL
         UHrTAS0MUFnlg==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-51e5da802afso1684156a12.3;
        Thu, 13 Jul 2023 21:03:49 -0700 (PDT)
X-Gm-Message-State: ABy/qLZQtrvu/fZ2Ts4c7YT6QsWVbBNCmMS6xRkg3sw/dNbal/2+05tU
        iGzZKJ36Yhts5DOWEEiDqhs1H19VuNNiyGXxtGI=
X-Google-Smtp-Source: APBJJlGLLJDwv3xdRFo6Gc6Bcl8EWBnq6MVEnmUzZFeRsWBL0DCIdBAYMHsV/i59syLr91KG3gpIfnFj1AEKDFFU4H8=
X-Received: by 2002:a05:6402:1492:b0:51d:e1cf:dc8a with SMTP id
 e18-20020a056402149200b0051de1cfdc8amr3297953edv.22.1689307427283; Thu, 13
 Jul 2023 21:03:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230629075538.4063701-1-zhaotianrui@loongson.cn>
 <20230629075538.4063701-20-zhaotianrui@loongson.cn> <CAAhV-H5T6LdY5vWR+OXaAw5=ZX1bDKW6RjFT=wYREO65Jv9Jtg@mail.gmail.com>
 <6c80254c-169d-4d4b-1e42-b709c4a9b4a5@loongson.cn>
In-Reply-To: <6c80254c-169d-4d4b-1e42-b709c4a9b4a5@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Fri, 14 Jul 2023 12:03:35 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7MNvhYgJPs6Q+T1HKqKKMBVYxGU-=a9bnOgCjiESL6Qg@mail.gmail.com>
Message-ID: <CAAhV-H7MNvhYgJPs6Q+T1HKqKKMBVYxGU-=a9bnOgCjiESL6Qg@mail.gmail.com>
Subject: Re: [PATCH v16 19/30] LoongArch: KVM: Implement kvm mmu operations
To:     bibo mao <maobibo@loongson.cn>
Cc:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>, hejinyang@loongson.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 14, 2023 at 11:52=E2=80=AFAM bibo mao <maobibo@loongson.cn> wro=
te:
>
>
>
> =E5=9C=A8 2023/7/14 11:19, Huacai Chen =E5=86=99=E9=81=93:
> > Hi, Tianrui,
> >
> > Via offline discussion now I know that the level2_xxx functions are
> > used to translate GPA to HPA, but the level2_ prefix is very confusing
> > that the first image may be "two level page tables (PMD+PTE, or
> > something like that)".
> >
> > So to make things clear, I think a gpa2hpa_ prefix may be better, and
> > if it is too long, we can use g2hpa_. As an alternative, use
> > hypervisor_ as the prefix may also be considerable.
> yes I agree, level2 is a little confused, how about kvm_ptw_xxx or lvzm_p=
tw_xxx?
kvm_ptw_xxx is OK for me.

Huacai
>
> There is no formal name for LoongArch memory virtualziation, g2hpa can no=
t
> represent memory virtualization, and it can be applied to X86 (with prefi=
x tdp_)
> and arm64 (with prefix stage2_ ), however each architecture has its own n=
ame.
>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> > On Thu, Jun 29, 2023 at 3:56=E2=80=AFPM Tianrui Zhao <zhaotianrui@loong=
son.cn> wrote:
> >>
> >> Implement LoongArch kvm mmu, it is used to switch gpa to hpa when
> >> guest exit because of address translation exception. This patch
> >> implement allocate gpa page table, search gpa from it and flush guest
> >> gpa in the table.
> >>
> >> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> >> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> >> ---
> >>  arch/loongarch/kvm/mmu.c | 725 ++++++++++++++++++++++++++++++++++++++=
+
> >>  1 file changed, 725 insertions(+)
> >>  create mode 100644 arch/loongarch/kvm/mmu.c
> >>
> >> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> >> new file mode 100644
> >> index 000000000000..d75446139546
> >> --- /dev/null
> >> +++ b/arch/loongarch/kvm/mmu.c
> >> @@ -0,0 +1,725 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/*
> >> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> >> + */
> >> +
> >> +#include <linux/highmem.h>
> >> +#include <linux/page-flags.h>
> >> +#include <linux/kvm_host.h>
> >> +#include <linux/uaccess.h>
> >> +#include <asm/mmu_context.h>
> >> +#include <asm/pgalloc.h>
> >> +#include <asm/tlb.h>
> >> +
> >> +/*
> >> + * KVM_MMU_CACHE_MIN_PAGES is the number of GPA page table translatio=
n levels
> >> + * for which pages need to be cached.
> >> + */
> >> +#define KVM_MMU_CACHE_MIN_PAGES (CONFIG_PGTABLE_LEVELS - 1)
> >> +
> >> +/**
> >> + * kvm_pgd_alloc() - Allocate and initialise a KVM GPA page directory=
.
> >> + *
> >> + * Allocate a blank KVM GPA page directory (PGD) for representing gue=
st physical
> >> + * to host physical page mappings.
> >> + *
> >> + * Returns:    Pointer to new KVM GPA page directory.
> >> + *             NULL on allocation failure.
> >> + */
> >> +pgd_t *kvm_pgd_alloc(void)
> >> +{
> >> +       pgd_t *pgd;
> >> +
> >> +       pgd =3D (pgd_t *)__get_free_pages(GFP_KERNEL, 0);
> >> +       if (pgd)
> >> +               pgd_init((void *)pgd);
> >> +
> >> +       return pgd;
> >> +}
> >> +
> >> +/**
> >> + * kvm_walk_pgd() - Walk page table with optional allocation.
> >> + * @pgd:       Page directory pointer.
> >> + * @addr:      Address to index page table using.
> >> + * @cache:     MMU page cache to allocate new page tables from, or NU=
LL.
> >> + *
> >> + * Walk the page tables pointed to by @pgd to find the PTE correspond=
ing to the
> >> + * address @addr. If page tables don't exist for @addr, they will be =
created
> >> + * from the MMU cache if @cache is not NULL.
> >> + *
> >> + * Returns:    Pointer to pte_t corresponding to @addr.
> >> + *             NULL if a page table doesn't exist for @addr and !@cac=
he.
> >> + *             NULL if a page table allocation failed.
> >> + */
> >> +static pte_t *kvm_walk_pgd(pgd_t *pgd, struct kvm_mmu_memory_cache *c=
ache,
> >> +                               unsigned long addr)
> >> +{
> >> +       p4d_t *p4d;
> >> +       pud_t *pud;
> >> +       pmd_t *pmd;
> >> +
> >> +       pgd +=3D pgd_index(addr);
> >> +       if (pgd_none(*pgd)) {
> >> +               /* Not used yet */
> >> +               BUG();
> >> +               return NULL;
> >> +       }
> >> +       p4d =3D p4d_offset(pgd, addr);
> >> +       pud =3D pud_offset(p4d, addr);
> >> +       if (pud_none(*pud)) {
> >> +               pmd_t *new_pmd;
> >> +
> >> +               if (!cache)
> >> +                       return NULL;
> >> +               new_pmd =3D kvm_mmu_memory_cache_alloc(cache);
> >> +               pmd_init((void *)new_pmd);
> >> +               pud_populate(NULL, pud, new_pmd);
> >> +       }
> >> +       pmd =3D pmd_offset(pud, addr);
> >> +       if (pmd_none(*pmd)) {
> >> +               pte_t *new_pte;
> >> +
> >> +               if (!cache)
> >> +                       return NULL;
> >> +               new_pte =3D kvm_mmu_memory_cache_alloc(cache);
> >> +               clear_page(new_pte);
> >> +               pmd_populate_kernel(NULL, pmd, new_pte);
> >> +       }
> >> +       return pte_offset_kernel(pmd, addr);
> >> +}
> >> +
> >> +/* Caller must hold kvm->mm_lock */
> >> +static pte_t *kvm_pte_for_gpa(struct kvm *kvm,
> >> +                               struct kvm_mmu_memory_cache *cache,
> >> +                               unsigned long addr)
> >> +{
> >> +       return kvm_walk_pgd(kvm->arch.gpa_mm.pgd, cache, addr);
> >> +}
> >> +
> >> +/*
> >> + * level2_flush_{pte,pmd,pud,pgd,pt}.
> >> + * Flush a range of guest physical address space from the VM's GPA pa=
ge tables.
> >> + */
> >> +static int level2_flush_pte(pmd_t *pmd, unsigned long addr, unsigned =
long end)
> >> +{
> >> +       pte_t *pte;
> >> +       unsigned long next, start;
> >> +       int ret;
> >> +
> >> +       ret =3D 0;
> >> +       start =3D addr;
> >> +       pte =3D pte_offset_kernel(pmd, addr);
> >> +       do {
> >> +               next =3D addr + PAGE_SIZE;
> >> +               if (!pte_present(*pte))
> >> +                       continue;
> >> +
> >> +               set_pte(pte, __pte(0));
> >> +               ret =3D 1;
> >> +       } while (pte++, addr =3D next, addr !=3D end);
> >> +
> >> +       if (start + PMD_SIZE =3D=3D end) {
> >> +               pte =3D pte_offset_kernel(pmd, 0);
> >> +               pmd_clear(pmd);
> >> +               pte_free_kernel(NULL, pte);
> >> +       }
> >> +       return ret;
> >> +}
> >> +
> >> +static int level2_flush_pmd(pud_t *pud, unsigned long addr, unsigned =
long end)
> >> +{
> >> +       pmd_t *pmd;
> >> +       unsigned long next, start;
> >> +       int ret;
> >> +
> >> +       ret =3D 0;
> >> +       start =3D addr;
> >> +       pmd =3D pmd_offset(pud, addr);
> >> +       do {
> >> +               next =3D pmd_addr_end(addr, end);
> >> +               if (!pmd_present(*pmd))
> >> +                       continue;
> >> +
> >> +               ret |=3D level2_flush_pte(pmd, addr, next);
> >> +       } while (pmd++, addr =3D next, addr !=3D end);
> >> +
> >> +       if (start + PUD_SIZE =3D=3D end) {
> >> +               pmd =3D pmd_offset(pud, 0);
> >> +               pud_clear(pud);
> >> +               pmd_free(NULL, pmd);
> >> +       }
> >> +       return ret;
> >> +}
> >> +
> >> +static int level2_flush_pud(pgd_t *pgd, unsigned long addr, unsigned =
long end)
> >> +{
> >> +       p4d_t *p4d;
> >> +       pud_t *pud;
> >> +       unsigned long next, start;
> >> +       int ret;
> >> +
> >> +       ret =3D 0;
> >> +       start =3D addr;
> >> +       p4d =3D p4d_offset(pgd, addr);
> >> +       pud =3D pud_offset(p4d, addr);
> >> +       do {
> >> +               next =3D pud_addr_end(addr, end);
> >> +               if (!pud_present(*pud))
> >> +                       continue;
> >> +
> >> +               ret |=3D level2_flush_pmd(pud, addr, next);
> >> +       } while (pud++, addr =3D next, addr !=3D end);
> >> +
> >> +       if (start + PGDIR_SIZE =3D=3D end) {
> >> +               pud =3D pud_offset(p4d, 0);
> >> +               pgd_clear(pgd);
> >> +               pud_free(NULL, pud);
> >> +       }
> >> +       return ret;
> >> +}
> >> +
> >> +static int level2_flush_pgd(pgd_t *pgd, unsigned long addr, unsigned =
long end)
> >> +{
> >> +       unsigned long next;
> >> +       int ret;
> >> +
> >> +       ret =3D 0;
> >> +       if (addr > end - 1)
> >> +               return ret;
> >> +       pgd =3D pgd + pgd_index(addr);
> >> +       do {
> >> +               next =3D pgd_addr_end(addr, end);
> >> +               if (!pgd_present(*pgd))
> >> +                       continue;
> >> +
> >> +               ret |=3D level2_flush_pud(pgd, addr, next);
> >> +       }  while (pgd++, addr =3D next, addr !=3D end);
> >> +
> >> +       return ret;
> >> +}
> >> +
> >> +/**
> >> + * level2_flush_range() - Flush a range of guest physical addresses.
> >> + * @kvm:       KVM pointer.
> >> + * @start_gfn: Guest frame number of first page in GPA range to flush=
.
> >> + * @end_gfn:   Guest frame number of last page in GPA range to flush.
> >> + *
> >> + * Flushes a range of GPA mappings from the GPA page tables.
> >> + *
> >> + * The caller must hold the @kvm->mmu_lock spinlock.
> >> + *
> >> + * Returns:    Whether its safe to remove the top level page director=
y because
> >> + *             all lower levels have been removed.
> >> + */
> >> +static bool level2_flush_range(struct kvm *kvm, gfn_t start_gfn, gfn_=
t end_gfn)
> >> +{
> >> +       return level2_flush_pgd(kvm->arch.gpa_mm.pgd, start_gfn << PAG=
E_SHIFT,
> >> +                               end_gfn << PAGE_SHIFT);
> >> +}
> >> +
> >> +typedef int (*level2_pte_ops)(void *pte);
> >> +/*
> >> + * level2_mkclean_pte
> >> + * Mark a range of guest physical address space clean (writes fault) =
in the VM's
> >> + * GPA page table to allow dirty page tracking.
> >> + */
> >> +static int level2_mkclean_pte(void *pte)
> >> +{
> >> +       pte_t val;
> >> +
> >> +       val =3D *(pte_t *)pte;
> >> +       if (pte_dirty(val)) {
> >> +               *(pte_t *)pte =3D pte_mkclean(val);
> >> +               return 1;
> >> +       }
> >> +       return 0;
> >> +}
> >> +
> >> +static int level2_ptw_pte(pmd_t *pmd, unsigned long addr, unsigned lo=
ng end,
> >> +                       level2_pte_ops func)
> >> +{
> >> +       pte_t *pte;
> >> +       unsigned long next;
> >> +       int ret;
> >> +
> >> +       ret =3D 0;
> >> +       pte =3D pte_offset_kernel(pmd, addr);
> >> +       do {
> >> +               next =3D addr + PAGE_SIZE;
> >> +               if (!pte_present(*pte))
> >> +                       continue;
> >> +
> >> +               ret |=3D func(pte);
> >> +       } while (pte++, addr =3D next, addr !=3D end);
> >> +
> >> +       return ret;
> >> +}
> >> +
> >> +static int level2_ptw_pmd(pud_t *pud, unsigned long addr, unsigned lo=
ng end,
> >> +                       level2_pte_ops func)
> >> +{
> >> +       pmd_t *pmd;
> >> +       unsigned long next;
> >> +       int ret;
> >> +
> >> +       ret =3D 0;
> >> +       pmd =3D pmd_offset(pud, addr);
> >> +       do {
> >> +               next =3D pmd_addr_end(addr, end);
> >> +               if (!pmd_present(*pmd))
> >> +                       continue;
> >> +
> >> +               ret |=3D level2_ptw_pte(pmd, addr, next, func);
> >> +       } while (pmd++, addr =3D next, addr !=3D end);
> >> +
> >> +       return ret;
> >> +}
> >> +
> >> +static int level2_ptw_pud(pgd_t *pgd, unsigned long addr, unsigned lo=
ng end,
> >> +                       level2_pte_ops func)
> >> +{
> >> +       p4d_t *p4d;
> >> +       pud_t *pud;
> >> +       unsigned long next;
> >> +       int ret;
> >> +
> >> +       ret =3D 0;
> >> +       p4d =3D p4d_offset(pgd, addr);
> >> +       pud =3D pud_offset(p4d, addr);
> >> +       do {
> >> +               next =3D pud_addr_end(addr, end);
> >> +               if (!pud_present(*pud))
> >> +                       continue;
> >> +
> >> +               ret |=3D level2_ptw_pmd(pud, addr, next, func);
> >> +       } while (pud++, addr =3D next, addr !=3D end);
> >> +
> >> +       return ret;
> >> +}
> >> +
> >> +static int level2_ptw_pgd(pgd_t *pgd, unsigned long addr, unsigned lo=
ng end,
> >> +                       level2_pte_ops func)
> >> +{
> >> +       unsigned long next;
> >> +       int ret;
> >> +
> >> +       ret =3D 0;
> >> +       if (addr > end - 1)
> >> +               return ret;
> >> +       pgd =3D pgd + pgd_index(addr);
> >> +       do {
> >> +               next =3D pgd_addr_end(addr, end);
> >> +               if (!pgd_present(*pgd))
> >> +                       continue;
> >> +
> >> +               ret |=3D level2_ptw_pud(pgd, addr, next, func);
> >> +       }  while (pgd++, addr =3D next, addr !=3D end);
> >> +
> >> +       return ret;
> >> +}
> >> +
> >> +/*
> >> + * kvm_mkclean_gpa_pt() - Make a range of guest physical addresses cl=
ean.
> >> + * @kvm:       KVM pointer.
> >> + * @start_gfn: Guest frame number of first page in GPA range to flush=
.
> >> + * @end_gfn:   Guest frame number of last page in GPA range to flush.
> >> + *
> >> + * Make a range of GPA mappings clean so that guest writes will fault=
 and
> >> + * trigger dirty page logging.
> >> + *
> >> + * The caller must hold the @kvm->mmu_lock spinlock.
> >> + *
> >> + * Returns:    Whether any GPA mappings were modified, which would re=
quire
> >> + *             derived mappings (GVA page tables & TLB enties) to be
> >> + *             invalidated.
> >> + */
> >> +static int kvm_mkclean_gpa_pt(struct kvm *kvm, gfn_t start_gfn, gfn_t=
 end_gfn)
> >> +{
> >> +       return level2_ptw_pgd(kvm->arch.gpa_mm.pgd, start_gfn << PAGE_=
SHIFT,
> >> +                               end_gfn << PAGE_SHIFT, level2_mkclean_=
pte);
> >> +}
> >> +
> >> +/*
> >> + * kvm_arch_mmu_enable_log_dirty_pt_masked() - write protect dirty pa=
ges
> >> + * @kvm:       The KVM pointer
> >> + * @slot:      The memory slot associated with mask
> >> + * @gfn_offset:        The gfn offset in memory slot
> >> + * @mask:      The mask of dirty pages at offset 'gfn_offset' in this=
 memory
> >> + *             slot to be write protected
> >> + *
> >> + * Walks bits set in mask write protects the associated pte's. Caller=
 must
> >> + * acquire @kvm->mmu_lock.
> >> + */
> >> +void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> >> +               struct kvm_memory_slot *slot,
> >> +               gfn_t gfn_offset, unsigned long mask)
> >> +{
> >> +       gfn_t base_gfn =3D slot->base_gfn + gfn_offset;
> >> +       gfn_t start =3D base_gfn +  __ffs(mask);
> >> +       gfn_t end =3D base_gfn + __fls(mask) + 1;
> >> +
> >> +       kvm_mkclean_gpa_pt(kvm, start, end);
> >> +}
> >> +
> >> +void kvm_arch_commit_memory_region(struct kvm *kvm,
> >> +                                  struct kvm_memory_slot *old,
> >> +                                  const struct kvm_memory_slot *new,
> >> +                                  enum kvm_mr_change change)
> >> +{
> >> +       int needs_flush;
> >> +
> >> +       /*
> >> +        * If dirty page logging is enabled, write protect all pages i=
n the slot
> >> +        * ready for dirty logging.
> >> +        *
> >> +        * There is no need to do this in any of the following cases:
> >> +        * CREATE:      No dirty mappings will already exist.
> >> +        * MOVE/DELETE: The old mappings will already have been cleane=
d up by
> >> +        *              kvm_arch_flush_shadow_memslot()
> >> +        */
> >> +       if (change =3D=3D KVM_MR_FLAGS_ONLY &&
> >> +           (!(old->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
> >> +            new->flags & KVM_MEM_LOG_DIRTY_PAGES)) {
> >> +               spin_lock(&kvm->mmu_lock);
> >> +               /* Write protect GPA page table entries */
> >> +               needs_flush =3D kvm_mkclean_gpa_pt(kvm, new->base_gfn,
> >> +                                       new->base_gfn + new->npages);
> >> +               if (needs_flush)
> >> +                       kvm_flush_remote_tlbs(kvm);
> >> +               spin_unlock(&kvm->mmu_lock);
> >> +       }
> >> +}
> >> +
> >> +void kvm_arch_flush_shadow_all(struct kvm *kvm)
> >> +{
> >> +       /* Flush whole GPA */
> >> +       level2_flush_range(kvm, 0, kvm->arch.gpa_size >> PAGE_SHIFT);
> >> +       /* Flush vpid for each vCPU individually */
> >> +       kvm_flush_remote_tlbs(kvm);
> >> +}
> >> +
> >> +void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> >> +               struct kvm_memory_slot *slot)
> >> +{
> >> +       int ret;
> >> +
> >> +       /*
> >> +        * The slot has been made invalid (ready for moving or deletio=
n), so we
> >> +        * need to ensure that it can no longer be accessed by any gue=
st vCPUs.
> >> +        */
> >> +       spin_lock(&kvm->mmu_lock);
> >> +       /* Flush slot from GPA */
> >> +       ret =3D level2_flush_range(kvm, slot->base_gfn,
> >> +                       slot->base_gfn + slot->npages);
> >> +       /* Let implementation do the rest */
> >> +       if (ret)
> >> +               kvm_flush_remote_tlbs(kvm);
> >> +       spin_unlock(&kvm->mmu_lock);
> >> +}
> >> +
> >> +void _kvm_destroy_mm(struct kvm *kvm)
> >> +{
> >> +       /* It should always be safe to remove after flushing the whole=
 range */
> >> +       level2_flush_range(kvm, 0, kvm->arch.gpa_size >> PAGE_SHIFT);
> >> +       pgd_free(NULL, kvm->arch.gpa_mm.pgd);
> >> +       kvm->arch.gpa_mm.pgd =3D NULL;
> >> +}
> >> +
> >> +/*
> >> + * Mark a range of guest physical address space old (all accesses fau=
lt) in the
> >> + * VM's GPA page table to allow detection of commonly used pages.
> >> + */
> >> +static int level2_mkold_pte(void *pte)
> >> +{
> >> +       pte_t val;
> >> +
> >> +       val =3D *(pte_t *)pte;
> >> +       if (pte_young(val)) {
> >> +               *(pte_t *)pte =3D pte_mkold(val);
> >> +               return 1;
> >> +       }
> >> +       return 0;
> >> +}
> >> +
> >> +bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range=
)
> >> +{
> >> +       return level2_flush_range(kvm, range->start, range->end);
> >> +}
> >> +
> >> +bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> >> +{
> >> +       gpa_t gpa =3D range->start << PAGE_SHIFT;
> >> +       pte_t hva_pte =3D range->pte;
> >> +       pte_t *ptep =3D kvm_pte_for_gpa(kvm, NULL, gpa);
> >> +       pte_t old_pte;
> >> +
> >> +       if (!ptep)
> >> +               return false;
> >> +
> >> +       /* Mapping may need adjusting depending on memslot flags */
> >> +       old_pte =3D *ptep;
> >> +       if (range->slot->flags & KVM_MEM_LOG_DIRTY_PAGES && !pte_dirty=
(old_pte))
> >> +               hva_pte =3D pte_mkclean(hva_pte);
> >> +       else if (range->slot->flags & KVM_MEM_READONLY)
> >> +               hva_pte =3D pte_wrprotect(hva_pte);
> >> +
> >> +       set_pte(ptep, hva_pte);
> >> +
> >> +       /* Replacing an absent or old page doesn't need flushes */
> >> +       if (!pte_present(old_pte) || !pte_young(old_pte))
> >> +               return false;
> >> +
> >> +       /* Pages swapped, aged, moved, or cleaned require flushes */
> >> +       return !pte_present(hva_pte) ||
> >> +              !pte_young(hva_pte) ||
> >> +              pte_pfn(old_pte) !=3D pte_pfn(hva_pte) ||
> >> +              (pte_dirty(old_pte) && !pte_dirty(hva_pte));
> >> +}
> >> +
> >> +bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> >> +{
> >> +       return level2_ptw_pgd(kvm->arch.gpa_mm.pgd, range->start << PA=
GE_SHIFT,
> >> +                               range->end << PAGE_SHIFT, level2_mkold=
_pte);
> >> +}
> >> +
> >> +bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> >> +{
> >> +       gpa_t gpa =3D range->start << PAGE_SHIFT;
> >> +       pte_t *ptep =3D kvm_pte_for_gpa(kvm, NULL, gpa);
> >> +
> >> +       if (ptep && pte_present(*ptep) && pte_young(*ptep))
> >> +               return true;
> >> +
> >> +       return false;
> >> +}
> >> +
> >> +/**
> >> + * kvm_map_page_fast() - Fast path GPA fault handler.
> >> + * @vcpu:              vCPU pointer.
> >> + * @gpa:               Guest physical address of fault.
> >> + * @write:     Whether the fault was due to a write.
> >> + *
> >> + * Perform fast path GPA fault handling, doing all that can be done w=
ithout
> >> + * calling into KVM. This handles marking old pages young (for idle p=
age
> >> + * tracking), and dirtying of clean pages (for dirty page logging).
> >> + *
> >> + * Returns:    0 on success, in which case we can update derived mapp=
ings and
> >> + *             resume guest execution.
> >> + *             -EFAULT on failure due to absent GPA mapping or write =
to
> >> + *             read-only page, in which case KVM must be consulted.
> >> + */
> >> +static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa=
,
> >> +                                  bool write)
> >> +{
> >> +       struct kvm *kvm =3D vcpu->kvm;
> >> +       gfn_t gfn =3D gpa >> PAGE_SHIFT;
> >> +       pte_t *ptep;
> >> +       kvm_pfn_t pfn =3D 0;
> >> +       bool pfn_valid =3D false;
> >> +       int ret =3D 0;
> >> +
> >> +       spin_lock(&kvm->mmu_lock);
> >> +
> >> +       /* Fast path - just check GPA page table for an existing entry=
 */
> >> +       ptep =3D kvm_pte_for_gpa(kvm, NULL, gpa);
> >> +       if (!ptep || !pte_present(*ptep)) {
> >> +               ret =3D -EFAULT;
> >> +               goto out;
> >> +       }
> >> +
> >> +       /* Track access to pages marked old */
> >> +       if (!pte_young(*ptep)) {
> >> +               set_pte(ptep, pte_mkyoung(*ptep));
> >> +               pfn =3D pte_pfn(*ptep);
> >> +               pfn_valid =3D true;
> >> +               /* call kvm_set_pfn_accessed() after unlock */
> >> +       }
> >> +       if (write && !pte_dirty(*ptep)) {
> >> +               if (!pte_write(*ptep)) {
> >> +                       ret =3D -EFAULT;
> >> +                       goto out;
> >> +               }
> >> +
> >> +               /* Track dirtying of writeable pages */
> >> +               set_pte(ptep, pte_mkdirty(*ptep));
> >> +               pfn =3D pte_pfn(*ptep);
> >> +               mark_page_dirty(kvm, gfn);
> >> +               kvm_set_pfn_dirty(pfn);
> >> +       }
> >> +
> >> +out:
> >> +       spin_unlock(&kvm->mmu_lock);
> >> +       if (pfn_valid)
> >> +               kvm_set_pfn_accessed(pfn);
> >> +       return ret;
> >> +}
> >> +
> >> +/**
> >> + * kvm_map_page() - Map a guest physical page.
> >> + * @vcpu:              vCPU pointer.
> >> + * @gpa:               Guest physical address of fault.
> >> + * @write:     Whether the fault was due to a write.
> >> + *
> >> + * Handle GPA faults by creating a new GPA mapping (or updating an ex=
isting
> >> + * one).
> >> + *
> >> + * This takes care of marking pages young or dirty (idle/dirty page t=
racking),
> >> + * asking KVM for the corresponding PFN, and creating a mapping in th=
e GPA page
> >> + * tables. Derived mappings (GVA page tables and TLBs) must be handle=
d by the
> >> + * caller.
> >> + *
> >> + * Returns:    0 on success
> >> + *             -EFAULT if there is no memory region at @gpa or a writ=
e was
> >> + *             attempted to a read-only memory region. This is usuall=
y handled
> >> + *             as an MMIO access.
> >> + */
> >> +static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, boo=
l write)
> >> +{
> >> +       bool writeable;
> >> +       int srcu_idx, err =3D 0, retry_no =3D 0;
> >> +       unsigned long hva;
> >> +       unsigned long mmu_seq;
> >> +       unsigned long prot_bits;
> >> +       pte_t *ptep, new_pte;
> >> +       kvm_pfn_t pfn;
> >> +       gfn_t gfn =3D gpa >> PAGE_SHIFT;
> >> +       struct vm_area_struct *vma;
> >> +       struct kvm *kvm =3D vcpu->kvm;
> >> +       struct kvm_memory_slot *memslot;
> >> +       struct kvm_mmu_memory_cache *memcache =3D &vcpu->arch.mmu_page=
_cache;
> >> +
> >> +       /* Try the fast path to handle old / clean pages */
> >> +       srcu_idx =3D srcu_read_lock(&kvm->srcu);
> >> +       err =3D kvm_map_page_fast(vcpu, gpa, write);
> >> +       if (!err)
> >> +               goto out;
> >> +
> >> +       memslot =3D gfn_to_memslot(kvm, gfn);
> >> +       hva =3D gfn_to_hva_memslot_prot(memslot, gfn, &writeable);
> >> +       if (kvm_is_error_hva(hva) || (write && !writeable))
> >> +               goto out;
> >> +
> >> +       mmap_read_lock(current->mm);
> >> +       vma =3D find_vma_intersection(current->mm, hva, hva + 1);
> >> +       if (unlikely(!vma)) {
> >> +               kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
> >> +               mmap_read_unlock(current->mm);
> >> +               err =3D -EFAULT;
> >> +               goto out;
> >> +       }
> >> +       mmap_read_unlock(current->mm);
> >> +
> >> +       /* We need a minimum of cached pages ready for page table crea=
tion */
> >> +       err =3D kvm_mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN=
_PAGES);
> >> +       if (err)
> >> +               goto out;
> >> +
> >> +retry:
> >> +       /*
> >> +        * Used to check for invalidations in progress, of the pfn tha=
t is
> >> +        * returned by pfn_to_pfn_prot below.
> >> +        */
> >> +       mmu_seq =3D kvm->mmu_invalidate_seq;
> >> +       /*
> >> +        * Ensure the read of mmu_invalidate_seq isn't reordered with =
PTE reads in
> >> +        * gfn_to_pfn_prot() (which calls get_user_pages()), so that w=
e don't
> >> +        * risk the page we get a reference to getting unmapped before=
 we have a
> >> +        * chance to grab the mmu_lock without mmu_invalidate_retry() =
noticing.
> >> +        *
> >> +        * This smp_rmb() pairs with the effective smp_wmb() of the co=
mbination
> >> +        * of the pte_unmap_unlock() after the PTE is zapped, and the
> >> +        * spin_lock() in kvm_mmu_invalidate_invalidate_<page|range_en=
d>() before
> >> +        * mmu_invalidate_seq is incremented.
> >> +        */
> >> +       smp_rmb();
> >> +
> >> +       /* Slow path - ask KVM core whether we can access this GPA */
> >> +       pfn =3D gfn_to_pfn_prot(kvm, gfn, write, &writeable);
> >> +       if (is_error_noslot_pfn(pfn)) {
> >> +               err =3D -EFAULT;
> >> +               goto out;
> >> +       }
> >> +
> >> +       spin_lock(&kvm->mmu_lock);
> >> +       /* Check if an invalidation has taken place since we got pfn *=
/
> >> +       if (mmu_invalidate_retry(kvm, mmu_seq)) {
> >> +               /*
> >> +                * This can happen when mappings are changed asynchron=
ously, but
> >> +                * also synchronously if a COW is triggered by
> >> +                * gfn_to_pfn_prot().
> >> +                */
> >> +               spin_unlock(&kvm->mmu_lock);
> >> +               kvm_set_pfn_accessed(pfn);
> >> +               kvm_release_pfn_clean(pfn);
> >> +               if (retry_no > 100) {
> >> +                       retry_no =3D 0;
> >> +                       schedule();
> >> +               }
> >> +               retry_no++;
> >> +               goto retry;
> >> +       }
> >> +
> >> +       /*
> >> +        * For emulated devices such virtio device, actual cache attri=
bute is
> >> +        * determined by physical machine.
> >> +        * For pass through physical device, it should be uncachable
> >> +        */
> >> +       prot_bits =3D _PAGE_PRESENT | __READABLE;
> >> +       if (vma->vm_flags & (VM_IO | VM_PFNMAP))
> >> +               prot_bits |=3D _CACHE_SUC;
> >> +       else
> >> +               prot_bits |=3D _CACHE_CC;
> >> +
> >> +       if (writeable) {
> >> +               prot_bits |=3D _PAGE_WRITE;
> >> +               if (write) {
> >> +                       prot_bits |=3D __WRITEABLE;
> >> +                       mark_page_dirty(kvm, gfn);
> >> +                       kvm_set_pfn_dirty(pfn);
> >> +               }
> >> +       }
> >> +
> >> +       /* Ensure page tables are allocated */
> >> +       ptep =3D kvm_pte_for_gpa(kvm, memcache, gpa);
> >> +       new_pte =3D pfn_pte(pfn, __pgprot(prot_bits));
> >> +       set_pte(ptep, new_pte);
> >> +
> >> +       err =3D 0;
> >> +       spin_unlock(&kvm->mmu_lock);
> >> +       kvm_release_pfn_clean(pfn);
> >> +       kvm_set_pfn_accessed(pfn);
> >> +out:
> >> +       srcu_read_unlock(&kvm->srcu, srcu_idx);
> >> +       return err;
> >> +}
> >> +
> >> +int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long gpa, boo=
l write)
> >> +{
> >> +       int ret;
> >> +
> >> +       ret =3D kvm_map_page(vcpu, gpa, write);
> >> +       if (ret)
> >> +               return ret;
> >> +
> >> +       /* Invalidate this entry in the TLB */
> >> +       return kvm_flush_tlb_gpa(vcpu, gpa);
> >> +}
> >> +
> >> +void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot =
*memslot)
> >> +{
> >> +
> >> +}
> >> +
> >> +int kvm_arch_prepare_memory_region(struct kvm *kvm,
> >> +                                  const struct kvm_memory_slot *old,
> >> +                                  struct kvm_memory_slot *new,
> >> +                                  enum kvm_mr_change change)
> >> +{
> >> +       return 0;
> >> +}
> >> +
> >> +void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> >> +                                       const struct kvm_memory_slot *=
memslot)
> >> +{
> >> +       kvm_flush_remote_tlbs(kvm);
> >> +}
> >> --
> >> 2.39.1
> >>
> >>
>

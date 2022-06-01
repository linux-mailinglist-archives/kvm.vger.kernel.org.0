Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C952539D35
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 08:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349858AbiFAGaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 02:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345399AbiFAG36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 02:29:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDCC5F243;
        Tue, 31 May 2022 23:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A53EF6126A;
        Wed,  1 Jun 2022 06:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06885C3411A;
        Wed,  1 Jun 2022 06:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654064996;
        bh=V0yoFuybIJOxGlsNnBcbsKTvNyHMgLezCKjXZJlRkww=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gN9NIOzS/z3WKNNFWuweki9I4nwBCMqi6/SScfAJOKO5H0TWkdip9UP6KxDtKnIJ/
         GItTZICAmmBP5M+2mTGFV9oUPF1Fqzh5go9smZ5A88XedwajXPce/oOQpswWWZKSAF
         MU921gXcjhHDZ4WJtadYwDkdrEkTXdGRKHAK1cOBeUIgBzr1vSiDRpviusO3l4P6XV
         0bIMWLZc1NOEVhcTjZHjk/6kpp9LYl9Apq7o35uU99Hf+VmH/HCRviUyGV6APHEOiV
         fIr2w/5F2y1CMkwSJJaYKKF6+L9lxNOkTq4FMx0ApXc5IpaewLp5ot/3mppQrNs3GU
         WBHKbrqldJriw==
Received: by mail-vs1-f53.google.com with SMTP id q14so697658vsr.12;
        Tue, 31 May 2022 23:29:55 -0700 (PDT)
X-Gm-Message-State: AOAM533j2A5jqHxBD5q58pS3vs/x8OWsI67hdEkrRGzRn6f1eM4nZGFb
        mFwtkLLsCqYDLdwXLbEz51T96VuKGlPCq7E22w8=
X-Google-Smtp-Source: ABdhPJw8mstu2XoXbV70BY/ZxhFTzUEkcJ5PyFUPcWeP2EMCH+T8T3PWLbRrjuzI+efazG4mRnQ78TER8f4uhJCSJxU=
X-Received: by 2002:a05:6102:2929:b0:349:d926:e092 with SMTP id
 cz41-20020a056102292900b00349d926e092mr2260705vsb.51.1654064994755; Tue, 31
 May 2022 23:29:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220530094701.2891404-1-alexandre.ghiti@canonical.com>
In-Reply-To: <20220530094701.2891404-1-alexandre.ghiti@canonical.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Wed, 1 Jun 2022 14:29:43 +0800
X-Gmail-Original-Message-ID: <CAJF2gTSny-Yz1L80B9MRQDHG1N=Nxy5O19LNsht+6d9oqyonuQ@mail.gmail.com>
Message-ID: <CAJF2gTSny-Yz1L80B9MRQDHG1N=Nxy5O19LNsht+6d9oqyonuQ@mail.gmail.com>
Subject: Re: [PATCH -for-next] riscv: Fix missing PAGE_PFN_MASK
To:     Alexandre Ghiti <alexandre.ghiti@canonical.com>
Cc:     =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 30, 2022 at 5:47 PM Alexandre Ghiti
<alexandre.ghiti@canonical.com> wrote:
>
> There are a bunch of functions that use the PFN from a page table entry
> that end up with the svpbmt upper-bits because they are missing the newly
> introduced PAGE_PFN_MASK which leads to wrong addresses conversions and
> then crash: fix this by adding this mask.
>
> Fixes: 100631b48ded ("riscv: Fix accessing pfn bits in PTEs for non-32bit variants")
> Signed-off-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>

I think this patch is the appendix for:
https://lore.kernel.org/linux-riscv/20220324000710.575331-10-heiko@sntech.de/

Reviewed-by: Guo Ren <guoren@kernel.org>


> ---
>  arch/riscv/include/asm/pgtable-64.h | 4 ++--
>  arch/riscv/include/asm/pgtable.h    | 4 ++--
>  arch/riscv/kvm/mmu.c                | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
> index 6d59e4695200..0e57bf1e25e9 100644
> --- a/arch/riscv/include/asm/pgtable-64.h
> +++ b/arch/riscv/include/asm/pgtable-64.h
> @@ -153,7 +153,7 @@ static inline pud_t pfn_pud(unsigned long pfn, pgprot_t prot)
>
>  static inline unsigned long _pud_pfn(pud_t pud)
>  {
> -       return pud_val(pud) >> _PAGE_PFN_SHIFT;
> +       return (pud_val(pud) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT;
>  }
>
>  static inline pmd_t *pud_pgtable(pud_t pud)
> @@ -240,7 +240,7 @@ static inline void p4d_clear(p4d_t *p4d)
>  static inline pud_t *p4d_pgtable(p4d_t p4d)
>  {
>         if (pgtable_l4_enabled)
> -               return (pud_t *)pfn_to_virt(p4d_val(p4d) >> _PAGE_PFN_SHIFT);
> +               return (pud_t *)pfn_to_virt((p4d_val(p4d) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT);
>
>         return (pud_t *)pud_pgtable((pud_t) { p4d_val(p4d) });
>  }
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index e2658a25f06d..43064025f4b0 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -255,7 +255,7 @@ static inline pgd_t pfn_pgd(unsigned long pfn, pgprot_t prot)
>
>  static inline unsigned long _pgd_pfn(pgd_t pgd)
>  {
> -       return pgd_val(pgd) >> _PAGE_PFN_SHIFT;
> +       return (pgd_val(pgd) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT;
>  }
>
>  static inline struct page *pmd_page(pmd_t pmd)
> @@ -568,7 +568,7 @@ static inline pmd_t pmd_mkinvalid(pmd_t pmd)
>         return __pmd(pmd_val(pmd) & ~(_PAGE_PRESENT|_PAGE_PROT_NONE));
>  }
>
> -#define __pmd_to_phys(pmd)  (pmd_val(pmd) >> _PAGE_PFN_SHIFT << PAGE_SHIFT)
> +#define __pmd_to_phys(pmd)  ((pmd_val(pmd) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT << PAGE_SHIFT)
>
>  static inline unsigned long pmd_pfn(pmd_t pmd)
>  {
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index f80a34fbf102..db03c5a29d4c 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -55,7 +55,7 @@ static inline unsigned long stage2_pte_index(gpa_t addr, u32 level)
>
>  static inline unsigned long stage2_pte_page_vaddr(pte_t pte)
>  {
> -       return (unsigned long)pfn_to_virt(pte_val(pte) >> _PAGE_PFN_SHIFT);
> +       return (unsigned long)pfn_to_virt((pte_val(pte) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT);
>  }
>
>  static int stage2_page_size_to_level(unsigned long page_size, u32 *out_level)
> --
> 2.34.1
>


-- 
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/

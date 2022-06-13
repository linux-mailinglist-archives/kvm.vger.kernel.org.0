Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680E75483A9
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 11:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbiFMJbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 05:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234660AbiFMJbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 05:31:42 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60800186D8
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 02:31:41 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id k16so6330570wrg.7
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 02:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/OqFsaupcKkbN5ZhwB7cTTOB/jJJt4KZYzQeTPC35+8=;
        b=4FIRDPlyNK+WMh7PnfjoRzqlLl6R8KV6uBkS/FTTx0qa70c8hfiqGl6hXSnxRKX4g5
         M2td+xg4QJnj+FOdx0QYC/F4PW/x9pGstgIMkvb/2FpiaMbxw1+rzbaZK2FrF+hW4NTb
         y5F4eHtHLtCifjnZAfhL6VCr+RXXM8dV1h3FML7iQJ6vmkiZvvI8AzeSZtvGSCHUgG6o
         kB5zQBUTJ4yylxGEnVe9GJ57fuyClEacPwME303K79FAzK29Zy4rPhFsD+hLjZkTT100
         TIoN1irlZbmAyzA4JMLK2A2Vpv5bzPvU1cx9Gj+Cz6C3+CL/LFLV9pakLe+Ga74LTxDG
         jAIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/OqFsaupcKkbN5ZhwB7cTTOB/jJJt4KZYzQeTPC35+8=;
        b=KvPzdHGnbYKEVg/dA+vmcx9Dqi139Y0rdrd5ZYN3eoBwVXIHQ6J95uYewo1gH7RLQZ
         g9xq7naefF2T7nMKSuDW/JaVRlQmBacyDWU8tUqUHeJIph1RkYiRp90qErFDARM0B+37
         hTD+DbZINbEhLPvEUZA58YOMz8xFreQiLk6P76KCOJM0FHjYiEEHau7+q1fSm8QlU1L3
         B1Y7jc0LaMzm8pkbb4bCiRg8R4kpF3Nr6Rx4OMRpFj1fBpA5F/JsqzhOwgq2QU2KUCoz
         fXUv1WD5+7znmnkVCWB3zLitI71uIQbmKLJLDIb9xVfvObZJaitcxvH6XrYkl7QO4Mzt
         as+w==
X-Gm-Message-State: AOAM530L91Tdo3U0BC0BhVLXOB2ggt0h2IWv/WRVjsuprz4u+e1pijxT
        lepEQfcvQEJpTk5jfGTrYvbY/D9RvO/Bqm55icfKjy70jtMhLQ==
X-Google-Smtp-Source: ABdhPJyJxuBV/uJZZhzzNbRjrZxQLROU+4Ucqqbti5noEvVDrdiFWuCWiOyFcxZFCb/sBhiP8wYqX4LQ++GrBZJzJPc=
X-Received: by 2002:a05:6000:1f18:b0:20f:e61b:520e with SMTP id
 bv24-20020a0560001f1800b0020fe61b520emr56401364wrb.214.1655112699798; Mon, 13
 Jun 2022 02:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220613085307.260256-1-alexandre.ghiti@canonical.com>
In-Reply-To: <20220613085307.260256-1-alexandre.ghiti@canonical.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 13 Jun 2022 15:01:28 +0530
Message-ID: <CAAhSdy1gr_WvCJUMXMwtZUux9qBsW-b_LGFg4=tdnkv5b538sg@mail.gmail.com>
Subject: Re: [PATCH -fixes v2] riscv: Fix missing PAGE_PFN_MASK
To:     Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Palmer Dabbelt <palmer@dabbelt.com>
Cc:     =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Guo Ren <guoren@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 13, 2022 at 2:23 PM Alexandre Ghiti
<alexandre.ghiti@canonical.com> wrote:
>
> There are a bunch of functions that use the PFN from a page table entry
> that end up with the svpbmt upper-bits because they are missing the newly
> introduced PAGE_PFN_MASK which leads to wrong addresses conversions and
> then crash: fix this by adding this mask.
>
> Fixes: 100631b48ded ("riscv: Fix accessing pfn bits in PTEs for non-32bit variants")
> Signed-off-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

@Palmer let me know if you want me to take this through the KVM repo.

Regards,
Anup

> ---
>  arch/riscv/include/asm/pgtable-64.h | 12 ++++++------
>  arch/riscv/include/asm/pgtable.h    |  6 +++---
>  arch/riscv/kvm/mmu.c                |  2 +-
>  3 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
> index 5c2aba5efbd0..dc42375c2357 100644
> --- a/arch/riscv/include/asm/pgtable-64.h
> +++ b/arch/riscv/include/asm/pgtable-64.h
> @@ -175,7 +175,7 @@ static inline pud_t pfn_pud(unsigned long pfn, pgprot_t prot)
>
>  static inline unsigned long _pud_pfn(pud_t pud)
>  {
> -       return pud_val(pud) >> _PAGE_PFN_SHIFT;
> +       return __page_val_to_pfn(pud_val(pud));
>  }
>
>  static inline pmd_t *pud_pgtable(pud_t pud)
> @@ -278,13 +278,13 @@ static inline p4d_t pfn_p4d(unsigned long pfn, pgprot_t prot)
>
>  static inline unsigned long _p4d_pfn(p4d_t p4d)
>  {
> -       return p4d_val(p4d) >> _PAGE_PFN_SHIFT;
> +       return __page_val_to_pfn(p4d_val(p4d));
>  }
>
>  static inline pud_t *p4d_pgtable(p4d_t p4d)
>  {
>         if (pgtable_l4_enabled)
> -               return (pud_t *)pfn_to_virt(p4d_val(p4d) >> _PAGE_PFN_SHIFT);
> +               return (pud_t *)pfn_to_virt(__page_val_to_pfn(p4d_val(p4d)));
>
>         return (pud_t *)pud_pgtable((pud_t) { p4d_val(p4d) });
>  }
> @@ -292,7 +292,7 @@ static inline pud_t *p4d_pgtable(p4d_t p4d)
>
>  static inline struct page *p4d_page(p4d_t p4d)
>  {
> -       return pfn_to_page(p4d_val(p4d) >> _PAGE_PFN_SHIFT);
> +       return pfn_to_page(__page_val_to_pfn(p4d_val(p4d)));
>  }
>
>  #define pud_index(addr) (((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
> @@ -347,7 +347,7 @@ static inline void pgd_clear(pgd_t *pgd)
>  static inline p4d_t *pgd_pgtable(pgd_t pgd)
>  {
>         if (pgtable_l5_enabled)
> -               return (p4d_t *)pfn_to_virt(pgd_val(pgd) >> _PAGE_PFN_SHIFT);
> +               return (p4d_t *)pfn_to_virt(__page_val_to_pfn(pgd_val(pgd)));
>
>         return (p4d_t *)p4d_pgtable((p4d_t) { pgd_val(pgd) });
>  }
> @@ -355,7 +355,7 @@ static inline p4d_t *pgd_pgtable(pgd_t pgd)
>
>  static inline struct page *pgd_page(pgd_t pgd)
>  {
> -       return pfn_to_page(pgd_val(pgd) >> _PAGE_PFN_SHIFT);
> +       return pfn_to_page(__page_val_to_pfn(pgd_val(pgd)));
>  }
>  #define pgd_page(pgd)  pgd_page(pgd)
>
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 1d1be9d9419c..5dbd6610729b 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -261,7 +261,7 @@ static inline pgd_t pfn_pgd(unsigned long pfn, pgprot_t prot)
>
>  static inline unsigned long _pgd_pfn(pgd_t pgd)
>  {
> -       return pgd_val(pgd) >> _PAGE_PFN_SHIFT;
> +       return __page_val_to_pfn(pgd_val(pgd));
>  }
>
>  static inline struct page *pmd_page(pmd_t pmd)
> @@ -590,14 +590,14 @@ static inline pmd_t pmd_mkinvalid(pmd_t pmd)
>         return __pmd(pmd_val(pmd) & ~(_PAGE_PRESENT|_PAGE_PROT_NONE));
>  }
>
> -#define __pmd_to_phys(pmd)  (pmd_val(pmd) >> _PAGE_PFN_SHIFT << PAGE_SHIFT)
> +#define __pmd_to_phys(pmd)  (__page_val_to_pfn(pmd_val(pmd)) << PAGE_SHIFT)
>
>  static inline unsigned long pmd_pfn(pmd_t pmd)
>  {
>         return ((__pmd_to_phys(pmd) & PMD_MASK) >> PAGE_SHIFT);
>  }
>
> -#define __pud_to_phys(pud)  (pud_val(pud) >> _PAGE_PFN_SHIFT << PAGE_SHIFT)
> +#define __pud_to_phys(pud)  (__page_val_to_pfn(pud_val(pud)) << PAGE_SHIFT)
>
>  static inline unsigned long pud_pfn(pud_t pud)
>  {
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 1c00695ebee7..9826073fbc67 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -54,7 +54,7 @@ static inline unsigned long gstage_pte_index(gpa_t addr, u32 level)
>
>  static inline unsigned long gstage_pte_page_vaddr(pte_t pte)
>  {
> -       return (unsigned long)pfn_to_virt(pte_val(pte) >> _PAGE_PFN_SHIFT);
> +       return (unsigned long)pfn_to_virt(__page_val_to_pfn(pte_val(pte)));
>  }
>
>  static int gstage_page_size_to_level(unsigned long page_size, u32 *out_level)
> --
> 2.34.1
>

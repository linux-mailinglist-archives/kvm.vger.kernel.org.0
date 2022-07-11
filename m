Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7150D56D3B3
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 06:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiGKESG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 00:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGKESE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 00:18:04 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F12A18B35
        for <kvm@vger.kernel.org>; Sun, 10 Jul 2022 21:18:03 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id f39so6748452lfv.3
        for <kvm@vger.kernel.org>; Sun, 10 Jul 2022 21:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BXMvZ5KKLKE+nh0OYbWGNjBxoJw8VkWFj1ZZS1mY0SI=;
        b=ej7GRO+QKUJQH443sPYaA4gOJkZCo7IxmJpeWGl0AHhMCNInxVZNLwcZLElsVyptjU
         HhylwHvV+PAQSFFof10iJ3Tutb31VJYYIei1/pB0iuKwvu9hN5fNbOhaYDOajU/fN5+x
         dS+2r69qPtHMvstkwMGqSe80+dbmc+YQRJG/qRtXFtiEEDz3lbFXLdScVNoRLZevtRiU
         KZ0uCx/FGRKgdkwysWBbSVgc18Ibey3GaT5en28gRMQRXbfes9HT6YTTEeFwVzCmPusl
         W3cU8H8oiBBjedFYSna5ze/37MrNAuWwy+jkuhtT6NBzeeDeP8Ss8M3sBIntsGoDGe27
         CX0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BXMvZ5KKLKE+nh0OYbWGNjBxoJw8VkWFj1ZZS1mY0SI=;
        b=71U6jv/oyMz1sDp0yXqaSomhLcjEn326wXe2D7DQqh+aqXsKMIpBJgYAQjSDExMBVF
         3yFcWDMKk6CMJKa8N6cy+gk3JFGO8MZpbz76lElML42qX2rPSg3mzVaGI3xp8Qe3/KTK
         7X09zzvwikNqrDtqknQcZF8HedQMN5ZvoPoZ83HoffXnVJwHEO/K2ZaiKkbKDnzRRX5f
         okzah6FwvzKWueXNYMaJY3Qu+yVhf120xYGbO+l6mhlPY3oRSrMZpn49tbHHF13UKkwI
         Ghk85dheEf0+jorIl8yBRtIV97knhlwEJDsqjJjjmbPoOX/fF2uAccBmN1aeHf+K1IB+
         ucpw==
X-Gm-Message-State: AJIora8PfOxSFfIlXnuBw4T/O/1ixkG2O9Qkc836gaeBbrcNmQUBX4lc
        nAtgPlc/dyVZZZVK+s4C16UE/SlrrDdzaYHupnKlsw==
X-Google-Smtp-Source: AGRyM1uLPA/b/bMbbC5qfsVLjsr93id3RByQNKW8mBzZDyUntxtEJGIfmJ6aXXnyNhDo5y4BGMCTWvJhjWZ8nKtpZuk=
X-Received: by 2002:a19:5f46:0:b0:488:4e69:2da2 with SMTP id
 a6-20020a195f46000000b004884e692da2mr10794220lfj.130.1657513081932; Sun, 10
 Jul 2022 21:18:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220707145248.458771-1-apatel@ventanamicro.com> <20220707145248.458771-3-apatel@ventanamicro.com>
In-Reply-To: <20220707145248.458771-3-apatel@ventanamicro.com>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Mon, 11 Jul 2022 09:47:46 +0530
Message-ID: <CAK9=C2U9jmbgE7FDzBqGChd+HffBdod7+8b_n45HzqYY1amd_Q@mail.gmail.com>
Subject: Re: [PATCH 2/5] riscv: Fix missing PAGE_PFN_MASK
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 7, 2022 at 8:23 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> From: Alexandre Ghiti <alexandre.ghiti@canonical.com>
>
> There are a bunch of functions that use the PFN from a page table entry
> that end up with the svpbmt upper-bits because they are missing the newly
> introduced PAGE_PFN_MASK which leads to wrong addresses conversions and
> then crash: fix this by adding this mask.
>
> Fixes: 100631b48ded ("riscv: Fix accessing pfn bits in PTEs for non-32bit variants")
> Signed-off-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
> Reviewed-by: Anup Patel <anup@brainfault.org>

I have queued this patch for 5.19-rcX fixes which I will send-out this week.

Thanks,
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
> index 2965284a490d..b75d4e200064 100644
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

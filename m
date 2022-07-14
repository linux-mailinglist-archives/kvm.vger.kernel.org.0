Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0B45756BD
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 23:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240594AbiGNVNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 17:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbiGNVNM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 17:13:12 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6203B54640
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 14:13:07 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c3so2037166pfb.13
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 14:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=zujWsXV21W8ZcFmHduJwQJx5ZFVvbf7C8VVkfXRSy2E=;
        b=lIqNnDPkpJUvBLG7ABgDbLC861u3by8ymz3X+gJ8jK4xa2Ln2rbtrn0NLGyyHzz3+D
         KACRQPzBjHEYqYbstkRIa3NGshT+rjq//RAha9/GBGn5rEUCCjw//Np+pXfaQh0YEDvw
         ZTPbtF84b7unvShUcY8l5h4jZvCQn5berhy1ZSSNPidkwTNP8i14mkZ/Irmo1UBDWUdM
         jTGWJfkEWdYLjcVP5U6v8M1z0oyWxxpfLHYHQGJuCm8UE6LbT/iF5XzaPZnxBtpNiW2i
         2aH962uxVwu8OdezamXVDM2PyWLvOLQGtEqKEIeMWABR9PDndkO6uvdZVmHF6B0mw95X
         qu3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=zujWsXV21W8ZcFmHduJwQJx5ZFVvbf7C8VVkfXRSy2E=;
        b=ENRiGJA3Kk7PERfGD6bWqHvSCceHqnJhNfhY/d45YsDAT/XZT1DNLuAP76OtLPJs9r
         5UNWxYyiJstpLnTt2Sfs1b6Rn3wwYesxvt6JHEym8VJkzRdPhbgRPsESvgQMv6HerVm1
         oMgVYQnppulnVwvNEsUAvZTuAgtC92fzCsD+1snkPUmJbCBla0u+e6qVLm24Z87oeEEy
         A+5E6dYL7JCFNB/JmOC4GICSZAteJNi795p6+4uv2ixk/XnMfSGlx5GOSd/rtL0kgVnk
         UVg1oNstDuYNbbWqD3Htufs5azeQ/Vix1iFK2mwIW4O2zJiAJkvC7KPW3K206ZsLUEAr
         q+3g==
X-Gm-Message-State: AJIora/f3lZXUfnkWvU7IJdnIpX+O+1XaXpC3Tx0WDVOotCM0HIxVBbu
        Ymccz5wKa1KQfHM7xOeN+lfK3lJNaDfg2A==
X-Google-Smtp-Source: AGRyM1s2Z1Rtnu16BV2sAjAGLa1lblRBK6bLRO+8Qea0GtWYFkSZ8UBJBZwyTv4+pxQEgVszbxIBCQ==
X-Received: by 2002:a05:6a00:21c2:b0:4fa:914c:2c2b with SMTP id t2-20020a056a0021c200b004fa914c2c2bmr10414427pfj.56.1657833186779;
        Thu, 14 Jul 2022 14:13:06 -0700 (PDT)
Received: from localhost ([50.221.140.186])
        by smtp.gmail.com with ESMTPSA id v21-20020a170902ca9500b0016b80d2fac8sm1877913pld.248.2022.07.14.14.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 14:13:05 -0700 (PDT)
Date:   Thu, 14 Jul 2022 14:13:05 -0700 (PDT)
X-Google-Original-Date: Thu, 14 Jul 2022 14:13:04 PDT (-0700)
Subject:     Re: [PATCH -fixes v2] riscv: Fix missing PAGE_PFN_MASK
In-Reply-To: <CAAhSdy3_EvAZJtHxFH=ihrfUaPUmp5EbXNY4eD+CRsiqNkYx9w@mail.gmail.com>
CC:     alexandre.ghiti@canonical.com, heiko@sntech.de, guoren@kernel.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, atishp@atishpatra.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     anup@brainfault.org
Message-ID: <mhng-0f4afa61-94cd-4471-9768-3a86c8a4678a@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 07 Jul 2022 07:56:31 PDT (-0700), anup@brainfault.org wrote:
> Hi Palmer,
>
> On Mon, Jun 13, 2022 at 3:01 PM Anup Patel <anup@brainfault.org> wrote:
>>
>> On Mon, Jun 13, 2022 at 2:23 PM Alexandre Ghiti
>> <alexandre.ghiti@canonical.com> wrote:
>> >
>> > There are a bunch of functions that use the PFN from a page table entry
>> > that end up with the svpbmt upper-bits because they are missing the newly
>> > introduced PAGE_PFN_MASK which leads to wrong addresses conversions and
>> > then crash: fix this by adding this mask.
>> >
>> > Fixes: 100631b48ded ("riscv: Fix accessing pfn bits in PTEs for non-32bit variants")
>> > Signed-off-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
>>
>> Looks good to me.
>>
>> Reviewed-by: Anup Patel <anup@brainfault.org>
>>
>> @Palmer let me know if you want me to take this through the KVM repo.
>
> This patch is required for KVM Svpbmt support so I have included it
> in my KVM RISC-V Svpbmt series.
>
> Let me know if you plan to send this as fix for Linux-5.19-rcX

Sorry I missed this one.

Acked-by: Palmer Dabbelt <palmer@rivosinc.com>

as it sounds like you already have it in a tree, but LMK if you wanted 
me to.

>
> Regards,
> Anup
>
>>
>> Regards,
>> Anup
>>
>> > ---
>> >  arch/riscv/include/asm/pgtable-64.h | 12 ++++++------
>> >  arch/riscv/include/asm/pgtable.h    |  6 +++---
>> >  arch/riscv/kvm/mmu.c                |  2 +-
>> >  3 files changed, 10 insertions(+), 10 deletions(-)
>> >
>> > diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
>> > index 5c2aba5efbd0..dc42375c2357 100644
>> > --- a/arch/riscv/include/asm/pgtable-64.h
>> > +++ b/arch/riscv/include/asm/pgtable-64.h
>> > @@ -175,7 +175,7 @@ static inline pud_t pfn_pud(unsigned long pfn, pgprot_t prot)
>> >
>> >  static inline unsigned long _pud_pfn(pud_t pud)
>> >  {
>> > -       return pud_val(pud) >> _PAGE_PFN_SHIFT;
>> > +       return __page_val_to_pfn(pud_val(pud));
>> >  }
>> >
>> >  static inline pmd_t *pud_pgtable(pud_t pud)
>> > @@ -278,13 +278,13 @@ static inline p4d_t pfn_p4d(unsigned long pfn, pgprot_t prot)
>> >
>> >  static inline unsigned long _p4d_pfn(p4d_t p4d)
>> >  {
>> > -       return p4d_val(p4d) >> _PAGE_PFN_SHIFT;
>> > +       return __page_val_to_pfn(p4d_val(p4d));
>> >  }
>> >
>> >  static inline pud_t *p4d_pgtable(p4d_t p4d)
>> >  {
>> >         if (pgtable_l4_enabled)
>> > -               return (pud_t *)pfn_to_virt(p4d_val(p4d) >> _PAGE_PFN_SHIFT);
>> > +               return (pud_t *)pfn_to_virt(__page_val_to_pfn(p4d_val(p4d)));
>> >
>> >         return (pud_t *)pud_pgtable((pud_t) { p4d_val(p4d) });
>> >  }
>> > @@ -292,7 +292,7 @@ static inline pud_t *p4d_pgtable(p4d_t p4d)
>> >
>> >  static inline struct page *p4d_page(p4d_t p4d)
>> >  {
>> > -       return pfn_to_page(p4d_val(p4d) >> _PAGE_PFN_SHIFT);
>> > +       return pfn_to_page(__page_val_to_pfn(p4d_val(p4d)));
>> >  }
>> >
>> >  #define pud_index(addr) (((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
>> > @@ -347,7 +347,7 @@ static inline void pgd_clear(pgd_t *pgd)
>> >  static inline p4d_t *pgd_pgtable(pgd_t pgd)
>> >  {
>> >         if (pgtable_l5_enabled)
>> > -               return (p4d_t *)pfn_to_virt(pgd_val(pgd) >> _PAGE_PFN_SHIFT);
>> > +               return (p4d_t *)pfn_to_virt(__page_val_to_pfn(pgd_val(pgd)));
>> >
>> >         return (p4d_t *)p4d_pgtable((p4d_t) { pgd_val(pgd) });
>> >  }
>> > @@ -355,7 +355,7 @@ static inline p4d_t *pgd_pgtable(pgd_t pgd)
>> >
>> >  static inline struct page *pgd_page(pgd_t pgd)
>> >  {
>> > -       return pfn_to_page(pgd_val(pgd) >> _PAGE_PFN_SHIFT);
>> > +       return pfn_to_page(__page_val_to_pfn(pgd_val(pgd)));
>> >  }
>> >  #define pgd_page(pgd)  pgd_page(pgd)
>> >
>> > diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
>> > index 1d1be9d9419c..5dbd6610729b 100644
>> > --- a/arch/riscv/include/asm/pgtable.h
>> > +++ b/arch/riscv/include/asm/pgtable.h
>> > @@ -261,7 +261,7 @@ static inline pgd_t pfn_pgd(unsigned long pfn, pgprot_t prot)
>> >
>> >  static inline unsigned long _pgd_pfn(pgd_t pgd)
>> >  {
>> > -       return pgd_val(pgd) >> _PAGE_PFN_SHIFT;
>> > +       return __page_val_to_pfn(pgd_val(pgd));
>> >  }
>> >
>> >  static inline struct page *pmd_page(pmd_t pmd)
>> > @@ -590,14 +590,14 @@ static inline pmd_t pmd_mkinvalid(pmd_t pmd)
>> >         return __pmd(pmd_val(pmd) & ~(_PAGE_PRESENT|_PAGE_PROT_NONE));
>> >  }
>> >
>> > -#define __pmd_to_phys(pmd)  (pmd_val(pmd) >> _PAGE_PFN_SHIFT << PAGE_SHIFT)
>> > +#define __pmd_to_phys(pmd)  (__page_val_to_pfn(pmd_val(pmd)) << PAGE_SHIFT)
>> >
>> >  static inline unsigned long pmd_pfn(pmd_t pmd)
>> >  {
>> >         return ((__pmd_to_phys(pmd) & PMD_MASK) >> PAGE_SHIFT);
>> >  }
>> >
>> > -#define __pud_to_phys(pud)  (pud_val(pud) >> _PAGE_PFN_SHIFT << PAGE_SHIFT)
>> > +#define __pud_to_phys(pud)  (__page_val_to_pfn(pud_val(pud)) << PAGE_SHIFT)
>> >
>> >  static inline unsigned long pud_pfn(pud_t pud)
>> >  {
>> > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
>> > index 1c00695ebee7..9826073fbc67 100644
>> > --- a/arch/riscv/kvm/mmu.c
>> > +++ b/arch/riscv/kvm/mmu.c
>> > @@ -54,7 +54,7 @@ static inline unsigned long gstage_pte_index(gpa_t addr, u32 level)
>> >
>> >  static inline unsigned long gstage_pte_page_vaddr(pte_t pte)
>> >  {
>> > -       return (unsigned long)pfn_to_virt(pte_val(pte) >> _PAGE_PFN_SHIFT);
>> > +       return (unsigned long)pfn_to_virt(__page_val_to_pfn(pte_val(pte)));
>> >  }
>> >
>> >  static int gstage_page_size_to_level(unsigned long page_size, u32 *out_level)
>> > --
>> > 2.34.1
>> >

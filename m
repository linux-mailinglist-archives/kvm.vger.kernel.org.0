Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F254F35D44E
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 02:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbhDMAHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 20:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237762AbhDMAHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 20:07:17 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB146C061756
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:06:58 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id r5so4439993ilb.2
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wi5y58NXhaqWJqCu7rykbp59hRwnukVU5T9tEJRybe8=;
        b=iFgUEbfkuYGLYjek/vn6OyGcvRT0ASn89ADFGms+ENBK1UIlXIktEm3dG3Ak1YWvre
         wM+rCeo2ePfcJJ2APzALUB//X/vSC0ytlevnrHT6ojYCQiLUujeUvujyCXAbky+hZnZH
         0DUwx5fDjSzBvVhAAJWnhISC+XMFM8fUuL3xvqRd5v6jQ/UxU2O2FBc2ok2gKhMKKaaC
         CtcnjJNQjtBQrJJppmgTrU4nf6Wy3bf3AvK1s4ZRP/+gqEE1ishwESM+4lSu4ufXbw3I
         rRy9TW+e0jg0fKQV87RWUfztjyaGtIUKUVhd4fEpI4pBL81KnTy83nRlRiayZA2pvWlI
         S/UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wi5y58NXhaqWJqCu7rykbp59hRwnukVU5T9tEJRybe8=;
        b=g6a2bMrLdJ9BgArhKvDAYZ2/yBcxwHybyRee/HuVVmlqdJNXcyFsRX9E+lvUrHl4Qe
         3cQyLM5r6Ol/SXuSCWDf/ZdtCOphO6ZxRbV4UNyK/DzcYqt3SQn6HO4kjNsUUvveJL6Z
         Q9t+oFAAy6tToZ6S6PhjqemrdF6frDiIwRDU4vf/SD9nlJjii5bHeH+Muh6A/5ueijSB
         awObD885k7IQw9JGwr4HDw+dnEPaLyZN68xU2toDyk5UylO/yWdypESfmO08bNVWBRZ7
         HtJTTUE5OjKxNjy24EAqvLeB+OdgImfMP8RthmpHt7k6m77FXEH1ruzp+0ka9e0EyzHs
         eW0g==
X-Gm-Message-State: AOAM530ltRQQPVyGyQvMvl6chbd9aM1nqq0hms7OrbBxez2fJs5JJW7F
        B/VYjThMKPLuoLLwgSypOhiqRNWblV6Cc2gp/Wh5iw==
X-Google-Smtp-Source: ABdhPJzL9b49ItYd+mw5mgINWsaHfu+pNeOHloM1N2RQWofppr7WxvE+6yes6Vca5KNe0SZCkoDOdWf8ui7+d+uwO8A=
X-Received: by 2002:a05:6e02:1e08:: with SMTP id g8mr25434450ila.176.1618272418171;
 Mon, 12 Apr 2021 17:06:58 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618254007.git.ashish.kalra@amd.com> <f2340642c5b8d597a099285194fca8d05c9843bd.1618254007.git.ashish.kalra@amd.com>
In-Reply-To: <f2340642c5b8d597a099285194fca8d05c9843bd.1618254007.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 12 Apr 2021 17:06:21 -0700
Message-ID: <CABayD+cofJ4FA-ZVmMpFLAA4MnDPOoAyg5=hAT=vtsfZXbYb1Q@mail.gmail.com>
Subject: Re: [PATCH v12 09/13] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 12:45 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> Invoke a hypercall when a memory region is changed from encrypted ->
> decrypted and vice versa. Hypervisor needs to know the page encryption
> status during the guest migration.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/include/asm/paravirt.h       | 10 +++++
>  arch/x86/include/asm/paravirt_types.h |  2 +
>  arch/x86/kernel/paravirt.c            |  1 +
>  arch/x86/mm/mem_encrypt.c             | 57 ++++++++++++++++++++++++++-
>  arch/x86/mm/pat/set_memory.c          |  7 ++++
>  5 files changed, 76 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index 4abf110e2243..efaa3e628967 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -84,6 +84,12 @@ static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
>         PVOP_VCALL1(mmu.exit_mmap, mm);
>  }
>
> +static inline void page_encryption_changed(unsigned long vaddr, int npages,
> +                                               bool enc)
> +{
> +       PVOP_VCALL3(mmu.page_encryption_changed, vaddr, npages, enc);
> +}
> +
>  #ifdef CONFIG_PARAVIRT_XXL
>  static inline void load_sp0(unsigned long sp0)
>  {
> @@ -799,6 +805,10 @@ static inline void paravirt_arch_dup_mmap(struct mm_struct *oldmm,
>  static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
>  {
>  }
> +
> +static inline void page_encryption_changed(unsigned long vaddr, int npages, bool enc)
> +{
> +}
>  #endif
>  #endif /* __ASSEMBLY__ */
>  #endif /* _ASM_X86_PARAVIRT_H */
> diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
> index de87087d3bde..69ef9c207b38 100644
> --- a/arch/x86/include/asm/paravirt_types.h
> +++ b/arch/x86/include/asm/paravirt_types.h
> @@ -195,6 +195,8 @@ struct pv_mmu_ops {
>
>         /* Hook for intercepting the destruction of an mm_struct. */
>         void (*exit_mmap)(struct mm_struct *mm);
> +       void (*page_encryption_changed)(unsigned long vaddr, int npages,
> +                                       bool enc);
>
>  #ifdef CONFIG_PARAVIRT_XXL
>         struct paravirt_callee_save read_cr2;
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index c60222ab8ab9..9f206e192f6b 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -335,6 +335,7 @@ struct paravirt_patch_template pv_ops = {
>                         (void (*)(struct mmu_gather *, void *))tlb_remove_page,
>
>         .mmu.exit_mmap          = paravirt_nop,
> +       .mmu.page_encryption_changed    = paravirt_nop,
>
>  #ifdef CONFIG_PARAVIRT_XXL
>         .mmu.read_cr2           = __PV_IS_CALLEE_SAVE(native_read_cr2),
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index ae78cef79980..fae9ccbd0da7 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -19,6 +19,7 @@
>  #include <linux/kernel.h>
>  #include <linux/bitops.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/kvm_para.h>
>
>  #include <asm/tlbflush.h>
>  #include <asm/fixmap.h>
> @@ -29,6 +30,7 @@
>  #include <asm/processor-flags.h>
>  #include <asm/msr.h>
>  #include <asm/cmdline.h>
> +#include <asm/kvm_para.h>
>
>  #include "mm_internal.h"
>
> @@ -229,6 +231,47 @@ void __init sev_setup_arch(void)
>         swiotlb_adjust_size(size);
>  }
>
> +static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
> +                                       bool enc)
> +{
> +       unsigned long sz = npages << PAGE_SHIFT;
> +       unsigned long vaddr_end, vaddr_next;
> +
> +       vaddr_end = vaddr + sz;
> +
> +       for (; vaddr < vaddr_end; vaddr = vaddr_next) {
> +               int psize, pmask, level;
> +               unsigned long pfn;
> +               pte_t *kpte;
> +
> +               kpte = lookup_address(vaddr, &level);
> +               if (!kpte || pte_none(*kpte))
> +                       return;
> +
> +               switch (level) {
> +               case PG_LEVEL_4K:
> +                       pfn = pte_pfn(*kpte);
> +                       break;
> +               case PG_LEVEL_2M:
> +                       pfn = pmd_pfn(*(pmd_t *)kpte);
> +                       break;
> +               case PG_LEVEL_1G:
> +                       pfn = pud_pfn(*(pud_t *)kpte);
> +                       break;
> +               default:
> +                       return;
> +               }
> +
> +               psize = page_level_size(level);
> +               pmask = page_level_mask(level);
> +
> +               kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
> +                                  pfn << PAGE_SHIFT, psize >> PAGE_SHIFT, enc);
> +
> +               vaddr_next = (vaddr & pmask) + psize;
> +       }
> +}
> +
>  static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
>  {
>         pgprot_t old_prot, new_prot;
> @@ -286,12 +329,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
>  static int __init early_set_memory_enc_dec(unsigned long vaddr,
>                                            unsigned long size, bool enc)
>  {
> -       unsigned long vaddr_end, vaddr_next;
> +       unsigned long vaddr_end, vaddr_next, start;
>         unsigned long psize, pmask;
>         int split_page_size_mask;
>         int level, ret;
>         pte_t *kpte;
>
> +       start = vaddr;
>         vaddr_next = vaddr;
>         vaddr_end = vaddr + size;
>
> @@ -346,6 +390,8 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
>
>         ret = 0;
>
> +       set_memory_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT,
> +                                       enc);
>  out:
>         __flush_tlb_all();
>         return ret;
> @@ -481,6 +527,15 @@ void __init mem_encrypt_init(void)
>         if (sev_active() && !sev_es_active())
>                 static_branch_enable(&sev_enable_key);
>
> +#ifdef CONFIG_PARAVIRT
> +       /*
> +        * With SEV, we need to make a hypercall when page encryption state is
> +        * changed.
> +        */
> +       if (sev_active())
> +               pv_ops.mmu.page_encryption_changed = set_memory_enc_dec_hypercall;
> +#endif
> +
>         print_mem_encrypt_feature_info();
>  }
>
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 16f878c26667..3576b583ac65 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -27,6 +27,7 @@
>  #include <asm/proto.h>
>  #include <asm/memtype.h>
>  #include <asm/set_memory.h>
> +#include <asm/paravirt.h>
>
>  #include "../mm_internal.h"
>
> @@ -2012,6 +2013,12 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>          */
>         cpa_flush(&cpa, 0);
>
> +       /* Notify hypervisor that a given memory range is mapped encrypted
> +        * or decrypted. The hypervisor will use this information during the
> +        * VM migration.
> +        */
> +       page_encryption_changed(addr, numpages, enc);
> +
>         return ret;
>  }
>
> --
> 2.17.1
>
Reviewed-by: Steve Rutherford <srutherford@google.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC071E8D0D
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 04:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgE3CGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 22:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728675AbgE3CGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 22:06:48 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870CCC08C5C9
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:06:48 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id s18so1412520ioe.2
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ersu1mZ/1WuvaD6HFrhHHPAf97XG85DrOF7Hn6OZ+tQ=;
        b=BdsJnM9HjseQdQC9SsuJV5ZrQ7JrYcjAVT+V9X0frMCJQgIgxEoD/hNHqE13V1wkOq
         tDDW32l8or4sQCGPDjnX6KCJAMU3TcaquxFVWXq3CbhFQBSYN0ZrNMn816CFHeDGABWF
         UMi9faKdDxpihoSfKZGsv7R6kyIaPl1HfWdad4D0/HpwpUzTFJiw6Odere/8GlXfQaEL
         76CMJDKLe11Pa5DpxHHqtLrSdOJht52abSICqvKzURsH+wTIBe35zi/kGMfmhmRJdAHb
         nIMiXkQAlwmsLhX5Q8rhOudv0YH2W0erv7Uhi9ZYKJ29VdXFSWtSMt27FBGZEGwMas3h
         m1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ersu1mZ/1WuvaD6HFrhHHPAf97XG85DrOF7Hn6OZ+tQ=;
        b=EnNicbq6q03wqq3KQ9FutIxCr8guP5yLanP42PchFtJntSzmr9YLHy3MGhVRp0UwaZ
         6+EQgp6Z9W4IaD4rwTm9AZBwqfPcr6135DfWjebyRefQSZG+kN0sq5CIljLOBwA7ch23
         HgdzyRfZN0gfTGQFlTETi3obstLSrMwvivUBjoffzf/e5bA4jKsbp02iTgFYrDJCBlu9
         QOg+9K46AGOURTKPPgvefmYlPPXGSltGFaEb2thjK60C0zvU69p7GHcMM8zTOnSNEt2y
         KH0+n7Fs1DN0f+/1F79uguCHWOJRNLvjTroDEa0/Ffwm1pqET7S4F+qqNHSEjEV3BvkA
         P/Yg==
X-Gm-Message-State: AOAM531LNOM2JnSsXQJEcdcKSoLfhctpAUCaWT7rTJbI7EJqHd2RkSAA
        hLR19tkoLibrb3dsXY+v0aSeZuNTzU13Ay4mKHUUpg==
X-Google-Smtp-Source: ABdhPJzkCqLNyzENTjt5R/TF1WiMNGTAN8xygUYGv2tzhjPu35nGiVNLG0GOjZnOTZ6XRf3ba4wwoHUairCPcpybmAE=
X-Received: by 2002:a02:cd2b:: with SMTP id h11mr3970089jaq.47.1590804407605;
 Fri, 29 May 2020 19:06:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1588711355.git.ashish.kalra@amd.com> <40272f7b19bd179b094ac1305c787f7e5002c068.1588711355.git.ashish.kalra@amd.com>
In-Reply-To: <40272f7b19bd179b094ac1305c787f7e5002c068.1588711355.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 29 May 2020 19:06:11 -0700
Message-ID: <CABayD+eWaTF+yekA8_PxN4OtEYDe_y87ohC=iKmkNvqKEuUiTw@mail.gmail.com>
Subject: Re: [PATCH v8 10/18] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 5, 2020 at 2:18 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <Brijesh.Singh@amd.com>
>
> Invoke a hypercall when a memory region is changed from encrypted ->
> decrypted and vice versa. Hypervisor needs to know the page encryption
> status during the guest migration.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Kr=C4=8Dm=C3=A1=C5=99" <rkrcmar@redhat.com>
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
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/parav=
irt.h
> index 694d8daf4983..8127b9c141bf 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -78,6 +78,12 @@ static inline void paravirt_arch_exit_mmap(struct mm_s=
truct *mm)
>         PVOP_VCALL1(mmu.exit_mmap, mm);
>  }
>
> +static inline void page_encryption_changed(unsigned long vaddr, int npag=
es,
> +                                               bool enc)
> +{
> +       PVOP_VCALL3(mmu.page_encryption_changed, vaddr, npages, enc);
> +}
> +
>  #ifdef CONFIG_PARAVIRT_XXL
>  static inline void load_sp0(unsigned long sp0)
>  {
> @@ -946,6 +952,10 @@ static inline void paravirt_arch_dup_mmap(struct mm_=
struct *oldmm,
>  static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
>  {
>  }
> +
> +static inline void page_encryption_changed(unsigned long vaddr, int npag=
es, bool enc)
> +{
> +}
>  #endif
>  #endif /* __ASSEMBLY__ */
>  #endif /* _ASM_X86_PARAVIRT_H */
> diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm=
/paravirt_types.h
> index 732f62e04ddb..03bfd515c59c 100644
> --- a/arch/x86/include/asm/paravirt_types.h
> +++ b/arch/x86/include/asm/paravirt_types.h
> @@ -215,6 +215,8 @@ struct pv_mmu_ops {
>
>         /* Hook for intercepting the destruction of an mm_struct. */
>         void (*exit_mmap)(struct mm_struct *mm);
> +       void (*page_encryption_changed)(unsigned long vaddr, int npages,
> +                                       bool enc);
>
>  #ifdef CONFIG_PARAVIRT_XXL
>         struct paravirt_callee_save read_cr2;
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index c131ba4e70ef..840c02b23aeb 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -367,6 +367,7 @@ struct paravirt_patch_template pv_ops =3D {
>                         (void (*)(struct mmu_gather *, void *))tlb_remove=
_page,
>
>         .mmu.exit_mmap          =3D paravirt_nop,
> +       .mmu.page_encryption_changed    =3D paravirt_nop,
>
>  #ifdef CONFIG_PARAVIRT_XXL
>         .mmu.read_cr2           =3D __PV_IS_CALLEE_SAVE(native_read_cr2),
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index f4bd4b431ba1..c9800fa811f6 100644
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
> @@ -196,6 +198,47 @@ void __init sme_early_init(void)
>                 swiotlb_force =3D SWIOTLB_FORCE;
>  }
>
> +static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages=
,
> +                                       bool enc)
> +{
> +       unsigned long sz =3D npages << PAGE_SHIFT;
> +       unsigned long vaddr_end, vaddr_next;
> +
> +       vaddr_end =3D vaddr + sz;
> +
> +       for (; vaddr < vaddr_end; vaddr =3D vaddr_next) {
> +               int psize, pmask, level;
> +               unsigned long pfn;
> +               pte_t *kpte;
> +
> +               kpte =3D lookup_address(vaddr, &level);
> +               if (!kpte || pte_none(*kpte))
> +                       return;
> +
> +               switch (level) {
> +               case PG_LEVEL_4K:
> +                       pfn =3D pte_pfn(*kpte);
> +                       break;
> +               case PG_LEVEL_2M:
> +                       pfn =3D pmd_pfn(*(pmd_t *)kpte);
> +                       break;
> +               case PG_LEVEL_1G:
> +                       pfn =3D pud_pfn(*(pud_t *)kpte);
> +                       break;
> +               default:
> +                       return;
> +               }
> +
> +               psize =3D page_level_size(level);
> +               pmask =3D page_level_mask(level);
> +
> +               kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
> +                                  pfn << PAGE_SHIFT, psize >> PAGE_SHIFT=
, enc);
> +
> +               vaddr_next =3D (vaddr & pmask) + psize;
> +       }
> +}
> +
>  static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
>  {
>         pgprot_t old_prot, new_prot;
> @@ -253,12 +296,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, i=
nt level, bool enc)
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
> +       start =3D vaddr;
>         vaddr_next =3D vaddr;
>         vaddr_end =3D vaddr + size;
>
> @@ -313,6 +357,8 @@ static int __init early_set_memory_enc_dec(unsigned l=
ong vaddr,
>
>         ret =3D 0;
>
> +       set_memory_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIF=
T,
> +                                       enc);
>  out:
>         __flush_tlb_all();
>         return ret;
> @@ -451,6 +497,15 @@ void __init mem_encrypt_init(void)
>         if (sev_active())
>                 static_branch_enable(&sev_enable_key);
>
> +#ifdef CONFIG_PARAVIRT
> +       /*
> +        * With SEV, we need to make a hypercall when page encryption sta=
te is
> +        * changed.
> +        */
> +       if (sev_active())
> +               pv_ops.mmu.page_encryption_changed =3D set_memory_enc_dec=
_hypercall;
> +#endif
> +
>         pr_info("AMD %s active\n",
>                 sev_active() ? "Secure Encrypted Virtualization (SEV)"
>                              : "Secure Memory Encryption (SME)");
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 59eca6a94ce7..9aaf1b6f5a1b 100644
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
> @@ -2003,6 +2004,12 @@ static int __set_memory_enc_dec(unsigned long addr=
, int numpages, bool enc)
>          */
>         cpa_flush(&cpa, 0);
>
> +       /* Notify hypervisor that a given memory range is mapped encrypte=
d
> +        * or decrypted. The hypervisor will use this information during =
the
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

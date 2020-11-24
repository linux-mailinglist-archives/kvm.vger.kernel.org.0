Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BF02C213F
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 10:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731221AbgKXJ1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 04:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728517AbgKXJ06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 04:26:58 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7637AC0613D6
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 01:26:58 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id s9so21157878ljo.11
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 01:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kukcRBKUzlxamYfGZyLQcYKTY8NzjKcvgUjtKw6Awcs=;
        b=mTKhkigHDoPSK5lJonpLM+ptC9nzL1l0tydMD89elegFPdySD76uSEJsbq+YHeYnxf
         Rz4FfjcDwKYN8FfQRRD+CLwKIrxw+xcIQTUUulqIGLJnGJJtpBcYxFzRdgpwQ6SWMOo+
         q3PkgZauF0skJeSgzy6EUgoeZeJJIR3+wesynyuOYU7UUggGUuSO4MnumIkz/7FpUgH7
         bPgZc731EbjWDEHb8hURC9bd0FVBXY8DcP4BR/R1Jo7TNsiP+2/tiOAVr2NZKsL2GNJp
         Jz0F1Lwi4OR9qB/Gy/s392aYCVV5Fn7wwJXzfaxfm5gTj6TFxF3WmE5GY7WRrHhjdS8B
         IXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kukcRBKUzlxamYfGZyLQcYKTY8NzjKcvgUjtKw6Awcs=;
        b=IfQ6WmUTgcOZkPjO4S+bU6lRm3TMr5Hc+4THtUYaSjHol2bj3LxKsd09cSvjA/FTG5
         nVRDl/lkJLuAx1g1w5p4M6Stakgev1eQzqP0lFylrJbc+Pf44dTlN0U00j1xino2MBhP
         t6Iw5Lxhq0oEqnrLo/jx9qTiC2fpT+l2g1trZuUrsvqmgKma6tEpn6HT7UIVHdSNbncQ
         6N5BDiKv236Jlyg0RNyOVgMDN0Ke+Kv1aZZ6/n2Lpl8qO7G3V+jr4Tor+0xyMbUlvDrR
         ZDcRAsTFA7wIBBxGt+T6npyJ2bd3He+zfTQdBtD8crLw3kQOIsUZGlRR6BYuDz6LrUVA
         87aw==
X-Gm-Message-State: AOAM5303wWZNI4jUMmihhz7NeyasajU/JcSmRTJeGOcRWATsuqogtNVf
        FEO1SaXw64VuLQMM6kGcdf2yrMqKpUQGwsaZ/dy2MQ==
X-Google-Smtp-Source: ABdhPJwOkzwqjm2LNBXyYJWEcdhsLWfHn+ob5iB1SDuNQIbquePN0gEeSNq06vXwo6W+kH3ODe5+sRqpAfJ/VDCKf+s=
X-Received: by 2002:a05:651c:134f:: with SMTP id j15mr1495677ljb.469.1606210016792;
 Tue, 24 Nov 2020 01:26:56 -0800 (PST)
MIME-Version: 1.0
References: <20201109113240.3733496-1-anup.patel@wdc.com> <20201109113240.3733496-11-anup.patel@wdc.com>
 <186ade3c372b44ef8ca1830da8c5002b@huawei.com>
In-Reply-To: <186ade3c372b44ef8ca1830da8c5002b@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 24 Nov 2020 14:56:43 +0530
Message-ID: <CAAhSdy1sx_oLGGoGjzr5ZrPStwCyFF4mBDEBw5zpsbSGcCRJjg@mail.gmail.com>
Subject: Re: [PATCH v15 10/17] RISC-V: KVM: Implement stage2 page table programming
To:     Jiangyifei <jiangyifei@huawei.com>
Cc:     Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhangxiaofeng (F)" <victor.zhangxiaofeng@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "dengkai (A)" <dengkai1@huawei.com>,
        yinyipeng <yinyipeng1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 16, 2020 at 2:59 PM Jiangyifei <jiangyifei@huawei.com> wrote:
>
>
> > -----Original Message-----
> > From: Anup Patel [mailto:anup.patel@wdc.com]
> > Sent: Monday, November 9, 2020 7:33 PM
> > To: Palmer Dabbelt <palmer@dabbelt.com>; Palmer Dabbelt
> > <palmerdabbelt@google.com>; Paul Walmsley <paul.walmsley@sifive.com>;
> > Albert Ou <aou@eecs.berkeley.edu>; Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Alexander Graf <graf@amazon.com>; Atish Patra <atish.patra@wdc.com>;
> > Alistair Francis <Alistair.Francis@wdc.com>; Damien Le Moal
> > <damien.lemoal@wdc.com>; Anup Patel <anup@brainfault.org>;
> > kvm@vger.kernel.org; kvm-riscv@lists.infradead.org;
> > linux-riscv@lists.infradead.org; linux-kernel@vger.kernel.org; Anup Patel
> > <anup.patel@wdc.com>; Jiangyifei <jiangyifei@huawei.com>
> > Subject: [PATCH v15 10/17] RISC-V: KVM: Implement stage2 page table
> > programming
> >
> > This patch implements all required functions for programming the stage2 page
> > table for each Guest/VM.
> >
> > At high-level, the flow of stage2 related functions is similar from KVM
> > ARM/ARM64 implementation but the stage2 page table format is quite
> > different for KVM RISC-V.
> >
> > [jiangyifei: stage2 dirty log support]
> > Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> > Signed-off-by: Anup Patel <anup.patel@wdc.com>
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/riscv/include/asm/kvm_host.h     |  12 +
> >  arch/riscv/include/asm/pgtable-bits.h |   1 +
> >  arch/riscv/kvm/Kconfig                |   1 +
> >  arch/riscv/kvm/main.c                 |  19 +
> >  arch/riscv/kvm/mmu.c                  | 649
> > +++++++++++++++++++++++++-
> >  arch/riscv/kvm/vm.c                   |   6 -
> >  6 files changed, 672 insertions(+), 16 deletions(-)
> >
>
> ......
>
> >
> >  int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, @@ -69,27 +562,163 @@
> > int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
> >                        gpa_t gpa, unsigned long hva,
> >                        bool writeable, bool is_write)
> >  {
> > -     /* TODO: */
> > -     return 0;
> > +     int ret;
> > +     kvm_pfn_t hfn;
> > +     short vma_pageshift;
> > +     gfn_t gfn = gpa >> PAGE_SHIFT;
> > +     struct vm_area_struct *vma;
> > +     struct kvm *kvm = vcpu->kvm;
> > +     struct kvm_mmu_page_cache *pcache = &vcpu->arch.mmu_page_cache;
> > +     bool logging = (memslot->dirty_bitmap &&
> > +                     !(memslot->flags & KVM_MEM_READONLY)) ? true : false;
> > +     unsigned long vma_pagesize;
> > +
> > +     mmap_read_lock(current->mm);
> > +
> > +     vma = find_vma_intersection(current->mm, hva, hva + 1);
> > +     if (unlikely(!vma)) {
> > +             kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
> > +             mmap_read_unlock(current->mm);
> > +             return -EFAULT;
> > +     }
> > +
> > +     if (is_vm_hugetlb_page(vma))
> > +             vma_pageshift = huge_page_shift(hstate_vma(vma));
> > +     else
> > +             vma_pageshift = PAGE_SHIFT;
> > +     vma_pagesize = 1ULL << vma_pageshift;
> > +     if (logging || (vma->vm_flags & VM_PFNMAP))
> > +             vma_pagesize = PAGE_SIZE;
> > +
> > +     if (vma_pagesize == PMD_SIZE || vma_pagesize == PGDIR_SIZE)
> > +             gfn = (gpa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
> > +
> > +     mmap_read_unlock(current->mm);
> > +
> > +     if (vma_pagesize != PGDIR_SIZE &&
> > +         vma_pagesize != PMD_SIZE &&
> > +         vma_pagesize != PAGE_SIZE) {
> > +             kvm_err("Invalid VMA page size 0x%lx\n", vma_pagesize);
> > +             return -EFAULT;
> > +     }
> > +
> > +     /* We need minimum second+third level pages */
> > +     ret = stage2_cache_topup(pcache, stage2_pgd_levels,
> > +                              KVM_MMU_PAGE_CACHE_NR_OBJS);
> > +     if (ret) {
> > +             kvm_err("Failed to topup stage2 cache\n");
> > +             return ret;
> > +     }
> > +
> > +     hfn = gfn_to_pfn_prot(kvm, gfn, is_write, NULL);
> > +     if (hfn == KVM_PFN_ERR_HWPOISON) {
> > +             send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
> > +                             vma_pageshift, current);
> > +             return 0;
> > +     }
> > +     if (is_error_noslot_pfn(hfn))
> > +             return -EFAULT;
> > +
> > +     /*
> > +      * If logging is active then we allow writable pages only
> > +      * for write faults.
> > +      */
> > +     if (logging && !is_write)
> > +             writeable = false;
> > +
> > +     spin_lock(&kvm->mmu_lock);
> > +
> > +     if (writeable) {
>
> Hi Anup,
>
> What is the purpose of "writable = !memslot_is_readonly(slot)" in this series?

Where ? I don't see this line in any of the patches.

>
> When mapping the HVA to HPA above, it doesn't know that the PTE writeable of stage2 is "!memslot_is_readonly(slot)".
> This may causes the difference between the writability of HVA->HPA and GPA->HPA.
> For example, GPA->HPA is writeable, but HVA->HPA is not writeable.

Yes, this is possible particularly when Host kernel is updating writability
of HVA->HPA mappings for swapping in/out pages.

>
> Is it better that the writability of HVA->HPA is also determined by whether the memslot is readonly in this change?
> Like this:
> -    hfn = gfn_to_pfn_prot(kvm, gfn, is_write, NULL);
> +    hfn = gfn_to_pfn_prot(kvm, gfn, writeable, NULL);

The gfn_to_pfn_prot() needs to know what type of fault we
got (i.e read/write fault). Rest of the information (such as whether
slot is writable or not) is already available to gfn_to_pfn_prot().

The question here is should we pass "&writeable" or NULL as
last parameter to gfn_to_pfn_prot(). The recent JUMP label
support in Linux RISC-V causes problem on HW where PTE
'A' and 'D' bits are not updated by HW so I have to change
last parameter of gfn_to_pfn_prot() from "&writeable" to NULL.

I am still investigating this.

Regards,
Anup

>
> Regards,
> Yifei
>
> > +             kvm_set_pfn_dirty(hfn);
> > +             mark_page_dirty(kvm, gfn);
> > +             ret = stage2_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
> > +                                   vma_pagesize, false, true);
> > +     } else {
> > +             ret = stage2_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
> > +                                   vma_pagesize, true, true);
> > +     }
> > +
> > +     if (ret)
> > +             kvm_err("Failed to map in stage2\n");
> > +
> > +     spin_unlock(&kvm->mmu_lock);
> > +     kvm_set_pfn_accessed(hfn);
> > +     kvm_release_pfn_clean(hfn);
> > +     return ret;
> >  }
> >
>
> ......
>

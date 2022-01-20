Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040C1495231
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 17:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347070AbiATQRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 11:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbiATQRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 11:17:31 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9FBC061574
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 08:17:30 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id x22so23497766lfd.10
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 08:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A84aj5UGI1NYrvkhOFIhb/Cs0SMGHG68d0x1Mrz2Olk=;
        b=ofFZI5gQS4+4hIGdZCMWgXw5MgHoP0NCo/XNXBn3rS/1BFshHj85BeUabsurO1Jg8i
         SchSM2Vs7e4hoyEd4NqCQQN89yCrACaqhXPpGU0F/ME9zbm+gv/8mYfDvqnv6ih6YQZV
         AZuAFGHQY4gF0eC7Rcwin1957iLSGWiPRv/D50TPyRSHnJg2f5InZhpxIEAlwDrxr/nM
         av74W3HWHeooOBK9o4ve3/xwL1Dd9VRHVfKRlGWRLbMnG0BWfZhEmCqAQSW/Sj++IXxh
         XdqEz+PY4fpaJLYkzrzMgbsn2S/kEP1CqKLN6DKvoE3FBad8BOP6BJn0XqQEwGVYkDx8
         H1iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A84aj5UGI1NYrvkhOFIhb/Cs0SMGHG68d0x1Mrz2Olk=;
        b=mw5gZ9h/nTnZ7oGPCa5lLgIwTCF9IzjwrNfkzXuqWPlf24G0c1FZvavO4Ma72eE3BX
         B1wFNJAlc8iFP66HhUJn29UFmvsLXRZw7uznn2RU2LrIBddVONsMv/nB67xtUQjIn4bS
         YuHzeYmlfZ+45piZ3ccWYLI+6sb+2DDnNYfDaRQZdmZlhQkY/qi9Rjo6sDlFbVDecefZ
         rmuGkVfaQoEpd/SIjQ9gu1js3WPFtDYyt4C/+kYdtZ0rEna6IcneC/MUReHDNgYJdwmo
         gPjEdTrZxaPuiOUvV1Ky89020mghGJeyqR2D7iP1CR1a1XZlWhrQKZkHq3Jnv0Okc/1O
         srJw==
X-Gm-Message-State: AOAM533JhxIFniG3NOQlbSioF4NHVjPBtXufdnGAxxS4V1t8AMEdIQYO
        wE9/x0lUFaemEDlo6jStT2n/l/Kt+KtfNE9H+JkM2FmU24xXVQ==
X-Google-Smtp-Source: ABdhPJzgKvahsgA2dYfEUogEjezEPLnpfvYmPEnG4OkDlebsoQzHT8ag6j0avC3sA35DmmMhMEHBBzin14U+DLGr2gQ=
X-Received: by 2002:a05:6512:1293:: with SMTP id u19mr30390170lfs.373.1642695448810;
 Thu, 20 Jan 2022 08:17:28 -0800 (PST)
MIME-Version: 1.0
References: <20220118110621.62462-1-nikunj@amd.com> <20220118110621.62462-7-nikunj@amd.com>
In-Reply-To: <20220118110621.62462-7-nikunj@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 20 Jan 2022 09:17:17 -0700
Message-ID: <CAMkAt6p1-82LTRNB3pkPRwYh=wGpreUN=jcUeBj_dZt8ss9w0Q@mail.gmail.com>
Subject: Re: [RFC PATCH 6/6] KVM: SVM: Pin SEV pages in MMU during sev_launch_update_data()
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18, 2022 at 4:07 AM Nikunj A Dadhania <nikunj@amd.com> wrote:
>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Pin the memory for the data being passed to launch_update_data()
> because it gets encrypted before the guest is first run and must
> not be moved which would corrupt it.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> [ * Changed hva_to_gva() to take an extra argument and return gpa_t.
>   * Updated sev_pin_memory_in_mmu() error handling.
>   * As pinning/unpining pages is handled within MMU, removed
>     {get,put}_user(). ]
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 122 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 119 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 14aeccfc500b..1ae714e83a3c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -22,6 +22,7 @@
>  #include <asm/trapnr.h>
>  #include <asm/fpu/xcr.h>
>
> +#include "mmu.h"
>  #include "x86.h"
>  #include "svm.h"
>  #include "svm_ops.h"
> @@ -490,6 +491,110 @@ static unsigned long get_num_contig_pages(unsigned long idx,
>         return pages;
>  }
>
> +#define SEV_PFERR_RO (PFERR_USER_MASK)
> +#define SEV_PFERR_RW (PFERR_WRITE_MASK | PFERR_USER_MASK)
> +
> +static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm,
> +                                             unsigned long hva)
> +{
> +       struct kvm_memslots *slots = kvm_memslots(kvm);
> +       struct kvm_memory_slot *memslot;
> +       int bkt;
> +
> +       kvm_for_each_memslot(memslot, bkt, slots) {
> +               if (hva >= memslot->userspace_addr &&
> +                   hva < memslot->userspace_addr +
> +                   (memslot->npages << PAGE_SHIFT))
> +                       return memslot;
> +       }
> +
> +       return NULL;
> +}
> +
> +static gpa_t hva_to_gpa(struct kvm *kvm, unsigned long hva, bool *ro)
> +{
> +       struct kvm_memory_slot *memslot;
> +       gpa_t gpa_offset;
> +
> +       memslot = hva_to_memslot(kvm, hva);
> +       if (!memslot)
> +               return UNMAPPED_GVA;
> +
> +       *ro = !!(memslot->flags & KVM_MEM_READONLY);
> +       gpa_offset = hva - memslot->userspace_addr;
> +       return ((memslot->base_gfn << PAGE_SHIFT) + gpa_offset);
> +}
> +
> +static struct page **sev_pin_memory_in_mmu(struct kvm *kvm, unsigned long addr,
> +                                          unsigned long size,
> +                                          unsigned long *npages)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       struct kvm_vcpu *vcpu;
> +       struct page **pages;
> +       unsigned long i;
> +       u32 error_code;
> +       kvm_pfn_t pfn;
> +       int idx, ret = 0;
> +       gpa_t gpa;
> +       bool ro;
> +
> +       pages = sev_alloc_pages(sev, addr, size, npages);
> +       if (IS_ERR(pages))
> +               return pages;
> +
> +       vcpu = kvm_get_vcpu(kvm, 0);
> +       if (mutex_lock_killable(&vcpu->mutex)) {
> +               kvfree(pages);
> +               return ERR_PTR(-EINTR);
> +       }
> +
> +       vcpu_load(vcpu);
> +       idx = srcu_read_lock(&kvm->srcu);
> +
> +       kvm_mmu_load(vcpu);
> +
> +       for (i = 0; i < *npages; i++, addr += PAGE_SIZE) {
> +               if (signal_pending(current)) {
> +                       ret = -ERESTARTSYS;
> +                       break;
> +               }
> +
> +               if (need_resched())
> +                       cond_resched();
> +
> +               gpa = hva_to_gpa(kvm, addr, &ro);
> +               if (gpa == UNMAPPED_GVA) {
> +                       ret = -EFAULT;
> +                       break;
> +               }
> +
> +               error_code = ro ? SEV_PFERR_RO : SEV_PFERR_RW;
> +
> +               /*
> +                * Fault in the page and sev_pin_page() will handle the
> +                * pinning
> +                */
> +               pfn = kvm_mmu_map_tdp_page(vcpu, gpa, error_code, PG_LEVEL_4K);
> +               if (is_error_noslot_pfn(pfn)) {
> +                       ret = -EFAULT;
> +                       break;
> +               }
> +               pages[i] = pfn_to_page(pfn);
> +       }
> +
> +       kvm_mmu_unload(vcpu);
> +       srcu_read_unlock(&kvm->srcu, idx);
> +       vcpu_put(vcpu);
> +       mutex_unlock(&vcpu->mutex);
> +
> +       if (!ret)
> +               return pages;
> +
> +       kvfree(pages);
> +       return ERR_PTR(ret);
> +}
> +
>  static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
>         unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
> @@ -510,15 +615,21 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>         vaddr_end = vaddr + size;
>
>         /* Lock the user memory. */
> -       inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
> +       if (atomic_read(&kvm->online_vcpus))
> +               inpages = sev_pin_memory_in_mmu(kvm, vaddr, size, &npages);

IIUC we can only use the sev_pin_memory_in_mmu() when there is an
online vCPU because that means the MMU has been setup enough to use?
Can we add a variable and a comment to help explain that?

bool mmu_usable = atomic_read(&kvm->online_vcpus) > 0;

> +       else
> +               inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);

So I am confused about this case. Since svm_register_enc_region() is
now a NOOP how can a user ensure that memory remains pinned from
sev_launch_update_data() to when the memory would be demand pinned?

Before users could svm_register_enc_region() which pins the region,
then sev_launch_update_data(), then the VM could run an the data from
sev_launch_update_data() would have never moved. I don't think that
same guarantee is held here?

>         if (IS_ERR(inpages))
>                 return PTR_ERR(inpages);
>
>         /*
>          * Flush (on non-coherent CPUs) before LAUNCH_UPDATE encrypts pages in
>          * place; the cache may contain the data that was written unencrypted.
> +        * Flushing is automatically handled if the pages can be pinned in the
> +        * MMU.
>          */
> -       sev_clflush_pages(inpages, npages);
> +       if (!atomic_read(&kvm->online_vcpus))
> +               sev_clflush_pages(inpages, npages);
>
>         data.reserved = 0;
>         data.handle = sev->handle;
> @@ -553,8 +664,13 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>                 set_page_dirty_lock(inpages[i]);
>                 mark_page_accessed(inpages[i]);
>         }
> +
>         /* unlock the user pages */
> -       sev_unpin_memory(kvm, inpages, npages);
> +       if (atomic_read(&kvm->online_vcpus))
> +               kvfree(inpages);
> +       else
> +               sev_unpin_memory(kvm, inpages, npages);
> +
>         return ret;
>  }
>
> --
> 2.32.0
>

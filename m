Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7177496283
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 17:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381749AbiAUQA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 11:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381742AbiAUQAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 11:00:55 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6938EC061401
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 08:00:55 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id u14so3786687lfo.11
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 08:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rm8vjPtGZ5zXWk7rSNfQe3QS2BCPnlKSAViEt2BOUO4=;
        b=efZDQpznbQC/3ugWCSp26fz60QHSCKEWWx05lB/gr/BiloWxmX/dPOu3HTlhegFFI8
         wQSymmM7qZyUywJT54JcNlxujP7i53KSNPKeubgHnWSphVHbc0GbRNv3ERfdgqfcTt62
         h5uMo9B4TgU+0aVGgTiX3ozQez48ZfEH0E95pmVBNB1wHnd2YTxILmWa7EleYLD7hO9M
         ZZbiUj/d5xDUNhXY57s+wdTDwjXMDFWZ9xli4OA/OsGp7yUbHrfq33xEdVGkrLl7NdJ+
         JTXa9mwTwf3b9mvVEIWN6Wwr3sPpGoCcr8+zmcFkqZHuGDk7SebYiseRjMqPmcOYTa2e
         S+fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rm8vjPtGZ5zXWk7rSNfQe3QS2BCPnlKSAViEt2BOUO4=;
        b=FaSpNq84SCV0cX1ppXa9eMSiwYAOAY/Aq+qrSxvbVadMvf7HZKh8ZBxUKs0ZeS7Lli
         VsrQnVvhk5+9BipYRYw9txY/FMGD2XQXDLwgTTNqogYDh7IXLFx/54G3vSWxiZGUYpL+
         36fWeDlx6Ed34VnEwpxnIEMRs3SOUy/S+8W95s4Byt4EJEhTdSgifbFm7FbhCgHP7dqA
         VNnQeGHRHIuG98sD7dTPnGrqJi5LS2PQTPNFK+EX31g+uNzIYVqRltXIudavl0FY3UYR
         Qce0VzbeyBmKkzN7+FFfpmIwBA8yrKsYHWxAgPQwD5Q/kTG7vp+EVF7oD1oYC/TtWDgA
         5Pmg==
X-Gm-Message-State: AOAM531huqm9H3aXkbQERWfeTFTGgojIbcqmgXS48A6aiUmFGF3ulNGI
        WC16B7zvUCYeBhuhTJqrRzryic2/XJI3lYADOvV86A==
X-Google-Smtp-Source: ABdhPJydfd+V8GdHjrRsGRvLPH+hUFe7W7ZFeGH/1OfOz3BQfM24vhqub61JsJkK0zeCjo7DQJZBAvqyh2Q4sBu4b/M=
X-Received: by 2002:a05:6512:32c8:: with SMTP id f8mr4030942lfg.402.1642780853424;
 Fri, 21 Jan 2022 08:00:53 -0800 (PST)
MIME-Version: 1.0
References: <20220118110621.62462-1-nikunj@amd.com> <20220118110621.62462-7-nikunj@amd.com>
 <CAMkAt6p1-82LTRNB3pkPRwYh=wGpreUN=jcUeBj_dZt8ss9w0Q@mail.gmail.com> <4e68ae1c-e0ed-2620-fbd1-0f0f7eb28c4f@amd.com>
In-Reply-To: <4e68ae1c-e0ed-2620-fbd1-0f0f7eb28c4f@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 21 Jan 2022 09:00:41 -0700
Message-ID: <CAMkAt6pnk8apG4VAdM3NRUokBH32pZx-VOrnhzq+7qJu+ubJ3A@mail.gmail.com>
Subject: Re: [RFC PATCH 6/6] KVM: SVM: Pin SEV pages in MMU during sev_launch_update_data()
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 20, 2022 at 9:08 PM Nikunj A. Dadhania <nikunj@amd.com> wrote:
>
> On 1/20/2022 9:47 PM, Peter Gonda wrote:
> > On Tue, Jan 18, 2022 at 4:07 AM Nikunj A Dadhania <nikunj@amd.com> wrote:
> >>
> >> From: Sean Christopherson <sean.j.christopherson@intel.com>
> >>
> >> Pin the memory for the data being passed to launch_update_data()
> >> because it gets encrypted before the guest is first run and must
> >> not be moved which would corrupt it.
> >>
> >> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >> [ * Changed hva_to_gva() to take an extra argument and return gpa_t.
> >>   * Updated sev_pin_memory_in_mmu() error handling.
> >>   * As pinning/unpining pages is handled within MMU, removed
> >>     {get,put}_user(). ]
> >> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> >> ---
> >>  arch/x86/kvm/svm/sev.c | 122 ++++++++++++++++++++++++++++++++++++++++-
> >>  1 file changed, 119 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> >> index 14aeccfc500b..1ae714e83a3c 100644
> >> --- a/arch/x86/kvm/svm/sev.c
> >> +++ b/arch/x86/kvm/svm/sev.c
> >> @@ -22,6 +22,7 @@
> >>  #include <asm/trapnr.h>
> >>  #include <asm/fpu/xcr.h>
> >>
> >> +#include "mmu.h"
> >>  #include "x86.h"
> >>  #include "svm.h"
> >>  #include "svm_ops.h"
> >> @@ -490,6 +491,110 @@ static unsigned long get_num_contig_pages(unsigned long idx,
> >>         return pages;
> >>  }
> >>
> >> +#define SEV_PFERR_RO (PFERR_USER_MASK)
> >> +#define SEV_PFERR_RW (PFERR_WRITE_MASK | PFERR_USER_MASK)
> >> +
> >> +static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm,
> >> +                                             unsigned long hva)
> >> +{
> >> +       struct kvm_memslots *slots = kvm_memslots(kvm);
> >> +       struct kvm_memory_slot *memslot;
> >> +       int bkt;
> >> +
> >> +       kvm_for_each_memslot(memslot, bkt, slots) {
> >> +               if (hva >= memslot->userspace_addr &&
> >> +                   hva < memslot->userspace_addr +
> >> +                   (memslot->npages << PAGE_SHIFT))
> >> +                       return memslot;
> >> +       }
> >> +
> >> +       return NULL;
> >> +}
> >> +
> >> +static gpa_t hva_to_gpa(struct kvm *kvm, unsigned long hva, bool *ro)
> >> +{
> >> +       struct kvm_memory_slot *memslot;
> >> +       gpa_t gpa_offset;
> >> +
> >> +       memslot = hva_to_memslot(kvm, hva);
> >> +       if (!memslot)
> >> +               return UNMAPPED_GVA;
> >> +
> >> +       *ro = !!(memslot->flags & KVM_MEM_READONLY);
> >> +       gpa_offset = hva - memslot->userspace_addr;
> >> +       return ((memslot->base_gfn << PAGE_SHIFT) + gpa_offset);
> >> +}
> >> +
> >> +static struct page **sev_pin_memory_in_mmu(struct kvm *kvm, unsigned long addr,
> >> +                                          unsigned long size,
> >> +                                          unsigned long *npages)
> >> +{
> >> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >> +       struct kvm_vcpu *vcpu;
> >> +       struct page **pages;
> >> +       unsigned long i;
> >> +       u32 error_code;
> >> +       kvm_pfn_t pfn;
> >> +       int idx, ret = 0;
> >> +       gpa_t gpa;
> >> +       bool ro;
> >> +
> >> +       pages = sev_alloc_pages(sev, addr, size, npages);
> >> +       if (IS_ERR(pages))
> >> +               return pages;
> >> +
> >> +       vcpu = kvm_get_vcpu(kvm, 0);
> >> +       if (mutex_lock_killable(&vcpu->mutex)) {
> >> +               kvfree(pages);
> >> +               return ERR_PTR(-EINTR);
> >> +       }
> >> +
> >> +       vcpu_load(vcpu);
> >> +       idx = srcu_read_lock(&kvm->srcu);
> >> +
> >> +       kvm_mmu_load(vcpu);
> >> +
> >> +       for (i = 0; i < *npages; i++, addr += PAGE_SIZE) {
> >> +               if (signal_pending(current)) {
> >> +                       ret = -ERESTARTSYS;
> >> +                       break;
> >> +               }
> >> +
> >> +               if (need_resched())
> >> +                       cond_resched();
> >> +
> >> +               gpa = hva_to_gpa(kvm, addr, &ro);
> >> +               if (gpa == UNMAPPED_GVA) {
> >> +                       ret = -EFAULT;
> >> +                       break;
> >> +               }
> >> +
> >> +               error_code = ro ? SEV_PFERR_RO : SEV_PFERR_RW;
> >> +
> >> +               /*
> >> +                * Fault in the page and sev_pin_page() will handle the
> >> +                * pinning
> >> +                */
> >> +               pfn = kvm_mmu_map_tdp_page(vcpu, gpa, error_code, PG_LEVEL_4K);
> >> +               if (is_error_noslot_pfn(pfn)) {
> >> +                       ret = -EFAULT;
> >> +                       break;
> >> +               }
> >> +               pages[i] = pfn_to_page(pfn);
> >> +       }
> >> +
> >> +       kvm_mmu_unload(vcpu);
> >> +       srcu_read_unlock(&kvm->srcu, idx);
> >> +       vcpu_put(vcpu);
> >> +       mutex_unlock(&vcpu->mutex);
> >> +
> >> +       if (!ret)
> >> +               return pages;
> >> +
> >> +       kvfree(pages);
> >> +       return ERR_PTR(ret);
> >> +}
> >> +
> >>  static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>  {
> >>         unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
> >> @@ -510,15 +615,21 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>         vaddr_end = vaddr + size;
> >>
> >>         /* Lock the user memory. */
> >> -       inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
> >> +       if (atomic_read(&kvm->online_vcpus))
> >> +               inpages = sev_pin_memory_in_mmu(kvm, vaddr, size, &npages);
> >
> > IIUC we can only use the sev_pin_memory_in_mmu() when there is an
> > online vCPU because that means the MMU has been setup enough to use?
> > Can we add a variable and a comment to help explain that?
> >
> > bool mmu_usable = atomic_read(&kvm->online_vcpus) > 0;
>
> Sure, will add comment and the variable.
>
> >
> >> +       else
> >> +               inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
> >
> > So I am confused about this case. Since svm_register_enc_region() is
> > now a NOOP how can a user ensure that memory remains pinned from
> > sev_launch_update_data() to when the memory would be demand pinned?
> >
> > Before users could svm_register_enc_region() which pins the region,
> > then sev_launch_update_data(), then the VM could run an the data from
> > sev_launch_update_data() would have never moved. I don't think that
> > same guarantee is held here?
>
> Yes, you are right. One way is to error out of this call if MMU is not setup.
> Other one would require us to maintain all list of pinned memory via sev_pin_memory()
> and unpin them in the destroy path.

Got it. So we'll probably still need regions_list to track those
pinned regions and free them on destruction.

Also similar changes are probably needed in sev_receive_update_data()?

>
> >>         if (IS_ERR(inpages))
> >>                 return PTR_ERR(inpages);
> >>
> >>         /*
> >>          * Flush (on non-coherent CPUs) before LAUNCH_UPDATE encrypts pages in
> >>          * place; the cache may contain the data that was written unencrypted.
> >> +        * Flushing is automatically handled if the pages can be pinned in the
> >> +        * MMU.
> >>          */
> >> -       sev_clflush_pages(inpages, npages);
> >> +       if (!atomic_read(&kvm->online_vcpus))
> >> +               sev_clflush_pages(inpages, npages);
> >>
> >>         data.reserved = 0;
> >>         data.handle = sev->handle;
> >> @@ -553,8 +664,13 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>                 set_page_dirty_lock(inpages[i]);
> >>                 mark_page_accessed(inpages[i]);
> >>         }
> >> +
> >>         /* unlock the user pages */
> >> -       sev_unpin_memory(kvm, inpages, npages);
> >> +       if (atomic_read(&kvm->online_vcpus))
> >> +               kvfree(inpages);
>
> >> +       else
> >> +               sev_unpin_memory(kvm, inpages, npages);
>
> And not unpin here in this case.
>
> Regards
> Nikunj

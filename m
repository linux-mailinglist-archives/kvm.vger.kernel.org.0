Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D05E422BB8
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 17:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhJEPD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 11:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhJEPD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 11:03:27 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E9AC061749
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 08:01:36 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id u18so87782093lfd.12
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 08:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=42G3scgpWAbOtgxef+InMFnEa34BVWcCFN53mKIikV0=;
        b=HaQ73Zp2P266ypuNKElq+jGbVlRIzMQ71XS7qQ2exXnMK2YWPRGvke9i4gh75sOsHE
         AaUeLPa93afxOCNwDZ4rZXLseWBCcrIfDV+lcMPL8MqJOAs+FWh2d7is2HYq78mBQQgY
         ZsYMsSpe8OkVrFv2+9XCEJSlWRawQCTaHtx3wCgLF/QdyXZ8UIbGcWs6yj/t+XvrMku9
         N7Q4tFJpL31ePVP6Ed4OYRuJ0y7Yai1ntz96WQrNjMKAqmokUP+uPW//gqWd7n6iNAgs
         srNj0nk5DBhe5iGveSfa7mXy7iSJxoZ7n5flMapZuomGAFyxyG0oTyLq+ZCevbABcV4Y
         K3EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=42G3scgpWAbOtgxef+InMFnEa34BVWcCFN53mKIikV0=;
        b=8Cmjv0wCe5Qp5nGu9evtaRDEBQ+PfxpFEBKNSsF4b9DYrlVxMMrQ0oUWV79GCBK6X1
         VuRUBMWUlW9s2j3+BFA9FwFymXP9/j6z0ks1865cCEGjdkpgLf5a4cOYOB+0BkPN5Yyt
         nVpNfAHLvKuH5LN0HX1GnSeB9Z+Uv1q6vLaDZRb8L31h4zQzugskkpDeXi1htCoNWU6E
         d7XWpJ0LdsuJK9tdWnhfGVmgeiNiOwPUPpUzxiYRPXN0aPuBJ1M8YbnnsBtXWnV2qjhX
         pXCh4viK2AZUDp5enfrwFQ/aDztLhJA8ZhO9d6hzZSLOT0pDeh7JJoMO+56jFj6/7HZF
         mp/A==
X-Gm-Message-State: AOAM533cI3vLVKrIk24Hofq7fqpe8bsBaxUVFfj+eiox1CyL7X6ziY3G
        ERz+GYH7g7UWbzsvj1vTVsfubj5nXR9RbWy1JwBKJw==
X-Google-Smtp-Source: ABdhPJwfIVQtcMQUnNx8RT4h/VH+mgd9JIEGGedHljgEqbQmJLD/tT2gzhFnJVT7XW0mk42MFtXlb2TKsV03h7OLuhU=
X-Received: by 2002:a2e:8787:: with SMTP id n7mr21556614lji.278.1633446087421;
 Tue, 05 Oct 2021 08:01:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-26-brijesh.singh@amd.com>
 <CAMkAt6qsZNJPM97Y6_8b7QmLv=n0MaDs7hThi3thFEee4P10pA@mail.gmail.com> <e5a47417-2f2e-7055-71ad-850b509f3876@amd.com>
In-Reply-To: <e5a47417-2f2e-7055-71ad-850b509f3876@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 5 Oct 2021 09:01:15 -0600
Message-ID: <CAMkAt6pJQmgzbpfxbXF_aJobszG8OU=rfVw8Xk9SMqC6050G6g@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 25/45] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE command
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        Marc Orr <marcorr@google.com>,
        sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 1:33 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
>
>
> On 9/27/21 11:43 AM, Peter Gonda wrote:
> ...
> >>
> >> +static bool is_hva_registered(struct kvm *kvm, hva_t hva, size_t len)
> >> +{
> >> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >> +       struct list_head *head = &sev->regions_list;
> >> +       struct enc_region *i;
> >> +
> >> +       lockdep_assert_held(&kvm->lock);
> >> +
> >> +       list_for_each_entry(i, head, list) {
> >> +               u64 start = i->uaddr;
> >> +               u64 end = start + i->size;
> >> +
> >> +               if (start <= hva && end >= (hva + len))
> >> +                       return true;
> >> +       }
> >> +
> >> +       return false;
> >> +}
> >
> > Internally we actually register the guest memory in chunks for various
> > reasons. So for our largest SEV VM we have 768 1 GB entries in
> > |sev->regions_list|. This was OK before because no look ups were done.
> > Now that we are performing a look ups a linked list with linear time
> > lookups seems not ideal, could we switch the back data structure here
> > to something more conducive too fast lookups?
> >> +
>
> Interesting, for qemu we had very few number of regions so there was no
> strong reason for me to think something otherwise. Do you have any
> preference on what data structure you will use ?

Chatted offline. I think this is fine for now, we won't want to use
our userspace demand pinning with SNP yet.

>
> >> +static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >> +{
> >> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >> +       struct sev_data_snp_launch_update data = {0};
> >> +       struct kvm_sev_snp_launch_update params;
> >> +       unsigned long npages, pfn, n = 0;
> >
> > Could we have a slightly more descriptive name for |n|? nprivate
> > maybe? Also why not zero in the loop below?
> >
>
> Sure, I will pick a better name and no need to zero above. I will fix it.
>
> > for (i = 0, n = 0; i < npages; ++i)
> >
> >> +       int *error = &argp->error;
> >> +       struct page **inpages;
> >> +       int ret, i, level;
> >
> > Should |i| be an unsigned long since it can is tracked in a for loop
> > with "i < npages" npages being an unsigned long? (|n| too)
> >
>
> Noted.
>
> >> +       u64 gfn;
> >> +
> >> +       if (!sev_snp_guest(kvm))
> >> +               return -ENOTTY;
> >> +
> >> +       if (!sev->snp_context)
> >> +               return -EINVAL;
> >> +
> >> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> >> +               return -EFAULT;
> >> +
> >> +       /* Verify that the specified address range is registered. */
> >> +       if (!is_hva_registered(kvm, params.uaddr, params.len))
> >> +               return -EINVAL;
> >> +
> >> +       /*
> >> +        * The userspace memory is already locked so technically we don't
> >> +        * need to lock it again. Later part of the function needs to know
> >> +        * pfn so call the sev_pin_memory() so that we can get the list of
> >> +        * pages to iterate through.
> >> +        */
> >> +       inpages = sev_pin_memory(kvm, params.uaddr, params.len, &npages, 1);
> >> +       if (!inpages)
> >> +               return -ENOMEM;
> >> +
> >> +       /*
> >> +        * Verify that all the pages are marked shared in the RMP table before
> >> +        * going further. This is avoid the cases where the userspace may try
> >
> > This is *too* avoid cases...
> >
> Noted
>
> >> +        * updating the same page twice.
> >> +        */
> >> +       for (i = 0; i < npages; i++) {
> >> +               if (snp_lookup_rmpentry(page_to_pfn(inpages[i]), &level) != 0) {
> >> +                       sev_unpin_memory(kvm, inpages, npages);
> >> +                       return -EFAULT;
> >> +               }
> >> +       }
> >> +
> >> +       gfn = params.start_gfn;
> >> +       level = PG_LEVEL_4K;
> >> +       data.gctx_paddr = __psp_pa(sev->snp_context);
> >> +
> >> +       for (i = 0; i < npages; i++) {
> >> +               pfn = page_to_pfn(inpages[i]);
> >> +
> >> +               ret = rmp_make_private(pfn, gfn << PAGE_SHIFT, level, sev_get_asid(kvm), true);
> >> +               if (ret) {
> >> +                       ret = -EFAULT;
> >> +                       goto e_unpin;
> >> +               }
> >> +
> >> +               n++;
> >> +               data.address = __sme_page_pa(inpages[i]);
> >> +               data.page_size = X86_TO_RMP_PG_LEVEL(level);
> >> +               data.page_type = params.page_type;
> >> +               data.vmpl3_perms = params.vmpl3_perms;
> >> +               data.vmpl2_perms = params.vmpl2_perms;
> >> +               data.vmpl1_perms = params.vmpl1_perms;
> >> +               ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE, &data, error);
> >> +               if (ret) {
> >> +                       /*
> >> +                        * If the command failed then need to reclaim the page.
> >> +                        */
> >> +                       snp_page_reclaim(pfn);
> >> +                       goto e_unpin;
> >> +               }
> >
> > Hmm if this call fails after the first iteration of this loop it will
> > lead to a hard to reproduce LaunchDigest right? Say if we are
> > SnpLaunchUpdating just 2 pages A and B. If we first call this ioctl
> > and A is SNP_LAUNCH_UPDATED'd but B fails, we then make A shared again
> > in the RMP. So we must call the ioctl with 2 pages again, after fixing
> > the issue with page B. Now the Launch digest has something like
> > Hash(A) then HASH(A & B) right (overly simplified) so A will be
> > included twice right? I am not sure if anything better can be done
> > here but might be worth documenting IIUC.
> >
>
> I can add a comment in documentation that if a LAUNCH_UPDATE fails then
> user need to destroy the existing context and start from the beginning.
> I am not sure if we want to support the partial update cases. But in
> case we have two choices a) decommission the context on failure or b)
> add a new command to destroy the existing context.
>

Agreed supporting the partial update case seems very tricky.

>
> >> +
> >> +               gfn++;
> >> +       }
> >> +
> >> +e_unpin:
> >> +       /* Content of memory is updated, mark pages dirty */
> >> +       for (i = 0; i < n; i++) {
> >> +               set_page_dirty_lock(inpages[i]);
> >> +               mark_page_accessed(inpages[i]);
> >> +
> >> +               /*
> >> +                * If its an error, then update RMP entry to change page ownership
> >> +                * to the hypervisor.
> >> +                */
> >> +               if (ret)
> >> +                       host_rmp_make_shared(pfn, level, true);
> >> +       }
> >> +
> >> +       /* Unlock the user pages */
> >> +       sev_unpin_memory(kvm, inpages, npages);
> >> +
> >> +       return ret;
> >> +}
> >> +
> >>   int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >>   {
> >>          struct kvm_sev_cmd sev_cmd;
> >> @@ -1712,6 +1873,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >>          case KVM_SEV_SNP_LAUNCH_START:
> >>                  r = snp_launch_start(kvm, &sev_cmd);
> >>                  break;
> >> +       case KVM_SEV_SNP_LAUNCH_UPDATE:
> >> +               r = snp_launch_update(kvm, &sev_cmd);
> >> +               break;
> >>          default:
> >>                  r = -EINVAL;
> >>                  goto out;
> >> @@ -1794,6 +1958,29 @@ find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
> >>   static void __unregister_enc_region_locked(struct kvm *kvm,
> >>                                             struct enc_region *region)
> >>   {
> >> +       unsigned long i, pfn;
> >> +       int level;
> >> +
> >> +       /*
> >> +        * The guest memory pages are assigned in the RMP table. Unassign it
> >> +        * before releasing the memory.
> >> +        */
> >> +       if (sev_snp_guest(kvm)) {
> >> +               for (i = 0; i < region->npages; i++) {
> >> +                       pfn = page_to_pfn(region->pages[i]);
> >> +
> >> +                       if (!snp_lookup_rmpentry(pfn, &level))
> >> +                               continue;
> >> +
> >> +                       cond_resched();
> >> +
> >> +                       if (level > PG_LEVEL_4K)
> >> +                               pfn &= ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
> >> +
> >> +                       host_rmp_make_shared(pfn, level, true);
> >> +               }
> >> +       }
> >> +
> >>          sev_unpin_memory(kvm, region->pages, region->npages);
> >>          list_del(&region->list);
> >>          kfree(region);
> >> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> >> index e6416e58cd9a..0681be4bdfdf 100644
> >> --- a/include/uapi/linux/kvm.h
> >> +++ b/include/uapi/linux/kvm.h
> >> @@ -1715,6 +1715,7 @@ enum sev_cmd_id {
> >>          /* SNP specific commands */
> >>          KVM_SEV_SNP_INIT,
> >>          KVM_SEV_SNP_LAUNCH_START,
> >> +       KVM_SEV_SNP_LAUNCH_UPDATE,
> >>
> >>          KVM_SEV_NR_MAX,
> >>   };
> >> @@ -1831,6 +1832,24 @@ struct kvm_sev_snp_launch_start {
> >>          __u8 pad[6];
> >>   };
> >>
> >> +#define KVM_SEV_SNP_PAGE_TYPE_NORMAL           0x1
> >> +#define KVM_SEV_SNP_PAGE_TYPE_VMSA             0x2
> >> +#define KVM_SEV_SNP_PAGE_TYPE_ZERO             0x3
> >> +#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED       0x4
> >> +#define KVM_SEV_SNP_PAGE_TYPE_SECRETS          0x5
> >> +#define KVM_SEV_SNP_PAGE_TYPE_CPUID            0x6
> >> +
> >> +struct kvm_sev_snp_launch_update {
> >> +       __u64 start_gfn;
> >> +       __u64 uaddr;
> >> +       __u32 len;
> >> +       __u8 imi_page;
> >> +       __u8 page_type;
> >> +       __u8 vmpl3_perms;
> >> +       __u8 vmpl2_perms;
> >> +       __u8 vmpl1_perms;
> >> +};
> >> +
> >>   #define KVM_DEV_ASSIGN_ENABLE_IOMMU    (1 << 0)
> >>   #define KVM_DEV_ASSIGN_PCI_2_3         (1 << 1)
> >>   #define KVM_DEV_ASSIGN_MASK_INTX       (1 << 2)
> >> --
> >> 2.17.1
> >>
> >>

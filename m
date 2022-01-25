Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC5949B944
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 17:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586022AbiAYQvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 11:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586495AbiAYQtm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 11:49:42 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3E2C0617A3
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 08:47:46 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id e9so5485501ljq.1
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 08:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZxKHsTlFPD/WqwTFCjR7TPuaLt90R4mNRogm3Hute3M=;
        b=S6WTHqWgA4KZAfJnWX7ED9KyhLUHjqy9o3jta+6fKhjpJGLUNyLpVNy0Y6dNu6NBtt
         Dif9jvPwXGLoAx8u9emNC1UdxK4/UL57mzQs4JfrU+rT1G9aAZzYmkLCHy9Nbw7i0pVB
         XObdbOFr1tvU5Ok/GVDS8jriv9fwETEpQqNTGD8dt0LDODOO0MuhjT3F9wjioSyaOrit
         px06CHsk7ucc0z6gJoedXSRpeCpJWZZ3K7tn9NfWnoWscEWNUQcyzoazXR3kDM6y6zGo
         +aDD/gCUmoYvn+27DiBliPWCpfT6SfD8gAMKO0oXGplCD+ITt8Mutot89QcmkP+koLTS
         1jbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZxKHsTlFPD/WqwTFCjR7TPuaLt90R4mNRogm3Hute3M=;
        b=nXOq2bU+E6NKexVnKz9V0ifMuKz5c14lPt+3Kej6GfXrKzC2Vk2TSItmCzkrcZKmHv
         SH/w9vHH47avT6fRP8ekeSWDEZAljnfcmU9sF+R6RvgLH4SNVWfVIr4Ru4/qLFS6QDiF
         43WVbw4yhEnQRStyYCTkxH0aMeKg7WQix+FtYOAY22yD145CNqMYVNll1aQ1vtHPTMos
         KU7npt1rlb1oPVVgezZ3xYdThTHuH0V4ktCRllg4pidhVITACm/8nuez37m27muEXU/5
         B+8sHHnhwE8PdBBSmICjN+/zpdWirPgHsE1ba0a0kv7k9EzsFVsngh3KcLnTZeyJZgwt
         H13w==
X-Gm-Message-State: AOAM5332QjOg+2wgk7AnA6QpKqvUjzc5J0Si/4lJ497VOPWk6FfETMFL
        wsiIXngRZhjDBZ7Txy8OuA5ahysJpsY06GTK+0MipA==
X-Google-Smtp-Source: ABdhPJwL3cj7hQT4SmKfZmXQLdgggc6MixizD5vULDnBU3FU20x8IpccQmyKjholb5Fn4/1OE1Y9DRv/Tgk3kEad/Is=
X-Received: by 2002:a2e:7a10:: with SMTP id v16mr9329790ljc.426.1643129264138;
 Tue, 25 Jan 2022 08:47:44 -0800 (PST)
MIME-Version: 1.0
References: <20220118110621.62462-1-nikunj@amd.com> <20220118110621.62462-4-nikunj@amd.com>
In-Reply-To: <20220118110621.62462-4-nikunj@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 25 Jan 2022 09:47:32 -0700
Message-ID: <CAMkAt6rxeGZ3SpF9UoSW0U5XWmTNe-iSMc5jgCmOLP587J03Aw@mail.gmail.com>
Subject: Re: [RFC PATCH 3/6] KVM: SVM: Implement demand page pinning
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
> Use the memslot metadata to store the pinned data along with the pfns.
> This improves the SEV guest startup time from O(n) to a constant by
> deferring guest page pinning until the pages are used to satisfy nested
> page faults. The page reference will be dropped in the memslot free
> path.
>
> Remove the enc_region structure definition and the code which did
> upfront pinning, as they are no longer needed in view of the demand
> pinning support.
>
> Leave svm_register_enc_region() and svm_unregister_enc_region() as stubs
> since qemu is dependent on this API.
>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 208 ++++++++++++++++-------------------------
>  arch/x86/kvm/svm/svm.c |   1 +
>  arch/x86/kvm/svm/svm.h |   3 +-
>  3 files changed, 81 insertions(+), 131 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index d972ab4956d4..a962bed97a0b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -66,14 +66,6 @@ static unsigned int nr_asids;
>  static unsigned long *sev_asid_bitmap;
>  static unsigned long *sev_reclaim_asid_bitmap;
>
> -struct enc_region {
> -       struct list_head list;
> -       unsigned long npages;
> -       struct page **pages;
> -       unsigned long uaddr;
> -       unsigned long size;
> -};
> -
>  /* Called with the sev_bitmap_lock held, or on shutdown  */
>  static int sev_flush_asids(int min_asid, int max_asid)
>  {
> @@ -257,8 +249,6 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>         if (ret)
>                 goto e_free;
>
> -       INIT_LIST_HEAD(&sev->regions_list);
> -
>         return 0;
>
>  e_free:
> @@ -1637,8 +1627,6 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
>         src->handle = 0;
>         src->pages_locked = 0;
>         src->enc_context_owner = NULL;
> -
> -       list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);

I think we need to move the pinned SPTE entries into the target, and
repin the pages in the target here. Otherwise the pages will be
unpinned when the source is cleaned up. Have you thought about how
this could be done?

>  }
>
>  static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
> @@ -1861,115 +1849,13 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  int svm_register_enc_region(struct kvm *kvm,
>                             struct kvm_enc_region *range)
>  {
> -       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -       struct enc_region *region;
> -       int ret = 0;
> -
> -       if (!sev_guest(kvm))
> -               return -ENOTTY;
> -
> -       /* If kvm is mirroring encryption context it isn't responsible for it */
> -       if (is_mirroring_enc_context(kvm))
> -               return -EINVAL;
> -
> -       if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
> -               return -EINVAL;
> -
> -       region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
> -       if (!region)
> -               return -ENOMEM;
> -
> -       mutex_lock(&kvm->lock);
> -       region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
> -       if (IS_ERR(region->pages)) {
> -               ret = PTR_ERR(region->pages);
> -               mutex_unlock(&kvm->lock);
> -               goto e_free;
> -       }
> -
> -       region->uaddr = range->addr;
> -       region->size = range->size;
> -
> -       list_add_tail(&region->list, &sev->regions_list);
> -       mutex_unlock(&kvm->lock);
> -
> -       /*
> -        * The guest may change the memory encryption attribute from C=0 -> C=1
> -        * or vice versa for this memory range. Lets make sure caches are
> -        * flushed to ensure that guest data gets written into memory with
> -        * correct C-bit.
> -        */
> -       sev_clflush_pages(region->pages, region->npages);
> -
> -       return ret;
> -
> -e_free:
> -       kfree(region);
> -       return ret;
> -}
> -
> -static struct enc_region *
> -find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
> -{
> -       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -       struct list_head *head = &sev->regions_list;
> -       struct enc_region *i;
> -
> -       list_for_each_entry(i, head, list) {
> -               if (i->uaddr == range->addr &&
> -                   i->size == range->size)
> -                       return i;
> -       }
> -
> -       return NULL;
> -}
> -
> -static void __unregister_enc_region_locked(struct kvm *kvm,
> -                                          struct enc_region *region)
> -{
> -       sev_unpin_memory(kvm, region->pages, region->npages);
> -       list_del(&region->list);
> -       kfree(region);
> +       return 0;
>  }
>
>  int svm_unregister_enc_region(struct kvm *kvm,
>                               struct kvm_enc_region *range)
>  {
> -       struct enc_region *region;
> -       int ret;
> -
> -       /* If kvm is mirroring encryption context it isn't responsible for it */
> -       if (is_mirroring_enc_context(kvm))
> -               return -EINVAL;
> -
> -       mutex_lock(&kvm->lock);
> -
> -       if (!sev_guest(kvm)) {
> -               ret = -ENOTTY;
> -               goto failed;
> -       }
> -
> -       region = find_enc_region(kvm, range);
> -       if (!region) {
> -               ret = -EINVAL;
> -               goto failed;
> -       }
> -
> -       /*
> -        * Ensure that all guest tagged cache entries are flushed before
> -        * releasing the pages back to the system for use. CLFLUSH will
> -        * not do this, so issue a WBINVD.
> -        */
> -       wbinvd_on_all_cpus();
> -
> -       __unregister_enc_region_locked(kvm, region);
> -
> -       mutex_unlock(&kvm->lock);
>         return 0;
> -
> -failed:
> -       mutex_unlock(&kvm->lock);
> -       return ret;
>  }
>
>  int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
> @@ -2018,7 +1904,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>         mirror_sev->fd = source_sev->fd;
>         mirror_sev->es_active = source_sev->es_active;
>         mirror_sev->handle = source_sev->handle;
> -       INIT_LIST_HEAD(&mirror_sev->regions_list);
>         ret = 0;
>
>         /*
> @@ -2038,8 +1923,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>  void sev_vm_destroy(struct kvm *kvm)
>  {
>         struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -       struct list_head *head = &sev->regions_list;
> -       struct list_head *pos, *q;
>
>         WARN_ON(sev->num_mirrored_vms);
>
> @@ -2066,18 +1949,6 @@ void sev_vm_destroy(struct kvm *kvm)
>          */
>         wbinvd_on_all_cpus();
>
> -       /*
> -        * if userspace was terminated before unregistering the memory regions
> -        * then lets unpin all the registered memory.
> -        */
> -       if (!list_empty(head)) {
> -               list_for_each_safe(pos, q, head) {
> -                       __unregister_enc_region_locked(kvm,
> -                               list_entry(pos, struct enc_region, list));
> -                       cond_resched();
> -               }
> -       }
> -
>         sev_unbind_asid(kvm, sev->handle);
>         sev_asid_free(sev);
>  }
> @@ -2946,13 +2817,90 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>         ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
>  }
>
> +void sev_pin_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +                 kvm_pfn_t pfn)
> +{
> +       struct kvm_arch_memory_slot *aslot;
> +       struct kvm_memory_slot *slot;
> +       gfn_t rel_gfn, pin_pfn;
> +       unsigned long npages;
> +       kvm_pfn_t old_pfn;
> +       int i;
> +
> +       if (!sev_guest(kvm))
> +               return;
> +
> +       if (WARN_ON_ONCE(is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn)))
> +               return;
> +
> +       /* Tested till 1GB pages */
> +       if (KVM_BUG_ON(level > PG_LEVEL_1G, kvm))
> +               return;
> +
> +       slot = gfn_to_memslot(kvm, gfn);
> +       if (!slot || !slot->arch.pfns)
> +               return;
> +
> +       /*
> +        * Use relative gfn index within the memslot for the bitmap as well as
> +        * the pfns array
> +        */
> +       rel_gfn = gfn - slot->base_gfn;
> +       aslot = &slot->arch;
> +       pin_pfn = pfn;
> +       npages = KVM_PAGES_PER_HPAGE(level);
> +
> +       /* Pin the page, KVM doesn't yet support page migration. */
> +       for (i = 0; i < npages; i++, rel_gfn++, pin_pfn++) {
> +               if (test_bit(rel_gfn, aslot->pinned_bitmap)) {
> +                       old_pfn = aslot->pfns[rel_gfn];
> +                       if (old_pfn == pin_pfn)
> +                               continue;
> +
> +                       put_page(pfn_to_page(old_pfn));
> +               }
> +
> +               set_bit(rel_gfn, aslot->pinned_bitmap);
> +               aslot->pfns[rel_gfn] = pin_pfn;
> +               get_page(pfn_to_page(pin_pfn));
> +       }
> +
> +       /*
> +        * Flush any cached lines of the page being added since "ownership" of
> +        * it will be transferred from the host to an encrypted guest.
> +        */
> +       clflush_cache_range(__va(pfn << PAGE_SHIFT), page_level_size(level));
> +}
> +
>  void sev_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
>  {
>         struct kvm_arch_memory_slot *aslot = &slot->arch;
> +       kvm_pfn_t *pfns;
> +       gfn_t gfn;
> +       int i;
>
>         if (!sev_guest(kvm))
>                 return;
>
> +       if (!aslot->pinned_bitmap || !slot->arch.pfns)
> +               goto out;
> +
> +       pfns = aslot->pfns;
> +
> +       /*
> +        * Iterate the memslot to find the pinned pfn using the bitmap and drop
> +        * the pfn stored.
> +        */
> +       for (i = 0, gfn = slot->base_gfn; i < slot->npages; i++, gfn++) {
> +               if (test_and_clear_bit(i, aslot->pinned_bitmap)) {
> +                       if (WARN_ON(!pfns[i]))
> +                               continue;
> +
> +                       put_page(pfn_to_page(pfns[i]));
> +               }
> +       }
> +
> +out:
>         if (aslot->pinned_bitmap) {
>                 kvfree(aslot->pinned_bitmap);
>                 aslot->pinned_bitmap = NULL;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3fb19974f719..22535c680b3f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4743,6 +4743,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>
>         .alloc_memslot_metadata = sev_alloc_memslot_metadata,
>         .free_memslot = sev_free_memslot,
> +       .pin_spte = sev_pin_spte,
>  };
>
>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index b2f8b3b52680..c731bc91ea8f 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -77,7 +77,6 @@ struct kvm_sev_info {
>         unsigned int handle;    /* SEV firmware handle */
>         int fd;                 /* SEV device fd */
>         unsigned long pages_locked; /* Number of pages locked */
> -       struct list_head regions_list;  /* List of registered regions */
>         u64 ap_jump_table;      /* SEV-ES AP Jump Table address */
>         struct kvm *enc_context_owner; /* Owner of copied encryption context */
>         unsigned long num_mirrored_vms; /* Number of VMs sharing this ASID */
> @@ -648,5 +647,7 @@ int sev_alloc_memslot_metadata(struct kvm *kvm,
>                                struct kvm_memory_slot *new);
>  void sev_free_memslot(struct kvm *kvm,
>                       struct kvm_memory_slot *slot);
> +void sev_pin_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +                 kvm_pfn_t pfn);
>
>  #endif
> --
> 2.32.0
>

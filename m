Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFCC375DA9
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 01:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbhEFXpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 19:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbhEFXpc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 19:45:32 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14913C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 16:44:32 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gx5so10784338ejb.11
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 16:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qhv1j7pNpSIh0kRrRi4C7ulLHu/0y1uR6QrzcVzsKFs=;
        b=JjBSKDp8wLUhN5/jyijaGmw6s+ZvIJR1IOGhJcNYnkQnHiNOdJCUz6Yn4whomeuDUl
         72RRj+Oy56L3vWffDkPVTZsZL4qnp5Cw5cHMJW14TNal8Lqkbg6PIy6ajog60qKlQOqs
         RQtFC6gzi23b1waKUPUwxHkbs5AhOw5ohyy1R0ug+yrNIT9g123QRZX+OmoG2YVDfq67
         5E9b9lM9JbxjMwEH0meYmCS3GzSaQbbwqP60Uycnd2kx8EvvEc5Wb7oqjNmrBTqfNb6g
         LsqwhoDsgsvzApO/j937gaFvvWNuG1HLffmusgncLejYejG9NET1U2AsOvM59othgtgz
         n70Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qhv1j7pNpSIh0kRrRi4C7ulLHu/0y1uR6QrzcVzsKFs=;
        b=qi6Y0qddDOYI30imhlyqjAyl64f2HZ+OmknRle1AmSkxTLEELCiFaiwMolv5A1Cpj1
         OlTo1rKp/Ou7PfQgnsvTKeofdLdJwR5Gq2dHtWpDfomnW5PsqbRkfOyOL8c6BO3rQLck
         olyscZbjg4Ys8Zqt4Xb1TrsNBqB4R0wkEud2zeWfW5BYnoeCGGfZ+T56T6vheONPmO+/
         Y4UaGGJz11EEm6pCY1PjVtT/3SiB80CiyCooRjb7bwZtrGSQp/gEJRXBfS4B1R32Oroc
         KuKHLKoD5NE9RRsH/pjrHEweQ528nseZJ+IaV5sYCxecLjvMZQpyuF1kOThjGwOTqqtv
         uojw==
X-Gm-Message-State: AOAM530B+Zbqox314CVge0g4TKYbWNURTtDkYTpBecPm3C8ad+ZouRxK
        Fck7qNRGH4u26IiV5wickphJHN7G9za6PbYeiwTPjA==
X-Google-Smtp-Source: ABdhPJwyqAnim/mOs8BRMBMgREtD47ZlL0QgWrPMb8ZNsO6Z5Kh0yGd6zaynzhj+HKKecp7MdpBAQFkrjaecabslY6w=
X-Received: by 2002:a17:907:3e0b:: with SMTP id hp11mr6746294ejc.171.1620344670313;
 Thu, 06 May 2021 16:44:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210506184241.618958-1-bgardon@google.com> <20210506184241.618958-6-bgardon@google.com>
In-Reply-To: <20210506184241.618958-6-bgardon@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 6 May 2021 16:44:19 -0700
Message-ID: <CANgfPd-eJsHRYARTa0tm4EUVQyXvdQxGQfGfj=qLi5vkLTG6pw@mail.gmail.com>
Subject: Re: [PATCH v3 5/8] KVM: x86/mmu: Add a field to control memslot rmap allocation
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 6, 2021 at 11:43 AM Ben Gardon <bgardon@google.com> wrote:
>
> Add a field to control whether new memslots should have rmaps allocated
> for them. As of this change, it's not safe to skip allocating rmaps, so
> the field is always set to allocate rmaps. Future changes will make it
> safe to operate without rmaps, using the TDP MMU. Then further changes
> will allow the rmaps to be allocated lazily when needed for nested
> oprtation.
>
> No functional change expected.
>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  8 ++++++++
>  arch/x86/kvm/mmu/mmu.c          |  2 ++
>  arch/x86/kvm/x86.c              | 18 +++++++++++++-----
>  3 files changed, 23 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ad22d4839bcc..00065f9bbc5e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1122,6 +1122,12 @@ struct kvm_arch {
>          */
>         spinlock_t tdp_mmu_pages_lock;
>  #endif /* CONFIG_X86_64 */
> +
> +       /*
> +        * If set, rmaps have been allocated for all memslots and should be
> +        * allocated for any newly created or modified memslots.
> +        */
> +       bool memslots_have_rmaps;
>  };
>
>  struct kvm_vm_stat {
> @@ -1853,4 +1859,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
>
>  int kvm_cpu_dirty_log_size(void);
>
> +inline bool kvm_memslots_have_rmaps(struct kvm *kvm);

Woops, this shouldn't be marked inline as it creates build problems
for the next patch with some configs.

> +
>  #endif /* _ASM_X86_KVM_HOST_H */
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 930ac8a7e7c9..8761b4925755 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5469,6 +5469,8 @@ void kvm_mmu_init_vm(struct kvm *kvm)
>
>         kvm_mmu_init_tdp_mmu(kvm);
>
> +       kvm->arch.memslots_have_rmaps = true;
> +
>         node->track_write = kvm_mmu_pte_write;
>         node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
>         kvm_page_track_register_notifier(kvm, node);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fc32a7dbe4c4..d7a40ce342cc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10868,7 +10868,13 @@ static int alloc_memslot_rmap(struct kvm_memory_slot *slot,
>         return -ENOMEM;
>  }
>
> -static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
> +bool kvm_memslots_have_rmaps(struct kvm *kvm)
> +{
> +       return kvm->arch.memslots_have_rmaps;
> +}
> +
> +static int kvm_alloc_memslot_metadata(struct kvm *kvm,
> +                                     struct kvm_memory_slot *slot,
>                                       unsigned long npages)
>  {
>         int i;
> @@ -10881,9 +10887,11 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
>          */
>         memset(&slot->arch, 0, sizeof(slot->arch));
>
> -       r = alloc_memslot_rmap(slot, npages);
> -       if (r)
> -               return r;
> +       if (kvm_memslots_have_rmaps(kvm)) {
> +               r = alloc_memslot_rmap(slot, npages);
> +               if (r)
> +                       return r;
> +       }
>
>         for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
>                 struct kvm_lpage_info *linfo;
> @@ -10954,7 +10962,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>                                 enum kvm_mr_change change)
>  {
>         if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
> -               return kvm_alloc_memslot_metadata(memslot,
> +               return kvm_alloc_memslot_metadata(kvm, memslot,
>                                                   mem->memory_size >> PAGE_SHIFT);
>         return 0;
>  }
> --
> 2.31.1.607.g51e8a6a459-goog
>

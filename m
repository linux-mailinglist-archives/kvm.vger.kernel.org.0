Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47767459528
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhKVS6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbhKVS6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 13:58:36 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D58CC061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:55:30 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id l19so19236112ilk.0
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+zTIitvg06tihvKYPYmcW1QukGk8peY0J0rY/G9i+i4=;
        b=TDwL5crSHCgmvdYPS+7vyXLvJkhBToGE8/slaGIU7klfHkgk7JitspVB1RzYU2CG0G
         sjARq7GQW2iOvzWC+vQpdUBtD/T18wVKX0lMCW0Ln5ZXLt2iFabLCoPRqWMoohPDgfGU
         ejW3QZ0wU2VvWxKcxh4tNlPIOxctEoyvuUrOxCZJGivnKJaRrWWU3rWaL+ApsS25KoPR
         A+IcfzAlqLc9yzzcUax2/yoLP1rC0h8+VQKd9gsppnE5048Qf2dMqOqWYxSqZ3o6x8TH
         JhkQITMOa2VxAUt+kKpss9Rop90U+cINuZAuyjR4mpIq+Zu363x0kQjBmYOb0Vn8nfZJ
         A3xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+zTIitvg06tihvKYPYmcW1QukGk8peY0J0rY/G9i+i4=;
        b=qwgjV+iRIz+xwAoA1t8lRMAOFf1mQo51wOjNRCzJLJdMEx4ts6yhGrLLpuRLELyh5l
         XeNMKOeY77mit08tjbcQ3WXrFJ2qQASS3qUyHlBRAXYeRHIez2JtRUI9Qb6w4/XWgREI
         9fUZzk5+vYH9oJIm2BT+dgh2RWiwOZAPoEYyjJLEtvB4nLSyWyoLjKjrJXcCHKFDKAwN
         x5j9YNfS4nFrDg4SzkCAl54hnfi9vM8ZOv07bdwVP3viAc+Cj1AfuMECaLVTHngoJLvn
         KoB9KVHMsb1Dy8GWG8j46tGxfXxtl3zzNcaUR3UOVXsuP2lXiewE4ZeLlFuQMacMbvYv
         HZHg==
X-Gm-Message-State: AOAM530Ovswl8IRx1/Oh1Rm1Gya1TQYvy0tQ5vMCfeMT0DflXMOPO1OX
        HZ2XXirYjxudqYlYZ9yN3YzxWZ1jJi3nwetSC1IvJg==
X-Google-Smtp-Source: ABdhPJzrmNWldoH0RqRqUSfZJcYbNPTZ9bI2lR2iNAeIV4i7BoYFFQiriaZr0faqu0J9b2puVQPcod8dtHSNWsNHRxk=
X-Received: by 2002:a05:6e02:1809:: with SMTP id a9mr21289599ilv.203.1637607328972;
 Mon, 22 Nov 2021 10:55:28 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-6-dmatlack@google.com>
In-Reply-To: <20211119235759.1304274-6-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 10:55:18 -0800
Message-ID: <CANgfPd-L0iA9Yxf4PtSY4q2c0QZ168s5X3DjLhzTBGjw3YGVHA@mail.gmail.com>
Subject: Re: [RFC PATCH 05/15] KVM: x86/mmu: Abstract mmu caches out to a
 separate struct
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 3:58 PM David Matlack <dmatlack@google.com> wrote:
>
> Move the kvm_mmu_memory_cache structs into a separate wrapper struct.
> This is in preparation for eagerly splitting all large pages during
> VM-ioctls (i.e. not in the vCPU fault path) which will require adding
> kvm_mmu_memory_cache structs to struct kvm_arch.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon

I don't think this patch creates any functional change. If that's the
intent, it'd be worth noting.


> ---
>  arch/x86/include/asm/kvm_host.h | 12 ++++---
>  arch/x86/kvm/mmu/mmu.c          | 59 ++++++++++++++++++++++-----------
>  arch/x86/kvm/mmu/tdp_mmu.c      |  7 ++--
>  3 files changed, 52 insertions(+), 26 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1fcb345bc107..2a7564703ea6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -612,6 +612,13 @@ struct kvm_vcpu_xen {
>         u64 runstate_times[4];
>  };
>
> +struct kvm_mmu_memory_caches {
> +       struct kvm_mmu_memory_cache pte_list_desc_cache;
> +       struct kvm_mmu_memory_cache shadow_page_cache;
> +       struct kvm_mmu_memory_cache gfn_array_cache;
> +       struct kvm_mmu_memory_cache page_header_cache;
> +};
> +
>  struct kvm_vcpu_arch {
>         /*
>          * rip and regs accesses must go through
> @@ -681,10 +688,7 @@ struct kvm_vcpu_arch {
>          */
>         struct kvm_mmu *walk_mmu;
>
> -       struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
> -       struct kvm_mmu_memory_cache mmu_shadow_page_cache;
> -       struct kvm_mmu_memory_cache mmu_gfn_array_cache;
> -       struct kvm_mmu_memory_cache mmu_page_header_cache;
> +       struct kvm_mmu_memory_caches mmu_caches;
>
>         /*
>          * QEMU userspace and the guest each have their own FPU state.
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1146f87044a6..537952574211 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -732,38 +732,60 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>
>  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  {
> +       struct kvm_mmu_memory_caches *mmu_caches;
>         int r;
>
> +       mmu_caches = &vcpu->arch.mmu_caches;
> +
>         /* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
> -       r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
> +       r = kvm_mmu_topup_memory_cache(&mmu_caches->pte_list_desc_cache,
>                                        1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>         if (r)
>                 return r;
> -       r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> +       r = kvm_mmu_topup_memory_cache(&mmu_caches->shadow_page_cache,
>                                        PT64_ROOT_MAX_LEVEL);
>         if (r)
>                 return r;
>         if (maybe_indirect) {
> -               r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
> +               r = kvm_mmu_topup_memory_cache(&mmu_caches->gfn_array_cache,
>                                                PT64_ROOT_MAX_LEVEL);
>                 if (r)
>                         return r;
>         }
> -       return kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
> +       return kvm_mmu_topup_memory_cache(&mmu_caches->page_header_cache,
>                                           PT64_ROOT_MAX_LEVEL);
>  }
>
>  static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  {
> -       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
> -       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> -       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
> -       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
> +       struct kvm_mmu_memory_caches *mmu_caches;
> +
> +       mmu_caches = &vcpu->arch.mmu_caches;
> +
> +       kvm_mmu_free_memory_cache(&mmu_caches->pte_list_desc_cache);
> +       kvm_mmu_free_memory_cache(&mmu_caches->shadow_page_cache);
> +       kvm_mmu_free_memory_cache(&mmu_caches->gfn_array_cache);
> +       kvm_mmu_free_memory_cache(&mmu_caches->page_header_cache);
> +}
> +
> +static void mmu_init_memory_caches(struct kvm_mmu_memory_caches *caches)
> +{
> +       caches->pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
> +       caches->pte_list_desc_cache.gfp_zero = __GFP_ZERO;
> +
> +       caches->page_header_cache.kmem_cache = mmu_page_header_cache;
> +       caches->page_header_cache.gfp_zero = __GFP_ZERO;
> +
> +       caches->shadow_page_cache.gfp_zero = __GFP_ZERO;
>  }
>
>  static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
>  {
> -       return kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
> +       struct kvm_mmu_memory_caches *mmu_caches;
> +
> +       mmu_caches = &vcpu->arch.mmu_caches;
> +
> +       return kvm_mmu_memory_cache_alloc(&mmu_caches->pte_list_desc_cache);
>  }
>
>  static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
> @@ -1071,7 +1093,7 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_mmu_memory_cache *mc;
>
> -       mc = &vcpu->arch.mmu_pte_list_desc_cache;
> +       mc = &vcpu->arch.mmu_caches.pte_list_desc_cache;
>         return kvm_mmu_memory_cache_nr_free_objects(mc);
>  }
>
> @@ -1742,12 +1764,15 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
>
>  static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
>  {
> +       struct kvm_mmu_memory_caches *mmu_caches;
>         struct kvm_mmu_page *sp;
>
> -       sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> -       sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> +       mmu_caches = &vcpu->arch.mmu_caches;
> +
> +       sp = kvm_mmu_memory_cache_alloc(&mmu_caches->page_header_cache);
> +       sp->spt = kvm_mmu_memory_cache_alloc(&mmu_caches->shadow_page_cache);
>         if (!direct)
> -               sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> +               sp->gfns = kvm_mmu_memory_cache_alloc(&mmu_caches->gfn_array_cache);
>         set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>
>         /*
> @@ -5544,13 +5569,7 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  {
>         int ret;
>
> -       vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
> -       vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
> -
> -       vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
> -       vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
> -
> -       vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> +       mmu_init_memory_caches(&vcpu->arch.mmu_caches);
>
>         vcpu->arch.mmu = &vcpu->arch.root_mmu;
>         vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 9ee3f4f7fdf5..b70707a7fe87 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -175,10 +175,13 @@ static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
>  static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>                                                int level)
>  {
> +       struct kvm_mmu_memory_caches *mmu_caches;
>         struct kvm_mmu_page *sp;
>
> -       sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> -       sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> +       mmu_caches = &vcpu->arch.mmu_caches;
> +
> +       sp = kvm_mmu_memory_cache_alloc(&mmu_caches->page_header_cache);
> +       sp->spt = kvm_mmu_memory_cache_alloc(&mmu_caches->shadow_page_cache);
>         set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>
>         sp->role.word = page_role_for_level(vcpu, level).word;
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>

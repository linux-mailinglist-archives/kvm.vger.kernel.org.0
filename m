Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D321F489E
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 23:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgFIVHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 17:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgFIVHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 17:07:16 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A95C08C5C3
        for <kvm@vger.kernel.org>; Tue,  9 Jun 2020 14:07:15 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id c9so93442uao.11
        for <kvm@vger.kernel.org>; Tue, 09 Jun 2020 14:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f15ThlgRIs3s50AvF0kFQ8PMHdAjHFT357oOtlUx/ug=;
        b=YQTUSvv3PxEEhj5ujE/dPySButOyH55bK4Xn7FFJQPplWJdwV27lg1hiiGZPMl+Csy
         utkQv6pOjG6DMuuUAn6OW8rUDsTwDk+L09wjyrOsEHgSM9DO1jG+4DXrAkvtnH7+VocI
         GJeE84ALY1lEBJxLNfWmnbxI8H4dKWQGgYe6NIzbLwEX92BP0BVccbN5ywjf+ad2hItV
         hOK3koJ698Vs9caFgU0Oz67/J789jH+4rxh31hXP0eWCQ0G50xlrah8Vhcbhoz+wsVGG
         RvWp/Z6BsjYqNpoy5p5CsKAw38VlYjZy47xgAAr8XRHehyo5E50oaLRajAfxViZwx+CC
         YVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f15ThlgRIs3s50AvF0kFQ8PMHdAjHFT357oOtlUx/ug=;
        b=m1SqbmP7Q0/8RmNLqBC1kCA7tNHpQUvVaLA/9mQxz7fxCiI6g6/3M6KKHLXm4Ss6R8
         8gTUOg+lMhzTcs/Cvfq5PRHE6ajPAOC5/2a1Lz5b4fwVhQW1N1ST9T6woxUjvLVNPeMm
         IIZ3a8Jt9vkxROOCb8WDDD0PpSVk6P8I3kZ3rZs5qFPuoS238j6aSvTv9/Wz8iexuQV2
         89DtPZ0/N5/zfoWXKQZszQ8ONUpW1WI9h2YsNRGxitVu7Al0nVfpDsFyE7hJHifIcY62
         LcBdDSSaLmb+3MPYdnGwar657TwL7y9x7I0vs/MhagCXYiL3YkjzHqyBcyWcqtIdgMEL
         UnYQ==
X-Gm-Message-State: AOAM533tJ3sm9DKoB1tlq0YP56TV3KvCHIMscf1GOFPRSFR1dAXvclel
        +AzixIZl550pXpD+fa/1JMbg71y2Y6loKrfSpdE+AQ==
X-Google-Smtp-Source: ABdhPJwQ+viuUyt4Xvfz0B/F5q8uWrpKqo6vNNs2uM0NepreAFEA0QuoyJVSJ76WQkzVbDy0sso7BcdwlZvUGeg7c1M=
X-Received: by 2002:ab0:6012:: with SMTP id j18mr260224ual.69.1591736832385;
 Tue, 09 Jun 2020 14:07:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com> <20200605213853.14959-2-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-2-sean.j.christopherson@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 9 Jun 2020 14:07:01 -0700
Message-ID: <CANgfPd87=eS6h=GX6CxZRwAj=MTET-AtVAjVQn4i1zkwZ4ApXw@mail.gmail.com>
Subject: Re: [PATCH 01/21] KVM: x86/mmu: Track the associated kmem_cache in
 the MMU caches
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Track the kmem_cache used for non-page KVM MMU memory caches instead of
> passing in the associated kmem_cache when filling the cache.  This will
> allow consolidating code and other cleanups.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/mmu/mmu.c          | 24 +++++++++++-------------
>  2 files changed, 12 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1da5858501ca..16347b050754 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -251,6 +251,7 @@ struct kvm_kernel_irq_routing_entry;
>   */
>  struct kvm_mmu_memory_cache {
>         int nobjs;
> +       struct kmem_cache *kmem_cache;
>         void *objects[KVM_NR_MEM_OBJS];
>  };
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index fdd05c233308..0830c195c9ed 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1060,15 +1060,14 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>         local_irq_enable();
>  }
>
> -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
> -                                 struct kmem_cache *base_cache, int min)
> +static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
>  {
>         void *obj;
>
>         if (cache->nobjs >= min)
>                 return 0;
>         while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> -               obj = kmem_cache_zalloc(base_cache, GFP_KERNEL_ACCOUNT);
> +               obj = kmem_cache_zalloc(cache->kmem_cache, GFP_KERNEL_ACCOUNT);
>                 if (!obj)
>                         return cache->nobjs >= min ? 0 : -ENOMEM;
>                 cache->objects[cache->nobjs++] = obj;
> @@ -1081,11 +1080,10 @@ static int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache)
>         return cache->nobjs;
>  }
>
> -static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
> -                                 struct kmem_cache *cache)
> +static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
>  {
>         while (mc->nobjs)
> -               kmem_cache_free(cache, mc->objects[--mc->nobjs]);
> +               kmem_cache_free(mc->kmem_cache, mc->objects[--mc->nobjs]);
>  }
>
>  static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
> @@ -1115,25 +1113,22 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
>         int r;
>
>         r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
> -                                  pte_list_desc_cache, 8 + PTE_PREFETCH_NUM);
> +                                  8 + PTE_PREFETCH_NUM);
>         if (r)
>                 goto out;
>         r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 8);
>         if (r)
>                 goto out;
> -       r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
> -                                  mmu_page_header_cache, 4);
> +       r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache, 4);
>  out:
>         return r;
>  }
>
>  static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  {
> -       mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
> -                               pte_list_desc_cache);
> +       mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
>         mmu_free_memory_cache_page(&vcpu->arch.mmu_page_cache);
> -       mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache,
> -                               mmu_page_header_cache);
> +       mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>  }
>
>  static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> @@ -5684,6 +5679,9 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>         uint i;
>         int ret;
>
> +       vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
> +       vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
> +
>         vcpu->arch.mmu = &vcpu->arch.root_mmu;
>         vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
>
> --
> 2.26.0
>

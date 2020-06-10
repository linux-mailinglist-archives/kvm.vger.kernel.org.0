Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811A61F5E2A
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 00:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgFJWMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 18:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbgFJWMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 18:12:16 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E701C03E96B
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 15:12:16 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id q2so2271262vsr.1
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 15:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ql4vRpj/ZWF0M5dCwe9+ml5aQlV0lcOnQe3sK6ypzM=;
        b=kTsXOfwbXO1Uvm6+8Wf5L/fmhgemJhOoPbGZtDXyP56sRmOUE+HA356ytHrF/MlXkQ
         r+1fTsody5otxHns0nzVjZjMeQJj9WoPKXg0BPcii5S2Vq1Ayu70wHvn3U6G6RqrQBvC
         jSu1p0ysxMxnJa2TzDGY4sLYXQnzRJLHj0xaUVf1zUO19aG6ujSzer2qXhNyA2X+cvfN
         QNZYptdgi9zoEJS5toP3hYFMkkzdyd1H8EpsMi509eCk6JMhMyTb06cU3CaECg/JVl6m
         tAYCYRdOo7EvNdkjSrQY9nVTNc4YUOIJmFbRZZ2waZnieyy4pcGkAdQQzGPlFugLlj6g
         3d7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ql4vRpj/ZWF0M5dCwe9+ml5aQlV0lcOnQe3sK6ypzM=;
        b=Bg8vBiIk7iXDK4pb8QHQf10C/3meBz6qUS2ojbaXXxUn8jxhGjV3PrfuC1s1dJrMiy
         U5vFal3XpqWnXAANWToV5Nzz87xQ4cDGKVhnGi8GDXVqwcEWZmLMxiIaPi2hkdiUg498
         k8elLybBNaJHOjjDz9v/ZMgKVRqaQ4tQJMA5RocQeAILvPz6K3cshGCBh7v/C7RkUZHu
         v+GYa5zn4MAmi+bzLp4F0yCHNGs+Fa6mCDRYSakgmx91BHEzDlj1abQ1NSbZWB5FoJIC
         zNMIFVOEpTFElKgxfubvr+yXlWKQEszNb5ktSq8UCCcZQkm6Cwm4zRTHfCqOl54BSJQV
         CIBw==
X-Gm-Message-State: AOAM5307vKeKCCmAsioA9sGW5f7S09MLdS9uqufj6T3QRB8K9ef3BOg+
        77nVmFlD3UIvC2vJs2qiiXmqf1aaDmceo9NNVHoohg==
X-Google-Smtp-Source: ABdhPJzdmghMx590xCu3q0oAa1Tiyl8Cd4txMWbr/Hdcmg3h07QCfUudu4lcAnLl2oYkxmlR4q6o6Uh/L8LMxNpv/bE=
X-Received: by 2002:a67:f982:: with SMTP id b2mr4434307vsq.202.1591827135387;
 Wed, 10 Jun 2020 15:12:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com> <20200605213853.14959-6-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-6-sean.j.christopherson@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Jun 2020 15:12:04 -0700
Message-ID: <CANgfPd8B5R9NRL5q_4v4xvvn_3Vo9N93Ms3EiUFANMzqAMedMw@mail.gmail.com>
Subject: Re: [PATCH 05/21] KVM: x86/mmu: Try to avoid crashing KVM if a MMU
 memory cache is empty
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
> Attempt to allocate a new object instead of crashing KVM (and likely the
> kernel) if a memory cache is unexpectedly empty.  Use GFP_ATOMIC for the
> allocation as the caches are used while holding mmu_lock.  The immediate
> BUG_ON() makes the code unnecessarily explosive and led to confusing
> minimums being used in the past, e.g. allocating 4 objects where 1 would
> suffice.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ba70de24a5b0..5e773564ab20 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1060,6 +1060,15 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>         local_irq_enable();
>  }
>
> +static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> +                                              gfp_t gfp_flags)
> +{
> +       if (mc->kmem_cache)
> +               return kmem_cache_zalloc(mc->kmem_cache, gfp_flags);
> +       else
> +               return (void *)__get_free_page(gfp_flags);
> +}
> +
>  static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>  {
>         void *obj;
> @@ -1067,10 +1076,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>         if (mc->nobjs >= min)
>                 return 0;
>         while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> -               if (mc->kmem_cache)
> -                       obj = kmem_cache_zalloc(mc->kmem_cache, GFP_KERNEL_ACCOUNT);
> -               else
> -                       obj = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> +               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
>                 if (!obj)
>                         return mc->nobjs >= min ? 0 : -ENOMEM;
>                 mc->objects[mc->nobjs++] = obj;
> @@ -1118,8 +1124,11 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
>  {
>         void *p;
>
> -       BUG_ON(!mc->nobjs);
> -       p = mc->objects[--mc->nobjs];
> +       if (WARN_ON(!mc->nobjs))
> +               p = mmu_memory_cache_alloc_obj(mc, GFP_ATOMIC | __GFP_ACCOUNT);
Is an atomic allocation really necessary here? In most cases, when
topping up the memory cache we are handing a guest page fault. This
bug could also be removed by returning null if unable to allocate from
the cache, and then re-trying the page fault in that case. I don't
know if this is necessary to handle other, non-x86 architectures more
easily, but I worry this could cause some unpleasantness if combined
with some other bug or the host was in a low memory situation and then
this consumed the atomic pool. Perhaps this is a moot point since we
log a warning and consider the atomic allocation something of an
error.
> +       else
> +               p = mc->objects[--mc->nobjs];
> +       BUG_ON(!p);
>         return p;
>  }
>
> --
> 2.26.0
>

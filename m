Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2EA1F5D18
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 22:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgFJUYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 16:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgFJUYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 16:24:32 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF85AC03E96B
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 13:24:31 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id c15so1325677uar.9
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 13:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OYjqAVwtvPl7Y3hFy8cg2FHFUeVaZTx/znZrNTcOHyg=;
        b=c2GBWEymOyDmHxxDIPkNDniIbX3TqlOV7Ry9nkanRvVCrSn2NMJ1GnwEfVB5/R50jP
         77Rjx/4tfzv/21jbJwgXQWYHRcGohQXCaWO3gsp+nHajYQM5boFPucGIPLgfHX2MDKZ9
         +OTXs9o5nIuxF0NxV+MOUmd1vMtcj2kdrDNZSP44fW4w0h/heaF22VAQQKgm2rqnMc6V
         NJb+uAZ7l7pOtCuqjyYuB03gXscyCe3TL+JYrlC+kUJVKogfkmlGDaS6Z3tJZHdjtIyR
         8GoO1sGjzYWFt6lmc/+nI7dUOUzM6fyQMlG2J8rvlAJmgx36NdSbKub1xcaNcasqobbn
         Zo8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OYjqAVwtvPl7Y3hFy8cg2FHFUeVaZTx/znZrNTcOHyg=;
        b=OfsbEKeKvLgp5a28AoSKbeBE2OrmhaYad9rBL96Pr41wGYKQkw2gt+JWzrJiZwF3DV
         cuQLSkD6GsAYrlQkQBZD2k3Q8l/d/RsNdeJlS0d3Noq1yF0CvCflPeTLR44e5wBqIuu8
         5svm8hdq2O2PfTc+3jr52OpL9Mreo6PQFopwUZwPZbrtNO/0P1tlD2ajjGsIq+4/vuvI
         MMLmnzONgUw5E4clBIHNETiBpWyxmKz9X6kICcTF9j7B+3QygD64ZOB0F1PrOAeU6efE
         lKuiuNPSMsJIjm3TnxGA1Uj/KcSihN1MW+lOhTYXH/c8jZ3fwa3z6bF0sRnOTHohhsDh
         Dvzg==
X-Gm-Message-State: AOAM531O4+zaStmpADqwuUOuQwYtYlvZXrGwqW8D1webUxvkEof8wHKm
        YSj3oVPWpK2qGOBJMhB43owdm0WKT8b7Rkzufc66UQ==
X-Google-Smtp-Source: ABdhPJzuDO175rlKEOjx+cUrssRUoDydSEqe6opXAVLnE5jRaJ0s7w5Cvs20/NG/qvzCO9X/JYv7sNtKVyijp2/LQvA=
X-Received: by 2002:ab0:5642:: with SMTP id z2mr4013044uaa.6.1591820670801;
 Wed, 10 Jun 2020 13:24:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com> <20200605213853.14959-16-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-16-sean.j.christopherson@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Jun 2020 13:24:18 -0700
Message-ID: <CANgfPd_oGhO4dpkejhzh1PaAc-0U068kVdoHj4_fiQveW8yXLg@mail.gmail.com>
Subject: Re: [PATCH 15/21] KVM: Move x86's MMU memory cache helpers to common
 KVM code
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
> Move x86's memory cache helpers to common KVM code so that they can be
> reused by arm64 and MIPS in future patches.
>
> Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c   | 53 --------------------------------------
>  include/linux/kvm_host.h |  7 +++++
>  virt/kvm/kvm_main.c      | 55 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 62 insertions(+), 53 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b85d3e8e8403..a627437f73fd 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1060,47 +1060,6 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>         local_irq_enable();
>  }
>
> -static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> -                                              gfp_t gfp_flags)
> -{
> -       gfp_flags |= mc->gfp_zero;
> -
> -       if (mc->kmem_cache)
> -               return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
> -       else
> -               return (void *)__get_free_page(gfp_flags);
> -}
> -
> -static int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> -{
> -       void *obj;
> -
> -       if (mc->nobjs >= min)
> -               return 0;
> -       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> -               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> -               if (!obj)
> -                       return mc->nobjs >= min ? 0 : -ENOMEM;
> -               mc->objects[mc->nobjs++] = obj;
> -       }
> -       return 0;
> -}
> -
> -static int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
> -{
> -       return mc->nobjs;
> -}
> -
> -static void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
> -{
> -       while (mc->nobjs) {
> -               if (mc->kmem_cache)
> -                       kmem_cache_free(mc->kmem_cache, mc->objects[--mc->nobjs]);
> -               else
> -                       free_page((unsigned long)mc->objects[--mc->nobjs]);
> -       }
> -}
> -
>  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  {
>         int r;
> @@ -1132,18 +1091,6 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>         kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>  }
>
> -static void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> -{
> -       void *p;
> -
> -       if (WARN_ON(!mc->nobjs))
> -               p = mmu_memory_cache_alloc_obj(mc, GFP_ATOMIC | __GFP_ACCOUNT);
> -       else
> -               p = mc->objects[--mc->nobjs];
> -       BUG_ON(!p);
> -       return p;
> -}
> -
>  static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
>  {
>         return kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d38d6b9c24be..802b9e2306f0 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -815,6 +815,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
>  void kvm_flush_remote_tlbs(struct kvm *kvm);
>  void kvm_reload_remote_mmus(struct kvm *kvm);
>
> +#ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
> +int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
> +int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
> +void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
> +void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
> +#endif
> +
>  bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>                                  struct kvm_vcpu *except,
>                                  unsigned long *vcpu_bitmap, cpumask_var_t tmp);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4db151f6101e..fead5f1d5594 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -342,6 +342,61 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
>         kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
>  }
>
> +#ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
> +static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> +                                              gfp_t gfp_flags)
> +{
> +       gfp_flags |= mc->gfp_zero;
> +
> +       if (mc->kmem_cache)
> +               return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
> +       else
> +               return (void *)__get_free_page(gfp_flags);
> +}
> +
> +int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> +{
> +       void *obj;
> +
> +       if (mc->nobjs >= min)
> +               return 0;
> +       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> +               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> +               if (!obj)
> +                       return mc->nobjs >= min ? 0 : -ENOMEM;
> +               mc->objects[mc->nobjs++] = obj;
> +       }
> +       return 0;
> +}
> +
> +int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
> +{
> +       return mc->nobjs;
> +}
> +
> +void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
> +{
> +       while (mc->nobjs) {
> +               if (mc->kmem_cache)
> +                       kmem_cache_free(mc->kmem_cache, mc->objects[--mc->nobjs]);
> +               else
> +                       free_page((unsigned long)mc->objects[--mc->nobjs]);
> +       }
> +}
> +
> +void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> +{
> +       void *p;
> +
> +       if (WARN_ON(!mc->nobjs))
> +               p = mmu_memory_cache_alloc_obj(mc, GFP_ATOMIC | __GFP_ACCOUNT);
> +       else
> +               p = mc->objects[--mc->nobjs];
> +       BUG_ON(!p);
> +       return p;
> +}
> +#endif
> +
>  static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>  {
>         mutex_init(&vcpu->mutex);
> --
> 2.26.0
>

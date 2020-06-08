Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1B81F14D7
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 10:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgFHI5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 04:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgFHI5c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 04:57:32 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BCEC08C5C4;
        Mon,  8 Jun 2020 01:57:31 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id a13so15981423ilh.3;
        Mon, 08 Jun 2020 01:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZhUJIihNsOJBPcBzEUBiE7/iTHmbpkI3L5KiEBlzlAw=;
        b=Y9+UtojWa2WvofBKlqksrH2UxqOeor9ywSsTiV/vDSFGtDp5oN9ImT7jixVrCmdrv7
         KqNvYCOlvk6+QKy0dRkO4iGrNI1kmjIN/u1NVSqW1i1b/KF63PcNOO/bFR5fou29C499
         imfbf9MzdZyRbHyCiRH8irRF8ehZh/IUDpq6TclCsORYbkamGlPncs3p/d40LqM/8v0O
         +fDZsW+XFyhc934YqXtULIaXiGVuUIDbErtxW3Jcylu0nj4HGVsGOYIqFaPoNNpjmbZy
         2J56AZj9w8fwtGQ2NO7AePx8m8uSEytRjzYL5oCw63lDRsB4J+xLIy9/+aw4NX/Oh//i
         Tqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZhUJIihNsOJBPcBzEUBiE7/iTHmbpkI3L5KiEBlzlAw=;
        b=WHeY0+r4m4nE9G/x683xsnmbknJAA8PUeEDr7lcw8ojSvRJ5wQf0oknqzk2mmWPqWe
         kJSh6QZ2GhH+hC1s04BjsnFjokILqb8KpQ4ypHb1e3EEzr84ll27LIE78N/MKdN0KELx
         a3h6TBa9oOlXQItS/PfgJ8WygUv5B/ecq7ILVEOyT/6NQjh6YeSCyazJd7ph0PFZJyjy
         mWeu8xsFvuvSt/JGLjQsRazJ0lduRxPib9xHZRVgzGY4F7GXksgEb8G2uvaYHEzLJo2r
         ZjLwAavJKTTwY6HUn55xrw0appCQJWeK3tyVrp7ezxTIeq9oiP2+FYeTFOECYaxAgueV
         AufQ==
X-Gm-Message-State: AOAM532D6J6vIPVcXqhKHY+epFW5KqrlagWgzAymlGieEptz42As1kom
        bYhVaMpiZ9bYtDPX5RbPBbOQCnN0YGtHWZ7pVhg=
X-Google-Smtp-Source: ABdhPJwyPmJaXLtSbRr/u7WSBpcrHXUO5Dpivercq2zRD4AQJbzLRnckACLEYWNLFcrCuA7qfpn1FslH2bosTiVE5PA=
X-Received: by 2002:a92:9f12:: with SMTP id u18mr20674915ili.287.1591606651183;
 Mon, 08 Jun 2020 01:57:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com> <20200605213853.14959-22-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-22-sean.j.christopherson@intel.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Mon, 8 Jun 2020 16:57:20 +0800
Message-ID: <CAAhV-H4XrXx9ktum-E706ggukSU77hdN-iofJ-DDGtLeGt+KPA@mail.gmail.com>
Subject: Re: [PATCH 21/21] KVM: MIPS: Use common KVM implementation of MMU
 memory caches
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
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Huacai Chen <chenhc@lemote.com>

On Sat, Jun 6, 2020 at 5:41 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Move to the common MMU memory cache implementation now that the common
> code and MIPS's existing code are semantically compatible.
>
> No functional change intended.
>
> Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/mips/include/asm/kvm_host.h  | 11 ---------
>  arch/mips/include/asm/kvm_types.h |  2 ++
>  arch/mips/kvm/mmu.c               | 40 ++++---------------------------
>  3 files changed, 7 insertions(+), 46 deletions(-)
>
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 363e7a89d173..f49617175f60 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -335,17 +335,6 @@ struct kvm_mips_tlb {
>         long tlb_lo[2];
>  };
>
> -#define KVM_NR_MEM_OBJS     4
> -
> -/*
> - * We don't want allocation failures within the mmu code, so we preallocate
> - * enough memory for a single page fault in a cache.
> - */
> -struct kvm_mmu_memory_cache {
> -       int nobjs;
> -       void *objects[KVM_NR_MEM_OBJS];
> -};
> -
>  #define KVM_MIPS_AUX_FPU       0x1
>  #define KVM_MIPS_AUX_MSA       0x2
>
> diff --git a/arch/mips/include/asm/kvm_types.h b/arch/mips/include/asm/kvm_types.h
> index 5efeb32a5926..213754d9ef6b 100644
> --- a/arch/mips/include/asm/kvm_types.h
> +++ b/arch/mips/include/asm/kvm_types.h
> @@ -2,4 +2,6 @@
>  #ifndef _ASM_MIPS_KVM_TYPES_H
>  #define _ASM_MIPS_KVM_TYPES_H
>
> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE     4
> +
>  #endif /* _ASM_MIPS_KVM_TYPES_H */
> diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
> index 41a4a063a730..d6acd88c0c46 100644
> --- a/arch/mips/kvm/mmu.c
> +++ b/arch/mips/kvm/mmu.c
> @@ -25,39 +25,9 @@
>  #define KVM_MMU_CACHE_MIN_PAGES 2
>  #endif
>
> -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
> -{
> -       void *page;
> -
> -       if (cache->nobjs >= min)
> -               return 0;
> -       while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> -               page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> -               if (!page)
> -                       return -ENOMEM;
> -               cache->objects[cache->nobjs++] = page;
> -       }
> -       return 0;
> -}
> -
> -static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
> -{
> -       while (mc->nobjs)
> -               free_page((unsigned long)mc->objects[--mc->nobjs]);
> -}
> -
> -static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> -{
> -       void *p;
> -
> -       BUG_ON(!mc || !mc->nobjs);
> -       p = mc->objects[--mc->nobjs];
> -       return p;
> -}
> -
>  void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  {
> -       mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
> +       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>  }
>
>  /**
> @@ -151,7 +121,7 @@ static pte_t *kvm_mips_walk_pgd(pgd_t *pgd, struct kvm_mmu_memory_cache *cache,
>
>                 if (!cache)
>                         return NULL;
> -               new_pmd = mmu_memory_cache_alloc(cache);
> +               new_pmd = kvm_mmu_memory_cache_alloc(cache);
>                 pmd_init((unsigned long)new_pmd,
>                          (unsigned long)invalid_pte_table);
>                 pud_populate(NULL, pud, new_pmd);
> @@ -162,7 +132,7 @@ static pte_t *kvm_mips_walk_pgd(pgd_t *pgd, struct kvm_mmu_memory_cache *cache,
>
>                 if (!cache)
>                         return NULL;
> -               new_pte = mmu_memory_cache_alloc(cache);
> +               new_pte = kvm_mmu_memory_cache_alloc(cache);
>                 clear_page(new_pte);
>                 pmd_populate_kernel(NULL, pmd, new_pte);
>         }
> @@ -709,7 +679,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
>                 goto out;
>
>         /* We need a minimum of cached pages ready for page table creation */
> -       err = mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES);
> +       err = kvm_mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES);
>         if (err)
>                 goto out;
>
> @@ -793,7 +763,7 @@ static pte_t *kvm_trap_emul_pte_for_gva(struct kvm_vcpu *vcpu,
>         int ret;
>
>         /* We need a minimum of cached pages ready for page table creation */
> -       ret = mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES);
> +       ret = kvm_mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES);
>         if (ret)
>                 return NULL;
>
> --
> 2.26.0
>

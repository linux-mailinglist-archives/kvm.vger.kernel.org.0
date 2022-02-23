Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FA94C1FB1
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 00:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244776AbiBWXbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 18:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244823AbiBWXbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 18:31:35 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF25F583B6
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 15:31:06 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id p15so643002ejc.7
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 15:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5ccdAVtqtaKeuzsvaiuEUAPtl8g+EHn8mU+jAaBKZh4=;
        b=PWpNIG+hT4vDvO5za40lu/u32WPHeBFhHiTkyAsrkHLcvgVV5pYgPB8g5ctItFpFEX
         O+q42AJt3JGH9xQ2Vwor2JYAeBufmPEaA15Q8VOUrAHZP0u8J3+/mfhtcVBDhTc4Tcc3
         mV5fdTLpI9Vp6p2/gdCa0tJ4THMh86z/jd6n93C+YzMzJ115z6PkI2IuRdebgYW555bT
         7vK+1Hdfc98biP65kypQJfXhjoB20q3RSKM7VsSq7uFF3YzscLW710X10iumwgPnQLvl
         owf9ujZwHJHGLZSgKNp5F76EUGMTU9WM3rgcak/6yoV/j/gx4fXGh2KKBkJ0InkRLtub
         F69Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ccdAVtqtaKeuzsvaiuEUAPtl8g+EHn8mU+jAaBKZh4=;
        b=em/6fwus8kgfyrN7lG0RYp3pDLky/oOIc43/kv0V3dcoxLEaRMWj7XFi09SCdSVX6r
         qiLqpVwn3ONEyoN1uMbP6I8h6qq4QH/2of/DVTJMcF5szUS1myfHteN5S50M8qq2XqMw
         l2NNvDZUCvy5WSIFcRRS0I/Y86vVaNKhNRPVqT/EeckxDGtNnEBMyiQlTlspiISK8yvs
         aaWCfnBZt9r6gHQvHK9qcZZGp25RWee5of6iIa992+dIGGG+S8ZZFadpajFVKCjozNXa
         68HCjdP/q6Szbv05F+Eeks/8kW4PcVHtZPD0nTnQX10BWPIMWY1WeLl97TRUW+HlnaoG
         XwTQ==
X-Gm-Message-State: AOAM5304y2m6UeAkpSlZ+CHCyOaf3iprbbD8cAPW7CNOv/74yVsstUMD
        mj+5WxqHkuwcZal5JDTs1QpBI9wWgnaDIuJyFGmXGQ==
X-Google-Smtp-Source: ABdhPJwIXzlCNdyzs0N+JumQnFYqw+y4DWSoeUCM/PyoAlk3oEAyOlDe/lSGRZuRRuH7fRALhCcW4BkqIFkBqwlDCZA=
X-Received: by 2002:a17:906:2486:b0:6cf:ced9:e4cc with SMTP id
 e6-20020a170906248600b006cfced9e4ccmr37281ejb.201.1645659065280; Wed, 23 Feb
 2022 15:31:05 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-13-dmatlack@google.com>
In-Reply-To: <20220203010051.2813563-13-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 23 Feb 2022 15:30:54 -0800
Message-ID: <CANgfPd-0U_kBya+xBp3f18x+ktN=59tzC3AjDG7SS-MrCzZvew@mail.gmail.com>
Subject: Re: [PATCH 12/23] KVM: x86/mmu: Decouple rmap_add() and
 link_shadow_page() from kvm_vcpu
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 2, 2022 at 5:02 PM David Matlack <dmatlack@google.com> wrote:
>
> Allow adding new entries to the rmap and linking shadow pages without a
> struct kvm_vcpu pointer by moving the implementation of rmap_add() and
> link_shadow_page() into inner helper functions.
>
> No functional change intended.
>

Reviewed-by: Ben Gardon <bgardon@google.com>

> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 43 +++++++++++++++++++++++++++---------------
>  1 file changed, 28 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index de7c47ee0def..c2f7f026d414 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -736,9 +736,9 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>         kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>  }
>
> -static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
> +static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_mmu_memory_cache *cache)
>  {
> -       return kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
> +       return kvm_mmu_memory_cache_alloc(cache);
>  }
>
>  static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
> @@ -885,7 +885,7 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
>  /*
>   * Returns the number of pointers in the rmap chain, not counting the new one.
>   */
> -static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
> +static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
>                         struct kvm_rmap_head *rmap_head)
>  {
>         struct pte_list_desc *desc;
> @@ -896,7 +896,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
>                 rmap_head->val = (unsigned long)spte;
>         } else if (!(rmap_head->val & 1)) {
>                 rmap_printk("%p %llx 1->many\n", spte, *spte);
> -               desc = mmu_alloc_pte_list_desc(vcpu);
> +               desc = mmu_alloc_pte_list_desc(cache);
>                 desc->sptes[0] = (u64 *)rmap_head->val;
>                 desc->sptes[1] = spte;
>                 desc->spte_count = 2;
> @@ -908,7 +908,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
>                 while (desc->spte_count == PTE_LIST_EXT) {
>                         count += PTE_LIST_EXT;
>                         if (!desc->more) {
> -                               desc->more = mmu_alloc_pte_list_desc(vcpu);
> +                               desc->more = mmu_alloc_pte_list_desc(cache);
>                                 desc = desc->more;
>                                 desc->spte_count = 0;
>                                 break;
> @@ -1607,8 +1607,10 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>
>  #define RMAP_RECYCLE_THRESHOLD 1000
>
> -static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
> -                    u64 *spte, gfn_t gfn)
> +static void __rmap_add(struct kvm *kvm,
> +                      struct kvm_mmu_memory_cache *cache,
> +                      const struct kvm_memory_slot *slot,
> +                      u64 *spte, gfn_t gfn)
>  {
>         struct kvm_mmu_page *sp;
>         struct kvm_rmap_head *rmap_head;
> @@ -1617,15 +1619,21 @@ static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
>         sp = sptep_to_sp(spte);
>         kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
>         rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
> -       rmap_count = pte_list_add(vcpu, spte, rmap_head);
> +       rmap_count = pte_list_add(cache, spte, rmap_head);
>
>         if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
> -               kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
> +               kvm_unmap_rmapp(kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
>                 kvm_flush_remote_tlbs_with_address(
> -                               vcpu->kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
> +                               kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
>         }
>  }
>
> +static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
> +                    u64 *spte, gfn_t gfn)
> +{
> +       __rmap_add(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, slot, spte, gfn);
> +}
> +
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>         bool young = false;
> @@ -1693,13 +1701,13 @@ static unsigned kvm_page_table_hashfn(gfn_t gfn)
>         return hash_64(gfn, KVM_MMU_HASH_SHIFT);
>  }
>
> -static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
> +static void mmu_page_add_parent_pte(struct kvm_mmu_memory_cache *cache,
>                                     struct kvm_mmu_page *sp, u64 *parent_pte)
>  {
>         if (!parent_pte)
>                 return;
>
> -       pte_list_add(vcpu, parent_pte, &sp->parent_ptes);
> +       pte_list_add(cache, parent_pte, &sp->parent_ptes);
>  }
>
>  static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
> @@ -2297,8 +2305,8 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
>         __shadow_walk_next(iterator, *iterator->sptep);
>  }
>
> -static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
> -                            struct kvm_mmu_page *sp)
> +static void __link_shadow_page(struct kvm_mmu_memory_cache *cache, u64 *sptep,
> +                              struct kvm_mmu_page *sp)
>  {
>         u64 spte;
>
> @@ -2308,12 +2316,17 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
>
>         mmu_spte_set(sptep, spte);
>
> -       mmu_page_add_parent_pte(vcpu, sp, sptep);
> +       mmu_page_add_parent_pte(cache, sp, sptep);
>
>         if (sp->unsync_children || sp->unsync)
>                 mark_unsync(sptep);
>  }
>
> +static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep, struct kvm_mmu_page *sp)
> +{
> +       __link_shadow_page(&vcpu->arch.mmu_pte_list_desc_cache, sptep, sp);
> +}
> +
>  static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>                                    unsigned direct_access)
>  {
> --
> 2.35.0.rc2.247.g8bbb082509-goog
>

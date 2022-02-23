Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72824C1F9E
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 00:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244806AbiBWX2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 18:28:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235909AbiBWX17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 18:27:59 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF51275DD
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 15:27:30 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id p14so587195ejf.11
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 15:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5X1YaFTI36jwHnoJwwM16KyoU6RTtxA9l17Sy715ZsA=;
        b=SpsUFkZNz0BM+tYUspnS5/gNcb6sKCfqJfKp+0HlOpUTH3JhwpdM4RXS+4z+Wd5S32
         ljc96LDTu94FY8455D1G8Af7/ZrP1nAJSgVkLjp/j28mSkBukmRlx6/WQEuazwtwxHXS
         vMROUBChz3gt7W+jxQA4X3rjz6enybt5Sl4+8CZTwsPAJvUQ9n7Wd4k4tWJvwG+O87lH
         KCIlQB0FxvAu3VqFaz4f6JbJpDf+kax+QZSXWSHA7hTjRnYykKNrqbBQj2Gaf5nd8W5M
         gI1E7Wdl+NBbnZ2rZfKDDqYXRuwmY4bfz+d6RkdgVWx11wBlSdCknZw8uhYQtHAd8bqO
         EZ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5X1YaFTI36jwHnoJwwM16KyoU6RTtxA9l17Sy715ZsA=;
        b=iS8hkYqTj6IDbwYEMd63bLpI9xs4pi8vx59fQ3GpG1vxSsBvvYhRb1ieEQ3SqT00dD
         owV3HVQ3BNFAUWZdTWNEbTr/wdMt41PAUO8K4N9QfExez/YWHVFDZGfRuNMUQGV5WE16
         1h7jhxO7Y5R82t5nrmFbZYOuKIxIaBopjOyO4Noy+8MioL3CabhSYa7/fMf1wU3lIgMD
         yIIoyj+8K7Qw/e6FBIwKnw3aCOsVzpga8f/5rCyILPcrNHODMfdzA9cIM5+buxNK4KlJ
         UJbtCZ8jKeSYQFCLkNfy+pHnNPrL+5peLHrqXzbQVourU1VHgNJeI+QRUxIOY4prki7D
         kHWg==
X-Gm-Message-State: AOAM532CoNT3kYMw83FT+/7zlbQHgveWpOr1YcapToP5XRQoBn6otG8E
        vuC89B4kZCa0fnBLwYXmdfTC0ZjloL8rGRV9zgrV4w==
X-Google-Smtp-Source: ABdhPJypusE8oK1dGxvuo68i/EI3X+k0BYKTeUc1jHHN0R24GYirBEY/bGVuc7fFfSMeLCWmCEO2gsuOykOkjrzo//Q=
X-Received: by 2002:a17:906:5cb:b0:6cf:954:d84d with SMTP id
 t11-20020a17090605cb00b006cf0954d84dmr44454ejt.560.1645658848879; Wed, 23 Feb
 2022 15:27:28 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-12-dmatlack@google.com>
In-Reply-To: <20220203010051.2813563-12-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 23 Feb 2022 15:27:17 -0800
Message-ID: <CANgfPd-qnG0eQY0DB9tpXH6U_FwoXf=8PiS3bLE8UrTgG4c8bw@mail.gmail.com>
Subject: Re: [PATCH 11/23] KVM: x86/mmu: Pass const memslot to
 kvm_mmu_init_sp() and descendants
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
> Use a const pointer so that kvm_mmu_init_sp() can be called from
> contexts where we have a const pointer.
>
> No functional change intended.
>

Reviewed-by: Ben Gardon <bgardon@google.com>

> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/include/asm/kvm_page_track.h | 2 +-
>  arch/x86/kvm/mmu/mmu.c                | 7 +++----
>  arch/x86/kvm/mmu/mmu_internal.h       | 2 +-
>  arch/x86/kvm/mmu/page_track.c         | 4 ++--
>  arch/x86/kvm/mmu/tdp_mmu.c            | 2 +-
>  arch/x86/kvm/mmu/tdp_mmu.h            | 2 +-
>  6 files changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index eb186bc57f6a..3a2dc183ae9a 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h
> @@ -58,7 +58,7 @@ int kvm_page_track_create_memslot(struct kvm *kvm,
>                                   unsigned long npages);
>
>  void kvm_slot_page_track_add_page(struct kvm *kvm,
> -                                 struct kvm_memory_slot *slot, gfn_t gfn,
> +                                 const struct kvm_memory_slot *slot, gfn_t gfn,
>                                   enum kvm_page_track_mode mode);
>  void kvm_slot_page_track_remove_page(struct kvm *kvm,
>                                      struct kvm_memory_slot *slot, gfn_t gfn,
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a5e3bb632542..de7c47ee0def 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -805,7 +805,7 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn)
>  }
>
>  static void account_shadowed(struct kvm *kvm,
> -                            struct kvm_memory_slot *slot,
> +                            const struct kvm_memory_slot *slot,
>                              struct kvm_mmu_page *sp)
>  {
>         gfn_t gfn;
> @@ -1384,7 +1384,7 @@ int kvm_cpu_dirty_log_size(void)
>  }
>
>  bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
> -                                   struct kvm_memory_slot *slot, u64 gfn,
> +                                   const struct kvm_memory_slot *slot, u64 gfn,
>                                     int min_level)
>  {
>         struct kvm_rmap_head *rmap_head;
> @@ -2158,9 +2158,8 @@ static struct kvm_mmu_page *kvm_mmu_get_existing_sp(struct kvm_vcpu *vcpu,
>         return sp;
>  }
>
> -
>  static void kvm_mmu_init_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
> -                           struct kvm_memory_slot *slot, gfn_t gfn,
> +                           const struct kvm_memory_slot *slot, gfn_t gfn,
>                             union kvm_mmu_page_role role)
>  {
>         struct hlist_head *sp_list;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index c5f2c0b9177d..e6bcea5a0aa9 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -123,7 +123,7 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
>  void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
>  void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
>  bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
> -                                   struct kvm_memory_slot *slot, u64 gfn,
> +                                   const struct kvm_memory_slot *slot, u64 gfn,
>                                     int min_level);
>  void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
>                                         u64 start_gfn, u64 pages);
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 68eb1fb548b6..ebd704946a35 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -83,7 +83,7 @@ int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot)
>         return 0;
>  }
>
> -static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
> +static void update_gfn_track(const struct kvm_memory_slot *slot, gfn_t gfn,
>                              enum kvm_page_track_mode mode, short count)
>  {
>         int index, val;
> @@ -111,7 +111,7 @@ static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
>   * @mode: tracking mode, currently only write track is supported.
>   */
>  void kvm_slot_page_track_add_page(struct kvm *kvm,
> -                                 struct kvm_memory_slot *slot, gfn_t gfn,
> +                                 const struct kvm_memory_slot *slot, gfn_t gfn,
>                                   enum kvm_page_track_mode mode)
>  {
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4ff1af24b5aa..34c451f1eac9 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1645,7 +1645,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
>   * Returns true if an SPTE was set and a TLB flush is needed.
>   */
>  bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
> -                                  struct kvm_memory_slot *slot, gfn_t gfn,
> +                                  const struct kvm_memory_slot *slot, gfn_t gfn,
>                                    int min_level)
>  {
>         struct kvm_mmu_page *root;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 3f987785702a..b1265149a05d 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -64,7 +64,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
>                                        const struct kvm_memory_slot *slot);
>
>  bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
> -                                  struct kvm_memory_slot *slot, gfn_t gfn,
> +                                  const struct kvm_memory_slot *slot, gfn_t gfn,
>                                    int min_level);
>
>  void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
> --
> 2.35.0.rc2.247.g8bbb082509-goog
>

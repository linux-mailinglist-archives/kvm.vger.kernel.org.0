Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5076C4C7A7F
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 21:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiB1UdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 15:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiB1UdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 15:33:18 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97D46588
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 12:32:38 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id p14so27192600ejf.11
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 12:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qBG++gz25ju+q482olgxmlJJKMf9qE+XSZWyoLg6wIU=;
        b=GMK/6nfKVr4/U5Vgs5EF4PI2b4dI6bEVOm8PnVbjiYv0LvHji4ie97WBm8R9j+JnfW
         +ghoZ32YGev7wLWyqTIC6qae0dKOLeQEBzGNgOrCDLQdhh49GFAKO5aFbdFGIrhKHcWX
         NHqkf8LmojaF1dCDBAlu/PlP0wOvjY0/OztrmbvmYBSy3eJiT2MDvpXdKEY+0FzTGUS1
         482qEFIYBd6oT+jk2vd01k+gYz0+K7M/gVwM+zSwAHVH1SUH9NA0oSE5iTMMIlAMuiVP
         3RB1H4Lnn/pDe8JqjG6yKJNSEMU+d41hbirLi+5x9BKdoxufQKtHOa4ZyZPCbSwqTYSx
         71Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qBG++gz25ju+q482olgxmlJJKMf9qE+XSZWyoLg6wIU=;
        b=yG30BC+VBkbUcD6gCPBuj6WGzja4LGZ2sVyd1IpeLE7CBcNuM4D0myme9GjDtGTP9V
         IURWiQzEY0ja9SmxFF8RbrE4gjh/FX8iHYoVBeSalhOF6F2do+8L4dqZY8DY43MGQQaj
         Az4rYOgBIwLhshZu2iTOv5ZHouhKcLdTQyzTR/uJOLZnf2gX0+4I7t5C/HSe/DUZ8quT
         GSQgqKvZ7SlyvBXV8st+6NtnvTp8SVqPzNjfmcPfLueit8d1Y/KY9PeROTAJlBkwgce0
         FEYm5dPD9IQGnk/7LrqcR2UOXTI2RKEey4s4uRijJ78WGS88E9uIe2tUwlPd9duoARre
         3oPw==
X-Gm-Message-State: AOAM533MuvIhjPSkmV9FykxPcAwm4vqikSXMV6WdT/HYpsWJ70+Tcsp8
        dVHPRdw1I/ySngxiOaVtWeGqEGsKtjF8JTsqFhwVnw==
X-Google-Smtp-Source: ABdhPJzZIr58WpSL112z4gPfVBsmxBFS/6XKDNlnNYbFj7+hgJlzI7vi4Ygb+mRBBq7uMfmgNoulPMmr8ZghoNJ6ghM=
X-Received: by 2002:a17:906:2486:b0:6cf:ced9:e4cc with SMTP id
 e6-20020a170906248600b006cfced9e4ccmr16417931ejb.201.1646080357052; Mon, 28
 Feb 2022 12:32:37 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-16-dmatlack@google.com>
In-Reply-To: <20220203010051.2813563-16-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 28 Feb 2022 12:32:25 -0800
Message-ID: <CANgfPd-roAGhXO1FQiJZy0D4eaJULr2nJwSJg4h4Pe1PHHtFzA@mail.gmail.com>
Subject: Re: [PATCH 15/23] KVM: x86/mmu: Pass access information to make_huge_page_split_spte()
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
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
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
> Currently make_huge_page_split_spte() assumes execute permissions can be
> granted to any 4K SPTE when splitting huge pages. This is true for the
> TDP MMU but is not necessarily true for the shadow MMU. Huge pages
> mapped by the shadow MMU may be shadowing huge pages that the guest has
> disallowed execute permissions.
>
> No functional change intended.
>

Reviewed-by: Ben Gardon <bgardon@google.com>

> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/spte.c    | 5 +++--
>  arch/x86/kvm/mmu/spte.h    | 3 ++-
>  arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
>  3 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 20cf9e0d45dd..7cba5cffc240 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -215,7 +215,8 @@ static u64 make_spte_executable(u64 spte)
>   * This is used during huge page splitting to build the SPTEs that make up the
>   * new page table.
>   */
> -u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
> +u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index,
> +                             unsigned int access)
>  {
>         u64 child_spte;
>         int child_level;
> @@ -243,7 +244,7 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
>                  * When splitting to a 4K page, mark the page executable as the
>                  * NX hugepage mitigation no longer applies.
>                  */
> -               if (is_nx_huge_page_enabled())
> +               if (is_nx_huge_page_enabled() && (access & ACC_EXEC_MASK))
>                         child_spte = make_spte_executable(child_spte);
>         }
>
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 73f12615416f..c7ccdd5c440d 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -415,7 +415,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>                unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
>                u64 old_spte, bool prefetch, bool can_unsync,
>                bool host_writable, u64 *new_spte);
> -u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
> +u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index,
> +                             unsigned int access);
>  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
>  u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
>  u64 mark_spte_for_access_track(u64 spte);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 34c451f1eac9..02bfbc1bebbe 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1310,7 +1310,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>          * not been linked in yet and thus is not reachable from any other CPU.
>          */
>         for (i = 0; i < PT64_ENT_PER_PAGE; i++)
> -               sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
> +               sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i, ACC_ALL);
>
>         /*
>          * Replace the huge spte with a pointer to the populated lower level
> --
> 2.35.0.rc2.247.g8bbb082509-goog
>

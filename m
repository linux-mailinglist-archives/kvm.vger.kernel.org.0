Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5354D4E3341
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 23:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiCUWxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 18:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiCUWws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 18:52:48 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B944616E2
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:40:07 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r10so22655466wrp.3
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9lfgL3STyhcbUTg/2mdbbAna/81RZPKVO1DCdewIE0c=;
        b=gyWTW65QfHhxvHH2bxgBaFULc3nQpwZVt/AImeBaMsagLh7ZILfBIv+cpBZ1WSMI9Y
         TOPeV02sp4XiVQ8lLN4FhnC7+vP3gy404ImwUap5qVGjKFQLADRuLKDINVF1PWzZB4oh
         U1mEyqWzxsu3MtArm0qnwbxI0Tx9hdG/LVKbNXemcrBdZ3oknTgvP+A4O4F1hDotj6c7
         FVqupN7ClUGTVzfsEfmwX4wkAgsXCHqtd+IxXQCc+4lmBRSffgJC9BQPVBCIHWW3kbD/
         9j6hHMT86dOmHX2WVzZ5qGs1t/Zz97eNKhrycXInFxW646D96NZqUdSy6LBktZ2feENm
         LGqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9lfgL3STyhcbUTg/2mdbbAna/81RZPKVO1DCdewIE0c=;
        b=UrGe8faXT0ZadXzEdxfPX5FL6Bpb4On2dwaePveaXCgQX54j993E8A220vR1InSspw
         /gJJa2PNKV5/IsHW5z5BjLEqcBZM10nX6cM5xIEzL8c8DXTFybDHMueTVlnOlB2CHMP2
         1Epht53paT/cHcTBt9Z058e+klGlZEID7Jx3+YHBmsJeb7W1qzrNE53+SE6bDVyDqV+t
         pdzjeL7zNc7SmKa0LH+MNFou3NKZoY6WQhouuyTB9GXO1tfPyP/uTEjnBhBvSgLVI68P
         UsguRFt43LTU/PwBf9P9liwj/Cf1OcDn4H/UkS++w5acxOM4/lffHZGiwiBBrwQUYDww
         ILtw==
X-Gm-Message-State: AOAM530qtueg8vdOLDihaq1bh/2UEChA/ESIDdRLvJ6RkRy5i7ND8ULK
        XPAoJFW6z0RCZRHwCC4FJNsVH2Hu07YEtradSwkzEB6emq3F5w==
X-Google-Smtp-Source: ABdhPJyawG4O85guPSFaNHQuFtdGjIUfvponf4x7mJ068IZhUDgnWrnpRgCdV86cGiMMISGbZ7KYluPjZMFypJf0Ncc=
X-Received: by 2002:a2e:6804:0:b0:245:f269:618 with SMTP id
 c4-20020a2e6804000000b00245f2690618mr16315718lja.198.1647900072176; Mon, 21
 Mar 2022 15:01:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220321002638.379672-1-mizhang@google.com> <20220321002638.379672-4-mizhang@google.com>
In-Reply-To: <20220321002638.379672-4-mizhang@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 21 Mar 2022 15:00:45 -0700
Message-ID: <CALzav=dU5TPfhp1=n+zo+AcPkL4rpWCRpMCL91vE5z20R+mmjg@mail.gmail.com>
Subject: Re: [PATCH 3/4] KVM: x86/mmu: explicitly check nx_hugepage in disallowed_hugepage_adjust()
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>, Ben Gardon <bgorden@google.com>
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

On Sun, Mar 20, 2022 at 5:26 PM Mingwei Zhang <mizhang@google.com> wrote:
>
> Add extra check to specify the case of nx hugepage and allow KVM to
> reconstruct large mapping after dirty logging is disabled. Existing code
> works only for nx hugepage but the condition is too general in that does
> not consider other usage case (such as dirty logging).

KVM calls kvm_mmu_zap_collapsible_sptes() when dirty logging is
disabled. Why is that not sufficient?

> Moreover, existing
> code assumes that a present PMD or PUD indicates that there exist 'smaller
> SPTEs' under the paging structure. This assumption may no be true if
> consider the zapping leafs only behavior in MMU.

Good point. Although, that code just got reverted. Maybe say something like:

  This assumption may not be true in the future if KVM gains support
for zapping only leaf SPTEs.

>
> Missing the check causes KVM incorrectly regards the faulting page as a NX
> huge page and refuse to map it at desired level. And this leads to back
> performance in shadow mmu and potentiall TDP mmu.

s/potentiall/potentially/

>
> Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
> Cc: stable@vger.kernel.org
>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5628d0ba637e..4d358c273f6c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2919,6 +2919,16 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>             cur_level == fault->goal_level &&
>             is_shadow_present_pte(spte) &&
>             !is_large_pte(spte)) {
> +               struct kvm_mmu_page *sp;
> +               u64 page_mask;
> +               /*
> +                * When nx hugepage flag is not set, there is no reason to
> +                * go down to another level. This helps demand paging to
> +                * generate large mappings.
> +                */
> +               sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
> +               if (!sp->lpage_disallowed)
> +                       return;
>                 /*
>                  * A small SPTE exists for this pfn, but FNAME(fetch)
>                  * and __direct_map would like to create a large PTE
> @@ -2926,8 +2936,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>                  * patching back for them into pfn the next 9 bits of
>                  * the address.
>                  */
> -               u64 page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
> -                               KVM_PAGES_PER_HPAGE(cur_level - 1);
> +               page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
> +                       KVM_PAGES_PER_HPAGE(cur_level - 1);
>                 fault->pfn |= fault->gfn & page_mask;
>                 fault->goal_level--;
>         }
> --
> 2.35.1.894.gb6a874cedc-goog
>

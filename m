Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FBA4E2F72
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 18:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351893AbiCUR5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 13:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351886AbiCUR5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 13:57:39 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F29666FA5
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 10:56:14 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id u103so29451215ybi.9
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 10:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kfv/9FSlbLzfGxHvKEV7DROpdlh0zhjyUxjgEm+XMUs=;
        b=Enp0aTiRztyLlENDKrOUZbpSrFZjJVqkANRGVkYcu7I6u7d4eQombCyjgdN5NKqFOL
         EsNSmqRoz9w4bFl4IW5D9ePCXA2C+H+Lhn6vESBb3aWarmDWoYUse/zJbSeBQ39Y0ped
         0jK4vEugdoWU+lAmEfb8NaboeiQ9coemxDEKa2WbtYFtV8Q71TXRx7StVbPdbV611qAv
         9XGwHE7y63aP8DmEaYs4mJUQltL/JXMXml44K+thSrIiCeqeY8M9WtewOvgJ+5sEtTSH
         bTLWTowp/fGI9Nv9sIb8pI+1086k7hD+efOGQ82JcXG2NlIYofYja4PJ/JxNcMS0hBEj
         bqmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kfv/9FSlbLzfGxHvKEV7DROpdlh0zhjyUxjgEm+XMUs=;
        b=UGSJC2nWslFNyBqERuWCbCocSuUql0ah/28Lb51ts5cZzAjbV8KxiOTXI5N/WKIm1F
         TOkmdGq9qJp72MIWRzE+cNc8Fg/0SYE/nMyRkFHgaHUMkZS5KhNdWGndplpJSUYlk5K6
         mRrpDnndY5bBjeUIjZb4hIhu68sojWQM7bN1P1jRTL5dpkiy2cf7i8IfIAo+Swun9Cpk
         +lEp/cgoxh/Aeopj3wz2tgOCiqbm0V0v3XbCkgs1coZ7hE5J/LsORKPesp2Q8u1rZB/7
         4IVvUO/aaIMewXkB53p+GQCb5UjMmq0rbtYTbY+8omlBZpgNOs8Y/KzKlBjwUK+s1T4C
         f6Nw==
X-Gm-Message-State: AOAM5300cegzLCg0jbw3iNGrrAn3whV/0xw5B3207OPVMZGWzvuCHSqa
        C8mF8MktFqa/UPnMnRCJE9fOpqQMo0gDkcqUlUOB3Q==
X-Google-Smtp-Source: ABdhPJy0PvjjI0rN49+9uygFrL+LdtdHi1DdOpbJJHdVvpT3nHHciEV6eiCz5S8ECH+mlI8qe4tK3hpKQ04e7trKGG8=
X-Received: by 2002:a25:94a:0:b0:615:7cf4:e2cd with SMTP id
 u10-20020a25094a000000b006157cf4e2cdmr24169543ybm.227.1647885373431; Mon, 21
 Mar 2022 10:56:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220321002638.379672-1-mizhang@google.com> <20220321002638.379672-4-mizhang@google.com>
In-Reply-To: <20220321002638.379672-4-mizhang@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 21 Mar 2022 10:56:02 -0700
Message-ID: <CANgfPd_CexHH-QDs899RdEpAO=xGnSfdf80FZzOsum5oYEPCMw@mail.gmail.com>
Subject: Re: [PATCH 3/4] KVM: x86/mmu: explicitly check nx_hugepage in disallowed_hugepage_adjust()
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
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
> not consider other usage case (such as dirty logging). Moreover, existing
> code assumes that a present PMD or PUD indicates that there exist 'smaller
> SPTEs' under the paging structure. This assumption may no be true if
> consider the zapping leafs only behavior in MMU.
>
> Missing the check causes KVM incorrectly regards the faulting page as a NX
> huge page and refuse to map it at desired level. And this leads to back
> performance in shadow mmu and potentiall TDP mmu.
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

This comment is relevant to Google's internal demand paging scheme,
but isn't really relevant to UFFD demand paging.
Still, as demonstrated by the next commit, this is important for dirty
loggin, so I'd suggest updating this comment to refer to that instead.


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

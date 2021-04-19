Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40B0364A72
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 21:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241576AbhDSTVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 15:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239503AbhDSTVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 15:21:35 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F74C06174A
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 12:21:05 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id v123so29163192ioe.10
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 12:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jXjjoWt46Jw4aYJCJQMswNRgoJcTtm7mXok8hN8cVH4=;
        b=LBc5ghnUtNA4sLNOF5O3uvKop9WrGL+xQVnrKdZ8+XbH7Xs2yahScji+toDvMDZY+F
         V0+g2AEeEDt6HgyR6Gk0dtFT+7Z/C5CoKr/+rv0qAo5G2Lzd7AY2S3RdlgWXuAJontG4
         Ndfupmi9oqSIgFlkJatmLRpZhX0PYrGzQP/IMIg0nOawSCojyPepe2tjJWbm84jneUqb
         aCVKNB5dfTbUfqlILEhnNHIUyz3fiScJsiTeNHZLK60LBPWb6E10ro4yeaMar9DyyQWS
         Sp5fLpappMul2poyk5T/G5xEyhMHAcoBv6/UiX6YHgVsPPXy7xwzWgM+90W9k8TfJSVh
         rB9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jXjjoWt46Jw4aYJCJQMswNRgoJcTtm7mXok8hN8cVH4=;
        b=Fg+DcPRhV309AQImbrxKuoVNFIlGmJH+p6K3uVWt6oxWUxdxpzSYF1VjMh7+I3psGM
         J86b2033VbmULQvhr0fB3liLgbZ1LYVWJ7pI/3L84CWxksgOGvLIVVQSnFhT+lyVXcTt
         RAHOB0qOqI+SB7AWeX+ewLfEzbO8pr6soZs5L9PRRvL7DOdcIdzB4voafh9/7TBat0zP
         z77v8m2wokAHvgEgyeuwuGdh6zBqLvowbX5bRL7GrGo0/VJjfAXgXBpzltS+YamJGh6I
         7pEV6NH3itGJqHUwNG2/aWiemejTRZ8nnMIeY2r+vUX9oB8D7fQb4nR/lNM2FO2/KwyW
         qaWg==
X-Gm-Message-State: AOAM530gSLJpf0gwlJpy/qAHiPg1KC/kD0Ltu6MpDgUVeEsRfL6oyTVL
        G8o/q2pTWtxC57l2ziYny5hx6Gq0FiQHQ/f42qW07Q==
X-Google-Smtp-Source: ABdhPJy+m5wNyx2xyn35TIHSejk2E2jy98q8+flIf1+I1QE2+JbjJoAcojKs79C0HMMRo4DcNuPu2rzYOKuLgA08bFs=
X-Received: by 2002:a5d:81c8:: with SMTP id t8mr15837366iol.19.1618860064760;
 Mon, 19 Apr 2021 12:21:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210416082511.2856-1-zhukeqian1@huawei.com> <20210416082511.2856-3-zhukeqian1@huawei.com>
In-Reply-To: <20210416082511.2856-3-zhukeqian1@huawei.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 19 Apr 2021 12:20:53 -0700
Message-ID: <CANgfPd_WzX6Fm7BiMoBoehuLL8tjh4WEqehUhF8biPyL8vS4XQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/2] KVM: x86: Not wr-protect huge page with
 init_all_set dirty log
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        wanghaibin.wang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 16, 2021 at 1:25 AM Keqian Zhu <zhukeqian1@huawei.com> wrote:
>
> Currently during start dirty logging, if we're with init-all-set,
> we write protect huge pages and leave normal pages untouched, for
> that we can enable dirty logging for these pages lazily.
>
> Actually enable dirty logging lazily for huge pages is feasible
> too, which not only reduces the time of start dirty logging, also
> greatly reduces side-effect on guest when there is high dirty rate.
>
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 48 ++++++++++++++++++++++++++++++++++++++----
>  arch/x86/kvm/x86.c     | 37 +++++++++-----------------------
>  2 files changed, 54 insertions(+), 31 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 2ce5bc2ea46d..98fa25172b9a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1188,8 +1188,7 @@ static bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>   * @gfn_offset: start of the BITS_PER_LONG pages we care about
>   * @mask: indicates which pages we should protect
>   *
> - * Used when we do not need to care about huge page mappings: e.g. during dirty
> - * logging we do not have any such mappings.
> + * Used when we do not need to care about huge page mappings.
>   */
>  static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>                                      struct kvm_memory_slot *slot,
> @@ -1246,13 +1245,54 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>   * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
>   * enable dirty logging for them.
>   *
> - * Used when we do not need to care about huge page mappings: e.g. during dirty
> - * logging we do not have any such mappings.
> + * We need to care about huge page mappings: e.g. during dirty logging we may
> + * have any such mappings.
>   */
>  void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>                                 struct kvm_memory_slot *slot,
>                                 gfn_t gfn_offset, unsigned long mask)
>  {
> +       gfn_t start, end;
> +
> +       /*
> +        * Huge pages are NOT write protected when we start dirty log with
> +        * init-all-set, so we must write protect them at here.
> +        *
> +        * The gfn_offset is guaranteed to be aligned to 64, but the base_gfn
> +        * of memslot has no such restriction, so the range can cross two large
> +        * pages.
> +        */
> +       if (kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> +               start = slot->base_gfn + gfn_offset + __ffs(mask);
> +               end = slot->base_gfn + gfn_offset + __fls(mask);
> +               kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
> +
> +               /* Cross two large pages? */
> +               if (ALIGN(start << PAGE_SHIFT, PMD_SIZE) !=
> +                   ALIGN(end << PAGE_SHIFT, PMD_SIZE))
> +                       kvm_mmu_slot_gfn_write_protect(kvm, slot, end,
> +                                                      PG_LEVEL_2M);
> +       }
> +
> +       /*
> +        * RFC:
> +        *
> +        * 1. I don't return early when kvm_mmu_slot_gfn_write_protect() returns
> +        * true, because I am not very clear about the relationship between
> +        * legacy mmu and tdp mmu. AFAICS, the code logic is NOT an if/else
> +        * manner.
> +        *
> +        * The kvm_mmu_slot_gfn_write_protect() returns true when we hit a
> +        * writable large page mapping in legacy mmu mapping or tdp mmu mapping.
> +        * Do we still have normal mapping in that case? (e.g. We have large
> +        * mapping in legacy mmu and normal mapping in tdp mmu).

Right, we can't return early because the two MMUs could map the page
in different ways, but each MMU could also map the page in multiple
ways independently.
For example, if the legacy MMU was being used and we were running a
nested VM, a page could be mapped 2M in EPT01 and 4K in EPT02, so we'd
still need kvm_mmu_slot_gfn_write_protect  calls for both levels.
I don't think there's a case where we can return early here with the
information that the first calls to kvm_mmu_slot_gfn_write_protect
access.

> +        *
> +        * 2. kvm_mmu_slot_gfn_write_protect() doesn't tell us whether the large
> +        * page mapping exist. If it exists but is clean, we can return early.
> +        * However, we have to do invasive change.

What do you mean by invasive change?

> +        */
> +
> +       /* Then we can handle the PT level pages */
>         if (kvm_x86_ops.cpu_dirty_log_size)
>                 kvm_mmu_clear_dirty_pt_masked(kvm, slot, gfn_offset, mask);
>         else
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eca63625aee4..dfd676ffa7da 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10888,36 +10888,19 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>                  */
>                 kvm_mmu_zap_collapsible_sptes(kvm, new);
>         } else {
> -               /* By default, write-protect everything to log writes. */
> -               int level = PG_LEVEL_4K;
> +               /*
> +                * If we're with initial-all-set, we don't need to write protect
> +                * any page because they're reported as dirty already.
> +                */
> +               if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> +                       return;
>
>                 if (kvm_x86_ops.cpu_dirty_log_size) {
> -                       /*
> -                        * Clear all dirty bits, unless pages are treated as
> -                        * dirty from the get-go.
> -                        */
> -                       if (!kvm_dirty_log_manual_protect_and_init_set(kvm))
> -                               kvm_mmu_slot_leaf_clear_dirty(kvm, new);
> -
> -                       /*
> -                        * Write-protect large pages on write so that dirty
> -                        * logging happens at 4k granularity.  No need to
> -                        * write-protect small SPTEs since write accesses are
> -                        * logged by the CPU via dirty bits.
> -                        */
> -                       level = PG_LEVEL_2M;
> -               } else if (kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> -                       /*
> -                        * If we're with initial-all-set, we don't need
> -                        * to write protect any small page because
> -                        * they're reported as dirty already.  However
> -                        * we still need to write-protect huge pages
> -                        * so that the page split can happen lazily on
> -                        * the first write to the huge page.
> -                        */
> -                       level = PG_LEVEL_2M;
> +                       kvm_mmu_slot_leaf_clear_dirty(kvm, new);
> +                       kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_2M);
> +               } else {
> +                       kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_4K);
>                 }
> -               kvm_mmu_slot_remove_write_access(kvm, new, level);
>         }
>  }
>
> --
> 2.23.0
>

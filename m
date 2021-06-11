Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABAC3A4B8D
	for <lists+kvm@lfdr.de>; Sat, 12 Jun 2021 02:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhFLACH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 20:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhFLACG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 20:02:06 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6925C061574
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 16:59:54 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id p17so10982548lfc.6
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 16:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ytt5xYKl94zIIkqy42AXMp1VMwXPiefUtmJxA2Rtf8k=;
        b=vAHZqwb45wlOuFw3DzujMES7THPL2YCNiah5vTHw+w28ZteYZAIUxeK2HAyO8NF9XG
         rX0ktOv9gXBdVxGZQEIcmCuUlYkid98c9hjyJhV4/U2yz59Hj6EAzFhszX9R0bMFKbuL
         0qrabF7vX6BsRZK8av/rKOEXELgCynVL9axysLKQumzFdMsNP7OwIbAJqxB4qaMG+YYW
         FWOwlYNs6avpJ9tnZ/5UuIDb1MAd4L1gNh/Do0FpoktP9ElFqzFH396tcsxpSxzCp2mX
         h89dRXNmIFm+uNwVZ3orJdYeKCBOKddrOT2cn/IoIWxwdudy0nSM0VRufGUl/RUPAz7c
         tF4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ytt5xYKl94zIIkqy42AXMp1VMwXPiefUtmJxA2Rtf8k=;
        b=G0dy2sX+Y/m2jzURV7LTo9G/Jh+JQV9aUHTcZx71zZxs1ZVgULGaWUFsAXu5VwbQK/
         n26YCQCA+yuzEafFN1CGPY6Y95ux/Bj+Jk+ZFvq9ae/8QjufCXpSQfrMWrR1w8IJZcyo
         IlXd8KgsZBUn15eB25tqJyYbRFou/NsufyqRGH3+qNGN2hOzHVkL+fOySpPTeg+jtq0J
         ZJbm/Xv44CgSyQs4C4QmqNAwFHk4Ag+mSsmQbrRw2oW7DNrg/X4DyRXFwOp5M5MtohLv
         aodClLVIIAglMbXk+M0ZEPb5aoeiQkexh4DPArrFgIdecAUO8BQAk+2VLY4lLwu+Q7xX
         JZFg==
X-Gm-Message-State: AOAM531HLRaVQj8swiwOsLOiFkXmHPvSwOG+gXr+EhMFFdc2PcXAWymD
        bvqQgyqwYtxFh2U2WjcRHxPH71/35b6nSm6bFRvDQpA/z2xM2Q==
X-Google-Smtp-Source: ABdhPJyVGctbUsfaQfcIBG8AjLSG02qFhtXBGqXqT5h2Tx8E8j6+TEUlvZkI3Qr5sMDXJryQ18DakqRnJk4JruDF83s=
X-Received: by 2002:a05:6512:3f8d:: with SMTP id x13mr4309012lfa.278.1623455992491;
 Fri, 11 Jun 2021 16:59:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210611235701.3941724-1-dmatlack@google.com> <20210611235701.3941724-7-dmatlack@google.com>
In-Reply-To: <20210611235701.3941724-7-dmatlack@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 11 Jun 2021 16:59:26 -0700
Message-ID: <CALzav=embwx9PoZrMSS3XkQsFjnAu4UyG8VBY=3yj8uqzKBgRg@mail.gmail.com>
Subject: Re: [PATCH 6/8] KVM: x86/mmu: fast_page_fault support for the TDP MMU
To:     kvm list <kvm@vger.kernel.org>
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021 at 4:57 PM David Matlack <dmatlack@google.com> wrote:
>
> This commit enables the fast_page_fault handler to work when the TDP MMU
> is enabled by leveraging the new walk_shadow_page_lockless* API to
> collect page walks independent of the TDP MMU.
>
> fast_page_fault was already using
> walk_shadow_page_lockless_{begin,end}(), we just have to change the
> actual walk to use walk_shadow_page_lockless() which does the right
> thing if the TDP MMU is in use.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Adding this feature was suggested by Ben Gardon:

Suggested-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c | 52 +++++++++++++++++-------------------------
>  1 file changed, 21 insertions(+), 31 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 765f5b01768d..5562727c3699 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -657,6 +657,9 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>         local_irq_enable();
>  }
>
> +static bool walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
> +                                     struct shadow_page_walk *walk);
> +
>  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  {
>         int r;
> @@ -2967,14 +2970,9 @@ static bool page_fault_can_be_fast(u32 error_code)
>   * Returns true if the SPTE was fixed successfully. Otherwise,
>   * someone else modified the SPTE from its original value.
>   */
> -static bool
> -fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> -                       u64 *sptep, u64 old_spte, u64 new_spte)
> +static bool fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, gpa_t gpa,
> +                                   u64 *sptep, u64 old_spte, u64 new_spte)
>  {
> -       gfn_t gfn;
> -
> -       WARN_ON(!sp->role.direct);
> -
>         /*
>          * Theoretically we could also set dirty bit (and flush TLB) here in
>          * order to eliminate unnecessary PML logging. See comments in
> @@ -2990,14 +2988,8 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>         if (cmpxchg64(sptep, old_spte, new_spte) != old_spte)
>                 return false;
>
> -       if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
> -               /*
> -                * The gfn of direct spte is stable since it is
> -                * calculated by sp->gfn.
> -                */
> -               gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
> -               kvm_vcpu_mark_page_dirty(vcpu, gfn);
> -       }
> +       if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
> +               kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
>
>         return true;
>  }
> @@ -3019,10 +3011,9 @@ static bool is_access_allowed(u32 fault_err_code, u64 spte)
>   */
>  static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
>  {
> -       struct kvm_shadow_walk_iterator iterator;
> -       struct kvm_mmu_page *sp;
>         int ret = RET_PF_INVALID;
>         u64 spte = 0ull;
> +       u64 *sptep = NULL;
>         uint retry_count = 0;
>
>         if (!page_fault_can_be_fast(error_code))
> @@ -3031,17 +3022,19 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
>         walk_shadow_page_lockless_begin(vcpu);
>
>         do {
> +               struct shadow_page_walk walk;
>                 u64 new_spte;
>
> -               for_each_shadow_entry_lockless(vcpu, gpa, iterator, spte)
> -                       if (!is_shadow_present_pte(spte))
> -                               break;
> +               if (!walk_shadow_page_lockless(vcpu, gpa, &walk))
> +                       break;
> +
> +               spte = walk.sptes[walk.last_level];
> +               sptep = walk.spteps[walk.last_level];
>
>                 if (!is_shadow_present_pte(spte))
>                         break;
>
> -               sp = sptep_to_sp(iterator.sptep);
> -               if (!is_last_spte(spte, sp->role.level))
> +               if (!is_last_spte(spte, walk.last_level))
>                         break;
>
>                 /*
> @@ -3084,7 +3077,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
>                          *
>                          * See the comments in kvm_arch_commit_memory_region().
>                          */
> -                       if (sp->role.level > PG_LEVEL_4K)
> +                       if (walk.last_level > PG_LEVEL_4K)
>                                 break;
>                 }
>
> @@ -3098,8 +3091,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
>                  * since the gfn is not stable for indirect shadow page. See
>                  * Documentation/virt/kvm/locking.rst to get more detail.
>                  */
> -               if (fast_pf_fix_direct_spte(vcpu, sp, iterator.sptep, spte,
> -                                           new_spte)) {
> +               if (fast_pf_fix_direct_spte(vcpu, gpa, sptep, spte, new_spte)) {
>                         ret = RET_PF_FIXED;
>                         break;
>                 }
> @@ -3112,7 +3104,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
>
>         } while (true);
>
> -       trace_fast_page_fault(vcpu, gpa, error_code, iterator.sptep, spte, ret);
> +       trace_fast_page_fault(vcpu, gpa, error_code, sptep, spte, ret);
>         walk_shadow_page_lockless_end(vcpu);
>
>         return ret;
> @@ -3748,11 +3740,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>         if (page_fault_handle_page_track(vcpu, error_code, gfn))
>                 return RET_PF_EMULATE;
>
> -       if (!is_vcpu_using_tdp_mmu(vcpu)) {
> -               r = fast_page_fault(vcpu, gpa, error_code);
> -               if (r != RET_PF_INVALID)
> -                       return r;
> -       }
> +       r = fast_page_fault(vcpu, gpa, error_code);
> +       if (r != RET_PF_INVALID)
> +               return r;
>
>         r = mmu_topup_memory_caches(vcpu, false);
>         if (r)
> --
> 2.32.0.272.g935e593368-goog
>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FAF303092
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 00:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732543AbhAYXxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 18:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732439AbhAYXwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 18:52:01 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4750C061574
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 15:51:20 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id z22so30218807ioh.9
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 15:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nd0bjEbAER/9POSPmPu9O4k2jMAolkMKfCYZRpEWzyk=;
        b=bGs1hw9F0elvPz+BbFoS7xe/EM2an3AAe4zIcqD0BGcx5igessQoOsC/DD/P52xc/5
         hBt+ZqlM/vjuMD2h3imyosWbTCkNMNk7Pltf8g6/b7OE3vxO8nQI8N5Wul9COHEAqG0S
         yzayNaJBcjg0LXu+PIvTebsjETAzNtd4VvKmEIKkQNW6mrrmO1IQLwh9m0A4ITf1FIKW
         s9OFmSfvAAixtM9LGkFpHAkeIaBQ+kVgtVEEuxhq0PZsMJLpJv58Me9UKt0JB5GMmj6K
         k8AK4+j9CO44r6FZMOg+K9L/P9iFpPhJJ93Ap9mFGWZQiHNPgBaYmJWN98ljc4zw/Q5J
         wvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nd0bjEbAER/9POSPmPu9O4k2jMAolkMKfCYZRpEWzyk=;
        b=pV9MDos6mz/f/xyoAuPg+dbmBoNa+lYeOmfedkDXGs+br0iCOOkap9N2HSUS3rwSMe
         kQdTC08EWXBF3WZfZEBmV07TUYKdJlznONq7J0eP1OXaAzy2B5zVq/jyIuFUL2x2nqJP
         +t9qn1hmfFLpMrd6vBNojTUWzYQG8VIcUQM3D8dj7q3Q3si5m8IVp8ZevlE0FTEgFbTm
         dhjcmWD4zSbO95Vdo9PnXj7hB0rwJn6Z+33oc0Khu1LyivS8qcvzsJPp6D1SUSrWbn4e
         jiz/RrhhmQeo9QWtGI6RKYBZ4fUoOLD0nRA4pyK7YHGLCSLuRTJvO6X8YXWugKZOkO4+
         mLLw==
X-Gm-Message-State: AOAM533erPK+0DEvosrtWCxUYsDVnN9LRg+7Jssl/WNjPDWk7kJRdH5l
        NihMkjH1oQnRrY9isEwk9SfjwvWFxGyB9wstp6Mhrg==
X-Google-Smtp-Source: ABdhPJxf+qIzKF7XhAxLeHKncjRgkuZNOfh8DP6LjU66+3S+g62Ik7vptGQ+k/H+PJtulr0uEApYV7CWp6qfJPNoEHo=
X-Received: by 2002:a02:ca17:: with SMTP id i23mr2640812jak.25.1611618680005;
 Mon, 25 Jan 2021 15:51:20 -0800 (PST)
MIME-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com> <20210112181041.356734-7-bgardon@google.com>
 <YAiJrsyC1KSTKycg@google.com>
In-Reply-To: <YAiJrsyC1KSTKycg@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 25 Jan 2021 15:51:08 -0800
Message-ID: <CANgfPd9Ef=GfcpbB118=h4ksHJ+nOB=YxyJ+6t6GWFKAP4yt8w@mail.gmail.com>
Subject: Re: [PATCH 06/24] kvm: x86/mmu: Skip no-op changes in TDP MMU functions
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 20, 2021 at 11:51 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jan 12, 2021, Ben Gardon wrote:
> > Skip setting SPTEs if no change is expected.
> >
> > Reviewed-by: Peter Feiner <pfeiner@google.com>
> >
> Nit on all of these, can you remove the extra newline between the Reviewed-by
> and SOB?

Yeah, that line is annoying. I'll make sure it's not there on future patches.

>
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 1987da0da66e..2650fa9fe066 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -882,6 +882,9 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> >                   !is_last_spte(iter.old_spte, iter.level))
> >                       continue;
> >
> > +             if (!(iter.old_spte & PT_WRITABLE_MASK))
>
> Include the new check with the existing if statement?  I think it makes sense to
> group all the checks on old_spte.

I agree that' s cleaner. I'll group the checks in the next patch set version.

>
> > +                     continue;
> > +
> >               new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
> >
> >               tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
> > @@ -1079,6 +1082,9 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> >               if (!is_shadow_present_pte(iter.old_spte))
> >                       continue;
> >
> > +             if (iter.old_spte & shadow_dirty_mask)
>
> Same comment here.
>
> > +                     continue;
> > +
>
> Unrelated to this patch, but it got me looking at the code: shouldn't
> clear_dirty_pt_masked() clear the bit in @mask before checking whether or not
> the spte needs to be modified?  That way the early break kicks in after sptes
> are checked, not necessarily written.  E.g.
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 2650fa9fe066..d8eeae910cbf 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1010,21 +1010,21 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
>                     !(mask & (1UL << (iter.gfn - gfn))))
>                         continue;
>
> -               if (wrprot || spte_ad_need_write_protect(iter.old_spte)) {
> -                       if (is_writable_pte(iter.old_spte))
> -                               new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
> -                       else
> -                               continue;
> -               } else {
> -                       if (iter.old_spte & shadow_dirty_mask)
> -                               new_spte = iter.old_spte & ~shadow_dirty_mask;
> -                       else
> -                               continue;
> -               }
> -
> -               tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
> -
>                 mask &= ~(1UL << (iter.gfn - gfn));
> +
> +               if (wrprot || spte_ad_need_write_protect(iter.old_spte)) {
> +                       if (is_writable_pte(iter.old_spte))
> +                               new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
> +                       else
> +                               continue;
> +               } else {
> +                       if (iter.old_spte & shadow_dirty_mask)
> +                               new_spte = iter.old_spte & ~shadow_dirty_mask;
> +                       else
> +                               continue;
> +               }
> +
> +               tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
>         }
>  }
>

Great point, that doesn't work as intended at all. I'll adopt your
proposed fix and include it in a patch after this one in the next
version of the series.

>
> >               new_spte = iter.old_spte | shadow_dirty_mask;
> >
> >               tdp_mmu_set_spte(kvm, &iter, new_spte);
> > --
> > 2.30.0.284.gd98b1dd5eaa7-goog
> >

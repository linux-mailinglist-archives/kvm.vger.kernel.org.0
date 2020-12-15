Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CCF2DA7A6
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 06:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgLOFYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 00:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgLOFYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 00:24:23 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA5AC06179C;
        Mon, 14 Dec 2020 21:14:37 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id p5so18041152iln.8;
        Mon, 14 Dec 2020 21:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OMeW5OwFJaFbzmMhVRdKenrFpNfjIBXNuOkkzI7axiY=;
        b=uhLL56ouklyItc4++bYAHnJJzS7KZGkHZ0Zl/+O7pvReKfc+axcaoLGP2yN88FQgh1
         BWfwwtYSBGbXMofydLQ+/H/wDYsD4M8Xt7OH+kHRWV7/wq3/PnRdOgHOFY1Nr1twvi+M
         FBBk/9CrLwRHpAwVYxI3Nus3eZ+wWXUW8tPOgVqoO2kP443UCKu9hcimp1+8wvlcV+3s
         un4sezeOlDtIy2KtdZ2daAuEDgKxab7uOFuDMNI/IPMFiFB9uxJ2dUyeWk9vAkSBQuDN
         dMhQj1+Ome3JFwCIy9JFE5cyLf4PFNqARa4UbJrfRlpfLCJaxbC2Z1Blp/5PnGepXjF6
         J67g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OMeW5OwFJaFbzmMhVRdKenrFpNfjIBXNuOkkzI7axiY=;
        b=tmMbBb4gvxyLLsRoC+haWGN+I50E/lQo3QgtaOSD8rBq5ZGloXFFQqrVCq5W0Fb2wo
         q+fSZBYg4KtivPxpQ8OKeTrEES/8TuWy48bBZFrNxiVrJa+D7YcnoHWUGzLyCzxEGkPh
         EfXW8WLg9I/NEcYrQfOwszF6bOss/ROqNCLLpUI6mlKcVytXOLUCoMtrDhxayKMZnvIe
         1uJJbXfSxnSXClvQYiMXYAhCxxN94VmyJWKGaaJmTO/Wf3bJg3XdS2BVbXCFNgQ0gtOO
         jZQR9rf89qEA2NKJI9EY7jsdW4WNS0Uc1rI3mKhbhEGlDoZMh2FD9evSBzROjixvIpXV
         71cg==
X-Gm-Message-State: AOAM531Yz5KsjsoLPBESpokXewAPq/MY5qvZajzB5qXbWr5PuuLHO/TO
        IoltAooXm7uMppnz4uFwuPS5aJ605gmxb+mZNMwX0dtGjhB1bg==
X-Google-Smtp-Source: ABdhPJyr7okVjyaNDLT3Yki4p2NdKxNVTrapTe1ew+D/vFTUlyiFudWJ2zBIZlhsnwk29eA5cWteKGxv0xeOWGwakA4=
X-Received: by 2002:a92:7789:: with SMTP id s131mr39728085ilc.52.1608009276995;
 Mon, 14 Dec 2020 21:14:36 -0800 (PST)
MIME-Version: 1.0
References: <20201213044913.15137-1-jiangshanlai@gmail.com> <X9ee7RzW+Dhv1aoW@google.com>
In-Reply-To: <X9ee7RzW+Dhv1aoW@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 15 Dec 2020 13:14:25 +0800
Message-ID: <CAJhGHyAzGwpXN2+cdQE=xhMP+Lm_9grvm_HUi7NfypOGcySxrg@mail.gmail.com>
Subject: Re: [PATCH] kvm: don't lose the higher 32 bits of tlbs_dirty
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 15, 2020 at 1:20 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Sun, Dec 13, 2020, Lai Jiangshan wrote:
> > From: Lai Jiangshan <laijs@linux.alibaba.com>
> >
> > In kvm_mmu_notifier_invalidate_range_start(), tlbs_dirty is used as:
> >       need_tlb_flush |= kvm->tlbs_dirty;
> > with need_tlb_flush's type being int and tlbs_dirty's type being long.
> >
> > It means that tlbs_dirty is always used as int and the higher 32 bits
> > is useless.
>
> It's probably worth noting in the changelog that it's _extremely_ unlikely this
> bug can cause problems in practice.  It would require encountering tlbs_dirty
> on a 4 billion count boundary, and KVM would need to be using shadow paging or
> be running a nested guest.

You are right, I don't consider it would cause problems in practice, and I
also tried to make tlbs_dirty as "int" and found that I have to change too
many places.

And you are right it is worth noting about it, I'm sorry for neglecting.

>
> > We can just change need_tlb_flush's type to long to
> > make full use of tlbs_dirty.
>
> Hrm, this does solve the problem, but I'm not a fan of continuing to use an
> integer variable as a boolean.  Rather than propagate tlbs_dirty to
> need_tlb_flush, what if this bug fix patch checks tlbs_dirty directly, and then
> a follow up patch converts need_tlb_flush to a bool and removes the unnecessary
> initialization (see below).
>
> E.g. the net result of both patches would be:
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3abcb2ce5b7d..93b6986d3dfc 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -473,7 +473,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>                                         const struct mmu_notifier_range *range)
>  {
>         struct kvm *kvm = mmu_notifier_to_kvm(mn);
> -       int need_tlb_flush = 0, idx;
> +       bool need_tlb_flush;
> +       int idx;
>
>         idx = srcu_read_lock(&kvm->srcu);
>         spin_lock(&kvm->mmu_lock);
> @@ -483,11 +484,10 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>          * count is also read inside the mmu_lock critical section.
>          */
>         kvm->mmu_notifier_count++;
> -       need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
> -                                            range->flags);
> -       need_tlb_flush |= kvm->tlbs_dirty;
> +       need_tlb_flush = !!kvm_unmap_hva_range(kvm, range->start, range->end,
> +                                              range->flags);
>         /* we've to flush the tlb before the pages can be freed */
> -       if (need_tlb_flush)
> +       if (need_tlb_flush || kvm->tlbs_dirty)
>                 kvm_flush_remote_tlbs(kvm);
>
>         spin_unlock(&kvm->mmu_lock);
>
> Cc: stable@vger.kernel.org
> Fixes: a4ee1ca4a36e ("KVM: MMU: delay flush all tlbs on sync_page path")

I searched back, found it and considered adding this fixes tag, but I was
afraid that this cleanup would be backported. Is it worth backporting such
patch which is extremely hardly a problem in practice?

>
> > Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> > ---
> >  virt/kvm/kvm_main.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 2541a17ff1c4..4e519a517e9f 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -470,7 +470,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
> >                                       const struct mmu_notifier_range *range)
> >  {
> >       struct kvm *kvm = mmu_notifier_to_kvm(mn);
> > -     int need_tlb_flush = 0, idx;
> > +     long need_tlb_flush = 0;
>
> need_tlb_flush doesn't need to be initialized here, it's explicitly set via the
> call to kvm_unmap_hva_range().
>
> > +     int idx;
> >
> >       idx = srcu_read_lock(&kvm->srcu);
> >       spin_lock(&kvm->mmu_lock);
> > --
> > 2.19.1.6.gb485710b
> >

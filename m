Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FC937AE34
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 20:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhEKSS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 14:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbhEKSS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 14:18:27 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F67C061574
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 11:17:21 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id h6so17970544ila.7
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 11:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vyc4dubnSLD+2BW6PH5UxSFi8txm49CBtKkbTHFdSjc=;
        b=jQCVdIe9pgUV9koKXqaLjKWuIiMn1YNXIXTPdThrhRpk6e34GBJjPxJN9uMPajlmzN
         ZD7usNNeDjrGfq0yOPFxxTgRyRzcchcB4Z9tTo5GQj4ayixk1+x09iCZk4rGjDIbInAz
         kHL0bE03YePZNAJbRcRJEoQSBObgx62vHHqhh1JRfAgzi5ob0T5bEP4VSnxKPWKRgeuP
         P77IKBOh5RYA4ILQny03ShkO38Gl+18JHF/T3BFoTfXL3igPNsKDnVhRGGzXJvBMjN+f
         A//hOUXmPr1FlwzLJiR8XIDPJ948gVdA2qk4c7My1JA/MQ+V8TplWjmKanv4LtPVInU6
         QCvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vyc4dubnSLD+2BW6PH5UxSFi8txm49CBtKkbTHFdSjc=;
        b=PPpryKWZUYC3hhRyEpzY4OvRTUTskPDhFSKI1Q6y1YM871EXQCIHKLqhtCudK7Gvmt
         Cd6UMrqjepZT0LSa26fnceS8nLaV35ZbE3G6b04+Y/i8Ow5k3f7nkd/J72/nul59aivD
         pYWSfyA4K5aUAIqTWoR6eUsypXDuihQ7n7YB9hafuPcJA5OY/dGD7yOP58QvAwbzOIj9
         PvBpgOq5m3BBMl4gI/uw0VDg3JGVAx1Ed8fro67mmpCIS40dtFvyntVpurViwjuRgLP1
         dylpAHTVZyyT7Kr7h81C6eOj4a56AH0JGy0fA7wCprmJYouZOJFGPvuhV2A4vxYDDAZS
         Coow==
X-Gm-Message-State: AOAM532z6oycDtX4z8z0lBSTATBdNVepqRuPm1+6lm+7gcNQDNSaPZ1Z
        jkFXBIsl2ythVV5taB7SEOYe5CmU3n6CSc7EaxYUYcBeBxFAUBlW
X-Google-Smtp-Source: ABdhPJzDRj+2yh+TiNZncGImnXQaKcIW3y3ODWt9QgJlNO06MKiYKAGTwlrWpUAteugvIGCUx/SjYnA8jdNl7+se1SM=
X-Received: by 2002:a05:6e02:dca:: with SMTP id l10mr27474797ilj.203.1620757040285;
 Tue, 11 May 2021 11:17:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210511171610.170160-1-bgardon@google.com> <20210511171610.170160-3-bgardon@google.com>
 <YJrFOXW3mM3WjGT5@google.com>
In-Reply-To: <YJrFOXW3mM3WjGT5@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 11 May 2021 11:17:09 -0700
Message-ID: <CANgfPd9ekAidRzAWi-i=7h0pUpoHADSFJdAB5AWAzwm_Uk3dSA@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] KVM: x86/mmu: Factor out allocating memslot rmap
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 10:56 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, May 11, 2021, Ben Gardon wrote:
> > Small refactor to facilitate allocating rmaps for all memslots at once.
> >
> > No functional change expected.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/x86.c | 39 ++++++++++++++++++++++++++++++---------
> >  1 file changed, 30 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 1e1f4f31e586..cc0440b5b35d 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10911,10 +10911,35 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> >       kvm_page_track_free_memslot(slot);
> >  }
> >
> > +static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
> > +                           unsigned long npages)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
> > +             int lpages;
> > +             int level = i + 1;
> > +
> > +             lpages = gfn_to_index(slot->base_gfn + npages - 1,
> > +                                   slot->base_gfn, level) + 1;
>
> Might as well assign lpages at its declaration, i.e.
>
>                 int lpages = gfn_to_index(slot->base_gfn + npages - 1,
>                                           slot->base_gfn, level) + 1;

I'll do this if I end up sending out a v5.

> > +
> > +             slot->arch.rmap[i] =
> > +                     kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
> > +                              GFP_KERNEL_ACCOUNT);
>
> Eh, I don't think avoiding a 3 char overrun is worth splitting across three lines.
> E.g. this is perfectly readable
>
>                 slot->arch.rmap[i] = kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
>                                               GFP_KERNEL_ACCOUNT);
>
> Alternatively, the rmap size could be captured in a local var, e.g.
>
>         const int sz = sizeof(*slot->arch.rmap[0]);
>
>         ...
>
>                 slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);

I like this suggestion. Much nicer. Will incorporate if I send a v5.

>                 if (!slot->arch.rmap[i]) {
>                         memslot_rmap_free(slot);
>                         return -ENOMEM;
>                 }
>
> > +             if (!slot->arch.rmap[i]) {
> > +                     memslot_rmap_free(slot);
> > +                     return -ENOMEM;
>
> Reaaaally getting into nitpicks, what do you think about changing this to a goto
> with the error handling at the bottom?  Obviously not necessary by any means,
> but for me it makes it easier to see that all rmaps are freed on failure.  My
> eyes skipped over that on the first read through.  E.g.
>
>                 if (!slot_arch.rmap[i])
>                         goto err;
>         }
>
>         return 0;
>
> err:
>         memslot_rmap_free(slot);
>         return -ENOMEM;
>

Lol, I had a goto in v3, but David Hildenbrand suggested removing it
and putting the free in the loop. I think I like it more this way too.

>
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> >  static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
> >                                     unsigned long npages)
> >  {
> >       int i;
> > +     int r;
>
> Personal preference, for short declarations like this I like putting 'em on a
> single line.
>
> >       /*
> >        * Clear out the previous array pointers for the KVM_MR_MOVE case.  The
> > @@ -10923,7 +10948,11 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
> >        */
> >       memset(&slot->arch, 0, sizeof(slot->arch));
> >
> > -     for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
> > +     r = memslot_rmap_alloc(slot, npages);
> > +     if (r)
> > +             return r;
> > +
> > +     for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
> >               struct kvm_lpage_info *linfo;
> >               unsigned long ugfn;
> >               int lpages;
> > @@ -10932,14 +10961,6 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
> >               lpages = gfn_to_index(slot->base_gfn + npages - 1,
> >                                     slot->base_gfn, level) + 1;
> >
> > -             slot->arch.rmap[i] =
> > -                     kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
> > -                              GFP_KERNEL_ACCOUNT);
> > -             if (!slot->arch.rmap[i])
> > -                     goto out_free;
> > -             if (i == 0)
> > -                     continue;
> > -
> >               linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
> >               if (!linfo)
> >                       goto out_free;
> > --
> > 2.31.1.607.g51e8a6a459-goog
> >

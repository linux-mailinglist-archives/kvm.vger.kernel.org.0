Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4A73793C3
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 18:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhEJQad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 12:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbhEJQaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 12:30:30 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D6DC06175F
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 09:29:25 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id z1so6722098ils.0
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 09:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BkfDg/7imdX1kS2mno+cgyMshYAEJnF0DUnywtzmZC8=;
        b=Rg5r5I5Swy6LR6oGgCyRRNQ8y01tbtyWS/ZLufuZK3tbzxJ5wWzlX2/SwDmdH/ccVi
         cVw5pHQVsCbYHSzxZeYs5uwqUqsRigm4/cOYPKBqY3h79/HBz3EWLs8VfZzEn+ThByUG
         2P/3HC8SuxBXiLHgYddPZBxwX9EddzBn+qSV/pgFqHETLruZBLbPsTy5kQBoHz/6CzcV
         cJ7YJuAYXBgkzPLIG3tJtErmtxYZgPjhRtPmpZYiuPqstGAFVoNvFF691USD7hx8lOAG
         GHkJd5UtmKqKHvUjsd2aQbUQAA2/pYnW4I95ex+21j0gzA59fpwYUqoK/qR5FXoxxVSm
         rRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BkfDg/7imdX1kS2mno+cgyMshYAEJnF0DUnywtzmZC8=;
        b=jrYneULKhpGLHB1I4yEHymss7vqy3iHMs0/tGnUb0MO4YvWnWMw586Q82yEgTVgqsV
         drXQyaZ+wx0veczx8t2wGKNvfpXPenccu9IWgINXlcKqJBi7ed8BQQEc9FBHe+2q3E85
         N8SW2nxy65NABV4UfP5adGhZK03R2ke7Hj2xZGS+sDzcQwXMY6VHhs6yTUxacUe2QT5X
         Yy75eNWpPbvy7MnLPhyUk5rGLClKAHt455Z4AdqZmrabPJI12CI5tE3wC0fQBtx1dyLx
         i1ARdRq10F9h0kZ3tBVdq+i621C60tX4yJn2c2lZbVoFbVroOMi1dQnKroUV4uOGc0lY
         6hfw==
X-Gm-Message-State: AOAM531Qtif2CXEIeMuk6kleRNzIpr6gTCRXN6ssnSe4eXStMgEoJmHK
        MNPXaNnf4r6GgOII2najcNHLmnYvKZ5jtNfTFJ89QQ==
X-Google-Smtp-Source: ABdhPJwiyFQV/afbXqOHGcblLT+JVG4Ot3xt71Vs8QQ375y0uMrhlKjEDTu+WwL6DR5Axajl25WCuoagaF2xqeMIeAk=
X-Received: by 2002:a05:6e02:96d:: with SMTP id q13mr9155411ilt.285.1620664165138;
 Mon, 10 May 2021 09:29:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210506184241.618958-1-bgardon@google.com> <20210506184241.618958-3-bgardon@google.com>
 <97d085a0-185d-2546-f32e-ea1c55579ba0@redhat.com>
In-Reply-To: <97d085a0-185d-2546-f32e-ea1c55579ba0@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 10 May 2021 09:29:14 -0700
Message-ID: <CANgfPd9GMZgfHxkgGxERrqLwP2aHYMK_yxyrDjCfjao3fvf7oQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] KVM: x86/mmu: Factor out allocating memslot rmap
To:     David Hildenbrand <david@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 7, 2021 at 12:47 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 06.05.21 20:42, Ben Gardon wrote:
> > Small refactor to facilitate allocating rmaps for all memslots at once.
> >
> > No functional change expected.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >   arch/x86/kvm/x86.c | 41 ++++++++++++++++++++++++++++++++---------
> >   1 file changed, 32 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 5bcf07465c47..fc32a7dbe4c4 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10842,10 +10842,37 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> >       kvm_page_track_free_memslot(slot);
> >   }
> >
> > +static int alloc_memslot_rmap(struct kvm_memory_slot *slot,
> > +                           unsigned long npages)
>
> I'd have called the functions memslot_rmap_alloc() and memslot_rmap_free()
>
>
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
> > +             int lpages;
> > +             int level = i + 1;
> > +
> > +             lpages = gfn_to_index(slot->base_gfn + npages - 1,
> > +                                   slot->base_gfn, level) + 1;
> > +
> > +             slot->arch.rmap[i] =
> > +                     kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
> > +                              GFP_KERNEL_ACCOUNT);
> > +             if (!slot->arch.rmap[i])
> > +                     goto out_free;
>
> you can just avoid the goto here and do the free_memslot_rmap() right away.

Oh good catch. I'll incorporate your suggestions in v4.

>
> > +     }
> > +
> > +     return 0;
> > +
> > +out_free:
> > +     free_memslot_rmap(slot);
> > +     return -ENOMEM;
> > +}
> > +
> >   static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
> >                                     unsigned long npages)
> >   {
> >       int i;
> > +     int r;
> >
> >       /*
> >        * Clear out the previous array pointers for the KVM_MR_MOVE case.  The
> > @@ -10854,7 +10881,11 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
> >        */
> >       memset(&slot->arch, 0, sizeof(slot->arch));
> >
> > -     for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
> > +     r = alloc_memslot_rmap(slot, npages);
> > +     if (r)
> > +             return r;
> > +
> > +     for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
> >               struct kvm_lpage_info *linfo;
> >               unsigned long ugfn;
> >               int lpages;
> > @@ -10863,14 +10894,6 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
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
> >
>
> apart from that LGTM
>
> --
> Thanks,
>
> David / dhildenb
>

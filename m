Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6048487CFA
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 20:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiAGT0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 14:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiAGT0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 14:26:40 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C76C061574
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 11:26:39 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id w7so5553573plp.13
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 11:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=amlpKrKBz5SWwrvFEWI7fYR1yYkmkc/r7rygGBoobKM=;
        b=ODnfXKWg4J0sSZCL9Uo+7QVVBnGiMdTOzJ9L7YVfIi2mIofBOnEZFAbS6dOLGzoEFr
         lA5AyNVsm1kMs2X3mqzNjaXfQqVOPdH9w46h+VUvgUmjegwmCmEHiUy7YYAWDyaVa7jM
         wmtKzxw8Akahm5Co8kLisonGLCHnllHmz59Bml/PPOXtJF7GHt3/39LKHbw16wdlfGHW
         j1ukkH6ExAAuzPBIWYKLOBRdclUGXlTbghW2yzeTdaHJp9B12rSlLhDGGudIpJbvBYnI
         PINtY+WbFpJCB6+61Z9PMwKqWCQkD+nwBwKsnU1zhtuHLVzv0cKYphsx8tkAAkg2h1q2
         cwZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=amlpKrKBz5SWwrvFEWI7fYR1yYkmkc/r7rygGBoobKM=;
        b=ct6WrooiGSSqfDeqeS03ee9Pfxf7F5mB/Arx5ShVr5Ti38JmUvOGLOO0vmG0TbRmbL
         xHTpR2r4oufkOJHu2JtC9fSn4EhN6A3WaThXdwzbTdenr+vdtS3wlAAR4veRrsh2rYpo
         nXCn8jNpqLkhoY0VUxwaKPYBniCd1wflANAUorO0vsf9//PxJwPh3XbHymp65xtxy3+q
         Hj1ml3SS9Im0stYrCJImCwDxUVXfu/6k1xGW9YHnp5NDZY1IKzGfTKiyi8lbzGWAmyHb
         5A0IJYEVEK59o0o38dW6O9ovvwqZ2gCWimxMIP3k2Jiz4Sgy3eEZr8nNCPstJWM9PGuT
         uerQ==
X-Gm-Message-State: AOAM530tzU7EKBrbUN1K6XqKDtR/EEUctieNgmErkyRrcfCyKdsxszty
        Cgapjz6P+TxJMrUodPpWDL4YkdIGv26FlhyQ5Dw=
X-Google-Smtp-Source: ABdhPJz/axDoBkQbBxfNZI/mDDdtUqKAqTWx9Doa5i5AM9gd/1gckBzJ5ZXtR4HmI/4iYjs++8Dy8FvSqtGxMsO17i4=
X-Received: by 2002:a17:903:1c4:b0:149:45fb:d6f0 with SMTP id
 e4-20020a17090301c400b0014945fbd6f0mr63004518plh.143.1641583599416; Fri, 07
 Jan 2022 11:26:39 -0800 (PST)
MIME-Version: 1.0
References: <20220107082554.32897-1-makvihas@gmail.com> <8886415d-f02d-7451-fa8d-4df340182dbc@redhat.com>
In-Reply-To: <8886415d-f02d-7451-fa8d-4df340182dbc@redhat.com>
From:   Vihas Mak <makvihas@gmail.com>
Date:   Sat, 8 Jan 2022 00:56:28 +0530
Message-ID: <CAH1kMwSNhQMVLany4u+1tOZpa3KFr93OcwJGhnWN66gKWimaZA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: move the can_unsync and prefetch checks outside
 of the loop
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 07, 2022, Sean Christopherson wrote:
>> NAK, this change is functionally wrong.  The checks are inside the loop because
>> the flow fails if and only if there is at least one indirect, valid shadow pages
>> at the target gfn.  The @prefetch check is even more restrictive as it bails if
>> there is at least one indirect, valid, synchronized shadow page.
>> The can_unsync check could be "optimized" to
>>
>>       if (!can_unsync && kvm_gfn_has_indirect_valid_sp())
>>
>> but identifying whether or not there's a valid SP requires walking the list of
>> shadow pages for the gfn, so it's simpler to just handle the check in the loop.
>> And "optimized" in quotes because both checks will be well-predicted single-uop
>> macrofused TEST+Jcc on modern CPUs, whereas walking the list twice would be
>> relatively expensive if there are shadow pages for the gfn.


So this change isn't safe. I will look into the optimization suggested
by Sean. Sorry for this patch.


On Fri, Jan 7, 2022 at 11:46 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 1/7/22 09:25, Vihas Mak wrote:
> > mmu_try_to_unsync_pages() performs !can_unsync check before attempting
> > to unsync any shadow pages.
> > This check is peformed inside the loop right now.
> > It's redundant to perform it every iteration if can_unsync is true, as
> > can_unsync parameter isn't getting updated inside the loop.
> > Move the check outside of the loop.
> >
> > Same is the case with prefetch.
>
> The meaning changes if the loop does not execute at all.  Is this safe?
>
> Paolo
>
> > Signed-off-by: Vihas Mak<makvihas@gmail.com>
> > Cc: Sean Christopherson<seanjc@google.com>
> > Cc: Vitaly Kuznetsov<vkuznets@redhat.com>
> > Cc: Wanpeng Li<wanpengli@tencent.com>
> > Cc: Jim Mattson<jmattson@google.com>
> > Cc: Joerg Roedel<joro@8bytes.org>
> > ---
> >   arch/x86/kvm/mmu/mmu.c | 11 +++++------
> >   1 file changed, 5 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 1d275e9d7..53f4b8b07 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2586,6 +2586,11 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
> >       if (kvm_slot_page_track_is_active(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
> >               return -EPERM;
> >
> > +     if (!can_unsync)
> > +             return -EPERM;
> > +
> > +     if (prefetch)
> > +             return -EEXIST;
> >       /*
> >        * The page is not write-tracked, mark existing shadow pages unsync
> >        * unless KVM is synchronizing an unsync SP (can_unsync = false).  In
> > @@ -2593,15 +2598,9 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
> >        * allowing shadow pages to become unsync (writable by the guest).
> >        */
> >       for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
> > -             if (!can_unsync)
> > -                     return -EPERM;
> > -
> >               if (sp->unsync)
> >                       continue;
> >
> > -             if (prefetch)
> > -                     return -EEXIST;
> > -
>


--
Thanks,
Vihas

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D468758F50F
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 02:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbiHKAJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 20:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiHKAJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 20:09:01 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D167C7E018
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 17:08:59 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id l22so19560807wrz.7
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 17:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=GiOpy66dXeywO19h9rt45rvbmkPz7BgCAuXeglbMw+M=;
        b=FFbshQkWWPkDMoaErINM2TK3+H+qrHQac1mOZUE06AMN9wIcQ/IssiqtweurAp8fyE
         sb9HQBaGxhMF/BPN6+iTFn1Lblr3CdOM768uDe1Jlj8X12b/0hg2s0DItCPn6wFZn3Cd
         0gZfsF5mA+LtwbNcAyHS2b9ct0mU9jrnps4JgOf0cGDgnFy50Pod5btRl5UKacvI+0vA
         NEPtKKL4NBy7a6KuQVAmn5Hs64B6IkadhL25aVB6CNF7HRBJFHbpo5RZwfIGogB/mqbf
         e6T5ot1MP9eCYIvbdALC5DuVAmEnrl224c22WK0bZyXBNvnPYh6AKjmYOrEK9tV8lI67
         pFZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=GiOpy66dXeywO19h9rt45rvbmkPz7BgCAuXeglbMw+M=;
        b=G7xItKorBngvOhPFfgRLhjPIOeQp/BA63yJSrPhWicr7sLWc5bZmnw69kU+dOx8tl+
         2pMZU9nMlxRdHnfgv24tPgGAtxithspaCMMcBex/C44x6LD00tsczfsivTWbCFiU+FIg
         OsKvnqXSW6xZTIWAJC2uuTlJkw6vjBYrQ1qbOoLf53bE2OTr/2l4o0yGM57zlnuvY+Py
         /54S11EKdGA5Gw21/J0ar5rLkJQWjN3TGizU7O+Kw7J76nN1TC+F/GAnAMBG+xOYiXgk
         KTauzlNIlk9lc42W1fx8ASwzKT4oXVdeUr2cCumKLSNGuP2tIcZdifhe3eN8DTN84Rt9
         F8gg==
X-Gm-Message-State: ACgBeo07nlhzsUtw/0itH2I+JmwcpoK+qtooNr3vkPp0EhqbKVYIFXaN
        ScM6+lYGV5TapmVJgYbYJmw1z+JHP+8GMQ9qIIw4oQ==
X-Google-Smtp-Source: AA6agR7H3e0POyQvBc5Et3bJY4VywEAHlMtVH8Spb5H1sNTH6tIT2o5dF2aiabtZgTbdpJo9098M6hTVGP4X6xT5Yx4=
X-Received: by 2002:adf:f846:0:b0:21e:ead2:6a9f with SMTP id
 d6-20020adff846000000b0021eead26a9fmr17549812wrq.209.1660176538239; Wed, 10
 Aug 2022 17:08:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220709011726.1006267-1-aaronlewis@google.com>
 <20220709011726.1006267-2-aaronlewis@google.com> <YuvzHkmU2DsBe6Rj@google.com>
In-Reply-To: <YuvzHkmU2DsBe6Rj@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 11 Aug 2022 00:08:46 +0000
Message-ID: <CAAAPnDGsAnm8q3ZPpUKP0DwKjjDgVGDfJo4kU43Li8F1NZ2G3Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
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

On Thu, Aug 4, 2022 at 4:26 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Sat, Jul 09, 2022, Aaron Lewis wrote:
> > diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> > index fdfd8e06fee6..016713b583bf 100644
> > --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> > @@ -24,6 +24,7 @@ KVM_X86_PMU_OP(set_msr)
> >  KVM_X86_PMU_OP(refresh)
> >  KVM_X86_PMU_OP(init)
> >  KVM_X86_PMU_OP(reset)
> > +KVM_X86_PMU_OP(get_event_mask)
> >  KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
> >  KVM_X86_PMU_OP_OPTIONAL(cleanup)
> >
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 21614807a2cb..2964f3f15fb5 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -522,6 +522,14 @@ struct kvm_pmu_event_filter {
> >  #define KVM_PMU_EVENT_ALLOW 0
> >  #define KVM_PMU_EVENT_DENY 1
> >
> > +#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS (1u << 0)
>
> Is this a "flag" or a "type"?  The usage in code isn't really clear, e.g. there's
> both
>
>         if (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
>
> and
>
>         if (flag == KVM_PMU_EVENT_FLAG_MASKED_EVENTS)

That should be "flag & KVM_PMU_EVENT_FLAG_MASKED_EVENTS".  I'll fix.

>
> > +#define KVM_PMU_EVENT_ENCODE_MASKED_EVENT(select, mask, match, invert) \
> > +             (((select) & 0xfful) | (((select) & 0xf00ul) << 24) | \
> > +             (((mask) & 0xfful) << 24) | \
> > +             (((match) & 0xfful) << 8) | \
> > +             (((invert) & 0x1ul) << 23))
>
> Please add a comment showing the actual layout, this is extremely dense to parse.
> Alternatively, and probably my preference, would be to define this as a union.
> Or maybe both?  E.g. so that userspace can do:
>
>         filter[i].raw = KVM_PMU_EVENT_ENCODE_MASKED_EVENT(...);
>
>         struct kvm_pmu_event_filter_entry {
>                 union {
>                         __u64 raw;
>                         struct {
>                                 __u64 select_lo:8;
>                                 __u64 match:8;
>                                 __u64 rsvd1:7;
>                                 __u64 invert:1;
>                                 __u64 mask:8;
>                                 __u64 select_hi:4;
>                                 __u64 rsvd2:28;
>                         };
>                 }
>         }

Agreed.  I'll add it.  Also, I like the idea of having both the union
and the helper.  They both seem useful.

>
> And that begs the question of whether or not KVM should check those "rsvd" fields.
> IIUC, this layout directly correlates to hardware, and hardware defines many of the
> "rsvd1" bits.  Are those just a don't care?

KVM really should care about the "rsvd" bits for filter events.  I
added a check in kvm_vm_ioctl_set_pmu_event_filter() for it and
documented it in the api docs.  If a "rsvd" bit is set, attempting to
set the filter will return -EINVAL.  This ensures that if we are on
Intel the 'select_hi' bits are clear.  This is important because it
allows us to use AMD's event select mask (AMD64_EVENTSEL_EVENT) in the
compare function when sorting or searching masked events on either
platform instead of having to special case the compare function.  I
also like validating the filter events so we have more predictability
from userspace's data when using it in the kernel.

I just noticed an issue: before doing the bsearch() the key needs to
apply the platform specific mask, i.e.
static_call(kvm_x86_pmu_get_event_mask)(), to ensure IN_TX (bit 32),
IN_TXCP (bit 33), and any other 'select_hi' bits Intel uses in the
future are clear.  I'll fix that in the follow-up.  I think we should
do that for both legacy and masked events, but I appreciate any
changes to the legacy mode will change the ABI, even if it is subtle,
so I can do that as an RFC.

> >
> > +static inline int cmp_safe64(u64 a, u64 b)
> > +{
> >       return (a > b) - (a < b);
> >  }
> >
> > +static int cmp_eventsel_event(const void *pa, const void *pb)
> > +{
> > +     return cmp_safe64(*(u64 *)pa & AMD64_EVENTSEL_EVENT,
> > +                       *(u64 *)pb & AMD64_EVENTSEL_EVENT);
>
> Why is common x86 code reference AMD64 masks?  If "AMD64" here just means the
> x86-64 / AMD64 architecture, i.e. is common to AMD and Intel, a comment to call
> that out would be helpful.

Explained above. I can add a comment.

>
> > +}
> > +
> > +static int cmp_u64(const void *pa, const void *pb)
> > +{
> > +     return cmp_safe64(*(u64 *)pa,
> > +                       *(u64 *)pb);
> > +}
> > +
> > +
> > +static bool is_filtered(struct kvm_pmu_event_filter *filter, u64 eventsel,
> > +                     bool invert)
> > +{
> > +     u64 key = get_event(eventsel);
> > +     u64 *event, *evt;
> > +
> > +     event = bsearch(&key, filter->events, filter->nevents, sizeof(u64),
> > +                     cmp_eventsel_event);
> > +
> > +     if (event) {
> > +             /* Walk the masked events backward looking for a match. */
>
> This isn't a very helpful comment.  It's obvious enough from the code that this
> walks backwards looking for a match, while the next one walks forward.  But it's
> not immediately obvious _why_ that's the behavior.  I eventually realized the code
> is looking for _any_ match, but a comment above this function documenting that
> would would be very helpful.
>
> And doesn't this approach yield somewhat arbitrary behavior?  If there are multiple
> filters for

I'm not sure I follow.  This should be deterministic.  An event is
either filtered or it's not, and while there are multiple cases that
would cause an event to not be filtered there is only one that will
cause it to be filtered.  That case is if a match exists in the filter
list while no corresponding inverted match exists.  Any other case
will not be filtered.  Those are: 1) if there is both a match and an
inverted match in the filter list. 2) there are no matching cases in
the filter list, inverted or non-inverted.  This second case is a
little more interesting because it can happen if no matches exist in
the filter list or if there is only an inverted match.  However,
either way we don't filter it, so it doesn't matter which one it is.

>
> > +             for (evt = event; evt >= filter->events &&
> > +                  get_event(*evt) == get_event(eventsel); evt--)
>
> > +static bool allowed_by_masked_events(struct kvm_pmu_event_filter *filter,
> > +                                  u64 eventsel)
> > +{
> > +     if (is_filtered(filter, eventsel, /*invert=*/false))
>
> Outer if-statement needs curly braces.  But even better would be to do:
>
>         if (is_filter(...) &&
>             !is_filter(...))
>                 return filter->action == KVM_PMU_EVENT_ALLOW;
>
> That said, I have zero idea what the intended logic is, i.e. this needs a verbose
> comment.   Maybe if I was actually familiar with PMU event magic it would be obvious,
> but I won't be the last person that reads this code with only a passing undertsanding
> of PMU events.
>
> Specifically, having an inverted flag _and_ an inverted bit in the event mask is
> confusing.

Maybe if I call it 'exclude' that would be better.  That does seem
like a more appropriate name.  I do think having this will be useful
at times, and in those moments it will allow for a more concise filter
list overall.  I'd really prefer to keep it.

Another option could be to remove KVM_PMU_EVENT_DENY.  I'm not sure
how useful it is.  Maybe there's a use case I'm not thinking of, but I
would think that the first step in building a deny list would be to
include all the undefined event selects + unit masks, which in legacy
mode would more than fill up the filter list.  That said, removing it
would be ABI breaking, so I thought I'd throw it out here.  Of course
there are other tricks to avoid breaking the ABI, but that would leave
the code a bit messier.  Thoughts?

>
> > +             if (!is_filtered(filter, eventsel, /*invert=*/true))
> > +                     return filter->action == KVM_PMU_EVENT_ALLOW;
> > +
> > +     return filter->action == KVM_PMU_EVENT_DENY;
> > +}
> > +

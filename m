Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3FA603765
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 03:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJSBHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 21:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiJSBGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 21:06:52 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9286BDFB64
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 18:06:36 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id a3so26508196wrt.0
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 18:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q2FexSsu+gvaZOh/IYZ31in718UtRM8gD0uGXu8ZvcE=;
        b=SjItn1o0qAm4iChqIoexw9V89Fy62420fnhTYftIGZRCKxoF0LE/vKrEGFYaTZ+G55
         fuo01Zct7N/OGqCNp8pnZkbcIeAL/T8DOLlisZ2wRICIf/iUyJx8Y2JvLSi9U2m5ICGy
         3psmevDyQF/6wybVpsxR8VFTvkM2M6GynFjxBSjnSmK3LQu7eHada3T6a1uRE31voKHG
         DkaW463PWD2z7sp2AcAJkIqAV0oFyBIjUHrorWwAa3rLTic8MaTJrjbv5MQYXS2TgeCG
         wM4qi71ZR7w4PdvP2iWs86/jUNh+zqQsfpqwEvAlsT3Ab5PCfjkAXQxsemo15sau8V12
         OapA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q2FexSsu+gvaZOh/IYZ31in718UtRM8gD0uGXu8ZvcE=;
        b=D0PEezgzyM3h0qhg+P6eRsheDjcUaNSXIB+AJ7xXvy2XX01h3uR3BLzpvcaulXuPp2
         JJODxB5VeZqpZz82VwVxYATNdkdVFfEAfKMTAp/IFLpzmNYesMXwfvnQ90D9qGSjF6su
         /99msi6NxlvSibBmYywEqwGcyv6G3dOoeE0t1aAkDgnJMYb/LIudKsDvv2eoiouQT/A5
         4iotniZcS6Q6Rb3Ryn93axz3DEW+ixLb3csiTDbPLg83IP/Afrsj0xZrKdOEhe/UQ6TL
         fPImJFzbsJx/W4JTO0pyy2UHK7FrEn5GbJFM1qfXIHy5egPaXUHlPNKcsLBNPAiVILkE
         9Z6A==
X-Gm-Message-State: ACrzQf2uwEHh4dgBf1j/1yUvpRjO6HtlgohSHbiUQm5W06HtSkoQ+V5z
        AUoCG0ppQEKarujQOauCTtC1kTaV1a8HcrLNLd43qw==
X-Google-Smtp-Source: AMsMyM7DwpELrO1dodmfZrIPvnYNAJ0MgSZjjJCd5SUZwGoC7NouvhpsDPwZK6FOEwV0p/rr8WHDs2fDyj/KLoki2JM=
X-Received: by 2002:adf:ea85:0:b0:231:faaa:897f with SMTP id
 s5-20020adfea85000000b00231faaa897fmr3278314wrm.209.1666141594243; Tue, 18
 Oct 2022 18:06:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220920174603.302510-1-aaronlewis@google.com>
 <20220920174603.302510-5-aaronlewis@google.com> <Y0Q9ZFGQf1On/Cus@google.com>
 <CAAAPnDGfPZ7k6mHkefhT2tvt6E4cWpEm_QE2Hz=zaVONoXO+xg@mail.gmail.com> <Y02VRyrVu2Fh3ipS@google.com>
In-Reply-To: <Y02VRyrVu2Fh3ipS@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 19 Oct 2022 01:06:22 +0000
Message-ID: <CAAAPnDFqkkEzixJGn39CqrZoAUBo8MbK7j1VorWT0U4cTSwSCQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/7] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > I think setting it up this way makes the data coming from userspace
> > less error prone and easier for them to work with because the lists
> > are being separated for them into include and exclude, and the order
> > they build it in doesn't matter.
>
> The above said, I agree that building the separate lists would be obnoxious for
> userspace.  Userspace would either need to know the length of the "includes" list
> up front, or would have to build the "excludes" list separately and then fold it
> in at the end.  Unless we might run out of bits, lets keep the flag approach for
> the uAPI.
>
> > Isn't having the include list pointer exposed to userspace a little
> > awkward?  As is I'm not sure why userspace would care about it, and
> > when we load the filter we'd essentially ignore it.
>
> I don't follow.  I assume userspace cares about specifying "includes", otherwise
> why provide that functionality?

Yes, userspace cares about includes, but I'm not sure they will care
about the "include" pointer because we would ignore it when loading a
filter (there's no information it provides we can get from the other
fields) and it would be cumbersome for them to use as you pointed out.
So, I was just guessing that they wouldn't use it.

>
> I'm not concerned about the setup cost to create the sub-lists, my thoughts are
> purely from a "how easy is it to understand" perspective, closely followed by
> "how performant is the runtime code".  IIUC, the runtime performance is basically
> equivalent since the comparison function will need to mask off bits either way.
>
> For the forward+backward, IMO it's easy to understand with a single comment above
> the forward+backward walks:
>
>         /*
>          * Entries are sorted by eventsel, walk the list in both directions to
>          * process all entries with the target eventsel.
>          */
>
> Sorting should probably have a comment too, but critically, understanding how the
> list is sorted doesn't require full understanding of how lookups are processed.
> E.g. a comment like this would suffice for sorting:
>
>         /*
>          * Sort entries by eventsel so that all entries for a given eventsel can
>          * be processed efficiently during filter.
>          */
>
> The sub-list on the other hand requires comments to explain the sub-list concept,
> document the indexing code (and its comparator?), the #define for the head bits
> (and/or struct field), and the walk code code that processes the sublist.
>
> In addition to having more things to document, the comments will be spread out,
> and IMO it's difficult to understand each individual piece without having a good
> grasp of the overall implementation.  Using "head" instead of "index" would help
> quite a bit for the lookup+walk, but I think the extra pieces will still leave
> readers wondering "why?.  E.g. Why is there a separate comparator for sorting
> vs. lookup?  Why is there a "head" field?  What problem do sub-lists solve?
>

I'll drop indexing.

>
> I don't see why encoding is necessary to achieve a common internal implementation
> though.  To make sure we're talking about the same thing, by "encoding" I mean
> having different layouts for the same data in the uAPI struct than the in-kernel
> struct.  I'm perfectly ok having bits in the uAPI struct that are dropped when
> building the in-kernel lists, e.g. the EXCLUDE bit.  Ditto for having bits in the
> in-kernel struct that don't exist in the uAPI struct, e.g. the "head" (index) of
> the sublist if we go that route.
>
> My objection to "encoding" is moving the eventsel bits around.  AFAICT, it's not
> strictly necessary, and similar to the sub-list approach, that raises that question
> of "why?".  In all cases, aren't the "eventsel" bits always contained in bits 35:32
> and 7:0?  The comparator can simply mask off all other bits in order to find a
> filter with the specified eventsel, no?

Strictly speaking, yes... as long as you are aware of some boundaries
and work within them.

Problem:
--------

Given the event select + unit mask pairs: {0x101, 0x1}, {0x101, 0x2},
{0x102, 0x1}

If we use the architectural layout we get: 0x10011, 0x10021, 0x10012.

Sorted by filter_event_cmp(), i.e. event select, it's possible to get:
0x10012, 0x10011, 0x10021.

Then if a search for {0x101, 0x2} with cmp_u64() is done it wouldn't
find anything because 0x10021 is deemed less than 0x10011 in this
list.  That's why adding find_filter_index(..., cmp_u64) > 0 doesn't
work to special case legacy events.

Similarly, if sorted by cmp_u64() we get: 0x10021, 0x10012, 0x10011.

Then a search with filter_event_cmp() for 0x10021 would fail as well.

Possible workaround #1:
-----------------------

If we use the internal layout (removed index).

struct kvm_pmu_filter_entry {
        union {
                u64 raw;
                struct {
                        u64 mask:8;
                        u64 match:8; // doubles as umask, i.e.
encode_filter_entry()
                        u64 event_select:12;
                        u64 exclude:1;
                        u64 rsvd:35;
                };
        };
};

Because the event_select is contiguous, all of its bits are above
match, and the fields in kvm_pmu_filter_entry are ordered from most
important to least important from a sort perspective, a sort with
cmp_u64() gives us: 0x10210, 0x10120, 0x10110.

This order will work for both legacy events and masked events.  So, as
you suggested, if we wanted to add the following to
is_gp_event_allowed() we can special case legacy events and early out:

        if (!(filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS))
                return find_filter_index(..., cmp_u64) > 0;

Or we can leave it as is and the mask events path will come up with
the same result.

Possible workaround #2:
-----------------------

If we use the architectural layout for masked events, e.g.:

struct kvm_pmu_event_filter_entry {
        union {
                __u64 raw;
                struct {
                        __u64 select_lo:8;
                        __u64 match:8;
                        __u64 rsvd1:16;
                        __u64 select_hi:4;
                        __u64 rsvd2:19;
                        __u64 mask:8;
                        __u64 exclude:1;
                };
        }
}

This becomes more restrictive, but for our use case I believe it will
work.  The problem with this layout in general is where the event
select ends up.  You can't put anything below 'select_lo', and
'select_lo' and 'select_hi' straddle the unit mask, so you just have
less control over the order things end up.  That said, if our goal is
to just sort by exclude + event select for masked events we can do
that with filter_event_cmp() on the layout above.  If we want to find
a legacy event we can use cmp_u64() on the layout above as well.  The
only caveat is you can't mix and match during lookup like you can in
workaround #1.  You have to sort and search with the same comparer.

If we convert legacy events to masked events I'm pretty sure we can
still have a common code path.

>
> > > We might need separate logic for the existing non-masked mechanism, but again
> > > that's only more code, IMO it's not more complex.  E.g. I believe that the legacy
> > > case can be handled with a dedicated:
> > >
> > >         if (!(filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS))
> > >                 return find_filter_index(..., cmp_u64) > 0;
> > >
> >
> > I'd rather not drop encoding, however, if we did, sorting and
> > searching would both have to be special cased.  Masked events and
> > non-masked events are not compatible with each other that way. If the
> > list is sorted for masked events, you can't do a cmp_u64 search on it
> > and expect to find anything.
>
> I'm not sure I follow.  As above, doesn't the search for masked vs. non-masked only
> differ on the comparator?
>
> > I suppose you could if using the struct overlay and we included match (which
> > doubles as the unit mask for non-masked events) in the comparer and dropped
> > indexing.
>
> Why does "match" need to be in the comparer?  I thought the sub-lists are created
> for each "eventsel"?
>
> > But that only works because the struct overlay keeps the event select
> > contiguous.  The fact that the architectural format has the event select
> > straddle the unit mask prevents that from working.
> >
> > > Oh, and as a bonus of splitting include vs. exclude, the legacy case effectively
> > > optimizes exclude since the length of the exclude array will be '0'.
> >
> > This should apply to both implementations.
>
> If everything is in a single list, doesn't the exclude lookup need to search the
> entire thing to determine that there are no entries?

Yes.  To do what I'm suggesting would require creating an internal
representation of the struct kvm_pmu_event_filter to track the include
and exclude portions of the list.  But that should be fairly
straightforward to set up when loading the filter, then we would be
able to search the individual lists rather than the whole thing.
Having said that, I'm not saying this is necessary, all I'm saying is
that it wouldn't be hard to do.

> ...
>
> > > >  struct kvm_pmu_filter_entry {
> > > >       union {
> > > >               u64 raw;
> > > >               struct {
> > > > +                     u64 mask:8;
> > > > +                     u64 match:8;
> > > > +                     u64 event_index:12;
> > >
> > > This is broken.  There are 2^12 possible event_select values, but event_index is
> > > the index into the full list of events, i.e. is bounded only by nevents, and so
> > > this needs to be stored as a 32-bit value.  E.g. if userspace creates a filter
> > > with 2^32-2 entries for eventsel==0, then the index for eventsel==1 will be
> > > 2^32-1 even though there are only two event_select values in the entire list.
> > >
> >
> > nevents <= KVM_PMU_EVENT_FILTER_MAX_EVENTS (300), so there is plenty
> > of space in event_index to cover any valid index.  Though a moot point
> > if we cut it.
>
> Oooh.  In that case, won't 9 bits suffice?  Using 12 implies there's a connection
> to eventsel, which is misleading and confusing.

Yes, 9 would suffice.  I gave some buffer because I liked the idea of
round numbers and I had a lot of space in the struct.  I didn't see it
implying a connection to event_select, but in hindsight I can see why
you may have thought that.

>
> Regardless, if we keep the indexing, there should be a BUILD_BUG_ON() to assert
> that the "head" (event_index) field is larger enough to hold the max number of
> events.  Not sure if there's a way to get the number of bits, i.e. might require
> a separate #define to get the compile-time assert. :-/

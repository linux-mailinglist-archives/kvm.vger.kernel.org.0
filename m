Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB396015A9
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 19:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiJQRsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 13:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiJQRr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 13:47:58 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBA373930
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 10:47:56 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id k9so11024780pll.11
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 10:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1iCb3Z3aKpHPpUsYrpZs20XoNjOIajZnwC/024IUEZc=;
        b=cKPL0jfE3GGMRkNvJ6wdFqMGIor7rbr4nv+TQGfHJsUUWvHexuZXwTl5EhvqlDHwIX
         QgYcQHh0v4GwnazXizO2v6zTqkpwbc7c6LqopIjATOdsfkgNCgxK/zJborUhGEEGozGl
         urDfjNKuU8/PQqI0zcL+6MP+rBbtlPevoM42E9ujnNK5dA1YQ56dbjjXj/hYUu8YdUOV
         jFJ9wKNB9cwkDV3ZJ9xqEKVr3qd62sSgB1787bMWLWH9VUKP+BkVIM+Ioqgpzo6dk91M
         aSly1ukjOFuirM3S0B8HgE1MYnH9UjhyP1ius4eNVrx9e+PWGYgghhwimqtILKKTtUYS
         cd8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1iCb3Z3aKpHPpUsYrpZs20XoNjOIajZnwC/024IUEZc=;
        b=gQn1OagTNh1+aeFSEs63hg3bnVuipBdcuVrdqspKoH4aJZbLAtvnXZv7HgV9DZDT88
         R7Rj91/Iq95ZZhpxwprz5dGrmKgnTClCw8IfSYhIbOa9gQE2XDmM2+CuAZFYrpn1/SCW
         Nsn2MHPQ+dvq5j8Ff2t3h9Y6NK5wydsTDiaxIrV7tT7sS25Gu71eF+6DatoPXbHYagoD
         8bDZHUYIS/7yT83OBlaA4HyCEf2xIteR1rCE3zEb4kFPNTWOTYl/w2BKpf5siQfELIvr
         SqySu6j8+sBte0KX7S9iFSVeYkNJuc6mRIBRla0yszs4H9ndDTkzRePpnfufVFmPpWfH
         oyCQ==
X-Gm-Message-State: ACrzQf2WXOpQvx83C8EFNbnvAl6+SHXIqhf4zW5d5htnfiazAI1at+zu
        AknG46ud4mlKkmQnx7KzqD4dAtv5lB0V1w==
X-Google-Smtp-Source: AMsMyM5Fdh2yTZr9BG3x1mziqIq8bHzDBT+TS9AZ2KQ6HKwphALEPqyqSS4yHCCehOGHSqxhkkJMVw==
X-Received: by 2002:a17:90b:1e0b:b0:20d:85ca:b50e with SMTP id pg11-20020a17090b1e0b00b0020d85cab50emr34249007pjb.82.1666028875244;
        Mon, 17 Oct 2022 10:47:55 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c9-20020a624e09000000b005365aee486bsm7413699pfb.192.2022.10.17.10.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 10:47:54 -0700 (PDT)
Date:   Mon, 17 Oct 2022 17:47:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v5 4/7] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
Message-ID: <Y02VRyrVu2Fh3ipS@google.com>
References: <20220920174603.302510-1-aaronlewis@google.com>
 <20220920174603.302510-5-aaronlewis@google.com>
 <Y0Q9ZFGQf1On/Cus@google.com>
 <CAAAPnDGfPZ7k6mHkefhT2tvt6E4cWpEm_QE2Hz=zaVONoXO+xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAPnDGfPZ7k6mHkefhT2tvt6E4cWpEm_QE2Hz=zaVONoXO+xg@mail.gmail.com>
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

On Sat, Oct 15, 2022, Aaron Lewis wrote:
> On Mon, Oct 10, 2022 at 8:42 AM Sean Christopherson <seanjc@google.com> wrote:
> > Unless I'm missing something, this is a complex way to solve a relatively simple
> > problem.  You want a list of "includes" and a list of "excludes".  Just have two
> > separate lists.
> >
> > Actually, if we're effectively changing the ABI, why not make everyone's lives
> > simpler and expose that to userspace.  E.g. use one of the "pad" words to specify
> > the number of "include" events and effectively do this:
> >
> > struct kvm_pmu_event_filter {
> >         __u32 action;
> >         __u32 nevents;
> >         __u32 fixed_counter_bitmap;
> >         __u32 flags;
> >         __u32 nr_include_events;
> >         __u64 include[nr_include_events];
> >         __u64 exclude[nevents - nr_allowed_events];
> > };
> >
> > Then we don't need to steal a bit for "exclude" in the uABI.  The kernel code
> > gets a wee bit simpler.
> 
> <end of previous comments>
> 
> I'm not sure I understand the struct changes you're proposing.  Is
> this what you mean?
> 
> struct kvm_pmu_event_filter {
>         __u32 action;
>         __u32 nevents;
>         __u32 fixed_counter_bitmap;
>         __u32 flags;
>         __u32 nr_include_events;
>         __u32 pad;
>         __u64 *include; // length == nr_include_events
>         __u64 exclude[]; // length == nevents - nr_include_events

Ya, something like that.

> };
> 
> I considered having an include list and exclude list on the filter,
> but I thought that was too much detail to share with userspace.  I've
> spent too much time lately trying to change ABI's or wishing they were
> different. I'd prefer to share as little as possible with userspace at
> this point in hopes of allowing us to change our minds or evolve this
> in the future.

I don't think a list vs. a flag shares any more or less with userspace, e.g. KVM
could very well merge the lists internally.

> To that end, if we use a bit in the event to distinguish between an
> include list and an exclude list the only thing we're locked into is
> the type of event being introduced with masked events, which would be
> easy to iterate on or change.

As above, we're not locked into an internal implementation either way.

> Then, if we sort the list like I do, it's naturally split into an include
> list and an exclude list anyway, so we essentially have the same thing in the
> end.  At that point if we want to explicitly have an include list and an
> exclude list we could make an internal struct for kvm_pmu_event_filter
> similar to what msr filtering does, but I'm not sure that's necessary.
> 
> I think setting it up this way makes the data coming from userspace
> less error prone and easier for them to work with because the lists
> are being separated for them into include and exclude, and the order
> they build it in doesn't matter.

The above said, I agree that building the separate lists would be obnoxious for
userspace.  Userspace would either need to know the length of the "includes" list
up front, or would have to build the "excludes" list separately and then fold it
in at the end.  Unless we might run out of bits, lets keep the flag approach for
the uAPI.
 
> Isn't having the include list pointer exposed to userspace a little
> awkward?  As is I'm not sure why userspace would care about it, and
> when we load the filter we'd essentially ignore it.

I don't follow.  I assume userspace cares about specifying "includes", otherwise
why provide that functionality?

> It feels like an internal variable that's exposed to userspace.  Also, the
> naming is confusing when working with non-masked events.  E.g. the "exclude"
> list would be used in place of what was the "events" list.  That seems less
> intuitive.

Honestly, I find the "includes vs. excludes" terminology to be quite confusing
regardless of what API is presented to userspace.  Can't think of better names
though.

> > I'm not so sure that this is simpler overall though.  If inclusive vs. exclusive
> > are separate lists, then avoiding "index" would mean there's no need to convert
> > entries.  And IIUC, the only thing this saves in filter_contains_match() is
> > having to walk backwards, e.g. it's
> >
> >         for (i = index; i < filter->nevents; i++) {
> >                 if (!<eventsel event match>)
> >                         break;
> >
> >                 if (is_filter_match(...))
> >                         return true;
> >         }
> >
> >         return false;
> >
> > versus
> >
> >         for (i = index; i < filter->nevents; i++) {
> >                 if (filter_event_cmp(eventsel, filter->events[i]))
> >                         break;
> >
> >                 if (is_filter_match(eventsel, filter->events[i]))
> >                         return true;
> >         }
> >
> >         for (i = index - 1; i > 0; i--) {
> >                 if (filter_event_cmp(eventsel, filter->events[i]))
> >                         break;
> >
> >                 if (is_filter_match(eventsel, filter->events[i]))
> >                         return true;
> >         }
> >
> >         return false;
> >
> > It's definitely _more_ code in filter_contains_match(), and the duplicate code is
> > unfortunate, but I wouldn't necessarily say it's simpler.  There's a fair bit of
> > complexity in understanding the indexing scheme, it's just hidden.
> >
> 
> I think indexing the data is nice to have.  The only additional cost
> is walking the list when a filter is loaded, then we are able to
> search the head of the list and not have to do this odd walk forward
> then backward business.

I'm not concerned about the setup cost to create the sub-lists, my thoughts are
purely from a "how easy is it to understand" perspective, closely followed by
"how performant is the runtime code".  IIUC, the runtime performance is basically
equivalent since the comparison function will need to mask off bits either way.

For the forward+backward, IMO it's easy to understand with a single comment above
the forward+backward walks:

	/*
	 * Entries are sorted by eventsel, walk the list in both directions to
	 * process all entries with the target eventsel.
	 */

Sorting should probably have a comment too, but critically, understanding how the
list is sorted doesn't require full understanding of how lookups are processed.
E.g. a comment like this would suffice for sorting:

	/*
	 * Sort entries by eventsel so that all entries for a given eventsel can
	 * be processed effeciently during filter.
	 */

The sub-list on the other hand requires comments to explain the sub-list concept,
document the indexing code (and its comparator?), the #define for the head bits
(and/or struct field), and the walk code code that processes the sublist.

In addition to having more things to document, the comments will be spread out,
and IMO it's difficult to understand each individual piece without having a good
grasp of the overall implementation.  Using "head" instead of "index" would help
quite a bit for the lookup+walk, but I think the extra pieces will still leave
readers wondering "why?.  E.g. Why is there a separate comparator for sorting
vs. lookup?  Why is there a "head" field?  What problem do sub-lists solve?

> I'm open to dropping it if it's causing more confusion than it's worth.  And
> as you pointed out, I believe not having it would allow for the use of
> filter_event_cmp() during bounding walks.
> 
> > And I believe if the indexing is dropped, then the same filter_event_cmp() helper
> > can be used for sort() and bsearch(), and for bounding the walks.
> >
> > And here's also no need to "encode" entries or use a second struct overly.
> >
> 
> Encoding events solves a different problem than indexing.  It converts
> the events that come from userspace into a common format we can use
> internally.  That allows the kernel to have a common code path, no
> matter what type of event it started out as.

I don't see why encoding is necessary to achieve a common internal imlementation
though.  To make sure we're talking about the same thing, by "encoding" I mean
having different layouts for the same data in the uAPI struct than the in-kernel
struct.  I'm perfectly ok having bits in the uAPI struct that are dropped when
building the in-kernel lists, e.g. the EXCLUDE bit.  Ditto for having bits in the
in-kernel struct that don't exist in the uAPI struct, e.g. the "head" (index) of
the sublist if we go that route.

My objection to "encoding" is moving the eventsel bits around.  AFAICT, it's not
strictly necessary, and similar to the sub-list approach, that raises that question
of "why?".  In all cases, aren't the "eventsel" bits always contained in bits 35:32
and 7:0?  The comparator can simply mask off all other bits in order to find a
filter with the specified eventsel, no?

> > We might need separate logic for the existing non-masked mechanism, but again
> > that's only more code, IMO it's not more complex.  E.g. I believe that the legacy
> > case can be handled with a dedicated:
> >
> >         if (!(filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS))
> >                 return find_filter_index(..., cmp_u64) > 0;
> >
> 
> I'd rather not drop encoding, however, if we did, sorting and
> searching would both have to be special cased.  Masked events and
> non-masked events are not compatible with each other that way. If the
> list is sorted for masked events, you can't do a cmp_u64 search on it
> and expect to find anything.

I'm not sure I follow.  As above, doesn't the search for masked vs. non-masked only
differ on the comparator?

> I suppose you could if using the struct overlay and we included match (which
> doubles as the unit mask for non-masked events) in the comparer and dropped
> indexing.

Why does "match" need to be in the comparer?  I thought the sub-lists are created
for each "eventsel"?

> But that only works because the struct overlay keeps the event select
> contiguous.  The fact that the architectural format has the event select
> straddle the unit mask prevents that from working.
> 
> > Oh, and as a bonus of splitting include vs. exclude, the legacy case effectively
> > optimizes exclude since the length of the exclude array will be '0'.
> 
> This should apply to both implementations.

If everything is in a single list, doesn't the exclude lookup need to search the
entire thing to determine that there are no entries?

> I didn't add an include list and exclude list, but the data is laid out for
> it.  The main reason I didn't do that is I didn't think there was enough of a
> win to create an internal copy of kvm_pmu_event_filter (stated above), and
> it'd be exposing too much of the implementation to userspace to add it there.
>
> > If we do keep the indexing, I think we should rename "index" to "head", e.g. like
> > "head pages", to make it more obvious that the helper returns the head of a list.

...

> > >  struct kvm_pmu_filter_entry {
> > >       union {
> > >               u64 raw;
> > >               struct {
> > > +                     u64 mask:8;
> > > +                     u64 match:8;
> > > +                     u64 event_index:12;
> >
> > This is broken.  There are 2^12 possible event_select values, but event_index is
> > the index into the full list of events, i.e. is bounded only by nevents, and so
> > this needs to be stored as a 32-bit value.  E.g. if userspace creates a filter
> > with 2^32-2 entries for eventsel==0, then the index for eventsel==1 will be
> > 2^32-1 even though there are only two event_select values in the entire list.
> >
> 
> nevents <= KVM_PMU_EVENT_FILTER_MAX_EVENTS (300), so there is plenty
> of space in event_index to cover any valid index.  Though a moot point
> if we cut it.

Oooh.  In that case, won't 9 bits suffice?  Using 12 implies there's a connection
to eventsel, which is misleading and confusing.

Regardless, if we keep the indexing, there should be a BUILD_BUG_ON() to assert
that the "head" (event_index) field is larger enough to hold the max number of
events.  Not sure if there's a way to get the number of bits, i.e. might require
a separate #define to get the compile-time assert. :-/

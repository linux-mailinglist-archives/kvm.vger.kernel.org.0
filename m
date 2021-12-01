Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6634645AB
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 05:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346506AbhLAEOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 23:14:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33760 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231869AbhLAEOL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 23:14:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638331850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eE0aTXtnF2atUJTISMBmb2NtIEVWec+Tg7pKWUMoTVc=;
        b=T/xvmIDaccvlA+XPH5absdGMahySUNnOQt3qHw9qrjdHYRKbZrgciwLNoE+hShQEtT74J6
        S904lwus3IT1sbiPQir/fBPBcgieSA1dy9tJlMqsPaHtFgESL6RJxV8H24Xs+5qRvQEEmu
        peexxDZJ56u8AzeYrjQgXm4YX0OX6jc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-sverqNa5MAytclhbjZ2png-1; Tue, 30 Nov 2021 23:10:49 -0500
X-MC-Unique: sverqNa5MAytclhbjZ2png-1
Received: by mail-wm1-f71.google.com with SMTP id z138-20020a1c7e90000000b003319c5f9164so14977070wmc.7
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 20:10:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eE0aTXtnF2atUJTISMBmb2NtIEVWec+Tg7pKWUMoTVc=;
        b=sfQ7oSzNFxeYk0E32olXE8QFVDv+L3im/I4MfFNWvT3tt+MteD5bx6See35CkcgGi+
         dQ/G12c19+wj595oHeciQEDS9N9EiPMnCO2u+MdS/ETY5LcGuB2eljEu8NiO9TAScPux
         7saZSieQ3mKahuer8T04nBParQUcxN3GOtj2Tvw/1tGTezetuFml75DYZrQIyroKRxkn
         VWSugULVQ9kYhK0ua07J66pktN5g7QH0iMMieV80rBrI9RbOICkjmlKHUNIyfvFanwsg
         z0ulHvT/QTdj1zH9PWY7fPCFRwmrMeIEV9DenVWsXXlVbKXDwebaqgL9dd5ovMsSpyrQ
         FHyg==
X-Gm-Message-State: AOAM532Gt5MHCE69c1J+G1dFqK23SVc52LIqLDqi75QZYTAPcJf6TazZ
        LCX6oLRzm1D+Gvq5MYMndtsORcs+DMdH9+Ulknwz2ipLMzqJjbOpujjhFlx39PyAfcsVWMVLMVQ
        Oy3huLcOPYFo+
X-Received: by 2002:a05:600c:4ed2:: with SMTP id g18mr3807313wmq.18.1638331847824;
        Tue, 30 Nov 2021 20:10:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy3mf+UxSySY1UUH3noGUOnHXd92UcN9UCwCHcucJvp4ydtNR3f7sIVwj+ky4GKxKNz++Fsgg==
X-Received: by 2002:a05:600c:4ed2:: with SMTP id g18mr3807295wmq.18.1638331847620;
        Tue, 30 Nov 2021 20:10:47 -0800 (PST)
Received: from xz-m1.local ([64.64.123.10])
        by smtp.gmail.com with ESMTPSA id j18sm4935499wmq.44.2021.11.30.20.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:10:46 -0800 (PST)
Date:   Wed, 1 Dec 2021 12:10:38 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [RFC PATCH 00/15] KVM: x86/mmu: Eager Page Splitting for the TDP
 MMU
Message-ID: <Yab1vgF6ls5KFkVk@xz-m1.local>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <YaDrmNVsXSMXR72Z@xz-m1.local>
 <CALzav=c7Px_X-MvoRixs=yy7wW4GdhavOAD=ZfHKy+n+Kih+bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALzav=c7Px_X-MvoRixs=yy7wW4GdhavOAD=ZfHKy+n+Kih+bQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021 at 03:22:29PM -0800, David Matlack wrote:
> On Fri, Nov 26, 2021 at 6:13 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > Hi, David,
> >
> > On Fri, Nov 19, 2021 at 11:57:44PM +0000, David Matlack wrote:
> > > This series is a first pass at implementing Eager Page Splitting for the
> > > TDP MMU. For context on the motivation and design of Eager Page
> > > Splitting, please see the RFC design proposal and discussion [1].
> > >
> > > Paolo, I went ahead and added splitting in both the intially-all-set
> > > case (only splitting the region passed to CLEAR_DIRTY_LOG) and the
> > > case where we are not using initially-all-set (splitting the entire
> > > memslot when dirty logging is enabled) to give you an idea of what
> > > both look like.
> > >
> > > Note: I will be on vacation all of next week so I will not be able to
> > > respond to reviews until Monday November 29. I thought it would be
> > > useful to seed discussion and reviews with an early version of the code
> > > rather than putting it off another week. But feel free to also ignore
> > > this until I get back :)
> > >
> > > This series compiles and passes the most basic splitting test:
> > >
> > > $ ./dirty_log_perf_test -s anonymous_hugetlb_2mb -v 2 -i 4
> > >
> > > But please operate under the assumption that this code is probably
> > > buggy.
> > >
> > > [1] https://lore.kernel.org/kvm/CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com/#t
> >
> > Will there be more numbers to show in the formal patchset?
> 
> Yes definitely. I didn't have a lot of time to test this series, hence
> the RFC status. I'll include more thorough testing and performance
> evaluation in the cover letter for v1.
> 
> 
> > It's interesting to
> > know how "First Pass Dirty Memory Time" will change comparing to the rfc
> > numbers; I can have a feel of it, but still. :) Also, not only how it speedup
> > guest dirty apps, but also some general measurement on how it slows down
> > KVM_SET_USER_MEMORY_REGION (!init-all-set) or CLEAR_LOG (init-all-set) would be
> > even nicer (for CLEAR, I guess the 1st/2nd+ round will have different overhead).
> >
> > Besides that, I'm also wondering whether we should still have a knob for it, as
> > I'm wondering what if the use case is the kind where eager split huge page may
> > not help at all.  What I'm thinking:
> >
> >   - Read-mostly guest overload; split huge page will speed up rare writes, but
> >     at the meantime drag readers down due to huge->small page mappings.
> >
> >   - Writes-over-very-limited-region workload: say we have 1T guest and the app
> >     in the guest only writes 10G part of it.  Hmm not sure whether it exists..
> >
> >   - Postcopy targeted: it means precopy may only run a few iterations just to
> >     send the static pages, so the migration duration will be relatively short,
> >     and the write just didn't spread a lot to the whole guest mem.
> >
> > I don't really think any of the example is strong enough as they're all very
> > corner cased, but just to show what I meant to raise this question on whether
> > unconditionally eager split is the best approach.
> 
> I'd be happy to add a knob if there's a userspace that wants to use
> it. I think the main challenge though is knowing when it is safe to
> disable eager splitting.

Isn't it a performance feature?  Why it'll be not safe?

> For a small deployment where you know the VM workload, it might make
> sense. But for a public cloud provider the only feasible way would be to
> dynamically monitor the guest writing patterns. But then we're back at square
> one because that would require dirty logging. And even then, there's no
> guaranteed way to predict future guest write patterns based on past patterns.

Agreed, what I was thinking was not for public cloud usages, but for the cases
where we can do specific tunings on some specific scenarios.  It normally won't
matter a lot with small or medium sized VMs but extreme use cases.

> 
> The way forward here might be to do a hybrid of 2M and 4K dirty
> tracking (and maybe even 1G). For example, first start dirty logging
> at 2M granularity, and then log at 4K for any specific regions or
> memslots that aren't making progress. We'd still use Eager Page
> Splitting unconditionally though, first to split to 2M and then to
> split to 4K.

Do you mean we'd also offer different granule dirty bitmap to the userspace
too?

I remembered you mentioned 2mb dirty tracking in your rfc series, but I didn't
expect it can be dynamically switched during tracking.  That sounds a very
intersting idea.

Thanks,

-- 
Peter Xu


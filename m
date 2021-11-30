Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CB946423B
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 00:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240786AbhK3X0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 18:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239144AbhK3X0T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 18:26:19 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15010C061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 15:22:58 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id z8so44290011ljz.9
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 15:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=awp2fNYvI8N0j1uERo7X7MYbQEC+ppqojEZsdcxlsLU=;
        b=nCbDTBk7DI8JoVU5VF/f1jYNihy+oGaBRsulseDViAL41CiFMq5/hk9EYKgE+7BO4o
         5PTyJmdvYHSN+n9+mE+ru1AcWDEQYV+Bt4ywzdGsZRVqqztWrGDuP5OHcxp0mGByqCbn
         Tk2A+ljudqzX2stt1MWTCYjesxEFUA7w0Gc+dV00iakfzQ8GhlBxx1jz5oj18zxV4VYk
         COjA6Idf2GKmwqT3BIy2begmiDjlcOeopfvkLcZZRDPqpu0FtrsLqiVjqOpnCA/sk403
         Cnhx0ZFQ9kHZTjoCSrD5DTxKpXdQYkeTDbbg/tZkw+EzcXbRX+eMV69G5AKu2nd2LqRZ
         dkTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=awp2fNYvI8N0j1uERo7X7MYbQEC+ppqojEZsdcxlsLU=;
        b=IUNH05b9cPbT5TkfykSBu0eR9I1ZSJ7vsOsZRxPVuAdggaIH6Jf9L6EOyJ1/WywgN6
         UIz34DAp6jqS/uuU4e5H1FuH9fYaSEsK7vi/+l4FXjyEVm0yIg3zX346P7q7w0BTC3yC
         XPO09kpDV5THTsvcnWUeLFn6wFsGMaDY/KdIWpzTs1SThKbRGZ+IFK3t27uUliiQGcTt
         KNXmZCO1G5LYGDNmZEzEn9nOPGNRES0Y3Laxr2dP37loMge3GsdEzc6sJ/Fe1+UxorSX
         QUj/VwMn8Oo8gjgLGrAAXKLiEpeg1lZIX88GEdXBlvspJ4CdzaLJCHLo+BKZgjIrC8kR
         WAXg==
X-Gm-Message-State: AOAM532FvjZbf2vgGFJR6YXZnLKBNuIfUHR1VRKTQIFB4ACluWaM7KU5
        YHp9U09VkrK493BvaJLwDuMqT4aMCnimw364nSHxkA==
X-Google-Smtp-Source: ABdhPJyQeqiUYeHmkQz5E8haoDBCFJIIwVEiCxo7MY5EU2CsI8nIhqAneRtdkuQd7+GtMBAlkyIjjPMGlmHkOVNAdVs=
X-Received: by 2002:a2e:8991:: with SMTP id c17mr1834575lji.361.1638314576177;
 Tue, 30 Nov 2021 15:22:56 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <YaDrmNVsXSMXR72Z@xz-m1.local>
In-Reply-To: <YaDrmNVsXSMXR72Z@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 30 Nov 2021 15:22:29 -0800
Message-ID: <CALzav=c7Px_X-MvoRixs=yy7wW4GdhavOAD=ZfHKy+n+Kih+bQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/15] KVM: x86/mmu: Eager Page Splitting for the TDP MMU
To:     Peter Xu <peterx@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 26, 2021 at 6:13 AM Peter Xu <peterx@redhat.com> wrote:
>
> Hi, David,
>
> On Fri, Nov 19, 2021 at 11:57:44PM +0000, David Matlack wrote:
> > This series is a first pass at implementing Eager Page Splitting for the
> > TDP MMU. For context on the motivation and design of Eager Page
> > Splitting, please see the RFC design proposal and discussion [1].
> >
> > Paolo, I went ahead and added splitting in both the intially-all-set
> > case (only splitting the region passed to CLEAR_DIRTY_LOG) and the
> > case where we are not using initially-all-set (splitting the entire
> > memslot when dirty logging is enabled) to give you an idea of what
> > both look like.
> >
> > Note: I will be on vacation all of next week so I will not be able to
> > respond to reviews until Monday November 29. I thought it would be
> > useful to seed discussion and reviews with an early version of the code
> > rather than putting it off another week. But feel free to also ignore
> > this until I get back :)
> >
> > This series compiles and passes the most basic splitting test:
> >
> > $ ./dirty_log_perf_test -s anonymous_hugetlb_2mb -v 2 -i 4
> >
> > But please operate under the assumption that this code is probably
> > buggy.
> >
> > [1] https://lore.kernel.org/kvm/CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com/#t
>
> Will there be more numbers to show in the formal patchset?

Yes definitely. I didn't have a lot of time to test this series, hence
the RFC status. I'll include more thorough testing and performance
evaluation in the cover letter for v1.


> It's interesting to
> know how "First Pass Dirty Memory Time" will change comparing to the rfc
> numbers; I can have a feel of it, but still. :) Also, not only how it speedup
> guest dirty apps, but also some general measurement on how it slows down
> KVM_SET_USER_MEMORY_REGION (!init-all-set) or CLEAR_LOG (init-all-set) would be
> even nicer (for CLEAR, I guess the 1st/2nd+ round will have different overhead).
>
> Besides that, I'm also wondering whether we should still have a knob for it, as
> I'm wondering what if the use case is the kind where eager split huge page may
> not help at all.  What I'm thinking:
>
>   - Read-mostly guest overload; split huge page will speed up rare writes, but
>     at the meantime drag readers down due to huge->small page mappings.
>
>   - Writes-over-very-limited-region workload: say we have 1T guest and the app
>     in the guest only writes 10G part of it.  Hmm not sure whether it exists..
>
>   - Postcopy targeted: it means precopy may only run a few iterations just to
>     send the static pages, so the migration duration will be relatively short,
>     and the write just didn't spread a lot to the whole guest mem.
>
> I don't really think any of the example is strong enough as they're all very
> corner cased, but just to show what I meant to raise this question on whether
> unconditionally eager split is the best approach.

I'd be happy to add a knob if there's a userspace that wants to use
it. I think the main challenge though is knowing when it is safe to
disable eager splitting. For a small deployment where you know the VM
workload, it might make sense. But for a public cloud provider the
only feasible way would be to dynamically monitor the guest writing
patterns. But then we're back at square one because that would require
dirty logging. And even then, there's no guaranteed way to predict
future guest write patterns based on past patterns.

The way forward here might be to do a hybrid of 2M and 4K dirty
tracking (and maybe even 1G). For example, first start dirty logging
at 2M granularity, and then log at 4K for any specific regions or
memslots that aren't making progress. We'd still use Eager Page
Splitting unconditionally though, first to split to 2M and then to
split to 4K.

>
> Thanks,
>
> --
> Peter Xu
>

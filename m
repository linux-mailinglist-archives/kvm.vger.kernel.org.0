Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120625892A7
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 21:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237997AbiHCTVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 15:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236531AbiHCTVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 15:21:50 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EC63E767
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 12:21:48 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f11so15967253pgj.7
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 12:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=L3BXoDAnjXKl7DF5MAL+W0kL9WnJVL0b1/HkhEfMB6o=;
        b=TjQRomc0BncZKstd0VtuEoVthcM/oSbSEL77eNSNYn0WzPnp2Edcq9KcBb1Vq9iXMx
         2FmV8jclNZmRNGHba1FWsdthmkJ3V4XXTaPSkSqHuDG+9xKpKQMzBZUI3PtLAXEjMSIz
         Gsakob4IjBskgerDp8blcso3BMVVtiZZkx/Wh29jgydRdN9W2q6mqYzP6nrkyvIwEGKp
         aA43mf6vjD++eHQcpNNLrIcszEocGgEAwKLJL4QV4ONcaqkiXH7d2l0r8KzwbTGlDJhS
         vSQNrYdhUKAT6TmlwJoMLYxkENEXLhmJxpPs3aqiGDEtrp8sozaZxufTWJ3DaD6N/QRB
         gDdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=L3BXoDAnjXKl7DF5MAL+W0kL9WnJVL0b1/HkhEfMB6o=;
        b=1m0C1smF4As8LcYsu/zjLHiJROECbjHp3zFlwR26WL8omfN81FoaYsquIxA6Qgdrdz
         2lm+BVAMgINATZmpxSnd2/fIpK0Z5hgi87SprrVCWOKeW5TOjehBAMvhi/6i8ecVYmg3
         CqbqVDBC2YeYkdrgj6qVA5Pc88ANLgQVqfLRlp7v9PALYwV2qD24uSjtcwnbrtuBtDVa
         s7PLJyo3jUVtEVGJVd/H10nqbnp8j27UMPyZPubBO937NkKBKgUKsw7P3hHRN2EiCjQt
         +47XAKtAdPdNxPUeczM7X2lb6mIc8ZT9WEezhIi1aLtXrUVdIEMn8ARse5pYOYrelniQ
         v21Q==
X-Gm-Message-State: AJIora+xVqs/K8F8/b9JuZjpxd8tgL8HjzFHc+TptROKp8V2KLrvnhFk
        EYEdcKfBV5tGlvH4cVcQjm4efg==
X-Google-Smtp-Source: AGRyM1sYEfRp+NhnfWgOD9pnywTRoeKibbqNbFltK9LYASso7bT1OFsTtRUBKZ37SNcDWD/PUDLZ6A==
X-Received: by 2002:a05:6a00:234f:b0:525:1f7c:f2bf with SMTP id j15-20020a056a00234f00b005251f7cf2bfmr27173548pfj.14.1659554508054;
        Wed, 03 Aug 2022 12:21:48 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t124-20020a635f82000000b0040d75537824sm8339323pgb.86.2022.08.03.12.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 12:21:47 -0700 (PDT)
Date:   Wed, 3 Aug 2022 19:21:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] selftests: KVM/x86: Fix vcpu_{save,load}_state() by
 adding APIC state into kvm_x86_state
Message-ID: <YurKx+gFAWPvj35L@google.com>
References: <20220802230718.1891356-1-mizhang@google.com>
 <20220802230718.1891356-3-mizhang@google.com>
 <YurCI5PQu44UJ0a7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YurCI5PQu44UJ0a7@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM: selftests: for the shortlog.

On Wed, Aug 03, 2022, Oliver Upton wrote:
> Hi Mingwei,
> 
> On Tue, Aug 02, 2022 at 11:07:15PM +0000, Mingwei Zhang wrote:
> > Fix vcpu_{save,load}_state() by adding APIC state into kvm_x86_state and
> > properly save/restore it in vcpu_{save,load}_state(). When vcpu resets,
> > APIC state become software disabled in kernel and thus the corresponding
> > vCPU is not able to receive posted interrupts [1].  So, add APIC
> > save/restore in userspace in selftest library code.
> 
> Of course, there are no hard rules around it but IMO a changelog is
> easier to grok if it first describes the what/why of the problem, then
> afterwards how it is fixed by the commit.

I strongly disagree.  :-)  To some extent, it's a personal preference, e.g. I
find it easier to understand the details (why something is a problem) if I have
the extra context of how a problem is fixed (or: what code was broken).

But beyond personal preference, there are less subjective reasons for stating
what a patch does before diving into details.  First and foremost, what code is
actually being changed is the most important information, and so that information
should be easy to find.  Changelogs that bury the "what's actually changing" in a
one-liner after 3+ paragraphs of background make it very hard to find that information.

Maybe for initial review one could argue that "what's the bug" is more important,
but for skimming logs and git archeology, the gory details matter less and less.
E.g. when doing a series of "git blame", the details of each change along the way
are useless, the details only matter for the culprit; I just want to quickly
determine whether or not a commit might be of interest.

Another argument for stating "what's changing" first is that it's almost always
possible to state "what's changing" in a single sentence.  Conversely, all but the
most simple bugs require multiple sentences or paragraphs to fully describe the
problem.  If both the "what's changing" and "what's the bug" are super short then
the order doesn't matter.  But if one is shorter (almost always the "what's changing),
then covering the shorter one first is advantageous because it's less of an
inconvenience for readers/reviewers that have a strict ordering preference.  E.g.
having to skip one sentence to get to the stuff you care about is less painful than
me having to skip three paragraphs to get to the stuff that I care about.

I think the underlying problem with this changelog (and the shortlog) is that it's
too literal about what is being fixed.  Shortlogs and changelogs shouldn't be
play-by-play descriptions of the code changes, they should be abstractions of the
problem and the fix.  E.g. 

  KVM: selftests: Save/restore vAPIC state in "migration" tests
  
  Save/restore vAPIC state as part of vCPU save/load so that it's preserved
  across VM "migration".  This will allow testing that posted interrupts
  are properly handled across VM migration.

With that, the first sentence covers both the "what's changing" and provides a
high-level description of the "bug" it's fixing.  And the second sentence covers
(a) "why do we want this patch", (b) "why wasn't this a problem before", and (c)
"what's the urgency of this patch".

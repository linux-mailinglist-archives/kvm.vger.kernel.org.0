Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849505032D4
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 07:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356686AbiDPAHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 20:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356697AbiDPAHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 20:07:08 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D11221808
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 17:04:38 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id c125so2314079iof.9
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 17:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v7EUmoZBDcoOSgCEPMYrLBJ9e85Zg5h9TjW7zpC21Dg=;
        b=ftWZfy7v/f/DG93DcGz77dRWOYr4bNA/SvNTc0zAPec+2UHfmMs3ZUugcqTPEdoCfJ
         KNcML7ZGC5BUit7RjIUr40BB3oHrFVHRx5fhXnvDGvIQjR/8qF2Y8gstiPEz0EGS+yI4
         xj1M0UlSE/f7RxwByZ1qXQCI2LHFsfFXGOtuyl9Za00sqr2OeHp1v12z7fdwsjz9+n82
         9XY4rty7YJD2qfnqkycJWRfhazyKVdzXsZ7nyn1gT+kLrkpoOBD1ymW24oiq74aDEyIH
         15osNd6623ac/vHHXdv2rRScwiO8kEkwzLn+v7+Wl0m+FpvHs76OpYBZIpGOrFYJcAp6
         xKTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v7EUmoZBDcoOSgCEPMYrLBJ9e85Zg5h9TjW7zpC21Dg=;
        b=qeeYFiJvXDyKwmbHfztpz7LDXDxcyRGtX8xTjixo3UY5y8Z5hcLz2PT47S59TNZL6y
         dHwl1d+CHUAIQU5kNOZbl7bXtiINLIpwvYqhPm+1++ACEJLd/1mlAXVqu0QiBjNAWke9
         bpAm12p230vWVf83z9ueW3K7Fy1EcT8DfgYuQtTAMBEtVYRVzp9qxa9FELHdlXoZrb8h
         AGdAwx0NTsimfUG51kgMVxJ8Dm6YO8eBXzAkJLS7GzW5NhEStk5d8GBtKCmKJ39NuZ6p
         DYyC4ROH5Er5CkZZFXBZajJPeTdHFMYM0cFARGspooV2VyUWZQTyudSpMmrJtZFnKZa+
         gulQ==
X-Gm-Message-State: AOAM5313yvqBe/h7EtSLXKuFgdSsnscRwhIOiWakumuV0D0KT2NyIJOf
        NnTmWGIR8hXHuDkqIfqct3COmw==
X-Google-Smtp-Source: ABdhPJx5WNudH60IdHmm8u5EeSYrYi3W2BxrIqiNRXfOdkSArYISyE9fEPmanjk3RcvvF4+wvKKxgg==
X-Received: by 2002:a5d:8b8f:0:b0:649:ec6d:98e9 with SMTP id p15-20020a5d8b8f000000b00649ec6d98e9mr469641iol.30.1650067477528;
        Fri, 15 Apr 2022 17:04:37 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id i3-20020a056602134300b0064620a85b6dsm4156467iov.12.2022.04.15.17.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:04:36 -0700 (PDT)
Date:   Sat, 16 Apr 2022 00:04:33 +0000
From:   Oliver Upton <oupton@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     KVMARM <kvmarm@lists.cs.columbia.edu>,
        kvm list <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [RFC PATCH 00/17] KVM: arm64: Parallelize stage 2 fault handling
Message-ID: <YloIEfCjWyQKJMxI@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <CALzav=c6jQ53G-2gEZYasH_b4_hLYtNAD5pW1TXSfPWxLf3_qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=c6jQ53G-2gEZYasH_b4_hLYtNAD5pW1TXSfPWxLf3_qw@mail.gmail.com>
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

On Fri, Apr 15, 2022 at 04:35:24PM -0700, David Matlack wrote:
> On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
> >
> > Presently KVM only takes a read lock for stage 2 faults if it believes
> > the fault can be fixed by relaxing permissions on a PTE (write unprotect
> > for dirty logging). Otherwise, stage 2 faults grab the write lock, which
> > predictably can pile up all the vCPUs in a sufficiently large VM.
> >
> > The x86 port of KVM has what it calls the TDP MMU. Basically, it is an
> > MMU protected by the combination of a read-write lock and RCU, allowing
> > page walkers to traverse in parallel.
> >
> > This series is strongly inspired by the mechanics of the TDP MMU,
> > making use of RCU to protect parallel walks. Note that the TLB
> > invalidation mechanics are a bit different between x86 and ARM, so we
> > need to use the 'break-before-make' sequence to split/collapse a
> > block/table mapping, respectively.
> 
> An alternative (or perhaps "v2" [1]) is to make x86's TDP MMU
> arch-neutral and port it to support ARM's stage-2 MMU. This is based
> on a few observations:
> 
> - The problems that motivated the development of the TDP MMU are not
> x86-specific (e.g. parallelizing faults during the post-copy phase of
> Live Migration).
> - The synchronization in the TDP MMU (read/write lock, RCU for PT
> freeing, atomic compare-exchanges for modifying PTEs) is complex, but
> would be equivalent across architectures.
> - Eventually RISC-V is going to want similar performance (my
> understanding is RISC-V MMU is already a copy-paste of the ARM MMU),
> and it'd be a shame to re-implement TDP MMU synchronization a third
> time.
> - The TDP MMU includes support for various performance features that
> would benefit other architectures, such as eager page splitting,
> deferred zapping, lockless write-protection resolution, and (coming
> soon) in-place huge page promotion.
> - And then there's the obvious wins from less code duplication in KVM
> (e.g. get rid of the RISC-V MMU copy, increased code test coverage,
> ...).

I definitely agree with the observation -- we're all trying to solve the
same set of issues. And I completely agree that a good long term goal
would be to create some common parts for all architectures. Less work
for us ARM folks it would seem ;-)

What's top of mind is how we paper over the architectural differences
between all of the architectures, especially when we need to do entirely
different things because of the arch.

For example, I whine about break-before-make a lot throughout this
series which is somewhat unique to ARM. I don't think we can do eager
page splitting on the base architecture w/o doing the TLBI for every
block. Not only that, we can't do a direct valid->valid change without
first making an invalid PTE visible to hardware. Things get even more
exciting when hardware revisions relax break-before-make requirements.

There's also significant architectural differences between KVM on x86
and KVM for ARM. Our paging code runs both in the host kernel and the
hyp/lowvisor, and does:

 - VM two dimensional paging (stage 2 MMU)
 - Hyp's own MMU (stage 1 MMU)
 - Host kernel isolation (stage 2 MMU)

each with its own quirks. The 'not exactly in the kernel' part will make
instrumentation a bit of a hassle too.

None of this is meant to disagree with you in the slightest. I firmly
agree we need to share as many parts between the architectures as
possible. I'm just trying to call out a few of the things relating to
ARM that will make this annoying so that way whoever embarks on the
adventure will see it.

> The side of this I haven't really looked into yet is ARM's stage-2
> MMU, and how amenable it would be to being managed by the TDP MMU. But
> I assume it's a conventional page table structure mapping GPAs to
> HPAs, which is the most important overlap.
> 
> That all being said, an arch-neutral TDP MMU would be a larger, more
> complex code change than something like this series (hence my "v2"
> caveat above). But I wanted to get this idea out there since the
> rubber is starting to hit the road on improving ARM MMU scalability.

All for it. I cc'ed you on the series for this exact reason, I wanted to
grab your attention to spark the conversation :)

--
Thanks,
Oliver

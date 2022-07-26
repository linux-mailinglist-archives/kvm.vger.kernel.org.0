Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A0E5818C2
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 19:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239438AbiGZRpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 13:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239404AbiGZRpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 13:45:11 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48941299
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 10:45:08 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id e8-20020a17090a280800b001f2fef7886eso1342367pjd.3
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 10:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e6Mz+oRz8N/ZMfMKQJLfeo18Qs4Bfu/y+IOLPo/Xolc=;
        b=Sl6Wz5Mc19zPbPzX/YifPRbqb/o8hj/Al005SjMzeeTFP0a6/21SHGsr9R2vtSSUqA
         Xl7DLGoVFKbgm3AZfLAOWUt6SkdbPMwCH2gWwrgBlhON4oQair/2reaTw/OJIuWupUdu
         ruFPRQ+mml66GMl7w4VOPpF+WF6JUT05A28HzTYodYUZj6qehwD+2o7ZlHPNoIh2Rbu/
         dBiFU5mB0eesLVZchDOIWBxXfqv4MDiIEvNirt5KVKEvbFXZYnLZasCyz+VkQqZgv0vS
         QTq2MNa+xn34sVEUr9MO/bP0PI7rWevwu3RJri9U/DnsGSnB6eB0c29FxCx+IeDtZkzN
         25Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e6Mz+oRz8N/ZMfMKQJLfeo18Qs4Bfu/y+IOLPo/Xolc=;
        b=nj0BiBbow1rt2/ydsRZd61A7EeqDPlJ9UxnSoxVvz5QYs2nkuiy9fiB7UeumFsUbgA
         2Ud3ju867qcQJ5CuaQKxNaefwZVedXg15TmnlmBYxKjlhBe/8ntJWTmPBib2zSbgdBup
         TfH/aUphP0n7dzzP7ZuCR9k71g+VLo4QScX23GrzI78te2ju87UyhmvfT/xH0O2mFhJr
         KoNB1uX2WBQOA8w45EqQg85YSSUqehHUvg6n9LoI76LT9e8r1CFRmVSV7qgTlTiUbnXp
         o8ctTK6cBjR6lUtNiCxkeBIyFnLT0pt7ZkWv75hvpVD+09BHjHGvY1KJoPSM95ZPirpI
         f6kw==
X-Gm-Message-State: AJIora8RZ3DmyEXL5xU2RI7fVZA8+GP6A8uApX96ckukph5wcJuoBAaZ
        QSHA7KhO1syLb/mrD56DnBAU6A==
X-Google-Smtp-Source: AGRyM1spXBSxypx2RydnwucYrC82/NnBmQLJRjMaunGalWfd0VV3Ww2fh7tE8iXt8LtgcUFHGMFdUw==
X-Received: by 2002:a17:90a:1485:b0:1ec:788e:a053 with SMTP id k5-20020a17090a148500b001ec788ea053mr334517pja.16.1658857507723;
        Tue, 26 Jul 2022 10:45:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u5-20020a627905000000b005259578e8fcsm12004983pfc.181.2022.07.26.10.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 10:45:07 -0700 (PDT)
Date:   Tue, 26 Jul 2022 17:45:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [RFC PATCH 0/2] KVM: selftests: Rename perf_test_util to
 memstress
Message-ID: <YuAoH9NZHbKzC6Az@google.com>
References: <20220725163539.3145690-1-dmatlack@google.com>
 <Yt8c6gklsMy2eM5f@google.com>
 <CALzav=e6ZODi1Cpv5Ej9uWWC_zF1eMMJqbXYHhi+fgenfgsfow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=e6ZODi1Cpv5Ej9uWWC_zF1eMMJqbXYHhi+fgenfgsfow@mail.gmail.com>
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

On Tue, Jul 26, 2022, David Matlack wrote:
> On Mon, Jul 25, 2022 at 3:45 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Jul 25, 2022, David Matlack wrote:
> > > This series renames the perf_test_util to memstress. patch 1 renames the files
> > > perf_test_util.[ch] to memstress.[ch], and patch 2 replaces the perf_test_
> > > prefix on symbols with memstress_.
> > >
> > > The reason for this rename, as with any rename, is to improve readability.
> > > perf_test_util is too generic and does not describe at all what the library
> > > does, other than being used for perf tests.
> > >
> > > I considered a lot of different names (naming is hard) and eventually settled
> > > on memstress for a few reasons:
> > >
> > >  - "memstress" better describes the functionality proveded by this library,
> > >    which is to run a VM that reads/writes to memory from all vCPUs in parallel
> > >    (i.e. stressing VM memory).
> >
> > Hmm, but the purpose of the library isn't to stress VM memory so much as it is to
> > stress KVM's MMU. And typically "stress" tests just hammer a resource to try and
> > make it fail, whereas measuring performance is one of the main
> >
> > In other words, IMO it would be nice to keep "perf" in there somehwere.
> 
> The reasons I leaned toward "stress" rather than "perf" is that this
> library itself does not measure performance (it's just a workload) and
> it's not always used for performance tests (e.g.
> memslot_modification_stress_test.c).

Yeah, I don't disagree on any point, it's purely that memstress makes me think of
memtest (the pre-boot test that blasts memory with patterns to detect bad DRAM).

> > Maybe mmu_perf or something along those lines?
> 
> How about "memperf"? "mmu_perf" makes me think it'd be explicitly
> measuring the performance of MMU operations.

Let's go with your original "memstress".  I like how it looks in code, and once I
get past the initial "memtest" association, it's a good fit.

> Another contender was "memstorm", but I thought it might be too cute.

Heh.  mem_minions?  Then we can have "mm_args" and really confuse everyone.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77D34CA55C
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 13:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241996AbiCBM70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 07:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbiCBM7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 07:59:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 191B02FFC0
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 04:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646225921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ls8zGvhed1PmT8PXmpNjbgsZ/iW5f7ZrkDvrKVFI5BU=;
        b=jPjgeR4mZAPP5nUdwpQ/IBwdSHnK64G1cBajxPAW7XyCD9bEY666E8W27aSF9pWsHCc10G
        CakiURxBVhUIEerk2+QC514WdXXnN5GiVInllOTV6nj8rkU8S+XwkgY62d8LCyjUVRWdYA
        CrDkGCC4T2fz4k9Mrr+OAVtWhwhhUSE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-K0kysdpeONyo2wfI8EtMNw-1; Wed, 02 Mar 2022 07:58:40 -0500
X-MC-Unique: K0kysdpeONyo2wfI8EtMNw-1
Received: by mail-wm1-f70.google.com with SMTP id 3-20020a05600c230300b00384e15ceae4so443205wmo.7
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 04:58:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ls8zGvhed1PmT8PXmpNjbgsZ/iW5f7ZrkDvrKVFI5BU=;
        b=tjPWRkjg0NwAfa/+dUKyKJAFatyS2I+k4y2up1SrqgxA2rdNqPg6MEcM82Z1GC+WkG
         /5e6cpYJOim19jTM2cbMcfjJkwUd8H3B8uAO5zoErr7Lhliqha2t62H1DEw/g9/TDAeF
         CJHXAl/XKq34J98+r6CWNd0/IWGF2ZEV6J3gPK77sq6UFCSATsk6APkRNKf1wpJPG3P9
         g/jxqSNPMAHiOgkTxDIHaHQbj8PvK5ZTxcza/nHiTj0KjwzYKYFaqDsh7I5km3xNkcEl
         w3ZpHHkzNGD5sVIM7+/u42VIg/twi91f7aGfA3ykOLYJrX7kWKcNKRSYS0zwF/Z+cUz+
         Lu8w==
X-Gm-Message-State: AOAM530raxG3uMemdWthPPxe7y+XpclsUtGNWEvqCQ2xl0Ocq+cSVyDo
        TJjJpIGFGOgVTevCfd1PTlxWxIYt2tB1ByVwpW9s2RzN2hipN2zFutP6PIKKCdIp5E+TFQljNF4
        Y1MJ1Tka2cMJ9
X-Received: by 2002:adf:a198:0:b0:1f0:2477:3b79 with SMTP id u24-20020adfa198000000b001f024773b79mr3317317wru.24.1646225919055;
        Wed, 02 Mar 2022 04:58:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzhoJzzmGubO9T+P2rp5sbzN9oKf63KELhC21OUOh6oTtXAlLF5dbd9EHC5QGAjjnU8td/9tg==
X-Received: by 2002:adf:a198:0:b0:1f0:2477:3b79 with SMTP id u24-20020adfa198000000b001f024773b79mr3317289wru.24.1646225918794;
        Wed, 02 Mar 2022 04:58:38 -0800 (PST)
Received: from redhat.com ([2a10:8006:355c:0:48d6:b937:2fb9:b7de])
        by smtp.gmail.com with ESMTPSA id z16-20020a7bc7d0000000b00381004c643asm5397040wmk.30.2022.03.02.04.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 04:58:36 -0800 (PST)
Date:   Wed, 2 Mar 2022 07:58:33 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Laszlo Ersek <lersek@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        linux-hyperv@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alexander Graf <graf@amazon.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        adrian@parity.io,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Linux PM <linux-pm@vger.kernel.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: propagating vmgenid outward and upward
Message-ID: <20220302074503-mutt-send-email-mst@kernel.org>
References: <Yh4+9+UpanJWAIyZ@zx2c4.com>
 <223f858c-34c5-3ccd-b9e8-7585a976364d@redhat.com>
 <Yh5JwK6toc/zBNL7@zx2c4.com>
 <20220301121419-mutt-send-email-mst@kernel.org>
 <CAHmME9qieLUDVoPYZPo=N8NCL1T-RzQ4p7kCFv3PKFUkhWZPsw@mail.gmail.com>
 <20220302031738-mutt-send-email-mst@kernel.org>
 <CAHmME9pf-bjnZuweoLqoFEmPy1OK7ogEgGEAva1T8uVTufhCuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pf-bjnZuweoLqoFEmPy1OK7ogEgGEAva1T8uVTufhCuw@mail.gmail.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022 at 12:26:27PM +0100, Jason A. Donenfeld wrote:
> Hey Michael,
> 
> Thanks for the benchmark.
> 
> On Wed, Mar 2, 2022 at 9:30 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > So yes, the overhead is higher by 50% which seems a lot but it's from a
> > very small number, so I don't see why it's a show stopper, it's not by a
> > factor of 10 such that we should sacrifice safety by default. Maybe a
> > kernel flag that removes the read replacing it with an interrupt will
> > do.
> >
> > In other words, premature optimization is the root of all evil.
> 
> Unfortunately I don't think it's as simple as that for several reasons.
> 
> First, I'm pretty confident a beefy Intel machine can mostly hide
> non-dependent comparisons in the memory access and have the problem
> mostly go away. But this is much less the case on, say, an in-order
> MIPS32r2, which isn't just "some crappy ISA I'm using for the sake of
> argument," but actually the platform on which a lot of networking and
> WireGuard stuff runs, so I do care about it. There, we have 4
> reads/comparisons which can't pipeline nearly as well.

Sure. Want to try running some benchmarks on that platform?
Presumably you have access to such a box, right?


> There's also the atomicity aspect, which I think makes your benchmark
> not quite accurate. Those 16 bytes could change between the first and
> second word (or between the Nth and N+1th word for N<=3 on 32-bit).
> What if in that case the word you read second doesn't change, but the
> word you read first did? So then you find yourself having to do a
> hi-lo-hi dance.
> And then consider the 32-bit case, where that's even
> more annoying. This is just one of those things that comes up when you
> compare the semantics of a "large unique ID" and "word-sized counter",
> as general topics. (My suggestion is that vmgenid provide both.)

I don't see how this matters for any applications at all. Feel free to
present a case that would be race free with a word but not a 16
byte value, I could not imagine one. It's human to err of course.

>
> Finally, there's a slightly storage aspect, where adding 16 bytes to a
> per-key struct is a little bit heavier than adding 4 bytes and might
> bust a cache line without sufficient care, care which always has some
> cost in one way or another.
> 
> So I just don't know if it's realistic to impose a 16-byte per-packet
> comparison all the time like that. I'm familiar with WireGuard
> obviously, but there's also cifs and maybe even wifi and bluetooth,
> and who knows what else, to care about too. Then there's the userspace
> discussion. I can't imagine a 16-byte hotpath comparison being
> accepted as implementable.

I think this hinges on benchmarking results. Want to start with
my silly benchmark at least? If you can't measure an order of
magnitude gain then I think any effect on wireguard will be in the
noise.


> > And I feel if linux
> > DTRT and reads the 16 bytes then hypervisor vendors will be motivated to
> > improve and add a 4 byte unique one. As long as linux is interrupt
> > driven there's no motivation for change.
> 
> I reeeeeally don't want to get pulled into the politics of this on the
> hypervisor side. I assume an improved thing would begin with QEMU and
> Firecracker or something collaborating because they're both open
> source and Amazon people seem interested.

I think it would begin with a benchmark showing there's even any
measureable performance to be gained by switching the semantics.

> And then pressure builds for
> Microsoft and VMware to do it on their side. And then we get this all
> nicely implemented in the kernel. In the meantime, though, I'm not
> going to refuse to address the problem entirely just because the
> virtual hardware is less than perfect; I'd rather make the most with
> what we've got while still being somewhat reasonable from an
> implementation perspective.
> 
> Jason

Right but given you are trading security off for performance, it matters
a lot what the performance gain is.

-- 
MST


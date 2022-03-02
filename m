Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 170D34CA39F
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241395AbiCBL1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241297AbiCBL1a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:27:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BA66622D;
        Wed,  2 Mar 2022 03:26:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2419161804;
        Wed,  2 Mar 2022 11:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16F9C340F1;
        Wed,  2 Mar 2022 11:26:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FLziEXpf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646220402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fufxSPRIOrmbnPbDC6hJ7ttxshIW5aGS9pJhSWhnCM4=;
        b=FLziEXpf2l0WTAhzSsctWfFPyoNczuf0yET5OvrmfeoHkbQdJJUnS5q+NI+vrChRlkMr3x
        174jqFOO+Z3Pr5c79Gii5Ryw0Vd9q9Ey0Hlr2keq9mQvPlFbNmRp37DUVNhIihEZDWJZG5
        HjPNCU02XchGOwdc6y1fEsx970Bts6c=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a4166dc6 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 2 Mar 2022 11:26:41 +0000 (UTC)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-2dbc48104beso13440867b3.5;
        Wed, 02 Mar 2022 03:26:40 -0800 (PST)
X-Gm-Message-State: AOAM531CCPFcEGKBbRNRGtYXkH9nqJ+pu4T+FHrfbpHSC9V4hrNo0nv0
        rosp0lWDaH02FtNz1efiEeJ2262x3AcFLqhgPQc=
X-Google-Smtp-Source: ABdhPJxbaslGOWNMYlqRkibxJ2ICArMnaBOXMWHprS75pC5WtpgRWsCTpsPEORMZE4FcmdBod69a3hNDLa7CXaxndsk=
X-Received: by 2002:a81:1143:0:b0:2db:ccb4:b0a1 with SMTP id
 64-20020a811143000000b002dbccb4b0a1mr9951120ywr.499.1646220398624; Wed, 02
 Mar 2022 03:26:38 -0800 (PST)
MIME-Version: 1.0
References: <Yh4+9+UpanJWAIyZ@zx2c4.com> <223f858c-34c5-3ccd-b9e8-7585a976364d@redhat.com>
 <Yh5JwK6toc/zBNL7@zx2c4.com> <20220301121419-mutt-send-email-mst@kernel.org>
 <CAHmME9qieLUDVoPYZPo=N8NCL1T-RzQ4p7kCFv3PKFUkhWZPsw@mail.gmail.com> <20220302031738-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220302031738-mutt-send-email-mst@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 2 Mar 2022 12:26:27 +0100
X-Gmail-Original-Message-ID: <CAHmME9pf-bjnZuweoLqoFEmPy1OK7ogEgGEAva1T8uVTufhCuw@mail.gmail.com>
Message-ID: <CAHmME9pf-bjnZuweoLqoFEmPy1OK7ogEgGEAva1T8uVTufhCuw@mail.gmail.com>
Subject: Re: propagating vmgenid outward and upward
To:     "Michael S. Tsirkin" <mst@redhat.com>
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
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Linux PM <linux-pm@vger.kernel.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Michael,

Thanks for the benchmark.

On Wed, Mar 2, 2022 at 9:30 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> So yes, the overhead is higher by 50% which seems a lot but it's from a
> very small number, so I don't see why it's a show stopper, it's not by a
> factor of 10 such that we should sacrifice safety by default. Maybe a
> kernel flag that removes the read replacing it with an interrupt will
> do.
>
> In other words, premature optimization is the root of all evil.

Unfortunately I don't think it's as simple as that for several reasons.

First, I'm pretty confident a beefy Intel machine can mostly hide
non-dependent comparisons in the memory access and have the problem
mostly go away. But this is much less the case on, say, an in-order
MIPS32r2, which isn't just "some crappy ISA I'm using for the sake of
argument," but actually the platform on which a lot of networking and
WireGuard stuff runs, so I do care about it. There, we have 4
reads/comparisons which can't pipeline nearly as well.

There's also the atomicity aspect, which I think makes your benchmark
not quite accurate. Those 16 bytes could change between the first and
second word (or between the Nth and N+1th word for N<=3 on 32-bit).
What if in that case the word you read second doesn't change, but the
word you read first did? So then you find yourself having to do a
hi-lo-hi dance. And then consider the 32-bit case, where that's even
more annoying. This is just one of those things that comes up when you
compare the semantics of a "large unique ID" and "word-sized counter",
as general topics. (My suggestion is that vmgenid provide both.)

Finally, there's a slightly storage aspect, where adding 16 bytes to a
per-key struct is a little bit heavier than adding 4 bytes and might
bust a cache line without sufficient care, care which always has some
cost in one way or another.

So I just don't know if it's realistic to impose a 16-byte per-packet
comparison all the time like that. I'm familiar with WireGuard
obviously, but there's also cifs and maybe even wifi and bluetooth,
and who knows what else, to care about too. Then there's the userspace
discussion. I can't imagine a 16-byte hotpath comparison being
accepted as implementable.

> And I feel if linux
> DTRT and reads the 16 bytes then hypervisor vendors will be motivated to
> improve and add a 4 byte unique one. As long as linux is interrupt
> driven there's no motivation for change.

I reeeeeally don't want to get pulled into the politics of this on the
hypervisor side. I assume an improved thing would begin with QEMU and
Firecracker or something collaborating because they're both open
source and Amazon people seem interested. And then pressure builds for
Microsoft and VMware to do it on their side. And then we get this all
nicely implemented in the kernel. In the meantime, though, I'm not
going to refuse to address the problem entirely just because the
virtual hardware is less than perfect; I'd rather make the most with
what we've got while still being somewhat reasonable from an
implementation perspective.

Jason

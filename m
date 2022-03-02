Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4984CA6BE
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 14:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241771AbiCBN4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 08:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbiCBN4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 08:56:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152DF2B18E;
        Wed,  2 Mar 2022 05:55:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FEF560B13;
        Wed,  2 Mar 2022 13:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB550C004E1;
        Wed,  2 Mar 2022 13:55:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kpzYHDtU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646229339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SpVcuA/WXuSF2VylmDTidLRP/fq6dnIG3IJK6i0yAko=;
        b=kpzYHDtUAlCnEdVEte//Tt36NxH+/Ez0o+kl3YdWmtGk9TZCjSHm6oGL/AbSTrC8Y1PuRg
        jZ3NV3d2m9tjm6vre8HArSM79be/kQc4jqSkH3qUrcSXgTDy8VV6MN3iqBxSC6PUytw5x2
        eJFYg/LLjTsXb0gq+k1Xln0G4fDjTNE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fd2dbd60 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 2 Mar 2022 13:55:38 +0000 (UTC)
Date:   Wed, 2 Mar 2022 14:55:29 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
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
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Linux PM <linux-pm@vger.kernel.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: propagating vmgenid outward and upward
Message-ID: <Yh93UZMQSYCe2LQ7@zx2c4.com>
References: <Yh4+9+UpanJWAIyZ@zx2c4.com>
 <223f858c-34c5-3ccd-b9e8-7585a976364d@redhat.com>
 <Yh5JwK6toc/zBNL7@zx2c4.com>
 <20220301121419-mutt-send-email-mst@kernel.org>
 <CAHmME9qieLUDVoPYZPo=N8NCL1T-RzQ4p7kCFv3PKFUkhWZPsw@mail.gmail.com>
 <20220302031738-mutt-send-email-mst@kernel.org>
 <CAHmME9pf-bjnZuweoLqoFEmPy1OK7ogEgGEAva1T8uVTufhCuw@mail.gmail.com>
 <20220302074503-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220302074503-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Michael,

On Wed, Mar 02, 2022 at 07:58:33AM -0500, Michael S. Tsirkin wrote:
> > There's also the atomicity aspect, which I think makes your benchmark
> > not quite accurate. Those 16 bytes could change between the first and
> > second word (or between the Nth and N+1th word for N<=3 on 32-bit).
> > What if in that case the word you read second doesn't change, but the
> > word you read first did? So then you find yourself having to do a
> > hi-lo-hi dance.
> > And then consider the 32-bit case, where that's even
> > more annoying. This is just one of those things that comes up when you
> > compare the semantics of a "large unique ID" and "word-sized counter",
> > as general topics. (My suggestion is that vmgenid provide both.)
> 
> I don't see how this matters for any applications at all. Feel free to
> present a case that would be race free with a word but not a 16
> byte value, I could not imagine one. It's human to err of course.

Word-size reads happen all at once on systems that Linux supports,
whereas this is not the case for 16 bytes (with a few niche exceptions
like cmpxchg16b and such). If you read the counter atomically, you can
check to see whether it's changed just after encrypting but before
transmitting and not transmit if it has changed, and voila, no race.
With 16 bytes, synchronization of that read is pretty tricky (though
maybe not all together impossible), because, as I mentioned, the first
word might have changed by the time you read a matching second word. I'm
sure you're familiar with the use of seqlocks in the kernel for solving
a somewhat related problem.

Jason

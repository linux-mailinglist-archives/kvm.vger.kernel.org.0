Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5409B4CAA46
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 17:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242402AbiCBQdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 11:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242543AbiCBQdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 11:33:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1B7C6255;
        Wed,  2 Mar 2022 08:32:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A2F6617F7;
        Wed,  2 Mar 2022 16:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDCBC004E1;
        Wed,  2 Mar 2022 16:32:16 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Jx2KF4SC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646238734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pn15odJ1axHr1tSHXKM6R6gy8OQYz+UX/tuJV8kTZOI=;
        b=Jx2KF4SCMS6oQ81ruL+PmUOxb313LAgFJH4b+Nm/AbpnaHEQrJ93HFFJlkrZFljIclR1Ig
        7MjMDAT88vIHvYQ5jVCXMswnqvnSTAn/DRep7zjTiB1RFfgW3eKlFxCp1420xGYalEM2Wc
        ntxUnKyAuMw/wp27G1pbbLokW2Kvk8w=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6b026337 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 2 Mar 2022 16:32:14 +0000 (UTC)
Date:   Wed, 2 Mar 2022 17:32:07 +0100
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
Message-ID: <Yh+cB5bWarl8CFN1@zx2c4.com>
References: <CAHmME9qieLUDVoPYZPo=N8NCL1T-RzQ4p7kCFv3PKFUkhWZPsw@mail.gmail.com>
 <20220302031738-mutt-send-email-mst@kernel.org>
 <CAHmME9pf-bjnZuweoLqoFEmPy1OK7ogEgGEAva1T8uVTufhCuw@mail.gmail.com>
 <20220302074503-mutt-send-email-mst@kernel.org>
 <Yh93UZMQSYCe2LQ7@zx2c4.com>
 <20220302092149-mutt-send-email-mst@kernel.org>
 <CAHmME9rf7hQP78kReP2diWNeX=obPem=f8R-dC7Wkpic2xmffg@mail.gmail.com>
 <20220302101602-mutt-send-email-mst@kernel.org>
 <Yh+PET49oHNpxn+H@zx2c4.com>
 <20220302111737-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220302111737-mutt-send-email-mst@kernel.org>
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

On Wed, Mar 02, 2022 at 11:22:46AM -0500, Michael S. Tsirkin wrote:
> > Because that 16 byte read of vmgenid is not atomic. Let's say you read
> > the first 8 bytes, and then the VM is forked.
> 
> But at this point when VM was forked plaintext key and nonce are all in
> buffer, and you previously indicated a fork at this point is harmless.
> You wrote "If it changes _after_ that point of check ... it doesn't
> matter:"

Ahhh, fair point. I think you're right.

Alright, so all we're talking about here is an ordinary 16-byte read,
and 16 bytes of storage per keypair, and a 16-byte comparison.

Still seems much worse than just having a single word...

Jason

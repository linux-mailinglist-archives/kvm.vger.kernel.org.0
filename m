Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27AF74C907C
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 17:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbiCAQgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 11:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236162AbiCAQgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 11:36:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6E463E3;
        Tue,  1 Mar 2022 08:35:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2D57608D5;
        Tue,  1 Mar 2022 16:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2D8C340EE;
        Tue,  1 Mar 2022 16:35:33 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="POdsqroe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646152531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1nOiauBbKjq2GBtfhMLzeD+6fw81ge7D0lpL4B2vR4M=;
        b=POdsqroeNiU2Fam7MP0fPCEPjinxMcgSl7jitNKrqAecVHoDyy1kYm1TiHzZXEPsUs5Cph
        mWVOl7LIgk0IKZAtatreikQb+OGH0M1JQK9Ms7mSYH4GpAU1+mLQmh+BNRKOvuRObCUGRr
        qvoLzNedtT0xoLOy9KSmqi6ARfFcgzg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1e38f283 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 1 Mar 2022 16:35:31 +0000 (UTC)
Date:   Tue, 1 Mar 2022 17:35:25 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, linux-hyperv@vger.kernel.org,
        linux-crypto@vger.kernel.org, graf@amazon.com,
        mikelley@microsoft.com, gregkh@linuxfoundation.org,
        adrian@parity.io, lersek@redhat.com, berrange@redhat.com,
        linux@dominikbrodowski.net, jannh@google.com, rafael@kernel.org,
        len.brown@intel.com, pavel@ucw.cz, linux-pm@vger.kernel.org,
        colmmacc@amazon.com, tytso@mit.edu, arnd@arndb.de
Subject: Re: propagating vmgenid outward and upward
Message-ID: <Yh5LTd1k1uB1eGFF@zx2c4.com>
References: <Yh4+9+UpanJWAIyZ@zx2c4.com>
 <20220301111459-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220301111459-mutt-send-email-mst@kernel.org>
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

On Tue, Mar 01, 2022 at 11:21:38AM -0500, Michael S. Tsirkin wrote:
> > If we had a "pull" model, rather than just expose a 16-byte unique
> > identifier, the vmgenid virtual hardware would _also_ expose a
> > word-sized generation counter, which would be incremented every time the
> > unique ID changed. Then, every time we would touch the RNG, we'd simply
> > do an inexpensive check of this memremap()'d integer, and reinitialize
> > with the unique ID if the integer changed. In this way, the race would
> > be entirely eliminated. We would then be able to propagate this outwards
> > to other drivers, by just exporting an extern symbol, in the manner of
> > `jiffies`, and propagate it upwards to userspace, by putting it in the
> > vDSO, in the manner of gettimeofday. And like that, there'd be no
> > terrible async thing and things would work pretty easily.
> 
> I am not sure what the difference is though. So we have a 16 byte unique
> value and you would prefer a dword counter. How is the former not a
> superset of the later?  

Laszlo just asked the same question, which I answered here:
<https://lore.kernel.org/lkml/Yh5JwK6toc%2FzBNL7@zx2c4.com/>. You have
to read the full 16 bytes. You can't safely just read the first 4 or 8
or something, because it's a "unique ID" rather than a counter. That
seems like a needlessly expensive thing to do on each-and-every packet.

> I'm not sure how safe it is to expose it to
> userspace specifically, but rest of text talks about exposing it to a
> kernel driver so maybe not an issue? So what makes interrupt driven
> required, and why not just remap and read existing vmgenid in the pull
> manner?  What did I miss?

I don't really understand your question, but guessing your meaning: I'm
not talking about exposing the actual 16-byte value to any other
drivers, but just notifying them that their sessions should be dropped.
If it's easier to think about this in code, grep for wg_pm_notification(),
and consider that it'd be changing this code:

        if (action != PM_HIBERNATION_PREPARE && action != PM_SUSPEND_PREPARE)
                return 0;

into:

        if (action != PM_HIBERNATION_PREPARE && action != PM_SUSPEND_PREPARE &&
	    action != PM_VMFORK_POST)
                return 0;

But perhaps I misunderstood this part of your question?

Jason

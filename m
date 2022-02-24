Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD0B4C29E2
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 11:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbiBXKxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 05:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbiBXKxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 05:53:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55E427AA00;
        Thu, 24 Feb 2022 02:53:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F982B82526;
        Thu, 24 Feb 2022 10:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9397C340E9;
        Thu, 24 Feb 2022 10:53:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="g1QXx2ES"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645699986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qJQbqpgTaOg8/vz4RU4R/Zyt33JoVSORCtRKA9BH80s=;
        b=g1QXx2ESzo2gs168k0660qWPcFbrYqN8feVSqkQM+KGMitKZDZZbiDmC+8lfNSWovzr9Rm
        a87Zi6YUrByAEeQUxMFRQj724QStsPZey8EwtZJaHYmWqO/8sbtywUWykhRwLrtfAFdt5a
        ksWR20+MaJYUa7bnYhHZoFIeZE1+AvA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1ff307f2 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 24 Feb 2022 10:53:05 +0000 (UTC)
Date:   Thu, 24 Feb 2022 11:53:02 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, adrian@parity.io, dwmw@amazon.co.uk,
        acatan@amazon.com, colmmacc@amazon.com, sblbir@amazon.com,
        raduweis@amazon.com, jannh@google.com, gregkh@linuxfoundation.org,
        tytso@mit.edu
Subject: Re: [PATCH RFC v1 0/2] VM fork detection for RNG
Message-ID: <YhdjjgGgS7SBhSvu@zx2c4.com>
References: <20220223131231.403386-1-Jason@zx2c4.com>
 <234d7952-0379-e3d9-5e02-5eba171024a0@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <234d7952-0379-e3d9-5e02-5eba171024a0@amazon.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

Strangely your message never made it to me, and I had to pull this out
of Lore after seeing Daniel's reply to it. I wonder what's up.

On Thu, Feb 24, 2022 at 09:53:59AM +0100, Alexander Graf wrote:
> The main problem with VMGenID is that it is inherently racy. There will 
> always be a (short) amount of time where the ACPI notification is not 
> processed, but the VM could use its RNG to for example establish TLS 
> connections.
> 
> Hence we as the next step proposed a multi-stage quiesce/resume 
> mechanism where the system is aware that it is going into suspend - can 
> block network connections for example - and only returns to a fully 
> functional state after an unquiesce phase:
> 
>    https://github.com/systemd/systemd/issues/20222
> 
> Looking at the issue again, it seems like we completely missed to follow 
> up with a PR to implement that functionality :(.
> 
> What exact use case do you have in mind for the RNG/VMGenID update? Can 
> you think of situations where the race is not an actual concern?

No, I think the race is something that remains a problem for the
situations I care about. There are simpler ways of fixing that -- just
expose a single incrementing integer so that it can be checked every
time the RNG does something, without being expensive, via the same
mechanism -- and then you don't need any complexity. But anyway, that
doesn't exist right now, so this series tries to implement something for
what does exist and is already supported by multiple hypervisors. I'd
suggest sending a proposal for an improved mechanism as part of a
different thread, and pull the various parties into that, and we can
make something good for the future. I'm happy to implement whatever the
virtual hardware exposes.

Jason

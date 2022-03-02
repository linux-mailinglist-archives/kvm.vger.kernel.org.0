Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF934CA847
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 15:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243136AbiCBOge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 09:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243105AbiCBOgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 09:36:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E67C4B67;
        Wed,  2 Mar 2022 06:35:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1980F615ED;
        Wed,  2 Mar 2022 14:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65885C340ED;
        Wed,  2 Mar 2022 14:35:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="TYEG0cFg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646231746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XGuMnK4OOgPCMwUmyaWZFFbNaYrxtgoILBjeCR8rojk=;
        b=TYEG0cFgyV9/JXbncaM4Z4+kmqmWkOAaZHoc8I/mCAGlDB9vYaT74K6vhubYquTDWAr+qk
        v4va5LWGM9xSmKOFJQRJgMOXGQqwJBuBgQz3jKkYz4vmBqYRv7Uvd1SvjJO2p45ulW0WKc
        B12ugOBKyN0QfjbUkssv2iT7UBk9rnE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6f2e4d35 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 2 Mar 2022 14:35:45 +0000 (UTC)
Date:   Wed, 2 Mar 2022 15:35:40 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, linux-hyperv@vger.kernel.org,
        linux-crypto@vger.kernel.org, graf@amazon.com,
        mikelley@microsoft.com, gregkh@linuxfoundation.org,
        adrian@parity.io, lersek@redhat.com, berrange@redhat.com,
        linux@dominikbrodowski.net, jannh@google.com, mst@redhat.com,
        rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz,
        linux-pm@vger.kernel.org, colmmacc@amazon.com, tytso@mit.edu,
        arnd@arndb.de
Subject: Re: propagating vmgenid outward and upward
Message-ID: <Yh+AvDzzxGjt240m@zx2c4.com>
References: <Yh4+9+UpanJWAIyZ@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yh4+9+UpanJWAIyZ@zx2c4.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey again,

On Tue, Mar 01, 2022 at 04:42:47PM +0100, Jason A. Donenfeld wrote:
> For (B), it's a little bit trickier. But I think our options follow the
> same rubric. We can expose a generation counter in the vDSO, with
> semantics akin to the extern integer I described above. Or we could
> expose that counter in a file that userspace could poll() on and receive
> notifications that way. Or perhaps a third way. I'm all ears here.
> Alex's team from Amazon last year proposed something similar to the vDSO
> idea, except using mmap on a sysfs file, though from what I can tell,
> that wound up being kind of complicated. Due to the fact that we're
> _already_ racy, I think I'm most inclined at this point toward the
> poll() approach for the same reasons as I prefer a notifier_block. But
> on userspace I could be convinced otherwise, and I'd be interested in
> totally different ideas here too.

I implemented the poll() case here in 15 lines of code and found it
remarkably simple to do:

https://lore.kernel.org/lkml/20220302143331.654426-1-Jason@zx2c4.com/

This is just a PoC/RFC for the sake of having something tangible to look
at for this thread. It is notable to me, though, that implementing this
was so minimal.

Regards,
Jason

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F474C904E
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 17:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbiCAQ3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 11:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiCAQ3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 11:29:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7915BBB4;
        Tue,  1 Mar 2022 08:29:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3712B819EB;
        Tue,  1 Mar 2022 16:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C10FC340EE;
        Tue,  1 Mar 2022 16:28:56 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="D7UrjJ4m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646152134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=azUn2ki7Mj00I4cZyGYyVEVMYgwAwBTMCuqvy/VXMbE=;
        b=D7UrjJ4maBEi4nEme98+YCPJVmJo8lVsaJoNewrcfQObk6P6YpRz+3CgWVQ+gGINDw/ivF
        ES5me9CToU/6hwtUO3skAMWGsSGQWTzhLNI/0Mc6pEtAN2qew//z0nGtg2BwltGPhDDtcM
        V4zLgBtAlAw4iOeKha7WaVAvWwGJTkA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6fec32bc (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 1 Mar 2022 16:28:53 +0000 (UTC)
Date:   Tue, 1 Mar 2022 17:28:48 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Laszlo Ersek <lersek@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, linux-hyperv@vger.kernel.org,
        linux-crypto@vger.kernel.org, graf@amazon.com,
        mikelley@microsoft.com, gregkh@linuxfoundation.org,
        adrian@parity.io, berrange@redhat.com, linux@dominikbrodowski.net,
        jannh@google.com, mst@redhat.com, rafael@kernel.org,
        len.brown@intel.com, pavel@ucw.cz, linux-pm@vger.kernel.org,
        colmmacc@amazon.com, tytso@mit.edu, arnd@arndb.de
Subject: Re: propagating vmgenid outward and upward
Message-ID: <Yh5JwK6toc/zBNL7@zx2c4.com>
References: <Yh4+9+UpanJWAIyZ@zx2c4.com>
 <223f858c-34c5-3ccd-b9e8-7585a976364d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <223f858c-34c5-3ccd-b9e8-7585a976364d@redhat.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Laszlo,

On Tue, Mar 01, 2022 at 05:15:21PM +0100, Laszlo Ersek wrote:
> > If we had a "pull" model, rather than just expose a 16-byte unique
> > identifier, the vmgenid virtual hardware would _also_ expose a
> > word-sized generation counter, which would be incremented every time the
> > unique ID changed. Then, every time we would touch the RNG, we'd simply
> > do an inexpensive check of this memremap()'d integer, and reinitialize
> > with the unique ID if the integer changed.
> 
> Does the vmgenid spec (as-is) preclude the use of the 16-byte identifier
> like this?
> 
> After all, once you locate the identifier via the ADDR object, you could
> perhaps consult it every time you were about to touch the RNG.

No, you could in fact do this, and there'd be nothing wrong with that
from a spec perspective. You could even vDSO it all the way through
onward to userspace. However, doing a 16-byte atomic memcmp on
each-and-every packet is really a non-starter. For that kind of "check
it in the hot path" thing to be viable, you really want it to be a
counter that is word-sized. The "pull"-model involves pulling on every
single packet in order to be better than the "push"-model. Anyway, even
with a word-sized counter, it's unclear whether the costs of checking on
every packet would be worth it to everyone, but at least it's more
tenable than a 16-byte whammy.

Jason

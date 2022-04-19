Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813D0507176
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 17:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245425AbiDSPPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 11:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244276AbiDSPPm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 11:15:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83E535847;
        Tue, 19 Apr 2022 08:12:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80498B81A3C;
        Tue, 19 Apr 2022 15:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873D8C385A7;
        Tue, 19 Apr 2022 15:12:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Q/37OvJm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1650381170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MQyU07hi01iEyPXxllEOCsC9A0SZXJB5Wi7OpTYio9w=;
        b=Q/37OvJmn6L6JA4hxc+U0Bn3ttmZ0CZK7DJgmf01GPUpJjg128RaHv5HvvhszqeqWVGnDL
        l2SlbN/Xi0ms/oUYvl2yitT4K4ENydlAVTCInOxrGQapJh2v0VztNLHKWKgpPG0QUe+Y1P
        ctRzvD0PsnFwOfRBcf+wRwQBHLblAwA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 275d05c0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 19 Apr 2022 15:12:50 +0000 (UTC)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-2edbd522c21so175482327b3.13;
        Tue, 19 Apr 2022 08:12:48 -0700 (PDT)
X-Gm-Message-State: AOAM533gVCPqMvHGE/tc0zxBalXqRCbGFQ8VeIEKp8ciYRx1Rox1hYxO
        Ls3I2/BcRbpBLbDfvj+sJVaaZvyqGlYZereFgXY=
X-Google-Smtp-Source: ABdhPJwPT8kpwudgm4aOLhhyxVPvw6QiVqCwGpv5AaqyiB3KI2pHaKNZHoMfD/PEIqVraDr3btr5C9vb1YaKvou13Fo=
X-Received: by 2002:a0d:c005:0:b0:2eb:d29d:8bf5 with SMTP id
 b5-20020a0dc005000000b002ebd29d8bf5mr17186902ywd.404.1650381167579; Tue, 19
 Apr 2022 08:12:47 -0700 (PDT)
MIME-Version: 1.0
References: <Yh4+9+UpanJWAIyZ@zx2c4.com> <c5181fb5-38fb-f261-9de5-24655be1c749@amazon.com>
 <CAHmME9rTMDkE7UA3_wg87mrDVYps+YaHw+dZwF0EbM0zC4pQQw@mail.gmail.com> <47137806-9162-0f60-e830-1a3731595c8c@amazon.com>
In-Reply-To: <47137806-9162-0f60-e830-1a3731595c8c@amazon.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 19 Apr 2022 17:12:36 +0200
X-Gmail-Original-Message-ID: <CAHmME9pwfKfKp_qqbmAO5tEaQSZ5srCO5COThK3vWZR4avRF1g@mail.gmail.com>
Message-ID: <CAHmME9pwfKfKp_qqbmAO5tEaQSZ5srCO5COThK3vWZR4avRF1g@mail.gmail.com>
Subject: Re: propagating vmgenid outward and upward
To:     Alexander Graf <graf@amazon.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        linux-hyperv@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        adrian@parity.io, Laszlo Ersek <lersek@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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

Hey Alex,

On Thu, Mar 10, 2022 at 12:18 PM Alexander Graf <graf@amazon.com> wrote:
> I agree on the slightly racy compromise and that it's a step into the
> right direction. Doing this is a no brainer IMHO and I like the proc
> based poll approach.

Alright. I'm going to email a more serious patch for that in the next
few hours and you can have a look. Let's do that for 5.19.

> I have an additional problem you might have an idea for with the poll
> based path. In addition to the clone notification, I'd need to know at
> which point everyone who was listening to a clone notification is
> finished acting up it. If I spawn a tiny VM to do "work", I want to know
> when it's safe to hand requests into it. How do I find out when that
> point in time is?

Seems tricky to solve. Even a count of current waiters and a
generation number won't be sufficient, since it wouldn't take into
account users who haven't _yet_ gotten to waiting. But maybe it's not
the right problem to solve? Or somehow not necessary? For example, if
the problem is a bit more constrained a solution becomes easier: you
have a fixed/known set of readers that you know about, and you
guarantee that they're all waiting before the fork. Then after the
fork, they all do something to alert you in their poll()er, and you
count up how many alerts you get until it matches the number of
expected waiters. Would that work? It seems like anything more general
than that is just butting heads with the racy compromise we're already
making.

Jason

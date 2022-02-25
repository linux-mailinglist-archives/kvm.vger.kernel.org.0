Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3874C4425
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 13:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240436AbiBYMCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 07:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240420AbiBYMC2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 07:02:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2BEFBF05;
        Fri, 25 Feb 2022 04:01:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3592961A1B;
        Fri, 25 Feb 2022 12:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B17AC340F2;
        Fri, 25 Feb 2022 12:01:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="e7rrjGXJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645790511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GohLlxwoxaOoPO6gq3rFNZF19DV6zVVxobKNLJM1ook=;
        b=e7rrjGXJDtydRXPyIDoT+OPUxWBEJJ/zwifDOp42UT7q9C8lkd+zFHiTU84mPsBAI3EV5Y
        28KvaAl1O1o5rk7b1n/OIQ8ndKsSRhOUPf3zrtRqIFP3wahS0gQDt+we92jeyUFXKppdi3
        XuWwjFDhN6+/UrfFY5Z7ZWkuMrLsDeQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 95c643cc (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 25 Feb 2022 12:01:51 +0000 (UTC)
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-2d07ae0b1bfso30734317b3.6;
        Fri, 25 Feb 2022 04:01:49 -0800 (PST)
X-Gm-Message-State: AOAM533LfuK6SOBESP0pSs/CFj42TUGJMzYFkzKJVA4EFXSlxRVSsYNT
        IoyQ1ir07/qZcAOwhuD+bKr60M7RKCCCG19fQJc=
X-Google-Smtp-Source: ABdhPJxCQEzCbIKLSycXajwp41qtjzUjR23a2R6uPz1/UKSpnSCt39obJbUOj0pGZOb3yMkzR1pQyesGew6EIssKfhc=
X-Received: by 2002:a81:1413:0:b0:2d9:d452:9c6a with SMTP id
 19-20020a811413000000b002d9d4529c6amr1051547ywu.231.1645790508130; Fri, 25
 Feb 2022 04:01:48 -0800 (PST)
MIME-Version: 1.0
References: <20220224133906.751587-1-Jason@zx2c4.com> <20220224133906.751587-3-Jason@zx2c4.com>
 <CAMj1kXE-2sknZD7o72G-ZARpfm4Q0m+im1pTLuPhPu6TkqKOPQ@mail.gmail.com> <20220225064445-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220225064445-mutt-send-email-mst@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 25 Feb 2022 13:01:37 +0100
X-Gmail-Original-Message-ID: <CAHmME9omqUy51EnUMNccewQ2UH69h2-uAR0r_B5u=RH9W+AEvw@mail.gmail.com>
Message-ID: <CAHmME9omqUy51EnUMNccewQ2UH69h2-uAR0r_B5u=RH9W+AEvw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] virt: vmgenid: introduce driver for reinitializing
 RNG on VM fork
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-hyperv@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        adrian@parity.io, "Woodhouse, David" <dwmw@amazon.co.uk>,
        Alexander Graf <graf@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, ben@skyportsystems.com,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>
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

On Fri, Feb 25, 2022 at 12:52 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >  if VIRT_DRIVERS
> > >
> > > +config VMGENID
> > > +       tristate "Virtual Machine Generation ID driver"
> > > +       default y
> >
> > Please make this default m - this code can run as a module and the
> > feature it relies on is discoverable by udev
>
> Or don't supply a default - I don't see why this has any preference.

It's inside of VIRT_DRIVERS. If you enabled VIRT_DRIVERS, you more
than likely want and need this.

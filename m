Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197CF4C92F5
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 19:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235299AbiCASZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 13:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiCASZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 13:25:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D7C55BCF;
        Tue,  1 Mar 2022 10:24:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 245A561480;
        Tue,  1 Mar 2022 18:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86A2C340F2;
        Tue,  1 Mar 2022 18:24:29 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="cPsu+Pfp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646159066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UhSvaSxnuwVg8z+lYMrcVY0V6HOk087dwrWAJX+wvNg=;
        b=cPsu+PfpQ1E+NfY2QM+mqL0MsGFB6uJQhrXq/ZPOpHqQ46Hg0jj++Y00wshljoHRmFIYXF
        sqrIz3aaStaOBaArIsWgtnsz0z2qiM7Ia9Q+X4rzhx+BpZAoD3c//ILGPSnO780HScVlDv
        ioajV2t4PXvamB22Q/Mq+I0CvJu0Avc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a7160bf9 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 1 Mar 2022 18:24:26 +0000 (UTC)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-2d07ae0b1c4so154233807b3.11;
        Tue, 01 Mar 2022 10:24:24 -0800 (PST)
X-Gm-Message-State: AOAM530P0T9Bnw/rb6P2yIpZN5irUswLb5pofA2zR3FIiqoj6EjfoYca
        TdnrBdNln/YiA6yosWBXTs8efjwmEFep3RU5xb8=
X-Google-Smtp-Source: ABdhPJzIw8Ot6KvcnZ9E6xhmQNl/dygRLAw2fnVFuv34JvBJjjinbct/exl35nFBlEkP8cMk/Ry82yLphyC5sa7l+Vc=
X-Received: by 2002:a81:1143:0:b0:2db:ccb4:b0a1 with SMTP id
 64-20020a811143000000b002dbccb4b0a1mr6755248ywr.499.1646159062762; Tue, 01
 Mar 2022 10:24:22 -0800 (PST)
MIME-Version: 1.0
References: <Yh4+9+UpanJWAIyZ@zx2c4.com> <Yh5fbe71BTT6xc8h@kroah.com>
In-Reply-To: <Yh5fbe71BTT6xc8h@kroah.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 1 Mar 2022 19:24:11 +0100
X-Gmail-Original-Message-ID: <CAHmME9oGcp7HNLeieptMKztgg7Fq4MnOuAEsiFJxsLbmjSuFCw@mail.gmail.com>
Message-ID: <CAHmME9oGcp7HNLeieptMKztgg7Fq4MnOuAEsiFJxsLbmjSuFCw@mail.gmail.com>
Subject: Re: propagating vmgenid outward and upward
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        linux-hyperv@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alexander Graf <graf@amazon.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
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

Hi Greg,

On Tue, Mar 1, 2022 at 7:01 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> A notifier block like this makes sense, but why tie onto the PM_ stuff?
> This isn't power management issues, it's a system-wide change that I am
> sure others will want to know about that doesn't reflect any power
> changes.
>
> As much as I hate adding new notifiers in the kernel, that might be all
> you need here.

You might indeed be right. I guess I was thinking that "resuming from
suspend" and "resuming from a VM fork" are kind of the same thing.
There _is_ a certain kind of similarity between the two. I was hoping
if the similarity was a strong enough one, maybe it'd make sense to do
them together rather than adding another notifier. But I suppose you
disagree, and it sounds like Rafael might too --
<https://lore.kernel.org/lkml/CAJZ5v0g+GihH_b9YvwuHzdrUVNGXOeabOznDC1vK6qLi8gtSTQ@mail.gmail.com/>.
Code-wise for me with WireGuard it's of course appealing to treat them
the same, since it's like a one line change, but if I need to add a
new notifier call there, it's not the end of the world.

Jason

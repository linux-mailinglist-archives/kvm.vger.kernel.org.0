Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969BD4C98EF
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 00:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbiCAXNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 18:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235726AbiCAXNH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 18:13:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADCC91AE0;
        Tue,  1 Mar 2022 15:12:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73577B81E95;
        Tue,  1 Mar 2022 23:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1F1C340F2;
        Tue,  1 Mar 2022 23:12:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Dwwa15li"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646176334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QVWwDfP6vCdKSXIrReokkbeYI07Avo5/7iLxJ3qVrMM=;
        b=Dwwa15lion2Yx6INZGRM8RR30ZitnRusGlT9CzLXoCxdVpdCr5DXvjzRrzg7k07EnD4GWH
        9r8Bj9vNalC7YaFb9/zxAbbO5GjK3tKRE/zZTWZAn7xkZ7/pd+9QdxImWwfep7+/3QpiUO
        gf3Pi7ZeianoIyi7RAgclPzrk8DlUNA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3e4d250c (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 1 Mar 2022 23:12:14 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id e186so6260915ybc.7;
        Tue, 01 Mar 2022 15:12:12 -0800 (PST)
X-Gm-Message-State: AOAM53015Y7OletVUxe4xXepLCksoJpZsPUJUltpohviHvbkJg9uxe5K
        t5jja5Gd1sFiSy41jpYIygwOJUxNFBteqbXdJfg=
X-Google-Smtp-Source: ABdhPJxG1EP2z5Lx925intNmaJt+8bpR2v0QoOtdNwKnXQnbrqMvRmDH6t8H149eZ3tCCAwnI0z6h3junDyhTjBtpjE=
X-Received: by 2002:a05:6902:693:b0:613:7f4f:2e63 with SMTP id
 i19-20020a056902069300b006137f4f2e63mr26499795ybt.271.1646176331461; Tue, 01
 Mar 2022 15:12:11 -0800 (PST)
MIME-Version: 1.0
References: <Yh4+9+UpanJWAIyZ@zx2c4.com> <Yh5fbe71BTT6xc8h@kroah.com>
 <CAHmME9oGcp7HNLeieptMKztgg7Fq4MnOuAEsiFJxsLbmjSuFCw@mail.gmail.com> <Yh528WPZrQn5s7vO@kroah.com>
In-Reply-To: <Yh528WPZrQn5s7vO@kroah.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 2 Mar 2022 00:12:00 +0100
X-Gmail-Original-Message-ID: <CAHmME9oxEWK6Nvra9eZBZnHKGNnWyeEzvE8d4HGy3NRPkajrvA@mail.gmail.com>
Message-ID: <CAHmME9oxEWK6Nvra9eZBZnHKGNnWyeEzvE8d4HGy3NRPkajrvA@mail.gmail.com>
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

On Tue, Mar 1, 2022 at 8:41 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Mar 01, 2022 at 07:24:11PM +0100, Jason A. Donenfeld wrote:
> > Hi Greg,
> >
> > On Tue, Mar 1, 2022 at 7:01 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > A notifier block like this makes sense, but why tie onto the PM_ stuff?
> > > This isn't power management issues, it's a system-wide change that I am
> > > sure others will want to know about that doesn't reflect any power
> > > changes.
> > >
> > > As much as I hate adding new notifiers in the kernel, that might be all
> > > you need here.
> >
> > You might indeed be right. I guess I was thinking that "resuming from
> > suspend" and "resuming from a VM fork" are kind of the same thing.
> > There _is_ a certain kind of similarity between the two. I was hoping
> > if the similarity was a strong enough one, maybe it'd make sense to do
> > them together rather than adding another notifier. But I suppose you
> > disagree, and it sounds like Rafael might too --
> > <https://lore.kernel.org/lkml/CAJZ5v0g+GihH_b9YvwuHzdrUVNGXOeabOznDC1vK6qLi8gtSTQ@mail.gmail.com/>.
>
> Hey, nice, we agree!  :)

It is now done and posted here:
https://lore.kernel.org/lkml/20220301231038.530897-1-Jason@zx2c4.com/

Jason

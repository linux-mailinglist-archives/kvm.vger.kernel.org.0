Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A622A4C948D
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 20:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237206AbiCATmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 14:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiCATmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 14:42:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D683465495;
        Tue,  1 Mar 2022 11:41:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7246761632;
        Tue,  1 Mar 2022 19:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58888C340EE;
        Tue,  1 Mar 2022 19:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646163700;
        bh=C1fiXSQzp/6mGSE4wF5VaDuuI40Za2PZjhJbinmIoDs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sFIIaOr3qhOtKIiGkw47+sRkCTakK6s4LOKKAyeJYuUR4/NwdOwfdasXUZZE+y2dN
         qTfAkZtm3bVoFwgnBR5c5AAcIWhrEK1eSu+jJttv2IPEGbRWp65T3CHVpPdKS0aQpb
         RsAEvhp7ssUECvOQfFWuscCf7xqrvhDIw/AQ44yk=
Date:   Tue, 1 Mar 2022 20:41:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        linux-hyperv@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alexander Graf <graf@amazon.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        adrian@parity.io, Laszlo Ersek <lersek@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Linux PM <linux-pm@vger.kernel.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: propagating vmgenid outward and upward
Message-ID: <Yh528WPZrQn5s7vO@kroah.com>
References: <Yh4+9+UpanJWAIyZ@zx2c4.com>
 <Yh5fbe71BTT6xc8h@kroah.com>
 <CAHmME9oGcp7HNLeieptMKztgg7Fq4MnOuAEsiFJxsLbmjSuFCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9oGcp7HNLeieptMKztgg7Fq4MnOuAEsiFJxsLbmjSuFCw@mail.gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 01, 2022 at 07:24:11PM +0100, Jason A. Donenfeld wrote:
> Hi Greg,
> 
> On Tue, Mar 1, 2022 at 7:01 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > A notifier block like this makes sense, but why tie onto the PM_ stuff?
> > This isn't power management issues, it's a system-wide change that I am
> > sure others will want to know about that doesn't reflect any power
> > changes.
> >
> > As much as I hate adding new notifiers in the kernel, that might be all
> > you need here.
> 
> You might indeed be right. I guess I was thinking that "resuming from
> suspend" and "resuming from a VM fork" are kind of the same thing.
> There _is_ a certain kind of similarity between the two. I was hoping
> if the similarity was a strong enough one, maybe it'd make sense to do
> them together rather than adding another notifier. But I suppose you
> disagree, and it sounds like Rafael might too --
> <https://lore.kernel.org/lkml/CAJZ5v0g+GihH_b9YvwuHzdrUVNGXOeabOznDC1vK6qLi8gtSTQ@mail.gmail.com/>.

Hey, nice, we agree!  :)

> Code-wise for me with WireGuard it's of course appealing to treat them
> the same, since it's like a one line change, but if I need to add a
> new notifier call there, it's not the end of the world.

I know there are other places in the kernel that would like to be
notified when they have been moved to another machine so that they can
do things like determine if the CPU functionality has changed (or not),
and perhaps do other types of device reconfiguration.  Right now the
kernel does not have any way of knowing this, so it makes sense that if
the platform (i.e. ACPI here) has a way of creating such a event, it
should and then we can start tieing in other subsystems to use it
as-needed.

thanks,

greg k-h

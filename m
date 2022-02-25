Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2924C4515
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 13:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240817AbiBYM5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 07:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbiBYM53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 07:57:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9B7286EE;
        Fri, 25 Feb 2022 04:56:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 062BF61BF8;
        Fri, 25 Feb 2022 12:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C3AC340E8;
        Fri, 25 Feb 2022 12:56:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="enMYkBkI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645793808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XssgunSt6iK78jyshO3hMq9+wDKO/OCGHO1mFFLrZQQ=;
        b=enMYkBkIudB/0krPIVVLhzRClwGqp92bzymz3GlaPY/CynpKIXYX03wKBGZ52ZVCe9Eujn
        kgPdqeLrCuQURxB1lO3tnKlABuuou7tz8M7L/27vzfUSx9/E+GZStDwJkrdcK/PldDBDFn
        5MO5bLzFBsxUJCj89tpuB1ncnSfIF98=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7f77180f (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 25 Feb 2022 12:56:48 +0000 (UTC)
Received: by mail-yb1-f180.google.com with SMTP id e140so5677751ybh.9;
        Fri, 25 Feb 2022 04:56:46 -0800 (PST)
X-Gm-Message-State: AOAM53285l4JXrzMYBbOkJo7n7JLpOeJRdxReNaxjVuAUerwEvl8CXL2
        IcW9eAQxCQ2kHgsFCpzMDGf4f8pw0AeFvhKWKGw=
X-Google-Smtp-Source: ABdhPJy+bf9nC/iTENWy4XIXFN5EQ0KO9hqlk22myA/sDhwpstQSK4hOUUQQu7RToXFr7rymY6Q0NMRfSY8co9VWFh4=
X-Received: by 2002:a25:d116:0:b0:61d:e8c9:531e with SMTP id
 i22-20020a25d116000000b0061de8c9531emr7032586ybg.637.1645793805904; Fri, 25
 Feb 2022 04:56:45 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com> <YhjRVz2184xhkZK3@kroah.com>
In-Reply-To: <YhjRVz2184xhkZK3@kroah.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 25 Feb 2022 13:56:35 +0100
X-Gmail-Original-Message-ID: <CAHmME9pGuPEWjr+RLFQi-kKcRuPxmCYyzAJOJtgx+5phwmkZ6Q@mail.gmail.com>
Message-ID: <CAHmME9pGuPEWjr+RLFQi-kKcRuPxmCYyzAJOJtgx+5phwmkZ6Q@mail.gmail.com>
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing RNG
 on VM fork
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     KVM list <kvm@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        adrian@parity.io, Ard Biesheuvel <ardb@kernel.org>,
        ben@skyportsystems.com,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        Eric Biggers <ebiggers@kernel.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Jann Horn <jannh@google.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "Weiss, Radu" <raduweis@amazon.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Wei Liu <wei.liu@kernel.org>
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

On Fri, Feb 25, 2022 at 1:53 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Feb 25, 2022 at 01:48:48PM +0100, Jason A. Donenfeld wrote:
> > +static struct acpi_driver acpi_driver = {
> > +     .name = "vmgenid",
> > +     .ids = vmgenid_ids,
> > +     .owner = THIS_MODULE,
> > +     .ops = {
> > +             .add = vmgenid_acpi_add,
> > +             .notify = vmgenid_acpi_notify,
> > +     }
> > +};
> > +
> > +static int __init vmgenid_init(void)
> > +{
> > +     return acpi_bus_register_driver(&acpi_driver);
> > +}
> > +
> > +static void __exit vmgenid_exit(void)
> > +{
> > +     acpi_bus_unregister_driver(&acpi_driver);
> > +}
> > +
> > +module_init(vmgenid_init);
> > +module_exit(vmgenid_exit);
>
> Nit, you could use module_acpi_driver() to make this even smaller if you
> want to.

Nice! Will do.

Jason

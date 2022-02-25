Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1874C4845
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238809AbiBYPFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235895AbiBYPFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:05:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86A017E37A;
        Fri, 25 Feb 2022 07:04:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7466A616F3;
        Fri, 25 Feb 2022 15:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FF9C36AE5;
        Fri, 25 Feb 2022 15:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645801475;
        bh=ZJKRPeCkChS3b+pwdBenEbdeLpCSBU8v77sN2j2sad8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eM5RtP9Pq7lHELsEtW7y2xuAZgm9Vg3+RGOAAGEm8P0FDl9LZsKDXIHSJDqem7QCf
         +m/kXl3wjcR0iCaP1HkY3vvHmKZNMfWQuYbIg7wj1yqbzSun0/HG4kgClGcF0WXmOO
         EBmd2AtrZc+QfrH3fhNhyezguuvehswtGJMeFj6hXdi8PV5pVtD9/I+C+JyrmwpDx8
         bluO8/kYHW8qv3P29Q+1Cj+qsdhxVswS7w4kmF+r1lBG1KMRp1lGE0dBBzX1Gfy3qf
         OkiOtQl3fOLhm0YpQuCPElpdNtvb10t67wIbrMv5HeT9kA1tk570xf7AJVXAhUCpr2
         TCKCjkXwr6dzQ==
Received: by mail-yb1-f175.google.com with SMTP id v186so6454038ybg.1;
        Fri, 25 Feb 2022 07:04:35 -0800 (PST)
X-Gm-Message-State: AOAM530Yqj5upJURJxamVA6dPNjXMTbWTx/RrSJuO9AvwSzwXC6I7YmK
        Z7asLuhJm66pbY4aFahakoDpjSeWBNt/I2SBeXo=
X-Google-Smtp-Source: ABdhPJyOHJrVQscGxhKhpztFY90eGZAnFgxpO8O8cRBKklhxWquUxFwdF3VqZzUEE9fRbqcR87m05T1DIeStPWsPse4=
X-Received: by 2002:a25:4214:0:b0:624:6215:4823 with SMTP id
 p20-20020a254214000000b0062462154823mr7558374yba.432.1645801474993; Fri, 25
 Feb 2022 07:04:34 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com> <YhjRVz2184xhkZK3@kroah.com>
In-Reply-To: <YhjRVz2184xhkZK3@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 25 Feb 2022 16:04:23 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH-sU5u+OcnTG0i1dOp7VuZX97336NqemhUq+apGstpXQ@mail.gmail.com>
Message-ID: <CAMj1kXH-sU5u+OcnTG0i1dOp7VuZX97336NqemhUq+apGstpXQ@mail.gmail.com>
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing RNG
 on VM fork
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        KVM list <kvm@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-hyperv@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        adrian@parity.io, ben@skyportsystems.com,
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
        KY Srinivasan <kys@microsoft.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "Weiss, Radu" <raduweis@amazon.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Wei Liu <wei.liu@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Feb 2022 at 13:53, Greg KH <gregkh@linuxfoundation.org> wrote:
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
>

With that suggestion adopted,

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

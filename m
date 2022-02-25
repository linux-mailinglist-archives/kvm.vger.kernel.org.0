Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F944C474A
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 15:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241722AbiBYOTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 09:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiBYOSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 09:18:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4829CF68F6;
        Fri, 25 Feb 2022 06:18:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 061F6B82FEA;
        Fri, 25 Feb 2022 14:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DC1C340F2;
        Fri, 25 Feb 2022 14:18:20 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ZEH8RZdN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645798695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uSqLnlnlYkI9AFDK+dTAw0XhAkDujSKiKT+1u2tB1Eg=;
        b=ZEH8RZdNgmHSXQzPHqqnaD5t4qhgKau/jiAp1RuGyohXpI72JAVjuSDtlWwQuTnNheLGe1
        FXrVjlBeqgPWwYjAUVQb5DsWGXyXm3DRp5aYT/J3dKNbYykQxV2dAPOC3m0caf/CE1QbDY
        PnaGUKPis3pEOjxOcaRhL4qjhWZdKcs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 919e9527 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 25 Feb 2022 14:18:15 +0000 (UTC)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-2d641c31776so34664417b3.12;
        Fri, 25 Feb 2022 06:18:15 -0800 (PST)
X-Gm-Message-State: AOAM5337yi+/iOQIpA96Ctj7dQWHxhUlcEJdrb1wHY87Kn4BVXxz1KYi
        n3Ox+juHpNR2hXEG67bQs/cyXDYIbXTFFVbgBjw=
X-Google-Smtp-Source: ABdhPJyAIBjcgySwjHVFkFa3Dtx+CHfd3sGiVdtkFFH5oIAfMcpE/adDECZiwcrv/0KSOJJf+VkyDHuROOt3DAiKeMA=
X-Received: by 2002:a0d:e005:0:b0:2d7:fb79:8f36 with SMTP id
 j5-20020a0de005000000b002d7fb798f36mr8270139ywe.404.1645798693111; Fri, 25
 Feb 2022 06:18:13 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com> <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
 <YhjjuMOeV7+T7thS@zx2c4.com>
In-Reply-To: <YhjjuMOeV7+T7thS@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 25 Feb 2022 15:18:02 +0100
X-Gmail-Original-Message-ID: <CAHmME9ov+4Eh0Gzi0XpS6dQ5u-FQnxXoMSQ-HEpFucEmWtNV2A@mail.gmail.com>
Message-ID: <CAHmME9ov+4Eh0Gzi0XpS6dQ5u-FQnxXoMSQ-HEpFucEmWtNV2A@mail.gmail.com>
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing RNG
 on VM fork
To:     Alexander Graf <graf@amazon.com>
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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

On Fri, Feb 25, 2022 at 3:12 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Alex,
>
> On Fri, Feb 25, 2022 at 02:57:38PM +0100, Alexander Graf wrote:
> > > +static const struct acpi_device_id vmgenid_ids[] = {
> > > +       { "VMGENID", 0 },
> > > +       { "QEMUVGID", 0 },
> >
> >
> > According to the VMGenID spec[1], you can only rely on _CID and _DDN for
> > matching. They both contain "VM_Gen_Counter". The list above contains
> > _HID values which are not an official identifier for the VMGenID device.
> >
> > IIRC the ACPI device match logic does match _CID in addition to _HID.
> > However, it is limited to 8 characters. Let me paste an experimental
> > hack I did back then to do the _CID matching instead.
> >
> > [1]
> > https://download.microsoft.com/download/3/1/C/31CFC307-98CA-4CA5-914C-D9772691E214/VirtualMachineGenerationID.docx
> >
> >
> > Alex
> >
> > diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> > index 1682f8b454a2..452443d79d87 100644
> > --- a/drivers/acpi/bus.c
> > +++ b/drivers/acpi/bus.c
> > @@ -748,7 +748,7 @@ static bool __acpi_match_device(struct acpi_device
> > *device,
> >           /* First, check the ACPI/PNP IDs provided by the caller. */
> >           if (acpi_ids) {
> >               for (id = acpi_ids; id->id[0] || id->cls; id++) {
> > -                if (id->id[0] && !strcmp((char *)id->id, hwid->id))
> > +                if (id->id[0] && !strncmp((char *)id->id, hwid->id,
> > ACPI_ID_LEN - 1))
> >                       goto out_acpi_match;
> >                   if (id->cls && __acpi_match_device_cls(id, hwid))
> >                       goto out_acpi_match;
> > diff --git a/drivers/virt/vmgenid.c b/drivers/virt/vmgenid.c
> > index 75a787da8aad..0bfa422cf094 100644
> > --- a/drivers/virt/vmgenid.c
> > +++ b/drivers/virt/vmgenid.c
> > @@ -356,7 +356,8 @@ static void vmgenid_acpi_notify(struct acpi_device
> > *device, u32 event)
> >   }
> >
> >   static const struct acpi_device_id vmgenid_ids[] = {
> > -    {"QEMUVGID", 0},
> > +    /* This really is VM_Gen_Counter, but we can only match 8 characters */
> > +    {"VM_GEN_C", 0},
> >       {"", 0},
> >   };
>
> I recall this part of the old thread. From what I understood, using
> "VMGENID" + "QEMUVGID" worked /well enough/, even if that wasn't
> technically in-spec. Ard noted that relying on _CID like that is
> technically an ACPI spec notification. So we're between one spec and
> another, basically, and doing "VMGENID" + "QEMUVGID" requires fewer
> changes, as mentioned, appears to work fine in my testing.
>
> However, with that said, I think supporting this via "VM_Gen_Counter"
> would be a better eventual thing to do, but will require acks and
> changes from the ACPI maintainers. Do you think you could prepare your
> patch proposal above as something on-top of my tree [1]? And if you can
> convince the ACPI maintainers that that's okay, then I'll happily take
> the patch.

Closely related concern that whatever patch you come up with will have
to handle is MODULE_DEVICE_TABLE and udev autoloading. I don't know if
_CID matching is something that happens in udev or what its limits
are, so that'll have to be researched and tested a bit.

Jason

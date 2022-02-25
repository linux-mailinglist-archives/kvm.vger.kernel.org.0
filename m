Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2A74C4420
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 13:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240407AbiBYMBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 07:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240399AbiBYMBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 07:01:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207D02763E2;
        Fri, 25 Feb 2022 04:01:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B16A961A2F;
        Fri, 25 Feb 2022 12:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993D2C340F4;
        Fri, 25 Feb 2022 12:01:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FrbMrkxA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645790467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PKJ8kj3JCrrxThlQ3iYnN2yFuKHQlideGF4Hi15eC4A=;
        b=FrbMrkxAx3wv1Na9y13Q+6XKbhI5SmN/tzDz12XbqTWoVKUT9TDUyUmBwpTvIAglgRXlFR
        kPIuK4L3T3qjLkv5OQqry4KN90LRKyaR41Cl7rUZSWs9nJJFc8nlmLxErIcsKth5a6Sy5z
        uPDhCkUHMPS648NiFEDIO88SmSP3+AE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 746735d1 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 25 Feb 2022 12:01:06 +0000 (UTC)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-2d07ae0b1c4so30633937b3.11;
        Fri, 25 Feb 2022 04:01:05 -0800 (PST)
X-Gm-Message-State: AOAM532s7MMn4O7LNRqv/gFYKEHtFKrYj0L+vIVNJu7JZKWigLYgMjKK
        Tf9L5z0IsEpYs5AXu32uQuuitmt2iGgC+zMZGPA=
X-Google-Smtp-Source: ABdhPJzOZdurIMZ0P9SbV33Il9mssGaSP73pY/PcPM5ehDl2bVRn5dIeKDcCAaK2fAgt/Er6hip+9B77IAK11QE0Db8=
X-Received: by 2002:a0d:d995:0:b0:2d6:f086:c0ec with SMTP id
 b143-20020a0dd995000000b002d6f086c0ecmr7354502ywe.396.1645790463524; Fri, 25
 Feb 2022 04:01:03 -0800 (PST)
MIME-Version: 1.0
References: <20220224133906.751587-1-Jason@zx2c4.com> <20220224133906.751587-3-Jason@zx2c4.com>
 <CAMj1kXE-2sknZD7o72G-ZARpfm4Q0m+im1pTLuPhPu6TkqKOPQ@mail.gmail.com>
In-Reply-To: <CAMj1kXE-2sknZD7o72G-ZARpfm4Q0m+im1pTLuPhPu6TkqKOPQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 25 Feb 2022 13:00:52 +0100
X-Gmail-Original-Message-ID: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
Message-ID: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] virt: vmgenid: introduce driver for reinitializing
 RNG on VM fork
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-hyperv@vger.kernel.org, KVM list <kvm@vger.kernel.org>,
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
        "Michael S. Tsirkin" <mst@redhat.com>,
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

On Fri, Feb 25, 2022 at 12:24 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> > @@ -13,6 +13,15 @@ menuconfig VIRT_DRIVERS
> >
> >  if VIRT_DRIVERS
> >
> > +config VMGENID
> > +       tristate "Virtual Machine Generation ID driver"
> > +       default y
>
> Please make this default m - this code can run as a module and the
> feature it relies on is discoverable by udev

Will do.

> > index 000000000000..5da4dc8f25e3
> > --- /dev/null
> > +++ b/drivers/virt/vmgenid.c
> > @@ -0,0 +1,121 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Virtual Machine Generation ID driver
> > + *
> > + * Copyright (C) 2022 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> > + * Copyright (C) 2020 Amazon. All rights reserved.
> > + * Copyright (C) 2018 Red Hat Inc. All rights reserved.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/acpi.h>
> > +#include <linux/random.h>
> > +
> > +ACPI_MODULE_NAME("vmgenid");
> > +
> > +enum { VMGENID_SIZE = 16 };
> > +
> > +static struct {
> > +       u8 this_id[VMGENID_SIZE];
> > +       u8 *next_id;
> > +} state;
> > +
>
> This state is singular
>
>
> > +static int vmgenid_acpi_add(struct acpi_device *device)
> > +{
>
> ... whereas this may be called for multiple instances of the device.
> This likely makes no sense, so it is better to reject it here.

Like, return early if it's called a second time? I can do that.

>
> > +       struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER };
> > +       union acpi_object *pss;
> > +       phys_addr_t phys_addr;
> > +       acpi_status status;
> > +       int ret = 0;
> > +
> > +       if (!device)
> > +               return -EINVAL;
> > +
> > +       status = acpi_evaluate_object(device->handle, "ADDR", NULL, &buffer);
> > +       if (ACPI_FAILURE(status)) {
> > +               ACPI_EXCEPTION((AE_INFO, status, "Evaluating ADDR"));
> > +               return -ENODEV;
> > +       }
> > +       pss = buffer.pointer;
> > +       if (!pss || pss->type != ACPI_TYPE_PACKAGE || pss->package.count != 2 ||
> > +           pss->package.elements[0].type != ACPI_TYPE_INTEGER ||
> > +           pss->package.elements[1].type != ACPI_TYPE_INTEGER) {
> > +               ret = -EINVAL;
> > +               goto out;
> > +       }
> > +
> > +       phys_addr = (pss->package.elements[0].integer.value << 0) |
> > +                   (pss->package.elements[1].integer.value << 32);
> > +       state.next_id = acpi_os_map_memory(phys_addr, VMGENID_SIZE);
>
> No need to use acpi_os_map_memory() here, plain memremap() should be fine.

As we discussed online, I'll use dev_memremap(), and then get rid of
the `.remove = ` function all together.

> > +               acpi_os_unmap_memory(state.next_id, VMGENID_SIZE);
>
> memunmap() here

And then as discussed, this goes away too.

>
> > +       state.next_id = NULL;
> > +       return 0;
> > +}
> > +
> > +static void vmgenid_acpi_notify(struct acpi_device *device, u32 event)
> > +{
> > +       u8 old_id[VMGENID_SIZE];
> > +
> > +       if (!device || acpi_driver_data(device) != &state)
> > +               return;
> > +       memcpy(old_id, state.this_id, sizeof(old_id));
> > +       memcpy(state.this_id, state.next_id, sizeof(state.this_id));
> > +       if (!memcmp(old_id, state.this_id, sizeof(old_id)))
> > +               return;
>
> Is this little dance really necessary? I.e., can we just do
>
> add_vmfork_randomness(state.next_id, VMGENID_SIZE)
>
> and be done with it?

Yes it is. vmfork induces a "premature-next" which we really should
not do unless it's really necessary. It torches the whole entropy
pool. In the even that this notifier fires but the ID hasn't changed,
we shouldn't touch anything.

Thanks for the review. v+1 coming up shortly.

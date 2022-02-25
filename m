Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1DE4C4892
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241853AbiBYPRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbiBYPRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:17:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77101D86D7;
        Fri, 25 Feb 2022 07:16:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76807B83250;
        Fri, 25 Feb 2022 15:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAD4C340F4;
        Fri, 25 Feb 2022 15:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645802200;
        bh=1YQNkQHMUBbNKAA0f8LEOAgGI8CQhzGcPzlC986yOhc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tbHJ0Z7vCb3cizuQ+2dUc2HkRr7mrIvcDE/uLyZptZ47dxE++tQGLqOjYhNNxzjub
         zH65Ezg04zvsuAUTDazs6wlN1zoTITR8ctKgDkW1r45/0413RL8Jln7xNNRELm+8ke
         UUdHy3tQu2Hd4YvK/I95CsuQx5X7DxYOLXe6VmcPLU61Dvlv1pXcI8IiILsMRlOe55
         lEkGrrWnIpRUAuiP2TZ+IY7NIAHRUzqQ0ldsP45PQF+Asdp0iNjT8vsDO+4RJyFhMc
         x7ivfMGT3aSWfmIlRjKuHYPx4+BEHaKVT76/nl9y0GrQWLcN5w6cS1ZFZ/ePlKIUQR
         WKbfYynoRvmaA==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2d66f95f1d1so37315927b3.0;
        Fri, 25 Feb 2022 07:16:40 -0800 (PST)
X-Gm-Message-State: AOAM531Z3myOg/XdE7h8e8IGm8y5QWS0FjZKr5RRS9dQ8EG4FPPDMsU6
        imgRU67uRJgdkjso0c7Vxc7L4fZl6Lzh8JIxzE4=
X-Google-Smtp-Source: ABdhPJy24j/XlMc4iMq9F1iPQkI+P8/SeG/oYlZqoLCoQ3g6Pbs6pk5D7Xk0ab1JaS6DRZ7G96N4rg6RmaiLoYr4VK0=
X-Received: by 2002:a81:84d5:0:b0:2d1:e85:bf04 with SMTP id
 u204-20020a8184d5000000b002d10e85bf04mr8081642ywf.465.1645802199166; Fri, 25
 Feb 2022 07:16:39 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com> <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
 <YhjjuMOeV7+T7thS@zx2c4.com> <88ebdc32-2e94-ef28-37ed-1c927c12af43@amazon.com>
 <YhjoyIUv2+18BwiR@zx2c4.com> <9ac68552-c1fc-22c8-13e6-4f344f85a4fb@amazon.com>
In-Reply-To: <9ac68552-c1fc-22c8-13e6-4f344f85a4fb@amazon.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 25 Feb 2022 16:16:27 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEue6cDCSG0N7WGTVF=JYZx3jwE7EK4tCdhO-HzMtWwVw@mail.gmail.com>
Message-ID: <CAMj1kXEue6cDCSG0N7WGTVF=JYZx3jwE7EK4tCdhO-HzMtWwVw@mail.gmail.com>
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing RNG
 on VM fork
To:     Alexander Graf <graf@amazon.com>
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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

On Fri, 25 Feb 2022 at 16:12, Alexander Graf <graf@amazon.com> wrote:
>
>
> On 25.02.22 15:33, Jason A. Donenfeld wrote:
> > On Fri, Feb 25, 2022 at 03:18:43PM +0100, Alexander Graf wrote:
> >>> I recall this part of the old thread. From what I understood, using
> >>> "VMGENID" + "QEMUVGID" worked /well enough/, even if that wasn't
> >>> technically in-spec. Ard noted that relying on _CID like that is
> >>> technically an ACPI spec notification. So we're between one spec and
> >>> another, basically, and doing "VMGENID" + "QEMUVGID" requires fewer
> >>> changes, as mentioned, appears to work fine in my testing.
> >>>
> >>> However, with that said, I think supporting this via "VM_Gen_Counter"
> >>> would be a better eventual thing to do, but will require acks and
> >>> changes from the ACPI maintainers. Do you think you could prepare your
> >>> patch proposal above as something on-top of my tree [1]? And if you can
> >>> convince the ACPI maintainers that that's okay, then I'll happily take
> >>> the patch.
> >>
> >> Sure, let me send the ACPI patch stand alone. No need to include the
> >> VMGenID change in there.
> > That's fine. If the ACPI people take it for 5.18, then we can count on
> > it being there and adjust the vmgenid driver accordingly also for 5.18.
> >
> > I just booted up a Windows VM, and it looks like Hyper-V uses
> > "Hyper_V_Gen_Counter_V1", which is also quite long, so we can't really
> > HID match on that either.
>
>
> Yes, due to the same problem. I'd really prefer we sort out the ACPI
> matching before this goes mainline. Matching on _HID is explicitly
> discouraged in the VMGenID spec.
>

OK, this really sucks. Quoting the ACPI spec:

"""
A _HID object evaluates to either a numeric 32-bit compressed EISA
type ID or a string. If a string, the format must be an alphanumeric
PNP or ACPI ID with no asterisk or other leading characters.
A valid PNP ID must be of the form "AAA####" where A is an uppercase
letter and # is a hex digit.
A valid ACPI ID must be of the form "NNNN####" where N is an uppercase
letter or a digit ('0'-'9') and # is a hex digit. This specification
reserves the string "ACPI" for use only with devices defined herein.
It further reserves all strings representing 4 HEX digits for
exclusive use with PCI-assigned Vendor IDs.
"""

So now we have to implement Microsoft's fork of ACPI to be able to use
this device, even if we expose it from QEMU instead of Hyper-V? I
strongly object to that.

Instead, we can match on _HID exposed by QEMU, and cordially invite
Microsoft to align their spec with the ACPI spec.

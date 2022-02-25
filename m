Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8A94C4920
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242082AbiBYPe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238920AbiBYPez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:34:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6223190B76;
        Fri, 25 Feb 2022 07:34:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 616CBB83253;
        Fri, 25 Feb 2022 15:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2B8C340E7;
        Fri, 25 Feb 2022 15:34:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="EWUvxbsv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645803256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aWLmVQxQDsQDY8xA+iWmKjooufWe/5wC2imqu/MRZlY=;
        b=EWUvxbsv0f37oRy8gRLWgC2f9N5nllIJZsgvlWWTgwSXhwcn1SAw9ahMy2L+erFJzM3Cok
        2LgLhaVSk7Y3z5WXitc4qbOO4HNlQEIOEgKhSZKCqlv5kIMeSZSSbrRloP3h+xPoexoTbJ
        roWa02VZ8DoxU22UyCjoRq3cY9oiQgA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ca8076dc (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 25 Feb 2022 15:34:15 +0000 (UTC)
Date:   Fri, 25 Feb 2022 16:34:11 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Ard Biesheuvel <ardb@kernel.org>, adrian@parity.io
Cc:     Alexander Graf <graf@amazon.com>, KVM list <kvm@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-hyperv@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        adrian@parity.io, ben@skyportsystems.com,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
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
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing
 RNG on VM fork
Message-ID: <Yhj288aE5rW15Qpj@zx2c4.com>
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com>
 <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
 <YhjjuMOeV7+T7thS@zx2c4.com>
 <88ebdc32-2e94-ef28-37ed-1c927c12af43@amazon.com>
 <YhjoyIUv2+18BwiR@zx2c4.com>
 <9ac68552-c1fc-22c8-13e6-4f344f85a4fb@amazon.com>
 <CAMj1kXEue6cDCSG0N7WGTVF=JYZx3jwE7EK4tCdhO-HzMtWwVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMj1kXEue6cDCSG0N7WGTVF=JYZx3jwE7EK4tCdhO-HzMtWwVw@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 04:16:27PM +0100, Ard Biesheuvel wrote:
> > > I just booted up a Windows VM, and it looks like Hyper-V uses
> > > "Hyper_V_Gen_Counter_V1", which is also quite long, so we can't really
> > > HID match on that either.
> >
> >
> > Yes, due to the same problem. I'd really prefer we sort out the ACPI
> > matching before this goes mainline. Matching on _HID is explicitly
> > discouraged in the VMGenID spec.
> >
> 
> OK, this really sucks. Quoting the ACPI spec:
> 
> """
> A _HID object evaluates to either a numeric 32-bit compressed EISA
> type ID or a string. If a string, the format must be an alphanumeric
> PNP or ACPI ID with no asterisk or other leading characters.
> A valid PNP ID must be of the form "AAA####" where A is an uppercase
> letter and # is a hex digit.
> A valid ACPI ID must be of the form "NNNN####" where N is an uppercase
> letter or a digit ('0'-'9') and # is a hex digit. This specification
> reserves the string "ACPI" for use only with devices defined herein.
> It further reserves all strings representing 4 HEX digits for
> exclusive use with PCI-assigned Vendor IDs.
> """
> 
> So now we have to implement Microsoft's fork of ACPI to be able to use
> this device, even if we expose it from QEMU instead of Hyper-V? I
> strongly object to that.
> 
> Instead, we can match on _HID exposed by QEMU, and cordially invite
> Microsoft to align their spec with the ACPI spec.

I don't know about that... Seems a bit extreme. Hopefully Alex will be
able to sort something out with the ACPI people, and this driver will
work inside of Hyper-V.

Here's what we currently have:

  static const struct acpi_device_id vmgenid_ids[] = {
    { "VMGENID", 0 },  <------------------------------------ ???
    { "QEMUVGID", 0 }, <------------------------------------ QEMU
    { },
  };

Adrian added "VMGENID" in last year's v4, so I copied that for this new
driver here. But does anybody know which hypervisor it is for? Some
internal Amazon thing? Firecracker? VMware? In case Alex does not
succeed with the ACPI changes, it'd be nice to know which HIDs for
which hypervisors we do and do not support.

Jason

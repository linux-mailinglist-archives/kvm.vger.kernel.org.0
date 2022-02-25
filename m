Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FA44C4724
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 15:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241665AbiBYONM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 09:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241670AbiBYOMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 09:12:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC68A17F6AD;
        Fri, 25 Feb 2022 06:12:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93288B831F4;
        Fri, 25 Feb 2022 14:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798F3C340E8;
        Fri, 25 Feb 2022 14:12:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="LsGya7Zp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645798335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BV1+orV8xAOnCySwR8Kh0ZZcktYp5OVL7BqBBF8rp7s=;
        b=LsGya7ZpDEDUGek9ZGSYOZatOh8MwhAFlVqgstKCLlXLPGhrCBE0wCNFT8WWh61CYyDofy
        VZTjAe3n19vVKcwOwqkC1i01bnUF+uWynljDo8xuepXOv6Q90oqPcseN9gUlYla9AErN0A
        Z9d4173wu2PlIm2PpDoyjVDDZ+YjUTc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 33c5875e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 25 Feb 2022 14:12:15 +0000 (UTC)
Date:   Fri, 25 Feb 2022 15:12:08 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        adrian@parity.io, ardb@kernel.org, ben@skyportsystems.com,
        berrange@redhat.com, colmmacc@amazon.com, decui@microsoft.com,
        dwmw@amazon.co.uk, ebiggers@kernel.org, ehabkost@redhat.com,
        gregkh@linuxfoundation.org, haiyangz@microsoft.com,
        imammedo@redhat.com, jannh@google.com, kys@microsoft.com,
        lersek@redhat.com, linux@dominikbrodowski.net, mst@redhat.com,
        qemu-devel@nongnu.org, raduweis@amazon.com, sthemmin@microsoft.com,
        tytso@mit.edu, wei.liu@kernel.org
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing
 RNG on VM fork
Message-ID: <YhjjuMOeV7+T7thS@zx2c4.com>
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com>
 <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On Fri, Feb 25, 2022 at 02:57:38PM +0100, Alexander Graf wrote:
> > +static const struct acpi_device_id vmgenid_ids[] = {
> > +       { "VMGENID", 0 },
> > +       { "QEMUVGID", 0 },
> 
> 
> According to the VMGenID spec[1], you can only rely on _CID and _DDN for 
> matching. They both contain "VM_Gen_Counter". The list above contains 
> _HID values which are not an official identifier for the VMGenID device.
> 
> IIRC the ACPI device match logic does match _CID in addition to _HID. 
> However, it is limited to 8 characters. Let me paste an experimental 
> hack I did back then to do the _CID matching instead.
> 
> [1] 
> https://download.microsoft.com/download/3/1/C/31CFC307-98CA-4CA5-914C-D9772691E214/VirtualMachineGenerationID.docx
> 
> 
> Alex
> 
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index 1682f8b454a2..452443d79d87 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -748,7 +748,7 @@ static bool __acpi_match_device(struct acpi_device 
> *device,
>           /* First, check the ACPI/PNP IDs provided by the caller. */
>           if (acpi_ids) {
>               for (id = acpi_ids; id->id[0] || id->cls; id++) {
> -                if (id->id[0] && !strcmp((char *)id->id, hwid->id))
> +                if (id->id[0] && !strncmp((char *)id->id, hwid->id, 
> ACPI_ID_LEN - 1))
>                       goto out_acpi_match;
>                   if (id->cls && __acpi_match_device_cls(id, hwid))
>                       goto out_acpi_match;
> diff --git a/drivers/virt/vmgenid.c b/drivers/virt/vmgenid.c
> index 75a787da8aad..0bfa422cf094 100644
> --- a/drivers/virt/vmgenid.c
> +++ b/drivers/virt/vmgenid.c
> @@ -356,7 +356,8 @@ static void vmgenid_acpi_notify(struct acpi_device 
> *device, u32 event)
>   }
> 
>   static const struct acpi_device_id vmgenid_ids[] = {
> -    {"QEMUVGID", 0},
> +    /* This really is VM_Gen_Counter, but we can only match 8 characters */
> +    {"VM_GEN_C", 0},
>       {"", 0},
>   };

I recall this part of the old thread. From what I understood, using
"VMGENID" + "QEMUVGID" worked /well enough/, even if that wasn't
technically in-spec. Ard noted that relying on _CID like that is
technically an ACPI spec notification. So we're between one spec and
another, basically, and doing "VMGENID" + "QEMUVGID" requires fewer
changes, as mentioned, appears to work fine in my testing.

However, with that said, I think supporting this via "VM_Gen_Counter"
would be a better eventual thing to do, but will require acks and
changes from the ACPI maintainers. Do you think you could prepare your
patch proposal above as something on-top of my tree [1]? And if you can
convince the ACPI maintainers that that's okay, then I'll happily take
the patch.

Jason

[1] https://git.kernel.org/pub/scm/linux/kernel/git/crng/random.git/

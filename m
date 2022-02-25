Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF384C4796
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 15:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239470AbiBYOe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 09:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiBYOe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 09:34:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8942763E2;
        Fri, 25 Feb 2022 06:33:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 286CDB831F9;
        Fri, 25 Feb 2022 14:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251F1C340E7;
        Fri, 25 Feb 2022 14:33:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GS3fWtqB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645799629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f7l+1znU0C3mGGUO232V1hcf63PeBIQ9HzasOLJsYSs=;
        b=GS3fWtqB1bIfgIGI51lS8j8ppgTmfWTnL/BLepHrXEWwGTqQkEnfaG0h2EEPE85kqfIYBc
        VEyZFu5mJGLEAB/T3OffmgHyhyZjZy5IC048I+OZLJ6gDvbCfB/dSktTa0JfsIgqEOxi7a
        P/XMxf5+izlbzRbSgUBu4cryEdBDZHk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ffcd5017 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 25 Feb 2022 14:33:49 +0000 (UTC)
Date:   Fri, 25 Feb 2022 15:33:44 +0100
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
Message-ID: <YhjoyIUv2+18BwiR@zx2c4.com>
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com>
 <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
 <YhjjuMOeV7+T7thS@zx2c4.com>
 <88ebdc32-2e94-ef28-37ed-1c927c12af43@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <88ebdc32-2e94-ef28-37ed-1c927c12af43@amazon.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 03:18:43PM +0100, Alexander Graf wrote:
> > I recall this part of the old thread. From what I understood, using
> > "VMGENID" + "QEMUVGID" worked /well enough/, even if that wasn't
> > technically in-spec. Ard noted that relying on _CID like that is
> > technically an ACPI spec notification. So we're between one spec and
> > another, basically, and doing "VMGENID" + "QEMUVGID" requires fewer
> > changes, as mentioned, appears to work fine in my testing.
> >
> > However, with that said, I think supporting this via "VM_Gen_Counter"
> > would be a better eventual thing to do, but will require acks and
> > changes from the ACPI maintainers. Do you think you could prepare your
> > patch proposal above as something on-top of my tree [1]? And if you can
> > convince the ACPI maintainers that that's okay, then I'll happily take
> > the patch.
> 
> 
> Sure, let me send the ACPI patch stand alone. No need to include the 
> VMGenID change in there.

That's fine. If the ACPI people take it for 5.18, then we can count on
it being there and adjust the vmgenid driver accordingly also for 5.18.

I just booted up a Windows VM, and it looks like Hyper-V uses
"Hyper_V_Gen_Counter_V1", which is also quite long, so we can't really
HID match on that either.

Jason

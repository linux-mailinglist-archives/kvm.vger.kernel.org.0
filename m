Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178134C4965
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242276AbiBYPoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242272AbiBYPoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:44:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF811D9B4C;
        Fri, 25 Feb 2022 07:43:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A9A6B83267;
        Fri, 25 Feb 2022 15:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7222C340F0;
        Fri, 25 Feb 2022 15:43:19 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FPOE4Qfk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645803798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IsOywQAnx5u1lAniICwae+nr6IyMZXA1OmfzCOAb3Zw=;
        b=FPOE4QfkcpcpUHrB2A1WDXR+lDY0zAzQkW+btr90FjI2KBwsgaXqxcYUaTh74AR13T3bec
        Yuq+dmEB1KAL/5o47dh+J4dVfjPgqb27eTMZOdgW6wbmQITTDTy+iVOdHrF9uOTLWjEQUa
        8CU9l2kxaCjN41L3TOwepJegb1r1BCs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b8ce3d14 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 25 Feb 2022 15:43:18 +0000 (UTC)
Date:   Fri, 25 Feb 2022 16:43:11 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, KVM list <kvm@vger.kernel.org>,
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
Message-ID: <Yhj5Dyd6+oC/R1H5@zx2c4.com>
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com>
 <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
 <YhjjuMOeV7+T7thS@zx2c4.com>
 <88ebdc32-2e94-ef28-37ed-1c927c12af43@amazon.com>
 <YhjoyIUv2+18BwiR@zx2c4.com>
 <9ac68552-c1fc-22c8-13e6-4f344f85a4fb@amazon.com>
 <CAMj1kXEue6cDCSG0N7WGTVF=JYZx3jwE7EK4tCdhO-HzMtWwVw@mail.gmail.com>
 <c8066caf-8bbb-b148-57e6-98d8449a64c3@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c8066caf-8bbb-b148-57e6-98d8449a64c3@amazon.com>
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

On Fri, Feb 25, 2022 at 04:22:54PM +0100, Alexander Graf wrote:
> I don't understand the rush here. This had been sitting on the ML for 1 
> year - and now suddenly talking the match through properly and getting 
> VMGenID spec compatible matching support into the ACPI core is a 
> problem? What did I miss? :)

I don't think this is a question about speed. Ard doesn't like the spec.
You like the feature more than you dislike the spec. Apparently that
means there's a disagreement.

As I mentioned earlier, I'd encourage you to send a patch to the ACPI
people and let them decide. If that gets in, then I'm fine with
modifying vmgenid to meet the spec and take advantage of the change
you'll be making to the ACPI code. If it is rejected by the ACPI people,
and consequently Linux isn't able to match on _CID, then I guess we'll
have the next best thing, which is "well, it still works on QEMU."
Hopefully you'll convince them. Feel free to CC me on that patch.

Jason

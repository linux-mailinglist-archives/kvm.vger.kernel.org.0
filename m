Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749684C4930
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242165AbiBYPh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240337AbiBYPh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:37:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F069821EB8C;
        Fri, 25 Feb 2022 07:36:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CFA4618E3;
        Fri, 25 Feb 2022 15:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674ECC340E7;
        Fri, 25 Feb 2022 15:36:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GI8DmJn5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645803410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iwp10sT7peKmlW9+/6iPiAzMvnsfb0aFjjMWYlFu/qY=;
        b=GI8DmJn5Hxh7L7PT1bruHnDbI+diCBzWolvVWhiHRhm9kvqyhDSEUyZBWH3DcI7YaqP/Xi
        q5vllj7ypWF2vqNN2CPJcmOw3jJ7ERFKYffFupSgURYWDWHVdyxSbFkJpCCTlMUwXPNz6j
        YfGs236u28Z04UbkO7Hl0QC8Y0EWsN8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a5decf67 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 25 Feb 2022 15:36:49 +0000 (UTC)
Date:   Fri, 25 Feb 2022 16:36:42 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, adrian@parity.io, ardb@kernel.org,
        ben@skyportsystems.com, berrange@redhat.com, colmmacc@amazon.com,
        decui@microsoft.com, dwmw@amazon.co.uk, ebiggers@kernel.org,
        ehabkost@redhat.com, haiyangz@microsoft.com, imammedo@redhat.com,
        jannh@google.com, kys@microsoft.com, lersek@redhat.com,
        linux@dominikbrodowski.net, mst@redhat.com, qemu-devel@nongnu.org,
        raduweis@amazon.com, sthemmin@microsoft.com, tytso@mit.edu,
        wei.liu@kernel.org
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing
 RNG on VM fork
Message-ID: <Yhj3iqBxxzDeFhyd@zx2c4.com>
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com>
 <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
 <YhjphtYyXoYZ9lXY@kroah.com>
 <0b8a2c25-df48-143d-7fac-dc9b4ef68d3c@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0b8a2c25-df48-143d-7fac-dc9b4ef68d3c@amazon.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi again,

On Fri, Feb 25, 2022 at 04:31:02PM +0100, Alexander Graf wrote:
> >> Please expose the vmgenid via /sysfs so that user space even remotely has a
> >> chance to check if it's been cloned.
> > Export it how?  And why, who would care?
> You can just

As mentioned in <https://lore.kernel.org/lkml/Yhj1nYHXmimPsqFd@zx2c4.com/>,
propose something later for all of this. It doesn't need to happen all
at once *now*.

Thanks,
Jason

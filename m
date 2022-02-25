Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5478F4C48DA
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242077AbiBYP3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbiBYP3M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:29:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E4D51E44;
        Fri, 25 Feb 2022 07:28:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33D27B83250;
        Fri, 25 Feb 2022 15:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BC2C340F0;
        Fri, 25 Feb 2022 15:28:34 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="WRm6cOGF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645802913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AGc3HtA6A4VpWTuoF56TukEqyXDHbzPy+Zb56qBmVE4=;
        b=WRm6cOGFOImn/aW/r2uMGAAnP99kIhA6KQkGrSddTUVxAkWVY9oezzK7F6YN6oeSPEX00v
        XVn/gXm/ZD0Khupal1wI4/zPDplhrs4umww7//LN2a9PB1DjWjGzF4rwRukBQLnbj5EMHE
        FRzEd8Ep4ZckCmimiThiqkYgmQENeqQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8a164ef4 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 25 Feb 2022 15:28:32 +0000 (UTC)
Date:   Fri, 25 Feb 2022 16:28:29 +0100
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
Message-ID: <Yhj1nYHXmimPsqFd@zx2c4.com>
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com>
 <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
 <YhjttNadaaJzVa5X@zx2c4.com>
 <b3b9dd9b-c42c-f057-f546-3e390b50479f@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b3b9dd9b-c42c-f057-f546-3e390b50479f@amazon.com>
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

On Fri, Feb 25, 2022 at 04:15:59PM +0100, Alexander Graf wrote:
> I'm not talking about a notification interface - we've gone through 
> great length on that one in the previous submission. What I'm more 
> interested in is *any* way for user space to read the current VM Gen ID. 
> The same way I'm interested to see other device attributes of my system 
> through sysfs.

Again, no. Same basic objection: we can do this later and design it
coherently with the rest. For example, maybe it's better to expose a
generation counter rather than 16 byte blob, and expect userspace to
call getrandom() subsequently to get something fresh. Or not! But maybe
it should be hashed with a fixed prefix string before being exposed to
userspace. Or not! I don't know, but that's not going to happen on this
patchset. There is no reason at all why that needs to be done here and
now. Trying to do too much at the same time is likely why the previous
efforts from your team stalled out last year. Propose something later,
in a new thread, and we can discuss then. One step at a time...

Jason

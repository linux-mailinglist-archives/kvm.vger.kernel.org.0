Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBA14C47FE
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 15:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241955AbiBYOzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 09:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241944AbiBYOzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 09:55:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E05C227597;
        Fri, 25 Feb 2022 06:54:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D50A615DE;
        Fri, 25 Feb 2022 14:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C72C340E7;
        Fri, 25 Feb 2022 14:54:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="KVOaVkaO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645800888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qE/ZWcS5laWbFfe6kS3CgvY+YPQ7FFHc3k15fj0mrEI=;
        b=KVOaVkaOu3r+Qp1WdK0zyPpBT7r2AjT2IjT7Nm8mLR9n6CbR5EX/G0eCvR9zZrR/5zSaHt
        /CZ+FaIO3789sgokItbqLEaLPJzLMHdPLARsfw8JqihocjrbnYc3X9aXUtF6jGn8nERzXw
        g2JWnL04850ISzo0Unco/uXtXvPFQBY=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3e8c7660 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 25 Feb 2022 14:54:47 +0000 (UTC)
Date:   Fri, 25 Feb 2022 15:54:44 +0100
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
Message-ID: <YhjttNadaaJzVa5X@zx2c4.com>
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com>
 <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
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

Missed this remark before:

On Fri, Feb 25, 2022 at 02:57:38PM +0100, Alexander Graf wrote:
> Please expose the vmgenid via /sysfs so that user space even remotely 
> has a chance to check if it's been cloned.

No. Did you read the 0/2 cover letter? I'll quote it for you here:

> As a side note, this series intentionally does _not_ focus on
> notification of these events to userspace or to other kernel consumers.
> Since these VM fork detection events first need to hit the RNG, we can
> later talk about what sorts of notifications or mmap'd counters the RNG
> should be making accessible to elsewhere. But that's a different sort of
> project and ties into a lot of more complicated concerns beyond this
> more basic patchset. So hopefully we can keep the discussion rather
> focused here to this ACPI business.

What about that was unclear to you?

Anyway, it's a different thing that will have to be designed and
considered carefully, and that design doesn't have a whole lot to do
with this little driver here, except insofar as it could build on top of
it in one way or another. Yes, it's an important thing to do. No, I'm
not going to do it in this patch here. If you want to have a discussion
about that, start a different thread.

Thanks,
Jason

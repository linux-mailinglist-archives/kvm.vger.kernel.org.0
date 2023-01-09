Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F916620F2
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 10:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbjAIJHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 04:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbjAIJG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 04:06:26 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB96A1BC
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 00:59:10 -0800 (PST)
Date:   Mon, 9 Jan 2023 09:59:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1673254749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=McSwTT3Eti/+xWN949F40XRwwDtzaH6NW83MRhzFPNw=;
        b=xqXs7WCq1JWVcYOOwkdRHyONVCZ6fJPnGrOiG69RmePP81Wewz7q7Zm6UQI0O1CwtWnYhZ
        rk7VctTn9s8PZSKEc6K255JFhTmrSFagDNq1PpOJmoUAJok5WahLWVA3/4i7rQy69vqeBW
        k6Fc6B/QS/f09C+bJLhIs1m9G7yA3LU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     alexandru.elisei@arm.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        eric.auger@redhat.com, oliver.upton@linux.dev, reijiw@google.com,
        ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH] arm: Remove MAX_SMP probe loop
Message-ID: <20230109085907.nklhxqz2vrfpengj@orel>
References: <20230106071124.ytv6cmkvmvxhzmoh@orel>
 <gsntwn5zr2cz.fsf@coltonlewis-kvm.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsntwn5zr2cz.fsf@coltonlewis-kvm.c.googlers.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 06, 2023 at 05:37:16PM +0000, Colton Lewis wrote:
> Andrew Jones <andrew.jones@linux.dev> writes:
> 
> > > We could cap at 8 for ACCEL=tcg. Even if no one cares, I'm tempted to do
> > > it so no one hits the same little landmine as me in the future.
> 
> > TCG supports up to 255 CPUs. The only reason it'd have a max of 8 is if
> > you were configuring a GICv2 instead of a GICv3.
> 
> That makes sense as it was the GICv2 tests failing that led me to this
> rabbit hole. In that case, it should be completely safe to delete the
> loop because all the GICv2 tests have ternary condition to cap at 8
> already.

How did your gicv2 tests hit the problem?

> 
> If we can't delete, the loop logic is still a suboptimal way to do
> things as qemu reports the max cpus it can take. We could read MAX_SMP
> from qemu error output.

Patches welcome, but you'll want to ensure older QEMU also reports the
number of max CPUs. Basically, either we completely drop the loop,
which assumes we're no longer concerned with testing kernels older than
v4.3 and testing shows we always get a working number of CPUs, or we
change the loop to parsing QEMU's output, but that requires testing
all versions of QEMU we care about report the error the same way, or
we leave the loop as is. Alex says the speedup obtained by dropping
the extra QEMU invocations is noticeable, so that's a vote for doing
something, but whatever is chosen will need a commit message identifying
which versions of kernel and/or QEMU are now the oldest ones supported.

Thanks,
drew

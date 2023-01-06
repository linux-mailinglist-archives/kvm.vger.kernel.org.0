Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE93365FBBA
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 08:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjAFHLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 02:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjAFHL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 02:11:29 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3BC755C4
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 23:11:27 -0800 (PST)
Date:   Fri, 6 Jan 2023 08:11:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1672989085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fauj+NonVb8iLkKg1RFq1TexduZK1wTOfm20pD1NyCg=;
        b=JroxeUE7yy/Xx9l/Vx7NJIWTUGynOY1CexlSlRBwYdE2tmZNsfhYCMaIemYvwBrp0IkkdN
        TPEbLU0ORvdGdu+09QkEc6TGbxrtwK4LYNuBUIWwk+AOdoQqnI9pmxw2r9PCex2dMJDN67
        yv+o49uVsZHpJoVS3nTW3i2pcKTPUso=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     alexandru.elisei@arm.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        eric.auger@redhat.com, oliver.upton@linux.dev, reijiw@google.com,
        ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH] arm: Remove MAX_SMP probe loop
Message-ID: <20230106071124.ytv6cmkvmvxhzmoh@orel>
References: <20221226182158.3azk5zwvl2vsy36h@orel>
 <gsntzgawr321.fsf@coltonlewis-kvm.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsntzgawr321.fsf@coltonlewis-kvm.c.googlers.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05, 2023 at 11:09:58PM +0000, Colton Lewis wrote:
> Andrew Jones <andrew.jones@linux.dev> writes:
> > On Tue, Dec 20, 2022 at 04:32:00PM +0000, Colton Lewis wrote:
> > > Alexandru Elisei <alexandru.elisei@arm.com> writes:
> > Ah, I think I understand now. Were you running 32-bit arm tests? If so,
> > it'd be good to point that out explicitly in the commit message (the
> > 'arm:' prefix in the summary is ambiguous).
> 
> No, this was happening on arm64. Since it had been a while since I noted
> this issue, I reviewed it and realized the issue was only happening
> using -accel tcg. That was automatically being used on my problem test
> machine without me noticing. That's where the limit of 8 seems to be
> coming from and why the loop is triggered.
> 
> qemu-system-aarch64: Number of SMP CPUs requested (152) exceeds max CPUs
> supported by machine 'mach-virt' (8)
> 
> Since this case doesn't directly involve KVM, I doubt anyone cares about
> a fix.
> 
> > Assuming the loop body was running because it needed to reduce MAX_SMP to
> > 8 or lower for 32-bit arm tests, then we should be replacing the loop with
> > something that caps MAX_SMP at 8 for 32-bit arm tests instead.
> 
> We could cap at 8 for ACCEL=tcg. Even if no one cares, I'm tempted to do
> it so no one hits the same little landmine as me in the future.

TCG supports up to 255 CPUs. The only reason it'd have a max of 8 is if
you were configuring a GICv2 instead of a GICv3. Using gic-version=3 or
gic-version=max should allow the 152 CPUs to work. Actually, I should
have asked about your gic version instead of whether or not the VM was
AArch32 in the first place. I was incorrectly associating the gicv2
limits with arm32 since my memories of these things have started to
blur together...

Thanks,
drew

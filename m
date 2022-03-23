Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DFD4E5391
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 14:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241924AbiCWNwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 09:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbiCWNwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 09:52:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA1A70F57
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 06:50:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BBF76167F
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 13:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C051C340E8;
        Wed, 23 Mar 2022 13:50:31 +0000 (UTC)
Date:   Wed, 23 Mar 2022 13:50:27 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Vladimir Murzin <vladimir.murzin@arm.com>, will@kernel.org,
        kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        linux-arm-kernel@lists.infradead.org, steven.price@arm.com
Subject: Re: [kvmtool PATCH 2/2] aarch64: Add support for MTE
Message-ID: <Yjslo2CQCVyEaGln@arm.com>
References: <20220321152820.246700-1-alexandru.elisei@arm.com>
 <20220321152820.246700-3-alexandru.elisei@arm.com>
 <3cf3b621-5a07-5c06-cb9f-f9c776b6717d@arm.com>
 <Yjiw/mdfLyMW2gFh@monolith.localdoman>
 <7e5ebae0-db08-ad87-0fa9-26da048a9b72@arm.com>
 <YjsMlZV1NBooKiYR@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjsMlZV1NBooKiYR@monolith.localdoman>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 23, 2022 at 12:03:33PM +0000, Alexandru Elisei wrote:
> On Wed, Mar 23, 2022 at 10:31:15AM +0000, Vladimir Murzin wrote:
> > On 3/21/22 5:08 PM, Alexandru Elisei wrote:
> > > On Mon, Mar 21, 2022 at 03:40:18PM +0000, Vladimir Murzin wrote:
> > > > Can we enable it unconditionally if KVM_CAP_ARM_MTE is supported like we do for
> > > > PAC and SVE?
> > > 
> > > I thought about that, the reason I chose to enable it based a kvmtool
> > > command line option, instead of always being enabled if available, is
> > > because of the overhead of sanitising the MTE tags on each stage 2 data
> > > abort. Steven, am I overreacting and that overhead is negligible?
> > > 
> > > Also, as far as I know, PAC and SVE incur basically no overhead in KVM
> > > until the guest starts to use those features.
> > > 
> > > Do you have a specific reason for wanting MTE to always be enabled if
> > > available? I'm happy to be convinced to make MTE enabled by default, I
> > > don't have preference either way.
> > 
> > Well, automatically enabling if available would align with what we do for
> > other features in kvmtool and Linux itself - we tend to default y for new
> > features, even MTE, thus improving chances to get reports back early if
> > something (even performance) goes wrong. Just my 2p.
> 
> According to Steven, for each 4k page the kernel uses an 128 byte buffer to
> store the tags, and then some extra memory is used to keep track of the
> buffers. Let's take the case of a VM with 1GB of memory, and be
> conservative and only account for the tag buffer. In this case, the tag
> buffers alone will be 32MB.

The 128 byte buffer is only allocated *if* the page is swapped out. So
if the host swaps out the entire 1GB guest memory, it will incur the
32MB cost. But a fully swapped out VM is pretty useless, so this doesn't
happen very often.

We do have the cost of zeroing the tags when the page is mapped into
guests. I don't remember the KVM implementation but maybe we can
optimise this to zero the tags at the same time with zeroing the data
as we do for anonymous pages in the host (unless it does this already).

We could use the fine-grained traps to detect when MAIR_EL1 was
configured by the guest for Tagged memory but, at least with Linux, we
do this at boot irrespective of whether any application will use MTE or
not. Future architecture versions may address this problem.

> The kernel documentation for MTE suggests that in order to take advantage
> of it, software must be modified and recompiled. That means that users that
> don't want to use MTE won't get to exercise MTE because they won't be using
> MTE enabled software, but they will pay the overhead regardless. This of
> course assumes that going forward software won't be using MTE by default.

Not all software needs to be recompiled. It's sufficient most of the
time to replace the glibc with an MTE-aware one.

I have a slight preference for MTE default in kvmtool, maybe with an
option to disable it if one doesn't care about the feature or we find
the overhead to be significant (I don't think it would be).

-- 
Catalin

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23825512496
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 23:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiD0VhP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 17:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241421AbiD0Vgw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 17:36:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686D2BF60
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 14:33:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2278EB82AD6
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 21:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D83C385A7;
        Wed, 27 Apr 2022 21:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651095213;
        bh=1iBDbgaS38FCqRlOfss8ueKSHJ7VkjrleWU06kV5KbM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IhRiECsXSHyR/fYqJQfGsNByuU4TGKmyhtiHJwzjys6Ak0JoLhtUNRxfeUxHn9uCX
         39K1bY0WsIxVyqPGMzYtQVM/LLnsLYqETORk0kiy0EVGTNcLzgAGwwvaH2Rg2youdw
         eJ4DJ37s8ll1C86aqIzEutexyxv0knj46iSGSJG49w1OtIZodMpQe+XFor8zOtplGD
         3GQHLbVFbGZQ2tXaKZ5+UKjGr3jlfFkXVrhdanSmDO4SR+tK+nvYvBm8cPd++Z95ip
         5wwO0MmFuyoC/7ECiAsSm2DEN4Lxt9ayz4gGj8QmQAokBfL3ns/lKelTE2nmb8kpjn
         3AUvhYDQaIKCQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1njpHu-007TnV-TE; Wed, 27 Apr 2022 22:33:30 +0100
MIME-Version: 1.0
Date:   Wed, 27 Apr 2022 22:33:30 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] KVM: arm64: Inject exception on out-of-IPA-range
 translation fault
In-Reply-To: <20220421153949.2931552-1-maz@kernel.org>
References: <20220421153949.2931552-1-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <f317899241aaf6858e3419f23800b987@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com, qperret@google.com, will@kernel.org, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-04-21 16:39, Marc Zyngier wrote:
> When taking an translation fault for an IPA that is outside of
> the range defined by the hypervisor (between the HW PARange and
> that exposed to the guest), we stupidly treat it as an IO and
> forward the access to userspace. Of course, userspace can't do
> much with it, and things end badly.
> 
> Arguably, the guest is braindead, but we should at least catch the
> case and inject an exception.
> 
> Check the faulting IPA against the IPA size the VM has, and
> inject an Address Size Fault at level 0 if the access fails the
> check.

I'm having second thoughts about this last point.
t
As it turns out, we do no override the PARange exposed to the guest,
and it sees the sanitised HW version. Which makes sense, as the
IPA range is much more fine grained than the PARange (1 bit for
IPA range, 4 bits for PARange).

So a fault can fall into a number of "don't do that" categories:
- outside of the *physical* PARange: the HW injects an AS fault
- outside of the *sanitised* PARange: KVM must inject an AS fault
- between IPA range and PARange: KVM must inject a external abort

This patch merges the last two cases, which is a bit wrong.

I'll repost an updated version and queue it for 5.18.

         M.
-- 
Jazz is not dead. It just smells funny...

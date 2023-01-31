Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36EA6838FC
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 23:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjAaWBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 17:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjAaWB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 17:01:29 -0500
Received: from out-48.mta1.migadu.com (out-48.mta1.migadu.com [IPv6:2001:41d0:203:375::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF7C54200
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 14:01:17 -0800 (PST)
Date:   Tue, 31 Jan 2023 22:01:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675202475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hF/1JIX2REtL2/Qz1+cxYWhMMeoRoACTMXxfqUjUYco=;
        b=sY3qNs0mkwHpAxOAoD2c7kJV/kexu8at9z88dznVcZhFHU+7QsXakoHxbV2FWdCWmnzWyt
        YQqJunw3Si1f7XenSCEDk9ZyKDlA2SFkHhqqNyIsOFRRRC1TMGOKXbbf4teF6U7HTQl9Cf
        bzdn+tF4IY2LYFeT/iHdC3uCbMBFTek=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v8 01/69] arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
Message-ID: <Y9mPpijHEinJkRQZ@google.com>
References: <20230131092504.2880505-1-maz@kernel.org>
 <20230131092504.2880505-2-maz@kernel.org>
 <b7dbe85e-c7f8-48ad-e1af-85befabd8509@arm.com>
 <86cz6u248j.wl-maz@kernel.org>
 <3c15760c-c76f-3d5d-a661-442459ce4e07@arm.com>
 <Y9l0PzgnKZiFJjvp@google.com>
 <871qnae6ov.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qnae6ov.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 09:26:56PM +0000, Marc Zyngier wrote:
> On Tue, 31 Jan 2023 20:04:15 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:
> > Marc, I'm curious, how do you plan to glue hVHE + NV together (if at
> > all)? We may need two separate options for this so the user could
> > separately configure NV for their hVHE KVM instance.
> 
> I really don't plan to support them together. But if we wanted to
> support something, I'd rather express it as a composition of the
> various options, as I suggested to Suzuki earlier. Something along the
> lines of:
> 
> 	kvm-arm.mode=hvhe,nested
> 
> But the extra complexity is mind-boggling, frankly. And the result
> will suck terribly. NV is already exit-heavy, compared to single-level
> virtualisation. But now you double the cost of the exit by moving all
> the load/put work into the entry-exit phase.

Oh yeah, that wasn't a feature request, just wanted to pick your brain
for a moment :) Hopefully nobody comes along asking for it in the
future, heh.

-- 
Thanks,
Oliver

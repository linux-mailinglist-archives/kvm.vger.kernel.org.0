Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B456CFBBE
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 08:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjC3Gm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 02:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjC3Gm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 02:42:58 -0400
Received: from out-31.mta0.migadu.com (out-31.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155BBC1
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 23:42:54 -0700 (PDT)
Date:   Thu, 30 Mar 2023 06:42:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680158572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UUNTmfY0fOvsY7bCYHRcY0CifEjhLb/ZBB0rxOVTkWw=;
        b=diSsM9vVRakxTDZtGuQYw6QXrbLjEJp1FY2lxYGXXgZJYd2XODjZapKBAQ05I717+/PMmA
        Sfmsekn6yMOLJWjfEq/9DUrrHY8rgQv96YwNTJLz+ea7Qrcu5yeXXD8Uzzz7uUXhQfx8Ot
        KHgrDaLYVm+XPEs9Gtr5EtgdMB4vVR8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: Re: [PATCH v3 05/18] KVM: arm64: timers: Allow physical offset
 without CNTPOFF_EL2
Message-ID: <ZCUvZ9yhfRSKRb3n@linux.dev>
References: <20230324144704.4193635-1-maz@kernel.org>
 <20230324144704.4193635-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324144704.4193635-6-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Marc,

On Fri, Mar 24, 2023 at 02:46:51PM +0000, Marc Zyngier wrote:
> CNTPOFF_EL2 is awesome, but it is mostly vapourware, and no publicly
> available implementation has it. So for the common mortals, let's
> implement the emulated version of this thing.
> 
> It means trapping accesses to the physical counter and timer, and
> emulate some of it as necessary.
> 
> As for CNTPOFF_EL2, nobody sets the offset yet.

Did you consider implementing a 'fast' exit handler for counter reads?
When I took a stab at this a long time ago I had something similar [*].
Since physical counter emulation is going to effectively be used by all
systems out there right now it might be worth giving the best emulation
implementation we can.

[*]: https://lore.kernel.org/kvmarm/20210916181510.963449-9-oupton@google.com/

-- 
Thanks,
Oliver

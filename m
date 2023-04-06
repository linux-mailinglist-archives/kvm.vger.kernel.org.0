Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFDF36D9E07
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 18:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239799AbjDFQ4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 12:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239769AbjDFQ4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 12:56:40 -0400
Received: from out-37.mta1.migadu.com (out-37.mta1.migadu.com [IPv6:2001:41d0:203:375::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A5A559F
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 09:56:38 -0700 (PDT)
Date:   Thu, 6 Apr 2023 16:56:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680800196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hWGOnY/KsMmqLwQwCb4u5bdX0ysrjDAt55lAt16ploc=;
        b=NkEI1OIm2rU+3hnzMAsNu8DP68SPnZe0M2ge3UVbzLNf1YONeH1Gi8YIQLAloNq3dSiNlY
        ffsdK8Z+2FqZ8aeK5SPUHLcgJGXlXWPdDURaPVXEphxj5lPLstWvPVXSs3pKOYa+VPRwQN
        LJKwv5rO9zKBmeN5t4cCCkAEV8t10QU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/2] KVM: arm64: nvhe: Synchronise with page table walker
 on MMU update
Message-ID: <ZC75v6kEe06omSc6@linux.dev>
References: <20230330100419.1436629-1-maz@kernel.org>
 <20230330100419.1436629-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330100419.1436629-2-maz@kernel.org>
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

On Thu, Mar 30, 2023 at 11:04:18AM +0100, Marc Zyngier wrote:
> When taking an exception between the EL1&0 translation regime and
> the EL2 translation regime, the page table walker is allowed to
> complete the walks started from EL0 or EL1 while running at EL2.
> 
> It means that altering the system registers that define the EL1&0
> translation regime is fraught with danger *unless* we wait for
> the completion of such walk with a DSB (R_LFHQG and subsequent
> statements in the ARM ARM). We already did the right thing for
> other external agents (SPE, TRBE), but not the PTW.
> 
> In the case of nVHE, this is a bit involved, as there are a number
> of situations where this can happen (such as switching between
> host and guest, invalidating TLBs...).

I'm assuming that the dsb(ishst) done in some of the other TLB
invalidation handlers is sufficient, as R_LFHQG does not describe the
scope of the DSB (i.e. loads and/or stores). Nonetheless, short of any
special serialization rules, it seems probable for the PTW to have both
outstanding loads and stores.

Is there some other language in the architecture that speaks to the
effects of _any_ DSB on the PTW? I couldn't find it myself. In any case,
I'll have to take you at your word if you say it is sufficient :)

-- 
Thanks,
Oliver

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEAD6E030A
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 02:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjDMAKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 20:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDMAKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 20:10:07 -0400
Received: from out-35.mta0.migadu.com (out-35.mta0.migadu.com [91.218.175.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37201B3
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 17:10:06 -0700 (PDT)
Date:   Thu, 13 Apr 2023 00:10:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681344604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wt4vsusNSg8/0nu8Bm5XWvB2zO4ZKlMCIL7i+a135ko=;
        b=pqPkcZy6S9lNv60O6xjf9Of4MIiZzeQEzH3uEimM/yQehZTSUpmjAfEuAWm9VwCuEYU+zo
        OQJ9QQy5cp+bVYgMYE5YiJJHsUoBk2QV4ZhIQTXaYAju0DZ6sT9Qx00gnIP9eRD5YQjX67
        hDdVZvUJs9W7WDOgfCWGns3HyzqBHA8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 1/5] KVM: arm64: nvhe: Synchronise with page table
 walker on vcpu run
Message-ID: <ZDdIWIIogROyg1zD@linux.dev>
References: <20230408160427.10672-1-maz@kernel.org>
 <20230408160427.10672-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408160427.10672-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 08, 2023 at 05:04:23PM +0100, Marc Zyngier wrote:
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
> Rework the existing SPE/TRBE synchronisation to include the PTW,
> and add the missing DSB on guest exit.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

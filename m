Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A84A695AB0
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 08:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjBNHda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 02:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjBNHd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 02:33:28 -0500
Received: from out-5.mta1.migadu.com (out-5.mta1.migadu.com [IPv6:2001:41d0:203:375::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9D812F18
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 23:33:27 -0800 (PST)
Date:   Tue, 14 Feb 2023 07:33:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676360005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ad/et/OIgS8gRdWL64gbaVO61dCrO/Lf6mmXhJYxJZc=;
        b=AGqkcIYhjtK3mjDdkr5sFTpnh+YoGyX8qgFC/ozYJ3DKUulZL0zLptH+Gz9uAnStY8sMmg
        y6jWC3WIYleMGpT9ut/RuRARrCmQBXQT2+ER34QBj23OP7GCB1FX/XVb6J9/WKtqJH7rNM
        tLB/XVn88PF/r9WzWftRIbFc72pPIn8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Gavin Shan <gshan@redhat.com>
Cc:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com
Subject: Re: [PATCH v2 00/12] Implement Eager Page Splitting for ARM.
Message-ID: <Y+s5PwV1l60jXal1@linux.dev>
References: <20230206165851.3106338-1-ricarkol@google.com>
 <1a3afa6d-3478-31dd-6f34-52075875c2fa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a3afa6d-3478-31dd-6f34-52075875c2fa@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gavin,

On Tue, Feb 14, 2023 at 04:57:59PM +1100, Gavin Shan wrote:
> On 2/7/23 3:58 AM, Ricardo Koller wrote:

<snip>

> > Eager Page Splitting fixes the above two issues by eagerly splitting
> > huge-pages when enabling dirty logging. The goal is to avoid doing it
> > while faulting on write-protected pages.

</snip>

> I'm not sure why we can't eagerly split the PMD mapping into 512 PTE
> mapping in the page fault handler?

The entire goal of the series is to avoid page splitting at all on the
stage-2 abort path. Ideally we want to minimize the time taken to handle
a fault so we can get back to running the guest. The requirement to
perform a break-before-make operation to change the mapping granularity
can, as Ricardo points out, be a bottleneck on contemporary implementations.

There is a clear uplift with the proposed implementation already, and I
would expect that margin to widen if/when we add support for lockless
(i.e. RCU-protected) permission relaxation.

> In the implementation, the newly introduced API
> kvm_pgtable_stage2_split() calls to kvm_pgtable_stage2_create_unlinked()
> and then stage2_map_walker(), which is part of kvm_pgtable_stage2_map(),
> to create the unlinked page tables.

This is deliberate code reuse. Page table construction in the fault path
is largely similar to that of eager split besides the fact that one is
working on 'live' page tables whereas the other is not. As such I gave
the suggestion to Ricardo to reuse what we have today for the sake of
eager splitting.

-- 
Thanks,
Oliver

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E22628750
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 18:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbiKNRmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 12:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237250AbiKNRmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 12:42:15 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E9B26AEE
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 09:42:11 -0800 (PST)
Date:   Mon, 14 Nov 2022 17:42:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668447730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=81grqjfzDbXvj/kXaN38dFg6IyEuzMGxJS1cZ3BwExg=;
        b=BYYs+S93PrA9vVkBPWsRJ92HUs5Bu24WxHWBumocLkBoLuv73fHHvwn4/0+o2MapvGeTyT
        RPXB5tTSzzkHJlhJt2zzpoKv+E3mEZPegjVH8mRb1KektxarogfmLvmou14ILn5UAplWns
        JjLprqhlcu/VJzDptSMXok7eHx8HAnk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y3J97ZTef8HLUv4i@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
 <CGME20221114142915eucas1p258f3ca2c536bde712c068e96851468fd@eucas1p2.samsung.com>
 <d9854277-0411-8169-9e8b-68d15e4c0248@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d9854277-0411-8169-9e8b-68d15e4c0248@samsung.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marek,

On Mon, Nov 14, 2022 at 03:29:14PM +0100, Marek Szyprowski wrote:
> This patch landed in today's linux-next (20221114) as commit 
> c3119ae45dfb ("KVM: arm64: Protect stage-2 traversal with RCU"). 
> Unfortunately it introduces a following warning:

Thanks for the bug report :) I had failed to test nVHE in the past few
revisions of this series.

> --->8---
> 
> kvm [1]: IPA Size Limit: 40 bits
> BUG: sleeping function called from invalid context at 
> include/linux/sched/mm.h:274
> in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
> preempt_count: 0, expected: 0
> RCU nest depth: 1, expected: 0
> 2 locks held by swapper/0/1:
>   #0: ffff80000a8a44d0 (kvm_hyp_pgd_mutex){+.+.}-{3:3}, at: 
> __create_hyp_mappings+0x80/0xc4
>   #1: ffff80000a927720 (rcu_read_lock){....}-{1:2}, at: 
> kvm_pgtable_walk+0x0/0x1f4
> CPU: 2 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc3+ #5918
> Hardware name: Raspberry Pi 3 Model B (DT)
> Call trace:
>   dump_backtrace.part.0+0xe4/0xf0
>   show_stack+0x18/0x40
>   dump_stack_lvl+0x8c/0xb8
>   dump_stack+0x18/0x34
>   __might_resched+0x178/0x220
>   __might_sleep+0x48/0xa0
>   prepare_alloc_pages+0x178/0x1a0
>   __alloc_pages+0x9c/0x109c
>   alloc_page_interleave+0x1c/0xc4
>   alloc_pages+0xec/0x160
>   get_zeroed_page+0x1c/0x44
>   kvm_hyp_zalloc_page+0x14/0x20
>   hyp_map_walker+0xd4/0x134
>   kvm_pgtable_visitor_cb.isra.0+0x38/0x5c
>   __kvm_pgtable_walk+0x1a4/0x220
>   kvm_pgtable_walk+0x104/0x1f4
>   kvm_pgtable_hyp_map+0x80/0xc4
>   __create_hyp_mappings+0x9c/0xc4
>   kvm_mmu_init+0x144/0x1cc
>   kvm_arch_init+0xe4/0xef4
>   kvm_init+0x3c/0x3d0
>   arm_init+0x20/0x30
>   do_one_initcall+0x74/0x400
>   kernel_init_freeable+0x2e0/0x350
>   kernel_init+0x24/0x130
>   ret_from_fork+0x10/0x20
> kvm [1]: Hyp mode initialized successfully
> 
> --->8----
> 
> I looks that more changes in the KVM code are needed to use RCU for that 
> code.

Right, the specific issue is that while the stage-2 walkers preallocate
any table memory they may need, the hyp walkers do not and allocate
inline.

As hyp stage-1 is protected by a spinlock there is no actual need for
RCU in that case. I'll post something later on today that addresses the
issue.

--
Thanks,
Oliver

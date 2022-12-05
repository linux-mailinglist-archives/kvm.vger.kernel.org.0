Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32AE16423D4
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 08:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbiLEHrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 02:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiLEHry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 02:47:54 -0500
Received: from out-32.mta0.migadu.com (out-32.mta0.migadu.com [IPv6:2001:41d0:1004:224b::20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8F09FD9
        for <kvm@vger.kernel.org>; Sun,  4 Dec 2022 23:47:52 -0800 (PST)
Date:   Mon, 5 Dec 2022 07:47:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670226470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SFXhjNJg/VGPR+qxqlId1yoMGevAJPF/9BAlI3Cx2LA=;
        b=LJp3jOesyzRjTIuPb3DvoBKpuxdiD0unikmxKd/WI9yo1C1EXz5ugIhfzHFePqnQa4WDFD
        jPgrMzq9BgeuTbF7NIP2T3Z3TQgYU4WESPWTJHyzBe/fPwtZaZq/6Dv7WhmjlIVbq+rRiC
        o4NsCnDOQi4URroo/lRFqwzzWrLSs7c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
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
Message-ID: <Y42iIXWbwxQ138fI@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
 <CGME20221114142915eucas1p258f3ca2c536bde712c068e96851468fd@eucas1p2.samsung.com>
 <d9854277-0411-8169-9e8b-68d15e4c0248@samsung.com>
 <Y3J97ZTef8HLUv4i@google.com>
 <Y42G0c9yBk2KHc+g@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y42G0c9yBk2KHc+g@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mingwei,

On Mon, Dec 05, 2022 at 05:51:13AM +0000, Mingwei Zhang wrote:
> On Mon, Nov 14, 2022, Oliver Upton wrote:

[...]

> > As hyp stage-1 is protected by a spinlock there is no actual need for
> > RCU in that case. I'll post something later on today that addresses the
> > issue.
> > 
> 
> For each stage-2 page table walk, KVM will use
> kvm_mmu_topup_memory_cache() before taking the mmu lock. This ensures
> whoever holding the mmu lock won't sleep. hyp walkers seems to
> miss  this notion completely, whic makes me puzzeled. Using a spinlock
> only ensures functionality but seems quite inefficient if the one who
> holds the spinlock try to allocate pages and sleep...

You're probably confused by my mischaracterization in the above
paragraph. Hyp stage-1 walkers (outside of pKVM) are guarded with a
mutex and are perfectly able to sleep. The erroneous application of RCU
led to this path becoming non-sleepable, hence the bug.

pKVM's own hyp stage-1 walkers are guarded by a spinlock, but the memory
allocations come from its own allocator and there is no concept of a
scheduler at EL2.

> Why do we need an RCU lock here. Oh is it for batching?

We definitely don't need RCU here, thus the corrective measure was to
avoid RCU for exclusive table walks.

https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=next&id=b7833bf202e3068abb77c642a0843f696e9c8d38

--
Thanks,
Oliver

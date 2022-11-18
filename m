Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F9162FC84
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 19:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242672AbiKRSXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 13:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242674AbiKRSWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 13:22:43 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9649F9737E;
        Fri, 18 Nov 2022 10:22:40 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668795758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+uOM/Fua4rhDVOWefaZ8Uq5AA7UeFgjxJb3kFrB+tz4=;
        b=EI93hjYHkqlernG2+yC6o8UByESVp2FCWuzQD0gzXgeNCSKZPJ9WCc3OrNqzHbk3vz1q+B
        RU7LXauCNfP2WenYN272ma1Mww+UaS1WDm2Hm3qtzpIv7jIUBtlUFQgeCeEtCXM5141r/5
        82I1DTf2dYq5ORX4Hog6LQXJfhtql7I=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/3] KVM: arm64: Don't acquire RCU read lock for exclusive table walks
Date:   Fri, 18 Nov 2022 18:22:21 +0000
Message-Id: <20221118182222.3932898-3-oliver.upton@linux.dev>
In-Reply-To: <20221118182222.3932898-1-oliver.upton@linux.dev>
References: <20221118182222.3932898-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marek reported a BUG resulting from the recent parallel faults changes,
as the hyp stage-1 map walker attempted to allocate table memory while
holding the RCU read lock:

  BUG: sleeping function called from invalid context at
  include/linux/sched/mm.h:274
  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
  preempt_count: 0, expected: 0
  RCU nest depth: 1, expected: 0
  2 locks held by swapper/0/1:
    #0: ffff80000a8a44d0 (kvm_hyp_pgd_mutex){+.+.}-{3:3}, at:
  __create_hyp_mappings+0x80/0xc4
    #1: ffff80000a927720 (rcu_read_lock){....}-{1:2}, at:
  kvm_pgtable_walk+0x0/0x1f4
  CPU: 2 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc3+ #5918
  Hardware name: Raspberry Pi 3 Model B (DT)
  Call trace:
    dump_backtrace.part.0+0xe4/0xf0
    show_stack+0x18/0x40
    dump_stack_lvl+0x8c/0xb8
    dump_stack+0x18/0x34
    __might_resched+0x178/0x220
    __might_sleep+0x48/0xa0
    prepare_alloc_pages+0x178/0x1a0
    __alloc_pages+0x9c/0x109c
    alloc_page_interleave+0x1c/0xc4
    alloc_pages+0xec/0x160
    get_zeroed_page+0x1c/0x44
    kvm_hyp_zalloc_page+0x14/0x20
    hyp_map_walker+0xd4/0x134
    kvm_pgtable_visitor_cb.isra.0+0x38/0x5c
    __kvm_pgtable_walk+0x1a4/0x220
    kvm_pgtable_walk+0x104/0x1f4
    kvm_pgtable_hyp_map+0x80/0xc4
    __create_hyp_mappings+0x9c/0xc4
    kvm_mmu_init+0x144/0x1cc
    kvm_arch_init+0xe4/0xef4
    kvm_init+0x3c/0x3d0
    arm_init+0x20/0x30
    do_one_initcall+0x74/0x400
    kernel_init_freeable+0x2e0/0x350
    kernel_init+0x24/0x130
    ret_from_fork+0x10/0x20

Since the hyp stage-1 table walkers are serialized by kvm_hyp_pgd_mutex,
RCU protection really doesn't add anything. Don't acquire the RCU read
lock for an exclusive walk.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 14 ++++++++------
 arch/arm64/kvm/hyp/pgtable.c         |  4 ++--
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index f23af693e3c5..4b6b52ebc11c 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -229,8 +229,8 @@ static inline kvm_pte_t *kvm_dereference_pteref(struct kvm_pgtable_walker *walke
 	return pteref;
 }
 
-static inline void kvm_pgtable_walk_begin(void) {}
-static inline void kvm_pgtable_walk_end(void) {}
+static inline void kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker) {}
+static inline void kvm_pgtable_walk_end(struct kvm_pgtable_walker *walker) {}
 
 static inline bool kvm_pgtable_walk_lock_held(void)
 {
@@ -247,14 +247,16 @@ static inline kvm_pte_t *kvm_dereference_pteref(struct kvm_pgtable_walker *walke
 	return rcu_dereference_check(pteref, !(walker->flags & KVM_PGTABLE_WALK_SHARED));
 }
 
-static inline void kvm_pgtable_walk_begin(void)
+static inline void kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
 {
-	rcu_read_lock();
+	if (walker->flags & KVM_PGTABLE_WALK_SHARED)
+		rcu_read_lock();
 }
 
-static inline void kvm_pgtable_walk_end(void)
+static inline void kvm_pgtable_walk_end(struct kvm_pgtable_walker *walker)
 {
-	rcu_read_unlock();
+	if (walker->flags & KVM_PGTABLE_WALK_SHARED)
+		rcu_read_unlock();
 }
 
 static inline bool kvm_pgtable_walk_lock_held(void)
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b5b91a882836..d6f3753cb87e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -289,9 +289,9 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	};
 	int r;
 
-	kvm_pgtable_walk_begin();
+	kvm_pgtable_walk_begin(walker);
 	r = _kvm_pgtable_walk(pgt, &walk_data);
-	kvm_pgtable_walk_end();
+	kvm_pgtable_walk_end(walker);
 
 	return r;
 }
-- 
2.38.1.584.g0f3c55d4c2-goog


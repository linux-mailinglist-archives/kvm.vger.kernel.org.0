Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6346662FC86
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 19:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242747AbiKRSX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 13:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242677AbiKRSWq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 13:22:46 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603709209A;
        Fri, 18 Nov 2022 10:22:43 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668795761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7go3+H51QR8+lH2MFJhouDdMualoRRzB14E5HXw/Lg4=;
        b=OU0PXGROkLqlvr+0xrh4JUkII6X/ARfgpVkJYuvfJrYF3OJPVmFKIy2YhSD8EPhLuQ7Bpy
        CMW1W+zHgGVDkMpkWVIPdz25L/dWzYFudVc3ine+AMpyGs2g8ZmVFxvEeFEMBnMvMGShBO
        W5EPNzAH9+x+8p5fi2zfLnap/xhqNbU=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/3] KVM: arm64: Reject shared table walks in the hyp code
Date:   Fri, 18 Nov 2022 18:22:22 +0000
Message-Id: <20221118182222.3932898-4-oliver.upton@linux.dev>
In-Reply-To: <20221118182222.3932898-1-oliver.upton@linux.dev>
References: <20221118182222.3932898-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Exclusive table walks are the only supported table walk in the hyp, as
there is no construct like RCU available in the hypervisor code. Reject
any attempt to do a shared table walk by returning an error and allowing
the caller to clean up the mess.

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 17 +++++++++++++++--
 arch/arm64/kvm/hyp/pgtable.c         |  5 ++++-
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 4b6b52ebc11c..d5cb01f8dc06 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -229,7 +229,18 @@ static inline kvm_pte_t *kvm_dereference_pteref(struct kvm_pgtable_walker *walke
 	return pteref;
 }
 
-static inline void kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker) {}
+static inline int kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
+{
+	/*
+	 * Due to the lack of RCU (or a similar protection scheme), only
+	 * non-shared table walkers are allowed in the hypervisor.
+	 */
+	if (walker->flags & KVM_PGTABLE_WALK_SHARED)
+		return -EPERM;
+
+	return 0;
+}
+
 static inline void kvm_pgtable_walk_end(struct kvm_pgtable_walker *walker) {}
 
 static inline bool kvm_pgtable_walk_lock_held(void)
@@ -247,10 +258,12 @@ static inline kvm_pte_t *kvm_dereference_pteref(struct kvm_pgtable_walker *walke
 	return rcu_dereference_check(pteref, !(walker->flags & KVM_PGTABLE_WALK_SHARED));
 }
 
-static inline void kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
+static inline int kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
 {
 	if (walker->flags & KVM_PGTABLE_WALK_SHARED)
 		rcu_read_lock();
+
+	return 0;
 }
 
 static inline void kvm_pgtable_walk_end(struct kvm_pgtable_walker *walker)
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index d6f3753cb87e..58dbe0ab567f 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -289,7 +289,10 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	};
 	int r;
 
-	kvm_pgtable_walk_begin(walker);
+	r = kvm_pgtable_walk_begin(walker);
+	if (r)
+		return r;
+
 	r = _kvm_pgtable_walk(pgt, &walk_data);
 	kvm_pgtable_walk_end(walker);
 
-- 
2.38.1.584.g0f3c55d4c2-goog


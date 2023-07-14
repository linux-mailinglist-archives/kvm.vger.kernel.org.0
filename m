Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85924753318
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbjGNHW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235395AbjGNHWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:22:51 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7C0358C;
        Fri, 14 Jul 2023 00:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689319359; x=1720855359;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=dXHUrVqTsBzck553w5GbptEVC8cgKTaiRMcUQpmhAWg=;
  b=m6TyDK4673WDnKHhPDlm+0HlRumfU4GdMCQAx//Vdxp2ZzK+G5w2nPCt
   /8uyqiYBRlbfuQblzkUvHFMj4vHxlmUC9Hts5kWb8D0xwR2U6InA/K4pX
   iOSHpd5OBCU7QanafFHAIf1cgvinTeiioU2IhW3SiA5Hh7nZcecZhyUoe
   yGlI53CaArmQJZi83hsNei5A88fBvqKKhkxXBf0deaBeK9xxQWg68mEPB
   6HnsBihHhJ0KT8RcpaSxu9164+pAw/WXm1flVsn/8r/pLw+wTNhAHpAr/
   BqpOrevwZAAb24QgPdXTR/C+Y4xlrauyg+HJ3yRUafoRuiFe+OevqFrCk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="345727883"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="345727883"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:22:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="896317393"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="896317393"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:22:36 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        yuan.yao@linux.intel.com, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 11/12] KVM: x86/mmu: split a single gfn zap range when guest MTRRs are honored
Date:   Fri, 14 Jul 2023 14:56:02 +0800
Message-Id: <20230714065602.20805-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230714064656.20147-1-yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split a single gfn zap range (specifially range [0, ~0UL)) to smaller
ranges according to current memslot layout when guest MTRRs are honored.

Though vCPUs have been serialized to perform kvm_zap_gfn_range() for MTRRs
updates and CR0.CD toggles, contention caused rescheduling cost is still
huge when there're concurrent page fault holding mmu_lock for read.

Split a single huge zap range according to the actual memslot layout can
reduce unnecessary transversal and yielding cost in tdp mmu.
Also, it can increase the chances for larger ranges to find existing ranges
to zap in zap list.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mtrr.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 9fdbdbf874a8..00e98dfc4b0d 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -909,21 +909,44 @@ static void kvm_zap_or_wait_mtrr_zap_list(struct kvm *kvm)
 static void kvm_mtrr_zap_gfn_range(struct kvm_vcpu *vcpu,
 				   gfn_t gfn_start, gfn_t gfn_end)
 {
+	int idx = srcu_read_lock(&vcpu->kvm->srcu);
+	const struct kvm_memory_slot *memslot;
 	struct mtrr_zap_range *range;
+	struct kvm_memslot_iter iter;
+	struct kvm_memslots *slots;
+	gfn_t start, end;
+	int i;
 
-	range = kmalloc(sizeof(*range), GFP_KERNEL_ACCOUNT);
-	if (!range)
-		goto fail;
-
-	range->start = gfn_start;
-	range->end = gfn_end;
-
-	kvm_add_mtrr_zap_list(vcpu->kvm, range);
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(vcpu->kvm, i);
+		kvm_for_each_memslot_in_gfn_range(&iter, slots, gfn_start, gfn_end) {
+			memslot = iter.slot;
+			start = max(gfn_start, memslot->base_gfn);
+			end = min(gfn_end, memslot->base_gfn + memslot->npages);
+			if (WARN_ON_ONCE(start >= end))
+				continue;
+
+			range = kmalloc(sizeof(*range), GFP_KERNEL_ACCOUNT);
+			if (!range)
+				goto fail;
+
+			range->start = start;
+			range->end = end;
+
+			/*
+			 * Redundent ranges in different address space will be
+			 * removed in kvm_add_mtrr_zap_list().
+			 */
+			kvm_add_mtrr_zap_list(vcpu->kvm, range);
+		}
+	}
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
 	kvm_zap_or_wait_mtrr_zap_list(vcpu->kvm);
 	return;
 
 fail:
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	kvm_zap_gfn_range(vcpu->kvm, gfn_start, gfn_end);
 }
 
-- 
2.17.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD3B7325A0
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 05:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241627AbjFPDHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 23:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241646AbjFPDHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 23:07:38 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C8F2D40;
        Thu, 15 Jun 2023 20:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686884846; x=1718420846;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=0qVLWf99lh56KC7DV9RlLyblgh+kyME9c2tLdLIauOU=;
  b=cIfU7OqXRv4tSSIg6RzmWDwBxNdocnnBfmbPh5goFNgwEiQHQGPMwzJT
   RPIm+bVBzkkuKwdTrwzKQIobQ0C6JUP0Vil7uM6ml0jAwlQIIbEJcagLE
   1thwxWiKnbTln/zFLb00fdZO2VMO3KHv3suOUkAuq09YFGLJ8jp7tpbOo
   zs49FiaRmpvGaJrUvuyXoR6KM9lEELZLxksLhlk4NUQyaNQ0D3Fo/8SeB
   QmD6awNgGLROs+bp9hI2sUWc1RI/3UnL4q7tVe4+OwvZYagZn+LHzX0E2
   kP2omGVAnI13R9o2pYNdjummuH0nDS11XK28UKW51ts1GICPcTGnEFfXg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="387736540"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="387736540"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:07:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="742483474"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="742483474"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:07:23 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 11/11] KVM: x86/mmu: split a single gfn zap range when guest MTRRs are honored
Date:   Fri, 16 Jun 2023 10:42:13 +0800
Message-Id: <20230616024213.7706-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230616023101.7019-1-yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split a single gfn zap range (specifially range [0, ~0UL)) to smaller
ranges according to current memslot layout when guest MTRRs are honored.

Though vCPUs have been serialized to perform kvm_zap_gfn_range() for MTRRs
updates and CR0.CD toggles, contention caused rescheduling cost is still
huge when there're concurrent page fault caused read locks of
kvm->mmu_lock.

Split a single huge zap range according to the actual memslot layout can
reduce unnecessary transversal and scheduling cost in tdp mmu.
Also, it can increase the chances for larger ranges to find existing ranges
to zap in zap list.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mtrr.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index e2a097822a62..b83abd14ccb1 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -917,21 +917,40 @@ static void kvm_zap_or_wait_mtrr_zap_list(struct kvm *kvm)
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
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(vcpu->kvm, i);
+		kvm_for_each_memslot_in_gfn_range(&iter, slots, gfn_start, gfn_end) {
+			memslot = iter.slot;
+			start = max(gfn_start, memslot->base_gfn);
+			end = min(gfn_end, memslot->base_gfn + memslot->npages);
+			if (WARN_ON_ONCE(start >= end))
+				continue;
 
-	range = kmalloc(sizeof(*range), GFP_KERNEL_ACCOUNT);
-	if (!range)
-		goto fail;
+			range = kmalloc(sizeof(*range), GFP_KERNEL_ACCOUNT);
+			if (!range)
+				goto fail;
 
-	range->start = gfn_start;
-	range->end = gfn_end;
+			range->start = start;
+			range->end = end;
 
-	kvm_add_mtrr_zap_list(vcpu->kvm, range);
+			kvm_add_mtrr_zap_list(vcpu->kvm, range);
+		}
+	}
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
 	kvm_zap_or_wait_mtrr_zap_list(vcpu->kvm);
 	return;
 
 fail:
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	kvm_clear_mtrr_zap_list(vcpu->kvm);
 	kvm_zap_gfn_range(vcpu->kvm, gfn_start, gfn_end);
 }
-- 
2.17.1


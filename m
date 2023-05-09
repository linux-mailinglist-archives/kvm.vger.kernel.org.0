Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2CA6FC89E
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 16:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbjEIOP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 10:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235794AbjEIOP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 10:15:28 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D11B40C9;
        Tue,  9 May 2023 07:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683641722; x=1715177722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=vihWXicRD+3O+AhuYtdyTHXD4NO+CZOfdeB7IWKIjnU=;
  b=iVMw+mPuNHBktWvx9nZ1U8TQWLdnE+IUtqmYdLHLEmFxoKsoj8tZpXyA
   4SMTU5XPQw5oJZXRQWdrU2imdGPWIXjJEaQeAjo2IOSukRmMGmmuwMV8O
   3K7i0vQvTSfdcVa6gBhP9/Mgol0AIeSLjjnDxbK+rO+fTl+CILmpS+M8f
   /+F0mvg14d5aSLt+OJbD8Pf4CV3ZNgHcXxr38Omftv4byuSNASDlcBUfZ
   3QyS9kbkH/u+7xwDbNnLuHcun+DsgaRy2OTIh3mTa7WXBCCO5INQ3ruQR
   kSQBqQlnuSnWjGCQCx46/zjBdTK5DlnIb26qvOClz5yRSetr4oMojXB6U
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="378034005"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="378034005"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 07:15:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="810701818"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="810701818"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 07:15:20 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 1/6] KVM: x86/mmu: add a new mmu zap helper to indicate memtype changes
Date:   Tue,  9 May 2023 21:50:06 +0800
Message-Id: <20230509135006.1604-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230509134825.1523-1-yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
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

Add a helper to indicate that the kvm_zap_gfn_range() request is to update
memory type.

Then the zap can be avoided in cases:
1. TDP is not enabled.
2. EPT is not enabled.

This is because only memory type of EPT leaf entries are subjected to
change when noncoherent DMA/guest CR0.CD/guest MTRR settings change.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu.h     |  1 +
 arch/x86/kvm/mmu/mmu.c | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 92d5a1924fc1..a04577afbc71 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -236,6 +236,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 }
 
 void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
+void kvm_zap_gfn_for_memtype(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8961f45e3b1..2706754794d1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6272,6 +6272,22 @@ static bool kvm_rmap_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_e
 	return flush;
 }
 
+/*
+ * Invalidate (zap) TDP SPTEs that cover GFNs from gfn_start and up to gfn_end
+ * (not including it) for reason of memory type being updated.
+ */
+void kvm_zap_gfn_for_memtype(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
+{
+	/* Currently only memory type of EPT leaf entries are affected by
+	 * guest CR0.CD and guest MTRR.
+	 * So skip invalidation (zap) in other cases
+	 */
+	if (!shadow_memtype_mask)
+		return;
+
+	kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
+}
+
 /*
  * Invalidate (zap) SPTEs that cover GFNs from gfn_start and up to gfn_end
  * (not including it)
-- 
2.17.1


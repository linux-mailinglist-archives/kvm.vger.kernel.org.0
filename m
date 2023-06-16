Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE67873259C
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 05:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241505AbjFPDGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 23:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241420AbjFPDGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 23:06:47 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC4D297D;
        Thu, 15 Jun 2023 20:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686884806; x=1718420806;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=haZIAE2eU8HEF6uKNlr28ZLP3izTWpZyD2lkLgNpwh4=;
  b=nLsJNV6LnXMu6N56RugHPPdb7hG8Fa2WzNQKSXUotMSnmke0ANq1QfpP
   ZPyPcBIZWnfmwC8WTT2JI6hWXDEIo/v6PHTRovi9IUMd2473nK+doyV3Q
   T3mJPRYjs0L9u1orcsFRVlsE1PYp/ObgqCGcApYcnUsz/Nj6qY6UhVf7Y
   EdHs1HNF0t2GzXVMKAW/MlVm/JyMuyV2KkxQUL1medJPdzn3E4DRmeleM
   Of7L35iixx32N9RWpSc1sRKCEOTCnEhKq1k3BeX/Y/HaRuTzoBdGGIrey
   XxneMQKHpK6QcZcr5nMeEaNZM5pYTmQLFHq4QNdKo4LJQgCpyPvU/5L/K
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="445482981"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="445482981"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:06:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="690038845"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="690038845"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:06:43 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 10/11] KVM: x86/mmu: fine-grained gfn zap when guest MTRRs are honored
Date:   Fri, 16 Jun 2023 10:41:34 +0800
Message-Id: <20230616024134.7649-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230616023101.7019-1-yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Find out guest MTRR ranges of non-default type and only zap those ranges
when guest MTRRs are enabled and MTRR default type equals to the memtype of
CR0.CD=1.

This allows fine-grained and faster gfn zap because of precise and shorter
zap ranges, and increases chances for concurent vCPUs to find existing
ranges to zap in zap list.

Incidentally, fix a typo in the original comment.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mtrr.c | 108 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 688748e3a4d2..e2a097822a62 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -179,7 +179,7 @@ static struct fixed_mtrr_segment fixed_seg_table[] = {
 	{
 		.start = 0xc0000,
 		.end = 0x100000,
-		.range_shift = 12, /* 12K */
+		.range_shift = 12, /* 4K */
 		.range_start = 24,
 	}
 };
@@ -816,6 +816,67 @@ static void kvm_add_mtrr_zap_list(struct kvm *kvm, struct mtrr_zap_range *range)
 	spin_unlock(&kvm->arch.mtrr_zap_list_lock);
 }
 
+/*
+ * Fixed ranges are only 256 pages in total.
+ * After balancing between reducing overhead of zap multiple ranges
+ * and increasing chances of finding duplicated ranges,
+ * just add fixed mtrr ranges as a whole to the mtrr zap list
+ * if memory type of one of them is not the specified type.
+ */
+static int prepare_zaplist_fixed_mtrr_of_non_type(struct kvm_vcpu *vcpu, u8 type)
+{
+	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
+	struct mtrr_zap_range *range;
+	int index, seg_end;
+	u8 mem_type;
+
+	for (index = 0; index < KVM_NR_FIXED_MTRR_REGION; index++) {
+		mem_type = mtrr_state->fixed_ranges[index];
+
+		if (mem_type == type)
+			continue;
+
+		range = kmalloc(sizeof(*range), GFP_KERNEL_ACCOUNT);
+		if (!range)
+			return -ENOMEM;
+
+		seg_end = ARRAY_SIZE(fixed_seg_table) - 1;
+		range->start = gpa_to_gfn(fixed_seg_table[0].start);
+		range->end = gpa_to_gfn(fixed_seg_table[seg_end].end);
+		kvm_add_mtrr_zap_list(vcpu->kvm, range);
+		break;
+	}
+	return 0;
+}
+
+/*
+ * Add var mtrr ranges to the mtrr zap list
+ * if its memory type does not equal to type
+ */
+static int prepare_zaplist_var_mtrr_of_non_type(struct kvm_vcpu *vcpu, u8 type)
+{
+	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
+	struct mtrr_zap_range *range;
+	struct kvm_mtrr_range *tmp;
+	u8 mem_type;
+
+	list_for_each_entry(tmp, &mtrr_state->head, node) {
+		mem_type = tmp->base & 0xff;
+		if (mem_type == type)
+			continue;
+
+		range = kmalloc(sizeof(*range), GFP_KERNEL_ACCOUNT);
+		if (!range)
+			return -ENOMEM;
+
+		var_mtrr_range(tmp, &range->start, &range->end);
+		range->start = gpa_to_gfn(range->start);
+		range->end = gpa_to_gfn(range->end);
+		kvm_add_mtrr_zap_list(vcpu->kvm, range);
+	}
+	return 0;
+}
+
 static void kvm_zap_mtrr_zap_list(struct kvm *kvm)
 {
 	struct list_head *head = &kvm->arch.mtrr_zap_list;
@@ -875,7 +936,50 @@ static void kvm_mtrr_zap_gfn_range(struct kvm_vcpu *vcpu,
 	kvm_zap_gfn_range(vcpu->kvm, gfn_start, gfn_end);
 }
 
+/*
+ * Zap GFN ranges when CR0.CD toggles between 0 and 1.
+ * With noncoherent DMA present,
+ * when CR0.CD=1, TDP memtype is WB or UC + IPAT;
+ * when CR0.CD=0, TDP memtype is determined by guest MTRR.
+ * Therefore, if the cache disabled memtype is different from default memtype
+ * in guest MTRR, everything is zapped;
+ * if the cache disabled memtype is equal to default memtype in guest MTRR,
+ * only MTRR ranges of non-default-memtype are required to be zapped.
+ */
 void kvm_zap_gfn_range_on_cd_toggle(struct kvm_vcpu *vcpu)
 {
-	return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
+	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
+	bool mtrr_enabled = mtrr_is_enabled(mtrr_state);
+	u8 default_type;
+	u8 cd_type;
+	bool ipat;
+
+	kvm_mtrr_get_cd_memory_type(vcpu, &cd_type, &ipat);
+
+	default_type = mtrr_enabled ? mtrr_default_type(mtrr_state) :
+		       mtrr_disabled_type(vcpu);
+
+	if (cd_type != default_type || ipat)
+		return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
+
+	/*
+	 * If mtrr is not enabled, it will go to zap all above if the default
+	 * type does not equal to cd_type;
+	 * Or it has no need to zap if the default type equals to cd_type.
+	 */
+	if (mtrr_enabled) {
+		if (prepare_zaplist_fixed_mtrr_of_non_type(vcpu, default_type))
+			goto fail;
+
+		if (prepare_zaplist_var_mtrr_of_non_type(vcpu, default_type))
+			goto fail;
+
+		kvm_zap_or_wait_mtrr_zap_list(vcpu->kvm);
+	}
+	return;
+fail:
+	kvm_clear_mtrr_zap_list(vcpu->kvm);
+	/* resort to zapping all on failure*/
+	kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
+	return;
 }
-- 
2.17.1


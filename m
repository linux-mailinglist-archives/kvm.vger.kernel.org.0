Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F28753315
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbjGNHWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235391AbjGNHWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:22:12 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773D635B0;
        Fri, 14 Jul 2023 00:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689319326; x=1720855326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=JwujvIAhHDIhsRscSy/VyNy1PdDMfjp1hDs4yRNRsl0=;
  b=HCu/19A1wtQk9Wgv4lBPCu5JKD50QZSEdR6tNF9K/1pswnJ8zEXTDXaj
   6UoEGtl8mSlajCUv32g3OOukapTw/2v8KAj89tVhbT7dqWfwI58l3bf78
   DtIzMcQ13OHKsfhdJQwgja+ubBCL8l21pLliJuie8+8f2syXAqWyvDri3
   HALcR2dh2veBGpVosNFYaNlADolEAHEmmhJa0YKSRq/4u6Bh2zLwOw+H5
   EsqqnzjqrcB0o2RY0LQWcwTlQC2vxT+Ugyqhl1dQk9eq2pCPLXVQPlJQ8
   ICKdzv/xpVzPfsR6IGTVBChrhkxpRH3Hci6R9AZShMnuZ8TNiZPG1Q+q/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="362877539"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="362877539"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:22:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="835937381"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="835937381"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:22:03 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        yuan.yao@linux.intel.com, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 10/12] KVM: x86/mmu: fine-grained gfn zap when guest MTRRs are honored
Date:   Fri, 14 Jul 2023 14:55:30 +0800
Message-Id: <20230714065530.20748-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230714064656.20147-1-yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When guest MTRRs are honored and CR0.CD toggles, rather than blindly zap
everything, find out fine-grained ranges to zap according to guest MTRRs.

Fine-grained and precise zap ranges allow reduced traversal footprint
during zap and increased chances for concurrent vCPUs to find and skip
duplicated ranges to zap.

Opportunistically fix a typo in a nearby comment.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mtrr.c | 164 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 162 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 996a274cee40..9fdbdbf874a8 100644
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
@@ -747,6 +747,19 @@ struct mtrr_zap_range {
 	struct list_head node;
 };
 
+static void kvm_clear_mtrr_zap_list(struct kvm *kvm)
+{
+	struct list_head *head = &kvm->arch.mtrr_zap_list;
+	struct mtrr_zap_range *tmp, *n;
+
+	spin_lock(&kvm->arch.mtrr_zap_list_lock);
+	list_for_each_entry_safe(tmp, n, head, node) {
+		list_del(&tmp->node);
+		kfree(tmp);
+	}
+	spin_unlock(&kvm->arch.mtrr_zap_list_lock);
+}
+
 /*
  * Add @range into kvm->arch.mtrr_zap_list and sort the list in
  * "length" ascending + "start" descending order, so that
@@ -795,6 +808,67 @@ static void kvm_add_mtrr_zap_list(struct kvm *kvm, struct mtrr_zap_range *range)
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
@@ -853,7 +927,93 @@ static void kvm_mtrr_zap_gfn_range(struct kvm_vcpu *vcpu,
 	kvm_zap_gfn_range(vcpu->kvm, gfn_start, gfn_end);
 }
 
+/*
+ * Zap SPTEs when guest MTRRs are honored and CR0.CD toggles
+ * in fine-grained way according to guest MTRRs.
+ * As guest MTRRs are per-vCPU, they are unchanged across this function.
+ *
+ * when CR0.CD=1, TDP memtype is WB or UC + IPAT;
+ * when CR0.CD=0, TDP memtype is determined by guest MTRRs.
+ *
+ * On CR0.CD toggles, as guest MTRRs remain unchanged,
+ * - if old memtype are new memtype are equal, nothing needs to do;
+ * - if guest default MTRR type equals to memtype in CR0.CD=1,
+ *   only MTRR ranges of non-default-memtype are required to be zapped.
+ * - if guest default MTRR type !equals to memtype in CR0.CD=1,
+ *   everything is zapped because memtypes for almost all guest memory
+ *   are out-dated.
+ * _____________________________________________________________________
+ *| quirk on             | CD=1 to CD=0         | CD=0 to CD=1          |
+ *|                      | old memtype = WB     | new memtype = WB      |
+ *|----------------------|----------------------|-----------------------|
+ *| MTRR enabled         | new memtype =        | old memtype =         |
+ *|                      | guest MTRR type      | guest MTRR type       |
+ *|    ------------------|----------------------|-----------------------|
+ *|    | if default MTRR | zap non-WB guest     | zap non-WB guest      |
+ *|    | type == WB      | MTRR ranges          | MTRR ranges           |
+ *|    |-----------------|----------------------|-----------------------|
+ *|    | if default MTRR | zap all              | zap all               |
+ *|    | type != WB      | as almost all guest MTRR ranges are non-WB   |
+ *|----------------------|----------------------------------------------|
+ *| MTRR disabled        | new memtype = UC     | old memtype = UC      |
+ *| (w/ FEATURE_MTRR)    | zap all              | zap all               |
+ *|----------------------|----------------------|-----------------------|
+ *| MTRR disabled        | new memtype = WB     | old memtype = WB      |
+ *| (w/o FEATURE_MTRR)   | do nothing           | do nothing            |
+ *|______________________|______________________|_______________________|
+ *
+ * _____________________________________________________________________
+ *| quirk off     | CD=1 to CD=0             | CD=0 to CD=1             |
+ *|               | old memtype = UC + IPAT  | new memtype = UC + IPAT  |
+ *|---------------|--------------------------|--------------------------|
+ *| MTRR enabled  | new memtype = guest MTRR | old memtype = guest MTRR |
+ *|               | type (!= UC + IPAT)      | type (!= UC + IPAT)      |
+ *|               | zap all                  | zap all                  |
+ *|---------------|------------------------- |--------------------------|
+ *| MTRR disabled | new memtype = UC         | old memtype = UC         |
+ *| (w/           | (!= UC + IPAT)           | (!= UC + IPAT)           |
+ *| FEATURE_MTRR) | zap all                  | zap all                  |
+ *|---------------|--------------------------|--------------------------|
+ *| MTRR disabled | new memtype = WB         | old memtype = WB         |
+ *| (w/o          | (!= UC + IPAT)           | (!= UC + IPAT)           |
+ *| FEATURE_MTRR) | zap all                  | zap all                  |
+ *|_______________|__________________________|__________________________|
+ *
+ */
 void kvm_honors_guest_mtrrs_zap_on_cd_toggle(struct kvm_vcpu *vcpu)
 {
-	return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
+	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
+	bool mtrr_enabled = mtrr_is_enabled(mtrr_state);
+	u8 default_mtrr_type;
+	bool cd_ipat;
+	u8 cd_type;
+
+	kvm_honors_guest_mtrrs_get_cd_memtype(vcpu, &cd_type, &cd_ipat);
+
+	default_mtrr_type = mtrr_enabled ? mtrr_default_type(mtrr_state) :
+			    mtrr_disabled_type(vcpu);
+
+	if (cd_type != default_mtrr_type || cd_ipat)
+		return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
+
+	/*
+	 * If mtrr is not enabled, it will go to zap all above if the default
+	 * type does not equal to cd_type;
+	 * Or it has no need to zap if the default type equals to cd_type.
+	 */
+	if (mtrr_enabled) {
+		if (prepare_zaplist_fixed_mtrr_of_non_type(vcpu, default_mtrr_type))
+			goto fail;
+
+		if (prepare_zaplist_var_mtrr_of_non_type(vcpu, default_mtrr_type))
+			goto fail;
+
+		kvm_zap_or_wait_mtrr_zap_list(vcpu->kvm);
+	}
+	return;
+fail:
+	kvm_clear_mtrr_zap_list(vcpu->kvm);
+	/* resort to zapping all on failure*/
+	kvm_zap_gfn_range(vcpu->kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
+	return;
 }
-- 
2.17.1


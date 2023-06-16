Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE3173259A
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 05:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241340AbjFPDFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 23:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241691AbjFPDE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 23:04:59 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E70F2D58;
        Thu, 15 Jun 2023 20:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686884698; x=1718420698;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=gRnQaSa7yFgKDt0BHybvJWmtcW9MjixKOmKtXyz6GPg=;
  b=ZWwKHmhMMME9YavITx8fIQ/iTbKqkY7U6XV8N9HnQ6B92ZXEygNd7I8s
   ph22Qt/jSo5DdvwASY25JDAtIQUQD7qLR/XQBvF0JA+d2IcqlntxBrpFa
   Hd/QVz4wgmk9Q6DRf4853gq8P8bLY7Pc803/btuBquOXVV4YwwHWGV/lo
   5DVVrjGeAU6IZUzMtWhXwjZ3aB9Q21G2DTq6W8M9ahLZsehbjlze2YIXY
   3+LVP9o4oosNju25EACMA/vD1yy5vyCAgUVJ9ph6cy3JPdkta3VFyg373
   83bGBK66494qc+V923Ho3nh4hO/ySN805T+E6EgVmpoYdQjfR2ZEqNnue
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="445482660"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="445482660"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:04:57 -0700
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="745964267"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="745964267"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:04:54 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 09/11] KVM: x86/mmu: serialize vCPUs to zap gfn when guest MTRRs are honored
Date:   Fri, 16 Jun 2023 10:39:45 +0800
Message-Id: <20230616023945.7570-1-yan.y.zhao@intel.com>
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

Serialize concurrent and repeated calls of kvm_zap_gfn_range() from every
vCPU for CR0.CD toggles and MTRR updates when guest MTRRs are honored.

During guest boot-up, if guest MTRRs are honored by TDP, TDP zaps are
triggered several times by each vCPU for CR0.CD toggles and MTRRs updates.
This will take unexpected longer CPU cycles because of the contention of
kvm->mmu_lock.

Therefore, introduce a mtrr_zap_list to remove duplicated zap and an atomic
mtrr_zapping to allow only one vCPU to do the real zap work at one time.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   4 +
 arch/x86/kvm/mtrr.c             | 141 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |   2 +-
 arch/x86/kvm/x86.h              |   1 +
 4 files changed, 146 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 28bd38303d70..8da1517a1513 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1444,6 +1444,10 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+	struct list_head mtrr_zap_list;
+	spinlock_t mtrr_zap_list_lock;
+	atomic_t mtrr_zapping;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index b35dd0bc9cad..688748e3a4d2 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -25,6 +25,8 @@
 #define IA32_MTRR_DEF_TYPE_FE		(1ULL << 10)
 #define IA32_MTRR_DEF_TYPE_TYPE_MASK	(0xff)
 
+static void kvm_mtrr_zap_gfn_range(struct kvm_vcpu *vcpu,
+				   gfn_t gfn_start, gfn_t gfn_end);
 static bool is_mtrr_base_msr(unsigned int msr)
 {
 	/* MTRR base MSRs use even numbers, masks use odd numbers. */
@@ -341,7 +343,7 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
 		var_mtrr_range(var_mtrr_msr_to_range(vcpu, msr), &start, &end);
 	}
 
-	kvm_zap_gfn_range(vcpu->kvm, gpa_to_gfn(start), gpa_to_gfn(end));
+	kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(start), gpa_to_gfn(end));
 }
 
 static bool var_mtrr_range_is_valid(struct kvm_mtrr_range *range)
@@ -437,6 +439,11 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 void kvm_vcpu_mtrr_init(struct kvm_vcpu *vcpu)
 {
 	INIT_LIST_HEAD(&vcpu->arch.mtrr_state.head);
+
+	if (vcpu->vcpu_id == 0) {
+		spin_lock_init(&vcpu->kvm->arch.mtrr_zap_list_lock);
+		INIT_LIST_HEAD(&vcpu->kvm->arch.mtrr_zap_list);
+	}
 }
 
 struct mtrr_iter {
@@ -740,3 +747,135 @@ void kvm_mtrr_get_cd_memory_type(struct kvm_vcpu *vcpu, u8 *type, bool *ipat)
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_mtrr_get_cd_memory_type);
+
+struct mtrr_zap_range {
+	gfn_t start;
+	/* end is exclusive */
+	gfn_t end;
+	struct list_head node;
+};
+
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
+/*
+ * Add @range into kvm->arch.mtrr_zap_list and sort the list in
+ * "length" ascending + "start" descending order, so that
+ * ranges consuming more zap cycles can be dequeued later and their
+ * chances of being found duplicated are increased.
+ */
+static void kvm_add_mtrr_zap_list(struct kvm *kvm, struct mtrr_zap_range *range)
+{
+	struct list_head *head = &kvm->arch.mtrr_zap_list;
+	u64 len = range->end - range->start;
+	struct mtrr_zap_range *cur, *n;
+	bool added = false;
+
+	spin_lock(&kvm->arch.mtrr_zap_list_lock);
+
+	if (list_empty(head)) {
+		list_add(&range->node, head);
+		spin_unlock(&kvm->arch.mtrr_zap_list_lock);
+		return;
+	}
+
+	list_for_each_entry_safe(cur, n, head, node) {
+		u64 cur_len = cur->end - cur->start;
+
+		if (len < cur_len)
+			break;
+
+		if (len > cur_len)
+			continue;
+
+		if (range->start > cur->start)
+			break;
+
+		if (range->start < cur->start)
+			continue;
+
+		/* equal len & start, no need to add */
+		added = true;
+		kfree(range);
+		break;
+	}
+
+	if (!added)
+		list_add_tail(&range->node, &cur->node);
+
+	spin_unlock(&kvm->arch.mtrr_zap_list_lock);
+}
+
+static void kvm_zap_mtrr_zap_list(struct kvm *kvm)
+{
+	struct list_head *head = &kvm->arch.mtrr_zap_list;
+	struct mtrr_zap_range *cur = NULL;
+
+	spin_lock(&kvm->arch.mtrr_zap_list_lock);
+
+	while (!list_empty(head)) {
+		u64 start, end;
+
+		cur = list_first_entry(head, typeof(*cur), node);
+		start = cur->start;
+		end = cur->end;
+		list_del(&cur->node);
+		kfree(cur);
+		spin_unlock(&kvm->arch.mtrr_zap_list_lock);
+
+		kvm_zap_gfn_range(kvm, start, end);
+
+		spin_lock(&kvm->arch.mtrr_zap_list_lock);
+	}
+
+	spin_unlock(&kvm->arch.mtrr_zap_list_lock);
+}
+
+static void kvm_zap_or_wait_mtrr_zap_list(struct kvm *kvm)
+{
+	if (atomic_cmpxchg_acquire(&kvm->arch.mtrr_zapping, 0, 1) == 0) {
+		kvm_zap_mtrr_zap_list(kvm);
+		atomic_set_release(&kvm->arch.mtrr_zapping, 0);
+		return;
+	}
+
+	while (atomic_read(&kvm->arch.mtrr_zapping))
+		cpu_relax();
+}
+
+static void kvm_mtrr_zap_gfn_range(struct kvm_vcpu *vcpu,
+				   gfn_t gfn_start, gfn_t gfn_end)
+{
+	struct mtrr_zap_range *range;
+
+	range = kmalloc(sizeof(*range), GFP_KERNEL_ACCOUNT);
+	if (!range)
+		goto fail;
+
+	range->start = gfn_start;
+	range->end = gfn_end;
+
+	kvm_add_mtrr_zap_list(vcpu->kvm, range);
+
+	kvm_zap_or_wait_mtrr_zap_list(vcpu->kvm);
+	return;
+
+fail:
+	kvm_clear_mtrr_zap_list(vcpu->kvm);
+	kvm_zap_gfn_range(vcpu->kvm, gfn_start, gfn_end);
+}
+
+void kvm_zap_gfn_range_on_cd_toggle(struct kvm_vcpu *vcpu)
+{
+	return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 32cc8bfaa5f1..74aac14a3c0b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -943,7 +943,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
 
 	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
 	    kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
-		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
+		kvm_zap_gfn_range_on_cd_toggle(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr0);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 9781b4b32d68..be946aba2bf0 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -314,6 +314,7 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
 bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
 					  int page_num);
 void kvm_mtrr_get_cd_memory_type(struct kvm_vcpu *vcpu, u8 *type, bool *ipat);
+void kvm_zap_gfn_range_on_cd_toggle(struct kvm_vcpu *vcpu);
 bool kvm_vector_hashing_enabled(void);
 void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code);
 int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
-- 
2.17.1


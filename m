Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0692C753312
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbjGNHVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235377AbjGNHVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:21:48 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095673586;
        Fri, 14 Jul 2023 00:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689319295; x=1720855295;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=9kHtvDYDM2RRR9tqpvSAXG8JNF/ruRm/IeraNi3+ZfI=;
  b=FSqXVHHqIicF/0FBBfP8z/885QPAMeZBVQoGCB8a3qGp+/J03lh8DBxp
   zmyr84gcjv40m4wZbLP1fHaqi3R5n5XyGq+kmbmT+yLBwdFCv3ZfXVwXg
   fyRVH4vnG+LptuuXUWymibJL3v4hMI9Rr0gazi7KeMaw5sf1wrbPHys2X
   GnI48UsR6+fIGaukhY85f9BeQNjnqwjrsgUMvdA5EWbUTqqDaVLJEJzpp
   5I4E2b6MCy9thDLYmVzvTH5MDcQrp0NPVZIuNN3h4I8g2AWGGx471Ge84
   YsEPNSXyEFtplk3YSTnwyC5qMqj62p11/DbQIjLhYHzUgIHRg8HLIsFpI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="345727768"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="345727768"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:21:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="896316954"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="896316954"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:21:28 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        yuan.yao@linux.intel.com, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 09/12] KVM: x86/mmu: serialize vCPUs to zap gfn when guest MTRRs are honored
Date:   Fri, 14 Jul 2023 14:54:54 +0800
Message-Id: <20230714065454.20688-1-yan.y.zhao@intel.com>
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

Serialize concurrent and repeated calls of kvm_zap_gfn_range() from every
vCPU for CR0.CD toggles and MTRR updates when guest MTRRs are honored.

During guest boot-up, if guest MTRRs are honored by TDP, TDP zaps are
triggered several times by each vCPU for CR0.CD toggles and MTRRs updates.
This will take unexpected longer CPU cycles because of the contention of
kvm->mmu_lock.

Therefore, introduce a mtrr_zap_list to remove duplicated zap and an atomic
mtrr_zapping to allow only one vCPU to do the real zap work at one time.

Cc: Yuan Yao <yuan.yao@linux.intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   4 ++
 arch/x86/kvm/mtrr.c             | 122 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |   5 +-
 arch/x86/kvm/x86.h              |   1 +
 4 files changed, 130 insertions(+), 2 deletions(-)

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
index 64c6daa659c8..996a274cee40 100644
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
@@ -737,3 +739,121 @@ void kvm_honors_guest_mtrrs_get_cd_memtype(struct kvm_vcpu *vcpu,
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_honors_guest_mtrrs_get_cd_memtype);
+
+struct mtrr_zap_range {
+	gfn_t start;
+	/* end is exclusive */
+	gfn_t end;
+	struct list_head node;
+};
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
+	kvm_zap_gfn_range(vcpu->kvm, gfn_start, gfn_end);
+}
+
+void kvm_honors_guest_mtrrs_zap_on_cd_toggle(struct kvm_vcpu *vcpu)
+{
+	return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 32cc8bfaa5f1..bb79154cf465 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -943,7 +943,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
 
 	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
 	    kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
-		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
+		kvm_honors_guest_mtrrs_zap_on_cd_toggle(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr0);
 
@@ -12310,6 +12310,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.guest_can_read_msr_platform_info = true;
 	kvm->arch.enable_pmu = enable_pmu;
 
+	spin_lock_init(&kvm->arch.mtrr_zap_list_lock);
+	INIT_LIST_HEAD(&kvm->arch.mtrr_zap_list);
+
 #if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
 	kvm->arch.hv_root_tdp = INVALID_PAGE;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index e7733dc4dccc..56d8755b2560 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -315,6 +315,7 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
 					  int page_num);
 void kvm_honors_guest_mtrrs_get_cd_memtype(struct kvm_vcpu *vcpu,
 					   u8 *type, bool *ipat);
+void kvm_honors_guest_mtrrs_zap_on_cd_toggle(struct kvm_vcpu *vcpu);
 bool kvm_vector_hashing_enabled(void);
 void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code);
 int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
-- 
2.17.1


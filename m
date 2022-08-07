Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C379958BD1C
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbiHGWFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235943AbiHGWDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:03:33 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DA8B1FC;
        Sun,  7 Aug 2022 15:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909770; x=1691445770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U5yLL6f1TGmTepIEEOw2HW9lFZeMarl/NReDdFm2X54=;
  b=DzRQf6hXf/XVbyJRrnxM7MdoAoKVd7+DGh9SVD0uB2hOs1F4dCsoK68u
   Asbr7LNAqdN4L3eBm4oQHbgOS6UQSIUIjnp8pK9Hpe5Q6ieuMYJait1fQ
   LXyaoFHP5qXnk3QspXTJTpKhvSXnhIb3IKKKrOMRNxfwTLdvPZR8DACVz
   n9r73v1ZSC3QOixBjaxH03sY4cIXF0PoTRyIjpRGhcdlIFb5Wtowyztwo
   eSC/VJ7Z7uDehl0HElJQaPGnhUNyX3t4jVLUmW1RiL3ra1lrPRhOzFr/+
   5obSR9a5GJ1R3BYqkGDrAZpXg3/3KlLrXx7k1d3596KlmBDbnHIHifT8k
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="291695699"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="291695699"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:38 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682634"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:38 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 058/103] KVM: x86/tdp_mmu: implement MapGPA hypercall for TDX
Date:   Sun,  7 Aug 2022 15:01:43 -0700
Message-Id: <1293aaf4ce16f80dc4bf9cd943d399183f0d4d7d.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

The TDX Guest-Hypervisor communication interface(GHCI) specification
defines MapGPA hypercall for guest TD to request the host VMM to map given
GPA range as private or shared.

It means the guest TD uses the GPA as shared (or private).  The GPA
won't be used as private (or shared).  VMM should enforce GPA usage. VMM
doesn't have to map the GPA on the hypercall request.

- Zap the aliased region.
  If shared (or private) GPA is requested, zap private (or shared) GPA
  (modulo shared bit).
- Record the request GPA is shared (or private) by kvm.mem_attr_array.
- Don't map GPA. The GPA is mapped on the next EPT violation.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu.h         |  3 +++
 arch/x86/kvm/mmu/mmu.c     | 50 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 40 ++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  3 +++
 4 files changed, 96 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 14f795f6db3a..dbf1abab84b0 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -217,6 +217,9 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
+int kvm_mmu_map_gpa(struct kvm_vcpu *vcpu, gfn_t *startp, gfn_t end,
+		    bool map_private);
+
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 00f797c83300..8d3b45db07eb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6761,6 +6761,56 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 	}
 }
 
+int kvm_mmu_map_gpa(struct kvm_vcpu *vcpu, gfn_t *startp, gfn_t end,
+		    bool map_private)
+{
+	struct kvm *kvm = vcpu->kvm;
+	gfn_t start = *startp;
+	int attr;
+	int ret;
+
+
+	if (!kvm_gfn_shared_mask(kvm))
+		return -EOPNOTSUPP;
+
+	attr = map_private ? KVM_MEM_ATTR_PRIVATE : KVM_MEM_ATTR_SHARED;
+	start = start & ~kvm_gfn_shared_mask(kvm);
+	end = end & ~kvm_gfn_shared_mask(kvm);
+
+	/*
+	 * To make the following kvm_vm_set_mem_attr() success within spinlock
+	 * without memory allocation.
+	 */
+	ret = kvm_vm_reserve_mem_attr(kvm, start, end);
+	if (ret)
+		return ret;
+
+	write_lock(&kvm->mmu_lock);
+	if (is_tdp_mmu_enabled(kvm)) {
+		gfn_t s = start;
+
+		ret = kvm_tdp_mmu_map_gpa(vcpu, &s, end, map_private);
+		if (!ret) {
+			WARN_ON(kvm_vm_set_mem_attr(kvm, attr, start, end));
+		} else if (ret == -EAGAIN) {
+			WARN_ON(kvm_vm_set_mem_attr(kvm, attr, start, s));
+			start = s;
+		}
+	} else {
+		ret = -EOPNOTSUPP;
+	}
+	write_unlock(&kvm->mmu_lock);
+
+	if (ret == -EAGAIN) {
+		if (map_private)
+			*startp = kvm_gfn_private(kvm, start);
+		else
+			*startp = kvm_gfn_shared(kvm, start);
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_map_gpa);
+
 static unsigned long
 mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9bf977b925f0..fa49e69de7ed 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -2086,6 +2086,46 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 	return spte_set;
 }
 
+int kvm_tdp_mmu_map_gpa(struct kvm_vcpu *vcpu,
+			gfn_t *startp, gfn_t end, bool map_private)
+{
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_mmu_page *root;
+	gfn_t start = *startp;
+	bool flush = false;
+	int i;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	WARN_ON(start & kvm_gfn_shared_mask(kvm));
+	WARN_ON(end & kvm_gfn_shared_mask(kvm));
+
+	if (!VALID_PAGE(mmu->root.hpa) || !VALID_PAGE(mmu->private_root_hpa))
+		return -EINVAL;
+
+	kvm_inc_notifier_count(kvm, start, end);
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		for_each_tdp_mmu_root_yield_safe(kvm, root, i) {
+			if (is_private_sp(root) == map_private)
+				continue;
+
+			/*
+			 * TODO: If necessary, return to the caller with -EAGAIN
+			 * instead of yield-and-resume within
+			 * tdp_mmu_zap_leafs().
+			 */
+			flush = tdp_mmu_zap_leafs(
+				kvm, root, start, end, /*can_yield=*/false,
+				flush, /*zap_private=*/is_private_sp(root));
+		}
+	}
+	if (flush)
+		kvm_flush_remote_tlbs_with_address(kvm, start, end - start);
+	kvm_dec_notifier_count(kvm, start, end);
+
+	return 0;
+}
+
 /*
  * Return the level of the lowest level SPTE added to sptes.
  * That SPTE may be non-present.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 695175c921a5..5715c28e81aa 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -51,6 +51,9 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 				      gfn_t start, gfn_t end,
 				      int target_level, bool shared);
 
+int kvm_tdp_mmu_map_gpa(struct kvm_vcpu *vcpu,
+			gfn_t *startp, gfn_t end, bool map_private);
+
 static inline void kvm_tdp_mmu_walk_lockless_begin(void)
 {
 	rcu_read_lock();
-- 
2.25.1


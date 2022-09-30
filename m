Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30095F08D4
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiI3KXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbiI3KVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:21:12 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497D515AB52;
        Fri, 30 Sep 2022 03:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533161; x=1696069161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/Veqw9EW8tUuQFbI7sS3UqOsMHilx9sG0zWvby86DKg=;
  b=bC+992OB2UZhTwqLpcwc+k4kcH/sJGOFHxAEm+YJU4ZUPXJljVA7TY/b
   68u5NB2+NtG0UcfmhC73ZPUHnLsQTg4D7KolsCaaMwBD7uj2zIIkxRiaa
   xd1AKQAUsoPKXaew1rXhiIcdOBmMBbUFJUz86VW63wxpaIqKf0LiF5a5f
   kJR9rnChyXHNFu7P7sFdYFpD1TIjirjYPrihmBLna7UrO4cJ+GSlZ6uuF
   zodDIauSSG/qQ2Vz/S0QeXZxFdOqLa0s1iSX0ilIHlZiclpVmVTLHULPB
   2afLoIl/7SAkol08w3++34EBKCBNB+ExHj6PH+boGxebZiTHBVnhtnWGb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870123"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870123"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:01 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807696"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807696"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:01 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 059/105] KVM: x86/tdp_mmu: implement MapGPA hypercall for TDX
Date:   Fri, 30 Sep 2022 03:17:53 -0700
Message-Id: <79cfc130e36a7754977af7460dc752188073d103.1664530908.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/mmu.h         |  5 ++++
 arch/x86/kvm/mmu/mmu.c     | 60 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 35 ++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  3 ++
 4 files changed, 103 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 3cd969bf5b69..d67ca298983c 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -217,6 +217,11 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
+int __kvm_mmu_map_gpa(struct kvm *kvm, gfn_t *startp, gfn_t end,
+		      bool map_private);
+int kvm_mmu_map_gpa(struct kvm_vcpu *vcpu, gfn_t *startp, gfn_t end,
+		    bool map_private);
+
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d463bc13c094..9a4acf2ad694 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6743,6 +6743,66 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 	}
 }
 
+int __kvm_mmu_map_gpa(struct kvm *kvm, gfn_t *startp, gfn_t end,
+		      bool map_private)
+{
+	gfn_t start = *startp;
+	int attr;
+	int ret;
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
+		ret = kvm_tdp_mmu_map_gpa(kvm, &s, end, map_private);
+		if (!ret) {
+			KVM_BUG_ON(kvm_vm_set_mem_attr(kvm, attr, start, end), kvm);
+		} else if (ret == -EAGAIN) {
+			KVM_BUG_ON(kvm_vm_set_mem_attr(kvm, attr, start, s), kvm);
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
+EXPORT_SYMBOL_GPL(__kvm_mmu_map_gpa);
+
+int kvm_mmu_map_gpa(struct kvm_vcpu *vcpu, gfn_t *startp, gfn_t end,
+		    bool map_private)
+{
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+
+	if (!VALID_PAGE(mmu->root.hpa) || !VALID_PAGE(mmu->private_root_hpa))
+		return -EINVAL;
+
+	return __kvm_mmu_map_gpa(vcpu->kvm, startp, end, map_private);
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_map_gpa);
+
 static unsigned long
 mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 784dcfaed505..7078c75d7103 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -2111,6 +2111,41 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 	return spte_set;
 }
 
+int kvm_tdp_mmu_map_gpa(struct kvm *kvm,
+			gfn_t *startp, gfn_t end, bool map_private)
+{
+	struct kvm_mmu_page *root;
+	gfn_t start = *startp;
+	bool flush = false;
+	int i;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	KVM_BUG_ON(start & kvm_gfn_shared_mask(kvm), kvm);
+	KVM_BUG_ON(end & kvm_gfn_shared_mask(kvm), kvm);
+
+	kvm_mmu_invalidate_begin(kvm, start, end);
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
+			flush = tdp_mmu_zap_leafs(kvm, root, start, end,
+						  /*can_yield=*/true, flush,
+						  /*zap_private=*/is_private_sp(root));
+		}
+	}
+	if (flush)
+		kvm_flush_remote_tlbs_with_address(kvm, start, end - start);
+	kvm_mmu_invalidate_end(kvm, start, end);
+
+	return 0;
+}
+
 /*
  * Return the level of the lowest level SPTE added to sptes.
  * That SPTE may be non-present.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 695175c921a5..cb13bc1c3679 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -51,6 +51,9 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 				      gfn_t start, gfn_t end,
 				      int target_level, bool shared);
 
+int kvm_tdp_mmu_map_gpa(struct kvm *kvm,
+			gfn_t *startp, gfn_t end, bool map_private);
+
 static inline void kvm_tdp_mmu_walk_lockless_begin(void)
 {
 	rcu_read_lock();
-- 
2.25.1


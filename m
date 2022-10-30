Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBEE612823
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiJ3G2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiJ3G0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:26:05 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F0E275;
        Sat, 29 Oct 2022 23:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111057; x=1698647057;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pSMPEvDBc8a1ASJVlEuOshAwnXNncrPDSUz+PdeyGII=;
  b=SHq1PChI9IDuVVegeU84HaMwaXXTdnOxV96+u9+m4K+3ZJelrwdYFGX4
   uK3whXOEeCjoNjmIY1TzLEcQ+5d6sS7AD3X2J1TYBUfGIVDfsagDPBq2j
   CnZuohlHgTLFVbBQ8dcwaC3wifQuYarUqVYp9Ya+ZR1mHwRfQ2ZJgpuVl
   egdIK1M/VBr471u9QHbwScauhwDLdQpdtXFmCoofwnb564N3CleG3dAmu
   Qp3qLJ2HTehxaOlgqevLc6GRaNj48ElszkAa3FIEB9saGlgijuUXjJZYQ
   cS1F1mwMfdk7kFIzoDdCG+HIPAA5A97vLTaMiMkkcoe5Jpxl7IrnBMSZi
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037175"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037175"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:07 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393045"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393045"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:07 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 062/108] KVM: x86/tdp_mmu: implement MapGPA hypercall for TDX
Date:   Sat, 29 Oct 2022 23:23:03 -0700
Message-Id: <73ef2bdcdf8ec88bbec9d3780484cecda7a21e6f.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index e2a0dfbee56d..e1641fa5a862 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -219,6 +219,11 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
+int __kvm_mmu_map_gpa(struct kvm *kvm, gfn_t *startp, gfn_t end,
+		      bool map_private);
+int kvm_mmu_map_gpa(struct kvm_vcpu *vcpu, gfn_t *startp, gfn_t end,
+		    bool map_private);
+
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 168c84c99de3..37b378bf60df 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6778,6 +6778,66 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
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
index 4b207ce83ffe..d3bab382ceaa 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -2156,6 +2156,41 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
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


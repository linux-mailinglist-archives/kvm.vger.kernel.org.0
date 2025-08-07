Return-Path: <kvm+bounces-54241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48D14B1D523
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:46:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4973C723724
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0627D26A1AB;
	Thu,  7 Aug 2025 09:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fC28vTf9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39923376F1;
	Thu,  7 Aug 2025 09:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559928; cv=none; b=HivoxTHeW+VD5fxhbJUE4T4bg92dWnyZgC90A8LLkp8iIPIvvkvTPKoRBI7l/BL3wo/G45MVAyhMuMUoIjyJF5jsitWgGXlrZHiTwILsRjDYGCLdh8/aA7ApG/n82xtFmo5aihpARwU18jp/gvMRCzwrQLknFeQ8Ty++eEpJi+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559928; c=relaxed/simple;
	bh=mE+14Bi9v8cADqyQZw7Hz4GZ4omcc+6NPqkxEjwZNTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsrxVzrfPiVcx5/+K/8tmrMOj70F9aQYFM+LLOUUWq62doLkI+/jh+j+vTZNvVF/S6XTLO0zkWFo8MmBcwmi4REBYRWRs1LlRsgjT8IBSW3/n1W61PEyP6X6rnYk44VGizV0JbEsmbdtSurXLDvkTQ69WrY0PY5d7jPQkoEk8UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fC28vTf9; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559927; x=1786095927;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mE+14Bi9v8cADqyQZw7Hz4GZ4omcc+6NPqkxEjwZNTk=;
  b=fC28vTf9dqdwIdHcPzc6OsvrMamK/7IQz+8yzNEH9HjTPTEWqH9HCstz
   vt56BxWRt2xdkS5DGgKXjLTm0+N37ss3YJkEAyss5JUnKIb6jEciVI6H2
   bkv4LxZL0px1GP5YKGysH+jLAJX0e19lDq9wsgg/8MnnTNfG3GhcHPbsU
   Z6BmjGJ68xcSisqiLksGabvX2VqP0ENWKNDDIkHsSMDoO0GMNaZ6FyY7S
   ENW7hehOalAJ8J4J7ZV3aAvodFHBevchosVlb1hBZFJUOdKoecehJ+Pki
   hs6HHAQJyGrN7QAmPfKio/EY4ehOeB3aYOVIMXD4v05HLkxJveYYAFhjN
   w==;
X-CSE-ConnectionGUID: 6szejlA5RHCLQG43FhxVTA==
X-CSE-MsgGUID: 7m87dl8uTNmNxS1+daoMCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="56760286"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="56760286"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:45:27 -0700
X-CSE-ConnectionGUID: jyq9TF3iSCCjNKyFGFmuzg==
X-CSE-MsgGUID: JNM1693rQkeyuavFtgjvqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="165382212"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:45:20 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kas@kernel.org,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	pgonda@google.com,
	zhiquan1.li@intel.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	yan.y.zhao@intel.com
Subject: [RFC PATCH v2 16/23] KVM: x86: Split cross-boundary mirror leafs for KVM_SET_MEMORY_ATTRIBUTES
Date: Thu,  7 Aug 2025 17:44:50 +0800
Message-ID: <20250807094450.4673-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250807093950.4395-1-yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In TDX, private page tables require precise zapping because faulting back
the zapped mappings necessitates the guest's re-acceptance. Therefore,
before performing a zap for the private-to-shared conversion, rather than
zapping a huge leaf entry that crosses the boundary of the GFN range to be
zapped, split the leaf entry to ensure GFNs outside the conversion range
are not affected.

Invoke kvm_split_cross_boundary_leafs() in
kvm_arch_pre_set_memory_attributes() to split the huge leafs that cross
GFN range boundary before calling kvm_unmap_gfn_range() to zap the GFN
range that will be converted to shared.
When kvm_split_cross_boundary_leafs() fails, it is expected to internally
invoke kvm_flush_remote_tlbs() to flush any changes that have been
successfully completed.

Unlike kvm_unmap_gfn_range(), which cannot fail,
kvm_split_cross_boundary_leafs() may fail due to memory allocation for
splitting. Update kvm_handle_gfn_range() to propagate the error back to
kvm_vm_set_mem_attributes(), which can then fail the ioctl
KVM_SET_MEMORY_ATTRIBUTES.

The downside of current implementation is that though
kvm_split_cross_boundary_leafs() is invoked before kvm_unmap_gfn_range()
for each GFN range, the entire conversion range may consist of several GFN
ranges. If an out-of-memory error occurs during the splitting of a GFN
range, some previous GFN ranges may have been successfully split and
zapped, even though their page attributes remain unchanged due to the
splitting failure.

If it's necessary, a patch can be arranged to divide a single invocation of
"kvm_handle_gfn_range(kvm, &pre_set_range)" into two, e.g.,

kvm_handle_gfn_range(kvm, &pre_set_range_prepare_and_split)
kvm_handle_gfn_range(kvm, &pre_set_range_unmap),

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- update kvm_split_boundary_leafs() to kvm_split_cross_boundary_leafs() and
  invoke it only for priate-to-shared conversion.

RFC v1:
- new patch.
---
 arch/x86/kvm/mmu/mmu.c | 13 ++++++++++---
 virt/kvm/kvm_main.c    | 13 +++++++++----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c71f8bb0b903..f23d8fc59323 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7845,7 +7845,9 @@ int kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 				       struct kvm_gfn_range *range)
 {
 	struct kvm_memory_slot *slot = range->slot;
+	bool flush = false;
 	int level;
+	int ret;
 
 	/*
 	 * Zap SPTEs even if the slot can't be mapped PRIVATE.  KVM x86 only
@@ -7894,12 +7896,17 @@ int kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	}
 
 	/* Unmap the old attribute page. */
-	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
+	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE) {
 		range->attr_filter = KVM_FILTER_SHARED;
-	else
+	} else {
 		range->attr_filter = KVM_FILTER_PRIVATE;
+		ret = kvm_split_cross_boundary_leafs(kvm, range, false);
+		if (ret < 0)
+			return ret;
+		flush |= ret;
+	}
 
-	return kvm_unmap_gfn_range(kvm, range);
+	return kvm_unmap_gfn_range(kvm, range) | flush;
 }
 
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8f87d6c6be3f..9dceecf34822 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2464,8 +2464,8 @@ bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	return true;
 }
 
-static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
-						 struct kvm_mmu_notifier_range *range)
+static __always_inline int kvm_handle_gfn_range(struct kvm *kvm,
+						struct kvm_mmu_notifier_range *range)
 {
 	struct kvm_gfn_range gfn_range;
 	struct kvm_memory_slot *slot;
@@ -2519,6 +2519,8 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 
 	if (found_memslot)
 		KVM_MMU_UNLOCK(kvm);
+
+	return ret < 0 ? ret : 0;
 }
 
 static int kvm_pre_set_memory_attributes(struct kvm *kvm,
@@ -2587,7 +2589,9 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 		cond_resched();
 	}
 
-	kvm_handle_gfn_range(kvm, &pre_set_range);
+	r = kvm_handle_gfn_range(kvm, &pre_set_range);
+	if (r)
+		goto out_unlock;
 
 	for (i = start; i < end; i++) {
 		r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
@@ -2596,7 +2600,8 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 		cond_resched();
 	}
 
-	kvm_handle_gfn_range(kvm, &post_set_range);
+	r = kvm_handle_gfn_range(kvm, &post_set_range);
+	KVM_BUG_ON(r, kvm);
 
 out_unlock:
 	mutex_unlock(&kvm->slots_lock);
-- 
2.43.2



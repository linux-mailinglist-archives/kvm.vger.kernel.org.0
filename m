Return-Path: <kvm+bounces-44048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 185E2A99F64
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:11:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F96C44382C
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ACE41B0420;
	Thu, 24 Apr 2025 03:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G5XyVcda"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA65B1A4F12;
	Thu, 24 Apr 2025 03:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464238; cv=none; b=REDoZlT5Y4FPR6ImQaUSpkH9cSdRrKdONb3mjn/8zj7Lk17JCSFMzAG3vD4A/v56kLoPkCf14uH1AZYcwr81hThzR/MvA2xVV1LOMuw4s2MDg1LwmyISbgs8C8mosz2EyzNqECf3s53GzhfqVomI83eduL+MsrTzpAc6eHkzb9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464238; c=relaxed/simple;
	bh=4Q49F1KukDj1GrSV5/vRYAfmizgIQDt+rh/0z9uXGO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZZJRqeW3tBBavedQ3bF6+Ok8tgTJZvUg85wv0Hd93BpecAhlUYUWbcBazN5Lk0a0n0KavCW1CDKMjNQbqBe0ecoT00PQuVps0RzVEzork0tKSxBVLnI81EBkhWkDqrnkEhKvm+kJRakjiXMnUDKf5QOCOudY6B3pSSP3Y1dWcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G5XyVcda; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464237; x=1777000237;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4Q49F1KukDj1GrSV5/vRYAfmizgIQDt+rh/0z9uXGO0=;
  b=G5XyVcdaXAtyFi+rf1R4tH5J0ypxPfN3xMiQUnZ0LL7sRd6t9PzJZ+7V
   H4Ag8MIwDk50zLU82msq3B2ClWWqAsZyhBW3sb0d+tb338lLJrdznmaRD
   894IcrThXkeRcfDrzmBcQ+LwDUWgl5zRQnjCdpVD08ksBPivQ8M1NcPP/
   mk5ljUlpKnKSxt3167RmI0zk0garVcK7Pz3Sj1Q02Nua7YITxS6C5Jgxx
   dCH1J5zn0wd+/V5DJI1NjD+j2F1i6GQ/9fTgoRlsSsVfhHXdQGGxvESs9
   myU0ENNazitWcTJZVDEZCRnDn815om8m4GojObBznDWIFuOqkeYUEqzUz
   g==;
X-CSE-ConnectionGUID: d+winD++RemqZ2pSou1zJA==
X-CSE-MsgGUID: Co7aXWvMS2apDZbdq9zdag==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="58072918"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="58072918"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:10:36 -0700
X-CSE-ConnectionGUID: el00KPCjQSSoadQq8uKZ/w==
X-CSE-MsgGUID: HHBrlznYQSicNFNPz9RIkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="137659327"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:10:30 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kirill.shutemov@intel.com,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	jroedel@suse.de,
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
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 18/21] KVM: x86: Split huge boundary leafs before private to shared conversion
Date: Thu, 24 Apr 2025 11:08:44 +0800
Message-ID: <20250424030844.502-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250424030033.32635-1-yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before converting a GFN range from private to shared, it is necessary to
zap the mirror page table. When huge pages are supported and the GFN range
intersects with a huge leaf, split the huge leaf to prevent zapping GFNs
outside the conversion range.

Invoke kvm_split_boundary_leafs() in kvm_arch_pre_set_memory_attributes()
to split the huge boundary leafs before calling kvm_unmap_gfn_range() to
zap the GFN range that will be converted to shared.

Unlike kvm_unmap_gfn_range(), which cannot fail, kvm_split_boundary_leafs()
may fail due to out of memory during splitting.
Update kvm_handle_gfn_range() to propagate the splitting error back to
kvm_vm_set_mem_attributes(), which will subsequently fail the ioctl
KVM_SET_MEMORY_ATTRIBUTES.

The downside of this approach is that although kvm_split_boundary_leafs()
is invoked before kvm_unmap_gfn_range() for each GFN range, the entire
conversion range may consist of several GFN ranges. If an out-of-memory
error occurs during the splitting of a GFN range, some previous GFN ranges
may have been successfully split and zapped, even though their page
attributes remain unchanged due to the splitting failure. This may not be a
big problem as the user can retry the ioctl to split and zap the full
range.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 +++++++++++++----
 virt/kvm/kvm_main.c    | 13 +++++++++----
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ba993445a00e..1a34e43bd349 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7694,6 +7694,9 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 int kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 				       struct kvm_gfn_range *range)
 {
+	bool flush = false;
+	int ret;
+
 	/*
 	 * Zap SPTEs even if the slot can't be mapped PRIVATE.  KVM x86 only
 	 * supports KVM_MEMORY_ATTRIBUTE_PRIVATE, and so it *seems* like KVM
@@ -7706,7 +7709,7 @@ int kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	 * a hugepage can be used for affected ranges.
 	 */
 	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
-		return false;
+		return 0;
 
 	/* Unmap the old attribute page. */
 	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
@@ -7714,7 +7717,13 @@ int kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	else
 		range->attr_filter = KVM_FILTER_PRIVATE;
 
-	return kvm_unmap_gfn_range(kvm, range);
+	ret = kvm_split_boundary_leafs(kvm, range);
+	if (ret < 0)
+		return ret;
+	flush |= ret;
+
+	flush |= kvm_unmap_gfn_range(kvm, range);
+	return flush;
 }
 
 static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
@@ -7769,7 +7778,7 @@ int kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 	 * SHARED may now allow hugepages.
 	 */
 	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
-		return false;
+		return 0;
 
 	/*
 	 * The sequence matters here: upper levels consume the result of lower
@@ -7816,7 +7825,7 @@ int kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 				hugepage_set_mixed(slot, gfn, level);
 		}
 	}
-	return false;
+	return 0;
 }
 
 void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 72bd98c100cf..6d9b82890f15 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2408,8 +2408,8 @@ bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	return true;
 }
 
-static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
-						 struct kvm_mmu_notifier_range *range)
+static __always_inline int kvm_handle_gfn_range(struct kvm *kvm,
+						struct kvm_mmu_notifier_range *range)
 {
 	struct kvm_gfn_range gfn_range;
 	struct kvm_memory_slot *slot;
@@ -2462,6 +2462,8 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 
 	if (found_memslot)
 		KVM_MMU_UNLOCK(kvm);
+
+	return ret < 0 ? ret : 0;
 }
 
 static int kvm_pre_set_memory_attributes(struct kvm *kvm,
@@ -2526,7 +2528,9 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 			goto out_unlock;
 	}
 
-	kvm_handle_gfn_range(kvm, &pre_set_range);
+	r = kvm_handle_gfn_range(kvm, &pre_set_range);
+	if (r)
+		goto out_unlock;
 
 	for (i = start; i < end; i++) {
 		r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
@@ -2534,7 +2538,8 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 		KVM_BUG_ON(r, kvm);
 	}
 
-	kvm_handle_gfn_range(kvm, &post_set_range);
+	r = kvm_handle_gfn_range(kvm, &post_set_range);
+	KVM_BUG_ON(r, kvm);
 
 out_unlock:
 	mutex_unlock(&kvm->slots_lock);
-- 
2.43.2



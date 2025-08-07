Return-Path: <kvm+bounces-54246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0482DB1D534
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:48:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0503C4E3AC0
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23B1927815B;
	Thu,  7 Aug 2025 09:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GOdyC5cE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFE926B742;
	Thu,  7 Aug 2025 09:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754560001; cv=none; b=h/KrZEBnNdbLLuW1zwcK+xkC1emHOJ+DgO3amW+0kfua+rDigqlPBIVLRxA/kWIi4rrelNlVpj9Go3ADGw11hYDiACRcKP8YK2qPqRi9nei3EburDbhejqGbD/UemOHU9fJ3/+vcMnv8uZdxu1xywP9s5syOGexL8OWZPvUaNSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754560001; c=relaxed/simple;
	bh=Nj3RxqvjndwtR2WgqYJxO5Hy0j8sDdkvJHOEsOl/tPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgOsgiRDgVJCpiUa9sexyZM/PQUBjcVwsHwGgxkBVKfFe2ZuDFACYKSbndEoWwpViIFR06FgLcLZsC59bC7mhv0R4k95Dvws/6MjFnLpzMEcVfNbLJdpipupJfb+KU1dHkD6vAyMvyY6msmvMQD6oqUaVGvocafNR7yBOjpt6F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GOdyC5cE; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754560000; x=1786096000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nj3RxqvjndwtR2WgqYJxO5Hy0j8sDdkvJHOEsOl/tPE=;
  b=GOdyC5cEZJMG1zyGfZtfnQxyLfLvHYe5qGW/EOLoOPcgW3P0leDMNJzv
   c9n5TLDnjJx4bWW2Qj4+/l2JYeuTSGw9TSsxXV9RKLrhysdyqhNMf8guv
   olI2DycGm/+1aalGhxBSQRd19hEbmM3lcD7s0wx1rg2BtD/6z8MMTKwKS
   BHG2sVVTy5IB32w7KL4SPV3lhN0ANrbbhUhhA21+mnptZZkb/Z5Mz8JwS
   EcufXGtKSUb82gQTphqfXjQJQ07YITEQCOV7jFOr9JUR967982bvpZKSW
   bLhPNNev7WqsIg3x9Vc32xm9FCmO50xZT8QkPPngRquS6N8LGnCUWl/61
   w==;
X-CSE-ConnectionGUID: yO07rF7hRNitkmnTMuBpdA==
X-CSE-MsgGUID: fPId2izDRv63bg0mJBSWlQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="68342869"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="68342869"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:46:40 -0700
X-CSE-ConnectionGUID: jaKQCGg1QYKswL9sbyDyFg==
X-CSE-MsgGUID: 7NslTzFVTyC98mRhC2aFPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="170392330"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:46:34 -0700
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
Subject: [RFC PATCH v2 21/23] KVM: TDX: Preallocate PAMT pages to be used in split path
Date: Thu,  7 Aug 2025 17:46:03 +0800
Message-ID: <20250807094604.4762-1-yan.y.zhao@intel.com>
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

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Preallocate a page to be used in the split_external_spt() path.

Kernel needs one PAMT page pair for external_spt and one that provided
directly to the TDH.MEM.PAGE.DEMOTE SEAMCALL.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- Pulled from
  git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt-huge.
- Implemented the flow of topup pamt_page_cache in
  tdp_mmu_split_huge_pages_root() (Yan)
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu/mmu.c          |  1 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 51 +++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6b6c46c27390..508b133df903 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1591,6 +1591,8 @@ struct kvm_arch {
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
 
+	struct kvm_mmu_memory_cache pamt_page_cache;
+
 	gfn_t gfn_direct_bits;
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f23d8fc59323..e581cee37f64 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6848,6 +6848,7 @@ static void mmu_free_vm_memory_caches(struct kvm *kvm)
 	kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
 	kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
 	kvm_mmu_free_memory_cache(&kvm->arch.split_shadow_page_cache);
+	kvm_mmu_free_memory_cache(&kvm->arch.pamt_page_cache);
 }
 
 void kvm_mmu_uninit_vm(struct kvm *kvm)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index eb758aaa4374..064c4e823658 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1584,6 +1584,27 @@ static bool iter_cross_boundary(struct tdp_iter *iter, gfn_t start, gfn_t end)
 		 (iter->gfn + KVM_PAGES_PER_HPAGE(iter->level)) <= end);
 }
 
+static bool need_topup_mirror_caches(struct kvm *kvm)
+{
+	int nr = tdx_nr_pamt_pages() * 2;
+
+	return kvm_mmu_memory_cache_nr_free_objects(&kvm->arch.pamt_page_cache) < nr;
+}
+
+static int topup_mirror_caches(struct kvm *kvm)
+{
+	int r, nr;
+
+	/* One for external_spt, one for TDH.MEM.PAGE.DEMOTE */
+	nr = tdx_nr_pamt_pages() * 2;
+
+	r = kvm_mmu_topup_memory_cache(&kvm->arch.pamt_page_cache, nr);
+	if (r)
+		return r;
+
+	return 0;
+}
+
 static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 					 struct kvm_mmu_page *root,
 					 gfn_t start, gfn_t end,
@@ -1656,6 +1677,36 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 			continue;
 		}
 
+		if (is_mirror_sp(root) && need_topup_mirror_caches(kvm)) {
+			int r;
+
+			rcu_read_unlock();
+
+			if (shared)
+				read_unlock(&kvm->mmu_lock);
+			else
+				write_unlock(&kvm->mmu_lock);
+
+			r = topup_mirror_caches(kvm);
+
+			if (shared)
+				read_lock(&kvm->mmu_lock);
+			else
+				write_lock(&kvm->mmu_lock);
+
+			if (r) {
+				trace_kvm_mmu_split_huge_page(iter.gfn,
+							      iter.old_spte,
+							      iter.level, r);
+				return r;
+			}
+
+			rcu_read_lock();
+
+			iter.yielded = true;
+			continue;
+		}
+
 		tdp_mmu_init_child_sp(sp, &iter);
 
 		if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
-- 
2.43.2



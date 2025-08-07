Return-Path: <kvm+bounces-54233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F103EB1D50E
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:44:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E17F0189F650
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 381F526A0BD;
	Thu,  7 Aug 2025 09:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CvqVTOv3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D19260588;
	Thu,  7 Aug 2025 09:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559825; cv=none; b=QkxPRCXOSbLfhXh6XwzWfG+NhrY+4N+zpP7n0ouw3SllmoAqSFwtgHdnshBGsyKAxO6qYy8i5N+aXOcdTBullRc7LsVCgPwRWqBZeXa59KH1yeWwcUIN1dUFd4BjiIGNz7+MJ1AnT9aqIHxoJFm+Cu4jJ/ahUKYNwTZM/pNv5Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559825; c=relaxed/simple;
	bh=IOKuDf3J2+8Nazup7kE5NIwSdPzIeno0E6vKZnU7YNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mG00dqTCFvG0uw7CYJkEtuHb9e6g8VQX2Yb96MF0mA72F/3I0Y9SPpKXbnfo9txcq5mNArwjtYz4LQeonWmsP0I9p9E+zi1Wn+VzsxgvJ5duMVN6B4RhmIJJ1nktlOXoI7xqIr9Q3Mg2xe0x89ScCF2oFD+WlBGnigkGd3T8j10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CvqVTOv3; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559823; x=1786095823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IOKuDf3J2+8Nazup7kE5NIwSdPzIeno0E6vKZnU7YNI=;
  b=CvqVTOv3s2wC+NbDefHB7YOTlohx9Ckr2cZki6SGNRUwo/0myMN03dIo
   kQNzmk2+/MFanyoC7H4nyFZ1XjPly3RunGw0WqLsBTvRNjVmmnchleUBW
   9Ba5ORU1OCpVbik7Ad178S2gIi/KK5waDBCvA3HX+f9reZ38hz7EmKLwl
   0VSUPUSL1y7n4aXtYzC72pO2YlMWlzq/5hSOXuHV8tOOVERm6Eru1RpHj
   BVXRFVK4umS4idNMvTb7RfVG/IvECxcwDN68DcQB/FqhQfyae18tGGXuN
   wwxEzcnNRInAtJNc+VPutXrzy6tbHscdm8CDcDLURocad9lK+zse4z9wR
   g==;
X-CSE-ConnectionGUID: 9JWeodfMRRSWTeTI47TF+g==
X-CSE-MsgGUID: jLP+ACF1S/2u0Osf8wosZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="57023575"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="57023575"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:43:43 -0700
X-CSE-ConnectionGUID: wrDnIFuSSNKWauY/WS2JEA==
X-CSE-MsgGUID: c8UrEdkDSvG8/XO4LmkViw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="165815191"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:43:38 -0700
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
Subject: [RFC PATCH v2 08/23] KVM: x86/tdp_mmu: Alloc external_spt page for mirror page table splitting
Date: Thu,  7 Aug 2025 17:43:08 +0800
Message-ID: <20250807094308.4551-1-yan.y.zhao@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Enhance tdp_mmu_alloc_sp_split() to allocate a page for sp->external_spt,
i.e., the external page table page, for splitting the mirror page table.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- NO change.

RFC v1:
- Rebased and simplified the code.
---
 arch/x86/kvm/mmu/tdp_mmu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f9a054754544..46b9f276bb6d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -324,6 +324,8 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level,
 				bool shared);
 
+static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(bool mirror);
+
 static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	kvm_account_pgtable_pages((void *)sp->spt, +1);
@@ -1475,7 +1477,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(void)
+static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(bool mirror)
 {
 	struct kvm_mmu_page *sp;
 
@@ -1489,6 +1491,15 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(void)
 		return NULL;
 	}
 
+	if (mirror) {
+		sp->external_spt = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+		if (!sp->external_spt) {
+			free_page((unsigned long)sp->spt);
+			kmem_cache_free(mmu_page_header_cache, sp);
+			return NULL;
+		}
+	}
+
 	return sp;
 }
 
@@ -1568,7 +1579,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 			else
 				write_unlock(&kvm->mmu_lock);
 
-			sp = tdp_mmu_alloc_sp_for_split();
+			sp = tdp_mmu_alloc_sp_for_split(is_mirror_sp(root));
 
 			if (shared)
 				read_lock(&kvm->mmu_lock);
-- 
2.43.2



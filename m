Return-Path: <kvm+bounces-16793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEB568BDB45
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 08:21:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19EF41C219B0
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 06:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344716FE06;
	Tue,  7 May 2024 06:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hjhQvOzA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D296D1C8;
	Tue,  7 May 2024 06:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715062854; cv=none; b=XpZgqXqhg1LRIyVJii5q00v/xrFs41FTa/g7m/VDgka7SDCkFZ3UPx+JF3XPS6h7wM/dKVaRoPlyhE9UvgPtStE/vHfw6opnpwmr+rwnrWh4xY75JCpRjgOUFH6gGSniM/Vz87Q4i19Kclrc2VYqnMbz0AE850x7mDZ1te99fl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715062854; c=relaxed/simple;
	bh=8eu/qd0HcIEbXA6xsMR5u7EcC2Nxb+4PTTFdq2/lk6A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=oYggI4ShDAQkWHR2rTFOKeHHRRXBzMUUZSI5fMjGpApctOgAk/9twIdB/56RV+MilhyioY4SD/7HhrelpqvvZFGO5bvH3gZSIANxE9uxb6WegfBZaxEW/2T2LPMQTLxrVL4+u7ZHF6dlJ4a557Slp6rwvQA9tmfXlOOBKfI8cfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hjhQvOzA; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715062851; x=1746598851;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=8eu/qd0HcIEbXA6xsMR5u7EcC2Nxb+4PTTFdq2/lk6A=;
  b=hjhQvOzA3r5o+tiyaj2hNao1zpGCm8Eol3+TEfmS5XLHFAmL65MN6sWP
   LracWAdcV93fEScw7JjSYbp/ZgizcyiG6nh0tLPR0oYl3IHAaiDWoVC6S
   ZGmtIkR+C7AeSO/y0k8TVmYDgt2ux47EIDtV+wqDOae8u4OaouYYvJ4YA
   QEVvz819v3xbkxXTV3k8WbvRhetVQq/Co3fsfC8i221sRZ6lSljbugv09
   eosREatjpvHW+ZFHYrZlcL1RLqjsitqNvMYPqbRaI4dmRl18f71beGrz0
   pUZMc08RQ9GAKu4KypZdrYMA+vVJ6QTeh+Yk+jBrcooYOuEtQylsSlv/N
   w==;
X-CSE-ConnectionGUID: KKa3DMqCT0qcf72sucr+cg==
X-CSE-MsgGUID: SlIoQ+5ERaqXsxJ90rfU6g==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="10991991"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="10991991"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 23:20:51 -0700
X-CSE-ConnectionGUID: +8utow1dTNavv5QvzC3s3Q==
X-CSE-MsgGUID: fDhGMvmsQ4+ufRX3B4RVDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="28296498"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 23:20:46 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	kevin.tian@intel.com
Cc: iommu@lists.linux.dev,
	pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	corbet@lwn.net,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	baolu.lu@linux.intel.com,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 2/5] KVM: x86/mmu: Fine-grained check of whether a invalid & RAM PFN is MMIO
Date: Tue,  7 May 2024 14:20:09 +0800
Message-Id: <20240507062009.20336-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240507061802.20184-1-yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Fine-grained check to decide whether a PFN, which is !pfn_valid() and
identified within the raw e820 table as RAM, should be treated as MMIO by
KVM in order to prevent guest cachable access.

Previously, a PFN that is !pfn_valid() and identified within the raw e820
table as RAM was not considered as MMIO. This is for the scenerio when
"mem=" was passed to the kernel, resulting in certain valid pages lacking
an associated struct page. See commit 0c55671f84ff ("kvm, x86: Properly
check whether a pfn is an MMIO or not").

However, that approach is only based on guest performance perspective
and may cause cacheable access to potential MMIO PFNs if
pat_pfn_immune_to_uc_mtrr() identifies the PFN as having a PAT type of
UC/WC/UC-. Therefore, do a fine-graned check for PAT in primary MMU so that
KVM would map the PFN as UC in EPT to prevent cachable access from guest.

For the rare case when PAT is not enabled, default the PFN to MMIO to avoid
further checking MTRR (since functions for MTRR related checking are not
exported now).

Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/spte.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4a599130e9c9..5db0fb7b74f5 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -101,9 +101,21 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 			 */
 			(!pat_enabled() || pat_pfn_immune_to_uc_mtrr(pfn));
 
+	/*
+	 * If the PFN is invalid and not RAM in raw e820 table, keep treating it
+	 * as MMIO.
+	 *
+	 * If the PFN is invalid and is RAM in raw e820 table,
+	 * - if PAT is not enabled, always treat the PFN as MMIO to avoid futher
+	 *   checking of MTRRs.
+	 * - if PAT is enabled, treat the PFN as MMIO if its PAT is UC/WC/UC- in
+	 *   primary MMU.
+	 * to prevent guest cacheable access to MMIO PFNs.
+	 */
 	return !e820__mapped_raw_any(pfn_to_hpa(pfn),
 				     pfn_to_hpa(pfn + 1) - 1,
-				     E820_TYPE_RAM);
+				     E820_TYPE_RAM) ? true :
+				     (!pat_enabled() || pat_pfn_immune_to_uc_mtrr(pfn));
 }
 
 /*
-- 
2.17.1



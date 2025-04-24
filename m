Return-Path: <kvm+bounces-44043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F1790A99F58
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 185241946D1D
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DD811AD403;
	Thu, 24 Apr 2025 03:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B+qDNIXr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084A01A9B49;
	Thu, 24 Apr 2025 03:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464163; cv=none; b=Mv2F+uGs5+Pw5FSHb4NrwQORtHSraI1pLmkjPsyvMIQIafumzrb+7wCvKqlB/mlPP1lz0MakZZzyKaaRXZQ4WV+tVd59mijzAv126m60fqepgvCvGv8rIg2qJvTaA1/ebUAuS5Qjklq674lkGpfKgA1X13CMq4dReGS5f2im0FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464163; c=relaxed/simple;
	bh=N450r3oIUt49XWDQC3IXoi1jJfPAZl0q0onXGgJ/nOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaPmRCb20cvgan/qJUr9Gc1pGI4ovt+gI7PeLDRmlmiiwwGR4NKzVja3nR1WXhct+tVf5yiOT/6Eq7p52zQOymX9knywXwsgbkUCfROFzHpQR2zgrQEsGXk12yN6V45qKPouuqF/DnhCZ0BE+2IUKCDh+XfPqptvqbsc+PTlrhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B+qDNIXr; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464162; x=1777000162;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N450r3oIUt49XWDQC3IXoi1jJfPAZl0q0onXGgJ/nOY=;
  b=B+qDNIXr5Jd6Y8JDTasKbouNuWbWna1wjJkEX4C8VPfw5akOQznur1hy
   ljkC+ZTiBhQVzkFg0PxBZiN0YXkHVUtrBydw22Nc3X1JJOCQLHvDZ3xrn
   ZO7lq9AIzwn+TCjw2BtHHwPwpAbQoOgaAAkO/J4PvmnOr8Ef6xZlPYHpy
   55chb375c7TEyW+mvzf47zVJY3PHsKBna+t2EnfZJzJ+zB/a5bsD1SGBE
   kEokEAEXrs/oejgPHpELx8VXU5OnBiIi8zF3dXf/kkoQO6zYebkJ8Kz7E
   RDBs+sTIfc/66LrelY318VJyatPFMPLNovKJcItkit2/5NxYVycAEBj93
   g==;
X-CSE-ConnectionGUID: chI7OZ0wTgCErgOU8BxofA==
X-CSE-MsgGUID: ZHoyt8wvSdudiZkpQ0Gs1Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="58072824"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="58072824"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:09:21 -0700
X-CSE-ConnectionGUID: UBl7Bk0MTea9sCp6DEx9Lg==
X-CSE-MsgGUID: T8qLEEmDTD6lwWBuE8tRhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="137659102"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:09:15 -0700
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
Subject: [RFC PATCH 13/21] KVM: x86/tdp_mmu: Alloc external_spt page for mirror page table splitting
Date: Thu, 24 Apr 2025 11:07:28 +0800
Message-ID: <20250424030728.419-1-yan.y.zhao@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Enhance tdp_mmu_alloc_sp_split() to allocate the external page table page
for splitting the mirror page table.

[Yan: Rebased and simplified the code ]

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8ee01277cc07..799a08f91bf9 100644
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



Return-Path: <kvm+bounces-44038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 27A8EA99F4E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECFA344282E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BDA31AC891;
	Thu, 24 Apr 2025 03:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ii+OuqOQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8491A316A;
	Thu, 24 Apr 2025 03:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464078; cv=none; b=Px60uBDeNoFUhf7+qEbaDRvtASbLSAcCKvHmILfucWY6xaKRrQbSmm5VXrVU84EQou0KY22p9RxMyp5qriqkez29vbXlXd7TZ175joeslOQNMqxE5yFe/74N4CPc/A2yq7BQWHK1JA+OQ1x/BK4am/c0XlQE7UaM5g8G5/i8xig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464078; c=relaxed/simple;
	bh=taJzXXNZDn+3qpBtx4Bk48OnVGTvHBxLcjMN7vryOac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqk7ac/OwqWTcT91snVbeNtR9kwQbUjUI3iRgSnqdpQLtNS99O8rJ18heHoTafoBYwc4kD1xv4mlRzYOE1BXVtG1hvEq4RPfqds1u61rMT2wByjnT97aJK1sIQJs6qybLBJkPfIIo49be2PfhvC5KzmdQZIF7tR/Wd+dr7zCRII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ii+OuqOQ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464077; x=1777000077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=taJzXXNZDn+3qpBtx4Bk48OnVGTvHBxLcjMN7vryOac=;
  b=Ii+OuqOQa5eqXELMghP96YFtvnfIiGSOzdmH+TOgYo38ELQYa6L9Miey
   jw5nDKC/lTX3FwZVFvzl8MRseBszTgQnN826jd6vkDEgQevKs9SrDdl0E
   JsqsZwqyvuINdHcYXsdvdH5SCPRtszqf2rdXVS3FtjJKscy0WexT8Y15Z
   9x7kTmdBbSEm5Yyx06CY/jO1IbpenY8MIy2KQOcygP33199v761VysBoV
   Yvn7OyevNwrZ/BAY7ojG/BAqmY2NASsvnZLdsY+4bnu1afBtLCjpKOUf3
   UKPZf3Szq82hXTWUeXDAFmu/OQdQba1jzBAry9hHl7SAufmmNKC6GqGG1
   w==;
X-CSE-ConnectionGUID: maEepibdT1K+MMNZmOFTIw==
X-CSE-MsgGUID: 7DoBP6g3SaSnbMHBfgFw7w==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="64491345"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="64491345"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:07:56 -0700
X-CSE-ConnectionGUID: dRfOiWFYTCSy8N+o/0MJbw==
X-CSE-MsgGUID: sPBW4DMqQtyi6nR39ixFkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="136564933"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:07:50 -0700
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
Subject: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
Date: Thu, 24 Apr 2025 11:06:03 +0800
Message-ID: <20250424030603.329-1-yan.y.zhao@intel.com>
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

Increase folio ref count before mapping a private page, and decrease
folio ref count after a mapping failure or successfully removing a private
page.

The folio ref count to inc/dec corresponds to the mapping/unmapping level,
ensuring the folio ref count remains balanced after entry splitting or
merging.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 355b21fc169f..e23dce59fc72 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1501,9 +1501,9 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
 }
 
-static void tdx_unpin(struct kvm *kvm, struct page *page)
+static void tdx_unpin(struct kvm *kvm, struct page *page, int level)
 {
-	put_page(page);
+	folio_put_refs(page_folio(page), KVM_PAGES_PER_HPAGE(level));
 }
 
 static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
@@ -1517,13 +1517,13 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 
 	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, page, &entry, &level_state);
 	if (unlikely(tdx_operand_busy(err))) {
-		tdx_unpin(kvm, page);
+		tdx_unpin(kvm, page, level);
 		return -EBUSY;
 	}
 
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_PAGE_AUG, err, entry, level_state);
-		tdx_unpin(kvm, page);
+		tdx_unpin(kvm, page, level);
 		return -EIO;
 	}
 
@@ -1570,10 +1570,11 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
 	 * migration.  Until guest_memfd supports page migration, prevent page
 	 * migration.
-	 * TODO: Once guest_memfd introduces callback on page migration,
-	 * implement it and remove get_page/put_page().
+	 * TODO: To support in-place-conversion in gmem in futre, remove
+	 * folio_ref_add()/folio_put_refs(). Only increase the folio ref count
+	 * when there're errors during removing private pages.
 	 */
-	get_page(page);
+	folio_ref_add(page_folio(page), KVM_PAGES_PER_HPAGE(level));
 
 	/*
 	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
@@ -1647,7 +1648,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		return -EIO;
 
 	tdx_clear_page(page, level);
-	tdx_unpin(kvm, page);
+	tdx_unpin(kvm, page, level);
 	return 0;
 }
 
@@ -1727,7 +1728,7 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
 	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
 		atomic64_dec(&kvm_tdx->nr_premapped);
-		tdx_unpin(kvm, page);
+		tdx_unpin(kvm, page, level);
 		return 0;
 	}
 
-- 
2.43.2



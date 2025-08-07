Return-Path: <kvm+bounces-54245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A38FB1D530
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:47:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EF6B169463
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72DA626D4E2;
	Thu,  7 Aug 2025 09:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E1HKBExw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177801B78F3;
	Thu,  7 Aug 2025 09:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559988; cv=none; b=GKMHUrpPRv/y0/4d66pTD7Nh32hJRlNNTNJPlPyaWVYQPfC7ArNpluZKpkW7cCbtBW62TGRUR41JxzkBnCn6WKTcf3sIMXJDioBqVaaJhrtIXH+1e4zIsai1JY7gUXEpLzN8uRyQeNARVt7hI/QGGbs2WGDDby8K4K4s2IJeQfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559988; c=relaxed/simple;
	bh=npfZY3owTxlrv9udkYSPiXOTHFe1ycuDdbUQV9i3p6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6ydFTbUIxxTtjnWD5qJpYToSoB6nvmkGEkbwjj+WgkmTIeXGFEc26DS7RRgx6Y994ceZIVmGCpwDFi2Q9fxN2icaGvNtQ9TcPp+uvFcFSMyEydHIlNafVtDl3g2N994u2Sdgh6wfXFjdv0f12l3FgYEbaUWnnRB3woMV0cDTwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E1HKBExw; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559987; x=1786095987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=npfZY3owTxlrv9udkYSPiXOTHFe1ycuDdbUQV9i3p6k=;
  b=E1HKBExw3LpyuVgCoMDJNRk6Wi81H/zu7UWMXU2mYgZDt5rwEfXQoV9v
   2RBN03B67b0pryDaMn7nLGy318VxzszdUy3KSBFtq8VI3A9rIzil2DBZy
   D/zTW5S7qOKE3NcG7pd+UbdL0DtLjSYt0mst22XamX9oyycWvCUeW9hWZ
   YS75WZI5+rJHJaoyh8gnw1odeT0zF+4xQgGVL754ulovxuwHu74SJTsiC
   SAVIoopwNXcVyh5JL88Js86qqzyQrYHXkxT0rLoXM4qN8oCHrlSHIZW8B
   /GYyJsuA0eKIsnj5FdGZqFNT6RW+QvzsPIOQ5w+gJl0aVDi0zbHvjpgYy
   Q==;
X-CSE-ConnectionGUID: ejpB1aXPSQKK+xAKjXCHsw==
X-CSE-MsgGUID: ugv3lmDmQ36Y5eG5Y9vcDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="68342850"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="68342850"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:46:27 -0700
X-CSE-ConnectionGUID: NY+zqrIlQNWgA0Xmabn2fg==
X-CSE-MsgGUID: 3n5stZWpReOpx/cp2ewujA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="170392279"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:46:21 -0700
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
Subject: [RFC PATCH v2 20/23] KVM: TDX: Handle Dynamic PAMT in tdh_mem_page_demote()
Date: Thu,  7 Aug 2025 17:45:50 +0800
Message-ID: <20250807094550.4748-1-yan.y.zhao@intel.com>
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

If Dynamic PAMT is enabled, TDH.MEM.PAGE.DEMOTE will take the PAMT page
pair in registers R12 and R13.

Pass the pamt_pages list down to tdh_mem_page_demote() and populate
registers R12 and R13 from it.

Instead of using seamcall_ret(), use seamcall_saved_ret() as it can
handle registers above R11.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- Pulled from
  git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt-huge.
- Rebased on top of TDX huge page RFC v2 (Yan).
---
 arch/x86/include/asm/tdx.h  |  1 +
 arch/x86/kvm/vmx/tdx.c      |  4 ++--
 arch/x86/virt/vmx/tdx/tdx.c | 13 +++++++++++--
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index c058a82d4a97..2e529f0c578a 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -180,6 +180,7 @@ u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
 u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *page,
+			struct list_head *pamt_pages,
 			u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mr_finalize(struct tdx_td *td);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 24aa9aaad6d8..9d24a1a86a23 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1924,12 +1924,12 @@ static int tdx_spte_demote_private_spte(struct kvm *kvm, gfn_t gfn,
 	u64 err, entry, level_state;
 
 	err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
-				  &entry, &level_state);
+				  NULL, &entry, &level_state);
 
 	if (unlikely(tdx_operand_busy(err))) {
 		tdx_no_vcpus_enter_start(kvm);
 		err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
-					  &entry, &level_state);
+					  NULL, &entry, &level_state);
 		tdx_no_vcpus_enter_stop(kvm);
 	}
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index b7a0ee0f4a50..50f9d49f1c91 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1825,6 +1825,7 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
 EXPORT_SYMBOL_GPL(tdh_mng_rd);
 
 u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *page,
+			struct list_head *pamt_pages,
 			u64 *ext_err1, u64 *ext_err2)
 {
 	struct tdx_module_args args = {
@@ -1832,10 +1833,18 @@ u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *page
 		.rdx = tdx_tdr_pa(td),
 		.r8 = page_to_phys(page),
 	};
-	u64 ret;
+	struct page *pamt_page;
+	u64 *p, ret;
 
+	if (level == TDX_PS_2M) {
+		p = &args.r12;
+		list_for_each_entry(pamt_page, pamt_pages, lru) {
+			*p = page_to_phys(pamt_page);
+			p++;
+		}
+	}
 	tdx_clflush_page(page);
-	ret = seamcall_ret(TDH_MEM_PAGE_DEMOTE, &args);
+	ret = seamcall_saved_ret(TDH_MEM_PAGE_DEMOTE, &args);
 
 	*ext_err1 = args.rcx;
 	*ext_err2 = args.rdx;
-- 
2.43.2



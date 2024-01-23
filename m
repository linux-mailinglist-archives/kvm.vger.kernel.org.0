Return-Path: <kvm+bounces-6698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22DE3837B8E
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 02:02:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF31028A55F
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBC8114E2D5;
	Tue, 23 Jan 2024 00:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GfxJBnDD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2B614D45E;
	Tue, 23 Jan 2024 00:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969361; cv=none; b=F3KocvEZT1Bv5ya8FP7kw36xmPApThSKm12q4wkPz/aLr1XoYprMmrfZEXrAhSyxIDIxohvXGZrxZzjCWq/pAZOnRBNtlpu9izmIGfeUoQisTe92tN3QWrIN63j64B57mYYGBCUwK5LMqKO/rxhCCx2vhVwVDdgXvilrNg7jKCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969361; c=relaxed/simple;
	bh=R8cBMPqil2+5pjGW+al9piEQU44M2m54kdZoD0oUf8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LwD+YJZ3kmAKBCe3cQq5Creock9LduXAhnmUftqPPkkV/Mv+DnXlVHbI1XUlVX6asNmlbE0b50mW1VaFuBEmJ/FnzPGD+xa27gm+S8j8np4vXxJBDS6MbKycQiTL8F9yL4M+a+1msb4e7SYO+WfdriLqtZ9uw5WGUuLWp65sUjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GfxJBnDD; arc=none smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705969359; x=1737505359;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R8cBMPqil2+5pjGW+al9piEQU44M2m54kdZoD0oUf8w=;
  b=GfxJBnDDhfz42jEJPsWkzAqSaPyVDSW/CFp1Rc/tVaK6v37NJICwlbNs
   CiXbXtnBWBkLrf6wirmw//dgGhGCU3lYwHtP+PIeDCzNWvQtQ+C1HTxNY
   9LbMKhDyMq99Fs+WiLkc4Tyd31D5ZAKJw/BgZormfhUfXAWmEz6EalOKv
   EwgxC2+PcVW3G/F97k2Y4b+IkB37i0R5Q3bg5BbJH70ZviCxKAcsKuEcs
   a+7jqHPH/miPwuRXtTXwv5RjpV8hXccKPTqi0q8TJGfm5ewnjtYY6AfIU
   35cV9JQN1QxJ/K6L4vPt1dL1SSivJJwxQvHr2PEkjWpS2XcHEYm96VHSk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="405125645"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="405125645"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27825624"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:36 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v7 02/13] KVM: TDX: Pass KVM page level to tdh_mem_page_aug()
Date: Mon, 22 Jan 2024 16:22:17 -0800
Message-Id: <63c4832507b9b10383e00b33ce2ab6e756ecdf3b.1705965958.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965958.git.isaku.yamahata@intel.com>
References: <cover.1705965958.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

Level info is needed in tdx_clflush_page() to generate the correct page
size.

Besides, explicitly pass level info to SEAMCALL instead of assuming
it's zero. It works naturally when 2MB support lands.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v7:
- Don't pass level to tdh_mem_page_add() as it supports only 4K page.
- catch up for change of tdx_seamcall()
---
 arch/x86/kvm/vmx/tdx.c     |  2 +-
 arch/x86/kvm/vmx/tdx_ops.h | 12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 67bb0c4c73a7..549dec05ccad 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1520,7 +1520,7 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	union tdx_sept_entry entry;
 	u64 err;
 
-	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, hpa, &out);
+	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
 	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
 		tdx_unpin(kvm, pfn);
 		return -EAGAIN;
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 2afd927eaa45..ce722e917d14 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -59,6 +59,11 @@ static inline int pg_level_to_tdx_sept_level(enum pg_level level)
 	return level - 1;
 }
 
+static inline enum pg_level tdx_sept_level_to_pg_level(int tdx_level)
+{
+	return tdx_level + 1;
+}
+
 static inline void tdx_clflush_page(hpa_t addr, enum pg_level level)
 {
 	clflush_cache_range(__va(addr), KVM_HPAGE_SIZE(level));
@@ -108,6 +113,7 @@ static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
 				   struct tdx_module_args *out)
 {
+	/* TDH.MEM.PAGE.ADD() suports only 4K page. tdx 4K page level = 0 */
 	struct tdx_module_args in = {
 		.rcx = gpa,
 		.rdx = tdr,
@@ -178,16 +184,16 @@ static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 	return tdx_seamcall_sept(TDH_MEM_PAGE_RELOCATE, &in, out);
 }
 
-static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
+static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, int level, hpa_t hpa,
 				   struct tdx_module_args *out)
 {
 	struct tdx_module_args in = {
-		.rcx = gpa,
+		.rcx = gpa | level,
 		.rdx = tdr,
 		.r8 = hpa,
 	};
 
-	tdx_clflush_page(hpa, PG_LEVEL_4K);
+	tdx_clflush_page(hpa, tdx_sept_level_to_pg_level(level));
 	return tdx_seamcall_sept(TDH_MEM_PAGE_AUG, &in, out);
 }
 
-- 
2.25.1



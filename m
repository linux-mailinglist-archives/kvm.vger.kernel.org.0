Return-Path: <kvm+bounces-9758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09349866DCC
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:12:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B36FC1F25E48
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 284C52C853;
	Mon, 26 Feb 2024 08:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CHw7tusO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE32132C04;
	Mon, 26 Feb 2024 08:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936177; cv=none; b=eQxBxC+JuxIrMUfsEMtdyc6+oQ/nYIXIkhvxIv8EoP65OzhmrmppQK7jH0ciIRa2r3c+cJzd4AezGKddqvnWkesnLZoT/zuXfqTQjBety/uiY5XYGpiAvPo85MPEjH264KBOzj6RylDKZgIdLDy+r5c3atkbwQF+7H2MexmAoao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936177; c=relaxed/simple;
	bh=9sC+tVDstlmuTrpJLRIwemasGuxQzkEeVSSJPRH35IY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iFiqQRoJyvnsqkc3S5UJ0gahvKswEBwiZ/QG2TqkEcewXYQAPH3LlM1Jw4T0XhznidAUSUwM9aMprQnIF0wfcl9gZ29V9btWXadSQ7SK9Q0cZX3KLKdPI3brNlObp/8IM26ChSEkKi3xfrJJQjp0wE/fI3HkNMYRaL9mM0EXNLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CHw7tusO; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936175; x=1740472175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9sC+tVDstlmuTrpJLRIwemasGuxQzkEeVSSJPRH35IY=;
  b=CHw7tusO+9QApu9CBLSO1jjmYdVkdRcJYNkHU4Xm/YgCzF8h66DDDW51
   3oJs8ZQOZENdtdLA+N/iYff626xsvL9JC2clWRAN5OpKWCd1efpzryxc0
   MaJklo0T+2Xz3N1FKadOyZQQSkPAM+zE/PmuQfMnEwI676b8x3W/kAAnw
   7gQEACu6p54VVGRr1krZ8R+sl+/RPv0WMv5XFX9Oi3F9nH82o2geFF7zR
   kqzzUHq3wd4qb71TyjPj0i6KZUmSBPPNeMzU4oK5dUz5Nj+6urF2ciEFE
   t9EnuUv2xGBy5Jpij8LjCCx++/kDlzD6FH1yfYWb0DgJmpbr1E2hsWv4x
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751505"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751505"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735293"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:32 -0800
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
Subject: [PATCH v8 03/14] KVM: TDX: Pass KVM page level to tdh_mem_page_aug()
Date: Mon, 26 Feb 2024 00:29:17 -0800
Message-Id: <8f4125c90898652317ae6bec5d46fe45d3f11eef.1708933624.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933624.git.isaku.yamahata@intel.com>
References: <cover.1708933624.git.isaku.yamahata@intel.com>
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
index a71093f7c3e3..fd992966379c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1470,7 +1470,7 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	union tdx_sept_entry entry;
 	u64 err;
 
-	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, hpa, &out);
+	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
 	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
 		tdx_unpin(kvm, pfn);
 		return -EAGAIN;
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 3af124711e98..ef4748943ac7 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -51,6 +51,11 @@ static inline int pg_level_to_tdx_sept_level(enum pg_level level)
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
@@ -100,6 +105,7 @@ static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
 				   struct tdx_module_args *out)
 {
+	/* TDH.MEM.PAGE.ADD() suports only 4K page. tdx 4K page level = 0 */
 	struct tdx_module_args in = {
 		.rcx = gpa,
 		.rdx = tdr,
@@ -170,16 +176,16 @@ static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
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



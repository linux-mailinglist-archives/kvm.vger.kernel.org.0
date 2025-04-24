Return-Path: <kvm+bounces-44033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0B84A99F3C
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:07:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4FF617F9D4
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0BDE1ACEBB;
	Thu, 24 Apr 2025 03:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JndJfV4K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366491A8F8A;
	Thu, 24 Apr 2025 03:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464000; cv=none; b=rQ349uMj75sfFMPsR4dL2E/TkowqEuSKDvYKSqQxbf+I2NBemeWj8e1UpdYJyFncMFEAxMbdnxP0gbdSaAD03JqsfL48GIFgdPrdpdGcPxqXWgo6kUG4VctucYdairEzeLVjeOfbTW///1lbKzUP4gifl+CqDpXUQTT9Uv0Ej8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464000; c=relaxed/simple;
	bh=PfVFd7JLz5IXS7WUKb/plfNE0+8ZFcg3O3M4av8SGOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tw7BCfuQQO9zZZ4ddYNeapkHwu/6/HZZyt7eALXmsuo3HjIiOos7/jrGRJQ4664xBZqs+/owEaMTFZhDDebPLQK4DhtScO21QKeT5X+SuqZ/wtmdl4kStLfiLMVaRkHrDZtdDDSDXmdz2zej/TRjIUjAIcEAu1HxH4Nm2NdI99Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JndJfV4K; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745463998; x=1776999998;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PfVFd7JLz5IXS7WUKb/plfNE0+8ZFcg3O3M4av8SGOg=;
  b=JndJfV4KSK+/Kph4o2wGiLuRjZrySVAZPY5x2tl8cFv3v40XSQOuZsKr
   1K1bR0EdsGArk5oafYhNH7QWaxTDT/jMFmR5RdHVX+uFRNuXT3vyLm1US
   17trnnRnIbe1mWzEd+3EGXk0aPjKOJZ9H2L3soze0nO2x/k/3cdOrzalv
   JN8lILBZwteBEPEvU3pTkfSEbHa9LNXqetjDupZ6BfUXpqxIPGsODVrJo
   +CnbfxduD6xDdMff45DcgjKmmo3HkfdtWZz0Ezyts11S7vY6bTSBjdb2H
   ONlxfvoHm2kWhgMQDDRbNfevEOKo5IlBBNt4AMFCy5dj3cVXdcwXoWvyP
   Q==;
X-CSE-ConnectionGUID: KwdD0Sn1RTmlKRtyjkFQ5A==
X-CSE-MsgGUID: PEV58hqBSmWdki16dq+qkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="47205567"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="47205567"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:06:38 -0700
X-CSE-ConnectionGUID: vGIPgGa/TgCJjZUv3jDSPA==
X-CSE-MsgGUID: 4QNwRSLpSqmO/KJE+PsO6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="133383716"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:06:31 -0700
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
Subject: [RFC PATCH 03/21] x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_page_demote()
Date: Thu, 24 Apr 2025 11:04:45 +0800
Message-ID: <20250424030445.32704-1-yan.y.zhao@intel.com>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

Add a wrapper tdh_mem_page_demote() to invoke SEAMCALL TDH_MEM_PAGE_DEMOTE
to demote a huge leaf entry to a non-leaf entry in S-EPT. Currently, the
TDX module only supports demotion of a 2M huge leaf entry. After a
successful demotion, the old 2M huge leaf entry in S-EPT is replaced with a
non-leaf entry, linking to the newly-added page table page. The newly
linked page table page then contains 512 leaf entries, pointing to the 2M
guest private pages.

The "gpa" and "level" direct the TDX module to search and find the old
huge leaf entry.

As the new non-leaf entry points to a page table page, callers need to
pass in the page table page in parameter "page".

In case of S-EPT walk failure, the entry, level and state where the error
was detected are returned in ext_err1 and ext_err2.

On interrupt pending, SEAMCALL TDH_MEM_PAGE_DEMOTE returns error
TDX_INTERRUPTED_RESTARTABLE.

[Yan: Rebased and split patch, wrote changelog]

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 20 ++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 26ffc792e673..08eff4b2f5e7 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -177,6 +177,8 @@ u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
+u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *page,
+			u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mr_finalize(struct tdx_td *td);
 u64 tdh_vp_flush(struct tdx_vp *vp);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index a66d501b5677..5699dfe500d9 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1684,6 +1684,26 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_rd);
 
+u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *page,
+			u64 *ext_err1, u64 *ext_err2)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = tdx_tdr_pa(td),
+		.r8 = page_to_phys(page),
+	};
+	u64 ret;
+
+	tdx_clflush_page(page);
+	ret = seamcall_ret(TDH_MEM_PAGE_DEMOTE, &args);
+
+	*ext_err1 = args.rcx;
+	*ext_err2 = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_page_demote);
+
 u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 82bb82be8567..b4dc6b86d40a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -24,6 +24,7 @@
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
 #define TDH_MNG_RD			11
+#define TDH_MEM_PAGE_DEMOTE		15
 #define TDH_MR_EXTEND			16
 #define TDH_MR_FINALIZE			17
 #define TDH_VP_FLUSH			18
-- 
2.43.2



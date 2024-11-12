Return-Path: <kvm+bounces-31574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E8069C4FB0
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:42:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D026C2829D3
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8707E210184;
	Tue, 12 Nov 2024 07:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nBxOTc7L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCF220B7F5;
	Tue, 12 Nov 2024 07:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397160; cv=none; b=Zbqa0pmlODSHFhF5O+S6M0rTlqAcuX2oOt0af1Yk9SNnqj3U2DY5c53QeZbVz7xyt5yqXnxU5ZUdsk1B7h0VG/yWsvaR9NKFhqkRyjIO+pDdhJp65Id7X/qlrfTZ+WHcxUpS29eTWOUm+wUK4i6xtkdTn3f5XS1p4wG9Sp06Yrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397160; c=relaxed/simple;
	bh=Tlk940Q5sXfX8YFlbf4ZFyHk3Wts0lRf2SX7bTseaDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ay3JwA6n+v6jURvbfc8JmC47+3Jux+fK4EXaausc30f/7rOkXUGLdixTtTDQjEtG1DdLaNxSnAaKmAP+2U9+8AIDA2jC36ICZVuTgeIKjRAn9KEnyPTWmjph6ajiYUXPGBcyDfMCk0zRUT9so4NTt4syIAGANOOFAEduUN3IRPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nBxOTc7L; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397159; x=1762933159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tlk940Q5sXfX8YFlbf4ZFyHk3Wts0lRf2SX7bTseaDM=;
  b=nBxOTc7LmzyeNZKBqJ6qH5lilcaXg35wT5qX+00TzBDjTAw+yotMp7ih
   qcgeDOg80jxWJmDFoRi85EPDAy0Zrpkz3pY5lonAC2HN12Dapxq01QojX
   J4VZI16BT9eD+9BjI62nHVdwbIxDhBy7M0Pw7XfYnvaITGnM3w4i4dR5A
   /hLNygyFFO4+SuQ7IPqY6J2fld5VGbKX9FQOkkLidPdCNHzClIYLj+8w8
   XcocSiWl11VfpXXzuYxbqdw69Ppz37nAu3/D5I4LRz8V8L+BuNvBlbEXh
   cg8fN1C0m0AWoidh2oWZkPx/r+o8v8kSDoc7ba0LCufuPZ+NWGf6pl8Tl
   g==;
X-CSE-ConnectionGUID: LvPg92jDRHqCnXzVU6E3DA==
X-CSE-MsgGUID: jBeXkSMuTueMkS4a+oWIEw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31389413"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31389413"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:39:19 -0800
X-CSE-ConnectionGUID: RD/na2I2TVC93NWbTkcNCg==
X-CSE-MsgGUID: GJD6Z86dQ125M6RARtRW4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="87081975"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:39:15 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 11/24] x86/virt/tdx: Add SEAMCALL wrappers to manage TDX TLB tracking
Date: Tue, 12 Nov 2024 15:36:47 +0800
Message-ID: <20241112073648.22143-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX module defines a TLB tracking protocol to make sure that no logical
processor holds any stale Secure EPT (S-EPT or SEPT) TLB translations for a
given TD private GPA range. After a successful TDH.MEM.RANGE.BLOCK,
TDH.MEM.TRACK, and kicking off all vCPUs, TDX module ensures that the
subsequent TDH.VP.ENTER on each vCPU will flush all stale TLB entries for
the specified GPA ranges in TDH.MEM.RANGE.BLOCK. Wrap the
TDH.MEM.RANGE.BLOCK with tdh_mem_range_block() and TDH.MEM.TRACK with
tdh_mem_track() to enable the kernel to assist the TDX module in TLB
tracking management.

The caller of tdh_mem_range_block() needs to specify "GPA" and "level" to
request the TDX module to block the subsequent creation of TLB translation
for a GPA range. This GPA range can correspond to a SEPT page or a TD
private page at any level.

Contentions and errors are possible with the SEAMCALL TDH.MEM.RANGE.BLOCK.
Therefore, the caller of tdh_mem_range_block() needs to check the function
return value and retrieve extended error info from the function output
params.

Upon TDH.MEM.RANGE.BLOCK success, no new TLB entries will be created for
the specified private GPA range, though the existing TLB translations may
still persist.

Call tdh_mem_track() after tdh_mem_range_block(). No extra info is required
except the TDR HPA to denote the TD. TDH.MEM.TRACK will advance the TD's
epoch counter to ensure TDX module will flush TLBs in all vCPUs once the
vCPUs re-enter the TD. TDH.MEM.TRACK will fail to advance TD's epoch
counter if there are vCPUs still running in non-root mode at the previous
TD epoch counter. Therefore, send IPIs to kick off vCPUs after
tdh_mem_track() to avoid the failure by forcing all vCPUs to re-enter the
TD.

Contentions are also possible in TDH.MEM.TRACK. For example, TDH.MEM.TRACK
may contend with TDH.VP.ENTER when advancing the TD epoch counter.
tdh_mem_track() does not provide the retries for the caller. Callers can
choose to avoid contentions or retry on their own.

[Kai: Switched from generic seamcall export]
[Yan: Re-wrote the changelog]
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
TDX MMU part 2 v2:
- split out TDH.MEM.RANGE.BLOCK and TDH.MEM.TRACK and re-wrote the patch
  msg (Yan).
- removed TDH.MEM.RANGE.UNBLOCK since it's unused. (Yan)
- split out from original patch "KVM: TDX: Add C wrapper functions for
  SEAMCALLs to the TDX module" and move to x86 core (Yan).
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 27 +++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 3 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index d363aa201283..227cb334176e 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -128,6 +128,7 @@ u64 tdh_mem_page_add(u64 tdr, u64 gpa, u64 hpa, u64 source, u64 *rcx, u64 *rdx);
 u64 tdh_mem_sept_add(u64 tdr, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx);
 u64 tdh_vp_addcx(u64 tdvpr, u64 tdcx);
 u64 tdh_mem_page_aug(u64 tdr, u64 gpa, u64 hpa, u64 *rcx, u64 *rdx);
+u64 tdh_mem_range_block(u64 tdr, u64 gpa, u64 level, u64 *rcx, u64 *rdx);
 u64 tdh_mng_key_config(u64 tdr);
 u64 tdh_mng_create(u64 tdr, u64 hkid);
 u64 tdh_vp_create(u64 tdr, u64 tdvpr);
@@ -141,6 +142,7 @@ u64 tdh_vp_rd(u64 tdvpr, u64 field, u64 *data);
 u64 tdh_vp_wr(u64 tdvpr, u64 field, u64 data, u64 mask);
 u64 tdh_vp_init_apicid(u64 tdvpr, u64 initial_rcx, u32 x2apicid);
 u64 tdh_phymem_page_reclaim(u64 page, u64 *rcx, u64 *rdx, u64 *r8);
+u64 tdh_mem_track(u64 tdr);
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(u64 tdr);
 #else
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index e63e3cfd41fc..f7f83d86ec18 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1645,6 +1645,23 @@ u64 tdh_mem_page_aug(u64 tdr, u64 gpa, u64 hpa, u64 *rcx, u64 *rdx)
 }
 EXPORT_SYMBOL_GPL(tdh_mem_page_aug);
 
+u64 tdh_mem_range_block(u64 tdr, u64 gpa, u64 level, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = tdr,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MEM_RANGE_BLOCK, &args);
+
+	*rcx = args.rcx;
+	*rdx = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_range_block);
+
 u64 tdh_mng_key_config(u64 tdr)
 {
 	struct tdx_module_args args = {
@@ -1820,6 +1837,16 @@ u64 tdh_phymem_page_reclaim(u64 page, u64 *rcx, u64 *rdx, u64 *r8)
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_reclaim);
 
+u64 tdh_mem_track(u64 tdr)
+{
+	struct tdx_module_args args = {
+		.rcx = tdr,
+	};
+
+	return seamcall(TDH_MEM_TRACK, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mem_track);
+
 u64 tdh_phymem_cache_wb(bool resume)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index d32ed527f67f..e659eee1080a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -22,6 +22,7 @@
 #define TDH_MEM_SEPT_ADD		3
 #define TDH_VP_ADDCX			4
 #define TDH_MEM_PAGE_AUG		6
+#define TDH_MEM_RANGE_BLOCK		7
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
 #define TDH_VP_CREATE			10
@@ -37,6 +38,7 @@
 #define TDH_SYS_KEY_CONFIG		31
 #define TDH_SYS_INIT			33
 #define TDH_SYS_RD			34
+#define TDH_MEM_TRACK			38
 #define TDH_SYS_LP_INIT			35
 #define TDH_SYS_TDMR_INIT		36
 #define TDH_PHYMEM_CACHE_WB		40
-- 
2.43.2



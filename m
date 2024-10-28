Return-Path: <kvm+bounces-29841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0EDE9B3094
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:42:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D03E1F2172F
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 12:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53F4A1DD525;
	Mon, 28 Oct 2024 12:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lIsjyDFa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6916D1DCB30;
	Mon, 28 Oct 2024 12:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119304; cv=none; b=Ez1HZD9pKXpbxM904oTjBiihqs1yU1nJxlI63FZKk2WzTXk2NCr8+r0NLtcVbPElf3fesbqA1oPkN8o/eMjq0El7EuoaTeVbtM33Z/OkMkca+gO87FvhP0GUw/8Mcd1s5jqLG4pd3zqPS/EOsmAOUXzgd6u+BIX8A7fYItn2DYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119304; c=relaxed/simple;
	bh=yZMoNSnCsjA2eku7horWjp5e7QExJ6tYxIH3z7yRPKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxxU4yBI+tCqH7MCx648xRwVw/dySmEmqs/hrRc4VIPPMIcjYCIZaSLkoM+GJWL9806kZ6+UjVbN/yyEAkUZCFcXWqB/umEc2xzyP7dOve3HdeYKZ/UB0YaIU1IPq5E/b6QVM4l/qk81tnvrv9MKXpQdyL19cd33Q7vU0yIvP2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lIsjyDFa; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730119302; x=1761655302;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yZMoNSnCsjA2eku7horWjp5e7QExJ6tYxIH3z7yRPKQ=;
  b=lIsjyDFah3EgSqQ5fgl5oeeVuGutOGX8BGdW3y0y5FdCYjXDMmKLMumr
   29zfcgitf3CPQ/r/y0Q75WjY8s/39wT27RLnL2rVa9yhWKcfFOZiD7GVD
   dnWG7DJOpljKfuKKQOBvg0/1TdYqUA/XckbcV+VLm6fjBMGxGLJl9uNwl
   JcBe4wcvT7EsSJB+d1lgsPR8etIM/DCBOZH8ho8PhT3oYxWshN9iOjLiV
   5EQiuiIMSJemU9Zlm3M5HlEzfXSv7l08DmooWgRZ1hgvraBgL3+sGP2kG
   MXigz8nUqtOkCzuYQsPNPzitro6M8TviRjx69prqqd5DnUibTkMoViPHl
   w==;
X-CSE-ConnectionGUID: VAXCeNpoQbCKBzIXoHC8Jw==
X-CSE-MsgGUID: pGoik0QuRVmp5tin7kHpjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="32575271"
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="32575271"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:42 -0700
X-CSE-ConnectionGUID: eVE5GG6zSdyMo1CcSrlSWQ==
X-CSE-MsgGUID: TU+JTy81Sv6cS8Ub5ltUXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="82420910"
Received: from gargmani-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.169])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:38 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	dan.j.williams@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	nik.borisov@suse.com,
	kai.huang@intel.com
Subject: [PATCH v6 04/10] x86/virt/tdx: Use dedicated struct members for PAMT entry sizes
Date: Tue, 29 Oct 2024 01:41:06 +1300
Message-ID: <e1f311a32a1721cb138982d475515e24f18e4edb.1730118186.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730118186.git.kai.huang@intel.com>
References: <cover.1730118186.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, the 'struct tdmr_sys_info_tdmr' which includes TDMR related
fields defines the PAMT entry sizes for TDX supported page sizes (4KB,
2MB and 1GB) as an array:

	struct tdx_sys_info_tdmr {
		...
		u16 pamt_entry_sizes[TDX_PS_NR];
	};

PAMT entry sizes are needed when allocating PAMTs for each TDMR.  Using
the array to contain PAMT entry sizes reduces the number of arguments
that need to be passed when calling tdmr_set_up_pamt().  It also makes
the code pattern like below clearer:

	for (pgsz = TDX_PS_4K; pgsz < TDX_PS_NR; pgsz++) {
		pamt_size[pgsz] = tdmr_get_pamt_sz(tdmr, pgsz,
					pamt_entry_size[pgsz]);
		tdmr_pamt_size += pamt_size[pgsz];
	}

However, the auto-generated metadata reading code generates a structure
member for each field.  The 'global_metadata.json' has a dedicated field
for each PAMT entry size, and the new 'struct tdx_sys_info_tdmr' looks
like:

	struct tdx_sys_info_tdmr {
		...
		u16 pamt_4k_entry_size;
		u16 pamt_2m_entry_size;
		u16 pamt_1g_entry_size;
	};

To prepare to use the auto-generated code, make the existing 'struct
tdx_sys_info_tdmr' look like the generated one.  But when passing to
tdmrs_set_up_pamt_all(), build a local array of PAMT entry sizes from
the structure so the code to allocate PAMTs can stay the same.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 14 +++++++++-----
 arch/x86/virt/vmx/tdx/tdx.h |  4 +++-
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 7a2f979092e7..28537a6c47fc 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -304,9 +304,9 @@ struct field_mapping {
 static const struct field_mapping fields[] = {
 	TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs),
 	TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
-	TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
-	TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
-	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
+	TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_4k_entry_size),
+	TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_2m_entry_size),
+	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_1g_entry_size),
 };
 
 static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
@@ -932,14 +932,18 @@ static int construct_tdmrs(struct list_head *tmb_list,
 			   struct tdmr_info_list *tdmr_list,
 			   struct tdx_sys_info_tdmr *sysinfo_tdmr)
 {
+	u16 pamt_entry_size[TDX_PS_NR] = {
+		sysinfo_tdmr->pamt_4k_entry_size,
+		sysinfo_tdmr->pamt_2m_entry_size,
+		sysinfo_tdmr->pamt_1g_entry_size,
+	};
 	int ret;
 
 	ret = fill_out_tdmrs(tmb_list, tdmr_list);
 	if (ret)
 		return ret;
 
-	ret = tdmrs_set_up_pamt_all(tdmr_list, tmb_list,
-			sysinfo_tdmr->pamt_entry_size);
+	ret = tdmrs_set_up_pamt_all(tdmr_list, tmb_list, pamt_entry_size);
 	if (ret)
 		return ret;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 2600ec3752f5..ec879d54eb5c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -84,7 +84,9 @@ struct tdmr_info {
 struct tdx_sys_info_tdmr {
 	u16 max_tdmrs;
 	u16 max_reserved_per_tdmr;
-	u16 pamt_entry_size[TDX_PS_NR];
+	u16 pamt_4k_entry_size;
+	u16 pamt_2m_entry_size;
+	u16 pamt_1g_entry_size;
 };
 
 /* Kernel used global metadata fields */
-- 
2.46.2



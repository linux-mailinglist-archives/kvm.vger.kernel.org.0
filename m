Return-Path: <kvm+bounces-31443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C94529C3C3E
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 11:43:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 818B41F21256
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:43:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7C319DF62;
	Mon, 11 Nov 2024 10:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q8ssbYll"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519ED17C7BD;
	Mon, 11 Nov 2024 10:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731321629; cv=none; b=LSp7KL9qILJdQKo/2pn/7VEJ3GciS5snm0a7VAtMc3qZLUvwhf0/d3VghyYwOhAznykwTpl7IQZ6fdALjrPTJhyM4qfLHu6RZCjT6HA1UcQQB2yMUdUtEq9fiyjendTitMwMBDQTRLjCwjfSX5ICYbV8Q18B91ygMC0NbOxOyFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731321629; c=relaxed/simple;
	bh=MiDuW3xv90eOoJn+KPKLwF+2gnSv91ApeTBM2COmSK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olqzx9EfuQdgtkqi59NgKn/5+qYESZGGQ7DC0xuhrGr0ePUYVyDLBEoeuE7jXUUul0CuvXpYA5LMsJcCj5I/o/FSciBeQvHZrJ1V1kFvpoKjh7qW43+JwbALCMOjrzE4gAVwN2/+eGduh09khwz9ji/mgfRIwn4pSj8sUxo8IEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q8ssbYll; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731321629; x=1762857629;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MiDuW3xv90eOoJn+KPKLwF+2gnSv91ApeTBM2COmSK8=;
  b=Q8ssbYllPTtEhnvFN3bUP+011iyvkLPPoIN5fR8Fxr0e4ObpWSLtYDmd
   ttNlPPX3s4sFJwSXxNt3AuZEsa8L0iFCip3YTGoMFp/8AkX/2jJiAZ9la
   rJWcXAz0Ts/eLgchvSwHP5onQe8mz9DfMPokxTcb84f8uwI/wU6CJ7Knp
   26cBARHy8hQa+4n4tROPSyeij4TleMfRw5Fmf+5Ym9LCYVaSIS35bwTVA
   LHPswcPoeNRqj0cBjmPDXiZMQek/fuCFiUkyjT5n/j5ZvFu248jXRjsn+
   hjxXb930RSoivNr3IJisFbu1mQzvfYAkyPrS3/aCmuYeNN16pogmixc89
   Q==;
X-CSE-ConnectionGUID: Vp6QI4hwRAqLV7sTsjQapw==
X-CSE-MsgGUID: FOiJ/eTQTOGpwaMgiLDxIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41682674"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41682674"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:29 -0800
X-CSE-ConnectionGUID: 7xQ1lm3HQKWkpE2bHP46NQ==
X-CSE-MsgGUID: wQi3sSrJQhOvMWejb3LA7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="117667242"
Received: from uaeoff-desk2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.207])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:24 -0800
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
Subject: [PATCH v7 04/10] x86/virt/tdx: Use dedicated struct members for PAMT entry sizes
Date: Mon, 11 Nov 2024 23:39:40 +1300
Message-ID: <6ab90fd332bccdec7b64e5909cb4637732d6bb01.1731318868.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1731318868.git.kai.huang@intel.com>
References: <cover.1731318868.git.kai.huang@intel.com>
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
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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



Return-Path: <kvm+bounces-48751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 730BEAD266F
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 21:14:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF61818900BB
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 19:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D3821FF49;
	Mon,  9 Jun 2025 19:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cRcGCzSR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F37121CC4A;
	Mon,  9 Jun 2025 19:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749496436; cv=none; b=ti590ZBRvl9bkykpXWnM2wU931d+9nBfjGxwXJs+ZSLiBXJlUpaE6xl50y7LtkbL5vw/zZ56BlOD6ssqh631qXzcjysSRl6zfFRzbBYphrA/e5Ntxh7qkXHT0rPtW+cAW4Kn8swZQKHI3GRxyTc6WQ33FmC5sGVb/xwW59lBIL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749496436; c=relaxed/simple;
	bh=qfB8VMSGySBtQwc24w5kS+61cOYDH+0r3VJ7G+xrbns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfbx5zM0yYupd/ZDcNnYC/2anckOcDWy+fTTklGvPXltFtex80vvBwebV9zteHhnvkAjem00UOhQM5tGfOYH6Sm0DW+DSNGuhd1igPg1uy6tJGkIN1YLpW9NMIQNjRs9FH3iGgHmZ/IxESWag+rkme5PzYXcAlXXCthIYAcDDUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cRcGCzSR; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749496435; x=1781032435;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qfB8VMSGySBtQwc24w5kS+61cOYDH+0r3VJ7G+xrbns=;
  b=cRcGCzSR163+wR7LZztxFsKYLdB+9mwLIf+p4IRS/KGWAppcYiZ7cLJx
   Uls/gvafrKRJPGIXeRfZkT/WGiSRQ++xmFGYEWFtZXLpPKo9QM6E+0Hfk
   ry/Omr4ljxDTtv1FI8aLmGP0fpu42iXPfQXRPB+BDKclCSJuF8nhdj0mb
   063G4Iufvy8k5XHWHz0yV6DnJRbpqEOrhVm0+vxtshJHImYe/5Tyqgxc1
   Rcp/mtY8yJferThr03IiLvrc6lTIp2sPgzfE1YZA/0JboHpRKNiiwaXeF
   tZ7QXpdQmhop8plWB1XENFvaepmWzSer6C9VaB/009HzOpVCajCfu02OQ
   Q==;
X-CSE-ConnectionGUID: 1qzGlIQWRRim4+Q/Fpx9Sg==
X-CSE-MsgGUID: hj8FW4tHTe+cY/TXquQPRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51681740"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="51681740"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 12:13:54 -0700
X-CSE-ConnectionGUID: B8SZt3eeQKKg6gaHNVT4ag==
X-CSE-MsgGUID: YlEQp6tfSA22ulyBZtOKGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147174157"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa007.jf.intel.com with ESMTP; 09 Jun 2025 12:13:51 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 0F88E290; Mon, 09 Jun 2025 22:13:49 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 02/12] x86/virt/tdx: Allocate page bitmap for Dynamic PAMT
Date: Mon,  9 Jun 2025 22:13:30 +0300
Message-ID: <20250609191340.2051741-3-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Physical Address Metadata Table (PAMT) holds TDX metadata for
physical memory and must be allocated by the kernel during TDX module
initialization.

The exact size of the required PAMT memory is determined by the TDX
module and may vary between TDX module versions, but currently it is
approximately 0.4% of the system memory. This is a significant
commitment, especially if it is not known upfront whether the machine
will run any TDX guests.

The Dynamic PAMT feature reduces static PAMT allocations. PAMT_1G and
PAMT_2M levels are still allocated on TDX module initialization, but the
PAMT_4K level is allocated dynamically, reducing static allocations to
approximately 0.004% of the system memory.

With Dynamic PAMT, the kernel no longer needs to allocate PAMT_4K on
boot, but instead must allocate a page bitmap. The TDX module determines
how many bits per page need to be allocated (currently it is 1).

Allocate the bitmap if the kernel boots on a machine with Dynamic PAMT.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/tdx.h                  |  5 +++++
 arch/x86/include/asm/tdx_global_metadata.h  |  1 +
 arch/x86/virt/vmx/tdx/tdx.c                 | 23 ++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c |  3 +++
 4 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 9649308bd9c0..583d6fe66821 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -106,6 +106,11 @@ int tdx_enable(void);
 const char *tdx_dump_mce_info(struct mce *m);
 const struct tdx_sys_info *tdx_get_sysinfo(void);
 
+static inline bool tdx_supports_dynamic_pamt(const struct tdx_sys_info *sysinfo)
+{
+	return false; /* To be enabled when kernel is ready */
+}
+
 int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
index 060a2ad744bf..5eb808b23997 100644
--- a/arch/x86/include/asm/tdx_global_metadata.h
+++ b/arch/x86/include/asm/tdx_global_metadata.h
@@ -15,6 +15,7 @@ struct tdx_sys_info_tdmr {
 	u16 pamt_4k_entry_size;
 	u16 pamt_2m_entry_size;
 	u16 pamt_1g_entry_size;
+	u8  pamt_page_bitmap_entry_bits;
 };
 
 struct tdx_sys_info_td_ctrl {
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 2457d13c3f9e..18179eb26eb9 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -470,6 +470,18 @@ static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr, int pgsz,
 	return pamt_sz;
 }
 
+static unsigned long tdmr_get_pamt_bitmap_sz(struct tdmr_info *tdmr)
+{
+	unsigned long pamt_sz, nr_pamt_entries;
+	int bits_per_entry;
+
+	bits_per_entry = tdx_sysinfo.tdmr.pamt_page_bitmap_entry_bits;
+	nr_pamt_entries = tdmr->size >> PAGE_SHIFT;
+	pamt_sz = DIV_ROUND_UP(nr_pamt_entries * bits_per_entry, BITS_PER_BYTE);
+
+	return ALIGN(pamt_sz, PAGE_SIZE);
+}
+
 /*
  * Locate a NUMA node which should hold the allocation of the @tdmr
  * PAMT.  This node will have some memory covered by the TDMR.  The
@@ -522,7 +534,16 @@ static int tdmr_set_up_pamt(struct tdmr_info *tdmr,
 	 * and the total PAMT size.
 	 */
 	tdmr_pamt_size = 0;
-	for (pgsz = TDX_PS_4K; pgsz < TDX_PS_NR; pgsz++) {
+	pgsz = TDX_PS_4K;
+
+	/* With Dynamic PAMT, PAMT_4K is replaced with a bitmap */
+	if (tdx_supports_dynamic_pamt(&tdx_sysinfo)) {
+		pamt_size[pgsz] = tdmr_get_pamt_bitmap_sz(tdmr);
+		tdmr_pamt_size += pamt_size[pgsz];
+		pgsz++;
+	}
+
+	for (; pgsz < TDX_PS_NR; pgsz++) {
 		pamt_size[pgsz] = tdmr_get_pamt_sz(tdmr, pgsz,
 					pamt_entry_size[pgsz]);
 		tdmr_pamt_size += pamt_size[pgsz];
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 13ad2663488b..683925bcc9eb 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -33,6 +33,9 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 		sysinfo_tdmr->pamt_2m_entry_size = val;
 	if (!ret && !(ret = read_sys_metadata_field(0x9100000100000012, &val)))
 		sysinfo_tdmr->pamt_1g_entry_size = val;
+	if (!ret && tdx_supports_dynamic_pamt(&tdx_sysinfo) &&
+	    !(ret = read_sys_metadata_field(0x9100000100000013, &val)))
+		sysinfo_tdmr->pamt_page_bitmap_entry_bits = val;
 
 	return ret;
 }
-- 
2.47.2



Return-Path: <kvm+bounces-10629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DEAD86E00E
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 12:21:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E1281C2106A
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6802A6D51F;
	Fri,  1 Mar 2024 11:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RGpNaqUA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9D76D1BD;
	Fri,  1 Mar 2024 11:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709292064; cv=none; b=gXU1UH+aukfFFl1lLfJJ77kHWh4CGzgNQmdQzbNx/THL2p7LXFEsmErxLBRrnUXtd1gMu0R8TthNp2yB5oiVtqq1pZTwE0U/I5a8TpMxGZdSj4QkK85rSYjHeZFrZVwv06lWR5SSz29gwJ0r3zUMwenAk4EJD55V4JZn4x5ARFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709292064; c=relaxed/simple;
	bh=ZH9yB3+bAlFuB6GdzN5jxW35ykjB3p90w+ZXJYVkg3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRzGB//GaoonOoEnN/tYtiqXsQaon/UNYxPFj9Q6LT6JUG/DGU/uut46HwXTNAo+qYBvhoa5h3vJhptXkLMHlB5oCsR64c22594diUVMZDJunIEKsexpYpIG6D3IBaBJtgZPQ6QAV1FtbrQgXY6CSgMz3IPDDgcxIbJJCGgPhv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RGpNaqUA; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709292061; x=1740828061;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZH9yB3+bAlFuB6GdzN5jxW35ykjB3p90w+ZXJYVkg3Y=;
  b=RGpNaqUA2FJOrM+F4mQO0Jt6d/Zi4HXJ8/IJ3FEMHO0Nr2ErjkBzqTe6
   lm7AzBo29TUqdkH4rLI2XO9XQ8UJZ5FqF3HxefToPOEiugP6EZe9Tmvtd
   7bD6tuo9M0DkOUvLvHMNJeevsF4lVNV3/I7XGfWqLUTIK9fUTnukgUTah
   dn22XfifS88cs8HKhZkq04MkQ9wtUGcmRYWVrzO2oQSC4aBcubXimusoc
   71VpSczSwuTwnPi7uhcbvt7YbkieRdOjUpVkwvZKis1ygFQiT+Ikrc+g5
   hHEZRGk/jh2l7sjBpgsQXMzF4rhJU+A34jgwBJPK3wLz39jx4yrRefxie
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="14465047"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="14465047"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 03:21:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="31350684"
Received: from rcaudill-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.48.180])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 03:20:57 -0800
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	isaku.yamahata@intel.com,
	jgross@suse.com,
	kai.huang@intel.com
Subject: [PATCH 2/5] x86/virt/tdx: Move TDMR metadata fields map table to local variable
Date: Sat,  2 Mar 2024 00:20:34 +1300
Message-ID: <41cd371d8a9caadf183e3ab464c57f9f715184d3.1709288433.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1709288433.git.kai.huang@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel reads all TDMR related global metadata fields based on a
table which maps the metadata fields to the corresponding members of
'struct tdx_tdmr_sysinfo'.

Currently this table is a static variable.  But this table is only used
by the function which reads these metadata fields and becomes useless
after reading is done.

Change the table to function local variable.  This also saves the
storage of the table from the kernel image.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 2aee64d2f27f..cdcb3332bc5d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -301,17 +301,16 @@ struct field_mapping {
 	{ .field_id = MD_FIELD_ID_##_field_id,	   \
 	  .offset   = offsetof(struct tdx_tdmr_sysinfo, _member) }
 
-/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
-static const struct field_mapping fields[] = {
-	TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs),
-	TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
-	TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
-	TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
-	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
-};
-
 static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
 {
+	/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
+	const struct field_mapping fields[] = {
+		TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs),
+		TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
+		TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
+		TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
+		TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
+	};
 	int ret;
 	int i;
 
-- 
2.43.2



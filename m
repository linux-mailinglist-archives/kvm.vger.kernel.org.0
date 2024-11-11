Return-Path: <kvm+bounces-31448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 650B09C3C4C
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 11:45:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 973DC1C21679
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 760911A0BC3;
	Mon, 11 Nov 2024 10:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Apw+yThv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C1219AD5C;
	Mon, 11 Nov 2024 10:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731321655; cv=none; b=GOVmZ3ED9hOyQE96fmD0Rpjn6GQaqLrV6WSetpDuE6TGYUz99oUppXwNSFeCPUno8coz9Kqhn+BSBOq7ve4K/x0ffjcvwdgIt+GAFH+aW0priOyy3rJeLiofHB8XUgULJkNcSiwFEz6mb2bEYWf2/IJwMX8hv1kmu/VnOB5izmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731321655; c=relaxed/simple;
	bh=QB6yVNsKPLPtF1p+makyEiGWRa8RHUWYNJibIIfK57c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhHQlQWXS29qQtsov0YPUKb9ZXNV057CL3AIt9YXYWDacralxRNv+vZ04lHNCdjTkyGXl65lzijq5nn7BiMgmEfRxGVKgdDSFfTA5CGFRnMY7T8J8uCR2CcP/4AeK5PriQXqx9AlOJiPmEk8vRW95muP6Y+6AfC4u6FJi57WvD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Apw+yThv; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731321654; x=1762857654;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QB6yVNsKPLPtF1p+makyEiGWRa8RHUWYNJibIIfK57c=;
  b=Apw+yThvKMs2+8cdQmmPL3rLGFtxKHGTGCxWQPGZp3HvzhXDrixGQnFU
   NUolAARXdCSPNxIECQqUlvDzi0hF+M4T0XJPmmyg+AiUiN7DsahqBBTR4
   KOYfQcxcj0nEzlHGHhR0Wqb193kokqeqP7DgsTPTsw74kgZ76I82KUIIE
   CpMfbq3xVWSEJAlMDB3LPLPpfGrA1Wbum991EHlJygPmcX3UIwLyRR7Iy
   fDYbaOi6AWXWFDJiXcLp2Xi4nAqrGo58b1+A6xIvxridO398RoQqxxZlH
   7XBbVt7fOy3tWP1M7Kfn6dFcR1EAmNeymh0ZOdmCUyaZUNK6lKIE9mTfN
   g==;
X-CSE-ConnectionGUID: sKVMxs3VTWyHqiOJgdaeGQ==
X-CSE-MsgGUID: toD/xpV5SvSsSPOxA3/oFQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31281430"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31281430"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:54 -0800
X-CSE-ConnectionGUID: cljPQjXlREKKLKgGNobagw==
X-CSE-MsgGUID: npNIOfjjTMSbhi8iC8mhJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="117667650"
Received: from uaeoff-desk2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.207])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:44 -0800
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
Subject: [PATCH v7 09/10] x86/virt/tdx: Require the module to assert it has the NO_RBP_MOD mitigation
Date: Mon, 11 Nov 2024 23:39:45 +1300
Message-ID: <b4915f31e1d845694f4bae5a3b2a248df2a310a9.1731318868.git.kai.huang@intel.com>
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

Old TDX modules can clobber RBP in the TDH.VP.ENTER SEAMCALL.  However
RBP is used as frame pointer in the x86_64 calling convention, and
clobbering RBP could result in bad things like being unable to unwind
the stack if any non-maskable exceptions (NMI, #MC etc) happens in that
gap.

A new "NO_RBP_MOD" feature was introduced to more recent TDX modules to
not clobber RBP.  This feature is reported in the TDX_FEATURES0 global
metadata field via bit 18.

Don't initialize the TDX module if this feature is not supported [1].

Note the bit definitions of TDX_FEATURES0 are not auto-generated in
tdx_global_metadata.h.  Manually define a macro for it in "tdx.h".

Link: https://lore.kernel.org/fc0e8ab7-86d4-4428-be31-82e1ece6dd21@intel.com/ [1]
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 17 +++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  4 ++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 9acb12c75e9b..9bc827a6cee8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -326,6 +326,18 @@ static int init_tdx_sys_info(struct tdx_sys_info *sysinfo)
 	return 0;
 }
 
+static int check_features(struct tdx_sys_info *sysinfo)
+{
+	u64 tdx_features0 = sysinfo->features.tdx_features0;
+
+	if (!(tdx_features0 & TDX_FEATURES0_NO_RBP_MOD)) {
+		pr_err("frame pointer (RBP) clobber bug present, upgrade TDX module\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* Calculate the actual TDMR size */
 static int tdmr_size_single(u16 max_reserved_per_tdmr)
 {
@@ -1109,6 +1121,11 @@ static int init_tdx_module(void)
 	if (ret)
 		return ret;
 
+	/* Check whether the kernel can support this module */
+	ret = check_features(&sysinfo);
+	if (ret)
+		return ret;
+
 	/*
 	 * To keep things simple, assume that all TDX-protected memory
 	 * will come from the page allocator.  Make sure all pages in the
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 0128b963b723..c8be00f6b15a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/compiler_attributes.h>
 #include <linux/stddef.h>
+#include <linux/bits.h>
 #include "tdx_global_metadata.h"
 
 /*
@@ -54,6 +55,9 @@ struct tdmr_info {
 	DECLARE_FLEX_ARRAY(struct tdmr_reserved_area, reserved_areas);
 } __packed __aligned(TDMR_INFO_ALIGNMENT);
 
+/* Bit definitions of TDX_FEATURES0 metadata field */
+#define TDX_FEATURES0_NO_RBP_MOD	BIT(18)
+
 /*
  * Do not put any hardware-defined TDX structure representations below
  * this comment!
-- 
2.46.2



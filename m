Return-Path: <kvm+bounces-6575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF25D8377E0
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:55:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7825928B02B
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 23:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 403FC4F5F1;
	Mon, 22 Jan 2024 23:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DfwPEh5h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B544EB2E;
	Mon, 22 Jan 2024 23:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967695; cv=none; b=nq0+k7YZFXMmDZTUDKfD0hCF3EfyqrOlsLdc6/F+Fw8rKHqqsEXylBiC928nlFhbWk+MdKT9jvaL+WLnj62k0AhifpBB93U7cq5mE/U5iCjlDNvtopjZU5EQAsp7GEVVBWNGwiAfG3XLYJLlKg3/3o6GBzyYQ0liaNbB1xJBoE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967695; c=relaxed/simple;
	bh=MY4i1eRsMR25nJn5OI9pQXWHMolnb8eFBdBk5/3evCo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AOrIVX8RctngUvRAgu38JMfydBUJuYrtatFwmcjdZyi+QjqRO3dq9LVugIsNoydljrtz3AQST2zl5KHwOw0qjyXQh5MBy/NeQknZrr8FuK+jdsXostIXlPuIH02xcUEWrRmrcMF44kJc9PNccRjaT5sCuwag7uHwd/r5ghExCVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DfwPEh5h; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967694; x=1737503694;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MY4i1eRsMR25nJn5OI9pQXWHMolnb8eFBdBk5/3evCo=;
  b=DfwPEh5hsidFfczzYW40SmiW8UUwZfsNoNWLm+7ztteonc+wCCtnoKoy
   M7QxKIeMDYpzck39L9qgPnOMniSYvTXQlcrGJ2zQflJspAa1e/1dvCDFv
   sBKQuf5n6FDYY6XAcLROysWJmQunZBlFaRP5i3NCavflcq54WbT88UM+L
   qZ8Mox2moAr031uf830dHaKoherGz9bZ33Rdhqt67vOtQ+HL5FLlFMUSB
   4y4diROze/DRLRSxn1TV2LcCLcpGo4NRRE3mxW21NNo/+cgiaDNgSAokF
   /ONRV8HhCW5np819uBIAybBSq80yAwY3OS+5SUzGvQuPj9CuJ/HUhZ4Ss
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1217795"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1217795"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:54:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1350104"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:54:51 -0800
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
	tina.zhang@intel.com
Subject: [PATCH v18 002/121] x86/virt/tdx: Export SEAMCALL functions
Date: Mon, 22 Jan 2024 15:52:38 -0800
Message-Id: <88bcf53760c42dafb14cd9a92bf4f9243f597bbe.1705965634.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kai Huang <kai.huang@intel.com>

KVM will need to make SEAMCALLs to create and run TDX guests.  Export
SEAMCALL functions for KVM to use.

Also add declaration of SEAMCALL functions to <asm/asm-prototypes.h> to
support CONFIG_MODVERSIONS=y.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/asm-prototypes.h | 1 +
 arch/x86/virt/vmx/tdx/seamcall.S      | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/asm-prototypes.h b/arch/x86/include/asm/asm-prototypes.h
index b1a98fa38828..0ec572ad75f1 100644
--- a/arch/x86/include/asm/asm-prototypes.h
+++ b/arch/x86/include/asm/asm-prototypes.h
@@ -13,6 +13,7 @@
 #include <asm/preempt.h>
 #include <asm/asm.h>
 #include <asm/gsseg.h>
+#include <asm/tdx.h>
 
 #ifndef CONFIG_X86_CMPXCHG64
 extern void cmpxchg8b_emu(void);
diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
index 5b1f2286aea9..e32cf82ed47e 100644
--- a/arch/x86/virt/vmx/tdx/seamcall.S
+++ b/arch/x86/virt/vmx/tdx/seamcall.S
@@ -1,5 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/linkage.h>
+#include <linux/export.h>
 #include <asm/frame.h>
 
 #include "tdxcall.S"
@@ -21,6 +22,7 @@
 SYM_FUNC_START(__seamcall)
 	TDX_MODULE_CALL host=1
 SYM_FUNC_END(__seamcall)
+EXPORT_SYMBOL_GPL(__seamcall);
 
 /*
  * __seamcall_ret() - Host-side interface functions to SEAM software
@@ -40,6 +42,7 @@ SYM_FUNC_END(__seamcall)
 SYM_FUNC_START(__seamcall_ret)
 	TDX_MODULE_CALL host=1 ret=1
 SYM_FUNC_END(__seamcall_ret)
+EXPORT_SYMBOL_GPL(__seamcall_ret);
 
 /*
  * __seamcall_saved_ret() - Host-side interface functions to SEAM software
@@ -59,3 +62,4 @@ SYM_FUNC_END(__seamcall_ret)
 SYM_FUNC_START(__seamcall_saved_ret)
 	TDX_MODULE_CALL host=1 ret=1 saved=1
 SYM_FUNC_END(__seamcall_saved_ret)
+EXPORT_SYMBOL_GPL(__seamcall_saved_ret);
-- 
2.25.1



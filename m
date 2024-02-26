Return-Path: <kvm+bounces-9631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 28063866C3D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:30:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD68CB2344E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DAC247F4A;
	Mon, 26 Feb 2024 08:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VwLS2EQl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064DA219FD;
	Mon, 26 Feb 2024 08:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936062; cv=none; b=QFT12y6QG2nHYsGQhNv/fbiwqqSQA/1mR4aq+lXeyjfSVOFE8aAZGIpOlR9YgHWUBukXKA7k1NYqn+Y//A0GiRlhZ5KxuWdFwQKneCvooJq5jvJIU8apStEMHGcvPFEMqglthbtJGPXFjrip6Athm1gHwO9+nkpW/FlsS5acDIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936062; c=relaxed/simple;
	bh=jlfMA54rdGG+IPOKGOPLVKDQtiL3/PSTjptpBZUxEnw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N2DpACiIFUnOrKHlPyLMt2r1o+1vtoi62te3UUrVY7L5kukc0krhHyMBnYAqxVqyx5LIQWNilUkoK42/APWXbyL1/yM61XqZevPtWUwScA4hk7b6MHarnrEgN+TifgttvPjND1rQSu/vy5XqHRLOlC4XRSQ6sq/zcVQFVu4EpV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VwLS2EQl; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936060; x=1740472060;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jlfMA54rdGG+IPOKGOPLVKDQtiL3/PSTjptpBZUxEnw=;
  b=VwLS2EQlknHA1ShFnNsgAuvgmOM3dSUKMujoqfDPG1+ILG+vLryL5QXf
   aOkpbIG3vqUhTpqQwgszKeN7EoE6xGuyS3zZksIEpz4JWQQdu1T/p564I
   ooiqkIcWMs6wYlJ8rW9sQln++97hv34Eps4WB9Ys7afkQKG/VMuTOtrNe
   ssYa3kTCm5ydEyk99ywfAVo36P1I7At8I72tM61ecpoi+MHhEgNkkkmlJ
   RYQs2xRHsiFuiyCyvqaXs0vbYmJbYxx0gemOUrd2TVf4OruT2rIPoY9dQ
   +6TvoaG/WgpyY+pWTncVoI8uteUXc7V+1rS3RJ2U2lEcRon0JgRWZbX2W
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="28631452"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="28631452"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6474307"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:39 -0800
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
Subject: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Date: Mon, 26 Feb 2024 00:25:09 -0800
Message-Id: <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
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
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
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



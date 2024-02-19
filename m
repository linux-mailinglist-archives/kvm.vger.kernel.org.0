Return-Path: <kvm+bounces-9014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2547E859D73
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57DD21C21E10
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA1323769;
	Mon, 19 Feb 2024 07:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nYILxYVy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F8A20DEA;
	Mon, 19 Feb 2024 07:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328867; cv=none; b=L2aM9XUvk8/A9MKk8GQN1h1xOhqm6LOf56rvRP6e0TQuVJYtd9L/LzNdgrWSVE0Nb+JkUXVq+zGPTKT6f9AoXS+i9eiHt3/JcxMXldLXOo27jhY1PegNfmKbEp2P7T+rEOv+lztGxguQ26j5LcheVD1lmygoiqLZjLYjgn5FLrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328867; c=relaxed/simple;
	bh=Qcjmmmende+5tsFshQjIf5GC3RiO8JOjs03Rr6rpZfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRYLwhTEaIwAun1bpxZ6yQCfOROFVhQIt9ux4iu/D8Z5yAVgLPBA3x5sqEwZ2p0WK2KaGcsiIlUrscHGdP71D2R/1g+lFcz7NIuduoPnpOl3XTxUNxQjSQgR7tBaeQZp2Ps4RqQEhnkcSO2ZAkxXVp28tUxYVMrNo45iKZMnvCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nYILxYVy; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328865; x=1739864865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qcjmmmende+5tsFshQjIf5GC3RiO8JOjs03Rr6rpZfY=;
  b=nYILxYVyhhZHgnRO8bR6J+F3oinEOlE3BuQKlWqWnvmVoldB+KxHEbvG
   KOS0sh5rYs3WUC5aGZsxC1kIZ1TCo8gLuRUeE4b4tg2RMHe+z/UHu717T
   TyBGa2F3nxMAeexfr1VtswWeW51POq+/jAfuk3pQVOKrVWsVuEYC1DgMv
   S1flUq4QfMlsJQbIFiFOo3bVnvMa7DrjwybwbUQAE/Sir6+IfhD9nZsPx
   bbcWEt7tNyswIeNMYaAx36U9BI6eT62FbMw1OV+WKN82fqXRC+MV3rRvE
   XSxqj3gdq6KPAprLBQYhGL+cw74/KP/8sBDWpbDgugjCfqkD/gtkP3yuV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535011"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535011"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966063"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966063"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:43 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v10 02/27] x86/fpu/xstate: Refine CET user xstate bit enabling
Date: Sun, 18 Feb 2024 23:47:08 -0800
Message-ID: <20240219074733.122080-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove XFEATURE_CET_USER entry from dependency array as the entry doesn't
reflect true dependency between CET features and the user xstate bit.
Enable the bit in fpu_kernel_cfg.max_features when either SHSTK or IBT is
available.

Both user mode shadow stack and indirect branch tracking features depend
on XFEATURE_CET_USER bit in XSS to automatically save/restore user mode
xstate registers, i.e., IA32_U_CET and IA32_PL3_SSP whenever necessary.

Note, the issue, i.e., CPUID only enumerates IBT but no SHSTK is resulted
from CET KVM series which synthesizes guest CPUIDs based on userspace
settings,in real world the case is rare. In other words, the existing
dependency check is correct when only user mode SHSTK is available.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/fpu/xstate.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 07911532b108..f6b98693da59 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -73,7 +73,6 @@ static unsigned short xsave_cpuid_features[] __initdata = {
 	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
 	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
 	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
-	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
 	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
 	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
 };
@@ -798,6 +797,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
 	}
 
+	/*
+	 * CET user mode xstate bit has been cleared by above sanity check.
+	 * Now pick it up if either SHSTK or IBT is available. Either feature
+	 * depends on the xstate bit to save/restore user mode states.
+	 */
+	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT))
+		fpu_kernel_cfg.max_features |= BIT_ULL(XFEATURE_CET_USER);
+
 	if (!cpu_feature_enabled(X86_FEATURE_XFD))
 		fpu_kernel_cfg.max_features &= ~XFEATURE_MASK_USER_DYNAMIC;
 
-- 
2.43.0



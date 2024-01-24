Return-Path: <kvm+bounces-6752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 994C9839F57
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:43:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11F48B28E94
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92B97E568;
	Wed, 24 Jan 2024 02:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ICedOzYC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0642B6FA5;
	Wed, 24 Jan 2024 02:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706064155; cv=none; b=u+PVAMcIp4CrQb7DKJtqILwfmpX/ymeia2GhPpad8XVdmZmlCpeqVzs90l2MuPtpKuh5EHbQ2DypF3nTyOy76Ku7/4QhWW4zqP2ZWF5+mTMWBhQ/tLxIthaKy/tyERfKJ2nedJbDU39jKl9bNZMilJxgD+3Cylo7Nm1CRXSvzws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706064155; c=relaxed/simple;
	bh=zDQRJW1MEJIyRReHbn6CnswFHThkqwgVHPSva/vwncA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g1C8/ezvzLQcpqMD3rgR/K9WQd3omhQAcs8TCsFO1gfvCm52H4K2nBJz5dr2/YbxMS0v28V9hkfFutgiknX/ACxRoHflYUmK/isV6866MwupshgH2XdW1MUWg2+TdpHNyLGw/XFlgZUQnLdSFVG4IJRPEJ11PRLjJJ2uUCeUWxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ICedOzYC; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706064154; x=1737600154;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zDQRJW1MEJIyRReHbn6CnswFHThkqwgVHPSva/vwncA=;
  b=ICedOzYCNNbC2x+WVQf4N7Da+88kqau+bElRGXhVXSHtGVDd9ydKgFoo
   oCdOXPG8kNlbRu6hcWW8/cq5+lr4jtP3KfY/onDCeTErjLF0k7uT3h+I8
   X/UC2eK8+LcQgvHMcpUTIvj8RQPUN3f+0l371dkToMtuCnDmOME6GSArm
   x2qgcK5qmJJkteLysv5scc/I6DVic3U0dwtmqlEceseH8DfgxBLR8GKWW
   w49QSKkqZer9PD8Chhlg4g1abwxRfw+97d2SWFiT5tWwHpTrLLFIAvONk
   fTCV+YJfsVz4Oqn4kaG3+BaWw5gzXeAg0Iu5VrX9iWWr6KDZK3oM+rH87
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400586430"
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="400586430"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="1825819"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:31 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yuan.yao@linux.intel.com
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v9 03/27] x86/fpu/xstate: Add CET supervisor mode state support
Date: Tue, 23 Jan 2024 18:41:36 -0800
Message-Id: <20240124024200.102792-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240124024200.102792-1-weijiang.yang@intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add supervisor mode state support within FPU xstate management framework.
Although supervisor shadow stack is not enabled/used today in kernel,KVM
requires the support because when KVM advertises shadow stack feature to
guest, architecturally it claims the support for both user and supervisor
modes for guest OSes(Linux or non-Linux).

CET supervisor states not only includes PL{0,1,2}_SSP but also IA32_S_CET
MSR, but the latter is not xsave-managed. In virtualization world, guest
IA32_S_CET is saved/stored into/from VM control structure. With supervisor
xstate support, guest supervisor mode shadow stack state can be properly
saved/restored when 1) guest/host FPU context is swapped 2) vCPU
thread is sched out/in.

The alternative is to enable it in KVM domain, but KVM maintainers NAKed
the solution. The external discussion can be found at [*], it ended up
with adding the support in kernel instead of KVM domain.

Note, in KVM case, guest CET supervisor state i.e., IA32_PL{0,1,2}_MSRs,
are preserved after VM-Exit until host/guest fpstates are swapped, but
since host supervisor shadow stack is disabled, the preserved MSRs won't
hurt host.

[*]: https://lore.kernel.org/all/806e26c2-8d21-9cc9-a0b7-7787dd231729@intel.com/

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/fpu/types.h  | 14 ++++++++++++--
 arch/x86/include/asm/fpu/xstate.h |  6 +++---
 arch/x86/kernel/fpu/xstate.c      |  6 +++++-
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index eb810074f1e7..c6fd13a17205 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -116,7 +116,7 @@ enum xfeature {
 	XFEATURE_PKRU,
 	XFEATURE_PASID,
 	XFEATURE_CET_USER,
-	XFEATURE_CET_KERNEL_UNUSED,
+	XFEATURE_CET_KERNEL,
 	XFEATURE_RSRVD_COMP_13,
 	XFEATURE_RSRVD_COMP_14,
 	XFEATURE_LBR,
@@ -139,7 +139,7 @@ enum xfeature {
 #define XFEATURE_MASK_PKRU		(1 << XFEATURE_PKRU)
 #define XFEATURE_MASK_PASID		(1 << XFEATURE_PASID)
 #define XFEATURE_MASK_CET_USER		(1 << XFEATURE_CET_USER)
-#define XFEATURE_MASK_CET_KERNEL	(1 << XFEATURE_CET_KERNEL_UNUSED)
+#define XFEATURE_MASK_CET_KERNEL	(1 << XFEATURE_CET_KERNEL)
 #define XFEATURE_MASK_LBR		(1 << XFEATURE_LBR)
 #define XFEATURE_MASK_XTILE_CFG		(1 << XFEATURE_XTILE_CFG)
 #define XFEATURE_MASK_XTILE_DATA	(1 << XFEATURE_XTILE_DATA)
@@ -264,6 +264,16 @@ struct cet_user_state {
 	u64 user_ssp;
 };
 
+/*
+ * State component 12 is Control-flow Enforcement supervisor states
+ */
+struct cet_supervisor_state {
+	/* supervisor ssp pointers  */
+	u64 pl0_ssp;
+	u64 pl1_ssp;
+	u64 pl2_ssp;
+};
+
 /*
  * State component 15: Architectural LBR configuration state.
  * The size of Arch LBR state depends on the number of LBRs (lbr_depth).
diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index d4427b88ee12..3b4a038d3c57 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -51,7 +51,8 @@
 
 /* All currently supported supervisor features */
 #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
-					    XFEATURE_MASK_CET_USER)
+					    XFEATURE_MASK_CET_USER | \
+					    XFEATURE_MASK_CET_KERNEL)
 
 /*
  * A supervisor state component may not always contain valuable information,
@@ -78,8 +79,7 @@
  * Unsupported supervisor features. When a supervisor feature in this mask is
  * supported in the future, move it to the supported supervisor feature mask.
  */
-#define XFEATURE_MASK_SUPERVISOR_UNSUPPORTED (XFEATURE_MASK_PT | \
-					      XFEATURE_MASK_CET_KERNEL)
+#define XFEATURE_MASK_SUPERVISOR_UNSUPPORTED (XFEATURE_MASK_PT)
 
 /* All supervisor states including supported and unsupported states. */
 #define XFEATURE_MASK_SUPERVISOR_ALL (XFEATURE_MASK_SUPERVISOR_SUPPORTED | \
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index f6b98693da59..03e166a87d61 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -51,7 +51,7 @@ static const char *xfeature_names[] =
 	"Protection Keys User registers",
 	"PASID state",
 	"Control-flow User registers",
-	"Control-flow Kernel registers (unused)",
+	"Control-flow Kernel registers",
 	"unknown xstate feature",
 	"unknown xstate feature",
 	"unknown xstate feature",
@@ -73,6 +73,7 @@ static unsigned short xsave_cpuid_features[] __initdata = {
 	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
 	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
 	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
+	[XFEATURE_CET_KERNEL]			= X86_FEATURE_SHSTK,
 	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
 	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
 };
@@ -277,6 +278,7 @@ static void __init print_xstate_features(void)
 	print_xstate_feature(XFEATURE_MASK_PKRU);
 	print_xstate_feature(XFEATURE_MASK_PASID);
 	print_xstate_feature(XFEATURE_MASK_CET_USER);
+	print_xstate_feature(XFEATURE_MASK_CET_KERNEL);
 	print_xstate_feature(XFEATURE_MASK_XTILE_CFG);
 	print_xstate_feature(XFEATURE_MASK_XTILE_DATA);
 }
@@ -346,6 +348,7 @@ static __init void os_xrstor_booting(struct xregs_state *xstate)
 	 XFEATURE_MASK_BNDCSR |			\
 	 XFEATURE_MASK_PASID |			\
 	 XFEATURE_MASK_CET_USER |		\
+	 XFEATURE_MASK_CET_KERNEL |		\
 	 XFEATURE_MASK_XTILE)
 
 /*
@@ -546,6 +549,7 @@ static bool __init check_xstate_against_struct(int nr)
 	case XFEATURE_PASID:	  return XCHECK_SZ(sz, nr, struct ia32_pasid_state);
 	case XFEATURE_XTILE_CFG:  return XCHECK_SZ(sz, nr, struct xtile_cfg);
 	case XFEATURE_CET_USER:	  return XCHECK_SZ(sz, nr, struct cet_user_state);
+	case XFEATURE_CET_KERNEL: return XCHECK_SZ(sz, nr, struct cet_supervisor_state);
 	case XFEATURE_XTILE_DATA: check_xtile_data_against_struct(sz); return true;
 	default:
 		XSTATE_WARN_ON(1, "No structure for xstate: %d\n", nr);
-- 
2.39.3



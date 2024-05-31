Return-Path: <kvm+bounces-18511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18A448D5D8A
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:05:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C32B1288DAF
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 09:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D84D15696E;
	Fri, 31 May 2024 09:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jtAhz4LQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8716815665D;
	Fri, 31 May 2024 09:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717146242; cv=none; b=YmSShSvnmciwK+7YBBx8+7p+t4HxuGCN/ZlCUWV0Jf0/Bk1fuIX0NZ1cjXvryLGVZWLj+K8cVTspErCpUiCH491UJICv09tBkTOSbhq+XBd+L6YXhGtQ2vS3E6gpuqZ0PvqpPiSfYU9A5YRRp6NVHL1LbVBOttMqAN1DMfWR2fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717146242; c=relaxed/simple;
	bh=HgGje5OjSiCYYJ7sGjRMBDMbj0piQLEBRn57zq5aDns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhLcIQiyRm2Py42DOW0pUoh7YKwy4fw0E/UV2H3pGb1wIgU0YoWHspEIkRGNjuz2WwnJ9ks8H2wZRcU+jH0EC9JKH32ulq7BKREwNUB+25CbeHpUeXaPjODpqryVxewi037ijrCR/7QidTQmV8nXGUpeXoDj2KdTBWJLXF9kiRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jtAhz4LQ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717146240; x=1748682240;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HgGje5OjSiCYYJ7sGjRMBDMbj0piQLEBRn57zq5aDns=;
  b=jtAhz4LQbTkzoAuLwKaxwfg2YRuSCjBchExZKOHhPiihjqZYMt0yaMGx
   BZ9iQYQrMAFF9uaSFrS3A4ZBHGsuhPE/42JvsU70+eQcV+nDk8x0QfcwF
   6cKgky7T84mhEzLW735llKX+SZOpOSesGavlnW3ll1S/8B9THvf0x+SkW
   6va/RIMXJICCQKO/Q1LnAzblzSXL4GedmlNW/e1Ztc2FUwSlwG4ebp4bW
   /TZOfciYOiYhTjRzIoMd4V5ChRh10BsE85meQ9pIOvJav7d4lO9lu2Mmy
   Xy0ftOtvhncIrnXILKgifH78ZOJc23c+D5ImJww26XjvNFA9BGGVbY56c
   g==;
X-CSE-ConnectionGUID: ktvBhpZ6TPmeORvBEOgwnQ==
X-CSE-MsgGUID: SGiHP/qOTXanl/XdNh9laQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="17480590"
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="17480590"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 02:03:59 -0700
X-CSE-ConnectionGUID: KBH2UrLaSPWV/ysJh/TIcw==
X-CSE-MsgGUID: VWFcxs/GTsea62xQKwey9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="36102742"
Received: from jf.jf.intel.com ([10.165.9.183])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 02:03:59 -0700
From: Yang Weijiang <weijiang.yang@intel.com>
To: tglx@linutronix.de,
	dave.hansen@intel.com,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	weijiang.yang@intel.com,
	john.allen@amd.com
Subject: [PATCH 2/6] x86/fpu/xstate: Add CET supervisor mode state support
Date: Fri, 31 May 2024 02:03:27 -0700
Message-ID: <20240531090331.13713-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240531090331.13713-1-weijiang.yang@intel.com>
References: <20240531090331.13713-1-weijiang.yang@intel.com>
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
index eb17f31b06d2..d633cf833411 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -118,7 +118,7 @@ enum xfeature {
 	XFEATURE_PKRU,
 	XFEATURE_PASID,
 	XFEATURE_CET_USER,
-	XFEATURE_CET_KERNEL_UNUSED,
+	XFEATURE_CET_KERNEL,
 	XFEATURE_RSRVD_COMP_13,
 	XFEATURE_RSRVD_COMP_14,
 	XFEATURE_LBR,
@@ -141,7 +141,7 @@ enum xfeature {
 #define XFEATURE_MASK_PKRU		(1 << XFEATURE_PKRU)
 #define XFEATURE_MASK_PASID		(1 << XFEATURE_PASID)
 #define XFEATURE_MASK_CET_USER		(1 << XFEATURE_CET_USER)
-#define XFEATURE_MASK_CET_KERNEL	(1 << XFEATURE_CET_KERNEL_UNUSED)
+#define XFEATURE_MASK_CET_KERNEL	(1 << XFEATURE_CET_KERNEL)
 #define XFEATURE_MASK_LBR		(1 << XFEATURE_LBR)
 #define XFEATURE_MASK_XTILE_CFG		(1 << XFEATURE_XTILE_CFG)
 #define XFEATURE_MASK_XTILE_DATA	(1 << XFEATURE_XTILE_DATA)
@@ -266,6 +266,16 @@ struct cet_user_state {
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
index bc66183c7df2..84d4fcaeff35 100644
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
@@ -74,6 +74,7 @@ static unsigned short xsave_cpuid_features[] __initdata = {
 	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
 	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
 	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
+	[XFEATURE_CET_KERNEL]			= X86_FEATURE_SHSTK,
 	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
 	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
 };
@@ -279,6 +280,7 @@ static void __init print_xstate_features(void)
 	print_xstate_feature(XFEATURE_MASK_PKRU);
 	print_xstate_feature(XFEATURE_MASK_PASID);
 	print_xstate_feature(XFEATURE_MASK_CET_USER);
+	print_xstate_feature(XFEATURE_MASK_CET_KERNEL);
 	print_xstate_feature(XFEATURE_MASK_XTILE_CFG);
 	print_xstate_feature(XFEATURE_MASK_XTILE_DATA);
 }
@@ -348,6 +350,7 @@ static __init void os_xrstor_booting(struct xregs_state *xstate)
 	 XFEATURE_MASK_BNDCSR |			\
 	 XFEATURE_MASK_PASID |			\
 	 XFEATURE_MASK_CET_USER |		\
+	 XFEATURE_MASK_CET_KERNEL |		\
 	 XFEATURE_MASK_XTILE)
 
 /*
@@ -548,6 +551,7 @@ static bool __init check_xstate_against_struct(int nr)
 	case XFEATURE_PASID:	  return XCHECK_SZ(sz, nr, struct ia32_pasid_state);
 	case XFEATURE_XTILE_CFG:  return XCHECK_SZ(sz, nr, struct xtile_cfg);
 	case XFEATURE_CET_USER:	  return XCHECK_SZ(sz, nr, struct cet_user_state);
+	case XFEATURE_CET_KERNEL: return XCHECK_SZ(sz, nr, struct cet_supervisor_state);
 	case XFEATURE_XTILE_DATA: check_xtile_data_against_struct(sz); return true;
 	default:
 		XSTATE_WARN_ON(1, "No structure for xstate: %d\n", nr);
-- 
2.43.0



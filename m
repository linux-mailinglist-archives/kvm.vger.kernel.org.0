Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5066579FBEA
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 08:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjING2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 02:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235209AbjING2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 02:28:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05ECF9;
        Wed, 13 Sep 2023 23:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694672923; x=1726208923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DH/kwoW6eRQtxK0yZo8tCx3soKPTztRafZKZYlHzFUA=;
  b=ROBswMT5MVWv75ejWPyQbkYLKmI2tk7mZCRDyFBU3TFj56ikcijFfAT3
   1nuq8rVMNeg0GUSz+ttBXM2RjSBc80UsSF/vPOS7FaalHaClr1xP366x9
   fkjZ0dZgVUQMrsBX+4Ef04XJSboF26QZhTmeufe7H8QOQ7H7p1eCz9ji7
   Z86u1LKHPDLBL3gUzRJ5qLr84NthyOq+m6WHW5DnU2G++DfNAewIwQfoE
   t4LGDhvGpvFduBAvpsXtJwLrMZ8gM/e9+L4XeB10LgXnHvJf32s6EYuGj
   uejWui7f2sxiTXxN99dwUPW5DeZ9FgDyM7tZ6YmbkaHwPstd3kpKTUCr+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382672449"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382672449"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 23:28:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="809937984"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="809937984"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 23:28:42 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, peterz@infradead.org,
        seanjc@google.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com,
        kvm@vger.kernel.org, yang.zhong@intel.com, jing2.liu@intel.com,
        chao.gao@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH 3/8] x86/fpu/xstate: Add CET supervisor mode state support
Date:   Wed, 13 Sep 2023 23:23:29 -0400
Message-Id: <20230914032334.75212-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914032334.75212-1-weijiang.yang@intel.com>
References: <20230914032334.75212-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add supervisor mode state support within FPU xstate management framework.
Although supervisor shadow stack is not enabled/used today in kernel,KVM
requires the support because when KVM advertises shadow stack feature to
guest, architechturally it claims the support for both user and supervisor
modes for Linux and non-Linux guest OSes.

With the xstate support, guest supervisor mode shadow stack state can be
properly saved/restored when 1) guest/host FPU context is swapped 2) vCPU
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
index 12c8cb278346..c3ed86732d33 100644
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
2.27.0


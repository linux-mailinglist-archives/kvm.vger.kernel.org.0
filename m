Return-Path: <kvm+bounces-45579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F34BAABFCD
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 11:38:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B698C3A41D6
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B868E2701A3;
	Tue,  6 May 2025 09:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HJ50CXWu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E34262FFE;
	Tue,  6 May 2025 09:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746524029; cv=none; b=KQtXtS3T/Ta/g3jwQmOcflQ0554FgI7xkv/+fmBdm7B3sZ6Rhcd1Qmm6i1qhyc7++GCR171kFPnpdyK9cs+NhkDVg5/Lfsc+Kr7TQUGtJXKabrlWN1RYqXsiXBc3OYKxWuEyn12Yrsj3F2Z3G1ScsrIqm+fNqxeEwqTkapnaZVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746524029; c=relaxed/simple;
	bh=SlxEBFvzTBZ9T/ujcuKgXBKVk73IYIx38GKTZR1Hk7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XN16oq2DAlxTvlvek8eerXEQZNKc+snMO9fj30OI3Xa0Yap2I4THOd27+uBAf8haymB8anfqOciqQ5ED/Z7Zls03gFIPH8WfN96cMYa11hOCNlsZpLauK77+2ja4J6AW2aXqGSUN7v77Te2osvW2C3TLx5eAcBRsP1Np/Iz6ENU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HJ50CXWu; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746524028; x=1778060028;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SlxEBFvzTBZ9T/ujcuKgXBKVk73IYIx38GKTZR1Hk7g=;
  b=HJ50CXWusxv6eKDjaW5RkhU6yRT+/CvUKoa8fK6VMf/EZXh4C5R2bC+L
   b9dkz0+LnYwHdzTf+kpmAppzkNahMphvnLhpvjY7xN2TqS3LVFDoLFJ30
   XaJXYsOMEzm77DxzBcPhO7kUjX62R7pVxOBeHCKhINzfXiaGtH0pDJj33
   qFIAgPd3Vp8j6DWXBfltoP+P23SIcVCm8kY9J00pClHL4/7GY/gZFlE9L
   GdTfSt+qym5PrTy1iWadP9xhZH2hY85VXJaPIDAx0LTKWs5OKu44mGsNU
   Ng+sLZABhQVCs09783qvi8yRUFG0Z2/HpCj3h/vIu1hnW4tzwo2zBm5nz
   A==;
X-CSE-ConnectionGUID: 0MqzaWiRRYCQfkJh8fp5Kg==
X-CSE-MsgGUID: Qy0zunfDSOy+cWUZFJW3Yw==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="35800497"
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="35800497"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 02:33:47 -0700
X-CSE-ConnectionGUID: 3inYr3/0SP+CLhdbKUDP4w==
X-CSE-MsgGUID: jJRWB7ZcQ3y2Qs5DbiKE6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="135446996"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 02:33:41 -0700
From: Chao Gao <chao.gao@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de,
	chang.seok.bae@intel.com,
	xin3.li@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>
Subject: [PATCH v6 7/7] x86/fpu/xstate: Add CET supervisor xfeature support as a guest-only feature
Date: Tue,  6 May 2025 17:36:12 +0800
Message-ID: <20250506093740.2864458-8-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250506093740.2864458-1-chao.gao@intel.com>
References: <20250506093740.2864458-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

== Background ==

CET defines two register states: CET user, which includes user-mode control
registers, and CET supervisor, which consists of shadow-stack pointers for
privilege levels 0-2.

Current kernels disable shadow stacks in kernel mode, making the CET
supervisor state unused and eliminating the need for context switching.

== Problem ==

To virtualize CET for guests, KVM must accurately emulate hardware
behavior. A key challenge arises because there is no CPUID flag to indicate
that shadow stack is supported only in user mode. Therefore, KVM cannot
assume guests will not enable shadow stacks in kernel mode and must
preserve the CET supervisor state of vCPUs.

== Solution ==

An initial proposal to manually save and restore CET supervisor states
using raw RDMSR/WRMSR in KVM was rejected due to performance concerns and
its impact on KVM's ABI. Instead, leveraging the kernel's FPU
infrastructure for context switching was favored [1].

The main question then became whether to enable the CET supervisor state
globally for all processes or restrict it to vCPU processes. This decision
involves a trade-off between a 24-byte XSTATE buffer waste for all non-vCPU
processes and approximately 100 lines of code complexity in the kernel [2].
The agreed approach is to first try this optimal solution [3], i.e.,
restricting the CET supervisor state to guest FPUs only and eliminating
unnecessary space waste.

The guest-only xfeature infrastructure has already been added. Now,
introduce CET supervisor xstate support as the first guest-only feature
to prepare for the upcoming CET virtualization in KVM.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/kvm/ZM1jV3UPL0AMpVDI@google.com/ [1]
Link: https://lore.kernel.org/kvm/1c2fd06e-2e97-4724-80ab-8695aa4334e7@intel.com/ [2]
Link: https://lore.kernel.org/kvm/2597a87b-1248-b8ce-ce60-94074bc67ea4@intel.com/ [3]
---
v5:
Introduce CET supervisor xfeature directly as a guest-only feature, rather
than first introducing it in one patch and then converting it to guest-only
in a subsequent patch. (Chang)
Add new features after cleanups/bug fixes (Chang, Dave, Ingo)
Improve the commit message to follow the suggested
background-problem-solution pattern.
---
 arch/x86/include/asm/fpu/types.h  | 14 ++++++++++++--
 arch/x86/include/asm/fpu/xstate.h |  5 ++---
 arch/x86/kernel/fpu/xstate.c      |  5 ++++-
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 54ba567258d6..93e99d2583d6 100644
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
@@ -142,7 +142,7 @@ enum xfeature {
 #define XFEATURE_MASK_PKRU		(1 << XFEATURE_PKRU)
 #define XFEATURE_MASK_PASID		(1 << XFEATURE_PASID)
 #define XFEATURE_MASK_CET_USER		(1 << XFEATURE_CET_USER)
-#define XFEATURE_MASK_CET_KERNEL	(1 << XFEATURE_CET_KERNEL_UNUSED)
+#define XFEATURE_MASK_CET_KERNEL	(1 << XFEATURE_CET_KERNEL)
 #define XFEATURE_MASK_LBR		(1 << XFEATURE_LBR)
 #define XFEATURE_MASK_XTILE_CFG		(1 << XFEATURE_XTILE_CFG)
 #define XFEATURE_MASK_XTILE_DATA	(1 << XFEATURE_XTILE_DATA)
@@ -268,6 +268,16 @@ struct cet_user_state {
 	u64 user_ssp;
 };
 
+/*
+ * State component 12 is Control-flow Enforcement supervisor states.
+ * This state includes SSP pointers for privilege levels 0 through 2.
+ */
+struct cet_supervisor_state {
+	u64 pl0_ssp;
+	u64 pl1_ssp;
+	u64 pl2_ssp;
+} __packed;
+
 /*
  * State component 15: Architectural LBR configuration state.
  * The size of Arch LBR state depends on the number of LBRs (lbr_depth).
diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index a3cd25453f94..7a7dc9d56027 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -47,7 +47,7 @@
 #define XFEATURE_MASK_USER_DYNAMIC	XFEATURE_MASK_XTILE_DATA
 
 /* Supervisor features which are enabled only in guest FPUs */
-#define XFEATURE_MASK_GUEST_SUPERVISOR	0
+#define XFEATURE_MASK_GUEST_SUPERVISOR	XFEATURE_MASK_CET_KERNEL
 
 /* All currently supported supervisor features */
 #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
@@ -79,8 +79,7 @@
  * Unsupported supervisor features. When a supervisor feature in this mask is
  * supported in the future, move it to the supported supervisor feature mask.
  */
-#define XFEATURE_MASK_SUPERVISOR_UNSUPPORTED (XFEATURE_MASK_PT | \
-					      XFEATURE_MASK_CET_KERNEL)
+#define XFEATURE_MASK_SUPERVISOR_UNSUPPORTED (XFEATURE_MASK_PT)
 
 /* All supervisor states including supported and unsupported states. */
 #define XFEATURE_MASK_SUPERVISOR_ALL (XFEATURE_MASK_SUPERVISOR_SUPPORTED | \
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index e77cbfd18094..549cc8929407 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -56,7 +56,7 @@ static const char *xfeature_names[] =
 	"Protection Keys User registers",
 	"PASID state",
 	"Control-flow User registers",
-	"Control-flow Kernel registers (unused)",
+	"Control-flow Kernel registers (KVM only)",
 	"unknown xstate feature",
 	"unknown xstate feature",
 	"unknown xstate feature",
@@ -80,6 +80,7 @@ static unsigned short xsave_cpuid_features[] __initdata = {
 	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
 	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
 	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
+	[XFEATURE_CET_KERNEL]			= X86_FEATURE_SHSTK,
 	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
 	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
 	[XFEATURE_APX]				= X86_FEATURE_APX,
@@ -371,6 +372,7 @@ static __init void os_xrstor_booting(struct xregs_state *xstate)
 	 XFEATURE_MASK_BNDCSR |			\
 	 XFEATURE_MASK_PASID |			\
 	 XFEATURE_MASK_CET_USER |		\
+	 XFEATURE_MASK_CET_KERNEL |		\
 	 XFEATURE_MASK_XTILE |			\
 	 XFEATURE_MASK_APX)
 
@@ -572,6 +574,7 @@ static bool __init check_xstate_against_struct(int nr)
 	case XFEATURE_PASID:	  return XCHECK_SZ(sz, nr, struct ia32_pasid_state);
 	case XFEATURE_XTILE_CFG:  return XCHECK_SZ(sz, nr, struct xtile_cfg);
 	case XFEATURE_CET_USER:	  return XCHECK_SZ(sz, nr, struct cet_user_state);
+	case XFEATURE_CET_KERNEL: return XCHECK_SZ(sz, nr, struct cet_supervisor_state);
 	case XFEATURE_APX:        return XCHECK_SZ(sz, nr, struct apx_state);
 	case XFEATURE_XTILE_DATA: check_xtile_data_against_struct(sz); return true;
 	default:
-- 
2.47.1



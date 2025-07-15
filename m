Return-Path: <kvm+bounces-52464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50F70B0563A
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:23:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DA634E56A2
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8F912D878C;
	Tue, 15 Jul 2025 09:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gxvT+8Ka"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C2A2D63F7;
	Tue, 15 Jul 2025 09:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752571303; cv=none; b=OTOBZQktcAtnzx7tQZsVycnTjOp3txk9rNgK8h94ZIDC/q2tFbgPYLE/2+10vi/I1F0Y+I1/ETqe9VqJFFKyibEq+NeqBeThcP3C8XcfTMTNaKO2Z9aM5ciFly0MNS2YEv0Hwv46DhMDJWpUXyFK4lraKRy2oMMPBta9Qrhwmmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752571303; c=relaxed/simple;
	bh=pGVqlGqCP/o6RjK9s7ShTdEMqkimt6Dd+lPwwZHbtKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqJvzi2VTbyIzRmNCJCgoxjk60KsfFoVJDweRqqw7lztWS+bwZFlmYP5SJvF6GaVoF018pCT23ztC6aA9Effz95vEJ+o3vaggZ+fZyzXslXw7rzTz0NTeXA2SxvDb8Kdt9ULVg6VaVEQwzXfJfGGgu9XFRVTTblIPdIFP4JPkIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gxvT+8Ka; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752571301; x=1784107301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pGVqlGqCP/o6RjK9s7ShTdEMqkimt6Dd+lPwwZHbtKQ=;
  b=gxvT+8KaLcaGOZmC4z1SuNwSwc3JJAZKI96Hs+WWaY+L5p7H3C6vxZqn
   NGfv/Sn7UJdlPV3Yp9WCwvAz+9pGOHf7ndZBj/CXoxtWSFAmUUPR5tSQ9
   n1k9b5uy8Tt5sFYVY6v8MP7i8J4oJLEwCGSEkAoAXiklZKTcuhkgdMNBd
   yHGKd/LDccc+FRvSdJmEx5c1jSAXjTK3+NvQAYB+eY8XyEI5HSpiCngFb
   0zPzps4KUkXRq7X0ydKdwLau0fq1ERzipUW7G29wQ7Gs52f62X0grHGMH
   NXLHanzqDg14o1j45nK8nrqHe/SiAXc6ZQIw4RZJaLhTxBCHroTQaTvnl
   A==;
X-CSE-ConnectionGUID: YHWcrHUbRN63UpAyl9/AUQ==
X-CSE-MsgGUID: 98fw8hxiQQiJ7UP4+NKlpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54003377"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="54003377"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 02:21:41 -0700
X-CSE-ConnectionGUID: X/u3Zql4Rw6fRG5VAw2FBw==
X-CSE-MsgGUID: tjXHMJCuQny68BqE2yF8yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="188183716"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa001.fm.intel.com with ESMTP; 15 Jul 2025 02:21:36 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: "Kirill A. Shutemov" <kas@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	yan.y.zhao@intel.com,
	reinette.chatre@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com,
	xiaoyao.li@intel.com
Subject: [PATCH v3 3/4] x86/tdx: Rename TDX_ATTR_* to TDX_TD_ATTR_*
Date: Tue, 15 Jul 2025 17:13:11 +0800
Message-ID: <20250715091312.563773-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250715091312.563773-1-xiaoyao.li@intel.com>
References: <20250715091312.563773-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The macros TDX_ATTR_* and DEF_TDX_ATTR_* are related to TD attributes,
which are TD-scope attributes. Naming them as TDX_ATTR_* can be somewhat
confusing and might mislead people into thinking they are TDX global
things.

Rename TDX_ATTR_* to TDX_TD_ATTR_* to explicitly clarify they are
TD-scope things.

Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/coco/tdx/debug.c         | 26 ++++++++--------
 arch/x86/coco/tdx/tdx.c           |  8 ++---
 arch/x86/include/asm/shared/tdx.h | 50 +++++++++++++++----------------
 arch/x86/kvm/vmx/tdx.c            |  4 +--
 4 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/arch/x86/coco/tdx/debug.c b/arch/x86/coco/tdx/debug.c
index 28990c2ab0a1..8e477db4ce0a 100644
--- a/arch/x86/coco/tdx/debug.c
+++ b/arch/x86/coco/tdx/debug.c
@@ -7,21 +7,21 @@
 #include <linux/printk.h>
 #include <asm/tdx.h>
 
-#define DEF_TDX_ATTR_NAME(_name) [TDX_ATTR_##_name##_BIT] = __stringify(_name)
+#define DEF_TDX_TD_ATTR_NAME(_name) [TDX_TD_ATTR_##_name##_BIT] = __stringify(_name)
 
 static __initdata const char *tdx_attributes[] = {
-	DEF_TDX_ATTR_NAME(DEBUG),
-	DEF_TDX_ATTR_NAME(HGS_PLUS_PROF),
-	DEF_TDX_ATTR_NAME(PERF_PROF),
-	DEF_TDX_ATTR_NAME(PMT_PROF),
-	DEF_TDX_ATTR_NAME(ICSSD),
-	DEF_TDX_ATTR_NAME(LASS),
-	DEF_TDX_ATTR_NAME(SEPT_VE_DISABLE),
-	DEF_TDX_ATTR_NAME(MIGRATABLE),
-	DEF_TDX_ATTR_NAME(PKS),
-	DEF_TDX_ATTR_NAME(KL),
-	DEF_TDX_ATTR_NAME(TPA),
-	DEF_TDX_ATTR_NAME(PERFMON),
+	DEF_TDX_TD_ATTR_NAME(DEBUG),
+	DEF_TDX_TD_ATTR_NAME(HGS_PLUS_PROF),
+	DEF_TDX_TD_ATTR_NAME(PERF_PROF),
+	DEF_TDX_TD_ATTR_NAME(PMT_PROF),
+	DEF_TDX_TD_ATTR_NAME(ICSSD),
+	DEF_TDX_TD_ATTR_NAME(LASS),
+	DEF_TDX_TD_ATTR_NAME(SEPT_VE_DISABLE),
+	DEF_TDX_TD_ATTR_NAME(MIGRATABLE),
+	DEF_TDX_TD_ATTR_NAME(PKS),
+	DEF_TDX_TD_ATTR_NAME(KL),
+	DEF_TDX_TD_ATTR_NAME(TPA),
+	DEF_TDX_TD_ATTR_NAME(PERFMON),
 };
 
 #define DEF_TD_CTLS_NAME(_name) [TD_CTLS_##_name##_BIT] = __stringify(_name)
diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 7b2833705d47..186915a17c50 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -238,14 +238,14 @@ static void __noreturn tdx_panic(const char *msg)
  *
  * TDX 1.0 does not allow the guest to disable SEPT #VE on its own. The VMM
  * controls if the guest will receive such #VE with TD attribute
- * TDX_ATTR_SEPT_VE_DISABLE.
+ * TDX_TD_ATTR_SEPT_VE_DISABLE.
  *
  * Newer TDX modules allow the guest to control if it wants to receive SEPT
  * violation #VEs.
  *
  * Check if the feature is available and disable SEPT #VE if possible.
  *
- * If the TD is allowed to disable/enable SEPT #VEs, the TDX_ATTR_SEPT_VE_DISABLE
+ * If the TD is allowed to disable/enable SEPT #VEs, the TDX_TD_ATTR_SEPT_VE_DISABLE
  * attribute is no longer reliable. It reflects the initial state of the
  * control for the TD, but it will not be updated if someone (e.g. bootloader)
  * changes it before the kernel starts. Kernel must check TDCS_TD_CTLS bit to
@@ -254,14 +254,14 @@ static void __noreturn tdx_panic(const char *msg)
 static void disable_sept_ve(u64 td_attr)
 {
 	const char *msg = "TD misconfiguration: SEPT #VE has to be disabled";
-	bool debug = td_attr & TDX_ATTR_DEBUG;
+	bool debug = td_attr & TDX_TD_ATTR_DEBUG;
 	u64 config, controls;
 
 	/* Is this TD allowed to disable SEPT #VE */
 	tdg_vm_rd(TDCS_CONFIG_FLAGS, &config);
 	if (!(config & TDCS_CONFIG_FLEXIBLE_PENDING_VE)) {
 		/* No SEPT #VE controls for the guest: check the attribute */
-		if (td_attr & TDX_ATTR_SEPT_VE_DISABLE)
+		if (td_attr & TDX_TD_ATTR_SEPT_VE_DISABLE)
 			return;
 
 		/* Relax SEPT_VE_DISABLE check for debug TD for backtraces */
diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index 11f3cf30b1ac..049638e3da74 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -20,31 +20,31 @@
 #define TDG_VM_RD			7
 #define TDG_VM_WR			8
 
-/* TDX attributes */
-#define TDX_ATTR_DEBUG_BIT		0
-#define TDX_ATTR_DEBUG			BIT_ULL(TDX_ATTR_DEBUG_BIT)
-#define TDX_ATTR_HGS_PLUS_PROF_BIT	4
-#define TDX_ATTR_HGS_PLUS_PROF		BIT_ULL(TDX_ATTR_HGS_PLUS_PROF_BIT)
-#define TDX_ATTR_PERF_PROF_BIT		5
-#define TDX_ATTR_PERF_PROF		BIT_ULL(TDX_ATTR_PERF_PROF_BIT)
-#define TDX_ATTR_PMT_PROF_BIT		6
-#define TDX_ATTR_PMT_PROF		BIT_ULL(TDX_ATTR_PMT_PROF_BIT)
-#define TDX_ATTR_ICSSD_BIT		16
-#define TDX_ATTR_ICSSD			BIT_ULL(TDX_ATTR_ICSSD_BIT)
-#define TDX_ATTR_LASS_BIT		27
-#define TDX_ATTR_LASS			BIT_ULL(TDX_ATTR_LASS_BIT)
-#define TDX_ATTR_SEPT_VE_DISABLE_BIT	28
-#define TDX_ATTR_SEPT_VE_DISABLE	BIT_ULL(TDX_ATTR_SEPT_VE_DISABLE_BIT)
-#define TDX_ATTR_MIGRATABLE_BIT		29
-#define TDX_ATTR_MIGRATABLE		BIT_ULL(TDX_ATTR_MIGRATABLE_BIT)
-#define TDX_ATTR_PKS_BIT		30
-#define TDX_ATTR_PKS			BIT_ULL(TDX_ATTR_PKS_BIT)
-#define TDX_ATTR_KL_BIT			31
-#define TDX_ATTR_KL			BIT_ULL(TDX_ATTR_KL_BIT)
-#define TDX_ATTR_TPA_BIT		62
-#define TDX_ATTR_TPA			BIT_ULL(TDX_ATTR_TPA_BIT)
-#define TDX_ATTR_PERFMON_BIT		63
-#define TDX_ATTR_PERFMON		BIT_ULL(TDX_ATTR_PERFMON_BIT)
+/* TDX TD attributes */
+#define TDX_TD_ATTR_DEBUG_BIT		0
+#define TDX_TD_ATTR_DEBUG		BIT_ULL(TDX_TD_ATTR_DEBUG_BIT)
+#define TDX_TD_ATTR_HGS_PLUS_PROF_BIT	4
+#define TDX_TD_ATTR_HGS_PLUS_PROF	BIT_ULL(TDX_TD_ATTR_HGS_PLUS_PROF_BIT)
+#define TDX_TD_ATTR_PERF_PROF_BIT	5
+#define TDX_TD_ATTR_PERF_PROF		BIT_ULL(TDX_TD_ATTR_PERF_PROF_BIT)
+#define TDX_TD_ATTR_PMT_PROF_BIT	6
+#define TDX_TD_ATTR_PMT_PROF		BIT_ULL(TDX_TD_ATTR_PMT_PROF_BIT)
+#define TDX_TD_ATTR_ICSSD_BIT		16
+#define TDX_TD_ATTR_ICSSD		BIT_ULL(TDX_TD_ATTR_ICSSD_BIT)
+#define TDX_TD_ATTR_LASS_BIT		27
+#define TDX_TD_ATTR_LASS		BIT_ULL(TDX_TD_ATTR_LASS_BIT)
+#define TDX_TD_ATTR_SEPT_VE_DISABLE_BIT	28
+#define TDX_TD_ATTR_SEPT_VE_DISABLE	BIT_ULL(TDX_TD_ATTR_SEPT_VE_DISABLE_BIT)
+#define TDX_TD_ATTR_MIGRATABLE_BIT	29
+#define TDX_TD_ATTR_MIGRATABLE		BIT_ULL(TDX_TD_ATTR_MIGRATABLE_BIT)
+#define TDX_TD_ATTR_PKS_BIT		30
+#define TDX_TD_ATTR_PKS			BIT_ULL(TDX_TD_ATTR_PKS_BIT)
+#define TDX_TD_ATTR_KL_BIT		31
+#define TDX_TD_ATTR_KL			BIT_ULL(TDX_TD_ATTR_KL_BIT)
+#define TDX_TD_ATTR_TPA_BIT		62
+#define TDX_TD_ATTR_TPA			BIT_ULL(TDX_TD_ATTR_TPA_BIT)
+#define TDX_TD_ATTR_PERFMON_BIT		63
+#define TDX_TD_ATTR_PERFMON		BIT_ULL(TDX_TD_ATTR_PERFMON_BIT)
 
 /* TDX TD-Scope Metadata. To be used by TDG.VM.WR and TDG.VM.RD */
 #define TDCS_CONFIG_FLAGS		0x1110000300000016
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index efb7d589b672..c539c2e6109f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -62,7 +62,7 @@ void tdh_vp_wr_failed(struct vcpu_tdx *tdx, char *uclass, char *op, u32 field,
 	pr_err("TDH_VP_WR[%s.0x%x]%s0x%llx failed: 0x%llx\n", uclass, field, op, val, err);
 }
 
-#define KVM_SUPPORTED_TD_ATTRS (TDX_ATTR_SEPT_VE_DISABLE)
+#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
 
 static __always_inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm)
 {
@@ -700,7 +700,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.l1_tsc_scaling_ratio = kvm_tdx->tsc_multiplier;
 
 	vcpu->arch.guest_state_protected =
-		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_ATTR_DEBUG);
+		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTR_DEBUG);
 
 	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
 		vcpu->arch.xfd_no_write_intercept = true;
-- 
2.43.0



Return-Path: <kvm+bounces-72496-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oGoVNTBTpmkbOAAAu9opvQ
	(envelope-from <kvm+bounces-72496-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 04:19:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D2B031E86E5
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 04:19:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6CEBC301BF80
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 03:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3932C382293;
	Tue,  3 Mar 2026 03:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WRbtTr/g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A727537DEA1;
	Tue,  3 Mar 2026 03:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772507817; cv=none; b=KXkpUxeqqFvPmqtoa5fLlkYDKl4A2ce9ltiJGlnumPYWsYjPh16XlviKI8+3ID+mQ09JF2aP3wHqle1dbVZZxRBj3Pc4sZt4Utz8JHuOOMNJPH0vgqZfTewfeSOCzZTPN8J7gueIkxpEYZbtM0wNuFm4IIqqPSqSQZvWjj14Z4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772507817; c=relaxed/simple;
	bh=gOcQDg6tr6jYCIuV+GW76b897cYlMBwjBDsNGPU73lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+Y2U9fJDQXMlpwRH1t4gPYmOD7Su5DU9SmhvAdHfbuvPs6ZC4/KnkT10vaVKIsfJrBHljp5XNJpjc/Z1DtmRCvAjaOSJtCF6di+ttRFiFeKLj9hojcY3KMdNJ9TroGA1KN4EUv8fejHM3rsm6P57nnTWa+/ZDekAD4m7ratjFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WRbtTr/g; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772507813; x=1804043813;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gOcQDg6tr6jYCIuV+GW76b897cYlMBwjBDsNGPU73lA=;
  b=WRbtTr/guMJCM47prcW/i0lgMnYJt/wHAIxjIK3kyGaF6pyZEqXh0U1f
   zT/8pldrMMDZrB1mQtkZi/UIdPaewuI71S3vOnCsQyrw4ZVFMgRQaeg1Y
   0GXr/9Btp2jz3GU6bTH6RXslTQOC6FSw/MEXn9YKwfKS/orHGk1RejLMQ
   JZEvL63BGYBNhVpcQZSjSLWTWFtxewQbvzTLm17eVzSYpxgxc8JrYMaNV
   hQ6JIxCi0n5Z33GIfIADTn6FriUYnLJrFhu6PHK8nCTargYs7lemCWmZS
   Kw6SPTMj+5OVYAoJQbM5lVsRWoFohJP6DzzENR/xyJA1cwb/q0sH2nRBi
   w==;
X-CSE-ConnectionGUID: 2Jrl+SnMTk6b/lBeZpcIzw==
X-CSE-MsgGUID: CZM5YeNkQY6m57kHS3sP0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="83869742"
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="83869742"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 19:16:53 -0800
X-CSE-ConnectionGUID: eS2Py3QqQDucv00fcLcS6A==
X-CSE-MsgGUID: 1nGTwpu5T9GkjJgeoFpxUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="216988919"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.22])
  by orviesa006.jf.intel.com with ESMTP; 02 Mar 2026 19:16:50 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
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
	Tony Lindgren <tony.lindgren@linux.intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v4 3/4] x86/tdx: Rename TDX_ATTR_* to TDX_TD_ATTR_*
Date: Tue,  3 Mar 2026 11:03:34 +0800
Message-ID: <20260303030335.766779-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260303030335.766779-1-xiaoyao.li@intel.com>
References: <20260303030335.766779-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D2B031E86E5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72496-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xiaoyao.li@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

The macros TDX_ATTR_* and DEF_TDX_ATTR_* are related to TD attributes,
which are TD-scope attributes. Naming them as TDX_ATTR_* can be somewhat
confusing and might mislead people into thinking they are TDX global
things.

Rename TDX_ATTR_* to TDX_TD_ATTR_* to explicitly clarify they are
TD-scope things.

Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Sean Christopherson <seanjc@google.com>
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
index f38e492fb3d5..c5065f84b78b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -75,7 +75,7 @@ void tdh_vp_wr_failed(struct vcpu_tdx *tdx, char *uclass, char *op, u32 field,
 	pr_err("TDH_VP_WR[%s.0x%x]%s0x%llx failed: 0x%llx\n", uclass, field, op, val, err);
 }
 
-#define KVM_SUPPORTED_TD_ATTRS (TDX_ATTR_SEPT_VE_DISABLE)
+#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
 
 static __always_inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm)
 {
@@ -707,7 +707,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.l1_tsc_scaling_ratio = kvm_tdx->tsc_multiplier;
 
 	vcpu->arch.guest_state_protected =
-		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_ATTR_DEBUG);
+		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTR_DEBUG);
 
 	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
 		vcpu->arch.xfd_no_write_intercept = true;
-- 
2.43.0



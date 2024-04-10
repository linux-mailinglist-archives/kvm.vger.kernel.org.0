Return-Path: <kvm+bounces-14126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7BC689F9FB
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 16:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB3E41C22B02
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 14:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A81B16D9D5;
	Wed, 10 Apr 2024 14:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nKgJZoyn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3642916D9B0;
	Wed, 10 Apr 2024 14:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712759736; cv=none; b=FSdbimWxCPOQFSij3AmWTWHPkILIz019TBQppuU2xJjMzQaf9G8Q/MmrJJgMFHgUIowlOz1E5rL/VHA0g6iOEsSO4L3hYQQUAw2pWXeQeElbj0TmduQOHOYy1hlHfBXVJARnm6ZZeujOIAZ56oclelRuLn2oaB8K6HJUynWLN8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712759736; c=relaxed/simple;
	bh=UjozbkaecHOIw9YUjZqS9NVQ0WA1ndVs75lx+QT9fiA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u6pvoWDENZci6vg17l0BG0Uu0N3GBU5YO1y5MfkMwciF/JsBRTmKcZbgIOn4uBlRbQx8ag7A9D5Y7fZ+mlQi6PN2T251UMATjsWwFRsw+iA8Z9h0HwZ0hlTriUGf3h1JO/8gyFBEVZmrXoT591Nu7C19jPUedXpJbj8wGDKBrdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nKgJZoyn; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712759735; x=1744295735;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UjozbkaecHOIw9YUjZqS9NVQ0WA1ndVs75lx+QT9fiA=;
  b=nKgJZoyn7Ieo5jvMUFK1qIMr5ZkhIAJv2U+FMvXAPrFCS1fXpUPJBqM3
   J4tnkuRP2yRZPIaqP7UZS+4Oqd5gj1yDc1egyPiRAJZUo60eEg/2R8pf3
   wJFv/IvYYcJCVXFo1ts1RDp83JCideDpc3JiP1xnr31URhanbKTJ10cl0
   DwLjkIXC8L5yeOeIPgYiPaMJVNHyhN+FgviDlnuW67lrWX9NRVfLvvPST
   PqzAT1jcNOXrh8L82R6mJu+FgR8RQx4VplWbmdFo8PaWD74Cx6LGNtW7Y
   XNQZZrIQAFsXHuzumXYchg8AKEpFhzWuitsCyAKyPNbAQvIDIcFKR4yDv
   A==;
X-CSE-ConnectionGUID: bK1/RL2oS72TQut2TC5UtA==
X-CSE-MsgGUID: RRI639NzQ9qYtirqoc+0iA==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="18837780"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="18837780"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:34 -0700
X-CSE-ConnectionGUID: zMGqbJm9SeGQFFRyv3CNTg==
X-CSE-MsgGUID: SX3zAcUlRJ22di1Mwz4BkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="25095500"
Received: from unknown (HELO spr.sh.intel.com) ([10.239.53.118])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:28 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: daniel.sneddon@linux.intel.com,
	pawan.kumar.gupta@linux.intel.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Jithu Joseph <jithu.joseph@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Adam Dunlap <acdunlap@google.com>,
	Arjan van de Ven <arjan@linux.intel.com>
Subject: [RFC PATCH v3 04/10] x86/bugs: Use Virtual MSRs to request BHI_DIS_S
Date: Wed, 10 Apr 2024 22:34:32 +0800
Message-Id: <20240410143446.797262-5-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20240410143446.797262-1-chao.gao@intel.com>
References: <20240410143446.797262-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Mitigation for BHI is to use hardware control BHI_DIS_S or the software
sequence. On platforms that support BHI_DIS_S, a software sequence may
be ineffective to mitigate BHI. Guests that are not aware of BHI_DIS_S
on host, and deploy the ineffective software sequence clear_bhb_loop(),
may become vulnerable to BHI.

To overcome this problem Intel has defined a virtual MSR interface
through which guests can report their mitigation status and request VMM
to deploy relevant hardware mitigations.

Use this virtual MSR interface to tell VMM that the guest is using a
short software sequence. Based on this information a VMM can deploy
BHI_DIS_S for the guest using virtual SPEC_CTRL.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/include/asm/msr-index.h | 18 ++++++++++++++++++
 arch/x86/kernel/cpu/bugs.c       | 26 ++++++++++++++++++++++++++
 arch/x86/kernel/cpu/common.c     |  1 +
 arch/x86/kernel/cpu/cpu.h        |  1 +
 4 files changed, 46 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index e72c2b872957..18a4081bf5cb 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -196,6 +196,7 @@
 						 * IA32_XAPIC_DISABLE_STATUS MSR
 						 * supported
 						 */
+#define ARCH_CAP_VIRTUAL_ENUM		BIT_ULL(63) /* MSR_VIRTUAL_ENUMERATION supported */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
@@ -1178,6 +1179,23 @@
 #define MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS (1ULL << 29)
 #define MSR_IA32_VMX_MISC_PREEMPTION_TIMER_SCALE   0x1F
 
+/* Intel virtual MSRs */
+#define MSR_VIRTUAL_ENUMERATION			0x50000000
+#define VIRT_ENUM_MITIGATION_CTRL_SUPPORT	BIT(0)	/*
+							 * Mitigation ctrl via virtual
+							 * MSRs supported
+							 */
+
+#define MSR_VIRTUAL_MITIGATION_ENUM		0x50000001
+#define MITI_ENUM_BHB_CLEAR_SEQ_S_SUPPORT	BIT(0)	/* VMM supports BHI_DIS_S */
+
+#define MSR_VIRTUAL_MITIGATION_CTRL		0x50000002
+#define MITI_CTRL_BHB_CLEAR_SEQ_S_USED_BIT	0	/*
+							 * Request VMM to deploy
+							 * BHI_DIS_S mitigation
+							 */
+#define MITI_CTRL_BHB_CLEAR_SEQ_S_USED		BIT(MITI_CTRL_BHB_CLEAR_SEQ_S_USED_BIT)
+
 /* AMD-V MSRs */
 #define MSR_VM_CR                       0xc0010114
 #define MSR_VM_IGNNE                    0xc0010115
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 295463707e68..e74e4c51d387 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -50,6 +50,8 @@ static void __init l1d_flush_select_mitigation(void);
 static void __init srso_select_mitigation(void);
 static void __init gds_select_mitigation(void);
 
+void virt_mitigation_ctrl_init(void);
+
 /* The base value of the SPEC_CTRL MSR without task-specific bits set */
 u64 x86_spec_ctrl_base;
 EXPORT_SYMBOL_GPL(x86_spec_ctrl_base);
@@ -171,6 +173,8 @@ void __init cpu_select_mitigations(void)
 	 */
 	srso_select_mitigation();
 	gds_select_mitigation();
+
+	virt_mitigation_ctrl_init();
 }
 
 /*
@@ -1680,6 +1684,28 @@ static void __init bhi_select_mitigation(void)
 	pr_info("Spectre BHI mitigation: SW BHB clearing on syscall\n");
 }
 
+void virt_mitigation_ctrl_init(void)
+{
+	u64 msr_virt_enum, msr_mitigation_enum;
+
+	if (!(x86_read_arch_cap_msr() & ARCH_CAP_VIRTUAL_ENUM))
+		return;
+
+	rdmsrl(MSR_VIRTUAL_ENUMERATION, msr_virt_enum);
+	if (!(msr_virt_enum & VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
+		return;
+
+	rdmsrl(MSR_VIRTUAL_MITIGATION_ENUM, msr_mitigation_enum);
+
+	if (msr_mitigation_enum & MITI_ENUM_BHB_CLEAR_SEQ_S_SUPPORT) {
+		/* When BHI short seq is being used, request BHI_DIS_S */
+		if (boot_cpu_has(X86_FEATURE_CLEAR_BHB_LOOP))
+			msr_set_bit(MSR_VIRTUAL_MITIGATION_CTRL, MITI_CTRL_BHB_CLEAR_SEQ_S_USED_BIT);
+		else
+			msr_clear_bit(MSR_VIRTUAL_MITIGATION_CTRL, MITI_CTRL_BHB_CLEAR_SEQ_S_USED_BIT);
+	}
+}
+
 static void __init spectre_v2_select_mitigation(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 754d91857d63..29f16655a7a0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1960,6 +1960,7 @@ void identify_secondary_cpu(struct cpuinfo_x86 *c)
 		update_gds_msr();
 
 	tsx_ap_init();
+	virt_mitigation_ctrl_init();
 }
 
 void print_cpu_info(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index ea9e07d57c8d..1cddf506b6ae 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -87,6 +87,7 @@ void cpu_select_mitigations(void);
 extern void x86_spec_ctrl_setup_ap(void);
 extern void update_srbds_msr(void);
 extern void update_gds_msr(void);
+extern void virt_mitigation_ctrl_init(void);
 
 extern enum spectre_v2_mitigation spectre_v2_enabled;
 
-- 
2.39.3



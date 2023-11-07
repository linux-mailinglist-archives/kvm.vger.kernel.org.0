Return-Path: <kvm+bounces-1024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2539E7E42E2
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:10:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B9D81B24D31
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25833AC39;
	Tue,  7 Nov 2023 15:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PLuvWTpi"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B92315BB
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:05:20 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441FA210A;
	Tue,  7 Nov 2023 07:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369255; x=1730905255;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bGcR5JIP8U4Y/wZxznPJUFcxeja4IPH8raMWmzND7FA=;
  b=PLuvWTpiL5bWonmuX0C+e7WJOhCiLZCqBLa7qvOFDE4CCJEN18TYH9Su
   WgfWC7BM1/O9sTIBrdPXRTI5D26tqYy0rivRNRG6oVaKmzLZJ7953DgVj
   ladDE0HCvi+vlsFCjO0imgP/vriabtuaPXEV+mBtNVPe5azhpFmQV8YEt
   qtEgt5L+02rsdhStttvHKAIZOEFe6JmRq5VticPNCLe587VWpmXLOVzT4
   zWlXqDy0n5BZBjyrTEUSnvCx4/bXMGW84SIynDuNy7wnD6bD8/bmafElH
   5KiS/NEvH+OOc8Av2R2Fdl4PDAToRUYAr6/Ygd7e86liPBqBvHAFwlynv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462446"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462446"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851465"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:18 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v17 067/116] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Date: Tue,  7 Nov 2023 06:56:33 -0800
Message-Id: <d6cf62e22e97330c94aedb1e4df1d6528eeb7a42.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

TDX module resets the TSX_CTRL MSR to 0 at TD exit if TSX is enabled for
TD. Or it preserves the TSX_CTRL MSR if TSX is disabled for TD.  VMM can
rely on uret_msrs mechanism to defer the reload of host value until exiting
to user space.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 33 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.h |  8 ++++++++
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index fbc3a1920f79..3ee65df99421 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -521,14 +521,21 @@ static struct tdx_uret_msr tdx_uret_msrs[] = {
 	{.msr = MSR_LSTAR,},
 	{.msr = MSR_TSC_AUX,},
 };
+static unsigned int tdx_uret_tsx_ctrl_slot;
 
-static void tdx_user_return_update_cache(void)
+static void tdx_user_return_update_cache(struct kvm_vcpu *vcpu)
 {
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
 		kvm_user_return_update_cache(tdx_uret_msrs[i].slot,
 					     tdx_uret_msrs[i].defval);
+	/*
+	 * TSX_CTRL is reset to 0 if guest TSX is supported. Otherwise
+	 * preserved.
+	 */
+	if (to_kvm_tdx(vcpu->kvm)->tsx_supported && tdx_uret_tsx_ctrl_slot != -1)
+		kvm_user_return_update_cache(tdx_uret_tsx_ctrl_slot, 0);
 }
 
 static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
@@ -623,7 +630,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_vcpu_enter_exit(tdx);
 
-	tdx_user_return_update_cache();
+	tdx_user_return_update_cache(vcpu);
 	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
@@ -1149,6 +1156,22 @@ static int setup_tdparams_xfam(struct kvm_cpuid2 *cpuid, struct td_params *td_pa
 	return 0;
 }
 
+static bool tdparams_tsx_supported(struct kvm_cpuid2 *cpuid)
+{
+	const struct kvm_cpuid_entry2 *entry;
+	u64 mask;
+	u32 ebx;
+
+	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x7, 0);
+	if (entry)
+		ebx = entry->ebx;
+	else
+		ebx = 0;
+
+	mask = __feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM);
+	return ebx & mask;
+}
+
 static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 			struct kvm_tdx_init_vm *init_vm)
 {
@@ -1194,6 +1217,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
 	MEMCPY_SAME_SIZE(td_params->mrownerconfig, init_vm->mrownerconfig);
 
+	to_kvm_tdx(kvm)->tsx_supported = tdparams_tsx_supported(cpuid);
 	return 0;
 }
 
@@ -1857,6 +1881,11 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 			return -EIO;
 		}
 	}
+	tdx_uret_tsx_ctrl_slot = kvm_find_user_return_msr(MSR_IA32_TSX_CTRL);
+	if (tdx_uret_tsx_ctrl_slot == -1 && boot_cpu_has(X86_FEATURE_MSR_TSX_CTRL)) {
+		pr_err("MSR_IA32_TSX_CTRL isn't included by kvm_find_user_return_msr\n");
+		return -EIO;
+	}
 
 	max_pkgs = topology_max_packages();
 	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 610bd3f4e952..45f5c2744d78 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -17,6 +17,14 @@ struct kvm_tdx {
 	u64 xfam;
 	int hkid;
 
+	/*
+	 * Used on each TD-exit, see tdx_user_return_update_cache().
+	 * TSX_CTRL value on TD exit
+	 * - set 0     if guest TSX enabled
+	 * - preserved if guest TSX disabled
+	 */
+	bool tsx_supported;
+
 	hpa_t source_pa;
 
 	bool finalized;
-- 
2.25.1



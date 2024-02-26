Return-Path: <kvm+bounces-9708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 67809866D3C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:55:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07118B22542
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B141F944;
	Mon, 26 Feb 2024 08:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nu6Bu72i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A2E73F1F;
	Mon, 26 Feb 2024 08:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936123; cv=none; b=Id1x6DYdYajyXn2F/FI/BmCfZpeRKQQrFeH8BwdXQp+kkJjyRf25GSrtl+/5CsOUkDTPHzxcKs1YqETgim5LiHcogtWVV8/P5acgkglxy1XNQY49FJCtUfxDbyAkUQmL64zXsmotgI5TgE5YusX9SrTPoCB4htWyKbDxZgyi5+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936123; c=relaxed/simple;
	bh=QAWpp4LjklCnK07uK2feZ4n6OzER6GSYaRkObJrBCqk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q9PdOcmIH5YL5VofnwfxHT7j/AE8bUyh7Xe9Taujj7ON8TgkDmVw2lu0KvKNOWFr50H4suW8hPhGSWgKQVwzvuNO/tM/D1+v5IawPoeXkI4Zjxa5uNPi6HpQkKLq+IwPukYnA3wRoEAeZtlcbs6L2XR7GBDEPQfn6zDgVX549B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nu6Bu72i; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936121; x=1740472121;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QAWpp4LjklCnK07uK2feZ4n6OzER6GSYaRkObJrBCqk=;
  b=nu6Bu72iExAw+Ha37v+ax1J+digzGAae9PZfXnRdBGF4Tcu9dyKUZReS
   CywflQCdhHZWzva/P4rBGQ+dwDAUqr60LfVsfbR5rbDAdvnwFAgII0U87
   v2b8IRSJuKN0lhk46ZZ9BoeUAumb9tPc4JtQvrHIvQsdr8AXffkwwV3WC
   IbGBkD/bnf+2uUDlKRg0oJ0jYy8ydEC4nCCPotW8GC+qBZx3evBO0140X
   Kxfhtmg99LWud5+zlTVgZFcmbmERS9/aTJ/T/cuNEAULXNr5j9Y2gPALZ
   pW/q//GklbTDS4Cx3cefWnPIKOgTMZDhQrrUGAxya07dzq7ODV/5v2/pP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069521"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069521"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272563"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:40 -0800
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
	tina.zhang@intel.com,
	Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v19 083/130] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Date: Mon, 26 Feb 2024 00:26:25 -0800
Message-Id: <06135e0897ae90c3dc7fd608948f8bdcd30a17ae.1708933498.git.isaku.yamahata@intel.com>
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

From: Yang Weijiang <weijiang.yang@intel.com>

TDX module resets the TSX_CTRL MSR to 0 at TD exit if TSX is enabled for
TD. Or it preserves the TSX_CTRL MSR if TSX is disabled for TD.  VMM can
rely on uret_msrs mechanism to defer the reload of host value until exiting
to user space.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v19:
- fix the type of tdx_uret_tsx_ctrl_slot. unguent int => int.
---
 arch/x86/kvm/vmx/tdx.c | 33 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.h |  8 ++++++++
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7e2b1e554246..83dcaf5b6fbd 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -547,14 +547,21 @@ static struct tdx_uret_msr tdx_uret_msrs[] = {
 	{.msr = MSR_LSTAR,},
 	{.msr = MSR_TSC_AUX,},
 };
+static int tdx_uret_tsx_ctrl_slot;
 
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
@@ -649,7 +656,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_vcpu_enter_exit(tdx);
 
-	tdx_user_return_update_cache();
+	tdx_user_return_update_cache(vcpu);
 	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
@@ -1167,6 +1174,22 @@ static int setup_tdparams_xfam(struct kvm_cpuid2 *cpuid, struct td_params *td_pa
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
@@ -1209,6 +1232,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
 	MEMCPY_SAME_SIZE(td_params->mrownerconfig, init_vm->mrownerconfig);
 
+	to_kvm_tdx(kvm)->tsx_supported = tdparams_tsx_supported(cpuid);
 	return 0;
 }
 
@@ -2014,6 +2038,11 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
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
index e96c416e73bf..44eab734e702 100644
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
 	bool finalized;
 	atomic_t tdh_mem_track;
 
-- 
2.25.1



Return-Path: <kvm+bounces-6627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2D358377F3
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:02:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1850E1C24BB1
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1735360EFD;
	Mon, 22 Jan 2024 23:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F4fSyKQH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801C760BA9;
	Mon, 22 Jan 2024 23:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967744; cv=none; b=dAzQwlKjfUMFNs/JCchtnbszSip7obss/qTkDLJHCYvpHk7g5KMl7GaNrxZnckMDKt9sj4goeYsi8v1E/bIgTk6omTvsIBIFdcht06FZFDnd3hxcKoUf2Y9I2VNBvjYLgvisKy4482rTbR8mqe5GzZBakuxSmAM9qc+RHx1ocTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967744; c=relaxed/simple;
	bh=1VZQl1YLJ54Ip20Xb7FfAwpVe2EpZMdqrkixqQ8wBD0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TszZ7lLI3IkoXx5Pbkc1qtuugiUTEGK7gtbtMARwTk9l0++4+eJTEbzE9OCjcWHSkZjCtZpT78NQL+FRYGgbbQdN4GsU1O/fUlBORM6B5ksajEkKZX/a9H+f7bRgxhyVrgfYkRtZaKsRLXQb6Dy9y6iSYyCJ7gfdgAwAecePYjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F4fSyKQH; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967742; x=1737503742;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1VZQl1YLJ54Ip20Xb7FfAwpVe2EpZMdqrkixqQ8wBD0=;
  b=F4fSyKQHo8HVVJsgCX0bKh6Y7YZkbHPF4ZGaPNVrENz+fMZ0hGnRul4r
   05bi+O4Zxf6pGOoZ8xlBMpIgeeWxhWrswrc0QeZlUyDtu/F0V6B1JLZA/
   8KegycXi0+R+zbeJASMfQILEdq1EI51yOutURGsRpB/tEsPA9HoErVBRt
   XkUO5PSitVCE+O36+oWTymareDlNEBud7mtOjtd0uIuLtVVZzlN2Z0LPi
   AUbrBGSuXDm4Qr/OWqXB5bl+FXzC9+GlmR1TGG+MZHrfkZnBRvW6nY//+
   E4BewOx8HICKi/geadSi9sWMEFyITAcpoLHGLBVp1CuyFfY1lGvQeBAbh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217744"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217744"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27817893"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:40 -0800
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
Subject: [PATCH v18 072/121] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Date: Mon, 22 Jan 2024 15:53:48 -0800
Message-Id: <ca819af632d5c7ea2905c4a1d07303139eaef4ea.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
index 4685ff6aa5f8..71c6fc10e8c4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -597,14 +597,21 @@ static struct tdx_uret_msr tdx_uret_msrs[] = {
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
@@ -699,7 +706,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_vcpu_enter_exit(tdx);
 
-	tdx_user_return_update_cache();
+	tdx_user_return_update_cache(vcpu);
 	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
@@ -1212,6 +1219,22 @@ static int setup_tdparams_xfam(struct kvm_cpuid2 *cpuid, struct td_params *td_pa
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
@@ -1253,6 +1276,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
 	MEMCPY_SAME_SIZE(td_params->mrownerconfig, init_vm->mrownerconfig);
 
+	to_kvm_tdx(kvm)->tsx_supported = tdparams_tsx_supported(cpuid);
 	return 0;
 }
 
@@ -1978,6 +2002,11 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
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
index 2d3119c60a14..883eb05d207f 100644
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



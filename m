Return-Path: <kvm+bounces-32322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C67AB9D53D3
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 21:17:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D5D97B2408D
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A7251D5157;
	Thu, 21 Nov 2024 20:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XNp8tE+r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBF91DE3BB;
	Thu, 21 Nov 2024 20:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732220150; cv=none; b=pZcgI4tTU7MJOu1gtUCabSVbtGZg4cOVxgrI1fZDxMay7cs7GTsuwhvOJLqRr/QXsVLkv6wNAuPAop1cuPkKb7wCssmI0Rt2VPqcvpdPdGM/FHrg6FcEVOzRVpYQ0CwfVasEvr5ky4hSHOUsntztCNvuQPtE9W2oIH8pNb4uRo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732220150; c=relaxed/simple;
	bh=RZvbXVGdZqP+GZ6zZdt9zxr03hnLUhvkUiPH4UxJI6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EErH0QpWUlCyLK6wK9bfyuirBRGUqF+KBqLdDX+ClJ/D7Wj9S7gU56TjYqGeMp/pmQtGAMEWwlcdrewad+KH8uWE3agAZwTgHyk26T0tlM1H45TU4Jk/6RRGA7uJu2Bs5VU9vhlk2V/eDH6S71SlElqlRfY1f7eAlo6SBBtLRc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XNp8tE+r; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732220149; x=1763756149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RZvbXVGdZqP+GZ6zZdt9zxr03hnLUhvkUiPH4UxJI6k=;
  b=XNp8tE+rZqUZyNEr6MSj8WbOPSTm9hfiZyivQKIZBBxduMubLsEQbvRl
   xr+9zmzQyI1ejfXTCenPiiWcM3lWVhuoHBuVBfCndN3yAS0zFZpX1+mRi
   pzRIqMsabceIU3aTmcaPl1VBepZd+r8zsYHS1zUVMHTJkZLOGk/KiGWN4
   SGa+VHVZwNvWzY/V5RsjJ8i0hciRN1wQ1zpi/Bt523y3KaxYhJKKzD1g0
   yUwD57ug2L8ovXf2Eft16jM6cUcMR+b76KsN/VQOozfp9EQFhM+8Yl59E
   GsIlGkX+l1jt1wTu39Slg7KRt7fHDEkPKrNrFDZ+w4BvscRIt22eKiFo8
   g==;
X-CSE-ConnectionGUID: osg1SZ3TTlCHLITWj2nVWg==
X-CSE-MsgGUID: 5ljI2RHkSKaXfd9Py2uNkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="31715944"
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="31715944"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 12:15:48 -0800
X-CSE-ConnectionGUID: +2hgsIzEQ8+EVK0QHd+4ig==
X-CSE-MsgGUID: 4iFgIhKgTkKq6pJi44ogwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="90161127"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.16.81])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 12:15:42 -0800
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Date: Thu, 21 Nov 2024 22:14:46 +0200
Message-ID: <20241121201448.36170-8-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241121201448.36170-1-adrian.hunter@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

TDX module resets the TSX_CTRL MSR to 0 at TD exit if TSX is enabled for
TD. Or it preserves the TSX_CTRL MSR if TSX is disabled for TD.  VMM can
rely on uret_msrs mechanism to defer the reload of host value until exiting
to user space.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
TD vcpu enter/exit v1:
 - Update from rename in earlier patches (Binbin)

v19:
- fix the type of tdx_uret_tsx_ctrl_slot. unguent int => int.
---
 arch/x86/kvm/vmx/tdx.c | 33 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.h |  8 ++++++++
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4a33ca54c8ba..2c7b6308da73 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -722,14 +722,21 @@ static struct tdx_uret_msr tdx_uret_msrs[] = {
 	{.msr = MSR_LSTAR,},
 	{.msr = MSR_TSC_AUX,},
 };
+static int tdx_uret_tsx_ctrl_slot;
 
-static void tdx_user_return_msr_update_cache(void)
+static void tdx_user_return_msr_update_cache(struct kvm_vcpu *vcpu)
 {
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
 		kvm_user_return_msr_update_cache(tdx_uret_msrs[i].slot,
 						 tdx_uret_msrs[i].defval);
+	/*
+	 * TSX_CTRL is reset to 0 if guest TSX is supported. Otherwise
+	 * preserved.
+	 */
+	if (to_kvm_tdx(vcpu->kvm)->tsx_supported && tdx_uret_tsx_ctrl_slot != -1)
+		kvm_user_return_msr_update_cache(tdx_uret_tsx_ctrl_slot, 0);
 }
 
 static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
@@ -817,7 +824,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 
 	tdx_vcpu_enter_exit(vcpu);
 
-	tdx_user_return_msr_update_cache();
+	tdx_user_return_msr_update_cache(vcpu);
 	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
@@ -1258,6 +1265,22 @@ static int setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
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
@@ -1299,6 +1322,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
 	MEMCPY_SAME_SIZE(td_params->mrownerconfig, init_vm->mrownerconfig);
 
+	to_kvm_tdx(kvm)->tsx_supported = tdparams_tsx_supported(cpuid);
 	return 0;
 }
 
@@ -2272,6 +2296,11 @@ static int __init __tdx_bringup(void)
 			return -EIO;
 		}
 	}
+	tdx_uret_tsx_ctrl_slot = kvm_find_user_return_msr(MSR_IA32_TSX_CTRL);
+	if (tdx_uret_tsx_ctrl_slot == -1 && boot_cpu_has(X86_FEATURE_MSR_TSX_CTRL)) {
+		pr_err("MSR_IA32_TSX_CTRL isn't included by kvm_find_user_return_msr\n");
+		return -EIO;
+	}
 
 	/*
 	 * Enabling TDX requires enabling hardware virtualization first,
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 48cf0a1abfcc..815ff6bdbc7e 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -29,6 +29,14 @@ struct kvm_tdx {
 	u8 nr_tdcs_pages;
 	u8 nr_vcpu_tdcx_pages;
 
+	/*
+	 * Used on each TD-exit, see tdx_user_return_msr_update_cache().
+	 * TSX_CTRL value on TD exit
+	 * - set 0     if guest TSX enabled
+	 * - preserved if guest TSX disabled
+	 */
+	bool tsx_supported;
+
 	u64 tsc_offset;
 
 	enum kvm_tdx_state state;
-- 
2.43.0



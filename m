Return-Path: <kvm+bounces-9709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4527C866D40
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:56:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E957128142F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F00E079938;
	Mon, 26 Feb 2024 08:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FCvGvELX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E831F77A0E;
	Mon, 26 Feb 2024 08:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936124; cv=none; b=naC9StShK8ALOm/UTQQEpS0Ue/wN7bssa3BCunW3Rt7ANPhBg/5QUrTEJiDNNv+uxp4NeAF249uegQ5AnG9PYkfiA0ZaeBXf3Upv0NOVqiOERCUhcHMyXkdqZx8uUiXPoQbbtqEYMz2qau1Uhj5dq6J4i6sYjjSTpJZ0OK+WiiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936124; c=relaxed/simple;
	bh=d16HpBuwInS8Tw2Ei/8iq4CZW3uueOnKvGugn8F5q+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tX6c46R/69xmEjBZjUGLz7uA83ZUwh15d4TfQ6+EzKpMc9s2tOP9Zjt1PMD8xvx774gETj2YCCefAdRH73XM/l2QwZOxTtlWlcJeCCXOJsF5+pEQi76Eys1kXpnKsGTcYjDdwxwm3wq4JALAOUz/QqUcY1/pZ5cfR1uGmaV0Vmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FCvGvELX; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936123; x=1740472123;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d16HpBuwInS8Tw2Ei/8iq4CZW3uueOnKvGugn8F5q+Q=;
  b=FCvGvELXmKt3QrxVDZt7OmY9LRVIVwB6avar2149XGqho1QiTDqi+LvN
   XXFUcyQyGBVBcu/P3Hezj+QVbIjJpSgSdUT0u63/OPq/r7nFAxES9hLZb
   07JKcDgt6ChoP/zf9d+t8ef7O/hBuzwyCUXcXaih3l5gsxw8WbYX4BDtn
   x1AAdl1okVA1rRjIffdDNSNs01LMMqWawAqdoIqLMI/CmMWLCEYjImDdG
   q2JjEp4otB6SP4JdxdsqlEa3f+VonJqhZg4qfwYYdYbyALaKSFceoxg1U
   jtGEzbEqAE7y+RBq3jVyf2UvRLlMcf5v3VtrZ3FBHxFZLYD9G2Yuqs/Nk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069529"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069529"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272581"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:42 -0800
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
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH v19 085/130] KVM: TDX: Complete interrupts after tdexit
Date: Mon, 26 Feb 2024 00:26:27 -0800
Message-Id: <aa6a927214a5d29d5591a0079f4374b05a82a03f.1708933498.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

This corresponds to VMX __vmx_complete_interrupts().  Because TDX
virtualize vAPIC, KVM only needs to care NMI injection.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
v19:
- move tdvps_management_check() to this patch
- typo: complete -> Complete in short log
---
 arch/x86/kvm/vmx/tdx.c | 10 ++++++++++
 arch/x86/kvm/vmx/tdx.h |  4 ++++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 83dcaf5b6fbd..b8b168f74dfe 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -535,6 +535,14 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 */
 }
 
+static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
+{
+	/* Avoid costly SEAMCALL if no nmi was injected */
+	if (vcpu->arch.nmi_injected)
+		vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
+							      TD_VCPU_PEND_NMI);
+}
+
 struct tdx_uret_msr {
 	u32 msr;
 	unsigned int slot;
@@ -663,6 +671,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
+	tdx_complete_interrupts(vcpu);
+
 	return EXIT_FASTPATH_NONE;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 44eab734e702..0d8a98feb58e 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -142,6 +142,8 @@ static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
 			 "Invalid TD VMCS access for 16-bit field");
 }
 
+static __always_inline void tdvps_management_check(u64 field, u8 bits) {}
+
 #define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
 static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
 							u32 field)		\
@@ -200,6 +202,8 @@ TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
 TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
 TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
 
+TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
+
 static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
 {
 	struct tdx_module_args out;
-- 
2.25.1



Return-Path: <kvm+bounces-38949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD7ACA404F8
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:50:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EB7F19E39BF
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:50:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C491205E37;
	Sat, 22 Feb 2025 01:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LC6RyOan"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18F4205E14;
	Sat, 22 Feb 2025 01:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188821; cv=none; b=YMrqnNS6D3rFKUUeB3y56qhhI+5IIZ/VuRLKX/BQrdFMG7oqyB1VxzzhNw3mnnX5bO5mz46bGcyW2zmEQKdxUDy1iHpo4m6faDg0sEOYl92WBJcjOQZIsrEpROjeNLGJAwLxUISodah+EcWn3P+PcV09IjtRapKkbelhxbH1tLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188821; c=relaxed/simple;
	bh=b4BQfaYKqAGQvkIl7FjXEllNViIbZzn4te0T6tHJlBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diwz2X2hEJuh2nnOi63UwDFTBv8N09pCUQW3giHAqnI8HoogN4cKM86C1iKdZOmAz9J75ezDrX+6GYx9vxQXDwQ7Pg1Dwa0XIWDdH9C9Q1tR6vxkL5yIC423Nj8fVlp3743U/JQRa28+oZVwrmU3bQS/cqMr6nbBdX3pX6eIsTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LC6RyOan; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188820; x=1771724820;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b4BQfaYKqAGQvkIl7FjXEllNViIbZzn4te0T6tHJlBE=;
  b=LC6RyOanKu1E51zCTsE16mr3yEt+e6sXbwmyVaajSiidPirlS2LVJY+E
   vxzNhAO08aF2Oo6uTQ6wF1Bs49plABkGxgjOpelJKa1Zd+HEEQ9v3YDYD
   PNJBeIevMROTRIG1LqIe/Q8ejqocOJqEL8+/XyA/nP0RjrzEyXcHdLmF1
   Y1kFkZWVzWISZH94/H2o6e0UqREl2+tmH57Gjxt3DurGj1NZloHIkBH0x
   PGCWqawwMT4APvQ4cW4X2byJKBE6/fK+QusZpkpvnCwT0hF3kUaFJ6Trg
   pRcOnPGsshr1YOfyCdd3ZEFef6WNJHliwZ7dWt4f1xiGjSHv8rykAtDTg
   Q==;
X-CSE-ConnectionGUID: Q6q4i0GxQwO+wRwxiIuTvw==
X-CSE-MsgGUID: 8xR4CA9GTBeeUpWdCUvsvw==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="52449059"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="52449059"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:47:00 -0800
X-CSE-ConnectionGUID: sEIBN9eYSdulNRmUyVe/Zw==
X-CSE-MsgGUID: og9e0lNpQnC3kMWsZYmZvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="120621716"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:56 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v3 11/16] KVM: TDX: Force APICv active for TDX guest
Date: Sat, 22 Feb 2025 09:47:52 +0800
Message-ID: <20250222014757.897978-12-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014757.897978-1-binbin.wu@linux.intel.com>
References: <20250222014757.897978-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Force APICv active for TDX guests in KVM because APICv is always enabled
by TDX module.

From the view of KVM, whether APICv state is active or not is decided by:
1. APIC is hw enabled
2. VM and vCPU have no inhibit reasons set.

After TDX vCPU init, APIC is set to x2APIC mode. KVM_SET_{SREGS,SREGS2} are
rejected due to has_protected_state for TDs and guest_state_protected
for TDX vCPUs are set.  Reject KVM_{GET,SET}_LAPIC from userspace since
migration is not supported yet, so that userspace cannot disable APIC.

For various APICv inhibit reasons:
- APICV_INHIBIT_REASON_DISABLED is impossible after checking enable_apicv
  in tdx_bringup(). If !enable_apicv, TDX support will be disabled.
- APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED is impossible since x2APIC is
  mandatory, KVM emulates APIC_ID as read-only for x2APIC mode. (Note:
  APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED could be set if the memory
  allocation fails for KVM apic_map.)
- APICV_INHIBIT_REASON_HYPERV is impossible since TDX doesn't support
  HyperV guest yet.
- APICV_INHIBIT_REASON_ABSENT is impossible since in-kernel LAPIC is
  checked in tdx_vcpu_create().
- APICV_INHIBIT_REASON_BLOCKIRQ is impossible since TDX doesn't support
  KVM_SET_GUEST_DEBUG.
- APICV_INHIBIT_REASON_APIC_ID_MODIFIED is impossible since x2APIC is
  mandatory.
- APICV_INHIBIT_REASON_APIC_BASE_MODIFIED is impossible since KVM rejects
  userspace to set APIC base.
- The rest inhibit reasons are relevant only to AMD's AVIC, including
  APICV_INHIBIT_REASON_NESTED, APICV_INHIBIT_REASON_IRQWIN,
  APICV_INHIBIT_REASON_PIT_REINJ, APICV_INHIBIT_REASON_SEV, and
  APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED.
  (For APICV_INHIBIT_REASON_PIT_REINJ, similar to AVIC, KVM can't intercept
   EOI for TDX guests neither, but KVM enforces KVM_IRQCHIP_SPLIT for TDX
   guests, which eliminates the in-kernel PIT.)

Implement vt_refresh_apicv_exec_ctrl() to call KVM_BUG_ON() if APICv is
disabled for TDX guests.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts v3:
- No change.

TDX interrupts v2:
- Renamed from "KVM: TDX: Inhibit APICv for TDX guest"
- Check enable_apicv in tdx_bringup().
- Changed APICv active state from always false to true for TDX guests. (Sean)
- Reject KVM_{GET,SET}_LAPIC from userspace.
- Implement vt_refresh_apicv_exec_ctrl() to bug the VM if APICv is
  disabled.

TDX interrupts v1:
- Removed WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm)) in
  tdx_td_vcpu_init(). (Rick)
- Change APICV -> APICv in changelog for consistency.
- Split the changelog to 2 paragraphs.
---
 arch/x86/kvm/vmx/main.c | 12 +++++++++++-
 arch/x86/kvm/vmx/tdx.c  |  5 +++++
 arch/x86/kvm/x86.c      |  6 ++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 6a066b7fb3dc..7d10b15cce27 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -437,6 +437,16 @@ static void vt_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 	vmx_get_exit_info(vcpu, reason, info1, info2, intr_info, error_code);
 }
 
+static void vt_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		KVM_BUG_ON(!kvm_vcpu_apicv_active(vcpu), vcpu->kvm);
+		return;
+	}
+
+	vmx_refresh_apicv_exec_ctrl(vcpu);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -553,7 +563,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.x2apic_icr_is_split = false,
 	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
 	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
-	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
+	.refresh_apicv_exec_ctrl = vt_refresh_apicv_exec_ctrl,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.apicv_pre_state_restore = vt_apicv_pre_state_restore,
 	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e2288ec5d1a5..532c2557ca0d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3071,6 +3071,11 @@ int __init tdx_bringup(void)
 		goto success_disable_tdx;
 	}
 
+	if (!enable_apicv) {
+		pr_err("APICv is required for TDX\n");
+		goto success_disable_tdx;
+	}
+
 	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
 		pr_err("MOVDIR64B is reqiured for TDX\n");
 		goto success_disable_tdx;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7b5f5f603ceb..a144dbc81ac4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5105,6 +5105,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
 				    struct kvm_lapic_state *s)
 {
+	if (vcpu->arch.apic->guest_apic_protected)
+		return -EINVAL;
+
 	kvm_x86_call(sync_pir_to_irr)(vcpu);
 
 	return kvm_apic_get_state(vcpu, s);
@@ -5115,6 +5118,9 @@ static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
 {
 	int r;
 
+	if (vcpu->arch.apic->guest_apic_protected)
+		return -EINVAL;
+
 	r = kvm_apic_set_state(vcpu, s);
 	if (r)
 		return r;
-- 
2.46.0



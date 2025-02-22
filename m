Return-Path: <kvm+bounces-38950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD387A404FA
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:51:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9412319E339B
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735903D69;
	Sat, 22 Feb 2025 01:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="El/RjefA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306742063CE;
	Sat, 22 Feb 2025 01:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188824; cv=none; b=LopIy//R1RSEYpQP0gJfey8oiY7BodAxcov+OX5EmEdaSjm08yhDjEUQhRO1+l9OSpFHAOF8ZmsUkG9vGNI6owyEbxPzsYq7+pm46GBCD6NplDLE8xQtJNfVR0JiivvT27p7oBnA/8wSCq4BFI3K7iqJcYZQnOr/5FGnhYFahJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188824; c=relaxed/simple;
	bh=4OO0yq27RtZkPU+K1Hu74LivpwsCzdP8l4OcGXFBGE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxbsYHe8sqDMViR8snrLYqWEjcYWDKirP7ZsKJ/vhk8dqM3KM5gW56L412bgy+6Jbl+xDnu1XHu9bkj2ZQ97pgUzU8MfTAmFkm8TqzeM6fzF4WSG6p/alclzZUCFDfrZ+Krq7SE+A4NoMw7Mn24pwRVpYOrh+ZKJNmnlNlTymDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=El/RjefA; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188823; x=1771724823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4OO0yq27RtZkPU+K1Hu74LivpwsCzdP8l4OcGXFBGE4=;
  b=El/RjefA/8MYlbW3wju70/3E4ejOH+lcyO+NzEj7erA1sYGL5Emof3W2
   naagAW+MvE4pbK9EZEmSgufs1Gts+YhKrmaCohHeZE1t9PaGdyhR04owz
   eY/NhIXfs/ZGjWeaU+FmmqpwFt0vREuCEGImgQIZMIc5knTVO3E9ZFrHz
   iuDSg2F6TgI6C5lRyGbfYEU94ziR6mROlGpOokZgJc4Q5RzYuFqwuSgs1
   BkHJ/5oIqPhgWvFG7JX85Cg6nnAEvNMnga7TVTxEqUXT5X8cFgoVHGvo/
   P2sXavssItjRUGpXd4vN6Aldf5+Uhl/AtxtXWJeXDuasIVQPsuDgtu7L+
   A==;
X-CSE-ConnectionGUID: PmAtrAbtSRazkvGZoTgmrw==
X-CSE-MsgGUID: yHhQR6MkQB6o7Gsfrf5G1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="52449062"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="52449062"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:47:03 -0800
X-CSE-ConnectionGUID: LpQdUP6dS4uw6cdFeQIumQ==
X-CSE-MsgGUID: HcgM34dnTLaaaeSDsG1/SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="120621720"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:47:00 -0800
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
Subject: [PATCH v3 12/16] KVM: TDX: Add methods to ignore virtual apic related operation
Date: Sat, 22 Feb 2025 09:47:53 +0800
Message-ID: <20250222014757.897978-13-binbin.wu@linux.intel.com>
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

TDX protects TDX guest APIC state from VMM.  Implement access methods of
TDX guest vAPIC state to ignore them or return zero.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts v3:
- No change.

TDX interrupts v2:
- Rebased due to "Force APICv active for TDX guest", i.e.,
  vt_refresh_apicv_exec_ctrl() is moved to the patch
  "KVM: TDX: Force APICv active for TDX guest".
- Drop vt_hwapic_irr_update() since .hwapic_irr_update() is gone in 6.14.

TDX interrupts v1:
- Removed WARN_ON_ONCE() in tdx_set_virtual_apic_mode(). (Rick)
- Open code tdx_set_virtual_apic_mode(). (Binbin)
---
 arch/x86/kvm/vmx/main.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7d10b15cce27..21d0788a4cce 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -240,6 +240,15 @@ static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 	return vmx_apic_init_signal_blocked(vcpu);
 }
 
+static void vt_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
+{
+	/* Only x2APIC mode is supported for TD. */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	return vmx_set_virtual_apic_mode(vcpu);
+}
+
 static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
@@ -248,6 +257,14 @@ static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
 	memset(pi->pir, 0, sizeof(pi->pir));
 }
 
+static void vt_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	return vmx_hwapic_isr_update(vcpu, max_isr);
+}
+
 static int vt_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -437,6 +454,14 @@ static void vt_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 	vmx_get_exit_info(vcpu, reason, info1, info2, intr_info, error_code);
 }
 
+static void vt_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_set_apic_access_page_addr(vcpu);
+}
+
 static void vt_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu)) {
@@ -561,13 +586,13 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.update_cr8_intercept = vmx_update_cr8_intercept,
 
 	.x2apic_icr_is_split = false,
-	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
-	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
+	.set_virtual_apic_mode = vt_set_virtual_apic_mode,
+	.set_apic_access_page_addr = vt_set_apic_access_page_addr,
 	.refresh_apicv_exec_ctrl = vt_refresh_apicv_exec_ctrl,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.apicv_pre_state_restore = vt_apicv_pre_state_restore,
 	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
-	.hwapic_isr_update = vmx_hwapic_isr_update,
+	.hwapic_isr_update = vt_hwapic_isr_update,
 	.sync_pir_to_irr = vt_sync_pir_to_irr,
 	.deliver_interrupt = vt_deliver_interrupt,
 	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
-- 
2.46.0



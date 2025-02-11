Return-Path: <kvm+bounces-37800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4045A301EA
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 04:00:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 248DC188C7E8
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 850A91EBFE6;
	Tue, 11 Feb 2025 02:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kEd+NujP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E6A1D63DA;
	Tue, 11 Feb 2025 02:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242656; cv=none; b=f4a8tDMFRLy0S8iv9aGoXii8Ozt5EdtoCsOi09N+DpFmLcjvUcvaQUiyEtIfERhSw32KX1PzkZYLO6mZ5is6tw0spWvSgLie3jPUusviV1ouCP9zSZsKylGmhDeojLB2MOyGf8e7ZaltYssVqUbpwSNhZC5p2PMeG59jk/2UPG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242656; c=relaxed/simple;
	bh=/hvMX0eGw3SrdzEZzlGEaAj/46ofMvuFfnLuzfoln/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSrsdPwceJPhEM7/1t/I3tKrBeJvhLqeJu9aNglNfojkS8w8d6XxFpmJG0mwrkuudyEsc9d3wENQztFfcZsmAUd4ofhDAip7VAkJBsWWonDvx0efPS62Vw28v6LKjlb1ZNGF0XxmO32Q0HtbxP42XFvyxoRHYg4ApKVwEQIfQFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kEd+NujP; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242656; x=1770778656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/hvMX0eGw3SrdzEZzlGEaAj/46ofMvuFfnLuzfoln/k=;
  b=kEd+NujPh0Ag7seQeJNl10tEFa4rCgnGoS/mvGN4UZ6jFdJclXwF6pKO
   znQnOJd2Cix4p/rwCqThyCzWI6J3H+87cs4DPd6Y32jdQbxa3xzv5p1Wi
   Nk9uV7eITW6sMyXEZqa3IzBCojLm4C15YNL2rT3mLGTjxHiqjekAK6Z2f
   0f1tCpPPgXCnnjpGlG8xRg+5lF0jzhPGAV4rHY340Ch3/QJ+ripJqPL1w
   slgiuAnFsbeXp+tOKI/dgb0ZFrWsj4BbZG+xWyijHY19h/bCtvQ4mI42L
   cjPi1ERSGd7gEeGADuFgMmfy/q+C7VUTHSIxL38iFlAgW7c4pCNQqP97b
   A==;
X-CSE-ConnectionGUID: BHn0cEBLQd+qFouNsOUh+A==
X-CSE-MsgGUID: ZMkybRCURU274l2UZAkDlg==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43612488"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43612488"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:36 -0800
X-CSE-ConnectionGUID: /L9wvfcXQpWrAl8mXB3rTA==
X-CSE-MsgGUID: 2+wGtfsnTGKkZwOsbVQhWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112355376"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:31 -0800
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
Subject: [PATCH v2 13/17] KVM: TDX: Add methods to ignore virtual apic related operation
Date: Tue, 11 Feb 2025 10:58:24 +0800
Message-ID: <20250211025828.3072076-14-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
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
index 7fa579c90991..9c173645928c 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -229,6 +229,15 @@ static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
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
@@ -237,6 +246,14 @@ static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
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
@@ -426,6 +443,14 @@ static void vt_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
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
@@ -549,13 +574,13 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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



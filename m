Return-Path: <kvm+bounces-37799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 83521A301E7
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 04:00:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE8DC188C616
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4179F1EB183;
	Tue, 11 Feb 2025 02:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nkeHVclN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67481EA7F6;
	Tue, 11 Feb 2025 02:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242653; cv=none; b=YouNj8O6NccdC9ypbjY2kGh8a2PAE0D7GzAZKWPt5yYawCnQnEkDD7W5R4AVA93QkQTs9d2QbAhUH010MJkRpm+TgGLXCk38RPUiUYUm/YGAMK89QpZyeOwW6E2K9ugTQ3BH/CiPRgks+TWPvuWXRruqzehspmQKfaD4NyonS2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242653; c=relaxed/simple;
	bh=5LMXMqPpwkIa7uNiLnG0k2FArtvqJ3FPiJdjPomBXjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhrTHqkskZvQBYPkADainr5C5JkkybEiQqDqvC2zXHCRqby2Oui+XkPCEYvNnX8Hq76TcbIqN+TxvO/X4kUar674EL4zVohaP/HboDZhLpKs9OYJSZSmIOm4lrSVtIdRC2zDf2sJZIY1mhgIwsYz9sQybz5N/Tf7PY1gjR+UsCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nkeHVclN; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242653; x=1770778653;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5LMXMqPpwkIa7uNiLnG0k2FArtvqJ3FPiJdjPomBXjw=;
  b=nkeHVclNrd3fMdGx8xiNkdsv37c/IG7ZXCGL22+b9NP41M0cU0/xYf6W
   iQVM904wwWNOiTpX9DM2VCrwzrYijTEQN8tQvMjKBzGeWdVf9ieOXAZsu
   9FYnW8YYdAjW9n18UnRtuOxk5FNdM3ghZQqwVfViaVLI6em/9IHViWLmZ
   ge+lCtxux6jqgQtcXja9t5gsp8BoNag5X0/05xY0gw3f5uN5DxBsWTZSd
   ZZDLNGGtrBby46HovAK41YXgclCLIf2g/7u7zxvMN+J8pEw1G9gtzaLGH
   Z/y/cmtgVxjkAnaQIJCjnEzylOOTh7zoRNSBKmbgfJGqI2is+iy7gAV1a
   w==;
X-CSE-ConnectionGUID: e2Oq0E4YR9eEq8TYUJrBQg==
X-CSE-MsgGUID: eZXt2a+7TAW0aCUNzP7fEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43612484"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43612484"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:32 -0800
X-CSE-ConnectionGUID: t6ItlQNjSgObhET45dMYoQ==
X-CSE-MsgGUID: 1EY9AZYPROWFSrb+NgsS5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112355370"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:28 -0800
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
Subject: [PATCH v2 12/17] KVM: TDX: Force APICv active for TDX guest
Date: Tue, 11 Feb 2025 10:58:23 +0800
Message-ID: <20250211025828.3072076-13-binbin.wu@linux.intel.com>
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
index 1ff4903a1853..7fa579c90991 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -426,6 +426,16 @@ static void vt_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
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
@@ -541,7 +551,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.x2apic_icr_is_split = false,
 	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
 	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
-	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
+	.refresh_apicv_exec_ctrl = vt_refresh_apicv_exec_ctrl,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.apicv_pre_state_restore = vt_apicv_pre_state_restore,
 	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4b3251680d43..4a29b3998cde 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3063,6 +3063,11 @@ int __init tdx_bringup(void)
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
index a41d57ba4a86..1e2ab3598846 100644
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



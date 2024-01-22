Return-Path: <kvm+bounces-6583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76E1F83798A
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:41:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D91A28571D
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE76C52F71;
	Mon, 22 Jan 2024 23:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QPdcS5+2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADEF50A62;
	Mon, 22 Jan 2024 23:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967700; cv=none; b=Ic+qFV4r1+mw5M2CcNX+cQCErOl8qdXBt3y29HaFsRoU9PJP5w3M44H9/5ypKNDM7kVyZbdnHsflCRCpSKiiR6Ph+soGUaHv0ZOQiBXwrsk/c3BZeXsg8STltsCiLLUacY8p4aFAVl1Da2PxH85R0DXp2eIHeCHuVR3NvH05bgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967700; c=relaxed/simple;
	bh=A7ezAzNW+x3LYZ1OfRN3x39U1CeFY05u8ohC5GQp9qA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DRBIjcraYau9zVCch3DbT/wIxDVDAbIRlqwjUtKr9rXQUrIVdmsEwPCn0bH8IMjcOrxzhd3/Pf4+TxcosErdS+FFSdmbvP4axPDOo2Le9tTkh9OIylzg/71KquHCDAdqfQBwX3EUz5pQqEM+1L3OBmE0RcDZzih0FaOy6zr4sZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QPdcS5+2; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967699; x=1737503699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A7ezAzNW+x3LYZ1OfRN3x39U1CeFY05u8ohC5GQp9qA=;
  b=QPdcS5+2Tvxm/9DDpjLdfAJbZMzSQl/bkXstXiMOcJqHM6se0abeSGQD
   ZEUehi8h3qb9rcqXXutw8Wvlw5pvEpmSuKAYNRw9v3ovi1TetmlVOzv49
   F4aGtrwH5Fyksh1n1sX1WAVztctI/z6SvQAPAf9ZSb+/iqfsCPt92hGr3
   AazqnjRgie1dTOkLaeLHB+pgB/Mh1tb6S4NpTYL6b+Xmwb1slUccHXK6e
   EUkEX8KnuwvnOrMOx+kEq8L28ct++eFwM103S/rF4cLIRoOWYegNkv2W0
   tQjtWpcLw574GguZULe+PIQApIwtsZAH9snRMQkSBhhcAFf1YsNFC3vs5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1217841"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1217841"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:54:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1350147"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:54:58 -0800
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
	tina.zhang@intel.com
Subject: [PATCH v18 010/121] KVM: TDX: Make TDX VM type supported
Date: Mon, 22 Jan 2024 15:52:46 -0800
Message-Id: <a8b53239da7a1962c5a0f7e51f99818cc1f39b7f.1705965634.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

NOTE: This patch is in position of the patch series for developers to be
able to test codes during the middle of the patch series although this
patch series doesn't provide functional features until the all the patches
of this patch series.  When merging this patch series, this patch can be
moved to the end.

As first step TDX VM support, return that TDX VM type supported to device
model, e.g. qemu.  The callback to create guest TD is vm_init callback for
KVM_CREATE_VM.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 18 ++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     |  6 ++++++
 arch/x86/kvm/vmx/vmx.c     |  6 ------
 arch/x86/kvm/vmx/x86_ops.h |  3 ++-
 4 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index f6b66f18c070..62236bde3779 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -10,6 +10,12 @@
 static bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
 
+static bool vt_is_vm_type_supported(unsigned long type)
+{
+	return __kvm_is_vm_type_supported(type) ||
+		(enable_tdx && tdx_is_vm_type_supported(type));
+}
+
 static int vt_hardware_enable(void)
 {
 	int ret;
@@ -41,6 +47,14 @@ static __init int vt_hardware_setup(void)
 	return 0;
 }
 
+static int vt_vm_init(struct kvm *kvm)
+{
+	if (is_td(kvm))
+		return -EOPNOTSUPP;	/* Not ready to create guest TD yet. */
+
+	return vmx_vm_init(kvm);
+}
+
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -61,9 +75,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.hardware_disable = vmx_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
-	.is_vm_type_supported = vmx_is_vm_type_supported,
+	.is_vm_type_supported = vt_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_vmx),
-	.vm_init = vmx_vm_init,
+	.vm_init = vt_vm_init,
 	.vm_destroy = vmx_vm_destroy,
 
 	.vcpu_precreate = vmx_vcpu_precreate,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1c9884164566..9d3f593eacb8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -24,6 +24,12 @@ static int __init tdx_module_setup(void)
 	return 0;
 }
 
+bool tdx_is_vm_type_supported(unsigned long type)
+{
+	/* enable_tdx check is done by the caller. */
+	return type == KVM_X86_TDX_VM;
+}
+
 struct vmx_tdx_enabled {
 	cpumask_var_t vmx_enabled;
 	atomic_t err;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3f4dad3acb13..69f5e0597534 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7531,12 +7531,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	return err;
 }
 
-bool vmx_is_vm_type_supported(unsigned long type)
-{
-	/* TODO: Check if TDX is supported. */
-	return __kvm_is_vm_type_supported(type);
-}
-
 #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index b44cb681f74d..5da7a5fd91cb 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -28,7 +28,6 @@ void vmx_hardware_unsetup(void);
 int vmx_check_processor_compat(void);
 int vmx_hardware_enable(void);
 void vmx_hardware_disable(void);
-bool vmx_is_vm_type_supported(unsigned long type);
 int vmx_vm_init(struct kvm *kvm);
 void vmx_vm_destroy(struct kvm *kvm);
 int vmx_vcpu_precreate(struct kvm *kvm);
@@ -137,8 +136,10 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_INTEL_TDX_HOST
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+bool tdx_is_vm_type_supported(unsigned long type);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
+static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1



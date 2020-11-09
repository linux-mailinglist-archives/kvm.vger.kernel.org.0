Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4AF2AB561
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 11:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgKIKuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 05:50:06 -0500
Received: from mga06.intel.com ([134.134.136.31]:14726 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbgKIKuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 05:50:06 -0500
IronPort-SDR: h4vSZ50VRU06ou2V0efcjioKhylYvXkacJKSIy8eHbhp1trWpPnr260Ecf9XhzWezPV3IP5sT1
 +EJqY1ndJuBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="231414470"
X-IronPort-AV: E=Sophos;i="5.77,463,1596524400"; 
   d="scan'208";a="231414470"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 02:50:05 -0800
IronPort-SDR: V9IQokZaV3BmJAerm00exXl37ZQ/x8K5Gug15Dz3+V7cIGY0nM4nO/gJNDpjnpcNx6/oBdr7zZ
 h6F7xXyGmLxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,463,1596524400"; 
   d="scan'208";a="359604402"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 09 Nov 2020 02:50:03 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org
Cc:     robert.hu@intel.com, Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH] KVM: VMX: Extract vmx_update_secondary_exec_control()
Date:   Mon,  9 Nov 2020 18:49:48 +0800
Message-Id: <1604918988-26884-1-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, vmx_compute_secondary_exec_control() is invoked by init_vmcs()
and vmx_vcpu_after_set_cpuid().
init_vmcs() is called when creating vcpu and vmx_vcpu_after_set_cpuid() is
called when guest cpuid is settled.

vmx_compute_secondary_exec_control() can be divided into 2 parts: 1)
compute guest's effective secondary_exec_control = vmcs_config + guest
settings. 2) further update effective secondary_exec_control on those
fields related to guest's cpuid.

When vmx_create_vcpu() --> init_vmcs() -->
vmx_compute_secondary_exec_control(), guest cpuid is actually blank, so
doing part 2 is non sense; and futher, part 2 involves
vmx.nested.msrs updates, which later, will be overwritten by
copying vmcs_config.nested. This doesn't cause trouble now is because
vmx_vcpu_after_set_cpuid() --> vmx_compute_secondary_exec_control() later
will update again, but it is wrong in essence.

This patch is to extract part 2 into vmx_update_secondary_exec_control(),
which is called only by vmx_vcpu_after_set_cpuid(), when guest cpuid is
settled. And vmx_vcpu_after_set_cpuid() doesn't need to redo part 1, which
has been done by init_vmcs() earlier.


Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47b8357..995cb4c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4239,6 +4239,19 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	if (!enable_pml)
 		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
 
+	vmx->secondary_exec_control = exec_control;
+}
+
+/*
+ * Some features/exits of Secondary VM-Exec control depend on guest cpuid,
+ * update them when guest cpuid settles/changes.
+ * In nested case, these updates also spread to nVMX control msrs.
+ */
+static void vmx_update_secondary_exec_control(struct vcpu_vmx *vmx)
+{
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
+	u32 exec_control = vmx->secondary_exec_control;
+
 	if (cpu_has_vmx_xsaves()) {
 		/* Exposing XSAVES only when XSAVE is exposed */
 		bool xsaves_enabled =
@@ -7227,7 +7240,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.xsaves_enabled = false;
 
 	if (cpu_has_secondary_exec_ctrls()) {
-		vmx_compute_secondary_exec_control(vmx);
+		vmx_update_secondary_exec_control(vmx);
 		vmcs_set_secondary_exec_control(vmx);
 	}
 
-- 
1.8.3.1


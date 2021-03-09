Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD0A331C69
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 02:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhCIBkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 20:40:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:62282 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231181AbhCIBjs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 20:39:48 -0500
IronPort-SDR: vuuHtzMGJ5nG8EfutIfSq2L/mRJ2ZzUfxciKtea6lun1iAjw7Wsp9qFOLAJaAxtiVVGOf/a6u1
 ShDqgjkWn7og==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="184774596"
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="184774596"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:39:48 -0800
IronPort-SDR: yMd8+/7tSFU8juBoZjEQIy8q6ZBMPCYMmgaHDp3JMEyO+IT+nu+WYi7+DtHg5U23tpo1Nu0AJ/
 PWi1y/Aw/LDw==
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="447327252"
Received: from kzliu-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.128.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:39:42 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 06/25] x86/cpu/intel: Allow SGX virtualization without Launch Control support
Date:   Tue,  9 Mar 2021 14:39:34 +1300
Message-Id: <f6d21cea6cd3b477a0e12c785feb0b6a2cfdde58.1615250634.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1615250634.git.kai.huang@intel.com>
References: <cover.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

The kernel will currently disable all SGX support if the hardware does
not support launch control.  Make it more permissive to allow SGX
virtualization on systems without Launch Control support.  This will
allow KVM to expose SGX to guests that have less-strict requirements on
the availability of flexible launch control.

Improve error message to distinguish between three cases.  There are two
cases where SGX support is completely disabled:
1) SGX has been disabled completely by the BIOS
2) SGX LC is locked by the BIOS.  Bare-metal support is disabled because
   of LC unavailability.  SGX virtualization is unavailable (because of
   Kconfig).
One where it is partially available:
3) SGX LC is locked by the BIOS.  Bare-metal support is disabled because
   of LC unavailability.  SGX virtualization is supported.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v1->v2:

 - Changed order of declaration of variables so that they are in
   reverse-christmas tree pattern.
 - Removed enable_sgx_any, suggested by Boris.

---
 arch/x86/kernel/cpu/feat_ctl.c | 59 +++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index 27533a6e04fa..5bf1dacdf456 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -104,8 +104,9 @@ early_param("nosgx", nosgx);
 
 void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 {
+	bool enable_sgx_kvm = false, enable_sgx_driver = false;
 	bool tboot = tboot_enabled();
-	bool enable_sgx;
+	bool enable_vmx;
 	u64 msr;
 
 	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
@@ -114,13 +115,19 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 		return;
 	}
 
-	/*
-	 * Enable SGX if and only if the kernel supports SGX and Launch Control
-	 * is supported, i.e. disable SGX if the LE hash MSRs can't be written.
-	 */
-	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
-		     cpu_has(c, X86_FEATURE_SGX_LC) &&
-		     IS_ENABLED(CONFIG_X86_SGX);
+	enable_vmx = cpu_has(c, X86_FEATURE_VMX) &&
+		     IS_ENABLED(CONFIG_KVM_INTEL);
+
+	if (cpu_has(c, X86_FEATURE_SGX) && IS_ENABLED(CONFIG_X86_SGX)) {
+		/*
+		 * Separate out SGX driver enabling from KVM.  This allows KVM
+		 * guests to use SGX even if the kernel SGX driver refuses to
+		 * use it.  This happens if flexible Faunch Control is not
+		 * available.
+		 */
+		enable_sgx_driver = cpu_has(c, X86_FEATURE_SGX_LC);
+		enable_sgx_kvm = enable_vmx && IS_ENABLED(CONFIG_X86_SGX_KVM);
+	}
 
 	if (msr & FEAT_CTL_LOCKED)
 		goto update_caps;
@@ -136,15 +143,18 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 	 * i.e. KVM is enabled, to avoid unnecessarily adding an attack vector
 	 * for the kernel, e.g. using VMX to hide malicious code.
 	 */
-	if (cpu_has(c, X86_FEATURE_VMX) && IS_ENABLED(CONFIG_KVM_INTEL)) {
+	if (enable_vmx) {
 		msr |= FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
 
 		if (tboot)
 			msr |= FEAT_CTL_VMX_ENABLED_INSIDE_SMX;
 	}
 
-	if (enable_sgx)
-		msr |= FEAT_CTL_SGX_ENABLED | FEAT_CTL_SGX_LC_ENABLED;
+	if (enable_sgx_kvm || enable_sgx_driver) {
+		msr |= FEAT_CTL_SGX_ENABLED;
+		if (enable_sgx_driver)
+			msr |= FEAT_CTL_SGX_LC_ENABLED;
+	}
 
 	wrmsrl(MSR_IA32_FEAT_CTL, msr);
 
@@ -167,10 +177,29 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 	}
 
 update_sgx:
-	if (!(msr & FEAT_CTL_SGX_ENABLED) ||
-	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
-		if (enable_sgx)
-			pr_err_once("SGX disabled by BIOS\n");
+	if (!(msr & FEAT_CTL_SGX_ENABLED)) {
+		if (enable_sgx_kvm || enable_sgx_driver)
+			pr_err_once("SGX disabled by BIOS.\n");
 		clear_cpu_cap(c, X86_FEATURE_SGX);
+		return;
+	}
+
+	/*
+	 * VMX feature bit may be cleared due to being disabled in BIOS,
+	 * in which case SGX virtualization cannot be supported either.
+	 */
+	if (!cpu_has(c, X86_FEATURE_VMX) && enable_sgx_kvm) {
+		pr_err_once("SGX virtualization disabled due to lack of VMX.\n");
+		enable_sgx_kvm = 0;
+	}
+
+	if (!(msr & FEAT_CTL_SGX_LC_ENABLED) && enable_sgx_driver) {
+		if (!enable_sgx_kvm) {
+			pr_err_once("SGX Launch Control is locked. Disable SGX.\n");
+			clear_cpu_cap(c, X86_FEATURE_SGX);
+		} else {
+			pr_err_once("SGX Launch Control is locked. Support SGX virtualization only.\n");
+			clear_cpu_cap(c, X86_FEATURE_SGX_LC);
+		}
 	}
 }
-- 
2.29.2


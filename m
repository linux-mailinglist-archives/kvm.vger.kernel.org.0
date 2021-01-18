Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A782F9837
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 04:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731637AbhARD2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 22:28:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:54207 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731627AbhARD2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 22:28:18 -0500
IronPort-SDR: WP1SjMNm1FNjbCyJFHt1dvj3qIhvLllYJ4KCMtCBb2IYC8UAe7FXMc+8BVdlMK8kpaLfEFELxd
 AZ+o8hr/UhAw==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="197445790"
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="197445790"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:27:37 -0800
IronPort-SDR: a9/rIcRQ7C0SNk7bXxfVeAySeodj8BE4vZ3+Cqjb/pMK+vgTZJb5VNqJ6+ns3Y6grMSs7UdtCg
 AqxfCRNel5BQ==
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="573150870"
Received: from amrahman-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.253])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:27:33 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v2 06/26] x86/cpu/intel: Allow SGX virtualization without Launch Control support
Date:   Mon, 18 Jan 2021 16:27:19 +1300
Message-Id: <a6c0b0d2632a6c603e68d9bdc81f564290ff04ad.1610935432.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610935432.git.kai.huang@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
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
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v1->v2:

 - Refined commit message per Dave's comments.
 - Added check to only enable SGX virtualization when VMX is supported, per
   Dave's comment.
 - Refined error msg print to explicitly call out SGX virtualization will be
   supported when LC is locked by BIOS, per Dave's comment.
---
 arch/x86/kernel/cpu/feat_ctl.c | 64 +++++++++++++++++++++++++++-------
 1 file changed, 51 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index 7937a315f8cf..7bd8c57c62fa 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -98,6 +98,11 @@ static void clear_sgx_caps(void)
 	setup_clear_cpu_cap(X86_FEATURE_SGX);
 }
 
+static void clear_sgx_lc(void)
+{
+	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
+}
+
 static int __init nosgx(char *str)
 {
 	clear_sgx_caps();
@@ -110,7 +115,7 @@ early_param("nosgx", nosgx);
 void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 {
 	bool tboot = tboot_enabled();
-	bool enable_sgx;
+	bool enable_vmx, enable_sgx_virt, enable_sgx_driver;
 	u64 msr;
 
 	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
@@ -119,13 +124,24 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 		return;
 	}
 
+	enable_vmx = cpu_has(c, X86_FEATURE_VMX) &&
+		     IS_ENABLED(CONFIG_KVM_INTEL);
+
 	/*
-	 * Enable SGX if and only if the kernel supports SGX and Launch Control
-	 * is supported, i.e. disable SGX if the LE hash MSRs can't be written.
+	 * Enable SGX if and only if the kernel supports SGX.  Require Launch
+	 * Control support if SGX virtualization is *not* supported, i.e.
+	 * disable SGX if the LE hash MSRs can't be written and SGX can't be
+	 * exposed to a KVM guest (which might support non-LC configurations).
 	 */
-	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
-		     cpu_has(c, X86_FEATURE_SGX_LC) &&
-		     IS_ENABLED(CONFIG_X86_SGX);
+	enable_sgx_driver = cpu_has(c, X86_FEATURE_SGX) &&
+			    cpu_has(c, X86_FEATURE_SGX1) &&
+			    IS_ENABLED(CONFIG_X86_SGX) &&
+			    cpu_has(c, X86_FEATURE_SGX_LC);
+	enable_sgx_virt = cpu_has(c, X86_FEATURE_SGX) &&
+			  cpu_has(c, X86_FEATURE_SGX1) &&
+			  IS_ENABLED(CONFIG_X86_SGX) &&
+			  IS_ENABLED(CONFIG_X86_SGX_VIRTUALIZATION) &&
+			  enable_vmx;
 
 	if (msr & FEAT_CTL_LOCKED)
 		goto update_caps;
@@ -141,15 +157,18 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
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
+	if (enable_sgx_driver || enable_sgx_virt) {
+		msr |= FEAT_CTL_SGX_ENABLED;
+		if (enable_sgx_driver)
+			msr |= FEAT_CTL_SGX_LC_ENABLED;
+	}
 
 	wrmsrl(MSR_IA32_FEAT_CTL, msr);
 
@@ -172,10 +191,29 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 	}
 
 update_sgx:
-	if (!(msr & FEAT_CTL_SGX_ENABLED) ||
-	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
-		if (enable_sgx)
-			pr_err_once("SGX disabled by BIOS\n");
+	if (!(msr & FEAT_CTL_SGX_ENABLED)) {
+		if (enable_sgx_driver || enable_sgx_virt)
+			pr_err_once("SGX disabled by BIOS.\n");
 		clear_sgx_caps();
+		return;
+	}
+
+	/*
+	 * VMX feature bit may be cleared due to being disabled in BIOS,
+	 * in which case SGX virtualization cannot be supported either.
+	 */
+	if (!cpu_has(c, X86_FEATURE_VMX) && enable_sgx_virt) {
+		pr_err_once("SGX virtualization disabled due to lack of VMX.\n");
+		enable_sgx_virt = 0;
+	}
+
+	if (!(msr & FEAT_CTL_SGX_LC_ENABLED) && enable_sgx_driver) {
+		if (!enable_sgx_virt) {
+			pr_err_once("SGX Launch Control is locked. Disable SGX.\n");
+			clear_sgx_caps();
+		} else {
+			pr_err_once("SGX Launch Control is locked. Support SGX virtualization only.\n");
+			clear_sgx_lc();
+		}
 	}
 }
-- 
2.29.2


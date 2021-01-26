Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF0B30437E
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 17:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391188AbhAZQNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 11:13:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:39104 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391187AbhAZJbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 04:31:48 -0500
IronPort-SDR: 9jSPVkbUrOWr2TVWinVm9IIydoX6eR5gT/xVS47YxbkLTvEZGDXCJxbqg0i46jEf8/mJQkhRjt
 qd4M0c14M7/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="176363313"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="176363313"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:31:07 -0800
IronPort-SDR: EX16KSkqm2HrJp68MbE79vNBavTLohW16YfTh8fmaKkT/Fd9RlvARFN2RQXXkFX+3KMqXV3iuW
 HABU1qZOx5lg==
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="577747596"
Received: from ravivisw-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.124.51])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:31:03 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v3 07/27] x86/cpu/intel: Allow SGX virtualization without Launch Control support
Date:   Tue, 26 Jan 2021 22:30:54 +1300
Message-Id: <ae05882235e61fd8e7a56e37b0d9c044781bd767.1611634586.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611634586.git.kai.huang@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
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
v2->v3:

 - Added to use 'enable_sgx_any', per Dave.
 - Changed to call clear_cpu_cap() directly, rather than using clear_sgx_caps()
   and clear_sgx_lc().
 - Changed to use CONFIG_X86_SGX_KVM, instead of CONFIG_X86_SGX_VIRTUALIZATION.

v1->v2:

 - Refined commit message per Dave's comments.
 - Added check to only enable SGX virtualization when VMX is supported, per
   Dave's comment.
 - Refined error msg print to explicitly call out SGX virtualization will be
   supported when LC is locked by BIOS, per Dave's comment.

---
 arch/x86/kernel/cpu/feat_ctl.c | 58 ++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index 27533a6e04fa..0fc202550fcc 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -105,7 +105,8 @@ early_param("nosgx", nosgx);
 void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 {
 	bool tboot = tboot_enabled();
-	bool enable_sgx;
+	bool enable_vmx;
+	bool enable_sgx_any, enable_sgx_kvm, enable_sgx_driver;
 	u64 msr;
 
 	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
@@ -114,13 +115,22 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
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
+	enable_sgx_any = cpu_has(c, X86_FEATURE_SGX) &&
+			 cpu_has(c, X86_FEATURE_SGX1) &&
+			 IS_ENABLED(CONFIG_X86_SGX);
+	enable_sgx_driver = enable_sgx_any &&
+			    cpu_has(c, X86_FEATURE_SGX_LC);
+	enable_sgx_kvm = enable_sgx_any && enable_vmx &&
+			  IS_ENABLED(CONFIG_X86_SGX_KVM);
 
 	if (msr & FEAT_CTL_LOCKED)
 		goto update_caps;
@@ -136,15 +146,18 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
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
 
@@ -167,10 +180,29 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
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


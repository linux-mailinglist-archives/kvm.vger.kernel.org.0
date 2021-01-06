Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B789C2EB7E1
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 02:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbhAFB4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 20:56:43 -0500
Received: from mga17.intel.com ([192.55.52.151]:55652 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbhAFB4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 20:56:43 -0500
IronPort-SDR: AhVsnmjDy57z0WQkycbmk/fUo3yqRqpSm2XEpR8vqNF4m5wh/xV1nybf/6doWYHaTSBXO0OLQ4
 8MH2q6qUqzwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9855"; a="156996660"
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="156996660"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 17:56:02 -0800
IronPort-SDR: 8CFlwQ2xxjXGVKI7ReG7IXD9uGIof1VZseMVbDV29Ma9epbgqD1Gim3dclmpc7WXVq9IqFGvOk
 +2V9hHWALwpQ==
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="421993235"
Received: from zhuoxuan-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.29.237])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 17:55:58 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH 05/23] x86/cpu/intel: Allow SGX virtualization without Launch Control support
Date:   Wed,  6 Jan 2021 14:55:50 +1300
Message-Id: <2f8a5cb73d9032e5c7ee32f0676e3786ebbc92f3.1609890536.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1609890536.git.kai.huang@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Allow SGX virtualization on systems without Launch Control support, i.e.
allow KVM to expose SGX to guests that support non-LC configurations.

Introduce clear_sgx_lc() to clear SGX_LC feature bit only if SGX Launch
Control is locked by BIOS when SGX virtualization is enabled, to prevent
SGX driver being enabled.

Improve error message to distinguish three cases: 1) SGX disabled
completely by BIOS; 2) SGX disabled completely due to SGX LC is locked
by BIOS, and SGX virtualization is also disabled; 3) Only SGX driver is
disabled due to SGX LC is locked by BIOS, but SGX virtualization is
enabled.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/cpu/feat_ctl.c | 48 +++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index 4fcd57fdc682..b07452b68538 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -101,6 +101,11 @@ static void clear_sgx_caps(void)
 	setup_clear_cpu_cap(X86_FEATURE_SGX2);
 }
 
+static void clear_sgx_lc(void)
+{
+	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
+}
+
 static int __init nosgx(char *str)
 {
 	clear_sgx_caps();
@@ -113,7 +118,7 @@ early_param("nosgx", nosgx);
 void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 {
 	bool tboot = tboot_enabled();
-	bool enable_sgx;
+	bool enable_sgx_virt, enable_sgx_driver;
 	u64 msr;
 
 	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
@@ -123,12 +128,19 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 	}
 
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
+			  IS_ENABLED(CONFIG_X86_SGX_VIRTUALIZATION);
 
 	if (msr & FEAT_CTL_LOCKED)
 		goto update_caps;
@@ -151,8 +163,11 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
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
 
@@ -175,10 +190,19 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
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
 	}
+	if (!(msr & FEAT_CTL_SGX_LC_ENABLED) &&
+	    (enable_sgx_driver || enable_sgx_virt)) {
+		if (!enable_sgx_virt) {
+			pr_err_once("SGX Launch Control is locked. Disable SGX.\n");
+			clear_sgx_caps();
+		} else if (enable_sgx_driver) {
+			pr_err_once("SGX Launch Control is locked. Disable SGX driver.\n");
+			clear_sgx_lc();
+		}
+	}
 }
-- 
2.29.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E311275DE1
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 18:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgIWQuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 12:50:52 -0400
Received: from mga06.intel.com ([134.134.136.31]:17994 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbgIWQuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 12:50:50 -0400
IronPort-SDR: HrFTGTDzdbzfJXxMreLXcdbjMyZ3x6VjWI+LbImyu+KANrcbshtLv1Aao3V+bxrNtXC5Uh57Q3
 3uzm9bsCxxJg==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="222529026"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="222529026"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 09:50:48 -0700
IronPort-SDR: AKGXHpbCoLRljd6qUPK1/on/+jfvjoGYcwvkOQ+ze+YV+UJuyoXjpItAY/xXecnN7FIT7dvhUO
 7bqeYRIzxJEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="454985296"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga004.jf.intel.com with ESMTP; 23 Sep 2020 09:50:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] KVM: VMX: Rename vmx_*_supported() helpers to cpu_has_vmx_*()
Date:   Wed, 23 Sep 2020 09:50:45 -0700
Message-Id: <20200923165048.20486-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923165048.20486-1-sean.j.christopherson@intel.com>
References: <20200923165048.20486-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename helpers for a few controls to conform to the more prevelant style
of cpu_has_vmx_<feature>().  Consistent names will allow adding macros
to consolidate the boilerplate code for adjusting secondary execution
controls.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  8 ++++----
 arch/x86/kvm/vmx/vmx.c          | 14 +++++++-------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4bbd8b448d22..5761736d373a 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -196,7 +196,7 @@ static inline bool cpu_has_vmx_ple(void)
 		SECONDARY_EXEC_PAUSE_LOOP_EXITING;
 }
 
-static inline bool vmx_rdrand_supported(void)
+static inline bool cpu_has_vmx_rdrand(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
 		SECONDARY_EXEC_RDRAND_EXITING;
@@ -233,7 +233,7 @@ static inline bool cpu_has_vmx_encls_vmexit(void)
 		SECONDARY_EXEC_ENCLS_EXITING;
 }
 
-static inline bool vmx_rdseed_supported(void)
+static inline bool cpu_has_vmx_rdseed(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
 		SECONDARY_EXEC_RDSEED_EXITING;
@@ -244,13 +244,13 @@ static inline bool cpu_has_vmx_pml(void)
 	return vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_ENABLE_PML;
 }
 
-static inline bool vmx_xsaves_supported(void)
+static inline bool cpu_has_vmx_xsaves(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
 		SECONDARY_EXEC_XSAVES;
 }
 
-static inline bool vmx_waitpkg_supported(void)
+static inline bool cpu_has_vmx_waitpkg(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
 		SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6f9a0c6d5dc5..cfed29329e4f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4112,7 +4112,7 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	if (!enable_pml)
 		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
 
-	if (vmx_xsaves_supported()) {
+	if (cpu_has_vmx_xsaves()) {
 		/* Exposing XSAVES only when XSAVE is exposed */
 		bool xsaves_enabled =
 			boot_cpu_has(X86_FEATURE_XSAVE) &&
@@ -4170,7 +4170,7 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 		}
 	}
 
-	if (vmx_rdrand_supported()) {
+	if (cpu_has_vmx_rdrand()) {
 		bool rdrand_enabled = guest_cpuid_has(vcpu, X86_FEATURE_RDRAND);
 		if (rdrand_enabled)
 			exec_control &= ~SECONDARY_EXEC_RDRAND_EXITING;
@@ -4185,7 +4185,7 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 		}
 	}
 
-	if (vmx_rdseed_supported()) {
+	if (cpu_has_vmx_rdseed()) {
 		bool rdseed_enabled = guest_cpuid_has(vcpu, X86_FEATURE_RDSEED);
 		if (rdseed_enabled)
 			exec_control &= ~SECONDARY_EXEC_RDSEED_EXITING;
@@ -4200,7 +4200,7 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 		}
 	}
 
-	if (vmx_waitpkg_supported()) {
+	if (cpu_has_vmx_waitpkg()) {
 		bool waitpkg_enabled =
 			guest_cpuid_has(vcpu, X86_FEATURE_WAITPKG);
 
@@ -4308,7 +4308,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	if (vmx->vpid != 0)
 		vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
 
-	if (vmx_xsaves_supported())
+	if (cpu_has_vmx_xsaves())
 		vmcs_write64(XSS_EXIT_BITMAP, VMX_XSS_EXIT_BITMAP);
 
 	if (enable_pml) {
@@ -7271,14 +7271,14 @@ static __init void vmx_set_cpu_caps(void)
 
 	/* CPUID 0xD.1 */
 	supported_xss = 0;
-	if (!vmx_xsaves_supported())
+	if (!cpu_has_vmx_xsaves())
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
 
 	/* CPUID 0x80000001 */
 	if (!cpu_has_vmx_rdtscp())
 		kvm_cpu_cap_clear(X86_FEATURE_RDTSCP);
 
-	if (vmx_waitpkg_supported())
+	if (cpu_has_vmx_waitpkg())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
 }
 
-- 
2.28.0


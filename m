Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22685275DE4
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 18:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgIWQuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 12:50:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:17994 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726693AbgIWQuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 12:50:51 -0400
IronPort-SDR: x2uRyoA6yiTXR2JsCntbl6uyfpWqUZw4r+FIy/C7lXj/MuIR0XywnWwEOEku4htHWoIz5TSBw4
 Z0SX47dJQu/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="222529029"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="222529029"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 09:50:49 -0700
IronPort-SDR: /kGUViqBTIvZC6nc+uZAETA7116U3N4xSrhrY9e9BPRauoF1+sCVu8jXHOi7kuKICYo3gEdjKZ
 DnwtDLsQ32LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="454985304"
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
Subject: [PATCH 4/4] KVM: VMX: Add a helper and macros to reduce boilerplate for sec exec ctls
Date:   Wed, 23 Sep 2020 09:50:48 -0700
Message-Id: <20200923165048.20486-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923165048.20486-1-sean.j.christopherson@intel.com>
References: <20200923165048.20486-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper function and several wrapping macros to consolidate the
copy-paste code in vmx_compute_secondary_exec_control() for adjusting
controls that are dependent on guest CPUID bits.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 128 +++++++++++++----------------------------
 1 file changed, 41 insertions(+), 87 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5180529f6531..b786cfb74f4f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4073,6 +4073,38 @@ u32 vmx_exec_control(struct vcpu_vmx *vmx)
 }
 
 
+static inline void
+vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
+				  u32 control, bool enabled, bool exiting)
+{
+	if (enabled == exiting)
+		*exec_control &= ~control;
+	if (nested) {
+		if (enabled)
+			vmx->nested.msrs.secondary_ctls_high |= control;
+		else
+			vmx->nested.msrs.secondary_ctls_high &= ~control;
+	}
+}
+
+#define vmx_adjust_sec_exec_control(vmx, exec_control, name, feat_name, ctrl_name, exiting) \
+({									 \
+	bool __enabled;							 \
+									 \
+	if (cpu_has_vmx_##name()) {					 \
+		__enabled = guest_cpuid_has(&(vmx)->vcpu,		 \
+					    X86_FEATURE_##feat_name);	 \
+		vmx_adjust_secondary_exec_control(vmx, exec_control,	 \
+			SECONDARY_EXEC_##ctrl_name, __enabled, exiting); \
+	}								 \
+})
+
+#define vmx_adjust_sec_exec_feature(vmx, exec_control, lname, uname) \
+	vmx_adjust_sec_exec_control(vmx, exec_control, lname, uname, ENABLE_##uname, false)
+
+#define vmx_adjust_sec_exec_exiting(vmx, exec_control, lname, uname) \
+	vmx_adjust_sec_exec_control(vmx, exec_control, lname, uname, uname##_EXITING, true)
+
 static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 {
 	struct kvm_vcpu *vcpu = &vmx->vcpu;
@@ -4121,33 +4153,12 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 
 		vcpu->arch.xsaves_enabled = xsaves_enabled;
 
-		if (!xsaves_enabled)
-			exec_control &= ~SECONDARY_EXEC_XSAVES;
-
-		if (nested) {
-			if (xsaves_enabled)
-				vmx->nested.msrs.secondary_ctls_high |=
-					SECONDARY_EXEC_XSAVES;
-			else
-				vmx->nested.msrs.secondary_ctls_high &=
-					~SECONDARY_EXEC_XSAVES;
-		}
+		vmx_adjust_secondary_exec_control(vmx, &exec_control,
+						  SECONDARY_EXEC_XSAVES,
+						  xsaves_enabled, false);
 	}
 
-	if (cpu_has_vmx_rdtscp()) {
-		bool rdtscp_enabled = guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP);
-		if (!rdtscp_enabled)
-			exec_control &= ~SECONDARY_EXEC_ENABLE_RDTSCP;
-
-		if (nested) {
-			if (rdtscp_enabled)
-				vmx->nested.msrs.secondary_ctls_high |=
-					SECONDARY_EXEC_ENABLE_RDTSCP;
-			else
-				vmx->nested.msrs.secondary_ctls_high &=
-					~SECONDARY_EXEC_ENABLE_RDTSCP;
-		}
-	}
+	vmx_adjust_sec_exec_feature(vmx, &exec_control, rdtscp, RDTSCP);
 
 	/*
 	 * Expose INVPCID if and only if PCID is also exposed to the guest.
@@ -4157,71 +4168,14 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	 */
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_PCID))
 		guest_cpuid_clear(vcpu, X86_FEATURE_INVPCID);
+	vmx_adjust_sec_exec_feature(vmx, &exec_control, invpcid, INVPCID);
 
-	if (cpu_has_vmx_invpcid()) {
-		/* Exposing INVPCID only when PCID is exposed */
-		bool invpcid_enabled =
-			guest_cpuid_has(vcpu, X86_FEATURE_INVPCID);
 
-		if (!invpcid_enabled)
-			exec_control &= ~SECONDARY_EXEC_ENABLE_INVPCID;
+	vmx_adjust_sec_exec_exiting(vmx, &exec_control, rdrand, RDRAND);
+	vmx_adjust_sec_exec_exiting(vmx, &exec_control, rdseed, RDSEED);
 
-		if (nested) {
-			if (invpcid_enabled)
-				vmx->nested.msrs.secondary_ctls_high |=
-					SECONDARY_EXEC_ENABLE_INVPCID;
-			else
-				vmx->nested.msrs.secondary_ctls_high &=
-					~SECONDARY_EXEC_ENABLE_INVPCID;
-		}
-	}
-
-	if (cpu_has_vmx_rdrand()) {
-		bool rdrand_enabled = guest_cpuid_has(vcpu, X86_FEATURE_RDRAND);
-		if (rdrand_enabled)
-			exec_control &= ~SECONDARY_EXEC_RDRAND_EXITING;
-
-		if (nested) {
-			if (rdrand_enabled)
-				vmx->nested.msrs.secondary_ctls_high |=
-					SECONDARY_EXEC_RDRAND_EXITING;
-			else
-				vmx->nested.msrs.secondary_ctls_high &=
-					~SECONDARY_EXEC_RDRAND_EXITING;
-		}
-	}
-
-	if (cpu_has_vmx_rdseed()) {
-		bool rdseed_enabled = guest_cpuid_has(vcpu, X86_FEATURE_RDSEED);
-		if (rdseed_enabled)
-			exec_control &= ~SECONDARY_EXEC_RDSEED_EXITING;
-
-		if (nested) {
-			if (rdseed_enabled)
-				vmx->nested.msrs.secondary_ctls_high |=
-					SECONDARY_EXEC_RDSEED_EXITING;
-			else
-				vmx->nested.msrs.secondary_ctls_high &=
-					~SECONDARY_EXEC_RDSEED_EXITING;
-		}
-	}
-
-	if (cpu_has_vmx_waitpkg()) {
-		bool waitpkg_enabled =
-			guest_cpuid_has(vcpu, X86_FEATURE_WAITPKG);
-
-		if (!waitpkg_enabled)
-			exec_control &= ~SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
-
-		if (nested) {
-			if (waitpkg_enabled)
-				vmx->nested.msrs.secondary_ctls_high |=
-					SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
-			else
-				vmx->nested.msrs.secondary_ctls_high &=
-					~SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
-		}
-	}
+	vmx_adjust_sec_exec_control(vmx, &exec_control, waitpkg, WAITPKG,
+				    ENABLE_USR_WAIT_PAUSE, false);
 
 	vmx->secondary_exec_control = exec_control;
 }
-- 
2.28.0


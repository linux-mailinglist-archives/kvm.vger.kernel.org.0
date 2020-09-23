Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BD5275DE2
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 18:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgIWQu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 12:50:59 -0400
Received: from mga06.intel.com ([134.134.136.31]:17995 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbgIWQuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 12:50:51 -0400
IronPort-SDR: YhNsNMFa9ksH01mlLDO3x0COcTCa6oT/a4f9xAJtmRP6JRq2jZTuJi1p4gyZ6g9PkBuIomAyDo
 EO0Gij7J0N0w==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="222529028"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="222529028"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 09:50:48 -0700
IronPort-SDR: fbRerztby2b0zm70lpXqdYELd0Zrmf6JETBvxNfYKPNmuYZPRrMw6Y+6qY/Bn76U77vu44ksQv
 4TJu43gXzUPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="454985301"
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
Subject: [PATCH 3/4] KVM: VMX: Rename RDTSCP secondary exec control name to insert "ENABLE"
Date:   Wed, 23 Sep 2020 09:50:47 -0700
Message-Id: <20200923165048.20486-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923165048.20486-1-sean.j.christopherson@intel.com>
References: <20200923165048.20486-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename SECONDARY_EXEC_RDTSCP to SECONDARY_EXEC_ENABLE_RDTSCP in
preparation for consolidating the logic for adjusting secondary exec
controls based on the guest CPUID model.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/vmx.h                       |  2 +-
 arch/x86/kvm/vmx/capabilities.h                  |  2 +-
 arch/x86/kvm/vmx/nested.c                        |  4 ++--
 arch/x86/kvm/vmx/vmx.c                           | 10 +++++-----
 tools/testing/selftests/kvm/include/x86_64/vmx.h |  2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index cd7de4b401fe..f8ba5289ecb0 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -52,7 +52,7 @@
 #define SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES VMCS_CONTROL_BIT(VIRT_APIC_ACCESSES)
 #define SECONDARY_EXEC_ENABLE_EPT               VMCS_CONTROL_BIT(EPT)
 #define SECONDARY_EXEC_DESC			VMCS_CONTROL_BIT(DESC_EXITING)
-#define SECONDARY_EXEC_RDTSCP			VMCS_CONTROL_BIT(RDTSCP)
+#define SECONDARY_EXEC_ENABLE_RDTSCP		VMCS_CONTROL_BIT(RDTSCP)
 #define SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE   VMCS_CONTROL_BIT(VIRTUAL_X2APIC)
 #define SECONDARY_EXEC_ENABLE_VPID              VMCS_CONTROL_BIT(VPID)
 #define SECONDARY_EXEC_WBINVD_EXITING		VMCS_CONTROL_BIT(WBINVD_EXITING)
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 5761736d373a..3a1861403d73 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -151,7 +151,7 @@ static inline bool vmx_umip_emulated(void)
 static inline bool cpu_has_vmx_rdtscp(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
-		SECONDARY_EXEC_RDTSCP;
+		SECONDARY_EXEC_ENABLE_RDTSCP;
 }
 
 static inline bool cpu_has_vmx_virtualize_x2apic_mode(void)
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b6ce9ce91029..c5808d798e4c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2286,7 +2286,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		/* Take the following fields only from vmcs12 */
 		exec_control &= ~(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
 				  SECONDARY_EXEC_ENABLE_INVPCID |
-				  SECONDARY_EXEC_RDTSCP |
+				  SECONDARY_EXEC_ENABLE_RDTSCP |
 				  SECONDARY_EXEC_XSAVES |
 				  SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
 				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
@@ -6393,7 +6393,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	msrs->secondary_ctls_low = 0;
 	msrs->secondary_ctls_high &=
 		SECONDARY_EXEC_DESC |
-		SECONDARY_EXEC_RDTSCP |
+		SECONDARY_EXEC_ENABLE_RDTSCP |
 		SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
 		SECONDARY_EXEC_WBINVD_EXITING |
 		SECONDARY_EXEC_APIC_REGISTER_VIRT |
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 57e48c5a1e91..5180529f6531 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2421,7 +2421,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_UNRESTRICTED_GUEST |
 			SECONDARY_EXEC_PAUSE_LOOP_EXITING |
 			SECONDARY_EXEC_DESC |
-			SECONDARY_EXEC_RDTSCP |
+			SECONDARY_EXEC_ENABLE_RDTSCP |
 			SECONDARY_EXEC_ENABLE_INVPCID |
 			SECONDARY_EXEC_APIC_REGISTER_VIRT |
 			SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
@@ -4137,15 +4137,15 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	if (cpu_has_vmx_rdtscp()) {
 		bool rdtscp_enabled = guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP);
 		if (!rdtscp_enabled)
-			exec_control &= ~SECONDARY_EXEC_RDTSCP;
+			exec_control &= ~SECONDARY_EXEC_ENABLE_RDTSCP;
 
 		if (nested) {
 			if (rdtscp_enabled)
 				vmx->nested.msrs.secondary_ctls_high |=
-					SECONDARY_EXEC_RDTSCP;
+					SECONDARY_EXEC_ENABLE_RDTSCP;
 			else
 				vmx->nested.msrs.secondary_ctls_high &=
-					~SECONDARY_EXEC_RDTSCP;
+					~SECONDARY_EXEC_ENABLE_RDTSCP;
 		}
 	}
 
@@ -7340,7 +7340,7 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	 * Because it is marked as EmulateOnUD, we need to intercept it here.
 	 */
 	case x86_intercept_rdtscp:
-		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_RDTSCP)) {
+		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_RDTSCP)) {
 			exception->vector = UD_VECTOR;
 			exception->error_code_valid = false;
 			return X86EMUL_PROPAGATE_FAULT;
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 16fa21ebb99c..54d624dd6c10 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -48,7 +48,7 @@
 #define SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES 0x00000001
 #define SECONDARY_EXEC_ENABLE_EPT		0x00000002
 #define SECONDARY_EXEC_DESC			0x00000004
-#define SECONDARY_EXEC_RDTSCP			0x00000008
+#define SECONDARY_EXEC_ENABLE_RDTSCP		0x00000008
 #define SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE	0x00000010
 #define SECONDARY_EXEC_ENABLE_VPID		0x00000020
 #define SECONDARY_EXEC_WBINVD_EXITING		0x00000040
-- 
2.28.0


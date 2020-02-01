Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E2114F9C7
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgBASyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:54:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:11279 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727219AbgBASwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075550"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 40/61] KVM: VMX: Convert feature updates from CPUID to KVM cpu caps
Date:   Sat,  1 Feb 2020 10:51:57 -0800
Message-Id: <20200201185218.24473-41-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the recently introduced KVM CPU caps to propagate VMX-only (kernel)
settings to supported CPUID flags.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 51 ++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 11b9c1e7e520..bae915431c72 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7102,37 +7102,42 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 {
 	switch (entry->function) {
-	case 0x1:
-		if (nested)
-			cpuid_entry_set(entry, X86_FEATURE_VMX);
-		break;
 	case 0x7:
-		if (boot_cpu_has(X86_FEATURE_MPX) && kvm_mpx_supported())
-			cpuid_entry_set(entry, X86_FEATURE_MPX);
-		if (boot_cpu_has(X86_FEATURE_INVPCID) && cpu_has_vmx_invpcid())
-			cpuid_entry_set(entry, X86_FEATURE_INVPCID);
-		if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
-		    vmx_pt_mode_is_host_guest())
-			cpuid_entry_set(entry, X86_FEATURE_INTEL_PT);
 		if (vmx_umip_emulated())
 			cpuid_entry_set(entry, X86_FEATURE_UMIP);
-
-		/* PKU is not yet implemented for shadow paging. */
-		if (enable_ept && boot_cpu_has(X86_FEATURE_PKU) &&
-		    boot_cpu_has(X86_FEATURE_OSPKE))
-			cpuid_entry_set(entry, X86_FEATURE_PKU);
-		break;
-	case 0x80000001:
-		if (!cpu_has_vmx_rdtscp())
-			cpuid_entry_clear(entry, X86_FEATURE_RDTSCP);
-		if (enable_ept && !cpu_has_vmx_ept_1g_page())
-			cpuid_entry_clear(entry, X86_FEATURE_GBPAGES);
 		break;
 	default:
 		break;
 	}
 }
 
+static __init void vmx_set_cpu_caps(void)
+{
+	/* CPUID 0x1 */
+	if (nested)
+		kvm_cpu_cap_set(X86_FEATURE_VMX);
+
+	/* CPUID 0x7 */
+	if (boot_cpu_has(X86_FEATURE_MPX) && kvm_mpx_supported())
+		kvm_cpu_cap_set(X86_FEATURE_MPX);
+	if (boot_cpu_has(X86_FEATURE_INVPCID) && cpu_has_vmx_invpcid())
+		kvm_cpu_cap_set(X86_FEATURE_INVPCID);
+	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
+	    vmx_pt_mode_is_host_guest())
+		kvm_cpu_cap_set(X86_FEATURE_INTEL_PT);
+
+	/* PKU is not yet implemented for shadow paging. */
+	if (enable_ept && boot_cpu_has(X86_FEATURE_PKU) &&
+	    boot_cpu_has(X86_FEATURE_OSPKE))
+		kvm_cpu_cap_set(X86_FEATURE_PKU);
+
+	/* CPUID 0x80000001 */
+	if (!cpu_has_vmx_rdtscp())
+		kvm_cpu_cap_clear(X86_FEATURE_RDTSCP);
+	if (enable_ept && !cpu_has_vmx_ept_1g_page())
+		kvm_cpu_cap_clear(X86_FEATURE_GBPAGES);
+}
+
 static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
 {
 	to_vmx(vcpu)->req_immediate_exit = true;
@@ -7750,6 +7755,8 @@ static __init int hardware_setup(void)
 			return r;
 	}
 
+	vmx_set_cpu_caps();
+
 	r = alloc_kvm_area();
 	if (r)
 		nested_vmx_hardware_unsetup();
-- 
2.24.1


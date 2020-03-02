Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3961768AC
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgCBX6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:58:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:25521 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbgCBX5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384743"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 40/66] KVM: VMX: Convert feature updates from CPUID to KVM cpu caps
Date:   Mon,  2 Mar 2020 15:56:43 -0800
Message-Id: <20200302235709.27467-41-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the recently introduced KVM CPU caps to propagate VMX-only (kernel)
settings to supported CPUID flags.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 56 +++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 131f4b88d307..6f68d5e694e0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7119,40 +7119,50 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 	}
 }
 
+/*
+ * Vendor specific emulation must be handled via ->set_supported_cpuid(), not
+ * vmx_set_cpu_caps(), as capabilities configured during hardware_setup() are
+ * masked against hardware/kernel support, i.e. they'd be lost.
+ */
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
@@ -7815,6 +7825,8 @@ static __init int hardware_setup(void)
 			return r;
 	}
 
+	vmx_set_cpu_caps();
+
 	r = alloc_kvm_area();
 	if (r)
 		nested_vmx_hardware_unsetup();
-- 
2.24.1


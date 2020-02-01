Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8EA514F98D
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgBASwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:52:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:11286 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbgBASwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075553"
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
Subject: [PATCH 41/61] KVM: x86: Move XSAVES CPUID adjust to VMX's KVM cpu cap update
Date:   Sat,  1 Feb 2020 10:51:58 -0800
Message-Id: <20200201185218.24473-42-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the clearing of the XSAVES CPUID bit into VMX, which has a separate
VMCS control to enable XSAVES in non-root, to eliminate the last ugly
renmant of the undesirable "unsigned f_* = *_supported ? F(*) : 0"
pattern in the common CPUID handling code.

Drop ->xsaves_supported(), CPUID adjustment was the only user.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/cpuid.c            | 4 ----
 arch/x86/kvm/svm.c              | 6 ------
 arch/x86/kvm/vmx/vmx.c          | 5 ++++-
 4 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ba828569cda5..dd690fb5ceca 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1163,7 +1163,6 @@ struct kvm_x86_ops {
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion *exit_fastpath);
 
-	bool (*xsaves_supported)(void);
 	bool (*umip_emulated)(void);
 	bool (*pt_supported)(void);
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c2a4c9df49a9..77a6c1db138d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -626,10 +626,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			goto out;
 
 		cpuid_entry_mask(entry, CPUID_D_1_EAX);
-
-		if (!kvm_x86_ops->xsaves_supported())
-			cpuid_entry_clear(entry, X86_FEATURE_XSAVES);
-
 		if (entry->eax & (F(XSAVES)|F(XSAVEC)))
 			entry->ebx = xstate_required_size(supported_xcr0, true);
 		else
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f98a192459f7..7cb05945162e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6080,11 +6080,6 @@ static bool svm_rdtscp_supported(void)
 	return boot_cpu_has(X86_FEATURE_RDTSCP);
 }
 
-static bool svm_xsaves_supported(void)
-{
-	return boot_cpu_has(X86_FEATURE_XSAVES);
-}
-
 static bool svm_umip_emulated(void)
 {
 	return false;
@@ -7455,7 +7450,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpuid_update = svm_cpuid_update,
 
 	.rdtscp_supported = svm_rdtscp_supported,
-	.xsaves_supported = svm_xsaves_supported,
 	.umip_emulated = svm_umip_emulated,
 	.pt_supported = svm_pt_supported,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bae915431c72..cfd0ef314176 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7131,6 +7131,10 @@ static __init void vmx_set_cpu_caps(void)
 	    boot_cpu_has(X86_FEATURE_OSPKE))
 		kvm_cpu_cap_set(X86_FEATURE_PKU);
 
+	/* CPUID 0xD.1 */
+	if (!vmx_xsaves_supported())
+		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
+
 	/* CPUID 0x80000001 */
 	if (!cpu_has_vmx_rdtscp())
 		kvm_cpu_cap_clear(X86_FEATURE_RDTSCP);
@@ -7886,7 +7890,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
-	.xsaves_supported = vmx_xsaves_supported,
 	.umip_emulated = vmx_umip_emulated,
 	.pt_supported = vmx_pt_supported,
 
-- 
2.24.1


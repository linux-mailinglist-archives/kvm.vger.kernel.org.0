Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C641768B8
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgCBX6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:58:53 -0500
Received: from mga03.intel.com ([134.134.136.65]:17173 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727467AbgCBX52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384823"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:24 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 66/66] KVM: x86: Move nSVM CPUID 0x8000000A handing into common x86 code
Date:   Mon,  2 Mar 2020 15:57:09 -0800
Message-Id: <20200302235709.27467-67-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Handle CPUID 0x8000000A in the main switch in __do_cpuid_func() and drop
->set_supported_cpuid() now that both VMX and SVM implementations are
empty.  Like leaf 0x14 (Intel PT) and leaf 0x8000001F (SEV), leaf
0x8000000A is is (obviously) vendor specific but can be queried in
common code while respecting SVM's wishes by querying kvm_cpu_cap_has().

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 --
 arch/x86/kvm/cpuid.c            | 13 +++++++++++--
 arch/x86/kvm/svm.c              | 19 -------------------
 arch/x86/kvm/vmx/vmx.c          |  6 ------
 4 files changed, 11 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 27983e5895d9..ccafcbe82d9d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1151,8 +1151,6 @@ struct kvm_x86_ops {
 
 	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
-	void (*set_supported_cpuid)(struct kvm_cpuid_entry2 *entry);
-
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*read_l1_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f0c4ad04d4dc..3347001bf3b0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -746,6 +746,17 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
 		break;
 	}
+	case 0x8000000A:
+		if (!kvm_cpu_cap_has(X86_FEATURE_SVM)) {
+			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+			break;
+		}
+		entry->eax = 1; /* SVM revision 1 */
+		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
+				   ASID emulation to nested SVM */
+		entry->ecx = 0; /* Reserved */
+		/* Note, 0x8000000A.EDX is managed via kvm_cpu_caps. */;
+		break;
 	case 0x80000019:
 		entry->ecx = entry->edx = 0;
 		break;
@@ -775,8 +786,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	}
 
-	kvm_x86_ops->set_supported_cpuid(entry);
-
 	r = 0;
 
 out:
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 32d9c13ec6b9..a190bea5ba90 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6048,23 +6048,6 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 					 APICV_INHIBIT_REASON_NESTED);
 }
 
-static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
-{
-	switch (entry->function) {
-	case 0x8000000A:
-		if (!kvm_cpu_cap_has(X86_FEATURE_SVM)) {
-			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
-			break;
-		}
-		entry->eax = 1; /* SVM revision 1 */
-		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
-				   ASID emulation to nested SVM */
-		entry->ecx = 0; /* Reserved */
-		/* Note, 0x8000000A.EDX is managed via kvm_cpu_caps. */;
-		break;
-	}
-}
-
 static bool svm_has_wbinvd_exit(void)
 {
 	return true;
@@ -7422,8 +7405,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.cpuid_update = svm_cpuid_update,
 
-	.set_supported_cpuid = svm_set_supported_cpuid,
-
 	.has_wbinvd_exit = svm_has_wbinvd_exit,
 
 	.read_l1_tsc_offset = svm_read_l1_tsc_offset,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 180aeebd029a..eab3f77e9b7f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7098,11 +7098,6 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
-{
-
-}
-
 static __init void vmx_set_cpu_caps(void)
 {
 	/* CPUID 0x1 */
@@ -7915,7 +7910,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.get_exit_info = vmx_get_exit_info,
 
 	.cpuid_update = vmx_cpuid_update,
-	.set_supported_cpuid = vmx_set_supported_cpuid,
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
-- 
2.24.1


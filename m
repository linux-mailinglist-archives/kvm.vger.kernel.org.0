Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 733FB1768C1
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgCBX7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:59:22 -0500
Received: from mga03.intel.com ([134.134.136.65]:17168 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727439AbgCBX52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384817"
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
Subject: [PATCH v2 64/66] KVM: nSVM: Expose SVM features to L1 iff nested is enabled
Date:   Mon,  2 Mar 2020 15:57:07 -0800
Message-Id: <20200302235709.27467-65-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set SVM feature bits in KVM capabilities if and only if nested=true, KVM
shouldn't advertise features that realistically can't be used.  Use
kvm_cpu_cap_has(X86_FEATURE_SVM) to indirectly query "nested" in
svm_set_supported_cpuid() in anticipation of moving CPUID 0x8000000A
adjustments into common x86 code.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f32fc3c03667..8e39dcd3160d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1373,21 +1373,21 @@ static __init void svm_set_cpu_caps(void)
 	if (avic)
 		kvm_cpu_cap_clear(X86_FEATURE_X2APIC);
 
-	/* CPUID 0x80000001 */
-	if (nested)
+	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
+	if (nested) {
 		kvm_cpu_cap_set(X86_FEATURE_SVM);
 
+		if (boot_cpu_has(X86_FEATURE_NRIPS))
+			kvm_cpu_cap_set(X86_FEATURE_NRIPS);
+
+		if (npt_enabled)
+			kvm_cpu_cap_set(X86_FEATURE_NPT);
+	}
+
 	/* CPUID 0x80000008 */
 	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
-
-	/* CPUID 0x8000000A */
-	/* Support next_rip if host supports it */
-	kvm_cpu_cap_check_and_set(X86_FEATURE_NRIPS);
-
-	if (npt_enabled)
-		kvm_cpu_cap_set(X86_FEATURE_NPT);
 }
 
 static __init int svm_hardware_setup(void)
@@ -6051,6 +6051,10 @@ static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 {
 	switch (entry->function) {
 	case 0x8000000A:
+		if (!kvm_cpu_cap_has(X86_FEATURE_SVM)) {
+			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+			break;
+		}
 		entry->eax = 1; /* SVM revision 1 */
 		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
 				   ASID emulation to nested SVM */
-- 
2.24.1


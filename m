Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF8621E50C
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 03:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgGNBYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 21:24:46 -0400
Received: from mga12.intel.com ([192.55.52.136]:3555 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgGNBYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 21:24:46 -0400
IronPort-SDR: SIGcOZgvAqjfH//LbaTL/KD/vLUq4oLQendT9QYk+KT9Vc/gGkuPgu+UzIWhuWJ4SapHoLU21S
 Rprxhe2HE5tg==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="128335352"
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="128335352"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 18:24:45 -0700
IronPort-SDR: zTuwavoXlFX6hjRzlLozhiHIC7rdTX3dDznO7Xsbcd+TcvNnPRYsMfxCNvEFbKCCwi91T5suab
 2Nu9R/xpPjRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="485691184"
Received: from guptapadev.jf.intel.com (HELO guptapadev.amr) ([10.54.74.188])
  by fmsmga005.fm.intel.com with ESMTP; 13 Jul 2020 18:24:44 -0700
Date:   Mon, 13 Jul 2020 18:18:54 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc:     x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "Gomez Iglesias, Antonio" <antonio.gomez.iglesias@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Anthony Steinhauser <asteinhauser@google.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Mark Gross <mgross@linux.intel.com>,
        Waiman Long <longman@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] x86/bugs/multihit: Fix mitigation reporting when KVM is not
 in use
Message-ID: <267631f4db4fd7e9f7ca789c2efaeab44103f68e.1594689154.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On systems that have virtualization disabled or KVM module is not
loaded, sysfs mitigation state of X86_BUG_ITLB_MULTIHIT is reported
incorrectly as:

  $ cat /sys/devices/system/cpu/vulnerabilities/itlb_multihit
  KVM: Vulnerable

System is not vulnerable to DoS attack from a rogue guest when:
 - KVM module is not loaded or
 - Virtualization is disabled in the hardware or
 - Kernel was configured without support for KVM

Change the reporting to "Currently not affected (KVM not in use)" for
such cases.

Reported-by: Nelson Dsouza <nelson.dsouza@linux.intel.com>
Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 .../admin-guide/hw-vuln/multihit.rst          |  5 +++-
 arch/x86/include/asm/processor.h              |  6 +++++
 arch/x86/kernel/cpu/bugs.c                    | 24 +++++++++----------
 arch/x86/kvm/mmu/mmu.c                        |  9 +++++--
 4 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/multihit.rst b/Documentation/admin-guide/hw-vuln/multihit.rst
index ba9988d8bce5..842961419f3e 100644
--- a/Documentation/admin-guide/hw-vuln/multihit.rst
+++ b/Documentation/admin-guide/hw-vuln/multihit.rst
@@ -82,7 +82,10 @@ The possible values in this file are:
        - Software changes mitigate this issue.
      * - KVM: Vulnerable
        - The processor is vulnerable, but no mitigation enabled
-
+     * - Currently not affected (KVM not in use)
+       - The processor is vulnerable but no mitigation is required because
+         KVM module is not loaded or virtualization is disabled in the hardware or
+         kernel was configured without support for KVM.
 
 Enumeration of the erratum
 --------------------------------
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 03b7c4ca425a..830a3e7725af 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -989,4 +989,10 @@ enum mds_mitigations {
 	MDS_MITIGATION_VMWERV,
 };
 
+enum itlb_multihit_mitigations {
+	ITLB_MULTIHIT_MITIGATION_OFF,
+	ITLB_MULTIHIT_MITIGATION_FULL,
+	ITLB_MULTIHIT_MITIGATION_NO_KVM,
+};
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 0b71970d2d3d..97f66a93f2be 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1395,8 +1395,15 @@ void x86_spec_ctrl_setup_ap(void)
 		x86_amd_ssb_disable();
 }
 
-bool itlb_multihit_kvm_mitigation;
-EXPORT_SYMBOL_GPL(itlb_multihit_kvm_mitigation);
+/* Default to KVM not in use, KVM module changes this later */
+enum itlb_multihit_mitigations itlb_multihit_mitigation = ITLB_MULTIHIT_MITIGATION_NO_KVM;
+EXPORT_SYMBOL_GPL(itlb_multihit_mitigation);
+
+static const char * const itlb_multihit_strings[] = {
+	[ITLB_MULTIHIT_MITIGATION_OFF]		= "KVM: Vulnerable",
+	[ITLB_MULTIHIT_MITIGATION_FULL]		= "KVM: Mitigation: Split huge pages",
+	[ITLB_MULTIHIT_MITIGATION_NO_KVM]	= "Currently not affected (KVM not in use)",
+};
 
 #undef pr_fmt
 #define pr_fmt(fmt)	"L1TF: " fmt
@@ -1553,25 +1560,18 @@ static ssize_t l1tf_show_state(char *buf)
 		       l1tf_vmx_states[l1tf_vmx_mitigation],
 		       sched_smt_active() ? "vulnerable" : "disabled");
 }
-
-static ssize_t itlb_multihit_show_state(char *buf)
-{
-	if (itlb_multihit_kvm_mitigation)
-		return sprintf(buf, "KVM: Mitigation: Split huge pages\n");
-	else
-		return sprintf(buf, "KVM: Vulnerable\n");
-}
 #else
 static ssize_t l1tf_show_state(char *buf)
 {
 	return sprintf(buf, "%s\n", L1TF_DEFAULT_MSG);
 }
+#endif
 
 static ssize_t itlb_multihit_show_state(char *buf)
 {
-	return sprintf(buf, "Processor vulnerable\n");
+	return sprintf(buf, "%s\n",
+		       itlb_multihit_strings[itlb_multihit_mitigation]);
 }
-#endif
 
 static ssize_t mds_show_state(char *buf)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d6a0ae7800c..e089b9e565a5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -50,7 +50,7 @@
 #include <asm/kvm_page_track.h>
 #include "trace.h"
 
-extern bool itlb_multihit_kvm_mitigation;
+extern enum itlb_multihit_mitigations itlb_multihit_mitigation;
 
 static int __read_mostly nx_huge_pages = -1;
 #ifdef CONFIG_PREEMPT_RT
@@ -6158,7 +6158,12 @@ static bool get_nx_auto_mode(void)
 
 static void __set_nx_huge_pages(bool val)
 {
-	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
+	nx_huge_pages = val;
+
+	if (val)
+		itlb_multihit_mitigation = ITLB_MULTIHIT_MITIGATION_FULL;
+	else
+		itlb_multihit_mitigation = ITLB_MULTIHIT_MITIGATION_OFF;
 }
 
 static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
-- 
2.21.3


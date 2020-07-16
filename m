Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59D1222BE9
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 21:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbgGPT34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 15:29:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:62386 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728788AbgGPT34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jul 2020 15:29:56 -0400
IronPort-SDR: dXX6OC5CoOkqakY0NaniPr/XTx4mAwfVa9u4jRPr/O9/lNSXcNWnwWxTISVfjsWdBdvGGOMzqi
 VrTEmm8eRHNg==
X-IronPort-AV: E=McAfee;i="6000,8403,9684"; a="167616024"
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="167616024"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 12:29:55 -0700
IronPort-SDR: Rw/CNHn192L0+R8y7GGaKRMKcHlm3dB/wEHRSknCC3Mzc7hl/2FGCndwvsfD2gY3p6lsaNLv7p
 pEUq9GnywRMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="486217234"
Received: from guptapadev.jf.intel.com (HELO guptapadev.amr) ([10.54.74.188])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jul 2020 12:29:54 -0700
Date:   Thu, 16 Jul 2020 12:23:59 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        "Gomez Iglesias, Antonio" <antonio.gomez.iglesias@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Anthony Steinhauser <asteinhauser@google.com>,
        Waiman Long <longman@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Mark Gross <mgross@linux.intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v2] x86/bugs/multihit: Fix mitigation reporting when VMX is
 not in use
Message-ID: <0ba029932a816179b9d14a30db38f0f11ef1f166.1594925782.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On systems that have virtualization disabled or unsupported, sysfs
mitigation for X86_BUG_ITLB_MULTIHIT is reported incorrectly as:

  $ cat /sys/devices/system/cpu/vulnerabilities/itlb_multihit
  KVM: Vulnerable

System is not vulnerable to DoS attack from a rogue guest when
virtualization is disabled or unsupported in the hardware. Change the
mitigation reporting for these cases.

Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Reported-by: Nelson Dsouza <nelson.dsouza@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
v2:
 - Change mitigation reporting as per the state on VMX feature.

v1: https://lore.kernel.org/lkml/267631f4db4fd7e9f7ca789c2efaeab44103f68e.1594689154.git.pawan.kumar.gupta@linux.intel.com/

 Documentation/admin-guide/hw-vuln/multihit.rst | 4 ++++
 arch/x86/kernel/cpu/bugs.c                     | 8 +++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/hw-vuln/multihit.rst b/Documentation/admin-guide/hw-vuln/multihit.rst
index ba9988d8bce5..140e4cec38c3 100644
--- a/Documentation/admin-guide/hw-vuln/multihit.rst
+++ b/Documentation/admin-guide/hw-vuln/multihit.rst
@@ -80,6 +80,10 @@ The possible values in this file are:
        - The processor is not vulnerable.
      * - KVM: Mitigation: Split huge pages
        - Software changes mitigate this issue.
+     * - KVM: Mitigation: VMX unsupported
+       - KVM is not vulnerable because Virtual Machine Extensions (VMX) is not supported.
+     * - KVM: Mitigation: VMX disabled
+       - KVM is not vulnerable because Virtual Machine Extensions (VMX) is disabled.
      * - KVM: Vulnerable
        - The processor is vulnerable, but no mitigation enabled
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 0b71970d2d3d..b0802d45abd3 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -31,6 +31,7 @@
 #include <asm/intel-family.h>
 #include <asm/e820/api.h>
 #include <asm/hypervisor.h>
+#include <asm/tlbflush.h>
 
 #include "cpu.h"
 
@@ -1556,7 +1557,12 @@ static ssize_t l1tf_show_state(char *buf)
 
 static ssize_t itlb_multihit_show_state(char *buf)
 {
-	if (itlb_multihit_kvm_mitigation)
+	if (!boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
+	    !boot_cpu_has(X86_FEATURE_VMX))
+		return sprintf(buf, "KVM: Mitigation: VMX unsupported\n");
+	else if (!(cr4_read_shadow() & X86_CR4_VMXE))
+		return sprintf(buf, "KVM: Mitigation: VMX disabled\n");
+	else if (itlb_multihit_kvm_mitigation)
 		return sprintf(buf, "KVM: Mitigation: Split huge pages\n");
 	else
 		return sprintf(buf, "KVM: Vulnerable\n");
-- 
2.21.3


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10467DF949
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 02:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387487AbfJVAIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 20:08:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:7797 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387479AbfJVAIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 20:08:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 17:08:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196274537"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 17:08:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 05/16] KVM: VMX: Drop initialization of IA32_FEATURE_CONTROL MSR
Date:   Mon, 21 Oct 2019 17:08:20 -0700
Message-Id: <20191022000820.1854-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191021234632.32363-1-sean.j.christopherson@intel.com>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the code to initialize IA32_FEATURE_CONTROL MSR when KVM is
loaded now that the MSR is initialized during boot on all CPUs that
support VMX, i.e. can possibly load kvm_intel.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 48 +++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d4575ffb3cec..23c9e4b91b31 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2192,24 +2192,26 @@ static __init int vmx_disabled_by_bios(void)
 	u64 msr;
 
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, msr);
-	if (msr & FEATURE_CONTROL_LOCKED) {
-		/* launched w/ TXT and VMX disabled */
-		if (!(msr & FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX)
-			&& tboot_enabled())
-			return 1;
-		/* launched w/o TXT and VMX only enabled w/ TXT */
-		if (!(msr & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX)
-			&& (msr & FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX)
-			&& !tboot_enabled()) {
-			printk(KERN_WARNING "kvm: disable TXT in the BIOS or "
-				"activate TXT before enabling KVM\n");
-			return 1;
-		}
-		/* launched w/o TXT and VMX disabled */
-		if (!(msr & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX)
-			&& !tboot_enabled())
-			return 1;
+
+	if (WARN_ON_ONCE(!(msr & FEATURE_CONTROL_LOCKED)))
+		return 1;
+
+	/* launched w/ TXT and VMX disabled */
+	if (!(msr & FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX) &&
+	    tboot_enabled())
+		return 1;
+	/* launched w/o TXT and VMX only enabled w/ TXT */
+	if (!(msr & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX) &&
+	    (msr & FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX) &&
+	    !tboot_enabled()) {
+		pr_warn("kvm: disable TXT in the BIOS or "
+			"activate TXT before enabling KVM\n");
+		return 1;
 	}
+	/* launched w/o TXT and VMX disabled */
+	if (!(msr & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX) &&
+	    !tboot_enabled())
+		return 1;
 
 	return 0;
 }
@@ -2226,7 +2228,6 @@ static int hardware_enable(void)
 {
 	int cpu = raw_smp_processor_id();
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
-	u64 old, test_bits;
 
 	if (cr4_read_shadow() & X86_CR4_VMXE)
 		return -EBUSY;
@@ -2254,17 +2255,6 @@ static int hardware_enable(void)
 	 */
 	crash_enable_local_vmclear(cpu);
 
-	rdmsrl(MSR_IA32_FEATURE_CONTROL, old);
-
-	test_bits = FEATURE_CONTROL_LOCKED;
-	test_bits |= FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
-	if (tboot_enabled())
-		test_bits |= FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX;
-
-	if ((old & test_bits) != test_bits) {
-		/* enable and lock */
-		wrmsrl(MSR_IA32_FEATURE_CONTROL, old | test_bits);
-	}
 	kvm_cpu_vmxon(phys_addr);
 	if (enable_ept)
 		ept_sync_global();
-- 
2.22.0


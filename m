Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E676EBB4
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 22:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388169AbfGSUlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 16:41:23 -0400
Received: from mga12.intel.com ([192.55.52.136]:46747 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388128AbfGSUlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 16:41:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 13:41:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,283,1559545200"; 
   d="scan'208";a="168655834"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by fmsmga008.fm.intel.com with ESMTP; 19 Jul 2019 13:41:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] KVM: VMX: Add error handling to VMREAD helper
Date:   Fri, 19 Jul 2019 13:41:08 -0700
Message-Id: <20190719204110.18306-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190719204110.18306-1-sean.j.christopherson@intel.com>
References: <20190719204110.18306-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that VMREAD flows require a taken branch, courtesy of commit

  3901336ed9887 ("x86/kvm: Don't call kvm_spurious_fault() from .fixup")

bite the bullet and add full error handling to VMREAD, i.e. replace the
JMP added by __ex()/____kvm_handle_fault_on_reboot() with a hinted Jcc.

To minimize the code footprint, add a helper function, vmread_error(),
to handle both faults and failures so that the inline flow has a single
CALL.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/ops.h | 21 +++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c |  8 ++++++++
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/ops.h
index 79e25d49d4d9..45eaedee2ac0 100644
--- a/arch/x86/kvm/vmx/ops.h
+++ b/arch/x86/kvm/vmx/ops.h
@@ -11,9 +11,8 @@
 #include "vmcs.h"
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
-#define __ex_clear(x, reg) \
-	____kvm_handle_fault_on_reboot(x, "xor " reg ", " reg)
 
+asmlinkage void vmread_error(unsigned long field, bool fault);
 void vmwrite_error(unsigned long field, unsigned long value);
 void vmclear_error(struct vmcs *vmcs, u64 phys_addr);
 void vmptrld_error(struct vmcs *vmcs, u64 phys_addr);
@@ -68,8 +67,22 @@ static __always_inline unsigned long __vmcs_readl(unsigned long field)
 {
 	unsigned long value;
 
-	asm volatile (__ex_clear("vmread %1, %0", "%k0")
-		      : "=r"(value) : "r"(field));
+	asm volatile("1: vmread %2, %1\n\t"
+		     ".byte 0x3e\n\t" /* branch taken hint */
+		     "ja 3f\n\t"
+		     "mov %2, %%" _ASM_ARG1 "\n\t"
+		     "xor %%" _ASM_ARG2 ", %%" _ASM_ARG2 "\n\t"
+		     "2: call vmread_error\n\t"
+		     "xor %k1, %k1\n\t"
+		     "3:\n\t"
+
+		     ".pushsection .fixup, \"ax\"\n\t"
+		     "4: mov %2, %%" _ASM_ARG1 "\n\t"
+		     "mov $1, %%" _ASM_ARG2 "\n\t"
+		     "jmp 2b\n\t"
+		     ".popsection\n\t"
+		     _ASM_EXTABLE(1b, 4b)
+		     : ASM_CALL_CONSTRAINT, "=r"(value) : "r"(field) : "cc");
 	return value;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 46689019ebf7..9acf3d6395d3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -349,6 +349,14 @@ do {					\
 	pr_warn_ratelimited(fmt);	\
 } while (0)
 
+asmlinkage void vmread_error(unsigned long field, bool fault)
+{
+	if (fault)
+		kvm_spurious_fault();
+	else
+		vmx_insn_failed("kvm: vmread failed: field=%lx\n", field);
+}
+
 noinline void vmwrite_error(unsigned long field, unsigned long value)
 {
 	vmx_insn_failed("kvm: vmwrite failed: field=%lx val=%lx err=%d\n",
-- 
2.22.0


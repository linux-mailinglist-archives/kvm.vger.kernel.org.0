Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 091D06EA16
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 19:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731283AbfGSRZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 13:25:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:21962 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbfGSRZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 13:25:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 10:25:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,283,1559545200"; 
   d="scan'208";a="252213007"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by orsmga001.jf.intel.com with ESMTP; 19 Jul 2019 10:25:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     kvm@vger.kernel.org
Subject: [PATCH 3/4] KVM: VMX: Add error handling to VMREAD helper
Date:   Fri, 19 Jul 2019 10:25:39 -0700
Message-Id: <20190719172540.7697-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190719172540.7697-1-sean.j.christopherson@intel.com>
References: <20190719172540.7697-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An inflight patch[1] to tweak  ____kvm_handle_fault_on_reboot() will
result in an extra JMP being inserted after every VMX instruction.
Since VMREAD flows will soon have a taken branch, bite the bullet and
add full error handling to VMREAD, i.e. preemptively replace the
to-be-added JMP with a hinted Jcc.

To minimize the code footprint, add a helper function, vmread_error(),
to handle both faults and failures so that the inline flow has a single
CALL.

[1] https://lkml.kernel.org/r/64a9b64d127e87b6920a97afde8e96ea76f6524e.1563413318.git.jpoimboe@redhat.com

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
index 1770622e9608..67028b0ff99a 100644
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


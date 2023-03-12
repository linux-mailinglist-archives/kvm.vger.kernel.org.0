Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42A46B645D
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjCLJzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjCLJyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:53 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBADB3B220
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614891; x=1710150891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BEe1gy5f0H5u6vJxdXrARBGcEC4j/LlyM+vXYsbJpHw=;
  b=dh7SFCDdpZDwhn35cKaOsCqrkuwOTsQDikiun6YIPMiy6aBc//p9JTa7
   BC/j1pIHChxKu19T6VHOKIbrJ8eV/TztFKAT8jhNaz78vYfrLAc76sCPk
   R1uAzz+Nlu66h4IZJ6fOPZYa/wpwrt6CIsdeKVUq8oxGLcQH/AZzk0+8p
   zfMZQn5sIF3S1Yn90IY08QIRoVtFINDGRtHRwCzzs0wMIDbNY1SqG4SI7
   wHN+MDjfM9FlSUULBAcFp/zgniyJ7VW70dwekDDg5nz3/dTFTexIh/t0z
   2WX2AT/YAv6CTLFcXfl/AYI04SWzEB4j+isVjhfLDY2cmdnjj7Uo87CQW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622938"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622938"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852409024"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852409024"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:33 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-2 12/17] pkvm: x86: Add vmexit handler for host vcpu
Date:   Mon, 13 Mar 2023 02:01:07 +0800
Message-Id: <20230312180112.1778254-13-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180112.1778254-1-jason.cj.chen@intel.com>
References: <20230312180112.1778254-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pKVM need to handle vmexit from host OS after it deprivilege to a VM.

Some instructions cause vmexit unconditionally, like CPUID, XSETBV, for
such vmexit handlers, pKVM just do what host VM want.

Although now msr_bitmap is cleared, there is still possibility host
Linux accessing unsupported MSR (e.g. MSR from AMD platform) which will
cause vmexit, pKVM just simply ignore such msr writing and return 0 on
such msr reading.

For MOV to CR vmexit, pKVM only take care CR4.VMXE, it allows host VM
change VMXE bit by directly write host value to CR4_READ_SHADOW.

Define a pkvm_main function which do the loop handling of
vmexit_handlers based on above different vmexit reason, and
__pkvm_vmx_vcpu_run at the tail of loop to trigger VMLAUNCH/VMRESUME.

New pKVM on Intel platform files to support hypervisor runtime are
placed under arch/x86/kvm/vmx/pkvm/hyp.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/Makefile       |   1 +
 arch/x86/kvm/vmx/pkvm/hyp/Makefile   |   8 ++
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c   | 154 ++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.h   |  11 ++
 arch/x86/kvm/vmx/pkvm/hyp/vmx_asm.S  | 186 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/include/pkvm.h |   2 +
 arch/x86/kvm/vmx/pkvm/pkvm_host.c    |   3 +-
 7 files changed, 364 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pkvm/Makefile b/arch/x86/kvm/vmx/pkvm/Makefile
index 1795d5f9b4b0..ed0629baf449 100644
--- a/arch/x86/kvm/vmx/pkvm/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/Makefile
@@ -6,3 +6,4 @@ ccflags-y += -I $(srctree)/arch/x86/kvm/vmx/pkvm/include
 pkvm-obj		:= pkvm_host.o
 
 obj-$(CONFIG_PKVM_INTEL)	+= $(pkvm-obj)
+obj-$(CONFIG_PKVM_INTEL)	+= hyp/
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
new file mode 100644
index 000000000000..ea810f09e381
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+
+ccflags-y += -I $(srctree)/arch/x86/kvm
+ccflags-y += -I $(srctree)/arch/x86/kvm/vmx/pkvm/include
+
+pkvm-hyp-y	:= vmx_asm.o vmexit.o
+
+obj-$(CONFIG_PKVM_INTEL)	+= $(pkvm-hyp-y)
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
new file mode 100644
index 000000000000..19be7ce201df
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#include <pkvm.h>
+#include "vmexit.h"
+#include "debug.h"
+
+#define CR4	4
+
+#define MOV_TO_CR		0
+
+static void skip_emulated_instruction(void)
+{
+	unsigned long rip;
+
+	rip = vmcs_readl(GUEST_RIP);
+	rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+	vmcs_writel(GUEST_RIP, rip);
+}
+
+static void handle_cpuid(struct kvm_vcpu *vcpu)
+{
+	u32 eax, ebx, ecx, edx;
+
+	eax = vcpu->arch.regs[VCPU_REGS_RAX];
+	ecx = vcpu->arch.regs[VCPU_REGS_RCX];
+	native_cpuid(&eax, &ebx, &ecx, &edx);
+	vcpu->arch.regs[VCPU_REGS_RAX] = eax;
+	vcpu->arch.regs[VCPU_REGS_RBX] = ebx;
+	vcpu->arch.regs[VCPU_REGS_RCX] = ecx;
+	vcpu->arch.regs[VCPU_REGS_RDX] = edx;
+}
+
+static void handle_cr(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long exit_qual, val;
+	int cr;
+	int type;
+	int reg;
+
+	exit_qual = vmx->exit_qualification;
+	cr = exit_qual & 15;
+	type = (exit_qual >> 4)	& 3;
+	reg = (exit_qual >> 8) & 15;
+
+	switch (type) {
+	case MOV_TO_CR:
+		switch (cr) {
+		case CR4:
+			/*
+			 * VMXE bit is owned by host, others are owned by guest
+			 * So only when guest is trying to modify VMXE bit it
+			 * can cause vmexit and get here.
+			 */
+			val = vcpu->arch.regs[reg];
+			vmcs_writel(CR4_READ_SHADOW, val);
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static void handle_read_msr(struct kvm_vcpu *vcpu)
+{
+	/* simply return 0 for non-supported MSRs */
+	vcpu->arch.regs[VCPU_REGS_RAX] = 0;
+	vcpu->arch.regs[VCPU_REGS_RDX] = 0;
+}
+
+static void handle_write_msr(struct kvm_vcpu *vcpu)
+{
+	/*No emulation for msr write now*/
+}
+
+static void handle_xsetbv(struct kvm_vcpu *vcpu)
+{
+	u32 eax = (u32)(vcpu->arch.regs[VCPU_REGS_RAX] & -1u);
+	u32 edx = (u32)(vcpu->arch.regs[VCPU_REGS_RDX] & -1u);
+	u32 ecx = (u32)(vcpu->arch.regs[VCPU_REGS_RCX] & -1u);
+
+	asm volatile(".byte 0x0f,0x01,0xd1"
+			: : "a" (eax), "d" (edx), "c" (ecx));
+}
+
+/* we take use of kvm_vcpu structure, but not used all the fields */
+int pkvm_main(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int launch = 1;
+
+	do {
+		bool skip_instruction = false;
+
+		if (__pkvm_vmx_vcpu_run(vcpu->arch.regs, launch)) {
+			pkvm_err("%s: CPU%d run_vcpu failed with error 0x%x\n",
+				__func__, vcpu->cpu, vmcs_read32(VM_INSTRUCTION_ERROR));
+			return -EINVAL;
+		}
+
+		vcpu->arch.cr2 = native_read_cr2();
+
+		vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
+		vmx->exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+
+		switch (vmx->exit_reason.full) {
+		case EXIT_REASON_CPUID:
+			handle_cpuid(vcpu);
+			skip_instruction = true;
+			break;
+		case EXIT_REASON_CR_ACCESS:
+			pkvm_dbg("CPU%d vmexit_reason: CR_ACCESS.\n", vcpu->cpu);
+			handle_cr(vcpu);
+			skip_instruction = true;
+			break;
+		case EXIT_REASON_MSR_READ:
+			pkvm_dbg("CPU%d vmexit_reason: MSR_READ 0x%lx\n",
+					vcpu->cpu, vcpu->arch.regs[VCPU_REGS_RCX]);
+			handle_read_msr(vcpu);
+			skip_instruction = true;
+			break;
+		case EXIT_REASON_MSR_WRITE:
+			pkvm_dbg("CPU%d vmexit_reason: MSR_WRITE 0x%lx\n",
+					vcpu->cpu, vcpu->arch.regs[VCPU_REGS_RCX]);
+			handle_write_msr(vcpu);
+			skip_instruction = true;
+			break;
+		case EXIT_REASON_XSETBV:
+			handle_xsetbv(vcpu);
+			skip_instruction = true;
+			break;
+		default:
+			pkvm_dbg("CPU%d: Unsupported vmexit reason 0x%x.\n", vcpu->cpu, vmx->exit_reason.full);
+			skip_instruction = true;
+			break;
+		}
+
+		/* now only need vmresume */
+		launch = 0;
+
+		if (skip_instruction)
+			skip_emulated_instruction();
+
+		native_write_cr2(vcpu->arch.cr2);
+	} while (1);
+
+	return 0;
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.h b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.h
new file mode 100644
index 000000000000..5089b87b51b5
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#ifndef _PKVM_VMEXIT_H_
+#define _PKVM_VMEXIT_H_
+
+int __pkvm_vmx_vcpu_run(unsigned long *regs, int launch);
+
+#endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmx_asm.S b/arch/x86/kvm/vmx/pkvm/hyp/vmx_asm.S
new file mode 100644
index 000000000000..3a0c9fcd8d9c
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmx_asm.S
@@ -0,0 +1,186 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#include <linux/linkage.h>
+#include <asm/kvm_vcpu_regs.h>
+#include <asm/frame.h>
+#include <asm/asm.h>
+#include <asm/bitsperlong.h>
+#include <asm/unwind_hints.h>
+#include <asm/nospec-branch.h>
+
+#define WORD_SIZE (BITS_PER_LONG / 8)
+
+#define VCPU_RAX	(__VCPU_REGS_RAX * WORD_SIZE)
+#define VCPU_RCX	(__VCPU_REGS_RCX * WORD_SIZE)
+#define VCPU_RDX	(__VCPU_REGS_RDX * WORD_SIZE)
+#define VCPU_RBX	(__VCPU_REGS_RBX * WORD_SIZE)
+#define VCPU_RBP	(__VCPU_REGS_RBP * WORD_SIZE)
+#define VCPU_RSI	(__VCPU_REGS_RSI * WORD_SIZE)
+#define VCPU_RDI	(__VCPU_REGS_RDI * WORD_SIZE)
+
+#define VCPU_R8		(__VCPU_REGS_R8  * WORD_SIZE)
+#define VCPU_R9		(__VCPU_REGS_R9  * WORD_SIZE)
+#define VCPU_R10	(__VCPU_REGS_R10 * WORD_SIZE)
+#define VCPU_R11	(__VCPU_REGS_R11 * WORD_SIZE)
+#define VCPU_R12	(__VCPU_REGS_R12 * WORD_SIZE)
+#define VCPU_R13	(__VCPU_REGS_R13 * WORD_SIZE)
+#define VCPU_R14	(__VCPU_REGS_R14 * WORD_SIZE)
+#define VCPU_R15	(__VCPU_REGS_R15 * WORD_SIZE)
+
+#define HOST_RSP	0x6C14
+
+/**
+ * __vmenter - VM-Enter the current loaded VMCS
+ *
+ * Returns:
+ *	%RFLAGS.CF is set on VM-Fail Invalid
+ *	%RFLAGS.ZF is set on VM-Fail Valid
+ *	%RFLAGS.{CF,ZF} are cleared on VM-Success, i.e. VM-Exit
+ *
+ * Note that VMRESUME/VMLAUNCH fall-through and return directly if
+ * they VM-Fail, whereas a successful VM-Enter + VM-Exit will jump
+ * to vmx_vmexit.
+ */
+SYM_FUNC_START_LOCAL(__vmenter)
+	/* EFLAGS.ZF is set if VMCS.LAUNCHED == 0 */
+	je 2f
+
+1:	vmresume
+	ANNOTATE_UNRET_SAFE
+	ret
+
+2:	vmlaunch
+	ANNOTATE_UNRET_SAFE
+	ret
+SYM_FUNC_END(__vmenter)
+
+/**
+ * __pkvm_vmx_vmexit - Handle a VMX VM-Exit
+ *
+ * Returns:
+ *	%RFLAGS.{CF,ZF} are cleared on VM-Success, i.e. VM-Exit
+ *
+ * This is __vmenter's partner in crime.  On a VM-Exit, control will jump
+ * here after hardware loads the host's state, i.e. this is the destination
+ * referred to by VMCS.HOST_RIP.
+ */
+SYM_FUNC_START(__pkvm_vmx_vmexit)
+	ANNOTATE_UNRET_SAFE
+	ret
+SYM_FUNC_END(__pkvm_vmx_vmexit)
+
+/**
+ * __pkvm_vmx_vcpu_run - Run a vCPU via a transition to VMX guest mode
+ * @regs:	unsigned long * (to guest registers)
+ * @launched:	%true if the VMCS has been launched
+ *
+ * Returns:
+ *	0 on VM-Exit, 1 on VM-Fail
+ */
+SYM_FUNC_START(__pkvm_vmx_vcpu_run)
+	push %_ASM_BP
+	mov  %_ASM_SP, %_ASM_BP
+	push %r15
+	push %r14
+	push %r13
+	push %r12
+
+	push %_ASM_BX
+
+	push %_ASM_ARG1
+
+	/* record host RSP (0x6C14) */
+	mov $HOST_RSP, %_ASM_BX
+	lea -WORD_SIZE(%_ASM_SP), %_ASM_CX
+	vmwrite %_ASM_CX, %_ASM_BX
+
+	mov %_ASM_ARG1, %_ASM_CX
+	cmp $1, %_ASM_ARG2
+
+	mov VCPU_RAX(%_ASM_CX), %_ASM_AX
+	mov VCPU_RBX(%_ASM_CX), %_ASM_BX
+	mov VCPU_RDX(%_ASM_CX), %_ASM_DX
+	mov VCPU_RSI(%_ASM_CX), %_ASM_SI
+	mov VCPU_RDI(%_ASM_CX), %_ASM_DI
+	mov VCPU_RBP(%_ASM_CX), %_ASM_BP
+	mov VCPU_R8(%_ASM_CX),  %r8
+	mov VCPU_R9(%_ASM_CX),  %r9
+	mov VCPU_R10(%_ASM_CX), %r10
+	mov VCPU_R11(%_ASM_CX), %r11
+	mov VCPU_R12(%_ASM_CX), %r12
+	mov VCPU_R13(%_ASM_CX), %r13
+	mov VCPU_R14(%_ASM_CX), %r14
+	mov VCPU_R15(%_ASM_CX), %r15
+
+	mov VCPU_RCX(%_ASM_CX), %_ASM_CX
+
+	call __vmenter
+
+	/* Jump on VM-Fail. */
+	jbe 2f
+
+	push %_ASM_CX
+	mov WORD_SIZE(%_ASM_SP), %_ASM_CX
+
+	mov %_ASM_AX, VCPU_RAX(%_ASM_CX)
+	mov %_ASM_BX, VCPU_RBX(%_ASM_CX)
+	mov %_ASM_DX, VCPU_RDX(%_ASM_CX)
+	mov %_ASM_SI, VCPU_RSI(%_ASM_CX)
+	mov %_ASM_DI, VCPU_RDI(%_ASM_CX)
+	mov %_ASM_BP, VCPU_RBP(%_ASM_CX)
+	mov %r8 , VCPU_R8(%_ASM_CX)
+	mov %r9 , VCPU_R9(%_ASM_CX)
+	mov %r10, VCPU_R10(%_ASM_CX)
+	mov %r11, VCPU_R11(%_ASM_CX)
+	mov %r12, VCPU_R12(%_ASM_CX)
+	mov %r13, VCPU_R13(%_ASM_CX)
+	mov %r14, VCPU_R14(%_ASM_CX)
+	mov %r15, VCPU_R15(%_ASM_CX)
+
+	pop VCPU_RCX(%_ASM_CX)
+
+	/* Clear RAX to indicate VM-Exit (as opposed to VM-Fail). */
+	xor %eax, %eax
+
+	/*
+	 * Clear all general purpose registers except RSP and RAX to prevent
+	 * speculative use of the guest's values, even those that are reloaded
+	 * via the stack.  In theory, an L1 cache miss when restoring registers
+	 * could lead to speculative execution with the guest's values.
+	 * Zeroing XORs are dirt cheap, i.e. the extra paranoia is essentially
+	 * free.  RSP and RAX are exempt as RSP is restored by hardware during
+	 * VM-Exit and RAX is explicitly loaded with 0 or 1 to return VM-Fail.
+	 */
+1:	xor %ebx, %ebx
+	xor %ecx, %ecx
+	xor %edx, %edx
+	xor %esi, %esi
+	xor %edi, %edi
+	xor %ebp, %ebp
+	xor %r8d,  %r8d
+	xor %r9d,  %r9d
+	xor %r10d, %r10d
+	xor %r11d, %r11d
+	xor %r12d, %r12d
+	xor %r13d, %r13d
+	xor %r14d, %r14d
+	xor %r15d, %r15d
+
+	/* "POP" @regs. */
+	add $WORD_SIZE, %_ASM_SP
+	pop %_ASM_BX
+
+	pop %r12
+	pop %r13
+	pop %r14
+	pop %r15
+
+	pop %_ASM_BP
+	ANNOTATE_UNRET_SAFE
+	ret
+	/* VM-Fail.  Out-of-line to avoid a taken Jcc after VM-Exit. */
+2:	mov $1, %eax
+	jmp 1b
+SYM_FUNC_END(__pkvm_vmx_vcpu_run)
diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index 486e631f4254..65583c01574e 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -47,4 +47,6 @@ struct pkvm_hyp {
 #define PKVM_PCPU_PAGES (ALIGN(sizeof(struct pkvm_pcpu), PAGE_SIZE) >> PAGE_SHIFT)
 #define PKVM_HOST_VCPU_PAGES (ALIGN(sizeof(struct pkvm_host_vcpu), PAGE_SIZE) >> PAGE_SHIFT)
 
+void __pkvm_vmx_vmexit(void);
+
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 810e7421f644..d147d6ec7795 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -277,7 +277,8 @@ static __init void init_host_state_area(struct pkvm_host_vcpu *vcpu)
 
 	_init_host_state_area(pcpu);
 
-	/*TODO: add HOST_RIP */
+	/*host RIP*/
+	vmcs_writel(HOST_RIP, (unsigned long)__pkvm_vmx_vmexit);
 }
 
 static __init void init_execution_control(struct vcpu_vmx *vmx,
-- 
2.25.1


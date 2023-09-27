Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3FF7AF97C
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjI0Eft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjI0Eey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:34:54 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC531FC;
        Tue, 26 Sep 2023 20:10:18 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxueoRnRNlvBctAA--.10816S3;
        Wed, 27 Sep 2023 11:10:09 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxjd4InRNlhZETAA--.42466S24;
        Wed, 27 Sep 2023 11:10:08 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn,
        Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH v22 22/25] LoongArch: KVM: Implement vcpu world switch
Date:   Wed, 27 Sep 2023 11:09:56 +0800
Message-Id: <20230927030959.3629941-23-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
References: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cxjd4InRNlhZETAA--.42466S24
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement LoongArch vcpu world switch, including vcpu enter guest and
vcpu exit from guest, both operations need to save or restore the host
and guest registers.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Tested-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kernel/asm-offsets.c |  32 ++++
 arch/loongarch/kvm/switch.S         | 250 ++++++++++++++++++++++++++++
 2 files changed, 282 insertions(+)
 create mode 100644 arch/loongarch/kvm/switch.S

diff --git a/arch/loongarch/kernel/asm-offsets.c b/arch/loongarch/kernel/asm-offsets.c
index 8da0726777..173fe514fc 100644
--- a/arch/loongarch/kernel/asm-offsets.c
+++ b/arch/loongarch/kernel/asm-offsets.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/kbuild.h>
 #include <linux/suspend.h>
+#include <linux/kvm_host.h>
 #include <asm/cpu-info.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
@@ -289,3 +290,34 @@ void output_fgraph_ret_regs_defines(void)
 	BLANK();
 }
 #endif
+
+void output_kvm_defines(void)
+{
+	COMMENT("KVM/LoongArch Specific offsets.");
+
+	OFFSET(VCPU_FCC, kvm_vcpu_arch, fpu.fcc);
+	OFFSET(VCPU_FCSR0, kvm_vcpu_arch, fpu.fcsr);
+	BLANK();
+
+	OFFSET(KVM_VCPU_ARCH, kvm_vcpu, arch);
+	OFFSET(KVM_VCPU_KVM, kvm_vcpu, kvm);
+	OFFSET(KVM_VCPU_RUN, kvm_vcpu, run);
+	BLANK();
+
+	OFFSET(KVM_ARCH_HSP, kvm_vcpu_arch, host_sp);
+	OFFSET(KVM_ARCH_HTP, kvm_vcpu_arch, host_tp);
+	OFFSET(KVM_ARCH_HPGD, kvm_vcpu_arch, host_pgd);
+	OFFSET(KVM_ARCH_HANDLE_EXIT, kvm_vcpu_arch, handle_exit);
+	OFFSET(KVM_ARCH_HEENTRY, kvm_vcpu_arch, host_eentry);
+	OFFSET(KVM_ARCH_GEENTRY, kvm_vcpu_arch, guest_eentry);
+	OFFSET(KVM_ARCH_GPC, kvm_vcpu_arch, pc);
+	OFFSET(KVM_ARCH_GGPR, kvm_vcpu_arch, gprs);
+	OFFSET(KVM_ARCH_HBADI, kvm_vcpu_arch, badi);
+	OFFSET(KVM_ARCH_HBADV, kvm_vcpu_arch, badv);
+	OFFSET(KVM_ARCH_HECFG, kvm_vcpu_arch, host_ecfg);
+	OFFSET(KVM_ARCH_HESTAT, kvm_vcpu_arch, host_estat);
+	OFFSET(KVM_ARCH_HPERCPU, kvm_vcpu_arch, host_percpu);
+
+	OFFSET(KVM_GPGD, kvm, arch.pgd);
+	BLANK();
+}
diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
new file mode 100644
index 0000000000..0ed9040307
--- /dev/null
+++ b/arch/loongarch/kvm/switch.S
@@ -0,0 +1,250 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#include <linux/linkage.h>
+#include <asm/asm.h>
+#include <asm/asmmacro.h>
+#include <asm/loongarch.h>
+#include <asm/regdef.h>
+#include <asm/stackframe.h>
+
+#define HGPR_OFFSET(x)		(PT_R0 + 8*x)
+#define GGPR_OFFSET(x)		(KVM_ARCH_GGPR + 8*x)
+
+.macro kvm_save_host_gpr base
+	.irp n,1,2,3,22,23,24,25,26,27,28,29,30,31
+	st.d	$r\n, \base, HGPR_OFFSET(\n)
+	.endr
+.endm
+
+.macro kvm_restore_host_gpr base
+	.irp n,1,2,3,22,23,24,25,26,27,28,29,30,31
+	ld.d	$r\n, \base, HGPR_OFFSET(\n)
+	.endr
+.endm
+
+/*
+ * Save and restore all GPRs except base register,
+ * and default value of base register is a2.
+ */
+.macro kvm_save_guest_gprs base
+	.irp n,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+	st.d	$r\n, \base, GGPR_OFFSET(\n)
+	.endr
+.endm
+
+.macro kvm_restore_guest_gprs base
+	.irp n,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+	ld.d	$r\n, \base, GGPR_OFFSET(\n)
+	.endr
+.endm
+
+/*
+ * Prepare switch to guest, save host regs and restore guest regs.
+ * a2: kvm_vcpu_arch, don't touch it until 'ertn'
+ * t0, t1: temp register
+ */
+.macro kvm_switch_to_guest
+	/* Set host ECFG.VS=0, all exceptions share one exception entry */
+	csrrd		t0, LOONGARCH_CSR_ECFG
+	bstrins.w	t0, zero, CSR_ECFG_VS_SHIFT_END, CSR_ECFG_VS_SHIFT
+	csrwr		t0, LOONGARCH_CSR_ECFG
+
+	/* Load up the new EENTRY */
+	ld.d	t0, a2, KVM_ARCH_GEENTRY
+	csrwr	t0, LOONGARCH_CSR_EENTRY
+
+	/* Set Guest ERA */
+	ld.d	t0, a2, KVM_ARCH_GPC
+	csrwr	t0, LOONGARCH_CSR_ERA
+
+	/* Save host PGDL */
+	csrrd	t0, LOONGARCH_CSR_PGDL
+	st.d	t0, a2, KVM_ARCH_HPGD
+
+	/* Switch to kvm */
+	ld.d	t1, a2, KVM_VCPU_KVM - KVM_VCPU_ARCH
+
+	/* Load guest PGDL */
+	li.w    t0, KVM_GPGD
+	ldx.d   t0, t1, t0
+	csrwr	t0, LOONGARCH_CSR_PGDL
+
+	/* Mix GID and RID */
+	csrrd		t1, LOONGARCH_CSR_GSTAT
+	bstrpick.w	t1, t1, CSR_GSTAT_GID_SHIFT_END, CSR_GSTAT_GID_SHIFT
+	csrrd		t0, LOONGARCH_CSR_GTLBC
+	bstrins.w	t0, t1, CSR_GTLBC_TGID_SHIFT_END, CSR_GTLBC_TGID_SHIFT
+	csrwr		t0, LOONGARCH_CSR_GTLBC
+
+	/*
+	 * Enable intr in root mode with future ertn so that host interrupt
+	 * can be responsed during VM runs
+	 * Guest CRMD comes from separate GCSR_CRMD register
+	 */
+	ori	t0, zero, CSR_PRMD_PIE
+	csrxchg	t0, t0,   LOONGARCH_CSR_PRMD
+
+	/* Set PVM bit to setup ertn to guest context */
+	ori	t0, zero, CSR_GSTAT_PVM
+	csrxchg	t0, t0,   LOONGARCH_CSR_GSTAT
+
+	/* Load Guest GPRs */
+	kvm_restore_guest_gprs a2
+	/* Load KVM_ARCH register */
+	ld.d	a2, a2,	(KVM_ARCH_GGPR + 8 * REG_A2)
+
+	ertn /* Switch to guest: GSTAT.PGM = 1, ERRCTL.ISERR = 0, TLBRPRMD.ISTLBR = 0 */
+.endm
+
+	/*
+	 * Exception entry for general exception from guest mode
+	 *  - IRQ is disabled
+	 *  - kernel privilege in root mode
+	 *  - page mode keep unchanged from previous PRMD in root mode
+	 *  - Fixme: tlb exception cannot happen since registers relative with TLB
+	 *  -        is still in guest mode, such as pgd table/vmid registers etc,
+	 *  -        will fix with hw page walk enabled in future
+	 * load kvm_vcpu from reserved CSR KVM_VCPU_KS, and save a2 to KVM_TEMP_KS
+	 */
+	.text
+	.cfi_sections	.debug_frame
+SYM_CODE_START(kvm_exc_entry)
+	csrwr	a2,   KVM_TEMP_KS
+	csrrd	a2,   KVM_VCPU_KS
+	addi.d	a2,   a2, KVM_VCPU_ARCH
+
+	/* After save GPRs, free to use any GPR */
+	kvm_save_guest_gprs a2
+	/* Save guest A2 */
+	csrrd	t0,	KVM_TEMP_KS
+	st.d	t0,	a2,	(KVM_ARCH_GGPR + 8 * REG_A2)
+
+	/* A2 is kvm_vcpu_arch, A1 is free to use */
+	csrrd	s1,   KVM_VCPU_KS
+	ld.d	s0,   s1, KVM_VCPU_RUN
+
+	csrrd	t0,   LOONGARCH_CSR_ESTAT
+	st.d	t0,   a2, KVM_ARCH_HESTAT
+	csrrd	t0,   LOONGARCH_CSR_ERA
+	st.d	t0,   a2, KVM_ARCH_GPC
+	csrrd	t0,   LOONGARCH_CSR_BADV
+	st.d	t0,   a2, KVM_ARCH_HBADV
+	csrrd	t0,   LOONGARCH_CSR_BADI
+	st.d	t0,   a2, KVM_ARCH_HBADI
+
+	/* Restore host ECFG.VS */
+	csrrd	t0, LOONGARCH_CSR_ECFG
+	ld.d	t1, a2, KVM_ARCH_HECFG
+	or	t0, t0, t1
+	csrwr	t0, LOONGARCH_CSR_ECFG
+
+	/* Restore host EENTRY */
+	ld.d	t0, a2, KVM_ARCH_HEENTRY
+	csrwr	t0, LOONGARCH_CSR_EENTRY
+
+	/* Restore host pgd table */
+	ld.d    t0, a2, KVM_ARCH_HPGD
+	csrwr   t0, LOONGARCH_CSR_PGDL
+
+	/*
+	 * Disable PGM bit to enter root mode by default with next ertn
+	 */
+	ori	t0, zero, CSR_GSTAT_PVM
+	csrxchg	zero, t0, LOONGARCH_CSR_GSTAT
+
+	/*
+	 * Clear GTLBC.TGID field
+	 *       0: for root  tlb update in future tlb instr
+	 *  others: for guest tlb update like gpa to hpa in future tlb instr
+	 */
+	csrrd	t0, LOONGARCH_CSR_GTLBC
+	bstrins.w	t0, zero, CSR_GTLBC_TGID_SHIFT_END, CSR_GTLBC_TGID_SHIFT
+	csrwr	t0, LOONGARCH_CSR_GTLBC
+	ld.d	tp, a2, KVM_ARCH_HTP
+	ld.d	sp, a2, KVM_ARCH_HSP
+	/* restore per cpu register */
+	ld.d	u0, a2, KVM_ARCH_HPERCPU
+	addi.d	sp, sp, -PT_SIZE
+
+	/* Prepare handle exception */
+	or	a0, s0, zero
+	or	a1, s1, zero
+	ld.d	t8, a2, KVM_ARCH_HANDLE_EXIT
+	jirl	ra, t8, 0
+
+	or	a2, s1, zero
+	addi.d	a2, a2, KVM_VCPU_ARCH
+
+	/* Resume host when ret <= 0 */
+	blez	a0, ret_to_host
+
+	/*
+         * Return to guest
+         * Save per cpu register again, maybe switched to another cpu
+         */
+	st.d	u0, a2, KVM_ARCH_HPERCPU
+
+	/* Save kvm_vcpu to kscratch */
+	csrwr	s1, KVM_VCPU_KS
+	kvm_switch_to_guest
+
+ret_to_host:
+	ld.d    a2, a2, KVM_ARCH_HSP
+	addi.d  a2, a2, -PT_SIZE
+	kvm_restore_host_gpr    a2
+	jr      ra
+
+SYM_INNER_LABEL(kvm_exc_entry_end, SYM_L_LOCAL)
+SYM_CODE_END(kvm_exc_entry)
+
+/*
+ * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu)
+ *
+ * @register_param:
+ *  a0: kvm_run* run
+ *  a1: kvm_vcpu* vcpu
+ */
+SYM_FUNC_START(kvm_enter_guest)
+	/* Allocate space in stack bottom */
+	addi.d	a2, sp, -PT_SIZE
+	/* Save host GPRs */
+	kvm_save_host_gpr a2
+
+	/* Save host CRMD, PRMD to stack */
+	csrrd	a3, LOONGARCH_CSR_CRMD
+	st.d	a3, a2, PT_CRMD
+	csrrd	a3, LOONGARCH_CSR_PRMD
+	st.d	a3, a2, PT_PRMD
+
+	addi.d	a2, a1, KVM_VCPU_ARCH
+	st.d	sp, a2, KVM_ARCH_HSP
+	st.d	tp, a2, KVM_ARCH_HTP
+	/* Save per cpu register */
+	st.d	u0, a2, KVM_ARCH_HPERCPU
+
+	/* Save kvm_vcpu to kscratch */
+	csrwr	a1, KVM_VCPU_KS
+	kvm_switch_to_guest
+SYM_INNER_LABEL(kvm_enter_guest_end, SYM_L_LOCAL)
+SYM_FUNC_END(kvm_enter_guest)
+
+SYM_FUNC_START(kvm_save_fpu)
+	fpu_save_csr	a0 t1
+	fpu_save_double a0 t1
+	fpu_save_cc	a0 t1 t2
+	jr              ra
+SYM_FUNC_END(kvm_save_fpu)
+
+SYM_FUNC_START(kvm_restore_fpu)
+	fpu_restore_double a0 t1
+	fpu_restore_csr    a0 t1 t2
+	fpu_restore_cc	   a0 t1 t2
+	jr                 ra
+SYM_FUNC_END(kvm_restore_fpu)
+
+	.section ".rodata"
+SYM_DATA(kvm_exception_size, .quad kvm_exc_entry_end - kvm_exc_entry)
+SYM_DATA(kvm_enter_guest_size, .quad kvm_enter_guest_end - kvm_enter_guest)
-- 
2.39.3


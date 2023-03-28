Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D88F6CBF2C
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 14:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjC1McQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 08:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbjC1Mbv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 08:31:51 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48363976C;
        Tue, 28 Mar 2023 05:31:36 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8BxIk4f3iJk0RkTAA--.29033S3;
        Tue, 28 Mar 2023 20:31:27 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxPL4X3iJku2cPAA--.12046S29;
        Tue, 28 Mar 2023 20:31:26 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PING PATCH v4 27/29] LoongArch: KVM: Implement vcpu world switch
Date:   Tue, 28 Mar 2023 20:31:17 +0800
Message-Id: <20230328123119.3649361-28-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
References: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxPL4X3iJku2cPAA--.12046S29
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW3Aw1DWF1fGrW7WF18Gw47XFb_yoWkXr4xpr
        98CrZYv3yjkrn3uFs7tFyj9r13XFWxXrWagrnrCrs5AryDGFWvqa40kFn8JFyUAw1xXF1F
        vF95tw40kFWDAw7anT9S1TB71UUUUbUqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b4AFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6x
        kF7I0E14v26F4UJVW0owAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAq
        jxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6c
        x26rWlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q
        6r43MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_WwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWDJVCq3wCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6x
        kF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7xREWSoJUUUUU==
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement loongarch vcpu world switch, including vcpu enter guest and
vcpu exit from guest, both operations need to save or restore the host
and guest registers.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kernel/asm-offsets.c |  32 +++
 arch/loongarch/kvm/switch.S         | 303 ++++++++++++++++++++++++++++
 2 files changed, 335 insertions(+)
 create mode 100644 arch/loongarch/kvm/switch.S

diff --git a/arch/loongarch/kernel/asm-offsets.c b/arch/loongarch/kernel/asm-offsets.c
index 4bdb203fc..655741c03 100644
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
@@ -272,3 +273,34 @@ void output_pbe_defines(void)
 	BLANK();
 }
 #endif
+
+void output_kvm_defines(void)
+{
+	COMMENT(" KVM/LOONGARCH Specific offsets. ");
+
+	OFFSET(VCPU_FCSR0, kvm_vcpu_arch, fpu.fcsr);
+	OFFSET(VCPU_FCC, kvm_vcpu_arch, fpu.fcc);
+	BLANK();
+
+	OFFSET(KVM_VCPU_ARCH, kvm_vcpu, arch);
+	OFFSET(KVM_VCPU_KVM, kvm_vcpu, kvm);
+	OFFSET(KVM_VCPU_RUN, kvm_vcpu, run);
+	BLANK();
+
+	OFFSET(KVM_ARCH_HSTACK, kvm_vcpu_arch, host_stack);
+	OFFSET(KVM_ARCH_HGP, kvm_vcpu_arch, host_gp);
+	OFFSET(KVM_ARCH_HANDLE_EXIT, kvm_vcpu_arch, handle_exit);
+	OFFSET(KVM_ARCH_HPGD, kvm_vcpu_arch, host_pgd);
+	OFFSET(KVM_ARCH_GEENTRY, kvm_vcpu_arch, guest_eentry);
+	OFFSET(KVM_ARCH_GPC, kvm_vcpu_arch, pc);
+	OFFSET(KVM_ARCH_GGPR, kvm_vcpu_arch, gprs);
+	OFFSET(KVM_ARCH_HESTAT, kvm_vcpu_arch, host_estat);
+	OFFSET(KVM_ARCH_HBADV, kvm_vcpu_arch, badv);
+	OFFSET(KVM_ARCH_HBADI, kvm_vcpu_arch, badi);
+	OFFSET(KVM_ARCH_HECFG, kvm_vcpu_arch, host_ecfg);
+	OFFSET(KVM_ARCH_HEENTRY, kvm_vcpu_arch, host_eentry);
+	OFFSET(KVM_ARCH_HPERCPU, kvm_vcpu_arch, host_percpu);
+
+	OFFSET(KVM_GPGD, kvm, arch.gpa_mm.pgd);
+	BLANK();
+}
diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
new file mode 100644
index 000000000..cc5192d3c
--- /dev/null
+++ b/arch/loongarch/kvm/switch.S
@@ -0,0 +1,303 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#include <linux/linkage.h>
+#include <asm/stackframe.h>
+#include <asm/asm.h>
+#include <asm/asmmacro.h>
+#include <asm/regdef.h>
+#include <asm/loongarch.h>
+#include <asm/export.h>
+
+#define PT_GPR_OFFSET(x)	(PT_R0 + 8*x)
+	.text
+
+.macro kvm_save_host_gpr base
+	.irp n,1,2,3,22,23,24,25,26,27,28,29,30,31
+	st.d	$r\n, \base, PT_GPR_OFFSET(\n)
+	.endr
+.endm
+
+.macro kvm_restore_host_gpr base
+	.irp n,1,2,3,22,23,24,25,26,27,28,29,30,31
+	ld.d	$r\n, \base, PT_GPR_OFFSET(\n)
+	.endr
+.endm
+
+/*
+ * prepare switch to guest
+ * @param:
+ *  KVM_ARCH: kvm_vcpu_arch, don't touch it until 'ertn'
+ *  GPRNUM: KVM_ARCH gpr number
+ *  tmp, tmp1: temp register
+ */
+.macro kvm_switch_to_guest tmp tmp1
+	/* set host excfg.VS=0, all exceptions share one exception entry */
+	csrrd	\tmp, LOONGARCH_CSR_ECFG
+	bstrins.w	\tmp, zero, CSR_ECFG_VS_SHIFT_END, CSR_ECFG_VS_SHIFT
+	csrwr	\tmp, LOONGARCH_CSR_ECFG
+
+	/* Load up the new EENTRY */
+	ld.d	\tmp, a2, KVM_ARCH_GEENTRY
+	csrwr	\tmp, LOONGARCH_CSR_EENTRY
+
+	/* Set Guest ERA */
+	ld.d	\tmp, a2, KVM_ARCH_GPC
+	csrwr	\tmp, LOONGARCH_CSR_ERA
+
+	/* Save host PGDL */
+	csrrd	\tmp, LOONGARCH_CSR_PGDL
+	st.d	\tmp, a2, KVM_ARCH_HPGD
+
+	/* Switch to kvm */
+	ld.d	\tmp1, a2, KVM_VCPU_KVM - KVM_VCPU_ARCH
+
+	/* Load guest PGDL */
+	lu12i.w \tmp, KVM_GPGD
+	srli.w \tmp, \tmp, 12
+	ldx.d  \tmp, \tmp1, \tmp
+	csrwr	\tmp, LOONGARCH_CSR_PGDL
+
+	/* Mix GID and RID */
+	csrrd	\tmp1, LOONGARCH_CSR_GSTAT
+	bstrpick.w	\tmp1, \tmp1, CSR_GSTAT_GID_SHIFT_END, CSR_GSTAT_GID_SHIFT
+	csrrd	\tmp, LOONGARCH_CSR_GTLBC
+	bstrins.w	\tmp, \tmp1, CSR_GTLBC_TGID_SHIFT_END, CSR_GTLBC_TGID_SHIFT
+	csrwr	\tmp, LOONGARCH_CSR_GTLBC
+
+	/*
+	 * Switch to guest:
+	 *  GSTAT.PGM = 1, ERRCTL.ISERR = 0, TLBRPRMD.ISTLBR = 0
+	 *  ertn
+	 */
+
+	/*
+	 * Enable intr in root mode with future ertn so that host interrupt
+	 * can be responsed during VM runs
+	 * guest crmd comes from separate gcsr_CRMD register
+	 */
+	ori	\tmp, zero, CSR_PRMD_PIE
+	csrxchg	\tmp, \tmp, LOONGARCH_CSR_PRMD
+
+	/* Set PVM bit to setup ertn to guest context */
+	ori	\tmp, zero, CSR_GSTAT_PVM
+	csrxchg	\tmp, \tmp, LOONGARCH_CSR_GSTAT
+
+	/* Load Guest gprs */
+	ld.d	ra,	a2,	(KVM_ARCH_GGPR + 8 * REG_RA)
+	ld.d	tp,	a2,	(KVM_ARCH_GGPR + 8 * REG_TP)
+	ld.d	sp,	a2,	(KVM_ARCH_GGPR + 8 * REG_SP)
+	ld.d	a0,	a2,	(KVM_ARCH_GGPR + 8 * REG_A0)
+	ld.d	a1,	a2,	(KVM_ARCH_GGPR + 8 * REG_A1)
+	ld.d	a3,	a2,	(KVM_ARCH_GGPR + 8 * REG_A3)
+	ld.d	a4,	a2,	(KVM_ARCH_GGPR + 8 * REG_A4)
+	ld.d	a5,	a2,	(KVM_ARCH_GGPR + 8 * REG_A5)
+	ld.d	a6,	a2,	(KVM_ARCH_GGPR + 8 * REG_A6)
+	ld.d	a7,	a2,	(KVM_ARCH_GGPR + 8 * REG_A7)
+	ld.d	t0,	a2,	(KVM_ARCH_GGPR + 8 * REG_T0)
+	ld.d	t1,	a2,	(KVM_ARCH_GGPR + 8 * REG_T1)
+	ld.d	t2,	a2,	(KVM_ARCH_GGPR + 8 * REG_T2)
+	ld.d	t3,	a2,	(KVM_ARCH_GGPR + 8 * REG_T3)
+	ld.d	t4,	a2,	(KVM_ARCH_GGPR + 8 * REG_T4)
+	ld.d	t5,	a2,	(KVM_ARCH_GGPR + 8 * REG_T5)
+	ld.d	t6,	a2,	(KVM_ARCH_GGPR + 8 * REG_T6)
+	ld.d	t7,	a2,	(KVM_ARCH_GGPR + 8 * REG_T7)
+	ld.d	t8,	a2,	(KVM_ARCH_GGPR + 8 * REG_T8)
+	ld.d	u0,	a2,	(KVM_ARCH_GGPR + 8 * REG_U0)
+	ld.d	fp,	a2,	(KVM_ARCH_GGPR + 8 * REG_FP)
+	ld.d	s0,	a2,	(KVM_ARCH_GGPR + 8 * REG_S0)
+	ld.d	s1,	a2,	(KVM_ARCH_GGPR + 8 * REG_S1)
+	ld.d	s2,	a2,	(KVM_ARCH_GGPR + 8 * REG_S2)
+	ld.d	s3,	a2,	(KVM_ARCH_GGPR + 8 * REG_S3)
+	ld.d	s4,	a2,	(KVM_ARCH_GGPR + 8 * REG_S4)
+	ld.d	s5,	a2,	(KVM_ARCH_GGPR + 8 * REG_S5)
+	ld.d	s6,	a2,	(KVM_ARCH_GGPR + 8 * REG_S6)
+	ld.d	s7,	a2,	(KVM_ARCH_GGPR + 8 * REG_S7)
+	ld.d	s8,	a2,	(KVM_ARCH_GGPR + 8 * REG_S8)
+	/* Load KVM_ARCH register */
+	ld.d	a2,	a2,	(KVM_ARCH_GGPR + 8 * REG_A2)
+
+	ertn
+.endm
+
+	/*
+	 * exception entry for general exception from guest mode
+	 *  - IRQ is disabled
+	 *  - kernel privilege in root mode
+	 *  - page mode keep unchanged from previous prmd in root mode
+	 *  - Fixme: tlb exception cannot happen since registers relative with TLB
+	 *  -        is still in guest mode, such as pgd table/vmid registers etc,
+	 *  -        will fix with hw page walk enabled in future
+	 * load kvm_vcpu from reserved CSR KVM_VCPU_KS, and save a2 to KVM_TEMP_KS
+	 */
+	.section	.text
+	.cfi_sections	.debug_frame
+SYM_CODE_START(kvm_vector_entry)
+	csrwr	a2,   KVM_TEMP_KS
+	csrrd	a2,   KVM_VCPU_KS
+	addi.d	a2,   a2, KVM_VCPU_ARCH
+
+	/* After save gprs, free to use any gpr */
+	st.d	ra,	a2,	(KVM_ARCH_GGPR + 8 * REG_RA)
+	st.d	tp,	a2,	(KVM_ARCH_GGPR + 8 * REG_TP)
+	st.d	sp,	a2,	(KVM_ARCH_GGPR + 8 * REG_SP)
+	st.d	a0,	a2,	(KVM_ARCH_GGPR + 8 * REG_A0)
+	st.d	a1,	a2,	(KVM_ARCH_GGPR + 8 * REG_A1)
+	st.d	a3,	a2,	(KVM_ARCH_GGPR + 8 * REG_A3)
+	st.d	a4,	a2,	(KVM_ARCH_GGPR + 8 * REG_A4)
+	st.d	a5,	a2,	(KVM_ARCH_GGPR + 8 * REG_A5)
+	st.d	a6,	a2,	(KVM_ARCH_GGPR + 8 * REG_A6)
+	st.d	a7,	a2,	(KVM_ARCH_GGPR + 8 * REG_A7)
+	st.d	t0,	a2,	(KVM_ARCH_GGPR + 8 * REG_T0)
+	st.d	t1,	a2,	(KVM_ARCH_GGPR + 8 * REG_T1)
+	st.d	t2,	a2,	(KVM_ARCH_GGPR + 8 * REG_T2)
+	st.d	t3,	a2,	(KVM_ARCH_GGPR + 8 * REG_T3)
+	st.d	t4,	a2,	(KVM_ARCH_GGPR + 8 * REG_T4)
+	st.d	t5,	a2,	(KVM_ARCH_GGPR + 8 * REG_T5)
+	st.d	t6,	a2,	(KVM_ARCH_GGPR + 8 * REG_T6)
+	st.d	t7,	a2,	(KVM_ARCH_GGPR + 8 * REG_T7)
+	st.d	t8,	a2,	(KVM_ARCH_GGPR + 8 * REG_T8)
+	st.d	u0,	a2,	(KVM_ARCH_GGPR + 8 * REG_U0)
+	st.d	fp,	a2,	(KVM_ARCH_GGPR + 8 * REG_FP)
+	st.d	s0,	a2,	(KVM_ARCH_GGPR + 8 * REG_S0)
+	st.d	s1,	a2,	(KVM_ARCH_GGPR + 8 * REG_S1)
+	st.d	s2,	a2,	(KVM_ARCH_GGPR + 8 * REG_S2)
+	st.d	s3,	a2,	(KVM_ARCH_GGPR + 8 * REG_S3)
+	st.d	s4,	a2,	(KVM_ARCH_GGPR + 8 * REG_S4)
+	st.d	s5,	a2,	(KVM_ARCH_GGPR + 8 * REG_S5)
+	st.d	s6,	a2,	(KVM_ARCH_GGPR + 8 * REG_S6)
+	st.d	s7,	a2,	(KVM_ARCH_GGPR + 8 * REG_S7)
+	st.d	s8,	a2,	(KVM_ARCH_GGPR + 8 * REG_S8)
+	/* Save guest a2 */
+	csrrd	t0,	KVM_TEMP_KS
+	st.d	t0,	a2,	(KVM_ARCH_GGPR + 8 * REG_A2)
+
+	/* a2: kvm_vcpu_arch, a1 is free to use */
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
+	/* Restore host excfg.VS */
+	csrrd	t0, LOONGARCH_CSR_ECFG
+	ld.d	t1, a2, KVM_ARCH_HECFG
+	or	t0, t0, t1
+	csrwr	t0, LOONGARCH_CSR_ECFG
+
+	/* Restore host eentry */
+	ld.d	t0, a2, KVM_ARCH_HEENTRY
+	csrwr	t0, LOONGARCH_CSR_EENTRY
+
+	/* restore host pgd table */
+	ld.d    t0, a2, KVM_ARCH_HPGD
+	csrwr   t0, LOONGARCH_CSR_PGDL
+
+	/*
+	 * Disable PGM bit to enter root mode by default with next ertn
+	 */
+	ori	t0, zero, CSR_GSTAT_PVM
+	csrxchg	zero, t0, LOONGARCH_CSR_GSTAT
+	/*
+	 * Clear GTLBC.TGID field
+	 *       0: for root  tlb update in future tlb instr
+	 *  others: for guest tlb update like gpa to hpa in future tlb instr
+	 */
+	csrrd	t0, LOONGARCH_CSR_GTLBC
+	bstrins.w	t0, zero, CSR_GTLBC_TGID_SHIFT_END, CSR_GTLBC_TGID_SHIFT
+	csrwr	t0, LOONGARCH_CSR_GTLBC
+	ld.d	tp, a2, KVM_ARCH_HGP
+	ld.d	sp, a2, KVM_ARCH_HSTACK
+	/* restore per cpu register */
+	ld.d	u0, a2, KVM_ARCH_HPERCPU
+	addi.d	sp, sp, -PT_SIZE
+
+	/* Prepare handle exception */
+	or	a0, s0, zero
+	or	a1, s1, zero
+	ld.d	t8, a2, KVM_ARCH_HANDLE_EXIT
+	jirl	ra,t8, 0
+
+	or	a2, s1, zero
+	addi.d	a2, a2, KVM_VCPU_ARCH
+
+	/* resume host when ret <= 0 */
+	bge	zero, a0, ret_to_host
+
+	/*
+         * return to guest
+         * save per cpu register again, maybe switched to another cpu
+         */
+	st.d	u0, a2, KVM_ARCH_HPERCPU
+
+	/* Save kvm_vcpu to kscratch */
+	csrwr	s1, KVM_VCPU_KS
+	kvm_switch_to_guest t0 t1
+
+ret_to_host:
+	ld.d    a2, a2, KVM_ARCH_HSTACK
+	addi.d  a2, a2, -PT_SIZE
+	kvm_restore_host_gpr    a2
+	jirl    zero, ra, 0
+SYM_CODE_END(kvm_vector_entry)
+kvm_vector_entry_end:
+
+/*
+ * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu)
+ *
+ * @register_param:
+ *  a0: kvm_run* run
+ *  a1: kvm_vcpu* vcpu
+ */
+SYM_FUNC_START(kvm_enter_guest)
+	/* allocate space in stack bottom */
+	addi.d	a2, sp, -PT_SIZE
+	/* save host gprs */
+	kvm_save_host_gpr a2
+
+	/* save host crmd,prmd csr to stack */
+	csrrd	a3, LOONGARCH_CSR_CRMD
+	st.d	a3, a2, PT_CRMD
+	csrrd	a3, LOONGARCH_CSR_PRMD
+	st.d	a3, a2, PT_PRMD
+
+	addi.d	a2, a1, KVM_VCPU_ARCH
+	st.d	sp, a2, KVM_ARCH_HSTACK
+	st.d	tp, a2, KVM_ARCH_HGP
+	/* Save per cpu register */
+	st.d	u0, a2, KVM_ARCH_HPERCPU
+
+	/* Save kvm_vcpu to kscratch */
+	csrwr	a1, KVM_VCPU_KS
+	kvm_switch_to_guest	t0 t1
+SYM_FUNC_END(kvm_enter_guest)
+kvm_enter_guest_end:
+
+	.section ".rodata"
+SYM_DATA(kvm_vector_size,
+		.quad kvm_vector_entry_end - kvm_vector_entry)
+SYM_DATA(kvm_enter_guest_size,
+		.quad kvm_enter_guest_end - kvm_enter_guest)
+
+
+SYM_FUNC_START(kvm_save_fpu)
+	fpu_save_csr	a0 t1
+	fpu_save_double a0 t1
+	fpu_save_cc	a0 t1 t2
+	jirl    zero, ra, 0
+SYM_FUNC_END(kvm_save_fpu)
+
+SYM_FUNC_START(kvm_restore_fpu)
+	fpu_restore_double a0 t1
+	fpu_restore_csr    a0 t1
+	fpu_restore_cc	   a0 t1 t2
+	jirl    zero, ra, 0
+SYM_FUNC_END(kvm_restore_fpu)
-- 
2.31.1


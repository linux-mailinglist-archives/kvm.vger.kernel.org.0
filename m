Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145A66956F4
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 03:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjBNC53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 21:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbjBNC5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 21:57:03 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D244A18AB3;
        Mon, 13 Feb 2023 18:57:00 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Cxidl7+Opj5FcAAA--.939S3;
        Tue, 14 Feb 2023 10:56:59 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axeb1w+OpjmZwyAA--.28802S24;
        Tue, 14 Feb 2023 10:56:57 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH v1 22/24] LoongArch: KVM: Implement vcpu world switch
Date:   Tue, 14 Feb 2023 10:56:46 +0800
Message-Id: <20230214025648.1898508-23-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230214025648.1898508-1-zhaotianrui@loongson.cn>
References: <20230214025648.1898508-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axeb1w+OpjmZwyAA--.28802S24
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW3tFW3uw15Zr15Xr18tw4kCrg_yoWkZFyxp3
        48CrZavayUKrn7uFs2qryj9r17JF4fu3ySgwnrWrs5XryDWFW0v3Wvkr1DGa4UJw48XF1S
        vFyrJw47CrZrAwUanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bxxFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aV
        CY1x0267AKxVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487
        Mc804VCY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1s
        IEY20_WwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_
        JF0_Jw1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VWrMxC20s026xCaFVCjc4
        AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
        r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
        IIjxv20xvE14v26w1j6s0DMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE
        42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8Jr0_Cr1UMIIF0xvEx4A2js
        IEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvj4RKpBTUUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 arch/loongarch/kvm/switch.S         | 327 ++++++++++++++++++++++++++++
 2 files changed, 359 insertions(+)
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
index 000000000..c0b8062ac
--- /dev/null
+++ b/arch/loongarch/kvm/switch.S
@@ -0,0 +1,327 @@
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
+#define RESUME_HOST	(1 << 1)
+
+#define PT_GPR_OFFSET(x)	(PT_R0 + 8*x)
+#define CONFIG_GUEST_CRMD	((1 << CSR_CRMD_DACM_SHIFT) | \
+				 (1 << CSR_CRMD_DACF_SHIFT) | \
+				 CSR_CRMD_PG | PLV_KERN)
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
+.macro kvm_switch_to_guest KVM_ARCH GPRNUM tmp tmp1
+	/* set host excfg.VS=0, all exceptions share one exception entry */
+	csrrd	\tmp, LOONGARCH_CSR_ECFG
+	bstrins.w	\tmp, zero, CSR_ECFG_VS_SHIFT_END, CSR_ECFG_VS_SHIFT
+	csrwr	\tmp, LOONGARCH_CSR_ECFG
+
+	/* Load up the new EENTRY */
+	ld.d	\tmp, \KVM_ARCH, KVM_ARCH_GEENTRY
+	csrwr	\tmp, LOONGARCH_CSR_EENTRY
+
+	/* Set Guest ERA */
+	ld.d	\tmp, \KVM_ARCH, KVM_ARCH_GPC
+	csrwr	\tmp, LOONGARCH_CSR_ERA
+
+	/* Save host PGDL */
+	csrrd	\tmp, LOONGARCH_CSR_PGDL
+	st.d	\tmp, \KVM_ARCH, KVM_ARCH_HPGD
+
+	/* Switch to kvm */
+	ld.d	\tmp1, \KVM_ARCH, KVM_VCPU_KVM - KVM_VCPU_ARCH
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
+	/* Prepare enable Intr before enter guest */
+	ori	\tmp, zero, CSR_PRMD_PIE
+	csrxchg	\tmp, \tmp, LOONGARCH_CSR_PRMD
+
+	/* Set PVM bit to setup ertn to guest context */
+	ori	\tmp, zero, CSR_GSTAT_PVM
+	csrxchg	\tmp, \tmp, LOONGARCH_CSR_GSTAT
+
+	/* Load Guest gprs */
+	ld.d    $r1,   \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 1)
+	ld.d    $r2,   \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 2)
+	ld.d    $r3,   \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 3)
+	ld.d    $r4,   \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 4)
+	ld.d    $r5,   \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 5)
+	ld.d    $r7,   \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 7)
+	ld.d    $r8,   \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 8)
+	ld.d    $r9,   \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 9)
+	ld.d    $r10,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 10)
+	ld.d    $r11,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 11)
+	ld.d    $r12,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 12)
+	ld.d    $r13,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 13)
+	ld.d    $r14,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 14)
+	ld.d    $r15,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 15)
+	ld.d    $r16,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 16)
+	ld.d    $r17,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 17)
+	ld.d    $r18,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 18)
+	ld.d    $r19,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 19)
+	ld.d    $r20,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 20)
+	ld.d    $r21,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 21)
+	ld.d    $r22,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 22)
+	ld.d    $r23,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 23)
+	ld.d    $r24,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 24)
+	ld.d    $r25,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 25)
+	ld.d    $r26,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 26)
+	ld.d    $r27,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 27)
+	ld.d    $r28,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 28)
+	ld.d    $r29,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 29)
+	ld.d    $r30,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 30)
+	ld.d    $r31,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 31)
+	/* Load KVM_ARCH register */
+	ld.d	\KVM_ARCH, \KVM_ARCH, (KVM_ARCH_GGPR + 8 * \GPRNUM)
+
+	ertn
+.endm
+
+/* load kvm_vcpu to a2 and store a1 for free use */
+	.section	.text
+	.cfi_sections	.debug_frame
+SYM_CODE_START(kvm_vector_entry)
+	csrwr	a2,   KVM_TEMP_KS
+	csrrd	a2,   KVM_VCPU_KS
+	addi.d	a2,   a2, KVM_VCPU_ARCH
+
+	/* After save gprs, free to use any gpr */
+        st.d    $r1,  a2, (KVM_ARCH_GGPR + 8 * 1)
+        st.d    $r2,  a2, (KVM_ARCH_GGPR + 8 * 2)
+        st.d    $r3,  a2, (KVM_ARCH_GGPR + 8 * 3)
+        st.d    $r4,  a2, (KVM_ARCH_GGPR + 8 * 4)
+        st.d    $r5,  a2, (KVM_ARCH_GGPR + 8 * 5)
+        st.d    $r7,  a2, (KVM_ARCH_GGPR + 8 * 7)
+        st.d    $r8,  a2, (KVM_ARCH_GGPR + 8 * 8)
+        st.d    $r9,  a2, (KVM_ARCH_GGPR + 8 * 9)
+        st.d    $r10, a2, (KVM_ARCH_GGPR + 8 * 10)
+        st.d    $r11, a2, (KVM_ARCH_GGPR + 8 * 11)
+        st.d    $r12, a2, (KVM_ARCH_GGPR + 8 * 12)
+        st.d    $r13, a2, (KVM_ARCH_GGPR + 8 * 13)
+        st.d    $r14, a2, (KVM_ARCH_GGPR + 8 * 14)
+        st.d    $r15, a2, (KVM_ARCH_GGPR + 8 * 15)
+        st.d    $r16, a2, (KVM_ARCH_GGPR + 8 * 16)
+        st.d    $r17, a2, (KVM_ARCH_GGPR + 8 * 17)
+        st.d    $r18, a2, (KVM_ARCH_GGPR + 8 * 18)
+        st.d    $r19, a2, (KVM_ARCH_GGPR + 8 * 19)
+        st.d    $r20, a2, (KVM_ARCH_GGPR + 8 * 20)
+        st.d    $r21, a2, (KVM_ARCH_GGPR + 8 * 21)
+        st.d    $r22, a2, (KVM_ARCH_GGPR + 8 * 22)
+        st.d    $r23, a2, (KVM_ARCH_GGPR + 8 * 23)
+        st.d    $r24, a2, (KVM_ARCH_GGPR + 8 * 24)
+        st.d    $r25, a2, (KVM_ARCH_GGPR + 8 * 25)
+        st.d    $r26, a2, (KVM_ARCH_GGPR + 8 * 26)
+        st.d    $r27, a2, (KVM_ARCH_GGPR + 8 * 27)
+        st.d    $r28, a2, (KVM_ARCH_GGPR + 8 * 28)
+        st.d    $r29, a2, (KVM_ARCH_GGPR + 8 * 29)
+        st.d    $r30, a2, (KVM_ARCH_GGPR + 8 * 30)
+        st.d    $r31, a2, (KVM_ARCH_GGPR + 8 * 31)
+	/* Save guest a2 */
+	csrrd	t0,   KVM_TEMP_KS
+	st.d	t0,   a2, (KVM_ARCH_GGPR + 8 * REG_A2)
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
+#if defined(CONFIG_CPU_HAS_FPU)
+	/* Save FPU context */
+	csrrd       t0, LOONGARCH_CSR_EUEN
+	ori         t1, zero, CSR_EUEN_FPEN
+	and         t2, t0, t1
+	beqz        t2, 1f
+	movfcsr2gr  t3, fcsr0
+	st.d        t3,	a2, VCPU_FCSR0
+
+	movcf2gr    t3, $fcc0
+	or          t2, t3, zero
+	movcf2gr    t3, $fcc1
+	bstrins.d   t2, t3, 0xf, 0x8
+	movcf2gr    t3, $fcc2
+	bstrins.d   t2, t3, 0x17, 0x10
+	movcf2gr    t3, $fcc3
+	bstrins.d   t2, t3, 0x1f, 0x18
+	movcf2gr    t3, $fcc4
+	bstrins.d   t2, t3, 0x27, 0x20
+	movcf2gr    t3, $fcc5
+	bstrins.d   t2, t3, 0x2f, 0x28
+	movcf2gr    t3, $fcc6
+	bstrins.d   t2, t3, 0x37, 0x30
+	movcf2gr    t3, $fcc7
+	bstrins.d   t2, t3, 0x3f, 0x38
+	st.d        t2, a2, VCPU_FCC
+	movgr2fcsr  fcsr0, zero
+1:
+#endif
+	ld.d    t0, a2, KVM_ARCH_HPGD
+	csrwr   t0, LOONGARCH_CSR_PGDL
+
+	/* Disable PVM bit for keeping from into guest */
+	ori	t0, zero, CSR_GSTAT_PVM
+	csrxchg	zero, t0, LOONGARCH_CSR_GSTAT
+	/* Clear GTLBC.TGID field */
+	csrrd	t0, LOONGARCH_CSR_GTLBC
+	bstrins.w	t0, zero, CSR_GTLBC_TGID_SHIFT_END, CSR_GTLBC_TGID_SHIFT
+	csrwr	t0, LOONGARCH_CSR_GTLBC
+	/* Enable Address Map mode */
+	ori	t0, zero, CONFIG_GUEST_CRMD
+	csrwr	t0, LOONGARCH_CSR_CRMD
+	ld.d	tp, a2, KVM_ARCH_HGP
+	ld.d	sp, a2, KVM_ARCH_HSTACK
+	/* restore per cpu register */
+	ld.d	$r21, a2, KVM_ARCH_HPERCPU
+	addi.d	sp, sp, -PT_SIZE
+
+	/* Prepare handle exception */
+	or	a0, s0, zero
+	or	a1, s1, zero
+	ld.d	t8, a2, KVM_ARCH_HANDLE_EXIT
+	jirl	ra,t8, 0
+
+	ori	t0, zero, CSR_CRMD_IE
+	csrxchg	zero, t0, LOONGARCH_CSR_CRMD
+	or	a2, s1, zero
+	addi.d	a2, a2, KVM_VCPU_ARCH
+
+	andi	t0, a0, RESUME_HOST
+	bnez	t0, ret_to_host
+
+	/*
+         * return to guest
+         * save per cpu register again, maybe switched to another cpu
+         */
+	st.d	$r21, a2, KVM_ARCH_HPERCPU
+
+	/* Save kvm_vcpu to kscratch */
+	csrwr	s1, KVM_VCPU_KS
+	kvm_switch_to_guest a2 REG_A2 t0 t1
+
+ret_to_host:
+	ld.d    a2, a2, KVM_ARCH_HSTACK
+	addi.d  a2, a2, -PT_SIZE
+	srai.w  a3, a0, 2
+	or      a0, a3, zero
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
+	st.d	$r21, a2, KVM_ARCH_HPERCPU
+
+	/* Save kvm_vcpu to kscratch */
+	csrwr	a1, KVM_VCPU_KS
+	kvm_switch_to_guest	a2 REG_A2 t0 t1
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
+	fpu_save_double a0 t1
+	jirl    zero, ra, 0
+SYM_FUNC_END(kvm_save_fpu)
+
+SYM_FUNC_START(kvm_restore_fpu)
+	fpu_restore_double a0 t1
+	jirl    zero, ra, 0
+SYM_FUNC_END(kvm_restore_fpu)
+
+SYM_FUNC_START(kvm_restore_fcsr)
+	fpu_restore_csr a0 t1
+	fpu_restore_cc  a0 t1 t2
+
+	jirl    zero, ra, 0
+SYM_FUNC_END(kvm_restore_fcsr)
-- 
2.31.1


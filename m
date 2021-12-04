Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943F9468126
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 01:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383694AbhLDAY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 19:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383658AbhLDAYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 19:24:23 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5590BC061353
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 16:20:59 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 8so4391932pfo.4
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 16:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pZO7Ldd+cXHk/e9bMEw/H3eaZYc3yYcxodWBMzHuUs0=;
        b=fOgBwC2KuwZdgBoNVMEWnAcjp/2bYrmo1TuJE0MBWbMLad1y3gV/yceepwh+NegFv6
         FUKwd+LIpMbFM5a6cbgJyLc6T2O/TjMYyEuhRo2qRMDAdVgiQbd7XXbunN2Bh9tPDVCc
         3TbulKPC/+k9togVKYEIASP9QJTF2pEMM6AKM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pZO7Ldd+cXHk/e9bMEw/H3eaZYc3yYcxodWBMzHuUs0=;
        b=ic7fArY6v/ToHjvaJVQ10isLy1jOS3WZH8bWD97XRWaUqnu15Vf88VqjX840ZuQCDR
         +S5mKQpbVrZUEYz1ZoCgCGzdRnbO1o76hGQAq3APOPsLXG2V2LVCaT1teCRrGzJZctHx
         EryQflPET5/GDfxCpYXVFtyY7QHKRQPeogFMMgrrH0x+wMzHPGqfTA+IdLjFO/QR42CL
         /psntm/xdzOlUyBpztDuHPx/Gp4UCXDxFFceRG4q/nXEixMFCYfmyN1kt+6vMEIdV0K6
         ZCjalAq5MnzsU8X+qUvRummo+jftoeqc9SPU0DSZBjfg05S8UqHxLnr9DpaLXdiqfD2p
         6dxA==
X-Gm-Message-State: AOAM532aEyywMIGaW0uPScw8oiH1+FK1qmzw3o/38VrcM92j+lTWPWw3
        cdEIxa56QlVUqeurIjJg8NYm
X-Google-Smtp-Source: ABdhPJzccrXHO6GmxNUtIknUQU5fr0ALmBvIaIlNiV1E7mc3CSEhi2beep0qOj5jwADq54zB1pZ21Q==
X-Received: by 2002:aa7:93c4:0:b0:49f:a7f5:7f5a with SMTP id y4-20020aa793c4000000b0049fa7f57f5amr22495213pff.8.1638577258691;
        Fri, 03 Dec 2021 16:20:58 -0800 (PST)
Received: from fedora.ba.rivosinc.com (99-13-229-45.lightspeed.snjsca.sbcglobal.net. [99.13.229.45])
        by smtp.gmail.com with ESMTPSA id r6sm3272402pjg.21.2021.12.03.16.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 16:20:58 -0800 (PST)
From:   Atish Patra <atishp@atishpatra.org>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Anup Patel <anup.patel@wdc.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Ingo Molnar <mingo@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        Nanyong Sun <sunnanyong@huawei.com>,
        Nick Kossifidis <mick@ics.forth.gr>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Pekka Enberg <penberg@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>
Subject: [RFC 6/6] RISC-V: Do not use cpumask data structure for hartid bitmap
Date:   Fri,  3 Dec 2021 16:20:38 -0800
Message-Id: <20211204002038.113653-7-atishp@atishpatra.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211204002038.113653-1-atishp@atishpatra.org>
References: <20211204002038.113653-1-atishp@atishpatra.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atishp@rivosinc.com>

Currently, SBI APIs accept a hartmask that is generated from struct cpumask.
Cpumask data structure can hold upto NR_CPUs value. Thus, it is not
the correct data structure for hartids as it can be higher than NR_CPUs
for platforms with sparse or discontguous hartids.

Remove all association between hartid mask and struct cpumask.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h      |  19 +--
 arch/riscv/include/asm/smp.h      |   8 --
 arch/riscv/kernel/sbi.c           | 189 +++++++++++++++++-------------
 arch/riscv/kernel/smp.c           |  10 --
 arch/riscv/kernel/smpboot.c       |   2 +-
 arch/riscv/kvm/mmu.c              |   4 +-
 arch/riscv/kvm/vcpu_sbi_replace.c |  11 +-
 arch/riscv/kvm/vcpu_sbi_v01.c     |  11 +-
 arch/riscv/kvm/vmid.c             |   4 +-
 arch/riscv/mm/cacheflush.c        |   5 +-
 arch/riscv/mm/tlbflush.c          |   9 +-
 11 files changed, 130 insertions(+), 142 deletions(-)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 9c46dd3ff4a2..94abf4c300e4 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -8,6 +8,7 @@
 #define _ASM_RISCV_SBI_H
 
 #include <linux/types.h>
+#include <linux/cpumask.h>
 
 #ifdef CONFIG_RISCV_SBI
 enum sbi_ext_id {
@@ -112,27 +113,27 @@ long sbi_get_mimpid(void);
 void sbi_set_timer(uint64_t stime_value);
 void sbi_shutdown(void);
 void sbi_clear_ipi(void);
-int sbi_send_ipi(const unsigned long *hart_mask);
-int sbi_remote_fence_i(const unsigned long *hart_mask);
-int sbi_remote_sfence_vma(const unsigned long *hart_mask,
+int sbi_send_ipi(const struct cpumask *cpu_mask);
+int sbi_remote_fence_i(const struct cpumask *cpu_mask);
+int sbi_remote_sfence_vma(const struct cpumask *cpu_mask,
 			   unsigned long start,
 			   unsigned long size);
 
-int sbi_remote_sfence_vma_asid(const unsigned long *hart_mask,
+int sbi_remote_sfence_vma_asid(const struct cpumask *cpu_mask,
 				unsigned long start,
 				unsigned long size,
 				unsigned long asid);
-int sbi_remote_hfence_gvma(const unsigned long *hart_mask,
+int sbi_remote_hfence_gvma(const struct cpumask *cpu_mask,
 			   unsigned long start,
 			   unsigned long size);
-int sbi_remote_hfence_gvma_vmid(const unsigned long *hart_mask,
+int sbi_remote_hfence_gvma_vmid(const struct cpumask *cpu_mask,
 				unsigned long start,
 				unsigned long size,
 				unsigned long vmid);
-int sbi_remote_hfence_vvma(const unsigned long *hart_mask,
+int sbi_remote_hfence_vvma(const struct cpumask *cpu_mask,
 			   unsigned long start,
 			   unsigned long size);
-int sbi_remote_hfence_vvma_asid(const unsigned long *hart_mask,
+int sbi_remote_hfence_vvma_asid(const struct cpumask *cpu_mask,
 				unsigned long start,
 				unsigned long size,
 				unsigned long asid);
@@ -159,7 +160,7 @@ static inline unsigned long sbi_minor_version(void)
 
 int sbi_err_map_linux_errno(int err);
 #else /* CONFIG_RISCV_SBI */
-static inline int sbi_remote_fence_i(const unsigned long *hart_mask) { return -1; }
+static inline int sbi_remote_fence_i(const struct cpumask *cpu_mask) { return -1; }
 static inline void sbi_init(void) {}
 #endif /* CONFIG_RISCV_SBI */
 #endif /* _ASM_RISCV_SBI_H */
diff --git a/arch/riscv/include/asm/smp.h b/arch/riscv/include/asm/smp.h
index a7d2811f3536..e07ecfb5d925 100644
--- a/arch/riscv/include/asm/smp.h
+++ b/arch/riscv/include/asm/smp.h
@@ -43,7 +43,6 @@ void arch_send_call_function_ipi_mask(struct cpumask *mask);
 void arch_send_call_function_single_ipi(int cpu);
 
 int riscv_hartid_to_cpuid(int hartid);
-void riscv_cpuid_to_hartid_mask(const struct cpumask *in, struct cpumask *out);
 
 /* Set custom IPI operations */
 void riscv_set_ipi_ops(const struct riscv_ipi_ops *ops);
@@ -85,13 +84,6 @@ static inline unsigned long cpuid_to_hartid_map(int cpu)
 	return boot_cpu_hartid;
 }
 
-static inline void riscv_cpuid_to_hartid_mask(const struct cpumask *in,
-					      struct cpumask *out)
-{
-	cpumask_clear(out);
-	cpumask_set_cpu(boot_cpu_hartid, out);
-}
-
 static inline void riscv_set_ipi_ops(const struct riscv_ipi_ops *ops)
 {
 }
diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index 7402a417f38e..2438d6fdb788 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -15,8 +15,8 @@ unsigned long sbi_spec_version __ro_after_init = SBI_SPEC_VERSION_DEFAULT;
 EXPORT_SYMBOL(sbi_spec_version);
 
 static void (*__sbi_set_timer)(uint64_t stime) __ro_after_init;
-static int (*__sbi_send_ipi)(const unsigned long *hart_mask) __ro_after_init;
-static int (*__sbi_rfence)(int fid, const unsigned long *hart_mask,
+static int (*__sbi_send_ipi)(const struct cpumask *cpu_mask) __ro_after_init;
+static int (*__sbi_rfence)(int fid, const struct cpumask *cpu_mask,
 			   unsigned long start, unsigned long size,
 			   unsigned long arg4, unsigned long arg5) __ro_after_init;
 
@@ -66,6 +66,30 @@ int sbi_err_map_linux_errno(int err)
 EXPORT_SYMBOL(sbi_err_map_linux_errno);
 
 #ifdef CONFIG_RISCV_SBI_V01
+static unsigned long __sbi_v01_cpumask_to_hartmask(const struct cpumask *cpu_mask)
+{
+	unsigned long cpuid, hartid;
+	unsigned long hmask = 0;
+
+	/*
+	 * There is no maximum hartid concept in RISC-V and NR_CPUS must not be
+	 * associated with hartid. As SBI v0.1 is only kept for backward compatibility
+	 * and will be removed in the future, there is no point in supporting hartid
+	 * greater than BITS_PER_LONG (32 for RV32 and 64 for RV64). Ideally, SBI v0.2
+	 * should be used for platforms with hartid greater than BITS_PER_LONG.
+	 */
+	for_each_cpu(cpuid, cpu_mask) {
+		hartid = cpuid_to_hartid_map(cpuid);
+		if (hartid >= BITS_PER_LONG) {
+			pr_warn("Unable to send any request to hartid > BITS_PER_LONG for SBI v0.1\n");
+			break;
+		}
+		hmask |= 1 << hartid;
+	}
+
+	return hmask;
+}
+
 /**
  * sbi_console_putchar() - Writes given character to the console device.
  * @ch: The data to be written to the console.
@@ -131,33 +155,44 @@ static void __sbi_set_timer_v01(uint64_t stime_value)
 #endif
 }
 
-static int __sbi_send_ipi_v01(const unsigned long *hart_mask)
+static int __sbi_send_ipi_v01(const struct cpumask *cpu_mask)
 {
-	sbi_ecall(SBI_EXT_0_1_SEND_IPI, 0, (unsigned long)hart_mask,
+	unsigned long hart_mask;
+
+	if (!cpu_mask)
+		cpu_mask = cpu_online_mask;
+	hart_mask = __sbi_v01_cpumask_to_hartmask(cpu_mask);
+
+	sbi_ecall(SBI_EXT_0_1_SEND_IPI, 0, (unsigned long)(&hart_mask),
 		  0, 0, 0, 0, 0);
 	return 0;
 }
 
-static int __sbi_rfence_v01(int fid, const unsigned long *hart_mask,
+static int __sbi_rfence_v01(int fid, const struct cpumask *cpu_mask,
 			    unsigned long start, unsigned long size,
 			    unsigned long arg4, unsigned long arg5)
 {
 	int result = 0;
+	unsigned long hart_mask;
+
+	if (!cpu_mask)
+		cpu_mask = cpu_online_mask;
+	hart_mask = __sbi_v01_cpumask_to_hartmask(cpu_mask);
 
 	/* v0.2 function IDs are equivalent to v0.1 extension IDs */
 	switch (fid) {
 	case SBI_EXT_RFENCE_REMOTE_FENCE_I:
 		sbi_ecall(SBI_EXT_0_1_REMOTE_FENCE_I, 0,
-			  (unsigned long)hart_mask, 0, 0, 0, 0, 0);
+			  (unsigned long)&hart_mask, 0, 0, 0, 0, 0);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
 		sbi_ecall(SBI_EXT_0_1_REMOTE_SFENCE_VMA, 0,
-			  (unsigned long)hart_mask, start, size,
+			  (unsigned long)&hart_mask, start, size,
 			  0, 0, 0);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
 		sbi_ecall(SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID, 0,
-			  (unsigned long)hart_mask, start, size,
+			  (unsigned long)&hart_mask, start, size,
 			  arg4, 0, 0);
 		break;
 	default:
@@ -179,7 +214,7 @@ static void __sbi_set_timer_v01(uint64_t stime_value)
 		sbi_major_version(), sbi_minor_version());
 }
 
-static int __sbi_send_ipi_v01(const unsigned long *hart_mask)
+static int __sbi_send_ipi_v01(const struct cpumask *cpu_mask)
 {
 	pr_warn("IPI extension is not available in SBI v%lu.%lu\n",
 		sbi_major_version(), sbi_minor_version());
@@ -187,7 +222,7 @@ static int __sbi_send_ipi_v01(const unsigned long *hart_mask)
 	return 0;
 }
 
-static int __sbi_rfence_v01(int fid, const unsigned long *hart_mask,
+static int __sbi_rfence_v01(int fid, const struct cpumask *cpu_mask,
 			    unsigned long start, unsigned long size,
 			    unsigned long arg4, unsigned long arg5)
 {
@@ -211,37 +246,33 @@ static void __sbi_set_timer_v02(uint64_t stime_value)
 #endif
 }
 
-static int __sbi_send_ipi_v02(const unsigned long *hart_mask)
+static int __sbi_send_ipi_v02(const struct cpumask *cpu_mask)
 {
-	unsigned long hartid, hmask_val, hbase;
-	struct cpumask tmask;
+	unsigned long hartid, cpuid, hmask = 0, hbase = 0;
 	struct sbiret ret = {0};
 	int result;
 
-	if (!hart_mask || !(*hart_mask)) {
-		riscv_cpuid_to_hartid_mask(cpu_online_mask, &tmask);
-		hart_mask = cpumask_bits(&tmask);
-	}
+	if (!cpu_mask)
+		cpu_mask = cpu_online_mask;
 
-	hmask_val = 0;
-	hbase = 0;
-	for_each_set_bit(hartid, hart_mask, NR_CPUS) {
-		if (hmask_val && ((hbase + BITS_PER_LONG) <= hartid)) {
+	for_each_cpu(cpuid, cpu_mask) {
+		hartid = cpuid_to_hartid_map(cpuid);
+		if (hmask && ((hbase + BITS_PER_LONG) <= hartid)) {
 			ret = sbi_ecall(SBI_EXT_IPI, SBI_EXT_IPI_SEND_IPI,
-					hmask_val, hbase, 0, 0, 0, 0);
+					hmask, hbase, 0, 0, 0, 0);
 			if (ret.error)
 				goto ecall_failed;
-			hmask_val = 0;
+			hmask = 0;
 			hbase = 0;
 		}
-		if (!hmask_val)
+		if (!hmask)
 			hbase = hartid;
-		hmask_val |= 1UL << (hartid - hbase);
+		hmask |= 1UL << (hartid - hbase);
 	}
 
-	if (hmask_val) {
+	if (hmask) {
 		ret = sbi_ecall(SBI_EXT_IPI, SBI_EXT_IPI_SEND_IPI,
-				hmask_val, hbase, 0, 0, 0, 0);
+				hmask, hbase, 0, 0, 0, 0);
 		if (ret.error)
 			goto ecall_failed;
 	}
@@ -251,11 +282,11 @@ static int __sbi_send_ipi_v02(const unsigned long *hart_mask)
 ecall_failed:
 	result = sbi_err_map_linux_errno(ret.error);
 	pr_err("%s: hbase = [%lu] hmask = [0x%lx] failed (error [%d])\n",
-	       __func__, hbase, hmask_val, result);
+	       __func__, hbase, hmask, result);
 	return result;
 }
 
-static int __sbi_rfence_v02_call(unsigned long fid, unsigned long hmask_val,
+static int __sbi_rfence_v02_call(unsigned long fid, unsigned long hmask,
 				 unsigned long hbase, unsigned long start,
 				 unsigned long size, unsigned long arg4,
 				 unsigned long arg5)
@@ -266,31 +297,31 @@ static int __sbi_rfence_v02_call(unsigned long fid, unsigned long hmask_val,
 
 	switch (fid) {
 	case SBI_EXT_RFENCE_REMOTE_FENCE_I:
-		ret = sbi_ecall(ext, fid, hmask_val, hbase, 0, 0, 0, 0);
+		ret = sbi_ecall(ext, fid, hmask, hbase, 0, 0, 0, 0);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
-		ret = sbi_ecall(ext, fid, hmask_val, hbase, start,
+		ret = sbi_ecall(ext, fid, hmask, hbase, start,
 				size, 0, 0);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
-		ret = sbi_ecall(ext, fid, hmask_val, hbase, start,
+		ret = sbi_ecall(ext, fid, hmask, hbase, start,
 				size, arg4, 0);
 		break;
 
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA:
-		ret = sbi_ecall(ext, fid, hmask_val, hbase, start,
+		ret = sbi_ecall(ext, fid, hmask, hbase, start,
 				size, 0, 0);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID:
-		ret = sbi_ecall(ext, fid, hmask_val, hbase, start,
+		ret = sbi_ecall(ext, fid, hmask, hbase, start,
 				size, arg4, 0);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA:
-		ret = sbi_ecall(ext, fid, hmask_val, hbase, start,
+		ret = sbi_ecall(ext, fid, hmask, hbase, start,
 				size, 0, 0);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID:
-		ret = sbi_ecall(ext, fid, hmask_val, hbase, start,
+		ret = sbi_ecall(ext, fid, hmask, hbase, start,
 				size, arg4, 0);
 		break;
 	default:
@@ -302,43 +333,39 @@ static int __sbi_rfence_v02_call(unsigned long fid, unsigned long hmask_val,
 	if (ret.error) {
 		result = sbi_err_map_linux_errno(ret.error);
 		pr_err("%s: hbase = [%lu] hmask = [0x%lx] failed (error [%d])\n",
-		       __func__, hbase, hmask_val, result);
+		       __func__, hbase, hmask, result);
 	}
 
 	return result;
 }
 
-static int __sbi_rfence_v02(int fid, const unsigned long *hart_mask,
+static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
 			    unsigned long start, unsigned long size,
 			    unsigned long arg4, unsigned long arg5)
 {
-	unsigned long hmask_val, hartid, hbase;
-	struct cpumask tmask;
+	unsigned long hartid, cpuid, hmask = 0, hbase = 0;
 	int result;
 
-	if (!hart_mask || !(*hart_mask)) {
-		riscv_cpuid_to_hartid_mask(cpu_online_mask, &tmask);
-		hart_mask = cpumask_bits(&tmask);
-	}
+	if (!cpu_mask)
+		cpu_mask = cpu_online_mask;
 
-	hmask_val = 0;
-	hbase = 0;
-	for_each_set_bit(hartid, hart_mask, NR_CPUS) {
-		if (hmask_val && ((hbase + BITS_PER_LONG) <= hartid)) {
-			result = __sbi_rfence_v02_call(fid, hmask_val, hbase,
+	for_each_cpu(cpuid, cpu_mask) {
+		hartid = cpuid_to_hartid_map(cpuid);
+		if (hmask && ((hbase + BITS_PER_LONG) <= hartid)) {
+			result = __sbi_rfence_v02_call(fid, hmask, hbase,
 						       start, size, arg4, arg5);
 			if (result)
 				return result;
-			hmask_val = 0;
+			hmask = 0;
 			hbase = 0;
 		}
-		if (!hmask_val)
+		if (!hmask)
 			hbase = hartid;
-		hmask_val |= 1UL << (hartid - hbase);
+		hmask |= 1UL << (hartid - hbase);
 	}
 
-	if (hmask_val) {
-		result = __sbi_rfence_v02_call(fid, hmask_val, hbase,
+	if (hmask) {
+		result = __sbi_rfence_v02_call(fid, hmask, hbase,
 					       start, size, arg4, arg5);
 		if (result)
 			return result;
@@ -360,44 +387,44 @@ void sbi_set_timer(uint64_t stime_value)
 
 /**
  * sbi_send_ipi() - Send an IPI to any hart.
- * @hart_mask: A cpu mask containing all the target harts.
+ * @cpu_mask: A cpu mask containing all the target harts.
  *
  * Return: 0 on success, appropriate linux error code otherwise.
  */
-int sbi_send_ipi(const unsigned long *hart_mask)
+int sbi_send_ipi(const struct cpumask *cpu_mask)
 {
-	return __sbi_send_ipi(hart_mask);
+	return __sbi_send_ipi(cpu_mask);
 }
 EXPORT_SYMBOL(sbi_send_ipi);
 
 /**
  * sbi_remote_fence_i() - Execute FENCE.I instruction on given remote harts.
- * @hart_mask: A cpu mask containing all the target harts.
+ * @cpu_mask: A cpu mask containing all the target harts.
  *
  * Return: 0 on success, appropriate linux error code otherwise.
  */
-int sbi_remote_fence_i(const unsigned long *hart_mask)
+int sbi_remote_fence_i(const struct cpumask *cpu_mask)
 {
 	return __sbi_rfence(SBI_EXT_RFENCE_REMOTE_FENCE_I,
-			    hart_mask, 0, 0, 0, 0);
+			    cpu_mask, 0, 0, 0, 0);
 }
 EXPORT_SYMBOL(sbi_remote_fence_i);
 
 /**
  * sbi_remote_sfence_vma() - Execute SFENCE.VMA instructions on given remote
  *			     harts for the specified virtual address range.
- * @hart_mask: A cpu mask containing all the target harts.
+ * @cpu_mask: A cpu mask containing all the target harts.
  * @start: Start of the virtual address
  * @size: Total size of the virtual address range.
  *
  * Return: 0 on success, appropriate linux error code otherwise.
  */
-int sbi_remote_sfence_vma(const unsigned long *hart_mask,
+int sbi_remote_sfence_vma(const struct cpumask *cpu_mask,
 			   unsigned long start,
 			   unsigned long size)
 {
 	return __sbi_rfence(SBI_EXT_RFENCE_REMOTE_SFENCE_VMA,
-			    hart_mask, start, size, 0, 0);
+			    cpu_mask, start, size, 0, 0);
 }
 EXPORT_SYMBOL(sbi_remote_sfence_vma);
 
@@ -405,38 +432,38 @@ EXPORT_SYMBOL(sbi_remote_sfence_vma);
  * sbi_remote_sfence_vma_asid() - Execute SFENCE.VMA instructions on given
  * remote harts for a virtual address range belonging to a specific ASID.
  *
- * @hart_mask: A cpu mask containing all the target harts.
+ * @cpu_mask: A cpu mask containing all the target harts.
  * @start: Start of the virtual address
  * @size: Total size of the virtual address range.
  * @asid: The value of address space identifier (ASID).
  *
  * Return: 0 on success, appropriate linux error code otherwise.
  */
-int sbi_remote_sfence_vma_asid(const unsigned long *hart_mask,
+int sbi_remote_sfence_vma_asid(const struct cpumask *cpu_mask,
 				unsigned long start,
 				unsigned long size,
 				unsigned long asid)
 {
 	return __sbi_rfence(SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID,
-			    hart_mask, start, size, asid, 0);
+			    cpu_mask, start, size, asid, 0);
 }
 EXPORT_SYMBOL(sbi_remote_sfence_vma_asid);
 
 /**
  * sbi_remote_hfence_gvma() - Execute HFENCE.GVMA instructions on given remote
  *			   harts for the specified guest physical address range.
- * @hart_mask: A cpu mask containing all the target harts.
+ * @cpu_mask: A cpu mask containing all the target harts.
  * @start: Start of the guest physical address
  * @size: Total size of the guest physical address range.
  *
  * Return: None
  */
-int sbi_remote_hfence_gvma(const unsigned long *hart_mask,
+int sbi_remote_hfence_gvma(const struct cpumask *cpu_mask,
 			   unsigned long start,
 			   unsigned long size)
 {
 	return __sbi_rfence(SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA,
-			    hart_mask, start, size, 0, 0);
+			    cpu_mask, start, size, 0, 0);
 }
 EXPORT_SYMBOL_GPL(sbi_remote_hfence_gvma);
 
@@ -444,38 +471,38 @@ EXPORT_SYMBOL_GPL(sbi_remote_hfence_gvma);
  * sbi_remote_hfence_gvma_vmid() - Execute HFENCE.GVMA instructions on given
  * remote harts for a guest physical address range belonging to a specific VMID.
  *
- * @hart_mask: A cpu mask containing all the target harts.
+ * @cpu_mask: A cpu mask containing all the target harts.
  * @start: Start of the guest physical address
  * @size: Total size of the guest physical address range.
  * @vmid: The value of guest ID (VMID).
  *
  * Return: 0 if success, Error otherwise.
  */
-int sbi_remote_hfence_gvma_vmid(const unsigned long *hart_mask,
+int sbi_remote_hfence_gvma_vmid(const struct cpumask *cpu_mask,
 				unsigned long start,
 				unsigned long size,
 				unsigned long vmid)
 {
 	return __sbi_rfence(SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID,
-			    hart_mask, start, size, vmid, 0);
+			    cpu_mask, start, size, vmid, 0);
 }
 EXPORT_SYMBOL(sbi_remote_hfence_gvma_vmid);
 
 /**
  * sbi_remote_hfence_vvma() - Execute HFENCE.VVMA instructions on given remote
  *			     harts for the current guest virtual address range.
- * @hart_mask: A cpu mask containing all the target harts.
+ * @cpu_mask: A cpu mask containing all the target harts.
  * @start: Start of the current guest virtual address
  * @size: Total size of the current guest virtual address range.
  *
  * Return: None
  */
-int sbi_remote_hfence_vvma(const unsigned long *hart_mask,
+int sbi_remote_hfence_vvma(const struct cpumask *cpu_mask,
 			   unsigned long start,
 			   unsigned long size)
 {
 	return __sbi_rfence(SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA,
-			    hart_mask, start, size, 0, 0);
+			    cpu_mask, start, size, 0, 0);
 }
 EXPORT_SYMBOL(sbi_remote_hfence_vvma);
 
@@ -484,20 +511,20 @@ EXPORT_SYMBOL(sbi_remote_hfence_vvma);
  * remote harts for current guest virtual address range belonging to a specific
  * ASID.
  *
- * @hart_mask: A cpu mask containing all the target harts.
+ * @cpu_mask: A cpu mask containing all the target harts.
  * @start: Start of the current guest virtual address
  * @size: Total size of the current guest virtual address range.
  * @asid: The value of address space identifier (ASID).
  *
  * Return: None
  */
-int sbi_remote_hfence_vvma_asid(const unsigned long *hart_mask,
+int sbi_remote_hfence_vvma_asid(const struct cpumask *cpu_mask,
 				unsigned long start,
 				unsigned long size,
 				unsigned long asid)
 {
 	return __sbi_rfence(SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID,
-			    hart_mask, start, size, asid, 0);
+			    cpu_mask, start, size, asid, 0);
 }
 EXPORT_SYMBOL(sbi_remote_hfence_vvma_asid);
 
@@ -564,11 +591,7 @@ long sbi_get_mimpid(void)
 
 static void sbi_send_cpumask_ipi(const struct cpumask *target)
 {
-	struct cpumask hartid_mask;
-
-	riscv_cpuid_to_hartid_mask(target, &hartid_mask);
-
-	sbi_send_ipi(cpumask_bits(&hartid_mask));
+	sbi_send_ipi(target);
 }
 
 static const struct riscv_ipi_ops sbi_ipi_ops = {
diff --git a/arch/riscv/kernel/smp.c b/arch/riscv/kernel/smp.c
index 2f6da845c9ae..b5d30ea92292 100644
--- a/arch/riscv/kernel/smp.c
+++ b/arch/riscv/kernel/smp.c
@@ -59,16 +59,6 @@ int riscv_hartid_to_cpuid(int hartid)
 	return -ENOENT;
 }
 
-void riscv_cpuid_to_hartid_mask(const struct cpumask *in, struct cpumask *out)
-{
-	int cpu;
-
-	cpumask_clear(out);
-	for_each_cpu(cpu, in)
-		cpumask_set_cpu(cpuid_to_hartid_map(cpu), out);
-}
-EXPORT_SYMBOL_GPL(riscv_cpuid_to_hartid_mask);
-
 bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
 {
 	return phys_id == cpuid_to_hartid_map(cpu);
diff --git a/arch/riscv/kernel/smpboot.c b/arch/riscv/kernel/smpboot.c
index bd82375db51a..622f226454d5 100644
--- a/arch/riscv/kernel/smpboot.c
+++ b/arch/riscv/kernel/smpboot.c
@@ -96,7 +96,7 @@ void __init setup_smp(void)
 		if (cpuid >= NR_CPUS) {
 			pr_warn("Invalid cpuid [%d] for hartid [%d]\n",
 				cpuid, hart);
-			break;
+			continue;
 		}
 
 		cpuid_to_hartid_map(cpuid) = hart;
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 9ffd0255af43..81702a4829ae 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -114,7 +114,6 @@ static bool stage2_get_leaf_entry(struct kvm *kvm, gpa_t addr,
 
 static void stage2_remote_tlb_flush(struct kvm *kvm, u32 level, gpa_t addr)
 {
-	struct cpumask hmask;
 	unsigned long size = PAGE_SIZE;
 	struct kvm_vmid *vmid = &kvm->arch.vmid;
 
@@ -127,8 +126,7 @@ static void stage2_remote_tlb_flush(struct kvm *kvm, u32 level, gpa_t addr)
 	 * where the Guest/VM is running.
 	 */
 	preempt_disable();
-	riscv_cpuid_to_hartid_mask(cpu_online_mask, &hmask);
-	sbi_remote_hfence_gvma_vmid(cpumask_bits(&hmask), addr, size,
+	sbi_remote_hfence_gvma_vmid(cpu_online_mask, addr, size,
 				    READ_ONCE(vmid->vmid));
 	preempt_enable();
 }
diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 67a64db1efc9..734b38b1846b 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -80,7 +80,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 				      struct kvm_cpu_trap *utrap, bool *exit)
 {
 	int i, ret = 0;
-	struct cpumask cm, hm;
+	struct cpumask cm;
 	struct kvm_vcpu *tmp;
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 	unsigned long hmask = cp->a0;
@@ -88,7 +88,6 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 	unsigned long funcid = cp->a6;
 
 	cpumask_clear(&cm);
-	cpumask_clear(&hm);
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
 		if (hbase != -1UL) {
 			if (tmp->vcpu_id < hbase)
@@ -101,17 +100,15 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 		cpumask_set_cpu(tmp->cpu, &cm);
 	}
 
-	riscv_cpuid_to_hartid_mask(&cm, &hm);
-
 	switch (funcid) {
 	case SBI_EXT_RFENCE_REMOTE_FENCE_I:
-		ret = sbi_remote_fence_i(cpumask_bits(&hm));
+		ret = sbi_remote_fence_i(&cm);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
-		ret = sbi_remote_hfence_vvma(cpumask_bits(&hm), cp->a2, cp->a3);
+		ret = sbi_remote_hfence_vvma(&cm, cp->a2, cp->a3);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
-		ret = sbi_remote_hfence_vvma_asid(cpumask_bits(&hm), cp->a2,
+		ret = sbi_remote_hfence_vvma_asid(&cm, cp->a2,
 						  cp->a3, cp->a4);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA:
diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
index 08097d1c13c1..84d7b96874f2 100644
--- a/arch/riscv/kvm/vcpu_sbi_v01.c
+++ b/arch/riscv/kvm/vcpu_sbi_v01.c
@@ -38,7 +38,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	int i, ret = 0;
 	u64 next_cycle;
 	struct kvm_vcpu *rvcpu;
-	struct cpumask cm, hm;
+	struct cpumask cm;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 
@@ -101,15 +101,12 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 				continue;
 			cpumask_set_cpu(rvcpu->cpu, &cm);
 		}
-		riscv_cpuid_to_hartid_mask(&cm, &hm);
 		if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
-			ret = sbi_remote_fence_i(cpumask_bits(&hm));
+			ret = sbi_remote_fence_i(&cm);
 		else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA)
-			ret = sbi_remote_hfence_vvma(cpumask_bits(&hm),
-						cp->a1, cp->a2);
+			ret = sbi_remote_hfence_vvma(&cm, cp->a1, cp->a2);
 		else
-			ret = sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
-						cp->a1, cp->a2, cp->a3);
+			ret = sbi_remote_hfence_vvma_asid(&cm, cp->a1, cp->a2, cp->a3);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 2c6253b293bc..1bd4779d124e 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -67,7 +67,6 @@ void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu)
 {
 	int i;
 	struct kvm_vcpu *v;
-	struct cpumask hmask;
 	struct kvm_vmid *vmid = &vcpu->kvm->arch.vmid;
 
 	if (!kvm_riscv_stage2_vmid_ver_changed(vmid))
@@ -102,8 +101,7 @@ void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu)
 		 * running, we force VM exits on all host CPUs using IPI and
 		 * flush all Guest TLBs.
 		 */
-		riscv_cpuid_to_hartid_mask(cpu_online_mask, &hmask);
-		sbi_remote_hfence_gvma(cpumask_bits(&hmask), 0, 0);
+		sbi_remote_hfence_gvma(cpu_online_mask, 0, 0);
 	}
 
 	vmid->vmid = vmid_next;
diff --git a/arch/riscv/mm/cacheflush.c b/arch/riscv/mm/cacheflush.c
index 89f81067e09e..6cb7d96ad9c7 100644
--- a/arch/riscv/mm/cacheflush.c
+++ b/arch/riscv/mm/cacheflush.c
@@ -67,10 +67,7 @@ void flush_icache_mm(struct mm_struct *mm, bool local)
 		 */
 		smp_mb();
 	} else if (IS_ENABLED(CONFIG_RISCV_SBI)) {
-		cpumask_t hartid_mask;
-
-		riscv_cpuid_to_hartid_mask(&others, &hartid_mask);
-		sbi_remote_fence_i(cpumask_bits(&hartid_mask));
+		sbi_remote_fence_i(&others);
 	} else {
 		on_each_cpu_mask(&others, ipi_remote_fence_i, NULL, 1);
 	}
diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index 64f8201237c2..37ed760d007c 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -32,7 +32,6 @@ static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long start,
 				  unsigned long size, unsigned long stride)
 {
 	struct cpumask *cmask = mm_cpumask(mm);
-	struct cpumask hmask;
 	unsigned int cpuid;
 	bool broadcast;
 
@@ -46,9 +45,7 @@ static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long start,
 		unsigned long asid = atomic_long_read(&mm->context.id);
 
 		if (broadcast) {
-			riscv_cpuid_to_hartid_mask(cmask, &hmask);
-			sbi_remote_sfence_vma_asid(cpumask_bits(&hmask),
-						   start, size, asid);
+			sbi_remote_sfence_vma_asid(cmask, start, size, asid);
 		} else if (size <= stride) {
 			local_flush_tlb_page_asid(start, asid);
 		} else {
@@ -56,9 +53,7 @@ static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long start,
 		}
 	} else {
 		if (broadcast) {
-			riscv_cpuid_to_hartid_mask(cmask, &hmask);
-			sbi_remote_sfence_vma(cpumask_bits(&hmask),
-					      start, size);
+			sbi_remote_sfence_vma(cmask, start, size);
 		} else if (size <= stride) {
 			local_flush_tlb_page(start);
 		} else {
-- 
2.33.1


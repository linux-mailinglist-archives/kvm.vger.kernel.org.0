Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AF239BEB9
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhFDR3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:29:30 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:56078 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhFDR33 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:29:29 -0400
Received: by mail-yb1-f201.google.com with SMTP id m194-20020a2526cb0000b02905375d41acd7so12657432ybm.22
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 10:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fI8pxJuBvcTSJcYb+gcMX6vyXH4iVi6Ryn52o35lufE=;
        b=OIMxMmMcMDTEikfdbYs4QFgl7LSKbguFsO6botGFgO5a7m4A4LlhG3Nm5M7UZmIQk2
         0PNq0dy2dMje1KR0G1ZnWapzieOzhBAlZ6G4ZjIZI0Xjg4sUy7pZ25Uys58wzm4M+Rhx
         T4DxxjSM7OAm/Ln5fwbscWfIt2T+QqpoZt/USk2rBK/MmyYSIBNldMxSgRdnFelXTY9j
         QlSB7YZJpeIMsLbSSwsu4kUhUauRtQMOVM8iXOs5Kd54nyFloxxNRuMSol5doyR/txrA
         Y8sQ1xnC3pbgunK7/1sAfIP5tcsdaCVc80s7WcTIu9z9ncNk+lYNFVGSzPhaq74wmD6i
         at8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fI8pxJuBvcTSJcYb+gcMX6vyXH4iVi6Ryn52o35lufE=;
        b=KgEE8KYNJS9PT8kphODMX6v3/a13slyD1nqqqR+7YgljM8tAiZOXJD/TIBh1a9mFUR
         5XO7nyTftqxsL30Gdgoam84RbRvZJXj2rQjksCVmBhlpPQDMrkG1LkCuixS/8L1WR3qF
         6lBGHl30gnMfGcZHyUXOkPMU6iEGXvMMyyJRx52Dc00pKu+wo5J9baSNCDfkuetd/mrG
         WkxcUazA+fPTjFhwpErHyzlBUNuWpZerBhdFxNlav3DDt0pleU5Ypcpoa/8kXIv0ErhV
         skSNimvcQuaPUrIJp23J4fkNz15u0aC6DeBMgre9IPltop1Sb/OxPDgj4t5rwWHMjO7/
         QkPg==
X-Gm-Message-State: AOAM530+BIMxud5YWt46AjGAlWobwGgwkAwNjA0Mxsm27piGwprjsYQ4
        Drcp9w6B8mW10P3vv9UL/TT4ZkOA1QzFGPap8ty1Qe6AhMXiSI3H6csTtC0Qx5iVwEPvpJnZ0Ls
        5NBfNVP+sJksg0SpY0sTO3wU5v6dFiIpKa0/y2xnJa5/LES7Z9YVwwL2iWjurTxk=
X-Google-Smtp-Source: ABdhPJxJNCDeRnKQMFXsvk9dp76wEZ4IjRH915e701jQYOq0+1GHkgVn+vrJZP0X/DcovQh4Mu65xz135fPPWw==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a25:2681:: with SMTP id
 m123mr5185657ybm.121.1622827602319; Fri, 04 Jun 2021 10:26:42 -0700 (PDT)
Date:   Fri,  4 Jun 2021 10:26:08 -0700
In-Reply-To: <20210604172611.281819-1-jmattson@google.com>
Message-Id: <20210604172611.281819-10-jmattson@google.com>
Mime-Version: 1.0
References: <20210604172611.281819-1-jmattson@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v2 09/12] KVM: selftests: Hoist APIC functions out of
 individual tests
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the APIC functions into the library to encourage code reuse and
to avoid unintended deviations.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  2 +-
 .../selftests/kvm/include/x86_64/apic.h       | 23 ++++++++
 .../selftests/kvm/include/x86_64/processor.h  |  2 +
 tools/testing/selftests/kvm/lib/x86_64/apic.c | 46 +++++++++++++++
 .../testing/selftests/kvm/x86_64/evmcs_test.c | 11 +---
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    |  6 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     | 59 +++----------------
 7 files changed, 83 insertions(+), 66 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/apic.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index daaee1888b12..5e9051dd4336 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -34,7 +34,7 @@ ifeq ($(ARCH),s390)
 endif
 
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
-LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
+LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
 LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
 
diff --git a/tools/testing/selftests/kvm/include/x86_64/apic.h b/tools/testing/selftests/kvm/include/x86_64/apic.h
index 0d0e35c8866b..e5a9fe040a6c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/apic.h
+++ b/tools/testing/selftests/kvm/include/x86_64/apic.h
@@ -8,6 +8,10 @@
 #ifndef SELFTEST_KVM_APIC_H
 #define SELFTEST_KVM_APIC_H
 
+#include <stdint.h>
+
+#include "processor.h"
+
 #define APIC_DEFAULT_GPA		0xfee00000ULL
 
 /* APIC base address MSR and fields */
@@ -55,4 +59,23 @@
 #define	APIC_ICR2	0x310
 #define		SET_APIC_DEST_FIELD(x)	((x) << 24)
 
+void apic_disable(void);
+void xapic_enable(void);
+void x2apic_enable(void);
+
+static inline uint32_t get_bsp_flag(void)
+{
+	return rdmsr(MSR_IA32_APICBASE) & MSR_IA32_APICBASE_BSP;
+}
+
+static inline uint32_t xapic_read_reg(unsigned int reg)
+{
+	return ((volatile uint32_t *)APIC_DEFAULT_GPA)[reg >> 2];
+}
+
+static inline void xapic_write_reg(unsigned int reg, uint32_t val)
+{
+	((volatile uint32_t *)APIC_DEFAULT_GPA)[reg >> 2] = val;
+}
+
 #endif /* SELFTEST_KVM_APIC_H */
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index a4729d9032ce..9a5b47d2d5d6 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -13,6 +13,8 @@
 
 #include <asm/msr-index.h>
 
+#include "../kvm_util.h"
+
 #define X86_EFLAGS_FIXED	 (1u << 1)
 
 #define X86_CR4_VME		(1ul << 0)
diff --git a/tools/testing/selftests/kvm/lib/x86_64/apic.c b/tools/testing/selftests/kvm/lib/x86_64/apic.c
new file mode 100644
index 000000000000..31f318ac67ba
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86_64/apic.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * tools/testing/selftests/kvm/lib/x86_64/processor.c
+ *
+ * Copyright (C) 2021, Google LLC.
+ */
+
+#include "apic.h"
+
+void apic_disable(void)
+{
+	wrmsr(MSR_IA32_APICBASE,
+	      rdmsr(MSR_IA32_APICBASE) &
+		~(MSR_IA32_APICBASE_ENABLE | MSR_IA32_APICBASE_EXTD));
+}
+
+void xapic_enable(void)
+{
+	uint64_t val = rdmsr(MSR_IA32_APICBASE);
+
+	/* Per SDM: to enable xAPIC when in x2APIC must first disable APIC */
+	if (val & MSR_IA32_APICBASE_EXTD) {
+		apic_disable();
+		wrmsr(MSR_IA32_APICBASE,
+		      rdmsr(MSR_IA32_APICBASE) | MSR_IA32_APICBASE_ENABLE);
+	} else if (!(val & MSR_IA32_APICBASE_ENABLE)) {
+		wrmsr(MSR_IA32_APICBASE, val | MSR_IA32_APICBASE_ENABLE);
+	}
+
+	/*
+	 * Per SDM: reset value of spurious interrupt vector register has the
+	 * APIC software enabled bit=0. It must be enabled in addition to the
+	 * enable bit in the MSR.
+	 */
+	val = xapic_read_reg(APIC_SPIV) | APIC_SPIV_APIC_ENABLED;
+	xapic_write_reg(APIC_SPIV, val);
+}
+
+void x2apic_enable(void)
+{
+	uint32_t spiv_reg = APIC_BASE_MSR + (APIC_SPIV >> 4);
+
+	wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) |
+	      MSR_IA32_APICBASE_ENABLE | MSR_IA32_APICBASE_EXTD);
+	wrmsr(spiv_reg, rdmsr(spiv_reg) | APIC_SPIV_APIC_ENABLED);
+}
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 63096cea26c6..d058d9e428c6 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -22,15 +22,6 @@
 
 static int ud_count;
 
-void enable_x2apic(void)
-{
-	uint32_t spiv_reg = APIC_BASE_MSR + (APIC_SPIV >> 4);
-
-	wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) |
-	      MSR_IA32_APICBASE_ENABLE | MSR_IA32_APICBASE_EXTD);
-	wrmsr(spiv_reg, rdmsr(spiv_reg) | APIC_SPIV_APIC_ENABLED);
-}
-
 static void guest_ud_handler(struct ex_regs *regs)
 {
 	ud_count++;
@@ -59,7 +50,7 @@ void guest_code(struct vmx_pages *vmx_pages)
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 
-	enable_x2apic();
+	x2apic_enable();
 
 	GUEST_SYNC(1);
 	GUEST_SYNC(2);
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index 12c558fc8074..5f8dd74d415f 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -14,16 +14,12 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "apic.h"
 
 #define N_VCPU 2
 #define VCPU_ID0 0
 #define VCPU_ID1 1
 
-static uint32_t get_bsp_flag(void)
-{
-	return rdmsr(MSR_IA32_APICBASE) & MSR_IA32_APICBASE_BSP;
-}
-
 static void guest_bsp_vcpu(void *arg)
 {
 	GUEST_SYNC(1);
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
index 2f964cdc273c..21b22718a9db 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
@@ -42,8 +42,6 @@
 #define HALTER_VCPU_ID 0
 #define SENDER_VCPU_ID 1
 
-volatile uint32_t *apic_base = (volatile uint32_t *)APIC_DEFAULT_GPA;
-
 /*
  * Vector for IPI from sender vCPU to halting vCPU.
  * Value is arbitrary and was chosen for the alternating bit pattern. Any
@@ -86,45 +84,6 @@ struct thread_params {
 	uint64_t *pipis_rcvd; /* host address of ipis_rcvd global */
 };
 
-uint32_t read_apic_reg(uint reg)
-{
-	return apic_base[reg >> 2];
-}
-
-void write_apic_reg(uint reg, uint32_t val)
-{
-	apic_base[reg >> 2] = val;
-}
-
-void disable_apic(void)
-{
-	wrmsr(MSR_IA32_APICBASE,
-	      rdmsr(MSR_IA32_APICBASE) &
-		~(MSR_IA32_APICBASE_ENABLE | MSR_IA32_APICBASE_EXTD));
-}
-
-void enable_xapic(void)
-{
-	uint64_t val = rdmsr(MSR_IA32_APICBASE);
-
-	/* Per SDM: to enable xAPIC when in x2APIC must first disable APIC */
-	if (val & MSR_IA32_APICBASE_EXTD) {
-		disable_apic();
-		wrmsr(MSR_IA32_APICBASE,
-		      rdmsr(MSR_IA32_APICBASE) | MSR_IA32_APICBASE_ENABLE);
-	} else if (!(val & MSR_IA32_APICBASE_ENABLE)) {
-		wrmsr(MSR_IA32_APICBASE, val | MSR_IA32_APICBASE_ENABLE);
-	}
-
-	/*
-	 * Per SDM: reset value of spurious interrupt vector register has the
-	 * APIC software enabled bit=0. It must be enabled in addition to the
-	 * enable bit in the MSR.
-	 */
-	val = read_apic_reg(APIC_SPIV) | APIC_SPIV_APIC_ENABLED;
-	write_apic_reg(APIC_SPIV, val);
-}
-
 void verify_apic_base_addr(void)
 {
 	uint64_t msr = rdmsr(MSR_IA32_APICBASE);
@@ -136,10 +95,10 @@ void verify_apic_base_addr(void)
 static void halter_guest_code(struct test_data_page *data)
 {
 	verify_apic_base_addr();
-	enable_xapic();
+	xapic_enable();
 
-	data->halter_apic_id = GET_APIC_ID_FIELD(read_apic_reg(APIC_ID));
-	data->halter_lvr = read_apic_reg(APIC_LVR);
+	data->halter_apic_id = GET_APIC_ID_FIELD(xapic_read_reg(APIC_ID));
+	data->halter_lvr = xapic_read_reg(APIC_LVR);
 
 	/*
 	 * Loop forever HLTing and recording halts & wakes. Disable interrupts
@@ -150,8 +109,8 @@ static void halter_guest_code(struct test_data_page *data)
 	 * TPR and PPR for diagnostic purposes in case the test fails.
 	 */
 	for (;;) {
-		data->halter_tpr = read_apic_reg(APIC_TASKPRI);
-		data->halter_ppr = read_apic_reg(APIC_PROCPRI);
+		data->halter_tpr = xapic_read_reg(APIC_TASKPRI);
+		data->halter_ppr = xapic_read_reg(APIC_PROCPRI);
 		data->hlt_count++;
 		asm volatile("sti; hlt; cli");
 		data->wake_count++;
@@ -166,7 +125,7 @@ static void halter_guest_code(struct test_data_page *data)
 static void guest_ipi_handler(struct ex_regs *regs)
 {
 	ipis_rcvd++;
-	write_apic_reg(APIC_EOI, 77);
+	xapic_write_reg(APIC_EOI, 77);
 }
 
 static void sender_guest_code(struct test_data_page *data)
@@ -179,7 +138,7 @@ static void sender_guest_code(struct test_data_page *data)
 	uint64_t tsc_start;
 
 	verify_apic_base_addr();
-	enable_xapic();
+	xapic_enable();
 
 	/*
 	 * Init interrupt command register for sending IPIs
@@ -206,8 +165,8 @@ static void sender_guest_code(struct test_data_page *data)
 		 * First IPI can be sent unconditionally because halter vCPU
 		 * starts earlier.
 		 */
-		write_apic_reg(APIC_ICR2, icr2_val);
-		write_apic_reg(APIC_ICR, icr_val);
+		xapic_write_reg(APIC_ICR2, icr2_val);
+		xapic_write_reg(APIC_ICR, icr_val);
 		data->ipis_sent++;
 
 		/*
-- 
2.32.0.rc1.229.g3e70b5a671-goog


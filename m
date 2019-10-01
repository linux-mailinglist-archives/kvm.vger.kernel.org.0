Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 226FDC3126
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 12:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbfJAKXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 06:23:41 -0400
Received: from foss.arm.com ([217.140.110.172]:45862 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729798AbfJAKXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 06:23:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1DFE1000;
        Tue,  1 Oct 2019 03:23:40 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 966CB3F739;
        Tue,  1 Oct 2019 03:23:39 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests RFC PATCH v2 02/19] arm/arm64: psci: Don't run C code without stack or vectors
Date:   Tue,  1 Oct 2019 11:23:06 +0100
Message-Id: <20191001102323.27628-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001102323.27628-1-alexandru.elisei@arm.com>
References: <20191001102323.27628-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The psci test performs a series of CPU_ON/CPU_OFF cycles for CPU 1. This is
done by setting the entry point for the CPU_ON call to the physical address
of the C function cpu_psci_cpu_die.

The compiler is well within its rights to use the stack when generating
code for cpu_psci_cpu_die.  However, because no stack initialization has
been done, the stack pointer is zero, as set by KVM when creating the VCPU.
This causes a data abort without a change in exception level. The VBAR_EL1
register is also zero (the KVM reset value for VBAR_EL1), the MMU is off,
and we end up trying to fetch instructions from address 0x200.

At this point, a stage 2 instruction abort is generated which is taken to
KVM. KVM interprets this as an instruction fetch from an I/O region, and
injects a prefetch abort into the guest. Prefetch abort is a synchronous
exception, and on guest return the VCPU PC will be set to VBAR_EL1 + 0x200,
which is...  0x200. The VCPU ends up in an infinite loop causing a prefetch
abort while fetching the instruction to service the said abort.

cpu_psci_cpu_die is basically a wrapper over the HVC instruction, so
provide an assembly implementation for the function which will serve as the
entry point for CPU_ON.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
Changes:
* replaced 'b halt' with 'b .' in asm_cpu_psci_cpu_die

 arm/cstart.S   | 7 +++++++
 arm/cstart64.S | 7 +++++++
 arm/psci.c     | 5 +++--
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 114726feab82..112124f222cb 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -7,6 +7,7 @@
  */
 #define __ASSEMBLY__
 #include <auxinfo.h>
+#include <linux/psci.h>
 #include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
 #include <asm/ptrace.h>
@@ -138,6 +139,12 @@ secondary_entry:
 	blx	r0
 	b	do_idle
 
+.global asm_cpu_psci_cpu_die
+asm_cpu_psci_cpu_die:
+	ldr	r0, =PSCI_0_2_FN_CPU_OFF
+	hvc	#0
+	b	.
+
 .globl halt
 halt:
 1:	wfi
diff --git a/arm/cstart64.S b/arm/cstart64.S
index b0e8baa1a23a..c98842f11e90 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -7,6 +7,7 @@
  */
 #define __ASSEMBLY__
 #include <auxinfo.h>
+#include <linux/psci.h>
 #include <asm/asm-offsets.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
@@ -128,6 +129,12 @@ secondary_entry:
 	blr	x0
 	b	do_idle
 
+.globl asm_cpu_psci_cpu_die
+asm_cpu_psci_cpu_die:
+	ldr	x0, =PSCI_0_2_FN_CPU_OFF
+	hvc	#0
+	b	.
+
 .globl halt
 halt:
 1:	wfi
diff --git a/arm/psci.c b/arm/psci.c
index 5cb4d5c7c233..0440c4cdbc59 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -72,6 +72,7 @@ static int cpu_on_ret[NR_CPUS];
 static cpumask_t cpu_on_ready, cpu_on_done;
 static volatile int cpu_on_start;
 
+extern void asm_cpu_psci_cpu_die(void);
 static void cpu_on_secondary_entry(void)
 {
 	int cpu = smp_processor_id();
@@ -79,7 +80,7 @@ static void cpu_on_secondary_entry(void)
 	cpumask_set_cpu(cpu, &cpu_on_ready);
 	while (!cpu_on_start)
 		cpu_relax();
-	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
+	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(asm_cpu_psci_cpu_die));
 	cpumask_set_cpu(cpu, &cpu_on_done);
 }
 
@@ -104,7 +105,7 @@ static bool psci_cpu_on_test(void)
 	cpu_on_start = 1;
 	smp_mb();
 
-	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
+	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(asm_cpu_psci_cpu_die));
 	cpumask_set_cpu(0, &cpu_on_done);
 
 	while (!cpumask_full(&cpu_on_done))
-- 
2.20.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1275214F0A9
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 17:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgAaQiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 11:38:11 -0500
Received: from foss.arm.com ([217.140.110.172]:37326 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgAaQiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 11:38:11 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0C8FFEC;
        Fri, 31 Jan 2020 08:38:10 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A00093F68E;
        Fri, 31 Jan 2020 08:38:09 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v4 02/10] arm/arm64: psci: Don't run C code without stack or vectors
Date:   Fri, 31 Jan 2020 16:37:20 +0000
Message-Id: <20200131163728.5228-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200131163728.5228-1-alexandru.elisei@arm.com>
References: <20200131163728.5228-1-alexandru.elisei@arm.com>
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

To avoid all of this, lets use the assembly function halt as the CPU_ON
entry address. Also, expand the check to test that we only get
PSCI_RET_SUCCESS exactly once, as we're never offlining the CPU during the
test.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/psci.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arm/psci.c b/arm/psci.c
index 5c1accb6cea4..ffc09a2e9858 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -79,13 +79,14 @@ static void cpu_on_secondary_entry(void)
 	cpumask_set_cpu(cpu, &cpu_on_ready);
 	while (!cpu_on_start)
 		cpu_relax();
-	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
+	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(halt));
 	cpumask_set_cpu(cpu, &cpu_on_done);
 }
 
 static bool psci_cpu_on_test(void)
 {
 	bool failed = false;
+	int ret_success = 0;
 	int cpu;
 
 	cpumask_set_cpu(1, &cpu_on_ready);
@@ -104,7 +105,7 @@ static bool psci_cpu_on_test(void)
 	cpu_on_start = 1;
 	smp_mb();
 
-	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
+	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(halt));
 	cpumask_set_cpu(0, &cpu_on_done);
 
 	while (!cpumask_full(&cpu_on_done))
@@ -113,12 +114,19 @@ static bool psci_cpu_on_test(void)
 	for_each_present_cpu(cpu) {
 		if (cpu == 1)
 			continue;
-		if (cpu_on_ret[cpu] != PSCI_RET_SUCCESS && cpu_on_ret[cpu] != PSCI_RET_ALREADY_ON) {
+		if (cpu_on_ret[cpu] == PSCI_RET_SUCCESS) {
+			ret_success++;
+		} else if (cpu_on_ret[cpu] != PSCI_RET_ALREADY_ON) {
 			report_info("unexpected cpu_on return value: caller=CPU%d, ret=%d", cpu, cpu_on_ret[cpu]);
 			failed = true;
 		}
 	}
 
+	if (ret_success != 1) {
+		report_info("got %d CPU_ON success", ret_success);
+		failed = true;
+	}
+
 	return !failed;
 }
 
-- 
2.20.1


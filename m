Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737A420A033
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 15:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405240AbgFYNoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 09:44:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:60444 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404890AbgFYNoN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 09:44:13 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 827B9338FB7BF2F083A7;
        Thu, 25 Jun 2020 21:44:10 +0800 (CST)
Received: from A190218597.china.huawei.com (10.47.76.118) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 25 Jun 2020 21:44:01 +0800
From:   Salil Mehta <salil.mehta@huawei.com>
To:     <linux-arm-kernel@lists.infradead.org>
CC:     <maz@kernel.org>, <will@kernel.org>, <catalin.marinas@arm.com>,
        <christoffer.dall@arm.com>, <andre.przywara@arm.com>,
        <james.morse@arm.com>, <mark.rutland@arm.com>,
        <lorenzo.pieralisi@arm.com>, <sudeep.holla@arm.com>,
        <qemu-arm@nongnu.org>, <peter.maydell@linaro.org>,
        <richard.henderson@linaro.org>, <imammedo@redhat.com>,
        <mst@redhat.com>, <drjones@redhat.com>, <pbonzini@redhat.com>,
        <eric.auger@redhat.com>, <gshan@redhat.com>, <david@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <mehta.salil.lnk@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "Xiongfeng Wang" <wangxiongfeng2@huawei.com>
Subject: [PATCH RFC 3/4] arm64: kernel: Init cpu operations for all possible vcpus
Date:   Thu, 25 Jun 2020 14:37:56 +0100
Message-ID: <20200625133757.22332-4-salil.mehta@huawei.com>
X-Mailer: git-send-email 2.8.3
In-Reply-To: <20200625133757.22332-1-salil.mehta@huawei.com>
References: <20200625133757.22332-1-salil.mehta@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.76.118]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, cpu-operations are only initialized for the cpus which
already have logical cpuid to hwid assoication established. And this
only happens for the cpus which are present during boot time.

To support virtual cpu hotplug, we shall initialze the cpu-operations
for all possible(present+disabled) vcpus. This means logical cpuid to
hwid/mpidr association might not exists(i.e. might be INVALID_HWID)
during init. Later, when the vcpu is actually hotplugged logical cpuid
is allocated and associated with the hwid/mpidr.

This patch does some refactoring to support above change.

Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 arch/arm64/kernel/smp.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 864ccd3da419..63f31ea23e55 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -503,13 +503,16 @@ static int __init smp_cpu_setup(int cpu)
 	const struct cpu_operations *ops;
 
 	if (init_cpu_ops(cpu))
-		return -ENODEV;
+		goto out;
 
 	ops = get_cpu_ops(cpu);
 	if (ops->cpu_init(cpu))
-		return -ENODEV;
+		goto out;
 
 	return 0;
+out:
+	cpu_logical_map(cpu) = INVALID_HWID;
+	return -ENODEV;
 }
 
 static bool bootcpu_valid __initdata;
@@ -547,7 +550,8 @@ acpi_map_gic_cpu_interface(struct acpi_madt_generic_interrupt *processor)
 		pr_debug("skipping disabled CPU entry with 0x%llx MPIDR\n", hwid);
 #else
 		cpu_madt_gicc[total_cpu_count] = *processor;
-		set_cpu_possible(total_cpu_count, true);
+		if (!smp_cpu_setup(total_cpu_count))
+			set_cpu_possible(total_cpu_count, true);
 		disabled_cpu_count++;
 #endif
 		return;
@@ -591,8 +595,11 @@ acpi_map_gic_cpu_interface(struct acpi_madt_generic_interrupt *processor)
 	 */
 	acpi_set_mailbox_entry(total_cpu_count, processor);
 
-	set_cpu_possible(total_cpu_count, true);
-	set_cpu_present(total_cpu_count, true);
+	if (!smp_cpu_setup(total_cpu_count)) {
+		set_cpu_possible(total_cpu_count, true);
+		set_cpu_present(total_cpu_count, true);
+	}
+
 	cpu_count++;
 }
 
@@ -701,8 +708,10 @@ static void __init of_parse_and_init_cpus(void)
 
 		early_map_cpu_to_node(cpu_count, of_node_to_nid(dn));
 
-		set_cpu_possible(cpu_count, true);
-		set_cpu_present(cpu_count, true);
+		if (!smp_cpu_setup(cpu_count)) {
+			set_cpu_possible(cpu_count, true);
+			set_cpu_present(cpu_count, true);
+		}
 next:
 		cpu_count++;
 	}
@@ -716,7 +725,6 @@ static void __init of_parse_and_init_cpus(void)
 void __init smp_init_cpus(void)
 {
 	unsigned int total_cpu_count = disabled_cpu_count + cpu_count;
-	int i;
 
 	if (acpi_disabled)
 		of_parse_and_init_cpus();
@@ -731,20 +739,6 @@ void __init smp_init_cpus(void)
 		pr_err("missing boot CPU MPIDR, not enabling secondaries\n");
 		return;
 	}
-
-	/*
-	 * We need to set the cpu_logical_map entries before enabling
-	 * the cpus so that cpu processor description entries (DT cpu nodes
-	 * and ACPI MADT entries) can be retrieved by matching the cpu hwid
-	 * with entries in cpu_logical_map while initializing the cpus.
-	 * If the cpu set-up fails, invalidate the cpu_logical_map entry.
-	 */
-	for (i = 1; i < nr_cpu_ids; i++) {
-		if (cpu_logical_map(i) != INVALID_HWID) {
-			if (smp_cpu_setup(i))
-				cpu_logical_map(i) = INVALID_HWID;
-		}
-	}
 }
 
 void __init smp_prepare_cpus(unsigned int max_cpus)
-- 
2.17.1



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D53920A031
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 15:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405221AbgFYNoL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 09:44:11 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49350 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405190AbgFYNoK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 09:44:10 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6F308B2C6D69505DCE5A;
        Thu, 25 Jun 2020 21:44:05 +0800 (CST)
Received: from A190218597.china.huawei.com (10.47.76.118) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 25 Jun 2020 21:43:54 +0800
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
Subject: [PATCH RFC 2/4] arm64: kernel: Bound the total(present+disabled) cpus with nr_cpu_ids
Date:   Thu, 25 Jun 2020 14:37:55 +0100
Message-ID: <20200625133757.22332-3-salil.mehta@huawei.com>
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

Bound the total number of identified cpus(including disabled cpus) by
maximum allowed limit by the kernel. Max value is either specified as
part of the kernel parameters 'nr_cpus' or specified during compile
time using CONFIG_NR_CPUS.

Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 arch/arm64/kernel/smp.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 51a707928302..864ccd3da419 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -513,6 +513,7 @@ static int __init smp_cpu_setup(int cpu)
 }
 
 static bool bootcpu_valid __initdata;
+static bool cpus_clipped __initdata = false;
 static unsigned int cpu_count = 1;
 static unsigned int disabled_cpu_count;
 
@@ -536,6 +537,11 @@ acpi_map_gic_cpu_interface(struct acpi_madt_generic_interrupt *processor)
 	unsigned int total_cpu_count = disabled_cpu_count + cpu_count;
 	u64 hwid = processor->arm_mpidr;
 
+	if (total_cpu_count > nr_cpu_ids) {
+		cpus_clipped = true;
+		return;
+	}
+
 	if (!(processor->flags & ACPI_MADT_ENABLED)) {
 #ifndef CONFIG_ACPI_HOTPLUG_CPU
 		pr_debug("skipping disabled CPU entry with 0x%llx MPIDR\n", hwid);
@@ -569,9 +575,6 @@ acpi_map_gic_cpu_interface(struct acpi_madt_generic_interrupt *processor)
 		return;
 	}
 
-	if (cpu_count >= NR_CPUS)
-		return;
-
 	/* map the logical cpu id to cpu MPIDR */
 	cpu_logical_map(total_cpu_count) = hwid;
 
@@ -688,8 +691,10 @@ static void __init of_parse_and_init_cpus(void)
 			continue;
 		}
 
-		if (cpu_count >= NR_CPUS)
+		if (cpu_count >= NR_CPUS) {
+			cpus_clipped = true;
 			goto next;
+		}
 
 		pr_debug("cpu logical map 0x%llx\n", hwid);
 		cpu_logical_map(cpu_count) = hwid;
@@ -710,6 +715,7 @@ static void __init of_parse_and_init_cpus(void)
  */
 void __init smp_init_cpus(void)
 {
+	unsigned int total_cpu_count = disabled_cpu_count + cpu_count;
 	int i;
 
 	if (acpi_disabled)
@@ -717,9 +723,9 @@ void __init smp_init_cpus(void)
 	else
 		acpi_parse_and_init_cpus();
 
-	if (cpu_count > nr_cpu_ids)
+	if (cpus_clipped)
 		pr_warn("Number of cores (%d) exceeds configured maximum of %u - clipping\n",
-			cpu_count, nr_cpu_ids);
+			total_cpu_count, nr_cpu_ids);
 
 	if (!bootcpu_valid) {
 		pr_err("missing boot CPU MPIDR, not enabling secondaries\n");
-- 
2.17.1



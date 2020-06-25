Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4FA20A034
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 15:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405250AbgFYNoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 09:44:22 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49622 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405247AbgFYNoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 09:44:20 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 991E3A2CC515FC3F8A23;
        Thu, 25 Jun 2020 21:44:15 +0800 (CST)
Received: from A190218597.china.huawei.com (10.47.76.118) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 25 Jun 2020 21:44:07 +0800
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
Subject: [PATCH RFC 4/4] arm64: kernel: Arch specific ACPI hooks(like logical cpuid<->hwid etc.)
Date:   Thu, 25 Jun 2020 14:37:57 +0100
Message-ID: <20200625133757.22332-5-salil.mehta@huawei.com>
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

To support virtual cpu hotplug, some arch specifc hooks must be
facilitated. These hooks are called by the generic ACPI cpu hotplug
framework during a vcpu hot-(un)plug event handling. The changes
required involve:

1. Allocation of the logical cpuid corresponding to the hwid/mpidr
2. Mapping of logical cpuid to hwid/mpidr and marking present
3. Removing vcpu from present mask during hot-unplug
4. For arm64, all possible cpus are registered within topology_init()
   Hence, we need to override the weak ACPI call of arch_register_cpu()
   (which returns -ENODEV) and return success.
5. NUMA node mapping set for this vcpu using SRAT Table info during init
   time will be discarded as the logical cpu-ids used at that time
   might not be correct. This mapping will be set again using the
   proximity/node info obtained by evaluating _PXM ACPI method.

Note, during hot unplug of vcpu, we do not unmap the association between
the logical cpuid and hwid/mpidr. This remains persistent.

Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 arch/arm64/kernel/smp.c | 80 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 63f31ea23e55..f3315840e829 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -528,6 +528,86 @@ struct acpi_madt_generic_interrupt *acpi_cpu_get_madt_gicc(int cpu)
 	return &cpu_madt_gicc[cpu];
 }
 
+#ifdef CONFIG_ACPI_HOTPLUG_CPU
+int arch_register_cpu(int num)
+{
+	return 0;
+}
+
+static int set_numa_node_for_cpu(acpi_handle handle, int cpu)
+{
+#ifdef CONFIG_ACPI_NUMA
+	int node_id;
+
+	/* will evaluate _PXM */
+	node_id = acpi_get_node(handle);
+	if (node_id != NUMA_NO_NODE)
+		set_cpu_numa_node(cpu, node_id);
+#endif
+	return 0;
+}
+
+static void unset_numa_node_for_cpu(int cpu)
+{
+#ifdef CONFIG_ACPI_NUMA
+	set_cpu_numa_node(cpu, NUMA_NO_NODE);
+#endif
+}
+
+static int allocate_logical_cpuid(u64 physid)
+{
+	int first_invalid_idx = -1;
+	bool first = true;
+	int i;
+
+	for_each_possible_cpu(i) {
+		/*
+		 * logical cpuid<->hwid association remains persistent once
+		 * established
+		 */
+		if (cpu_logical_map(i) == physid)
+			return i;
+
+		if ((cpu_logical_map(i) == INVALID_HWID) && first) {
+			first_invalid_idx = i;
+			first = false;
+		}
+	}
+
+	return first_invalid_idx;
+}
+
+int acpi_unmap_cpu(int cpu)
+{
+	set_cpu_present(cpu, false);
+	unset_numa_node_for_cpu(cpu);
+
+	return 0;
+}
+
+int acpi_map_cpu(acpi_handle handle, phys_cpuid_t physid, u32 acpi_id,
+		 int *cpuid)
+{
+	int cpu;
+
+	cpu = allocate_logical_cpuid(physid);
+	if (cpu < 0) {
+		pr_warn("Unable to map logical cpuid to physid 0x%llx\n",
+			physid);
+		return -ENOSPC;
+	}
+
+	/* map the logical cpu id to cpu MPIDR */
+	cpu_logical_map(cpu) = physid;
+	set_numa_node_for_cpu(handle, cpu);
+
+	set_cpu_present(cpu, true);
+	*cpuid = cpu;
+
+	return 0;
+}
+#endif
+
 /*
  * acpi_map_gic_cpu_interface - parse processor MADT entry
  *
-- 
2.17.1



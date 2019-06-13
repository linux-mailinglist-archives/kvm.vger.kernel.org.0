Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 337C6437D5
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733038AbfFMPB3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:01:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48656 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732552AbfFMOg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 10:36:29 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 40FE8C065135;
        Thu, 13 Jun 2019 14:36:29 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B0DA1001B2E;
        Thu, 13 Jun 2019 14:36:26 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Rob Bradford <robert.bradford@intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v2 12/20] hw/i386/pc: Pass the CPUArchIdList array by argument
Date:   Thu, 13 Jun 2019 16:34:38 +0200
Message-Id: <20190613143446.23937-13-philmd@redhat.com>
In-Reply-To: <20190613143446.23937-1-philmd@redhat.com>
References: <20190613143446.23937-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 13 Jun 2019 14:36:29 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass the CPUArchIdList array by argument, this will
allow us to remove the PCMachineState argument later.

Suggested-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/pc.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 7f5215965e..266cdf19b5 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -933,14 +933,13 @@ static void pc_build_smbios(PCMachineState *pcms)
 }
 
 static FWCfgState *fw_cfg_arch_create(PCMachineState *pcms,
+                                      const CPUArchIdList *cpus,
                                       uint16_t boot_cpus,
                                       uint16_t apic_id_limit)
 {
     FWCfgState *fw_cfg;
     uint64_t *numa_fw_cfg;
     int i;
-    const CPUArchIdList *cpus;
-    MachineClass *mc = MACHINE_GET_CLASS(pcms);
 
     fw_cfg = fw_cfg_init_io_dma(FW_CFG_IO_BASE, FW_CFG_IO_BASE + 4,
                                 &address_space_memory);
@@ -958,7 +957,7 @@ static FWCfgState *fw_cfg_arch_create(PCMachineState *pcms,
      * So for compatibility reasons with old BIOSes we are stuck with
      * "etc/max-cpus" actually being apic_id_limit
      */
-    fw_cfg_add_i16(fw_cfg, FW_CFG_MAX_CPUS, (uint16_t)pcms->apic_id_limit);
+    fw_cfg_add_i16(fw_cfg, FW_CFG_MAX_CPUS, apic_id_limit);
     fw_cfg_add_i64(fw_cfg, FW_CFG_RAM_SIZE, (uint64_t)ram_size);
     fw_cfg_add_bytes(fw_cfg, FW_CFG_ACPI_TABLES,
                      acpi_tables, acpi_tables_len);
@@ -974,20 +973,19 @@ static FWCfgState *fw_cfg_arch_create(PCMachineState *pcms,
      * of nodes, one word for each VCPU->node and one word for each node to
      * hold the amount of memory.
      */
-    numa_fw_cfg = g_new0(uint64_t, 1 + pcms->apic_id_limit + nb_numa_nodes);
+    numa_fw_cfg = g_new0(uint64_t, 1 + apic_id_limit + nb_numa_nodes);
     numa_fw_cfg[0] = cpu_to_le64(nb_numa_nodes);
-    cpus = mc->possible_cpu_arch_ids(MACHINE(pcms));
     for (i = 0; i < cpus->len; i++) {
         unsigned int apic_id = cpus->cpus[i].arch_id;
-        assert(apic_id < pcms->apic_id_limit);
+        assert(apic_id < apic_id_limit);
         numa_fw_cfg[apic_id + 1] = cpu_to_le64(cpus->cpus[i].props.node_id);
     }
     for (i = 0; i < nb_numa_nodes; i++) {
-        numa_fw_cfg[pcms->apic_id_limit + 1 + i] =
+        numa_fw_cfg[apic_id_limit + 1 + i] =
             cpu_to_le64(numa_info[i].node_mem);
     }
     fw_cfg_add_bytes(fw_cfg, FW_CFG_NUMA, numa_fw_cfg,
-                     (1 + pcms->apic_id_limit + nb_numa_nodes) *
+                     (1 + apic_id_limit + nb_numa_nodes) *
                      sizeof(*numa_fw_cfg));
 
     return fw_cfg;
@@ -1768,7 +1766,8 @@ void pc_memory_init(PCMachineState *pcms,
                                         option_rom_mr,
                                         1);
 
-    fw_cfg = fw_cfg_arch_create(pcms, pcms->boot_cpus, pcms->apic_id_limit);
+    fw_cfg = fw_cfg_arch_create(pcms, mc->possible_cpu_arch_ids(machine),
+                                pcms->boot_cpus, pcms->apic_id_limit);
 
     rom_set_fw(fw_cfg);
 
-- 
2.20.1


Return-Path: <kvm+bounces-65129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B29B1C9C15A
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:05:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A9308349CB0
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A296E248896;
	Tue,  2 Dec 2025 16:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KCmaT4s9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BE725FA10
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691495; cv=none; b=Dk4ReFL+JldnVxQc4Tl+mqFDbxtKG/tVQ3xc+nH3NDu+xnNzpFdeyXk4jx6N49+u5tIoVpAEGpDz/ixIpKGQ+m7ZwYM4xYsnWELDhRTSWVmVtAVCRqPASjfFDdPH7DRFp6ck362cLnNpVhb9T77tn/4H9wriHm0tAsEnomFnqHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691495; c=relaxed/simple;
	bh=Ch3Kdw3v64j3a308+n/yOhs5HIIblXLk1moEEZ2xySM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XOZRvyoYeqRkN3IvhbqbLUtprMUNqv+nWpM3pH3fdbvOWO3wbb3JZwR+zzC0WK8dvmnjSWMV1jCMV0ybszTDmXHzfT0e90DJajtnHaVaejDwUv6C5QUWWtrrBqv1NZ1AwX6H8H1m6N4Q3jnrEFxoc7x4GEDz3+j93ApN5VrrrZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KCmaT4s9; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691494; x=1796227494;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ch3Kdw3v64j3a308+n/yOhs5HIIblXLk1moEEZ2xySM=;
  b=KCmaT4s9gHoxNevz4nUE4bAvt5eMcAVD48rReXAdgbyar1GaN6UUfUqF
   xzFX23gtLNfnbKZuXo+PjTGTsg7+1tmsl7yqV6iUYz4oHCtgKwDSps4hh
   ZvsiiL2lCAtGXHR2oXSEObrnQQgtiD7IeGvYG11wK4K2nbp3RxhCht6n1
   bHCgNvw+Y7xe39Cyn2lQi0TteE9z11JSfS7r04jXOsbsUQI9YMtucOi7i
   m1+9Gh82w7ogjIqBlgqy8ukaeVdqX6v4uucOLe7+Wb8M3P8yzwvTVgmeh
   +d0cNGogOH9NW5qa+zb3UNQpIyhrIlrhAnumHoararmeXjYt4EZtbwMOL
   g==;
X-CSE-ConnectionGUID: sM5q7fsgSu+X4BMLwunpxw==
X-CSE-MsgGUID: nVLxoqaASoKPaXm3DQKmFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="92142372"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="92142372"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:04:53 -0800
X-CSE-ConnectionGUID: uo46+pzvQNKOwZJafx9EuQ==
X-CSE-MsgGUID: PKzCc7ewTNmv4GpixNcQfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="199536996"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 02 Dec 2025 08:04:44 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Thomas Huth <thuth@redhat.com>
Cc: qemu-devel@nongnu.org,
	devel@lists.libvirt.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Peter Krempa <pkrempa@redhat.com>,
	Jiri Denemark <jdenemar@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 05/28] acpi: Remove legacy cpu hotplug utilities
Date: Wed,  3 Dec 2025 00:28:12 +0800
Message-Id: <20251202162835.3227894-6-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251202162835.3227894-1-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Igor Mammedov <imammedo@redhat.com>

The cpu_hotplug.h and cpu_hotplug.c contain legacy cpu hotplug
utilities. Now there's no use case of legacy cpu hotplug, so it's safe
to drop legacy cpu hotplug support totally.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v4:
 * New patch split off from Igor's v5 [*].

[*]: https://lore.kernel.org/qemu-devel/20251031142825.179239-1-imammedo@redhat.com/
---
 hw/acpi/acpi-cpu-hotplug-stub.c |  19 +-
 hw/acpi/cpu_hotplug.c           | 348 --------------------------------
 hw/acpi/generic_event_device.c  |   1 +
 hw/acpi/ich9.c                  |   1 +
 hw/acpi/meson.build             |   2 +-
 hw/acpi/piix4.c                 |   2 +-
 hw/i386/acpi-build.c            |   1 +
 hw/i386/pc.c                    |   3 +-
 hw/i386/x86-common.c            |   1 -
 include/hw/acpi/cpu_hotplug.h   |  40 ----
 include/hw/acpi/ich9.h          |   2 +-
 include/hw/acpi/piix4.h         |   2 +-
 12 files changed, 10 insertions(+), 412 deletions(-)
 delete mode 100644 hw/acpi/cpu_hotplug.c
 delete mode 100644 include/hw/acpi/cpu_hotplug.h

diff --git a/hw/acpi/acpi-cpu-hotplug-stub.c b/hw/acpi/acpi-cpu-hotplug-stub.c
index 9872dd55e43f..72c5f05f5c4e 100644
--- a/hw/acpi/acpi-cpu-hotplug-stub.c
+++ b/hw/acpi/acpi-cpu-hotplug-stub.c
@@ -1,22 +1,10 @@
 #include "qemu/osdep.h"
-#include "hw/acpi/cpu_hotplug.h"
 #include "migration/vmstate.h"
-
+#include "hw/acpi/cpu.h"
 
 /* Following stubs are all related to ACPI cpu hotplug */
 const VMStateDescription vmstate_cpu_hotplug;
 
-void acpi_switch_to_modern_cphp(AcpiCpuHotplug *gpe_cpu,
-                                CPUHotplugState *cpuhp_state,
-                                uint16_t io_port)
-{
-}
-
-void legacy_acpi_cpu_hotplug_init(MemoryRegion *parent, Object *owner,
-                                  AcpiCpuHotplug *gpe_cpu, uint16_t base)
-{
-}
-
 void cpu_hotplug_hw_init(MemoryRegion *as, Object *owner,
                          CPUHotplugState *state, hwaddr base_addr)
 {
@@ -31,11 +19,6 @@ void acpi_cpu_plug_cb(HotplugHandler *hotplug_dev,
 {
 }
 
-void legacy_acpi_cpu_plug_cb(HotplugHandler *hotplug_dev,
-                             AcpiCpuHotplug *g, DeviceState *dev, Error **errp)
-{
-}
-
 void acpi_cpu_unplug_cb(CPUHotplugState *cpu_st,
                         DeviceState *dev, Error **errp)
 {
diff --git a/hw/acpi/cpu_hotplug.c b/hw/acpi/cpu_hotplug.c
deleted file mode 100644
index aa0e1e3efa54..000000000000
--- a/hw/acpi/cpu_hotplug.c
+++ /dev/null
@@ -1,348 +0,0 @@
-/*
- * QEMU ACPI hotplug utilities
- *
- * Copyright (C) 2013 Red Hat Inc
- *
- * Authors:
- *   Igor Mammedov <imammedo@redhat.com>
- *
- * This work is licensed under the terms of the GNU GPL, version 2 or later.
- * See the COPYING file in the top-level directory.
- */
-#include "qemu/osdep.h"
-#include "hw/acpi/cpu_hotplug.h"
-#include "qapi/error.h"
-#include "hw/core/cpu.h"
-#include "hw/i386/x86.h"
-#include "hw/pci/pci_device.h"
-#include "qemu/error-report.h"
-
-#define CPU_EJECT_METHOD "CPEJ"
-#define CPU_MAT_METHOD "CPMA"
-#define CPU_ON_BITMAP "CPON"
-#define CPU_STATUS_METHOD "CPST"
-#define CPU_STATUS_MAP "PRS"
-#define CPU_SCAN_METHOD "PRSC"
-
-static uint64_t cpu_status_read(void *opaque, hwaddr addr, unsigned int size)
-{
-    AcpiCpuHotplug *cpus = opaque;
-    uint64_t val = cpus->sts[addr];
-
-    return val;
-}
-
-static void cpu_status_write(void *opaque, hwaddr addr, uint64_t data,
-                             unsigned int size)
-{
-    /* firmware never used to write in CPU present bitmap so use
-       this fact as means to switch QEMU into modern CPU hotplug
-       mode by writing 0 at the beginning of legacy CPU bitmap
-     */
-    if (addr == 0 && data == 0) {
-        AcpiCpuHotplug *cpus = opaque;
-        object_property_set_bool(cpus->device, "cpu-hotplug-legacy", false,
-                                 &error_abort);
-    }
-}
-
-static const MemoryRegionOps AcpiCpuHotplug_ops = {
-    .read = cpu_status_read,
-    .write = cpu_status_write,
-    .endianness = DEVICE_LITTLE_ENDIAN,
-    .valid = {
-        .min_access_size = 1,
-        .max_access_size = 4,
-    },
-    .impl = {
-        .max_access_size = 1,
-    },
-};
-
-static void acpi_set_cpu_present_bit(AcpiCpuHotplug *g, CPUState *cpu,
-                                     bool *swtchd_to_modern)
-{
-    int64_t cpu_id;
-
-    cpu_id = cpu->cc->get_arch_id(cpu);
-    if ((cpu_id / 8) >= ACPI_GPE_PROC_LEN) {
-        object_property_set_bool(g->device, "cpu-hotplug-legacy", false,
-                                 &error_abort);
-        *swtchd_to_modern = true;
-        return;
-    }
-
-    *swtchd_to_modern = false;
-    g->sts[cpu_id / 8] |= (1 << (cpu_id % 8));
-}
-
-void legacy_acpi_cpu_plug_cb(HotplugHandler *hotplug_dev,
-                             AcpiCpuHotplug *g, DeviceState *dev, Error **errp)
-{
-    bool swtchd_to_modern;
-    Error *local_err = NULL;
-
-    acpi_set_cpu_present_bit(g, CPU(dev), &swtchd_to_modern);
-    if (swtchd_to_modern) {
-        /* propagate the hotplug to the modern interface */
-        hotplug_handler_plug(hotplug_dev, dev, &local_err);
-    } else {
-        acpi_send_event(DEVICE(hotplug_dev), ACPI_CPU_HOTPLUG_STATUS);
-    }
-}
-
-void legacy_acpi_cpu_hotplug_init(MemoryRegion *parent, Object *owner,
-                                  AcpiCpuHotplug *gpe_cpu, uint16_t base)
-{
-    CPUState *cpu;
-    bool swtchd_to_modern;
-
-    memory_region_init_io(&gpe_cpu->io, owner, &AcpiCpuHotplug_ops,
-                          gpe_cpu, "acpi-cpu-hotplug", ACPI_GPE_PROC_LEN);
-    memory_region_add_subregion(parent, base, &gpe_cpu->io);
-    gpe_cpu->device = owner;
-
-    CPU_FOREACH(cpu) {
-        acpi_set_cpu_present_bit(gpe_cpu, cpu, &swtchd_to_modern);
-    }
-}
-
-void acpi_switch_to_modern_cphp(AcpiCpuHotplug *gpe_cpu,
-                                CPUHotplugState *cpuhp_state,
-                                uint16_t io_port)
-{
-    MemoryRegion *parent = pci_address_space_io(PCI_DEVICE(gpe_cpu->device));
-
-    memory_region_del_subregion(parent, &gpe_cpu->io);
-    cpu_hotplug_hw_init(parent, gpe_cpu->device, cpuhp_state, io_port);
-}
-
-void build_legacy_cpu_hotplug_aml(Aml *ctx, MachineState *machine,
-                                  uint16_t io_base)
-{
-    Aml *dev;
-    Aml *crs;
-    Aml *pkg;
-    Aml *field;
-    Aml *method;
-    Aml *if_ctx;
-    Aml *else_ctx;
-    int i, apic_idx;
-    Aml *sb_scope = aml_scope("_SB");
-    uint8_t madt_tmpl[8] = {0x00, 0x08, 0x00, 0x00, 0x00, 0, 0, 0};
-    Aml *cpu_id = aml_arg(1);
-    Aml *apic_id = aml_arg(0);
-    Aml *cpu_on = aml_local(0);
-    Aml *madt = aml_local(1);
-    Aml *cpus_map = aml_name(CPU_ON_BITMAP);
-    Aml *zero = aml_int(0);
-    Aml *one = aml_int(1);
-    MachineClass *mc = MACHINE_GET_CLASS(machine);
-    const CPUArchIdList *apic_ids = mc->possible_cpu_arch_ids(machine);
-    X86MachineState *x86ms = X86_MACHINE(machine);
-
-    /*
-     * _MAT method - creates an madt apic buffer
-     * apic_id = Arg0 = Local APIC ID
-     * cpu_id  = Arg1 = Processor ID
-     * cpu_on = Local0 = CPON flag for this cpu
-     * madt = Local1 = Buffer (in madt apic form) to return
-     */
-    method = aml_method(CPU_MAT_METHOD, 2, AML_NOTSERIALIZED);
-    aml_append(method,
-        aml_store(aml_derefof(aml_index(cpus_map, apic_id)), cpu_on));
-    aml_append(method,
-        aml_store(aml_buffer(sizeof(madt_tmpl), madt_tmpl), madt));
-    /* Update the processor id, lapic id, and enable/disable status */
-    aml_append(method, aml_store(cpu_id, aml_index(madt, aml_int(2))));
-    aml_append(method, aml_store(apic_id, aml_index(madt, aml_int(3))));
-    aml_append(method, aml_store(cpu_on, aml_index(madt, aml_int(4))));
-    aml_append(method, aml_return(madt));
-    aml_append(sb_scope, method);
-
-    /*
-     * _STA method - return ON status of cpu
-     * apic_id = Arg0 = Local APIC ID
-     * cpu_on = Local0 = CPON flag for this cpu
-     */
-    method = aml_method(CPU_STATUS_METHOD, 1, AML_NOTSERIALIZED);
-    aml_append(method,
-        aml_store(aml_derefof(aml_index(cpus_map, apic_id)), cpu_on));
-    if_ctx = aml_if(cpu_on);
-    {
-        aml_append(if_ctx, aml_return(aml_int(0xF)));
-    }
-    aml_append(method, if_ctx);
-    else_ctx = aml_else();
-    {
-        aml_append(else_ctx, aml_return(zero));
-    }
-    aml_append(method, else_ctx);
-    aml_append(sb_scope, method);
-
-    method = aml_method(CPU_EJECT_METHOD, 2, AML_NOTSERIALIZED);
-    aml_append(method, aml_sleep(200));
-    aml_append(sb_scope, method);
-
-    method = aml_method(CPU_SCAN_METHOD, 0, AML_NOTSERIALIZED);
-    {
-        Aml *while_ctx, *if_ctx2, *else_ctx2;
-        Aml *bus_check_evt = aml_int(1);
-        Aml *remove_evt = aml_int(3);
-        Aml *status_map = aml_local(5); /* Local5 = active cpu bitmap */
-        Aml *byte = aml_local(2); /* Local2 = last read byte from bitmap */
-        Aml *idx = aml_local(0); /* Processor ID / APIC ID iterator */
-        Aml *is_cpu_on = aml_local(1); /* Local1 = CPON flag for cpu */
-        Aml *status = aml_local(3); /* Local3 = active state for cpu */
-
-        aml_append(method, aml_store(aml_name(CPU_STATUS_MAP), status_map));
-        aml_append(method, aml_store(zero, byte));
-        aml_append(method, aml_store(zero, idx));
-
-        /* While (idx < SizeOf(CPON)) */
-        while_ctx = aml_while(aml_lless(idx, aml_sizeof(cpus_map)));
-        aml_append(while_ctx,
-            aml_store(aml_derefof(aml_index(cpus_map, idx)), is_cpu_on));
-
-        if_ctx = aml_if(aml_and(idx, aml_int(0x07), NULL));
-        {
-            /* Shift down previously read bitmap byte */
-            aml_append(if_ctx, aml_shiftright(byte, one, byte));
-        }
-        aml_append(while_ctx, if_ctx);
-
-        else_ctx = aml_else();
-        {
-            /* Read next byte from cpu bitmap */
-            aml_append(else_ctx, aml_store(aml_derefof(aml_index(status_map,
-                       aml_shiftright(idx, aml_int(3), NULL))), byte));
-        }
-        aml_append(while_ctx, else_ctx);
-
-        aml_append(while_ctx, aml_store(aml_and(byte, one, NULL), status));
-        if_ctx = aml_if(aml_lnot(aml_equal(is_cpu_on, status)));
-        {
-            /* State change - update CPON with new state */
-            aml_append(if_ctx, aml_store(status, aml_index(cpus_map, idx)));
-            if_ctx2 = aml_if(aml_equal(status, one));
-            {
-                aml_append(if_ctx2,
-                    aml_call2(AML_NOTIFY_METHOD, idx, bus_check_evt));
-            }
-            aml_append(if_ctx, if_ctx2);
-            else_ctx2 = aml_else();
-            {
-                aml_append(else_ctx2,
-                    aml_call2(AML_NOTIFY_METHOD, idx, remove_evt));
-            }
-        }
-        aml_append(if_ctx, else_ctx2);
-        aml_append(while_ctx, if_ctx);
-
-        aml_append(while_ctx, aml_increment(idx)); /* go to next cpu */
-        aml_append(method, while_ctx);
-    }
-    aml_append(sb_scope, method);
-
-    /* The current AML generator can cover the APIC ID range [0..255],
-     * inclusive, for VCPU hotplug. */
-    QEMU_BUILD_BUG_ON(ACPI_CPU_HOTPLUG_ID_LIMIT > 256);
-    if (x86ms->apic_id_limit > ACPI_CPU_HOTPLUG_ID_LIMIT) {
-        error_report("max_cpus is too large. APIC ID of last CPU is %u",
-                     x86ms->apic_id_limit - 1);
-        exit(1);
-    }
-
-    /* create PCI0.PRES device and its _CRS to reserve CPU hotplug MMIO */
-    dev = aml_device("PCI0." stringify(CPU_HOTPLUG_RESOURCE_DEVICE));
-    aml_append(dev, aml_name_decl("_HID", aml_eisaid("PNP0A06")));
-    aml_append(dev,
-        aml_name_decl("_UID", aml_string("CPU Hotplug resources"))
-    );
-    /* device present, functioning, decoding, not shown in UI */
-    aml_append(dev, aml_name_decl("_STA", aml_int(0xB)));
-    crs = aml_resource_template();
-    aml_append(crs,
-        aml_io(AML_DECODE16, io_base, io_base, 1, ACPI_GPE_PROC_LEN)
-    );
-    aml_append(dev, aml_name_decl("_CRS", crs));
-    aml_append(sb_scope, dev);
-    /* declare CPU hotplug MMIO region and PRS field to access it */
-    aml_append(sb_scope, aml_operation_region(
-        "PRST", AML_SYSTEM_IO, aml_int(io_base), ACPI_GPE_PROC_LEN));
-    field = aml_field("PRST", AML_BYTE_ACC, AML_NOLOCK, AML_PRESERVE);
-    aml_append(field, aml_named_field("PRS", 256));
-    aml_append(sb_scope, field);
-
-    /* build Processor object for each processor */
-    for (i = 0; i < apic_ids->len; i++) {
-        int cpu_apic_id = apic_ids->cpus[i].arch_id;
-
-        assert(cpu_apic_id < ACPI_CPU_HOTPLUG_ID_LIMIT);
-
-        dev = aml_processor(i, 0, 0, "CP%.02X", cpu_apic_id);
-
-        method = aml_method("_MAT", 0, AML_NOTSERIALIZED);
-        aml_append(method,
-            aml_return(aml_call2(CPU_MAT_METHOD,
-                                 aml_int(cpu_apic_id), aml_int(i))
-        ));
-        aml_append(dev, method);
-
-        method = aml_method("_STA", 0, AML_NOTSERIALIZED);
-        aml_append(method,
-            aml_return(aml_call1(CPU_STATUS_METHOD, aml_int(cpu_apic_id))));
-        aml_append(dev, method);
-
-        method = aml_method("_EJ0", 1, AML_NOTSERIALIZED);
-        aml_append(method,
-            aml_return(aml_call2(CPU_EJECT_METHOD, aml_int(cpu_apic_id),
-                aml_arg(0)))
-        );
-        aml_append(dev, method);
-
-        aml_append(sb_scope, dev);
-    }
-
-    /* build this code:
-     *   Method(NTFY, 2) {If (LEqual(Arg0, 0x00)) {Notify(CP00, Arg1)} ...}
-     */
-    /* Arg0 = APIC ID */
-    method = aml_method(AML_NOTIFY_METHOD, 2, AML_NOTSERIALIZED);
-    for (i = 0; i < apic_ids->len; i++) {
-        int cpu_apic_id = apic_ids->cpus[i].arch_id;
-
-        if_ctx = aml_if(aml_equal(aml_arg(0), aml_int(cpu_apic_id)));
-        aml_append(if_ctx,
-            aml_notify(aml_name("CP%.02X", cpu_apic_id), aml_arg(1))
-        );
-        aml_append(method, if_ctx);
-    }
-    aml_append(sb_scope, method);
-
-    /* build "Name(CPON, Package() { One, One, ..., Zero, Zero, ... })"
-     *
-     * Note: The ability to create variable-sized packages was first
-     * introduced in ACPI 2.0. ACPI 1.0 only allowed fixed-size packages
-     * ith up to 255 elements. Windows guests up to win2k8 fail when
-     * VarPackageOp is used.
-     */
-    pkg = x86ms->apic_id_limit <= 255 ? aml_package(x86ms->apic_id_limit) :
-                                        aml_varpackage(x86ms->apic_id_limit);
-
-    for (i = 0, apic_idx = 0; i < apic_ids->len; i++) {
-        int cpu_apic_id = apic_ids->cpus[i].arch_id;
-
-        for (; apic_idx < cpu_apic_id; apic_idx++) {
-            aml_append(pkg, aml_int(0));
-        }
-        aml_append(pkg, aml_int(apic_ids->cpus[i].cpu ? 1 : 0));
-        apic_idx = cpu_apic_id + 1;
-    }
-    aml_append(sb_scope, aml_name_decl(CPU_ON_BITMAP, pkg));
-    aml_append(ctx, sb_scope);
-
-    method = aml_method("\\_GPE._E02", 0, AML_NOTSERIALIZED);
-    aml_append(method, aml_call0("\\_SB." CPU_SCAN_METHOD));
-    aml_append(ctx, method);
-}
diff --git a/hw/acpi/generic_event_device.c b/hw/acpi/generic_event_device.c
index e7b773d84d50..9d0962d60203 100644
--- a/hw/acpi/generic_event_device.c
+++ b/hw/acpi/generic_event_device.c
@@ -13,6 +13,7 @@
 #include "qapi/error.h"
 #include "hw/acpi/acpi.h"
 #include "hw/acpi/pcihp.h"
+#include "hw/acpi/cpu.h"
 #include "hw/acpi/generic_event_device.h"
 #include "hw/pci/pci.h"
 #include "hw/irq.h"
diff --git a/hw/acpi/ich9.c b/hw/acpi/ich9.c
index f254f3879716..bbb1bd60a206 100644
--- a/hw/acpi/ich9.c
+++ b/hw/acpi/ich9.c
@@ -40,6 +40,7 @@
 #include "hw/southbridge/ich9.h"
 #include "hw/mem/pc-dimm.h"
 #include "hw/mem/nvdimm.h"
+#include "hw/acpi/pc-hotplug.h"
 
 static void ich9_pm_update_sci_fn(ACPIREGS *regs)
 {
diff --git a/hw/acpi/meson.build b/hw/acpi/meson.build
index 56b5d1ec9691..66c978aae836 100644
--- a/hw/acpi/meson.build
+++ b/hw/acpi/meson.build
@@ -6,7 +6,7 @@ acpi_ss.add(files(
   'core.c',
   'utils.c',
 ))
-acpi_ss.add(when: 'CONFIG_ACPI_CPU_HOTPLUG', if_true: files('cpu.c', 'cpu_hotplug.c'))
+acpi_ss.add(when: 'CONFIG_ACPI_CPU_HOTPLUG', if_true: files('cpu.c'))
 acpi_ss.add(when: 'CONFIG_ACPI_CPU_HOTPLUG', if_false: files('acpi-cpu-hotplug-stub.c'))
 acpi_ss.add(when: 'CONFIG_ACPI_MEMORY_HOTPLUG', if_true: files('memory_hotplug.c'))
 acpi_ss.add(when: 'CONFIG_ACPI_MEMORY_HOTPLUG', if_false: files('acpi-mem-hotplug-stub.c'))
diff --git a/hw/acpi/piix4.c b/hw/acpi/piix4.c
index 6ad5f1d1c19d..87a2e4a68247 100644
--- a/hw/acpi/piix4.c
+++ b/hw/acpi/piix4.c
@@ -33,7 +33,6 @@
 #include "system/xen.h"
 #include "qapi/error.h"
 #include "qemu/range.h"
-#include "hw/acpi/cpu_hotplug.h"
 #include "hw/acpi/cpu.h"
 #include "hw/hotplug.h"
 #include "hw/mem/pc-dimm.h"
@@ -43,6 +42,7 @@
 #include "migration/vmstate.h"
 #include "hw/core/cpu.h"
 #include "qom/object.h"
+#include "hw/acpi/pc-hotplug.h"
 
 #define GPE_BASE 0xafe0
 #define GPE_LEN 4
diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
index bf7ed2e50837..a744eb6c3a9b 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -35,6 +35,7 @@
 #include "hw/acpi/acpi-defs.h"
 #include "hw/acpi/acpi.h"
 #include "hw/acpi/cpu.h"
+#include "hw/acpi/pc-hotplug.h"
 #include "hw/nvram/fw_cfg.h"
 #include "hw/acpi/bios-linker-loader.h"
 #include "hw/acpi/acpi_aml_interface.h"
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index f8b919cb6c47..2b8d3982c4a0 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -48,7 +48,8 @@
 #include "hw/xen/xen.h"
 #include "qobject/qlist.h"
 #include "qemu/error-report.h"
-#include "hw/acpi/cpu_hotplug.h"
+#include "hw/acpi/acpi.h"
+#include "hw/acpi/pc-hotplug.h"
 #include "acpi-build.h"
 #include "hw/mem/nvdimm.h"
 #include "hw/cxl/cxl_host.h"
diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
index c844749900a3..60b7ab80433a 100644
--- a/hw/i386/x86-common.c
+++ b/hw/i386/x86-common.c
@@ -36,7 +36,6 @@
 #include "hw/rtc/mc146818rtc.h"
 #include "target/i386/sev.h"
 
-#include "hw/acpi/cpu_hotplug.h"
 #include "hw/irq.h"
 #include "hw/loader.h"
 #include "multiboot.h"
diff --git a/include/hw/acpi/cpu_hotplug.h b/include/hw/acpi/cpu_hotplug.h
deleted file mode 100644
index 3b932abbbbee..000000000000
--- a/include/hw/acpi/cpu_hotplug.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * QEMU ACPI hotplug utilities
- *
- * Copyright (C) 2013 Red Hat Inc
- *
- * Authors:
- *   Igor Mammedov <imammedo@redhat.com>
- *
- * This work is licensed under the terms of the GNU GPL, version 2 or later.
- * See the COPYING file in the top-level directory.
- */
-
-#ifndef HW_ACPI_CPU_HOTPLUG_H
-#define HW_ACPI_CPU_HOTPLUG_H
-
-#include "hw/acpi/acpi.h"
-#include "hw/acpi/pc-hotplug.h"
-#include "hw/acpi/aml-build.h"
-#include "hw/hotplug.h"
-#include "hw/acpi/cpu.h"
-
-typedef struct AcpiCpuHotplug {
-    Object *device;
-    MemoryRegion io;
-    uint8_t sts[ACPI_GPE_PROC_LEN];
-} AcpiCpuHotplug;
-
-void legacy_acpi_cpu_plug_cb(HotplugHandler *hotplug_dev,
-                             AcpiCpuHotplug *g, DeviceState *dev, Error **errp);
-
-void legacy_acpi_cpu_hotplug_init(MemoryRegion *parent, Object *owner,
-                                  AcpiCpuHotplug *gpe_cpu, uint16_t base);
-
-void acpi_switch_to_modern_cphp(AcpiCpuHotplug *gpe_cpu,
-                                CPUHotplugState *cpuhp_state,
-                                uint16_t io_port);
-
-void build_legacy_cpu_hotplug_aml(Aml *ctx, MachineState *machine,
-                                  uint16_t io_base);
-#endif
diff --git a/include/hw/acpi/ich9.h b/include/hw/acpi/ich9.h
index 6a21472eb32e..019f0915c110 100644
--- a/include/hw/acpi/ich9.h
+++ b/include/hw/acpi/ich9.h
@@ -22,12 +22,12 @@
 #define HW_ACPI_ICH9_H
 
 #include "hw/acpi/acpi.h"
-#include "hw/acpi/cpu_hotplug.h"
 #include "hw/acpi/cpu.h"
 #include "hw/acpi/pcihp.h"
 #include "hw/acpi/memory_hotplug.h"
 #include "hw/acpi/acpi_dev_interface.h"
 #include "hw/acpi/ich9_tco.h"
+#include "hw/acpi/cpu.h"
 
 #define ACPI_PCIHP_ADDR_ICH9 0x0cc0
 
diff --git a/include/hw/acpi/piix4.h b/include/hw/acpi/piix4.h
index e075f0cbeaf1..863382a814ad 100644
--- a/include/hw/acpi/piix4.h
+++ b/include/hw/acpi/piix4.h
@@ -24,11 +24,11 @@
 
 #include "hw/pci/pci_device.h"
 #include "hw/acpi/acpi.h"
-#include "hw/acpi/cpu_hotplug.h"
 #include "hw/acpi/memory_hotplug.h"
 #include "hw/acpi/pcihp.h"
 #include "hw/i2c/pm_smbus.h"
 #include "hw/isa/apm.h"
+#include "hw/acpi/cpu.h"
 
 #define TYPE_PIIX4_PM "PIIX4_PM"
 OBJECT_DECLARE_SIMPLE_TYPE(PIIX4PMState, PIIX4_PM)
-- 
2.34.1



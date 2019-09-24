Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339D1BC81E
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 14:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504974AbfIXMqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 08:46:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45172 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441001AbfIXMqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 08:46:14 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AED2C30860B9;
        Tue, 24 Sep 2019 12:46:13 +0000 (UTC)
Received: from dritchie.redhat.com (unknown [10.33.36.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 286DA60603;
        Tue, 24 Sep 2019 12:46:04 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     mst@redhat.com, imammedo@redhat.com, marcel.apfelbaum@gmail.com,
        pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>
Subject: [PATCH v4 8/8] hw/i386: Introduce the microvm machine type
Date:   Tue, 24 Sep 2019 14:44:33 +0200
Message-Id: <20190924124433.96810-9-slp@redhat.com>
In-Reply-To: <20190924124433.96810-1-slp@redhat.com>
References: <20190924124433.96810-1-slp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 24 Sep 2019 12:46:13 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Microvm is a machine type inspired by both NEMU and Firecracker, and
constructed after the machine model implemented by the latter.

It's main purpose is providing users a minimalist machine type free
from the burden of legacy compatibility, serving as a stepping stone
for future projects aiming at improving boot times, reducing the
attack surface and slimming down QEMU's footprint.

The microvm machine type supports the following devices:

 - ISA bus
 - i8259 PIC
 - LAPIC (implicit if using KVM)
 - IOAPIC (defaults to kernel_irqchip_split = true)
 - i8254 PIT
 - MC146818 RTC (optional)
 - kvmclock (if using KVM)
 - fw_cfg
 - One ISA serial port (optional)
 - Up to eight virtio-mmio devices (configured by the user)

It supports the following machine-specific options:

microvm.option-roms=bool (Set off to disable loading option ROMs)
microvm.isa-serial=bool (Set off to disable the instantiation an ISA serial port)
microvm.rtc=bool (Set off to disable the instantiation of an MC146818 RTC)
microvm.kernel-cmdline=bool (Set off to disable adding virtio-mmio devices to the kernel cmdline)

By default, microvm uses qboot as its BIOS, to obtain better boot
times, but it's also compatible with SeaBIOS.

As no current FW is able to boot from a block device using virtio-mmio
as its transport, a microvm-based VM needs to be run using a host-side
kernel and, optionally, an initrd image.

This is an example of instantiating a microvm VM with a virtio-mmio
based console:

qemu-system-x86_64 -M microvm
 -enable-kvm -cpu host -m 512m -smp 2 \
 -kernel vmlinux -append "console=hvc0 root=/dev/vda" \
 -nodefaults -no-user-config -nographic \
 -chardev stdio,id=virtiocon0,server \
 -device virtio-serial-device \
 -device virtconsole,chardev=virtiocon0 \
 -drive id=test,file=test.img,format=raw,if=none \
 -device virtio-blk-device,drive=test \
 -netdev tap,id=tap0,script=no,downscript=no \
 -device virtio-net-device,netdev=tap0

This is another example, this time using an ISA serial port, useful
for debugging purposes:

qemu-system-x86_64 -M microvm \
 -enable-kvm -cpu host -m 512m -smp 2 \
 -kernel vmlinux -append "earlyprintk=ttyS0 console=ttyS0 root=/dev/vda" \
 -nodefaults -no-user-config -nographic \
 -serial stdio \
 -drive id=test,file=test.img,format=raw,if=none \
 -device virtio-blk-device,drive=test \
 -netdev tap,id=tap0,script=no,downscript=no \
 -device virtio-net-device,netdev=tap0

Finally, in this example a microvm VM is instantiated without RTC,
without an ISA serial port and without loading the option ROMs,
obtaining the smallest configuration:

qemu-system-x86_64 -M microvm,rtc=off,isa-serial=off,option-roms=off \
 -enable-kvm -cpu host -m 512m -smp 2 \
 -kernel vmlinux -append "console=hvc0 root=/dev/vda" \
 -nodefaults -no-user-config -nographic \
 -chardev stdio,id=virtiocon0,server \
 -device virtio-serial-device \
 -device virtconsole,chardev=virtiocon0 \
 -drive id=test,file=test.img,format=raw,if=none \
 -device virtio-blk-device,drive=test \
 -netdev tap,id=tap0,script=no,downscript=no \
 -device virtio-net-device,netdev=tap0

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
 default-configs/i386-softmmu.mak |   1 +
 hw/i386/Kconfig                  |   4 +
 hw/i386/Makefile.objs            |   1 +
 hw/i386/microvm.c                | 512 +++++++++++++++++++++++++++++++
 include/hw/i386/microvm.h        |  80 +++++
 5 files changed, 598 insertions(+)
 create mode 100644 hw/i386/microvm.c
 create mode 100644 include/hw/i386/microvm.h

diff --git a/default-configs/i386-softmmu.mak b/default-configs/i386-softmmu.mak
index cd5ea391e8..c27cdd98e9 100644
--- a/default-configs/i386-softmmu.mak
+++ b/default-configs/i386-softmmu.mak
@@ -26,3 +26,4 @@ CONFIG_ISAPC=y
 CONFIG_I440FX=y
 CONFIG_Q35=y
 CONFIG_ACPI_PCI=y
+CONFIG_MICROVM=y
\ No newline at end of file
diff --git a/hw/i386/Kconfig b/hw/i386/Kconfig
index 6350438036..324e193dd8 100644
--- a/hw/i386/Kconfig
+++ b/hw/i386/Kconfig
@@ -88,6 +88,10 @@ config Q35
     select SMBIOS
     select FW_CFG_DMA
 
+config MICROVM
+    bool
+    select VIRTIO_MMIO
+
 config VTD
     bool
 
diff --git a/hw/i386/Makefile.objs b/hw/i386/Makefile.objs
index 5b4b3a672e..bb17d54567 100644
--- a/hw/i386/Makefile.objs
+++ b/hw/i386/Makefile.objs
@@ -6,6 +6,7 @@ obj-y += pc.o
 obj-y += e820.o
 obj-$(CONFIG_I440FX) += pc_piix.o
 obj-$(CONFIG_Q35) += pc_q35.o
+obj-$(CONFIG_MICROVM) += microvm.o
 obj-y += fw_cfg.o pc_sysfw.o
 obj-y += x86-iommu.o
 obj-$(CONFIG_VTD) += intel_iommu.o
diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
new file mode 100644
index 0000000000..4b494a1b27
--- /dev/null
+++ b/hw/i386/microvm.c
@@ -0,0 +1,512 @@
+/*
+ * Copyright (c) 2018 Intel Corporation
+ * Copyright (c) 2019 Red Hat, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2 or later, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/error-report.h"
+#include "qemu/cutils.h"
+#include "qemu/units.h"
+#include "qapi/error.h"
+#include "qapi/visitor.h"
+#include "sysemu/sysemu.h"
+#include "sysemu/cpus.h"
+#include "sysemu/numa.h"
+#include "sysemu/reset.h"
+
+#include "hw/loader.h"
+#include "hw/irq.h"
+#include "hw/nmi.h"
+#include "hw/kvm/clock.h"
+#include "hw/i386/microvm.h"
+#include "hw/i386/x86.h"
+#include "hw/i386/pc.h"
+#include "target/i386/cpu.h"
+#include "hw/timer/i8254.h"
+#include "hw/timer/mc146818rtc.h"
+#include "hw/char/serial.h"
+#include "hw/i386/topology.h"
+#include "hw/i386/e820.h"
+#include "hw/i386/fw_cfg.h"
+#include "hw/virtio/virtio-mmio.h"
+
+#include "cpu.h"
+#include "elf.h"
+#include "pvh.h"
+#include "kvm_i386.h"
+#include "hw/xen/start_info.h"
+
+#define MICROVM_BIOS_FILENAME "bios-microvm.bin"
+
+static void microvm_set_rtc(MicrovmMachineState *mms, ISADevice *s)
+{
+    X86MachineState *x86ms = X86_MACHINE(mms);
+    int val;
+
+    val = MIN(x86ms->below_4g_mem_size / KiB, 640);
+    rtc_set_memory(s, 0x15, val);
+    rtc_set_memory(s, 0x16, val >> 8);
+    /* extended memory (next 64MiB) */
+    if (x86ms->below_4g_mem_size > 1 * MiB) {
+        val = (x86ms->below_4g_mem_size - 1 * MiB) / KiB;
+    } else {
+        val = 0;
+    }
+    if (val > 65535) {
+        val = 65535;
+    }
+    rtc_set_memory(s, 0x17, val);
+    rtc_set_memory(s, 0x18, val >> 8);
+    rtc_set_memory(s, 0x30, val);
+    rtc_set_memory(s, 0x31, val >> 8);
+    /* memory between 16MiB and 4GiB */
+    if (x86ms->below_4g_mem_size > 16 * MiB) {
+        val = (x86ms->below_4g_mem_size - 16 * MiB) / (64 * KiB);
+    } else {
+        val = 0;
+    }
+    if (val > 65535) {
+        val = 65535;
+    }
+    rtc_set_memory(s, 0x34, val);
+    rtc_set_memory(s, 0x35, val >> 8);
+    /* memory above 4GiB */
+    val = x86ms->above_4g_mem_size / 65536;
+    rtc_set_memory(s, 0x5b, val);
+    rtc_set_memory(s, 0x5c, val >> 8);
+    rtc_set_memory(s, 0x5d, val >> 16);
+}
+
+static void microvm_devices_init(MicrovmMachineState *mms)
+{
+    X86MachineState *x86ms = X86_MACHINE(mms);
+    ISABus *isa_bus;
+    ISADevice *rtc_state;
+    GSIState *gsi_state;
+    qemu_irq *i8259;
+    int i;
+
+    gsi_state = g_malloc0(sizeof(*gsi_state));
+    x86ms->gsi = qemu_allocate_irqs(gsi_handler, gsi_state, GSI_NUM_PINS);
+
+    isa_bus = isa_bus_new(NULL, get_system_memory(), get_system_io(),
+                          &error_abort);
+    isa_bus_irqs(isa_bus, x86ms->gsi);
+
+    i8259 = i8259_init(isa_bus, pc_allocate_cpu_irq());
+
+    for (i = 0; i < ISA_NUM_IRQS; i++) {
+        gsi_state->i8259_irq[i] = i8259[i];
+    }
+
+    ioapic_init_gsi(gsi_state, "machine");
+
+    if (mms->rtc_enabled) {
+        rtc_state = mc146818_rtc_init(isa_bus, 2000, NULL);
+        microvm_set_rtc(mms, rtc_state);
+    }
+
+    if (kvm_pit_in_kernel()) {
+        kvm_pit_init(isa_bus, 0x40);
+    } else {
+        i8254_pit_init(isa_bus, 0x40, 0, NULL);
+    }
+
+    kvmclock_create();
+
+    for (i = 0; i < VIRTIO_NUM_TRANSPORTS; i++) {
+        int nirq = VIRTIO_IRQ_BASE + i;
+        ISADevice *isadev = isa_create(isa_bus, TYPE_ISA_SERIAL);
+        qemu_irq mmio_irq;
+
+        isa_init_irq(isadev, &mmio_irq, nirq);
+        sysbus_create_simple("virtio-mmio",
+                             VIRTIO_MMIO_BASE + i * 512,
+                             x86ms->gsi[VIRTIO_IRQ_BASE + i]);
+    }
+
+    g_free(i8259);
+
+    if (mms->isa_serial_enabled) {
+        serial_hds_isa_init(isa_bus, 0, 1);
+    }
+
+    if (bios_name == NULL) {
+        bios_name = MICROVM_BIOS_FILENAME;
+    }
+    x86_system_rom_init(get_system_memory(), true);
+}
+
+static void microvm_memory_init(MicrovmMachineState *mms)
+{
+    MachineState *machine = MACHINE(mms);
+    X86MachineState *x86ms = X86_MACHINE(mms);
+    MemoryRegion *ram, *ram_below_4g, *ram_above_4g;
+    MemoryRegion *system_memory = get_system_memory();
+    FWCfgState *fw_cfg;
+    ram_addr_t lowmem;
+    int i;
+
+    /*
+     * Check whether RAM fits below 4G (leaving 1/2 GByte for IO memory
+     * and 256 Mbytes for PCI Express Enhanced Configuration Access Mapping
+     * also known as MMCFG).
+     * If it doesn't, we need to split it in chunks below and above 4G.
+     * In any case, try to make sure that guest addresses aligned at
+     * 1G boundaries get mapped to host addresses aligned at 1G boundaries.
+     */
+    if (machine->ram_size >= 0xb0000000) {
+        lowmem = 0x80000000;
+    } else {
+        lowmem = 0xb0000000;
+    }
+
+    /*
+     * Handle the machine opt max-ram-below-4g.  It is basically doing
+     * min(qemu limit, user limit).
+     */
+    if (!x86ms->max_ram_below_4g) {
+        x86ms->max_ram_below_4g = 1ULL << 32; /* default: 4G */
+    }
+    if (lowmem > x86ms->max_ram_below_4g) {
+        lowmem = x86ms->max_ram_below_4g;
+        if (machine->ram_size - lowmem > lowmem &&
+            lowmem & (1 * GiB - 1)) {
+            warn_report("There is possibly poor performance as the ram size "
+                        " (0x%" PRIx64 ") is more then twice the size of"
+                        " max-ram-below-4g (%"PRIu64") and"
+                        " max-ram-below-4g is not a multiple of 1G.",
+                        (uint64_t)machine->ram_size, x86ms->max_ram_below_4g);
+        }
+    }
+
+    if (machine->ram_size > lowmem) {
+        x86ms->above_4g_mem_size = machine->ram_size - lowmem;
+        x86ms->below_4g_mem_size = lowmem;
+    } else {
+        x86ms->above_4g_mem_size = 0;
+        x86ms->below_4g_mem_size = machine->ram_size;
+    }
+
+    ram = g_malloc(sizeof(*ram));
+    memory_region_allocate_system_memory(ram, NULL, "microvm.ram",
+                                         machine->ram_size);
+
+    ram_below_4g = g_malloc(sizeof(*ram_below_4g));
+    memory_region_init_alias(ram_below_4g, NULL, "ram-below-4g", ram,
+                             0, x86ms->below_4g_mem_size);
+    memory_region_add_subregion(system_memory, 0, ram_below_4g);
+
+    e820_add_entry(0, x86ms->below_4g_mem_size, E820_RAM);
+
+    if (x86ms->above_4g_mem_size > 0) {
+        ram_above_4g = g_malloc(sizeof(*ram_above_4g));
+        memory_region_init_alias(ram_above_4g, NULL, "ram-above-4g", ram,
+                                 x86ms->below_4g_mem_size,
+                                 x86ms->above_4g_mem_size);
+        memory_region_add_subregion(system_memory, 0x100000000ULL,
+                                    ram_above_4g);
+        e820_add_entry(0x100000000ULL, x86ms->above_4g_mem_size, E820_RAM);
+    }
+
+    fw_cfg = fw_cfg_init_io_dma(FW_CFG_IO_BASE, FW_CFG_IO_BASE + 4,
+                                &address_space_memory);
+
+    fw_cfg_add_i16(fw_cfg, FW_CFG_NB_CPUS, x86ms->boot_cpus);
+    fw_cfg_add_i16(fw_cfg, FW_CFG_MAX_CPUS, (uint16_t)x86ms->apic_id_limit);
+    fw_cfg_add_i64(fw_cfg, FW_CFG_RAM_SIZE, (uint64_t)machine->ram_size);
+    fw_cfg_add_i32(fw_cfg, FW_CFG_IRQ0_OVERRIDE, kvm_allows_irq0_override());
+
+    rom_set_fw(fw_cfg);
+
+    e820_create_fw_entry(fw_cfg);
+
+    load_linux(x86ms, fw_cfg, 0, true, true);
+
+    if (mms->option_roms_enabled) {
+        for (i = 0; i < nb_option_roms; i++) {
+            rom_add_option(option_rom[i].name, option_rom[i].bootindex);
+        }
+    }
+
+    x86ms->fw_cfg = fw_cfg;
+    x86ms->ioapic_as = &address_space_memory;
+}
+
+static gchar *microvm_get_mmio_cmdline(gchar *name)
+{
+    gchar *cmdline;
+    gchar *separator;
+    long int index;
+    int ret;
+
+    separator = g_strrstr(name, ".");
+    if (!separator) {
+        return NULL;
+    }
+
+    if (qemu_strtol(separator + 1, NULL, 10, &index) != 0) {
+        return NULL;
+    }
+
+    cmdline = g_malloc0(VIRTIO_CMDLINE_MAXLEN);
+    ret = g_snprintf(cmdline, VIRTIO_CMDLINE_MAXLEN,
+                     " virtio_mmio.device=512@0x%lx:%ld",
+                     VIRTIO_MMIO_BASE + index * 512,
+                     VIRTIO_IRQ_BASE + index);
+    if (ret < 0 || ret >= VIRTIO_CMDLINE_MAXLEN) {
+        g_free(cmdline);
+        return NULL;
+    }
+
+    return cmdline;
+}
+
+static void microvm_fix_kernel_cmdline(MachineState *machine)
+{
+    X86MachineState *x86ms = X86_MACHINE(machine);
+    BusState *bus;
+    BusChild *kid;
+    char *cmdline;
+
+    /*
+     * Find MMIO transports with attached devices, and add them to the kernel
+     * command line.
+     *
+     * Yes, this is a hack, but one that heavily improves the UX without
+     * introducing any significant issues.
+     */
+    cmdline = g_strdup(machine->kernel_cmdline);
+    bus = sysbus_get_default();
+    QTAILQ_FOREACH(kid, &bus->children, sibling) {
+        DeviceState *dev = kid->child;
+        ObjectClass *class = object_get_class(OBJECT(dev));
+
+        if (class == object_class_by_name(TYPE_VIRTIO_MMIO)) {
+            VirtIOMMIOProxy *mmio = VIRTIO_MMIO(OBJECT(dev));
+            VirtioBusState *mmio_virtio_bus = &mmio->bus;
+            BusState *mmio_bus = &mmio_virtio_bus->parent_obj;
+
+            if (!QTAILQ_EMPTY(&mmio_bus->children)) {
+                gchar *mmio_cmdline = microvm_get_mmio_cmdline(mmio_bus->name);
+                if (mmio_cmdline) {
+                    char *newcmd = g_strjoin(NULL, cmdline, mmio_cmdline, NULL);
+                    g_free(mmio_cmdline);
+                    g_free(cmdline);
+                    cmdline = newcmd;
+                }
+            }
+        }
+    }
+
+    fw_cfg_modify_i32(x86ms->fw_cfg, FW_CFG_CMDLINE_SIZE, strlen(cmdline) + 1);
+    fw_cfg_modify_string(x86ms->fw_cfg, FW_CFG_CMDLINE_DATA, cmdline);
+}
+
+static void microvm_machine_state_init(MachineState *machine)
+{
+    MicrovmMachineState *mms = MICROVM_MACHINE(machine);
+    X86MachineState *x86ms = X86_MACHINE(machine);
+    Error *local_err = NULL;
+
+    if (machine->kernel_filename == NULL) {
+        error_report("missing kernel image file name, required by microvm");
+        exit(1);
+    }
+
+    microvm_memory_init(mms);
+
+    x86_cpus_init(x86ms, CPU_VERSION_LATEST);
+    if (local_err) {
+        error_report_err(local_err);
+        exit(1);
+    }
+
+    microvm_devices_init(mms);
+}
+
+static void microvm_machine_reset(MachineState *machine)
+{
+    MicrovmMachineState *mms = MICROVM_MACHINE(machine);
+    CPUState *cs;
+    X86CPU *cpu;
+
+    if (mms->kernel_cmdline_enabled && !mms->kernel_cmdline_fixed) {
+        microvm_fix_kernel_cmdline(machine);
+        mms->kernel_cmdline_fixed = true;
+    }
+
+    qemu_devices_reset();
+
+    CPU_FOREACH(cs) {
+        cpu = X86_CPU(cs);
+
+        if (cpu->apic_state) {
+            device_reset(cpu->apic_state);
+        }
+    }
+}
+
+static bool microvm_machine_get_rtc(Object *obj, Error **errp)
+{
+    MicrovmMachineState *mms = MICROVM_MACHINE(obj);
+
+    return mms->rtc_enabled;
+}
+
+static void microvm_machine_set_rtc(Object *obj, bool value, Error **errp)
+{
+    MicrovmMachineState *mms = MICROVM_MACHINE(obj);
+
+    mms->rtc_enabled = value;
+}
+
+static bool microvm_machine_get_isa_serial(Object *obj, Error **errp)
+{
+    MicrovmMachineState *mms = MICROVM_MACHINE(obj);
+
+    return mms->isa_serial_enabled;
+}
+
+static void microvm_machine_set_isa_serial(Object *obj, bool value,
+                                           Error **errp)
+{
+    MicrovmMachineState *mms = MICROVM_MACHINE(obj);
+
+    mms->isa_serial_enabled = value;
+}
+
+static bool microvm_machine_get_option_roms(Object *obj, Error **errp)
+{
+    MicrovmMachineState *mms = MICROVM_MACHINE(obj);
+
+    return mms->option_roms_enabled;
+}
+
+static void microvm_machine_set_option_roms(Object *obj, bool value,
+                                            Error **errp)
+{
+    MicrovmMachineState *mms = MICROVM_MACHINE(obj);
+
+    mms->option_roms_enabled = value;
+}
+
+static bool microvm_machine_get_kernel_cmdline(Object *obj, Error **errp)
+{
+    MicrovmMachineState *mms = MICROVM_MACHINE(obj);
+
+    return mms->kernel_cmdline_enabled;
+}
+
+static void microvm_machine_set_kernel_cmdline(Object *obj, bool value,
+                                               Error **errp)
+{
+    MicrovmMachineState *mms = MICROVM_MACHINE(obj);
+
+    mms->kernel_cmdline_enabled = value;
+}
+
+static void microvm_machine_initfn(Object *obj)
+{
+    MicrovmMachineState *mms = MICROVM_MACHINE(obj);
+
+    /* Configuration */
+    mms->rtc_enabled = true;
+    mms->isa_serial_enabled = true;
+    mms->option_roms_enabled = true;
+    mms->kernel_cmdline_enabled = true;
+
+    /* State */
+    mms->kernel_cmdline_fixed = false;
+}
+
+static void microvm_class_init(ObjectClass *oc, void *data)
+{
+    MachineClass *mc = MACHINE_CLASS(oc);
+    NMIClass *nc = NMI_CLASS(oc);
+
+    mc->init = microvm_machine_state_init;
+
+    mc->family = "microvm_i386";
+    mc->desc = "Microvm (i386)";
+    mc->units_per_default_bus = 1;
+    mc->no_floppy = 1;
+    machine_class_allow_dynamic_sysbus_dev(mc, "sysbus-debugcon");
+    machine_class_allow_dynamic_sysbus_dev(mc, "sysbus-debugexit");
+    mc->max_cpus = 288;
+    mc->has_hotpluggable_cpus = false;
+    mc->auto_enable_numa_with_memhp = false;
+    mc->default_cpu_type = TARGET_DEFAULT_CPU_TYPE;
+    mc->nvdimm_supported = false;
+
+    /* Avoid relying too much on kernel components */
+    mc->default_kernel_irqchip_split = true;
+
+    /* Machine class handlers */
+    mc->reset = microvm_machine_reset;
+
+    /* NMI handler */
+    nc->nmi_monitor_handler = x86_nmi;
+
+    object_class_property_add_bool(oc, MICROVM_MACHINE_RTC,
+                                   microvm_machine_get_rtc,
+                                   microvm_machine_set_rtc,
+                                   &error_abort);
+    object_class_property_set_description(oc, MICROVM_MACHINE_RTC,
+        "Set off to disable the instantiation of an MC146818 RTC",
+        &error_abort);
+
+    object_class_property_add_bool(oc, MICROVM_MACHINE_ISA_SERIAL,
+                                   microvm_machine_get_isa_serial,
+                                   microvm_machine_set_isa_serial,
+                                   &error_abort);
+    object_class_property_set_description(oc, MICROVM_MACHINE_ISA_SERIAL,
+        "Set off to disable the instantiation an ISA serial port",
+        &error_abort);
+
+    object_class_property_add_bool(oc, MICROVM_MACHINE_OPTION_ROMS,
+                                   microvm_machine_get_option_roms,
+                                   microvm_machine_set_option_roms,
+                                   &error_abort);
+    object_class_property_set_description(oc, MICROVM_MACHINE_OPTION_ROMS,
+        "Set off to disable loading option ROMs", &error_abort);
+
+    object_class_property_add_bool(oc, MICROVM_MACHINE_KERNEL_CMDLINE,
+                                   microvm_machine_get_kernel_cmdline,
+                                   microvm_machine_set_kernel_cmdline,
+                                   &error_abort);
+    object_class_property_set_description(oc, MICROVM_MACHINE_KERNEL_CMDLINE,
+        "Set off to disable adding virtio-mmio devices to the kernel cmdline",
+        &error_abort);
+}
+
+static const TypeInfo microvm_machine_info = {
+    .name          = TYPE_MICROVM_MACHINE,
+    .parent        = TYPE_X86_MACHINE,
+    .instance_size = sizeof(MicrovmMachineState),
+    .instance_init = microvm_machine_initfn,
+    .class_size    = sizeof(MicrovmMachineClass),
+    .class_init    = microvm_class_init,
+    .interfaces = (InterfaceInfo[]) {
+         { TYPE_NMI },
+         { }
+    },
+};
+
+static void microvm_machine_init(void)
+{
+    type_register_static(&microvm_machine_info);
+}
+type_init(microvm_machine_init);
diff --git a/include/hw/i386/microvm.h b/include/hw/i386/microvm.h
new file mode 100644
index 0000000000..04c8caf886
--- /dev/null
+++ b/include/hw/i386/microvm.h
@@ -0,0 +1,80 @@
+/*
+ * Copyright (c) 2018 Intel Corporation
+ * Copyright (c) 2019 Red Hat, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2 or later, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef HW_I386_MICROVM_H
+#define HW_I386_MICROVM_H
+
+#include "qemu-common.h"
+#include "exec/hwaddr.h"
+#include "qemu/notify.h"
+
+#include "hw/boards.h"
+#include "hw/i386/x86.h"
+
+/* Microvm memory layout */
+#define PVH_START_INFO        0x6000
+#define MEMMAP_START          0x7000
+#define MODLIST_START         0x7800
+#define BOOT_STACK_POINTER    0x8ff0
+#define PML4_START            0x9000
+#define PDPTE_START           0xa000
+#define PDE_START             0xb000
+#define KERNEL_CMDLINE_START  0x20000
+#define EBDA_START            0x9fc00
+#define HIMEM_START           0x100000
+
+/* Platform virtio definitions */
+#define VIRTIO_MMIO_BASE      0xc0000000
+#define VIRTIO_IRQ_BASE       5
+#define VIRTIO_NUM_TRANSPORTS 8
+#define VIRTIO_CMDLINE_MAXLEN 64
+
+/* Machine type options */
+#define MICROVM_MACHINE_RTC            "rtc"
+#define MICROVM_MACHINE_ISA_SERIAL     "isa-serial"
+#define MICROVM_MACHINE_OPTION_ROMS    "option-roms"
+#define MICROVM_MACHINE_KERNEL_CMDLINE "kernel-cmdline"
+
+typedef struct {
+    X86MachineClass parent;
+    HotplugHandler *(*orig_hotplug_handler)(MachineState *machine,
+                                           DeviceState *dev);
+} MicrovmMachineClass;
+
+typedef struct {
+    X86MachineState parent;
+
+    /* Machine type options */
+    bool rtc_enabled;
+    bool isa_serial_enabled;
+    bool option_roms_enabled;
+    bool kernel_cmdline_enabled;
+
+
+    /* Machine state */
+    bool kernel_cmdline_fixed;
+} MicrovmMachineState;
+
+#define TYPE_MICROVM_MACHINE   MACHINE_TYPE_NAME("microvm")
+#define MICROVM_MACHINE(obj) \
+    OBJECT_CHECK(MicrovmMachineState, (obj), TYPE_MICROVM_MACHINE)
+#define MICROVM_MACHINE_GET_CLASS(obj) \
+    OBJECT_GET_CLASS(MicrovmMachineClass, obj, TYPE_MICROVM_MACHINE)
+#define MICROVM_MACHINE_CLASS(class) \
+    OBJECT_CLASS_CHECK(MicrovmMachineClass, class, TYPE_MICROVM_MACHINE)
+
+#endif
-- 
2.21.0


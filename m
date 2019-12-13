Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D451C11E80B
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 17:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbfLMQUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 11:20:40 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24538 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726404AbfLMQUj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 11:20:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576254037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4iY8APFf9mkIq+cbZyyzXVA8af+R0+1u/Mw6FuzxngQ=;
        b=ZlQ+cX1TrrGTLyHIT4HrhfBzgyp4hzdNWw+ZCyATgCLzaTz7lh0dbQ1nKZQOOKfH0oGKtu
        HnloFwUCAWOj16jGNLYBQiqxRKbsgWKjB/cNQIakbpouAa/J65C8qdY2BrEIhhpll1OdZj
        qaRLhWvmaAimzv7KEXRFRIFlRpJZGRE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-7TJ690WrPveV067pFYkoLA-1; Fri, 13 Dec 2019 11:20:35 -0500
X-MC-Unique: 7TJ690WrPveV067pFYkoLA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF7DF1856A60;
        Fri, 13 Dec 2019 16:20:33 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 20A8F19C4F;
        Fri, 13 Dec 2019 16:20:24 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     John Snow <jsnow@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-block@nongnu.org, Richard Henderson <rth@twiddle.net>,
        xen-devel@lists.xenproject.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 12/12] hw/i386/pc: Move PC-machine specific declarations to 'pc_internal.h'
Date:   Fri, 13 Dec 2019 17:17:53 +0100
Message-Id: <20191213161753.8051-13-philmd@redhat.com>
In-Reply-To: <20191213161753.8051-1-philmd@redhat.com>
References: <20191213161753.8051-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Historically, QEMU started with only one X86 machine: the PC.
The 'hw/i386/pc.h' header was used to store all X86 and PC
declarations. Since we have now multiple machines based on the
X86 architecture, move the PC-specific declarations in a new
header.
We use 'internal' in the name to explicit this header is restricted
to the X86 architecture. Other architecture can not access it.

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
Maybe name it 'pc_machine.h'?
---
 hw/i386/pc_internal.h | 144 ++++++++++++++++++++++++++++++++++++++++++
 include/hw/i386/pc.h  | 128 -------------------------------------
 hw/i386/acpi-build.c  |   1 +
 hw/i386/pc.c          |   1 +
 hw/i386/pc_piix.c     |   1 +
 hw/i386/pc_q35.c      |   1 +
 hw/i386/pc_sysfw.c    |   1 +
 hw/i386/xen/xen-hvm.c |   1 +
 8 files changed, 150 insertions(+), 128 deletions(-)
 create mode 100644 hw/i386/pc_internal.h

diff --git a/hw/i386/pc_internal.h b/hw/i386/pc_internal.h
new file mode 100644
index 0000000000..c9be64e815
--- /dev/null
+++ b/hw/i386/pc_internal.h
@@ -0,0 +1,144 @@
+#ifndef HW_I386_PC_INTERNAL_H
+#define HW_I386_PC_INTERNAL_H
+
+#include "hw/hw.h"
+#include "hw/isa/isa.h"
+#include "hw/i386/pc.h"
+#include "hw/block/fdc.h"
+#include "net/net.h"
+
+#define PC_MACHINE_ACPI_DEVICE_PROP     "acpi-device"
+#define PC_MACHINE_DEVMEM_REGION_SIZE   "device-memory-region-size"
+#define PC_MACHINE_MAX_RAM_BELOW_4G     "max-ram-below-4g"
+#define PC_MACHINE_VMPORT               "vmport"
+#define PC_MACHINE_SMM                  "smm"
+#define PC_MACHINE_SMBUS                "smbus"
+#define PC_MACHINE_SATA                 "sata"
+#define PC_MACHINE_PIT                  "pit"
+
+void pc_register_ferr_irq(qemu_irq irq);
+void pc_acpi_smi_interrupt(void *opaque, int irq, int level);
+
+void pc_hot_add_cpu(MachineState *ms, const int64_t id, Error **errp);
+void pc_smp_parse(MachineState *ms, QemuOpts *opts);
+
+void pc_guest_info_init(PCMachineState *pcms);
+
+void xen_load_linux(PCMachineState *pcms);
+void pc_memory_init(PCMachineState *pcms,
+                    MemoryRegion *system_memory,
+                    MemoryRegion *rom_memory,
+                    MemoryRegion **ram_memory);
+
+void pc_basic_device_init(ISABus *isa_bus, qemu_irq *gsi,
+                          ISADevice **rtc_state,
+                          bool create_fdctrl,
+                          bool no_vmport,
+                          bool has_pit,
+                          uint32_t hpet_irqs);
+void pc_init_ne2k_isa(ISABus *bus, NICInfo *nd);
+void pc_cmos_init(PCMachineState *pcms,
+                  BusState *ide0, BusState *ide1,
+                  ISADevice *s);
+void pc_nic_init(PCMachineClass *pcmc, ISABus *isa_bus, PCIBus *pci_bus)=
;
+
+ISADevice *pc_find_fdc0(void);
+int cmos_get_fd_drive_type(FloppyDriveType fd0);
+
+#define FW_CFG_IO_BASE     0x510
+
+/* pc_sysfw.c */
+void pc_system_flash_create(PCMachineState *pcms);
+void pc_system_firmware_init(PCMachineState *pcms, MemoryRegion *rom_mem=
ory);
+
+extern GlobalProperty pc_compat_4_1[];
+extern const size_t pc_compat_4_1_len;
+
+extern GlobalProperty pc_compat_4_0[];
+extern const size_t pc_compat_4_0_len;
+
+extern GlobalProperty pc_compat_3_1[];
+extern const size_t pc_compat_3_1_len;
+
+extern GlobalProperty pc_compat_3_0[];
+extern const size_t pc_compat_3_0_len;
+
+extern GlobalProperty pc_compat_2_12[];
+extern const size_t pc_compat_2_12_len;
+
+extern GlobalProperty pc_compat_2_11[];
+extern const size_t pc_compat_2_11_len;
+
+extern GlobalProperty pc_compat_2_10[];
+extern const size_t pc_compat_2_10_len;
+
+extern GlobalProperty pc_compat_2_9[];
+extern const size_t pc_compat_2_9_len;
+
+extern GlobalProperty pc_compat_2_8[];
+extern const size_t pc_compat_2_8_len;
+
+extern GlobalProperty pc_compat_2_7[];
+extern const size_t pc_compat_2_7_len;
+
+extern GlobalProperty pc_compat_2_6[];
+extern const size_t pc_compat_2_6_len;
+
+extern GlobalProperty pc_compat_2_5[];
+extern const size_t pc_compat_2_5_len;
+
+extern GlobalProperty pc_compat_2_4[];
+extern const size_t pc_compat_2_4_len;
+
+extern GlobalProperty pc_compat_2_3[];
+extern const size_t pc_compat_2_3_len;
+
+extern GlobalProperty pc_compat_2_2[];
+extern const size_t pc_compat_2_2_len;
+
+extern GlobalProperty pc_compat_2_1[];
+extern const size_t pc_compat_2_1_len;
+
+extern GlobalProperty pc_compat_2_0[];
+extern const size_t pc_compat_2_0_len;
+
+extern GlobalProperty pc_compat_1_7[];
+extern const size_t pc_compat_1_7_len;
+
+extern GlobalProperty pc_compat_1_6[];
+extern const size_t pc_compat_1_6_len;
+
+extern GlobalProperty pc_compat_1_5[];
+extern const size_t pc_compat_1_5_len;
+
+extern GlobalProperty pc_compat_1_4[];
+extern const size_t pc_compat_1_4_len;
+
+/*
+ * Helper for setting model-id for CPU models that changed model-id
+ * depending on QEMU versions up to QEMU 2.4.
+ */
+#define PC_CPU_MODEL_IDS(v) \
+    { "qemu32-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v,=
 },\
+    { "qemu64-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v,=
 },\
+    { "athlon-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v,=
 },
+
+#define DEFINE_PC_MACHINE(suffix, namestr, initfn, optsfn) \
+    static void pc_machine_##suffix##_class_init(ObjectClass *oc, void *=
data) \
+    { \
+        MachineClass *mc =3D MACHINE_CLASS(oc); \
+        optsfn(mc); \
+        mc->init =3D initfn; \
+    } \
+    static const TypeInfo pc_machine_type_##suffix =3D { \
+        .name       =3D namestr TYPE_MACHINE_SUFFIX, \
+        .parent     =3D TYPE_PC_MACHINE, \
+        .class_init =3D pc_machine_##suffix##_class_init, \
+    }; \
+    static void pc_machine_init_##suffix(void) \
+    { \
+        type_register(&pc_machine_type_##suffix); \
+    } \
+    type_init(pc_machine_init_##suffix)
+
+#endif
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 2ef6e2cfff..9a5633a394 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -4,9 +4,7 @@
 #include "exec/memory.h"
 #include "hw/boards.h"
 #include "hw/isa/isa.h"
-#include "hw/block/fdc.h"
 #include "hw/block/flash.h"
-#include "net/net.h"
 #include "hw/i386/ioapic.h"
 #include "hw/i386/x86.h"
=20
@@ -58,14 +56,6 @@ struct PCMachineState {
     hwaddr memhp_io_base;
 };
=20
-#define PC_MACHINE_ACPI_DEVICE_PROP "acpi-device"
-#define PC_MACHINE_DEVMEM_REGION_SIZE "device-memory-region-size"
-#define PC_MACHINE_VMPORT           "vmport"
-#define PC_MACHINE_SMM              "smm"
-#define PC_MACHINE_SMBUS            "smbus"
-#define PC_MACHINE_SATA             "sata"
-#define PC_MACHINE_PIT              "pit"
-
 /**
  * PCMachineClass:
  *
@@ -173,12 +163,6 @@ void vmmouse_set_data(const uint32_t *data);
 extern int fd_bootchk;
=20
 bool pc_machine_is_smm_enabled(PCMachineState *pcms);
-void pc_acpi_smi_interrupt(void *opaque, int irq, int level);
-
-void pc_hot_add_cpu(MachineState *ms, const int64_t id, Error **errp);
-void pc_smp_parse(MachineState *ms, QemuOpts *opts);
-
-void pc_guest_info_init(PCMachineState *pcms);
=20
 #define PCI_HOST_PROP_PCI_HOLE_START   "pci-hole-start"
 #define PCI_HOST_PROP_PCI_HOLE_END     "pci-hole-end"
@@ -192,31 +176,12 @@ void pc_guest_info_init(PCMachineState *pcms);
 void pc_pci_as_mapping_init(Object *owner, MemoryRegion *system_memory,
                             MemoryRegion *pci_address_space);
=20
-void xen_load_linux(PCMachineState *pcms);
-void pc_memory_init(PCMachineState *pcms,
-                    MemoryRegion *system_memory,
-                    MemoryRegion *rom_memory,
-                    MemoryRegion **ram_memory);
 uint64_t pc_pci_hole64_start(void);
 DeviceState *pc_vga_init(ISABus *isa_bus, PCIBus *pci_bus);
-void pc_basic_device_init(ISABus *isa_bus, qemu_irq *gsi,
-                          ISADevice **rtc_state,
-                          bool create_fdctrl,
-                          bool no_vmport,
-                          bool has_pit,
-                          uint32_t hpet_irqs);
-void pc_init_ne2k_isa(ISABus *bus, NICInfo *nd);
-void pc_cmos_init(PCMachineState *pcms,
-                  BusState *ide0, BusState *ide1,
-                  ISADevice *s);
-void pc_nic_init(PCMachineClass *pcmc, ISABus *isa_bus, PCIBus *pci_bus)=
;
=20
 void pc_i8259_create(ISABus *isa_bus, qemu_irq *i8259_irqs);
 void ioapic_init_gsi(GSIState *gsi_state, const char *parent_name);
=20
-ISADevice *pc_find_fdc0(void);
-int cmos_get_fd_drive_type(FloppyDriveType fd0);
-
 #define FW_CFG_IO_BASE     0x510
=20
 #define PORT92_A20_LINE "a20"
@@ -224,102 +189,9 @@ int cmos_get_fd_drive_type(FloppyDriveType fd0);
 /* hpet.c */
 extern int no_hpet;
=20
-/* pc_sysfw.c */
-void pc_system_flash_create(PCMachineState *pcms);
-void pc_system_firmware_init(PCMachineState *pcms, MemoryRegion *rom_mem=
ory);
-
 /* acpi-build.c */
 void pc_madt_cpu_entry(AcpiDeviceIf *adev, int uid,
                        const CPUArchIdList *apic_ids, GArray *entry);
=20
-extern GlobalProperty pc_compat_4_1[];
-extern const size_t pc_compat_4_1_len;
-
-extern GlobalProperty pc_compat_4_0[];
-extern const size_t pc_compat_4_0_len;
-
-extern GlobalProperty pc_compat_3_1[];
-extern const size_t pc_compat_3_1_len;
-
-extern GlobalProperty pc_compat_3_0[];
-extern const size_t pc_compat_3_0_len;
-
-extern GlobalProperty pc_compat_2_12[];
-extern const size_t pc_compat_2_12_len;
-
-extern GlobalProperty pc_compat_2_11[];
-extern const size_t pc_compat_2_11_len;
-
-extern GlobalProperty pc_compat_2_10[];
-extern const size_t pc_compat_2_10_len;
-
-extern GlobalProperty pc_compat_2_9[];
-extern const size_t pc_compat_2_9_len;
-
-extern GlobalProperty pc_compat_2_8[];
-extern const size_t pc_compat_2_8_len;
-
-extern GlobalProperty pc_compat_2_7[];
-extern const size_t pc_compat_2_7_len;
-
-extern GlobalProperty pc_compat_2_6[];
-extern const size_t pc_compat_2_6_len;
-
-extern GlobalProperty pc_compat_2_5[];
-extern const size_t pc_compat_2_5_len;
-
-extern GlobalProperty pc_compat_2_4[];
-extern const size_t pc_compat_2_4_len;
-
-extern GlobalProperty pc_compat_2_3[];
-extern const size_t pc_compat_2_3_len;
-
-extern GlobalProperty pc_compat_2_2[];
-extern const size_t pc_compat_2_2_len;
-
-extern GlobalProperty pc_compat_2_1[];
-extern const size_t pc_compat_2_1_len;
-
-extern GlobalProperty pc_compat_2_0[];
-extern const size_t pc_compat_2_0_len;
-
-extern GlobalProperty pc_compat_1_7[];
-extern const size_t pc_compat_1_7_len;
-
-extern GlobalProperty pc_compat_1_6[];
-extern const size_t pc_compat_1_6_len;
-
-extern GlobalProperty pc_compat_1_5[];
-extern const size_t pc_compat_1_5_len;
-
-extern GlobalProperty pc_compat_1_4[];
-extern const size_t pc_compat_1_4_len;
-
-/* Helper for setting model-id for CPU models that changed model-id
- * depending on QEMU versions up to QEMU 2.4.
- */
-#define PC_CPU_MODEL_IDS(v) \
-    { "qemu32-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v,=
 },\
-    { "qemu64-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v,=
 },\
-    { "athlon-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v,=
 },
-
-#define DEFINE_PC_MACHINE(suffix, namestr, initfn, optsfn) \
-    static void pc_machine_##suffix##_class_init(ObjectClass *oc, void *=
data) \
-    { \
-        MachineClass *mc =3D MACHINE_CLASS(oc); \
-        optsfn(mc); \
-        mc->init =3D initfn; \
-    } \
-    static const TypeInfo pc_machine_type_##suffix =3D { \
-        .name       =3D namestr TYPE_MACHINE_SUFFIX, \
-        .parent     =3D TYPE_PC_MACHINE, \
-        .class_init =3D pc_machine_##suffix##_class_init, \
-    }; \
-    static void pc_machine_init_##suffix(void) \
-    { \
-        type_register(&pc_machine_type_##suffix); \
-    } \
-    type_init(pc_machine_init_##suffix)
-
 extern void igd_passthrough_isa_bridge_create(PCIBus *bus, uint16_t gpu_=
dev_id);
 #endif
diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
index 291909fa05..7267e9754f 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -64,6 +64,7 @@
 #include "hw/acpi/pci.h"
=20
 #include "qom/qom-qobject.h"
+#include "hw/i386/pc_internal.h"
 #include "hw/i386/amd_iommu.h"
 #include "hw/i386/intel_iommu.h"
=20
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 4c018735b0..df879ff8e5 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -26,6 +26,7 @@
 #include "qemu/units.h"
 #include "hw/i386/x86.h"
 #include "hw/i386/pc.h"
+#include "hw/i386/pc_internal.h"
 #include "hw/char/serial.h"
 #include "hw/char/parallel.h"
 #include "hw/i386/apic.h"
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 1bd70d1abb..a7f67f39a8 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -29,6 +29,7 @@
 #include "hw/loader.h"
 #include "hw/i386/x86.h"
 #include "hw/i386/pc.h"
+#include "hw/i386/pc_internal.h"
 #include "hw/i386/apic.h"
 #include "hw/pci-host/i440fx.h"
 #include "hw/southbridge/piix.h"
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 385e5cffb1..d1d251cb26 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -42,6 +42,7 @@
 #include "exec/address-spaces.h"
 #include "hw/i386/x86.h"
 #include "hw/i386/pc.h"
+#include "hw/i386/pc_internal.h"
 #include "hw/i386/ich9.h"
 #include "hw/i386/amd_iommu.h"
 #include "hw/i386/intel_iommu.h"
diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index f5f3f466b0..6762a6b453 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -33,6 +33,7 @@
 #include "hw/sysbus.h"
 #include "hw/i386/x86.h"
 #include "hw/i386/pc.h"
+#include "hw/i386/pc_internal.h"
 #include "hw/loader.h"
 #include "hw/qdev-properties.h"
 #include "sysemu/sysemu.h"
diff --git a/hw/i386/xen/xen-hvm.c b/hw/i386/xen/xen-hvm.c
index 82ece6b9e7..26e6d013d0 100644
--- a/hw/i386/xen/xen-hvm.c
+++ b/hw/i386/xen/xen-hvm.c
@@ -14,6 +14,7 @@
 #include "hw/pci/pci.h"
 #include "hw/pci/pci_host.h"
 #include "hw/i386/pc.h"
+#include "hw/i386/pc_internal.h"
 #include "hw/southbridge/piix.h"
 #include "hw/irq.h"
 #include "hw/hw.h"
--=20
2.21.0


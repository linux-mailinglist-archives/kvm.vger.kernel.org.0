Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E9C11E80A
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 17:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbfLMQU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 11:20:29 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48241 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728237AbfLMQU2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 11:20:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576254027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2EftjF8HiFSpwXHv8YZWYjoqxeIDtjy2n7wAZHjtMGk=;
        b=A7+DBJ7RSW942P7zwXRg7R/4n94VRlMi/c+EYQ01Y06nQzqCZ/sThWMLJn63sTY5tB0oNo
        lvCGQte90GCw1wP93Gj518KogjhUpFe2GXxwSisgw4ZjsG6i6HiCM/DBO06m8HP2NOeyuW
        P5DKzHrfleAOjeUz2SFgVMT+ONgAO80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-fqun19fLNLSrG9Al94wyOA-1; Fri, 13 Dec 2019 11:20:26 -0500
X-MC-Unique: fqun19fLNLSrG9Al94wyOA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89139800D4E;
        Fri, 13 Dec 2019 16:20:24 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E95AD19481;
        Fri, 13 Dec 2019 16:20:12 +0000 (UTC)
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
Subject: [PATCH 11/12] hw/i386/pc: Move x86_machine_allocate_cpu_irq() to 'hw/i386/x86.c'
Date:   Fri, 13 Dec 2019 17:17:52 +0100
Message-Id: <20191213161753.8051-12-philmd@redhat.com>
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

Keep 'pc.c' for PC-machine specific code, and use 'x86.c' for code
used by all the X86-based machines.

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 include/hw/i386/pc.h  |  1 -
 include/hw/i386/x86.h |  2 ++
 hw/i386/pc.c          | 27 ---------------------------
 hw/i386/x86.c         | 30 ++++++++++++++++++++++++++++++
 4 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 244dbf2ec0..2ef6e2cfff 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -198,7 +198,6 @@ void pc_memory_init(PCMachineState *pcms,
                     MemoryRegion *rom_memory,
                     MemoryRegion **ram_memory);
 uint64_t pc_pci_hole64_start(void);
-qemu_irq x86_machine_allocate_cpu_irq(void);
 DeviceState *pc_vga_init(ISABus *isa_bus, PCIBus *pci_bus);
 void pc_basic_device_init(ISABus *isa_bus, qemu_irq *gsi,
                           ISADevice **rtc_state,
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index 4b84917885..4c3dd6f33e 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -95,4 +95,6 @@ void x86_load_linux(X86MachineState *x86ms,
                     bool pvh_enabled,
                     bool linuxboot_dma_enabled);
=20
+qemu_irq x86_machine_allocate_cpu_irq(void);
+
 #endif
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 4defee274f..4c018735b0 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -412,28 +412,6 @@ int cpu_get_pic_interrupt(CPUX86State *env)
     return intno;
 }
=20
-static void pic_irq_request(void *opaque, int irq, int level)
-{
-    CPUState *cs =3D first_cpu;
-    X86CPU *cpu =3D X86_CPU(cs);
-
-    trace_x86_pic_interrupt(irq, level);
-    if (cpu->apic_state && !kvm_irqchip_in_kernel()) {
-        CPU_FOREACH(cs) {
-            cpu =3D X86_CPU(cs);
-            if (apic_accept_pic_intr(cpu->apic_state)) {
-                apic_deliver_pic_intr(cpu->apic_state, level);
-            }
-        }
-    } else {
-        if (level) {
-            cpu_interrupt(cs, CPU_INTERRUPT_HARD);
-        } else {
-            cpu_reset_interrupt(cs, CPU_INTERRUPT_HARD);
-        }
-    }
-}
-
 /* PC cmos mappings */
=20
 #define REG_EQUIPMENT_BYTE          0x14
@@ -1282,11 +1260,6 @@ uint64_t pc_pci_hole64_start(void)
     return ROUND_UP(hole64_start, 1 * GiB);
 }
=20
-qemu_irq x86_machine_allocate_cpu_irq(void)
-{
-    return qemu_allocate_irq(pic_irq_request, NULL, 0);
-}
-
 DeviceState *pc_vga_init(ISABus *isa_bus, PCIBus *pci_bus)
 {
     DeviceState *dev =3D NULL;
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 394edc2f72..a6a394ca36 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -34,6 +34,7 @@
 #include "sysemu/numa.h"
 #include "sysemu/replay.h"
 #include "sysemu/sysemu.h"
+#include "sysemu/kvm.h"
=20
 #include "hw/i386/x86.h"
 #include "target/i386/cpu.h"
@@ -41,11 +42,13 @@
 #include "hw/i386/fw_cfg.h"
=20
 #include "hw/acpi/cpu_hotplug.h"
+#include "hw/irq.h"
 #include "hw/nmi.h"
 #include "hw/loader.h"
 #include "multiboot.h"
 #include "elf.h"
 #include "standard-headers/asm-x86/bootparam.h"
+#include "trace.h"
=20
 #define BIOS_FILENAME "bios.bin"
=20
@@ -206,6 +209,33 @@ static void x86_nmi(NMIState *n, int cpu_index, Erro=
r **errp)
     }
 }
=20
+static void pic_irq_request(void *opaque, int irq, int level)
+{
+    CPUState *cs =3D first_cpu;
+    X86CPU *cpu =3D X86_CPU(cs);
+
+    trace_x86_pic_interrupt(irq, level);
+    if (cpu->apic_state && !kvm_irqchip_in_kernel()) {
+        CPU_FOREACH(cs) {
+            cpu =3D X86_CPU(cs);
+            if (apic_accept_pic_intr(cpu->apic_state)) {
+                apic_deliver_pic_intr(cpu->apic_state, level);
+            }
+        }
+    } else {
+        if (level) {
+            cpu_interrupt(cs, CPU_INTERRUPT_HARD);
+        } else {
+            cpu_reset_interrupt(cs, CPU_INTERRUPT_HARD);
+        }
+    }
+}
+
+qemu_irq x86_machine_allocate_cpu_irq(void)
+{
+    return qemu_allocate_irq(pic_irq_request, NULL, 0);
+}
+
 static long get_file_size(FILE *f)
 {
     long where, size;
--=20
2.21.0


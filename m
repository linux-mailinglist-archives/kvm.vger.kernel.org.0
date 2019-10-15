Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B526D7B99
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388072AbfJOQbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:31:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388085AbfJOQbE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:31:04 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 51DDC3090FC6;
        Tue, 15 Oct 2019 16:31:04 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B2C319C58;
        Tue, 15 Oct 2019 16:30:55 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Markovic <amarkovic@wavecomp.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        xen-devel@lists.xenproject.org,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 20/32] hw/i386/pc: Extract pc_gsi_create()
Date:   Tue, 15 Oct 2019 18:26:53 +0200
Message-Id: <20191015162705.28087-21-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 15 Oct 2019 16:31:04 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The GSI creation code is common to all PC machines, extract the
common code.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/pc.c         | 15 +++++++++++++++
 hw/i386/pc_piix.c    |  9 +--------
 hw/i386/pc_q35.c     |  9 +--------
 include/hw/i386/pc.h |  2 ++
 4 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index bcda50efcc..a7597c6c44 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -357,6 +357,21 @@ void gsi_handler(void *opaque, int n, int level)
     qemu_set_irq(s->ioapic_irq[n], level);
 }
 
+GSIState *pc_gsi_create(qemu_irq **irqs, bool pci_enabled)
+{
+    GSIState *s;
+
+    s = g_new0(GSIState, 1);
+    if (kvm_ioapic_in_kernel()) {
+        kvm_pc_setup_irq_routing(pci_enabled);
+        *irqs = qemu_allocate_irqs(kvm_pc_gsi_handler, s, GSI_NUM_PINS);
+    } else {
+        *irqs = qemu_allocate_irqs(gsi_handler, s, GSI_NUM_PINS);
+    }
+
+    return s;
+}
+
 static void ioport80_write(void *opaque, hwaddr addr, uint64_t data,
                            unsigned size)
 {
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 431965d921..452b107e1b 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -188,14 +188,7 @@ static void pc_init1(MachineState *machine,
         xen_load_linux(pcms);
     }
 
-    gsi_state = g_malloc0(sizeof(*gsi_state));
-    if (kvm_ioapic_in_kernel()) {
-        kvm_pc_setup_irq_routing(pcmc->pci_enabled);
-        pcms->gsi = qemu_allocate_irqs(kvm_pc_gsi_handler, gsi_state,
-                                       GSI_NUM_PINS);
-    } else {
-        pcms->gsi = qemu_allocate_irqs(gsi_handler, gsi_state, GSI_NUM_PINS);
-    }
+    gsi_state = pc_gsi_create(&pcms->gsi, pcmc->pci_enabled);
 
     if (pcmc->pci_enabled) {
         pci_bus = i440fx_init(host_type,
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 8fad20f314..52261962b8 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -210,14 +210,7 @@ static void pc_q35_init(MachineState *machine)
     }
 
     /* irq lines */
-    gsi_state = g_malloc0(sizeof(*gsi_state));
-    if (kvm_ioapic_in_kernel()) {
-        kvm_pc_setup_irq_routing(pcmc->pci_enabled);
-        pcms->gsi = qemu_allocate_irqs(kvm_pc_gsi_handler, gsi_state,
-                                       GSI_NUM_PINS);
-    } else {
-        pcms->gsi = qemu_allocate_irqs(gsi_handler, gsi_state, GSI_NUM_PINS);
-    }
+    gsi_state = pc_gsi_create(&pcms->gsi, pcmc->pci_enabled);
 
     /* create pci host bus */
     q35_host = Q35_HOST_DEVICE(qdev_create(NULL, TYPE_Q35_HOST_DEVICE));
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index b63fc7631e..d0c6b9d469 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -174,6 +174,8 @@ typedef struct GSIState {
 
 void gsi_handler(void *opaque, int n, int level);
 
+GSIState *pc_gsi_create(qemu_irq **irqs, bool pci_enabled);
+
 /* vmport.c */
 #define TYPE_VMPORT "vmport"
 typedef uint32_t (VMPortReadFunc)(void *opaque, uint32_t address);
-- 
2.21.0


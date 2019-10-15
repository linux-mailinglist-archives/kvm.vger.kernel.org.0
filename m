Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6725D7B5F
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbfJOQ12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:27:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64031 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728521AbfJOQ12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:27:28 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BEB018E1CF1;
        Tue, 15 Oct 2019 16:27:27 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB9AE19C58;
        Tue, 15 Oct 2019 16:27:20 +0000 (UTC)
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
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH 01/32] hw/i386: Remove obsolete LoadStateHandler::load_state_old handlers
Date:   Tue, 15 Oct 2019 18:26:34 +0200
Message-Id: <20191015162705.28087-2-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Tue, 15 Oct 2019 16:27:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These devices implemented their load_state_old() handler 10 years
ago, previous to QEMU v0.12.
Since commit cc425b5ddf removed the pc-0.10 and pc-0.11 machines,
we can drop this code.

Note: the mips_r4k machine started to use the i8254 device just
after QEMU v0.5.0, but the MIPS machine types are not versioned,
so there is no migration compatibility issue removing this handler.

Suggested-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/acpi/piix4.c         | 40 ---------------------------------
 hw/intc/apic_common.c   | 49 -----------------------------------------
 hw/pci-host/piix.c      | 25 ---------------------
 hw/timer/i8254_common.c | 40 ---------------------------------
 4 files changed, 154 deletions(-)

diff --git a/hw/acpi/piix4.c b/hw/acpi/piix4.c
index 5742c3df87..1d29d438c7 100644
--- a/hw/acpi/piix4.c
+++ b/hw/acpi/piix4.c
@@ -42,7 +42,6 @@
 #include "hw/acpi/memory_hotplug.h"
 #include "hw/acpi/acpi_dev_interface.h"
 #include "hw/xen/xen.h"
-#include "migration/qemu-file-types.h"
 #include "migration/vmstate.h"
 #include "hw/core/cpu.h"
 #include "trace.h"
@@ -205,43 +204,6 @@ static const VMStateDescription vmstate_pci_status = {
     }
 };
 
-static int acpi_load_old(QEMUFile *f, void *opaque, int version_id)
-{
-    PIIX4PMState *s = opaque;
-    int ret, i;
-    uint16_t temp;
-
-    ret = pci_device_load(PCI_DEVICE(s), f);
-    if (ret < 0) {
-        return ret;
-    }
-    qemu_get_be16s(f, &s->ar.pm1.evt.sts);
-    qemu_get_be16s(f, &s->ar.pm1.evt.en);
-    qemu_get_be16s(f, &s->ar.pm1.cnt.cnt);
-
-    ret = vmstate_load_state(f, &vmstate_apm, &s->apm, 1);
-    if (ret) {
-        return ret;
-    }
-
-    timer_get(f, s->ar.tmr.timer);
-    qemu_get_sbe64s(f, &s->ar.tmr.overflow_time);
-
-    qemu_get_be16s(f, (uint16_t *)s->ar.gpe.sts);
-    for (i = 0; i < 3; i++) {
-        qemu_get_be16s(f, &temp);
-    }
-
-    qemu_get_be16s(f, (uint16_t *)s->ar.gpe.en);
-    for (i = 0; i < 3; i++) {
-        qemu_get_be16s(f, &temp);
-    }
-
-    ret = vmstate_load_state(f, &vmstate_pci_status,
-        &s->acpi_pci_hotplug.acpi_pcihp_pci_status[ACPI_PCIHP_BSEL_DEFAULT], 1);
-    return ret;
-}
-
 static bool vmstate_test_use_acpi_pci_hotplug(void *opaque, int version_id)
 {
     PIIX4PMState *s = opaque;
@@ -313,8 +275,6 @@ static const VMStateDescription vmstate_acpi = {
     .name = "piix4_pm",
     .version_id = 3,
     .minimum_version_id = 3,
-    .minimum_version_id_old = 1,
-    .load_state_old = acpi_load_old,
     .post_load = vmstate_acpi_post_load,
     .fields = (VMStateField[]) {
         VMSTATE_PCI_DEVICE(parent_obj, PIIX4PMState),
diff --git a/hw/intc/apic_common.c b/hw/intc/apic_common.c
index aafd8e0e33..375cb6abe9 100644
--- a/hw/intc/apic_common.c
+++ b/hw/intc/apic_common.c
@@ -31,7 +31,6 @@
 #include "sysemu/kvm.h"
 #include "hw/qdev-properties.h"
 #include "hw/sysbus.h"
-#include "migration/qemu-file-types.h"
 #include "migration/vmstate.h"
 
 static int apic_irq_delivered;
@@ -262,52 +261,6 @@ static void apic_reset_common(DeviceState *dev)
     apic_init_reset(dev);
 }
 
-/* This function is only used for old state version 1 and 2 */
-static int apic_load_old(QEMUFile *f, void *opaque, int version_id)
-{
-    APICCommonState *s = opaque;
-    APICCommonClass *info = APIC_COMMON_GET_CLASS(s);
-    int i;
-
-    if (version_id > 2) {
-        return -EINVAL;
-    }
-
-    /* XXX: what if the base changes? (registered memory regions) */
-    qemu_get_be32s(f, &s->apicbase);
-    qemu_get_8s(f, &s->id);
-    qemu_get_8s(f, &s->arb_id);
-    qemu_get_8s(f, &s->tpr);
-    qemu_get_be32s(f, &s->spurious_vec);
-    qemu_get_8s(f, &s->log_dest);
-    qemu_get_8s(f, &s->dest_mode);
-    for (i = 0; i < 8; i++) {
-        qemu_get_be32s(f, &s->isr[i]);
-        qemu_get_be32s(f, &s->tmr[i]);
-        qemu_get_be32s(f, &s->irr[i]);
-    }
-    for (i = 0; i < APIC_LVT_NB; i++) {
-        qemu_get_be32s(f, &s->lvt[i]);
-    }
-    qemu_get_be32s(f, &s->esr);
-    qemu_get_be32s(f, &s->icr[0]);
-    qemu_get_be32s(f, &s->icr[1]);
-    qemu_get_be32s(f, &s->divide_conf);
-    s->count_shift = qemu_get_be32(f);
-    qemu_get_be32s(f, &s->initial_count);
-    s->initial_count_load_time = qemu_get_be64(f);
-    s->next_time = qemu_get_be64(f);
-
-    if (version_id >= 2) {
-        s->timer_expiry = qemu_get_be64(f);
-    }
-
-    if (info->post_load) {
-        info->post_load(s);
-    }
-    return 0;
-}
-
 static const VMStateDescription vmstate_apic_common;
 
 static void apic_common_realize(DeviceState *dev, Error **errp)
@@ -408,8 +361,6 @@ static const VMStateDescription vmstate_apic_common = {
     .name = "apic",
     .version_id = 3,
     .minimum_version_id = 3,
-    .minimum_version_id_old = 1,
-    .load_state_old = apic_load_old,
     .pre_load = apic_pre_load,
     .pre_save = apic_dispatch_pre_save,
     .post_load = apic_dispatch_post_load,
diff --git a/hw/pci-host/piix.c b/hw/pci-host/piix.c
index 135c645535..2f4cbcbfe9 100644
--- a/hw/pci-host/piix.c
+++ b/hw/pci-host/piix.c
@@ -33,7 +33,6 @@
 #include "qapi/error.h"
 #include "qemu/range.h"
 #include "hw/xen/xen.h"
-#include "migration/qemu-file-types.h"
 #include "migration/vmstate.h"
 #include "hw/pci-host/pam.h"
 #include "sysemu/reset.h"
@@ -174,28 +173,6 @@ static void i440fx_write_config(PCIDevice *dev,
     }
 }
 
-static int i440fx_load_old(QEMUFile* f, void *opaque, int version_id)
-{
-    PCII440FXState *d = opaque;
-    PCIDevice *pd = PCI_DEVICE(d);
-    int ret, i;
-    uint8_t smm_enabled;
-
-    ret = pci_device_load(pd, f);
-    if (ret < 0)
-        return ret;
-    i440fx_update_memory_mappings(d);
-    qemu_get_8s(f, &smm_enabled);
-
-    if (version_id == 2) {
-        for (i = 0; i < PIIX_NUM_PIRQS; i++) {
-            qemu_get_be32(f); /* dummy load for compatibility */
-        }
-    }
-
-    return 0;
-}
-
 static int i440fx_post_load(void *opaque, int version_id)
 {
     PCII440FXState *d = opaque;
@@ -208,8 +185,6 @@ static const VMStateDescription vmstate_i440fx = {
     .name = "I440FX",
     .version_id = 3,
     .minimum_version_id = 3,
-    .minimum_version_id_old = 1,
-    .load_state_old = i440fx_load_old,
     .post_load = i440fx_post_load,
     .fields = (VMStateField[]) {
         VMSTATE_PCI_DEVICE(parent_obj, PCII440FXState),
diff --git a/hw/timer/i8254_common.c b/hw/timer/i8254_common.c
index 57bf10cc94..050875b497 100644
--- a/hw/timer/i8254_common.c
+++ b/hw/timer/i8254_common.c
@@ -29,7 +29,6 @@
 #include "qemu/timer.h"
 #include "hw/timer/i8254.h"
 #include "hw/timer/i8254_internal.h"
-#include "migration/qemu-file-types.h"
 #include "migration/vmstate.h"
 
 /* val must be 0 or 1 */
@@ -202,43 +201,6 @@ static const VMStateDescription vmstate_pit_channel = {
     }
 };
 
-static int pit_load_old(QEMUFile *f, void *opaque, int version_id)
-{
-    PITCommonState *pit = opaque;
-    PITCommonClass *c = PIT_COMMON_GET_CLASS(pit);
-    PITChannelState *s;
-    int i;
-
-    if (version_id != 1) {
-        return -EINVAL;
-    }
-
-    for (i = 0; i < 3; i++) {
-        s = &pit->channels[i];
-        s->count = qemu_get_be32(f);
-        qemu_get_be16s(f, &s->latched_count);
-        qemu_get_8s(f, &s->count_latched);
-        qemu_get_8s(f, &s->status_latched);
-        qemu_get_8s(f, &s->status);
-        qemu_get_8s(f, &s->read_state);
-        qemu_get_8s(f, &s->write_state);
-        qemu_get_8s(f, &s->write_latch);
-        qemu_get_8s(f, &s->rw_mode);
-        qemu_get_8s(f, &s->mode);
-        qemu_get_8s(f, &s->bcd);
-        qemu_get_8s(f, &s->gate);
-        s->count_load_time = qemu_get_be64(f);
-        s->irq_disabled = 0;
-        if (i == 0) {
-            s->next_transition_time = qemu_get_be64(f);
-        }
-    }
-    if (c->post_load) {
-        c->post_load(pit);
-    }
-    return 0;
-}
-
 static int pit_dispatch_pre_save(void *opaque)
 {
     PITCommonState *s = opaque;
@@ -266,8 +228,6 @@ static const VMStateDescription vmstate_pit_common = {
     .name = "i8254",
     .version_id = 3,
     .minimum_version_id = 2,
-    .minimum_version_id_old = 1,
-    .load_state_old = pit_load_old,
     .pre_save = pit_dispatch_pre_save,
     .post_load = pit_dispatch_post_load,
     .fields = (VMStateField[]) {
-- 
2.21.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BAC274A05
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 22:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgIVUTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 16:19:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726448AbgIVUTn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 16:19:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600805981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=52XNin5Hd63T3Wdn9qi1J9VaOtpC4qNSf/yGry9fMRE=;
        b=g0/M9i0GY/WSarWje8twyFE8WOypnj23Dx9czpCoNNUft4U4LmBoyEy4Y/ithX1wnAyHJK
        Plns/NGRHcrnpy7WFox6QHg9fQqOpIc0ixS1MB/33elf/X52MX4+6mrdvo/kaXJP+yUcuL
        Us0rmfZJxoREZc9TGHO7Peo2c9GRpng=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-lpF4hf4rMqOJmjGEfKsm1g-1; Tue, 22 Sep 2020 16:19:39 -0400
X-MC-Unique: lpF4hf4rMqOJmjGEfKsm1g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D481104D3E2;
        Tue, 22 Sep 2020 20:19:38 +0000 (UTC)
Received: from localhost (unknown [10.10.67.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEE075DE86;
        Tue, 22 Sep 2020 20:19:37 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sergio Lopez <slp@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 2/3] i386/kvm: Remove IRQ routing support checks
Date:   Tue, 22 Sep 2020 16:19:21 -0400
Message-Id: <20200922201922.2153598-3-ehabkost@redhat.com>
In-Reply-To: <20200922201922.2153598-1-ehabkost@redhat.com>
References: <20200922201922.2153598-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_IRQ_ROUTING is always available on x86, so replace checks
for kvm_has_gsi_routing() and KVM_CAP_IRQ_ROUTING with asserts.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 hw/i386/kvm/apic.c   |  5 ++---
 hw/i386/kvm/ioapic.c | 33 ++++++++++++++++-----------------
 target/i386/kvm.c    |  7 -------
 3 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/hw/i386/kvm/apic.c b/hw/i386/kvm/apic.c
index 4eb2d77b87b..dd29906061c 100644
--- a/hw/i386/kvm/apic.c
+++ b/hw/i386/kvm/apic.c
@@ -225,9 +225,8 @@ static void kvm_apic_realize(DeviceState *dev, Error **errp)
     memory_region_init_io(&s->io_memory, OBJECT(s), &kvm_apic_io_ops, s,
                           "kvm-apic-msi", APIC_SPACE_SIZE);
 
-    if (kvm_has_gsi_routing()) {
-        msi_nonbroken = true;
-    }
+    assert(kvm_has_gsi_routing());
+    msi_nonbroken = true;
 }
 
 static void kvm_apic_unrealize(DeviceState *dev)
diff --git a/hw/i386/kvm/ioapic.c b/hw/i386/kvm/ioapic.c
index c5528df942a..dfc3c980057 100644
--- a/hw/i386/kvm/ioapic.c
+++ b/hw/i386/kvm/ioapic.c
@@ -25,27 +25,26 @@ void kvm_pc_setup_irq_routing(bool pci_enabled)
     KVMState *s = kvm_state;
     int i;
 
-    if (kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
-        for (i = 0; i < 8; ++i) {
-            if (i == 2) {
-                continue;
-            }
-            kvm_irqchip_add_irq_route(s, i, KVM_IRQCHIP_PIC_MASTER, i);
-        }
-        for (i = 8; i < 16; ++i) {
-            kvm_irqchip_add_irq_route(s, i, KVM_IRQCHIP_PIC_SLAVE, i - 8);
+    assert(kvm_has_gsi_routing());
+    for (i = 0; i < 8; ++i) {
+        if (i == 2) {
+            continue;
         }
-        if (pci_enabled) {
-            for (i = 0; i < 24; ++i) {
-                if (i == 0) {
-                    kvm_irqchip_add_irq_route(s, i, KVM_IRQCHIP_IOAPIC, 2);
-                } else if (i != 2) {
-                    kvm_irqchip_add_irq_route(s, i, KVM_IRQCHIP_IOAPIC, i);
-                }
+        kvm_irqchip_add_irq_route(s, i, KVM_IRQCHIP_PIC_MASTER, i);
+    }
+    for (i = 8; i < 16; ++i) {
+        kvm_irqchip_add_irq_route(s, i, KVM_IRQCHIP_PIC_SLAVE, i - 8);
+    }
+    if (pci_enabled) {
+        for (i = 0; i < 24; ++i) {
+            if (i == 0) {
+                kvm_irqchip_add_irq_route(s, i, KVM_IRQCHIP_IOAPIC, 2);
+            } else if (i != 2) {
+                kvm_irqchip_add_irq_route(s, i, KVM_IRQCHIP_IOAPIC, i);
             }
         }
-        kvm_irqchip_commit_routes(s);
     }
+    kvm_irqchip_commit_routes(s);
 }
 
 typedef struct KVMIOAPICState KVMIOAPICState;
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index d884ff1b071..cf6dc90f7c5 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -4558,13 +4558,6 @@ bool kvm_arch_stop_on_emulation_error(CPUState *cs)
 
 void kvm_arch_init_irq_routing(KVMState *s)
 {
-    if (!kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
-        /* If kernel can't do irq routing, interrupt source
-         * override 0->2 cannot be set up as required by HPET.
-         * So we have to disable it.
-         */
-        no_hpet = 1;
-    }
     /* We know at this point that we're using the in-kernel
      * irqchip, so we can use irqfds, and on x86 we know
      * we can use msi via irqfd and GSI routing.
-- 
2.26.2


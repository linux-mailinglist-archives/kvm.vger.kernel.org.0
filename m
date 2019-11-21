Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 025611047C7
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 01:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfKUA6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 19:58:47 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:44437 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbfKUA6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 19:58:46 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 47JLm41Hqpz9sNx; Thu, 21 Nov 2019 11:58:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1574297924;
        bh=fREJuuqgAEuiDzU2O79CZ0GSodqvDi8dVSOI0miZGuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcxKWzfsNp+TDMm/FcmYOF/G6BK8Fwdx7sj3AbbpJBecSmOD3EvejoKZXJ9Hdo5X4
         GBJcG9PY7fmZVX3w/91Q8nXcqBSmyoGG35fPguQUP2szAqbFxrua9emPjVKUaoeYJL
         b8W+cjT9+2k1AAe70PVOMNqijScMEkmCl0xnVIm4=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Alex Williamson <alex.williamson@redhat.com>, clg@kaod.org
Cc:     groug@kaod.org, philmd@redhat.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Riku Voipio <riku.voipio@iki.fi>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH 1/5] kvm: Introduce KVM irqchip change notifier
Date:   Thu, 21 Nov 2019 11:56:03 +1100
Message-Id: <20191121005607.274347-2-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191121005607.274347-1-david@gibson.dropbear.id.au>
References: <20191121005607.274347-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Awareness of an in kernel irqchip is usually local to the machine and its
top-level interrupt controller.  However, in a few cases other things need
to know about it.  In particular vfio devices need this in order to
accelerate interrupt delivery.

If interrupt routing is changed, such devices may need to readjust their
connection to the KVM irqchip.  pci_bus_fire_intx_routing_notifier() exists
to do just this.

However, for the pseries machine type we have a situation where the routing
remains constant but the top-level irq chip itself is changed.  This occurs
because of PAPR feature negotiation which allows the guest to decide
between the older XICS and newer XIVE irq chip models (both of which are
paravirtualized).

To allow devices like vfio to adjust to this change, introduce a new
notifier for the purpose kvm_irqchip_change_notify().

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 accel/kvm/kvm-all.c    | 18 ++++++++++++++++++
 accel/stubs/kvm-stub.c | 12 ++++++++++++
 include/sysemu/kvm.h   |  5 +++++
 3 files changed, 35 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 140b0bd8f6..ca00daa2f5 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -149,6 +149,9 @@ static const KVMCapabilityInfo kvm_required_capabilites[] = {
     KVM_CAP_LAST_INFO
 };
 
+static NotifierList kvm_irqchip_change_notifiers =
+    NOTIFIER_LIST_INITIALIZER(kvm_irqchip_change_notifiers);
+
 #define kvm_slots_lock(kml)      qemu_mutex_lock(&(kml)->slots_lock)
 #define kvm_slots_unlock(kml)    qemu_mutex_unlock(&(kml)->slots_lock)
 
@@ -1396,6 +1399,21 @@ void kvm_irqchip_release_virq(KVMState *s, int virq)
     trace_kvm_irqchip_release_virq(virq);
 }
 
+void kvm_irqchip_add_change_notifier(Notifier *n)
+{
+    notifier_list_add(&kvm_irqchip_change_notifiers, n);
+}
+
+void kvm_irqchip_remove_change_notifier(Notifier *n)
+{
+    notifier_remove(n);
+}
+
+void kvm_irqchip_change_notify(void)
+{
+    notifier_list_notify(&kvm_irqchip_change_notifiers, NULL);
+}
+
 static unsigned int kvm_hash_msi(uint32_t data)
 {
     /* This is optimized for IA32 MSI layout. However, no other arch shall
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 6feb66ed80..82f118d2df 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -138,6 +138,18 @@ void kvm_irqchip_commit_routes(KVMState *s)
 {
 }
 
+void kvm_irqchip_add_change_notifier(Notifier *n)
+{
+}
+
+void kvm_irqchip_remove_change_notifier(Notifier *n)
+{
+}
+
+void kvm_irqchip_change_notify(void)
+{
+}
+
 int kvm_irqchip_add_adapter_route(KVMState *s, AdapterInfo *adapter)
 {
     return -ENOSYS;
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 9d143282bc..9fe233b9bf 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -201,6 +201,7 @@ typedef struct KVMCapabilityInfo {
 struct KVMState;
 typedef struct KVMState KVMState;
 extern KVMState *kvm_state;
+typedef struct Notifier Notifier;
 
 /* external API */
 
@@ -401,6 +402,10 @@ int kvm_irqchip_send_msi(KVMState *s, MSIMessage msg);
 
 void kvm_irqchip_add_irq_route(KVMState *s, int gsi, int irqchip, int pin);
 
+void kvm_irqchip_add_change_notifier(Notifier *n);
+void kvm_irqchip_remove_change_notifier(Notifier *n);
+void kvm_irqchip_change_notify(void);
+
 void kvm_get_apic_state(DeviceState *d, struct kvm_lapic_state *kapic);
 
 struct kvm_guest_debug;
-- 
2.23.0


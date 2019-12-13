Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7C111E284
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 12:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfLMLHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 06:07:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24996 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725948AbfLMLHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 06:07:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576235269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9YVwxsrA7bHU0ZxobUQ7B9E7z5AaZfc5ooyfIz7vtGg=;
        b=AC1y87w2JjQDb94mQxvye37nJ6TRi02WuodYhTxpIxKpwbo4SzdeIxuU8hkVC4S10eGhKl
        5W9Tc05ICP57ICFvaelUqAYHtm6QPkpfVKa6KnKs5iltUmw/qxfc5kELdN5Y/7iMurfujf
        yiYzkhKcrSjaSe4Lt4VMPaR5HjrxDxo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-S5e_EUE5MiSWKFOHK0hUeA-1; Fri, 13 Dec 2019 06:07:48 -0500
X-MC-Unique: S5e_EUE5MiSWKFOHK0hUeA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52FA6107ACC7;
        Fri, 13 Dec 2019 11:07:47 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-134.brq.redhat.com [10.40.204.134])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 814145D6BE;
        Fri, 13 Dec 2019 11:07:39 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH] hw/i386: De-duplicate gsi_handler() to remove kvm_pc_gsi_handler()
Date:   Fri, 13 Dec 2019 12:07:36 +0100
Message-Id: <20191213110736.10767-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both gsi_handler() and kvm_pc_gsi_handler() have the same content,
except one comment. Move the comment, and de-duplicate the code.

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 include/sysemu/kvm.h |  1 -
 hw/i386/kvm/ioapic.c | 12 ------------
 hw/i386/pc.c         |  5 ++---
 3 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 9fe233b9bf..f5d0d0d710 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -515,7 +515,6 @@ int kvm_irqchip_add_irqfd_notifier(KVMState *s, Event=
Notifier *n,
 int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n,
                                       qemu_irq irq);
 void kvm_irqchip_set_qemuirq_gsi(KVMState *s, qemu_irq irq, int gsi);
-void kvm_pc_gsi_handler(void *opaque, int n, int level);
 void kvm_pc_setup_irq_routing(bool pci_enabled);
 void kvm_init_irq_routing(KVMState *s);
=20
diff --git a/hw/i386/kvm/ioapic.c b/hw/i386/kvm/ioapic.c
index f94729c565..bae7413a39 100644
--- a/hw/i386/kvm/ioapic.c
+++ b/hw/i386/kvm/ioapic.c
@@ -48,18 +48,6 @@ void kvm_pc_setup_irq_routing(bool pci_enabled)
     }
 }
=20
-void kvm_pc_gsi_handler(void *opaque, int n, int level)
-{
-    GSIState *s =3D opaque;
-
-    if (n < ISA_NUM_IRQS) {
-        /* Kernel will forward to both PIC and IOAPIC */
-        qemu_set_irq(s->i8259_irq[n], level);
-    } else {
-        qemu_set_irq(s->ioapic_irq[n], level);
-    }
-}
-
 typedef struct KVMIOAPICState KVMIOAPICState;
=20
 struct KVMIOAPICState {
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index ac08e63604..97e9049b71 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -350,6 +350,7 @@ void gsi_handler(void *opaque, int n, int level)
=20
     DPRINTF("pc: %s GSI %d\n", level ? "raising" : "lowering", n);
     if (n < ISA_NUM_IRQS) {
+        /* Under KVM, Kernel will forward to both PIC and IOAPIC */
         qemu_set_irq(s->i8259_irq[n], level);
     }
     qemu_set_irq(s->ioapic_irq[n], level);
@@ -362,10 +363,8 @@ GSIState *pc_gsi_create(qemu_irq **irqs, bool pci_en=
abled)
     s =3D g_new0(GSIState, 1);
     if (kvm_ioapic_in_kernel()) {
         kvm_pc_setup_irq_routing(pci_enabled);
-        *irqs =3D qemu_allocate_irqs(kvm_pc_gsi_handler, s, GSI_NUM_PINS=
);
-    } else {
-        *irqs =3D qemu_allocate_irqs(gsi_handler, s, GSI_NUM_PINS);
     }
+    *irqs =3D qemu_allocate_irqs(gsi_handler, s, GSI_NUM_PINS);
=20
     return s;
 }
--=20
2.21.0


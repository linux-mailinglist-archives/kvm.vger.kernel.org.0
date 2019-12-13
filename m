Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8442A11E7EF
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 17:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbfLMQSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 11:18:24 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26592 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728057AbfLMQSY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 11:18:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576253903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zCZ3/HzJt6UebSooqSPs4MgLhNuCHweYJBKUsTXMBXw=;
        b=eThTNBIj1LpDkDq5CCRCKqh+fTh87XpfdBoRJx4Ua0Cnn5wVsZsqDvI45VF3FHikhHRsmz
        0k6nC7gXlg+1jaIRLd+AGXlbFIEFq6RVMTcDJQvis44avpk/SgJWOReOHw+A3c8uIrKyTR
        NTDBAlnIcJSWq1zcb9vxnBhwPlu4ToQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-3ZUD0pJMOhuSY8G0PHLj2g-1; Fri, 13 Dec 2019 11:18:21 -0500
X-MC-Unique: 3ZUD0pJMOhuSY8G0PHLj2g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B5BB107ACC4;
        Fri, 13 Dec 2019 16:18:20 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB3BD19C4F;
        Fri, 13 Dec 2019 16:18:12 +0000 (UTC)
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
Subject: [PATCH 01/12] hw/i386/pc: Convert DPRINTF() to trace events
Date:   Fri, 13 Dec 2019 17:17:42 +0100
Message-Id: <20191213161753.8051-2-philmd@redhat.com>
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

Convert the deprecated DPRINTF() macro to trace events.

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
v2: rename pc_pic -> x86_pic
---
 hw/i386/pc.c         | 19 +++++--------------
 hw/i386/trace-events |  6 ++++++
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index ac08e63604..5f8e39c025 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -90,16 +90,7 @@
 #include "config-devices.h"
 #include "e820_memory_layout.h"
 #include "fw_cfg.h"
-
-/* debug PC/ISA interrupts */
-//#define DEBUG_IRQ
-
-#ifdef DEBUG_IRQ
-#define DPRINTF(fmt, ...)                                       \
-    do { printf("CPUIRQ: " fmt , ## __VA_ARGS__); } while (0)
-#else
-#define DPRINTF(fmt, ...)
-#endif
+#include "trace.h"
=20
 struct hpet_fw_config hpet_cfg =3D {.count =3D UINT8_MAX};
=20
@@ -348,7 +339,7 @@ void gsi_handler(void *opaque, int n, int level)
 {
     GSIState *s =3D opaque;
=20
-    DPRINTF("pc: %s GSI %d\n", level ? "raising" : "lowering", n);
+    trace_x86_gsi_interrupt(n, level);
     if (n < ISA_NUM_IRQS) {
         qemu_set_irq(s->i8259_irq[n], level);
     }
@@ -426,7 +417,7 @@ static void pic_irq_request(void *opaque, int irq, in=
t level)
     CPUState *cs =3D first_cpu;
     X86CPU *cpu =3D X86_CPU(cs);
=20
-    DPRINTF("pic_irqs: %s irq %d\n", level? "raise" : "lower", irq);
+    trace_x86_pic_interrupt(irq, level);
     if (cpu->apic_state && !kvm_irqchip_in_kernel()) {
         CPU_FOREACH(cs) {
             cpu =3D X86_CPU(cs);
@@ -760,7 +751,7 @@ static void port92_write(void *opaque, hwaddr addr, u=
int64_t val,
     Port92State *s =3D opaque;
     int oldval =3D s->outport;
=20
-    DPRINTF("port92: write 0x%02" PRIx64 "\n", val);
+    trace_port92_write(val);
     s->outport =3D val;
     qemu_set_irq(s->a20_out, (val >> 1) & 1);
     if ((val & 1) && !(oldval & 1)) {
@@ -775,7 +766,7 @@ static uint64_t port92_read(void *opaque, hwaddr addr=
,
     uint32_t ret;
=20
     ret =3D s->outport;
-    DPRINTF("port92: read 0x%02x\n", ret);
+    trace_port92_read(ret);
     return ret;
 }
=20
diff --git a/hw/i386/trace-events b/hw/i386/trace-events
index c8bc464bc5..a608a5b635 100644
--- a/hw/i386/trace-events
+++ b/hw/i386/trace-events
@@ -111,3 +111,9 @@ amdvi_ir_irte_ga_val(uint64_t hi, uint64_t lo) "hi 0x=
%"PRIx64" lo 0x%"PRIx64
 # vmport.c
 vmport_register(unsigned char command, void *func, void *opaque) "comman=
d: 0x%02x func: %p opaque: %p"
 vmport_command(unsigned char command) "command: 0x%02x"
+
+# pc.c
+x86_gsi_interrupt(int irqn, int level) "GSI interrupt #%d level:%d"
+x86_pic_interrupt(int irqn, int level) "PIC interrupt #%d level:%d"
+port92_read(uint8_t val) "port92: read 0x%02x"
+port92_write(uint8_t val) "port92: write 0x%02x"
--=20
2.21.0


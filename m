Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9201ED7B6D
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbfJOQ2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:28:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37820 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727766AbfJOQ2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:28:42 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9115A20FF;
        Tue, 15 Oct 2019 16:28:41 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5778C19C69;
        Tue, 15 Oct 2019 16:28:22 +0000 (UTC)
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
Subject: [PATCH 06/32] mc146818rtc: always register rtc to rtc list
Date:   Tue, 15 Oct 2019 18:26:39 +0200
Message-Id: <20191015162705.28087-7-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Tue, 15 Oct 2019 16:28:41 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hervé Poussineau <hpoussin@reactos.org>

We are not required anymore to use rtc_init() function.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Hervé Poussineau <hpoussin@reactos.org>
Message-Id: <20171216090228.28505-5-hpoussin@reactos.org>
[PMD: rebased, fix OBJECT() value]
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/timer/mc146818rtc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/hw/timer/mc146818rtc.c b/hw/timer/mc146818rtc.c
index 0c04b74c2e..8f7d3a9cdf 100644
--- a/hw/timer/mc146818rtc.c
+++ b/hw/timer/mc146818rtc.c
@@ -963,17 +963,16 @@ static void rtc_realizefn(DeviceState *dev, Error **errp)
     object_property_add_tm(OBJECT(s), "date", rtc_get_date, NULL);
 
     qdev_init_gpio_out(dev, &s->irq, 1);
+    QLIST_INSERT_HEAD(&rtc_devices, s, link);
 }
 
 ISADevice *mc146818_rtc_init(ISABus *bus, int base_year, qemu_irq intercept_irq)
 {
     DeviceState *dev;
     ISADevice *isadev;
-    RTCState *s;
 
     isadev = isa_create(bus, TYPE_MC146818_RTC);
     dev = DEVICE(isadev);
-    s = MC146818_RTC(isadev);
     qdev_prop_set_int32(dev, "base_year", base_year);
     qdev_init_nofail(dev);
     if (intercept_irq) {
@@ -981,9 +980,8 @@ ISADevice *mc146818_rtc_init(ISABus *bus, int base_year, qemu_irq intercept_irq)
     } else {
         isa_connect_gpio_out(isadev, 0, RTC_ISA_IRQ);
     }
-    QLIST_INSERT_HEAD(&rtc_devices, s, link);
 
-    object_property_add_alias(qdev_get_machine(), "rtc-time", OBJECT(s),
+    object_property_add_alias(qdev_get_machine(), "rtc-time", OBJECT(isadev),
                               "date", NULL);
 
     return isadev;
@@ -1015,8 +1013,6 @@ static void rtc_class_initfn(ObjectClass *klass, void *data)
     dc->reset = rtc_resetdev;
     dc->vmsd = &vmstate_rtc;
     dc->props = mc146818rtc_properties;
-    /* Reason: needs to be wired up by rtc_init() */
-    dc->user_creatable = false;
 }
 
 static const TypeInfo mc146818rtc_info = {
-- 
2.21.0


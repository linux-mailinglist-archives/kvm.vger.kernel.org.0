Return-Path: <kvm+bounces-57877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61DD8B7F22F
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A523F4A6596
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC5CC32E75E;
	Wed, 17 Sep 2025 13:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="u0e4qWkR"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0C4316185
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114317; cv=none; b=ORfMivjliJ3nXbnLx9M9MtK5M5gmNwH++W4GRMocu0vgo3ezDiS01yO4XrIy9I3ZkYsj4n+WeNmtX7Dbuplq3it3FZ0Tnsaz8Z9kuY5YXmhzWxIwzMQQkOKlFmf6lcciMFW2lwf4R705EuSHBfs56sc6H/R58sRZKwrwHGj2TxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114317; c=relaxed/simple;
	bh=9VvSuqkjjFsmGF0DAl2yNR3104BHwusZkM/BdiDFInw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uQ0EUaidAOVSJQ6NIO/yH+giZ1QeiG7xsOOqUpOZAHUXvRvS/ddRgZ6oeWr0q5dh/30LpwBYhaa2BsOrPsJyJdZYqVpC15Jxd3W3mQu/RZzSNZ/lVaVek8uvrBDau+XnvIJtlrrP7Ah1sfdF0HPXT69/P5nWaPYPJ83xLsjZSPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=u0e4qWkR reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58HCuN6s008967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Sep 2025 21:56:42 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=xplWx0T3pH95kfYhsL6HObR0v1/371FsGPZ7likh5Eo=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Date:Subject:Message-Id:To;
        s=rs20250326; t=1758113803; v=1;
        b=u0e4qWkRUJ30ZFxZupPVEGVLpoAX0qgZl3mczzMZJ6ciKmH26JvBI2UbGVLoLb/l
         RCWQDqjNSH/BwyDKf5oVnYhPptBdNepbPjoI0kDyafZJyT9skmz8F851N3fq4QF9
         TGKnQMQYKRm/zCzAjv+WncnP7a7Ja9j2Jx5R9iInHH3UQKlmb7TsQ0Xkrrwsha1G
         oKI+4Gf5Z06GaycO3NgiwqIk5ZG3pw1l4umaK+XFIuchSh7SJ14vQczC3BZ0qvTr
         s5OI5nrZMLby0g7zMYdJEeXj+cEcnJEFWSJCS4bnT56F1d6cCIhpZ3CbYNkpCYzZ
         ORZTrQ9dCXZq58Fkzi59BQ==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 17 Sep 2025 21:56:26 +0900
Subject: [PATCH 14/35] hw/misc: QOM-ify AddressSpace
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250917-qom-v1-14-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
References: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Steven Lee <steven_lee@aspeedtech.com>, Troy Lee <leetroy@gmail.com>,
        Jamin Lin <jamin_lin@aspeedtech.com>,
        Andrew Jeffery <andrew@codeconstruct.com.au>,
        Joel Stanley <joel@jms.id.au>, Eric Auger <eric.auger@redhat.com>,
        Helge Deller <deller@gmx.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?utf-8?q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <arikalo@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Alistair Francis <alistair@alistair23.me>,
        Ninad Palsule <ninad@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Yi Liu <yi.l.liu@intel.com>,
        =?utf-8?q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Aditya Gupta <adityag@linux.ibm.com>,
        Gautam Menghani <gautam@linux.ibm.com>, Song Gao <gaosong@loongson.cn>,
        Bibo Mao <maobibo@loongson.cn>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Fan Ni <fan.ni@samsung.com>, David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Subbaraya Sundeep <sundeep.lkml@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>, Laurent Vivier <laurent@vivier.eu>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Bernhard Beschow <shentey@gmail.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Weiwei Li <liwei1518@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
        Bin Meng <bmeng.cn@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>, Peter Xu <peterx@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
        qemu-block@nongnu.org, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.15-dev-179e8

Make AddressSpaces QOM objects to ensure that they are destroyed when
their owners are finalized and also to get a unique path for debugging
output.

The name arguments were used to distinguish AddresSpaces in debugging
output, but they will represent property names after QOM-ification and
debugging output will show QOM paths. So change them to make them more
concise and also avoid conflicts with other properties.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 hw/misc/aspeed_hace.c      | 2 +-
 hw/misc/auxbus.c           | 2 +-
 hw/misc/bcm2835_mbox.c     | 3 +--
 hw/misc/bcm2835_property.c | 3 +--
 hw/misc/max78000_gcr.c     | 2 +-
 hw/misc/tz-mpc.c           | 6 ++----
 hw/misc/tz-msc.c           | 2 +-
 hw/misc/tz-ppc.c           | 5 ++++-
 8 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/hw/misc/aspeed_hace.c b/hw/misc/aspeed_hace.c
index 198363fd64fa..a8a4a91afac8 100644
--- a/hw/misc/aspeed_hace.c
+++ b/hw/misc/aspeed_hace.c
@@ -603,7 +603,7 @@ static void aspeed_hace_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    address_space_init(&s->dram_as, NULL, s->dram_mr, "dram");
+    address_space_init(&s->dram_as, OBJECT(s), s->dram_mr, "as");
 
     sysbus_init_mmio(sbd, &s->iomem);
 }
diff --git a/hw/misc/auxbus.c b/hw/misc/auxbus.c
index e5448ef3cc60..d20dd8789ae6 100644
--- a/hw/misc/auxbus.c
+++ b/hw/misc/auxbus.c
@@ -74,7 +74,7 @@ AUXBus *aux_bus_init(DeviceState *parent, const char *name)
     /* Memory related. */
     bus->aux_io = g_malloc(sizeof(*bus->aux_io));
     memory_region_init(bus->aux_io, OBJECT(bus), "aux-io", 1 * MiB);
-    address_space_init(&bus->aux_addr_space, NULL, bus->aux_io, "aux-io");
+    address_space_init(&bus->aux_addr_space, OBJECT(bus), bus->aux_io, "as");
     return bus;
 }
 
diff --git a/hw/misc/bcm2835_mbox.c b/hw/misc/bcm2835_mbox.c
index 4bf3c59a40a1..f26aa39ca4e5 100644
--- a/hw/misc/bcm2835_mbox.c
+++ b/hw/misc/bcm2835_mbox.c
@@ -310,8 +310,7 @@ static void bcm2835_mbox_realize(DeviceState *dev, Error **errp)
 
     obj = object_property_get_link(OBJECT(dev), "mbox-mr", &error_abort);
     s->mbox_mr = MEMORY_REGION(obj);
-    address_space_init(&s->mbox_as, NULL, s->mbox_mr,
-                       TYPE_BCM2835_MBOX "-memory");
+    address_space_init(&s->mbox_as, OBJECT(s), s->mbox_mr, "as");
     bcm2835_mbox_reset(dev);
 }
 
diff --git a/hw/misc/bcm2835_property.c b/hw/misc/bcm2835_property.c
index 8bdde2d248b5..e86d001f17fb 100644
--- a/hw/misc/bcm2835_property.c
+++ b/hw/misc/bcm2835_property.c
@@ -540,8 +540,7 @@ static void bcm2835_property_realize(DeviceState *dev, Error **errp)
 
     obj = object_property_get_link(OBJECT(dev), "dma-mr", &error_abort);
     s->dma_mr = MEMORY_REGION(obj);
-    address_space_init(&s->dma_as, NULL, s->dma_mr,
-                       TYPE_BCM2835_PROPERTY "-memory");
+    address_space_init(&s->dma_as, OBJECT(s), s->dma_mr, "as");
 
     obj = object_property_get_link(OBJECT(dev), "otp", &error_abort);
     s->otp = BCM2835_OTP(obj);
diff --git a/hw/misc/max78000_gcr.c b/hw/misc/max78000_gcr.c
index 0a0692c7cffe..048b265be348 100644
--- a/hw/misc/max78000_gcr.c
+++ b/hw/misc/max78000_gcr.c
@@ -320,7 +320,7 @@ static void max78000_gcr_realize(DeviceState *dev, Error **errp)
 {
     Max78000GcrState *s = MAX78000_GCR(dev);
 
-    address_space_init(&s->sram_as, NULL, s->sram, "sram");
+    address_space_init(&s->sram_as, OBJECT(s), s->sram, "as");
 }
 
 static void max78000_gcr_class_init(ObjectClass *klass, const void *data)
diff --git a/hw/misc/tz-mpc.c b/hw/misc/tz-mpc.c
index b8be234630e3..b5415d46feae 100644
--- a/hw/misc/tz-mpc.c
+++ b/hw/misc/tz-mpc.c
@@ -550,10 +550,8 @@ static void tz_mpc_realize(DeviceState *dev, Error **errp)
     memory_region_init_io(&s->blocked_io, obj, &tz_mpc_mem_blocked_ops,
                           s, "tz-mpc-blocked-io", size);
 
-    address_space_init(&s->downstream_as, NULL, s->downstream,
-                       "tz-mpc-downstream");
-    address_space_init(&s->blocked_io_as, NULL, &s->blocked_io,
-                       "tz-mpc-blocked-io");
+    address_space_init(&s->downstream_as, obj, s->downstream, "downstream-as");
+    address_space_init(&s->blocked_io_as, obj, &s->blocked_io, "blocked-io-as");
 
     s->blk_lut = g_new0(uint32_t, s->blk_max);
 }
diff --git a/hw/misc/tz-msc.c b/hw/misc/tz-msc.c
index ed1c95e2e9fa..07a8a5137d22 100644
--- a/hw/misc/tz-msc.c
+++ b/hw/misc/tz-msc.c
@@ -260,7 +260,7 @@ static void tz_msc_realize(DeviceState *dev, Error **errp)
     }
 
     size = memory_region_size(s->downstream);
-    address_space_init(&s->downstream_as, NULL, s->downstream, name);
+    address_space_init(&s->downstream_as, obj, s->downstream, "as");
     memory_region_init_io(&s->upstream, obj, &tz_msc_ops, s, name, size);
     sysbus_init_mmio(sbd, &s->upstream);
 }
diff --git a/hw/misc/tz-ppc.c b/hw/misc/tz-ppc.c
index 28a1c27aa3cc..ac928accec2d 100644
--- a/hw/misc/tz-ppc.c
+++ b/hw/misc/tz-ppc.c
@@ -257,6 +257,7 @@ static void tz_ppc_realize(DeviceState *dev, Error **errp)
     for (i = 0; i <= max_port; i++) {
         TZPPCPort *port = &s->port[i];
         char *name;
+        g_autofree char *as_name = NULL;
         uint64_t size;
 
         if (!port->downstream) {
@@ -274,9 +275,11 @@ static void tz_ppc_realize(DeviceState *dev, Error **errp)
         }
 
         name = g_strdup_printf("tz-ppc-port[%d]", i);
+        as_name = g_strconcat(name, "-as", NULL);
 
         port->ppc = s;
-        address_space_init(&port->downstream_as, NULL, port->downstream, name);
+        address_space_init(&port->downstream_as, obj, port->downstream,
+                           as_name);
 
         size = memory_region_size(port->downstream);
         memory_region_init_io(&port->upstream, obj, &tz_ppc_ops,

-- 
2.51.0



Return-Path: <kvm+bounces-8874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C75C858170
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 16:40:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28322283699
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 15:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D56130E26;
	Fri, 16 Feb 2024 15:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LN3XpByc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8E8130E20
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 15:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708097736; cv=none; b=tvBzZmkkV8kKQyqjgcd1wK8KPUUgUPAE4ddOVH9XYaLcoO61J4XeG2ftD6PMmzwfl0u9clCR3v5/z1UISqAnojQmiZKGV/F+s4esK5AkfuuV9w/1oysn0ea9PX75G7ysi6X244sFNR4bOeqByC8OWqbtCUNXNeX27hvctzGIS8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708097736; c=relaxed/simple;
	bh=x0kmFl2uKKB9P/8zejfgoB5FyDQIfKAf8JXzo8x1zOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R+EpnVdUP0mtjmM+80ci3jMyyU2NlpgqJXKPniwOeyeIk/6rDFKzkUKPghevjqOmcyTg3Rj73b33F1rS/u2LurFMfIXVhTTAbS7KZeS3Q95Q6NnOpKHsbswF4kR3vr2pu8iSSUGWB2Vd2sd8rjWtHjNVQt+5a8xUu3NJS2131wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LN3XpByc; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a2a17f3217aso281131566b.2
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 07:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708097733; x=1708702533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wZ1SK8UcIGNjoS5oUCJZaLlSaFI2o9jBSpbbsKbpCUU=;
        b=LN3XpBycF5Tu2pS+9qyb6Xu231OKJOCALguKEfAo1udvrmk3OJ4UKMvdm+/f2vTJ2A
         lmTOdBq1vSWOg/g2kd9RkAWgKuUIjUY7/lgl4pV4dbwSM5GOYBkH+DpP+zxC3OaWA/SQ
         hAG66iffuaqzvDvrFAV8K5MR/IV0VW9MGwSiEAeQXWZGjb3LxwuVH5AIoFZASA2HcjC3
         sgPdV8wXR1u86tXCIuTmQxam17Fbm+Cg/zyDtJkC9X2UJVTT8rlvHWW/xOfA334lfyUU
         CDTBRMETTxmxH46oHJyZDz8asz9Q2ok/gxq9Uz37D16sdk0OK2efvI4gBVm7dubrX2wU
         lXCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708097733; x=1708702533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wZ1SK8UcIGNjoS5oUCJZaLlSaFI2o9jBSpbbsKbpCUU=;
        b=NdnKx5guybWti73x6x4rUE6yzhpT0QhVTw641GyFz+uk/waQHvzaPaxzkok4QsQJwk
         2O6ZUq1XjsQ25rPtzzUc2LLJwzI0u+iqVxSzaqwK9W4/bqBzPxWrCDHTNqHyhWq4Gz4H
         hyih2tFXQcSTr/t9Vj4ZqZg0IeN152gXtQ4bHaXCU45aIJHTzYHF44GydOUcms6H7IDS
         6yEDBS4qSJOx03uRyOhhjzN96evDBrTAXNIt6+ZpG5o/py6lBjo+Mh9Xdw+m1qCUytqv
         6Dqu4EE+HAxNbVc1JORzOXvYVTP51/j1PHM5qbEtX4uTh21up11/pqwoUE+RfKQ8R8Sv
         SmxA==
X-Forwarded-Encrypted: i=1; AJvYcCUBUiE6S8kf1cXIA3ujtL0beAE8WZrns3pllvlwAtIeAbrcvNgC/osQl8Z5otgShj1tJ93A3AdOjxi1EsQM2EQYItlJ
X-Gm-Message-State: AOJu0Yze1N+UZksaOHJSrR+zXaLDktyYWegQmavazo9GFSoVb7W9c+zP
	Oe0EcCUCuh2l0yGwgcLr/jBhTwK29v7k84H+cePIjBRVRh/cuUeE3Uia7dkngak=
X-Google-Smtp-Source: AGHT+IH9BTAcIohzCR8eVt3EE/x7HR0y4dxLNcTYXzXwSeNEodcpT2ESRISuFuitM7rP6Rj400gYrw==
X-Received: by 2002:a17:907:119c:b0:a3d:4037:73e7 with SMTP id uz28-20020a170907119c00b00a3d403773e7mr3369329ejb.48.1708097733048;
        Fri, 16 Feb 2024 07:35:33 -0800 (PST)
Received: from m1x-phil.lan ([176.187.210.246])
        by smtp.gmail.com with ESMTPSA id qw17-20020a170906fcb100b00a3d25d35ca5sm52716ejb.16.2024.02.16.07.35.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 16 Feb 2024 07:35:32 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Igor Mitsyanko <i.mitsyanko@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 2/6] hw/display/pl110: Pass frame buffer memory region as link property
Date: Fri, 16 Feb 2024 16:35:13 +0100
Message-ID: <20240216153517.49422-3-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240216153517.49422-1-philmd@linaro.org>
References: <20240216153517.49422-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add the PL110::'framebuffer-memory' property. Have the different
ARM boards set it. We don't need to call sysbus_address_space()
anymore.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/arm/realview.c    |  2 ++
 hw/arm/versatilepb.c |  2 ++
 hw/arm/vexpress.c    |  5 +++++
 hw/display/pl110.c   | 20 ++++++++++++++++----
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/hw/arm/realview.c b/hw/arm/realview.c
index 77300e92e5..b186f965c6 100644
--- a/hw/arm/realview.c
+++ b/hw/arm/realview.c
@@ -239,6 +239,8 @@ static void realview_init(MachineState *machine,
     gpio2 = sysbus_create_simple("pl061", 0x10015000, pic[8]);
 
     dev = qdev_new("pl111");
+    object_property_set_link(OBJECT(dev), "framebuffer-memory",
+                             OBJECT(sysmem), &error_fatal);
     sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
     sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, 0x10020000);
     sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, pic[23]);
diff --git a/hw/arm/versatilepb.c b/hw/arm/versatilepb.c
index 7e04b23af8..d48235453e 100644
--- a/hw/arm/versatilepb.c
+++ b/hw/arm/versatilepb.c
@@ -300,6 +300,8 @@ static void versatile_init(MachineState *machine, int board_id)
     /* The versatile/PB actually has a modified Color LCD controller
        that includes hardware cursor support from the PL111.  */
     dev = qdev_new("pl110_versatile");
+    object_property_set_link(OBJECT(dev), "framebuffer-memory",
+                             OBJECT(sysmem), &error_fatal);
     sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
     sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, 0x10120000);
     sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, pic[16]);
diff --git a/hw/arm/vexpress.c b/hw/arm/vexpress.c
index 671986c21e..de815d84cc 100644
--- a/hw/arm/vexpress.c
+++ b/hw/arm/vexpress.c
@@ -299,6 +299,9 @@ static void a9_daughterboard_init(VexpressMachineState *vms,
 
     /* 0x10020000 PL111 CLCD (daughterboard) */
     dev = qdev_new("pl111");
+    object_property_set_link(OBJECT(dev), "framebuffer-memory",
+                             OBJECT(sysmem), &error_fatal);
+    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
     sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, 0x10020000);
     sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, pic[44]);
 
@@ -654,6 +657,8 @@ static void vexpress_common_init(MachineState *machine)
     /* VE_COMPACTFLASH: not modelled */
 
     dev = qdev_new("pl111");
+    object_property_set_link(OBJECT(dev), "framebuffer-memory",
+                             OBJECT(sysmem), &error_fatal);
     sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
     sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, map[VE_CLCD]);
     sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, pic[14]);
diff --git a/hw/display/pl110.c b/hw/display/pl110.c
index 4b83db9322..7f145bbdba 100644
--- a/hw/display/pl110.c
+++ b/hw/display/pl110.c
@@ -10,6 +10,7 @@
 #include "qemu/osdep.h"
 #include "hw/irq.h"
 #include "hw/sysbus.h"
+#include "hw/qdev-properties.h"
 #include "migration/vmstate.h"
 #include "ui/console.h"
 #include "framebuffer.h"
@@ -17,6 +18,7 @@
 #include "qemu/timer.h"
 #include "qemu/log.h"
 #include "qemu/module.h"
+#include "qapi/error.h"
 #include "qom/object.h"
 
 #define PL110_CR_EN   0x001
@@ -74,6 +76,7 @@ struct PL110State {
     uint32_t palette[256];
     uint32_t raw_palette[128];
     qemu_irq irq;
+    MemoryRegion *fbmem;
 };
 
 static int vmstate_pl110_post_load(void *opaque, int version_id);
@@ -210,7 +213,6 @@ static int pl110_enabled(PL110State *s)
 static void pl110_update_display(void *opaque)
 {
     PL110State *s = (PL110State *)opaque;
-    SysBusDevice *sbd;
     DisplaySurface *surface = qemu_console_surface(s->con);
     drawfn fn;
     int src_width;
@@ -222,8 +224,6 @@ static void pl110_update_display(void *opaque)
         return;
     }
 
-    sbd = SYS_BUS_DEVICE(s);
-
     if (s->cr & PL110_CR_BGR)
         bpp_offset = 0;
     else
@@ -290,7 +290,7 @@ static void pl110_update_display(void *opaque)
     first = 0;
     if (s->invalidate) {
         framebuffer_update_memory_section(&s->fbsection,
-                                          sysbus_address_space(sbd),
+                                          s->fbmem,
                                           s->upbase,
                                           s->rows, src_width);
     }
@@ -535,11 +535,22 @@ static const GraphicHwOps pl110_gfx_ops = {
     .gfx_update  = pl110_update_display,
 };
 
+static Property pl110_properties[] = {
+    DEFINE_PROP_LINK("framebuffer-memory", PL110State, fbmem,
+                     TYPE_MEMORY_REGION, MemoryRegion *),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
 static void pl110_realize(DeviceState *dev, Error **errp)
 {
     PL110State *s = PL110(dev);
     SysBusDevice *sbd = SYS_BUS_DEVICE(dev);
 
+    if (!s->fbmem) {
+        error_setg(errp, "'framebuffer-memory' property was not set");
+        return;
+    }
+
     memory_region_init_io(&s->iomem, OBJECT(s), &pl110_ops, s, "pl110", 0x1000);
     sysbus_init_mmio(sbd, &s->iomem);
     sysbus_init_irq(sbd, &s->irq);
@@ -577,6 +588,7 @@ static void pl110_class_init(ObjectClass *klass, void *data)
     set_bit(DEVICE_CATEGORY_DISPLAY, dc->categories);
     dc->vmsd = &vmstate_pl110;
     dc->realize = pl110_realize;
+    device_class_set_props(dc, pl110_properties);
 }
 
 static const TypeInfo pl110_info = {
-- 
2.41.0



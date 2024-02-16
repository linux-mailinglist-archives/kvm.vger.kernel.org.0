Return-Path: <kvm+bounces-8876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31E60858172
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 16:40:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC1D9284E9E
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 15:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39045130E4C;
	Fri, 16 Feb 2024 15:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FwAdfG5i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EAC130AD7
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 15:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708097748; cv=none; b=p0n8QLu182+6SGSRs3jkYjngirWlEsXqiFyH0garkJ8azxFd8dqhWfxUmZbTIe3XUhDTs1c70QlGXFH9kPY6ZSl25p0IS0fNPHLEg37K75CYRF9wQIfqfjkrHMdyfqQ49FrL7W/G7CSewtAE/3fmAqZ3xHUIRXqK2Gp4A/RJQoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708097748; c=relaxed/simple;
	bh=l/S3DsfwtkVeTaU7AnNP+1uVTs0OzSwTkehRTh2I1Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MuZY1WKqosAZ5gYdu1ZeHfcP2uVz+B7jQT07aLbDKrec8ic9HQpzqTKt6g/1wG15wiOuacyyT4Kov2VL74plccLxXmvyeMuRqc/Mg/aIqtWhXAhihthSKDwmAunaQKa3MzAl/9KMu6cltwRsn1FJGujVcRZfeWs9uaFjmJF5aUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FwAdfG5i; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-55a8fd60af0so3193104a12.1
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 07:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708097745; x=1708702545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ztXjxwe8IKbXpGPRKa7UqA3qhxM54O9HdB2Bhpwj8c=;
        b=FwAdfG5iPHhFE/JEsLqaVuZzOSzQX3ZiQc7PuATbP01zEDcOeNf4MbxH2NK7nioKUe
         vxdXO2dZuxGgsmozo33l6i3j9uyx/FRIuyJZn4mxtn3PDNvseI/Z/NMKoI7zdPFM1YXH
         DWQZVDaG68izJMMcLgZpbSjwyADUK2/wwqs212WNel/6wDrXVz8moPO29OTwFatB1yza
         3JRqGqOzT7xR5tYrbDmp23+Wz1xgga7jaB/YIDkEe2CgOhxLuKPdBfD3NP8b72h69PJY
         FKl1RSjs31FN6sZ1WXbK2oooesQBP55FCa4+Dsu780F43zQGs6XIWfqYqiTV5PWAQce0
         KOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708097745; x=1708702545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ztXjxwe8IKbXpGPRKa7UqA3qhxM54O9HdB2Bhpwj8c=;
        b=jyWG+LmgMi8PuK81hTWtPxAAxtMIbtDlhSEaAs9CyD8dj48PJIJDH0MSX4wIs/z/xy
         uRY6/g5XVj63FLG8TZESWfgLKBWPi11fdZZgMLdZgPRDDX2iy6I1IfcNkaXgE8/7ZZ4m
         fwim3y8bDyb7sFnudeV2KpMDUR+NQPff9E9+ZbH+Q05gmVfr4Cjjabnrj+PZMJqHD2y2
         fOy5qzzoFX+tvwG2PjzvzhOSrvzMcSxCdNTVJcWGgbq8YXp5PvMgk2a3yDodLZGGRl7W
         /BNDz4A0rSV4RQ3RS6e2M/30IBQ4fyvEgL9wPYsDZpVYpq15e79uYZtXUr58csyShC9x
         kHDw==
X-Forwarded-Encrypted: i=1; AJvYcCW63YxISo8BVW3wR8diiP661ReAm7gWhyE0nHnRWOw3y6rb/zp/ANbllDzxKvVersvWURuC3598af6fOe5edvRo07t5
X-Gm-Message-State: AOJu0YxGWMVUhvtA9MZtVgfkunxIJxd762BDzZASxM8GDI/9chJtQMex
	M0LBnHpWwjzTnP/2Nn3IYywQsMgS1Kix+7wc9u4D6f/cnFp13kPUETV3t19pz3ayA161CbZqbD9
	Q
X-Google-Smtp-Source: AGHT+IGAFxEntDsPXEoYg04THRPSQ35FumBk18CuWooi3xaKjvMlW2W8e2Rd87e9wlVE4krtOGb7/g==
X-Received: by 2002:a05:6402:793:b0:564:1c0:bf4b with SMTP id d19-20020a056402079300b0056401c0bf4bmr836119edy.40.1708097744750;
        Fri, 16 Feb 2024 07:35:44 -0800 (PST)
Received: from m1x-phil.lan ([176.187.210.246])
        by smtp.gmail.com with ESMTPSA id df13-20020a05640230ad00b005621a9b09fbsm83681edb.41.2024.02.16.07.35.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 16 Feb 2024 07:35:44 -0800 (PST)
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
Subject: [PATCH 4/6] hw/display/exynos4210_fimd: Pass frame buffer memory region as link
Date: Fri, 16 Feb 2024 16:35:15 +0100
Message-ID: <20240216153517.49422-5-philmd@linaro.org>
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

Add the Exynos4210fimdState::'framebuffer-memory' property. Have
the board set it. We don't need to call sysbus_address_space()
anymore.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/display/exynos4210_fimd.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/hw/display/exynos4210_fimd.c b/hw/display/exynos4210_fimd.c
index 84687527d5..5712558e13 100644
--- a/hw/display/exynos4210_fimd.c
+++ b/hw/display/exynos4210_fimd.c
@@ -23,6 +23,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "hw/qdev-properties.h"
 #include "hw/hw.h"
 #include "hw/irq.h"
 #include "hw/sysbus.h"
@@ -32,6 +33,7 @@
 #include "qemu/bswap.h"
 #include "qemu/module.h"
 #include "qemu/log.h"
+#include "qapi/error.h"
 #include "qom/object.h"
 
 /* Debug messages configuration */
@@ -302,6 +304,7 @@ struct Exynos4210fimdState {
     MemoryRegion iomem;
     QemuConsole *console;
     qemu_irq irq[3];
+    MemoryRegion *fbmem;
 
     uint32_t vidcon[4];     /* Video main control registers 0-3 */
     uint32_t vidtcon[4];    /* Video time control registers 0-3 */
@@ -1119,7 +1122,6 @@ static void exynos4210_fimd_invalidate(void *opaque)
  * VIDOSDA, VIDOSDB, VIDWADDx and SHADOWCON registers */
 static void fimd_update_memory_section(Exynos4210fimdState *s, unsigned win)
 {
-    SysBusDevice *sbd = SYS_BUS_DEVICE(s);
     Exynos4210fimdWindow *w = &s->window[win];
     hwaddr fb_start_addr, fb_mapped_len;
 
@@ -1147,8 +1149,7 @@ static void fimd_update_memory_section(Exynos4210fimdState *s, unsigned win)
         memory_region_unref(w->mem_section.mr);
     }
 
-    w->mem_section = memory_region_find(sysbus_address_space(sbd),
-                                        fb_start_addr, w->fb_len);
+    w->mem_section = memory_region_find(s->fbmem, fb_start_addr, w->fb_len);
     assert(w->mem_section.mr);
     assert(w->mem_section.offset_within_address_space == fb_start_addr);
     DPRINT_TRACE("Window %u framebuffer changed: address=0x%08x, len=0x%x\n",
@@ -1924,6 +1925,12 @@ static const GraphicHwOps exynos4210_fimd_ops = {
     .gfx_update  = exynos4210_fimd_update,
 };
 
+static Property exynos4210_fimd_properties[] = {
+    DEFINE_PROP_LINK("framebuffer-memory", Exynos4210fimdState, fbmem,
+                     TYPE_MEMORY_REGION, MemoryRegion *),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
 static void exynos4210_fimd_init(Object *obj)
 {
     Exynos4210fimdState *s = EXYNOS4210_FIMD(obj);
@@ -1944,6 +1951,11 @@ static void exynos4210_fimd_realize(DeviceState *dev, Error **errp)
 {
     Exynos4210fimdState *s = EXYNOS4210_FIMD(dev);
 
+    if (!s->fbmem) {
+        error_setg(errp, "'framebuffer-memory' property was not set");
+        return;
+    }
+
     s->console = graphic_console_init(dev, 0, &exynos4210_fimd_ops, s);
 }
 
@@ -1954,6 +1966,7 @@ static void exynos4210_fimd_class_init(ObjectClass *klass, void *data)
     dc->vmsd = &exynos4210_fimd_vmstate;
     dc->reset = exynos4210_fimd_reset;
     dc->realize = exynos4210_fimd_realize;
+    device_class_set_props(dc, exynos4210_fimd_properties);
 }
 
 static const TypeInfo exynos4210_fimd_info = {
-- 
2.41.0



Return-Path: <kvm+bounces-8871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C03C85801A
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 16:04:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 607471C21384
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 15:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F0412F38A;
	Fri, 16 Feb 2024 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FnfYu1yV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F69612C7F3
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708095889; cv=none; b=MNBr8iJqqb8+jcvCogv9YuYbGQzY1WllbFnAHe4CCHuLfvh8oLNbIJx2y3CJcsYLinADp5TP9T8PkBTrI2TndMeFvScF5P83Pg8KNDtnSzRaVgl2XREA2l7xMZDAJYLTCYwohDwQlSltD/KDdliSfdBAbpjoYLR7eaJFD9hbpxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708095889; c=relaxed/simple;
	bh=V0JkYqvTn+uVSE1L+dG0IYgFoeuyTuFYuLokOngLHfA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oAJHx7baW4ZaJpJesrD1cSYJEloJ5gDW5+qp+9OIbfKJniKhgSBu+2t2oVylkMJ87qIMbqpe5wwxY+YcPAkTAxsejnNb7mxRpM4kYAbrZdxjUL8EIUP/DGQVQAz8MsR31Li2sPXJVy+H6akuxq/rMWyih1hTqP0BDSpyjphLUVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FnfYu1yV; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a3c1a6c10bbso277534866b.3
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 07:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708095886; x=1708700686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IgMGnwDJJp9CianhhLKV4Wm1OtNzAWG/gtuYlfJ5Kdg=;
        b=FnfYu1yVhb1iCg5V17YgSDrisXqKo0UqTLrQE5PT6+cFvL4A3sW3l0aDxhgMgFxJlt
         XrIeTtB5T5nLxWFi85Xnqs2SYw3NHBZLkNceEirSdcHzuFbecCpDDJsyIdtP4PGihusM
         LavZGO3oFRuoETC2LTMxMwmryXvuP4L+dp7snhD5ZELrh6vfXF4ACEcaEhWj0kpOoG7c
         4gtEvl52a8netsnGEy80OqWxrXy4m9EATQGfz2zSLiezuKAuMPBmxcDXnWxNDlAQyhmQ
         2u3/r1Eb22NRiM/hZlgrkUnuzdBiFRdUT+jyqrWyQAme1qX4VjUnvYm8c51CB5SH4p/j
         TdUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708095886; x=1708700686;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IgMGnwDJJp9CianhhLKV4Wm1OtNzAWG/gtuYlfJ5Kdg=;
        b=X0GdxjKbX+OLgSBOAcOTt1M4niU5tXvh111bqFFSlRVz1G3t0OHEpHYAPtpxCGdiu/
         ChmQikPfUpvE3D/EVClo+bkf/5tiX5fc3WuhFB9dT15eVCx08GtSAyUWO54lUtv/15uW
         uum2Kr+1cT+PQKHfeX1CDNoTTiWU5ofVv+7GmPBzk0dBqbCJRRVDz5NB4sEpxY/dR5Fk
         6Wessjq82D2P3sEAL67vvoETJMPDozqWa/Xkqst5ZeTsHsjAX7Zn5BZDDBqjQ62EMMi9
         Vx65RuOF132wxesrGezfwnhQLrUXai5ZO7fEJWugqUPdwdADMv+bVv8sZmcwtt+5vAec
         qfjg==
X-Forwarded-Encrypted: i=1; AJvYcCWofWW0CST6sZIPZiHcvlJmY+SgU/Z8O3ox+PoWqu09gGryjl5W67yW/0hVaZj8ekZjS4yo/4ANzC82XQpDrwsN3UeD
X-Gm-Message-State: AOJu0YyrFnUJQIRNcYZzMNH+26SRra2lyH4iG8SxFEVlrrfNnulH3cj3
	P1b7LSqmd0Bx3S47M49km1IKap3rKw8oTVsHXIn8scnkeADkwxyK3JnbqBytcmZKAoa/4o+r5ra
	T
X-Google-Smtp-Source: AGHT+IEyR9s9gmGSVwo9B83uKFpZp+AMJ+H9XSuex4SN4sutNHsSVLGhT4D3PECIl4DYIV6TzmZwdw==
X-Received: by 2002:a17:906:a881:b0:a3d:8466:d355 with SMTP id ha1-20020a170906a88100b00a3d8466d355mr3635489ejb.19.1708095885825;
        Fri, 16 Feb 2024 07:04:45 -0800 (PST)
Received: from m1x-phil.lan ([176.187.210.246])
        by smtp.gmail.com with ESMTPSA id qw13-20020a1709066a0d00b00a3df2b849a5sm14099ejc.155.2024.02.16.07.04.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 16 Feb 2024 07:04:45 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	kvm@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>
Subject: [PATCH] hw/sysbus: Inline and remove sysbus_add_io()
Date: Fri, 16 Feb 2024 16:04:41 +0100
Message-ID: <20240216150441.45681-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

sysbus_add_io(...) is a simple wrapper to
memory_region_add_subregion(get_system_io(), ...).
It is used in 3 places; inline it directly.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/sysbus.h | 2 --
 hw/core/sysbus.c    | 6 ------
 hw/i386/kvmvapic.c  | 2 +-
 hw/mips/mipssim.c   | 2 +-
 hw/nvram/fw_cfg.c   | 5 +++--
 5 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/include/hw/sysbus.h b/include/hw/sysbus.h
index 3564b7b6a2..14dbc22d0c 100644
--- a/include/hw/sysbus.h
+++ b/include/hw/sysbus.h
@@ -83,8 +83,6 @@ void sysbus_mmio_map(SysBusDevice *dev, int n, hwaddr addr);
 void sysbus_mmio_map_overlap(SysBusDevice *dev, int n, hwaddr addr,
                              int priority);
 void sysbus_mmio_unmap(SysBusDevice *dev, int n);
-void sysbus_add_io(SysBusDevice *dev, hwaddr addr,
-                   MemoryRegion *mem);
 MemoryRegion *sysbus_address_space(SysBusDevice *dev);
 
 bool sysbus_realize(SysBusDevice *dev, Error **errp);
diff --git a/hw/core/sysbus.c b/hw/core/sysbus.c
index 35f902b582..9f1d5b2d6d 100644
--- a/hw/core/sysbus.c
+++ b/hw/core/sysbus.c
@@ -298,12 +298,6 @@ static char *sysbus_get_fw_dev_path(DeviceState *dev)
     return g_strdup(qdev_fw_name(dev));
 }
 
-void sysbus_add_io(SysBusDevice *dev, hwaddr addr,
-                       MemoryRegion *mem)
-{
-    memory_region_add_subregion(get_system_io(), addr, mem);
-}
-
 MemoryRegion *sysbus_address_space(SysBusDevice *dev)
 {
     return get_system_memory();
diff --git a/hw/i386/kvmvapic.c b/hw/i386/kvmvapic.c
index f2b0aff479..3be64fba3b 100644
--- a/hw/i386/kvmvapic.c
+++ b/hw/i386/kvmvapic.c
@@ -727,7 +727,7 @@ static void vapic_realize(DeviceState *dev, Error **errp)
     VAPICROMState *s = VAPIC(dev);
 
     memory_region_init_io(&s->io, OBJECT(s), &vapic_ops, s, "kvmvapic", 2);
-    sysbus_add_io(sbd, VAPIC_IO_PORT, &s->io);
+    memory_region_add_subregion(get_system_io(), VAPIC_IO_PORT, &s->io);
     sysbus_init_ioports(sbd, VAPIC_IO_PORT, 2);
 
     option_rom[nb_option_roms].name = "kvmvapic.bin";
diff --git a/hw/mips/mipssim.c b/hw/mips/mipssim.c
index a12427b6c8..57c8c33e2b 100644
--- a/hw/mips/mipssim.c
+++ b/hw/mips/mipssim.c
@@ -226,7 +226,7 @@ mips_mipssim_init(MachineState *machine)
         qdev_prop_set_uint8(dev, "endianness", DEVICE_LITTLE_ENDIAN);
         sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
         sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, env->irq[4]);
-        sysbus_add_io(SYS_BUS_DEVICE(dev), 0x3f8,
+        memory_region_add_subregion(get_system_io(), 0x3f8,
                       sysbus_mmio_get_region(SYS_BUS_DEVICE(dev), 0));
     }
 
diff --git a/hw/nvram/fw_cfg.c b/hw/nvram/fw_cfg.c
index e85493d513..6d6b17462d 100644
--- a/hw/nvram/fw_cfg.c
+++ b/hw/nvram/fw_cfg.c
@@ -1142,6 +1142,7 @@ FWCfgState *fw_cfg_init_io_dma(uint32_t iobase, uint32_t dma_iobase,
     SysBusDevice *sbd;
     FWCfgIoState *ios;
     FWCfgState *s;
+    MemoryRegion *iomem = get_system_io();
     bool dma_requested = dma_iobase && dma_as;
 
     dev = qdev_new(TYPE_FW_CFG_IO);
@@ -1155,7 +1156,7 @@ FWCfgState *fw_cfg_init_io_dma(uint32_t iobase, uint32_t dma_iobase,
     sbd = SYS_BUS_DEVICE(dev);
     sysbus_realize_and_unref(sbd, &error_fatal);
     ios = FW_CFG_IO(dev);
-    sysbus_add_io(sbd, iobase, &ios->comb_iomem);
+    memory_region_add_subregion(iomem, iobase, &ios->comb_iomem);
 
     s = FW_CFG(dev);
 
@@ -1163,7 +1164,7 @@ FWCfgState *fw_cfg_init_io_dma(uint32_t iobase, uint32_t dma_iobase,
         /* 64 bits for the address field */
         s->dma_as = dma_as;
         s->dma_addr = 0;
-        sysbus_add_io(sbd, dma_iobase, &s->dma_iomem);
+        memory_region_add_subregion(iomem, dma_iobase, &s->dma_iomem);
     }
 
     return s;
-- 
2.41.0



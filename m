Return-Path: <kvm+bounces-9342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0C7185E9C9
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 22:16:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A65C8284E77
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 21:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15FA6126F3A;
	Wed, 21 Feb 2024 21:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q9kHMW7s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5037385927
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 21:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708550206; cv=none; b=aMdafrmnwUh5sw6rkQiKOBJ4NE3at8hMAjC3DdYHcHwbAF0m8Be4fPrQVZxPv6FTHe6tI66FgK0JfdrT+WhN6Mt0Q05jXF9LfqQ73M5soebsgDeT8zB2zlQ5xTb9MqNU2f+3dtYc3Xzjcu390aukYungariDNQvRwjwToe5hGC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708550206; c=relaxed/simple;
	bh=Nman6J6nntuhSIWvoHa/yhkSJpHd7hSZDfmlCwMKDj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MqaC96pEyApoNvPw0iloq+wiHL4n3fUP0qDEN+9nyH4FuZzY+nscuz+tg+eZ4hZ6B4QjEtutoRtDOt4ocDdLKzk6jsCCm4AXfcbjny0sP+4K7Nc95HoKH/S/w17ghZwph5iS+lQBwxRLxZY3ZuNvhQbXk+SpVXxGCwTQIe8vor0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q9kHMW7s; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-33ce8cbf465so3658814f8f.3
        for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 13:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708550202; x=1709155002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=krMCnSm7PN59WBp42omeBRDoSFldcCIH3sGDX1JOTwc=;
        b=Q9kHMW7sCQFaIcmvM1JKA7b+76wASVjOA+FrJY4PlVeM2EPxFjX+Iv9H6smale6/Oy
         z7s8W/a+spXxLkuIJ5D3NmsL95huF/AlJwEWzIwerIyBYcjJsFftyVOyHkYdSmoJHlR6
         eNiy2Qbuapx2Sf3fphuerBc4uWGGGUsez5z0+PlXKHEcRA2c1VCsugcrYSVYfAhK3hNm
         JhU2zecWFMxh5MBuk+sk6B0idPV68HdCIxuqKQDI7BNyl/D2Zq10TMMQQ2Us5rE3jGCu
         GCikqe5SCnDRJxgP1K7Z4LKtOG1+3skzsH12JUA1BdRcIUVO/bLgQh6qc3DbWZOv5j2F
         bzMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708550202; x=1709155002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=krMCnSm7PN59WBp42omeBRDoSFldcCIH3sGDX1JOTwc=;
        b=Nmc6gNKA30RELVhkmH2582F+mAstxHAZVBIDgx3/kRGPB98L5orS8qnUsNHiTM1kkR
         kTeJoYDMf4D/I5drHvPuZPm+/fdAWUMjYd7yl3VBnZkQiZfBxi9NvFajP+SRNVgV61Cr
         JO+kvcTzaqbsuC+ZS6KnUASgeVpJ6hzRvsqVi1zhpQiLoGOpwZBOC/uN+FDP3Dp70vaM
         aQChDIPnSyD083q5TStmPN/Ac+gdLSpDU/8eRy5GVjhcZMW9SAnTWx9l6VzCmtHj+6/l
         wGzOrvZH6o6E/aqcak/uomzzz/rhb5LcXGq58sKCuwxhi2qHfslsHXRwkrVgqPUgXg5d
         om4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXKE6yh5HB27RKQdkwWs3kW4pJTFcOcMPZrH5lfvrIDExTCODIKGAA432vzxGMzITWnTsdRtNDBU2XgMPbJ47Kbsu4I
X-Gm-Message-State: AOJu0YxO5M19U4jH99SaHWZDsc+MIgDhqfdXu4QK6RIpw7MhfOqYx6Wv
	B+P7YScsuUh5ffOvUHDLVpS3uWMe6+AYvcUNFUF49zG9hGUzO1zLj5S9p5Et4ak=
X-Google-Smtp-Source: AGHT+IGZf8Qtrl4tZWmdwUIeSK1cDaEYgeGvhmoolrdmoUSN1r0xO5Kbs+SYa2GK0wYLV2zGb/OPJQ==
X-Received: by 2002:a5d:648e:0:b0:33d:3bc2:7acc with SMTP id o14-20020a5d648e000000b0033d3bc27accmr9430955wri.11.1708550202692;
        Wed, 21 Feb 2024 13:16:42 -0800 (PST)
Received: from m1x-phil.lan ([176.187.211.34])
        by smtp.gmail.com with ESMTPSA id ba20-20020a0560001c1400b0033d640c8942sm7735227wrb.10.2024.02.21.13.16.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Feb 2024 13:16:42 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	qemu-block@nongnu.org,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	kvm@vger.kernel.org
Subject: [PULL 02/25] hw/sysbus: Inline and remove sysbus_add_io()
Date: Wed, 21 Feb 2024 22:16:02 +0100
Message-ID: <20240221211626.48190-3-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240221211626.48190-1-philmd@linaro.org>
References: <20240221211626.48190-1-philmd@linaro.org>
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

Rationale: we want to move to an explicit I/O bus,
rather that an implicit one. Besides in heterogeneous
setup we can have more than one I/O bus.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
Message-Id: <20240216150441.45681-1-philmd@linaro.org>
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



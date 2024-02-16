Return-Path: <kvm+bounces-8873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 787CA85816F
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 16:40:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E42591F210F5
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 15:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE4A130AF3;
	Fri, 16 Feb 2024 15:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="b0AZIloY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430CF12F395
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 15:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708097731; cv=none; b=hKuHKOxo5o554uCCwMAaeqla3OpUJqENFlKWZtJHX4Cd/YvNmlHX5S9DFoRUXX6S4vmQpvvE6gqj6DJBme6ugtDS5hxkVMXSg0MRKmQDxEMb/WWDFwcX3zungiUhCcVyToW1oCnlWAHlNfOX+93aSihyOfaI1uiYmGCIAEt5FXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708097731; c=relaxed/simple;
	bh=aOCi2jxVMoX2vXApcp8pAfB018JsB+6pqRTrSNXkR8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sK64VsrO2Mu/LBJe9JTiUIE+lc2GZ4hJY1zB96W1EEdrmKXnQA9WTJEjcNicK0t6E1GSp8iVkFJzIwyvPok/0oEg1V/YIzhDxSnFlEiwl+H9DHnbmW0JBhVM/u1zgRjFgRc7l2LijEdFwkmCl5yPOlDLFkv8yiyvpG3lvoHbKAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=b0AZIloY; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5114fa38434so2542802e87.0
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 07:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708097727; x=1708702527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kV0Ad1FDMlSK0WAR0PyajC3eAS8o+2asLjvJepPvncc=;
        b=b0AZIloYW1/1PYxSKmUp6Q6y4ah3qqOWNhLT7NQl0mFw7Cwuo87QtJO6ty6tm+19lu
         P1/yVOqkHzX49gfjFbx5+wnA9KeAHFFtrox4rweuva/+SdzkdTEnvFd4PqjqK0s4NRwE
         zwSfclSQE6Dh4oSFhALo4/wscxp9vGQlaehUtIeoq2WOLJj+FYbAs7eI2UqP93oFu8Cj
         ZMyxI6sDgUgXG0opkcue9WT+FpxWO91swuZNY/4L+6ZAhCzInFdk3SIl5HpZa1+pJE6t
         BdxwRSooTgT5X64CLM8SewY1T5dDqeqlggXm0tv1Sp/sYbnDNsAYb4SAaYVlAWfnb2QU
         1qoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708097727; x=1708702527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kV0Ad1FDMlSK0WAR0PyajC3eAS8o+2asLjvJepPvncc=;
        b=PnAOKE63wmR9J7g+NKmqWBICbppDoitygwLZ0dmEt7qQ4ohEZtYgadSv8/5Q3MLgk/
         zYqNrUzyEwEb6mgZ+39yOUCOxorn8YXXjZJsHQKVbRmfqxENal8OXkYV71g7Hn5F7Nc+
         haZcaLg3D+7Ixeh9aDjlGcm9Xa0ZNsNfyEYIqd+rL/5g7p0DwDvQDVnZXBe4W0e48Tmy
         ljywIFiP4vOlWPXfdm2LdqGPePR2uiL54XozsTYEwGMVS2cBN5Lrf45Nz6yXeuhuZEGT
         RTpgMc5SCj9jBgdVWNn+5b4k9yUDn6Gq35ZvLsFjrCHSbnEWDNoxWpVtHyq1qKwXA1Is
         3ZoA==
X-Forwarded-Encrypted: i=1; AJvYcCV54LPee7iqdnBoPsesDgJ5fbTvodmM9khn/H+F4bLaTI38diqby71qlskWqVDm31Vz8bcGzPHH+RiBfOPkQZ02HdlJ
X-Gm-Message-State: AOJu0YwFXtarvnGujWSf7KsFBlKXwtok5KSMF19oUlDRvXRigdMQMK7z
	nLX0eFX/wTcOljRlwJ52e/qWJ4hOlD4Z78zF4ypvs52raOx9VUI6BTh0WmsxUvuA1um2DE6t8aP
	T
X-Google-Smtp-Source: AGHT+IGfgXbpqZgKjNCGN8KVVHtzk2yqUaFF2+wmjjuAVnYD5GbeKX6Jl3GUMNEQNUdVj+AH74b60A==
X-Received: by 2002:a05:6512:20ce:b0:511:78bb:1a4d with SMTP id u14-20020a05651220ce00b0051178bb1a4dmr3559454lfr.17.1708097727158;
        Fri, 16 Feb 2024 07:35:27 -0800 (PST)
Received: from m1x-phil.lan ([176.187.210.246])
        by smtp.gmail.com with ESMTPSA id rn28-20020a170906d93c00b00a36c5b01ef3sm42951ejb.225.2024.02.16.07.35.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 16 Feb 2024 07:35:26 -0800 (PST)
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
Subject: [PATCH 1/6] hw/arm: Inline sysbus_create_simple(PL110 / PL111)
Date: Fri, 16 Feb 2024 16:35:12 +0100
Message-ID: <20240216153517.49422-2-philmd@linaro.org>
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

We want to set another qdev property (a link) for the pl110
and pl111 devices, we can not use sysbus_create_simple() which
only passes sysbus base address and IRQs as arguments. Inline
it so we can set the link property in the next commit.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/arm/realview.c    |  5 ++++-
 hw/arm/versatilepb.c |  6 +++++-
 hw/arm/vexpress.c    | 10 ++++++++--
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/hw/arm/realview.c b/hw/arm/realview.c
index 9058f5b414..77300e92e5 100644
--- a/hw/arm/realview.c
+++ b/hw/arm/realview.c
@@ -238,7 +238,10 @@ static void realview_init(MachineState *machine,
     sysbus_create_simple("pl061", 0x10014000, pic[7]);
     gpio2 = sysbus_create_simple("pl061", 0x10015000, pic[8]);
 
-    sysbus_create_simple("pl111", 0x10020000, pic[23]);
+    dev = qdev_new("pl111");
+    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
+    sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, 0x10020000);
+    sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, pic[23]);
 
     dev = sysbus_create_varargs("pl181", 0x10005000, pic[17], pic[18], NULL);
     /* Wire up MMC card detect and read-only signals. These have
diff --git a/hw/arm/versatilepb.c b/hw/arm/versatilepb.c
index d10b75dfdb..7e04b23af8 100644
--- a/hw/arm/versatilepb.c
+++ b/hw/arm/versatilepb.c
@@ -299,7 +299,11 @@ static void versatile_init(MachineState *machine, int board_id)
 
     /* The versatile/PB actually has a modified Color LCD controller
        that includes hardware cursor support from the PL111.  */
-    dev = sysbus_create_simple("pl110_versatile", 0x10120000, pic[16]);
+    dev = qdev_new("pl110_versatile");
+    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
+    sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, 0x10120000);
+    sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, pic[16]);
+
     /* Wire up the mux control signals from the SYS_CLCD register */
     qdev_connect_gpio_out(sysctl, 0, qdev_get_gpio_in(dev, 0));
 
diff --git a/hw/arm/vexpress.c b/hw/arm/vexpress.c
index aa5f3ca0d4..671986c21e 100644
--- a/hw/arm/vexpress.c
+++ b/hw/arm/vexpress.c
@@ -276,6 +276,7 @@ static void a9_daughterboard_init(VexpressMachineState *vms,
 {
     MachineState *machine = MACHINE(vms);
     MemoryRegion *sysmem = get_system_memory();
+    DeviceState *dev;
 
     if (ram_size > 0x40000000) {
         /* 1GB is the maximum the address space permits */
@@ -297,7 +298,9 @@ static void a9_daughterboard_init(VexpressMachineState *vms,
     /* Daughterboard peripherals : 0x10020000 .. 0x20000000 */
 
     /* 0x10020000 PL111 CLCD (daughterboard) */
-    sysbus_create_simple("pl111", 0x10020000, pic[44]);
+    dev = qdev_new("pl111");
+    sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, 0x10020000);
+    sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, pic[44]);
 
     /* 0x10060000 AXI RAM */
     /* 0x100e0000 PL341 Dynamic Memory Controller */
@@ -650,7 +653,10 @@ static void vexpress_common_init(MachineState *machine)
 
     /* VE_COMPACTFLASH: not modelled */
 
-    sysbus_create_simple("pl111", map[VE_CLCD], pic[14]);
+    dev = qdev_new("pl111");
+    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
+    sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, map[VE_CLCD]);
+    sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, pic[14]);
 
     dinfo = drive_get(IF_PFLASH, 0, 0);
     pflash0 = ve_pflash_cfi01_register(map[VE_NORFLASH0], "vexpress.flash0",
-- 
2.41.0



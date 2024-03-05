Return-Path: <kvm+bounces-10993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 085AA872097
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:43:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C7621C25CF1
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C20C8613F;
	Tue,  5 Mar 2024 13:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BwizpPEb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CF15915D
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646211; cv=none; b=VrfjwhPQlo4mXUKE+q/h3UHXBdMG8yZ69u8c2jzQpW5zPtXMtXtmmtXpCa+cKz8CK9MzYXp12nxTI3HCiPBY9sq2ruNs9humas/PjFPhuMnQTyfSGAjLpoUWbOcYSgS2z2YvkDGLOxuU60PVlNaJELWj5RqaS18p3yUqC/ZSrkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646211; c=relaxed/simple;
	bh=jwF3AbTukR/6HTghMfOgXQV/wDPLw05QOsKUsxuS04E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VIdnAccs75FssbP4RmY5kyiu0j7+GAcUPS4SsU4UZsS7/fJSN8CPxpCc8wjlGDggr2nENSl6MTLhYieOCaX1SY1tc0UWXBQ7RUDWjhbWcBwUxXpHtlnKTRasVPAxq1t+sO0DxUSviwC+XoJkPo1kvRf+n+QDUUnhmKXxIO0L4kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BwizpPEb; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-564fd9eea75so924637a12.3
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646208; x=1710251008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0hhJFtIMtwQt2Q60UHnY//zCzzc81rKvwExxrpPdrH8=;
        b=BwizpPEb2AJxzZLuB/OsvKp6qBWVFsQwio9q81kuntfJhyemDhaPoojQzd0dkqdNHQ
         M2grab8DLGsbuz6j4kyk8/iPh94zoHoD9k+dACnsodhN0VM22WmQICNRs69caOSCFVNh
         16xdrt373tg+sALb3Cq7tLju0AJq3Djj5rLR25o318/+UZcyep+vQITyvWbxp2PyrtrJ
         saLTe20+w714pkslTXkvkKeBCbBtDj8dGITxQOCtCbEs3X3oHlOsflR9ZmnEIwsGmXLW
         7LjffPq/lY4+CRVsJ34d5iqVy06mxo6Nn04Z5K1yfCU0qNEBcdfu494b2WNpCmcEwcv0
         du1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646208; x=1710251008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0hhJFtIMtwQt2Q60UHnY//zCzzc81rKvwExxrpPdrH8=;
        b=bj9tcP8hB5FGO9INiftLaLQQ9iK3WYrgXBsvbqveEDdTPQXjl5yhhqcVP5UvvCSvLK
         2S4xepbzRhbWIXTD64yKpwVyPWQe1NchJrvYHO110b9rBQWb4Kz2fActeBqPBRjyUJjR
         wDaYtLk5p2G8Llk//Bfu3EbNuQtiFyNI7QrJEW577Gjd7D4TPDkm/4yAHhoci7xzBnOt
         TB2cNcz12GThpRCmJAHhR0/BkQjBNbXjy/Ksem5fSwOq0wqe3IMbsIiqgOhaGbboFGyY
         cNNI7EAKV3n+0TX0pMGtIfHUlpiarXSpkbfTk50s4dWK7NcykUEfpwMDLMoR4VienUIl
         pZ3Q==
X-Forwarded-Encrypted: i=1; AJvYcCX0Myo/xJgmw7euNmpqY+i0qESrIn7ES9hV6N3l2gVZb5r3msHPL1HKsgypya9Cg+XLgm+Nh6iPM8eDyfVWYmCtS3Jb
X-Gm-Message-State: AOJu0YxmOihcV+XinqkPU5sQsbKOovN26AgeZTqzQXzdV3uZ2pstrnIA
	sNMy5rdUB3jxZvQm0Vva2te8P6IlqnEqzyzO66fcvH8tr6Luh33RQDBk9iPuSprmOzDVDEF+DE3
	t
X-Google-Smtp-Source: AGHT+IFem75Y0FPHygJH4hylsAO/6REF+jZArZQNrRqkWJpWcKTi1COMM9pGe9G4ODDoaNilTiITnQ==
X-Received: by 2002:a17:906:1c8d:b0:a44:415d:fa39 with SMTP id g13-20020a1709061c8d00b00a44415dfa39mr6365674ejh.37.1709646208209;
        Tue, 05 Mar 2024 05:43:28 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id f18-20020a170906049200b00a44ebb34851sm3773626eja.10.2024.03.05.05.43.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:43:27 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	devel@lists.libvirt.org,
	David Hildenbrand <david@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>
Subject: [PATCH-for-9.1 09/18] hw/i386/pc: Remove PCMachineClass::enforce_aligned_dimm
Date: Tue,  5 Mar 2024 14:42:11 +0100
Message-ID: <20240305134221.30924-10-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240305134221.30924-1-philmd@linaro.org>
References: <20240305134221.30924-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

PCMachineClass::enforce_aligned_dimm was only used by the
pc-i440fx-2.1 machine, which got removed. It is now always
true. Remove it, simplifying pc_get_device_memory_range().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/i386/pc.h |  3 ---
 hw/i386/pc.c         | 14 +++-----------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index f051ddafca..bf1d6e99b4 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -74,8 +74,6 @@ typedef struct PCMachineState {
  *
  * Compat fields:
  *
- * @enforce_aligned_dimm: check that DIMM's address/size is aligned by
- *                        backend's alignment value if provided
  * @acpi_data_size: Size of the chunk of memory at the top of RAM
  *                  for the BIOS ACPI tables and other BIOS
  *                  datastructures.
@@ -114,7 +112,6 @@ struct PCMachineClass {
     /* RAM / address space compat: */
     bool gigabyte_align;
     bool has_reserved_memory;
-    bool enforce_aligned_dimm;
     bool broken_reserved_end;
     bool enforce_amd_1tb_hole;
 
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 409114bba5..0950abcc2a 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -734,7 +734,6 @@ static void pc_get_device_memory_range(PCMachineState *pcms,
                                        hwaddr *base,
                                        ram_addr_t *device_mem_size)
 {
-    PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
     MachineState *machine = MACHINE(pcms);
     ram_addr_t size;
     hwaddr addr;
@@ -742,10 +741,8 @@ static void pc_get_device_memory_range(PCMachineState *pcms,
     size = machine->maxram_size - machine->ram_size;
     addr = ROUND_UP(pc_above_4g_end(pcms), 1 * GiB);
 
-    if (pcmc->enforce_aligned_dimm) {
-        /* size device region assuming 1G page max alignment per slot */
-        size += (1 * GiB) * machine->ram_slots;
-    }
+    /* size device region assuming 1G page max alignment per slot */
+    size += (1 * GiB) * machine->ram_slots;
 
     *base = addr;
     *device_mem_size = size;
@@ -1301,12 +1298,9 @@ void pc_i8259_create(ISABus *isa_bus, qemu_irq *i8259_irqs)
 static void pc_memory_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
                                Error **errp)
 {
-    const PCMachineState *pcms = PC_MACHINE(hotplug_dev);
     const X86MachineState *x86ms = X86_MACHINE(hotplug_dev);
-    const PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
     const MachineState *ms = MACHINE(hotplug_dev);
     const bool is_nvdimm = object_dynamic_cast(OBJECT(dev), TYPE_NVDIMM);
-    const uint64_t legacy_align = TARGET_PAGE_SIZE;
     Error *local_err = NULL;
 
     /*
@@ -1331,8 +1325,7 @@ static void pc_memory_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
         return;
     }
 
-    pc_dimm_pre_plug(PC_DIMM(dev), MACHINE(hotplug_dev),
-                     pcmc->enforce_aligned_dimm ? NULL : &legacy_align, errp);
+    pc_dimm_pre_plug(PC_DIMM(dev), MACHINE(hotplug_dev), NULL, errp);
 }
 
 static void pc_memory_plug(HotplugHandler *hotplug_dev,
@@ -1793,7 +1786,6 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
     pcmc->smbios_defaults = true;
     pcmc->gigabyte_align = true;
     pcmc->has_reserved_memory = true;
-    pcmc->enforce_aligned_dimm = true;
     pcmc->enforce_amd_1tb_hole = true;
     /* BIOS ACPI tables: 128K. Other BIOS datastructures: less than 4K reported
      * to be used at the moment, 32K should be enough for a while.  */
-- 
2.41.0



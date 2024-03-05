Return-Path: <kvm+bounces-11002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47E2A8720A5
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:44:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C0E21C25F6B
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA4C85C70;
	Tue,  5 Mar 2024 13:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Qjb06DjD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC475676A
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646274; cv=none; b=sLDpqzTM6uFjejWF4YZEqxFdhZPT2sG2c3Iqi1IVHl/tofLebWZDCJ+gzqr518e5gQo6wq7kcBSFkXkAwqGwi77FotY3f3Rg842+dRX3RWD0cuiOIWXJE8+ZOStGfp4XCfN0nvkLhO+CDw7baFRsmVJlCe5YIhNRm6wAJVXEAW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646274; c=relaxed/simple;
	bh=Zv8TEYpl4FTPaycvD89xMRWpPPEVQqYImAIZSGGG0Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jYq8fCVrpb68Nw5r0fy65hqbAuRf9XOd4eEM/7k+fC+qqw/j8Uq2EixIKW9mUiCzbvX3zWqtqOl2sZSNphsV4yt1YKqW6w2NCu/0Ad2mnwjXxaVB8kO1RIoADv9U9RPVq2Kllh/7dNNx50QscduPKHMo5yWPDz9k7POFidD7K9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Qjb06DjD; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5132010e5d1so963834e87.0
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646271; x=1710251071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iOxnYUajpBTpGKSyr9S0Yy8S7gw3p/1QBOxX+w9BDyM=;
        b=Qjb06DjDqTuyU5WVVn5AOVLyT8aOWiLU5mYjKhemVoW1k3lpFNOKcFCwP1iaejQ60r
         wKWPpO/+rR4bfTcA/ic9PqV3xGtM08TdFYUGexH7UiNfaLJcyoIWZ8gHKzMl/Nlnvx+L
         YP4ZwV/+yfpOsvPuGzJ8gldRnLRyn85ILcUhIx+bfNdzI0M1YLe7EqGNGJ+tGmSksYS+
         YKdHujcsa/dweNPyfehUprGN1sRCIFEOSUDWkVQrkTIWDaks/ZoT9SYOf9fH+Utz4h9+
         dzkDR1mPI6TISJET0q+cVU+H3Cg8Z+7rY5F/3N25HUyUAOu9lnldHmlUcdrPjwSuYAPl
         3NlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646271; x=1710251071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iOxnYUajpBTpGKSyr9S0Yy8S7gw3p/1QBOxX+w9BDyM=;
        b=fz9RyJrtoAInoFnRAy0V0XNqlwfo9uSj00fMzXo9gat5TNaWjYG7fO5cTazHw8rLx1
         nwrGizsVW7jqmXvEbYnzqCdxZoDQKXIyY/kvj6ngwq7FvAZiIbCV9A6tnuPs35dNa8lR
         6SlyJ7xfONWIjv/roxOncADmhdOT6wQ51AVWqOHuPmxByqsVh7rYxWxAQvxvCtPMCZSF
         AQzpV4gfL+JG1FS88BQ94PlDMpAtULZMoqwl4QkEdK6Xz6e9uVzImWqoGupQyT3VKQCa
         dSH3Jz8wlz856EblOtLf53Mo0XyUp+XNBUZsDcrc2V/cK0pC4PeQ0MMuqs7PMGu2Y3RZ
         Tlzw==
X-Forwarded-Encrypted: i=1; AJvYcCX8DC3RCEmvF9C96v2j8eFIOYduXDm3Xwh7YlMHvRL+Rn5JduYw1rcxmU5vDKJVuWHFUnqxZ3UIAcX1VuVbzg9Wvual
X-Gm-Message-State: AOJu0YwuQHea5uhBCGDkkhfUefNqaILtjVZ5QkrCUkCYSaTmSX+nU/Pv
	ebuNytjLkDaF5dVXL8/MUsBY/r7Ck4kOWIsDCyUbIkumwtm+7XzobnAZ63VyV0I=
X-Google-Smtp-Source: AGHT+IHpOzBhI25sZswJgzVD41rB8MjyWnj6iLrgSAs150NP2za1mp4EKVUQTwD9LVaUetj1tdSnbA==
X-Received: by 2002:a05:6512:10ce:b0:513:588a:260f with SMTP id k14-20020a05651210ce00b00513588a260fmr510188lfg.38.1709646271091;
        Tue, 05 Mar 2024 05:44:31 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id bu16-20020a056000079000b0033dc3f3d689sm15142258wrb.93.2024.03.05.05.44.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:44:30 -0800 (PST)
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
Subject: [PATCH-for-9.1 18/18] hw/i386/pc: Replace PCMachineClass::acpi_data_size by PC_ACPI_DATA_SIZE
Date: Tue,  5 Mar 2024 14:42:20 +0100
Message-ID: <20240305134221.30924-19-philmd@linaro.org>
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

PCMachineClass::acpi_data_size was only used by the pc-i440fx-2.0
machine, which got removed. Since it is constant, replace the class
field by a definition.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/i386/pc.h |  4 ----
 hw/i386/pc.c         | 19 ++++++++++++-------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index b4a9ea46a3..2e57a1b5da 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -74,9 +74,6 @@ typedef struct PCMachineState {
  *
  * Compat fields:
  *
- * @acpi_data_size: Size of the chunk of memory at the top of RAM
- *                  for the BIOS ACPI tables and other BIOS
- *                  datastructures.
  * @gigabyte_align: Make sure that guest addresses aligned at
  *                  1Gbyte boundaries get mapped to host
  *                  addresses aligned at 1Gbyte boundaries. This
@@ -100,7 +97,6 @@ struct PCMachineClass {
 
     /* ACPI compat: */
     bool has_acpi_build;
-    unsigned acpi_data_size;
     int pci_root_uid;
 
     /* SMBIOS compat: */
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 4b9f4c5c2c..ce9e6b6272 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -256,6 +256,16 @@ GlobalProperty pc_compat_2_4[] = {
 };
 const size_t pc_compat_2_4_len = G_N_ELEMENTS(pc_compat_2_4);
 
+/*
+ * @PC_ACPI_DATA_SIZE:
+ * Size of the chunk of memory at the top of RAM for the BIOS ACPI tables
+ * and other BIOS datastructures.
+ *
+ * BIOS ACPI tables: 128K. Other BIOS datastructures: less than 4K
+ * reported to be used at the moment, 32K should be enough for a while.
+ */
+#define PC_ACPI_DATA_SIZE (0x20000 + 0x8000)
+
 GSIState *pc_gsi_create(qemu_irq **irqs, bool pci_enabled)
 {
     GSIState *s;
@@ -652,8 +662,7 @@ void xen_load_linux(PCMachineState *pcms)
     fw_cfg_add_i16(fw_cfg, FW_CFG_NB_CPUS, x86ms->boot_cpus);
     rom_set_fw(fw_cfg);
 
-    x86_load_linux(x86ms, fw_cfg, pcmc->acpi_data_size,
-                   pcmc->pvh_enabled);
+    x86_load_linux(x86ms, fw_cfg, PC_ACPI_DATA_SIZE, pcmc->pvh_enabled);
     for (i = 0; i < nb_option_roms; i++) {
         assert(!strcmp(option_rom[i].name, "linuxboot.bin") ||
                !strcmp(option_rom[i].name, "linuxboot_dma.bin") ||
@@ -987,8 +996,7 @@ void pc_memory_init(PCMachineState *pcms,
     }
 
     if (linux_boot) {
-        x86_load_linux(x86ms, fw_cfg, pcmc->acpi_data_size,
-                       pcmc->pvh_enabled);
+        x86_load_linux(x86ms, fw_cfg, PC_ACPI_DATA_SIZE, pcmc->pvh_enabled);
     }
 
     for (i = 0; i < nb_option_roms; i++) {
@@ -1737,9 +1745,6 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
     pcmc->gigabyte_align = true;
     pcmc->has_reserved_memory = true;
     pcmc->enforce_amd_1tb_hole = true;
-    /* BIOS ACPI tables: 128K. Other BIOS datastructures: less than 4K reported
-     * to be used at the moment, 32K should be enough for a while.  */
-    pcmc->acpi_data_size = 0x20000 + 0x8000;
     pcmc->pvh_enabled = true;
     pcmc->kvmclock_create_always = true;
     x86mc->apic_xrupt_override = true;
-- 
2.41.0



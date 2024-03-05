Return-Path: <kvm+bounces-10998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71B3487209E
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:44:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3B14B28C7D
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64A7F85C70;
	Tue,  5 Mar 2024 13:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nBqebKfL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA795676A
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646246; cv=none; b=diA+xGgNRaoHQbhUp+PljSndjlv1oyoC0elR1Euwl75gDVC++WCo3rVi/rNX0L0fx2rbdNiWrrfL5OK0SBiaVgptcslAynZMpR6Ig5eo6qUOczCMilc97O87tAURwwacwbAGLqGbeD4uWkeAN+Mzr9b/xy2h1y6fKNWyV1nSYSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646246; c=relaxed/simple;
	bh=ClegcMf7H40OMS0VZ3ZH3g2LaoCdDpzJvruzbZgIzt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nmzsQ9+s24WbrlizULWICjzuimtI7Eh2esW3hdykLBIVApVvG29n88lJUMs//uOdIYW76GzpJiLIR/8kGscvxjgbb19jDuwKl/XBMUm8Q3kUOZXHYd9nn+sqNFzubqkS+SVnBzWfJJY5zl+rGP2aEX99ZYUrnRRN0WREos09F/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nBqebKfL; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-33e1878e357so2768124f8f.3
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646243; x=1710251043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FzQHy7YOOPXp7F0gjrTW5/+w7YXN5elr0MFrrc4cC28=;
        b=nBqebKfLDoi53nRgZK0Rx4K9+niajXr2Gf7sbByWzXBIpe6Q3mGPcrYiJAPC/8ADNj
         fRZt4QvqhM38lQk3K+l4mEEibjdoKEOputpfCUWHhSUFPrvBdVLPjYx9t+vkUSWaz+0y
         7wrIXHe2Xsfo2i943uW0lgZ0Nx+X3jwBk1TcSR+PkwTzyhaye8jHdExWr9Ydh8ew3HMn
         T9dkuuyXj6oRblJ0+okFFLpHovzwZdOrmm3HyEoAmtxe52SDNycH1hvXr+GsISTIzX5S
         ZG6r8LsbdEdCqbBCW/N7hIWlQpXAcogBhai5Fs/k0P2CGb8wDGsAaBdhGqzuEGPK1bSu
         5hNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646243; x=1710251043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FzQHy7YOOPXp7F0gjrTW5/+w7YXN5elr0MFrrc4cC28=;
        b=Up7Gir40od4JZ/3VL1GqoIsiZUjp/vt+a1ETt7BtS3vFGyXXWC1elCWWqtxVzREh2m
         fQX75ihGz/5TXh3H1spq55ySI0DaJA29MRCuSTvIPOgii64KeTZCOe1ePXagkmRFCrjY
         wKh4q4TNzPZi6/9Wi9LLCjo7Xw/IHifxG0yMLGenQDwHcIwYYUbbLZkMi+zwNs3cBuRx
         eF2H9AcFEk3meEtnKuASAc6nZbqTtIqyAmLtxaTiqIolSqXNhNKFZhJ/gdCCPizqpypA
         pX43a7lmtNlt7wWgOhn1fRarTktAAlLe8bRSXdkIdpV/7PoShJTupSt+SO6NqCR4CXa3
         V6Kw==
X-Forwarded-Encrypted: i=1; AJvYcCUdRAsZKiMuMH9lWmXju/Hx9G0bXbCmvmINrOiNqM+KX+f/evceypM4iWegF4rdm+EkNpVuEh0q2uJYmprJJd3v9o7W
X-Gm-Message-State: AOJu0Yx/Q0mSZ5g3iE6vPjIrSpqLIFKfj62AYA/9EFjK+Cpsq4VsC6KH
	chkTFCyUWLngNmKT/GlrsA5CsenKbFBg7mgBoWS7eXaB6devrOZZH7e7phGhzYY=
X-Google-Smtp-Source: AGHT+IEjpwA0g43mBREYBeuT5/kLCNlui8vuGjhft3ga4tNUhSEjB3x6+ULiPdcLMxtnN6fCCD8dmQ==
X-Received: by 2002:a5d:6e48:0:b0:33d:6c9f:39d6 with SMTP id j8-20020a5d6e48000000b0033d6c9f39d6mr8913204wrz.40.1709646243280;
        Tue, 05 Mar 2024 05:44:03 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id f6-20020a5d6646000000b0033e34982311sm6992738wrw.81.2024.03.05.05.44.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:44:02 -0800 (PST)
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
Subject: [PATCH-for-9.1 14/18] hw/i386/pc: Remove PCMachineClass::rsdp_in_ram
Date: Tue,  5 Mar 2024 14:42:16 +0100
Message-ID: <20240305134221.30924-15-philmd@linaro.org>
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

PCMachineClass::rsdp_in_ram was only used by the
pc-i440fx-2.2 machine, which got removed. It is
now always true. Remove it, simplifying acpi_setup().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/i386/pc.h |  1 -
 hw/i386/acpi-build.c | 35 ++++-------------------------------
 hw/i386/pc.c         |  1 -
 3 files changed, 4 insertions(+), 33 deletions(-)

diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index be3a58c972..b4a9ea46a3 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -100,7 +100,6 @@ struct PCMachineClass {
 
     /* ACPI compat: */
     bool has_acpi_build;
-    bool rsdp_in_ram;
     unsigned acpi_data_size;
     int pci_root_uid;
 
diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
index a56ac8dc90..12bc2b7d54 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -2492,7 +2492,6 @@ static
 void acpi_build(AcpiBuildTables *tables, MachineState *machine)
 {
     PCMachineState *pcms = PC_MACHINE(machine);
-    PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
     X86MachineState *x86ms = X86_MACHINE(machine);
     DeviceState *iommu = pcms->iommu;
     GArray *table_offsets;
@@ -2664,16 +2663,6 @@ void acpi_build(AcpiBuildTables *tables, MachineState *machine)
             .rsdt_tbl_offset = &rsdt,
         };
         build_rsdp(tables->rsdp, tables->linker, &rsdp_data);
-        if (!pcmc->rsdp_in_ram) {
-            /* We used to allocate some extra space for RSDP revision 2 but
-             * only used the RSDP revision 0 space. The extra bytes were
-             * zeroed out and not used.
-             * Here we continue wasting those extra 16 bytes to make sure we
-             * don't break migration for machine types 2.2 and older due to
-             * RSDP blob size mismatch.
-             */
-            build_append_int_noprefix(tables->rsdp, 0, 16);
-        }
     }
 
     /* We'll expose it all to Guest so we want to reduce
@@ -2755,7 +2744,6 @@ static const VMStateDescription vmstate_acpi_build = {
 void acpi_setup(void)
 {
     PCMachineState *pcms = PC_MACHINE(qdev_get_machine());
-    PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
     X86MachineState *x86ms = X86_MACHINE(pcms);
     AcpiBuildTables tables;
     AcpiBuildState *build_state;
@@ -2817,25 +2805,10 @@ void acpi_setup(void)
                            tables.vmgenid);
     }
 
-    if (!pcmc->rsdp_in_ram) {
-        /*
-         * Keep for compatibility with old machine types.
-         * Though RSDP is small, its contents isn't immutable, so
-         * we'll update it along with the rest of tables on guest access.
-         */
-        uint32_t rsdp_size = acpi_data_len(tables.rsdp);
-
-        build_state->rsdp = g_memdup(tables.rsdp->data, rsdp_size);
-        fw_cfg_add_file_callback(x86ms->fw_cfg, ACPI_BUILD_RSDP_FILE,
-                                 acpi_build_update, NULL, build_state,
-                                 build_state->rsdp, rsdp_size, true);
-        build_state->rsdp_mr = NULL;
-    } else {
-        build_state->rsdp = NULL;
-        build_state->rsdp_mr = acpi_add_rom_blob(acpi_build_update,
-                                                 build_state, tables.rsdp,
-                                                 ACPI_BUILD_RSDP_FILE);
-    }
+    build_state->rsdp = NULL;
+    build_state->rsdp_mr = acpi_add_rom_blob(acpi_build_update,
+                                             build_state, tables.rsdp,
+                                             ACPI_BUILD_RSDP_FILE);
 
     qemu_register_reset(acpi_build_reset, build_state);
     acpi_build_reset(build_state);
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 8139cd4a7d..7f41895d97 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1758,7 +1758,6 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
 
     pcmc->pci_enabled = true;
     pcmc->has_acpi_build = true;
-    pcmc->rsdp_in_ram = true;
     pcmc->smbios_defaults = true;
     pcmc->gigabyte_align = true;
     pcmc->has_reserved_memory = true;
-- 
2.41.0



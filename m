Return-Path: <kvm+bounces-10984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3CBB872087
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:42:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5961D284A19
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C4A485C70;
	Tue,  5 Mar 2024 13:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ejEVd1lr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF2243AB0
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646155; cv=none; b=X4jZxTbt3GwcM894tY2ZSg+pLF1iBJjV+0twGPTsHts2Qh0lxsF681S/E7msPplx/mnmjElHZGOFYjRpuTUJlV9JgGJKUzaUTCJyPB8nZSg0BG52bYuSRQYafwInlYYJAE5z/hPJeQ3dsN+tS3L7JG3eIy19sPUrpXPy33Y7Agk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646155; c=relaxed/simple;
	bh=4f5hpTMNukHoMuNyvqbw+kfTjdcX8GLFrMreKTfTYps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hO76iKGSZeHRQAUexJCrq5dNlOQjDFiL7j+pFfaf3wDiNgnysOcsG8/CaWogvdwvi3wR0dicRwcQDFu23em/eX0HET5bxIhSkDzqH2iEnPwHU2Y6bQrVh5ps6GHWCpURN9KQMna4VRDAbtbk3ROQEr4ON2AfavyzrcLunkKrgJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ejEVd1lr; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-566e869f631so4727669a12.0
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646152; x=1710250952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMNfTRI2EEqDMvR5k42GTJ+bmKNe3TP93rxFG8a8RHU=;
        b=ejEVd1lrH1FK81gV+SnnKRXgLK4+DginodNDks6/JG0Qtzr6YooHbvdv6cLr/7LGdx
         IfA5CzWSZc3RivZFc/5Ae8UmsDlXwuoHq7FIm/tr96kA+BNTF5xXR0Po3qtmduGxOjva
         sR2GlEqKW/UIbgCoN2aRQpc9kW5ifOj31AoQd5wtxoSh5rbzgbvQz5V+8BSXbh/lQIWU
         PwXO5eEGxoeq6dKw8LMDiy3c4t+NfxE/Rik7tvT130ocfvDkZm8xsgnVoZu2VvkeYUAc
         SzAWVVgCIJz0UoLOE3YHEqVz6Q/hZ7p97pTBOXIwJfB0+BHL6uaS/BqZ9jzv6p6tGD7H
         y9nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646152; x=1710250952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OMNfTRI2EEqDMvR5k42GTJ+bmKNe3TP93rxFG8a8RHU=;
        b=Jt9n1205OmUYR/LGdX+Ab4VWOC/c101CHcPTbtr142hN5tf4YfVljO0plAtkfpr6Ar
         srt53QukpaYlv+ixFZ8VLgtMm8F9JwOfgA0DoFoX84r71T5JY6r1tZmWLn7Mge/rk+ZR
         UW0/qnfiF1T1jt92p+SbEJCbH/EnANsY3FBhIz6ZIEXvn9mHvHZx51PepGlBDHZg+dnm
         mlk3sz+m1Ie+j88stbFT7tmKlFsTqc1NB83rHJWk0YEdmJlsJ66wZ10q9/m1cZ7WU8kN
         0pf4fdx2B4AQXPeaMFIZCdyHg+oTpZ9IGi9qzp6nNJ/o/NzJdcVw0z4j7WYWG4RQjJpt
         XGmw==
X-Forwarded-Encrypted: i=1; AJvYcCWLChtei48W/CI6/cYUNrHnb42XOg8K4nJfS+o0TO8hjS29VljBLrpj1Y74EvE0ZEaU0ovsq3SQHuzqbtoEC1WDESRq
X-Gm-Message-State: AOJu0Yzj6Gx4yvmGuG30R9xGJ09/W9hwNURLYRui4VgcREhXHaHraEGQ
	W8CzFPslzWjcjfiXjGo6/IqEHikG7/pIOJxMXnmUDJgQ0JCiSpPz9hSH44+9eUY=
X-Google-Smtp-Source: AGHT+IG1q9HaAJ/qhvQerM8geumyfDRonf6wnB9tKhRLsDqaklXBgRR2dzeyq17BLhnoyQtqTJ+6sw==
X-Received: by 2002:a05:6402:5189:b0:567:26dd:d403 with SMTP id q9-20020a056402518900b0056726ddd403mr6223181edd.17.1709646152145;
        Tue, 05 Mar 2024 05:42:32 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id i1-20020a0564020f0100b00567afe29709sm215237eda.78.2024.03.05.05.42.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:42:31 -0800 (PST)
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
Subject: [PATCH-for-9.1 01/18] hw/i386/pc: Remove deprecated pc-i440fx-2.0 machine
Date: Tue,  5 Mar 2024 14:42:03 +0100
Message-ID: <20240305134221.30924-2-philmd@linaro.org>
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

The pc-i440fx-2.0 machine was deprecated for the 8.2
release (see commit c7437f0ddb "docs/about: Mark the
old pc-i440fx-2.0 - 2.3 machine types as deprecated"),
time to remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 docs/about/deprecated.rst       |  2 +-
 docs/about/removed-features.rst |  2 +-
 include/hw/i386/pc.h            |  3 ---
 hw/i386/pc.c                    | 15 -------------
 hw/i386/pc_piix.c               | 37 ---------------------------------
 5 files changed, 2 insertions(+), 57 deletions(-)

diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
index 8565644da6..6d4738ca20 100644
--- a/docs/about/deprecated.rst
+++ b/docs/about/deprecated.rst
@@ -221,7 +221,7 @@ deprecated; use the new name ``dtb-randomness`` instead. The new name
 better reflects the way this property affects all random data within
 the device tree blob, not just the ``kaslr-seed`` node.
 
-``pc-i440fx-2.0`` up to ``pc-i440fx-2.3`` (since 8.2)
+``pc-i440fx-2.1`` up to ``pc-i440fx-2.3`` (since 8.2)
 '''''''''''''''''''''''''''''''''''''''''''''''''''''
 
 These old machine types are quite neglected nowadays and thus might have
diff --git a/docs/about/removed-features.rst b/docs/about/removed-features.rst
index 417a0e4fa1..156737989e 100644
--- a/docs/about/removed-features.rst
+++ b/docs/about/removed-features.rst
@@ -801,7 +801,7 @@ mips ``fulong2e`` machine alias (removed in 6.0)
 
 This machine has been renamed ``fuloong2e``.
 
-``pc-0.10`` up to ``pc-i440fx-1.7`` (removed in 4.0 up to 8.2)
+``pc-0.10`` up to ``pc-i440fx-2.0`` (removed in 4.0 up to 9.0)
 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
 These machine types were very old and likely could not be used for live
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index b958023187..3360ca2307 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -285,9 +285,6 @@ extern const size_t pc_compat_2_2_len;
 extern GlobalProperty pc_compat_2_1[];
 extern const size_t pc_compat_2_1_len;
 
-extern GlobalProperty pc_compat_2_0[];
-extern const size_t pc_compat_2_0_len;
-
 #define DEFINE_PC_MACHINE(suffix, namestr, initfn, optsfn) \
     static void pc_machine_##suffix##_class_init(ObjectClass *oc, void *data) \
     { \
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index f5ff970acf..bb7ef31af2 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -311,21 +311,6 @@ GlobalProperty pc_compat_2_1[] = {
 };
 const size_t pc_compat_2_1_len = G_N_ELEMENTS(pc_compat_2_1);
 
-GlobalProperty pc_compat_2_0[] = {
-    PC_CPU_MODEL_IDS("2.0.0")
-    { "virtio-scsi-pci", "any_layout", "off" },
-    { "PIIX4_PM", "memory-hotplug-support", "off" },
-    { "apic", "version", "0x11" },
-    { "nec-usb-xhci", "superspeed-ports-first", "off" },
-    { "nec-usb-xhci", "force-pcie-endcap", "on" },
-    { "pci-serial", "prog_if", "0" },
-    { "pci-serial-2x", "prog_if", "0" },
-    { "pci-serial-4x", "prog_if", "0" },
-    { "virtio-net-pci", "guest_announce", "off" },
-    { "ICH9-LPC", "memory-hotplug-support", "off" },
-};
-const size_t pc_compat_2_0_len = G_N_ELEMENTS(pc_compat_2_0);
-
 GSIState *pc_gsi_create(qemu_irq **irqs, bool pci_enabled)
 {
     GSIState *s;
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index fa5f93f99f..594b131625 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -441,11 +441,6 @@ static void pc_compat_2_1_fn(MachineState *machine)
     x86_cpu_change_kvm_default("svm", NULL);
 }
 
-static void pc_compat_2_0_fn(MachineState *machine)
-{
-    pc_compat_2_1_fn(machine);
-}
-
 #ifdef CONFIG_ISAPC
 static void pc_init_isa(MachineState *machine)
 {
@@ -868,38 +863,6 @@ static void pc_i440fx_2_1_machine_options(MachineClass *m)
 DEFINE_I440FX_MACHINE(v2_1, "pc-i440fx-2.1", pc_compat_2_1_fn,
                       pc_i440fx_2_1_machine_options);
 
-static void pc_i440fx_2_0_machine_options(MachineClass *m)
-{
-    PCMachineClass *pcmc = PC_MACHINE_CLASS(m);
-
-    pc_i440fx_2_1_machine_options(m);
-    m->hw_version = "2.0.0";
-    compat_props_add(m->compat_props, pc_compat_2_0, pc_compat_2_0_len);
-    pcmc->smbios_legacy_mode = true;
-    pcmc->has_reserved_memory = false;
-    /* This value depends on the actual DSDT and SSDT compiled into
-     * the source QEMU; unfortunately it depends on the binary and
-     * not on the machine type, so we cannot make pc-i440fx-1.7 work on
-     * both QEMU 1.7 and QEMU 2.0.
-     *
-     * Large variations cause migration to fail for more than one
-     * consecutive value of the "-smp" maxcpus option.
-     *
-     * For small variations of the kind caused by different iasl versions,
-     * the 4k rounding usually leaves slack.  However, there could be still
-     * one or two values that break.  For QEMU 1.7 and QEMU 2.0 the
-     * slack is only ~10 bytes before one "-smp maxcpus" value breaks!
-     *
-     * 6652 is valid for QEMU 2.0, the right value for pc-i440fx-1.7 on
-     * QEMU 1.7 it is 6414.  For RHEL/CentOS 7.0 it is 6418.
-     */
-    pcmc->legacy_acpi_table_size = 6652;
-    pcmc->acpi_data_size = 0x10000;
-}
-
-DEFINE_I440FX_MACHINE(v2_0, "pc-i440fx-2.0", pc_compat_2_0_fn,
-                      pc_i440fx_2_0_machine_options);
-
 #ifdef CONFIG_ISAPC
 static void isapc_machine_options(MachineClass *m)
 {
-- 
2.41.0



Return-Path: <kvm+bounces-14851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1DE88A7404
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:00:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 215121C21172
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBDA313791B;
	Tue, 16 Apr 2024 19:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RUFwfTGU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FC913777B
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 18:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294000; cv=none; b=KuHglKQyK9Q/ldD3zvf+dSygejz/wZ9w7te4Mdzaql1AR/TY9aSGZzR0IviAbhDQ7jsSOlpdPXupcKhTuRTC3Jc2iOKkfEsL7uBfDIWqdfYUz5bNL2GV3FSqpqHVARJUAf1DIf9fj7Ht5r0qXgHj41w3yAlnQ3uSWtSOaEHYOVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294000; c=relaxed/simple;
	bh=rAxo4a1NNCdhruKdE46wj612EsL9qnhPaDcRDR4KUXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MkkvMocUq1Gv1x5qk5cgRVZ6Qhj5ANcCYR8XKMpuhf+zVo17nABK73uiFPRa/U9xN/dh0VatfXYwdwcMI0LY4vho43CYd1tXPsHEf85z5/hD3XX/AZ/yolM8wwtESlsiyBh4Q/gKjs0bVhsq3QnFyhHSVMIm/IE7Zz92T050lKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RUFwfTGU; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-56e78970853so118296a12.0
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 11:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713293997; x=1713898797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1V0kAA/eWhoS7zcrOVou3w7pilpSrG0y1cYXN1Lr2Pg=;
        b=RUFwfTGUxDZ34ouUeospTeWQpmvc9UW7fHpjvtYB69MzjHd/7xdn8/DlpKKJVY4c1T
         /xby/8gtBaVU0wLaAm29fWXbK2EdZ+LL+iIBdHKpFqLurFig0d4giFGIRw1WrbrUCuD1
         IVMiespNdc3xfPdMdZqJYEq2U5vAjdTGNLOX+/u5p6oOivafaBousxRVomImlc9F3eFX
         z/9QN3RWShniOdi8lfE9DNzR2B/NvBStMZdZMJg6LqY59j4ZrUBkjMhXc3hwCOxjAOhT
         RkRsvpcRyCGA/tq9WbyOIYH9JSGzCFkLfkXdP8tUWoc+m1MPuoSfJE6yXrUqrZnrS++H
         HCKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713293997; x=1713898797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1V0kAA/eWhoS7zcrOVou3w7pilpSrG0y1cYXN1Lr2Pg=;
        b=oXLfnty4XgLWLbB8R8vVJz05gmI1NokAOZE4Xjss7r25QAjVT+JvzT3qy+Gz864jgZ
         EQD/lGfbPhB2FwaoMNdrptFxhubb+rmjWNdEGW+Xt7LV2N/fOGQ/V4HcXDAdHTrujIKw
         l6pe7ZC912q5OljpyrnGqDXHZp9KkVhxDQH0ipc2BHmafAoRCCTjMqt4mDCYp/eLG3Fq
         mU5lVWkc/EzAH+YFTi23SlRy/3adah08F/24byPDjqRP6rH4OV1gh3MOxXBNcQWCP5mU
         SPmr9acbStAqsxkg+DYNUfPHIKmnX6/A7sK/A/pbExq3EuG8wSOQLbADPU8/CAO33I3v
         q8fg==
X-Forwarded-Encrypted: i=1; AJvYcCU0cL5Ub9XG0NYkwKBjiBVsMcPpYCz7b/ML3OzIb8n3lPThy+xyHlxdMU6iqOAPaOCutBDYY1pQAaZoU9Ubh6GUyvo8
X-Gm-Message-State: AOJu0YyjqjCskqSp7tB0wAfLckWg2hdZfG3d3XaWoX8fAk71jlJMBafC
	i8J5QlFkTVKWKvs78LoQJS6DX8lfrBn/GFeGzIoMBFexFQUaU3OXFeJSZFzcYL4=
X-Google-Smtp-Source: AGHT+IHlrz7w1jeNA/Qttm4+X6hFJQqGDdbM0y2U1/FZjg7zMV3JYiO/NIWax6hq1GaxHfHR3Y3EwA==
X-Received: by 2002:a17:907:6d1a:b0:a51:f823:f4b4 with SMTP id sa26-20020a1709076d1a00b00a51f823f4b4mr3051283ejc.17.1713293996667;
        Tue, 16 Apr 2024 11:59:56 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.155.61])
        by smtp.gmail.com with ESMTPSA id qb11-20020a1709077e8b00b00a51ab065bf0sm7129332ejc.202.2024.04.16.11.59.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Apr 2024 11:59:56 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	devel@lists.libvirt.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: [PATCH v4 02/22] hw/i386/pc: Remove deprecated pc-i440fx-2.0 machine
Date: Tue, 16 Apr 2024 20:59:18 +0200
Message-ID: <20240416185939.37984-3-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240416185939.37984-1-philmd@linaro.org>
References: <20240416185939.37984-1-philmd@linaro.org>
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
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 docs/about/deprecated.rst       |  2 +-
 docs/about/removed-features.rst |  2 +-
 include/hw/i386/pc.h            |  3 ---
 hw/i386/pc.c                    | 15 -------------
 hw/i386/pc_piix.c               | 37 ---------------------------------
 5 files changed, 2 insertions(+), 57 deletions(-)

diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
index 47234da329..b09ae3d55d 100644
--- a/docs/about/deprecated.rst
+++ b/docs/about/deprecated.rst
@@ -219,7 +219,7 @@ deprecated; use the new name ``dtb-randomness`` instead. The new name
 better reflects the way this property affects all random data within
 the device tree blob, not just the ``kaslr-seed`` node.
 
-``pc-i440fx-2.0`` up to ``pc-i440fx-2.3`` (since 8.2) and ``pc-i440fx-2.4`` up to ``pc-i440fx-2.12`` (since 9.1)
+``pc-i440fx-2.1`` up to ``pc-i440fx-2.3`` (since 8.2) and ``pc-i440fx-2.4`` up to ``pc-i440fx-2.12`` (since 9.1)
 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
 These old machine types are quite neglected nowadays and thus might have
diff --git a/docs/about/removed-features.rst b/docs/about/removed-features.rst
index f9cf874f7b..51119e623f 100644
--- a/docs/about/removed-features.rst
+++ b/docs/about/removed-features.rst
@@ -816,7 +816,7 @@ mips ``fulong2e`` machine alias (removed in 6.0)
 
 This machine has been renamed ``fuloong2e``.
 
-``pc-0.10`` up to ``pc-i440fx-1.7`` (removed in 4.0 up to 8.2)
+``pc-0.10`` up to ``pc-i440fx-2.0`` (removed in 4.0 up to 9.0)
 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
 These machine types were very old and likely could not be used for live
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 27a68071d7..67856f54c3 100644
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
index 5c21b0c4db..172814f604 100644
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
index 817d99c0ce..9e1bca7b17 100644
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
@@ -872,38 +867,6 @@ static void pc_i440fx_2_1_machine_options(MachineClass *m)
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



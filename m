Return-Path: <kvm+bounces-14865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD2898A7415
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:01:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0F621C20C67
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5F9013791E;
	Tue, 16 Apr 2024 19:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DJ9FF++P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CA0137753
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 19:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294092; cv=none; b=aVnNA6AXdvUUmj8WBQR9ppjGT/X4sxBDZ6QYDLGyn3AWx9ZBFEp3DtGb/pz5C34MYBq6PqtL1hza/I7g3WrKWQZKk53UCYElsJffF0hbikvuKRG9Dkx7v/QD1oK3arF0q91u3Jr40eCahIStc3LNh0FmDnsctiFUQ29OluLbVHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294092; c=relaxed/simple;
	bh=06/AORJrqU/eHy1WqtWMKp/PrX2isbTsEqIy3ss2oqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J0VoJ2T4vKUAKiFwFNqiZ6VX6QN8Uh6jQU1GVeZgjwlF9nlVyhr8CG8akcnaEDrqE8jSQlWJl66QDSNkJeiY5Gs/9L0dtG/CWF2LMU/y2vg0Q9FeoMLo9orPNeRRjoFsUsppDCYgRp7bgZ/R7z8QM8db/RKDmNPPKww9gN14ZAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DJ9FF++P; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a44f2d894b7so538615566b.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 12:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713294089; x=1713898889; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGmHgX0sXYbEat6EBpXLxmNF9uP2m/qR4kqm1cYWX4M=;
        b=DJ9FF++PyOyNlyumnLoeymsUO2guk6fP9lxC+LwbHWoedSpCFwT0voiC51tdi6ebT+
         04VQRGWzwvbRFuG20eQ70aPd6Q0/fuEjUQO+v62MQYWASEsgLYHDDH2JQ9JCGh8SN51F
         ScQAhLjHyWKh5bRmdWuOwSyIMAktAeqJocqzsKXSBYGGIDFYx01A4A1WgJqNPIqF0g2o
         AFWWIKd1TpR34GauOqyLkxtytYjTEzye3A7idBEDyf9vzIXGtf+l3LVoH+uZ0uKEcPna
         d7ZgCeuahQxeSNU7MkNbot7fxEPkE5VQMDGmfixljloSQn/HTVsZlho2VIHfjLUsQsOm
         11hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713294089; x=1713898889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rGmHgX0sXYbEat6EBpXLxmNF9uP2m/qR4kqm1cYWX4M=;
        b=tiKASxsfndbJQmA1MlBq06W1330IYFZR/hCT2b4wqPeSMioAv1TDd44bbmLKm+ZSAZ
         vbpxzILclfN8c6hw5Xcfkr/PYoorT373geeZS2x5OGqdIa3xZ/+oin+uJi7gCOQV83WU
         w5IcPH2Kjels6WBW4GXH1KOR6zd79NhRZoKaWNO0wnr1iDnBaw1ZI0g3ZWpU9PVVldE7
         xTU92kL1sNiOO1IsrD0DaNZs2Kp0tzBaJG1eLUHf7Ro4UjlpyFyV+JhM+nPHdzLkAzy2
         d0bme6RJxU/HR+0HQ/22fIffCkO0/vW8kxe/80676LYsGdV42pvpz8Wrr+kgUJN0AsAD
         MaVg==
X-Forwarded-Encrypted: i=1; AJvYcCW2ddmBSj0Th5nlecQfO/UvgOS4VTLHL2zQwpr731qOztXxeIWawlXYnPfLDg6tB8MPox4LqusmEMjC6k+ExHRT+k+o
X-Gm-Message-State: AOJu0YyLi2iFJTd6fUBuVeOh88BsNZPm/s9xy1H75FrJQl8Svc/P/WVK
	CaEGRhMKFQvhbv9EaVIXMb23LSVZ/puK8rd4xkI3MAeTY5eA3/KVOt5ZrksUqz4=
X-Google-Smtp-Source: AGHT+IHwSLlfXpGmmQgYiDUJLR1M/IaxvhamPbEJuRmw3eYDC+dQDZkHraqE/dsrkb77qrGpJhsYJw==
X-Received: by 2002:a17:906:2988:b0:a52:2486:299f with SMTP id x8-20020a170906298800b00a522486299fmr8851431eje.71.1713294088766;
        Tue, 16 Apr 2024 12:01:28 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.155.61])
        by smtp.gmail.com with ESMTPSA id e22-20020a170906c01600b00a51cdde5d9bsm7211175ejz.225.2024.04.16.12.01.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Apr 2024 12:01:28 -0700 (PDT)
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
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>
Subject: [PATCH v4 16/22] hw/i386/pc: Remove deprecated pc-i440fx-2.2 machine
Date: Tue, 16 Apr 2024 20:59:32 +0200
Message-ID: <20240416185939.37984-17-philmd@linaro.org>
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

The pc-i440fx-2.2 machine was deprecated for the 8.2
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
 hw/i386/pc.c                    | 23 -----------------------
 hw/i386/pc_piix.c               | 21 ---------------------
 5 files changed, 2 insertions(+), 49 deletions(-)

diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
index a2a1b9d337..75bf0f4886 100644
--- a/docs/about/deprecated.rst
+++ b/docs/about/deprecated.rst
@@ -219,7 +219,7 @@ deprecated; use the new name ``dtb-randomness`` instead. The new name
 better reflects the way this property affects all random data within
 the device tree blob, not just the ``kaslr-seed`` node.
 
-``pc-i440fx-2.2`` up to ``pc-i440fx-2.3`` (since 8.2) and ``pc-i440fx-2.4`` up to ``pc-i440fx-2.12`` (since 9.1)
+``pc-i440fx-2.3`` up to ``pc-i440fx-2.3`` (since 8.2) and ``pc-i440fx-2.4`` up to ``pc-i440fx-2.12`` (since 9.1)
 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
 These old machine types are quite neglected nowadays and thus might have
diff --git a/docs/about/removed-features.rst b/docs/about/removed-features.rst
index 01c55103d3..4664974a8b 100644
--- a/docs/about/removed-features.rst
+++ b/docs/about/removed-features.rst
@@ -816,7 +816,7 @@ mips ``fulong2e`` machine alias (removed in 6.0)
 
 This machine has been renamed ``fuloong2e``.
 
-``pc-0.10`` up to ``pc-i440fx-2.1`` (removed in 4.0 up to 9.0)
+``pc-0.10`` up to ``pc-i440fx-2.2`` (removed in 4.0 up to 9.0)
 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
 These machine types were very old and likely could not be used for live
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 231aae92ed..df97df6ca7 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -274,9 +274,6 @@ extern const size_t pc_compat_2_4_len;
 extern GlobalProperty pc_compat_2_3[];
 extern const size_t pc_compat_2_3_len;
 
-extern GlobalProperty pc_compat_2_2[];
-extern const size_t pc_compat_2_2_len;
-
 #define DEFINE_PC_MACHINE(suffix, namestr, initfn, optsfn) \
     static void pc_machine_##suffix##_class_init(ObjectClass *oc, void *data) \
     { \
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 633724f177..18bef7c85e 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -281,29 +281,6 @@ GlobalProperty pc_compat_2_3[] = {
 };
 const size_t pc_compat_2_3_len = G_N_ELEMENTS(pc_compat_2_3);
 
-GlobalProperty pc_compat_2_2[] = {
-    PC_CPU_MODEL_IDS("2.2.0")
-    { "kvm64" "-" TYPE_X86_CPU, "vme", "off" },
-    { "kvm32" "-" TYPE_X86_CPU, "vme", "off" },
-    { "Conroe" "-" TYPE_X86_CPU, "vme", "off" },
-    { "Penryn" "-" TYPE_X86_CPU, "vme", "off" },
-    { "Nehalem" "-" TYPE_X86_CPU, "vme", "off" },
-    { "Westmere" "-" TYPE_X86_CPU, "vme", "off" },
-    { "SandyBridge" "-" TYPE_X86_CPU, "vme", "off" },
-    { "Haswell" "-" TYPE_X86_CPU, "vme", "off" },
-    { "Broadwell" "-" TYPE_X86_CPU, "vme", "off" },
-    { "Opteron_G1" "-" TYPE_X86_CPU, "vme", "off" },
-    { "Opteron_G2" "-" TYPE_X86_CPU, "vme", "off" },
-    { "Opteron_G3" "-" TYPE_X86_CPU, "vme", "off" },
-    { "Opteron_G4" "-" TYPE_X86_CPU, "vme", "off" },
-    { "Opteron_G5" "-" TYPE_X86_CPU, "vme", "off" },
-    { "Haswell" "-" TYPE_X86_CPU, "f16c", "off" },
-    { "Haswell" "-" TYPE_X86_CPU, "rdrand", "off" },
-    { "Broadwell" "-" TYPE_X86_CPU, "f16c", "off" },
-    { "Broadwell" "-" TYPE_X86_CPU, "rdrand", "off" },
-};
-const size_t pc_compat_2_2_len = G_N_ELEMENTS(pc_compat_2_2);
-
 GSIState *pc_gsi_create(qemu_irq **irqs, bool pci_enabled)
 {
     GSIState *s;
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index dcf50684a4..30bcd86ee6 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -429,11 +429,6 @@ static void pc_compat_2_3_fn(MachineState *machine)
     }
 }
 
-static void pc_compat_2_2_fn(MachineState *machine)
-{
-    pc_compat_2_3_fn(machine);
-}
-
 #ifdef CONFIG_ISAPC
 static void pc_init_isa(MachineState *machine)
 {
@@ -828,22 +823,6 @@ static void pc_i440fx_2_3_machine_options(MachineClass *m)
 DEFINE_I440FX_MACHINE(v2_3, "pc-i440fx-2.3", pc_compat_2_3_fn,
                       pc_i440fx_2_3_machine_options);
 
-static void pc_i440fx_2_2_machine_options(MachineClass *m)
-{
-    PCMachineClass *pcmc = PC_MACHINE_CLASS(m);
-
-    pc_i440fx_2_3_machine_options(m);
-    m->hw_version = "2.2.0";
-    m->default_machine_opts = "firmware=bios-256k.bin,suppress-vmdesc=on";
-    compat_props_add(m->compat_props, hw_compat_2_2, hw_compat_2_2_len);
-    compat_props_add(m->compat_props, pc_compat_2_2, pc_compat_2_2_len);
-    pcmc->rsdp_in_ram = false;
-    pcmc->resizable_acpi_blob = false;
-}
-
-DEFINE_I440FX_MACHINE(v2_2, "pc-i440fx-2.2", pc_compat_2_2_fn,
-                      pc_i440fx_2_2_machine_options);
-
 #ifdef CONFIG_ISAPC
 static void isapc_machine_options(MachineClass *m)
 {
-- 
2.41.0



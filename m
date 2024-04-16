Return-Path: <kvm+bounces-14869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D3B18A742E
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:03:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADC7A1C20FAA
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 721DB137921;
	Tue, 16 Apr 2024 19:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uKWueDmI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A619013957B
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 19:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294117; cv=none; b=bB9ZlLfO0BLFUAce9jye1OfdJRiQwOdvbxlpNho3cD5ygPKeQNfHEMUQbX9CieXoVHa1Cd4VEPcu/FsFwGG5pFqPfmBCLm/8wuPrKvuZyeD2SeFGsgmdGqIglwiSnbltxXqUv6SiAQMHjfoNnOojAPHymmnQSEi/HW8wbLanvWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294117; c=relaxed/simple;
	bh=g6xwt7Unl7tAQWrvicE+dEHhZzLjBWn566BsLPOMQXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PgTbveB+dGEeaN/+MVvdmHk2VMqTxpIR1KEcQhxDx0UWNFoycfZTyqrTdeFOD/EOsTPLKCyXxluC8T63z5ImREBHNEhBhf9zA6qWN8n58togLjkRIpKoMNizp5uDekn4HAsgdO/3ykLfqN3B2d1xeUv6VkNL68FVylGrjy1Bs1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uKWueDmI; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-56e69a51a33so4743992a12.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 12:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713294114; x=1713898914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yRDJ/6CeDpX+rBaqWai3BvHbA1Ey+M3PEP71cuI1QCM=;
        b=uKWueDmIwbLch1VdmZci++kS8GlvX8APyQIKdZQBdvqJhQt2RX0EvkSXX23V8EmO2P
         cRbgz1HAsNHxNi4Cb2fhxeEazmdyT9uQ+gV7rJq9Y/ThYr+Vdpe5ewBC++be/tp6uOFB
         EntCGtHMzlRptVGkRpGBx+A3Fs8oE7xhqRZx7Bp6DQvP/abcU5LAdXmfnhaRFHsq3oz/
         Q5Hp+3LsOY7gFEFw2wort6OBLWE459OMfN06sIFsVA6l4JNY299/ZVr8GG/6yYQ91/2N
         tZ+mEIzSCUOS3HeiBzm+at66D711scvC0WgnmwJP3H8FU5+RXVisVmH8GMviWaeBGHSw
         J6/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713294114; x=1713898914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yRDJ/6CeDpX+rBaqWai3BvHbA1Ey+M3PEP71cuI1QCM=;
        b=JBDWeqbYXkz7K67qvoOvLmwL9enKYKW/IsGXFfL8aZyS/CyePCyU67hTE8CfLdWnI3
         0Wi2gEB2IfLmfo5rgmKNpI8gkWvAIrCRZrTB83IM+8Cdi4selOOrFfDP1FRnXOtSofX5
         AxzeCvI0Q8E13DH+K3/AzknkYRP5dz3McKFXHVsiC+98D+mchfoM9LHR9jp4RC/BuI6U
         TSLC779lzjTy56bot9cU8kiHVBbrZG07Npx5OYAXcBT+TFqR+AUFyqZrd2RETJrz5mBR
         qeh7FsWqXTGBepkvzRzw1clQXwhy3A1BOe/D8yvaLPkljvsr+vC2v2rt5OZebqsygOrW
         gxOA==
X-Forwarded-Encrypted: i=1; AJvYcCWm8KlknuOvyz+Y6cCiiCE+3aPmCiLw75Pnn/5FKXQI/xMUdT6VLPccO+gbrizUTHrZTmvB8vNdVjUTgeEXEI2pIEO4
X-Gm-Message-State: AOJu0YxspJlVO5jUZW0Ks789x4T+39Jngdz0dEBsiVuNwiV12WXnJwm/
	oPoXZ9w6HqWncz6LiDKgbsKm1ySu4O1Vx6kckJCc0oKd3cUlNamgypQqiv/rqFI=
X-Google-Smtp-Source: AGHT+IGbN4pVpHOuCVs1vpZXoKir+5UlkDJfYGPm0F9gzxHmEpVmKVINj61gLzSY1JPoELa7vVkCfQ==
X-Received: by 2002:a50:8e5c:0:b0:56e:2a0a:c133 with SMTP id 28-20020a508e5c000000b0056e2a0ac133mr11019517edx.22.1713294113891;
        Tue, 16 Apr 2024 12:01:53 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.155.61])
        by smtp.gmail.com with ESMTPSA id z3-20020a056402274300b0056e3d80ca71sm6417110edd.35.2024.04.16.12.01.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Apr 2024 12:01:53 -0700 (PDT)
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
	devel@lists.libvirt.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: [PATCH v4 20/22] hw/i386/pc: Remove deprecated pc-i440fx-2.3 machine
Date: Tue, 16 Apr 2024 20:59:36 +0200
Message-ID: <20240416185939.37984-21-philmd@linaro.org>
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

The pc-i440fx-2.3 machine was deprecated for the 8.2
release (see commit c7437f0ddb "docs/about: Mark the
old pc-i440fx-2.0 - 2.3 machine types as deprecated"),
time to remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 docs/about/deprecated.rst       |  4 ++--
 docs/about/removed-features.rst |  2 +-
 hw/i386/pc.c                    | 25 -------------------------
 hw/i386/pc_piix.c               | 19 -------------------
 4 files changed, 3 insertions(+), 47 deletions(-)

diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
index 75bf0f4886..cb6ca372f2 100644
--- a/docs/about/deprecated.rst
+++ b/docs/about/deprecated.rst
@@ -219,8 +219,8 @@ deprecated; use the new name ``dtb-randomness`` instead. The new name
 better reflects the way this property affects all random data within
 the device tree blob, not just the ``kaslr-seed`` node.
 
-``pc-i440fx-2.3`` up to ``pc-i440fx-2.3`` (since 8.2) and ``pc-i440fx-2.4`` up to ``pc-i440fx-2.12`` (since 9.1)
-''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
+``pc-i440fx-2.4`` up to ``pc-i440fx-2.12`` (since 9.1)
+''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
 These old machine types are quite neglected nowadays and thus might have
 various pitfalls with regards to live migration. Use a newer machine type
diff --git a/docs/about/removed-features.rst b/docs/about/removed-features.rst
index 4664974a8b..0caa6a63e4 100644
--- a/docs/about/removed-features.rst
+++ b/docs/about/removed-features.rst
@@ -816,7 +816,7 @@ mips ``fulong2e`` machine alias (removed in 6.0)
 
 This machine has been renamed ``fuloong2e``.
 
-``pc-0.10`` up to ``pc-i440fx-2.2`` (removed in 4.0 up to 9.0)
+``pc-0.10`` up to ``pc-i440fx-2.3`` (removed in 4.0 up to 9.0)
 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
 These machine types were very old and likely could not be used for live
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index a1b0e94523..2e2146f42b 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -256,31 +256,6 @@ GlobalProperty pc_compat_2_4[] = {
 };
 const size_t pc_compat_2_4_len = G_N_ELEMENTS(pc_compat_2_4);
 
-GlobalProperty pc_compat_2_3[] = {
-    PC_CPU_MODEL_IDS("2.3.0")
-    { TYPE_X86_CPU, "arat", "off" },
-    { "qemu64" "-" TYPE_X86_CPU, "min-level", "4" },
-    { "kvm64" "-" TYPE_X86_CPU, "min-level", "5" },
-    { "pentium3" "-" TYPE_X86_CPU, "min-level", "2" },
-    { "n270" "-" TYPE_X86_CPU, "min-level", "5" },
-    { "Conroe" "-" TYPE_X86_CPU, "min-level", "4" },
-    { "Penryn" "-" TYPE_X86_CPU, "min-level", "4" },
-    { "Nehalem" "-" TYPE_X86_CPU, "min-level", "4" },
-    { "n270" "-" TYPE_X86_CPU, "min-xlevel", "0x8000000a" },
-    { "Penryn" "-" TYPE_X86_CPU, "min-xlevel", "0x8000000a" },
-    { "Conroe" "-" TYPE_X86_CPU, "min-xlevel", "0x8000000a" },
-    { "Nehalem" "-" TYPE_X86_CPU, "min-xlevel", "0x8000000a" },
-    { "Westmere" "-" TYPE_X86_CPU, "min-xlevel", "0x8000000a" },
-    { "SandyBridge" "-" TYPE_X86_CPU, "min-xlevel", "0x8000000a" },
-    { "IvyBridge" "-" TYPE_X86_CPU, "min-xlevel", "0x8000000a" },
-    { "Haswell" "-" TYPE_X86_CPU, "min-xlevel", "0x8000000a" },
-    { "Haswell-noTSX" "-" TYPE_X86_CPU, "min-xlevel", "0x8000000a" },
-    { "Broadwell" "-" TYPE_X86_CPU, "min-xlevel", "0x8000000a" },
-    { "Broadwell-noTSX" "-" TYPE_X86_CPU, "min-xlevel", "0x8000000a" },
-    { TYPE_X86_CPU, "kvm-no-smi-migration", "on" },
-};
-const size_t pc_compat_2_3_len = G_N_ELEMENTS(pc_compat_2_3);
-
 GSIState *pc_gsi_create(qemu_irq **irqs, bool pci_enabled)
 {
     GSIState *s;
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 30bcd86ee6..370d130a6d 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -421,14 +421,6 @@ static void pc_set_south_bridge(Object *obj, int value, Error **errp)
  * hw_compat_*, pc_compat_*, or * pc_*_machine_options().
  */
 
-static void pc_compat_2_3_fn(MachineState *machine)
-{
-    X86MachineState *x86ms = X86_MACHINE(machine);
-    if (kvm_enabled()) {
-        x86ms->smm = ON_OFF_AUTO_OFF;
-    }
-}
-
 #ifdef CONFIG_ISAPC
 static void pc_init_isa(MachineState *machine)
 {
@@ -812,17 +804,6 @@ static void pc_i440fx_2_4_machine_options(MachineClass *m)
 DEFINE_I440FX_MACHINE(v2_4, "pc-i440fx-2.4", NULL,
                       pc_i440fx_2_4_machine_options)
 
-static void pc_i440fx_2_3_machine_options(MachineClass *m)
-{
-    pc_i440fx_2_4_machine_options(m);
-    m->hw_version = "2.3.0";
-    compat_props_add(m->compat_props, hw_compat_2_3, hw_compat_2_3_len);
-    compat_props_add(m->compat_props, pc_compat_2_3, pc_compat_2_3_len);
-}
-
-DEFINE_I440FX_MACHINE(v2_3, "pc-i440fx-2.3", pc_compat_2_3_fn,
-                      pc_i440fx_2_3_machine_options);
-
 #ifdef CONFIG_ISAPC
 static void isapc_machine_options(MachineClass *m)
 {
-- 
2.41.0



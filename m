Return-Path: <kvm+bounces-11000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 767488720A2
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:44:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC858B255AD
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61C0C85C6F;
	Tue,  5 Mar 2024 13:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N+bUuwWl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2B05676A
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646261; cv=none; b=ZSIzRAzATUDgza4J4MJcxcQDO2r/1cBFJCgWBESh/u//AweScDCzED0VTfD/0VLuRUpzbky9hPrndA0B7R4wx4PN0eD1RBaT/DeXwn/nvnCcLMILOy4pS/b9rEj9ZAkskOwBLhJtc818u+zeY05A7mYBE6Xyk8GCyBJr7x+cMtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646261; c=relaxed/simple;
	bh=nwgszOo5CilW5a91vASft5P32iGwwle9WKL+y3DAjWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hHNnJX0lWlp3cYKmHu4oOksVFizHh8bQs78xTHR8mqdOqwFstrEnAW0HjLpRby00B0UIBn43BvuFzsvoxZw3oq1JGxs3G78TtSwtaX4x/uCk0xSGCxg5+vS4ZR8Y+Fyq7p9qnBagbtaoo6VDWqLSUhlETJvB5MmJXc1syrwRV9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=N+bUuwWl; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-33e122c8598so3443484f8f.1
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646258; x=1710251058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ijGEHV3qc1F3JPlNft0UaVVASq790sFq2U8890KClw=;
        b=N+bUuwWlt5mSUEtMtgqN0RCDsSvfb73h9C5xF4KouVll1VBz47yZqf6DEWq16eIP3I
         JkXSEXeM12tQTmBuViInM2UNiug4bU5syJFbdsY8DT+nmJFOEgBhTp42pBoVNXpis8ej
         ETjoyafyB8oJ3AEWxU2J2SEz+1OW31immDTSIyLG0jp8+rki8rP6iccUF/RxgAKqn7LT
         90MBnFfSSzkQz+J9+caj/II8EDhcxzxUwhvYyy7xz3Kd6FVWQI0e7mB7WYcKRe/Rhgiy
         s/TpEvlRvAV7KyeiIPx1Ldk7BgLMZon2VnJlHUDWDBs9D+U2xBEgJTtDWkxWGJnkbrj/
         dNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646258; x=1710251058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ijGEHV3qc1F3JPlNft0UaVVASq790sFq2U8890KClw=;
        b=KKfhl+del8pjw4JbT/BpHnVHVcZyOH9HgDS/CPwhijHrzfh9ujfiJUYpPnPZMYufEQ
         amdSYrLB3xFTGSE9DIupJqyLUhVtoaZcS+ZwbkQ6xmg/cFxAen7xrQ7DnGa069uox4fq
         br3ItSHxK8l0bOU8HvIBs5/lsXKgTRrJfvan42B9ji8CELgcKA6C2fjBq7IsdF/sceuD
         hbJSRWB7cSBSkP5mMfwSGRdWc+DUGFhZQY3Ii/NYFyNg06MDrHOfwEYBxR5wLdJ0xt58
         K/cnfguezW9R2ULj3iijoeQOiQ/2+z8pyhRFE33E9Gt3m62ho7B/76Ewl9RB61mo2gFK
         cB3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUv82JIAGuxGRpxjSz3Ut5EDTuymfqQ9imRi/hpKApGA1ZHI4/nuQngWqF1El0bQr2HCaE4litu0aaVuyFgoE2puDwN
X-Gm-Message-State: AOJu0YyEgapvnGChEAeHVm8/Y0cV9avkBs1zuoclRii47U+k2G/fdXpk
	mN9mAB9BzI+mC1LuyH0PmEpeikNplM4KLT0VsQuIChPKX2LsRr6uVK/RK74BL4I=
X-Google-Smtp-Source: AGHT+IHZi/JMf/B738CVhWG7eDChuF+p775TwNNz0xLGRtYqph+j97xXKvLHDPTy5WjIdMBezCAIAw==
X-Received: by 2002:adf:f103:0:b0:33e:1c83:6a97 with SMTP id r3-20020adff103000000b0033e1c836a97mr8891742wro.13.1709646258044;
        Tue, 05 Mar 2024 05:44:18 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id p15-20020a05600c468f00b00412b0e51ef9sm18116631wmo.31.2024.03.05.05.44.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:44:17 -0800 (PST)
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
Subject: [PATCH-for-9.1 16/18] hw/i386/pc: Remove deprecated pc-i440fx-2.3 machine
Date: Tue,  5 Mar 2024 14:42:18 +0100
Message-ID: <20240305134221.30924-17-philmd@linaro.org>
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

The pc-i440fx-2.3 machine was deprecated for the 8.2
release (see commit c7437f0ddb "docs/about: Mark the
old pc-i440fx-2.0 - 2.3 machine types as deprecated"),
time to remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 docs/about/deprecated.rst       |  7 -------
 docs/about/removed-features.rst |  2 +-
 hw/i386/pc.c                    | 25 -------------------------
 hw/i386/pc_piix.c               | 20 --------------------
 4 files changed, 1 insertion(+), 53 deletions(-)

diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
index 84c82d85e1..78be35e42a 100644
--- a/docs/about/deprecated.rst
+++ b/docs/about/deprecated.rst
@@ -221,13 +221,6 @@ deprecated; use the new name ``dtb-randomness`` instead. The new name
 better reflects the way this property affects all random data within
 the device tree blob, not just the ``kaslr-seed`` node.
 
-``pc-i440fx-2.3`` (since 8.2)
-'''''''''''''''''''''''''''''
-
-This old machine type is quite neglected nowadays and thus might have
-various pitfalls with regards to live migration. Use a newer machine type
-instead.
-
 Nios II ``10m50-ghrd`` and ``nios2-generic-nommu`` machines (since 8.2)
 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
diff --git a/docs/about/removed-features.rst b/docs/about/removed-features.rst
index c2ec08f56c..533d4669d2 100644
--- a/docs/about/removed-features.rst
+++ b/docs/about/removed-features.rst
@@ -801,7 +801,7 @@ mips ``fulong2e`` machine alias (removed in 6.0)
 
 This machine has been renamed ``fuloong2e``.
 
-``pc-0.10`` up to ``pc-i440fx-2.2`` (removed in 4.0 up to 9.0)
+``pc-0.10`` up to ``pc-i440fx-2.3`` (removed in 4.0 up to 9.0)
 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
 These machine types were very old and likely could not be used for live
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 7f41895d97..4b9f4c5c2c 100644
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
index e5a2182211..2e056036de 100644
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
@@ -807,18 +799,6 @@ static void pc_i440fx_2_4_machine_options(MachineClass *m)
 DEFINE_I440FX_MACHINE(v2_4, "pc-i440fx-2.4", NULL,
                       pc_i440fx_2_4_machine_options)
 
-static void pc_i440fx_2_3_machine_options(MachineClass *m)
-{
-    pc_i440fx_2_4_machine_options(m);
-    m->hw_version = "2.3.0";
-    m->deprecation_reason = "old and unattended - use a newer version instead";
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



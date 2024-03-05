Return-Path: <kvm+bounces-10996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 32F0687209C
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:44:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 975FDB28B20
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF9185C6F;
	Tue,  5 Mar 2024 13:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nP6zGUSP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1135676A
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646233; cv=none; b=Iedly4ByQmSg00BxFyEmrwCp2guW8QPseWcbpe0PZQoUfNJE2qaQzCvYlbiX+6BH0Y3U5Knbazn2WueLx08pV2a6YOy2w3G02VwdJ3nRzl+Q6VqRizrlmC4UAgnJbPsP2wd8a86qSaSo8gwfrV+zKLDjNGF6l5DAckvSdK0MZfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646233; c=relaxed/simple;
	bh=hkGnY31yWWOP5AalDQ1bPnCtVpifnL1G6I9gvqvuJKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PkGrnrftlrrR0aIdHlUmRtMSmC4v6kQkWxVLlNKBWA99JxxFeTpAQh7Gb9nXtgbcHlsRdxtr0GrHPg8vBtQYCO4moQ6dYeQUyIoBv50QWD+oeI8XiMLwKcuCe6WSW+Vsl1nZh48WNDGBSo015MEuIUOUd9HPow31Bwa76dhEe9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nP6zGUSP; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2d288bac3caso70152431fa.2
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646230; x=1710251030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=crLnBPuyRmvWsoYI1VEnIHyayJ9tujHUtxXmAXPz7S0=;
        b=nP6zGUSPyVRGpLCddpVadronil15wHgFeyQ84LHgwApj2HoO5USzvdQsmxePTp58x8
         yqVF0yO1plvDWOpKwO6xzTwMpoXe0hmpU8XG2pUOvy4mAyXyh4KtI/Edhze5OZhJVWsm
         AgevgBWsORaA8jk07EG7mpgXuD/B+AFGTW2jbksqmeLpx1FizSRK50WrtrnJZrDmUTLq
         TcebgGnz8E2PLiN0yNAHKPJmznJbRii3BsOcROIAgmYY84y/CcekWwEQJgbTDDcbuvdO
         9bvsSP3xmk64UdJhLZhgDWg1APCHrp09te/5QIJxEYE5IAKQK16BqFUa0oWsTI2KIbuB
         QuLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646230; x=1710251030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=crLnBPuyRmvWsoYI1VEnIHyayJ9tujHUtxXmAXPz7S0=;
        b=jAwnijQeqaMoprjdK2B6Nl+BaE6CGQQRoSz80ee7GPnY0l80UrLQSodQ9Ka3bNEvy9
         wf4i8NOxyBILOeZHS1ivP8HavqhbAFBtS60XtdgAs4QrZzBqTBniuGq0FMMPu7+SBX1c
         JfL20vPJVcFVqw04K+5AvpUd1NQgWRUOKcwcBRZB3pxHAPkDVcWB0GnPKFV6q3+VB+uV
         M/hCiX1BZShSR9nhWzYv0/dgJRCvhpEmf0MyJlj6ovVxb7in/009ojJXSTBn/tXUSPCO
         ky9IHoBOxF+RvZ18RJm1zd9nstU4U1FHW9W+TrGEGZ4nyhHP5+1TJTC90foJCFCFcEJJ
         /hMw==
X-Forwarded-Encrypted: i=1; AJvYcCXPUjXW8wJ2WZrNW9zb0eCiowKtrIEiskLDh0fK39kNHT9L1ODMSDrmeYuqFnzPaX8UERzKztnBzdZ3lP8xuqi0pbEu
X-Gm-Message-State: AOJu0YyUKOi/MRSogdaJ2E4a5SJ1NN2ybx3V2xgGgWr6xRMHDKtX3+E/
	eWaeBXqm9VtQajVxknTdsmI98TcL6/K+yJ4TxhenBK9MoGizpfPm9qcvE5bktM8=
X-Google-Smtp-Source: AGHT+IGFXNMkQQ5YVY8UgcokF2PhotSsOKNiPHMYVo14782EEjGRnY/YAP3IVXaa0oSUfvc5RQL3mg==
X-Received: by 2002:a2e:b0e5:0:b0:2d3:ba52:f878 with SMTP id h5-20020a2eb0e5000000b002d3ba52f878mr1364796ljl.0.1709646229749;
        Tue, 05 Mar 2024 05:43:49 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id k40-20020a05600c1ca800b00412b643b5a3sm17863110wms.11.2024.03.05.05.43.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:43:49 -0800 (PST)
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
Subject: [PATCH-for-9.1 12/18] hw/i386/pc: Remove deprecated pc-i440fx-2.2 machine
Date: Tue,  5 Mar 2024 14:42:14 +0100
Message-ID: <20240305134221.30924-13-philmd@linaro.org>
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

The pc-i440fx-2.2 machine was deprecated for the 8.2
release (see commit c7437f0ddb "docs/about: Mark the
old pc-i440fx-2.0 - 2.3 machine types as deprecated"),
time to remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 docs/about/deprecated.rst       |  6 +++---
 docs/about/removed-features.rst |  2 +-
 include/hw/i386/pc.h            |  3 ---
 hw/i386/pc.c                    | 23 -----------------------
 hw/i386/pc_piix.c               | 21 ---------------------
 5 files changed, 4 insertions(+), 51 deletions(-)

diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
index c68b17df23..84c82d85e1 100644
--- a/docs/about/deprecated.rst
+++ b/docs/about/deprecated.rst
@@ -221,10 +221,10 @@ deprecated; use the new name ``dtb-randomness`` instead. The new name
 better reflects the way this property affects all random data within
 the device tree blob, not just the ``kaslr-seed`` node.
 
-``pc-i440fx-2.2`` up to ``pc-i440fx-2.3`` (since 8.2)
-'''''''''''''''''''''''''''''''''''''''''''''''''''''
+``pc-i440fx-2.3`` (since 8.2)
+'''''''''''''''''''''''''''''
 
-These old machine types are quite neglected nowadays and thus might have
+This old machine type is quite neglected nowadays and thus might have
 various pitfalls with regards to live migration. Use a newer machine type
 instead.
 
diff --git a/docs/about/removed-features.rst b/docs/about/removed-features.rst
index d01b0afbef..c2ec08f56c 100644
--- a/docs/about/removed-features.rst
+++ b/docs/about/removed-features.rst
@@ -801,7 +801,7 @@ mips ``fulong2e`` machine alias (removed in 6.0)
 
 This machine has been renamed ``fuloong2e``.
 
-``pc-0.10`` up to ``pc-i440fx-2.1`` (removed in 4.0 up to 9.0)
+``pc-0.10`` up to ``pc-i440fx-2.2`` (removed in 4.0 up to 9.0)
 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
 These machine types were very old and likely could not be used for live
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index bf1d6e99b4..f7a5f4f283 100644
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
index ea7b05797b..a762df7686 100644
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
index 88457de0f8..e5a2182211 100644
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
@@ -824,22 +819,6 @@ static void pc_i440fx_2_3_machine_options(MachineClass *m)
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



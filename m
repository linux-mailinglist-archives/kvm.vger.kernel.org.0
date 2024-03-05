Return-Path: <kvm+bounces-10990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 715EE872091
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:43:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 017F5288CC0
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42BA48613C;
	Tue,  5 Mar 2024 13:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j7TAC6XO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B4186126
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646189; cv=none; b=rw5JVN3bPvzELECMQaFeTb/QeBB6wdo9NATLwSMt4bBD/eb445pnZq1hGq+1H7dwdToXSRTWmymz9B+ibocGDhFHid3wREk04kvFbEXf+jLby2UobkmoKsry2yZ9sHmDIGuz58I1srqEohMPiZENy52sTf9BqL0LoXWXpQGjyOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646189; c=relaxed/simple;
	bh=GNSSRndJCpU/HMACy39lWc79Zr8+mPLGjEktUi3MkcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GJt/N9+4U5MkSUlbt+Z9kTnumRZCAg5unyOrDFtZ/eyb1dELvzMySbEdHyMoGcHWowLnQ0PbhOj34rxHF873oegsva8UJUZnmi5eccj7nJy/sS+l6ZFZF0KBhG4uV3v/uFN9cmEJYROxz3iBx/gB26069x+9eoM45VuiIvIwocE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=j7TAC6XO; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5658082d2c4so7796370a12.1
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646186; x=1710250986; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qNCIUOXAP5nkn1WP2t/PEPvMd4mRhcnbtnDDAPAoHAk=;
        b=j7TAC6XOJWgDCZ2p/6p9l89eSu3pf13/yWIpVPwJ/D8K4TdYWrZJzsHhzL6miKNWi5
         IEIM+yuFA5IowKc7h4fRNeala1ytASYFrpCYjQcUz7OivDEBr+gLmji3TGyH6ryKTh0r
         9lA2YKm33LAPZq2HHkaXDdaSC9xFEf2MUyi6cPwkOiAmv3tWcukfZhcrz5jERJQObt7C
         UWTZqESgycefJWgpktSE27pwjFrX5NmtzkA3rNBWHeJpJbPDyOp+YEOOoxfk2C8n2UdZ
         Z4pVEk5fxOrixqmnXwJNaTCBwqsQ8LFMv54KA3GtZzw9NnPo5lr3FLibKOeDdVLFv5as
         7VKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646186; x=1710250986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qNCIUOXAP5nkn1WP2t/PEPvMd4mRhcnbtnDDAPAoHAk=;
        b=Glk7MQRNGHf7I2O8mvP0gevJsB+PQXetZ1ZmTkb/ibBsO3pzPOl33b0Qjcvhll2xXl
         SzMXiOnMYO8Iq8an3y+1MSY6icbd9dqebT/Q3uAXSO7ZoOmhaCO4gMmhAPIMUs+4GSZi
         cPh+K0grkJqfnPTCDC8vgWgZB8ZwCQicgevmjeWN654BhjMbZFAHgx+NbBkFzqt2JKtB
         UU7v8hob9+jCkkAvPw+uU8jbd1gDN9GZKFDVU/MWoOwm0P4IV1nE2O7zlpC9UdIJu0zz
         tFGJeZyXcmHOlM6XBh22yyvWv5Aw0+1/01Yc0bTxcpWhtQQPYZPD3rpxsFTwXcDQSqF2
         o3rw==
X-Forwarded-Encrypted: i=1; AJvYcCUWNIdqrXTgioA7ds49umiipMD8EmYLWIu3rMbIhZgr9T4ciFhXNxQSLELf24shvahVSFeIUvTvACAKaYYtlPs2biNU
X-Gm-Message-State: AOJu0Yyq50LoHP//TozYUMzZVb8rt1qkIkBUTRqaLHqz0ZnhfxpGSuZK
	m/kKVFPLFASoyKW+RnwwYRqQk2vnplFZnMOmxSZHctC79brLNy7u4Nx2e3cU4Bg=
X-Google-Smtp-Source: AGHT+IFf8ZGZhDfjYAXFDPsxT7EZZWXpGFpXOeFd4BwtvveykEU8Vst9MseHS8RugHUgHLPbLYodgA==
X-Received: by 2002:a17:906:270d:b0:a45:ab75:7628 with SMTP id z13-20020a170906270d00b00a45ab757628mr1214935ejc.52.1709646186033;
        Tue, 05 Mar 2024 05:43:06 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id lh24-20020a170906f8d800b00a45b1ce5046sm946ejb.155.2024.03.05.05.43.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:43:05 -0800 (PST)
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
Subject: [PATCH-for-9.1 06/18] hw/i386/pc: Remove deprecated pc-i440fx-2.1 machine
Date: Tue,  5 Mar 2024 14:42:08 +0100
Message-ID: <20240305134221.30924-7-philmd@linaro.org>
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

The pc-i440fx-2.1 machine was deprecated for the 8.2
release (see commit c7437f0ddb "docs/about: Mark the
old pc-i440fx-2.0 - 2.3 machine types as deprecated"),
time to remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 docs/about/deprecated.rst       |  2 +-
 docs/about/removed-features.rst |  2 +-
 include/hw/i386/pc.h            |  3 ---
 hw/i386/pc.c                    |  7 -------
 hw/i386/pc_piix.c               | 23 -----------------------
 5 files changed, 2 insertions(+), 35 deletions(-)

diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
index 6d4738ca20..c68b17df23 100644
--- a/docs/about/deprecated.rst
+++ b/docs/about/deprecated.rst
@@ -221,7 +221,7 @@ deprecated; use the new name ``dtb-randomness`` instead. The new name
 better reflects the way this property affects all random data within
 the device tree blob, not just the ``kaslr-seed`` node.
 
-``pc-i440fx-2.1`` up to ``pc-i440fx-2.3`` (since 8.2)
+``pc-i440fx-2.2`` up to ``pc-i440fx-2.3`` (since 8.2)
 '''''''''''''''''''''''''''''''''''''''''''''''''''''
 
 These old machine types are quite neglected nowadays and thus might have
diff --git a/docs/about/removed-features.rst b/docs/about/removed-features.rst
index 156737989e..d01b0afbef 100644
--- a/docs/about/removed-features.rst
+++ b/docs/about/removed-features.rst
@@ -801,7 +801,7 @@ mips ``fulong2e`` machine alias (removed in 6.0)
 
 This machine has been renamed ``fuloong2e``.
 
-``pc-0.10`` up to ``pc-i440fx-2.0`` (removed in 4.0 up to 9.0)
+``pc-0.10`` up to ``pc-i440fx-2.1`` (removed in 4.0 up to 9.0)
 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
 These machine types were very old and likely could not be used for live
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 758d670a36..f77639d94f 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -281,9 +281,6 @@ extern const size_t pc_compat_2_3_len;
 extern GlobalProperty pc_compat_2_2[];
 extern const size_t pc_compat_2_2_len;
 
-extern GlobalProperty pc_compat_2_1[];
-extern const size_t pc_compat_2_1_len;
-
 #define DEFINE_PC_MACHINE(suffix, namestr, initfn, optsfn) \
     static void pc_machine_##suffix##_class_init(ObjectClass *oc, void *data) \
     { \
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index bb7ef31af2..d417cf106c 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -304,13 +304,6 @@ GlobalProperty pc_compat_2_2[] = {
 };
 const size_t pc_compat_2_2_len = G_N_ELEMENTS(pc_compat_2_2);
 
-GlobalProperty pc_compat_2_1[] = {
-    PC_CPU_MODEL_IDS("2.1.0")
-    { "coreduo" "-" TYPE_X86_CPU, "vmx", "on" },
-    { "core2duo" "-" TYPE_X86_CPU, "vmx", "on" },
-};
-const size_t pc_compat_2_1_len = G_N_ELEMENTS(pc_compat_2_1);
-
 GSIState *pc_gsi_create(qemu_irq **irqs, bool pci_enabled)
 {
     GSIState *s;
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 594b131625..88457de0f8 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -65,7 +65,6 @@
 #include "hw/hyperv/vmbus-bridge.h"
 #include "hw/mem/nvdimm.h"
 #include "hw/i386/acpi-build.h"
-#include "kvm/kvm-cpu.h"
 #include "target/i386/cpu.h"
 
 #define XEN_IOAPIC_NUM_PIRQS 128ULL
@@ -435,12 +434,6 @@ static void pc_compat_2_2_fn(MachineState *machine)
     pc_compat_2_3_fn(machine);
 }
 
-static void pc_compat_2_1_fn(MachineState *machine)
-{
-    pc_compat_2_2_fn(machine);
-    x86_cpu_change_kvm_default("svm", NULL);
-}
-
 #ifdef CONFIG_ISAPC
 static void pc_init_isa(MachineState *machine)
 {
@@ -847,22 +840,6 @@ static void pc_i440fx_2_2_machine_options(MachineClass *m)
 DEFINE_I440FX_MACHINE(v2_2, "pc-i440fx-2.2", pc_compat_2_2_fn,
                       pc_i440fx_2_2_machine_options);
 
-static void pc_i440fx_2_1_machine_options(MachineClass *m)
-{
-    PCMachineClass *pcmc = PC_MACHINE_CLASS(m);
-
-    pc_i440fx_2_2_machine_options(m);
-    m->hw_version = "2.1.0";
-    m->default_display = NULL;
-    compat_props_add(m->compat_props, hw_compat_2_1, hw_compat_2_1_len);
-    compat_props_add(m->compat_props, pc_compat_2_1, pc_compat_2_1_len);
-    pcmc->smbios_uuid_encoded = false;
-    pcmc->enforce_aligned_dimm = false;
-}
-
-DEFINE_I440FX_MACHINE(v2_1, "pc-i440fx-2.1", pc_compat_2_1_fn,
-                      pc_i440fx_2_1_machine_options);
-
 #ifdef CONFIG_ISAPC
 static void isapc_machine_options(MachineClass *m)
 {
-- 
2.41.0



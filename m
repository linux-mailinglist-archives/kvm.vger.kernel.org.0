Return-Path: <kvm+bounces-14856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B5FB8A740C
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5AA91F2285E
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEEFF137C2E;
	Tue, 16 Apr 2024 19:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="baSO85H3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74A8137916
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 19:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294039; cv=none; b=jBJAqE64DV0kwdZ0jCXNRLxJ3tYBMeEUGIuP8lM/BQb5XZJ4TMnBGqlo0/Mo6Dkad/VNoz41KJ8wvQuHuyKWpmdwmUbqEp/PI4I6LWOJ/MRuLW0sEO8fMYMsyCR9DAAiACkcpDE74qdidTFDouOa1mRPmvXD93alto+xaZOTeAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294039; c=relaxed/simple;
	bh=bB39rOTaKMmBtbm2Su3lf5ak9SotLOPlSmxBENLNoZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s9rIWgGx0Iz6mcjGdhxkhsoQXVlLsSuQQbsLoQw5JVj1w/6Y8c0eQeXjSIIeFdkjAvYQjBIbUuF7xRKAJS4C62arx4vlGzpg0ZDaw/RO4ok2UYeZraZQr2x8DS3aGq5WD4KZYW7eJeiVcbo8uFS5Q3D071VofipiO+J7njMAFKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=baSO85H3; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-57009454c83so4243326a12.2
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 12:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713294029; x=1713898829; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aDu2aZ9r50YKxf+dNaxDqKUjAn6DYpDYAzbmilk8iWY=;
        b=baSO85H3dds7HXZ/fs/w+Sr7js98gPHMIKq64eaAVtpfEHwbGBxmP+lUedkJAyXou2
         mQFYbu4KjTKx1TzTGKfgoMlHtlv6ypxSWnvAgnRRcyDJz6ekHbkSbf7enXm6QVR08h7L
         Otu3sTdEjnr67gEdynUOhK56uHqk1iImdQguk4EamghZlOGlkKPFXuNp7FcRoGdlbi3J
         qsmtFUWkSR8m3Kr/FnRoG5LjpORYbeO5zV79RpSYF3G1nVX1ZdZqKGrK7CBB/HVKC+lV
         VozA1DfvqcOWwdMYkObCrR6Anyj/++zwT/xiEaIDPh2lJ1byCWmSzR2Q4OWMJV7rg8u4
         gzYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713294029; x=1713898829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aDu2aZ9r50YKxf+dNaxDqKUjAn6DYpDYAzbmilk8iWY=;
        b=Ksqz7WJq0rejbEn2thAlxX9sU6LHvA0QRcvEq07zvNwvEZqanRL1M6taxmD21Dn7kK
         main1K4yXYA7JnG/vbIx/mWRtqoZzNw4eK9XQv1ZCpQpg/tfBu+oWkjFo++P8mfDNqSg
         ySY3QctroN7IoFtQp498tFJffQp9dguP4Xl8gGHm+l7opStaMbT8b+CF0lwPd11FWmkA
         7REzKjagF1MqstWtpV3PPSwjyEszX9fDwZA9ptAYtT+gRVd+ukaspRabXoXvADfJNCm+
         YlTqAA+1U6Ezhp/yhpaE467Vw0IPrs51/iQImAczpdKUlZHMSKOnQK0wyDQ0cnqDol6a
         jGxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVq+5Gs0gM0Brql6Fq5SNzG87No1ZQM5e9hk2Zz4kVOqXNQ8qrQozBHne4D7YvxhSG0Z73KHAcNxQ/vHfL5yvaJhy0r
X-Gm-Message-State: AOJu0YyHc3TGGvkC7TB6JLAQVahmfOD3yGHF6Pe9h/RNFKKrrgP7qWuy
	AL38PzdGFmmZu7kll1GBI0BuWUN86bu10TBRA0KsKawRnN6iloXCK/SXlO8yb6Q=
X-Google-Smtp-Source: AGHT+IEc0M7W+KyDB0aQ8QUm+zC7hkHWbLtW7gtPPIqf8ccsUyI98Px0KPtH3uOffjFEYOIbTwSX0w==
X-Received: by 2002:a17:907:1b1d:b0:a52:2b39:879b with SMTP id mp29-20020a1709071b1d00b00a522b39879bmr10404824ejc.46.1713294029119;
        Tue, 16 Apr 2024 12:00:29 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.155.61])
        by smtp.gmail.com with ESMTPSA id em3-20020a170907288300b00a5180d5b31asm7161409ejc.32.2024.04.16.12.00.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Apr 2024 12:00:28 -0700 (PDT)
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
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Ani Sinha <anisinha@redhat.com>
Subject: [PATCH v4 07/22] hw/acpi/ich9: Remove dead code related to 'acpi_memory_hotplug'
Date: Tue, 16 Apr 2024 20:59:23 +0200
Message-ID: <20240416185939.37984-8-philmd@linaro.org>
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

acpi_memory_hotplug::is_enabled is set to %true once via
ich9_lpc_initfn() -> ich9_pm_add_properties(). No need to
check it, so remove now dead code.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/acpi/ich9.c | 28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/hw/acpi/ich9.c b/hw/acpi/ich9.c
index 9b605af21a..02d8546bd3 100644
--- a/hw/acpi/ich9.c
+++ b/hw/acpi/ich9.c
@@ -153,17 +153,10 @@ static int ich9_pm_post_load(void *opaque, int version_id)
      .offset     = vmstate_offset_pointer(_state, _field, uint8_t),  \
  }
 
-static bool vmstate_test_use_memhp(void *opaque)
-{
-    ICH9LPCPMRegs *s = opaque;
-    return s->acpi_memory_hotplug.is_enabled;
-}
-
 static const VMStateDescription vmstate_memhp_state = {
     .name = "ich9_pm/memhp",
     .version_id = 1,
     .minimum_version_id = 1,
-    .needed = vmstate_test_use_memhp,
     .fields = (const VMStateField[]) {
         VMSTATE_MEMORY_HOTPLUG(acpi_memory_hotplug, ICH9LPCPMRegs),
         VMSTATE_END_OF_LIST()
@@ -335,11 +328,9 @@ void ich9_pm_init(PCIDevice *lpc_pci, ICH9LPCPMRegs *pm, qemu_irq sci_irq)
     legacy_acpi_cpu_hotplug_init(pci_address_space_io(lpc_pci),
         OBJECT(lpc_pci), &pm->gpe_cpu, ICH9_CPU_HOTPLUG_IO_BASE);
 
-    if (pm->acpi_memory_hotplug.is_enabled) {
-        acpi_memory_hotplug_init(pci_address_space_io(lpc_pci), OBJECT(lpc_pci),
-                                 &pm->acpi_memory_hotplug,
-                                 ACPI_MEMORY_HOTPLUG_BASE);
-    }
+    acpi_memory_hotplug_init(pci_address_space_io(lpc_pci), OBJECT(lpc_pci),
+                             &pm->acpi_memory_hotplug,
+                             ACPI_MEMORY_HOTPLUG_BASE);
 }
 
 static void ich9_pm_get_gpe0_blk(Object *obj, Visitor *v, const char *name,
@@ -460,12 +451,7 @@ void ich9_pm_device_pre_plug_cb(HotplugHandler *hotplug_dev, DeviceState *dev,
         return;
     }
 
-    if (object_dynamic_cast(OBJECT(dev), TYPE_PC_DIMM) &&
-        !lpc->pm.acpi_memory_hotplug.is_enabled) {
-        error_setg(errp,
-                   "memory hotplug is not enabled: %s.memory-hotplug-support "
-                   "is not set", object_get_typename(OBJECT(lpc)));
-    } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
+    if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
         uint64_t negotiated = lpc->smi_negotiated_features;
 
         if (negotiated & BIT_ULL(ICH9_LPC_SMI_F_BROADCAST_BIT) &&
@@ -509,8 +495,7 @@ void ich9_pm_device_unplug_request_cb(HotplugHandler *hotplug_dev,
 {
     ICH9LPCState *lpc = ICH9_LPC_DEVICE(hotplug_dev);
 
-    if (lpc->pm.acpi_memory_hotplug.is_enabled &&
-        object_dynamic_cast(OBJECT(dev), TYPE_PC_DIMM)) {
+    if (object_dynamic_cast(OBJECT(dev), TYPE_PC_DIMM)) {
         acpi_memory_unplug_request_cb(hotplug_dev,
                                       &lpc->pm.acpi_memory_hotplug, dev,
                                       errp);
@@ -545,8 +530,7 @@ void ich9_pm_device_unplug_cb(HotplugHandler *hotplug_dev, DeviceState *dev,
 {
     ICH9LPCState *lpc = ICH9_LPC_DEVICE(hotplug_dev);
 
-    if (lpc->pm.acpi_memory_hotplug.is_enabled &&
-        object_dynamic_cast(OBJECT(dev), TYPE_PC_DIMM)) {
+    if (object_dynamic_cast(OBJECT(dev), TYPE_PC_DIMM)) {
         acpi_memory_unplug_cb(&lpc->pm.acpi_memory_hotplug, dev, errp);
     } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU) &&
                !lpc->pm.cpu_hotplug_legacy) {
-- 
2.41.0



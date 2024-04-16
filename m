Return-Path: <kvm+bounces-14855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 128DC8A740B
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0165282AE3
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FEED13791E;
	Tue, 16 Apr 2024 19:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cHdz9AQO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4379213791B
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 19:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294038; cv=none; b=X5OZ2URc6ERpf3sikMCIYhPgfzTuC2/13FlLJ/oz9ahSRAPod3mwc0O3HfHEqDzMdkB8uYwlVjiKJmJHDcChA2lsRrt4N2izzdJFaUx+h6GliyjmZX6uvsiMa+Dph1fg7A3YAjdzHKIkg3nlayMIWqeqFzInUiT6vMIIjYDfGJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294038; c=relaxed/simple;
	bh=XArO7gBRA8/Ay1iZUJuYJWGokF4fTEXW8HFgkerMQVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jb6VvtMQZa3X/vIWiCQ6OzZpUZKQ02zBtQkF0u8tCZlkHjK2J54+1owv6mmSHS5QJYDkNFuOO3VmtnymECC7m41OrsXIIVerUHs4G3BICY273bnkJ+PRuILPUtkMO6ozwILKDnhwgXH76puyrEWITdSr3MOqqNJO/bUPXoSiLbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cHdz9AQO; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a46ea03c2a5so12142166b.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 12:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713294022; x=1713898822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cesSegXMr71Lpaal5FJBOqynS/3X0jmvbPzoIKbt5l0=;
        b=cHdz9AQOfPLAgvq6AAVhIjTrdV5XLgpAeDcc+0jqvztyQmuHK9oGLecCUSib86Xij2
         +cTPf66JOIdpAlPKTk8bwP6V0ESatrvZYszdVBFfQyYOxWFq5ca3vLHNjIxwGZ+1Rnlw
         +9ekpwv6IBITl031IDXvE92nbO64WYoQQrmuamuQFXCnu5nb76cXx4ZpUdgJFVXNN/8D
         EAtCSKvKV0+gs/tZAjzjkiGaopZ8hEvchr3HQ/fO6L8QMoO4bKWM2UZ2iJsxD1YrI0gp
         oTlBf205NojJKPWPpwMx4kSpZPdV2NnupAfAbpDkZpEWy9l/GRWICEropSBw8WVo/S2K
         EaeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713294022; x=1713898822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cesSegXMr71Lpaal5FJBOqynS/3X0jmvbPzoIKbt5l0=;
        b=lGwCgDx7Tf4J61kX2OREWJRKgAin9E0LxH2DMKAmb4kqVYawqO+aiJcFFw//meXcIB
         r8BOKL5aB5YVIliR10uP6EbAFhhW+RJ4JAch+WA8IZuMkq/kSkLZmiu/UB8v5tVQhB8e
         2qRkhTDXvcmbSGC2j4IoYS/XzR4qZmuqrRGp+6Um5S4MEvOa84qjZXXWwltSLkNSiNET
         2jDULaNHYPf5PPWaYVWDGSLIMB2M/9mzeshM0GRBbvhPPfgvV1DnxY7b8olYIu4yFcjp
         gjqWA40phzZ4cp88qUj8ER7lNbyVGkBoGRpFz2Fv6bNs52R9CqgnuRE0ZaRXl4tuhmF9
         Gkgw==
X-Forwarded-Encrypted: i=1; AJvYcCX+73Dng2N4hJeWIWtofPQfDohBbCjrpwYJ5jTh92jANnPIxK/QRkz6mAWl45ylYrZB8ajNP46I/ulmwpRYpwqQFeH5
X-Gm-Message-State: AOJu0YylfWbAE0xjX/NcA891zcsfERHKXro7xDyE3Am3PtZbmsH4kNpz
	GiAEcnqlEBLHgAqHApuYN9NIUA9oxItop/R4BlHc+oBGimbmVlRN4EkxuZv/Tlk=
X-Google-Smtp-Source: AGHT+IH5BOnyXnn72Ltuk21ppetjbOqt3E7UuzCKXeGkk/xw3+Vi5Lw88kwgqxO3CIw5JIxDda7Syw==
X-Received: by 2002:a17:906:cec8:b0:a51:ee80:bae9 with SMTP id si8-20020a170906cec800b00a51ee80bae9mr3007893ejb.17.1713294022679;
        Tue, 16 Apr 2024 12:00:22 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.155.61])
        by smtp.gmail.com with ESMTPSA id d3-20020a170906640300b00a4e379ac57fsm7099907ejm.30.2024.04.16.12.00.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Apr 2024 12:00:22 -0700 (PDT)
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
Subject: [PATCH v4 06/22] hw/acpi/ich9: Remove 'memory-hotplug-support' property
Date: Tue, 16 Apr 2024 20:59:22 +0200
Message-ID: <20240416185939.37984-7-philmd@linaro.org>
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

No external code sets the 'memory-hotplug-support'
property, remove it.

Suggested-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/acpi/ich9.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/hw/acpi/ich9.c b/hw/acpi/ich9.c
index 573d032e8e..9b605af21a 100644
--- a/hw/acpi/ich9.c
+++ b/hw/acpi/ich9.c
@@ -351,21 +351,6 @@ static void ich9_pm_get_gpe0_blk(Object *obj, Visitor *v, const char *name,
     visit_type_uint32(v, name, &value, errp);
 }
 
-static bool ich9_pm_get_memory_hotplug_support(Object *obj, Error **errp)
-{
-    ICH9LPCState *s = ICH9_LPC_DEVICE(obj);
-
-    return s->pm.acpi_memory_hotplug.is_enabled;
-}
-
-static void ich9_pm_set_memory_hotplug_support(Object *obj, bool value,
-                                               Error **errp)
-{
-    ICH9LPCState *s = ICH9_LPC_DEVICE(obj);
-
-    s->pm.acpi_memory_hotplug.is_enabled = value;
-}
-
 static bool ich9_pm_get_cpu_hotplug_legacy(Object *obj, Error **errp)
 {
     ICH9LPCState *s = ICH9_LPC_DEVICE(obj);
@@ -445,9 +430,6 @@ void ich9_pm_add_properties(Object *obj, ICH9LPCPMRegs *pm)
                         NULL, NULL, pm);
     object_property_add_uint32_ptr(obj, ACPI_PM_PROP_GPE0_BLK_LEN,
                                    &gpe0_len, OBJ_PROP_FLAG_READ);
-    object_property_add_bool(obj, "memory-hotplug-support",
-                             ich9_pm_get_memory_hotplug_support,
-                             ich9_pm_set_memory_hotplug_support);
     object_property_add_bool(obj, "cpu-hotplug-legacy",
                              ich9_pm_get_cpu_hotplug_legacy,
                              ich9_pm_set_cpu_hotplug_legacy);
-- 
2.41.0



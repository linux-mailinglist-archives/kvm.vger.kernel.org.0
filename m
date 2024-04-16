Return-Path: <kvm+bounces-14868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 351B38A741A
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:02:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8A121F21FEB
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:02:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0BF5137C2E;
	Tue, 16 Apr 2024 19:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d1+0yNOr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48276136995
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 19:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294110; cv=none; b=AGAGCQnksvp3eyRxeyj5hA20s8gYRRNrS/iXT1dPU6qmTSN8DnYjCKD5Xa+YghLdof6+s+++9GqdU2N5RpHWOvWYWzv2c/NIj4g9b+U0dWKw5eflH83M0wKoYPZflPn0/iAw3FG13RJuQEji+QfVxuxbF/FZPkpHHgKJGdKjBkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294110; c=relaxed/simple;
	bh=LY6d/B7zjFnteYcEwHF3F5b+VLZBtL39Jzgiyp+18QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E8g81Ea4fffWrFBJA59SbP2DmNuX7H9mBdFNlTNquek2019LMVLa3xSOVOia/vynDQYWtgFt2lwrG8IcXVsN8xwqupP/k0d31eSjGklHfAm18SJTXbzuSFda/ddqQ84cId09MoBqm4LKaz+XL6NA4BsZhTc+jvCzOL22n28Iw80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d1+0yNOr; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a51a1c8d931so615406666b.0
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 12:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713294108; x=1713898908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DC2xHT4tK3V/eBcSroqFKTXibEqMvehvouzWEl1ZI6k=;
        b=d1+0yNOrARUX2jswal2XUGPZ23bnyegsTOpb101RJ4ZDfLlbwF7ED1uUIWbSDVIwpx
         hBrRfeSGa6PYLguvWzDzEfKzLpuCnF9J8FRcT364JsdDXVB4dDQ9leYbGhN05QS5fT9x
         V855SqOeqtZzJ8wVS2t+ZIiZYV3bhVjh1Ixz6+ZklEgGvgYjOvsepAovKb2hdO34FDTQ
         VW/fr3mWoA2ko3GnICauC8EmLsi+wJClJuSjwXEFxxs7AyFwhaJlMOAmht0F7Rs2KSME
         KRhuobZWMVLZp3Te75MDmYWUX5ktwPSJPxwQGDslly2Yi4AAvcTiBCC9m/ysJ2ztAoBe
         HPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713294108; x=1713898908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DC2xHT4tK3V/eBcSroqFKTXibEqMvehvouzWEl1ZI6k=;
        b=nUpPrjKHIvKW2a2uUjQhxGoHrY8YtgKTu8NP+RmsZv42b+rhrQFpAyQjnc56/f7kfX
         f56wnqSU4YTtyfHnHHBV12Z+TdqSsa+Jjfwge6xquHdNs4diOVoG+toBgau9SdTzphV4
         j64AZc5BuWfTtx7KhL4PdLV3S+8X1FNbfXidHqo0MjSLk6apz9PYOeS6afUNPLWH/BRL
         YpokjMt8mkeFSaUO04DCD+sBkONvt2LBReu+fK4mJL0dL5ezgTA9gyGiAlrPNEvxbqrn
         txNP1HQtdr1zbKOTDB+9OSupr7eU/y9VBFtje1f3airRjs055DhGzhAKBvBy4tyIf4Um
         GdPg==
X-Forwarded-Encrypted: i=1; AJvYcCWBq1bUiTiRpqLe/6mkt2jEzWVpz2b1DScVE2DvM0jr6JetczEecCjZkEvME/qeo88jOHeZwDNitUb51BCQe/5hIwMq
X-Gm-Message-State: AOJu0YzRKc7wpTy/Us733aDj/4L4Rzbga5PrvTn4btwZoaNaohuu/o54
	BJceuLsBjf8/SyOw2Ra9uFgzNKg0og9chmIUgGj+mrlVKgp3iKHE+0hp2fLlc9w=
X-Google-Smtp-Source: AGHT+IEweZwN1XzO84AS/y9gMjvEcIKlXa10QZ5mIlzXvdKEUrwDWOrz4pI3PLDYD5OPCMFQHnZ4uw==
X-Received: by 2002:a17:907:724c:b0:a54:e183:6249 with SMTP id ds12-20020a170907724c00b00a54e1836249mr4000170ejc.56.1713294107715;
        Tue, 16 Apr 2024 12:01:47 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.155.61])
        by smtp.gmail.com with ESMTPSA id v13-20020a17090606cd00b00a526562de1fsm3471599ejb.73.2024.04.16.12.01.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Apr 2024 12:01:47 -0700 (PDT)
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
	Ani Sinha <anisinha@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>
Subject: [PATCH v4 19/22] hw/i386/acpi: Remove AcpiBuildState::rsdp field
Date: Tue, 16 Apr 2024 20:59:35 +0200
Message-ID: <20240416185939.37984-20-philmd@linaro.org>
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

AcpiBuildState::rsdp is always NULL, remove it,
simplifying acpi_build_update().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/acpi-build.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
index ed0adb0e82..6f9925d176 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -2459,7 +2459,6 @@ struct AcpiBuildState {
     MemoryRegion *table_mr;
     /* Is table patched? */
     uint8_t patched;
-    void *rsdp;
     MemoryRegion *rsdp_mr;
     MemoryRegion *linker_mr;
 } AcpiBuildState;
@@ -2715,11 +2714,7 @@ static void acpi_build_update(void *build_opaque)
 
     acpi_ram_update(build_state->table_mr, tables.table_data);
 
-    if (build_state->rsdp) {
-        memcpy(build_state->rsdp, tables.rsdp->data, acpi_data_len(tables.rsdp));
-    } else {
-        acpi_ram_update(build_state->rsdp_mr, tables.rsdp);
-    }
+    acpi_ram_update(build_state->rsdp_mr, tables.rsdp);
 
     acpi_ram_update(build_state->linker_mr, tables.linker->cmd_blob);
     acpi_build_tables_cleanup(&tables, true);
@@ -2805,7 +2800,6 @@ void acpi_setup(void)
                            tables.vmgenid);
     }
 
-    build_state->rsdp = NULL;
     build_state->rsdp_mr = acpi_add_rom_blob(acpi_build_update,
                                              build_state, tables.rsdp,
                                              ACPI_BUILD_RSDP_FILE);
-- 
2.41.0



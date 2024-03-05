Return-Path: <kvm+bounces-10999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5FDC87209F
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:44:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03ED91C25E30
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC3AF85C6F;
	Tue,  5 Mar 2024 13:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O6MqT7xS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712D35676A
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646253; cv=none; b=r4efAw/gs4Zy512eqotfeHeP8Ii5+/orhBNWmZ8kFo7x5ka7wgOLei+SsheH9PUbGiCa4FKEh1XFnECiwqkJSQIp5AXWcgaqo4y8nTHkJKRcKcePEHFICkeSjKJBsRdGQahbqVLKqKu21AqQTPLtIrMiYgVA4nySM4Pyva94H7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646253; c=relaxed/simple;
	bh=C2oXd7Xj2PCn10QKJNBDyS6bfTY/pvKuD7kH+Xj+xY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TDzqclHf8Tt14GigJdxO3fFMHjgmv8eHf+nPqh63oo2yAbsrNPsn99D2bNTisqerj5l/SksEjzpeuwFuEIQPs8W/EnJ73RbbIoZxa0SW45S5NNp3R6a4a/IvJOZOYY8HGMoL7EkA9RQQeYdvLT2nmmRV9qBZ+27d8jSnHJqp4r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=O6MqT7xS; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-412e96284b9so5759815e9.3
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646250; x=1710251050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CWBRqdFoui2ZIQdsVAc4WwMyQH/pl83wSwYQ0f8fh5s=;
        b=O6MqT7xSQJ9Gr1FKAhKDOG6Zgwu1VzgD8D/06awCXOnVG6fC/nvTs52WyQwGRUCoiA
         5xY1TV07No2sX+D06kenwREeHz8irVWl4gD2UMREcZox7QkqOOQPK96aPw+z6d/olQuN
         Yp/OX23V6w/B910rNXempgRbvKI1SjR7KHYEwZiZEOsDJXSSSSz1E+oUMiWDLGpCFaig
         HmGXSYC3bskRyEs6vw/AE3IIyi2WVz3pM5RCH4RXLKoa6p13BZKlvu9/r0Q4EEAVYu7o
         wEIvicX5blID7m+fpWRnBANCwGITim+Frp4iut4or1wYrlHprmg2F7Q+aA0VltifTURE
         LHOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646250; x=1710251050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CWBRqdFoui2ZIQdsVAc4WwMyQH/pl83wSwYQ0f8fh5s=;
        b=AGaNZeSkBavFSvpHgO+Rjbq2dVDZVSIbl3zM0KKZpey54OnRaPN+RHDmuhY1IWGIc1
         Qdri9IpKLDBrB2L2Y08pEqqeDmgErpjERTny6Htos2FykFInFuA2yHX8ho28WYUrTzFG
         sGrP9jRcu6rb8aMTQisJLctNz4EGxmWUBZE1Wg5458Ba7GJsxNJlQO1NBgV9psv7YFE0
         xVehprj5nwU3+AMFJ4bJ1wjmwvQ6hv7R21xIRzGndHsu8t+0o2wwpjS8wuRKP63KumYP
         8SX6C2CIudrbBYIGN8KvfFj8NN6ePpzLJfgc0BFOg9dnYErY3iRGtGrdkxmCh2/fYfaQ
         Ih4g==
X-Forwarded-Encrypted: i=1; AJvYcCU04RtRKeXiEx1N3/DD7K6sBVMWgaGiXLdCNaEVVp+Yh74tl8Oah63OGkbbEpY8wnUR/+t4CuaN6nupJHeWwgekBaFE
X-Gm-Message-State: AOJu0Yz9auTY4aMBvRL86/oNON5tuQctU4WkUA3WHFCWmbKWJ51JKDV8
	VYSAJ2x/PvjeJfBpOd3TYHGq8qw83j8+jxmwYjajRKcdJRZ5RQ7Kf9qvXCMtpIM=
X-Google-Smtp-Source: AGHT+IGQTuvSA25MYt3l0zdavkjoVT1Rvq7X1tInRhssFdU2bEWiaupK/vlzesgSWvabYqXcp2J6Qw==
X-Received: by 2002:a05:600c:3d0f:b0:412:f0fa:5c81 with SMTP id bh15-20020a05600c3d0f00b00412f0fa5c81mr14729wmb.12.1709646249934;
        Tue, 05 Mar 2024 05:44:09 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id bd23-20020a05600c1f1700b00412ef097c27sm1260661wmb.16.2024.03.05.05.44.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:44:09 -0800 (PST)
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
Subject: [PATCH-for-9.1 15/18] hw/i386/acpi: Remove AcpiBuildState::rsdp field
Date: Tue,  5 Mar 2024 14:42:17 +0100
Message-ID: <20240305134221.30924-16-philmd@linaro.org>
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

AcpiBuildState::rsdp is always NULL, remove it,
simplifying acpi_build_update().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i386/acpi-build.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
index 12bc2b7d54..bf727eb148 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -2456,7 +2456,6 @@ struct AcpiBuildState {
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



Return-Path: <kvm+bounces-8770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 405D38565C9
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 15:21:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CE2C1C24346
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 14:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DADD132478;
	Thu, 15 Feb 2024 14:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IPO2XVG/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8612131E53
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 14:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708006858; cv=none; b=qF+Gjhpuv/YJBYU/ZTP7oK9/2dPxLMkuGEeitAspJ8NlfwakqAZk01FN6Fvoeo272BT/tLBeSg0j+lc2EgBdy9RtHJvRQl70IlCz368dTDPJU+FKp1KYOGLJE6Nw9lUgCPaDb7bFaTgXKuArY25sZcx0aGyO3qA7CWintdUPX+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708006858; c=relaxed/simple;
	bh=8N2KbE37hzzYop+XNgXAu0dXKbVPb7QPPap+rSBDaRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J1fJYpRgVVWYLqDGpHULo2GFq++xUCRm/WXO4JLm3dhD5F3islbd1shAZLk+Mzft/cJURjuNqpEg7zDgXGbx2hN3myd3rqdwKv+d1oGyVV1gQyT3EsOp//4LCPAQVml3Xlbyk9GzQ8vOhswfMm9T8M9Ks77NQQuUaU7yElFA9GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IPO2XVG/; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-410e820a4feso11477555e9.1
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 06:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708006855; x=1708611655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V9a2tbqcFhv7866Po+eazVne7c9fJyb++6ZKJPt9MeE=;
        b=IPO2XVG/egnudZE4iG99xRo4Bze5lw4+sSlUIxo8qvq97VpdCWfuevsKd0LcAs8qGA
         e9I0eC9VMTjEu2g49RspcUWZQ3m2MM2dRJOhaXZg8dPKDCE8NeSVSuJVOpUcjb81jgei
         N9XmtDf5Jn0luj/L7ynYo6NkzIXlImtfOM31r9Qm/5gku9g3Ja055Y1er4NvhHosxrca
         O9Uxq6owL4BJVfnnxO9Esq7ZxYFF6nDvRlexxpzCThIOzGyDX9VTYp6yMitylx7994rb
         YObm5bIawteP3/Vg+GaES5Iv/xyFzDfL7VpAkcJYjP7yQeMPVvUyel0ehORWmLAMfKx+
         BtMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708006855; x=1708611655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V9a2tbqcFhv7866Po+eazVne7c9fJyb++6ZKJPt9MeE=;
        b=TEKV2+AEtWPD+m+rSPxpzeioY8wvoThoXermSjZZZS/820PGnkDbVhnDOAM8Swfcm0
         qEl5wVQXJMHSPrrtUW25R0iKPZdJxNag19zWf0UfVTWZ0GrQJg8PVqwrZNsT5vwWMdhD
         kXHqak8LvSwLbeAPPO+g00K0SAiUrUXPlN6OA1AV8OfV8xh5+9SQABhN/oR55E7W5op5
         jyNkduR4VXKfwloJt5/1bhjm3ZvALaqiRIl5/Fh+tN88RIo071xwN9pCECvNtoejTAcn
         WdzbWT35FE/wz59CRTFG1Q8nGrMRZqrMKkAr8WhjVt7hLO4x34iII8B/XP9rS+yb77Yz
         92Sw==
X-Forwarded-Encrypted: i=1; AJvYcCXqGgfR2so7JPS5XYmjsduw1yobyjbuVAulS7XQOi1HEYcSaBgINAYj6stMsQLHksUHNhZAYJlGY7JFy1GAiWAF9LrQ
X-Gm-Message-State: AOJu0YwVUCssD+O3U5BL/AjNREX3KWUJygyaDW0taOvrGOm+LgwmT4FN
	Jwqnc3SGAG/M7Wq2vB7adl6V5vyaOFi5wydeolYwAxU4AzHrvY4ZExxL7XzvzpY=
X-Google-Smtp-Source: AGHT+IHZtXtX6MfTefPcXDCoXO9cBpuaZm8C6bzeO6EAUHK2OKEi7VgqOojokGFFWz2RMHHac1bnig==
X-Received: by 2002:a05:600c:1c0a:b0:411:dd82:a23c with SMTP id j10-20020a05600c1c0a00b00411dd82a23cmr1813787wms.0.1708006855024;
        Thu, 15 Feb 2024 06:20:55 -0800 (PST)
Received: from m1x-phil.lan ([176.187.193.50])
        by smtp.gmail.com with ESMTPSA id bi20-20020a05600c3d9400b004103e15441dsm2147381wmb.6.2024.02.15.06.20.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 15 Feb 2024 06:20:54 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Tokarev <mjt@tls.msk.ru>
Subject: [PATCH v2 3/3] hw/i386/sgx: Use QDev API
Date: Thu, 15 Feb 2024 15:20:35 +0100
Message-ID: <20240215142035.73331-4-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240215142035.73331-1-philmd@linaro.org>
References: <20240215142035.73331-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Prefer the QDev API over the low level QOM one.
No logical change intended.

Reviewed-by: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
Only build-tested.
---
 hw/i386/kvm/sgx.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/hw/i386/kvm/sgx.c b/hw/i386/kvm/sgx.c
index 70305547d4..de76397bcf 100644
--- a/hw/i386/kvm/sgx.c
+++ b/hw/i386/kvm/sgx.c
@@ -286,7 +286,6 @@ void pc_machine_init_sgx_epc(PCMachineState *pcms)
     SGXEPCState *sgx_epc = &pcms->sgx_epc;
     X86MachineState *x86ms = X86_MACHINE(pcms);
     SgxEPCList *list = NULL;
-    Object *obj;
 
     memset(sgx_epc, 0, sizeof(SGXEPCState));
     if (!x86ms->sgx_epc_list) {
@@ -300,16 +299,15 @@ void pc_machine_init_sgx_epc(PCMachineState *pcms)
                                 &sgx_epc->mr);
 
     for (list = x86ms->sgx_epc_list; list; list = list->next) {
-        obj = object_new("sgx-epc");
+        DeviceState *dev = qdev_new(TYPE_SGX_EPC);
 
         /* set the memdev link with memory backend */
-        object_property_parse(obj, SGX_EPC_MEMDEV_PROP, list->value->memdev,
-                              &error_fatal);
+        object_property_parse(OBJECT(dev), SGX_EPC_MEMDEV_PROP,
+                              list->value->memdev, &error_fatal);
         /* set the numa node property for sgx epc object */
-        object_property_set_uint(obj, SGX_EPC_NUMA_NODE_PROP, list->value->node,
-                             &error_fatal);
-        object_property_set_bool(obj, "realized", true, &error_fatal);
-        object_unref(obj);
+        object_property_set_uint(OBJECT(dev), SGX_EPC_NUMA_NODE_PROP,
+                                 list->value->node, &error_fatal);
+        qdev_realize_and_unref(dev, NULL, &error_fatal);
     }
 
     if ((sgx_epc->base + sgx_epc->size) < sgx_epc->base) {
-- 
2.41.0



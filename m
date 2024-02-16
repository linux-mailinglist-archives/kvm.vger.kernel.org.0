Return-Path: <kvm+bounces-8875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18C1B858171
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 16:40:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B6CC1C21FAE
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 15:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2972C130E38;
	Fri, 16 Feb 2024 15:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="giCt/cdN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED10130AD7
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 15:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708097742; cv=none; b=JIaaq72On+D55X9vWio3McBAeXkvw/P3CwbN5qQERD+HXH6H9rhS53jvhgkck8Ztu0/LC3MNM5xsFIcWB9Iijy0hjcv+6vPrGdSAZDCd3TBCWRnw2h+PwS/symbsJHwh3CmFoAKmTj08h8yWX8soCr8kf9kHLh0wTu7oEBrLvzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708097742; c=relaxed/simple;
	bh=j7kGj0gaCP81pdVf2jNljACEQYSAij8Itt1Edeo2yno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oqjNU3v1uNjTyFvan01Q9V1ReNX4/NzmHmmetHibv+ekB14caTRNCt0ArwYJYJNymQRbC1CvGVuCe5Y6yjHizLtYfHp8+oqyODq7x1d8rrabVSq7FI6uUR+aiggBKjcTOIX2QzkPQRniYCLvakVDvaMvgtjG+VBGbf95d8l/yTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=giCt/cdN; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a26fa294e56so329481866b.0
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 07:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708097739; x=1708702539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FHq12xVLql3ZjDkC8k2lRJAF5RJwUJ4vzRZ5Ca5vbxw=;
        b=giCt/cdNaFx/WHznZK5L6SnY4akyPMZdFSqt0Fw4kyE7vJj9R8X37++cLsnmHuWrk+
         Z1FX0jisMyjoWbVptvx5XkgAq4ZiigdsG+91Yv1nwY63DLjARQ8suGfp6W3NJfFxtzaq
         MRBcnHm4AbVYUdN7YK61kRO5UUo+wFtgYKBS1ytHAFv8KG92/267dOKdeNWPjQMH1OKc
         a1jDGIUvepgHScAonqZJY6KwFBu9VYB329XpyjUwzUpMuc1NITXJETvp0iZdMTEk4KPg
         mb8tldPVBccLo6z3ccWbPFvZMaMbZidGhHVXSAizYCWAvMFnzmi6Lh3opGzpebkgw++e
         /msw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708097739; x=1708702539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FHq12xVLql3ZjDkC8k2lRJAF5RJwUJ4vzRZ5Ca5vbxw=;
        b=Npp9BkPie+pr6AuwIwhVIwinxvK5SsZu63Amlk2UFKx0OV3qtlCBG8fVH631pmhB+C
         wGRWTHnZjbu/dUvseMTYtEyMNrs1o7H+yCpB1GeHCymnmTbaXAOkRN734DrrRxsD5w3J
         9hOtfUrF0AWHUSEKCBAxRsWRxN8NfHGmzGkQu8HqYprhJx4vhj90lcPA0z6pZbH5jF5L
         MtnSZExPrkIS80cQd396uyxI+5NCmO36BoVoBYEwLPLRvXitNTes9gDy+fJTOhjKhiwz
         Vl7utQ0+YIjxVlYWr0Um6o7HS/vkYQ0WNExYc+suBR7cr35TTjjCeQ3SDp4qXRnoEhE7
         txrw==
X-Forwarded-Encrypted: i=1; AJvYcCVMveeCvJgWNofntM40iN36DicqJwacDirhbDKHS3kmgHD/OmxQiEUTiBFCsgZc+r+P98nv82U3y7DOCs5vwIIiAsEq
X-Gm-Message-State: AOJu0YzZHtswuL0nf0XgW31xkk1bCpPqfcqfnaVTDuSx3ikpjgrD3GZo
	9h8gt5EEbste+4dDmtxo8SgxJ3q2WyKFyJmsEIVqORG0lqixLfCW/DsuKqwHkx4=
X-Google-Smtp-Source: AGHT+IEi6meqrapeqjO4OgHfp/p6JY/NLaWMf9AKL7DDim/5nYeDiOvwjmctPUdudVyzB5T7NpBDLw==
X-Received: by 2002:a17:907:b9c6:b0:a3d:2e34:30a5 with SMTP id xa6-20020a170907b9c600b00a3d2e3430a5mr3626388ejc.29.1708097738898;
        Fri, 16 Feb 2024 07:35:38 -0800 (PST)
Received: from m1x-phil.lan ([176.187.210.246])
        by smtp.gmail.com with ESMTPSA id tl7-20020a170907c30700b00a3d1458523esm52110ejc.29.2024.02.16.07.35.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 16 Feb 2024 07:35:38 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Igor Mitsyanko <i.mitsyanko@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 3/6] hw/arm/exynos4210: Inline sysbus_create_varargs(EXYNOS4210_FIMD)
Date: Fri, 16 Feb 2024 16:35:14 +0100
Message-ID: <20240216153517.49422-4-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240216153517.49422-1-philmd@linaro.org>
References: <20240216153517.49422-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We want to set another qdev property (a link) for the FIMD
device, we can not use sysbus_create_varargs() which only
passes sysbus base address and IRQs as arguments. Inline
it so we can set the link property in the next commit.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/arm/exynos4210.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/hw/arm/exynos4210.c b/hw/arm/exynos4210.c
index 57c77b140c..ab18836943 100644
--- a/hw/arm/exynos4210.c
+++ b/hw/arm/exynos4210.c
@@ -769,11 +769,13 @@ static void exynos4210_realize(DeviceState *socdev, Error **errp)
     }
 
     /*** Display controller (FIMD) ***/
-    sysbus_create_varargs("exynos4210.fimd", EXYNOS4210_FIMD0_BASE_ADDR,
-            s->irq_table[exynos4210_get_irq(11, 0)],
-            s->irq_table[exynos4210_get_irq(11, 1)],
-            s->irq_table[exynos4210_get_irq(11, 2)],
-            NULL);
+    dev = qdev_new("exynos4210.fimd");
+    busdev = SYS_BUS_DEVICE(dev);
+    sysbus_realize_and_unref(busdev, &error_fatal);
+    sysbus_mmio_map(busdev, 0, EXYNOS4210_FIMD0_BASE_ADDR);
+    for (n = 0; n < 3; n++) {
+        sysbus_connect_irq(busdev, n, s->irq_table[exynos4210_get_irq(11, n)]);
+    }
 
     sysbus_create_simple(TYPE_EXYNOS4210_EHCI, EXYNOS4210_EHCI_BASE_ADDR,
             s->irq_table[exynos4210_get_irq(28, 3)]);
-- 
2.41.0



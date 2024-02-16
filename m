Return-Path: <kvm+bounces-8878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 79968858174
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 16:40:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3080E1F21367
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 15:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC8BE131738;
	Fri, 16 Feb 2024 15:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Cyd3lW1F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7B6130E4A
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 15:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708097760; cv=none; b=rYuN6DHe4UDGJEK2P7HK2bL9WpTsaI0u54hZiiZ6iMiNPEsodMPKHjZGs0twksKbNEgmUVqK5992bkTRmruC0PYkvqGZeNU0/BthnO9zcJ7krJ6+Icr2qE0w7q9dflUUuWWW4IC39+ITbNO3oeE/eRaUECRQrQ3ap85dV4SIQDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708097760; c=relaxed/simple;
	bh=fixOx+DdCCs3/qzHLRZOIn8B/mfiHSNF8Fmdld4Lyc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qIKLEs1thsGCTD6dZ3OSB6q7UG6FqXlR64I+NulIyZFE0Fsb326H0Z4Z/M5X9lbK0ZV15U/XaiUgybWlBRypwO1V7XIPIhy9aJhfcCHNx9iV2sRLpPVYENgnaIQKTnRUmol2x7tBoTXgiqcpHo1wtRwjlzlAJtsaX9q/pKP0tpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Cyd3lW1F; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a293f2280c7so306498866b.1
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 07:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708097756; x=1708702556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hOmGAqEBBOEy9P6DsYyadVIEFCheEXAYvta8nSQ9bhE=;
        b=Cyd3lW1F5/UTLDcmtDpZ8SS4o2NQArA05vLGLPgy6PK/2V+Ac+YYUObB4YMXvVgD8l
         40q+r5J7lbdICVTOfB9D3paeL9ZrFrDQkm92ImvqBsV4r8vKFLmmyQiOGuNUWEbTMtkY
         wva+j9zZ+N5ICl0/77QtsTlc0C9Q0uA6OhYruG8EjJMoIohTQ7W+8lPsFG8bAEGYI3Cu
         WjP4o3P9erxDu434M5L0LT8odlwt24LWh3J1x7ubCatEnoABN43sj6PVIU6bP1XaQfR5
         Bh3CqhY1eIz9YblxopyhuY0SXIUkDDcfLqkLubljtxD0IhWXTqHeXSuTtS2mMzNHLbsX
         p/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708097756; x=1708702556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hOmGAqEBBOEy9P6DsYyadVIEFCheEXAYvta8nSQ9bhE=;
        b=QqrPmc9v2s7v24QzdLhdfiAFY+vE+cmcis29DlnB/W8zCakPgAzbJrZ/aJIsOtXHJJ
         C5CBc5qkkJ7KhUtIw4WYO/rnd+RkpSbHfOBB/9TsMytu7R/1IRJeBGRmUGUdsr4pJ2Ed
         OzjLsyXSGph3ifH+vP0eD6pe2luDYrO/6vLgQXQsN7PZBOm06IMRxiqGNJDgNnE5e+GQ
         UCMNdh2iIH3fDRQUZCPzhwDMKUf3MIBQSKHj1HQIW+e3rq64qAIBKynjDtPcVuUr4Dog
         rhbpEAM/SQAdOw9wa+CJmCuh3HlOXBYhpP4uAvOrnUZQf2jrQqf/PozcKWD3de8+jcsI
         VcqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNtUP7+ildumBUsEPp5LweicE7j0c5H2jqKogwM2fdAVQXJGAiwa7xcuTsfB16c3hgq1Ekc0Ey4DFvRmKKFl7XxvZ2
X-Gm-Message-State: AOJu0YwehybxiM3TN+DlxffetieSAL9c3b8xCVcuoNFJsxWWl5uSyM3D
	8fxA+eji6XhjMk1ZizlEOdGM5LVPBgS2VDs+v3VFpqYob8Azsq+jIIhYQK3859A=
X-Google-Smtp-Source: AGHT+IGBmhb6VOfB2zCo0LEpA88KaKbBg1ovfqo3KF7CJB2va+ushmG+IzCBDpkcDMp91+krbOftmg==
X-Received: by 2002:a17:906:c415:b0:a3d:7d6b:2dc3 with SMTP id u21-20020a170906c41500b00a3d7d6b2dc3mr3608466ejz.73.1708097756627;
        Fri, 16 Feb 2024 07:35:56 -0800 (PST)
Received: from m1x-phil.lan ([176.187.210.246])
        by smtp.gmail.com with ESMTPSA id fy22-20020a170906b7d600b00a3cf4e8fdf5sm44841ejb.150.2024.02.16.07.35.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 16 Feb 2024 07:35:56 -0800 (PST)
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
Subject: [PATCH 6/6] hw/sysbus: Remove now unused sysbus_address_space()
Date: Fri, 16 Feb 2024 16:35:17 +0100
Message-ID: <20240216153517.49422-7-philmd@linaro.org>
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

sysbus_address_space() is not more used, remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/sysbus.h | 1 -
 hw/core/sysbus.c    | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/include/hw/sysbus.h b/include/hw/sysbus.h
index 3564b7b6a2..01d4a400c6 100644
--- a/include/hw/sysbus.h
+++ b/include/hw/sysbus.h
@@ -85,7 +85,6 @@ void sysbus_mmio_map_overlap(SysBusDevice *dev, int n, hwaddr addr,
 void sysbus_mmio_unmap(SysBusDevice *dev, int n);
 void sysbus_add_io(SysBusDevice *dev, hwaddr addr,
                    MemoryRegion *mem);
-MemoryRegion *sysbus_address_space(SysBusDevice *dev);
 
 bool sysbus_realize(SysBusDevice *dev, Error **errp);
 bool sysbus_realize_and_unref(SysBusDevice *dev, Error **errp);
diff --git a/hw/core/sysbus.c b/hw/core/sysbus.c
index 35f902b582..5524287730 100644
--- a/hw/core/sysbus.c
+++ b/hw/core/sysbus.c
@@ -304,11 +304,6 @@ void sysbus_add_io(SysBusDevice *dev, hwaddr addr,
     memory_region_add_subregion(get_system_io(), addr, mem);
 }
 
-MemoryRegion *sysbus_address_space(SysBusDevice *dev)
-{
-    return get_system_memory();
-}
-
 static void sysbus_device_class_init(ObjectClass *klass, void *data)
 {
     DeviceClass *k = DEVICE_CLASS(klass);
-- 
2.41.0



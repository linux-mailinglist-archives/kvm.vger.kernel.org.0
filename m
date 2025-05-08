Return-Path: <kvm+bounces-45863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFB20AAFB8F
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:37:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 992503A3658
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61CE322B5B1;
	Thu,  8 May 2025 13:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gb86tvxH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CB0215F46
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711459; cv=none; b=sfyxFXxIuYrT9TYsgdm2uGrnn3U0o31V40H3Shb6O762oVnFZJMDIL2u4AAZfOUi2/dt8ltcYfMabizT4eWnIOHD7UuGrlqEzWgx2ethp+tAd7nwf5CJd9nHACEVoOfMZ0UPMfzj9T5ienjJnSAbiSNsxqBeaDcClYwkNWvKzgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711459; c=relaxed/simple;
	bh=KCmhYs0xw0YqbtcY6GSMEssa+051TTUsa6rWSwAu8dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RcgN28F+WtcKaTu/ZTqtasXxiEU78fIh2j946OPghNie3LzIieuu540XRjpWXJg3ab+uA8ryXclCHrijPD+OfkmDWvC5+9obmAJCmx8xfuJpexxYuJ4OOIwu5HXzVQR5iEJrq8AxoktNa7myaexQBi7X3V+/xB8wRu2TpcO1NY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gb86tvxH; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-30ab344a1d8so988162a91.3
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711457; x=1747316257; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kL4pIFttZ2qmq1tFiNzzTmUrRSAgtctinyd6wOyzE6Q=;
        b=gb86tvxHS//n5xXZJKebeNyJ5Vg47VLvmxWFYLSCnKItCZUoAYj9dq5tKbX30eUFpy
         PzN10TpI5Dv4bxRzmKLWKpALj4BYFt+KtoTSuZtozaYSkRE3sWbpPi8EqJK8NEFqjVMZ
         j6U7uVVAOl8ZFurt8CrQH1JdQhayv10YttcmdsaN59qtJ/K+77njC50YQRl5T2uRP9U0
         KKc1fvscVzlFPgrJZalXvy7u6n80JP+uWvdAQbIqjbApYMmdyYYz4TBeAc1KWKEApm2n
         wMBS+EOy2kUB5tWHT+vBD8vlLmMyHyBTijLM/AG8g1FU0Yu2CRTdfLPI7EYvsHrBOLgK
         L4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711457; x=1747316257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kL4pIFttZ2qmq1tFiNzzTmUrRSAgtctinyd6wOyzE6Q=;
        b=reKjcL0d0IUZQF2nVpyrTns/0ORcpJ6ZODfqF3tAcO0aWUbhJs1btP1H7kVfarrBt6
         P1g/DNn90eiAassb6S+Gz1PejF+GOshwfdkdn/qF0GNZnthwTuJIO5etQS56zVFop1l8
         nVmlP0YRaP2Or+JWsETY94/qMOniqI67IXVxp1EiXcQNJr9sWKIZCeSMhFC9mlwaHjH0
         H6OcqmlUwR4jS2hVFv5bCGqt4Yf/H+ZkUE70qetLtcZOVFu4684ng3wcWg+eGDujr6N8
         ikvdCaW/Xn4iGApJpwIMTUjN7iYdjP4jORc1vC2U7trK9iiudd24otGVUHg0TTGy3YZi
         Imnw==
X-Forwarded-Encrypted: i=1; AJvYcCUYcI6UZbjTkUH/q8ULFWi4C+4xzZGYYTTEH5g0imqXH/pdO+dZLtB4d6ZPKC9OgRVsOzE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOfT5Hd7odzQLkgJUwJX2aGtwGNsHZVmiRL33uJ4lPyfm2mD0H
	KtyJj8jyGegzl4Di8NGSPSqp0AQOnRvrvqXflMWxqrA1QTIh2L3yDwFD9186uEg=
X-Gm-Gg: ASbGncuwCTzMzHA4yB4j/8XCpyjw+1Anx6urOX8rxVsVyKUbRNhTI25LPw+cTY2KN0T
	DVpeRy9IHZDi7FJQKCOUo+l4+n32obBITuQBYhzHNBBVaRP8pR/yc1kYryfh365hdltjbgRbZdl
	vCIYZTPbClXK2ftypnMu28wJi53Ni9lBWQH8vbtLanKfPn8yaF/zpH4PKyak2wbL5DcVsGE/eBM
	/AncrJ8X75vo9vK4KYdjDjl2O+hVJChHF2iF5CDksNa2p8vLo4xNc09Gc93rQFNYo3yRYCDNkov
	axe9zUAxfzjBWwXDqgeP51rsJiJ9h2SrOvpZUwnuXjlqlwkvLLHdGY9ONL+LbOd+NxiVP5xIg7+
	ga9uvr8GDHTKEAOf4cOTXksasyQ==
X-Google-Smtp-Source: AGHT+IEk1b8ISPttgleiSmQEDw2klEkwqCgpYadFc8f0DOCy8FGYg03X1jjsNrMZ6SJ85jEJZpDRnw==
X-Received: by 2002:a17:90b:1d03:b0:2fe:e0a9:49d4 with SMTP id 98e67ed59e1d1-30b28cd784amr5179358a91.2.1746711457171;
        Thu, 08 May 2025 06:37:37 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e15228ce9sm112128395ad.163.2025.05.08.06.37.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:37:36 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>
Subject: [PATCH v4 04/27] hw/mips/loongson3_virt: Prefer using fw_cfg_init_mem_nodma()
Date: Thu,  8 May 2025 15:35:27 +0200
Message-ID: <20250508133550.81391-5-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250508133550.81391-1-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

fw_cfg_init_mem_wide() is prefered to initialize fw_cfg
with DMA support. Without DMA, use fw_cfg_init_mem_nodma().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/mips/loongson3_virt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/mips/loongson3_virt.c b/hw/mips/loongson3_virt.c
index de6fbcc0cb4..654a2f0999f 100644
--- a/hw/mips/loongson3_virt.c
+++ b/hw/mips/loongson3_virt.c
@@ -286,7 +286,7 @@ static void fw_conf_init(void)
     FWCfgState *fw_cfg;
     hwaddr cfg_addr = virt_memmap[VIRT_FW_CFG].base;
 
-    fw_cfg = fw_cfg_init_mem_wide(cfg_addr, cfg_addr + 8, 8, 0, NULL);
+    fw_cfg = fw_cfg_init_mem_nodma(cfg_addr, cfg_addr + 8, 8);
     fw_cfg_add_i16(fw_cfg, FW_CFG_NB_CPUS, (uint16_t)current_machine->smp.cpus);
     fw_cfg_add_i16(fw_cfg, FW_CFG_MAX_CPUS, (uint16_t)current_machine->smp.max_cpus);
     fw_cfg_add_i64(fw_cfg, FW_CFG_RAM_SIZE, loaderparams.ram_size);
-- 
2.47.1



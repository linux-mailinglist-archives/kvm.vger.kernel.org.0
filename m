Return-Path: <kvm+bounces-45864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19CAAAAFB92
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:38:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3FD4B23ABC
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8CEF22B8C3;
	Thu,  8 May 2025 13:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="E8XsAVB7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8E084D13
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711480; cv=none; b=cANl+pnTdNGZWUaIyrX0cuO4sXombeSe6UAgzgCL7nsuBnX0ObyR1n44wkmtQQDXiHYuoh6WY9K84dbQwPU1goEmxB3pzT2FVtZ5IadU731rW+2Nt6ZrcKoM911ms4RD2mvBDAZlYhy7Wm68FJxoSG1jjC9lC6qXlGpEXLYLQcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711480; c=relaxed/simple;
	bh=BTjJ3I/zeSUs15qCjKHTCRdYiArqeKsZs21fhzK7vkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dgbnsSM/nmNTsEucsWKfwI5kxP2f4aEyv/vdiK8ZIzPWoykSVV20KreC9GuyUx+kmvsWXtThkuZ4IZPmwt6lae+JWyAAgjIhGUMGremGLTRkp1rbp7cPjJOxNJaCNJIz5fFSohkjGmq/BTsf8jWGeQnDLmvlX13ZYyqq8U1Q51w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=E8XsAVB7; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22d95f0dda4so10850295ad.2
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711478; x=1747316278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WY7gSBXT6cR7bWSaiDRLSHPRiSnEJ0DiKBMO01arpK0=;
        b=E8XsAVB7I1IXUvU6IlevLw2DtaxxTxFe994F7MpAd9LoOTaW9RH0TNQ5uS/Ef8Jx1T
         YMSEBLslBsaxN2Z6pCez1P3W0c/8INzOz1bpfQnKMLHoR7kCI9IY4QG6fwwpETzQrOLl
         m64qMpJ44sdvIAiF08Ez2NMugIVhCFcy57iyibMPfRrw8f8hKYtohqDHJGdvR2esZW/0
         g8QEiMwaP0SUAdBqGbXV2FAKJvc8qHGajPDZknl5VpOJ2iEfnZKCFREoC78nCDsVcPvi
         HcsTvYqqhis9nbY3xGg2rXB9/29E+EwIOkaZh1F5RjO8JxkMD27mXsGyH/gqZxluG4sN
         ZjVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711478; x=1747316278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WY7gSBXT6cR7bWSaiDRLSHPRiSnEJ0DiKBMO01arpK0=;
        b=VQmPJJuJ6TohpWaIRedembGyfj+ukddqObJazoebJjc4hs2kRV5xL5QqlDQlK59Ej3
         R4YL3hcvf4siuS+GZJOZ44Cbiv+0NFOk5zYNI2h8+L+XNcLYwBzX6fLD74o9VgyF6ebO
         JxOA3QO+uD9mBq+MEE6SBVdtgefb2LlyVJOe8PkpZpg4cUXGg/bn/h1DaW4pdoo1acD1
         TwC/pgPpvBqjNcfbMzAE96ABg6Yx+OOH6aKSGAlsQXz+kmLgLl8INetaqTmX2yB3PjF4
         4Cmg8O0dwKhjVw/U9PfWSylU21ghSBzZ+nyFZ5sfU5YJKReTK9LUb2l7liOQcOE6kaWY
         fLBg==
X-Forwarded-Encrypted: i=1; AJvYcCUHkQFOZgQ8u9YMx7RY/YtBAHnq9cHJWuyUt1VAiiUOq70jQcvX+PREz7/VvY/I73mWf9s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7Q1hZiqERRpnYVN+KXOUtHrRSqV7OBkkhJtE377CrPhwNhbVT
	/+5eJss6G+yeEawi9orfnH6BrmMyE8RNAMcrNPlURHohKDSILM1xa2so/iq3+QA=
X-Gm-Gg: ASbGnctvT5+omgDJI6dve60Fl9fiYlt26SFiKnO0KjUBNvm5MLxpOC+rPQWNvnEeI9Z
	CKStgnfiYUq1tDauB7MFwrB1RwsD5pg+YlFrw5NpToXeqpSRuEHnH4qL0vkFoQKXtf0OQSSO4DH
	QO1QhRJ81bVuYo8M7W5cP4j5EIUSj4jlouf8Y1W4lRs1mphdwoFa9GpKrIe0UDZ+mc4y4upFBEF
	sCy3PhwnsnlFySbWLMPQmm4E+46OiKl1Dsgk5k8VXSvuxWiOzLSkoojdFme1MlZXZa4gglcJ9fC
	Bv/6Pu6oOuqTQ3XJ/YgYIx6Z5mZ2tBgoSc752ESnIDT5xtAMOYx/TCDOUBLgPzc1VIiFqTSyNTb
	I6eAIwb4olho2vgMbjMAygTD/3Q==
X-Google-Smtp-Source: AGHT+IFLlPSB1rrLA2f2qz61Ov5siZIkGu3fk4846ZY3wJHNQUHlcR79jlid3BO4tuhX5LA8XNMdHA==
X-Received: by 2002:a17:903:244b:b0:22e:b215:1b6 with SMTP id d9443c01a7336-22eb2150297mr51984415ad.28.1746711478628;
        Thu, 08 May 2025 06:37:58 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151ebd08sm111835505ad.104.2025.05.08.06.37.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:37:58 -0700 (PDT)
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
Subject: [PATCH v4 05/27] hw/nvram/fw_cfg: Factor fw_cfg_init_mem_internal() out
Date: Thu,  8 May 2025 15:35:28 +0200
Message-ID: <20250508133550.81391-6-philmd@linaro.org>
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

Factor fw_cfg_init_mem_internal() out of fw_cfg_init_mem_wide().
In fw_cfg_init_mem_wide(), assert DMA arguments are provided.
Callers without DMA have to use the fw_cfg_init_mem() helper.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/nvram/fw_cfg.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/hw/nvram/fw_cfg.c b/hw/nvram/fw_cfg.c
index 10f8f8db86f..4067324fb09 100644
--- a/hw/nvram/fw_cfg.c
+++ b/hw/nvram/fw_cfg.c
@@ -1053,9 +1053,9 @@ FWCfgState *fw_cfg_init_io_dma(uint32_t iobase, uint32_t dma_iobase,
     return s;
 }
 
-FWCfgState *fw_cfg_init_mem_wide(hwaddr ctl_addr,
-                                 hwaddr data_addr, uint32_t data_width,
-                                 hwaddr dma_addr, AddressSpace *dma_as)
+static FWCfgState *fw_cfg_init_mem_internal(hwaddr ctl_addr,
+                                            hwaddr data_addr, uint32_t data_width,
+                                            hwaddr dma_addr, AddressSpace *dma_as)
 {
     DeviceState *dev;
     SysBusDevice *sbd;
@@ -1087,10 +1087,19 @@ FWCfgState *fw_cfg_init_mem_wide(hwaddr ctl_addr,
     return s;
 }
 
+FWCfgState *fw_cfg_init_mem_wide(hwaddr ctl_addr,
+                                 hwaddr data_addr, uint32_t data_width,
+                                 hwaddr dma_addr, AddressSpace *dma_as)
+{
+    assert(dma_addr && dma_as);
+    return fw_cfg_init_mem_internal(ctl_addr, data_addr, data_addr,
+                                    dma_addr, dma_as);
+}
+
 FWCfgState *fw_cfg_init_mem_nodma(hwaddr ctl_addr, hwaddr data_addr,
                                   unsigned data_width)
 {
-    return fw_cfg_init_mem_wide(ctl_addr, data_addr, data_width, 0, NULL);
+    return fw_cfg_init_mem_internal(ctl_addr, data_addr, data_width, 0, NULL);
 }
 
 
-- 
2.47.1



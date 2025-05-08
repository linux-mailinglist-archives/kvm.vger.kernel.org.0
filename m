Return-Path: <kvm+bounces-45865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F345AAFB94
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:38:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 963F51BC02AC
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E705E22B5B1;
	Thu,  8 May 2025 13:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lzf/higR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914D3215F46
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711502; cv=none; b=FoQvl3KiwXcuyUHJqWRAKbc3HQhwy1Q7ODFjjPkEeSG/9zdAyGSTtAdU9M6q+O6eqKr1dgRPlcDDXHa97VCr9oqYELm8eRm3/ZeVBUOwF+ozNz3sO8w1iIdmNDqBYJVXwaxD8sVT9mHHqqF/VVsikfnYCw/PVRtHj8rEzx0RjT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711502; c=relaxed/simple;
	bh=0erEW8kioBIB5kze1LV13qRaYmyI2Iby/mV+3bYkVGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lxNetI1yF2RmR96IsfKIqRbGLkG/yi5R6WopIfKQPvW+eIu/gS+1li/Rz2qg3JaRg8SEptcS8UOAr3CXaN28vR+3ymr7XSJVFBROec5qU5aCYMXLO37XvNPHi35NZVwC4NY4rPpcX4POsscG47OP1F/lWC4UDplcxDSxeedBEhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lzf/higR; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-af50f56b862so593227a12.1
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711500; x=1747316300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wpFm28NPDHDVh+ccZL7bpwZ5qyD7oJMGgna414/IiOE=;
        b=lzf/higRh6Zg+CelHLKc2QSkjphmvwGvmlIBEFDgimXmaxU/MYOeFq6c7cJizDxAhy
         9xpspNJrS7ZeDMeep6IzELBlRG6FLLrDpnYerHnhUfrwUhaxk8go5U6moDVsd2XYztl9
         ettk20z4+KMmRY8/n7vEeK+0rm5gl81uG1RsfhVwy1sW1UH5TijXBjcgiV3ZIRIrRqYQ
         qc3DjWe3V4VnSUwrlKk2opeSP6bqP5/oRxq1AwS8OYeGI942Jz6YqdFS6Vo0ULjreh0i
         GSusdhlRNUXNoQKLMVE9GnONX9dTztWX5ChGrm9rxD47AAhWD4cLgPWzcQbMITg2FNR2
         wf2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711500; x=1747316300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wpFm28NPDHDVh+ccZL7bpwZ5qyD7oJMGgna414/IiOE=;
        b=aV5LMhbSvtJhaNj/zZ6giw56UVLxiXWpQXu5WGcWYtIL2xQUlE+LwDSwhvTltEIz+3
         IzL0aYtrc07bEf1RLEqubQmVcAV8EIUqDq4dhsG7jUlf1WFPIkV8e7xH59CwCYseNT1V
         Vt8k/Pr/OfKkXIwuZW77tHPLDXFUrKyZTFDfg3b2zhqycI9+1xINOPwkrMzVERHNK5NL
         M0XeW4QM/J26roivskrG6k2xb7Mtjrc2oQIJMvUArmKy7ai4ANllHxdsDUeUBfr3GOeA
         KA/Dl5DorU96Vb+f3Rr9eTBbLBuxHs021gyVXTJCy9SeT1CXVryXLSQ58ilepV3HaDmV
         ZPiA==
X-Forwarded-Encrypted: i=1; AJvYcCVD4+R/2UEu+s8v6hqSt7Nho7sJv1Uxtrn34/J3qgRJ/vj7Rn0nOkgpWHXJt5rWc45wYNE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjbJydViajm0qgF8nRBmsMtBJoYMwNqaJL1vwmq1ZDv4FiTrW5
	S9MqhL1vV31fRKxAjH7AZYSHpIGsmM/GZCv4xZxqyzz8YuaSvsvzENCWoUSZSUc=
X-Gm-Gg: ASbGncvJCEFBj0fn38BWcK9+NJhiSr9Mk24T/0v3Re38Sokh2k/J7WfWcFJ58JeARCd
	/MY2z3ZK5cDX25czLx58YJD17nedsthUdNQKok8PTCg31bOHCkA6hd1YfrHkhALaJCoLWRsdGqp
	Gqv3jewn3Yvht+gTbTO5kjV+zYXUbuGFtdbLLj+KNZ74jsIHWytXNcQGPDhIpmkWj0aW/goDnMg
	HJNAq04+hdwM9nu7nvmUYd0mH7hEL7y2GegILdfEXPkym3VE1mvGBgZOeYojbCMAO8EWSRJoest
	QZ7YOScwfqFtctCPipmo+rtbYnA75Hb5ZCcw3TBUUTZWP/jXxua/g75uvi6l0OoJ8qwTLOLquy3
	lRtcvNoxPMjqj27g=
X-Google-Smtp-Source: AGHT+IG5M7LxAxEtqrn6SjETmt6IKYSS9xA29boF8nxAUppyBF7lEa5eggXi+7v4Zp5iVONXRRv7CQ==
X-Received: by 2002:a17:902:ecc6:b0:224:10a2:cae7 with SMTP id d9443c01a7336-22e5edf9e5cmr112894945ad.40.1746711499714;
        Thu, 08 May 2025 06:38:19 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e15232797sm112617585ad.240.2025.05.08.06.38.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:38:19 -0700 (PDT)
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
Subject: [PATCH v4 06/27] hw/nvram/fw_cfg: Rename fw_cfg_init_mem_wide() -> fw_cfg_init_mem_dma()
Date: Thu,  8 May 2025 15:35:29 +0200
Message-ID: <20250508133550.81391-7-philmd@linaro.org>
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

"wide" in fw_cfg_init_mem_wide() means "DMA support".
Rename for clarity.

Suggested-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/nvram/fw_cfg.h | 6 +++---
 hw/arm/virt.c             | 2 +-
 hw/nvram/fw_cfg.c         | 6 +++---
 hw/riscv/virt.c           | 4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/hw/nvram/fw_cfg.h b/include/hw/nvram/fw_cfg.h
index d5161a79436..c4c49886754 100644
--- a/include/hw/nvram/fw_cfg.h
+++ b/include/hw/nvram/fw_cfg.h
@@ -309,9 +309,9 @@ FWCfgState *fw_cfg_init_io_dma(uint32_t iobase, uint32_t dma_iobase,
                                 AddressSpace *dma_as);
 FWCfgState *fw_cfg_init_mem_nodma(hwaddr ctl_addr, hwaddr data_addr,
                                   unsigned data_width);
-FWCfgState *fw_cfg_init_mem_wide(hwaddr ctl_addr,
-                                 hwaddr data_addr, uint32_t data_width,
-                                 hwaddr dma_addr, AddressSpace *dma_as);
+FWCfgState *fw_cfg_init_mem_dma(hwaddr ctl_addr,
+                                hwaddr data_addr, uint32_t data_width,
+                                hwaddr dma_addr, AddressSpace *dma_as);
 
 FWCfgState *fw_cfg_find(void);
 bool fw_cfg_dma_enabled(void *opaque);
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 9a6cd085a37..7583f0a85d9 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -1361,7 +1361,7 @@ static FWCfgState *create_fw_cfg(const VirtMachineState *vms, AddressSpace *as)
     FWCfgState *fw_cfg;
     char *nodename;
 
-    fw_cfg = fw_cfg_init_mem_wide(base + 8, base, 8, base + 16, as);
+    fw_cfg = fw_cfg_init_mem_dma(base + 8, base, 8, base + 16, as);
     fw_cfg_add_i16(fw_cfg, FW_CFG_NB_CPUS, (uint16_t)ms->smp.cpus);
 
     nodename = g_strdup_printf("/fw-cfg@%" PRIx64, base);
diff --git a/hw/nvram/fw_cfg.c b/hw/nvram/fw_cfg.c
index 4067324fb09..51b028b5d0a 100644
--- a/hw/nvram/fw_cfg.c
+++ b/hw/nvram/fw_cfg.c
@@ -1087,9 +1087,9 @@ static FWCfgState *fw_cfg_init_mem_internal(hwaddr ctl_addr,
     return s;
 }
 
-FWCfgState *fw_cfg_init_mem_wide(hwaddr ctl_addr,
-                                 hwaddr data_addr, uint32_t data_width,
-                                 hwaddr dma_addr, AddressSpace *dma_as)
+FWCfgState *fw_cfg_init_mem_dma(hwaddr ctl_addr,
+                                hwaddr data_addr, uint32_t data_width,
+                                hwaddr dma_addr, AddressSpace *dma_as)
 {
     assert(dma_addr && dma_as);
     return fw_cfg_init_mem_internal(ctl_addr, data_addr, data_addr,
diff --git a/hw/riscv/virt.c b/hw/riscv/virt.c
index be1bf0f6468..3ddea18c93e 100644
--- a/hw/riscv/virt.c
+++ b/hw/riscv/virt.c
@@ -1266,8 +1266,8 @@ static FWCfgState *create_fw_cfg(const MachineState *ms)
     hwaddr base = virt_memmap[VIRT_FW_CFG].base;
     FWCfgState *fw_cfg;
 
-    fw_cfg = fw_cfg_init_mem_wide(base + 8, base, 8, base + 16,
-                                  &address_space_memory);
+    fw_cfg = fw_cfg_init_mem_dma(base + 8, base, 8, base + 16,
+                                 &address_space_memory);
     fw_cfg_add_i16(fw_cfg, FW_CFG_NB_CPUS, (uint16_t)ms->smp.cpus);
 
     return fw_cfg;
-- 
2.47.1



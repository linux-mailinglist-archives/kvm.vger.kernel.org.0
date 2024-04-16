Return-Path: <kvm+bounces-14859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54FF08A740F
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:01:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11C65282CA3
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A59137C23;
	Tue, 16 Apr 2024 19:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sFC+uzEB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4B613473F
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 19:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294052; cv=none; b=dRipftpHtcOP2hfuXKExgY5URp4R2SQfEZN87KSuKx2FqWuoR/jtgneJosXfVteLnbtPgnOR9M8p14p+YvoZFxRxNrQuRso+bO3E36byUidLPMEGFNBBdgTc2emZGToofH1Jvqmg8gqye43x8JhiFzmq/4ZOyrzfmxXPCrtf70c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294052; c=relaxed/simple;
	bh=SMaorDpOaYbz6v/qERun96TKmyKTWNE+5ViNkdRMHbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rhN+LlbY8eeVuxS48bpFNYzJNCALxyrYuyIXbJS1Y/Sae4PufjfBMkqNJ3cGyWxfnRm5Hq6JdnjAbMJ/69xUbBhHEcvMUbWvHwkLWKeZbu49qSw/xmjR+Ikdm8ySjgcMizVSBWrLzdzknxuCva+sxNIX8zOv08mVabebzaqsNAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sFC+uzEB; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-516d1c8dc79so6058839e87.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 12:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713294049; x=1713898849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0cSOUYBAUJgDyQn/Z100iE3+Sgt5Cj+78hNwZltzxNs=;
        b=sFC+uzEBsoa7UxsbJOrTnFjCnQ/eeaXfP/FhHMMlsXbI283rh0RX1fsdRuRyd5Xpv/
         6R3DQFRjOdLjr4TXqYv3l8voOwVBtIXTH2frmjKLruSWX7nCahxqsULKnDyQDIuarMbN
         veHgfPiTM2OTcY3IilRS3iJ86qEkIXZ1SVEGm8q04DkG3IWoDFRs1MeKMyX8liZ/1gRu
         o/R8r6zHomBWVHXXuaZmY/hqw130A7iJZoPxDKiOhQZjlOeUwBbsEbq7GemtVhXmKiRs
         rQ2lHKyH7ks3Img20KX0QJrcumoau0B04BRc/8TvppPOGEux0N6vYsZ7p6MQc1967wZc
         MYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713294049; x=1713898849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0cSOUYBAUJgDyQn/Z100iE3+Sgt5Cj+78hNwZltzxNs=;
        b=MTx9mzBksiAOQiNK2LdacKRsFWd3ElePouKTdg8SV9cky8IP3cbUS+Iz10qz4bHJAa
         bN5aGNfosbUfA+F2Xm66DuncJJPHpwP7LXYxtl2Ajqu7fBSiCFE2PMNnL7397T1GcSDN
         6hnouhxILNHG90V3xFV/pIojk7CRTZ+6M4jeLERBJabZHRbzvPwA7wAVu7N+AY9Uf1XV
         hARs/9mqWcV5XVjdhKx71VcUarSrbzJ5TXyaelYS9ZTxhWyKRaGg4y+/VYtY01uzHezI
         0vtyJU1Q8OcU1C7n0iqWxlfRR5r7KlqaKK5TY86q7aE1qjK0/EuRHotdsNM/ocn08Hx1
         iJow==
X-Forwarded-Encrypted: i=1; AJvYcCXT1PaCLSe7pFKPzLOl9JpijAk86SD+naM9E/HUSXO2GEzNxV1ZgEA1w4JO+HDZ7Lm01pm2rCp3zjZlzLzwmR/ES1ZC
X-Gm-Message-State: AOJu0YxLfNK604ofHGdSVekL1JZHeFI7Du48vR5+keOzg79dIWJ50PeT
	HvwuoQw50o4uOhx/Ygpj7uoYKrvGwi3QqBT9De54W6Ib3kzfA+ZHrzPqcjdh0rPOEd92tzdlllV
	+
X-Google-Smtp-Source: AGHT+IHGTBCSVJo2t7yAUY9UWwABae+zuiW472THcqCnHvQ3bUekN+LNwbNpJnex0bMnOpxnGv/ltw==
X-Received: by 2002:a05:6512:3c9e:b0:517:866a:117e with SMTP id h30-20020a0565123c9e00b00517866a117emr12821425lfv.7.1713294049051;
        Tue, 16 Apr 2024 12:00:49 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.155.61])
        by smtp.gmail.com with ESMTPSA id du2-20020a17090772c200b00a52299d8eecsm6710577ejc.135.2024.04.16.12.00.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Apr 2024 12:00:48 -0700 (PDT)
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
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>
Subject: [PATCH v4 10/22] hw/i386/pc: Remove PCMachineClass::smbios_uuid_encoded
Date: Tue, 16 Apr 2024 20:59:26 +0200
Message-ID: <20240416185939.37984-11-philmd@linaro.org>
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

PCMachineClass::smbios_uuid_encoded was only used by the
pc-i440fx-2.1 machine, which got removed. It is now always
true, remove it.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 include/hw/i386/pc.h | 1 -
 hw/i386/fw_cfg.c     | 3 +--
 hw/i386/pc.c         | 1 -
 3 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index b528f17904..c2d9af36b2 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -109,7 +109,6 @@ struct PCMachineClass {
     /* SMBIOS compat: */
     bool smbios_defaults;
     bool smbios_legacy_mode;
-    bool smbios_uuid_encoded;
     SmbiosEntryPointType default_smbios_ep_type;
 
     /* RAM / address space compat: */
diff --git a/hw/i386/fw_cfg.c b/hw/i386/fw_cfg.c
index d802d2787f..f7c2501161 100644
--- a/hw/i386/fw_cfg.c
+++ b/hw/i386/fw_cfg.c
@@ -63,8 +63,7 @@ void fw_cfg_build_smbios(PCMachineState *pcms, FWCfgState *fw_cfg,
 
     if (pcmc->smbios_defaults) {
         /* These values are guest ABI, do not change */
-        smbios_set_defaults("QEMU", mc->desc, mc->name,
-                            pcmc->smbios_uuid_encoded);
+        smbios_set_defaults("QEMU", mc->desc, mc->name, true);
     }
 
     /* tell smbios about cpuid version and features */
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index cd6335d6b4..2bf1bfd5b2 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1778,7 +1778,6 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
     pcmc->has_acpi_build = true;
     pcmc->rsdp_in_ram = true;
     pcmc->smbios_defaults = true;
-    pcmc->smbios_uuid_encoded = true;
     pcmc->gigabyte_align = true;
     pcmc->has_reserved_memory = true;
     pcmc->enforce_aligned_dimm = true;
-- 
2.41.0



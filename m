Return-Path: <kvm+bounces-42023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F380EA710DE
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 07:57:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A66551757CF
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 06:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33B1519ABC2;
	Wed, 26 Mar 2025 06:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="mm2gJEyv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3F617578
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 06:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742972228; cv=none; b=UKo/lmUWHf/ab//iivTM0Rdp9ruQA4QljT9KNcRaDpEPd/CWJLsSPI87rkHd59uxsSHFs3UK+OIl71iLWRmpUOhULHAV8sbB3hw3YpWznjDNEvKI2LqBhwgt+INlYAx/0rXCB0iHjNr4Cg4kHiVDFsAVp30jmoP3qchaHqWoNIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742972228; c=relaxed/simple;
	bh=kabGxAp7nbybX19AF+XqMyWmp0pFwJJ2uH7LngQjt6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijRLeinuZBOuw+kzCQqm1ucMmH721mJdwkOIyj6ne9bfs+iNrIz+Ui6U5lDdVQw3ptKYztf0A9TvCvSfnr8fxSG304wQjvmSSwAxKsISTLX53xsnEoBVETbJ5xT8jbV8BISZDPYNQA4q8C3bGk9jCrwrjTmCsY+KdL7guzaBrfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=mm2gJEyv; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2279915e06eso73070945ad.1
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 23:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1742972226; x=1743577026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLEKqRLWfjNWO1Y3LXL24I6Udo4pWSqiBjtsFWDKELE=;
        b=mm2gJEyv633E+Zw6k1yEsZB3xrxH1YPfUBvYefjAD+7N7F/r2lSkKAGF2bQlHeokaN
         8/f/jDRbSlQoWBZ4TWDV/AVhRSbSHIHjDRl5/AflB1IIsmuG8FywhrrRIRAHQbixTxhN
         TvBtxgpy/YzOiX7JfbgZaLmBIqtpXnkbfs/HGE33daW5wiDYurAuBcEYoRA47IwL6+90
         9AYekFS41mvGsHwgU4+Bk6OLai89aREVdNGZOaAg0Sm0wC3JPt28oS8BudsxZ4h8D80R
         vzzS1WuNj2VQoRMI9RgwlOBiAsE8Zljr6WxJoPeSTkfU3nNH4d+wVKCGxf/J07AjzATK
         4ZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742972226; x=1743577026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sLEKqRLWfjNWO1Y3LXL24I6Udo4pWSqiBjtsFWDKELE=;
        b=fanJqyV9lvE2+TaGAywxstbvT5jL/VYby0fH4VL1PuqTu6AIqJBsvv0BneyikOXtBo
         tmcu3l/ej9OkbAzl9Jhfj6pdPdanarm2YnU45F2JM1J4t2fu8367xH0dqZlm2oNrs1oD
         FU6EESwA5TfwuLXPhjsQq7A/wCxO295Mzz8KBp8/CaQRqSagBw0CdPkbHdLMucIxD+2T
         VaMUlq6Ywv3MzclV/KtkcawwRMBviLl8P3dhO5zHwNXPx0efLRdRJs3tqMiWb/xdTOD8
         SYSh0tW+gTHLQXBcQpfYU5IcoLPyu0y8xOqCLtNcu0H5nxS33Zqs3Z8Lhe74zj9dzSTt
         sOWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLFtuinmartXxDxrXyL6UDDZt+Ifihr7mA+yacU+hcDZ1Mn14F58Fv/e1VrMPZdDpsk4s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0ToaHmUec2p1KBTrsFDy9Grj2oerqFOTqDeFF9+QqG6F4H0xf
	HqMNppWo+HizPC/WON1SanvxvcFWS5pESsl1+4HvJRSzhZiK7e3Pt9ukKu8YKyg=
X-Gm-Gg: ASbGncsVA9EBevXenEfBArG8X3pqO81e/DkfKNOZJq0YJ/bjm9yPypc02V9QD7rSFrt
	jAiYs5OUIZMm+2No4miKddrnOMr9L7p3/GfW3PissjQq/NwiQjbeBSNbRlJ/2nryniCIMrXRlBZ
	fudgWGtuC/TSYulmQZrHj2HI9OvlVDggI/pA/g1nDofRGtnMsQB1WoCGtp+EwxURiPGVLK5vUtQ
	xrLhkGyP/CZQCdlKu9gUCuI4DYAxqabHBxdTqGR09kYJSvK6U94iNjl4XvC6/Kwkt+rkSIZhLBH
	Ob5IHRXAtlPybXyca09Z4GvWJkW/oOK11O1MIFF6ybbEIaqZFssq0WDX7hE2bcICHKSwUy/8M5k
	t2BZ4lw==
X-Google-Smtp-Source: AGHT+IGXY3LffBHOP/txcrjQdMCWm5HHhSPkS9j9uUWBO3DwQkN4QXL93Ox56vzpd7i3gf8NiUBNTQ==
X-Received: by 2002:aa7:8881:0:b0:732:5276:4ac9 with SMTP id d2e1a72fcca58-73905980abcmr24766474b3a.9.1742972226153;
        Tue, 25 Mar 2025 23:57:06 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390611c8d1sm11788817b3a.105.2025.03.25.23.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 23:57:05 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 03/10] riscv: Add Zabha extension support
Date: Wed, 26 Mar 2025 12:26:37 +0530
Message-ID: <20250326065644.73765-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250326065644.73765-1-apatel@ventanamicro.com>
References: <20250326065644.73765-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Zabha extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index c1e688d..ddd0b28 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -28,6 +28,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"svvptc", KVM_RISCV_ISA_EXT_SVVPTC},
+	{"zabha", KVM_RISCV_ISA_EXT_ZABHA},
 	{"zacas", KVM_RISCV_ISA_EXT_ZACAS},
 	{"zawrs", KVM_RISCV_ISA_EXT_ZAWRS},
 	{"zba", KVM_RISCV_ISA_EXT_ZBA},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index ae01e14..d86158d 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -61,6 +61,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-svvptc",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVVPTC],	\
 		    "Disable Svvptc Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zabha",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZABHA],	\
+		    "Disable Zabha Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zacas",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZACAS],	\
 		    "Disable Zacas Extension"),				\
-- 
2.43.0



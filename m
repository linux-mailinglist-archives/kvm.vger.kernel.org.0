Return-Path: <kvm+bounces-57123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AAD5B50520
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 20:23:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0F3BD4E14B7
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 18:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B1BF352FF1;
	Tue,  9 Sep 2025 18:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GMPl4RwY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C123A2FC88C;
	Tue,  9 Sep 2025 18:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757442204; cv=none; b=fN/nXWLvAY8Pz8xlAF2E18ne5aX+8TVtZR/0k8u61CgXBxpHDILS0WzDALPI9Dq04cCeVBuLsmU5r9zDh1KopZLgNkxltjuy4nFg3i8peP2dbvHK6DS9EIZCcmGI10aDnsYwbEv5zeVjFdmAMpCP6D3gEofAgZqWMtlWeCe/I7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757442204; c=relaxed/simple;
	bh=ayXq+M/IXmtH+qzE3s/vt9E1QhH2xZ1MYd7INE929wc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=IXS2o9tI78YGmZWiQhhqKsv6CPjltmJ0fr5+JFS296aC9Kxb0AGB0hZO0H8pklP9xjwlTh4eyTnuJVQxXHY196ijIiLuLJUQhaA+OFnb1coyLi6QgZkju5jI2XyIw5J/GUWY4YRd1j4T2CVBLujD4jBTgsDUC1P4CZa19xKbkvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GMPl4RwY; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6228de280a4so6886775a12.2;
        Tue, 09 Sep 2025 11:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757442201; x=1758047001; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8PUVP7FKAOtU/TwsRsEeYoSFs2VmQKSg6Oic7Qyd3DY=;
        b=GMPl4RwYkObqtz5cZGJp0pAo67hOTJX+oU/pog8n0rcFzF05tGnaokIEtrp7hLFH6C
         U8wBamVgjLD11deqtmGzwbJBCNJaD2EZgpeAf9UbqFOyyx1M/v1KwOeChVEGo4vufXJ9
         kPQ1guq0QvLKEsg1421mf96s5m7D25oCgSZeAfg+Wtm4rKl/C7FvRyws7J5mrboOEC4e
         WFN54URafwAYqJX67GrIoai1zMtfAavmd5TjrEmmrtgUtU/+jLuIQUm9N36Szj9rYzkT
         jCm4oqvJEARZbZwV+9aE8h/b4NaYss4k7jBjs9cZZuy5PoP4hAzUnnEnu815QQgrleNA
         TkSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757442201; x=1758047001;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8PUVP7FKAOtU/TwsRsEeYoSFs2VmQKSg6Oic7Qyd3DY=;
        b=kZmRZKO468y9QvZqwiAPfJsey9sIv50Hz3rmAdcnEHq6a3VZskvMI82f3UjUTtwDpU
         csYrCp9IU/rjmmHLXVU86YQYiSaDK1aw0oTEqF5/NdLLMdvq+Rk9zoYRGRWANhuLSyFW
         8AHSuXnON6/vpj8ehqnZKGbWdKmK0HgCzvF1ApMAGh8WZQyH0RowMY/nX2TlLLgLvcJ0
         wxl9G9FjmtEfq7GLeQAah31NrV/5OHRzblSnb9KwWw6aI1ooazkMd61sE9miN1hARsst
         nlTZP5vOa7U0IKY/fwpTjPCI/8fYi76368o4GOLSmOewI3uCVJ4b4c7OEZ6cunWwp9gw
         yt1Q==
X-Forwarded-Encrypted: i=1; AJvYcCU2DNr0za1QPz8v8dlwj3tSaCGiDhqcoiyd4U919nVBHtiZkxXhnTfiAmWzkYiMHDU5FQgrGB5gp3iV0KmL@vger.kernel.org, AJvYcCX/oKrRh5sx27qJf03ERFHzz52aX+0Pp+434h7oo8t/nURdjPaB6YKIabrKf7RGZqyIM+g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeknF3QE58+K0gSo1BE1SEM0rYIaPVZ4jj22sRhm4HdW32f6Os
	uqiGzyZqEk3/iHA3ajrT3XLEz3YwRlK9GCvkXQqSLUzjz7b6hJKMmtiX
X-Gm-Gg: ASbGncsak9yWEiBDPYxcncDfV3TYKpDgcafXfObJbyHqO+Rw0Zzz0OItXfnKscnbIon
	83OPgUyLq3+oFNwhkCPJkRWKqXd1iWpWYX6o4CapppO21n4LReyLJHT/q7u+8/DRO5r3SON8DYv
	RBsGcTKcxhY4SJFT8hJ6cCOq1f1lpzuAaSAJENU79OzdoIGO7HzwyNrG1AOguCSWqsJESWwvt18
	0iEjNmTm78TabJY5mplaAp4vlWj89jQ8rdKD27+DBI+91FNbAUFQWafT2JnFF8ui0jFj9+hTwmN
	WJcNTfJWQsoJbiaVZ05zI5p0ffbTVDdbgIMdgyBMOdDIdphcV7gPmj5LEqb7rS2KX0gkR5dy4b5
	IAiDz3wuCznhbYePBiho62x2bVDSHwqY=
X-Google-Smtp-Source: AGHT+IG6IL42h/9FNE6j6CpH2K3Mce2bZXCFt5O8zybEj1g1GeIFSi2pHiMl3l2RmkPRMJ29sOuVmg==
X-Received: by 2002:a05:6402:358f:b0:628:bee2:b32f with SMTP id 4fb4d7f45d1cf-628bee2b7d1mr7116519a12.10.1757442200742;
        Tue, 09 Sep 2025 11:23:20 -0700 (PDT)
Received: from [127.0.1.1] ([46.53.240.27])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-62c01bdb7f4sm1765335a12.50.2025.09.09.11.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 11:23:20 -0700 (PDT)
From: Dzmitry Sankouski <dsankouski@gmail.com>
Date: Tue, 09 Sep 2025 21:23:07 +0300
Subject: [PATCH v3] mfd: max77705: rework interrupts
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-max77705-fix_interrupt_handling-v3-1-233c5a1a20b5@gmail.com>
X-B4-Tracking: v=1; b=H4sIAIpwwGgC/43Nyw6CMBQE0F8hXVvTR+jDlf9hDEG4wE2gkBYbD
 OHfLWx0p8uZTM6sJIBHCOSSrcRDxICjS0GeMlJ1pWuBYp0yEUzkzEhOh3LRWrOcNrgU6Gbw/jn
 NRdrWPbqWMmNsBaCsVDVJyuQhLY+H2z3lDsM8+tdxGPne/m9HTjnVEpg2jAvI+bUdSuzP1TiQ3
 Y7i41mmf3ti9+zDKKVEY4389rZtewMfMrV/HgEAAA==
To: Chanwoo Choi <cw00.choi@samsung.com>, 
 Krzysztof Kozlowski <krzk@kernel.org>, Lee Jones <lee@kernel.org>, 
 "Kirill A. Shutemov" <kas@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, 
 linux-kernel@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
 kvm@vger.kernel.org, Dzmitry Sankouski <dsankouski@gmail.com>
X-Mailer: b4 0.14.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1757442199; l=3969;
 i=dsankouski@gmail.com; s=20240619; h=from:subject:message-id;
 bh=ayXq+M/IXmtH+qzE3s/vt9E1QhH2xZ1MYd7INE929wc=;
 b=66TYJUIuxw3yPPu486grXeNmMd8ThQFhW/B+yOmNoPfG13vTLT9sur8zphKWfPUk3IDIg1uK3
 nFCtqugAYkVB1wJ12k33rDY3CIy8SKPKOuPR5qJubiAcp9MkB3hOwTH
X-Developer-Key: i=dsankouski@gmail.com; a=ed25519;
 pk=YJcXFcN1EWrzBYuiE2yi5Mn6WLn6L1H71J+f7X8fMag=

Current implementation describes only MFD's own topsys interrupts.
However, max77705 has a register which indicates interrupt source, i.e.
it acts as an interrupt controller. There's 4 interrupt sources in
max77705: topsys, charger, fuelgauge, usb type-c manager.

Setup max77705 MFD parent as an interrupt controller. Delete topsys
interrupts because currently unused.

Remove shared interrupt flag, because we're are an interrupt controller
now, and subdevices should request interrupts from us.

Fixes: c8d50f029748 ("mfd: Add new driver for MAX77705 PMIC")

Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
---
Max77705 has a register, which indicates, who is triggering irq. There
may be 4 irq sources in max77705: charger, fuelgauge, usb type-c
manager ic, and so-called 'topsys'. Hence, max77705 mfd parent device is
an interrupt controller. This series implements interrupt controller in
max77705 mfd.
---
Changes in v3:
- remove shared flag
- Link to v2: https://lore.kernel.org/r/20250907-max77705-fix_interrupt_handling-v2-1-79b86662f983@gmail.com

Changes in v2:
- remove unused interrupt declarations
- Link to v1: https://lore.kernel.org/r/20250831-max77705-fix_interrupt_handling-v1-1-73e078012e51@gmail.com
---
Changes to v2:
- delete topsys interrupts declarations
Changes to v3:
- remove shared irq flag, and describe why in commit msg
---
 drivers/mfd/max77705.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/mfd/max77705.c b/drivers/mfd/max77705.c
index 6b263bacb8c2..62dbc63efa8d 100644
--- a/drivers/mfd/max77705.c
+++ b/drivers/mfd/max77705.c
@@ -61,21 +61,21 @@ static const struct regmap_config max77705_regmap_config = {
 	.max_register = MAX77705_PMIC_REG_USBC_RESET,
 };
 
-static const struct regmap_irq max77705_topsys_irqs[] = {
-	{ .mask = MAX77705_SYSTEM_IRQ_BSTEN_INT, },
-	{ .mask = MAX77705_SYSTEM_IRQ_SYSUVLO_INT, },
-	{ .mask = MAX77705_SYSTEM_IRQ_SYSOVLO_INT, },
-	{ .mask = MAX77705_SYSTEM_IRQ_TSHDN_INT, },
-	{ .mask = MAX77705_SYSTEM_IRQ_TM_INT, },
+static const struct regmap_irq max77705_irqs[] = {
+	{ .mask = MAX77705_SRC_IRQ_CHG, },
+	{ .mask = MAX77705_SRC_IRQ_TOP, },
+	{ .mask = MAX77705_SRC_IRQ_FG, },
+	{ .mask = MAX77705_SRC_IRQ_USBC, },
 };
 
-static const struct regmap_irq_chip max77705_topsys_irq_chip = {
-	.name		= "max77705-topsys",
-	.status_base	= MAX77705_PMIC_REG_SYSTEM_INT,
-	.mask_base	= MAX77705_PMIC_REG_SYSTEM_INT_MASK,
+static const struct regmap_irq_chip max77705_irq_chip = {
+	.name		= "max77705",
+	.status_base	= MAX77705_PMIC_REG_INTSRC,
+	.ack_base	= MAX77705_PMIC_REG_INTSRC,
+	.mask_base	= MAX77705_PMIC_REG_INTSRC_MASK,
 	.num_regs	= 1,
-	.irqs		= max77705_topsys_irqs,
-	.num_irqs	= ARRAY_SIZE(max77705_topsys_irqs),
+	.irqs		= max77705_irqs,
+	.num_irqs	= ARRAY_SIZE(max77705_irqs),
 };
 
 static int max77705_i2c_probe(struct i2c_client *i2c)
@@ -110,19 +110,12 @@ static int max77705_i2c_probe(struct i2c_client *i2c)
 
 	ret = devm_regmap_add_irq_chip(dev, max77705->regmap,
 					i2c->irq,
-					IRQF_ONESHOT | IRQF_SHARED, 0,
-					&max77705_topsys_irq_chip,
+					IRQF_ONESHOT, 0,
+					&max77705_irq_chip,
 					&irq_data);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to add IRQ chip\n");
 
-	/* Unmask interrupts from all blocks in interrupt source register */
-	ret = regmap_update_bits(max77705->regmap,
-				 MAX77705_PMIC_REG_INTSRC_MASK,
-				 MAX77705_SRC_IRQ_ALL, (unsigned int)~MAX77705_SRC_IRQ_ALL);
-	if (ret < 0)
-		return dev_err_probe(dev, ret, "Could not unmask interrupts in INTSRC\n");
-
 	domain = regmap_irq_get_domain(irq_data);
 
 	ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE,

---
base-commit: be5d4872e528796df9d7425f2bd9b3893eb3a42c
change-id: 20250831-max77705-fix_interrupt_handling-0889cee6936d

Best regards,
-- 
Dzmitry Sankouski <dsankouski@gmail.com>



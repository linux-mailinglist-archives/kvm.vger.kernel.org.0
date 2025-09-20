Return-Path: <kvm+bounces-58333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6CD7B8D11C
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 22:42:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C33E1B2716C
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 20:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 730AD2E5B11;
	Sat, 20 Sep 2025 20:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="oZExTUWr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1372E2296
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 20:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758400752; cv=none; b=Mzmm6ZADLMkJWaZSUcCRcO0UkxaW3ZX7J5F9KXV2L1qR59UycUWv21mAQY4FesZUwa9yTzrwFwF/niVeW332Bp9/808n0cuT88BPAopbal0AoeD4gwrulxnlV9r81Hur52s9dUWfzsi3QQ8NB1qwPapgVNbRaPLf0HPTpvp4AJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758400752; c=relaxed/simple;
	bh=Hg34JU7YAR3ovVopvNeMy/UYrJOofzU+xpM0EejLzeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QImxCT73ZVaqqPS6mKDknvPGEPxa57shrxwQVa7s19wa3tDxvYKYfx+Hv8hFy1Oe2kZEKYyVY3RgoH31a7CjyEqRS4Uyt2sYULwncOCMRf7biZBhb9sN7LzdtfnAoCJwSLoWzvEci5pcBG1UowLGhz4DFPbGoBvu9QXfFL0Bcds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=oZExTUWr; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-4256f0fac67so5297875ab.2
        for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 13:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1758400750; x=1759005550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tiJg8ON0boDhCQorG+j+Xw5gw12MCBbaI74+jnmrMFk=;
        b=oZExTUWrER6X/OgXrV7rlHfqqm468bDvvF0DIk1x9k77GCBQdVwSxk7ox+TIBVHnwY
         Dx57sU1muoIj86ADKODQB29H8gYgqUgkKsb60coYVAnUKxhbUhP3h9JSbbblphlE5MXD
         JNvsRqAJWlhoT5vQnT4F1rdq9jgiwHI3xHGkfRVDl8oahLIUCM/T0TGrdrvUL+ViOykv
         t23gOLG/g8ZCP25/+j7WpUchyyIwf8bau8tpTxYgxIYNFbIkawCsP+aWP9Zqzy7hpej+
         ZxxOkInWm/0R0PAvfYgUByS1RJt5cJ9Fs181Qpq1Tbpif2o3+J3NCtXEo9q14/+pG6OL
         QXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758400750; x=1759005550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tiJg8ON0boDhCQorG+j+Xw5gw12MCBbaI74+jnmrMFk=;
        b=XzjCC49OiqnfJ8n94weJ08CuAXkuyi7kAh6nfDapXNLt0dtz96fthuiDFRI6+Ompoz
         kBmplbYcz/IjCrUdBAzuVEAfijhD9zutFZelzkkrI4tucu0ICE9xi2Vsca3YlmBz6Iyz
         ea7Qv3hp7YrRl9mYgPImsruo3j9Hb0tZjP1kr5NDVmpaZGfC0q+1CWoujFoR4mwQPbp5
         dZXD7UzUran0ueW6qkBM1Oo9g7TPXjQK/CmXo1V63IMomXyGAqeuAUJU1oWcQuiOvSa9
         cp0891x0WRzv3nTTUjMgkar3mma30UcQtchz1cjEO1o1Jb6AsBgn+1V3mBL0F2HV9gk/
         rPsA==
X-Forwarded-Encrypted: i=1; AJvYcCX/REEuLnOyLWhgX4pcu6S83WBA0IzZGjbfvZAGKHmuuG95au119qTb6jmr5+XHZUAiyAE=@vger.kernel.org
X-Gm-Message-State: AOJu0YywkdsJ+O8TbFR1Q5rDKT+PU1scO/ljvx6AcuJZZUmpqw+2Io4C
	3/hCKJHHAZO3Ka4lbJZIA44rH+QTZhA+U9UO8ILwGdbFifOOEDBy4a4N4ATpPn1H7Qs=
X-Gm-Gg: ASbGncuEWrJJ7r/dHXVGWTRFOg66halb4rby/5wBWjw6t9XcNb+xoRiv7QltcPT1CJn
	HmYtm3JUIKTwtzFlDr4X2CjPMLHFcvtaIrsD6g4cEn2N9C3iMg/61yB2qlPgzhgDekHbIynMZG6
	nujADU9M8J7p4VCFkdI2eWTNLn5MDCZ1bAapa439O6t9RfKH63x6Jm+QJjHWEn2RoTC3DTLN4bm
	txU4eGY39syOMzzLgt+/V7pHK77XMGsmefv71QmCLBxnmvj2dDG37B4yMRDohj2WXJYKFxoQpss
	S6HTFRGGEHtCDNc89odYt79oMImGSkAqwztG04CG158hiS+iNuAlAH+2abmPkTyiHjpOXmZLDFF
	Go07mXUiGCsNxq2jy98XPOCx9
X-Google-Smtp-Source: AGHT+IFsmriwC7sM1H4SekuoxTk4S0bUk4TUqEUdLP6mEpfm4K0KojSVb0TkIY/Q7lu1c7nixhkmrw==
X-Received: by 2002:a92:c24c:0:b0:40c:410d:dc35 with SMTP id e9e14a558f8ab-424819709a7mr96072735ab.21.1758400749673;
        Sat, 20 Sep 2025 13:39:09 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4248a975078sm17095365ab.17.2025.09.20.13.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Sep 2025 13:39:09 -0700 (PDT)
From: Andrew Jones <ajones@ventanamicro.com>
To: iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com,
	zong.li@sifive.com,
	tjeznach@rivosinc.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	tglx@linutronix.de,
	alex.williamson@redhat.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	alex@ghiti.fr
Subject: [RFC PATCH v2 13/18] iommu/riscv: report iommu capabilities
Date: Sat, 20 Sep 2025 15:39:03 -0500
Message-ID: <20250920203851.2205115-33-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920203851.2205115-20-ajones@ventanamicro.com>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tomasz Jeznach <tjeznach@rivosinc.com>

Report RISC-V IOMMU capability required by the VFIO subsystem
to enable PCIe device assignment.

Signed-off-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 drivers/iommu/riscv/iommu.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 02f38aa0b231..5a0dd99f07d0 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1452,6 +1452,17 @@ static struct iommu_group *riscv_iommu_device_group(struct device *dev)
 	return generic_device_group(dev);
 }
 
+static bool riscv_iommu_capable(struct device *dev, enum iommu_cap cap)
+{
+	switch (cap) {
+	case IOMMU_CAP_CACHE_COHERENCY:
+		/* The RISC-V IOMMU is always DMA cache coherent. */
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int riscv_iommu_of_xlate(struct device *dev, const struct of_phandle_args *args)
 {
 	return iommu_fwspec_add_ids(dev, args->args, 1);
@@ -1531,6 +1542,7 @@ static void riscv_iommu_release_device(struct device *dev)
 
 static const struct iommu_ops riscv_iommu_ops = {
 	.of_xlate = riscv_iommu_of_xlate,
+	.capable = riscv_iommu_capable,
 	.identity_domain = &riscv_iommu_identity_domain,
 	.blocked_domain = &riscv_iommu_blocking_domain,
 	.release_domain = &riscv_iommu_blocking_domain,
-- 
2.49.0



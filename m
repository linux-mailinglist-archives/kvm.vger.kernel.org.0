Return-Path: <kvm+bounces-58329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 111E0B8D104
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 22:41:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DEFEC1B25AA3
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 20:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E9A82E040C;
	Sat, 20 Sep 2025 20:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="oAnTD/14"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5005E2DE71E
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 20:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758400747; cv=none; b=MVxFwzKM8tK1b8BZK/h6HMR7RzdzvqkwGDAjcOc6PAnNS3K2/HXbFnga4WKdVUN3c5dUJhsXU64LsrUuPKK8wOnRHyy5Bk33/rlOi5buJpIRRBDZEYlyM+yh/q2ZFAaE+BjI5MExXobxz2HKnq3PsnwMhfY14L7L1ZIJhD5/hek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758400747; c=relaxed/simple;
	bh=FfOMQJOET+fXIoGZ1uM25aIVQjCYOD9kzF8+9pRr/5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUHCGT6//UFTufApLsNOkQ/YI+83/nGLOL85lBpW5IXihjubm3iNoc82sje2WlYVYiEll+mIlF1I+d0CH+hV61UhGAImU9SM4DqeYdsCnC+PhrFEHeXea2fY+m74/xOP+c9J2jURg82tL7UK5FMbkV5YSLbaC55ZPhsjmyP6m1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=oAnTD/14; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-88cdb27571eso111426739f.0
        for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 13:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1758400744; x=1759005544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jyclL1XhlEcYsrqgE10jIhLpC+mtwJUT0A78Decqu/E=;
        b=oAnTD/14RXpyUYUTE7DUHZ5AdYeVu2JrtCEIkYIrfYFlR4hdUIYAbO0CkR3l5UjDSm
         PRyJBiibZqynglRci4k1L+fa+Jvt1LFeogcdzy16Hg9M+HsXgHJ6pAmYF7oJA2SRMfcn
         21zbKBrLKcpeL+zGmErWt37uKtijqPn0WQWS1hGrpZK/OIpQKiOgnEfVdaQl1nyUA6c6
         KDRFcNgyxf5NQS3Vbw+blK20orkLJN008l1fygbDZQUeA897t4NejaBMXqCUP/oP9zCh
         SR83dLgFUXX07xvNOTluyydCj3pfWW4cwSLXzNFCnuUvib2NJ/o+dvbq9iWLN0AS1r/d
         snGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758400744; x=1759005544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jyclL1XhlEcYsrqgE10jIhLpC+mtwJUT0A78Decqu/E=;
        b=OTTUi62VpW5K0U7iB9il39vWtVx/kZiFdhtpVGnQrkEvZrvlkhHDl1iz6ATNCru4BP
         Z0IS727zSTj4audd0IG6ymNBVoI7I1iCOBzWorus6BK8J0YMUo/KSo0RirJEU1LDkSal
         meibYIlGNV2+dJMn4WXWs0jl6w7pYUn8iUn8DXadPgRxJ75heksh3Rh0GVYajGr2Ypzp
         LXuKG0SKVTh+t7ORw4VMCNIWLBuy3nevi03KnOkqRyU3QgzOlzf9+9DiJvAI/+QZzzOP
         2Dk18f33ICycxSB6qT5d9/3/k2rmj7P1c7jMrwn36yx51UFntMniO2GM8W7UKinwyyje
         tafg==
X-Forwarded-Encrypted: i=1; AJvYcCWKQmmhlA96Ol99PkI1O0vOVd7ksfX/lFg03lyMrMnWRw8prUohr5DOqiTCYlbeJrR6El8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzVDnItOLyIfsd4DCjHzsSnycn7NeXO+bAf2DBkV4N6t36rpCN
	+6zrlwXI7CdvEP3ikTJW4Af86wHBgVSeKKiP5DgwM/5T1QRbT8yjltla6eb1ujBjrnU=
X-Gm-Gg: ASbGncuMJRrE6ZQcB3gOnF1l2YNgD9PSnxLVzgtJMia5S+a5qWn2SoSmjWkGWG5QQ4G
	7Az215BFfGUZze2H4vigCKYhXCQLYlN2Q0LHSSKKedFzDxfYDSzs7+mpTKbeYlUrrX7y0TLR2JG
	Qlo6P7d2xp+KOg8T/Wp951AY0l57oGWt6k00+gL1SC+L2vW+5xQCfYl/zlWZK7H6N5N3nw16WcG
	TXafOVH4CKCPdjAjQ6K5hmjvPEUNXtgfqs3kVC0UqRakjlQnshBCkXnjHW90NT5r83ymNzdTpFO
	hE6JQggPtJMuj7E45FREZJNPCpRvnidUs9W+jxU0Rx8onbVh9MSv2boX7KyuRXk9ZMdelrN67k+
	OeFnDdfDJFCI6p8+VaS9HbWbe
X-Google-Smtp-Source: AGHT+IG40gGHsXsi5eSQylQi3Zsm0ULLvlAN1CN/2lldqNCL8Ji0Ye7gijLwVVX5LjTNRaDqmRWawQ==
X-Received: by 2002:a05:6602:6d04:b0:887:788c:d345 with SMTP id ca18e2360f4ac-8addc8a1170mr1309874539f.12.1758400744491;
        Sat, 20 Sep 2025 13:39:04 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8a46b2f3405sm304724039f.1.2025.09.20.13.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Sep 2025 13:39:04 -0700 (PDT)
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
Subject: [RFC PATCH v2 09/18] iommu/dma: enable IOMMU_DMA for RISC-V
Date: Sat, 20 Sep 2025 15:38:59 -0500
Message-ID: <20250920203851.2205115-29-ajones@ventanamicro.com>
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

With iommu/riscv driver available we can enable IOMMU_DMA support
for RISC-V architecture.

Signed-off-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 drivers/iommu/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 70d29b14d851..9d8c90690275 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -150,7 +150,7 @@ config OF_IOMMU
 
 # IOMMU-agnostic DMA-mapping layer
 config IOMMU_DMA
-	def_bool ARM64 || X86 || S390
+	def_bool ARM64 || X86 || S390 || RISCV
 	select DMA_OPS_HELPERS
 	select IOMMU_API
 	select IOMMU_IOVA
-- 
2.49.0



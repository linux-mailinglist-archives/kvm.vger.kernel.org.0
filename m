Return-Path: <kvm+bounces-58327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5D82B8D0F8
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 22:40:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D622463DD6
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 20:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D094E2DEA95;
	Sat, 20 Sep 2025 20:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="H03bEKa7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30C22D5408
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 20:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758400744; cv=none; b=broisY99+2PAa+wgDyV2XELDSaNSwWJ6N5XMc8ky/OS7pznprwNiOsBECeWmnbQJFKIs4JPaTIiYSWxtQZ+r5IGbmoA+i6hwDXdaM1Np/+xhPQSMqiY7PebUYP5UpLEjhDJjspB61rlqNRsKh19UkBEPOxR3R6CsNYaQPPv5wVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758400744; c=relaxed/simple;
	bh=EtUHAW01dG26USQdIfV+Yy6SqNqw0Y7AlTfeDTcH4mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmmFDy80G61HWT1tA8mkHECgiIahjr5sUM/dp/7c693oLejBa26vnCTvkk+bTRxf0pPtnbXX2PzD+YBncqDMh1SU0sk+YJIKOw9LtkNElsodKkCxrN5uOULSxL9RuEsWjO3tCY5/3NwPc8U/X+JOXQa68ynQiXz0IaHDjKirQl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=H03bEKa7; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-4103fb72537so28729965ab.0
        for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 13:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1758400742; x=1759005542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l6f7KZQEISNEv2FyFAI35jNTdGKnVk6r1+8ZxOPZeRc=;
        b=H03bEKa7+wBak2rE4vjTjdfS9Hpr+wip98gfNaF7bEfchRBHVc9IPL703PAiYE2qra
         jFzOd0odIkfxZg5kSngmSjoZhJCdVfhez2SuclNpTurODPZ8s9o8eIjpx4qyHAt26JIJ
         +fMwn0r2CulNbtNyugN3ai8firKajuHWxPAKYVTwaf2+IWfvJfooODtZHLGwu/8mCPIS
         mAgZ2l1RuvkazqFT3D+bVibp07rZ0GnsXyM74uz5enTlCSrRX4szbmWGqoh9GPKWcuZB
         U/bM+seeJAUNhKgc3mJebtA2jyNJsNmfEp2SLX3ZnC7BRr0LpNpifPUS9Zvj4Qm/WhOW
         nW0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758400742; x=1759005542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l6f7KZQEISNEv2FyFAI35jNTdGKnVk6r1+8ZxOPZeRc=;
        b=DCG56qvBtlH9BBjGZrFhA7lrWk0qEFtfXLivLYfsUAZzcGZ5r2u3ldyHrbUePW1x+m
         7wSd7kR9/6dK7e9bKYuGmto7lvVsi7tGhAVTGP581wge0/gKcjrXuDlgU3RFkE1tAGRP
         u57Pu9kcS2Enc/3gw/2cpgiQ2U/5WbmIzwVJF2Z2wYaDGQuob31bgmeCpPmfs20fgT0O
         rfS2mos5w3u7A2KCCF5DlRPy8osxirLLUwAVaCVWjh/uIqEBAdYEQVHzNJO5fRXwfYYD
         f85tAOWXwqnL7yXnPwQDWYw+8+zvAE5Vu9P4TTCcDiT8Q3tHDJ65qB70FJS8tW+febpW
         yBZA==
X-Forwarded-Encrypted: i=1; AJvYcCWxjn2wDoWiLsBgz/Jpcxt6QADKXXnM4ZF21HxWsL3Eud08pojJZ9ZUlgiAw6ZwqX6pplo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtA6GSC6FV9Udd2waUHwyCGyOglwP/lHp9NQ4KK/32LFpmH83I
	2+AeSQk/G1/e6gREGybxtWdIYpaFVsJ0QpV9gsxLfoXEf688/tv9yWX1zG/Ajzc56mM=
X-Gm-Gg: ASbGncuOrWAIyBnlLBW3In7YYPAMkYkyw45+gN10/XphytZRNCwr1mVHH9CSS42+mUF
	CLI8CfUA6adOFAByfjhvmtq7pKUr0NGIRgdDqHV9LkjBjHpeXEq6JLEFRY4AORcDP+OJKU3kFLY
	pcVHCEWQERYzoH2NUyXWUEGha3lSlogBCnk4bh1nPcb4W5KgcQfnW2qXllClkWp3uv1jWPHrmi2
	GzWPkmTu7i34tSWOQkofjpZEitVfdtViecYQze7PHdOf2toGJF047OXNeyqfzBrySglPm7wYI6I
	jumDeP6Lu462nEZlIQFCMNj2JyQRtwrCd+kN3aZhjEoJlG8csTlaOme/olYZAam2YR+llkIO55e
	Fzi+liPQ4VZP1y+msM0BD4SYp
X-Google-Smtp-Source: AGHT+IG6qvYE0BGeOGDeP/XzQJiC5ybLNPiJhBG7MlSgnnXrk46BBkVe1V+3lVgHEoHjnN1GIShpVQ==
X-Received: by 2002:a05:6e02:2188:b0:424:8c2d:ca3b with SMTP id e9e14a558f8ab-4248c2dcd57mr47940475ab.28.1758400741904;
        Sat, 20 Sep 2025 13:39:01 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5505433c271sm1648409173.78.2025.09.20.13.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Sep 2025 13:39:01 -0700 (PDT)
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
Subject: [RFC PATCH v2 07/18] iommu/riscv: Export phys_to_ppn and ppn_to_phys
Date: Sat, 20 Sep 2025 15:38:57 -0500
Message-ID: <20250920203851.2205115-27-ajones@ventanamicro.com>
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

The riscv iommu uses a specific set of bits for PPNs (53:10). Export
the translation functions so iommu-ir can use them as well.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 drivers/iommu/riscv/iommu-bits.h |  4 ++++
 drivers/iommu/riscv/iommu.c      | 14 +++++---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/riscv/iommu-bits.h b/drivers/iommu/riscv/iommu-bits.h
index d72b982cf9bf..d3d98dbed709 100644
--- a/drivers/iommu/riscv/iommu-bits.h
+++ b/drivers/iommu/riscv/iommu-bits.h
@@ -36,6 +36,10 @@
 #define RISCV_IOMMU_ATP_PPN_FIELD	GENMASK_ULL(43, 0)
 #define RISCV_IOMMU_ATP_MODE_FIELD	GENMASK_ULL(63, 60)
 
+/* RISC-V IOMMU PPN <> PHYS address conversions, PHYS <=> PPN[53:10] */
+#define riscv_iommu_phys_to_ppn(pa)	(((pa) >> 2) & (((1ULL << 44) - 1) << 10))
+#define riscv_iommu_ppn_to_phys(pn)	(((pn) << 2) & (((1ULL << 44) - 1) << 12))
+
 /* 5.3 IOMMU Capabilities (64bits) */
 #define RISCV_IOMMU_REG_CAPABILITIES		0x0000
 #define RISCV_IOMMU_CAPABILITIES_VERSION	GENMASK_ULL(7, 0)
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 7418e91d8edd..440c3eb6f15a 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -30,10 +30,6 @@
 #define RISCV_IOMMU_DEF_CQ_COUNT	8192
 #define RISCV_IOMMU_DEF_FQ_COUNT	4096
 
-/* RISC-V IOMMU PPN <> PHYS address conversions, PHYS <=> PPN[53:10] */
-#define phys_to_ppn(pa)  (((pa) >> 2) & (((1ULL << 44) - 1) << 10))
-#define ppn_to_phys(pn)	 (((pn) << 2) & (((1ULL << 44) - 1) << 12))
-
 /* IOMMU PSCID allocation namespace. */
 static DEFINE_IDA(riscv_iommu_pscids);
 #define RISCV_IOMMU_MAX_PSCID		(BIT(20) - 1)
@@ -165,7 +161,7 @@ static int riscv_iommu_queue_alloc(struct riscv_iommu_device *iommu,
 	if (!queue->base)
 		return -ENOMEM;
 
-	qb = phys_to_ppn(queue->phys) |
+	qb = riscv_iommu_phys_to_ppn(queue->phys) |
 	     FIELD_PREP(RISCV_IOMMU_QUEUE_LOG2SZ_FIELD, logsz);
 
 	/* Update base register and read back to verify hw accepted our write */
@@ -608,7 +604,7 @@ static struct riscv_iommu_dc *riscv_iommu_get_dc(struct riscv_iommu_device *iomm
 		do {
 			ddt = READ_ONCE(*(unsigned long *)ddtp);
 			if (ddt & RISCV_IOMMU_DDTE_V) {
-				ddtp = __va(ppn_to_phys(ddt));
+				ddtp = __va(riscv_iommu_ppn_to_phys(ddt));
 				break;
 			}
 
@@ -616,7 +612,7 @@ static struct riscv_iommu_dc *riscv_iommu_get_dc(struct riscv_iommu_device *iomm
 			if (!ptr)
 				return NULL;
 
-			new = phys_to_ppn(__pa(ptr)) | RISCV_IOMMU_DDTE_V;
+			new = riscv_iommu_phys_to_ppn(__pa(ptr)) | RISCV_IOMMU_DDTE_V;
 			old = cmpxchg_relaxed((unsigned long *)ddtp, ddt, new);
 
 			if (old == ddt) {
@@ -683,7 +679,7 @@ static int riscv_iommu_iodir_alloc(struct riscv_iommu_device *iommu)
 		if (ddtp & RISCV_IOMMU_DDTP_BUSY)
 			return -EBUSY;
 
-		iommu->ddt_phys = ppn_to_phys(ddtp);
+		iommu->ddt_phys = riscv_iommu_ppn_to_phys(ddtp);
 		if (iommu->ddt_phys)
 			iommu->ddt_root = devm_ioremap(iommu->dev,
 						       iommu->ddt_phys, PAGE_SIZE);
@@ -730,7 +726,7 @@ static int riscv_iommu_iodir_set_mode(struct riscv_iommu_device *iommu,
 	do {
 		rq_ddtp = FIELD_PREP(RISCV_IOMMU_DDTP_IOMMU_MODE, rq_mode);
 		if (rq_mode > RISCV_IOMMU_DDTP_IOMMU_MODE_BARE)
-			rq_ddtp |= phys_to_ppn(iommu->ddt_phys);
+			rq_ddtp |= riscv_iommu_phys_to_ppn(iommu->ddt_phys);
 
 		riscv_iommu_writeq(iommu, RISCV_IOMMU_REG_DDTP, rq_ddtp);
 		ddtp = riscv_iommu_read_ddtp(iommu);
-- 
2.49.0



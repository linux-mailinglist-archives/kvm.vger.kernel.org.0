Return-Path: <kvm+bounces-6019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC7E782A4C5
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 00:15:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A398283BC1
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 23:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F85850266;
	Wed, 10 Jan 2024 23:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="0F98St71"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A334F8AA
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 23:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3608bdb484fso11499095ab.1
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 15:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1704928481; x=1705533281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DpN1MW+95i3F5wasxziCwuSYEcNzMGQOQLUR8+9YpL0=;
        b=0F98St71ILMisMGT6EsMyuiC5F0vqPN8co9EpR+2OW/piJMMgnwqKDyTXQHYHIzK2C
         HswkcuSfpjy3Wj5Mgr7M0NoQpCETx2nT23lVUUpxPyc7KuzJlyxuNAcrasniF3F4SaSQ
         TOCJxYujAlZc5mFSnH0Wspziv4eLUAbNJo5SZylut+rVOBVyJ5OAobJ0F9po9XoNP4Cg
         JwKFqYoVGdFlSq/Py1mAGtVKgIqfBPx/enXVr9gXvS0CozeWsFk8a42FpCYBaOCR5YgY
         HZm1VOilzaD5i/v3hbCYs+C42qiryFfKI0yBgeuQy861Aju4fIY+V7Ye5/F1AyTIiIf6
         yrWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704928481; x=1705533281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DpN1MW+95i3F5wasxziCwuSYEcNzMGQOQLUR8+9YpL0=;
        b=jL7gWj128rlEaiI0YX5THZI0h6jwnEf7/wAWx1Rn0odlzMVdgbCvgxKSv1BDFUSmpD
         v5up4m8D4oaRk+Sc7eU1L1maeRPpen3sKBcoA9q4RfR5BNaLZOeCj48fxj/cSz2eZLtR
         nU6l7xdHpYU8cIiWHRkblGRuHutNz5Ls605JxQUpmitfCVUzFGQ1EJ2xEDLW0CpEFdoi
         srwDY/C+X1WRKImNT7cFJUBHqatxKfde4rnHJ0KdkNpAKJpO5SI7oovypScq3dO8MDHj
         JmuHhQOUHpn+fWpw9qXKL54ZrWVzaQALLK+PamWicgzKPT7mlUwElhSiSrIJr3eVixsH
         +LOg==
X-Gm-Message-State: AOJu0YwFAp3cz3t8xN/7sA+PgQF6vG1EabkO1IDXbQNMGqePVGVPoBBF
	vmPP99fyWJLJ9z5xxTMAZ4FBSDmOTe1hIw==
X-Google-Smtp-Source: AGHT+IEerfI4D/HCt6Wq/EDTg532UTtpPwmlvQqg9CrVuB5160up0pSpFPO/ZG+KXWk1i3x4xdcmZg==
X-Received: by 2002:a05:6e02:180b:b0:360:7947:f14f with SMTP id a11-20020a056e02180b00b003607947f14fmr650893ilv.17.1704928481341;
        Wed, 10 Jan 2024 15:14:41 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id co13-20020a0566383e0d00b0046e3b925818sm1185503jab.37.2024.01.10.15.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 15:14:41 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Anup Patel <anup@brainfault.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@atishpatra.org>,
	Guo Ren <guoren@kernel.org>,
	Icenowy Zheng <uwu@icenowy.me>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>,
	Vladimir Isaev <vladimir.isaev@syntacore.com>
Subject: [v3 02/10] RISC-V: Add FIRMWARE_READ_HI definition
Date: Wed, 10 Jan 2024 15:13:51 -0800
Message-Id: <20240110231359.1239367-3-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240110231359.1239367-1-atishp@rivosinc.com>
References: <20240110231359.1239367-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SBI v2.0 added another function to SBI PMU extension to read
the upper bits of a counter with width larger than XLEN.

Add the definition for that function.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index b6f898c56940..914eacc6ba2e 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -122,6 +122,7 @@ enum sbi_ext_pmu_fid {
 	SBI_EXT_PMU_COUNTER_START,
 	SBI_EXT_PMU_COUNTER_STOP,
 	SBI_EXT_PMU_COUNTER_FW_READ,
+	SBI_EXT_PMU_COUNTER_FW_READ_HI,
 };
 
 union sbi_pmu_ctr_info {
-- 
2.34.1



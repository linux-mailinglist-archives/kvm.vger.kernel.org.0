Return-Path: <kvm+bounces-13430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96E3C896790
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 10:06:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA9DA1C254F3
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 08:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F94473173;
	Wed,  3 Apr 2024 08:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="OdCJtUm/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B85A71737
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 08:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712131522; cv=none; b=FGsJp513zgaxlZqjcCXO4+f3g/AJa8kTTUFF6DSJflI6QOSSlu1jy0uJrUN5jYMOPRvRinwUP6K1N7/GToJmmQZp1/Xy6pDCQXBDvZYAf8Kd2K0mAwz+Xpw2KRvhBjCpxgZAACCbY552B1lDZiQG5kAuG10BXaxct1lg0ScPmVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712131522; c=relaxed/simple;
	bh=IeCUKxpOMKG0zL7LcLS/wH2lWaOxpIfM9zaAAyQj4Uk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xya5kChyoRg+vIdCSsu0Z1V7EdtFd7V4XmvG8OHHsupklM6Cg2fDhoQhI0P1l5g19XtBSqUMwG5krQzwyJds3mh6GgyECFSoXFEzLU1fsrKAXQ74CzSN9FYsv5fO8v3CNugNvHyQuEgA8oXd51YIl+1F47XMOl6Om1Fj10AkHbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=OdCJtUm/; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1e27fadbbe1so10747465ad.1
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 01:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712131520; x=1712736320; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ixjc/2duOe8tMNsDFapztE6WZpMRR0IqMx2Riyo3ljE=;
        b=OdCJtUm/TnCsKRq0tOayzDsxkmSlAE4FjEpJQ8e4FvpENOjnl6jwWVCrlwrgStP4zL
         AKlz3P/CLAem4ptLrNY6j0UaCbQqAbfvKQ6u8qMnfN50cRknOPKxAa6FyBCn5zVQYG1W
         EcMpRnWm2kHkgkpEAHc5xIwmNgVAINAVvJ0g2zxWgw1sfPBOis1sYIQJNdIGQUSadp/F
         2WkDKPYY6YDOwvrioJDD36yGUs0aoegshj5HvZie4Uy3uXFovDk7heQZa4hOJfsWGW20
         e/cWfP2ScDyVwCxu7mAjRNoKhvFrQbfRApoN1NXz/sViPapNAeAhJCBIY9CxfCFtkLtC
         cFFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712131520; x=1712736320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ixjc/2duOe8tMNsDFapztE6WZpMRR0IqMx2Riyo3ljE=;
        b=MDxyroUehPcDYjndrvn4VqtjoRLucj6pTmSIJHUffNZnsMl+8/MXhgUC9j68X0iK0b
         e1RAEUYVyQBp/1U0/4J/uJ3GnPsDeZkOAmOweOjYLbXziZBOBbz5mGeUHLx61mTz/3iO
         TYrEjaES7UgMl2zVXQVMHQ2P0+e0bfEwcf/bv5wUkHX+ClDO/z76mejt2Sx/RlRA2TgW
         yAFANtJ1cvYNPFFkTxNm4xFc61SyjCW8PvRcLZ4/+XTthZdC+xbJpLt/cfgS6sHJFaA4
         4TlLEsoPYv86DApD7K84RhvoXyD2groCNeiFJicKFDdXOfUeAOZLLwe2i6Tas4+qrYii
         AbUw==
X-Forwarded-Encrypted: i=1; AJvYcCUSu5S2LIJqbd/EWBClxrGPGWzCgPkviRVoaRPpXxW4Dyj3EzTqefkKILa3EaQnLbXLEogdxy5j6ZgcyWgoEdbqiH4b
X-Gm-Message-State: AOJu0YwAKG9zOljha562/cVvGM5Zan+SK6aU8MWKOr9sr+9gggpBlJ1I
	XwYbPcmd1yqrr/uZ7W9WEkv3T7gu+p4Ahb47d8hR1F5MrxFjU9wkcuv3c0Jh1MLIrS+ERXp6TgU
	Z
X-Google-Smtp-Source: AGHT+IFNP2TORKh7//FzhNMEZN9MBNitQSqhLOnah919WVqeHY+e2MYv0jsRIRUc8mtVSGHiLEDhcg==
X-Received: by 2002:a17:902:b701:b0:1e0:a1c7:56fd with SMTP id d1-20020a170902b70100b001e0a1c756fdmr13300312pls.61.1712131520248;
        Wed, 03 Apr 2024 01:05:20 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id c12-20020a170902d48c00b001e0b5d49fc7sm12557229plg.161.2024.04.03.01.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 01:05:19 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Ajay Kaher <akaher@vmware.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Alexey Makhalov <amakhalov@vmware.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Juergen Gross <jgross@suse.com>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>,
	virtualization@lists.linux.dev,
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
	Will Deacon <will@kernel.org>,
	x86@kernel.org
Subject: [PATCH v5 04/22] drivers/perf: riscv: Use BIT macro for shifting operations
Date: Wed,  3 Apr 2024 01:04:33 -0700
Message-Id: <20240403080452.1007601-5-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240403080452.1007601-1-atishp@rivosinc.com>
References: <20240403080452.1007601-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is a good practice to use BIT() instead of (1UL << x).
Replace the current usages with BIT().

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 20 ++++++++++----------
 drivers/perf/riscv_pmu_sbi.c |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index ef8311dafb91..4afa2cd01bae 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -233,20 +233,20 @@ enum sbi_pmu_ctr_type {
 #define SBI_PMU_EVENT_IDX_INVALID 0xFFFFFFFF
 
 /* Flags defined for config matching function */
-#define SBI_PMU_CFG_FLAG_SKIP_MATCH	(1 << 0)
-#define SBI_PMU_CFG_FLAG_CLEAR_VALUE	(1 << 1)
-#define SBI_PMU_CFG_FLAG_AUTO_START	(1 << 2)
-#define SBI_PMU_CFG_FLAG_SET_VUINH	(1 << 3)
-#define SBI_PMU_CFG_FLAG_SET_VSINH	(1 << 4)
-#define SBI_PMU_CFG_FLAG_SET_UINH	(1 << 5)
-#define SBI_PMU_CFG_FLAG_SET_SINH	(1 << 6)
-#define SBI_PMU_CFG_FLAG_SET_MINH	(1 << 7)
+#define SBI_PMU_CFG_FLAG_SKIP_MATCH	BIT(0)
+#define SBI_PMU_CFG_FLAG_CLEAR_VALUE	BIT(1)
+#define SBI_PMU_CFG_FLAG_AUTO_START	BIT(2)
+#define SBI_PMU_CFG_FLAG_SET_VUINH	BIT(3)
+#define SBI_PMU_CFG_FLAG_SET_VSINH	BIT(4)
+#define SBI_PMU_CFG_FLAG_SET_UINH	BIT(5)
+#define SBI_PMU_CFG_FLAG_SET_SINH	BIT(6)
+#define SBI_PMU_CFG_FLAG_SET_MINH	BIT(7)
 
 /* Flags defined for counter start function */
-#define SBI_PMU_START_FLAG_SET_INIT_VALUE (1 << 0)
+#define SBI_PMU_START_FLAG_SET_INIT_VALUE BIT(0)
 
 /* Flags defined for counter stop function */
-#define SBI_PMU_STOP_FLAG_RESET (1 << 0)
+#define SBI_PMU_STOP_FLAG_RESET BIT(0)
 
 enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE = 0,
diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index babf1b9a4dbe..a83ae82301e3 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -386,7 +386,7 @@ static int pmu_sbi_ctr_get_idx(struct perf_event *event)
 			cmask = 1;
 		} else if (event->attr.config == PERF_COUNT_HW_INSTRUCTIONS) {
 			cflags |= SBI_PMU_CFG_FLAG_SKIP_MATCH;
-			cmask = 1UL << (CSR_INSTRET - CSR_CYCLE);
+			cmask = BIT(CSR_INSTRET - CSR_CYCLE);
 		}
 	}
 
-- 
2.34.1



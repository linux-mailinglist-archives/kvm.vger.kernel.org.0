Return-Path: <kvm+bounces-10323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BFB086BDE0
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 02:05:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA973282F29
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 01:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 229C04597B;
	Thu, 29 Feb 2024 01:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="TXZg5mP1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99ABD3BBE8
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 01:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709168509; cv=none; b=DilCTpi8f0wQV1k1yQRESbDSFF3yMh9RBbg6f6UJrCZi6vUFMYzw4YTQzyVfC+Sd3c854ZXI4ab4Ghdlw5bpsGG664R8L6m4T1F9tGgW8z478CyycYCnxOp4Kg61F/zZk8z+T65I4YB/9mwQxzClpZn9CONoO8dT/r3ob6UhZA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709168509; c=relaxed/simple;
	bh=ULMcUPZgsZy5s7AHs7JS+lYRRb/s3cg5atfyscwS9oY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Nq5OWivymA4tDCVmRAsDG5+QxOKeyWump0UcjcOeRb0G6tFeW+2gz3tFp/jJPMx5ANCMO67Kla1w+M/4K2NW9YYLiPtgmMVqGEoyGzUJUowD3b2os2IJFfg+lvDTknlIGVUnvoQUR9cDobNNMEa3wZaK5JfU4RoOIzzYyOlr9+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=TXZg5mP1; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1d94b222a3aso4445445ad.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 17:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1709168507; x=1709773307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y/Smp2oLhuu6GIJFXbIgbmjKI2p4Ava6d/2TN1s81h4=;
        b=TXZg5mP1FfuLO7QKPhZqp+oSPbiF/LglTSMIASd5Brt3EVGf2DhuG4XPx9mGPhfANy
         jJoCmxF6lzwmDtnsMd1hZhuRjaFLixCGCbE2+tytWbLBFi5SRw/DlKoWZOcqZ7ypDVmY
         at09iGenFM4nRhKY1Ey/KioH9Tb0ytPG6WuVnk2dulOZe+LhSktQD2tyq8f4H6EFpArh
         YS9HlVH+eGVOSdFXi7YqemkUEcxLyfiXLVsOgOFfxQGAbjX1SUJUe0lP73VON5iUnFpk
         QMIPLjOXOJotodqFJ6RIcFfG788+5EndhVEXo+dDrWjCuWtrBkjysDu00rBWuN88jsTd
         Ayuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709168507; x=1709773307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y/Smp2oLhuu6GIJFXbIgbmjKI2p4Ava6d/2TN1s81h4=;
        b=I3Ud/Za97UQz3VLz5pceGS/lnJ2BIrmRYOZQqvLtnoFH7WgAM3nxXKhbecccFKOkg0
         qAFfhpNOIy4IumpgDoNlFBBhIO0pLDYElYpZRIdmaL9g28IcpP99Filr47i+L7Wyp/k1
         7CIOLvS3a5+oiiGfDAs/Kqz4bVaNkUomvRRFYM+pBBLpRb1wEnr8SI+rDXGhJc1PkX/U
         Au5NQ5T4IM8Y18YPzTLl+jsa39mNaetsc3l/KQnWZszgXUUgkynBmHLaSWdvm6T5+X18
         JO+JrUB8rjb/6r3O9Mm5qYPtN9t7BSz0PKqSfHRmNh2AIrNiiRvNcaSKO82VlhYK7ASD
         XmnA==
X-Forwarded-Encrypted: i=1; AJvYcCUm/+dE9dGWijdGKHme0d0WSYPNHw2t52S+NfqJnyRVzmuKt/3TIdIubtppygffbs0m9Ui4DO8c+9qU8Xz5eoqYRoSg
X-Gm-Message-State: AOJu0Yx8vYJGJ9XMxQjdim2evSLSTkw40nid5yy9C821QfOPXGok6O8n
	rhfBREHLg1gMBJHwlyWC7Bsubv3xi3rQzhyNjjhIwF2S12en/7Bt8P6HchTl/53mboKNq5tqJHg
	g
X-Google-Smtp-Source: AGHT+IEZMqLInCQx07S+Rn3WGEj/67sJxXqMLsPFvU4OeQFWJPIk5NjjGR/a40uVdCrM5KTE7F+2QQ==
X-Received: by 2002:a17:902:ecc9:b0:1dc:a60f:4bef with SMTP id a9-20020a170902ecc900b001dca60f4befmr636692plh.63.1709168506981;
        Wed, 28 Feb 2024 17:01:46 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id j14-20020a170902da8e00b001dc8d6a9d40sm78043plx.144.2024.02.28.17.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 17:01:46 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@atishpatra.org>,
	Guo Ren <guoren@kernel.org>,
	Icenowy Zheng <uwu@icenowy.me>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v4 03/15] drivers/perf: riscv: Read upper bits of a firmware counter
Date: Wed, 28 Feb 2024 17:01:18 -0800
Message-Id: <20240229010130.1380926-4-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229010130.1380926-1-atishp@rivosinc.com>
References: <20240229010130.1380926-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SBI v2.0 introduced a explicit function to read the upper 32 bits
for any firmwar counter width that is longer than 32bits.
This is only applicable for RV32 where firmware counter can be
64 bit.

Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 16acd4dcdb96..ea0fdb589f0d 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -35,6 +35,8 @@
 PMU_FORMAT_ATTR(event, "config:0-47");
 PMU_FORMAT_ATTR(firmware, "config:63");
 
+static bool sbi_v2_available;
+
 static struct attribute *riscv_arch_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_firmware.attr,
@@ -488,16 +490,23 @@ static u64 pmu_sbi_ctr_read(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 	struct sbiret ret;
-	union sbi_pmu_ctr_info info;
 	u64 val = 0;
+	union sbi_pmu_ctr_info info = pmu_ctr_list[idx];
 
 	if (pmu_sbi_is_fw_event(event)) {
 		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ,
 				hwc->idx, 0, 0, 0, 0, 0);
-		if (!ret.error)
-			val = ret.value;
+		if (ret.error)
+			return 0;
+
+		val = ret.value;
+		if (IS_ENABLED(CONFIG_32BIT) && sbi_v2_available && info.width >= 32) {
+			ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ_HI,
+					hwc->idx, 0, 0, 0, 0, 0);
+			if (!ret.error)
+				val |= ((u64)ret.value << 32);
+		}
 	} else {
-		info = pmu_ctr_list[idx];
 		val = riscv_pmu_ctr_read_csr(info.csr);
 		if (IS_ENABLED(CONFIG_32BIT))
 			val = ((u64)riscv_pmu_ctr_read_csr(info.csr + 0x80)) << 31 | val;
@@ -1108,6 +1117,9 @@ static int __init pmu_sbi_devinit(void)
 		return 0;
 	}
 
+	if (sbi_spec_version >= sbi_mk_version(2, 0))
+		sbi_v2_available = true;
+
 	ret = cpuhp_setup_state_multi(CPUHP_AP_PERF_RISCV_STARTING,
 				      "perf/riscv/pmu:starting",
 				      pmu_sbi_starting_cpu, pmu_sbi_dying_cpu);
-- 
2.34.1



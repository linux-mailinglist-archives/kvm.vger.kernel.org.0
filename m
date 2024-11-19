Return-Path: <kvm+bounces-32093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1496D9D2F71
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 21:31:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54330B24DF3
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 20:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02A901D3560;
	Tue, 19 Nov 2024 20:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="o0xsLxbk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174901D2716
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 20:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732048252; cv=none; b=iPMsI7ysD5ELZwLTY9Ua4ZUr0iE7J3+xyP3o6hw7bRd4H4GN8BlFIeZWfqstOG7DPXUVhvSdptGojSz3Ft8olx2gPD5vpNaVlfnHLvmGeUv2NkDMe+Q2YuzKM57UiHUh6npOD4W0Y8CSFBNSioRCR88PmPuCbfA4EEBrc+DEk6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732048252; c=relaxed/simple;
	bh=9a3a2dykXm+Z1VuOIzXUUFPIUB4KYnT3BbloIfBYDqg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WEUtAcDEu1jhwmW4Iu0fDwfR0XJ0gciGmDb3T8dZ/KPz7Mk4n7wdCOtuOfO8zxcZ55n8ZOv9tW768t9vL0o9W0tHvz61BIhcNm+G3REeFBtnPSIRaN3w36Ux6c5Cmze1PpqZbVWdiXcRAPE1eyR9KRiAHNPieUsGxilGrOERAC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=o0xsLxbk; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ea49a1b4c8so2332712a91.2
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 12:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732048250; x=1732653050; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2qPwdXgi93D1Fj1M3CTUmRPQX23R+cN6bIgDXtW8EzY=;
        b=o0xsLxbkhLJ21l87Ve0dLhopPiU/2eKj5rUKGEmqAsKjm7Mklrfr3qPEAJ8B7zjOl5
         f3t0oJdnWna2iun7jK8a+iVMfFzLROCO+Gpq2c1aFOEWtf6xIMViwMoYystcsNSy3B7w
         5OVyohRwrKCXkAcSjCeEmFw/TNuAWGzZ5bJ6fz88salWfutHIM6GwYIoC8cN32WtVYr6
         B+FyKLIHS0cmylE1ND4Ruso8YkixxR0SP4GAwl2XUpEjyofzmqrVlzx7A2CK8KNtxjw0
         7AKuQMLuC/VpDm3gWz23i5llqaA3wngwXusqimS5KDHnQIDzWaSWDbQqK4WbDPTZtvu3
         PTAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732048250; x=1732653050;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2qPwdXgi93D1Fj1M3CTUmRPQX23R+cN6bIgDXtW8EzY=;
        b=iOEIF/3YOHb0o6oWXQd92oIVaqnl2mYiP3J8g+lDTtVpt65335scLBCp5sc8GwzP4g
         3+Ushbz/lrc82bA2twpL9OsJ4RH6FAPrfIDl4ABAh005tTbJFSZXMUV7smRy4GOLdeeQ
         e5yl7Rw+YgcHjML+UuFomgKVJITSgUAfbQk6LLn6Xlf7WaQinaNH57YehwtOJtltpv9r
         d7swZ4b5VFtVI3SeQjuop1BKn5rNZ6fZ3S1oSf3A/1p8Lb/vtC+MZSWtlQBZ9RwIgEwE
         nglMm3qnOrph+QXrx1z51gQaQkjrf7bxSvnxPZC16sq6zosJcYsvZXmPV7J+ydpRh94J
         BZjg==
X-Forwarded-Encrypted: i=1; AJvYcCWcr8sg57qPVmwpHYBhyJGkQDFStwOLotXzcFctQsCNJthF7ROqJW0eSZOSFxSfG8KXCHU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTD5RjdTH2g4aHxVGRsIJr9ucJQX100Mn0NGZCrylxVB316/yJ
	64tH4pwiXgsB/dhG0JYo9NxhnFqMGl8InUdPYO9vMrk2usPedzL+dFo+RdMA/TU=
X-Google-Smtp-Source: AGHT+IHGbLa6SegMg+6UWCLGuDz+AC9C3f5G3GHUQKuYncIbocwbfU1Y52MRciljHs7ffGD0KEce3w==
X-Received: by 2002:a17:90b:288e:b0:2ea:37b4:5373 with SMTP id 98e67ed59e1d1-2eaca70abedmr135913a91.10.1732048250306;
        Tue, 19 Nov 2024 12:30:50 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f34f2fsm79001315ad.159.2024.11.19.12.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 12:30:50 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 19 Nov 2024 12:29:49 -0800
Subject: [PATCH 1/8] drivers/perf: riscv: Add SBI v3.0 flag
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241119-pmu_event_info-v1-1-a4f9691421f8@rivosinc.com>
References: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
In-Reply-To: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

There are new PMU related features introduced in SBI v3.0.
1. Raw Event v2 which allows mhpmeventX value to be 56 bit wide.
2. Get Event info function to do a bulk query at one shot.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 391ca1422cae..cb98efa9b106 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -63,6 +63,7 @@ PMU_FORMAT_ATTR(event, "config:0-47");
 PMU_FORMAT_ATTR(firmware, "config:62-63");
 
 static bool sbi_v2_available;
+static bool sbi_v3_available;
 static DEFINE_STATIC_KEY_FALSE(sbi_pmu_snapshot_available);
 #define sbi_pmu_snapshot_available() \
 	static_branch_unlikely(&sbi_pmu_snapshot_available)
@@ -1450,6 +1451,9 @@ static int __init pmu_sbi_devinit(void)
 	if (sbi_spec_version >= sbi_mk_version(2, 0))
 		sbi_v2_available = true;
 
+	if (sbi_spec_version >= sbi_mk_version(3, 0))
+		sbi_v3_available = true;
+
 	ret = cpuhp_setup_state_multi(CPUHP_AP_PERF_RISCV_STARTING,
 				      "perf/riscv/pmu:starting",
 				      pmu_sbi_starting_cpu, pmu_sbi_dying_cpu);

-- 
2.34.1



Return-Path: <kvm+bounces-3439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7903880453A
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 03:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9E741C20B91
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 02:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2271E945F;
	Tue,  5 Dec 2023 02:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="FKH1Gs8B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1C8138
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 18:43:38 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id 46e09a7af769-6d87a83ec27so1843975a34.2
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 18:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1701744217; x=1702349017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezsx5Eqv7C1IIJcHeXVdQzYdP4PWuNbr/jfR9i9uc+E=;
        b=FKH1Gs8B1mqIu9eyoVmvKmmrtqbDrYKlv0vtgXtIxQJmNTeb5piflB3M9hRwo3r1JC
         f51kFxYpLx505XbsNejjSN353ZLlwQ5IMt4KqnW88yHFpPFGjYD9q5JhwfJyW9LZAmvK
         6MSHbLFY5h4lk8taYY7dpw9CIDzsnMSKAMzKUJELD8k6JBkxkFffrCcruEh6kSlV4/1c
         Q3fxN3Gxm8XhgmVm3MFbDqqYWGsSdXZLH5/1aRmE8aHqhW2eiCmS0FfOfG+HC0hmkgB6
         r37cx5zgfhxlDkX9137V+0E4O+NIqXJpFmWBAkamHiYP6oFAEZpZ25ezg16xC7ADMznH
         xKSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701744217; x=1702349017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ezsx5Eqv7C1IIJcHeXVdQzYdP4PWuNbr/jfR9i9uc+E=;
        b=Xz83Kow3qSzAbexJWEkTi9znA6XklOhTMtPXIImap0TGgISFhJ/4zCcHve3r0f87UL
         HbAML4nyulOPr1pejW5B0ptZuZg5ZoHKp7Ev4mZGW6z963P79CSE+R+xCrr0FVB1vIuF
         Si4NPRxK0OxLoAmMd8MXDnTG1GM0njWUuTUOyM+hb0tI1295vVzOCD6d59elIpZZ6u/S
         8EpOlhi7GGsv7laB+iXpsUtsSvXb5fJIfSMi+KZvdC4Sty3eXKXlKTqm8JTmyMyrFJv/
         XVCQx2oHG3zpLmaHXmch9aU8zmKYSUCT9mMhuPVr6DGwFh97DXM7+3WY7LE+xGEstgCN
         Nesw==
X-Gm-Message-State: AOJu0YyK9J5cFkWz8XEVIMiuwU3MCd4xuzcvEcWd6r1bTwM4ZTSzsNeu
	6HnNVQrrBG8T1TS/Kl9BYLdPHw==
X-Google-Smtp-Source: AGHT+IF8HbmBfGcwhzrY8QgNBoAV0D9dftfiztmlrc9uBoUNExR6eq192ybD6wyNke0oHa4GT14FGA==
X-Received: by 2002:a9d:6398:0:b0:6d9:a17c:237 with SMTP id w24-20020a9d6398000000b006d9a17c0237mr2375646otk.23.1701744217652;
        Mon, 04 Dec 2023 18:43:37 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id z17-20020a9d62d1000000b006b9848f8aa7sm2157655otk.45.2023.12.04.18.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 18:43:37 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Guo Ren <guoren@kernel.org>,
	Icenowy Zheng <uwu@icenowy.me>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>
Subject: [RFC 4/9] drivers/perf: riscv: Read upper bits of a firmware counter
Date: Mon,  4 Dec 2023 18:43:05 -0800
Message-Id: <20231205024310.1593100-5-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231205024310.1593100-1-atishp@rivosinc.com>
References: <20231205024310.1593100-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SBI v2.0 introduced a explicit function to read the upper bits
for any firmwar counter width that is longer than XLEN. Currently,
this is only applicable for RV32 where firmware counter can be
64 bit.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 40a335350d08..1c9049e6b574 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -490,16 +490,23 @@ static u64 pmu_sbi_ctr_read(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 	struct sbiret ret;
-	union sbi_pmu_ctr_info info;
 	u64 val = 0;
+	union sbi_pmu_ctr_info info = pmu_ctr_list[idx];
 
 	if (pmu_sbi_is_fw_event(event)) {
 		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ,
 				hwc->idx, 0, 0, 0, 0, 0);
 		if (!ret.error)
 			val = ret.value;
+#if defined(CONFIG_32BIT)
+		if (sbi_v2_available && info.width >= 32) {
+			ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ_HI,
+					hwc->idx, 0, 0, 0, 0, 0);
+			if (!ret.error)
+				val = val | ((u64)ret.value << 32);
+		}
+#endif
 	} else {
-		info = pmu_ctr_list[idx];
 		val = riscv_pmu_ctr_read_csr(info.csr);
 		if (IS_ENABLED(CONFIG_32BIT))
 			val = ((u64)riscv_pmu_ctr_read_csr(info.csr + 0x80)) << 31 | val;
-- 
2.34.1



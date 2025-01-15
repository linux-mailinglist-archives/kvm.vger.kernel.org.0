Return-Path: <kvm+bounces-35587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 81633A12AE5
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 19:31:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0F7A1889898
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 18:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B681D7E2F;
	Wed, 15 Jan 2025 18:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="XYRyoTc2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3191D5CD6
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 18:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736965860; cv=none; b=FLMrcnjR1yqlk4E+r+4kMRTQdD9gryjhXvOAqwDD6zoJLkIk9F2e3sfZ8liT8zmLsA3TM861OUrVhFCVYfOASW4s6oZsjpZy0dGDq8/7rYG38c4KcpSzA296zwgtkvAw4XaB1hL0pOs6r8yy92PaUtBwbrP5Gqd8PZ6Xkqae+VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736965860; c=relaxed/simple;
	bh=IRi8vvVbX7RcsNkx4/mfVGVQ/4HYTvSqhjj1SdFdZyI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kZbqqpD4UWGO1cncyX2xVG/XV98yUotaySgtQlzcOTHgODVZ2vF287rY+nT58+u9xq8XmUF6e+QJlWLB6aM+vDLaT++auH8qSfQOJJ4ButSCuHID/R48jNLMtMb/mk6dOGLQJcQBd2kjYsfWsk2l5OjN7/48eIpKb+YdzyaICeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=XYRyoTc2; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2167141dfa1so1960975ad.1
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 10:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736965856; x=1737570656; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R6MbfDRCc6A6mGBsw+fhL6wjTkBIFejSaI+SDSiajdA=;
        b=XYRyoTc2U8kV4DIQcSsbHRuVZPEJ7XTXlz4mBbp3Fe1SPyY6O0kGMB5VeLH9eKXtUT
         9i5XEXFAsXkRUiEMP3p16BXz6nNmtaD/nxy4G7+5B/fmd1zR2jDj7Ni0L1k7yoOCkWwI
         9hPpPwDYTLKVGxnTAM+PymX/NcU5SsPAAxWh1yCLPL8EDJUFutiWWpD4Z/4yiCDtcN63
         HlDlpn3sES4CNQIEfc0KnYFPiNDGh2SY4c/EOBW1Ar3jrMDa1s0F8MSQ/rqjBsZYfpYS
         fV/kv1zYSL0nkEc6NlhI/WfHHTYtF+QYosqDvaL4ELWCcXq6JOr/HABfrB23SpJpryHf
         sFvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736965856; x=1737570656;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R6MbfDRCc6A6mGBsw+fhL6wjTkBIFejSaI+SDSiajdA=;
        b=Mu4S9hWd+jLczTbnNbIX/aKRzZkzPhwWzLmfOYfUARyp90OM7Mjf5fUljlQ7/WZaDX
         fVgToSpQw/rIDMqfweM2SsTA49u6OpwP+5r2AEct2NNKTgNnlpa2YMtHOkV2rQQTjn0G
         SVpDva/O/ukKVmQTn/QUv5artXmzwwIWoZlEhSOwR2TMcWJa766IlJHPPT5q3hCfOomO
         2rbAETb4kynKmfxaVaQ85A1iALBO4Dbe2MZlqspe2jkFZumab4aE387zmnY6SRsGpgx+
         fcGIYtfbd+kqIi4zrTHAPafkkkfAhnmhjt20ERC1bT+qhQmoK/gmAYdL8gdmat85O8+N
         0fcw==
X-Forwarded-Encrypted: i=1; AJvYcCUl/SwroIZxnsnBjmcNQR+iKC7fWSdtA/roLcdPeNZKHRYKOym31xcJkiQVFcbqoLMTekg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8uOW+34oyCYtq1NEgxau35AsITfVHS9bikdbFS0jRHsbR5kNE
	hABY31WxFMW4ADF0EAjNdZ2oUTQoNxOuTnL302YxG5YCKYX6BZ/1pXh+meJVeNo=
X-Gm-Gg: ASbGncsfgOJFF0IXBHposB0gmUZU36hQEYzDlrGfzkVDGnbqOSKrCUIHJZ8NSDIulao
	Hqxy+OG0lCVlSFYa8VMfb+0wTTjtCHBKi9SIc56x7+KBnWMk5YjVNaC3HXFMPOyWqV/6WoW88SA
	rhgPIt4V/uqTcrcPoJQhx55RAvZCKvlg2BikVhHHpOFLxA5hfi8pZpXMYmNgjPkD/bNk+Td3kg1
	f+Az/GexRg6KL1YL5IBUQgUQ2E2HNOm81UQ+9COQsZgE2Hgu81VOyLRvtOVRPqE3x/sTg==
X-Google-Smtp-Source: AGHT+IGH5/giAEf8Q/ecUlIbOiNlBZurjf3IoH6KsqiI1EGl06ksaFaVD7yVqQ1dvhjlbV18FEvXig==
X-Received: by 2002:a17:902:c40b:b0:215:ba2b:cd55 with SMTP id d9443c01a7336-21bf0b76a12mr58588755ad.2.1736965856596;
        Wed, 15 Jan 2025 10:30:56 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f219f0dsm85333195ad.139.2025.01.15.10.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 10:30:56 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 15 Jan 2025 10:30:41 -0800
Subject: [PATCH v2 1/9] drivers/perf: riscv: Add SBI v3.0 flag
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250115-pmu_event_info-v2-1-84815b70383b@rivosinc.com>
References: <20250115-pmu_event_info-v2-0-84815b70383b@rivosinc.com>
In-Reply-To: <20250115-pmu_event_info-v2-0-84815b70383b@rivosinc.com>
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
index 194c153e5d71..170aa93106b9 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -63,6 +63,7 @@ PMU_FORMAT_ATTR(event, "config:0-47");
 PMU_FORMAT_ATTR(firmware, "config:62-63");
 
 static bool sbi_v2_available;
+static bool sbi_v3_available;
 static DEFINE_STATIC_KEY_FALSE(sbi_pmu_snapshot_available);
 #define sbi_pmu_snapshot_available() \
 	static_branch_unlikely(&sbi_pmu_snapshot_available)
@@ -1452,6 +1453,9 @@ static int __init pmu_sbi_devinit(void)
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



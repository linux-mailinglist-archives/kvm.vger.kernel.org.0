Return-Path: <kvm+bounces-53055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB320B0D01B
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:15:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0782B3A596B
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 03:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B8928C2BB;
	Tue, 22 Jul 2025 03:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="cxOpbG6o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9BE28B406
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 03:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753154128; cv=none; b=dmt5DBSFP4/W+ijrT16MPTXP121s3kK4tM+zOVfDYTaAv3KTl67cgOxyB2qTq5C7HAjutEy6UwVDn4ZoG5g64SKAEdLKs6BqTBx3R/su1rvQxZL7hhr3IVVp8uBBjbk7BJgd2n1ZNdGRZAGSnxSOr/3Ct61eur2zpHzznDJ/XfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753154128; c=relaxed/simple;
	bh=m2E8W7DiSx6Ltrasj+rnR9WEkMr09MKsEoyxo0F+Klg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kLHpOj1i99VV4520Z0yRAhE+hoRiIxhyjYCJxZHxZ5oBEqfD8xhrPLtKuGm784wYbZKCYrSMnlxG6B3RSl4+Y93e4nloWQLFJR/sANR2O1j52+CenZdp/qrMs3uXH0cTIQ4OSJteXRIbuoMJJKBDCamMVW8zJphc7C7cYRMUFAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=cxOpbG6o; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-748d982e97cso4472695b3a.1
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 20:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753154126; x=1753758926; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QppemwXg72umVaHol/lc8lTgDOnrssZANvnDyByXBzA=;
        b=cxOpbG6opvR+8IuaxkxL2yUWP/SmqzCtnL0uJLzhO9ngBg4TPwHd307T/KZgGzxLHx
         0HhzDt915bdN7Xnx3H4TljgciT96Iz5JYgDsG01mqC5gzID2si6wqzI05BDwy1zCwXDT
         xhjok01RlUUo2tSU67j1ncR8TkNx1UW8MtKt41qsM/QAYgKXmBBZgOSFQGA6YRjSwo7v
         wpHGlix7+fJ/jBxVnT6HOvm9fdspIsFZjnrXfQ0vHs0nSZh0EmmGNuNbopSYtcRZx+4X
         yPev6AhsOOtMzOUNwOSut5tVsSqBNj8ZS3gxpWD60q4NgbhmUEDNlBPBeEj66+YYRyAK
         iJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753154126; x=1753758926;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QppemwXg72umVaHol/lc8lTgDOnrssZANvnDyByXBzA=;
        b=squrxEnUj0o2+Q9i0IJtvG56S92Bv+r07JzTx3OjA1ACIEkP8R9q+TwP+IXni+hG4S
         5g3Xfu7g6lQmgpORICDBfa/OzMHmx9HgMJTNIC8uOHr2FVStTwMyGH9penS28diJAo9k
         o6Q1dJ+hZrdrpRJ7U19y/Q64eE2/J74Eav6KJS0EXBHhUvTn0yugdnA7LAB6jEEcA3m6
         8HYROfWtQeeXmLT/uJ5m2lrAs4bS71TwAjl0ygvmiCrhyDM50r1BkyGRjM0MNegu6742
         PLpgU/k80UGn9+1ZA6EkTmqs0M1ImJ4T9xvovbT+aiOG1JBwwQUunIX1AbITI4hWv7d5
         amKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCdXi5ClMAb5jcFKtejpf1rIQ4NsqKtLIasj0wIwUqfvRREmSMGhFZeUZmKmWDddUZc+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyobUwr9d3G9bsqO4UpYNy8hV/kusi49t2Rj4AL6c8N7owY2hO
	jlPpyjo/1ZlvpUpB8lkXLPr2pTQTV03RecMhc/OXHxbo56n8bXSMsOc8n+W2etRJ/pc=
X-Gm-Gg: ASbGnctE+jkCuCKM2EXWvKyWDGO/MKPNZ+lLErzEeatb+SdCXZ1rQWEp1j5nEqlyepW
	q/UUbjbq8Hqaa2l1eX6/4Ctesw9HY6m3fSNVnKUYOVPpzz8SDdzdBONeUEqsYrZlGgjG0OoEnyz
	MPG4mMFbMVx/wWqfMuiVYOPQfZgqTVDqCh75RQZc7cSzK2H4OK+ovR82g9yvTOYr1mWIzC+rsks
	YfNnFChponBmXxaj0yCszPYVDZS3N4GUIPSoOPoucBUiG2Hn2/zqHCwXHvhflyxi3ugdiVy96xg
	InDzehcss6Y7b7PNwR8d7jKyQ8lDFhme6M3o+r0Q9hb1TU70f+qtKHudlbdm6HqbwwpgOet10p1
	tV/gZJLELb4nelAaJLDn89Bf/LeNfftUY8PY=
X-Google-Smtp-Source: AGHT+IFGWxj3iUKxSSdZKPT9lOfiDcRTnkWskcnNV9b0jBWk2yItlB0Jg7U1GDfAal+i2ahxkqkLKQ==
X-Received: by 2002:a05:6a21:6daa:b0:1f5:8a1d:3904 with SMTP id adf61e73a8af0-23810b4dd3dmr37662781637.7.1753154126114;
        Mon, 21 Jul 2025 20:15:26 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2feac065sm6027612a12.33.2025.07.21.20.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 20:15:25 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 21 Jul 2025 20:15:17 -0700
Subject: [PATCH v4 1/9] drivers/perf: riscv: Add SBI v3.0 flag
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-pmu_event_info-v4-1-ac76758a4269@rivosinc.com>
References: <20250721-pmu_event_info-v4-0-ac76758a4269@rivosinc.com>
In-Reply-To: <20250721-pmu_event_info-v4-0-ac76758a4269@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

There are new PMU related features introduced in SBI v3.0.
1. Raw Event v2 which allows mhpmeventX value to be 56 bit wide.
2. Get Event info function to do a bulk query at one shot.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 698de8ddf895..cfd6946fca42 100644
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
2.43.0



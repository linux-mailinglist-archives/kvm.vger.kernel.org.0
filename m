Return-Path: <kvm+bounces-57054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 912D3B4A2DA
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:03:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39EB516AF8B
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 07:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3EAC306D2A;
	Tue,  9 Sep 2025 07:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="VoVuFYPM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6665A3019B3
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 07:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757401407; cv=none; b=P8j+wAAQqi+yUCALwL2dTtnIS9oNqHGX4rntw5QeujaxKTztYD86PKNuNZ7UNW6XZq4/Y7x+X0SqB63oZUkUhx9skTqTR9CwHNquNi27Ouz1dpTvKTzHmFXDzOZfsgjOoK1/ErMC3POVndYUcwn4VeTadwtzZet2YYNcYtE84xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757401407; c=relaxed/simple;
	bh=m2E8W7DiSx6Ltrasj+rnR9WEkMr09MKsEoyxo0F+Klg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uV0KsO9OSseOY83hTCAf4wBiJAA8ZR86winlqlPSSN+kudZAyD9dOR/EbZD121js7Gj9fJgoIo9i7DyaXTEl6jCLrpfhZSIxnlWE/3lhX0QGg23A2jyy2QwJZ44JIwNf2uMIqpG5u3jh0NNFfFSP+13w8JIrrmnlDfkfggXd31E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=VoVuFYPM; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-77238cb3cbbso5517007b3a.0
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 00:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1757401406; x=1758006206; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QppemwXg72umVaHol/lc8lTgDOnrssZANvnDyByXBzA=;
        b=VoVuFYPMGG7mF6nKhQqKrHMYMOIktE34kOU97h38mZSiLfPSc6hA5CD2IfnxEdQZNr
         4FZxCHIgMnW5fyPmUGx4tYQ0WhZ6eCeMB+FbMCq12p1+MuTvi+Yv8nonOXkq4WiPvYWs
         EOJ5Gvk9o+ONJqH4heQLAJduA/8ZxP/Kcc2gmepDGq5CL16gJfpeGsao4u2OfwtZjqle
         YJQztVnhN3ESQKULvNTNSOU/pbnYIX5XIY2fEQUU1vTJVS6mN4ilasSa9qPnn50EAuim
         ko7+k/dnMdZU9BdYVQmeutlSGeajiFIcLfsZWCRW6rMP62RSOqI5Avm6hf9E0IZP3G+9
         kZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757401406; x=1758006206;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QppemwXg72umVaHol/lc8lTgDOnrssZANvnDyByXBzA=;
        b=DLpV7UYoiY8m+uG9x2Cccrioup1E1R+upvovMfzyPlwy9SCD6eIXOyHLPPAgCZJZFJ
         tBBctdmVUIL2LyDpfGu2Is96K1Mo9e1HOqC5PhccwjXEpCOAYzgVslVEbqyNQIM5lnS6
         DgUGyOCcIXlSLxT0TzovgJdIH8YO3v6rmZNpZkN3EKLKW75A6SILB/kBn52/N4PtWttg
         bUkc7tpiiw9ezCp4kEIs0Zck44NGOwI0+L0oW1sxJ8MjOLcINSlRA0dF8Gm0Z8Mb/FKZ
         Eoo9CN8osgpkEk3cMI/iRPqrpBaXZV+WP+ulnVDUegQWskDD0H4RIM82wUG/ilOdUQoX
         dmmA==
X-Forwarded-Encrypted: i=1; AJvYcCVWZEARKPvTBkfHmNzqX9DIRjp3+LL7igC8PaCgrYFgfx2Wm86KZ4Y90OfR27BUpcaOAVo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXUB86HQ0bU7LP1uE5QQ2YnxaXRjjBg6S8HOOoa3LDfZUVERya
	i+tQPbmTAeEVBMytAnDdmoUKWtrgRqDXG5dTJjDGQUspfUzRjC51ren4rAbQyu81LIw=
X-Gm-Gg: ASbGncvtwQFpPHnbmWDKEJdujq8Tny3xE7WVcoRYECPw0ZZ9SQ+918UbTD2l6qzJ0uT
	unLrx7rMAWFX6kuaE23u9GyoYTAq7zfUdyZVHF7nMZsImwKKAGkNfdXdqa0xYXFXzopETRlIxjU
	jogENK3clgUjhpxFlEqZ5WuM/6bvBlpTmPH4qUxRCLXovp9oM0Tvgk6qbGOyGxtKyZORnjTNEsg
	4RGWU+QzWbvMLjkCtuJlB+jqrvqgY2SGBc9oEUo2g9w9dhTIR3yK+mWx5WOBYVg0Y0GUlQc1L2U
	N48VO4rrUMr/ERz+t+Fi3tFRV6xgrNDjlmY32w5S5RWy8jXR7tvgczplmeq85yumDY+Ivjp2g/g
	ljBt2gg/a2f/w8/Mu4FLEAOlNlC4w8E6ipSs=
X-Google-Smtp-Source: AGHT+IGTI0+CANiAOY9dQTvuxmq7UvW41+dk3xf0GTORfOZzG86GOBRQUviZ8wH9nFVkT6u1ya+N/Q==
X-Received: by 2002:a05:6a00:928c:b0:772:4b05:789e with SMTP id d2e1a72fcca58-7742ddadae6mr13433332b3a.2.1757401405716;
        Tue, 09 Sep 2025 00:03:25 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-774662c7158sm1025535b3a.72.2025.09.09.00.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 00:03:25 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 09 Sep 2025 00:03:20 -0700
Subject: [PATCH v6 1/8] drivers/perf: riscv: Add SBI v3.0 flag
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-pmu_event_info-v6-1-d8f80cacb884@rivosinc.com>
References: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com>
In-Reply-To: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-50721

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



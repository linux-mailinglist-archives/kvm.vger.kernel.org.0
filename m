Return-Path: <kvm+bounces-56311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ACFDB3BE16
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 16:41:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59872168AD1
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 14:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E80320CA3;
	Fri, 29 Aug 2025 14:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="J2lZAwMe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336EA2E7F08
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 14:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756478471; cv=none; b=i/Y9CY416w6eIewd8oKtMeeY6bVLxMPwTh8BuGdyRAf3N3kGyiCPnaglvUiswWatrHDJgLxtTg59IDOk7uH0WNTDvbHVjxh36RRr/1Kwz6X1Z/36dQdeZtOAkmaVoWmPkWF69m76willNuzGnAYnXq/2GisaePUaPx5E11yQOkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756478471; c=relaxed/simple;
	bh=m2E8W7DiSx6Ltrasj+rnR9WEkMr09MKsEoyxo0F+Klg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tkzt3GGDPRK/xNjlzysHqc/frzuK40HJfUlsjVtp8wPAEF7jWGwJtXYY281d3sjzPIWTWaEVAgkbQ0aV/q1GDKb4h4sAbdbPkOK2AmwYyZ+R0+7CVTtemDaoWiKKzxfqKIQDiJzR954n1jwi+nd8t/iCLlaI7/zo7A1DWGDsacM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=J2lZAwMe; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-771f69fd6feso2494011b3a.1
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 07:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1756478469; x=1757083269; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QppemwXg72umVaHol/lc8lTgDOnrssZANvnDyByXBzA=;
        b=J2lZAwMeDRUl811hv53I23QJWBwz6961FQgBLeHdvbDBDomJSn6qLvLAr9tjlsJHL5
         QTFsj8vcPQN54Xo77LNRt2OX8/JDqvGA58ObrM4yKhxGWx5fkkj6RlwrtL0UOcbGPMQ1
         gUqv5/gGVqoTdOIZ4pGIwHfRo6aDYtvJLfrfNngIcRAGpAzpFiKajHYjZkkO5Umm29qb
         hTiT9Bpga7IfE2H48Jzw7BSWbDc6dzDFOyWd0BEZdzRTP2Gx3DMiEKPAMZQG8AF1BXll
         ypbVG2Kq/lQ35pxybndDazJ+SmDPbdH4fER1INxceVoHTEf7ltYuHZtuBss7s8FoTS3Y
         0upg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756478469; x=1757083269;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QppemwXg72umVaHol/lc8lTgDOnrssZANvnDyByXBzA=;
        b=qTqk1q1utnvUlTa5XNpKcfEB9eFwHTUPSZ9niGWfZ8ieyLLYdmxvMMeCFUa+Dx2ro7
         Z1svK73RFeplNgLNt+N/PqqtzB+zm1o0Lj3ho13p/K6x6bsODtRzLdXq4QE7IGPIPlgg
         5nwibexSHja7/V43LWRqkuzgddgUu9pw82BtElak7lkdur7drtWxWQCdmkCZ6wPinCLv
         gX3Pl2JhdyY13Vo6p/eIJYOp9AAqBckeqJ4P4wKaznNR2Y1CU7kk1Up7tRQAdQZRM9I+
         u4sxVUD8o/BC1ASeu/yYD/liUF71P7rYva7GeJzG40awMOAErewLdv+/enwWJIg7TdLR
         3NEg==
X-Forwarded-Encrypted: i=1; AJvYcCV9yq1iGCk5BKZykg2WmFLdx15JRtw4Y+YpkNr+R0sNs67CjJFO6LxafSQWcXEaYpQD/90=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1MqyH/5nIJNES0qw2S4JZkO0sJg4TaoqiYr3WwgeySm08DF+z
	DC14YFtk1g8HhcYkCE+AHzNB88RyoCww/tsWuHj9RnnCWk5hMBbVw18GlmscKZpvaV0=
X-Gm-Gg: ASbGncuKHMtGVFQGpc7lLj1OZhUhf3Lz9oQDi5+YHnmiHaRoU2KCt3rldNP5y7qZO7x
	5+2wqOY9FbOwLoaMcUhkz2AWluNqAHYPcdTl0iHZ2oNy43ThGrp557p9WHEy6KgRTWqlf8RqgnU
	Ttn15RZPn0sWSVNL5ftWI4aT7GCod+qeNaCliW5lMtwfYrjcQqe88IWKsaLmx6zAQS9oDj5QrC2
	HGLGP9bLMEqIV6IGklRJLPNzAKhe9iC7LUq7YONT2g29FVcYqR/gSfFxjaViOudNOnRc7u59kCE
	R4B3KE/PtjwXxiIFhM9/B3MVf+0rE8wwNWCZoThoNwGwV5KxdR/gzIKjnxQtxDOUiSXdc/gWfQD
	P0Kqqy4b/wRZ8kOPhW5VsN9IOZ5Du/xrqAHc=
X-Google-Smtp-Source: AGHT+IEyDQaVO7hw6M+jmWcVL/199fQHjMH7i3C/32jO0Trqcu+fqIoi/CB4Tct+03RcyOTn/ZKedg==
X-Received: by 2002:a05:6a00:2306:b0:76b:e868:eedd with SMTP id d2e1a72fcca58-7702fc059c7mr38073588b3a.24.1756478469428;
        Fri, 29 Aug 2025 07:41:09 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4e1f86sm2560999b3a.72.2025.08.29.07.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 07:41:09 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Fri, 29 Aug 2025 07:41:02 -0700
Subject: [PATCH v5 1/9] drivers/perf: riscv: Add SBI v3.0 flag
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250829-pmu_event_info-v5-1-9dca26139a33@rivosinc.com>
References: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com>
In-Reply-To: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com>
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



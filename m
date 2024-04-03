Return-Path: <kvm+bounces-13429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE4AA89678C
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 10:06:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B49E1C251D3
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 08:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 515F871738;
	Wed,  3 Apr 2024 08:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="uK75Skh/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7E26BFBF
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 08:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712131520; cv=none; b=uFy8ajx4WO7Yf+B5saQnxgEXoSpQhfEs2aSd6FRCQfLQhu7FA1xpmk/J6LKeYxDFkItGqbZq06gElsxVTL4ckR2+bgYRz58BvcPbHxvO9SfbYmBy6uVWOy83PPZym4+f7j4bDnirURxK4N5HpeekDG3K79is6tCuOBlStz15/4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712131520; c=relaxed/simple;
	bh=5SixT0kcz+8IGtYwvZGhA9Q1KZ5SaAWo/BakwlxdqZM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=novrVhfWVuhhwMWssdAOfQgUxzXZcixgEtDrxIB9YnxJ74BZm2ugK5qIGa0vCKoDtF2VZsXME9bjRiJE71BAzW5EWr/cskX6gFxBs6u2TOv+ZK6fIkgdivgFV+5C0waz5VP168sx8LQ4neno3aNQtOaEK4jGWcxjYJmBhdGkK5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=uK75Skh/; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1e2987e9d06so1351955ad.2
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 01:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712131518; x=1712736318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ukUdwvkRaeQmBPwRJpu6uMxNPU93zNWp+RJiBVsFw4=;
        b=uK75Skh/kr8v4RnArctSD7ENSLfakR6lkmYZzFmP10Hlu2kXP5spk6IQXSbS309AaS
         9nbmQ4aRhTKH0iRWuaqGf6zCfxadSs2xbbF1T8ORRzclYNTfaQOwuOGETxdNIWfmEm8U
         p+CqL2TIKw4I3+/L6Q5T3lQl4JiL3qaYPBcj/PlhwrhVE8iEJOY/iM27X3hlAS+ZN2tv
         Gpml8cz1wynHkSUN1G2U14IRmkD/g3YTv5c2wNNneC94/mcK5Lmt1jBQ9OHoeFn+zgRu
         oGQennlWMs0RxBAo6lHuE8p69IWXe5O9cqfHqvgriT9PzQqbyvumCyJWNX9P8TMdmxzP
         8SBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712131518; x=1712736318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ukUdwvkRaeQmBPwRJpu6uMxNPU93zNWp+RJiBVsFw4=;
        b=BONKg6l4tUbjXW1yQTajyCDy6mhFKRf8rz5tN7hFU5ER4VLIgFKBCqLW58gwfj+W2S
         8LLB593keqS3639qKpPBsNOKOoAWmyE+8wEFO3IRUxPHE6PKjvCI6J+0yX13m1S36xe0
         p5jRLmorX/RbSlDPWoFJpmCbGA6TMGKQ4s3x44wStI5GDFhykHW5kLwoYu0DVJXBDzpR
         05N0CP9AIIlyF6j0+D8Dh4nVgaSswfks2VFcq5j0PUXp9pc8qjHZTvxfYAObgfKxp/9m
         QnM/wVO+NoFONoTdMmcsteTFTC3j/2cmG6yMljHMyfJtmW3PYVzXx+r9H6zOjoDOhuUF
         TbHQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8PE+M7GjGE8a6Xgkl9fkFZuMktXsPmFJDWb22TSjyLjrfT3d1LDBeLKQDexr8rQ2cIxDNQlSBqyyKlUBA1Y+CVr3Y
X-Gm-Message-State: AOJu0YycZ5lhDEIxcWSbmqdLlmEBOC+1mk0CBv4aSif2SCOS9EYr8x+P
	lOXZ9wx4tJIaoxWlIwo5LoMUhQ4QOExpIc0KXM5KgMQ6VpfYQ1FCLaXMW55U23k=
X-Google-Smtp-Source: AGHT+IGzCaqR/FZVf4jG8/W5aRGI+FZChKgtdmsu22b2KjgU9hzL33Vhb0robWHwzAUPtLmResHVWQ==
X-Received: by 2002:a17:902:e741:b0:1dc:a605:5435 with SMTP id p1-20020a170902e74100b001dca6055435mr16071106plf.31.1712131518213;
        Wed, 03 Apr 2024 01:05:18 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id c12-20020a170902d48c00b001e0b5d49fc7sm12557229plg.161.2024.04.03.01.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 01:05:17 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Anup Patel <anup@brainfault.org>,
	Ajay Kaher <akaher@vmware.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Alexey Makhalov <amakhalov@vmware.com>,
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
Subject: [PATCH v5 03/22] drivers/perf: riscv: Read upper bits of a firmware counter
Date: Wed,  3 Apr 2024 01:04:32 -0700
Message-Id: <20240403080452.1007601-4-atishp@rivosinc.com>
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

SBI v2.0 introduced a explicit function to read the upper 32 bits
for any firmware counter width that is longer than 32bits.
This is only applicable for RV32 where firmware counter can be
64 bit.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 3e44d2fb8bf8..babf1b9a4dbe 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -57,6 +57,8 @@ asm volatile(ALTERNATIVE(						\
 PMU_FORMAT_ATTR(event, "config:0-47");
 PMU_FORMAT_ATTR(firmware, "config:63");
 
+static bool sbi_v2_available;
+
 static struct attribute *riscv_arch_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_firmware.attr,
@@ -511,19 +513,29 @@ static u64 pmu_sbi_ctr_read(struct perf_event *event)
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
+			else
+				WARN_ONCE(1, "Unable to read upper 32 bits of firmware counter error: %d\n",
+					  sbi_err_map_linux_errno(ret.error));
+		}
 	} else {
-		info = pmu_ctr_list[idx];
 		val = riscv_pmu_ctr_read_csr(info.csr);
 		if (IS_ENABLED(CONFIG_32BIT))
-			val = ((u64)riscv_pmu_ctr_read_csr(info.csr + 0x80)) << 31 | val;
+			val |= ((u64)riscv_pmu_ctr_read_csr(info.csr + 0x80)) << 32;
 	}
 
 	return val;
@@ -1135,6 +1147,9 @@ static int __init pmu_sbi_devinit(void)
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



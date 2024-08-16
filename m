Return-Path: <kvm+bounces-24354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 056CD954263
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:09:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 381441C2343E
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 07:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E36E512CDB0;
	Fri, 16 Aug 2024 07:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="KyI80U+D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7D184A21
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 07:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723792127; cv=none; b=NtEwA0asBxyla49l/8WI23xTCM9kX7FA3v+I9pWRRsxz1X3reCpPTXcnmzIla/7ykhvJ3LtzGRr0fPBmtPA8bK02JNttDWu6t6MZ5w9Gs3kzaKRJoSCA4iRSt8EKh8QmyodKt7YmqcM3k2uY9ETZcEGusGFUBn4+vMaNbnNobhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723792127; c=relaxed/simple;
	bh=5XVXWSCOJYWprQTKTvAdmBVOdn99LaCk4rIKa8PzMRw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eXqC4g5FELU7jP21XlD2EfUheALlzYA4iBpjoB5scW0+n3sTojYtdT2l+cnGha3eaRK5AtHmjW81rHlsAA2o4+gy9X120VT3yCJqVKQQrHEE22wUzzd0gbcRBcXG1tsS0nFvq/qKNAELUpA4PW/JHfOIa+uH9ei784aKH3ALEqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=KyI80U+D; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3db13410adfso1093429b6e.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 00:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1723792124; x=1724396924; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gK7gcmoudAbCqj7iaqTuRq1w3RESYnAkJX7cowgaEr4=;
        b=KyI80U+D1p4H/wdLVBT1XO9TJq+N/V7773Fd2M7z84dt9+5FmFsQJ29Jrf2/HjzmuN
         fa1qJOq6LQq8RJmiRyEC4hBxcpHEyblR2Z6RNh68wRw2iD8axWZElbPycRE6vxLqmdO6
         OG4fjTA/a3wTAya6uTARydfhhrO6KrI33UvxpndbA8O3kbrdbcwIYZZ1c/6nieXqTf2F
         xoegDZr5jbPIF936XLLPKDqDdfe3wQo5gMHR2UvnorGiDGGOVGNffhFynBHxuY6bn9IA
         Dwa7zcqKjlt5JsU0guREB1ctibz4Lgho9pgdRaYQr+4iLXETGwc5SQcBy4Ar4R6tAuVk
         ieAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723792124; x=1724396924;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gK7gcmoudAbCqj7iaqTuRq1w3RESYnAkJX7cowgaEr4=;
        b=qAr/6d0zI8WF1RYwUa6+TDmfp45oz/aazDwA26n2m60szJLbW6uISDGHd1grRpFWi0
         /DAdX3FcKnAEQ04SCyS/69R2Tny0yOqw2pXVG4Lv1AxhOL3UXxAGAyge46V3lD35euhm
         O8NhJHXExsbpOsQmu50hUOOGPTTXi7kUfXmxr5D3PvbMj/59u3DPGckxiGRCUlav4/+N
         bckm2VVsBAcA6030F4HQyGIGo9g9p6n3JhPPmZ0+X0fS7RNmSs9c1s66F3l/PGPmX37k
         RZNjundaKmJU0+7YQBT9c7Y3q80fGzmzh4NZL3Pe4xXdWQkDJFgbTAiFE+JWjGt1V8yK
         ehoA==
X-Gm-Message-State: AOJu0Yye7WWNQafqkU4OVzQ3MV1lx5uVOT9icNyB7e4hVGahpD+VWb93
	VOheke1CrZI23z5icID+YS1N2MhKS3/iIxtBNCg9nETbfJ1TrWrubP2MfJuUic8=
X-Google-Smtp-Source: AGHT+IE+/4hnr8pi/hB7OE22f8NAJk7FUg2stklMrqV9hhE+HQc45Z6KkT09rm4aZzQByvzCn2SBnA==
X-Received: by 2002:a05:6808:3008:b0:3d9:30a2:f8fc with SMTP id 5614622812f47-3dd3ad525b6mr2167419b6e.20.1723792124349;
        Fri, 16 Aug 2024 00:08:44 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b636bcabsm2293792a12.90.2024.08.16.00.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 00:08:43 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Fri, 16 Aug 2024 00:08:08 -0700
Subject: [PATCH 1/2] RISC-V: KVM: Allow legacy PMU access from guest
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240816-kvm_pmu_fixes-v1-1-cdfce386dd93@rivosinc.com>
References: <20240816-kvm_pmu_fixes-v1-0-cdfce386dd93@rivosinc.com>
In-Reply-To: <20240816-kvm_pmu_fixes-v1-0-cdfce386dd93@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

Currently, KVM traps & emulates PMU counter access only if SBI PMU
is available as the guest can only configure/read PMU counters via
SBI only. However, if SBI PMU is not enabled in the host, the
guest will fallback to the legacy PMU which will try to access
cycle/instret and result in an illegal instruction trap which
is not desired.

KVM can allow dummy emulation of cycle/instret only for the guest
if SBI PMU is not enabled in the host. The dummy emulation will
still return zero as we don't to expose the host counter values
from a guest using legacy PMU.

Fixes: a9ac6c37521f ("RISC-V: KVM: Implement trap & emulate for hpmcounters")

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_pmu.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
index fa0f535bbbf0..c309daa2d75a 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -10,6 +10,7 @@
 #define __KVM_VCPU_RISCV_PMU_H
 
 #include <linux/perf/riscv_pmu.h>
+#include <asm/kvm_vcpu_insn.h>
 #include <asm/sbi.h>
 
 #ifdef CONFIG_RISCV_PMU_SBI
@@ -104,8 +105,20 @@ void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
 struct kvm_pmu {
 };
 
+static inline int kvm_riscv_vcpu_pmu_read_legacy(struct kvm_vcpu *vcpu, unsigned int csr_num,
+						 unsigned long *val, unsigned long new_val,
+						 unsigned long wr_mask)
+{
+	if (csr_num == CSR_CYCLE || csr_num == CSR_INSTRET) {
+		*val = 0;
+		return KVM_INSN_CONTINUE_NEXT_SEPC;
+	} else {
+		return KVM_INSN_ILLEGAL_TRAP;
+	}
+}
+
 #define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
-{.base = 0,	.count = 0,	.func = NULL },
+{.base = CSR_CYCLE,	.count = 3,	.func = kvm_riscv_vcpu_pmu_read_legacy },
 
 static inline void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu) {}
 static inline int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned long fid)

-- 
2.34.1



Return-Path: <kvm+bounces-53062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6476BB0D029
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07C2D3A9091
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 03:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7221B291C0D;
	Tue, 22 Jul 2025 03:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="AXDuL73Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06D728D844
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 03:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753154134; cv=none; b=bdafltu0Bwn8a613RLEDPVdYOWqL5SBitddpXsMXRnVC8pLQzwpBPIHJdfXYI8MmdjLwz3948OTPTfrP2iI6ozF2OEWqtjLdhY6EDvjjNyR0FrDGw5lTE2B3WfrxiXEbsyri/Z1mzO2BzLVIhVFJ/3LeK9JWnvyEPyVh3OTz66k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753154134; c=relaxed/simple;
	bh=n7ot1ZDrapxOuuoKWAWNChBQRBahYk/5sPYJuIjMo04=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hm+pznMwA6vIE9a6R/iTex0OnZ2mfHWRs3Ku8/A3HuxS7963NG1O4j77zIZCoNffSMzvabnmDLXyN9CX4K9S3IGZ05100OLyXTq0tJNqq7kQ/Bq8FiUkuaG21/9BkUOW1S6Iti5HjBh0KU5KWR4ajLefMmflmUxfiYirweeOHPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=AXDuL73Q; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-75ce8f8a3cdso1043884b3a.0
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 20:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753154132; x=1753758932; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jhkogpIzLqmuw+J4yXbDtFu/+vtMV2ME5+zsyZigSm8=;
        b=AXDuL73Qib4HNSK8RzQZ0ZiMvr6QRbQKaeVj1FN4dJdKasgawDFqmRcD6bC0jucWEF
         XM4TO2wzXWsG41JCZUx3ycSLKhb+eNY8tjO4UPkPONtphjY40y7Nv1sJp/nhpYigNJ/g
         VqD9Hq+0QAwQ8iVG861hVSX8hralGkNEYMAr8bxWEerGRhiC6NU7Fa4qGCSbn3vMaDUd
         RisE050OpjHOxTaaGS86mAMpMZlkjRwktFW3VuSgF7oEVVa5d/rY4i+AMMmwg21KFFQd
         6Gyl/wt967+fC3cR2RWWCQjYOSwbPAO/Egu9Do7uwvatUG6N6GNs9cgkZuZsE5vkgpkm
         3b3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753154132; x=1753758932;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jhkogpIzLqmuw+J4yXbDtFu/+vtMV2ME5+zsyZigSm8=;
        b=KwnK07Ntwt18AiBi0aOFvxIpJLM4Q1diBOp/ADjZ22pRlt36KHjc+O1IQdKNAxVJry
         PE3cvFKUKo1wduJFygssDwbOhF05uSngQILO8LIWjV3lWS0zNvcy8HfFTpcbTPNKmB3r
         8VcTzs8jLS8xtxiuf0Wo+DovPCW5RqxMznfErE4Y10Le5EYBSUFIX9XmG0tp8KgYXDxp
         FWbdQGRupuExEIWS1GNH4J7IWL35Bcmp7CgbN+CVU+sfHKW6O9ftLCQNbNlX0ab0rPgU
         ef/B01N6RSW3S0nT0Jej5bSNqcd0SN82UvEwTRH/x6RlB7HhZg+a8wU97ujSnOzjiS0o
         JBog==
X-Forwarded-Encrypted: i=1; AJvYcCWq8L2WGLjEa4JW+y2IwpVb1Do8glccBzpYrOt9dck06zPwpYIhKePeucjOSP5EKY+NNi0=@vger.kernel.org
X-Gm-Message-State: AOJu0YynnrxMTLOIyVHTXlAIQXKwKH5EixEueEcH6A5ZEbcLvrgB5CGd
	DSO1Z8YVvRDRsaN6l2r/Bq5p4IHf1T0tH6G/TT59MPTwhUJGdNza9ZPny3jF1OuFsDw=
X-Gm-Gg: ASbGnctlrtzeLogPq/4k9clTF8/+058wWCYUJ6Hgj3Ewh4jiFTSwiYpz/P6863g2+yo
	1xTi1lNfKuFaEkbdVBLGYYh7ef+fSEuhZ3Rz4ETyfa4Hf/NO76skC4LZO619qUrIlOLCe5QOUJ1
	aO9EKyS7KQ+3a3N3JLcSLE+VVxR+LdTSIcjrfnIGE0vsQQ88ONop3gsCUdGOc4VZhCivd0+A+W6
	9T64UsSaFzRI4a5eI2UH0YIWickXnJ6pPjFhmFrvkEe8mrhqjzbIZRz/2vniLH5Rnbl01DU0PZ3
	LbXBfNlax9NogZ8vXBNTLoNUht7LckVSj4TRqXQX7B8sTXhtQYlULPlhk7IAtqNxPZL94BhZyjC
	30RZzuJG+5eYWFjOG1o28583F904yu1bplUZkA6BpU2e2EQ==
X-Google-Smtp-Source: AGHT+IFymBDNRC6n0aOx6RiDMH5WWpmPfPiOTR2NPfmMJh6ymjUAaxXLpsltj/PI9MkAWHdOyBXsLA==
X-Received: by 2002:a05:6a20:7d8b:b0:220:5c12:efa3 with SMTP id adf61e73a8af0-237d89607dcmr37332092637.38.1753154132341;
        Mon, 21 Jul 2025 20:15:32 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2feac065sm6027612a12.33.2025.07.21.20.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 20:15:32 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 21 Jul 2025 20:15:23 -0700
Subject: [PATCH v4 7/9] RISC-V: KVM: Use the new gpa range validate helper
 function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-pmu_event_info-v4-7-ac76758a4269@rivosinc.com>
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

Remove the duplicate code and use the new helper function to validate
the shared memory gpa address.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c     | 5 +----
 arch/riscv/kvm/vcpu_sbi_sta.c | 6 ++----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 15d71a7b75ba..163bd4403fd0 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -409,8 +409,6 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long s
 	int snapshot_area_size = sizeof(struct riscv_pmu_snapshot_data);
 	int sbiret = 0;
 	gpa_t saddr;
-	unsigned long hva;
-	bool writable;
 
 	if (!kvpmu || flags) {
 		sbiret = SBI_ERR_INVALID_PARAM;
@@ -432,8 +430,7 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long s
 		goto out;
 	}
 
-	hva = kvm_vcpu_gfn_to_hva_prot(vcpu, saddr >> PAGE_SHIFT, &writable);
-	if (kvm_is_error_hva(hva) || !writable) {
+	if (kvm_vcpu_validate_gpa_range(vcpu, saddr, PAGE_SIZE, true)) {
 		sbiret = SBI_ERR_INVALID_ADDRESS;
 		goto out;
 	}
diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
index 5f35427114c1..67dfb613df6a 100644
--- a/arch/riscv/kvm/vcpu_sbi_sta.c
+++ b/arch/riscv/kvm/vcpu_sbi_sta.c
@@ -85,8 +85,6 @@ static int kvm_sbi_sta_steal_time_set_shmem(struct kvm_vcpu *vcpu)
 	unsigned long shmem_phys_hi = cp->a1;
 	u32 flags = cp->a2;
 	struct sbi_sta_struct zero_sta = {0};
-	unsigned long hva;
-	bool writable;
 	gpa_t shmem;
 	int ret;
 
@@ -111,8 +109,8 @@ static int kvm_sbi_sta_steal_time_set_shmem(struct kvm_vcpu *vcpu)
 			return SBI_ERR_INVALID_ADDRESS;
 	}
 
-	hva = kvm_vcpu_gfn_to_hva_prot(vcpu, shmem >> PAGE_SHIFT, &writable);
-	if (kvm_is_error_hva(hva) || !writable)
+	/* The spec requires the shmem to be 64-byte aligned. */
+	if (kvm_vcpu_validate_gpa_range(vcpu, shmem, 64, true))
 		return SBI_ERR_INVALID_ADDRESS;
 
 	ret = kvm_vcpu_write_guest(vcpu, shmem, &zero_sta, sizeof(zero_sta));

-- 
2.43.0



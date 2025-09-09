Return-Path: <kvm+bounces-57058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 674CCB4A2E4
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05824174FD4
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 07:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C6D3093A7;
	Tue,  9 Sep 2025 07:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="TDz56iMr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1736A3081B7
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 07:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757401412; cv=none; b=K/cWXOUC4WuDEJusXvGxTKg2DAmq+/8HXJb2gMVJt2BGJmBVewWpcGAxgM8nizNJURsWpe6OYP9RhnqPv2Rh6V/DZPDD20xU79Hqk4QJKHLxqINJNeoySP9ocBy5wCAn3W7NTWJSgYc7y/Uny5Xx/w6z7sYqbw5WGPw8zab/hDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757401412; c=relaxed/simple;
	bh=FShHH1HSMrmoVp5u1PcL4F5vjxrP/Jvx+dnFDhWtXGY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IsA4uWWv/sJKo+pSBxZ69kzLR//oxs8wNc67Vs64uT+pk7g9l8PO5hH5JAMKPC3A0Iv2/epxH5EOIKQGAxyhCcojDoIh0otN10cFb7ttP+ayyVWQIV8PYDlCw0cpZjN5xlcvRHeaXukmz98pIuJpfU3mA5kAmqStXtkFQ1no6dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=TDz56iMr; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-32b92d75eaeso3561338a91.0
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 00:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1757401410; x=1758006210; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=53RW3r37vVd/uOGEJeJ40vwWJphKZpVppDFV/CpDLs4=;
        b=TDz56iMrt1ib0qgISpTvRAUQZ6DsWjZMgBX8xvglndagXbPz/4t2DsGbgPRFMa7hZw
         /6dhdZKjkXUFCCNlhPB1MtZCK9Et9wizJ6w0mGExScOMCyMMywZ5zfFPk9JLnl3VKDvW
         r/6wolsGLUyhJBkHIaalnBlSk/mZwCP5GxHCv5T4GZ761GBCT2oN58Eo7FONXQu5asm8
         PxhC9Sx2mcBCIG634ob8WIsMHPjw3EusJt3jCRsEpqhWVKF/rMuqJDtr4id8pPtaYDV9
         BDJnVW2alpeRQcAl+uPEsfqkN2uSNdlJACz1I4tsmqFHp38Gv93OQkfJGp+yLuewJMsX
         Wdfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757401410; x=1758006210;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=53RW3r37vVd/uOGEJeJ40vwWJphKZpVppDFV/CpDLs4=;
        b=chHxlcHPYoytIi1PX0OuX5Y/x0bnY8EX3RU5DgZUXM45BwDU1Iisf5QAzryyHm4dB/
         70Gv7w/eF/lbnDZ9AFgRJI/dF+m7Q9ATA+wJYN68PnHf84L9diD7aM4IC5UcwlC38MiO
         SMGLTXxBvgYmS20jexXsBHtL7tO9sXi5KUgYCs/FU5bBASIQiSBD6Z+avsdZx7DT4LsD
         XAYiB1Y4UCND38SJJMUnKjYY8ZH3YmSZsNVkcgXFzxMW0sOIig9SLhNFvvAec9+6UIV7
         UMT5s7uGC5ELYPOQNEu9FB2wE0xtDj0/bP7T+XxbE/u7aDe1TSaqM6h4eFnyZL0aZZFG
         NT4w==
X-Forwarded-Encrypted: i=1; AJvYcCX3FCXEmJdz7dNoQy0YHg7IS2G0+cz6gdSoonFEcqCZ1SuqdtH1RJt6iKEZ7gvak+8nmf0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywa4yUesF4KrQOeK497UBLQcTL4/B+f1Qy9L6EHEAekoUnsjj0a
	vFhrTW1wfVCrCeAa1S788XZtHs7mo5MMaucTm8kN1E1moy83ucFY8YPl6vm3Fpy6uYQ=
X-Gm-Gg: ASbGncs+KAPiCXVqp1p1I31M8vr9dzM+zKyU2Q5CVyNE9Cx74ueLncys/9lJSdn/GBv
	4U95R5oFRyL2JK6wihDrLMp43zjlsnK6vnSA57Y5QCaAFdcmmkhYLYTe6MIX83FNtE6UorJjTjm
	fQhR5dRGUO3SzS6k/awZU/R5kam8SWkxEtKIhXOPq5kSV9+1xsLhuUl1H11+E0kmCzSf89Nchy4
	xZCtg2Hfene71q8xvOTpPInhyEwAvCC+qNAGuAMsAfAfcp8/mmUE5uK/DKfSMkQtZqywpUAXnPY
	uasFWFCOaNevsZRrDk9VZXKLZRIKTkF7Dyxo6MTCkMJpaQ1gkP9PermGCXZgYpBlDKJw8djIs9U
	FRlXfzspwbWyOnKo5FyDNRxQ9OH6YX4g+XqxFkhumP6eRhA==
X-Google-Smtp-Source: AGHT+IEp7M2YTd5oqLJWntqYzx+W66KU/8IVhi9uG5EgartrnOvK3S6t6vrkn2Q3yP3sdZUpu5Y3+A==
X-Received: by 2002:a17:90b:48c9:b0:32b:96f2:e2c9 with SMTP id 98e67ed59e1d1-32bbe104088mr17623995a91.12.1757401410327;
        Tue, 09 Sep 2025 00:03:30 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-774662c7158sm1025535b3a.72.2025.09.09.00.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 00:03:29 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 09 Sep 2025 00:03:25 -0700
Subject: [PATCH v6 6/8] RISC-V: KVM: No need of explicit writable slot
 check
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-pmu_event_info-v6-6-d8f80cacb884@rivosinc.com>
References: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com>
In-Reply-To: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>, 
 Sean Christopherson <seanjc@google.com>
X-Mailer: b4 0.15-dev-50721

There is not much value in checking if a memslot is writable explicitly
before a write as it may change underneath after the check. Rather, return
invalid address error when write_guest fails as it checks if the slot
is writable anyways.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c     | 11 ++---------
 arch/riscv/kvm/vcpu_sbi_sta.c |  9 ++-------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 15d71a7b75ba..f8514086bd6b 100644
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
@@ -432,19 +430,14 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long s
 		goto out;
 	}
 
-	hva = kvm_vcpu_gfn_to_hva_prot(vcpu, saddr >> PAGE_SHIFT, &writable);
-	if (kvm_is_error_hva(hva) || !writable) {
-		sbiret = SBI_ERR_INVALID_ADDRESS;
-		goto out;
-	}
-
 	kvpmu->sdata = kzalloc(snapshot_area_size, GFP_ATOMIC);
 	if (!kvpmu->sdata)
 		return -ENOMEM;
 
+	/* No need to check writable slot explicitly as kvm_vcpu_write_guest does it internally */
 	if (kvm_vcpu_write_guest(vcpu, saddr, kvpmu->sdata, snapshot_area_size)) {
 		kfree(kvpmu->sdata);
-		sbiret = SBI_ERR_FAILURE;
+		sbiret = SBI_ERR_INVALID_ADDRESS;
 		goto out;
 	}
 
diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
index cc6cb7c8f0e4..caaa28460ca4 100644
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
 
@@ -111,13 +109,10 @@ static int kvm_sbi_sta_steal_time_set_shmem(struct kvm_vcpu *vcpu)
 			return SBI_ERR_INVALID_ADDRESS;
 	}
 
-	hva = kvm_vcpu_gfn_to_hva_prot(vcpu, shmem >> PAGE_SHIFT, &writable);
-	if (kvm_is_error_hva(hva) || !writable)
-		return SBI_ERR_INVALID_ADDRESS;
-
+	/* No need to check writable slot explicitly as kvm_vcpu_write_guest does it internally */
 	ret = kvm_vcpu_write_guest(vcpu, shmem, &zero_sta, sizeof(zero_sta));
 	if (ret)
-		return SBI_ERR_FAILURE;
+		return SBI_ERR_INVALID_ADDRESS;
 
 	vcpu->arch.sta.shmem = shmem;
 	vcpu->arch.sta.last_steal = current->sched_info.run_delay;

-- 
2.43.0



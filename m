Return-Path: <kvm+bounces-56317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C4122B3BE2F
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 16:43:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E75AA1C272E3
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 14:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCAF8326D63;
	Fri, 29 Aug 2025 14:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="Lh+YeIS8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5983322A2F
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 14:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756478478; cv=none; b=YDPPdfxDdeZGzHKMBhbqN+rMuzR/mnv8jjenubVpGVPsmyR6X1sN3B4TP/rmHEAzqkjDCtPhYY1osSZTSl/Ro5b59sf6zIUUPUSfuuvK82iPOuqAvhjCaYh5QeC9hRSCgFWZLlWBF66w66phCzYLdVWuxsZsCnuJBN3dKvAv4pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756478478; c=relaxed/simple;
	bh=OIK2edexmMK460AAbag3XeqDeoi08HRp9qzXGx0bT/w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dTCeu3NWlwcnEEOKJGdtYOmkcJT6PB60rh3bAaW+1zXhlCIm3zLkwoM6kX/xjRURMGxh1Bzalb5R4pjuvuWKI0+/WrnLnimHgOqW/bCQC040wd96TrHviBFsnFk8O5G2GPLsxkzB6NbMh4ZKuH5z2q+B2ovnI5JI/qZ3Y+vdBSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=Lh+YeIS8; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7722f8cf9adso676682b3a.0
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 07:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1756478476; x=1757083276; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/MakGsp/S2cNx5PFmj2E2VVtHHLv1RzGj2Qogo6hOhw=;
        b=Lh+YeIS8uU0oKZaRM02NqtKJRiINqEaf4E7OOXIh0qeWnkmCyYd5znmi0T1yJ0akMh
         RAuwdKylWl3lJmPOQ1R/vnw3nBbQgEcFkRHPj+SOwesn/RiaV8HMC1N1pl7+/wZlcUcW
         tytRi10LGrYJmG7G1q12tDoJC9bglJp4DBnbr0ji07Y4WngPxn/KrW+ftSdknYDeCkh3
         ti+rrj4jeDAiyT+nkf44vUK/tGAQpnpxEq5jZ8EpfYwfwfVWihJmogqFxwHJ9yYhz6b+
         /gQzODFKENIBtfTQnesZ9IIbBQjkYiJSVIoY+VVHf3o1BSnU9oV5OZg9IR+hjkJvQo20
         t3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756478476; x=1757083276;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/MakGsp/S2cNx5PFmj2E2VVtHHLv1RzGj2Qogo6hOhw=;
        b=IJBKm3LPE4BC4GHYJgi7daPyZmo9RCaovCfX3ObCP+eDy5OFMYXxgz4itO/nMJhPId
         Gjl5caK+UrMfGFhm5MJi8CYwws0ob/uZRC7x57BBHejkGUR6Q2jG9UorwWZeBgpH1nYp
         9PNXWCV/dLklj+e5uPWBHTFSqF6nC1Jlew6m51QxM3jjZgHlCztAGKDcjMom/KuGbzR3
         8cONNlFgWWe4A9ZbTfMi8IpCZXQDv4e1PgpsbzWxeV+fmlWiOvJ8fXv1xJTLkJNjCsxw
         +M6MgTKJz2lcKtMCYhh40rHwMMAnq8rbk9hMa1ONAcFvZu/ITaVP/O7LnKV+x54kUzev
         ARvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIboFuVA/EcY4bFPZ98j3d5POyaRfcw+1oieRXLISyKIw35e3yEaN9M6IpPN9F1WNU5js=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmEXfriEKikRC/4DzNLIWT/L+5ZjAhaSNY0XqL7XOWHTQXQPIR
	6Sv7ra2kQRcCPQDkSmndqgfyTZyErnk82VtZe7phlCsmiyE/fu8RK+D+5o8cHeQ5UlA=
X-Gm-Gg: ASbGncu9UEWfpQJVd+5l268XI6+KIEJt5CPH/aJqW+VKMXkRDqO0CTysaS/Hy7sWIqa
	fvFCQl7XtS8TMaW+hBMDpM4le4lB8KRyB1miuw4TXEpTRR+uSo19nTcmRxt4sxYv1w8r65pZJHd
	cUNOMnzrVNpZNuUdJhcEgUtLEjipksC4XR8f6E44PUT2wJUFTi4HXaEuH4EG9O9SNjOYmpuYn7a
	DeAQrc/mNbFHwK3SvRYkpkHxzxOMUCjgREd7525GPb1UpJ6e6cH8gY/zEtfHGzOl7NqxU48otzQ
	vs+mfIO8YuAGAWTy/XsqCfbK6/jBe6hBL2JWJ1jAMYD55f9OXgRUlkmkGyqdsr2z+cKl6rB6Ktm
	GNfVKD0Q+Qp7v1xjuOMUabMVqQCinq+v9dP5DnInfiSfbbg==
X-Google-Smtp-Source: AGHT+IFbDhya0VpL4dDdmpa2UiIlEb5E5l+kiCERG2V1mfvmn8kbsxwgyRACqpsdN0fY/j0vO5OnzQ==
X-Received: by 2002:a05:6a20:7d8a:b0:243:78a:82b1 with SMTP id adf61e73a8af0-24340db3ac2mr40858661637.57.1756478475772;
        Fri, 29 Aug 2025 07:41:15 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4e1f86sm2560999b3a.72.2025.08.29.07.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 07:41:15 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Fri, 29 Aug 2025 07:41:08 -0700
Subject: [PATCH v5 7/9] RISC-V: KVM: Use the new gpa validate helper
 function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250829-pmu_event_info-v5-7-9dca26139a33@rivosinc.com>
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

Remove the duplicate code and use the new helper function to validate
the shared memory gpa address.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c     | 5 +----
 arch/riscv/kvm/vcpu_sbi_sta.c | 6 ++----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 15d71a7b75ba..851caa86cde2 100644
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
+	if (!kvm_is_gpa_in_writable_memslot(vcpu->kvm, saddr)) {
 		sbiret = SBI_ERR_INVALID_ADDRESS;
 		goto out;
 	}
diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
index cc6cb7c8f0e4..80acbb75041a 100644
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
+	if (!kvm_is_gpa_in_writable_memslot(vcpu->kvm, shmem))
 		return SBI_ERR_INVALID_ADDRESS;
 
 	ret = kvm_vcpu_write_guest(vcpu, shmem, &zero_sta, sizeof(zero_sta));

-- 
2.43.0



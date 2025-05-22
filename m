Return-Path: <kvm+bounces-47405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65DBAAC1439
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 21:06:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15371171065
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 19:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF7102BCF48;
	Thu, 22 May 2025 19:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Jvv0HrfZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5026C28C870
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 19:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747940635; cv=none; b=mvXayq0TRkqXkxsvTuSVs2SQQEDgiWgH3kQttKojmInuxE+awQobSIXQt0TPA3imOlHCrKHPqLixzxaZPcHR/830G0RWFuL9xbfHACj0yfsnwVfuBxbp14COKLhVs8TMFW7AOrzfMNoK9SjWVm+TgIMdaS4WhVeEth1BXLgpzxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747940635; c=relaxed/simple;
	bh=15uNoWw1oFmc2RxCK2PSoncmAe9FQepCxYJUbSkoVrQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mur7Smb3e27CpKJ5EF7APdkp0hw3hXiOXPrrnBfQBpg/pDEPdM90X7P2xnLlOthDqg3A0YYRmf3YKM732086U30XLPcBVsIVWCKgVOqAAKaJrn39R1YheKNGuSepEyB6cF0x7Vuas/MJ1YxYiLa4kp7CBVnoUZ7l4R+WFIxIKvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Jvv0HrfZ; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-231fc83a33aso53407275ad.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 12:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747940632; x=1748545432; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hlpauo+rroktx9kyAnwP3yRkffTzlKUHEtIrSQJtdwQ=;
        b=Jvv0HrfZiLEVmlP0FLF2oJo4pr+TqEaSjswrUwy7iqfS3VKpYHVEFc5OFRnxo9pK/t
         yqgdQfE5z5SQt2yEnvdyzdmY/C0QbZhAysbAsoXgFtIjwJBbFpBntMHAaCN8fR4yukA7
         sPpUf3JIgkuL46DO16eUvi2lMgYAOd2k7cxgAE8Wr6SSGsLNx7hu7ZwAd/78/XebEsPG
         qRT30LBXKpWeO3jHHAtMfntlbMP8mGUOKrjBj4qy8Jinda/RRMS8qHGqdyppZRIK1adw
         QBYGYdDygrX2gUr1TLICAlZ5HNdvKx7qJUGDkUm3oR3Aiu7567zbitNQbRzFo7DnyG8y
         N9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747940632; x=1748545432;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hlpauo+rroktx9kyAnwP3yRkffTzlKUHEtIrSQJtdwQ=;
        b=CoatS9gS3U43nlMuVLRkuEUAZ37HAxUfUzhnwDH42YjNS79sEWWJqDvV2i53EeDBTn
         8f7NCi9lb9sa4qWsFmkQjytAvgZ5uthqsQQsJlwb4WIPVurk7sscvUjx5R5M3/aKjOn5
         NReM4gkAaDtbvsn1JBVIXRbhYBvNikqWM9m7e6XaiIQEPF2zytlqXlEYbiLgWNy1qhAE
         8aC5ebUM5bEfkN1CugmFmwXkDfcfOGgaEK7X0y3U6KfmIBLAgbY8qzenD4we2Ei/jPPo
         nNC3RScZ8VG38QZ6SmFz8d0qVrDObg8x8JGxHg6OqDvsDSX9UGod+PDZgpWgTnXT20Yx
         +eUw==
X-Forwarded-Encrypted: i=1; AJvYcCWL1On5gvrotnEb5+WKKfuoeZUgNUBHejgF/VEegGY3kC0CF2zVrY4ZHntizz3/0YdIfk8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBtAi4wBW9uhsjIvOoKcmlgsPJR+6+OVw/retDNpCva2Lrdv4t
	6KZbHf5El4uare8VSZU5sA/JGehGfm7SQvB+WLAfAZfM/dQptiLX/bH0mG15ZnJKsEE=
X-Gm-Gg: ASbGncsvndepVkgWEnGSgKWpEZ308UxAXugFKIuF3HYU79rZT/4D2t1SNTDJAuKy1+X
	5wC22CPCjPLDElr89qIuvlZYcfRiAIa2aGoaQmR4VJiNfiZF0G7lE3fvPux9wyiWoBz+1wMdYnA
	T50Q2rmfjd4Qdt+TNMRtzYxGbMvRdHAhcq6EbPej6Etfd1Kjphm8dBvP8d4HmRP062LZNG4+SXb
	TCle+P5GlymKbqP3ihVJ3HXE6kQrhdw4uRfV6lcM3W8WxvzhsIAuk/50zT5mAGF+jpRgYtk+Eio
	KiT/+dB/ZfKV6I9ilgcqAF1Gw4AWT4+/MgVoLxyvqzUkJs7mFSdM9TDcGLYSigLT
X-Google-Smtp-Source: AGHT+IFokfHrS0cqFKUDrcGnm0bjUiSThIlPHjvO9RTk66q9cyYFiPgwK1o9zc41Z294fx1ovdpLTA==
X-Received: by 2002:a17:903:1aec:b0:22d:e57a:27a2 with SMTP id d9443c01a7336-231de36bb6bmr358484745ad.23.1747940632165;
        Thu, 22 May 2025 12:03:52 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e9736esm111879155ad.149.2025.05.22.12.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 12:03:51 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 22 May 2025 12:03:41 -0700
Subject: [PATCH v3 7/9] RISC-V: KVM: Use the new gpa range validate helper
 function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-pmu_event_info-v3-7-f7bba7fd9cfe@rivosinc.com>
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
In-Reply-To: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

Remove the duplicate code and use the new helper function to validate
the shared memory gpa address.

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



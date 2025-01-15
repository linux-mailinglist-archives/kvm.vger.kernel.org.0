Return-Path: <kvm+bounces-35592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8AF8A12AF0
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 19:32:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73709163D8C
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 18:32:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7CAA1DAC8E;
	Wed, 15 Jan 2025 18:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="KEHRw4cn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F371D90A9
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 18:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736965867; cv=none; b=AJwCxrQng9oBRa0jfuDH0fYwxSHYyfsozdDWogr5qAkAv+jbCgG8arhTpq8OQ9xEvrmHTwzSLjGdfRA7osyZrScXrr6eg0vQbTHVIxMMyFFnG16xJK4ZfWt40NDXJEgxvZ9t8eV2mPPHxD3NoJoy0+Ga1yvpWv4zzrKc+MYajNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736965867; c=relaxed/simple;
	bh=efs3Hd7cOdrjOpmhmL2LomzcbRptdMckK8U3wRsh0lA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZlmYBSayW6Kj/1vOxeuf7Yf9zuOdrjaJLuI/+FtWu3Sf56esXDyS5N8badB8xbjWrL8JqxVTzlLXuJtzmnmTM/GMh+sDlzJD2FN3FrvSisb82KDKuzOTli45WjfKQAbzpZtrMi3yPSb+q2jcoU+NjZ+NO4yFEvAx+6pbfZHsxFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=KEHRw4cn; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2166022c5caso113093875ad.2
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 10:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736965863; x=1737570663; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YPQonIfRWz8q533cgyWsgSdgY3t/tGTd1rJqUG9L59Y=;
        b=KEHRw4cnfFpUI7D6MXDVGVtsAH3RvTeFmlIhybyHBU53/bA6aDHAJrKgVoMYnPvy6v
         vekvAag4iuafrV7O+i1+kUUSqqbOcJJVL2d9G+Iq59WTHmpDn3AzLOglYI/+FmyzxVji
         2maknp3CcZU2QY27KPSlEOJKDeM+xzJ0LHWSWgXRWZYg9lCkiViE7vMJY4ANqepE51vp
         wJOZC9pc8uvRlEmcFwnukYHuXoYAxrdk9+FeNAXSKawj2DNo4JpDoXzUP+Wh+hkBEInk
         OwO2vjVV0MDVYPcaH8QpeJvJkwAsmcMMEkXkdhI3dUZw2tOftdJ8HT+JbwONHWpcBp2K
         xElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736965863; x=1737570663;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YPQonIfRWz8q533cgyWsgSdgY3t/tGTd1rJqUG9L59Y=;
        b=lHfMtQTJy7ewZiq4v4vvsZ65a0eZlXDzgX/I+a/DWlLyKnXE5mB+/RjSDurA+/Ha8V
         SAs1az+DVOo5A3cISUTkQ3pUSqzaGoegW2ZvzqRQtkAF4X78xk911ZivJgzzBFWO1ACi
         PHIjOxz0aLrKbAQ92Ky6vAmkS/VKBrHGi5uRwnw+ar1jWiM8ro79nlQ2QpKEoZGzZqmh
         M0CgkkEBSsJ7P6PxpRTN+2/G0NL8wRCjmaHZnOpLFLxCD7vvLNlE94MCnl1yKmtzNnuJ
         SF/HtWQwVyyJFXsLA5Wb+wQzMLcYc8DvqC2tta2RIa7LGcaEdsxywxa/Cj5pWBhXaP64
         Et2w==
X-Forwarded-Encrypted: i=1; AJvYcCXWFjO9vfC14cXpE599I5wsZFj+qLNwYgPjwZYa1HxU74jq7kcDg2ANE4zxSx28DFgCdSs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw50WL7tWoIzDU1xUg7tFxt8A8TeXcJ2DJLrtDhy7zh3QdRNJyk
	e26ttfNim4kimbVrF+sKSt90eyZRxQDu6HBz434JEZyAU1Xj+ZaYnfMbqO60blc=
X-Gm-Gg: ASbGncvOlQK8+DDgOzAb400AEwgr/XP9mbUoODohpwThquHwood4LDMGhSTYGG6T0Ia
	nINx4tElCS5PEaMWjQFvu2TNJZ3/7fxRTYAgtg6eozIn8P1mFIer2WasnKISbmrTAECxw1clr18
	izSXdT1pc4+H9s0SV16gotrSGFUq947FlKYKMOpRXwZDNBSgCtweeu3Hw9spuhizl24+sXNjfeB
	PwmjeHlKZhOKBStqKB7AovmJue8V4c5AdHN6/sJI446yJ9yRRJ4kbHp5TCJ+Dr+Tc1Pkg==
X-Google-Smtp-Source: AGHT+IHrlKrKdeucl7zMxkF/5l3NHVR4wNF51oJC9P55Fo2f9FtCoIn3BV0XWsDAU93AJPqz/FttjQ==
X-Received: by 2002:a17:902:ebc4:b0:21b:d105:26b9 with SMTP id d9443c01a7336-21bd10529e9mr125689755ad.16.1736965863474;
        Wed, 15 Jan 2025 10:31:03 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f219f0dsm85333195ad.139.2025.01.15.10.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 10:31:03 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 15 Jan 2025 10:30:47 -0800
Subject: [PATCH v2 7/9] RISC-V: KVM: Use the new gpa range validate helper
 function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250115-pmu_event_info-v2-7-84815b70383b@rivosinc.com>
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

Remove the duplicate code and use the new helper function to validate
the shared memory gpa address.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c     | 5 +----
 arch/riscv/kvm/vcpu_sbi_sta.c | 6 ++----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index efd66835c2b8..ca23427edfaa 100644
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
2.34.1



Return-Path: <kvm+bounces-14233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 420C58A0BE7
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 11:07:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBD621F27EFA
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 09:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EFFB143C6B;
	Thu, 11 Apr 2024 09:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="VZsfrf8Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EAE1448C8
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 09:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712826418; cv=none; b=JWZMNgIJiAlCUpNaOHA1aFsYu4d+wdCtrynS4jvQa5iHvijMClEJlfQzxfPDgo8qLQp4OjS8m+LFSyqT5tymeJ94AotEipCuqlKSaUf6C9qi9gIgxuKzNHJHQaKDnUAl/2FP6OEA8CpUSYp+k0nc5LQjJf7lfcHV02OSaI4MdF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712826418; c=relaxed/simple;
	bh=MdZT8LAfLKaM3p+4YIFGXmit9KkJvDm4RxB+fCgM5S0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mEDtrSQxqlI4df9Ved5BjjTFPkBmVKshvnOOxcGrrlo382gRpRfxIIBs/rEFrXeuvmlnDQUr76SRyRoh2o9GTJVFyZy7eavQJpPtiPmP1KGsSCi7IhZPWCDJ86GmRau2yVEsDd/Uq4/EMkkVTj4I9PP+NtT7+0JGPwhCDiihdzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=VZsfrf8Q; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6ed0e9ccca1so4410625b3a.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 02:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1712826416; x=1713431216; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CXD3qtP3CDUjevrxBmZTbJq+qLx3zHWdB21VYaybQbQ=;
        b=VZsfrf8QJw88VHRn1AQy35n7hWrtzIe7a7mMvaeixVTXLJf+vOSNtxuU5Q58k9SSBr
         pGIbDeIxQsCR04Q/34P3jvA9uYEGEKk9VHUT5W+P+CCJlGJ8Q8vPJfx7hcihUx2VX0nz
         QdON870F/fR3xDhI4QFjLPdIBeXJiHw5kM5dSWjvpGTwIVPz/BxtNzQO+jS5jdRgXl39
         JKP4ep6YW5kxvkn8tPryrmRjEuuJ2z6tvcze7Y6s5iMeHXrd47HXqCqyzWJbFyCBIGOl
         JfAfBr7OSBiwMCMlB0/NH6bQJCX//JG2HjGYOeL7AyVRWxh7nb03nBb8hqrIu4XrsIuw
         0zlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712826416; x=1713431216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CXD3qtP3CDUjevrxBmZTbJq+qLx3zHWdB21VYaybQbQ=;
        b=NnRUQSSpX2Dg81KeU8uWngPsfXRfxOpcLb16ZtOOK1sYNsm/6tnux84JKvuxaFrkS2
         FoCDOSdX9+ZEW+/b9TlJ1aleFDxXJpMouXMe6neumQ2Nvu7NkeKjAgx064bTcd+gPGy3
         r899q41XRBvEVaZ8+IrPnO53qoWiCBzhQCf1Av4mYZVf0v3YFIxbTS3/a3loM7EfAwSn
         ETUMVbFvCjilz5VWFOH/cBVTCaQ3V8v38mmbcKaLKFkfyD7BfAUN5KMGtm7dfZ89OWpr
         b5Tg34Tg4Z68HwamOTeoo5p2s1KPOgTVlbSBMte535HVpfoKlh1EpIerCkLv2mzhwFEf
         JrjA==
X-Forwarded-Encrypted: i=1; AJvYcCX4bNrjMCWZD8mGY4P6n3VuxR8TED/6ViY/PrbuTuq0SDQWkUQoaqaGXgWIYaSzcfSsuwQG275li4oKyr3mRbyO0CrG
X-Gm-Message-State: AOJu0YykQ+u46lGPbLu5nW80ahgFKnAKfR2vsPdPykgPYZakb574tMrr
	2mbovK2mmOiRni+IaQZQvJ+6PtncnTj+XI7q5DrJdrG9WwaIdzxzC/O4Yvci8eg=
X-Google-Smtp-Source: AGHT+IGX6O8bt1yPLmnfze8p06yu78d6f+V9zy0fus6DLrMlig86+tMSW5Fnv40gEVzwp+6iihayww==
X-Received: by 2002:a05:6a00:181b:b0:6ea:950f:7d29 with SMTP id y27-20020a056a00181b00b006ea950f7d29mr5252624pfa.20.1712826416364;
        Thu, 11 Apr 2024 02:06:56 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.118])
        by smtp.gmail.com with ESMTPSA id e21-20020aa78c55000000b006e729dd12d5sm816738pfd.48.2024.04.11.02.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 02:06:55 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>
Cc: Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 2/2] RISC-V: KVM: Use IMSIC guest files when available
Date: Thu, 11 Apr 2024 14:36:39 +0530
Message-Id: <20240411090639.237119-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240411090639.237119-1-apatel@ventanamicro.com>
References: <20240411090639.237119-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let us discover and use IMSIC guest files from the IMSIC global
config provided by the IMSIC irqchip driver.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/aia.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index 8ea51a791371..596209f1a6ff 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -394,6 +394,8 @@ int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu *owner,
 {
 	int ret = -ENOENT;
 	unsigned long flags;
+	const struct imsic_global_config *gc;
+	const struct imsic_local_config *lc;
 	struct aia_hgei_control *hgctrl = per_cpu_ptr(&aia_hgei, cpu);
 
 	if (!kvm_riscv_aia_available() || !hgctrl)
@@ -409,11 +411,14 @@ int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu *owner,
 
 	raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
 
-	/* TODO: To be updated later by AIA IMSIC HW guest file support */
-	if (hgei_va)
-		*hgei_va = NULL;
-	if (hgei_pa)
-		*hgei_pa = 0;
+	gc = imsic_get_global_config();
+	lc = (gc) ? per_cpu_ptr(gc->local, cpu) : NULL;
+	if (lc && ret > 0) {
+		if (hgei_va)
+			*hgei_va = lc->msi_va + (ret * IMSIC_MMIO_PAGE_SZ);
+		if (hgei_pa)
+			*hgei_pa = lc->msi_pa + (ret * IMSIC_MMIO_PAGE_SZ);
+	}
 
 	return ret;
 }
@@ -600,9 +605,11 @@ void kvm_riscv_aia_disable(void)
 int kvm_riscv_aia_init(void)
 {
 	int rc;
+	const struct imsic_global_config *gc;
 
 	if (!riscv_isa_extension_available(NULL, SxAIA))
 		return -ENODEV;
+	gc = imsic_get_global_config();
 
 	/* Figure-out number of bits in HGEIE */
 	csr_write(CSR_HGEIE, -1UL);
@@ -614,17 +621,17 @@ int kvm_riscv_aia_init(void)
 	/*
 	 * Number of usable HGEI lines should be minimum of per-HART
 	 * IMSIC guest files and number of bits in HGEIE
-	 *
-	 * TODO: To be updated later by AIA IMSIC HW guest file support
 	 */
-	kvm_riscv_aia_nr_hgei = 0;
+	if (gc)
+		kvm_riscv_aia_nr_hgei = min((ulong)kvm_riscv_aia_nr_hgei,
+					    BIT(gc->guest_index_bits) - 1);
+	else
+		kvm_riscv_aia_nr_hgei = 0;
 
-	/*
-	 * Find number of guest MSI IDs
-	 *
-	 * TODO: To be updated later by AIA IMSIC HW guest file support
-	 */
+	/* Find number of guest MSI IDs */
 	kvm_riscv_aia_max_ids = IMSIC_MAX_ID;
+	if (gc && kvm_riscv_aia_nr_hgei)
+		kvm_riscv_aia_max_ids = gc->nr_guest_ids + 1;
 
 	/* Initialize guest external interrupt line management */
 	rc = aia_hgei_init();
-- 
2.34.1



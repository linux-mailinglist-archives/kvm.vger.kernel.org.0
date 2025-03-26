Return-Path: <kvm+bounces-42029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AA3DA710EC
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 08:00:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BF923BA087
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 06:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEFCD18BC3F;
	Wed, 26 Mar 2025 06:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="KHsb+1Se"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914031953BB
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 06:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742972251; cv=none; b=lZGLj9f1t7sR/wJ9raQUR+RPab8u1fOHulTKSG3oUyx1zbohWlgi6AD/SnHXx6YifXDCmyOlhSBU5CIhr5l55kEViGxMB9n/0PoM42qKMrIBw3p2OSU+rDpd/ntqS6B0wDK/SHu3r2yVJtl/tLutuxsSrDMUEouHcohufSkALTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742972251; c=relaxed/simple;
	bh=b5ANY6pw6aquZ7z2wPudBNZpjR+oJr6jVAx4snkDOrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOG9lpEeDH5QumhrLsJlRVH8UbGDHuKgDmIzSKH7uSv2ohLwLjFP1G/r3V4XFywKxfUvcdsdyy6J+Y2IKkluoCy2QFwawyuBj4PzJ2vBYAvdHSHoG6FEfLLfU/fENU/MQF3zLJDEePjbZ+D3/XdkPS2IUsOe+M04l4WO0Phi4Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=KHsb+1Se; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-226185948ffso126408335ad.0
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 23:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1742972248; x=1743577048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n8sYS0mGBFpzdWCqih7tNQr0/K62dVE67VsyJQp2bF4=;
        b=KHsb+1SeeV8rf+fTR2HZvIKYcIJdD69C8hX2uLOVmUDSFM29pFmrQb8N/EbYTI47pZ
         dsh8TDqye2+w0ZMmmnmCwshA2LQL7NQGNR1O/BNe6Yeq38l2uXPhLkbr8N/DGtWuzbxx
         s/X7VuJ2AvvB7n06WNlwEdVJaAMUaaRZRqj+ax8SSATad9wuR/0BnD7f7+T5QzvsgI2c
         27fVrRHTR5lRTsdfD9dFm+P/xHGpGOX3dH0etpffjvWYCfxbP68UUcZ0NDvuxp00kju6
         U1EDbHd5PbbGoZdlRL3UjDP7aTU9LWBC4Bf9YOGZYPc1vkxQH3DE1lQn+LEB8LaH5ey2
         01Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742972248; x=1743577048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n8sYS0mGBFpzdWCqih7tNQr0/K62dVE67VsyJQp2bF4=;
        b=UOzYL0+yM3uBVHW3+BU7Mi1qFqYplCUEycg55K9Hf7bU8AwSZIoe4fr830RQDtmjOB
         TeaFYiDEZoIAkrigKNqcCO9MJmG/DlZxMxMsGRHDTB1wBMfVow8RnrBejVKYQSejOxlG
         3a2nlHjESvwNPxt2NaT0iLdUveO5iYZcU5D3C5rdiYOlsTSukDgmgh2xGG+WZltADTlM
         WR4TmVfmpzSb9kQXGB6KxWm8f4rVQaPhhJ4JDBFM16+F3zhVyhCpvH1THBS03wzDtFZM
         S4Qx6zrw44mnUknD5IAbmP7DdyozZQpz891vAAPxn2ntG8m8OIUqeIxdK0Efx5FTfHC0
         nN8A==
X-Forwarded-Encrypted: i=1; AJvYcCX5jb0jPogxUgtBW7BDm5kM1bfx3nhUqBMI2IQ4b4siH3uTqxhcOO+ZxrUxbITZy3e1kBo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzBaoupbA0Jzetot7l7mixrB2SWbYCU5rOOFNA5BXkvnT5Vh+f
	EYDODMc1jd7xrfO6W2OrZ32dqe3vxWfghoMnp9qFGL6BaUzTCKi8Mt4pKywDsCo=
X-Gm-Gg: ASbGncsYFmyXFyejDois+LBwLQWdrsoIjL+wc1i+0TwFX6E9vdFtLgd4oaO3pskUpw0
	t0nVpqErcwnhQjvu2kGT8JIXuqnfYze95TCm1yzu4Uc5JqztcSyD1JCLlF63A3U1daU+DXFZhQv
	EI5B9LxySLSilW2Lr3HHbROVwrdstFHU6aWzM5yZ5KjMhqIUoRxNLrtkdW1IMLMyKO0KP2eWtXa
	Av+g6mmie+jo8/fG69zMb8phydrSQX9xfQmkDqZgbeHUdJ8sN6AJnvxpISYYcPIqFISSnvuhoze
	8TflrlhfPXt40rYDqaXk8Dj7JbQdLV8cd3s0pbWr4QkRnOvwbI6zefL8+LTkYaGWtGoqdAtPP3R
	1VlNUoZD1to0229VE
X-Google-Smtp-Source: AGHT+IH0ang+2XFqtIDSGLqN8uYyeTYD9gQBM1UWFsOgO0amceh8OAp2LnSh1T9B9MZgjZdK3NL43Q==
X-Received: by 2002:aa7:88c9:0:b0:730:7600:aeab with SMTP id d2e1a72fcca58-739059c5da7mr31327771b3a.13.1742972247623;
        Tue, 25 Mar 2025 23:57:27 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390611c8d1sm11788817b3a.105.2025.03.25.23.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 23:57:27 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 09/10] riscv: Add cpu-type command-line option
Date: Wed, 26 Mar 2025 12:26:43 +0530
Message-ID: <20250326065644.73765-10-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250326065644.73765-1-apatel@ventanamicro.com>
References: <20250326065644.73765-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, the KVMTOOL always creates a VM with all available
ISA extensions virtualized by the in-kernel KVM module.

For better flexibility, add cpu-type command-line option using
which users can select one of the available CPU types for VM.

There are two CPU types supported at the moment namely "min"
and "max". The "min" CPU type implies VCPU with rv[64|32]imafdc
ISA whereas the "max" CPU type implies VCPU with all available
ISA extensions.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/aia.c                         |   2 +-
 riscv/fdt.c                         | 220 +++++++++++++++++-----------
 riscv/include/kvm/kvm-arch.h        |   2 +
 riscv/include/kvm/kvm-config-arch.h |   5 +
 riscv/kvm.c                         |   2 +
 5 files changed, 143 insertions(+), 88 deletions(-)

diff --git a/riscv/aia.c b/riscv/aia.c
index 21d9704..cad53d4 100644
--- a/riscv/aia.c
+++ b/riscv/aia.c
@@ -209,7 +209,7 @@ void aia__create(struct kvm *kvm)
 		.flags = 0,
 	};
 
-	if (kvm->cfg.arch.ext_disabled[KVM_RISCV_ISA_EXT_SSAIA])
+	if (riscv__isa_extension_disabled(kvm, KVM_RISCV_ISA_EXT_SSAIA))
 		return;
 
 	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &aia_device);
diff --git a/riscv/fdt.c b/riscv/fdt.c
index 46efb47..4c018c8 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -13,82 +13,134 @@ struct isa_ext_info {
 	const char *name;
 	unsigned long ext_id;
 	bool multi_letter;
+	bool min_cpu_included;
 };
 
 struct isa_ext_info isa_info_arr[] = {
-	/* single-letter */
-	{"a", KVM_RISCV_ISA_EXT_A, false},
-	{"c", KVM_RISCV_ISA_EXT_C, false},
-	{"d", KVM_RISCV_ISA_EXT_D, false},
-	{"f", KVM_RISCV_ISA_EXT_F, false},
-	{"h", KVM_RISCV_ISA_EXT_H, false},
-	{"i", KVM_RISCV_ISA_EXT_I, false},
-	{"m", KVM_RISCV_ISA_EXT_M, false},
-	{"v", KVM_RISCV_ISA_EXT_V, false},
+	/* single-letter ordered canonically as "IEMAFDQCLBJTPVNSUHKORWXYZG" */
+	{"i",		KVM_RISCV_ISA_EXT_I,		false, true},
+	{"m",		KVM_RISCV_ISA_EXT_M,		false, true},
+	{"a",		KVM_RISCV_ISA_EXT_A,		false, true},
+	{"f",		KVM_RISCV_ISA_EXT_F,		false, true},
+	{"d",		KVM_RISCV_ISA_EXT_D,		false, true},
+	{"c",		KVM_RISCV_ISA_EXT_C,		false, true},
+	{"v",		KVM_RISCV_ISA_EXT_V,		false, false},
+	{"h",		KVM_RISCV_ISA_EXT_H,		false, false},
 	/* multi-letter sorted alphabetically */
-	{"smnpm", KVM_RISCV_ISA_EXT_SMNPM, true},
-	{"smstateen", KVM_RISCV_ISA_EXT_SMSTATEEN, true},
-	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA, true},
-	{"sscofpmf", KVM_RISCV_ISA_EXT_SSCOFPMF, true},
-	{"ssnpm", KVM_RISCV_ISA_EXT_SSNPM, true},
-	{"sstc", KVM_RISCV_ISA_EXT_SSTC, true},
-	{"svade", KVM_RISCV_ISA_EXT_SVADE, true},
-	{"svadu", KVM_RISCV_ISA_EXT_SVADU, true},
-	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL, true},
-	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT, true},
-	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT, true},
-	{"svvptc", KVM_RISCV_ISA_EXT_SVVPTC, true},
-	{"zabha", KVM_RISCV_ISA_EXT_ZABHA, true},
-	{"zacas", KVM_RISCV_ISA_EXT_ZACAS, true},
-	{"zawrs", KVM_RISCV_ISA_EXT_ZAWRS, true},
-	{"zba", KVM_RISCV_ISA_EXT_ZBA, true},
-	{"zbb", KVM_RISCV_ISA_EXT_ZBB, true},
-	{"zbc", KVM_RISCV_ISA_EXT_ZBC, true},
-	{"zbkb", KVM_RISCV_ISA_EXT_ZBKB, true},
-	{"zbkc", KVM_RISCV_ISA_EXT_ZBKC, true},
-	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX, true},
-	{"zbs", KVM_RISCV_ISA_EXT_ZBS, true},
-	{"zca", KVM_RISCV_ISA_EXT_ZCA, true},
-	{"zcb", KVM_RISCV_ISA_EXT_ZCB, true},
-	{"zcd", KVM_RISCV_ISA_EXT_ZCD, true},
-	{"zcf", KVM_RISCV_ISA_EXT_ZCF, true},
-	{"zcmop", KVM_RISCV_ISA_EXT_ZCMOP, true},
-	{"zfa", KVM_RISCV_ISA_EXT_ZFA, true},
-	{"zfh", KVM_RISCV_ISA_EXT_ZFH, true},
-	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN, true},
-	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM, true},
-	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ, true},
-	{"ziccrse", KVM_RISCV_ISA_EXT_ZICCRSE, true},
-	{"zicntr", KVM_RISCV_ISA_EXT_ZICNTR, true},
-	{"zicond", KVM_RISCV_ISA_EXT_ZICOND, true},
-	{"zicsr", KVM_RISCV_ISA_EXT_ZICSR, true},
-	{"zifencei", KVM_RISCV_ISA_EXT_ZIFENCEI, true},
-	{"zihintntl", KVM_RISCV_ISA_EXT_ZIHINTNTL, true},
-	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE, true},
-	{"zihpm", KVM_RISCV_ISA_EXT_ZIHPM, true},
-	{"zimop", KVM_RISCV_ISA_EXT_ZIMOP, true},
-	{"zknd", KVM_RISCV_ISA_EXT_ZKND, true},
-	{"zkne", KVM_RISCV_ISA_EXT_ZKNE, true},
-	{"zknh", KVM_RISCV_ISA_EXT_ZKNH, true},
-	{"zkr", KVM_RISCV_ISA_EXT_ZKR, true},
-	{"zksed", KVM_RISCV_ISA_EXT_ZKSED, true},
-	{"zksh", KVM_RISCV_ISA_EXT_ZKSH, true},
-	{"zkt", KVM_RISCV_ISA_EXT_ZKT, true},
-	{"ztso", KVM_RISCV_ISA_EXT_ZTSO, true},
-	{"zvbb", KVM_RISCV_ISA_EXT_ZVBB, true},
-	{"zvbc", KVM_RISCV_ISA_EXT_ZVBC, true},
-	{"zvfh", KVM_RISCV_ISA_EXT_ZVFH, true},
-	{"zvfhmin", KVM_RISCV_ISA_EXT_ZVFHMIN, true},
-	{"zvkb", KVM_RISCV_ISA_EXT_ZVKB, true},
-	{"zvkg", KVM_RISCV_ISA_EXT_ZVKG, true},
-	{"zvkned", KVM_RISCV_ISA_EXT_ZVKNED, true},
-	{"zvknha", KVM_RISCV_ISA_EXT_ZVKNHA, true},
-	{"zvknhb", KVM_RISCV_ISA_EXT_ZVKNHB, true},
-	{"zvksed", KVM_RISCV_ISA_EXT_ZVKSED, true},
-	{"zvksh", KVM_RISCV_ISA_EXT_ZVKSH, true},
-	{"zvkt", KVM_RISCV_ISA_EXT_ZVKT, true},
+	{"smnpm",	KVM_RISCV_ISA_EXT_SMNPM,	true, false},
+	{"smstateen",	KVM_RISCV_ISA_EXT_SMSTATEEN,	true, false},
+	{"ssaia",	KVM_RISCV_ISA_EXT_SSAIA,	true, false},
+	{"sscofpmf",	KVM_RISCV_ISA_EXT_SSCOFPMF,	true, false},
+	{"ssnpm",	KVM_RISCV_ISA_EXT_SSNPM,	true, false},
+	{"sstc",	KVM_RISCV_ISA_EXT_SSTC,		true, false},
+	{"svade",	KVM_RISCV_ISA_EXT_SVADE,	true, false},
+	{"svadu",	KVM_RISCV_ISA_EXT_SVADU,	true, false},
+	{"svinval",	KVM_RISCV_ISA_EXT_SVINVAL,	true, false},
+	{"svnapot",	KVM_RISCV_ISA_EXT_SVNAPOT,	true, false},
+	{"svpbmt",	KVM_RISCV_ISA_EXT_SVPBMT,	true, false},
+	{"svvptc",	KVM_RISCV_ISA_EXT_SVVPTC,	true, false},
+	{"zabha",	KVM_RISCV_ISA_EXT_ZABHA,	true, false},
+	{"zacas",	KVM_RISCV_ISA_EXT_ZACAS,	true, false},
+	{"zawrs",	KVM_RISCV_ISA_EXT_ZAWRS,	true, false},
+	{"zba",		KVM_RISCV_ISA_EXT_ZBA,		true, false},
+	{"zbb",		KVM_RISCV_ISA_EXT_ZBB,		true, false},
+	{"zbc",		KVM_RISCV_ISA_EXT_ZBC,		true, false},
+	{"zbkb",	KVM_RISCV_ISA_EXT_ZBKB,		true, false},
+	{"zbkc",	KVM_RISCV_ISA_EXT_ZBKC,		true, false},
+	{"zbkx",	KVM_RISCV_ISA_EXT_ZBKX,		true, false},
+	{"zbs",		KVM_RISCV_ISA_EXT_ZBS,		true, false},
+	{"zca",		KVM_RISCV_ISA_EXT_ZCA,		true, false},
+	{"zcb",		KVM_RISCV_ISA_EXT_ZCB,		true, false},
+	{"zcd",		KVM_RISCV_ISA_EXT_ZCD,		true, false},
+	{"zcf",		KVM_RISCV_ISA_EXT_ZCF,		true, false},
+	{"zcmop",	KVM_RISCV_ISA_EXT_ZCMOP,	true, false},
+	{"zfa",		KVM_RISCV_ISA_EXT_ZFA,		true, false},
+	{"zfh",		KVM_RISCV_ISA_EXT_ZFH,		true, false},
+	{"zfhmin",	KVM_RISCV_ISA_EXT_ZFHMIN,	true, false},
+	{"zicbom",	KVM_RISCV_ISA_EXT_ZICBOM,	true, false},
+	{"zicboz",	KVM_RISCV_ISA_EXT_ZICBOZ,	true, false},
+	{"ziccrse",	KVM_RISCV_ISA_EXT_ZICCRSE,	true, false},
+	{"zicntr",	KVM_RISCV_ISA_EXT_ZICNTR,	true, false},
+	{"zicond",	KVM_RISCV_ISA_EXT_ZICOND,	true, false},
+	{"zicsr",	KVM_RISCV_ISA_EXT_ZICSR,	true, false},
+	{"zifencei",	KVM_RISCV_ISA_EXT_ZIFENCEI,	true, false},
+	{"zihintntl",	KVM_RISCV_ISA_EXT_ZIHINTNTL,	true, false},
+	{"zihintpause",	KVM_RISCV_ISA_EXT_ZIHINTPAUSE,	true, false},
+	{"zihpm",	KVM_RISCV_ISA_EXT_ZIHPM,	true, false},
+	{"zimop",	KVM_RISCV_ISA_EXT_ZIMOP,	true, false},
+	{"zknd",	KVM_RISCV_ISA_EXT_ZKND,		true, false},
+	{"zkne",	KVM_RISCV_ISA_EXT_ZKNE,		true, false},
+	{"zknh",	KVM_RISCV_ISA_EXT_ZKNH,		true, false},
+	{"zkr",		KVM_RISCV_ISA_EXT_ZKR,		true, false},
+	{"zksed",	KVM_RISCV_ISA_EXT_ZKSED,	true, false},
+	{"zksh",	KVM_RISCV_ISA_EXT_ZKSH,		true, false},
+	{"zkt",		KVM_RISCV_ISA_EXT_ZKT,		true, false},
+	{"ztso",	KVM_RISCV_ISA_EXT_ZTSO,		true, false},
+	{"zvbb",	KVM_RISCV_ISA_EXT_ZVBB,		true, false},
+	{"zvbc",	KVM_RISCV_ISA_EXT_ZVBC,		true, false},
+	{"zvfh",	KVM_RISCV_ISA_EXT_ZVFH,		true, false},
+	{"zvfhmin",	KVM_RISCV_ISA_EXT_ZVFHMIN,	true, false},
+	{"zvkb",	KVM_RISCV_ISA_EXT_ZVKB,		true, false},
+	{"zvkg",	KVM_RISCV_ISA_EXT_ZVKG,		true, false},
+	{"zvkned",	KVM_RISCV_ISA_EXT_ZVKNED,	true, false},
+	{"zvknha",	KVM_RISCV_ISA_EXT_ZVKNHA,	true, false},
+	{"zvknhb",	KVM_RISCV_ISA_EXT_ZVKNHB,	true, false},
+	{"zvksed",	KVM_RISCV_ISA_EXT_ZVKSED,	true, false},
+	{"zvksh",	KVM_RISCV_ISA_EXT_ZVKSH,	true, false},
+	{"zvkt",	KVM_RISCV_ISA_EXT_ZVKT,		true, false},
 };
 
+static bool __isa_ext_disabled(struct kvm *kvm, struct isa_ext_info *info)
+{
+	if (!strncmp(kvm->cfg.arch.cpu_type, "min", 3) &&
+	    !info->min_cpu_included)
+		return true;
+
+	return kvm->cfg.arch.ext_disabled[info->ext_id];
+}
+
+static bool __isa_ext_warn_disable_failure(struct kvm *kvm, struct isa_ext_info *info)
+{
+	if (!strncmp(kvm->cfg.arch.cpu_type, "min", 3) &&
+	    !info->min_cpu_included)
+		return false;
+
+	return true;
+}
+
+bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_ext_id)
+{
+	struct isa_ext_info *info = NULL;
+	unsigned long i;
+
+	for (i = 0; i < ARRAY_SIZE(isa_info_arr); i++) {
+		if (isa_info_arr[i].ext_id == isa_ext_id) {
+			info = &isa_info_arr[i];
+			break;
+		}
+	}
+	if (!info)
+		return true;
+
+	return __isa_ext_disabled(kvm, info);
+}
+
+int riscv__cpu_type_parser(const struct option *opt, const char *arg, int unset)
+{
+	struct kvm *kvm = opt->ptr;
+
+	if ((strncmp(arg, "min", 3) && strncmp(arg, "max", 3)) || strlen(arg) != 3)
+		die("Invalid CPU type %s\n", arg);
+
+	if (!strncmp(arg, "max", 3))
+		kvm->cfg.arch.cpu_type = "max";
+
+	if (!strncmp(arg, "min", 3))
+		kvm->cfg.arch.cpu_type = "min";
+
+	return 0;
+}
+
 static void dump_fdt(const char *dtb_file, void *fdt)
 {
 	int count, fd;
@@ -108,10 +160,8 @@ static void dump_fdt(const char *dtb_file, void *fdt)
 #define CPU_NAME_MAX_LEN 15
 static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 {
-	int cpu, pos, i, index, valid_isa_len;
-	const char *valid_isa_order = "IEMAFDQCLBJTPVNSUHKORWXYZG";
-	int arr_sz = ARRAY_SIZE(isa_info_arr);
 	unsigned long cbom_blksz = 0, cboz_blksz = 0, satp_mode = 0;
+	int i, cpu, pos, arr_sz = ARRAY_SIZE(isa_info_arr);
 
 	_FDT(fdt_begin_node(fdt, "cpus"));
 	_FDT(fdt_property_cell(fdt, "#address-cells", 0x1));
@@ -131,18 +181,8 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 
 		snprintf(cpu_isa, CPU_ISA_MAX_LEN, "rv%ld", vcpu->riscv_xlen);
 		pos = strlen(cpu_isa);
-		valid_isa_len = strlen(valid_isa_order);
-		for (i = 0; i < valid_isa_len; i++) {
-			index = valid_isa_order[i] - 'A';
-			if (vcpu->riscv_isa & (1 << (index)))
-				cpu_isa[pos++] = 'a' + index;
-		}
 
 		for (i = 0; i < arr_sz; i++) {
-			/* Skip single-letter extensions since these are taken care */
-			if (!isa_info_arr[i].multi_letter)
-				continue;
-
 			reg.id = RISCV_ISA_EXT_REG(isa_info_arr[i].ext_id);
 			reg.addr = (unsigned long)&isa_ext_out;
 			if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
@@ -151,9 +191,10 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 				/* This extension is not available in hardware */
 				continue;
 
-			if (kvm->cfg.arch.ext_disabled[isa_info_arr[i].ext_id]) {
+			if (__isa_ext_disabled(kvm, &isa_info_arr[i])) {
 				isa_ext_out = 0;
-				if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+				if ((ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0) &&
+				     __isa_ext_warn_disable_failure(kvm, &isa_info_arr[i]))
 					pr_warning("Failed to disable %s ISA exension\n",
 						   isa_info_arr[i].name);
 				continue;
@@ -178,8 +219,13 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 					   isa_info_arr[i].name);
 				break;
 			}
-			pos += snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN - pos, "_%s",
-					isa_info_arr[i].name);
+
+			if (isa_info_arr[i].multi_letter)
+				pos += snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN - pos, "_%s",
+						isa_info_arr[i].name);
+			else
+				pos += snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN - pos, "%s",
+						isa_info_arr[i].name);
 		}
 		cpu_isa[pos] = '\0';
 
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index f0f469f..1bb2d32 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -90,6 +90,8 @@ enum irqchip_type {
 	IRQCHIP_AIA
 };
 
+bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long ext_id);
+
 extern enum irqchip_type riscv_irqchip;
 extern bool riscv_irqchip_inkernel;
 extern void (*riscv_irqchip_trigger)(struct kvm *kvm, int irq,
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 7e54d8a..26b1b50 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -4,6 +4,7 @@
 #include "kvm/parse-options.h"
 
 struct kvm_config_arch {
+	const char	*cpu_type;
 	const char	*dump_dtb_filename;
 	u64		suspend_seconds;
 	u64		custom_mvendorid;
@@ -13,8 +14,12 @@ struct kvm_config_arch {
 	bool		sbi_ext_disabled[KVM_RISCV_SBI_EXT_MAX];
 };
 
+int riscv__cpu_type_parser(const struct option *opt, const char *arg, int unset);
+
 #define OPT_ARCH_RUN(pfx, cfg)						\
 	pfx,								\
+	OPT_CALLBACK('\0', "cpu-type", kvm, "min or max",		\
+		     "Choose the cpu type (default is max).", riscv__cpu_type_parser, kvm),\
 	OPT_STRING('\0', "dump-dtb", &(cfg)->dump_dtb_filename,		\
 		   ".dtb file", "Dump generated .dtb to specified file"),\
 	OPT_U64('\0', "suspend-seconds",				\
diff --git a/riscv/kvm.c b/riscv/kvm.c
index 1d49479..6a1b154 100644
--- a/riscv/kvm.c
+++ b/riscv/kvm.c
@@ -20,6 +20,8 @@ u64 kvm__arch_default_ram_address(void)
 
 void kvm__arch_validate_cfg(struct kvm *kvm)
 {
+	if (!kvm->cfg.arch.cpu_type)
+		kvm->cfg.arch.cpu_type = "max";
 }
 
 bool kvm__arch_cpu_supports_vm(void)
-- 
2.43.0



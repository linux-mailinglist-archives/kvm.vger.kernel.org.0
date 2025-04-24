Return-Path: <kvm+bounces-44193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59F30A9B264
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:33:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 908B24A42D4
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF8F27CCD3;
	Thu, 24 Apr 2025 15:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ASn5unyW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com [209.85.215.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E1E1A5B94
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 15:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745508767; cv=none; b=V2lQXSPvdR2EryknKGFAdfbhlSCUih1lVRMhqjD8HTlG7ekApvoqYisBJ9h9HqgoE/fX3sulfzg2AiPiKl+iomzfyk5gl/EEFTJlAj9Au5cS1zLN+HKMnc5oAscH9yB5WA8S/F/ix9SK4XBJ6sTnHVRbhc2fcOsvELEX7pmbhlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745508767; c=relaxed/simple;
	bh=UnNPblNI82485JOZYj9GeHN1HPG+H7B5dNKdkxXbwds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRrss3/0hbo5SBAcjATQpVpjC2wraTau/0C04gjLYiY6gS3/6/AQ+rXCgaRQGbTWL+tjZl5dMZbN8LlzjKyeRBx+UvrBITwhs5+IFln5WngVeriO7oyS9IC1UPL1ZDfVwZvW1/JWKPhgiQzOPVmR5KE3hC19LtefHbZYYIw8cns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ASn5unyW; arc=none smtp.client-ip=209.85.215.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f193.google.com with SMTP id 41be03b00d2f7-b061a06f127so775340a12.2
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 08:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745508765; x=1746113565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Frtk/o0Vpadsquf+T/ueIK+pphbVVL4+IpDtNAsinII=;
        b=ASn5unyWDFkNjZnYRk5S4qQSsEYyr9txvvgCKXAQOUIktFyxQ3lxKKvYL0YNm6sQYf
         mujdDcTmKzeENVZR6rPuXPJBJawYml98BFleXR+HxODP00Z+BGFENseNaDf7o2wuwKIk
         42RcfO7kXjgGkDC8Kic0hO6Qe4aSIWAm55ZiIf75j2NGDavkgI/NJXikSHZhx6indSxW
         8NUNgcvb/gh1X/L3BewH+muvvroiy/Cx0TMpxqObEcpq+maKu6qJu8nMHDs6fT8ihFfe
         RKZbEM3tePc4ihqKxmmJn9l4DmMxmkKnWGMMU0Nhg6yiI/Emz3dK/PvDavmYRxLfPeAK
         w1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745508765; x=1746113565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Frtk/o0Vpadsquf+T/ueIK+pphbVVL4+IpDtNAsinII=;
        b=HAv2im+z49hyOB8NhnW00tRI91fF7vSUIHWI/XegFBTs1eXFKtOX284MAXZ3DoTMlp
         vT6U1eBc5oFCUB/5pSqoesO5101Q97vMTpyXqKD6QsFDCnxHQfD2CgKtkbKZCON7D+IN
         gycZ8Bi19eY58lhR/P2y2pyBO8V2EbwhorMkII0m5gTdlQyDezbEyfujdF8vjZ0C3SSO
         bOobB0osbsU1DLvtAw9dAwbkRhtEYI0gcmBDIJZje1vmhDF33OEDGIthlsOWa7Cd1fJr
         nKWMmUj4lrV228v0lkzC7289d8mkKm33BGktgsrnSgPe2p/8c88HcHu3/JckPsmeyA77
         BGew==
X-Forwarded-Encrypted: i=1; AJvYcCXjR+nXKMa+Lm2nE8pz8B0gHcJSYZDU+Mxa+D8cETaM7bu+dcFWkxP+ThMsKdxS3cV8Ysg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxngCjbcevs6SjYmsL7qOxa4CHswLgmYid59GBX7/stDI4nqZI7
	H89vRbBRQPkAox7pDmHq+dJQCTy/hkv8qPj6awEBUSjxuZbcQ7/JG+LJf1SyM5UHBUV0V27SREz
	82XxxhHTp
X-Gm-Gg: ASbGncvlw3Ytp2U8aDmMfLhD2qzEkFhpuqssc2Tr5qz+CBy/qFoBfcYz5urJKu1mRrp
	vCjcRD4qgvWT2xWRxNgmqx8mNvuwM11OSwnuctS/hymVDjMJCvJbwIkkJBsLZvdkcg0TTbOnFtt
	trW0lkYED7Z15KW8dUkBllzkFgjEW9Cr3rnsEjDrP5O9skyNoO4bffqsd3agmm7RKrA25XcdfwS
	zLWnwmLPX1LX0frkJDkk1u6/E9OAwpLPGlYe0CoF0h7Cm7q+PJWEq+qVIKAZrRgfiqo46/08elp
	epZzGJkcgOJ45Hgn7+6DOLTeuoxu86mR0KdpZ5JTLQcZvIBShaJbhfbxqagrFMuX4CHmXWHMadv
	6SO0I
X-Google-Smtp-Source: AGHT+IGgyLIWZm8J6v5M7H7WaWUHuNkzZQ49TFQOQikE/n/Gi5I96krTD1wd+PSoMJ7aBOWvEIgmDg==
X-Received: by 2002:a05:6a21:4006:b0:1f5:5b2a:f641 with SMTP id adf61e73a8af0-20444fc068bmr4490835637.28.1745508765283;
        Thu, 24 Apr 2025 08:32:45 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15f8597f5csm1360610a12.43.2025.04.24.08.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 08:32:44 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 08/10] riscv: Include single-letter extensions in isa_info_arr[]
Date: Thu, 24 Apr 2025 21:01:57 +0530
Message-ID: <20250424153159.289441-9-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250424153159.289441-1-apatel@ventanamicro.com>
References: <20250424153159.289441-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, the isa_info_arr[] only include multi-letter extensions but
the KVM ONE_REG interface covers both single-letter and multi-letter
extensions so extend isa_info_arr[] to include single-letter extensions.

This also allows combining two loops in the generate_cpu_nodes()
function into one loop.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c | 148 +++++++++++++++++++++++++++-------------------------
 1 file changed, 76 insertions(+), 72 deletions(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 251821e..c741fd8 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -12,71 +12,81 @@
 struct isa_ext_info {
 	const char *name;
 	unsigned long ext_id;
+	bool single_letter;
 };
 
 struct isa_ext_info isa_info_arr[] = {
-	/* sorted alphabetically */
-	{"smnpm", KVM_RISCV_ISA_EXT_SMNPM},
-	{"smstateen", KVM_RISCV_ISA_EXT_SMSTATEEN},
-	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA},
-	{"sscofpmf", KVM_RISCV_ISA_EXT_SSCOFPMF},
-	{"ssnpm", KVM_RISCV_ISA_EXT_SSNPM},
-	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
-	{"svade", KVM_RISCV_ISA_EXT_SVADE},
-	{"svadu", KVM_RISCV_ISA_EXT_SVADU},
-	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
-	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
-	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
-	{"svvptc", KVM_RISCV_ISA_EXT_SVVPTC},
-	{"zabha", KVM_RISCV_ISA_EXT_ZABHA},
-	{"zacas", KVM_RISCV_ISA_EXT_ZACAS},
-	{"zawrs", KVM_RISCV_ISA_EXT_ZAWRS},
-	{"zba", KVM_RISCV_ISA_EXT_ZBA},
-	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
-	{"zbc", KVM_RISCV_ISA_EXT_ZBC},
-	{"zbkb", KVM_RISCV_ISA_EXT_ZBKB},
-	{"zbkc", KVM_RISCV_ISA_EXT_ZBKC},
-	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX},
-	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
-	{"zca", KVM_RISCV_ISA_EXT_ZCA},
-	{"zcb", KVM_RISCV_ISA_EXT_ZCB},
-	{"zcd", KVM_RISCV_ISA_EXT_ZCD},
-	{"zcf", KVM_RISCV_ISA_EXT_ZCF},
-	{"zcmop", KVM_RISCV_ISA_EXT_ZCMOP},
-	{"zfa", KVM_RISCV_ISA_EXT_ZFA},
-	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
-	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
-	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
-	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
-	{"ziccrse", KVM_RISCV_ISA_EXT_ZICCRSE},
-	{"zicntr", KVM_RISCV_ISA_EXT_ZICNTR},
-	{"zicond", KVM_RISCV_ISA_EXT_ZICOND},
-	{"zicsr", KVM_RISCV_ISA_EXT_ZICSR},
-	{"zifencei", KVM_RISCV_ISA_EXT_ZIFENCEI},
-	{"zihintntl", KVM_RISCV_ISA_EXT_ZIHINTNTL},
-	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
-	{"zihpm", KVM_RISCV_ISA_EXT_ZIHPM},
-	{"zimop", KVM_RISCV_ISA_EXT_ZIMOP},
-	{"zknd", KVM_RISCV_ISA_EXT_ZKND},
-	{"zkne", KVM_RISCV_ISA_EXT_ZKNE},
-	{"zknh", KVM_RISCV_ISA_EXT_ZKNH},
-	{"zkr", KVM_RISCV_ISA_EXT_ZKR},
-	{"zksed", KVM_RISCV_ISA_EXT_ZKSED},
-	{"zksh", KVM_RISCV_ISA_EXT_ZKSH},
-	{"zkt", KVM_RISCV_ISA_EXT_ZKT},
-	{"ztso", KVM_RISCV_ISA_EXT_ZTSO},
-	{"zvbb", KVM_RISCV_ISA_EXT_ZVBB},
-	{"zvbc", KVM_RISCV_ISA_EXT_ZVBC},
-	{"zvfh", KVM_RISCV_ISA_EXT_ZVFH},
-	{"zvfhmin", KVM_RISCV_ISA_EXT_ZVFHMIN},
-	{"zvkb", KVM_RISCV_ISA_EXT_ZVKB},
-	{"zvkg", KVM_RISCV_ISA_EXT_ZVKG},
-	{"zvkned", KVM_RISCV_ISA_EXT_ZVKNED},
-	{"zvknha", KVM_RISCV_ISA_EXT_ZVKNHA},
-	{"zvknhb", KVM_RISCV_ISA_EXT_ZVKNHB},
-	{"zvksed", KVM_RISCV_ISA_EXT_ZVKSED},
-	{"zvksh", KVM_RISCV_ISA_EXT_ZVKSH},
-	{"zvkt", KVM_RISCV_ISA_EXT_ZVKT},
+	/* single-letter ordered canonically as "IEMAFDQCLBJTPVNSUHKORWXYZG" */
+	{"i",		KVM_RISCV_ISA_EXT_I,	.single_letter = true},
+	{"m",		KVM_RISCV_ISA_EXT_M,	.single_letter = true},
+	{"a",		KVM_RISCV_ISA_EXT_A,	.single_letter = true},
+	{"f",		KVM_RISCV_ISA_EXT_F,	.single_letter = true},
+	{"d",		KVM_RISCV_ISA_EXT_D,	.single_letter = true},
+	{"c",		KVM_RISCV_ISA_EXT_C,	.single_letter = true},
+	{"v",		KVM_RISCV_ISA_EXT_V,	.single_letter = true},
+	{"h",		KVM_RISCV_ISA_EXT_H,	.single_letter = true},
+	/* multi-letter sorted alphabetically */
+	{"smnpm",	KVM_RISCV_ISA_EXT_SMNPM},
+	{"smstateen",	KVM_RISCV_ISA_EXT_SMSTATEEN},
+	{"ssaia",	KVM_RISCV_ISA_EXT_SSAIA},
+	{"sscofpmf",	KVM_RISCV_ISA_EXT_SSCOFPMF},
+	{"ssnpm",	KVM_RISCV_ISA_EXT_SSNPM},
+	{"sstc",	KVM_RISCV_ISA_EXT_SSTC},
+	{"svade",	KVM_RISCV_ISA_EXT_SVADE},
+	{"svadu",	KVM_RISCV_ISA_EXT_SVADU},
+	{"svinval",	KVM_RISCV_ISA_EXT_SVINVAL},
+	{"svnapot",	KVM_RISCV_ISA_EXT_SVNAPOT},
+	{"svpbmt",	KVM_RISCV_ISA_EXT_SVPBMT},
+	{"svvptc",	KVM_RISCV_ISA_EXT_SVVPTC},
+	{"zabha",	KVM_RISCV_ISA_EXT_ZABHA},
+	{"zacas",	KVM_RISCV_ISA_EXT_ZACAS},
+	{"zawrs",	KVM_RISCV_ISA_EXT_ZAWRS},
+	{"zba",		KVM_RISCV_ISA_EXT_ZBA},
+	{"zbb",		KVM_RISCV_ISA_EXT_ZBB},
+	{"zbc",		KVM_RISCV_ISA_EXT_ZBC},
+	{"zbkb",	KVM_RISCV_ISA_EXT_ZBKB},
+	{"zbkc",	KVM_RISCV_ISA_EXT_ZBKC},
+	{"zbkx",	KVM_RISCV_ISA_EXT_ZBKX},
+	{"zbs",		KVM_RISCV_ISA_EXT_ZBS},
+	{"zca",		KVM_RISCV_ISA_EXT_ZCA},
+	{"zcb",		KVM_RISCV_ISA_EXT_ZCB},
+	{"zcd",		KVM_RISCV_ISA_EXT_ZCD},
+	{"zcf",		KVM_RISCV_ISA_EXT_ZCF},
+	{"zcmop",	KVM_RISCV_ISA_EXT_ZCMOP},
+	{"zfa",		KVM_RISCV_ISA_EXT_ZFA},
+	{"zfh",		KVM_RISCV_ISA_EXT_ZFH},
+	{"zfhmin",	KVM_RISCV_ISA_EXT_ZFHMIN},
+	{"zicbom",	KVM_RISCV_ISA_EXT_ZICBOM},
+	{"zicboz",	KVM_RISCV_ISA_EXT_ZICBOZ},
+	{"ziccrse",	KVM_RISCV_ISA_EXT_ZICCRSE},
+	{"zicntr",	KVM_RISCV_ISA_EXT_ZICNTR},
+	{"zicond",	KVM_RISCV_ISA_EXT_ZICOND},
+	{"zicsr",	KVM_RISCV_ISA_EXT_ZICSR},
+	{"zifencei",	KVM_RISCV_ISA_EXT_ZIFENCEI},
+	{"zihintntl",	KVM_RISCV_ISA_EXT_ZIHINTNTL},
+	{"zihintpause",	KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
+	{"zihpm",	KVM_RISCV_ISA_EXT_ZIHPM},
+	{"zimop",	KVM_RISCV_ISA_EXT_ZIMOP},
+	{"zknd",	KVM_RISCV_ISA_EXT_ZKND},
+	{"zkne",	KVM_RISCV_ISA_EXT_ZKNE},
+	{"zknh",	KVM_RISCV_ISA_EXT_ZKNH},
+	{"zkr",		KVM_RISCV_ISA_EXT_ZKR},
+	{"zksed",	KVM_RISCV_ISA_EXT_ZKSED},
+	{"zksh",	KVM_RISCV_ISA_EXT_ZKSH},
+	{"zkt",		KVM_RISCV_ISA_EXT_ZKT},
+	{"ztso",	KVM_RISCV_ISA_EXT_ZTSO},
+	{"zvbb",	KVM_RISCV_ISA_EXT_ZVBB},
+	{"zvbc",	KVM_RISCV_ISA_EXT_ZVBC},
+	{"zvfh",	KVM_RISCV_ISA_EXT_ZVFH},
+	{"zvfhmin",	KVM_RISCV_ISA_EXT_ZVFHMIN},
+	{"zvkb",	KVM_RISCV_ISA_EXT_ZVKB},
+	{"zvkg",	KVM_RISCV_ISA_EXT_ZVKG},
+	{"zvkned",	KVM_RISCV_ISA_EXT_ZVKNED},
+	{"zvknha",	KVM_RISCV_ISA_EXT_ZVKNHA},
+	{"zvknhb",	KVM_RISCV_ISA_EXT_ZVKNHB},
+	{"zvksed",	KVM_RISCV_ISA_EXT_ZVKSED},
+	{"zvksh",	KVM_RISCV_ISA_EXT_ZVKSH},
+	{"zvkt",	KVM_RISCV_ISA_EXT_ZVKT},
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
@@ -98,10 +108,8 @@ static void dump_fdt(const char *dtb_file, void *fdt)
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
@@ -121,12 +129,6 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 
 		snprintf(cpu_isa, CPU_ISA_MAX_LEN, "rv%ld", vcpu->riscv_xlen);
 		pos = strlen(cpu_isa);
-		valid_isa_len = strlen(valid_isa_order);
-		for (i = 0; i < valid_isa_len; i++) {
-			index = valid_isa_order[i] - 'A';
-			if (vcpu->riscv_isa & (1 << (index)))
-				cpu_isa[pos++] = 'a' + index;
-		}
 
 		for (i = 0; i < arr_sz; i++) {
 			reg.id = RISCV_ISA_EXT_REG(isa_info_arr[i].ext_id);
@@ -164,7 +166,9 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 					   isa_info_arr[i].name);
 				break;
 			}
-			pos += snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN - pos, "_%s",
+
+			pos += snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN - pos, "%s%s",
+					isa_info_arr[i].single_letter ? "" : "_",
 					isa_info_arr[i].name);
 		}
 		cpu_isa[pos] = '\0';
-- 
2.43.0



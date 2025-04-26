Return-Path: <kvm+bounces-44408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5009A9DA4E
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 13:04:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1157E1B6636E
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 11:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78AAB227EBF;
	Sat, 26 Apr 2025 11:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="n8bq6hd+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com [209.85.216.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215C2227EB2
	for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 11:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745665478; cv=none; b=o4Roc7z71jC74So2m/j9Ejle3ya+P2CTyKjDfQjl59E26IOKoQSfYRO1Thl0jov9dnFJQ8g8tQnl3gFvkTyDyQ08ils84XEA6v9rqt051kruyGVZFtAYsclax7wbg+q4secTpuXGTWDzH7KsREHaBKU6WmKe80AVd6JFzAu6Yoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745665478; c=relaxed/simple;
	bh=4lN7mSQSym5plF5gP5p29ssRwo4P0t9w0zk5pnKwApw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYclHolrHbgZKWJJg4Wo3SEimkfX8KXd2uH8KZ04qLjrY0xf48X0X6wAb5XDTzyG2OGutBScmb3OAsQjawtmztKWAo9bXU5rKhroYxGZO4CgMQ/JU1C2pBldZFv08/peGm/xSHrhqPZ9dKOjqabPimnYk84tip2PxN60i+LDtVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=n8bq6hd+; arc=none smtp.client-ip=209.85.216.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f68.google.com with SMTP id 98e67ed59e1d1-301e05b90caso3474269a91.2
        for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 04:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745665476; x=1746270276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yYn/7MVNfoUYT5BM89IVGc1t8Fbskccdra0N4a7LYrg=;
        b=n8bq6hd+LNI+M+uR7NR5zirWVespWwMZE0X4C9e0Kvg/gTBik4mCHKairFMernuOOT
         Q8Z9+5GxL6CgaeuQKLUn8ZRB1tK397WMhfBgda6FiwbCTM8vOGOxRLY0NQEfaULBLTty
         hPLCccdH5X1Pq6UUw8RdKlAT/CY9dT9neZit7HPW8Hfcnr2iQcwYxDYS6AhVS4PF+FkL
         WonihkPBb4s5EkT/GQ5Vhk044E+FvcjvQpX3Et6UYb7ww5AHwBAiyRc09avHk6DcAAye
         q3vjgeycylVY3waAvLUwvi/iZJJIsiitxrpVIlfy0FQOYvFL9vOVOW1JvwiL0imAE/jz
         Xcng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745665476; x=1746270276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yYn/7MVNfoUYT5BM89IVGc1t8Fbskccdra0N4a7LYrg=;
        b=GDmkj14AMP/4cShXQntS/eTqMkS4ylsnsNTUXV0Y6AwUgIMJXtXvYJqgkTECbK5sPd
         w1HuKoGieSjrxpQIJa9OUS1ksxc4BZ5FTm5GIHFa/V8HRO9/cuW4LEs9Yo7vklz6x1hk
         fJpkXO3aoSZdLJmLGA2rk9URuzH9TahI+tqZ7tt66aHkW7OWkDS6WElDFj//Xr9v/PVj
         CrYFlShk5zHktT7qAOXDCOsz5u1dxe4pw17zsyg/xArZPCSt9clHIZKs/dOR4xiu3Uwl
         e3pJr+BZLxneNvpjcY1Qrq2TcxmcYKa5IC0KsI/IQNeNIS7C9AzezcQ0fSmQ4LZ4/reb
         bgEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzmmcG/8Ykl1/m4HYHdf/tTr/LeL4B1sJdjSrRxf8cbQgvVCnzfW6fbTfqkanP0tCqiNc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDuikXtrb/HrBKax43Tnu0HvIWHnvihaPDUZ5dSnCLHLvJkLP9
	GtEvxBx5GVphIbZ0QZqJ7ukJw1EsVOKehp6KTaZbwvAsATmNGRGs806WdyKd6FY=
X-Gm-Gg: ASbGncuGz9b7ddkBhQ/OcM8T90d32zE2x40T//jTOSINQnIz6c1aygaUFG9dH1Np8G8
	oGwiSUnpagfEeDEFZ+8H9EXb+HKWukz7Tst1wQg2j7pd5EPduxZCX8iKAfrg+g4QdmkX0uuxPkU
	uxjIIog2cKSuLemUwWG8DVT4aYtrf44L0bm71MhGdEGMmk/aoFWE8Mz8M9+QD45xu7oBNlfd0aW
	gH7QmO+bUQ7hst7+26nNNpZRHrpP5zsu6e7weB5XlWVpcj7QMyzDGGPxLj1yiGLNSuSgneyigTO
	eHMeVDbBxs2LShDsXZnvdUtkwSKBImtAsqFZd5Eq/5ocT5f5Pdor/wANI6UyRv6HZW3qc++A6j0
	CTSJg
X-Google-Smtp-Source: AGHT+IHZcPmRk5gPH/rH2C3jEZSb4NxsBOfY7HPr+KD0wv8fTTgyyCcfCNUg48txYmIiFnZJNGrSWQ==
X-Received: by 2002:a17:90b:3504:b0:301:1c11:aa83 with SMTP id 98e67ed59e1d1-30a013b1668mr3710418a91.28.1745665476071;
        Sat, 26 Apr 2025 04:04:36 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22dc8e24231sm10956725ad.125.2025.04.26.04.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 04:04:35 -0700 (PDT)
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
Subject: [kvmtool PATCH v3 08/10] riscv: Include single-letter extensions in isa_info_arr[]
Date: Sat, 26 Apr 2025 16:33:45 +0530
Message-ID: <20250426110348.338114-9-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250426110348.338114-1-apatel@ventanamicro.com>
References: <20250426110348.338114-1-apatel@ventanamicro.com>
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
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
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



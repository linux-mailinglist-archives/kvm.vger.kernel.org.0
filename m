Return-Path: <kvm+bounces-42028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34CA3A710E3
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 07:58:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4988C175991
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 06:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE05119EEBD;
	Wed, 26 Mar 2025 06:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="dMS9rgQ6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE49E1953BB
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 06:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742972246; cv=none; b=pVt7WNE3kPSAE7e4Gjh3R2AXujAZZQaGeauyXyoKYzs4Mo+4pEgp5al7QQRhzV8FRD1D+ZTBEtJFdSaV/T2RCT1t+6vL4gOC1mBTexd0le7HrWYdC7NmhE4wu29dYOWnpox/3xHB5MCOfum2AHLYIkKTa8u6YGKSd1yFfB6ofEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742972246; c=relaxed/simple;
	bh=2ItT+SGCOCnf0Ie1SBi2rjFVuQhO6jnOR5IcGeNE7Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gO4+NW3V5iSJNNedncnIHFeT4jYwglJN7IOBAtwmf7kjgAfHoLgISXRsa0kWBtRwJ6jyD9lQ1IcGIXLeBWAJgB8CDMS5/C3XkT76fvJ/kxEAqDyDgoykWdI85yYmLJFl2YiKbGN8m81X/yhSGI0vgiJSxtl3k10fbOASK8t8zBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=dMS9rgQ6; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22403cbb47fso127991905ad.0
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 23:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1742972244; x=1743577044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+y2JzdWEw4KqciqhaDRSciMbrFvQAV33aM50nrXl4Y=;
        b=dMS9rgQ6C2SX+pfMGQwG+6SFRx3iNR03zswxDRmkvxWzKOG15cC5sjGbp39MPzTemk
         jl2y+Zs2NjIRVhJlW4ceGPi1mMSO+hhfb72YNk1nS4R0Uii4PYsAa14yLNUgUcP4DpwQ
         IP4YS3PmKDYn+3BVZtYWbYhLUsVIg0KxP04TSgUKMfpwLfMr27rJQxn5qKHre5iq6RD6
         kwFd0afN7jeByoH20TgZIqvXK9IvZqFGwHXHSCfOxKHnJNgLWaXyAIdRwI+WqmI+YAMO
         luPIPXz0fkUqJtvCHuy0ZBHXL37zbXjufIwWXtAysd2xlTxeV38KNkkD8xJV7TtK4a5W
         1/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742972244; x=1743577044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p+y2JzdWEw4KqciqhaDRSciMbrFvQAV33aM50nrXl4Y=;
        b=ReL1XN+jeWasYN/0azWHcHZehxpTVcGrDktMwdYrCCejxKJ/LtzsmtT3b7NdXjWh6f
         Lfqe2y0mH+eV321hxpfKVEmd48wjTz0BlTKcyjBAQcHkZX483FNVC+noXC1+cJUhVEE4
         fuCSdKT9j1rUxTv4pBf/QvDvjFGkx7iDDA3r+0aaP2tvPI9HTdlR5AsqJketTy5lb1gu
         IUcPgUTNKdjtzb6XYHwU/mgyg7KQbNCMN/6R7SdnpvpvLa3tfMC2cuZbfLthnSPQrPAk
         fdWfEJKirGcHR8SMfF4Vyp8pGFdYEfq36VPako/ueIGoEPZbwpzPaTFWgRYi4MYnclNI
         brtw==
X-Forwarded-Encrypted: i=1; AJvYcCU9YRkEzU+vaR8d5HCXD5t5pKOCKwPzsG0vZncL9kp/eke+8kZP5pLg9kF0KPIo2qvQfL8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf3ttTwUnzce7j00NOIosll2o8ShFczCMcx93W2M0f9jkR3E+P
	39UwmLI55ilswD1tq7OkgaLY2QalTb80nhsTkSewusv5/x4Aj/12PA9/5P4neso=
X-Gm-Gg: ASbGncvZHViBlVh2B8LHrK3aFuz7GVVEtnF3IRKMOzjHYvXxaRdf86BnNsKRdIjKcfg
	oY//Abs+ZvF0SR6QLaEgjG0r2hGSF9iwj2n80tXNIK9jEu5Bnt34FdPR1hZkj19GH2+jKEIVMjy
	sc2fBg/hRVIEjJajZu8KcN8ipNvqn3AT3rzosipSlvE+5KnnFggX9PfmtjdcJB5FOlsZjxPTcbj
	TXEY9XTWdU4/McO642J7sb/pRtBMMr0pRosWVyqJ6zJWKPdwT+2Ac5OdArkgz9d1rqCFIRQLlmT
	LUnaEMCTGZM/Fg5SxVoEUZo8i6A5sAxwtwdHvNnxIWlxPfznTzWe6bApg+9vW7E0s8krWyTrAdv
	Zx7cDbA==
X-Google-Smtp-Source: AGHT+IG4tad9JTLYUplpx/9PnlhtklOxzyIFXcy12vg4T3cnDDVBdvzCYx2xw6xXdTRO+pMdvqoLHw==
X-Received: by 2002:a05:6a00:4648:b0:736:4e0a:7e82 with SMTP id d2e1a72fcca58-739059809a1mr29800294b3a.10.1742972244084;
        Tue, 25 Mar 2025 23:57:24 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390611c8d1sm11788817b3a.105.2025.03.25.23.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 23:57:23 -0700 (PDT)
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
Subject: [kvmtool PATCH 08/10] riscv: Include single-letter extensions in isa_info_arr[]
Date: Wed, 26 Mar 2025 12:26:42 +0530
Message-ID: <20250326065644.73765-9-apatel@ventanamicro.com>
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

Currently, the isa_info_arr[] only include multi-letter extensions but
the KVM ONE_REG interface covers both single-letter and multi-letter
extensions so extend isa_info_arr[] to include single-letter extensions.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c | 138 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 76 insertions(+), 62 deletions(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 251821e..46efb47 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -12,71 +12,81 @@
 struct isa_ext_info {
 	const char *name;
 	unsigned long ext_id;
+	bool multi_letter;
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
+	/* single-letter */
+	{"a", KVM_RISCV_ISA_EXT_A, false},
+	{"c", KVM_RISCV_ISA_EXT_C, false},
+	{"d", KVM_RISCV_ISA_EXT_D, false},
+	{"f", KVM_RISCV_ISA_EXT_F, false},
+	{"h", KVM_RISCV_ISA_EXT_H, false},
+	{"i", KVM_RISCV_ISA_EXT_I, false},
+	{"m", KVM_RISCV_ISA_EXT_M, false},
+	{"v", KVM_RISCV_ISA_EXT_V, false},
+	/* multi-letter sorted alphabetically */
+	{"smnpm", KVM_RISCV_ISA_EXT_SMNPM, true},
+	{"smstateen", KVM_RISCV_ISA_EXT_SMSTATEEN, true},
+	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA, true},
+	{"sscofpmf", KVM_RISCV_ISA_EXT_SSCOFPMF, true},
+	{"ssnpm", KVM_RISCV_ISA_EXT_SSNPM, true},
+	{"sstc", KVM_RISCV_ISA_EXT_SSTC, true},
+	{"svade", KVM_RISCV_ISA_EXT_SVADE, true},
+	{"svadu", KVM_RISCV_ISA_EXT_SVADU, true},
+	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL, true},
+	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT, true},
+	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT, true},
+	{"svvptc", KVM_RISCV_ISA_EXT_SVVPTC, true},
+	{"zabha", KVM_RISCV_ISA_EXT_ZABHA, true},
+	{"zacas", KVM_RISCV_ISA_EXT_ZACAS, true},
+	{"zawrs", KVM_RISCV_ISA_EXT_ZAWRS, true},
+	{"zba", KVM_RISCV_ISA_EXT_ZBA, true},
+	{"zbb", KVM_RISCV_ISA_EXT_ZBB, true},
+	{"zbc", KVM_RISCV_ISA_EXT_ZBC, true},
+	{"zbkb", KVM_RISCV_ISA_EXT_ZBKB, true},
+	{"zbkc", KVM_RISCV_ISA_EXT_ZBKC, true},
+	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX, true},
+	{"zbs", KVM_RISCV_ISA_EXT_ZBS, true},
+	{"zca", KVM_RISCV_ISA_EXT_ZCA, true},
+	{"zcb", KVM_RISCV_ISA_EXT_ZCB, true},
+	{"zcd", KVM_RISCV_ISA_EXT_ZCD, true},
+	{"zcf", KVM_RISCV_ISA_EXT_ZCF, true},
+	{"zcmop", KVM_RISCV_ISA_EXT_ZCMOP, true},
+	{"zfa", KVM_RISCV_ISA_EXT_ZFA, true},
+	{"zfh", KVM_RISCV_ISA_EXT_ZFH, true},
+	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN, true},
+	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM, true},
+	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ, true},
+	{"ziccrse", KVM_RISCV_ISA_EXT_ZICCRSE, true},
+	{"zicntr", KVM_RISCV_ISA_EXT_ZICNTR, true},
+	{"zicond", KVM_RISCV_ISA_EXT_ZICOND, true},
+	{"zicsr", KVM_RISCV_ISA_EXT_ZICSR, true},
+	{"zifencei", KVM_RISCV_ISA_EXT_ZIFENCEI, true},
+	{"zihintntl", KVM_RISCV_ISA_EXT_ZIHINTNTL, true},
+	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE, true},
+	{"zihpm", KVM_RISCV_ISA_EXT_ZIHPM, true},
+	{"zimop", KVM_RISCV_ISA_EXT_ZIMOP, true},
+	{"zknd", KVM_RISCV_ISA_EXT_ZKND, true},
+	{"zkne", KVM_RISCV_ISA_EXT_ZKNE, true},
+	{"zknh", KVM_RISCV_ISA_EXT_ZKNH, true},
+	{"zkr", KVM_RISCV_ISA_EXT_ZKR, true},
+	{"zksed", KVM_RISCV_ISA_EXT_ZKSED, true},
+	{"zksh", KVM_RISCV_ISA_EXT_ZKSH, true},
+	{"zkt", KVM_RISCV_ISA_EXT_ZKT, true},
+	{"ztso", KVM_RISCV_ISA_EXT_ZTSO, true},
+	{"zvbb", KVM_RISCV_ISA_EXT_ZVBB, true},
+	{"zvbc", KVM_RISCV_ISA_EXT_ZVBC, true},
+	{"zvfh", KVM_RISCV_ISA_EXT_ZVFH, true},
+	{"zvfhmin", KVM_RISCV_ISA_EXT_ZVFHMIN, true},
+	{"zvkb", KVM_RISCV_ISA_EXT_ZVKB, true},
+	{"zvkg", KVM_RISCV_ISA_EXT_ZVKG, true},
+	{"zvkned", KVM_RISCV_ISA_EXT_ZVKNED, true},
+	{"zvknha", KVM_RISCV_ISA_EXT_ZVKNHA, true},
+	{"zvknhb", KVM_RISCV_ISA_EXT_ZVKNHB, true},
+	{"zvksed", KVM_RISCV_ISA_EXT_ZVKSED, true},
+	{"zvksh", KVM_RISCV_ISA_EXT_ZVKSH, true},
+	{"zvkt", KVM_RISCV_ISA_EXT_ZVKT, true},
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
@@ -129,6 +139,10 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 		}
 
 		for (i = 0; i < arr_sz; i++) {
+			/* Skip single-letter extensions since these are taken care */
+			if (!isa_info_arr[i].multi_letter)
+				continue;
+
 			reg.id = RISCV_ISA_EXT_REG(isa_info_arr[i].ext_id);
 			reg.addr = (unsigned long)&isa_ext_out;
 			if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-- 
2.43.0



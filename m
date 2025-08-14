Return-Path: <kvm+bounces-54682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22AC4B26BDE
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 18:05:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C6C55E2465
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 15:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CE652FD7C4;
	Thu, 14 Aug 2025 15:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="pjBFEwC2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62362FABFD
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 15:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755186997; cv=none; b=tgpD3HLp2ESZIfP6FfmW/q+XCPBDYlkKt6TozzSO+3dtlroN/BsXDxfrh36vTIrMOrRflODxjsAB1SosO2jV0/6DViHfJ1KwAhgdCk2wjRX0Dw8O8Aual6JVb/mZ3EkrERDw0iyWbY0Tb6QMD/oHb3hpa8AlWe38sHdvumY+gf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755186997; c=relaxed/simple;
	bh=G9gBXgS5ZP2+2D3CVqP+3wrJpRXlPa7RbLzeqdLAE8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mg8OVf+YQhvXNYE4AKj+sI+9HQfCyc1inJPjiJiK6slvb1xVkPtwWGHNPjUeo2gGuCQTZE9jYYI7d2OUoJNUaiwflTzclcmGCj++PIibq92sUT86w2IPp6ZJfN4yBO77RUdDq+VkdhvveHUU7Opa+mmdJaHMdmv+IBo8iZv3GtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=pjBFEwC2; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b4717563599so883945a12.3
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 08:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755186995; x=1755791795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cSJAzpJrB/+0Vhq3Jx8mxwwAXiXUMS9lCBbypwhOCgE=;
        b=pjBFEwC2Xzb2hGf2VxS0T80g4QoDHHd9ZXXmjfPgYSNAQolkmzgp77YEcR3uoS6mUV
         q8hgKr1T4c0Rhu4bpW5prEK3iHhzLHpG9GtRkgWaet5HPdhVV6GrH78PSrbNdPwbPnJh
         9+yjMMJWTbxVYQzHT2SQyll5H2UbPXtIfe5pR9aNS3zNxQ71M2jbFIITGzMzZKyj4T6h
         /idDtf734hsXxbIdiF/o+uFWutKSE5nsFuM3F/koTAPeU2eS5iLbtTLtdEw8FUqqlyB1
         vBlbg45fkfY3BbA+VepInS9y9lQsUbEjXXNdDDvsOr9g78rnIlxnKnZCcCDp63Xm4zpK
         aFxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755186995; x=1755791795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cSJAzpJrB/+0Vhq3Jx8mxwwAXiXUMS9lCBbypwhOCgE=;
        b=tVVTd4jQPGhAszIa92dr1GugnfqoZSx8LTfFjo/6GzmpV3smrwAidXk6az1Di0/V2z
         C1NQjOnZsL+b5r3MDlLTOlZ7F2xYhil+cJKo+qYKZfmMljUlbTXsV8vougarfAurLKSf
         D/EClfjutfJQ2RLHkcineiFCd3/5ocbwoJRdPHYmpfihxm3WVB8xoVXUz0mxuIL/jo1T
         024vU8hIgiUVdP/Lg2AsliaS8gQIgOzcG3Mx3wotrKVT/Vphm+AWphUGFcduBD8ym/TH
         fTU93wDU0VoThUryl8hoavvpgyMvm7fvhBrkjj/MeLLqvMiI1ZCkC/e0pY3EuyNq8LVV
         u2uQ==
X-Forwarded-Encrypted: i=1; AJvYcCUd+SGNUU+KEL02kf3y9vP1uUlKjD2zOpxm1+qxurJmEI6ZAgFYNpCu0FIoKJeiMZkKC1s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqTV2010wCrsmbDSWNnrzTnS4AqTWssE6cdKHpFvQRjiRVJfKE
	l9Bp2VDka3mZOwja+CqgGgAKPQVOZcy3hF5qXNP/e399NcXKKD5mFbINr+PXRpDlB00=
X-Gm-Gg: ASbGncs5/dWbSEw5cNX4TH2VyAr/r2qi7O6ZjtK3R1fwcGR0q01JRagZOs8chKSivEq
	0QR0xZuTUxJAfWf6HV4Mnrs5FcS0BzD+f7L8YQVFpkk1GVUWOxqQbQP78M3QpjuIY8dUtzr9fIf
	IERajcPlQb8EE7AZ5lbqGByZ7hGrxgLQYg1j5ITpK4Gmb+c6nuIv/XZXy7KQcddXRSPIw0Kj1Me
	mj2jQw+/EMI1xtYm2nQh12Do2OLgGHcEvBtSPS7oR4II6D2orhLN3Z124WXwjaBbMDpT2gsmRzy
	clxifT9bo4dsSAJd1CvjJgb/g46fsRwhtFDJnQkSUL77VI1vSAvBencfybDtMtEEbAori58TlHx
	aHRwGrf0wxga2GdMq45ErPBBd0Rt986UBfOZU4R06Dn3yh66ZbT2YV4IMvf+5Gw==
X-Google-Smtp-Source: AGHT+IGJVdqHFLQAppNcJd7AUqhrBmK4Q+zaiql1Y8W6JMc1bdxvvOyGCokaiILV9/xyDSM5iDy5Dw==
X-Received: by 2002:a17:903:984:b0:224:23be:c569 with SMTP id d9443c01a7336-2445853c0ecmr58111655ad.22.1755186994714;
        Thu, 14 Aug 2025 08:56:34 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3233108e1d9sm2225500a91.29.2025.08.14.08.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 08:56:34 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 6/6] KVM: riscv: selftests: Add SBI FWFT to get-reg-list test
Date: Thu, 14 Aug 2025 21:25:48 +0530
Message-ID: <20250814155548.457172-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250814155548.457172-1-apatel@ventanamicro.com>
References: <20250814155548.457172-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM RISC-V now supports SBI FWFT, so add it to the get-reg-list test.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 .../selftests/kvm/riscv/get-reg-list.c        | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index a0b7dabb5040..1bc84f09b4ee 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -128,6 +128,7 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_DBCN:
 	case KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_SUSP:
 	case KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_STA:
+	case KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_FWFT:
 	case KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_EXPERIMENTAL:
 	case KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_VENDOR:
 		return true;
@@ -627,6 +628,7 @@ static const char *sbi_ext_single_id_to_str(__u64 reg_off)
 		KVM_SBI_EXT_ARR(KVM_RISCV_SBI_EXT_DBCN),
 		KVM_SBI_EXT_ARR(KVM_RISCV_SBI_EXT_SUSP),
 		KVM_SBI_EXT_ARR(KVM_RISCV_SBI_EXT_STA),
+		KVM_SBI_EXT_ARR(KVM_RISCV_SBI_EXT_FWFT),
 		KVM_SBI_EXT_ARR(KVM_RISCV_SBI_EXT_EXPERIMENTAL),
 		KVM_SBI_EXT_ARR(KVM_RISCV_SBI_EXT_VENDOR),
 	};
@@ -683,6 +685,17 @@ static const char *sbi_sta_id_to_str(__u64 reg_off)
 	return strdup_printf("KVM_REG_RISCV_SBI_STA | %lld /* UNKNOWN */", reg_off);
 }
 
+static const char *sbi_fwft_id_to_str(__u64 reg_off)
+{
+	switch (reg_off) {
+	case 0: return "KVM_REG_RISCV_SBI_FWFT | KVM_REG_RISCV_SBI_FWFT_REG(misaligned_deleg.flags)";
+	case 1: return "KVM_REG_RISCV_SBI_FWFT | KVM_REG_RISCV_SBI_FWFT_REG(misaligned_deleg.value)";
+	case 2: return "KVM_REG_RISCV_SBI_FWFT | KVM_REG_RISCV_SBI_FWFT_REG(pointer_masking.flags)";
+	case 3: return "KVM_REG_RISCV_SBI_FWFT | KVM_REG_RISCV_SBI_FWFT_REG(pointer_masking.value)";
+	}
+	return strdup_printf("KVM_REG_RISCV_SBI_STA | %lld /* UNKNOWN */", reg_off);
+}
+
 static const char *sbi_id_to_str(const char *prefix, __u64 id)
 {
 	__u64 reg_off = id & ~(REG_MASK | KVM_REG_RISCV_SBI_STATE);
@@ -695,6 +708,8 @@ static const char *sbi_id_to_str(const char *prefix, __u64 id)
 	switch (reg_subtype) {
 	case KVM_REG_RISCV_SBI_STA:
 		return sbi_sta_id_to_str(reg_off);
+	case KVM_REG_RISCV_SBI_FWFT:
+		return sbi_fwft_id_to_str(reg_off);
 	}
 
 	return strdup_printf("%lld | %lld /* UNKNOWN */", reg_subtype, reg_off);
@@ -859,6 +874,14 @@ static __u64 sbi_sta_regs[] = {
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_STATE | KVM_REG_RISCV_SBI_STA | KVM_REG_RISCV_SBI_STA_REG(shmem_hi),
 };
 
+static __u64 sbi_fwft_regs[] = {
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_FWFT,
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_STATE | KVM_REG_RISCV_SBI_FWFT | KVM_REG_RISCV_SBI_FWFT_REG(misaligned_deleg.flags),
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_STATE | KVM_REG_RISCV_SBI_FWFT | KVM_REG_RISCV_SBI_FWFT_REG(misaligned_deleg.value),
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_STATE | KVM_REG_RISCV_SBI_FWFT | KVM_REG_RISCV_SBI_FWFT_REG(pointer_masking.flags),
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_STATE | KVM_REG_RISCV_SBI_FWFT | KVM_REG_RISCV_SBI_FWFT_REG(pointer_masking.value),
+};
+
 static __u64 zicbom_regs[] = {
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_CONFIG | KVM_REG_RISCV_CONFIG_REG(zicbom_block_size),
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZICBOM,
@@ -1010,6 +1033,9 @@ static __u64 vector_regs[] = {
 #define SUBLIST_SBI_STA \
 	{"sbi-sta", .feature_type = VCPU_FEATURE_SBI_EXT, .feature = KVM_RISCV_SBI_EXT_STA, \
 	 .regs = sbi_sta_regs, .regs_n = ARRAY_SIZE(sbi_sta_regs),}
+#define SUBLIST_SBI_FWFT \
+	{"sbi-fwft", .feature_type = VCPU_FEATURE_SBI_EXT, .feature = KVM_RISCV_SBI_EXT_FWFT, \
+	 .regs = sbi_fwft_regs, .regs_n = ARRAY_SIZE(sbi_fwft_regs),}
 #define SUBLIST_ZICBOM \
 	{"zicbom", .feature = KVM_RISCV_ISA_EXT_ZICBOM, .regs = zicbom_regs, .regs_n = ARRAY_SIZE(zicbom_regs),}
 #define SUBLIST_ZICBOZ \
@@ -1092,6 +1118,7 @@ KVM_SBI_EXT_SUBLIST_CONFIG(sta, STA);
 KVM_SBI_EXT_SIMPLE_CONFIG(pmu, PMU);
 KVM_SBI_EXT_SIMPLE_CONFIG(dbcn, DBCN);
 KVM_SBI_EXT_SIMPLE_CONFIG(susp, SUSP);
+KVM_SBI_EXT_SUBLIST_CONFIG(fwft, FWFT);
 
 KVM_ISA_EXT_SUBLIST_CONFIG(aia, AIA);
 KVM_ISA_EXT_SUBLIST_CONFIG(fp_f, FP_F);
@@ -1167,6 +1194,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_sbi_pmu,
 	&config_sbi_dbcn,
 	&config_sbi_susp,
+	&config_sbi_fwft,
 	&config_aia,
 	&config_fp_f,
 	&config_fp_d,
-- 
2.43.0



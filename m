Return-Path: <kvm+bounces-48311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35992ACCA84
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 17:48:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC42A3A2E81
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 15:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79E7E23BF91;
	Tue,  3 Jun 2025 15:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="WdOCtM/0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B0E239E67
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 15:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748965638; cv=none; b=HPBCHOz5BUc/HDJjP6U3n5G6f6vt8XO6T9akShplHxeEuEY+Gb/+tQUvKimJ4uORTVO5v36nhCFZ85nossAi9IcXkmXwoSVHxjA1o6u1t4QY7ROHe6Rt9WGW6ixZ6hAxgRjEWNrOq0o4bXaP7zaZPFK1yWACziXZzAcX9WldvR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748965638; c=relaxed/simple;
	bh=GIhtuRjojVntdqFAnEtoAXQfMFJn9oXWP+onGhDByEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hIW+zN9OZzHPd2ikeW28T0DTlSVAu2GxI46GK+byBFB7UXg6ULF5H4+M0VvzWzj3w7P/d7swU9vG1hVWc+47vKQ//VaiQKvKZ0UjU5ANFBk3/1pvm8FQegurvx/wbxLPuEU5VbX/ik7WDgRBb/brYrr0y+Q5cIIjvMx1vs3cack=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=WdOCtM/0; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-73972a54919so5098440b3a.3
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 08:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1748965635; x=1749570435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J3kUEJK4cCzrgp5Hjn4rjGk6y08adFzIGT6yPFpKOJE=;
        b=WdOCtM/0+ekVT6PNSwZ0NUFJj0WotMTnz/b/SmazgpJhVWgZsXevmzd44PzK5VZRFB
         YUnXVTp01ItQM/uOfZlL7KpsJqIqZewn4YXMVIzPCRYBBADxd5c8R6kLTMXMCcxpwF7i
         fMgy0EynKrgME02ZmcdaEjFMvSYssI9g++7CLDNBJ4hT9jqCtidiLgVqSlp5B66pNJw3
         PPXuIiGQ3wU3Fir1U/d+9AiSCH2AHryPYNqtTgzElHDUfwrJtU85A+EFnC6Mkj2NO8VI
         zTmht1ZcPxDtLbtoDiJ3W4ATwuYf2kNgjhQSI685Lmtqa4MA+enuEdU1FAdjwlz5koyd
         YIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748965635; x=1749570435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J3kUEJK4cCzrgp5Hjn4rjGk6y08adFzIGT6yPFpKOJE=;
        b=Tu6nUBRZ6RWLIMU37xbRMd5tYutu9qVeRHtkGFAzRTZjD736AFIeQ1Iq0bAiN2ngvj
         tGKUl0Cm2qNB+wPD11zKmY8kYboVHVdoD/IG/9/IlIEcd/UpdlChCyCwBs9R02bIA5ZN
         suPHdbR1t3WeriMYnaEp9ncBa0FDEuiSPQAxhSPt0Q7rcvAZ3C5mw8FxZUH3q157qYwB
         ZgN3RnWMUB1y1R85HemjdHqjkkW9bzBuqJIuHAII/7/Fa2kgTtIq6qULFxCSACCduxH0
         wDJb/axF7diPcq7/whQOb37zfmzhsuj+10TJdoqnna7TuF/uFV/xtp2x3B9aXhYQEMs7
         jHJg==
X-Gm-Message-State: AOJu0YxpHFx9DRUWK2G/ZBpQAnOnqIcJuHvdxb3UqZeplswF1bQQIfrq
	/q8vSBqMVgAWa+ZTniowN/tVfAvmF2TmCZqYGTef4VxSpBTQGKdqgsganJ0PXV4SBx9nze0WY4d
	wQiAD3SA=
X-Gm-Gg: ASbGncvryP39MZnl+qd4eJ5KeCktCKH4mNwkaFUWY9cVTZ2rUYM0Hb4IUMam9M6dbTy
	DhcmRWo7MQ1k7XOtN3Jzsw31r7/bg9kZik7uoyPJo/UDXGBZafrPavF3PNBegycfA+y3Wh1KIoI
	LTAMaWwr7UjCcr//xwzvL3zpQR+4LKYAZ75ex2pgp9ZEhFbfIJVE2+btZtlB2DU4G8V9WttF1ZJ
	LBjSdhYMo3Ah6cgd42EfFHoa2UKZTTWZkZcCHvau0daq4dC4OZ4M5ErYas3xJiGxRVLEdjzk0zE
	L4e3BAs5wlkExcRpG/LfcYNIpiIDu/FiTRIrCewka49tghUWZlkQ
X-Google-Smtp-Source: AGHT+IHwM3BLFSc/RyKlP6OdXFPc/z8ol3QI8dLNrujmp/qTsiV1Lcou38qgPA5otevc4437lbQRpw==
X-Received: by 2002:a05:6a21:2d8a:b0:1f5:769a:a4c2 with SMTP id adf61e73a8af0-21bad120dd0mr19798649637.22.1748965635442;
        Tue, 03 Jun 2025 08:47:15 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2eceb9711asm6306066a12.57.2025.06.03.08.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 08:47:14 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests v2 1/2] lib/riscv: export FWFT functions
Date: Tue,  3 Jun 2025 17:46:49 +0200
Message-ID: <20250603154652.1712459-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250603154652.1712459-1-cleger@rivosinc.com>
References: <20250603154652.1712459-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These functions will be needed by other tests as well, expose them.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/sbi.h |  5 +++++
 lib/riscv/sbi.c     | 20 ++++++++++++++++++
 riscv/sbi-fwft.c    | 49 +++++++++++++--------------------------------
 3 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index a5738a5c..08146260 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -302,5 +302,10 @@ struct sbiret sbi_sse_hart_mask(void);
 struct sbiret sbi_sse_hart_unmask(void);
 struct sbiret sbi_sse_inject(unsigned long event_id, unsigned long hart_id);
 
+struct sbiret sbi_fwft_set_raw(unsigned long feature, unsigned long value, unsigned long flags);
+struct sbiret sbi_fwft_set(uint32_t feature, unsigned long value, unsigned long flags);
+struct sbiret sbi_fwft_get_raw(unsigned long feature);
+struct sbiret sbi_fwft_get(uint32_t feature);
+
 #endif /* !__ASSEMBLER__ */
 #endif /* _ASMRISCV_SBI_H_ */
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index 2959378f..0b547d42 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -107,6 +107,26 @@ struct sbiret sbi_sse_inject(unsigned long event_id, unsigned long hart_id)
 	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_INJECT, event_id, hart_id, 0, 0, 0, 0);
 }
 
+struct sbiret sbi_fwft_set_raw(unsigned long feature, unsigned long value, unsigned long flags)
+{
+	return sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET, feature, value, flags, 0, 0, 0);
+}
+
+struct sbiret sbi_fwft_set(uint32_t feature, unsigned long value, unsigned long flags)
+{
+	return sbi_fwft_set_raw(feature, value, flags);
+}
+
+struct sbiret sbi_fwft_get_raw(unsigned long feature)
+{
+	return sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_GET, feature, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_fwft_get(uint32_t feature)
+{
+	return sbi_fwft_get_raw(feature);
+}
+
 void sbi_shutdown(void)
 {
 	sbi_ecall(SBI_EXT_SRST, 0, 0, 0, 0, 0, 0, 0);
diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
index c52fbd6e..8920bcb5 100644
--- a/riscv/sbi-fwft.c
+++ b/riscv/sbi-fwft.c
@@ -19,37 +19,16 @@
 
 void check_fwft(void);
 
-
-static struct sbiret fwft_set_raw(unsigned long feature, unsigned long value, unsigned long flags)
-{
-	return sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET, feature, value, flags, 0, 0, 0);
-}
-
-static struct sbiret fwft_set(uint32_t feature, unsigned long value, unsigned long flags)
-{
-	return fwft_set_raw(feature, value, flags);
-}
-
-static struct sbiret fwft_get_raw(unsigned long feature)
-{
-	return sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_GET, feature, 0, 0, 0, 0, 0);
-}
-
-static struct sbiret fwft_get(uint32_t feature)
-{
-	return fwft_get_raw(feature);
-}
-
 static struct sbiret fwft_set_and_check_raw(const char *str, unsigned long feature,
 					    unsigned long value, unsigned long flags)
 {
 	struct sbiret ret;
 
-	ret = fwft_set_raw(feature, value, flags);
+	ret = sbi_fwft_set_raw(feature, value, flags);
 	if (!sbiret_report_error(&ret, SBI_SUCCESS, "set to %ld%s", value, str))
 		return ret;
 
-	ret = fwft_get_raw(feature);
+	ret = sbi_fwft_get_raw(feature);
 	sbiret_report(&ret, SBI_SUCCESS, value, "get %ld after set%s", value, str);
 
 	return ret;
@@ -59,17 +38,17 @@ static void fwft_check_reserved(unsigned long id)
 {
 	struct sbiret ret;
 
-	ret = fwft_get(id);
+	ret = sbi_fwft_get(id);
 	sbiret_report_error(&ret, SBI_ERR_DENIED, "get reserved feature 0x%lx", id);
 
-	ret = fwft_set(id, 1, 0);
+	ret = sbi_fwft_set(id, 1, 0);
 	sbiret_report_error(&ret, SBI_ERR_DENIED, "set reserved feature 0x%lx", id);
 }
 
-/* Must be called before any fwft_set() call is made for @feature */
+/* Must be called before any sbi_fwft_set() call is made for @feature */
 static void fwft_check_reset(uint32_t feature, unsigned long reset)
 {
-	struct sbiret ret = fwft_get(feature);
+	struct sbiret ret = sbi_fwft_get(feature);
 
 	sbiret_report(&ret, SBI_SUCCESS, reset, "resets to %lu", reset);
 }
@@ -87,16 +66,16 @@ static void fwft_feature_lock_test_values(uint32_t feature, size_t nr_values,
 		     __sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 7);
 
 	for (int i = 0; i < nr_values; ++i) {
-		ret = fwft_set(feature, test_values[i], 0);
+		ret = sbi_fwft_set(feature, test_values[i], 0);
 		sbiret_kfail_error(kfail, &ret, SBI_ERR_DENIED_LOCKED,
 				   "Set to %lu without lock flag", test_values[i]);
 
-		ret = fwft_set(feature, test_values[i], SBI_FWFT_SET_FLAG_LOCK);
+		ret = sbi_fwft_set(feature, test_values[i], SBI_FWFT_SET_FLAG_LOCK);
 		sbiret_kfail_error(kfail, &ret, SBI_ERR_DENIED_LOCKED,
 				   "Set to %lu with lock flag", test_values[i]);
 	}
 
-	ret = fwft_get(feature);
+	ret = sbi_fwft_get(feature);
 	sbiret_report(&ret, SBI_SUCCESS, locked_value, "Get value %lu", locked_value);
 
 	report_prefix_pop();
@@ -131,12 +110,12 @@ static void misaligned_handler(struct pt_regs *regs)
 
 static struct sbiret fwft_misaligned_exc_set(unsigned long value, unsigned long flags)
 {
-	return fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, value, flags);
+	return sbi_fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, value, flags);
 }
 
 static struct sbiret fwft_misaligned_exc_get(void)
 {
-	return fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG);
+	return sbi_fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG);
 }
 
 static void fwft_check_misaligned_exc_deleg(void)
@@ -304,7 +283,7 @@ static void fwft_check_pte_ad_hw_updating(void)
 
 	report_prefix_push("pte_ad_hw_updating");
 
-	ret = fwft_get(SBI_FWFT_PTE_AD_HW_UPDATING);
+	ret = sbi_fwft_get(SBI_FWFT_PTE_AD_HW_UPDATING);
 	if (ret.error != SBI_SUCCESS) {
 		if (env_enabled("SBI_HAVE_FWFT_PTE_AD_HW_UPDATING")) {
 			sbiret_report_error(&ret, SBI_SUCCESS, "supported");
@@ -350,10 +329,10 @@ static void fwft_check_pte_ad_hw_updating(void)
 #endif
 
 adue_inval_tests:
-	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, 2, 0);
+	ret = sbi_fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, 2, 0);
 	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "set to 2");
 
-	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, !enabled, 2);
+	ret = sbi_fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, !enabled, 2);
 	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "set to %d with flags=2", !enabled);
 
 	if (!adue_toggle_and_check(" with lock", !enabled, 1))
-- 
2.49.0



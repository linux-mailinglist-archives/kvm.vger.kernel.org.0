Return-Path: <kvm+bounces-49602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52023ADAFA4
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 14:03:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89FC21893751
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 12:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 353932ED85D;
	Mon, 16 Jun 2025 11:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="hjUPmzRR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122402DBF54
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 11:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750075168; cv=none; b=G6YFfUJzkvItmAcTFpGRiU89DQm8mYWEEUWyxf8xxgaCicw4nbOpqv4pjdblR9cAatakIQ7EqwOvunVmNaQnCTlRZEVOcf2HgH+5ZkMEUbWFyq+XrQJBbidvDoOVuCnPS/5yMAsy5on6hnlsGjGtyZ1nrbHF1f7F3nsE8LBPfPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750075168; c=relaxed/simple;
	bh=GIhtuRjojVntdqFAnEtoAXQfMFJn9oXWP+onGhDByEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fcWaqCfKaorGWbWnW20wB3LZk88SpkiSFeI75Jz496Xu6E1QseGJSeHKyALoFRD/IcabBQNND08Y9Jf4CwY4FXGGLYSlrlN+3zyfsZubApkzGUK8rtsxZMGnf8R6Tsh0Ekff1LtPLONVVfGnPq4c+yFJ987Xxk0+7CH5olg46W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=hjUPmzRR; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a50fc7ac4dso2561814f8f.0
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 04:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750075164; x=1750679964; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J3kUEJK4cCzrgp5Hjn4rjGk6y08adFzIGT6yPFpKOJE=;
        b=hjUPmzRRWxHQFXeD21okeqBBdBmIJoqazxO0QTqutdPxAvPXA5FuIOJGRZd4HF5se2
         EDs8wt9MAdBoRbhiivWpVUzG62M+czPOYWsE3VXCOYkj1fq0SbDCwFVMawgvk6c9S0Lc
         UoNegE2jLTCb8IiV+ehtb5Sd0oUCd9/qCQgKhKLRdWRTZLd7Ti6Xux/yMO3LTpw3ZfGp
         Du4JDwe9MgzbqcLinxwiTS4SoTWRK7ZOHRRvkx8cjNWPBqKmeQ2pejHcD3mlpCS0lgA9
         IW6snkK41JZPtz+Tmr8baeHfnrRc60oHwGhS141bq0uGlhTm16TZRsH0kbWqdbKEK2H1
         3ysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750075164; x=1750679964;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J3kUEJK4cCzrgp5Hjn4rjGk6y08adFzIGT6yPFpKOJE=;
        b=RNQkFKSw15fd8wCNLLxAAgtseknJPMb8sDJJY3v+3YCeU8NSNcXS6WAa5lQXLeECXj
         FgYGNM44lRi8RzC37sJ5dMFJEBPN3XK26FP8Fra1iRRUB1Ntbm1348gUPLknn4bb3vGw
         4hM/EivXLfQ9jUmOwEcFdAsdjIxdFLFv/ao+AD0SFDyCUGioebGONtkHk4fHdKzxqtwS
         1wUGDoQRF2LJcUcuifhI+0w1APv4CSyejGkF2hCL7oXWE2U0Oacu3n83UUd4YLIN7UN7
         NMNhejUE0fD4Nu4V4UIPauR/bpLeLnwPB+Dc6QdB/AzVKPsIeKa1wFXLeDhI2nlD89+R
         EsKA==
X-Gm-Message-State: AOJu0YxZqJ7FBVmn6QDlA+exnlc0r6xjaxJOUGSLpQDOWZdWgfNPlQp7
	5CNqBpKk/cq9Govg2uUTZqtm7ki9quxZDZu6v5M2SIOQSkpAfWHbXn6GIbOD6CXKvHNNzo4Grky
	J3svpoKc=
X-Gm-Gg: ASbGncueV73M1Ju847Df9DGqDYxFGYd9KGoowaCLeMQV+SXtvSTIqITI7KoZPF7kkFK
	WxORqi4/Z4/mVwmVXNGWO19ZEr7+C7/skiu17rOjNFTQyr/SsczcB7G/YLo7LUo2yL4/ysLDQhh
	7OAu7zMaxkros4JXNVTYg2QB6O0Iy2JMiKim+HrjyshptmDRcyBgsx3Q9Iao12XaIxVCDocm8Cx
	kNmxTVBKU8IbKWVs81rTya641QSq9e9iZ2vAbbDnI4keHCvz6j43II0OpYNBZPGZLM8Z2ep98GO
	r7pEp3HSrRYqlVsQT32EPBssQCKJkH8pYDgNbVEHkYF1sic/jfeRe5fHtO1AD91cLEzGfKX3OA=
	=
X-Google-Smtp-Source: AGHT+IF2/vXhLgCtYuTQ1216X7RBTPhjZ3zG/EabUpilZq4OuILNMyPGaPGwDotk0xpbs4ohQpPhrg==
X-Received: by 2002:a05:6000:41fa:b0:3a4:fc37:70e4 with SMTP id ffacd0b85a97d-3a572e6b34fmr8089283f8f.58.1750075163902;
        Mon, 16 Jun 2025 04:59:23 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a579808c24sm6198786f8f.43.2025.06.16.04.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 04:59:23 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests v3 1/2] lib/riscv: export FWFT functions
Date: Mon, 16 Jun 2025 13:58:59 +0200
Message-ID: <20250616115900.957266-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250616115900.957266-1-cleger@rivosinc.com>
References: <20250616115900.957266-1-cleger@rivosinc.com>
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



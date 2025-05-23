Return-Path: <kvm+bounces-47528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 102A8AC1DF5
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:55:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 250E5A25E57
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 07:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26BCB2857FF;
	Fri, 23 May 2025 07:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="xYh3ZERU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698B417A30F
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 07:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747986905; cv=none; b=CmIqKZjqLX753sa3Nah+ySXROWNmvvZ5Qa5ZRApx5nyajjHJaitq9XWP1yS89MicsuNTPNhKcnvfhB1+2EmyfGBhuGfVVQTbGjABgODLfPdnOQeWJ4L13FmNJzbKl7FRmR+JUqYJHm8bJsKDcN4LTvbB5QHFKqWJVmCMnUnvPjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747986905; c=relaxed/simple;
	bh=lUvc6cBrc5AGkxmqbusro5mB4sgx6LEjVh6zHvGORuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WJjB6wKQxez84YeqXbm/CZXw6ppnmVs317z0YVrLTIXPWSXIWWEYFiAbUx6+zgwxvX55eEpp49haZ0vNwJNq9IOYx/lzRaxv63ZUJ5iFOqSzu0/5sIjW+YT2tdzf3cBEbnjNnSOttasKUXK5f3zV3UxzmqhfMlTGrQf0d7A+95U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=xYh3ZERU; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-310cf8f7301so544053a91.1
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 00:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747986902; x=1748591702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TIh2/la5VXYaUYqPJQiKhgsiJPpkFatbGozgF/Ujxa8=;
        b=xYh3ZERUOcEq7HyUYP8hwL2rZViMevalaYNStcgYDDupiGjyF/Vyw7zeYkPu34oxon
         Ic/y5xKBcSpSN6dB8O0pvyTymesqhpEEU+8LeJHaRX0n9IJB9DHBFnLrzjtdzPt/f3Rr
         duTe8UCcFDtyjJ9sZoAPqwhRmzGJIa64VW5kM4/mShb1jREyH6oUR3lCdmKZjs4ZnkNy
         /Gv/4wwuc3AjLw+0fLL5sHJnDBenzwjdqI2itd2vMs3X2BSyWBUv7plLVaATzIsm79NV
         z8YaLxre0eXTrhQJEYFfCsep6AWEDMOkGYMgrCqyVBq3BrxS15Qbh+R7BOKjuB7pC0Wm
         iRaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747986902; x=1748591702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TIh2/la5VXYaUYqPJQiKhgsiJPpkFatbGozgF/Ujxa8=;
        b=a7PPFQGg1OrervQmahV6jMQfYJ6ddkZ/MY/L7sT68XiO4WOLpaoFklHVvXPg1J9jbC
         o1Z6xQvdF9hlfXOH/dDvHU9yr6YmzgljRhaMYdVLF/tCNde5MPHnmA3Jtlf4fWJDznlZ
         /l2uC7s2VXkgJIhpxy07dnUBhVfOJjCHS1vUDDbSsG84H9iUA2Y6YdfjxzU6NOEpQgvc
         NTzl9B9j0HVd55wL6gTrheHGx7H9XJ2bQ3qxS5s11stpz1fnmrEZUg+UrsnBX3F1tgJW
         /MHIlg5UNNkBzJEZU31HXkhKqG3uPqObVk/e4JC9Yof5Kzg5Kv+J/DfM7vlgH+jFMRZw
         a2FQ==
X-Gm-Message-State: AOJu0Yz4QDZq4e24Wo8P8f5O7zj5w92homIRK1z25RHgDNGn3KeFk0eg
	NZ8hsIrstlDMXRIEq2ueVpXT+wCWk8Y4uRtlukh4kKZIjBJJoZl1Y8w5Qt+34lDPHfgWxoD5wRJ
	U8jA2+O8=
X-Gm-Gg: ASbGncstqVFzWIb9ffIS02FE4a8BugY2V+5Q44nPpF0Dp35UXw148AUZVthCWlqa4vX
	1sI7Jkq0zMvy5TiOVo0f5KJ9H6ohVfIRL38qvXIp8XZMDDk17D6RObwkaIbzkBjpG9axDvEynqI
	Smy4QPH+6VSnwCq/8ztQSQZr5lJt4hNSH1GG+LjlDJJ+5KynIou/2lACmLWW5/KC0cbOPtBZQIK
	ag2eERtFXP5cH08Trr/j2LUI7acIzmpFvtNbTkgRJrJ4IZjH20hiWLdmK7/PmCqbw0cRYibyJgL
	yMrgfBGJ/uISTP97MpKC4FFmwOGOtSH6NtbmSncxBki9FxnvfYdPRsCos0bRgD8=
X-Google-Smtp-Source: AGHT+IG7scHh1XLTOwqsg+d0XjixFekQ/XtdIqZ5IKoCHMTuK67iJHSWsWdeIkPfoGw2bTaM8Rva+Q==
X-Received: by 2002:a17:90b:1811:b0:2fa:42f3:e3e4 with SMTP id 98e67ed59e1d1-310e8899e12mr3790096a91.3.1747986902131;
        Fri, 23 May 2025 00:55:02 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f36513bb7sm6767204a91.46.2025.05.23.00.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 00:55:01 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ved Shanbhogue <ved@rivosinc.com>
Subject: [PATCH 1/3] lib/riscv: export FWFT functions
Date: Fri, 23 May 2025 09:53:08 +0200
Message-ID: <20250523075341.1355755-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523075341.1355755-1-cleger@rivosinc.com>
References: <20250523075341.1355755-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These functions will probably be needed by other tests as well, expose
them.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
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



Return-Path: <kvm+bounces-40664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E159FA59966
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:14:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A6E13AA0A5
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 818EE22E407;
	Mon, 10 Mar 2025 15:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="db1BCc5I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E33522D4DE
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 15:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741619602; cv=none; b=muitUR4h3ubsTZI1TrsB4huSj1JpQUtUP1Fp9DNG3gdSYijt+9uI8j8NSWkVfugDjqtWMAzwhWaw+Kl83BbfZVnguqYMffR5AVCze1TIHRhnXDcOezu5nwQlSb/RZk4xD6skagFEE2wHNDVnbcl5VfV9vYby+IO3wn2bgU9KqOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741619602; c=relaxed/simple;
	bh=pZ+9pW5BDqYXCcejKIs+lMeMx/vb5B3qOSbyzQ08BYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GAFdRIupjUnTrMIN8BEn0lYGqyyM689yX/lWTN+q7tsTH6GYoOGjGDSbq5aOn3P84UY+Ih0CZsGdDyY+mibcuFCD/wwvIDu9a9lC3eN/v9BVESixkRzSSZlxLm0LV3UTjyTHKj3cKubbk6wKKfQKBbgRmXH89j4QHW70tmHtIGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=db1BCc5I; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22359001f1aso105534245ad.3
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741619600; x=1742224400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iCzObjCiX22GaNtqPcn313QNcQsAxjFzTtLeQoUqwaY=;
        b=db1BCc5Ifdj/kGpvRDfAmdqRNIPNcKL4AN5SkReaB9WCKhF0kbQ/RU6B6L/vqis7oR
         C8D71VbYxyPwxcvu/jDKtVM+9xkiKBm/OXUrHnxAPHimqvKvBdTWZskwNnRTI1U2SzGT
         J4giq/bxcbe2z7emIQGraVwfp8oGE2Btlem7TFBkonenm1f0vTpePczp2pHHcnjq6aMx
         vw4+cIaPbEdbozy7b3AGhPwc5NDquYn37jo7ZulOASVSVFfZw+JLICybt0mX/kqmWj9x
         HpMECe+wJPqjr9nCeQWgtD74mA7QF4f+xHk1Jp9z21iDXOOxMLgC/xS4lhflQJdf5V1U
         lNsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741619600; x=1742224400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iCzObjCiX22GaNtqPcn313QNcQsAxjFzTtLeQoUqwaY=;
        b=KHDHp+QiX8AN/CrNSJv2Ygqmn/JNbfLC1B+vJFpLuqCvXmPmOnXhEn1YNMR2w4nqLK
         LMawJHmF1wYHX+jQAqjeE4gjQP5jDOkMok6znZxSZRqgCTkSlWkrgwZ2upsAS9HXiLnQ
         5dKFKX7kMaSZJPmSJBSH9Y15A5wV5AU1BZLom75pisfdghn7pWWXgGmvMaVsO6NJPaUH
         cs3IJ2RAdYK2Kyocnfy9LekAw07twFdd3k5jwaUm7MytpdDc7/7RizSMhSwxHNUDX0a/
         nggpdMRZzf8TmjOGF/vqH1ATws0unDgZCXDSyP3MP6anPpC21VAEqKzBpdgE9/Y61Tr8
         0NJw==
X-Forwarded-Encrypted: i=1; AJvYcCWwsWo7Crhcm8T7V9+oJH2OsdAlZ02tPMNVXr+9EBl5VAWSovbwoAPIZFdxntWJ3ltf9yY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8N+Y8CwkD0Qqs+H8wQJeBSxZyGRVzeaKgoHa1L83HgXw6qZcN
	H4elipfg5vn7uYKGusn5fChwgmJsVttqYLUdV6nISqh3kWKZQXqrZDpm2C3K7ho=
X-Gm-Gg: ASbGncsc66c1esfIkqXSxl86PFiqSfAc5dbH5yb/aOYkw5HT4uNyfF5bP87oU4J0E6g
	nsVduCSlZvzcCRAYX8HTxzDcXG1/ugWGRbLh9ZushkmXquLH0R8DSeoG3ctPtnLV4v9WS4cp+Oi
	aTIItk8zOh5W91/QIjzfQfFq4j6QXfYMnXzwWkNp6Hm0WXf1ywO6hIOFmW5NL1muE6USRfFe/6h
	jATO0F7wA1A8we5P4Yg6odNXqTaLyqRDo7cAIv+USIAq0i/leK/rj6b5isGS7Ro0dMWu51WDdzM
	28b4aygmQRNZpmZN0EOuR6NctFR1n5QSM3wkpnOtj7367w==
X-Google-Smtp-Source: AGHT+IFAN+g28xsEl6cRHjCuf/iafyl8QjCyWFLr5ynPSsnxM9bGhegkupQZbu72YeMxbfX8Ebj7iA==
X-Received: by 2002:a17:903:32c5:b0:224:10a2:cad5 with SMTP id d9443c01a7336-2242887b36bmr234821365ad.10.1741619600386;
        Mon, 10 Mar 2025 08:13:20 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109e99dfsm79230515ad.91.2025.03.10.08.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 08:13:19 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 04/17] riscv: misaligned: request misaligned exception from SBI
Date: Mon, 10 Mar 2025 16:12:11 +0100
Message-ID: <20250310151229.2365992-5-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250310151229.2365992-1-cleger@rivosinc.com>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Now that the kernel can handle misaligned accesses in S-mode, request
misaligned access exception delegation from SBI. This uses the FWFT SBI
extension defined in SBI version 3.0.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/cpufeature.h        |  3 +-
 arch/riscv/kernel/traps_misaligned.c       | 77 +++++++++++++++++++++-
 arch/riscv/kernel/unaligned_access_speed.c | 11 +++-
 3 files changed, 86 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/cpufeature.h b/arch/riscv/include/asm/cpufeature.h
index 569140d6e639..ad7d26788e6a 100644
--- a/arch/riscv/include/asm/cpufeature.h
+++ b/arch/riscv/include/asm/cpufeature.h
@@ -64,8 +64,9 @@ void __init riscv_user_isa_enable(void);
 	_RISCV_ISA_EXT_DATA(_name, _id, _sub_exts, ARRAY_SIZE(_sub_exts), _validate)
 
 bool check_unaligned_access_emulated_all_cpus(void);
+void unaligned_access_init(void);
+int cpu_online_unaligned_access_init(unsigned int cpu);
 #if defined(CONFIG_RISCV_SCALAR_MISALIGNED)
-void check_unaligned_access_emulated(struct work_struct *work __always_unused);
 void unaligned_emulation_finish(void);
 bool unaligned_ctl_available(void);
 DECLARE_PER_CPU(long, misaligned_access_speed);
diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 7cc108aed74e..90ac74191357 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -16,6 +16,7 @@
 #include <asm/entry-common.h>
 #include <asm/hwprobe.h>
 #include <asm/cpufeature.h>
+#include <asm/sbi.h>
 #include <asm/vector.h>
 
 #define INSN_MATCH_LB			0x3
@@ -635,7 +636,7 @@ bool check_vector_unaligned_access_emulated_all_cpus(void)
 
 static bool unaligned_ctl __read_mostly;
 
-void check_unaligned_access_emulated(struct work_struct *work __always_unused)
+static void check_unaligned_access_emulated(struct work_struct *work __always_unused)
 {
 	int cpu = smp_processor_id();
 	long *mas_ptr = per_cpu_ptr(&misaligned_access_speed, cpu);
@@ -646,6 +647,13 @@ void check_unaligned_access_emulated(struct work_struct *work __always_unused)
 	__asm__ __volatile__ (
 		"       "REG_L" %[tmp], 1(%[ptr])\n"
 		: [tmp] "=r" (tmp_val) : [ptr] "r" (&tmp_var) : "memory");
+}
+
+static int cpu_online_check_unaligned_access_emulated(unsigned int cpu)
+{
+	long *mas_ptr = per_cpu_ptr(&misaligned_access_speed, cpu);
+
+	check_unaligned_access_emulated(NULL);
 
 	/*
 	 * If unaligned_ctl is already set, this means that we detected that all
@@ -654,9 +662,10 @@ void check_unaligned_access_emulated(struct work_struct *work __always_unused)
 	 */
 	if (unlikely(unaligned_ctl && (*mas_ptr != RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED))) {
 		pr_crit("CPU misaligned accesses non homogeneous (expected all emulated)\n");
-		while (true)
-			cpu_relax();
+		return -EINVAL;
 	}
+
+	return 0;
 }
 
 bool check_unaligned_access_emulated_all_cpus(void)
@@ -688,4 +697,66 @@ bool check_unaligned_access_emulated_all_cpus(void)
 {
 	return false;
 }
+static int cpu_online_check_unaligned_access_emulated(unsigned int cpu)
+{
+	return 0;
+}
 #endif
+
+#ifdef CONFIG_RISCV_SBI
+
+static bool misaligned_traps_delegated;
+
+static int cpu_online_sbi_unaligned_setup(unsigned int cpu)
+{
+	if (sbi_fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 1, 0) &&
+	    misaligned_traps_delegated) {
+		pr_crit("Misaligned trap delegation non homogeneous (expected delegated)");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void unaligned_sbi_request_delegation(void)
+{
+	int ret;
+
+	ret = sbi_fwft_all_cpus_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 1, 0, 0);
+	if (ret)
+		return;
+
+	misaligned_traps_delegated = true;
+	pr_info("SBI misaligned access exception delegation ok\n");
+	/*
+	 * Note that we don't have to take any specific action here, if
+	 * the delegation is successful, then
+	 * check_unaligned_access_emulated() will verify that indeed the
+	 * platform traps on misaligned accesses.
+	 */
+}
+
+void unaligned_access_init(void)
+{
+	if (sbi_probe_extension(SBI_EXT_FWFT) > 0)
+		unaligned_sbi_request_delegation();
+}
+#else
+void unaligned_access_init(void) {}
+
+static int cpu_online_sbi_unaligned_setup(unsigned int cpu __always_unused)
+{
+	return 0;
+}
+#endif
+
+int cpu_online_unaligned_access_init(unsigned int cpu)
+{
+	int ret;
+
+	ret = cpu_online_sbi_unaligned_setup(cpu);
+	if (ret)
+		return ret;
+
+	return cpu_online_check_unaligned_access_emulated(cpu);
+}
diff --git a/arch/riscv/kernel/unaligned_access_speed.c b/arch/riscv/kernel/unaligned_access_speed.c
index 91f189cf1611..2f3aba073297 100644
--- a/arch/riscv/kernel/unaligned_access_speed.c
+++ b/arch/riscv/kernel/unaligned_access_speed.c
@@ -188,13 +188,20 @@ arch_initcall_sync(lock_and_set_unaligned_access_static_branch);
 
 static int riscv_online_cpu(unsigned int cpu)
 {
+	int ret;
 	static struct page *buf;
 
 	/* We are already set since the last check */
 	if (per_cpu(misaligned_access_speed, cpu) != RISCV_HWPROBE_MISALIGNED_SCALAR_UNKNOWN)
 		goto exit;
 
-	check_unaligned_access_emulated(NULL);
+	ret = cpu_online_unaligned_access_init(cpu);
+	if (ret)
+		return ret;
+
+	if (per_cpu(misaligned_access_speed, cpu) == RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED)
+		goto exit;
+
 	buf = alloc_pages(GFP_KERNEL, MISALIGNED_BUFFER_ORDER);
 	if (!buf) {
 		pr_warn("Allocation failure, not measuring misaligned performance\n");
@@ -403,6 +410,8 @@ static int check_unaligned_access_all_cpus(void)
 {
 	bool all_cpus_emulated, all_cpus_vec_unsupported;
 
+	unaligned_access_init();
+
 	all_cpus_emulated = check_unaligned_access_emulated_all_cpus();
 	all_cpus_vec_unsupported = check_vector_unaligned_access_emulated_all_cpus();
 
-- 
2.47.2



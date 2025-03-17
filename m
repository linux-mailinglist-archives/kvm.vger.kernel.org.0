Return-Path: <kvm+bounces-41272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3FA7A659E6
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9CEC67AE728
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 543321F8ADB;
	Mon, 17 Mar 2025 17:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="q2CTpS6Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821281E1E10
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 17:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742231300; cv=none; b=Hc28rhDJNSMfEL6n1grKhBWB0Bx1T/xUlhG0ZdOsxba6zOsTSAx4HgCngO48k84/w5/AJDjMQSXxARAYlEizIWkdAhnNzuRp5+0XVazlqNhN8vanx6jPoNjOm5854G8tT7MfqZsO0xnfAkk4CtRT/mJBF1Mu2LM5xwnwtZdnZ4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742231300; c=relaxed/simple;
	bh=s4E957oqIf8er7oaqipLhpUVd977hLf6TtGqZJ/vs/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u4rUv4naQXuYQBgctx+0shUEzm4O2VrepZevdk/2NozU+2Hp2Z427ftXt17+m7mnCuSI9lyq8r7g+HvJ6rUNxMQZTsndFxbwwI7WT7J25Be8lgi+69FJjNvLiVRZBXEauTIvaCe6Y97nG9UMsJtpTa5L4sONxQlsH0zeUSdGSVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=q2CTpS6Q; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43cf680d351so13284255e9.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742231297; x=1742836097; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=goQPfqUUhZrDcxyWXuqyDL1Ho5AqcAiizxxMLq8C+LA=;
        b=q2CTpS6QJi8dW1qdnBA0JvHSyuONwujIfHN+9AEMomvVztDcwc6S85/MBlQvtsCxjL
         oc+yf5/SO0wma9uU3DXO/mCKCD42WDqZtap+n/4vPJ4/fsmPcjVuNj9hrXbjmMKIKJN9
         3aW12fbP68JHbxRGpGhQin9fWC4pECamas80Pzs0IWpN2cNgonJm9wzGLGMVyhR+JSHn
         MRw9TfAMNzHjGEW71MROy66cMPt642/Odp6UYfai+j9SRLUSvog/AW7kMswsJCwk/Kzt
         /4j02ifaPq/5Lba8XgXCRe8JLytb6cOXQUDyv60EVHFnKH1FuSLta5xPASUlmjVv1w1x
         JSvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742231297; x=1742836097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=goQPfqUUhZrDcxyWXuqyDL1Ho5AqcAiizxxMLq8C+LA=;
        b=LbFipXVv/IpBnKPAhIudZb5ddkoSRjfu7ps7QNSTb684qI4E3hD0Q+pWZ8k41ImwCL
         BpsC6ewqy1253WmXaZgmfzlSU/8Lid36oLKQbLiXJLosU3kXz547mStZtdzfsx+Ldexf
         Cb7gRXZl95a2VGc4P4lkGz0e5tdfj60kGR/rsXItThiFloFIPbTpcfQRw+OUVXrfnLbI
         MBiWIbh/Xjin3R8U9DBbkND/jSlPU9lgMK7Ulvz4gb+XlijloQ6ZhEBWLM4e+Xaw7cum
         PBIi3MltAPN7SJi+OLYUuL4caGOzCCfHqiq5bYvqiJqzQEbLXmRkpMaCU1YgfxJRY2Ja
         o2Ew==
X-Forwarded-Encrypted: i=1; AJvYcCXPm8chsLyGZ3lRmwYsxK0CZYIWnzciOuKLErSdT1a4UVbdjFz/I/6XpZ5LuZzOemDGDYk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIZU3ymh3QtQpjzyNtolH1n/yDkDmvRJGGl/2nhPpiZDzWtF/7
	5zNOBu7eypOhiNWGsrQUxYA3VNRrVMIvbbgAidM6p4c2OwJi4qMdVhKuzgrsIiA=
X-Gm-Gg: ASbGnctr3ILy9bPUt9IPPysdznzJMw93ETSS+QOGZUPtGrpciUjoc4JxFUFZImdIox/
	dJcHPKL5ksTpqrg74PB5Z5zopb8uYe4d5davlhSYkdmDlt8crYLiecnO4iCXaBFEGq5F3vjMDed
	XXCeZDtDgqFItqBXRTIRVspKdsxageU+rxaNsZrzSmQbZyj/hAPfMuIQy6zHfUonVl+umdALnkP
	KHVZu1oo8eFreMPCdRMz4/7i9IIhDzw+7+b4pZqUQQY2D9OnTIEZ8Wc3SNlBkaApL2Vg49ia3Gl
	c2ZWM66qlxYbF/z77XBU7OYdshU58UYhCitvcg8qK9cjZg==
X-Google-Smtp-Source: AGHT+IFputIgv6zhtm+v7+MGBN3nI7X+BtRN1fT5rRbozYZS+RzAoNXF9CqISuMs9K5H8TPGERcLdQ==
X-Received: by 2002:a05:600c:4e51:b0:439:8878:5029 with SMTP id 5b1f17b1804b1-43d38f72af6mr2448325e9.2.1742231296757;
        Mon, 17 Mar 2025 10:08:16 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d23cddb2asm96014505e9.39.2025.03.17.10.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 10:08:16 -0700 (PDT)
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
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v4 09/18] riscv: misaligned: add a function to check misalign trap delegability
Date: Mon, 17 Mar 2025 18:06:15 +0100
Message-ID: <20250317170625.1142870-10-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317170625.1142870-1-cleger@rivosinc.com>
References: <20250317170625.1142870-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Checking for the delegability of the misaligned access trap is needed
for the KVM FWFT extension implementation. Add a function to get the
delegability of the misaligned trap exception.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/cpufeature.h  |  5 +++++
 arch/riscv/kernel/traps_misaligned.c | 17 +++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/cpufeature.h b/arch/riscv/include/asm/cpufeature.h
index ad7d26788e6a..8b97cba99fc3 100644
--- a/arch/riscv/include/asm/cpufeature.h
+++ b/arch/riscv/include/asm/cpufeature.h
@@ -69,12 +69,17 @@ int cpu_online_unaligned_access_init(unsigned int cpu);
 #if defined(CONFIG_RISCV_SCALAR_MISALIGNED)
 void unaligned_emulation_finish(void);
 bool unaligned_ctl_available(void);
+bool misaligned_traps_can_delegate(void);
 DECLARE_PER_CPU(long, misaligned_access_speed);
 #else
 static inline bool unaligned_ctl_available(void)
 {
 	return false;
 }
+static inline bool misaligned_traps_can_delegate(void)
+{
+	return false;
+}
 #endif
 
 bool check_vector_unaligned_access_emulated_all_cpus(void);
diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 3c77fc78fe4f..0fb663ac200f 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -715,10 +715,10 @@ static int cpu_online_check_unaligned_access_emulated(unsigned int cpu)
 }
 #endif
 
-#ifdef CONFIG_RISCV_SBI
-
 static bool misaligned_traps_delegated;
 
+#ifdef CONFIG_RISCV_SBI
+
 static int cpu_online_sbi_unaligned_setup(unsigned int cpu)
 {
 	if (sbi_fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 1, 0) &&
@@ -760,6 +760,7 @@ static int cpu_online_sbi_unaligned_setup(unsigned int cpu __always_unused)
 {
 	return 0;
 }
+
 #endif
 
 int cpu_online_unaligned_access_init(unsigned int cpu)
@@ -772,3 +773,15 @@ int cpu_online_unaligned_access_init(unsigned int cpu)
 
 	return cpu_online_check_unaligned_access_emulated(cpu);
 }
+
+bool misaligned_traps_can_delegate(void)
+{
+	/*
+	 * Either we successfully requested misaligned traps delegation for all
+	 * CPUS or the SBI does not implemented FWFT extension but delegated the
+	 * exception by default.
+	 */
+	return misaligned_traps_delegated ||
+	       all_cpus_unaligned_scalar_access_emulated();
+}
+EXPORT_SYMBOL_GPL(misaligned_traps_can_delegate);
-- 
2.47.2



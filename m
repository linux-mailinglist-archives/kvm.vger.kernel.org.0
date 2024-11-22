Return-Path: <kvm+bounces-32360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F24859D601D
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 15:05:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77E101F218D1
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 14:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C3704879B;
	Fri, 22 Nov 2024 14:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="st0r+wOv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F129879C0
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 14:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732284324; cv=none; b=f7QCXGzLhfWsy6FF5P+9rlsEY3dWmwtStEzcm7SvJARjiM/UTVAorkZy4lvatScevmhAUIqnpJt04asEg3sKyvuqwTQSaSREOyMRsziw5PqNfNvbM4ZY/QioxVuwwm4TzEIN4OvQhnqZUdnig6P2J4uFWJyFsaVc52u8QADpL/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732284324; c=relaxed/simple;
	bh=Ic84VpHOibuQozUqai/NlpjOIfc0/mvT9lPytZjuUEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nWNdDqL4XU8Hyo0CaugJIFlDmNWFN432yUtxt0JWpQ5wUV8Z1L6Y35MzD0ziSqxVOx4nSJgL7X87HNpUnrZ9+IwYx4215ZMXI1880YGxCe1B+e7VpTI4vEVR5LZCk6nNbyDFcrz6/4E148W6ioks4VmWxQK/X/DOvoQhr3DNXlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=st0r+wOv; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7f43259d220so1641483a12.3
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 06:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732284320; x=1732889120; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+6HsNHdQt0kd/5veTGdUtJoVQV5/G9bnuHZ7XDP5v4A=;
        b=st0r+wOvhRBafSQ74gubh1XbGZ1tBMPBjai9bjiyJ0eQ9zN1vOniQNLzyHCgCs6I8s
         cqzv1VaR4YnKS2Oo+a3ccCvrrX2uLmU2cQCbAoHU0Ptw8g0nbB0AXpH3nNka3RwxC/4t
         lVH+U5qdi5cBAXZNEZI+v2PD9cZ9O+bgkETjWhaQFATTWIJ783ndUT3yrk5TOb+5aG0h
         MP2haL601CSArvzuOgf8hKWqpxsrbZTdkk8QS0e37CQK/EMB3Sm7+lwrn32zG3AUh8nq
         Qza4HepUoBIqSQvriloD/I3djX/rCkBcixFt4l4QR5bhmu7299HxDnaTzYcW0aLhaiD5
         kIgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732284320; x=1732889120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+6HsNHdQt0kd/5veTGdUtJoVQV5/G9bnuHZ7XDP5v4A=;
        b=loT6rLJvJp5qzm0E3WrOBwQzLLa5SFatAPG5MJl8wBUHjNm94zO+I7lrt/tmb9F127
         GbDoLrLEyQ2EyuI+kN/jxXZpd5Bcxp0n3Hyg60LlY2lJHkWG0kevZMKvzPKQVShJj428
         JDtWgyc8EFZ/byrAwLHN5/dGS2xE7qC+Bp269UQ0zWECSeBz2FV5E2rSN5bjn+LegbHB
         Z6ppvNyAY8zdq8vmakz0X02915AlbKW9CyVFw3fvnNW63Nz9JxEBy9GyoCi4LBu/51lA
         qap1h+hG6/zcls0AUwAwtP1MRYHPyU/S+KUWVKfr7nDvWnh7mxoEmf6c2Yvyr2T+FR3q
         qa+w==
X-Gm-Message-State: AOJu0YwasMXBFh+zULHc6wHTRUPqFkaBysrPZB2sbhWGNoFIsyf41h2h
	FlEPlPgt1mHQ0FA+xiuD/+1Fd+8817Xqmnzx0M2VV847tB0OVuMKHhZ/8KURt30JLwfym8F5R+r
	K
X-Gm-Gg: ASbGncu8Hi//BHlXEJHpEdQwBebSs7adKmX8as0ggNh6nPjUzRNNYAYbdRHqKTJIws+
	elzvYxNWDBEv3Qljnd4/R2ZqCcoNfLY5T6TRqNXYmE8FMXUpnM3V1YswBtWn4NddfhzitcNgL8j
	uJ0kNG9W1RhKpolZu7pbIuOOOQe3PlSSr9NQj7x8qWTJH3Diml2qj2AvTP53u9AUnr+iIvR8M4D
	ZKC4doQoIWBY2xdZgpWM+JaDMT4I7mJx75S0XSaOwv1ipjjQEE=
X-Google-Smtp-Source: AGHT+IGid/fbx0xuvBIDaJVF0FRMbdG9SzJUU5kaw27BZYKVAXfvfwXmZtBuY3ERk0xdCbVU+KT96w==
X-Received: by 2002:a17:90b:4f45:b0:2ea:9309:7594 with SMTP id 98e67ed59e1d1-2eb0e1254dfmr3255445a91.4.1732284319855;
        Fri, 22 Nov 2024 06:05:19 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ead04d2b9dsm5153370a91.33.2024.11.22.06.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 06:05:19 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v2 1/3] riscv: lib: Add SBI SSE extension definitions
Date: Fri, 22 Nov 2024 15:04:55 +0100
Message-ID: <20241122140459.566306-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241122140459.566306-1-cleger@rivosinc.com>
References: <20241122140459.566306-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add SBI SSE extension definitions in sbi.h

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 lib/riscv/asm/sbi.h | 76 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 98a9b097..96100bc2 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -11,6 +11,9 @@
 #define SBI_ERR_ALREADY_AVAILABLE	-6
 #define SBI_ERR_ALREADY_STARTED		-7
 #define SBI_ERR_ALREADY_STOPPED		-8
+#define SBI_ERR_NO_SHMEM		-9
+#define SBI_ERR_INVALID_STATE		-10
+#define SBI_ERR_BAD_RANGE		-11
 
 #ifndef __ASSEMBLY__
 #include <cpumask.h>
@@ -23,6 +26,7 @@ enum sbi_ext_id {
 	SBI_EXT_SRST = 0x53525354,
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_SUSP = 0x53555350,
+	SBI_EXT_SSE = 0x535345,
 };
 
 enum sbi_ext_base_fid {
@@ -71,6 +75,78 @@ enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
 };
 
+/* SBI Function IDs for SSE extension */
+#define SBI_EXT_SSE_READ_ATTR		0x00000000
+#define SBI_EXT_SSE_WRITE_ATTR		0x00000001
+#define SBI_EXT_SSE_REGISTER		0x00000002
+#define SBI_EXT_SSE_UNREGISTER		0x00000003
+#define SBI_EXT_SSE_ENABLE		0x00000004
+#define SBI_EXT_SSE_DISABLE		0x00000005
+#define SBI_EXT_SSE_COMPLETE		0x00000006
+#define SBI_EXT_SSE_INJECT		0x00000007
+
+/* SBI SSE Event Attributes. */
+enum sbi_sse_attr_id {
+	SBI_SSE_ATTR_STATUS		= 0x00000000,
+	SBI_SSE_ATTR_PRIO		= 0x00000001,
+	SBI_SSE_ATTR_CONFIG		= 0x00000002,
+	SBI_SSE_ATTR_PREFERRED_HART	= 0x00000003,
+	SBI_SSE_ATTR_ENTRY_PC		= 0x00000004,
+	SBI_SSE_ATTR_ENTRY_ARG		= 0x00000005,
+	SBI_SSE_ATTR_INTERRUPTED_SEPC	= 0x00000006,
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS	= 0x00000007,
+	SBI_SSE_ATTR_INTERRUPTED_A6	= 0x00000008,
+	SBI_SSE_ATTR_INTERRUPTED_A7	= 0x00000009,
+};
+
+#define SBI_SSE_ATTR_STATUS_STATE_OFFSET	0
+#define SBI_SSE_ATTR_STATUS_STATE_MASK		0x3
+#define SBI_SSE_ATTR_STATUS_PENDING_OFFSET	2
+#define SBI_SSE_ATTR_STATUS_INJECT_OFFSET	3
+
+#define SBI_SSE_ATTR_CONFIG_ONESHOT	(1 << 0)
+
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_STATUS_SPP	BIT(0)
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_STATUS_SPIE	BIT(1)
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPV	BIT(2)
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPVP	BIT(3)
+
+enum sbi_sse_state {
+	SBI_SSE_STATE_UNUSED     = 0,
+	SBI_SSE_STATE_REGISTERED = 1,
+	SBI_SSE_STATE_ENABLED    = 2,
+	SBI_SSE_STATE_RUNNING    = 3,
+};
+
+/* SBI SSE Event IDs. */
+#define SBI_SSE_EVENT_LOCAL_RAS			0x00000000
+#define	SBI_SSE_EVENT_LOCAL_PLAT_0_START	0x00004000
+#define SBI_SSE_EVENT_LOCAL_PLAT_0_END		0x00007fff
+#define SBI_SSE_EVENT_GLOBAL_RAS		0x00008000
+#define	SBI_SSE_EVENT_GLOBAL_PLAT_0_START	0x00004000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_0_END		0x00007fff
+
+#define SBI_SSE_EVENT_LOCAL_PMU			0x00010000
+#define	SBI_SSE_EVENT_LOCAL_PLAT_1_START	0x00014000
+#define SBI_SSE_EVENT_LOCAL_PLAT_1_END		0x00017fff
+#define	SBI_SSE_EVENT_GLOBAL_PLAT_1_START	0x0001c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_1_END		0x0001ffff
+
+#define	SBI_SSE_EVENT_LOCAL_PLAT_2_START	0x00024000
+#define SBI_SSE_EVENT_LOCAL_PLAT_2_END		0x00027fff
+#define	SBI_SSE_EVENT_GLOBAL_PLAT_2_START	0x0002c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_2_END		0x0002ffff
+
+#define SBI_SSE_EVENT_LOCAL_SOFTWARE		0xffff0000
+#define	SBI_SSE_EVENT_LOCAL_PLAT_3_START	0xffff4000
+#define SBI_SSE_EVENT_LOCAL_PLAT_3_END		0xffff7fff
+#define SBI_SSE_EVENT_GLOBAL_SOFTWARE		0xffff8000
+#define	SBI_SSE_EVENT_GLOBAL_PLAT_3_START	0xffffc000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_3_END		0xffffffff
+
+#define SBI_SSE_EVENT_GLOBAL_BIT		(1 << 15)
+#define SBI_SSE_EVENT_PLATFORM_BIT		(1 << 14)
+
 struct sbiret {
 	long error;
 	long value;
-- 
2.45.2



Return-Path: <kvm+bounces-47558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 68934AC20D1
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 12:21:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6424BA27F6D
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 10:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C6E8229B2C;
	Fri, 23 May 2025 10:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="JO7P8Gn2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5195227EAF
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 10:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747995658; cv=none; b=JYFFDFsnDJKJ7thDdjHMCB9w/ihGL3fRyDbRp35ZHFKgjTqYVyn3T/7AC/3nbgnK3HHR1ufoWVXz8fC1FkLJF8Rz8NSTGNkIkEPm5vDltH2MKrUH6EfrTUdfnLlQaVDF3I+W0IRwFxj4gmk8IS3iCtcjNCi4CTQtD6JbUV+4DZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747995658; c=relaxed/simple;
	bh=a4HmXbZsUXBGVxOtLEuaSzvGsxTBPYeLxEetHvR5itM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OsWooYILkj2xP0aixL3aaVBnspZIEzOPNthuQeV4UnVZrBUHX9jlmAgpObVdVjYQ7ugweQxrBB72mwovAIqcZEsMIcIevQf+AxMy/F+X9zk2n8IwAl5YOl1+kimJLao35JvfZmt+j2K4uEtKKH47nsEDwuycNbSgH4ajAuMo+68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=JO7P8Gn2; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-742c9563fafso5096495b3a.0
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 03:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747995656; x=1748600456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GthJpHk7CYaw8f95HNVaUdqkaGIjKWsbIYnr+62Txtw=;
        b=JO7P8Gn2GUKnkLClg5bKzQ2DJBV3RGt5ZDmJK8U4FUqR44njdxvcp6hvfEKLGcVTfC
         0yvagZmYw2y/V1eGs2SoSW7Y5eBM6iKDCtyGic33o9oGRTYhtqbR3e1qIssvNDCp+rjh
         DgYwAYo1RD7Lv2uCR899VqrtIlWzWFzwDg8vq4DfvIA441nL2k72plHZDQXOQpm8C4hQ
         1ZSkWPhcWz4s/rjSdrih5qja/d9oy4a2MiJZjKp9+m4CEH8nWGQRSMfMkaxudbDKMTdW
         EZRLTf/kklD+ElyJXua3UmbLosLJMYo4yaMW/s722RGFJMJ7CX6bdzFBqWuNaPkVsicH
         7JUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747995656; x=1748600456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GthJpHk7CYaw8f95HNVaUdqkaGIjKWsbIYnr+62Txtw=;
        b=cnj8DGQoOyzk1cL+riRXXo5kuUfwSHwnPqbNr6lxtb49pt6BVEAy4v3k/sb71236tQ
         2FWwvjmqh3vJvXAfwXTDWYSLqA6aJit4EV5a2pRSmTM2vvI2L3/1ZvBssf+cww5DcnrQ
         o/v9dgr+qR35DcXuQsj8WNqcJKl9vm54zpFRS47S0CsLRP4w4KCLNUs0aPep5PLo+B4c
         u+NfgOvM4bepILLYrXM6nt98+9SVZQVNG4PSS/Tuj1w9FJLvjb6A4sE4nvSfGyFMkifH
         DiHYh+HTBf0Nu4NjWRwV21y0Sf+vKC3Pu9iXj7+NRoifvZ6ciBcS1IzSTqHKsKLckYi6
         ePDA==
X-Forwarded-Encrypted: i=1; AJvYcCVibZB1aib5KMtqgkDXDohR9ieiDfk/7MfpWUoC/+wegkWJs7jf79njcEue2/kWSMG+2Sw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPCyuF+tq3l4qA765RJ1Umw0YOnkp8ADxkf4f8XgCaomhX9KXe
	iginJSKcBI3DoW8b6T9alWA+KBavN5uUjk2VjuPpxD0QXVpABrwyY+Q4Wj+pHSLFci4=
X-Gm-Gg: ASbGnctcsJPpbaBidPC2kFxg40wo9enPqZ1DJj8bLhf5IHcNA1U6dF2ZvNfTbQVnRs2
	E3vndykkTp9YpH20FvGGzlvNLDlBPN0K9IeZSUKgK/icSeq10NrDao+/1FtjNRAcDxUyuIrIaMW
	jaUM9PwhLGcqkEBgR1ixDo0uOPZi02x5LN3rJA+N7Q24qzu2QsXp52zNsucVtUVhrUw/S3vQmXd
	TiG82/1zTdgDEZILgBHR6vjHv41f/AtHvt/KfFy5AFRyE5cXwWc+y3o0erQu7PTJg6bKhXhbJyy
	NUCu3K4/dcVr/+jNaQCj0k1zIYErM/gNQrmGwMi3FD1dzExc6RyuyVTQDo3batI=
X-Google-Smtp-Source: AGHT+IGNn5Ze7RmeDktlCW0T183bymn1C862lKIDtG+J3J1vY1Fk8ZeY7B6o/JkpGeXA+XwUMijVpg==
X-Received: by 2002:aa7:888e:0:b0:742:39fa:13df with SMTP id d2e1a72fcca58-742a98a2520mr39921026b3a.19.1747995656125;
        Fri, 23 May 2025 03:20:56 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a9829ce8sm12466688b3a.118.2025.05.23.03.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 03:20:55 -0700 (PDT)
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
	Andrew Jones <ajones@ventanamicro.com>,
	Deepak Gupta <debug@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v8 01/14] riscv: sbi: add Firmware Feature (FWFT) SBI extensions definitions
Date: Fri, 23 May 2025 12:19:18 +0200
Message-ID: <20250523101932.1594077-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523101932.1594077-1-cleger@rivosinc.com>
References: <20250523101932.1594077-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The Firmware Features extension (FWFT) was added as part of the SBI 3.0
specification. Add SBI definitions to use this extension.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Tested-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 3d250824178b..bb077d0c912f 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -35,6 +35,7 @@ enum sbi_ext_id {
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_STA = 0x535441,
 	SBI_EXT_NACL = 0x4E41434C,
+	SBI_EXT_FWFT = 0x46574654,
 
 	/* Experimentals extensions must lie within this range */
 	SBI_EXT_EXPERIMENTAL_START = 0x08000000,
@@ -402,6 +403,33 @@ enum sbi_ext_nacl_feature {
 #define SBI_NACL_SHMEM_SRET_X(__i)		((__riscv_xlen / 8) * (__i))
 #define SBI_NACL_SHMEM_SRET_X_LAST		31
 
+/* SBI function IDs for FW feature extension */
+#define SBI_EXT_FWFT_SET		0x0
+#define SBI_EXT_FWFT_GET		0x1
+
+enum sbi_fwft_feature_t {
+	SBI_FWFT_MISALIGNED_EXC_DELEG		= 0x0,
+	SBI_FWFT_LANDING_PAD			= 0x1,
+	SBI_FWFT_SHADOW_STACK			= 0x2,
+	SBI_FWFT_DOUBLE_TRAP			= 0x3,
+	SBI_FWFT_PTE_AD_HW_UPDATING		= 0x4,
+	SBI_FWFT_POINTER_MASKING_PMLEN		= 0x5,
+	SBI_FWFT_LOCAL_RESERVED_START		= 0x6,
+	SBI_FWFT_LOCAL_RESERVED_END		= 0x3fffffff,
+	SBI_FWFT_LOCAL_PLATFORM_START		= 0x40000000,
+	SBI_FWFT_LOCAL_PLATFORM_END		= 0x7fffffff,
+
+	SBI_FWFT_GLOBAL_RESERVED_START		= 0x80000000,
+	SBI_FWFT_GLOBAL_RESERVED_END		= 0xbfffffff,
+	SBI_FWFT_GLOBAL_PLATFORM_START		= 0xc0000000,
+	SBI_FWFT_GLOBAL_PLATFORM_END		= 0xffffffff,
+};
+
+#define SBI_FWFT_PLATFORM_FEATURE_BIT		BIT(30)
+#define SBI_FWFT_GLOBAL_FEATURE_BIT		BIT(31)
+
+#define SBI_FWFT_SET_FLAG_LOCK			BIT(0)
+
 /* SBI spec version fields */
 #define SBI_SPEC_VERSION_DEFAULT	0x1
 #define SBI_SPEC_VERSION_MAJOR_SHIFT	24
@@ -419,6 +447,11 @@ enum sbi_ext_nacl_feature {
 #define SBI_ERR_ALREADY_STARTED -7
 #define SBI_ERR_ALREADY_STOPPED -8
 #define SBI_ERR_NO_SHMEM	-9
+#define SBI_ERR_INVALID_STATE	-10
+#define SBI_ERR_BAD_RANGE	-11
+#define SBI_ERR_TIMEOUT		-12
+#define SBI_ERR_IO		-13
+#define SBI_ERR_DENIED_LOCKED	-14
 
 extern unsigned long sbi_spec_version;
 struct sbiret {
-- 
2.49.0



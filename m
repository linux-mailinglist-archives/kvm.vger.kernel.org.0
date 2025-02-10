Return-Path: <kvm+bounces-37734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85F63A2FC29
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 22:36:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FCC73A34B5
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 21:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4FC424CEC8;
	Mon, 10 Feb 2025 21:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ElJIDrr+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CA124CEC5
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 21:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739223368; cv=none; b=eO3VMufH+ZI4QAo+VTKD7+4fM+A6xXCKSVBFsu53tvL0iVTe21UPALWHYgUAhhd2oDDdrPMqxSJQWunyGyD17/d+ZpRGgx2mBK0IHOy7rKKQX13fwXZj4NvzSJ9n6bNX/KCXhWJsAcfaZFWY2YiRnyzpCHW8tvVqDEQkAbEQCAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739223368; c=relaxed/simple;
	bh=pmkjbFivpopT/t1TZQFWk2I+IyDpQtxJktgGqR1CYS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UKD6uvumPGK10V1kgVmgvwaye/nnZciu9jmLpp/9blYLEyXxLkQ8cenxJkF2ZqDOVVx5P2VUnxsFgYXM8pNuc6MTDlK8GecQQAalqJ7WLw/VCZtymxYR+CGfGsjMNzYmi72/WybAvxL2WzzBzWxrePXSmtROFu8sF78fdQPaPIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ElJIDrr+; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4368a293339so54240655e9.3
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 13:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1739223364; x=1739828164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dNygMxZnETinUIbqht3HdG0xEf8Y/zFmGWQC8EBuXhA=;
        b=ElJIDrr+OQmC6jPe4mIqSUR5mRtwFbqWwlWYxdQY172qlMaLocL9xC3e5VOO+gRaBa
         3naV6gwfGy38sh/uaicAqANkjcJP4WPFwOUVvy9FE1sKKJtNlYjVDHyg9uwjITm1kBo9
         NPeuA/E4aS0R0U6gA1TvQ5e3tj/Mj2mDiH0MA275Qu+wl3ds+1COyLrv9BfDf9Exfo3M
         fgcP45ipCYrBFuBvkl5FkZ51sctmxLmrhVdtDkK+Pl0uCJp6TiaBzyUqdxYWjhfvjivN
         gDL2AFe0gXWxcsj9XgQNXVa1ax8b1RhCxKRvHEL/aQ55di+FO7oVzu4dwy2pcG7gDqaC
         WIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739223364; x=1739828164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dNygMxZnETinUIbqht3HdG0xEf8Y/zFmGWQC8EBuXhA=;
        b=pywkFRJV+OVA2EY5ExRaMwKhrEgOfkMEKikSJ2DUtQdHl5pNC4PCUa26kiVcF1Vorg
         bAbohYi0QL8E4ld8MwCdxG/crq7BrFWAnJhafFp0EVu8L8tjclzwqIoP+a00hr4CR2qk
         73HZ/QQNBKcF/ntaXZfv80Zz+HTSe6JgNisSyWy0AwAgzfJMkclnlkbeNu4osSlxCn4Y
         515hpNuA3bre6zzEmo/DCb8auOjV3AlnsK7MhNsVfOWXKbiRwgLQJgtjZBRmdr4H8tOr
         /MYZ6RKkSw0Fvdq38N/B1uVljbSXO2AirvIa2o4mx6M6ZDmmB3wJHShoiGbescsu34QM
         GzRA==
X-Forwarded-Encrypted: i=1; AJvYcCV5ibhp4Aqpy9vL/o2LQS7bTZkxVpGLbp7PAFJDReJQFkUfZQGfIZp3yfELBaiky+YM1BY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpxNnUocBRiVPjH5QW3eXA4OcTqrn0vfEcWcngVMF2eEiVpIC8
	iPO/daDZeX0R65JhQ1SYI75sQGDwdsE535UrGzTYHOhHPqkhGC9pNExVCZR/PZE=
X-Gm-Gg: ASbGnctPhj+RyqGgohUijQot4+buKZ7Wqsg5KNOmbkBMIpGFDmIk+kJ4WFpt38nUIlu
	RMbtZxfWotWqWQlnIP4ISs0lG04PsCNxex4mVoVPESlWSEdGXuzpWfSt/sXE78xNqTo/Kaf6abR
	nQqquby9Pi3bTf7i3yz+RZvFG+NeEsOSHjsdiLcyaZ8XeOzuyHNeovTyFiU8zpkP4JVrVkR4AhJ
	pj5LS46suB6focBBKZQjqYOfQ1jKXtTor3yAVaZg9gu2bWoEv2DBCMUXqF1VCfFBRINtwcOlZ+o
	WVMf/vLv6jSZBCne
X-Google-Smtp-Source: AGHT+IEAhlsJGIdKtITdkCqcTf1jglZE/SWwXLDChC0QYiT0cR7GNzwUW0cObTxbcQCBuKABIqPOaA==
X-Received: by 2002:a05:600c:1f17:b0:436:e8b4:36e7 with SMTP id 5b1f17b1804b1-43924987efbmr120307725e9.8.1739223364575;
        Mon, 10 Feb 2025 13:36:04 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4394376118esm47541515e9.40.2025.02.10.13.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 13:36:03 -0800 (PST)
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
Subject: [PATCH v2 01/15] riscv: add Firmware Feature (FWFT) SBI extensions definitions
Date: Mon, 10 Feb 2025 22:35:34 +0100
Message-ID: <20250210213549.1867704-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250210213549.1867704-1-cleger@rivosinc.com>
References: <20250210213549.1867704-1-cleger@rivosinc.com>
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
---
 arch/riscv/include/asm/sbi.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 3d250824178b..d373b5c08039 100644
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
+#define SBI_FWFT_PLATFORM_FEATURE_BIT		(1 << 30)
+#define SBI_FWFT_GLOBAL_FEATURE_BIT		(1 << 31)
+
+#define SBI_FWFT_SET_FLAG_LOCK			(1 << 0)
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
2.47.2



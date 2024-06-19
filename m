Return-Path: <kvm+bounces-19973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEAC790E9DC
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:41:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B948289C6B
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1724156243;
	Wed, 19 Jun 2024 11:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="pcidmBEs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2187C15442A
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 11:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718796961; cv=none; b=DFCilpamVTGVyz1RlDAfOuneNKZ2Gk0I7BacpYku9nGpauouxzCOO2kdmd46UqHUasP0nL+R1heuRBsxkRM8lZlEv4Omyg2xtVLY1exZdzItVDP/Y6mjmA/P5JttGbBHmq6WVfW+hbyaLIq3kClIFoNwo9nZnva5ctSqGoEu+a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718796961; c=relaxed/simple;
	bh=LZHBNXdz6Lwh0lOeQXM/tAC46qcX/zMftVdcEX8HWMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZUlzjSbkoxisjdD/QnGgkuq3ojk/cna6sP/PtOjUnAVO4aaHx6kZPJ2xY/6aeGHRWMT02jT412mQvv2u+GTIpnCD9Qz8+fUM37kmiH4XdIKf2eB417gWNMx7DurQKmTLN+zN9Iw4Wo2Powt7JuhyBHhqdYVdyqvV6PKeXTCXsH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=pcidmBEs; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4217ee64ac1so6494745e9.2
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 04:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1718796957; x=1719401757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QNTR87ViStRTLjbLTFramo32AnhtfCIqG+mY5nzsVhg=;
        b=pcidmBEsYbbqZfYDl1+IfVc4oBzbD1RL/224j4FJPDxdqoJwlE3S7w909rba0PDDqB
         O5ZBpiZ/BX+bYs+lppG+W25Hds41m/MLwR6DA/u5RDEMHYi48Ui4YgpfbyOOEMxl4Qee
         cndtJFGbYxNWMRkrs9MzgVcrtGpT9Uhi5hSMKz+4DQxte+eQkmqQAA/SY/4m4MBSFMXT
         Fq0vKuaEq9DpW57Ik3JXMKm4Rf4gd/CMnBRKsc5A1eXlemjQfJ9s+jhw7ZPpmriI5dFn
         NH2cFjZ8xsV0UiFL/BKAGhrHzTXsRwlqxMsiKVksfjZK7ibSnDYlwS5mlnTAWIaEPh0s
         29uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718796957; x=1719401757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QNTR87ViStRTLjbLTFramo32AnhtfCIqG+mY5nzsVhg=;
        b=u1ortL8ONb+M2bbB60PkDXkU2k0Sry9b4c/lwYP6jFeNAJdORodc5vkWSXFRHpPd+S
         r9EC/Ss9/6Ar3wtaoCuC05qQaqfoZIFK+AMTpEUk5c7QHuv7Kw48/vwDUlQRDN/JjazY
         0HDtlGpYmpc1wTxha6PjQMeuJ89ngVtsWS8C5fhbKKvfoD4x8cVI86GvJOOT8fAFH3ux
         2HxwCOW5ZgHqYPbO2LCDAZGHG62cQ1NJNUsdPhqthFiygUheHm6R386ObEAlcASleM62
         DLX1tMUAFm4QqJhUqs6yBl/pn6tfKyFqyYxGc+lamw9dgCUMmP1wa+HbftHAC9F2stkj
         OLNw==
X-Forwarded-Encrypted: i=1; AJvYcCVo1qxwdyKcy/dZNBRPn0Un1Gyua7Trgu08AICO8hmRdbp1v+Q92Kbeg15SYTKIV+QmntdKfFDLgRObVTkpIRb+rMrS
X-Gm-Message-State: AOJu0YytmW3vmIjZ+TIMaxfhCYw1sVMWDcBxibjurYSjxvu2SR07SA6Y
	KoVIaDDmleVCjzqHS+QMGYkhnWyzk0jUpfQXF3xlHvU7XIq0h4TeqZz+Mt1CsZc=
X-Google-Smtp-Source: AGHT+IGn/LpwHNx73QtNZmX0LVZG43iWR+YwELGXaE1GpTfJ5aoWVLtbw2nzaPBzkFgiYXBhTTJV0Q==
X-Received: by 2002:a05:600c:511d:b0:423:445:4aad with SMTP id 5b1f17b1804b1-42475016e88mr16022565e9.0.1718796957512;
        Wed, 19 Jun 2024 04:35:57 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:e67b:7ea9:5658:701a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422870e9681sm266192075e9.28.2024.06.19.04.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 04:35:56 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>,
	Shuah Khan <shuah@kernel.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Atish Patra <atishp@atishpatra.org>,
	linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v7 14/16] riscv: hwprobe: export Zcmop ISA extension
Date: Wed, 19 Jun 2024 13:35:24 +0200
Message-ID: <20240619113529.676940-15-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619113529.676940-1-cleger@rivosinc.com>
References: <20240619113529.676940-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Export Zcmop ISA extension through hwprobe.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 Documentation/arch/riscv/hwprobe.rst  | 4 ++++
 arch/riscv/include/uapi/asm/hwprobe.h | 1 +
 arch/riscv/kernel/sys_hwprobe.c       | 1 +
 3 files changed, 6 insertions(+)

diff --git a/Documentation/arch/riscv/hwprobe.rst b/Documentation/arch/riscv/hwprobe.rst
index 4d9b4ed34c96..25d783be2878 100644
--- a/Documentation/arch/riscv/hwprobe.rst
+++ b/Documentation/arch/riscv/hwprobe.rst
@@ -231,6 +231,10 @@ The following keys are defined:
        ("Zcf doesn't exist on RV64 as it contains no instructions") of
        riscv-code-size-reduction.
 
+  * :c:macro:`RISCV_HWPROBE_EXT_ZCMOP`: The Zcmop May-Be-Operations extension is
+       supported as defined in the RISC-V ISA manual starting from commit
+       c732a4f39a4 ("Zcmop is ratified/1.0").
+
 * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
   information about the selected set of processors.
 
diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index c38f3f2b8382..920fc6a586c9 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -70,6 +70,7 @@ struct riscv_hwprobe {
 #define		RISCV_HWPROBE_EXT_ZCB		(1ULL << 44)
 #define		RISCV_HWPROBE_EXT_ZCD		(1ULL << 45)
 #define		RISCV_HWPROBE_EXT_ZCF		(1ULL << 46)
+#define		RISCV_HWPROBE_EXT_ZCMOP		(1ULL << 47)
 #define RISCV_HWPROBE_KEY_CPUPERF_0	5
 #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index 89e03cdf38b7..3d1aa13a0bb2 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -115,6 +115,7 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 		EXT_KEY(ZIMOP);
 		EXT_KEY(ZCA);
 		EXT_KEY(ZCB);
+		EXT_KEY(ZCMOP);
 
 		/*
 		 * All the following extensions must depend on the kernel
-- 
2.45.2



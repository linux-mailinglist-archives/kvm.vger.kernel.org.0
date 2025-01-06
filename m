Return-Path: <kvm+bounces-34605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA6FA02C06
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 16:49:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8330918871BA
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 15:49:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF2871DDC06;
	Mon,  6 Jan 2025 15:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="dTsdyakz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C926D1DBB13
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 15:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178554; cv=none; b=Ef2BzwetnGaAHUDUaXg4wkfpmk17w4r8ckJQuHe/CgC4byXpcQASevQiOYc+3p4/4d31B1Xdb1NkMHo6ZcabiYN8oZELGU9OJFxcSX0RoIAwNLMGglGT1mIPOZLqxHySIdDMWbjmZaps0AEKWWj2FV1OU2Ieewac6jl66goB9a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178554; c=relaxed/simple;
	bh=KJViQbIKB51hAmzJsn4Tca3rpV3uTsCs5XwY4x4I6Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uvOuiQk6c5cMPvdiV1brPkE3rui4Rg4v+ka9Qw0MtVEQEDd5gyO9L8ZTeYcSriD2VxvQgJcc7erP/dJuGk/FvbmBJwDJhymM0Qn1k8PS7ebu4KhjplKuYRCBSKnX7Px6vfSvVg0B/yHOtR9R1mk4VczhLC/1I2hcjl0M6kH7saA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=dTsdyakz; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-216401de828so197556015ad.3
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 07:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736178552; x=1736783352; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YWWbvbVWcBkTLDmBWRGuP/373zfHHQD7CsE6sYbpx+8=;
        b=dTsdyakzKfleJvvMixWTIgLaIhfi7Be/jGyyhzbC81o1RlJklegP9a3+rrsNlNOMVU
         bBOkCbO+0/JMC1TLn2TaA3J3ijEr5kNsiZTy7ZFmJnCy60dU6NVlHRr+um3aBTeyGgv0
         nc5KrF4r4PSNyeLQORYiE5LzGFbWydgbp5Ff65VQxSFDnqXyyJPccLVpXunYf4mfvQlW
         aEQJshSr8GvP8jLpaT6prOKxGSDtBYsCVqXk4EfY12Ec+G1W+2f9D0otUKoUfQOH5DV8
         UpcuNTMc+9l9uu4kcPCFb3ZFFo4YNLkEdIT2BpZAeOacaGb/tSSnuqrcOVeqPlCDSuMq
         /k/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736178552; x=1736783352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YWWbvbVWcBkTLDmBWRGuP/373zfHHQD7CsE6sYbpx+8=;
        b=B/3/kY3D8fsUoypYEnlLLDsqBXaVhvVhhlsq+y6EN/NWVuV1xVYzG1WjOwwYHfFSbF
         HdSNHea4DJw/S8DTRixYmUlT4AE8MmaPhmvUZNvFtb0DkZAZtRTHVfqRgmpDAMxf+DH4
         Eud534miVP52PxuhSa++IGghUhW+SNp4pTewNxuc6VfinVy6fH9lA0QztebDqHkpUa1J
         Uq48UvyHll3hsZZZ4egOVgiYNFu5ccfU852Nvwdh2i2IrNrZUWQCyqhpjFV8t31tdg8u
         9sFWQo36Xoyq2/GgX0lyEIHpCzsTn/qimmBHC1m1M8np33tO6cg7qbbkqopjASmTG2ZM
         9byg==
X-Forwarded-Encrypted: i=1; AJvYcCXBBlMPXg22ufmv0wqitlhPyvYIZIhLSXPsD3yElmKw+qHcvRk20C00qS2dQCnN+kgbOIA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2UVsBHbeWihue5onnJ45jsmbKpb9XW6Xtm/7DKm9DcEHUAqM/
	22iyFtrvPZpoB0WOrcKC/Zv1ZpUgmNnAeLKK0K5NHIhEy5fSHFn4g1Dinf77+V0=
X-Gm-Gg: ASbGncsN/Hy5rGD00FyJoFz4NzOetzZJqu+HhjlQc/gkcuhvchREsBAU9UpnAyEhWM3
	FLg+LX01d1KEJfJpSKIYCfyDxRSxDNhDFqdf2ypqLOs77wJhmZSXSvKK/AtLJ4AeEEPArsCZsn1
	MojjpM4B7nEaOAigeEa4+Ay1cn5gWolN+urBw/L8lzw8e70RUv0mKMrdOe9gNjdjs1rp2YDVPrc
	QVj0VUx9p/ufHlhhSwAvXS/K647pKYzDWB0vlQmbl2j18wasFPoJNwo7A==
X-Google-Smtp-Source: AGHT+IFsrR++da94vh57i8gZG2YCIfCJlCqOllnoSuVQjwf/TtLCIaXs8yZigKmfjKjyX3pC2+VXhQ==
X-Received: by 2002:a17:902:d2c7:b0:216:5448:22a4 with SMTP id d9443c01a7336-219e6e89a6dmr805222645ad.10.1736178552138;
        Mon, 06 Jan 2025 07:49:12 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9f6967sm292479535ad.214.2025.01.06.07.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 07:49:11 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
Subject: [PATCH 1/6] riscv: add Firmware Feature (FWFT) SBI extensions definitions
Date: Mon,  6 Jan 2025 16:48:38 +0100
Message-ID: <20250106154847.1100344-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106154847.1100344-1-cleger@rivosinc.com>
References: <20250106154847.1100344-1-cleger@rivosinc.com>
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
---
 arch/riscv/include/asm/sbi.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 6c82318065cf..ec78de071e0e 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -35,6 +35,7 @@ enum sbi_ext_id {
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_STA = 0x535441,
 	SBI_EXT_NACL = 0x4E41434C,
+	SBI_EXT_FWFT = 0x46574654,
 
 	/* Experimentals extensions must lie within this range */
 	SBI_EXT_EXPERIMENTAL_START = 0x08000000,
@@ -401,6 +402,33 @@ enum sbi_ext_nacl_feature {
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
-- 
2.47.1



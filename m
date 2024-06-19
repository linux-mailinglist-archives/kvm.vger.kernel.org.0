Return-Path: <kvm+bounces-19974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5691190E9E1
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:41:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CCD04B2133B
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:41:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC6F156F21;
	Wed, 19 Jun 2024 11:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="EUjD1yC5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783B7155756
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 11:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718796963; cv=none; b=MhnCnXHKC7J6mP4aUKz6eSK0bPrgEAErHSqDgWsgRdxEwOphJwdC0Q6sjEe7BHYQcktGU0RP1hFJLlZqT8efBl5XNHTCwy8p+8c3Cd8bWVd6xoa3sxUyoPagdBxqfbP5EUZrDOS3iGTFtkkMmTfiRdGMsQ2mlcYzCTdYBdwZEQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718796963; c=relaxed/simple;
	bh=X4qBKgV4JJYgoyWLE1WwBRgEHa7E96dNUupuHsGIhok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cQsVNQqZ5p6ORDUYgonFn1olbkZ7NTbCyA7HSOzHvkeoOYveuoFD3G7Jx0NeaqF4wfKTV5ingCTR+zHj+WBcf1yI1O6O4ijbGH5jQ/c54JMqePwFk5t6moaENy5bKvOwkMRVyyMUz5L6pS6GxM1fcfaYSRxbVGVVGxGzc86kqyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=EUjD1yC5; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2ec3ce5fda0so1063691fa.1
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 04:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1718796959; x=1719401759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TPgjZRcqRRqmI3UFgS+Cn+Zr3OcI7PEtvkIvlPP0qT0=;
        b=EUjD1yC5qNCrn3Muaiif1DjGmCkVQmRI5g9Gf50hxBi2z1mp50kR1ZD0GeWKPjuckV
         2dkMJroFxRajztiG7ljqzZGLmM1BkVbnBuHuiZ8RJow+TbyreGjEXiJ8CXyDPYhTQfxN
         fhqj+OND0javAV2cftdLhleFt1dZ66roXJFkhDQ0/9Er1E/1FmE24GCOs7iOaO7YL9fu
         iJLH3k6xbpUDVFBYPvqTYvh8zRZrPc+niIo6RVm0N+JVLTEQ8kUvgGxlD/S/xZTNL2tb
         C2tG8YlMv0CsO4n7lFePrluCULPnLirvOXyW7vfnNcbEf9uDVJHTX7ZpmFj2mec/ljyo
         70Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718796959; x=1719401759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TPgjZRcqRRqmI3UFgS+Cn+Zr3OcI7PEtvkIvlPP0qT0=;
        b=FAbiRb4WgQbz/DX66FyyuBDU2XrDlujfS+bXqCBaLFMUd2b7ZZ2pwGb/NG5mnFLwMb
         Bq/xB+6oBekDSj+sukQt7VlY62XOKTOJT6VzRfGvUTw3mhaMUkPkMkjqw/sja8ucIlYq
         K18a1FdgcDo5ndy5IgwfbAZMS/swEBqWBTZBJDYxzF8Q2YUTxQiUFtNs8GoNsk5sY6uf
         NW2SqY0gzp4XH8TXe+IKLNkEg8EnWuXefNiBiiA/LpO7RucTkzgtDyxojfehKR+4EMNL
         HVaG0Qns9IXwfMIfKJh/i8DfGAosp7Nqv3RGeJciC/la01fqxy4NQlCyExjl/dx2s3qL
         KrlA==
X-Forwarded-Encrypted: i=1; AJvYcCU0MoIXv7GVPzfxA87wHnN9JvohEBO9gpxlgKvAd5Vtx8qo/C0G2wJXTPp5uaR9aO/OZxSawr+7XDqxRUon+0IZT5W7
X-Gm-Message-State: AOJu0Yy0m0e0rum/O8DdPfKL4bBS4gBH7i6mYEreCKHn5SihOax1SzrZ
	+TYJZH1+k5jWZefAiPTwda4XFmPFzrfZeJdmcPleZ0QU79VGM6Wrsl3fxl3ppGs=
X-Google-Smtp-Source: AGHT+IEEUCVgW+BCowVYPjYKYwNlCLmKSZ/5HGn2eR9JA6+OxkNbZ4kw3whUx8mTA5ZRd8MgB6kmxQ==
X-Received: by 2002:a05:6512:398f:b0:52c:a7b6:bb11 with SMTP id 2adb3069b0e04-52ccaa59e2dmr1406908e87.1.1718796959602;
        Wed, 19 Jun 2024 04:35:59 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:e67b:7ea9:5658:701a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422870e9681sm266192075e9.28.2024.06.19.04.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 04:35:59 -0700 (PDT)
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
Subject: [PATCH v7 16/16] KVM: riscv: selftests: Add Zcmop extension to get-reg-list test
Date: Wed, 19 Jun 2024 13:35:26 +0200
Message-ID: <20240619113529.676940-17-cleger@rivosinc.com>
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

The KVM RISC-V allows Zcmop extension for Guest/VM so add this
extension to get-reg-list test.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Anup Patel <anup@brainfault.org>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 864a701ef6c3..1a5637a6ea1e 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -60,6 +60,7 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZCB:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZCD:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZCF:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZCMOP:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFA:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFH:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFHMIN:
@@ -431,6 +432,7 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
 		KVM_ISA_EXT_ARR(ZCB),
 		KVM_ISA_EXT_ARR(ZCD),
 		KVM_ISA_EXT_ARR(ZCF),
+		KVM_ISA_EXT_ARR(ZCMOP),
 		KVM_ISA_EXT_ARR(ZFA),
 		KVM_ISA_EXT_ARR(ZFH),
 		KVM_ISA_EXT_ARR(ZFHMIN),
@@ -960,6 +962,7 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zca, ZCA),
 KVM_ISA_EXT_SIMPLE_CONFIG(zcb, ZCB),
 KVM_ISA_EXT_SIMPLE_CONFIG(zcd, ZCD),
 KVM_ISA_EXT_SIMPLE_CONFIG(zcf, ZCF),
+KVM_ISA_EXT_SIMPLE_CONFIG(zcmop, ZCMOP);
 KVM_ISA_EXT_SIMPLE_CONFIG(zfa, ZFA);
 KVM_ISA_EXT_SIMPLE_CONFIG(zfh, ZFH);
 KVM_ISA_EXT_SIMPLE_CONFIG(zfhmin, ZFHMIN);
@@ -1021,6 +1024,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_zcb,
 	&config_zcd,
 	&config_zcf,
+	&config_zcmop,
 	&config_zfa,
 	&config_zfh,
 	&config_zfhmin,
-- 
2.45.2



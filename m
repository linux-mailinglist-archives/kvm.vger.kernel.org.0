Return-Path: <kvm+bounces-13526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9457898526
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 12:35:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62DDF283C37
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 10:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5C7784FD0;
	Thu,  4 Apr 2024 10:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="kPtlXCEt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E472B80C14
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 10:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712226871; cv=none; b=JSa70rUGc/9tJC+8z+txIo2Qfgdu1YQSPRoMXdRF3TEzTPakBSCb0CiKmtr9WwmLdyIniRhz9vflxsWYiDWUphXqVVTGitQplHS0cPfpS510g23l0Hdbxbjq6nC55uR853n7fxem3gbCN87PgvGVIFUSXslLkgWVKe2nXr/YKaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712226871; c=relaxed/simple;
	bh=tISoTGebS4407fh89NkrPP6RNVyQwmfvD5bdgCJ5Fi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uUl6WB7eePP/8DyxwSpxdM1sfALJSCXc2JXgIXAygkzws59wXrPZir8FNo2C+lBTqIPR5AHTsjllMFhF2zW0m8NkzOxn8xHhpoo0hRAca33auy/zcSDZ3s6uGEpflKbxzHuvxnQqr5Hdv0IYC4CcAZq/UhCjeaPrC1iF6Fjri/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=kPtlXCEt; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-41401ee5828so416505e9.0
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 03:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712226867; x=1712831667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p3qT2c8/AbHM1mLG3KaUUQ1VJHCZOCgVEzdfPOCGq3I=;
        b=kPtlXCEt3EGAeK1fE02h12tzNeJyPkb+mlY6384SqmhbD+fyGuNRR+McyQtUivwIC9
         6YECsvTAdrIhQbDwYaXq+TRPXDxMwsqpq2UvFZaSYDKx5J+gFkKhSHOjIHl0rMXhnAqv
         51ajX7hVamiWHpfS5x8FslulSnfKLKkobQ6CGNQcuihGE/OTocXBYyzPAPDe8NXdBYzI
         txrqagC2MFiY8L4sybrJAShVvO/nQCh8UNO34OAxd7I1ZY8K86TB3J8lXgdGq6oKi3LW
         uxvBfeJXbj3rz7TSWJLDFA1kxpjuBkO+9zdCcJ3EfW+4AVgSlHcNbwC6cY3qqve5MjnH
         5r+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712226867; x=1712831667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p3qT2c8/AbHM1mLG3KaUUQ1VJHCZOCgVEzdfPOCGq3I=;
        b=cY1GBv+hKx1Quz1X1kiePrSEsbFL3VShMxoiidtmgT48cP9N860P9pyHf3BOviBcah
         Qmh+/Vm5c+k0eJIszu9eh7po1leAQZyqhhMyw4QyYwPEt2PXVZWJ2zlzicOi48JHjbPv
         3P/EBjIeCmEwulrc0pR9BAnpIJ8NmNzUBnYpCXtWZ9c7YO4NPJTdAO5xx33ilewk7YFJ
         8d11OUzRlQYvpvIVKqjWUuN9DC9thS/AKPmGXeGZhR6NMo6YMxyKqsLHfF+4xX+tQhtI
         dc8Xtfd02JJcQcvHeeBQPH9sS6LRcusAtPpdVdtOD5s0tdaLaejeUxCISot1cVQexGTO
         HzSA==
X-Forwarded-Encrypted: i=1; AJvYcCV4bdvPi3hj+3b+uvcWD2fDo4I+ns1sUsMc3TyyvG+4rw7DUIWabMx6DxMKPv1gX8Mz976p8tD0ewAfGrCZ8RgajhK4
X-Gm-Message-State: AOJu0Yy4yLqt4pOhYjMP/7IYFr39YRLrgIKLnTWICte6i/E5QEINGqvz
	I65xI2htQjDi1ChndjO4+0j/OU2Wkf2VJHsSUoYd8VA6YgAzefEhDUSDgArLALI=
X-Google-Smtp-Source: AGHT+IFHr+u5rilj3I1gcYe1DCoh9ifQezh0QsNetqn5cyyFOzLAXut6U4dx1r1pj5Eqiio15Ou5mQ==
X-Received: by 2002:a05:600c:1c13:b0:414:6467:2b1d with SMTP id j19-20020a05600c1c1300b0041464672b1dmr1726188wms.0.1712226867334;
        Thu, 04 Apr 2024 03:34:27 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:555b:1d2e:132d:dd32])
        by smtp.gmail.com with ESMTPSA id ju8-20020a05600c56c800b00416253a0dbdsm2171340wmb.36.2024.04.04.03.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 03:34:26 -0700 (PDT)
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
Subject: [PATCH 4/5] RISC-V: KVM: Allow Zimop extension for Guest/VM
Date: Thu,  4 Apr 2024 12:32:50 +0200
Message-ID: <20240404103254.1752834-5-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240404103254.1752834-1-cleger@rivosinc.com>
References: <20240404103254.1752834-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Extend the KVM ISA extension ONE_REG interface to allow KVM user space
to detect and enable Zimop extension for Guest/VM.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu_onereg.c      | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index b1c503c2959c..35a12aa1953e 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -167,6 +167,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZFA,
 	KVM_RISCV_ISA_EXT_ZTSO,
 	KVM_RISCV_ISA_EXT_ZACAS,
+	KVM_RISCV_ISA_EXT_ZIMOP,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index f4a6124d25c9..c6ee763422f2 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -60,6 +60,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(ZIHINTNTL),
 	KVM_ISA_EXT_ARR(ZIHINTPAUSE),
 	KVM_ISA_EXT_ARR(ZIHPM),
+	KVM_ISA_EXT_ARR(ZIMOP),
 	KVM_ISA_EXT_ARR(ZKND),
 	KVM_ISA_EXT_ARR(ZKNE),
 	KVM_ISA_EXT_ARR(ZKNH),
@@ -137,6 +138,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_ZIHINTNTL:
 	case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
 	case KVM_RISCV_ISA_EXT_ZIHPM:
+	case KVM_RISCV_ISA_EXT_ZIMOP:
 	case KVM_RISCV_ISA_EXT_ZKND:
 	case KVM_RISCV_ISA_EXT_ZKNE:
 	case KVM_RISCV_ISA_EXT_ZKNH:
-- 
2.43.0



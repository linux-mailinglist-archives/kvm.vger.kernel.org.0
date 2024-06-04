Return-Path: <kvm+bounces-18777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BB6698FB2D4
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E5001F21D3A
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FB21149E01;
	Tue,  4 Jun 2024 12:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="h9S8tfa2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45679146A99
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 12:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717505298; cv=none; b=Wx50SQWvw6BJVpQqd1DnrgflNtnnkjAyoCaTtTohqQE3bCNMvuXEiGbANvnfGd775YpV8pQntaw8al8fBkMiYH89ip31BEHQ6YcPNQUAWaTXhR1EbfqY14X5XiQNmYX7Pa8aXz43fVuLf3/RndTYlf8aEJB/Ib3FVKDTmUwyl4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717505298; c=relaxed/simple;
	bh=aJAliq5CHA/MVkbpTKH/IWMG7oopOra0amDyV4wWYK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bOwqqmmgF4k+m+2dTI8tL5R/0LAqrtDNo4cVUJvAsYoX1bXH14tg/7QJpzggcMAXQ1K2qKXrWPiNNTY7HxgzF33ABTPsruEP7M8GOH45wGdqOfN/yHwNvZZlVoB3wqlRSQc4y0hfeQqBYqf1Y3psLAD5GkHxikUSfEEU2TTGQik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=h9S8tfa2; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1f61c2c689eso1264375ad.3
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 05:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1717505296; x=1718110096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pl7e/Uw2TsjVm5w2UCcg19dOQoVq7golKlAiO1RXFLo=;
        b=h9S8tfa2HXLjWvZ6hhI6a5/AgFz+WWwc1+1XNcbg/LdhqGSKCgxqlvzJ2H43thsZ95
         TsAT+lTUBkNO7dI4EOd0eSq2aFs4Rj4nU62p/E4jFnYCpJXpa1e0tJ6825bqYtGoeAAo
         66qMPxcdxVM1roxtngqsk9RoHWQ7Jr3Tze6jvTtw3hDB04zgJ0IQV58X+lZbSqedCC9+
         aWMzgdch+JBsdFnpps0zkG4hLsGA5nssPrpdhhjDMVyiWujZPZcAaIOrmXwkzOjjfzbX
         0IJ9baePE1fa0KIGDHtKvn9+3DrlxxE5VFNPnZxOrzLUarYPy3T6CUBHZ30/y2FfqMIV
         7zHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717505296; x=1718110096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pl7e/Uw2TsjVm5w2UCcg19dOQoVq7golKlAiO1RXFLo=;
        b=RNh7MiH0yfZ/8Lcs5Eq2no/n8hE5+cRN78SoJ06SlPxEfWkm1UYtb2oo869gFqUzlB
         ZJlsA+///2yOkL8KNZ29fdE022Z9TWN0ezjdBPc+HSKybVTt+8zS5nlNkagkhRSnj5Yj
         Ovugr/Nbq3AxJwbkhM1E0zTauSqoe4Zaelv9fmrDJ8VVGm8bvOdbl6EZCuT4gOOOxsRU
         RKpv9wMA08dUWdbUxP1MaYU7ZKwfZ3aJfk55ikGNUhbXZBzvtRTDkrAf2Ea2prAN5tnu
         Fk0Ed+W0quEHT0IB+FNy4HAfoYBUzClDFiEXgdor8UELTe7sYf5KiD+ba0xd3tyrY7k2
         H2iQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5hIZYBcgdrAhOXMwSXtFG0sMI+XKppY/mJ5EFe4XwKXbuLiJFG2DFtD6mQTDvb7EDtodOel4zfOUpSn22b9xjhjQM
X-Gm-Message-State: AOJu0YwJ9M/qEEjS5C64N9WZx22Ub9c6dky+ABIe+qd46AzFg3jBQb19
	1CGWhgPMQ8SoHBr9dXvT+ahG4UsAGKqCoqIUHwUVUu/PaD0ush5dS60zPGDYSpc=
X-Google-Smtp-Source: AGHT+IHDavkX6lYzEzmyDr28AhE3WeR2xg+16B5HaBHrs9r6naCfkGg0GyGTT03skFYsojMtzKntzA==
X-Received: by 2002:a17:902:6541:b0:1f6:226f:cc50 with SMTP id d9443c01a7336-1f69425b1e5mr23526605ad.6.1717505296634;
        Tue, 04 Jun 2024 05:48:16 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:327b:5ba3:8154:37ed])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6323ebc69sm83042885ad.211.2024.06.04.05.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 05:48:16 -0700 (PDT)
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
Subject: [PATCH v6 11/16] KVM: riscv: selftests: Add some Zc* extensions to get-reg-list test
Date: Tue,  4 Jun 2024 14:45:43 +0200
Message-ID: <20240604124550.3214710-12-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240604124550.3214710-1-cleger@rivosinc.com>
References: <20240604124550.3214710-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The KVM RISC-V allows Zca, Zcf, Zcd and Zcb extensions for Guest/VM so
add these extensions to get-reg-list test.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Anup Patel <anup@brainfault.org>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 8c8b109ce3ca..864a701ef6c3 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -56,6 +56,10 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZBKC:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZBKX:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZBS:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZCA:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZCB:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZCD:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZCF:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFA:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFH:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFHMIN:
@@ -423,6 +427,10 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
 		KVM_ISA_EXT_ARR(ZBKC),
 		KVM_ISA_EXT_ARR(ZBKX),
 		KVM_ISA_EXT_ARR(ZBS),
+		KVM_ISA_EXT_ARR(ZCA),
+		KVM_ISA_EXT_ARR(ZCB),
+		KVM_ISA_EXT_ARR(ZCD),
+		KVM_ISA_EXT_ARR(ZCF),
 		KVM_ISA_EXT_ARR(ZFA),
 		KVM_ISA_EXT_ARR(ZFH),
 		KVM_ISA_EXT_ARR(ZFHMIN),
@@ -948,6 +956,10 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zbkb, ZBKB);
 KVM_ISA_EXT_SIMPLE_CONFIG(zbkc, ZBKC);
 KVM_ISA_EXT_SIMPLE_CONFIG(zbkx, ZBKX);
 KVM_ISA_EXT_SIMPLE_CONFIG(zbs, ZBS);
+KVM_ISA_EXT_SIMPLE_CONFIG(zca, ZCA),
+KVM_ISA_EXT_SIMPLE_CONFIG(zcb, ZCB),
+KVM_ISA_EXT_SIMPLE_CONFIG(zcd, ZCD),
+KVM_ISA_EXT_SIMPLE_CONFIG(zcf, ZCF),
 KVM_ISA_EXT_SIMPLE_CONFIG(zfa, ZFA);
 KVM_ISA_EXT_SIMPLE_CONFIG(zfh, ZFH);
 KVM_ISA_EXT_SIMPLE_CONFIG(zfhmin, ZFHMIN);
@@ -1005,6 +1017,10 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_zbkc,
 	&config_zbkx,
 	&config_zbs,
+	&config_zca,
+	&config_zcb,
+	&config_zcd,
+	&config_zcf,
 	&config_zfa,
 	&config_zfh,
 	&config_zfhmin,
-- 
2.45.1



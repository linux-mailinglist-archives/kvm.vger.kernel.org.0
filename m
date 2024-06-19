Return-Path: <kvm+bounces-19969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF39890E9C4
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F4AA288979
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D3C152536;
	Wed, 19 Jun 2024 11:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="T1OD0LP+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049B715099E
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 11:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718796955; cv=none; b=hyDHpzXEUBrzt4NB61ItzsJ2mLp2wbgqCG6F1Br5VgW2e6u5ZzdNEhAFDlDCw5h1/2a+En6zHgqEDJNnBbLM2aoBHwImKWMgMFD+Yr9WAk/sYHw8ygCAHGX9G3ZxSfWSLVgA332QDkoMnqVoB3YVbFidAr2odyOU/XVwUgl/cFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718796955; c=relaxed/simple;
	bh=mL6CbMRV2Y+Cc6SDQkB1CIgyJ8GWXK/1Cwsr12Rf8fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gwwW1DMksL3JiXua5XQjv2we3qvpOMzz456n2uBe3tQuOBxGwLaZZJr14IMypI1Ii0s9brZxu6HEtziyf+naf9TA8AJKIhmTE7UDhPTr77qsIKoePE90tPFJ+sjvMxKXJWD5Mo64VsNdr+To96t5M/h4tOWbhCen4nWmn/w/62E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=T1OD0LP+; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-52a6f05503aso618000e87.0
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 04:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1718796952; x=1719401752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5oE8gsBvV5fZz1ffXpMzF77ixjq/ISJJW2NOreey68Q=;
        b=T1OD0LP+5dB0ro1KI5qs0bolxsxd8jO4dbHwgLN9+A0yjPCW7O2lLMqBZF/io0GxlM
         ew2m9ZzyVYs1/JWzqlMlNqHDgAFreRojEVRJeAa49O8y+yDQA3itj6Sh2nnIBieSn8g1
         luPHHbYyN8sXFykVMI07VpKd8luLM8sTdWzuOzMps5cynHfF/jVfWv8K879x7kQApc6u
         xgbyli7JvtXrBrmmNqXvi0RIq2UyjUnX+Kb/xkgi1MHw2NwP1/4IV4GnQWkwLiVdTK2O
         FAIRJol6fhnVhcx0NWxFHfLu/2HqvvwdBMI9HIDo2dEE/OSE9uqt25q3wgHq6VmWiPAo
         G3eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718796952; x=1719401752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5oE8gsBvV5fZz1ffXpMzF77ixjq/ISJJW2NOreey68Q=;
        b=F0czz+QtOuX0nLciQtBWtoTpgSNQre2Cu3YMVgD4k/3sESXpvhXG1hFuQAOhMi2epK
         9N1eO2DDE+VqI7WX66qtw8Q4caGmSlHxDal9Y+V+H/KEU4zO2woITAhtot0ymYoEOZl2
         O7A7fcY8YyN6tFRpsHkI3gIPELte6GITsAqW/v5WPEgO9KbrBW9tX6+K7eiSnlK8EdXJ
         RPPMq4vx4mBAOBI7ylEZRrlhNs3IbIdK8Pd62cg7ygAMOK2cYsx8sheNFj9UN1UCjD8k
         8VMehow89trPx+XQ01+BxSdCBRHFOi0EF2iZTdNVrgvSkyPvisZH2TCezNnsgwP/+ILY
         TkDw==
X-Forwarded-Encrypted: i=1; AJvYcCXEmK4oGoDi11H+0IHnKoJ27wR8sxGLBfy8YJ5fSJXxIL7mvM+QPLxdWrpesAfaXrpS5bzYNfLVqv+D30czO6tlvu9H
X-Gm-Message-State: AOJu0YxVdCYKnN6WzRtZzNz+PYiUlXqyQDoEmG2c2w+tO/AUKFshInNZ
	ByCXXlnIwNW84YgxIOwTt0yBXkIeXTK3O5wHQ/3MLGwHSIdLGz/Vh7SsYfsNiNk=
X-Google-Smtp-Source: AGHT+IHTtkzZFj1rr1J3MMHIV92yO19IIimUF3KsHK4wEqSnORETlwIu0v29uuJeQFp2SthY6SPnTQ==
X-Received: by 2002:a05:6512:39c4:b0:52c:a657:7e85 with SMTP id 2adb3069b0e04-52ccaa60a8bmr1738253e87.3.1718796952270;
        Wed, 19 Jun 2024 04:35:52 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:e67b:7ea9:5658:701a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422870e9681sm266192075e9.28.2024.06.19.04.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 04:35:51 -0700 (PDT)
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
Subject: [PATCH v7 11/16] KVM: riscv: selftests: Add some Zc* extensions to get-reg-list test
Date: Wed, 19 Jun 2024 13:35:21 +0200
Message-ID: <20240619113529.676940-12-cleger@rivosinc.com>
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
2.45.2



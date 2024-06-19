Return-Path: <kvm+bounces-19963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C252290E9A5
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:37:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A85C286816
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A8C4147C6E;
	Wed, 19 Jun 2024 11:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="i1UiM5Uh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DF8143885
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 11:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718796945; cv=none; b=Mrx9CRWZutfacnnnwjJUo2e1080Vg6wNlEzTOSbFv+nseI6yOQNpow9+D59Keygs0pTSdLbgjYMG3kmAWfxhpwIKFxJcOw5u10YADz//NuGVG1yrBppD0JIL8f8Eoo66ddCjB3TabmAfrqxQODwCWj/vUHxjBDHvb7ZUA5H8DrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718796945; c=relaxed/simple;
	bh=O++FL3hoG6s+6VU68wFkgUM2bEL6DqMNwQ6yctql2FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rYGrBx1qkPnUE3x/i10xi/qZ2gAw5Hq3tmmpqjMVgaWNR3wbaOkSImkd3jwbVOK5Ing+tvb51/qJp486whkzhlOFeismVmNKBLqp+a7jIqJVg63AzmKuobfk6KIgrJ4YDQad7qODxYJDgn+wU+6c8VOSDhpOR4nP03I6k7VOc6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=i1UiM5Uh; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-363db2f9fc5so47530f8f.1
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 04:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1718796942; x=1719401742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=75rTjwiTigH0M5dSuDfGTD/7XLnMHNSdwJR4GKnSoMI=;
        b=i1UiM5Uhd4t9br6wOdkGAahWDQJf49NIgp3vNkPZVNCFbJFWcApSlKTXpOVhzyQGrl
         /41hRpuPZF5bSM0K4IYdb8py1C3qAT7sBqKhgs8oTeJRw4uGp91ndtZewJ4RXs7Z5+eK
         G/ZT8lTnBgj92iVf92UeoI1K/4fg0aIK0krjBmQO5nCG296hUZYK8TdNLHoK6GHiFtkQ
         MroxiocIDDmHI4+X2sntwT9+YIxkpoT42laiV/kDcpRcuBPwcL8SWvJOgOTaqRDTPdzM
         u7ikht6L26B3YVb4b4gscb8WxwFMKmOZdOQFyUMuwzvR09RRUxtIOjgHs8RaFmn5i+Q7
         D9tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718796942; x=1719401742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=75rTjwiTigH0M5dSuDfGTD/7XLnMHNSdwJR4GKnSoMI=;
        b=ngmih2mTVn9bn40w9gM5OxSNu4S8YpECElijt7JDYgW6//nUxyqR6ghg5nfPeVUSae
         FgPZcfPLmBdeKefPZPRqDptFXJLtxLY0XEPn1bgNl9Ff/ulf8cX1mYIPbKNrtvcZEdBs
         ADC9Hu6+IVY/5AN7r/6oyf6UfxzeJEFqk1LA5Avgw39rtMRphqiBnKb6CoNTbU3xw+ie
         QHgU9XawjXsVsvcWMXkmJMHwCSlmvYmp0z51VelEgfzOi0I3nPuHNlFdVFt7ueUq8TQu
         qa+XRu+YYTlaKx2BfKzNBURuZcuPG9E7Q6BB3U0BxNU8/ebpu8bYRF2/GtEovLp1UG/E
         U4qQ==
X-Forwarded-Encrypted: i=1; AJvYcCXa+pB+fT0wUfGjAXHv6BVvufqis05mnye2B6FFy9vYczs83IQw4DOovYRTb+XH/NWRE17xvm02rinWPVMp/yDZh/Cz
X-Gm-Message-State: AOJu0YwYHZ5V+MdYyIZDM3R+68K9LIhet+PCahOflMLw4xknykbIAli2
	xiqT+n5KvlIp402dCP/UeAFdqJwifOj3yjR71i2FkBCJUlcIOcgYkqtkqicw7fA=
X-Google-Smtp-Source: AGHT+IHnu+3U5OyaRWV2j3JU5BIwJF09UD4syTsljNxRRPi07OByw6Zovlpi+faN3PrM3kuT5uCqKA==
X-Received: by 2002:a05:600c:2252:b0:424:798a:f7f3 with SMTP id 5b1f17b1804b1-424798afe49mr6215185e9.1.1718796941741;
        Wed, 19 Jun 2024 04:35:41 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:e67b:7ea9:5658:701a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422870e9681sm266192075e9.28.2024.06.19.04.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 04:35:40 -0700 (PDT)
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
Subject: [PATCH v7 05/16] KVM: riscv: selftests: Add Zimop extension to get-reg-list test
Date: Wed, 19 Jun 2024 13:35:15 +0200
Message-ID: <20240619113529.676940-6-cleger@rivosinc.com>
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

The KVM RISC-V allows Zimop extension for Guest/VM so add this
extension to get-reg-list test.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Anup Patel <anup@brainfault.org>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 222198dd6d04..8c8b109ce3ca 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -68,6 +68,7 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZIHINTNTL:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZIHPM:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZIMOP:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZKND:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZKNE:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZKNH:
@@ -434,6 +435,7 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
 		KVM_ISA_EXT_ARR(ZIHINTNTL),
 		KVM_ISA_EXT_ARR(ZIHINTPAUSE),
 		KVM_ISA_EXT_ARR(ZIHPM),
+		KVM_ISA_EXT_ARR(ZIMOP),
 		KVM_ISA_EXT_ARR(ZKND),
 		KVM_ISA_EXT_ARR(ZKNE),
 		KVM_ISA_EXT_ARR(ZKNH),
@@ -958,6 +960,7 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zifencei, ZIFENCEI);
 KVM_ISA_EXT_SIMPLE_CONFIG(zihintntl, ZIHINTNTL);
 KVM_ISA_EXT_SIMPLE_CONFIG(zihintpause, ZIHINTPAUSE);
 KVM_ISA_EXT_SIMPLE_CONFIG(zihpm, ZIHPM);
+KVM_ISA_EXT_SIMPLE_CONFIG(zimop, ZIMOP);
 KVM_ISA_EXT_SIMPLE_CONFIG(zknd, ZKND);
 KVM_ISA_EXT_SIMPLE_CONFIG(zkne, ZKNE);
 KVM_ISA_EXT_SIMPLE_CONFIG(zknh, ZKNH);
@@ -1014,6 +1017,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_zihintntl,
 	&config_zihintpause,
 	&config_zihpm,
+	&config_zimop,
 	&config_zknd,
 	&config_zkne,
 	&config_zknh,
-- 
2.45.2



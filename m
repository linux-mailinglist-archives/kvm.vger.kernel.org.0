Return-Path: <kvm+bounces-8674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D92E1854959
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 13:39:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64A241F23BBB
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 12:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B38253E1A;
	Wed, 14 Feb 2024 12:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="DHowmyyD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE1D537FB
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 12:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707914301; cv=none; b=oYwg78UIJqJojVKf7nIo5UnzCVm7tadqYto64B2tErJZf9VQdIZCVnsnuDHV0QxxHv4V7l7B18fa8ZJQqr94T8s4qeXc3T+hXaibWCjeVB8Maxjf7KhqHAj3SeTZkD7b97QZStaQihRnpzC3+FhdOfAI90PTFgMgbd8jYocLHJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707914301; c=relaxed/simple;
	bh=c2+76faT1dINMScpmeF2F1CzQBtl7c0GReCrzYb31Pc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oYKEZSZ1PZZglkgkdP4SwYh3g2srXN2dqTaqlIoZKqHouGqgkRIXgI2b35jpIRUdSHGVhphzuDLwua2LNT5vy3zVW3oqiY+VCnkNxKQ9aSgBASYVYn+Zcw7PKEW87rjkEQE+IfS2xp6oT/740yVtqIOveUmDjYK/OJqUKJei2fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=DHowmyyD; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e0ac91e1e9so2605952b3a.3
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 04:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1707914299; x=1708519099; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CtRzUtn5YlgGEqGNmE5oViuKGD26HTcJD0Q89ujSctY=;
        b=DHowmyyDEHkxsIMMpPhLpPVnbetZ7o+DifFSlfGGSj5LKLlA/s2w8hxgCE7yxQMX9j
         MTUmlWgcQJcQOqwCRKuoTtHCTIc6GdVG4xPbHMrc8gFXOzhdKN3CWR05QMla0JKe2c/m
         dqe7rWOkBDx4rYGXcWJ6se2coi5DxLRlq1ES8DVn9kcw+DKLfOqgs/1FWzJQaGcv0loQ
         OlDC55sC0vxuAFOKzo0EMd5yLlHmzcPNREewYpwzxGHO5YIXun2v4lEq1hc1qHT6zWHC
         LAGeHt9WKEm+B7kzOTVrraygsqNYQ4JAp4B3Jctk+Tyq7nWNJadLhWBHKP87LeOggVYN
         E0VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707914299; x=1708519099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CtRzUtn5YlgGEqGNmE5oViuKGD26HTcJD0Q89ujSctY=;
        b=TmB2wt9/AXctpyGa4rtk2HY31jZOwov5Gks8/S8vJAkiKTBCKNrGNL1qE1zyG9IyL6
         IW/oHD1cFyApe/JHB153PJU3i+xjDAphXJzBNHPTy55k0v5nBOVk2n/zclkp8P3ThoCc
         aaK37y2f3PgFSeYttWsNg4lbyfqutyvD2vzfcldUO9a6lWxipEfeVZs6zfcjl78afDhK
         SbgpZP/HTYswdTVxS7783/VWLJUUSzfbJmtNySlpolMpMkubHncdezqCQST96TKbO/T2
         ugKCqS6yyegMFxnN5ygGNktAHwQ1ZhnjkJ7G9Yesrbp93W3oFxeVV3bNojAwt+jFVVkU
         /Rug==
X-Forwarded-Encrypted: i=1; AJvYcCVysehUWVIUif3NnWIig/D8bXGdwrNNKVA3BF6DaYZFR32B/9i4YF4lBDFbCFzzpt+HqpgsIK2DxaR1l5PPAl6PjZR9
X-Gm-Message-State: AOJu0YwFmlFaWO53isMjBjwvq4IkBeoGvUdVYSzSdeaqwNR2Bh29QHB0
	oFW9Rycpk8bLQrjKTRAHkxr/rkBplVUbkgdEoiRlPxOnnox2KhF8Q6AxG6qMNHw=
X-Google-Smtp-Source: AGHT+IGCWZ5G/G3vbyNMBfek5NVGYdPpcnCAN0KmPun1zKGXih4KLFfWufmz/OYQLaOucpICouOPBA==
X-Received: by 2002:a05:6a21:1644:b0:19e:cf31:6a04 with SMTP id no4-20020a056a21164400b0019ecf316a04mr2855300pzb.59.1707914299363;
        Wed, 14 Feb 2024 04:38:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXrXT4KToL9IgoHVlEatzhhCjqaY+aDf2dj3WXtREaMV4mVz7xD/BsynLgPAcDs1YDjmE60t4dut/SjiWkhbTvOevleB2YNKNZYIS19SAmNlE2hgyLgJhuLzf4qm1iogqAQxnKViApc+lYzuksXCv1knBeeRikj8YvcIXPoBUqJwAQzDYBhZwDXGkF5pQvyOMUj5qPsY2GGzZ81gTzJ6hteOMyADmeptjvymrVt6NED+ZuDq9a1Ks+rj8snJcamLctx8azbCwuMgKAr3SrDpJAGu1O411FkkvGCSFbB3bsz6Q6CTd8Oxqd4gaX7coarmV/Ix2htiWKpjx3EXVWnO3m+jbPNad0iid8txVbAZu/3P31wCiAi8REn65ISTwSDmI6/XM7mgZ/a3fDMXFQc8buJ4+f0iw4Z+H0YQ3JZ1IWCooM3JsOmzkeOv1Ny6A==
Received: from anup-ubuntu-vm.localdomain ([171.76.87.178])
        by smtp.gmail.com with ESMTPSA id o20-20020a170902e29400b001d9b749d281sm3041419plc.53.2024.02.14.04.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Feb 2024 04:38:18 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 3/5] KVM: riscv: selftests: Add Ztso extension to get-reg-list test
Date: Wed, 14 Feb 2024 18:07:55 +0530
Message-Id: <20240214123757.305347-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240214123757.305347-1-apatel@ventanamicro.com>
References: <20240214123757.305347-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KVM RISC-V allows Ztso extension for Guest/VM so let us
add this extension to get-reg-list test.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 9d9c50b68207..5429453561d7 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -73,6 +73,7 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZKSED:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZKSH:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZKT:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZTSO:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVBB:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVBC:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZVFH:
@@ -436,6 +437,7 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
 		KVM_ISA_EXT_ARR(ZKSED),
 		KVM_ISA_EXT_ARR(ZKSH),
 		KVM_ISA_EXT_ARR(ZKT),
+		KVM_ISA_EXT_ARR(ZTSO),
 		KVM_ISA_EXT_ARR(ZVBB),
 		KVM_ISA_EXT_ARR(ZVBC),
 		KVM_ISA_EXT_ARR(ZVFH),
@@ -957,6 +959,7 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zkr, ZKR);
 KVM_ISA_EXT_SIMPLE_CONFIG(zksed, ZKSED);
 KVM_ISA_EXT_SIMPLE_CONFIG(zksh, ZKSH);
 KVM_ISA_EXT_SIMPLE_CONFIG(zkt, ZKT);
+KVM_ISA_EXT_SIMPLE_CONFIG(ztso, ZTSO);
 KVM_ISA_EXT_SIMPLE_CONFIG(zvbb, ZVBB);
 KVM_ISA_EXT_SIMPLE_CONFIG(zvbc, ZVBC);
 KVM_ISA_EXT_SIMPLE_CONFIG(zvfh, ZVFH);
@@ -1010,6 +1013,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_zksed,
 	&config_zksh,
 	&config_zkt,
+	&config_ztso,
 	&config_zvbb,
 	&config_zvbc,
 	&config_zvfh,
-- 
2.34.1



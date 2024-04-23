Return-Path: <kvm+bounces-15654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 067158AE6A7
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 14:45:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29D4D1C220BE
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06FF21369AC;
	Tue, 23 Apr 2024 12:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="1OYAdQWQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749861350F8
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 12:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713876231; cv=none; b=k/Aa8ZntLQQjLi+XVHl9/ApkjBC8JkVFVqYFJjIBId50uaGWYaANqQFFBC3zNKN1l8vX3/nhl8IrZIefXVawDuhw91H6Z/a+Dwudm1DVr+98xlTzNutKyPMdxKKWlz8gmlKZgOX9Ik9IWCNyH3qD324uptGnL7X20J+ZlSVVUsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713876231; c=relaxed/simple;
	bh=u6ulU0BPQmNSIcLbsuogo6WHzBJ6ZqZxhPCHBhuLYhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hEK8NIzph2gj6AGjO6uutR5Vw/XHZi2uakalvawGTZEko3q7miK+2KpAcKRKjk8crH4yHDi3poXztKd5eOSNHvNeJRcrIoNbYgz24OyDky5woOayMYbw3xbSlsBCYYxoL/+eRePNQuyqBfnQdIX1+WiVlutelX8IeLM6tf+0iJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=1OYAdQWQ; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-347c6d6fc02so875589f8f.1
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 05:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713876228; x=1714481028; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HO1pUvU0QFRoXzPxVhmpQLKjzbVC9RycGYDtZgzkuNE=;
        b=1OYAdQWQcFEPlzeEprCTVc/JiZruU3aK36LrPaOl8x2ehY0ZJS/0zxYc6pqwg2lD8o
         s/n+EgYAH3OqhIz53Hp/FMGnzXUS0VCVO44Rs13rdSb1KUR0sJ2vJSkbdjwEQxUyCEgF
         UA3R7lbB/vIMOa4ivyTaqRA52gdGt9ND4166Ta7WArbJEfnVNkb1hDUb1PdjJM0kmxvg
         aitVdqNQYfDFf+fsRbw6hqaWIVOq4l2JGQN4UZd25MIXekXPYTeDMnszmQOJMwkhOrZH
         ce9VXVz+poXsqJlJ9dlbtlto6KjKjJbcANZFwbhMz9/lXeQ3VAUuo9J4xP9DOS/GqkyA
         LgnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713876228; x=1714481028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HO1pUvU0QFRoXzPxVhmpQLKjzbVC9RycGYDtZgzkuNE=;
        b=wH7GDio8+NLgYQEaCN+hmnywVlQVthFlKO7PIBfOor0jvvI3fEb9WS6Tf5yWnx0cLb
         vOCmdgUaYES0od2IGmteXV3FfrIlp/4OBNhSNKQMlMhAunY31M+dFMEb/Tf9rk5Bth9i
         7iw0z9Rj2YdkIIzfN0U3NNI6tkhl7C+mr8uiLfNcrT6fFjRVI6CuScZXNjAwWVlxy9VT
         o2EPWVnvCJZqJyByOHjwhzfyLjDCzyoKOJKU9nAPUX2c4qTj7bBzXu327sGHojmcbvco
         eecWIr/ndQ2kvmFZ0AejgNKgNmLIU7yH9l7ykfm+8nwHMkqSFzwewVPmjOe7j0VUcIRH
         1FBg==
X-Forwarded-Encrypted: i=1; AJvYcCVxWJ1s+5mu7xXdofgcjFIc91dqObo8ssnrz712OjTbl39gk2N87s4MRMpGPcFamffKPyVFKpmvLWOCHZ1IXeHJ+AFb
X-Gm-Message-State: AOJu0Yx4CP84ulMsF5EvzXolxpU6e/k4eXsq2lhjnK6GxLOkpAaSedag
	qlnUCTV2Uxv/BzqwBWsAfWyHxA/6NN9KrzJG+Faw+Iu8q7kceV4jm/mKHbra4FY=
X-Google-Smtp-Source: AGHT+IFRgUnk0vEtF+hGJCYsgJqApSFxTJfbdXsIxf1B/11WOBNdkte1X7YViXtLgl4+JyLNVfZS7w==
X-Received: by 2002:a05:600c:468f:b0:418:9941:ca28 with SMTP id p15-20020a05600c468f00b004189941ca28mr9046696wmo.2.1713876227919;
        Tue, 23 Apr 2024 05:43:47 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:71cb:1f75:7053:849c])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c470a00b00418a386c059sm19975709wmo.42.2024.04.23.05.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 05:43:47 -0700 (PDT)
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
Subject: [PATCH v3 06/11] KVM: riscv: selftests: Add some Zc* extensions to get-reg-list test
Date: Tue, 23 Apr 2024 14:43:20 +0200
Message-ID: <20240423124326.2532796-7-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240423124326.2532796-1-cleger@rivosinc.com>
References: <20240423124326.2532796-1-cleger@rivosinc.com>
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
index 40107bb61975..61cad4514197 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -55,6 +55,10 @@ bool filter_reg(__u64 reg)
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
@@ -421,6 +425,10 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
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
@@ -945,6 +953,10 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zbkb, ZBKB);
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
@@ -1001,6 +1013,10 @@ struct vcpu_reg_list *vcpu_configs[] = {
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
2.43.0



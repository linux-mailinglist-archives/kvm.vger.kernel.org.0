Return-Path: <kvm+bounces-3398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E10C803D00
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 19:29:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0DD00B20A9A
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 18:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46CE52FC4E;
	Mon,  4 Dec 2023 18:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="VZK8D13H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A721FB0
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 10:29:19 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6ce3935ffedso2102458b3a.1
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 10:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701714559; x=1702319359; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mGBD600RHtXFtkPU4SOmbidKDzxeJ3jBcLp4jGcjDdY=;
        b=VZK8D13HFVHDoEtqwWG2tsDOa1wVrIclggIjuoiWlByB3xtM0hMEe5DWm68ErjvodA
         /9u+rXkIrWcjowNu/KX/lGn+fzuZzVPPI7TKsgUTOPtBOUVnFdvjnwlBEiMqSDLRXOPD
         ldi+a6HpHgXsHdIRwktz/boMMa6fmnI2aSY2OjxStjkNVuWD/lFwa4kK7Fc/JOYxLdgE
         65Gk9ZssEj9WX4LLC5KLccfF/bvFMjE0qGvRi5reNGQJa376k3Nc/08ga0xoHL0stCO1
         ysnP/X6BK4Hzk8wm+3+ZHssZVgdFio0s1r7S1Wythth84bi+XdayZxEgNp4OV48YFZ3C
         K/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701714559; x=1702319359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mGBD600RHtXFtkPU4SOmbidKDzxeJ3jBcLp4jGcjDdY=;
        b=Swic3vl3Q31JBi7NjRg253lF/kZE+afm1TmaFOzRB8r8NPhHa8JjarYusm2Z0n7en1
         W/0JtIWoyBrbSYjLHHT7MYPJz57HE4VN+QQWPBC5Ehquigv25caAxmEtQE7BghVr1Knh
         r1Wphj3yVf3Cpz+n7yTOSIsZZxGQ2YYY1Y8h4bhvHhjAt+EPVVo4M8h2WSCL4gSOpJlF
         xI0z95E3yAqthuCPV7V15SEwn8Wo2YwXPHDim4xgkx43wAxtsPCbMpXoK3W0J0/SGICU
         YsGaV9k/vdUrRwpdBGD9mzp5Oehth6Urk9BPi1TaRx/+RndGovjKUTOIZQxVyVa9Ta8C
         GErw==
X-Gm-Message-State: AOJu0YzvmOfqPtJHgtE31jEkkS+WI8StsoT+BDGUzeNRpZgUoCqJUGFJ
	d35Hzvt0IKda4yNiTdZ7IzXBEA==
X-Google-Smtp-Source: AGHT+IESIwZmOWM6eeY2+i7bqfBNcq8SQrottFDB8R8T+zVBCK33v9JZ4EZonX0hxRihd6tmXKie+w==
X-Received: by 2002:a05:6a00:2d0d:b0:6be:314c:16cb with SMTP id fa13-20020a056a002d0d00b006be314c16cbmr4797997pfb.10.1701714559101;
        Mon, 04 Dec 2023 10:29:19 -0800 (PST)
Received: from grind.. (200-206-229-234.dsl.telesp.net.br. [200.206.229.234])
        by smtp.gmail.com with ESMTPSA id it19-20020a056a00459300b006cdce7c69d9sm1806224pfb.91.2023.12.04.10.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 10:29:18 -0800 (PST)
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To: kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	palmer@dabbelt.com,
	ajones@ventanamicro.com,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH 3/3] RISC-V: KVM: add vector CSRs in KVM_GET_REG_LIST
Date: Mon,  4 Dec 2023 15:29:04 -0300
Message-ID: <20231204182905.2163676-4-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231204182905.2163676-1-dbarboza@ventanamicro.com>
References: <20231204182905.2163676-1-dbarboza@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add all vector CSRs (vstart, vl, vtype, vcsr, vlenb) in get-reg-list.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 37 ++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index f8c9fa0c03c5..1c91615f47cc 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -986,6 +986,37 @@ static int copy_sbi_ext_reg_indices(u64 __user *uindices)
 	return num_sbi_ext_regs();
 }
 
+static inline unsigned long num_vector_regs(const struct kvm_vcpu *vcpu)
+{
+	const struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+
+	if (!riscv_isa_extension_available(vcpu->arch.isa, v))
+		return 0;
+
+	/* vstart, vl, vtype, vcsr, vlenb; */
+	return 5;
+}
+
+static int copy_vector_reg_indices(const struct kvm_vcpu *vcpu,
+				u64 __user *uindices)
+{
+	int n = num_vector_regs(vcpu);
+	u64 reg, size;
+
+	for (int i = 0; i < n; i++) {
+		size = IS_ENABLED(CONFIG_32BIT) ? KVM_REG_SIZE_U32 : KVM_REG_SIZE_U64;
+		reg = KVM_REG_RISCV | size | KVM_REG_RISCV_VECTOR | i;
+
+		if (uindices) {
+			if (put_user(reg, uindices))
+				return -EFAULT;
+			uindices++;
+		}
+	}
+
+	return n;
+}
+
 /*
  * kvm_riscv_vcpu_num_regs - how many registers do we present via KVM_GET/SET_ONE_REG
  *
@@ -1001,6 +1032,7 @@ unsigned long kvm_riscv_vcpu_num_regs(struct kvm_vcpu *vcpu)
 	res += num_timer_regs();
 	res += num_fp_f_regs(vcpu);
 	res += num_fp_d_regs(vcpu);
+	res += num_vector_regs(vcpu);
 	res += num_isa_ext_regs(vcpu);
 	res += num_sbi_ext_regs();
 
@@ -1045,6 +1077,11 @@ int kvm_riscv_vcpu_copy_reg_indices(struct kvm_vcpu *vcpu,
 		return ret;
 	uindices += ret;
 
+	ret = copy_vector_reg_indices(vcpu, uindices);
+	if (ret < 0)
+		return ret;
+	uindices += ret;
+
 	ret = copy_isa_ext_reg_indices(vcpu, uindices);
 	if (ret < 0)
 		return ret;
-- 
2.41.0



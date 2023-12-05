Return-Path: <kvm+bounces-3617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B0C0805B47
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:45:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43EC71F216DB
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36C6668B85;
	Tue,  5 Dec 2023 17:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="A+qQp/ju"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F45122
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 09:45:30 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1d0c94397c0so6193075ad.2
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 09:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701798330; x=1702403130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xDmx5prnNC5GcsIkGu5R3qOSAEa8hCYanFPPTHn90qw=;
        b=A+qQp/jusDzJjFMMnN5+QTKEgABCTB+AYukhP4UK0fBkRFnqwg/XWQ4WZgHH7r7N10
         ifLnmqc5kB3/JcrvxOfbsZs4V8ASZpyrPJDeSbv1N+dmGd48OUlKTsYNZL+IeiUaumUF
         M+v4a+AB8nqkA9xdhJ6alBzmGI0Pw6FojG8FzvEehY9OnwHb417IRm9C7+nt1TKx89CG
         O/C0ITvitesZOKoJXjqnHc04Aye6Mcd/8Q43JgvaLJ3NZZeAN0BEmXuyM3CUD92rgGst
         wV0uPP7CfGpvnzLj0h+M/xfWb/dXruoeoesxRbYIsAe4/I3BYnamsosrLknaEDdX4P1q
         5TNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701798330; x=1702403130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xDmx5prnNC5GcsIkGu5R3qOSAEa8hCYanFPPTHn90qw=;
        b=Ie4NjY4K7dHC1f8iojpzSunIgxJwAwPf2+JnbHliJjNByFFN82x7GSD6wypaLPsesG
         bvOyB0WXGtvEqE2OhH2MSwii/u/GoFRAJ4RuAq5F2Fw9u0MGS74NvdSuT8RNDdHjXrkk
         VElSIZsS99f7Q1Mfy8YFi5XXsvCc4IHGNWznlGFrBFlkdeSH4wxaYpsRPqV22CY1aBRk
         a9E9wiwb4zq3wjQ5P88/OcGS9mDOXp1d6hqZlNiUNVAZiQwEDgw8FuBU8sBi7slv/syy
         1hUw/o0bx68o/aZevts0Q4oSmc5j4SHbo+aGmsegi7/v25gkqauIYa3bfGIpejwsMAFo
         sVvQ==
X-Gm-Message-State: AOJu0Yxf1OUqg6VPXtdBp9hQt+YBQKdkE/LZO6ciaXHMKKwbLfrHA8D+
	H62n8PkZPKj/aSWurUYXYe1xOg==
X-Google-Smtp-Source: AGHT+IF1UZLtbstXiLGAqb3dZPBrPK0Kg5I3E3SNIV6kA8JjlJ2QhfhiGUU2Udk2N9DtQEvBJyDFVw==
X-Received: by 2002:a17:902:748c:b0:1d0:b033:4a98 with SMTP id h12-20020a170902748c00b001d0b0334a98mr2747236pll.17.1701798329723;
        Tue, 05 Dec 2023 09:45:29 -0800 (PST)
Received: from grind.. ([152.234.124.8])
        by smtp.gmail.com with ESMTPSA id j20-20020a170902759400b001c74df14e6fsm10465705pll.284.2023.12.05.09.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 09:45:29 -0800 (PST)
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To: kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	palmer@dabbelt.com,
	ajones@ventanamicro.com,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v3 2/3] RISC-V: KVM: add 'vlenb' Vector CSR
Date: Tue,  5 Dec 2023 14:45:08 -0300
Message-ID: <20231205174509.2238870-3-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231205174509.2238870-1-dbarboza@ventanamicro.com>
References: <20231205174509.2238870-1-dbarboza@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Userspace requires 'vlenb' to be able to encode it in reg ID. Otherwise
it is not possible to retrieve any vector reg since we're returning
EINVAL if reg_size isn't vlenb (see kvm_riscv_vcpu_vreg_addr()).

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_vector.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
index 530e49c588d6..d92d1348045c 100644
--- a/arch/riscv/kvm/vcpu_vector.c
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -116,6 +116,9 @@ static int kvm_riscv_vcpu_vreg_addr(struct kvm_vcpu *vcpu,
 		case KVM_REG_RISCV_VECTOR_CSR_REG(vcsr):
 			*reg_addr = &cntx->vector.vcsr;
 			break;
+		case KVM_REG_RISCV_VECTOR_CSR_REG(vlenb):
+			*reg_addr = &cntx->vector.vlenb;
+			break;
 		case KVM_REG_RISCV_VECTOR_CSR_REG(datap):
 		default:
 			return -ENOENT;
@@ -174,6 +177,18 @@ int kvm_riscv_vcpu_set_reg_vector(struct kvm_vcpu *vcpu,
 	if (!riscv_isa_extension_available(isa, v))
 		return -ENOENT;
 
+	if (reg_num == KVM_REG_RISCV_VECTOR_CSR_REG(vlenb)) {
+		struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+		unsigned long reg_val;
+
+		if (copy_from_user(&reg_val, uaddr, reg_size))
+			return -EFAULT;
+		if (reg_val != cntx->vector.vlenb)
+			return -EINVAL;
+
+		return 0;
+	}
+
 	rc = kvm_riscv_vcpu_vreg_addr(vcpu, reg_num, reg_size, &reg_addr);
 	if (rc)
 		return rc;
-- 
2.41.0



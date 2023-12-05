Return-Path: <kvm+bounces-3618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A7AD2805B48
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:45:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51D221F218A0
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B335A68B88;
	Tue,  5 Dec 2023 17:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="aqS9wvDu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E22122
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 09:45:33 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1d08a924fcfso25350485ad.2
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 09:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701798333; x=1702403133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xh660VR+cynL5ByMmnyvYALQkVg9X3nzQmC84j+D7MQ=;
        b=aqS9wvDuiFhyqcSWngWp8Zz45DTTvxkgi7l845MuMa7XY9irFXPAtB8am8FcPy5+lU
         p248AMjjgkLIHttlBTpExWal5g6/LFfgVvFt95Aio+mhMhM4jb4W0g01A61rfrIB9Hlj
         RsSVbk8OX3SwemXG51KCxQ7wNhksTBYtNwM5bKW6zJrWGlz88oQCF2Vl0B/Vzz1wYiuI
         AD1sx6WpNBzinW1LwZoQtDJZZ4NLCYYa3fJrYrNl/0QiW/uzna9Jnf3aq8NgSs3Zyee9
         7eW8tQDO97zEXVAXxM3cHmBSmYNaH41dyrLO3yEp9HL3R5xyNLBText4Y9vQUttZGCrl
         YQrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701798333; x=1702403133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xh660VR+cynL5ByMmnyvYALQkVg9X3nzQmC84j+D7MQ=;
        b=dec2at6TY81SScLQWwzVPwZscMzCd7LDN5Nth6kPDbLLD9TzYF1FWL6DV6z7DAj7aL
         5u+FUD6NkljLVmqusM0mX3WsloOBjxgSNt7n5z5suTDK7Q6c9237be4e9xnX0gkHrpG1
         K/fubocjHqeV9BRHzG+GzVeo5d90fK171bD1zu3JUJ0JpTI4h8xdKDol1zb2q+OYRO7n
         B5iDcmbmKn56d97Y8LJflAHGxbIRBpZT8NjIWOUgryeBySSB2d1x6BmBKhr/rGAg785k
         NCw3kFBTgKXrWBQ/YQnIEBPordK+Mtntb4rKIUyQuJlm6ToiGj6i1elLNJGqwzF/1+K4
         8bXA==
X-Gm-Message-State: AOJu0YwzfCpA+Mf+fzTWT72fBxIz0tL1If8o3XPpDFciqtAFGsoHOodJ
	cGkatoErzwQ95fra16zMfPDarA==
X-Google-Smtp-Source: AGHT+IHmxq3UYJ5ZQx5exhCrZrdLX5Q8e34CNi9nSp70tBpb4whX5/If4GYuXq2EXsnqnTsBq5YwzQ==
X-Received: by 2002:a17:903:1c7:b0:1d0:9c53:9cca with SMTP id e7-20020a17090301c700b001d09c539ccamr4076817plh.96.1701798333325;
        Tue, 05 Dec 2023 09:45:33 -0800 (PST)
Received: from grind.. ([152.234.124.8])
        by smtp.gmail.com with ESMTPSA id j20-20020a170902759400b001c74df14e6fsm10465705pll.284.2023.12.05.09.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 09:45:32 -0800 (PST)
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To: kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	palmer@dabbelt.com,
	ajones@ventanamicro.com,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v3 3/3] RISC-V: KVM: add vector CSRs in KVM_GET_REG_LIST
Date: Tue,  5 Dec 2023 14:45:09 -0300
Message-ID: <20231205174509.2238870-4-dbarboza@ventanamicro.com>
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

Add all vector CSRs (vstart, vl, vtype, vcsr, vlenb) in get-reg-list.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 55 ++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index f8c9fa0c03c5..2eb4980295ae 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -986,6 +986,55 @@ static int copy_sbi_ext_reg_indices(u64 __user *uindices)
 	return num_sbi_ext_regs();
 }
 
+static inline unsigned long num_vector_regs(const struct kvm_vcpu *vcpu)
+{
+	if (!riscv_isa_extension_available(vcpu->arch.isa, v))
+		return 0;
+
+	/* vstart, vl, vtype, vcsr, vlenb and 32 vector regs */
+	return 37;
+}
+
+static int copy_vector_reg_indices(const struct kvm_vcpu *vcpu,
+				u64 __user *uindices)
+{
+	const struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	int n = num_vector_regs(vcpu);
+	u64 reg, size;
+	int i;
+
+	if (n == 0)
+		return 0;
+
+	/* copy vstart, vl, vtype, vcsr and vlenb */
+	size = IS_ENABLED(CONFIG_32BIT) ? KVM_REG_SIZE_U32 : KVM_REG_SIZE_U64;
+	for (i = 0; i < 5; i++) {
+		reg = KVM_REG_RISCV | size | KVM_REG_RISCV_VECTOR | i;
+
+		if (uindices) {
+			if (put_user(reg, uindices))
+				return -EFAULT;
+			uindices++;
+		}
+	}
+
+	/* vector_regs have a variable 'vlenb' size */
+	size = __builtin_ctzl(cntx->vector.vlenb);
+	size <<= KVM_REG_SIZE_SHIFT;
+	for (i = 0; i < 32; i++) {
+		reg = KVM_REG_RISCV | KVM_REG_RISCV_VECTOR | size |
+			KVM_REG_RISCV_VECTOR_REG(i);
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
@@ -1001,6 +1050,7 @@ unsigned long kvm_riscv_vcpu_num_regs(struct kvm_vcpu *vcpu)
 	res += num_timer_regs();
 	res += num_fp_f_regs(vcpu);
 	res += num_fp_d_regs(vcpu);
+	res += num_vector_regs(vcpu);
 	res += num_isa_ext_regs(vcpu);
 	res += num_sbi_ext_regs();
 
@@ -1045,6 +1095,11 @@ int kvm_riscv_vcpu_copy_reg_indices(struct kvm_vcpu *vcpu,
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



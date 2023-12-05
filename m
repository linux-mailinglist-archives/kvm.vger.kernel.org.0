Return-Path: <kvm+bounces-3575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2C12805683
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 14:51:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E34591C20FEF
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 13:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D7595E0D2;
	Tue,  5 Dec 2023 13:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="OZnWz0e5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647A5D40
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 05:51:23 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6ce72730548so439440b3a.1
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 05:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701784283; x=1702389083; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gWIP8Cx7D+GV9Mq+7uijTcrk0Pfg2qHA9s0FvsGVo74=;
        b=OZnWz0e5qGsiTQYZse/pxHJ0Oxfwe3lDSL7Cych4sandyDGB/UUU6KDAJMWBgA1eqK
         eW6IrzxxNMxV77jTST45fofO3Q0HVonUoZvEchFKaKzhlTgF6Ik1Oo2s3uBC0yJWIBfL
         EAD6ByLMIQ14Hb8y8BoNS39iwlJRtS4DPfDC7LFZeSdal4mkQGPpEZdVu12+jJkc19RV
         x3WEX9ZT4kosOkR3sw07jPO9UGV+c1beDJ/Zk/yQPYryPIB8qNOcGdKqEQGS4ZRG00v5
         pcosLy5M30+gDfqT2Xpd23fg5FBg41b8hLU2ePBoIFVgefVyC62vG4/2b3po0RtvDBtA
         l0cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701784283; x=1702389083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gWIP8Cx7D+GV9Mq+7uijTcrk0Pfg2qHA9s0FvsGVo74=;
        b=Y/qXieUuOt3UseeJBHvIu3h8ccqSect3xhLEEwaZVduQWPKX7oj5TcTpKk/IJSbhLf
         jzEnpiRG7/uD6RrGS4k1VpUZiiT3Hw6sJggh+nCHf0FH405Jt2q/cT9/loe6Nz18AFN1
         cKgKr84Q9nMBDXEZSj1REHixMDEvbgYp8ApzYj6T+sBbPuDK+leUu+LUaXuDjjxLC8Sl
         FW1JyCJun3k7RZ+RtN3COqcjpJ89lccmwOCd7WGp+n1zYH6UkJKC28GEH3INYlRRYNc+
         EQiPjxv6TtbxRisg8wi4bpZpLTARKGNnYG2LJaPQjULrxwzqJ0QFjiYVWsPpmNn4ZT1p
         RkoQ==
X-Gm-Message-State: AOJu0YyiJVL+76k5qQez7NWdlhFMEHqNrISpqaxmEIfj0oTgvQvJAtCK
	3GIJNIFyYaT0YZFA7fzA4DBoXQ==
X-Google-Smtp-Source: AGHT+IFl6VUO3lxE+m7fVq4lH0JgDU9K0sD3DxngsxIxRWrEodduyQcrtEHmBXOHOq/B4vNQoN+evg==
X-Received: by 2002:a05:6a20:a113:b0:18f:b899:21dd with SMTP id q19-20020a056a20a11300b0018fb89921ddmr96150pzk.47.1701784257468;
        Tue, 05 Dec 2023 05:50:57 -0800 (PST)
Received: from grind.. (200-206-229-234.dsl.telesp.net.br. [200.206.229.234])
        by smtp.gmail.com with ESMTPSA id c22-20020aa78c16000000b006ce77ffcc75sm673641pfd.165.2023.12.05.05.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 05:50:57 -0800 (PST)
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To: kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	palmer@dabbelt.com,
	ajones@ventanamicro.com,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v2 3/3] RISC-V: KVM: add vector CSRs in KVM_GET_REG_LIST
Date: Tue,  5 Dec 2023 10:50:41 -0300
Message-ID: <20231205135041.2208004-4-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231205135041.2208004-1-dbarboza@ventanamicro.com>
References: <20231205135041.2208004-1-dbarboza@ventanamicro.com>
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
 arch/riscv/kvm/vcpu_onereg.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index f8c9fa0c03c5..712785a8f22b 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -986,6 +986,35 @@ static int copy_sbi_ext_reg_indices(u64 __user *uindices)
 	return num_sbi_ext_regs();
 }
 
+static inline unsigned long num_vector_regs(const struct kvm_vcpu *vcpu)
+{
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
@@ -1001,6 +1030,7 @@ unsigned long kvm_riscv_vcpu_num_regs(struct kvm_vcpu *vcpu)
 	res += num_timer_regs();
 	res += num_fp_f_regs(vcpu);
 	res += num_fp_d_regs(vcpu);
+	res += num_vector_regs(vcpu);
 	res += num_isa_ext_regs(vcpu);
 	res += num_sbi_ext_regs();
 
@@ -1045,6 +1075,11 @@ int kvm_riscv_vcpu_copy_reg_indices(struct kvm_vcpu *vcpu,
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



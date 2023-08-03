Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8562376EBAC
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 16:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbjHCOCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 10:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbjHCOCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 10:02:03 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F70944BD
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 07:01:01 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 46e09a7af769-6bc9254a1baso901301a34.2
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 07:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691071256; x=1691676056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EkwDk8dXju8I9w7KpYFAws21Qd1+OBzn/0afxgdVQLI=;
        b=XW9PuJZm7znGzIG6HfPZZ/EGSS3Y+yBOiKzv2jqmphbRIf/VN2MPDFnaWNAm+VOGQP
         34QUrUiKUm4OkSD1al24yYdOf6sjR3/rCgLKIETf0kA2njYbv/lZDER/JT8cSlv6+na2
         aeTQfyDIjwwuX6RVsOiwhNVWY/uXkOLSHKP/UcIpeGGm5fohk16zPrWhL9FJiF16gKdc
         arFNZ5mDy52or5a3sBPZk8uMlAONYl/76yjBviZeEeRH8NVWytAEia2yJkI7REmXODFv
         QoUR1W9PhYUPdMM0u6yp3qAgn7LIAZuHkPSdefAC+ihmm+tyt2eb34SnZEUSmwgl60eT
         gvfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691071256; x=1691676056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EkwDk8dXju8I9w7KpYFAws21Qd1+OBzn/0afxgdVQLI=;
        b=JfiKWpDmoW6OsPgM1sWoFRoW5j2KuseFL+bJbXuX2hM2bo70Nuc7t4PB0C9e4Gq+98
         XDgPpvwUv9VvJvQMQ9R02nBPtFXFKvUy2jObR8rDzMmcvIZyQaMv5e+ibjhZm5A00YUf
         8AkA98N0PBBD+OvtXU0buP+dA6agEdJl+N0FVInuGMWFczsVTwEpdWcfZg4irbljAI/j
         uKPJaGRcZMhAowF1f5JYofaO6KWuChOSKM7jamI0p/vuKVnOJ8nAvVoAWhqC3nif9fBt
         2YH245Y3cWwo81UxCu9QMBQ+tkhoEPGgC5P3HF8aTbp2QV887YyI+WGDHS5w8dVdn1m1
         1cJw==
X-Gm-Message-State: ABy/qLZcG8WJbZFpKhTC19qiSeU6pirJlVBqzT5f6THMqdU/nMAOvBr4
        htAXRSZq5BibWSyIHIrG13EgCA==
X-Google-Smtp-Source: APBJJlGZdJ8RVR9JidGuJDXr3yfjorlKS5cjnZTx47GbtEuo0utyyEwhjsgOyM7aj9j2Hz8lFiOMMA==
X-Received: by 2002:a9d:4e89:0:b0:6bc:8cd2:dd9c with SMTP id v9-20020a9d4e89000000b006bc8cd2dd9cmr17883841otk.36.1691071256311;
        Thu, 03 Aug 2023 07:00:56 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id e14-20020a0568301e4e00b006b29a73efb5sm11628otj.7.2023.08.03.07.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 07:00:55 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org, ajones@ventanamicro.com
Subject: [PATCH v3 09/10] RISC-V: KVM: Improve vector save/restore errors
Date:   Thu,  3 Aug 2023 11:00:21 -0300
Message-ID: <20230803140022.399333-10-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803140022.399333-1-dbarboza@ventanamicro.com>
References: <20230803140022.399333-1-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Jones <ajones@ventanamicro.com>

kvm_riscv_vcpu_(get/set)_reg_vector() now returns ENOENT if V is not
available, EINVAL if reg type is not of VECTOR type, and any error that
might be thrown by kvm_riscv_vcpu_vreg_addr().

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_vector.c | 60 ++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
index edd2eecbddc2..39c5bceb4d1b 100644
--- a/arch/riscv/kvm/vcpu_vector.c
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -91,44 +91,44 @@ void kvm_riscv_vcpu_free_vector_context(struct kvm_vcpu *vcpu)
 }
 #endif
 
-static void *kvm_riscv_vcpu_vreg_addr(struct kvm_vcpu *vcpu,
+static int kvm_riscv_vcpu_vreg_addr(struct kvm_vcpu *vcpu,
 				      unsigned long reg_num,
-				      size_t reg_size)
+				      size_t reg_size,
+				      void **reg_val)
 {
 	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
-	void *reg_val;
 	size_t vlenb = riscv_v_vsize / 32;
 
 	if (reg_num < KVM_REG_RISCV_VECTOR_REG(0)) {
 		if (reg_size != sizeof(unsigned long))
-			return NULL;
+			return -EINVAL;
 		switch (reg_num) {
 		case KVM_REG_RISCV_VECTOR_CSR_REG(vstart):
-			reg_val = &cntx->vector.vstart;
+			*reg_val = &cntx->vector.vstart;
 			break;
 		case KVM_REG_RISCV_VECTOR_CSR_REG(vl):
-			reg_val = &cntx->vector.vl;
+			*reg_val = &cntx->vector.vl;
 			break;
 		case KVM_REG_RISCV_VECTOR_CSR_REG(vtype):
-			reg_val = &cntx->vector.vtype;
+			*reg_val = &cntx->vector.vtype;
 			break;
 		case KVM_REG_RISCV_VECTOR_CSR_REG(vcsr):
-			reg_val = &cntx->vector.vcsr;
+			*reg_val = &cntx->vector.vcsr;
 			break;
 		case KVM_REG_RISCV_VECTOR_CSR_REG(datap):
 		default:
-			return NULL;
+			return -ENOENT;
 		}
 	} else if (reg_num <= KVM_REG_RISCV_VECTOR_REG(31)) {
 		if (reg_size != vlenb)
-			return NULL;
-		reg_val = cntx->vector.datap
+			return -EINVAL;
+		*reg_val = cntx->vector.datap
 			  + (reg_num - KVM_REG_RISCV_VECTOR_REG(0)) * vlenb;
 	} else {
-		return NULL;
+		return -ENOENT;
 	}
 
-	return reg_val;
+	return 0;
 }
 
 int kvm_riscv_vcpu_get_reg_vector(struct kvm_vcpu *vcpu,
@@ -141,17 +141,20 @@ int kvm_riscv_vcpu_get_reg_vector(struct kvm_vcpu *vcpu,
 	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
 					    KVM_REG_SIZE_MASK |
 					    rtype);
-	void *reg_val = NULL;
 	size_t reg_size = KVM_REG_SIZE(reg->id);
+	void *reg_val;
+	int rc;
 
-	if (rtype == KVM_REG_RISCV_VECTOR &&
-	    riscv_isa_extension_available(isa, v)) {
-		reg_val = kvm_riscv_vcpu_vreg_addr(vcpu, reg_num, reg_size);
-	}
-
-	if (!reg_val)
+	if (rtype != KVM_REG_RISCV_VECTOR)
 		return -EINVAL;
 
+	if (!riscv_isa_extension_available(isa, v))
+		return -ENOENT;
+
+	rc = kvm_riscv_vcpu_vreg_addr(vcpu, reg_num, reg_size, &reg_val);
+	if (rc)
+		return rc;
+
 	if (copy_to_user(uaddr, reg_val, reg_size))
 		return -EFAULT;
 
@@ -168,17 +171,20 @@ int kvm_riscv_vcpu_set_reg_vector(struct kvm_vcpu *vcpu,
 	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
 					    KVM_REG_SIZE_MASK |
 					    rtype);
-	void *reg_val = NULL;
 	size_t reg_size = KVM_REG_SIZE(reg->id);
+	void *reg_val;
+	int rc;
 
-	if (rtype == KVM_REG_RISCV_VECTOR &&
-	    riscv_isa_extension_available(isa, v)) {
-		reg_val = kvm_riscv_vcpu_vreg_addr(vcpu, reg_num, reg_size);
-	}
-
-	if (!reg_val)
+	if (rtype != KVM_REG_RISCV_VECTOR)
 		return -EINVAL;
 
+	if (!riscv_isa_extension_available(isa, v))
+		return -ENOENT;
+
+	rc = kvm_riscv_vcpu_vreg_addr(vcpu, reg_num, reg_size, &reg_val);
+	if (rc)
+		return rc;
+
 	if (copy_from_user(reg_val, uaddr, reg_size))
 		return -EFAULT;
 
-- 
2.41.0


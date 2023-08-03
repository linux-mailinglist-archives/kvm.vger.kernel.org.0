Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD27F76EF91
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 18:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbjHCQdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 12:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbjHCQdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 12:33:40 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F1E4205
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 09:33:33 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id 006d021491bc7-56c8757d45bso735962eaf.2
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 09:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691080412; x=1691685212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EkwDk8dXju8I9w7KpYFAws21Qd1+OBzn/0afxgdVQLI=;
        b=N6eD3D+2ZGDTGKs0uoKUQflxUg0CRszU0wYcEX1ODl11fo+EjpZB5bT8npzJM5ItSe
         9OKx0XMOTuDUsslrgxtturtBHw7YNozWeasDIk+elGxIOUREq4cDP0XBzmmlL5qkMagz
         niXg4nabm1nFAYLle3gbBiYpYT0CLVnpxBCdVwDAr3xvO+nlp6ptob8r90iCHhj9yFro
         RqLfhQ3aC5xruAhvY5WjGP1ejgj93gqrtelZcVdCGOBvrNJ6W2G5BjRt53sfnu/biBJC
         UOrdkP+U29Ha2CplC/nEgI07aZRZUB+umL+Tzw9iDcAyE04EC1VPn8aZ4KvMRqqkT39v
         L7PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691080412; x=1691685212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EkwDk8dXju8I9w7KpYFAws21Qd1+OBzn/0afxgdVQLI=;
        b=cRKk6abwtBrNTu8M0K6QrJGjtzvtd7wah//5r32PHUoO5wHx0WJsTjy/D7deCONyk6
         Nmh7GEnEh572Gvz8KnKbtdiPDL9fOoUOP4DDukwyQqxeeozLhjvIhknCFUwZvnTFdCML
         ACMfwK2d6HfYX1KMSYMKnBMpVUfCm9XX9v4/p7vNH/7lUJjT+OLy/KUXrCzJ1ySA/gY0
         p23qhsciGYgSZii54DkAVpQz6cV+o43geLHLnRVe5okXPGC5E4XiB623/T14TF1iS4gO
         lbFYBWEQIelpZAekEp4MBoj+6VgNQqRAlU3LDbV9H0lNQKDD/dM/tgLS4fwII5O+Au+5
         EfFw==
X-Gm-Message-State: ABy/qLZ4JoFU2Pal3fLuFMLjhZIkczzrZa08k5ly8J18r44U710Gyxsf
        j5tthRIjd/rzPXaU86IplsPBrA==
X-Google-Smtp-Source: APBJJlEq0uC7OWZ+6nYyMbSifB7fjfEM6gJvhiWUQN3f23VfZ00dVOJUMOBYDODSu4FG2ATfbt524w==
X-Received: by 2002:a05:6808:f11:b0:3a1:dd99:8158 with SMTP id m17-20020a0568080f1100b003a1dd998158mr23751679oiw.6.1691080412183;
        Thu, 03 Aug 2023 09:33:32 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id y5-20020a056870428500b001bb71264dccsm152929oah.8.2023.08.03.09.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 09:33:31 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org, ajones@ventanamicro.com
Subject: [PATCH v4 09/10] RISC-V: KVM: Improve vector save/restore errors
Date:   Thu,  3 Aug 2023 13:33:01 -0300
Message-ID: <20230803163302.445167-10-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803163302.445167-1-dbarboza@ventanamicro.com>
References: <20230803163302.445167-1-dbarboza@ventanamicro.com>
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


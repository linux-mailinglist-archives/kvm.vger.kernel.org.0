Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42EE0767754
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 23:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbjG1VBf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 17:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbjG1VBc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 17:01:32 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C3B4489
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 14:01:31 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 46e09a7af769-6b9b52724ccso2186379a34.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 14:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690578090; x=1691182890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aFtwvHzLUf5NSAoO+eWuJDzHkMB9r0GqcjuVDz6J8fc=;
        b=pAaNQW24ZWjKwIrSX3bM+7any3SzG9Dcg/xEkCSEiBAO5Ntnzn3EE6uuAmnjYdYk2Q
         JfXb2u/mScYaWtJ7UbstMvTt90gKUK00vEIE/7fEwWVS519+pNY7gykuXFiuo2u7mgDZ
         gq1aJA9eVriNzZkkpARBuIMhujzWmaGhhlKLKBt6G1j5nn+7maMTkKREjauCd3WOvy5M
         mAGOySSIB7YmRlxoBEGH8gqkIYhzzrgRw6aEFswVc2xoEaQnpegUBaLbXK2WnMHwerfK
         WEn7hz/+LSdn6NJz+e/93Xs+yrtRm7Zl6LTyphS0QAkh7chyXjjTRNg7h6WaVbihrOcp
         aGFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690578090; x=1691182890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aFtwvHzLUf5NSAoO+eWuJDzHkMB9r0GqcjuVDz6J8fc=;
        b=TyrF1r6UNnBy8K71/iGccqrZjtpFNXcF5gPlMCoWI5AkqiFqLOFKGh/4jEOfmH7LfY
         TTd2dbIOCAIMZ84XHmKgpPTmEXqBLRkVjgO+s7J3/lbFSWLZP8yRvUg42OML90h9izzo
         xEMIRANtqJQA2rgUsCC0Z3xGU+yZqjNhSBWfqmwX0W0kAomL+bbsDKFs07cfeojSJ72M
         MBiesXcEipYay3R6a0K179vLlGHmBTNG9ijvXCOm10KtwcvZBTCAo4kQKQidim1wwy92
         Uas8aonuD4AGMOzi2hjs3sEdOdtIjNwygwu4DXbdJw0tFZNXejWJBUd2DfOqD13dFTCF
         ITLg==
X-Gm-Message-State: ABy/qLbxpAdAhJQDkmP5dLSO6EjeHsl/qRTjwQ7KcIoZ09WC3VrrndIp
        xL++Zl7Trw5LnyNOB0YwsHRZhQ==
X-Google-Smtp-Source: APBJJlGFxN5w1wqhoG4W9fTYv9xNGtBCO8MiWkbh5KrryNE8D3Qf7sgMmcNODSyqTqQRMmSPsaELMw==
X-Received: by 2002:a05:6830:1e71:b0:6bb:1c21:c52e with SMTP id m17-20020a0568301e7100b006bb1c21c52emr3676325otr.15.1690578090156;
        Fri, 28 Jul 2023 14:01:30 -0700 (PDT)
Received: from grind.. (201-69-66-36.dial-up.telesp.net.br. [201.69.66.36])
        by smtp.gmail.com with ESMTPSA id n11-20020a9d740b000000b006b9c87b7035sm1987769otk.18.2023.07.28.14.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 14:01:29 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v2 1/1] RISC-V: KVM: provide UAPI for host SATP mode
Date:   Fri, 28 Jul 2023 18:01:22 -0300
Message-ID: <20230728210122.175229-2-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230728210122.175229-1-dbarboza@ventanamicro.com>
References: <20230728210122.175229-1-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM userspaces need to be aware of the host SATP to allow them to
advertise it back to the guest OS.

Since this information is used to build the guest FDT we can't wait for
the SATP reg to be readable. We just need to read the SATP mode, thus
we can use the existing 'satp_mode' global that represents the SATP reg
with MODE set and both ASID and PPN cleared. E.g. for a 32 bit host
running with sv32 satp_mode is 0x80000000, for a 64 bit host running
sv57 satp_mode is 0xa000000000000000, and so on.

Add a new userspace virtual config register 'satp_mode' to allow
userspace to read the current SATP mode the host is using with
GET_ONE_REG API before spinning the vcpu.

'satp_mode' can't be changed via KVM, so SET_ONE_REG is allowed as long
as userspace writes the existing 'satp_mode'.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/csr.h      | 2 ++
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu_onereg.c      | 7 +++++++
 3 files changed, 10 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 7bac43a3176e..777cb8299551 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -54,6 +54,7 @@
 #ifndef CONFIG_64BIT
 #define SATP_PPN	_AC(0x003FFFFF, UL)
 #define SATP_MODE_32	_AC(0x80000000, UL)
+#define SATP_MODE_SHIFT	31
 #define SATP_ASID_BITS	9
 #define SATP_ASID_SHIFT	22
 #define SATP_ASID_MASK	_AC(0x1FF, UL)
@@ -62,6 +63,7 @@
 #define SATP_MODE_39	_AC(0x8000000000000000, UL)
 #define SATP_MODE_48	_AC(0x9000000000000000, UL)
 #define SATP_MODE_57	_AC(0xa000000000000000, UL)
+#define SATP_MODE_SHIFT	60
 #define SATP_ASID_BITS	16
 #define SATP_ASID_SHIFT	44
 #define SATP_ASID_MASK	_AC(0xFFFF, UL)
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 9c35e1427f73..992c5e407104 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -55,6 +55,7 @@ struct kvm_riscv_config {
 	unsigned long marchid;
 	unsigned long mimpid;
 	unsigned long zicboz_block_size;
+	unsigned long satp_mode;
 };
 
 /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 0dc2c2cecb45..85773e858120 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -152,6 +152,9 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
 	case KVM_REG_RISCV_CONFIG_REG(mimpid):
 		reg_val = vcpu->arch.mimpid;
 		break;
+	case KVM_REG_RISCV_CONFIG_REG(satp_mode):
+		reg_val = satp_mode >> SATP_MODE_SHIFT;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -234,6 +237,10 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 		else
 			return -EBUSY;
 		break;
+	case KVM_REG_RISCV_CONFIG_REG(satp_mode):
+		if (reg_val != (satp_mode >> SATP_MODE_SHIFT))
+			return -EINVAL;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.41.0


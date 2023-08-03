Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB9B76EF87
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 18:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbjHCQdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 12:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237433AbjHCQdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 12:33:16 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2ED30E2
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 09:33:12 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1bf0a1134d6so788977fac.3
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 09:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691080391; x=1691685191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=US2zdq/tIHnGcM98HjdKSGw1xllfeBdBbDmstB2Y/1A=;
        b=G5V20V98yafmTTzAS6fKNdzV0zv0/1C3M27Yy2afXWAaBGkNnsT43mabIZLzqBQZRX
         uz+0tJiXDh/kMmDcmkGSZb18ZZ+zP7behdb1tDmurJBEUgv3K06zCUnqv9+UQl92VM4A
         CuSjiRhLjalQmOq7xtNiMFLtslA4JGGUQ76gLxdBBWX0X1xDNJ4/kZM9PV+0PZTQuUKg
         AByc1k6fg0Zuu/XEzOGY1LPMBxnmfkqQsqS66HrY2Z/1kFzRQKkhc8CliWg3+QUyeazV
         hpIHGceMmSGwMLwkvD/j+WcE9r+Bl43u22SzAzU5Wh9ffJPHSysFJmMH3HhEku6m1M4Y
         haXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691080391; x=1691685191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=US2zdq/tIHnGcM98HjdKSGw1xllfeBdBbDmstB2Y/1A=;
        b=FKwxloshInGeyo2yYJmOi2ClUJxpLpgPFJhSmcMPdbX+BimEpotyeERoTQgAenMEl2
         cOh2KxLqOaA04cbb8a393vPuMslkB/nC2kVseQuwivAt4kaUw4u/hIsqH7wueXhNrPgC
         /yt2iSYUgEP5KIFhGD6lNMjOeOpoN6lnyw5/SkuP8Ubp8/mFoRj08DqfimnuoKIYl8y0
         HgEhw1r6MmbvOLmGvjd8xl92MjvOwEl7aW4mniTWT1tOQLMKG2fWlJGQx1ZlyyxUw7NR
         Gmsdgx2tDB1obKlAszZXpZjVMk15TS5gk7Y5EDp0rM6nlUO5iXt97Vv/i2IeLT5UW2vZ
         rw8g==
X-Gm-Message-State: ABy/qLaVMsyNAzJCQYH1lH+QCIJLXFS6FOtZYwGdcaVQI7kUiykkt+d1
        0mjmyThw1rEl1kZA+1CC2ubGNQ==
X-Google-Smtp-Source: APBJJlHhCTyLkztyA7oyo63LQw96Y/GkUsnwq8vUWzGnkQwicnOUTN6ahBpc6Hl36zCyLO6Tq4cBpQ==
X-Received: by 2002:a05:6870:4150:b0:1be:ccce:7991 with SMTP id r16-20020a056870415000b001beccce7991mr17631935oad.13.1691080391465;
        Thu, 03 Aug 2023 09:33:11 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id y5-20020a056870428500b001bb71264dccsm152929oah.8.2023.08.03.09.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 09:33:11 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v4 01/10] RISC-V: KVM: return ENOENT in *_one_reg() when reg is unknown
Date:   Thu,  3 Aug 2023 13:32:53 -0300
Message-ID: <20230803163302.445167-2-dbarboza@ventanamicro.com>
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

get_one_reg() and set_one_reg() are returning EINVAL errors for almost
everything: if a reg doesn't exist, if a reg ID is malformatted, if the
associated CPU extension that implements the reg isn't present in the
host, and for set_one_reg() if the value being written is invalid.

This isn't wrong according to the existing KVM API docs (EINVAL can be
used when there's no such register) but adding more ENOENT instances
will make easier for userspace to understand what went wrong.

Existing userspaces can be affected by this error code change. We
checked a few. As of current upstream code, crosvm doesn't check for any
particular errno code when using kvm_(get|set)_one_reg(). Neither does
QEMU. rust-vmm doesn't have kvm-riscv support yet. Thus we have a good
chance of changing these error codes now while the KVM RISC-V ecosystem
is still new, minimizing user impact.

Change all get_one_reg() and set_one_reg() implementations to return
-ENOENT at all "no such register" cases.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/aia.c         |  4 ++--
 arch/riscv/kvm/vcpu_fp.c     | 12 ++++++------
 arch/riscv/kvm/vcpu_onereg.c | 36 ++++++++++++++++++------------------
 arch/riscv/kvm/vcpu_sbi.c    | 16 +++++++++-------
 arch/riscv/kvm/vcpu_timer.c  |  8 ++++----
 5 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index 585a3b42c52c..74bb27440527 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -176,7 +176,7 @@ int kvm_riscv_vcpu_aia_get_csr(struct kvm_vcpu *vcpu,
 	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
 
 	if (reg_num >= sizeof(struct kvm_riscv_aia_csr) / sizeof(unsigned long))
-		return -EINVAL;
+		return -ENOENT;
 
 	*out_val = 0;
 	if (kvm_riscv_aia_available())
@@ -192,7 +192,7 @@ int kvm_riscv_vcpu_aia_set_csr(struct kvm_vcpu *vcpu,
 	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
 
 	if (reg_num >= sizeof(struct kvm_riscv_aia_csr) / sizeof(unsigned long))
-		return -EINVAL;
+		return -ENOENT;
 
 	if (kvm_riscv_aia_available()) {
 		((unsigned long *)csr)[reg_num] = val;
diff --git a/arch/riscv/kvm/vcpu_fp.c b/arch/riscv/kvm/vcpu_fp.c
index 9d8cbc42057a..08ba48a395aa 100644
--- a/arch/riscv/kvm/vcpu_fp.c
+++ b/arch/riscv/kvm/vcpu_fp.c
@@ -96,7 +96,7 @@ int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
 			  reg_num <= KVM_REG_RISCV_FP_F_REG(f[31]))
 			reg_val = &cntx->fp.f.f[reg_num];
 		else
-			return -EINVAL;
+			return -ENOENT;
 	} else if ((rtype == KVM_REG_RISCV_FP_D) &&
 		   riscv_isa_extension_available(vcpu->arch.isa, d)) {
 		if (reg_num == KVM_REG_RISCV_FP_D_REG(fcsr)) {
@@ -109,9 +109,9 @@ int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
 				return -EINVAL;
 			reg_val = &cntx->fp.d.f[reg_num];
 		} else
-			return -EINVAL;
+			return -ENOENT;
 	} else
-		return -EINVAL;
+		return -ENOENT;
 
 	if (copy_to_user(uaddr, reg_val, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
@@ -141,7 +141,7 @@ int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
 			  reg_num <= KVM_REG_RISCV_FP_F_REG(f[31]))
 			reg_val = &cntx->fp.f.f[reg_num];
 		else
-			return -EINVAL;
+			return -ENOENT;
 	} else if ((rtype == KVM_REG_RISCV_FP_D) &&
 		   riscv_isa_extension_available(vcpu->arch.isa, d)) {
 		if (reg_num == KVM_REG_RISCV_FP_D_REG(fcsr)) {
@@ -154,9 +154,9 @@ int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
 				return -EINVAL;
 			reg_val = &cntx->fp.d.f[reg_num];
 		} else
-			return -EINVAL;
+			return -ENOENT;
 	} else
-		return -EINVAL;
+		return -ENOENT;
 
 	if (copy_from_user(reg_val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 85773e858120..456e9f31441a 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -156,7 +156,7 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
 		reg_val = satp_mode >> SATP_MODE_SHIFT;
 		break;
 	default:
-		return -EINVAL;
+		return -ENOENT;
 	}
 
 	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
@@ -242,7 +242,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 		break;
 	default:
-		return -EINVAL;
+		return -ENOENT;
 	}
 
 	return 0;
@@ -262,7 +262,7 @@ static int kvm_riscv_vcpu_get_reg_core(struct kvm_vcpu *vcpu,
 	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
 		return -EINVAL;
 	if (reg_num >= sizeof(struct kvm_riscv_core) / sizeof(unsigned long))
-		return -EINVAL;
+		return -ENOENT;
 
 	if (reg_num == KVM_REG_RISCV_CORE_REG(regs.pc))
 		reg_val = cntx->sepc;
@@ -273,7 +273,7 @@ static int kvm_riscv_vcpu_get_reg_core(struct kvm_vcpu *vcpu,
 		reg_val = (cntx->sstatus & SR_SPP) ?
 				KVM_RISCV_MODE_S : KVM_RISCV_MODE_U;
 	else
-		return -EINVAL;
+		return -ENOENT;
 
 	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
@@ -295,7 +295,7 @@ static int kvm_riscv_vcpu_set_reg_core(struct kvm_vcpu *vcpu,
 	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
 		return -EINVAL;
 	if (reg_num >= sizeof(struct kvm_riscv_core) / sizeof(unsigned long))
-		return -EINVAL;
+		return -ENOENT;
 
 	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
@@ -311,7 +311,7 @@ static int kvm_riscv_vcpu_set_reg_core(struct kvm_vcpu *vcpu,
 		else
 			cntx->sstatus &= ~SR_SPP;
 	} else
-		return -EINVAL;
+		return -ENOENT;
 
 	return 0;
 }
@@ -323,7 +323,7 @@ static int kvm_riscv_vcpu_general_get_csr(struct kvm_vcpu *vcpu,
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 
 	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
-		return -EINVAL;
+		return -ENOENT;
 
 	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
 		kvm_riscv_vcpu_flush_interrupts(vcpu);
@@ -342,7 +342,7 @@ static int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu,
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 
 	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
-		return -EINVAL;
+		return -ENOENT;
 
 	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
 		reg_val &= VSIP_VALID_MASK;
@@ -381,7 +381,7 @@ static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
 		rc = kvm_riscv_vcpu_aia_get_csr(vcpu, reg_num, &reg_val);
 		break;
 	default:
-		rc = -EINVAL;
+		rc = -ENOENT;
 		break;
 	}
 	if (rc)
@@ -420,7 +420,7 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
 		rc = kvm_riscv_vcpu_aia_set_csr(vcpu, reg_num, reg_val);
 		break;
 	default:
-		rc = -EINVAL;
+		rc = -ENOENT;
 		break;
 	}
 	if (rc)
@@ -437,7 +437,7 @@ static int riscv_vcpu_get_isa_ext_single(struct kvm_vcpu *vcpu,
 
 	if (reg_num >= KVM_RISCV_ISA_EXT_MAX ||
 	    reg_num >= ARRAY_SIZE(kvm_isa_ext_arr))
-		return -EINVAL;
+		return -ENOENT;
 
 	*reg_val = 0;
 	host_isa_ext = kvm_isa_ext_arr[reg_num];
@@ -455,7 +455,7 @@ static int riscv_vcpu_set_isa_ext_single(struct kvm_vcpu *vcpu,
 
 	if (reg_num >= KVM_RISCV_ISA_EXT_MAX ||
 	    reg_num >= ARRAY_SIZE(kvm_isa_ext_arr))
-		return -EINVAL;
+		return -ENOENT;
 
 	host_isa_ext = kvm_isa_ext_arr[reg_num];
 	if (!__riscv_isa_extension_available(NULL, host_isa_ext))
@@ -489,7 +489,7 @@ static int riscv_vcpu_get_isa_ext_multi(struct kvm_vcpu *vcpu,
 	unsigned long i, ext_id, ext_val;
 
 	if (reg_num > KVM_REG_RISCV_ISA_MULTI_REG_LAST)
-		return -EINVAL;
+		return -ENOENT;
 
 	for (i = 0; i < BITS_PER_LONG; i++) {
 		ext_id = i + reg_num * BITS_PER_LONG;
@@ -512,7 +512,7 @@ static int riscv_vcpu_set_isa_ext_multi(struct kvm_vcpu *vcpu,
 	unsigned long i, ext_id;
 
 	if (reg_num > KVM_REG_RISCV_ISA_MULTI_REG_LAST)
-		return -EINVAL;
+		return -ENOENT;
 
 	for_each_set_bit(i, &reg_val, BITS_PER_LONG) {
 		ext_id = i + reg_num * BITS_PER_LONG;
@@ -554,7 +554,7 @@ static int kvm_riscv_vcpu_get_reg_isa_ext(struct kvm_vcpu *vcpu,
 			reg_val = ~reg_val;
 		break;
 	default:
-		rc = -EINVAL;
+		rc = -ENOENT;
 	}
 	if (rc)
 		return rc;
@@ -592,7 +592,7 @@ static int kvm_riscv_vcpu_set_reg_isa_ext(struct kvm_vcpu *vcpu,
 	case KVM_REG_RISCV_SBI_MULTI_DIS:
 		return riscv_vcpu_set_isa_ext_multi(vcpu, reg_num, reg_val, false);
 	default:
-		return -EINVAL;
+		return -ENOENT;
 	}
 
 	return 0;
@@ -627,7 +627,7 @@ int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
 		break;
 	}
 
-	return -EINVAL;
+	return -ENOENT;
 }
 
 int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
@@ -659,5 +659,5 @@ int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
 		break;
 	}
 
-	return -EINVAL;
+	return -ENOENT;
 }
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 7b46e04fb667..9cd97091c723 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -140,8 +140,10 @@ static int riscv_vcpu_set_sbi_ext_single(struct kvm_vcpu *vcpu,
 	const struct kvm_riscv_sbi_extension_entry *sext = NULL;
 	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
 
-	if (reg_num >= KVM_RISCV_SBI_EXT_MAX ||
-	    (reg_val != 1 && reg_val != 0))
+	if (reg_num >= KVM_RISCV_SBI_EXT_MAX)
+		return -ENOENT;
+
+	if (reg_val != 1 && reg_val != 0)
 		return -EINVAL;
 
 	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
@@ -175,7 +177,7 @@ static int riscv_vcpu_get_sbi_ext_single(struct kvm_vcpu *vcpu,
 	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
 
 	if (reg_num >= KVM_RISCV_SBI_EXT_MAX)
-		return -EINVAL;
+		return -ENOENT;
 
 	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
 		if (sbi_ext[i].ext_idx == reg_num) {
@@ -206,7 +208,7 @@ static int riscv_vcpu_set_sbi_ext_multi(struct kvm_vcpu *vcpu,
 	unsigned long i, ext_id;
 
 	if (reg_num > KVM_REG_RISCV_SBI_MULTI_REG_LAST)
-		return -EINVAL;
+		return -ENOENT;
 
 	for_each_set_bit(i, &reg_val, BITS_PER_LONG) {
 		ext_id = i + reg_num * BITS_PER_LONG;
@@ -226,7 +228,7 @@ static int riscv_vcpu_get_sbi_ext_multi(struct kvm_vcpu *vcpu,
 	unsigned long i, ext_id, ext_val;
 
 	if (reg_num > KVM_REG_RISCV_SBI_MULTI_REG_LAST)
-		return -EINVAL;
+		return -ENOENT;
 
 	for (i = 0; i < BITS_PER_LONG; i++) {
 		ext_id = i + reg_num * BITS_PER_LONG;
@@ -272,7 +274,7 @@ int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
 	case KVM_REG_RISCV_SBI_MULTI_DIS:
 		return riscv_vcpu_set_sbi_ext_multi(vcpu, reg_num, reg_val, false);
 	default:
-		return -EINVAL;
+		return -ENOENT;
 	}
 
 	return 0;
@@ -307,7 +309,7 @@ int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *vcpu,
 			reg_val = ~reg_val;
 		break;
 	default:
-		rc = -EINVAL;
+		rc = -ENOENT;
 	}
 	if (rc)
 		return rc;
diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
index 3ac2ff6a65da..527d269cafff 100644
--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -170,7 +170,7 @@ int kvm_riscv_vcpu_get_reg_timer(struct kvm_vcpu *vcpu,
 	if (KVM_REG_SIZE(reg->id) != sizeof(u64))
 		return -EINVAL;
 	if (reg_num >= sizeof(struct kvm_riscv_timer) / sizeof(u64))
-		return -EINVAL;
+		return -ENOENT;
 
 	switch (reg_num) {
 	case KVM_REG_RISCV_TIMER_REG(frequency):
@@ -187,7 +187,7 @@ int kvm_riscv_vcpu_get_reg_timer(struct kvm_vcpu *vcpu,
 					  KVM_RISCV_TIMER_STATE_OFF;
 		break;
 	default:
-		return -EINVAL;
+		return -ENOENT;
 	}
 
 	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
@@ -211,7 +211,7 @@ int kvm_riscv_vcpu_set_reg_timer(struct kvm_vcpu *vcpu,
 	if (KVM_REG_SIZE(reg->id) != sizeof(u64))
 		return -EINVAL;
 	if (reg_num >= sizeof(struct kvm_riscv_timer) / sizeof(u64))
-		return -EINVAL;
+		return -ENOENT;
 
 	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
@@ -233,7 +233,7 @@ int kvm_riscv_vcpu_set_reg_timer(struct kvm_vcpu *vcpu,
 			ret = kvm_riscv_vcpu_timer_cancel(t);
 		break;
 	default:
-		ret = -EINVAL;
+		ret = -ENOENT;
 		break;
 	}
 
-- 
2.41.0


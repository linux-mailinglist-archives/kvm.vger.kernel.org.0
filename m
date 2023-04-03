Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6F16D40B6
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 11:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbjDCJeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 05:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjDCJeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 05:34:21 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D279CD337
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 02:33:58 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id o25-20020a9d4119000000b006a11eb19f8eso14084201ote.5
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 02:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680514438; x=1683106438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DbIL2R4BbWdg8J7OAaKXV5aF5CAjir3TG4QymDLTrYk=;
        b=Cf+4UIIPv5TTBiyEN7r8FKIHYeEu53s+lvh9b6LpqOMAIAxQImwsj2/TwR7xTynMkp
         CK4edr++aEb5J743Bl62h+2m43WjwaUKdvAFViPNLfvw6ajNJDUNHaRuBCQFgn5CZ40s
         ON69nPkTq7d5cmP0V6MJ1N1GVuLPHsKMXqnX6n8v7l0WPBBmh1BrOdwhwgO4VF8Qjdit
         N5DT8M/4XqHbIKfAKoD97FU+8DK//cL+T7TANqzJ3T0sSaGUN9pxsNvG47iEgKEn+JA2
         1czaUce3UMbB1Ba80BmyvnZ7alOdC7oX8SaNzXzoUm6V/0d05gudHEEZXPhJYsLdtijp
         IRfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680514438; x=1683106438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DbIL2R4BbWdg8J7OAaKXV5aF5CAjir3TG4QymDLTrYk=;
        b=UTNzPX5afJWYq6jhW1qgCOD2UxLNwhR/ZN30MJezSsSBApbwgLAoic5W77XSt94QMn
         +r9odTx+6b54IGmpRGsqYLRdUyF86HL91o1QuuFwqVwKNdvzbertKfEg4I0E4Ps17QNX
         kKxYGHNeR5DJzVBkGaIdBNEU/9QbRXVyMZs6De6GENQVAJG8lC6Uf/5xbeuir5uFggqq
         /7aTcYc8RTLj8SplJnmowxqmvWl6gMoy9DoVMskecg40AZ9OU+qEggUB+c7RLwqSJOud
         AE5CKzBugTTIZ8jLVxV3f/Yi/YRGZlr5zE6909wOiC60ga1cVWdAiExUt5mdGjUSNpva
         b9sQ==
X-Gm-Message-State: AAQBX9c3PTAxsksKKtmL5m6NYBgtQ4hnFL+Gj8KddQOWyLUQBieUIeTa
        OvhYcSrPAB9FnCcX0K3bx5WFOQ==
X-Google-Smtp-Source: AKy350a8CdQ+7GbARk61CNLe4SIuFNs+HJwIKyXnXsOqQt4MkrXG5bXU8fVlXObFmcBnveuNhp8rew==
X-Received: by 2002:a05:6830:e12:b0:6a3:60c7:696d with SMTP id do18-20020a0568300e1200b006a360c7696dmr1452661otb.28.1680514438385;
        Mon, 03 Apr 2023 02:33:58 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id f5-20020a9d6c05000000b006a154373578sm3953953otq.39.2023.04.03.02.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 02:33:57 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v3 6/8] RISC-V: KVM: Add ONE_REG interface for AIA CSRs
Date:   Mon,  3 Apr 2023 15:03:08 +0530
Message-Id: <20230403093310.2271142-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403093310.2271142-1-apatel@ventanamicro.com>
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We implement ONE_REG interface for AIA CSRs as a separate subtype
under the CSR ONE_REG interface.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 8 ++++++++
 arch/riscv/kvm/vcpu.c             | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 182023dc9a51..cbc3e74fa670 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -79,6 +79,10 @@ struct kvm_riscv_csr {
 	unsigned long scounteren;
 };
 
+/* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_aia_csr {
+};
+
 /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
 struct kvm_riscv_timer {
 	__u64 frequency;
@@ -107,6 +111,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
 	KVM_RISCV_ISA_EXT_ZICBOM,
 	KVM_RISCV_ISA_EXT_ZBB,
+	KVM_RISCV_ISA_EXT_SSAIA,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
@@ -153,8 +158,11 @@ enum KVM_RISCV_SBI_EXT_ID {
 /* Control and status registers are mapped as type 3 */
 #define KVM_REG_RISCV_CSR		(0x03 << KVM_REG_RISCV_TYPE_SHIFT)
 #define KVM_REG_RISCV_CSR_GENERAL	(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_CSR_AIA		(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
 #define KVM_REG_RISCV_CSR_REG(name)	\
 		(offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
+#define KVM_REG_RISCV_CSR_AIA_REG(name)	\
+	(offsetof(struct kvm_riscv_aia_csr, name) / sizeof(unsigned long))
 
 /* Timer registers are mapped as type 4 */
 #define KVM_REG_RISCV_TIMER		(0x04 << KVM_REG_RISCV_TYPE_SHIFT)
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index aca6b4fb7519..15507cd3a595 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -58,6 +58,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	[KVM_RISCV_ISA_EXT_I] = RISCV_ISA_EXT_i,
 	[KVM_RISCV_ISA_EXT_M] = RISCV_ISA_EXT_m,
 
+	KVM_ISA_EXT_ARR(SSAIA),
 	KVM_ISA_EXT_ARR(SSTC),
 	KVM_ISA_EXT_ARR(SVINVAL),
 	KVM_ISA_EXT_ARR(SVPBMT),
@@ -97,6 +98,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_C:
 	case KVM_RISCV_ISA_EXT_I:
 	case KVM_RISCV_ISA_EXT_M:
+	case KVM_RISCV_ISA_EXT_SSAIA:
 	case KVM_RISCV_ISA_EXT_SSTC:
 	case KVM_RISCV_ISA_EXT_SVINVAL:
 	case KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
@@ -520,6 +522,9 @@ static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
 	case KVM_REG_RISCV_CSR_GENERAL:
 		rc = kvm_riscv_vcpu_general_get_csr(vcpu, reg_num, &reg_val);
 		break;
+	case KVM_REG_RISCV_CSR_AIA:
+		rc = kvm_riscv_vcpu_aia_get_csr(vcpu, reg_num, &reg_val);
+		break;
 	default:
 		rc = -EINVAL;
 		break;
@@ -556,6 +561,9 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
 	case KVM_REG_RISCV_CSR_GENERAL:
 		rc = kvm_riscv_vcpu_general_set_csr(vcpu, reg_num, reg_val);
 		break;
+	case KVM_REG_RISCV_CSR_AIA:
+		rc = kvm_riscv_vcpu_aia_set_csr(vcpu, reg_num, reg_val);
+		break;
 	default:
 		rc = -EINVAL;
 		break;
-- 
2.34.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8077B6E8492
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbjDSWS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbjDSWSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:18:21 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B521583CF
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:04 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1a920d484bdso4573795ad.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942676; x=1684534676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aZA9SkX62fIMzNEcuGtwzVe8Up8R4eolVQO1cYHyNXI=;
        b=pr/kZUHrkhLnktVNRdfz4ij02MTZd+B9h2TaIJSMbt3NVujPvaiFp7Ik4rbkspQ4Mw
         yuGTwtHLYNepi572aUMJZXGKBGxqqLOoQQAVLkJQE8EutQeaNnEXjp7ozMrwLpK3F/bd
         Ea/tWnKPdLgS76oaBzGp+E0BB9Obb3YUpFKxXwNOfadBL+8Y1NryGBq3tL1grWdeANk4
         WZM2Z6J10fv3mT8jXclG/Jc0tJeziAmqwuD529CbKYuuh+zFcMDe14NqalRMWLaTiCrI
         zVE7Fohp3aDpbBaOaQnfhoMTTf4olrAvxRsbHG36Vnwm4rXJhTcr8zeKFydq/GZ4e/40
         +9lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942676; x=1684534676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aZA9SkX62fIMzNEcuGtwzVe8Up8R4eolVQO1cYHyNXI=;
        b=EyWf1nEtzPmFdZrVFptmkaLhzC89Xi+0ID8vEtzEI3wcXyh7N3veOcbZHsF3e40aYI
         d6Hk6hmbwXwZYIQ+kXE489hpHoPbwy0mOAumMOw9OUbONHOMRu1SUsvEz1L1j5NfGr4B
         xjxVBQDq34nLgkfyyCdr3/owlMiSlgdA5JFGpuCdHOdqjr9KFLGLKRFpIjbAn7t3141R
         tm/O2BK1kxnFm2oVFLXT0vpdPx2d+NlCZDdPJMVYDGH4GQHOnZoitaTMqcPg54AgUj/p
         iNoDxig/7/24r0X6qekttNiIsGSEOsNJrDijn9jVWCPKe+gHc0LYCwEs7lvZuJB+i3Dg
         GOGQ==
X-Gm-Message-State: AAQBX9d7JuPL7yFQyg6X5RLzFXzjy35pKK3/mFxPLEuqLI9GiiQMuFsj
        Hl410F6PPnv0mRaPRyPgJlvPRw==
X-Google-Smtp-Source: AKy350aluUR1rPQXEDjya7qc0cousjv7HzRiR+wEHDbTSJe3tj7Btum5nXicmgptUoZ7hSCP4qqeQg==
X-Received: by 2002:a17:902:c40d:b0:1a8:1cbb:4f76 with SMTP id k13-20020a170902c40d00b001a81cbb4f76mr4908149plk.28.1681942676188;
        Wed, 19 Apr 2023 15:17:56 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:17:55 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 12/48] RISC-V: KVM: Exit to the user space for trap redirection
Date:   Wed, 19 Apr 2023 15:16:40 -0700
Message-Id: <20230419221716.3603068-13-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419221716.3603068-1-atishp@rivosinc.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the trap redirection to the guest happens in the
following cases.

1. Illegal instruction trap
2. Virtual instruction trap
3. Unsuccesfull unpriv read

Allowing host to cause traps in the TVM directly is problematic.
TSM doesn't support trap redirection yet. Ideally, the host should not end
up in one of these situations where it has to redirect the trap. If it
happens, exit to the userspace with error as it can't forward the trap to
the TVM.

If there is any usecasse arises in the future, it has to be co-ordinated
through TSM.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_exit.c |  9 ++++++++-
 arch/riscv/kvm/vcpu_insn.c | 17 +++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 4ea101a..0d0c895 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -9,6 +9,7 @@
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
 #include <asm/insn-def.h>
+#include <asm/kvm_cove.h>
 
 static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			     struct kvm_cpu_trap *trap)
@@ -135,8 +136,14 @@ unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
 void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
 				  struct kvm_cpu_trap *trap)
 {
-	unsigned long vsstatus = csr_read(CSR_VSSTATUS);
+	unsigned long vsstatus;
 
+	if (is_cove_vcpu(vcpu)) {
+		kvm_err("RISC-V KVM do not support redirect to CoVE guest yet\n");
+		return;
+	}
+
+	vsstatus = csr_read(CSR_VSSTATUS);
 	/* Change Guest SSTATUS.SPP bit */
 	vsstatus &= ~SR_SPP;
 	if (vcpu->arch.guest_context.sstatus & SR_SPP)
diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 7a6abed..331489f 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -6,6 +6,7 @@
 
 #include <linux/bitops.h>
 #include <linux/kvm_host.h>
+#include <asm/kvm_cove.h>
 
 #define INSN_OPCODE_MASK	0x007c
 #define INSN_OPCODE_SHIFT	2
@@ -153,6 +154,10 @@ static int truly_illegal_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 {
 	struct kvm_cpu_trap utrap = { 0 };
 
+	/* The host can not redirect any illegal instruction trap to TVM */
+	if (unlikely(is_cove_vcpu(vcpu)))
+		return -EPERM;
+
 	/* Redirect trap to Guest VCPU */
 	utrap.sepc = vcpu->arch.guest_context.sepc;
 	utrap.scause = EXC_INST_ILLEGAL;
@@ -169,6 +174,10 @@ static int truly_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 {
 	struct kvm_cpu_trap utrap = { 0 };
 
+	/* The host can not redirect any virtual instruction trap to TVM */
+	if (unlikely(is_cove_vcpu(vcpu)))
+		return -EPERM;
+
 	/* Redirect trap to Guest VCPU */
 	utrap.sepc = vcpu->arch.guest_context.sepc;
 	utrap.scause = EXC_VIRTUAL_INST_FAULT;
@@ -417,6 +426,10 @@ int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	if (unlikely(INSN_IS_16BIT(insn))) {
 		if (insn == 0) {
 			ct = &vcpu->arch.guest_context;
+
+			if (unlikely(is_cove_vcpu(vcpu)))
+				return -EPERM;
+
 			insn = kvm_riscv_vcpu_unpriv_read(vcpu, true,
 							  ct->sepc,
 							  &utrap);
@@ -469,6 +482,8 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		insn = htinst | INSN_16BIT_MASK;
 		insn_len = (htinst & BIT(1)) ? INSN_LEN(insn) : 2;
 	} else {
+		if (unlikely(is_cove_vcpu(vcpu)))
+			return -EFAULT;
 		/*
 		 * Bit[0] == 0 implies trapped instruction value is
 		 * zero or special value.
@@ -595,6 +610,8 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		insn = htinst | INSN_16BIT_MASK;
 		insn_len = (htinst & BIT(1)) ? INSN_LEN(insn) : 2;
 	} else {
+		if (unlikely(is_cove_vcpu(vcpu)))
+			return -EFAULT;
 		/*
 		 * Bit[0] == 0 implies trapped instruction value is
 		 * zero or special value.
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8F1545B6C
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 07:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243484AbiFJFGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 01:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243446AbiFJFGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 01:06:33 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71974256959
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 22:06:27 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id f65so13568080pgc.7
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 22:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ULPEiXMnFU7l6XselUzEmxUGI/TXFOKAnllM+GAyEtM=;
        b=C80BPXGalQYbDk/yHa5kUa+rgnL897bCITP0/Yl1pRCEmHFQ5y7eSiws3uouxLjyhf
         fOAmIidz0WVMC0m4UnivgGbTxLeINhT+qn4SihRoI9EWPvVUXeF36//GzCgYt4wKrK34
         RPjfuMXXtQSLMGv1W22Mb05ZAeW/qRLqvgUK8lwFnrIlSw1QRJsEHPakq8GJAaGI1AEr
         ER2ra1gswhj/rWVgvWfrQ7O+S01pP5MIO1yenDdDR4T6pmB9lG3M8cnr91VFw01uydth
         U2L/eXdLvrwIBGCj1XOkqGRpUo4DxiodnVGJlDK+E+NsmvcpkbEuFKh+k1TDcSaNLbEt
         gvvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ULPEiXMnFU7l6XselUzEmxUGI/TXFOKAnllM+GAyEtM=;
        b=MFyR9eZMEGRUm2YzK7bPmp2qWHtba4BwtBgDPSAPPIvvYhti0i0sSsK7oknjn2QAnc
         16Bt70jKjsew0wsr3Ev6O67aAnl3SSaZ7UCRyGMSqILJrVfRnl1fzM0q65wzDhD+LozG
         NoV2wL0C/myHy723wmtCGeBrRMti+IdfWTq+vixKmAPpB/giTpwTIKYIoBgG/ExoyIRT
         PaU95m9SksaD5cw5v0WSLnFdyf0stdNVVbTEWhf4XQsM1cgoeW1qBfV2im8R8BCCSw3q
         eZY5JWPTVzk0k35Tyfm4oRw7/8ReA6sBaVQtuAElizgdqGlBr0rbmtQIFrJJr8GheTLi
         9XYg==
X-Gm-Message-State: AOAM530Z7jB7zxL7R8dp33VJs/R81oO/MdQVU7VYIUPrQMCEhDUgwxqU
        jyTf7/WLCqhk48B1PF4pAWlCVK40URG8Ng==
X-Google-Smtp-Source: ABdhPJweOx1PBTSkMvPt8AagCRjsaLxKg4ryVjzg61dVMeRO7qYXQLOZJxei8sbJLYBE7lz2yO1IlA==
X-Received: by 2002:aa7:88cb:0:b0:51c:2627:2c03 with SMTP id k11-20020aa788cb000000b0051c26272c03mr22840484pff.63.1654837586673;
        Thu, 09 Jun 2022 22:06:26 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([106.200.250.139])
        by smtp.gmail.com with ESMTPSA id u7-20020a056a00158700b00519cfca8e30sm12429424pfk.209.2022.06.09.22.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 22:06:26 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 2/3] RISC-V: KVM: Add extensible system instruction emulation framework
Date:   Fri, 10 Jun 2022 10:35:54 +0530
Message-Id: <20220610050555.288251-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610050555.288251-1-apatel@ventanamicro.com>
References: <20220610050555.288251-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will be emulating more system instructions in near future with
upcoming AIA, PMU, Nested and other virtualization features.

To accommodate above, we add an extensible system instruction emulation
framework in vcpu_insn.c.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_vcpu_insn.h |  9 +++
 arch/riscv/kvm/vcpu_insn.c             | 82 +++++++++++++++++++++++---
 2 files changed, 82 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_insn.h b/arch/riscv/include/asm/kvm_vcpu_insn.h
index 4e3ba4e84d0f..3351eb61a251 100644
--- a/arch/riscv/include/asm/kvm_vcpu_insn.h
+++ b/arch/riscv/include/asm/kvm_vcpu_insn.h
@@ -18,6 +18,15 @@ struct kvm_mmio_decode {
 	int return_handled;
 };
 
+/* Return values used by function emulating a particular instruction */
+enum kvm_insn_return {
+	KVM_INSN_EXIT_TO_USER_SPACE = 0,
+	KVM_INSN_CONTINUE_NEXT_SEPC,
+	KVM_INSN_CONTINUE_SAME_SEPC,
+	KVM_INSN_ILLEGAL_TRAP,
+	KVM_INSN_VIRTUAL_TRAP
+};
+
 void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu);
 int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 				struct kvm_cpu_trap *trap);
diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index be756879c2ee..75ca62a7fba5 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -118,8 +118,24 @@
 				 (s32)(((insn) >> 7) & 0x1f))
 #define MASK_FUNCT3		0x7000
 
-static int truly_illegal_insn(struct kvm_vcpu *vcpu,
-			      struct kvm_run *run,
+struct insn_func {
+	unsigned long mask;
+	unsigned long match;
+	/*
+	 * Possible return values are as follows:
+	 * 1) Returns < 0 for error case
+	 * 2) Returns 0 for exit to user-space
+	 * 3) Returns 1 to continue with next sepc
+	 * 4) Returns 2 to continue with same sepc
+	 * 5) Returns 3 to inject illegal instruction trap and continue
+	 * 6) Returns 4 to inject virtual instruction trap and continue
+	 *
+	 * Use enum kvm_insn_return for return values
+	 */
+	int (*func)(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn);
+};
+
+static int truly_illegal_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			      ulong insn)
 {
 	struct kvm_cpu_trap utrap = { 0 };
@@ -128,6 +144,24 @@ static int truly_illegal_insn(struct kvm_vcpu *vcpu,
 	utrap.sepc = vcpu->arch.guest_context.sepc;
 	utrap.scause = EXC_INST_ILLEGAL;
 	utrap.stval = insn;
+	utrap.htval = 0;
+	utrap.htinst = 0;
+	kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
+
+	return 1;
+}
+
+static int truly_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			      ulong insn)
+{
+	struct kvm_cpu_trap utrap = { 0 };
+
+	/* Redirect trap to Guest VCPU */
+	utrap.sepc = vcpu->arch.guest_context.sepc;
+	utrap.scause = EXC_VIRTUAL_INST_FAULT;
+	utrap.stval = insn;
+	utrap.htval = 0;
+	utrap.htinst = 0;
 	kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
 
 	return 1;
@@ -148,18 +182,48 @@ void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu)
 	}
 }
 
-static int system_opcode_insn(struct kvm_vcpu *vcpu,
-			      struct kvm_run *run,
+static int wfi_insn(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn)
+{
+	vcpu->stat.wfi_exit_stat++;
+	kvm_riscv_vcpu_wfi(vcpu);
+	return KVM_INSN_CONTINUE_NEXT_SEPC;
+}
+
+static const struct insn_func system_opcode_funcs[] = {
+	{
+		.mask  = INSN_MASK_WFI,
+		.match = INSN_MATCH_WFI,
+		.func  = wfi_insn,
+	},
+};
+
+static int system_opcode_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			      ulong insn)
 {
-	if ((insn & INSN_MASK_WFI) == INSN_MATCH_WFI) {
-		vcpu->stat.wfi_exit_stat++;
-		kvm_riscv_vcpu_wfi(vcpu);
+	int i, rc = KVM_INSN_ILLEGAL_TRAP;
+	const struct insn_func *ifn;
+
+	for (i = 0; i < ARRAY_SIZE(system_opcode_funcs); i++) {
+		ifn = &system_opcode_funcs[i];
+		if ((insn & ifn->mask) == ifn->match) {
+			rc = ifn->func(vcpu, run, insn);
+			break;
+		}
+	}
+
+	switch (rc) {
+	case KVM_INSN_ILLEGAL_TRAP:
+		return truly_illegal_insn(vcpu, run, insn);
+	case KVM_INSN_VIRTUAL_TRAP:
+		return truly_virtual_insn(vcpu, run, insn);
+	case KVM_INSN_CONTINUE_NEXT_SEPC:
 		vcpu->arch.guest_context.sepc += INSN_LEN(insn);
-		return 1;
+		break;
+	default:
+		break;
 	}
 
-	return truly_illegal_insn(vcpu, run, insn);
+	return (rc <= 0) ? rc : 1;
 }
 
 /**
-- 
2.34.1


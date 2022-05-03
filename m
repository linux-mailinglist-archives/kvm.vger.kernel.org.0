Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C0F517CF2
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 08:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiECGFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 02:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiECGFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 02:05:45 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD1333352
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 23:02:13 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id t15-20020a17090a3b4f00b001d67e27715dso778347pjf.0
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 23:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iMHosWYQzv6+yhARsG5DZnRjYpdmpqLFNAAhXhqlO0Y=;
        b=XPvCQ0ZOZ/FhbBs/FauWTHTsiMJBhV+cQ9o4zm3kzJ4uBDfsoRUchoT8UrDEyncwfL
         DnyaynfY4f6H1UpQ10QWzojkPGpFV92lvQeUIS3+sOZ15od4kUpcnSOr7Km46DlZ+rF5
         jGaobVwvXzeriQ7LGsZ8O96b2soO59MBuHEXdd1lUEXbp3dH+Ny7tNV8UGee6LjwfyZ7
         XXRVNgzvkjgC+svfYCxfoxAI61dAUTXyXUQX22vyxX8Q7vnVhYynPFxeP5Qr+wj4ixYq
         NTFuChSCynIApyDpnWmZWdgrAykNfMsIqszJOitaOt0zWmoqSlOkK9SvsF9U+Eenh51d
         +mEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iMHosWYQzv6+yhARsG5DZnRjYpdmpqLFNAAhXhqlO0Y=;
        b=a1ltH2ACLXYB/oyzsKsSje2jmDfuOJlNmgp+72PiMLFIRuJXL2zr6lWPcpRYeeXTRV
         35VDS25oN/8mTQf6zflfSOytsgFZYv2Yg2Ci4Ni5P6oTsZ0RwlfgvHFIzPJBrN2wUgbl
         30NDYl1d8l/5r8V03O3G3OWM74+/xcDUe91gPlCV0bPre/WNQfMKfyk8SiwStuDT/KH+
         /RAjjOF8y5WzNJWvocQGyPkUPciz1Y8RjmxrprDb5gSFifn7iwqzAfI1PhEHDj3Ny04M
         zJwG4H6r9ye6rKML4zm5mIihbcVGxl2HOGqLWvORJVQ78pWwgbEQUWV7tW/2aKDQ5Zcp
         3Idw==
X-Gm-Message-State: AOAM532sPKmr8tNv5YcXTXpF+ITpeq2aocdEeTmVa5cIn8WMAuG3orog
        402anH5cD2RV9D/u2w4+XWN1MQ/W4tI=
X-Google-Smtp-Source: ABdhPJyxWkE8z6PmjYJrZBWkij7h6t5O4MaqXZetjxoeehlcNmC4S8YXLUMunW4YfmQ5f++4M3kyLk4fDec=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a05:6a00:181d:b0:50d:d56c:73d3 with SMTP id
 y29-20020a056a00181d00b0050dd56c73d3mr12193122pfa.22.1651557733374; Mon, 02
 May 2022 23:02:13 -0700 (PDT)
Date:   Tue,  3 May 2022 06:02:01 +0000
In-Reply-To: <20220503060205.2823727-1-oupton@google.com>
Message-Id: <20220503060205.2823727-4-oupton@google.com>
Mime-Version: 1.0
References: <20220503060205.2823727-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 3/7] KVM: arm64: Wire up CP15 feature registers to their
 AArch64 equivalents
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        reijiw@google.com, ricarkol@google.com,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM currently does not trap ID register accesses from an AArch32 EL1.
This is painful for a couple of reasons. Certain unimplemented features
are visible to AArch32 EL1, as we limit PMU to version 3 and the debug
architecture to v8.0. Additionally, we attempt to paper over
heterogeneous systems by using register values that are safe
system-wide. All this hard work is completely sidestepped because KVM
does not set TID3 for AArch32 guests.

Fix up handling of CP15 feature registers by simply rerouting to their
AArch64 aliases. Punt setting HCR_EL2.TID3 to a later change, as we need
to fix up the oddball CP10 feature registers still.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 86 ++++++++++++++++++++++++++++++++-------
 arch/arm64/kvm/sys_regs.h |  7 ++++
 2 files changed, 78 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f0a076e5cc1c..f403ea47b8a3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2344,34 +2344,73 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
+static bool emulate_sys_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
+
+/**
+ * kvm_emulate_cp15_id_reg() - Handles an MRC trap on a guest CP15 access where
+ *			       CRn=0, which corresponds to the AArch32 feature
+ *			       registers.
+ * @vcpu: the vCPU pointer
+ * @params: the system register access parameters.
+ *
+ * Our cp15 system register tables do not enumerate the AArch32 feature
+ * registers. Conveniently, our AArch64 table does, and the AArch32 system
+ * register encoding can be trivially remapped into the AArch64 for the feature
+ * registers: Append op0=3, leaving op1, CRn, CRm, and op2 the same.
+ *
+ * According to DDI0487G.b G7.3.1, paragraph "Behavior of VMSAv8-32 32-bit
+ * System registers with (coproc=0b1111, CRn==c0)", read accesses from this
+ * range are either UNKNOWN or RES0. Rerouting remains architectural as we
+ * treat undefined registers in this range as RAZ.
+ */
+static int kvm_emulate_cp15_id_reg(struct kvm_vcpu *vcpu,
+				   struct sys_reg_params *params)
+{
+	int Rt = kvm_vcpu_sys_get_rt(vcpu);
+
+	/* Treat impossible writes to RO registers as UNDEFINED */
+	if (params->is_write) {
+		unhandled_cp_access(vcpu, params);
+		return 1;
+	}
+
+	params->Op0 = 3;
+
+	/*
+	 * All registers where CRm > 3 are known to be UNKNOWN/RAZ from AArch32.
+	 * Avoid conflicting with future expansion of AArch64 feature registers
+	 * and simply treat them as RAZ here.
+	 */
+	if (params->CRm > 3)
+		params->regval = 0;
+	else if (!emulate_sys_reg(vcpu, params))
+		return 1;
+
+	vcpu_set_reg(vcpu, Rt, params->regval);
+	return 1;
+}
+
 /**
  * kvm_handle_cp_32 -- handles a mrc/mcr trap on a guest CP14/CP15 access
  * @vcpu: The VCPU pointer
  * @run:  The kvm_run struct
  */
 static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *params,
 			    const struct sys_reg_desc *global,
 			    size_t nr_global)
 {
-	struct sys_reg_params params;
-	u32 esr = kvm_vcpu_get_esr(vcpu);
 	int Rt  = kvm_vcpu_sys_get_rt(vcpu);
 
-	params.CRm = (esr >> 1) & 0xf;
-	params.regval = vcpu_get_reg(vcpu, Rt);
-	params.is_write = ((esr & 1) == 0);
-	params.CRn = (esr >> 10) & 0xf;
-	params.Op0 = 0;
-	params.Op1 = (esr >> 14) & 0x7;
-	params.Op2 = (esr >> 17) & 0x7;
+	params->regval = vcpu_get_reg(vcpu, Rt);
 
-	if (emulate_cp(vcpu, &params, global, nr_global)) {
-		if (!params.is_write)
-			vcpu_set_reg(vcpu, Rt, params.regval);
+	if (emulate_cp(vcpu, params, global, nr_global)) {
+		if (!params->is_write)
+			vcpu_set_reg(vcpu, Rt, params->regval);
 		return 1;
 	}
 
-	unhandled_cp_access(vcpu, &params);
+	unhandled_cp_access(vcpu, params);
 	return 1;
 }
 
@@ -2382,7 +2421,20 @@ int kvm_handle_cp15_64(struct kvm_vcpu *vcpu)
 
 int kvm_handle_cp15_32(struct kvm_vcpu *vcpu)
 {
-	return kvm_handle_cp_32(vcpu, cp15_regs, ARRAY_SIZE(cp15_regs));
+	struct sys_reg_params params;
+
+	params = esr_cp1x_32_to_params(kvm_vcpu_get_esr(vcpu));
+
+	/*
+	 * Certain AArch32 ID registers are handled by rerouting to the AArch64
+	 * system register table. Registers in the ID range where CRm=0 are
+	 * excluded from this scheme as they do not trivially map into AArch64
+	 * system register encodings.
+	 */
+	if (params.Op1 == 0 && params.CRn == 0 && params.CRm)
+		return kvm_emulate_cp15_id_reg(vcpu, &params);
+
+	return kvm_handle_cp_32(vcpu, &params, cp15_regs, ARRAY_SIZE(cp15_regs));
 }
 
 int kvm_handle_cp14_64(struct kvm_vcpu *vcpu)
@@ -2392,7 +2444,11 @@ int kvm_handle_cp14_64(struct kvm_vcpu *vcpu)
 
 int kvm_handle_cp14_32(struct kvm_vcpu *vcpu)
 {
-	return kvm_handle_cp_32(vcpu, cp14_regs, ARRAY_SIZE(cp14_regs));
+	struct sys_reg_params params;
+
+	params = esr_cp1x_32_to_params(kvm_vcpu_get_esr(vcpu));
+
+	return kvm_handle_cp_32(vcpu, &params, cp14_regs, ARRAY_SIZE(cp14_regs));
 }
 
 static bool is_imp_def_sys_reg(struct sys_reg_params *params)
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index cc0cc95a0280..0d31a12b640c 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -35,6 +35,13 @@ struct sys_reg_params {
 				  .Op2 = ((esr) >> 17) & 0x7,                  \
 				  .is_write = !((esr) & 1) })
 
+#define esr_cp1x_32_to_params(esr)						\
+	((struct sys_reg_params){ .Op1 = ((esr) >> 14) & 0x7,			\
+				  .CRn = ((esr) >> 10) & 0xf,			\
+				  .CRm = ((esr) >> 1) & 0xf,			\
+				  .Op2 = ((esr) >> 17) & 0x7,			\
+				  .is_write = !((esr) & 1) })
+
 struct sys_reg_desc {
 	/* Sysreg string for debug */
 	const char *name;
-- 
2.36.0.464.gb9c8b46e94-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8A74EA47A
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 03:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiC2BOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 21:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiC2BOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 21:14:53 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68A94133E
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 18:13:10 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id t1-20020a92c0c1000000b002c9a0b72880so3144253ilf.1
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 18:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=htFRtOyZ6uolAOd+Si3+5Uh8OfwPEQrnbEsfTJih2b0=;
        b=Vgd7moNsWmoGoWT3hkitkk2U6NneUuTDgwg+dc2HeyQxPq+N2vDMHohiU9BHi+m0ID
         kAluu2Wy1zDXo0RVwcP9tKg6naMo8Ox8UJ0pCGBvD1O3iX5j3KrAQ+N58hStq4LFCdo0
         fW8SzSj/Xg5vUfaEH91Ns3qWyrQbkkMhkTYyzDVAyAc2JF7yhw/GpYUqYS05aRLwD18X
         hRAWlvsswDKhW1Wj2N3AIOTmm//8NOdh5K5Xl+DC+/FJ/z+L3pjarnT12AA3K0R5gGYa
         eshrwN4aDKduvxbSeuWM+SFxwIsTVDllLn5CBr5z92gWE6PToQ9OIcnyvE1fesiOvi31
         bgTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=htFRtOyZ6uolAOd+Si3+5Uh8OfwPEQrnbEsfTJih2b0=;
        b=KSypiJqIRSnZX0FG3ZEvEQzJ6X7G9aBXlovQ2gfM+7RVBIQRMX6i3Nc5VcGXy8LxKr
         b497WzEMTkUg6VHRtaI15bO1pDeuplqOR9fIKed4iH2rGjaY/ueSzSlNYrKxh1XPbPfW
         80uZO4+OSGzXGGYo2ItoCPx7NhWCO7XhzT68r9HjPDSdP/k80NjsssWw3CCA6UEBGylf
         liSDB8X2IkwJL5wimqSUEO79YYoz0UAaYS/o7TC0CK0UNJ7h76HLj23T5mOzlNLrouhv
         jztT7I020QR4riE+cJUdA6z9BZpff7y8n0cvUgfdi6aids4ylGVd8mZk8+tJBi4m/TxD
         V02Q==
X-Gm-Message-State: AOAM533yRFMw2vAMzo4ibfvKTkyh8ghd287AEf2MJXnfyxAN8E/1vJWO
        H3YCvZbA/tpjHnbvx4YDUIeOKhhJwSg=
X-Google-Smtp-Source: ABdhPJx9kYVH6UxwFrBRPPnEgN4FD1oy0p4csE/CGQ+j8IF62YSB8Yf55th8evusYewf+f0N/Kbur7dmQig=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:388f:b0:321:523d:4449 with SMTP id
 b15-20020a056638388f00b00321523d4449mr14926113jav.276.1648516390091; Mon, 28
 Mar 2022 18:13:10 -0700 (PDT)
Date:   Tue, 29 Mar 2022 01:12:59 +0000
In-Reply-To: <20220329011301.1166265-1-oupton@google.com>
Message-Id: <20220329011301.1166265-2-oupton@google.com>
Mime-Version: 1.0
References: <20220329011301.1166265-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH 1/3] KVM: arm64: Wire up CP15 feature registers to their
 AArch64 equivalents
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
---
 arch/arm64/kvm/sys_regs.c | 66 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dd34b5ab51d4..30771f950027 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2339,6 +2339,65 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
+static int emulate_sys_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
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
+	int ret = 1;
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
+	else
+		ret = emulate_sys_reg(vcpu, params);
+
+	/* Treat impossible writes to RO registers as UNDEFINED */
+	if (params->is_write)
+		unhandled_cp_access(vcpu, params);
+	else
+		vcpu_set_reg(vcpu, Rt, params->regval);
+
+	return ret;
+}
+
+/**
+ * kvm_is_cp15_id_reg() - Returns true if the specified CP15 register is an
+ *			  AArch32 ID register.
+ * @params: the system register access parameters
+ *
+ * Note that CP15 ID registers where CRm=0 are excluded from this check, as they
+ * are already correctly handled in the CP15 register table.
+ */
+static inline bool kvm_is_cp15_id_reg(struct sys_reg_params *params)
+{
+	return params->CRn == 0 && params->Op1 == 0 && params->CRm != 0;
+}
+
 /**
  * kvm_handle_cp_32 -- handles a mrc/mcr trap on a guest CP14/CP15 access
  * @vcpu: The VCPU pointer
@@ -2360,6 +2419,13 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 	params.Op1 = (esr >> 14) & 0x7;
 	params.Op2 = (esr >> 17) & 0x7;
 
+	/*
+	 * Certain AArch32 ID registers are handled by rerouting to the AArch64
+	 * system register table.
+	 */
+	if (ESR_ELx_EC(esr) == ESR_ELx_EC_CP15_32 && kvm_is_cp15_id_reg(&params))
+		return kvm_emulate_cp15_id_reg(vcpu, &params);
+
 	if (!emulate_cp(vcpu, &params, global, nr_global)) {
 		if (!params.is_write)
 			vcpu_set_reg(vcpu, Rt, params.regval);
-- 
2.35.1.1021.g381101b075-goog


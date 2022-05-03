Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143A6517CF7
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 08:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiECGF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 02:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiECGFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 02:05:46 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE3C3334F
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 23:02:15 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id l2-20020a17090ad10200b001ca56de815aso723759pju.0
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 23:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kNIvmW+UQg4kyqFomsH3U0dCsHh4hH7Ihe0URim/gjs=;
        b=b8rMBUdg4rhRlWUVQAGU8hwTTgclcE+ZuT0I+HoyfNsYte5xd4WZREks7dSJU2hZMi
         W4nw4EmMJxc4L57f/GjA40yADNMoW/qKH/AkbNYA8gLS+qld7+pQcxsef2BeWecupjTd
         dXe+QrmXQEaFf793D6cRph4IQPhYTGEWOXVq3xNVWZ0yP1wcpHCOQsKJ04G2wiWyPbCt
         gX7KU4MCAOaZjeajKEHSt+YZNLVh2LTypdUfaeGYcMiBoSE7k+/dupBHNZWtdPPoxICl
         gj5s/tyxhC4ZfQMYwMtfRP+bfcTXubHDdnOnOc0Z2il9yqGfAj+XikS3UMysgF9YCBTx
         rsgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kNIvmW+UQg4kyqFomsH3U0dCsHh4hH7Ihe0URim/gjs=;
        b=aJpxN2+0Vq5C5hVcdraw2rGWmNoay89+kSbR4ab5OO+6hxfMJBw+/Wd0f2W4iy6ymt
         cIsBT7MZx/Vn4Gtfq49MSSkfTZBdYJLeBpTJbnZ8CV6dzm96O/EzAb5llOOE6O8RqGJk
         dxNSMgGm2U4MrlYn8/Qinz2xUbSsCaSAwythTrwL3bU4CPmxVLEbYVPjptD6obO4qgzn
         fnHqOuE3JnbBW5LIn8y4byX6k7ZaI4DDigw0n6GZ6SdQNNI7ok9aA5cpMMUUZIRbp32M
         t8IPRAYEn/BIe+JtPvm8YkQux4fPkXHCiwz2CZAAAQt9VFIDeiKGbGEHvLsXBN+8VXhL
         O8dQ==
X-Gm-Message-State: AOAM531IwiMYD3SsKMoj65bWCjVv25g3dvZ6GTo761P5TzWJaNtu1SC7
        SileHsKlTqdPPQvYQG82yFZL4ZJOTRg=
X-Google-Smtp-Source: ABdhPJwhlUbmJ/c+5cel5YbXwoabm+ZFEQDGUQzmk+0Grk7pE6oPCjZRhL0uNrGXFbrQzfvJ7uRjCYQnx/8=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:90a:5407:b0:1bf:43ce:f11b with SMTP id
 z7-20020a17090a540700b001bf43cef11bmr3031142pjh.31.1651557734948; Mon, 02 May
 2022 23:02:14 -0700 (PDT)
Date:   Tue,  3 May 2022 06:02:02 +0000
In-Reply-To: <20220503060205.2823727-1-oupton@google.com>
Message-Id: <20220503060205.2823727-5-oupton@google.com>
Mime-Version: 1.0
References: <20220503060205.2823727-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 4/7] KVM: arm64: Plumb cp10 ID traps through the AArch64
 sysreg handler
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

In order to enable HCR_EL2.TID3 for AArch32 guests KVM needs to handle
traps where ESR_EL2.EC=0x8, which corresponds to an attempted VMRS
access from an ID group register. Specifically, the MVFR{0-2} registers
are accessed this way from AArch32. Conveniently, these registers are
architecturally mapped to MVFR{0-2}_EL1 in AArch64. Furthermore, KVM
already handles reads to these aliases in AArch64.

Plumb VMRS read traps through to the general AArch64 system register
handler.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/handle_exit.c      |  1 +
 arch/arm64/kvm/sys_regs.c         | 71 +++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 94a27a7520f4..05081b9b7369 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -683,6 +683,7 @@ int kvm_handle_cp14_64(struct kvm_vcpu *vcpu);
 int kvm_handle_cp15_32(struct kvm_vcpu *vcpu);
 int kvm_handle_cp15_64(struct kvm_vcpu *vcpu);
 int kvm_handle_sys_reg(struct kvm_vcpu *vcpu);
+int kvm_handle_cp10_id(struct kvm_vcpu *vcpu);
 
 void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 97fe14aab1a3..5088a86ace5b 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -167,6 +167,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_CP15_64]	= kvm_handle_cp15_64,
 	[ESR_ELx_EC_CP14_MR]	= kvm_handle_cp14_32,
 	[ESR_ELx_EC_CP14_LS]	= kvm_handle_cp14_load_store,
+	[ESR_ELx_EC_CP10_ID]	= kvm_handle_cp10_id,
 	[ESR_ELx_EC_CP14_64]	= kvm_handle_cp14_64,
 	[ESR_ELx_EC_HVC32]	= handle_hvc,
 	[ESR_ELx_EC_SMC32]	= handle_smc,
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f403ea47b8a3..586b292ca94f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2346,6 +2346,77 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 
 static bool emulate_sys_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
 
+/*
+ * The CP10 ID registers are architecturally mapped to AArch64 feature
+ * registers. Abuse that fact so we can rely on the AArch64 handler for accesses
+ * from AArch32.
+ */
+static bool kvm_esr_cp10_id_to_sys64(u32 esr, struct sys_reg_params *params)
+{
+	u8 reg_id = (esr >> 10) & 0xf;
+	bool valid;
+
+	params->is_write = ((esr & 1) == 0);
+	params->Op0 = 3;
+	params->Op1 = 0;
+	params->CRn = 0;
+	params->CRm = 3;
+
+	/* CP10 ID registers are read-only */
+	valid = !params->is_write;
+
+	switch (reg_id) {
+	/* MVFR0 */
+	case 0b0111:
+		params->Op2 = 0;
+		break;
+	/* MVFR1 */
+	case 0b0110:
+		params->Op2 = 1;
+		break;
+	/* MVFR2 */
+	case 0b0101:
+		params->Op2 = 2;
+		break;
+	default:
+		valid = false;
+	}
+
+	if (valid)
+		return true;
+
+	kvm_pr_unimpl("Unhandled cp10 register %s: %u\n",
+		      params->is_write ? "write" : "read", reg_id);
+	return false;
+}
+
+/**
+ * kvm_handle_cp10_id() - Handles a VMRS trap on guest access to a 'Media and
+ *			  VFP Register' from AArch32.
+ * @vcpu: The vCPU pointer
+ *
+ * MVFR{0-2} are architecturally mapped to the AArch64 MVFR{0-2}_EL1 registers.
+ * Work out the correct AArch64 system register encoding and reroute to the
+ * AArch64 system register emulation.
+ */
+int kvm_handle_cp10_id(struct kvm_vcpu *vcpu)
+{
+	int Rt = kvm_vcpu_sys_get_rt(vcpu);
+	u32 esr = kvm_vcpu_get_esr(vcpu);
+	struct sys_reg_params params;
+
+	/* UNDEF on any unhandled register access */
+	if (!kvm_esr_cp10_id_to_sys64(esr, &params)) {
+		kvm_inject_undefined(vcpu);
+		return 1;
+	}
+
+	if (emulate_sys_reg(vcpu, &params))
+		vcpu_set_reg(vcpu, Rt, params.regval);
+
+	return 1;
+}
+
 /**
  * kvm_emulate_cp15_id_reg() - Handles an MRC trap on a guest CP15 access where
  *			       CRn=0, which corresponds to the AArch32 feature
-- 
2.36.0.464.gb9c8b46e94-goog


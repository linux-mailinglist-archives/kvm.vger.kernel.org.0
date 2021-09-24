Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A66A417580
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345112AbhIXNZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345219AbhIXNYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:51 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE26C08EAED
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:13 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id e1-20020adfa741000000b0015e424fdd01so8005898wrd.11
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=c3qdDK6CwCMhdcn2tEJ6TpJKVu10uhj+XXDIPCtJjb0=;
        b=psNFg6nCmH9EU5Pajcz2UKWfcUW6CIkoTg6ob88wrS/HBXB3AkOhMbUc4AFLeMA0Sp
         7lu9JHDpVOWOXTNsn+YcIqR2zulAavdwwQM2YXe6C97wYk874q3MJIcDhun/XPLkM3pd
         aTmQUfLBonBQGjH0b4Xbo57FTjmUG/w7C0EUsuWgalUsbrG9wGYx1riQpbFpAJkE9a9T
         ISA5Y4eXtmuXhHAdn7YguY2m9S7EzU47PoSqQq64YqMpVEJUtiCQNauB8oza5MU9Z9Pp
         DUh1ObVuEjj9HZAXz32oTdLCLWK0TGm4SzdzVB1bDoeIwUh+cRZCmAJP4TcEm0Lov7cg
         ULBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=c3qdDK6CwCMhdcn2tEJ6TpJKVu10uhj+XXDIPCtJjb0=;
        b=OGQY6Y724f3O8R1ewFQCU9QBsWIoc4IYEGfwYu3QRbnZ4Eu0alRCcK9UsEE88w2Sz+
         sV6n9BIU4Id1i0lODUcc86VXWT97MU1UE1HzE+IIzqixD4yluWyK2QnKIGIHvEJDXt0w
         Zloy9bYQjgkLWQZlVC1nSMCqvVmnz27/mp92JO7+uvD+/DK4Ckyt4HzzChnEQSjYR+dV
         KDF1Y2rDY8yKJd+hiWr+mdh9HW+OeNNgFXfQ8l/veeXGBlFyp70PBjvdLxwxqWY6iAOT
         UfmYzjiGIYP8r8jAOHy8yYYc4Ghg2mwTTs+0j4BNHqArWLIl3juwMr54uGN80S7f1iQ/
         vK7w==
X-Gm-Message-State: AOAM532u+ZEyVSBR8eONldJHxb+TWC2Mo2U8tAaWIUxWLTvs0KiSl2/k
        M9vAMw3E/dvI02747tCKH9rxLTWf3A==
X-Google-Smtp-Source: ABdhPJyHSTQAdyddoCnAQ1t8SsXdoW5w2rUjyZviDC87bdJ5+MrSTkFU5/hlW9/ETaN0jl9llsuMltIXvQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:c766:: with SMTP id x6mr1928628wmk.53.1632488052437;
 Fri, 24 Sep 2021 05:54:12 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:34 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-6-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 05/30] KVM: arm64: add accessors for kvm_cpu_context
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add accessors to get/set elements of struct kvm_cpu_context.

Simplifies future refactoring, and makes the code more consistent.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 53 ++++++++++++++++++++++------
 arch/arm64/include/asm/kvm_host.h    | 18 +++++++++-
 arch/arm64/kvm/hyp/exception.c       | 43 +++++++++++++++++-----
 3 files changed, 94 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 01b9857757f2..ad6e53cef1a4 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -127,19 +127,34 @@ static inline void vcpu_set_vsesr(struct kvm_vcpu *vcpu, u64 vsesr)
 	vcpu->arch.vsesr_el2 = vsesr;
 }
 
+static __always_inline unsigned long *ctxt_pc(const struct kvm_cpu_context *ctxt)
+{
+	return (unsigned long *)&ctxt_gp_regs(ctxt)->pc;
+}
+
 static __always_inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
 {
-	return (unsigned long *)&vcpu_gp_regs(vcpu)->pc;
+	return ctxt_pc(&vcpu_ctxt(vcpu));
+}
+
+static __always_inline unsigned long *ctxt_cpsr(const struct kvm_cpu_context *ctxt)
+{
+	return (unsigned long *)&ctxt_gp_regs(ctxt)->pstate;
 }
 
 static __always_inline unsigned long *vcpu_cpsr(const struct kvm_vcpu *vcpu)
 {
-	return (unsigned long *)&vcpu_gp_regs(vcpu)->pstate;
+	return ctxt_cpsr(&vcpu_ctxt(vcpu));
+}
+
+static __always_inline bool ctxt_mode_is_32bit(const struct kvm_cpu_context *ctxt)
+{
+	return !!(*ctxt_cpsr(ctxt) & PSR_MODE32_BIT);
 }
 
 static __always_inline bool vcpu_mode_is_32bit(const struct kvm_vcpu *vcpu)
 {
-	return !!(*vcpu_cpsr(vcpu) & PSR_MODE32_BIT);
+	return ctxt_mode_is_32bit(&vcpu_ctxt(vcpu));
 }
 
 static __always_inline bool kvm_condition_valid(const struct kvm_vcpu *vcpu)
@@ -150,27 +165,45 @@ static __always_inline bool kvm_condition_valid(const struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static inline void ctxt_set_thumb(struct kvm_cpu_context *ctxt)
+{
+	*ctxt_cpsr(ctxt) |= PSR_AA32_T_BIT;
+}
+
 static inline void vcpu_set_thumb(struct kvm_vcpu *vcpu)
 {
-	*vcpu_cpsr(vcpu) |= PSR_AA32_T_BIT;
+	ctxt_set_thumb(&vcpu_ctxt(vcpu));
 }
 
 /*
- * vcpu_get_reg and vcpu_set_reg should always be passed a register number
- * coming from a read of ESR_EL2. Otherwise, it may give the wrong result on
- * AArch32 with banked registers.
+ * vcpu/ctxt_get_reg and vcpu/ctxt_set_reg should always be passed a register
+ * number coming from a read of ESR_EL2. Otherwise, it may give the wrong result
+ * on AArch32 with banked registers.
  */
+static __always_inline unsigned long
+ctxt_get_reg(const struct kvm_cpu_context *ctxt, u8 reg_num)
+{
+	return (reg_num == 31) ? 0 : ctxt_gp_regs(ctxt)->regs[reg_num];
+}
+
+static __always_inline void
+ctxt_set_reg(struct kvm_cpu_context *ctxt, u8 reg_num, unsigned long val)
+{
+	if (reg_num != 31)
+		ctxt_gp_regs(ctxt)->regs[reg_num] = val;
+}
+
 static __always_inline unsigned long vcpu_get_reg(const struct kvm_vcpu *vcpu,
 					 u8 reg_num)
 {
-	return (reg_num == 31) ? 0 : vcpu_gp_regs(vcpu)->regs[reg_num];
+	return ctxt_get_reg(&vcpu_ctxt(vcpu), reg_num);
+
 }
 
 static __always_inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 				unsigned long val)
 {
-	if (reg_num != 31)
-		vcpu_gp_regs(vcpu)->regs[reg_num] = val;
+	ctxt_set_reg(&vcpu_ctxt(vcpu), reg_num, val);
 }
 
 /*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index adb21a7f0891..097e5f533af9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -446,7 +446,23 @@ struct kvm_vcpu_arch {
 #define vcpu_has_ptrauth(vcpu)		false
 #endif
 
-#define vcpu_gp_regs(v)		(&(v)->arch.ctxt.regs)
+#define vcpu_ctxt(vcpu) ((vcpu)->arch.ctxt)
+
+/* VCPU Context accessors (direct) */
+#define ctxt_gp_regs(c)		(&(c)->regs)
+#define ctxt_spsr_abt(c)	(&(c)->spsr_abt)
+#define ctxt_spsr_und(c)	(&(c)->spsr_und)
+#define ctxt_spsr_irq(c)	(&(c)->spsr_irq)
+#define ctxt_spsr_fiq(c)	(&(c)->spsr_fiq)
+#define ctxt_fp_regs(c)		(&(c)->fp_regs)
+
+/* VCPU Context accessors */
+#define vcpu_gp_regs(v)		ctxt_gp_regs(&vcpu_ctxt(v))
+#define vcpu_spsr_abt(v)	ctxt_spsr_abt(&vcpu_ctxt(v))
+#define vcpu_spsr_und(v)	ctxt_spsr_und(&vcpu_ctxt(v))
+#define vcpu_spsr_irq(v)	ctxt_spsr_irq(&vcpu_ctxt(v))
+#define vcpu_spsr_fiq(v)	ctxt_spsr_fiq(&vcpu_ctxt(v))
+#define vcpu_fp_regs(v)		ctxt_fp_regs(&vcpu_ctxt(v))
 
 /*
  * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 11541b94b328..643c5844f684 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -18,43 +18,68 @@
 #error Hypervisor code only!
 #endif
 
-static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
+static inline u64 __ctxt_read_sys_reg(const struct kvm_cpu_context *vcpu_ctxt, int reg)
 {
 	u64 val;
 
 	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
 		return val;
 
-	return __vcpu_sys_reg(vcpu, reg);
+	return ctxt_sys_reg(vcpu_ctxt, reg);
 }
 
-static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
+static inline void __ctxt_write_sys_reg(struct kvm_cpu_context *vcpu_ctxt, u64 val, int reg)
 {
 	if (__vcpu_write_sys_reg_to_cpu(val, reg))
 		return;
 
-	 __vcpu_sys_reg(vcpu, reg) = val;
+	 ctxt_sys_reg(vcpu_ctxt, reg) = val;
 }
 
-static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
+static void __ctxt_write_spsr(struct kvm_cpu_context *vcpu_ctxt, u64 val)
 {
 	write_sysreg_el1(val, SYS_SPSR);
 }
 
-static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
+static void __ctxt_write_spsr_abt(struct kvm_cpu_context *vcpu_ctxt, u64 val)
 {
 	if (has_vhe())
 		write_sysreg(val, spsr_abt);
 	else
-		vcpu->arch.ctxt.spsr_abt = val;
+		*ctxt_spsr_abt(vcpu_ctxt) = val;
 }
 
-static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
+static void __ctxt_write_spsr_und(struct kvm_cpu_context *vcpu_ctxt, u64 val)
 {
 	if (has_vhe())
 		write_sysreg(val, spsr_und);
 	else
-		vcpu->arch.ctxt.spsr_und = val;
+		*ctxt_spsr_und(vcpu_ctxt) = val;
+}
+
+static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
+{
+	return __ctxt_read_sys_reg(&vcpu_ctxt(vcpu), reg);
+}
+
+static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
+{
+	__ctxt_write_sys_reg(&vcpu_ctxt(vcpu), val, reg);
+}
+
+static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
+{
+	__ctxt_write_spsr(&vcpu_ctxt(vcpu), val);
+}
+
+static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
+{
+	__ctxt_write_spsr_abt(&vcpu_ctxt(vcpu), val);
+}
+
+static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
+{
+	__ctxt_write_spsr_und(&vcpu_ctxt(vcpu), val);
 }
 
 /*
-- 
2.33.0.685.g46640cef36-goog


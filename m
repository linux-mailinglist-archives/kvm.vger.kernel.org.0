Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB72E3A80FA
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 15:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhFONnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 09:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbhFONmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 09:42:51 -0400
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE847C061224
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:17 -0700 (PDT)
Received: by mail-wm1-x34a.google.com with SMTP id 18-20020a05600c0252b029019a0ce35d36so522840wmj.4
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1Wmriyk1OkyHf916HajtQUN47VqCEGbBdy7CNNzscrg=;
        b=VtUZSKOkS6UceI4ijJW5thWf/ti2OPA7C+U6i15zx8x/Z+StMWl3IPpd2r2fOJIY1S
         niVVeQhWHr5sV679EKMmrYl9Pj/L8RVD4e5a6h3h/zKVovgAsJ2Rw9WueQOx6FYvGj+/
         g3G96uIWJdUsLQo6teDqIFa5DUhleMOdTclhJNEiLj2BmimTMemJiKDmxsjuUr7omDjZ
         0j4p0EzSXU2HEEqDezF0cauDDf8uFtRY47FODIJrKB953j2Y8xExq2nSxZeq1BZWETzE
         nLetUYm5DjlNGRQq9BPckAwcVdbXSBj9radl0jWTIXO4IdyOcznDOit/XczTLNTJJ5uF
         P2iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1Wmriyk1OkyHf916HajtQUN47VqCEGbBdy7CNNzscrg=;
        b=HKY+dOUM5XuDPapwvYswWlnKwKQBxObQhHQC0igUlgYQzrfLJGAmQZd6TKHC0ZlpLj
         pQgirfhFapdCQyzMYLMgHL6Bcmg99UGv9oBnypdU+02MkNDJaT96plWrznxtQoEJjQt6
         ng1H7673laOpEh9kfrXbjOUXomO6/k578tKbjWdINinfa5ks2hslhis27MPTOVs5lRAO
         zWYwNBdi6+RL+e5bM+DuUZTeprdeYtHY0/1s9xgiFB50HQqIbDM+ipC/xO8QCj+2zWpL
         QuTvaD3ACkEfLNBR+DADRf0fSzoMZIz1j/Czrv/BJ9enrhJ1nQSML4T0QDqQNq1dMdBP
         3nvA==
X-Gm-Message-State: AOAM530xMAowHR5l0IHlFACRCVNqbcgxTeeTyCTjvHGAdsSpTnbbWI0s
        ecVZsqXo6upuxDBXEucCHuswzqFTBA==
X-Google-Smtp-Source: ABdhPJyL7cf8gf/wcPCRTQSqMyiGgh+Xc29p0vNyyZJEys+nrM2vy/ugPT03TxgbqQVLGdCJlmJiCH9gsQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:c24a:: with SMTP id b10mr11398wmj.1.1623764416097;
 Tue, 15 Jun 2021 06:40:16 -0700 (PDT)
Date:   Tue, 15 Jun 2021 14:39:48 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-12-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 11/13] KVM: arm64: Trap access to pVM restricted features
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Trap accesses to restricted features for VMs running in protected
mode.

Access to feature registers are emulated, and only supported
features are exposed to protected VMs.

Accesses to restricted registers as well as restricted
instructions are trapped, and an undefined exception is injected
into the protected guest.

Only affects the functionality of protected VMs. Otherwise,
should not affect non-protected VMs when KVM is running in
protected mode.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |   3 +
 arch/arm64/kvm/hyp/nvhe/switch.c        | 116 +++++++++++++++++++++---
 2 files changed, 105 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index f5d3d1da0aec..d9f087ed6e02 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -33,6 +33,9 @@
 extern struct exception_table_entry __start___kvm_ex_table;
 extern struct exception_table_entry __stop___kvm_ex_table;
 
+int kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu);
+int kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu);
+
 /* Check whether the FP regs were dirtied while in the host-side run loop: */
 static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 967a3ad74fbd..8505201e1cfb 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -34,12 +34,74 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
+/*
+ * Set EL2 configuration registers to trap restricted register accesses and
+ * instructions for protected VMs.
+ *
+ * Should be called right before vcpu entry to restrict its impact only to the
+ * protected guest.
+ */
+static void __activate_traps_pvm(struct kvm_vcpu *vcpu)
+{
+	u64 hcr;
+	u64 mdcr;
+	u64 cptr;
+
+	if (!kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)))
+		return;
+
+	hcr = read_sysreg(hcr_el2);
+	mdcr = read_sysreg(mdcr_el2);
+	cptr = read_sysreg(cptr_el2);
+
+	hcr |= HCR_TID3 |			/* Feature Registers */
+	       HCR_TLOR |			/* LOR */
+	       HCR_RW |	HCR_TID0 |		/* AArch64 EL1 only */
+	       HCR_TERR |			/* RAS */
+	       HCR_TID5 |			/* Memory Tagging */
+	       HCR_TACR | HCR_TIDCP | HCR_TID1; /* Implementation defined */
+
+	hcr &= ~(HCR_DCT | HCR_ATA |	/* Memory Tagging */
+		 HCR_FIEN |		/* RAS */
+		 HCR_AMVOFFEN);		/* Disable AMU register virtualization */
+
+
+	/* Debug and Trace */
+	mdcr |= MDCR_EL2_TDRA | MDCR_EL2_TDA | MDCR_EL2_TDE |
+		MDCR_EL2_TDOSA | MDCR_EL2_TDCC | MDCR_EL2_TTRF |
+		MDCR_EL2_TPM | MDCR_EL2_TPMCR |
+		MDCR_EL2_TPMS; /* SPE */
+
+	mdcr &= ~(MDCR_EL2_HPME | MDCR_EL2_MTPME |		/* PMU */
+		  (MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT));	/* SPE */
+
+	cptr |= CPTR_EL2_TTA |	/* Trace */
+		CPTR_EL2_TAM |	/* AMU */
+		CPTR_EL2_TZ;	/* SVE */
+
+	/*
+	 * Clear res0 bits and set res1 bits to trap potential new features.
+	 * It's not guaranteed, but new features are typically added with the
+	 * trapping value being the inverse of the reserved one.
+	 */
+	hcr &= ~HCR_RES0;
+	mdcr &= ~MDCR_EL2_RES0;
+	cptr &= ~CPTR_NVHE_EL2_RES0;
+	cptr |= CPTR_NVHE_EL2_RES1;
+
+	/*  __deactivate_traps() restores these registers. */
+	write_sysreg(hcr, hcr_el2);
+	write_sysreg(mdcr, mdcr_el2);
+	write_sysreg(cptr, cptr_el2);
+}
+
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
 	___activate_traps(vcpu);
 	__activate_traps_common(vcpu);
+	__activate_traps_pvm(vcpu);
 
 	val = CPTR_EL2_DEFAULT;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TAM;
@@ -165,30 +227,56 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+/**
+ * Handle system register accesses for protected VMs.
+ *
+ * Return 1 if handled, or 0 if not.
+ */
+static int handle_pvm_sys64(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)))
+		return kvm_handle_pvm_sys64(vcpu);
+	else
+		return 0;
+}
+
+/**
+ * Handle restricted feature accesses for protected VMs.
+ *
+ * Return 1 if handled, or 0 if not.
+ */
+static int handle_pvm_restricted(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)))
+		return kvm_handle_pvm_restricted(vcpu);
+	else
+		return 0;
+}
+
 typedef int (*exit_handle_fn)(struct kvm_vcpu *);
 
 static exit_handle_fn hyp_exit_handlers[] = {
-	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[0 ... ESR_ELx_EC_MAX]		= handle_pvm_restricted,
 	[ESR_ELx_EC_WFx]		= NULL,
-	[ESR_ELx_EC_CP15_32]		= NULL,
-	[ESR_ELx_EC_CP15_64]		= NULL,
-	[ESR_ELx_EC_CP14_MR]		= NULL,
-	[ESR_ELx_EC_CP14_LS]		= NULL,
-	[ESR_ELx_EC_CP14_64]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= handle_pvm_restricted,
+	[ESR_ELx_EC_CP15_64]		= handle_pvm_restricted,
+	[ESR_ELx_EC_CP14_MR]		= handle_pvm_restricted,
+	[ESR_ELx_EC_CP14_LS]		= handle_pvm_restricted,
+	[ESR_ELx_EC_CP14_64]		= handle_pvm_restricted,
 	[ESR_ELx_EC_HVC32]		= NULL,
 	[ESR_ELx_EC_SMC32]		= NULL,
 	[ESR_ELx_EC_HVC64]		= NULL,
 	[ESR_ELx_EC_SMC64]		= NULL,
-	[ESR_ELx_EC_SYS64]		= NULL,
-	[ESR_ELx_EC_SVE]		= NULL,
+	[ESR_ELx_EC_SYS64]		= handle_pvm_sys64,
+	[ESR_ELx_EC_SVE]		= handle_pvm_restricted,
 	[ESR_ELx_EC_IABT_LOW]		= NULL,
 	[ESR_ELx_EC_DABT_LOW]		= NULL,
-	[ESR_ELx_EC_SOFTSTP_LOW]	= NULL,
-	[ESR_ELx_EC_WATCHPT_LOW]	= NULL,
-	[ESR_ELx_EC_BREAKPT_LOW]	= NULL,
-	[ESR_ELx_EC_BKPT32]		= NULL,
-	[ESR_ELx_EC_BRK64]		= NULL,
-	[ESR_ELx_EC_FP_ASIMD]		= NULL,
+	[ESR_ELx_EC_SOFTSTP_LOW]	= handle_pvm_restricted,
+	[ESR_ELx_EC_WATCHPT_LOW]	= handle_pvm_restricted,
+	[ESR_ELx_EC_BREAKPT_LOW]	= handle_pvm_restricted,
+	[ESR_ELx_EC_BKPT32]		= handle_pvm_restricted,
+	[ESR_ELx_EC_BRK64]		= handle_pvm_restricted,
+	[ESR_ELx_EC_FP_ASIMD]		= handle_pvm_restricted,
 	[ESR_ELx_EC_PAC]		= NULL,
 };
 
-- 
2.32.0.272.g935e593368-goog


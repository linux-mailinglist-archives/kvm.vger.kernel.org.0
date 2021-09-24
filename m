Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F95C417585
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345345AbhIXNZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345221AbhIXNYy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:54 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CFCC08EAF7
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:24 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id e6-20020a0cb446000000b0037eeb9851dfso30074639qvf.17
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Q3Qv5RrzIkzZKkPoa+t7yuRspw6lMoesSpU7KdXvcDY=;
        b=eyhYeIi0Yc+OpQ4WMWB6cehoP4mjxRW0OT/gINGnW1NX3nKXLh6PloH1z7YXRhLRXD
         peezCPobScU708l00p9f5m1T/VHFeVITDCk9WMh1QSAlfuJK+hrFj7DW3hxAuc46fN2Z
         F0kdWLjOE7agAn61bsssc7wGH5Qh4UWbFVUVFIZSbb7sZlE9xdGK0ta7jvigzphojt91
         Jln4/X0wiH2ePbGsLP+kpJpWcswJzPsJS4Gbx3RnsC+83ctbyj+FXU+ucwZ5bY3f8pPw
         4jaOO/FpP64PazSutjAhS86CC3QUmA6kgPtAYkIFkwb5jSW4fMZWarD6aA5DcqW/3Niu
         yYLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Q3Qv5RrzIkzZKkPoa+t7yuRspw6lMoesSpU7KdXvcDY=;
        b=wlc2aR/UMVlClq3KQHLEnPcK5nBMCld/9XC6/FWL9CxRrJqMhyK/nRb0lCJoupa5kK
         vPFnEWGr7UZqn+oD/Yo/tkSw8eHQ/dMfzOaZ0AjhE8Ukz9pbHTMtdNhwM+TVWX1LJJG/
         o6+sJFR9VB3lbWdccCUVS1E0Ezb+PwP6GgQBmTet+V1HmOMaeyyctYD4IT7tr1LyQ13r
         otnVTGxmxXpY7ly03RgMPBypDJDQnF9sM1X9I56cod+FdbeolGu750+Fczmc8nE5iiWu
         /2LuQb+bjMef46RdndZ6Gx5KtVIhoCqlbt09M7MVk58eXqfKNjhUR6kdPNTF3Yk+38/s
         v4dQ==
X-Gm-Message-State: AOAM531fGqEssewMEJLGkAgB1Ur7syyeT32uMYpYc+13zo4J8kHuf0Jj
        T/xDZJsa8Debok1O5Y8m3LyJX1JqaQ==
X-Google-Smtp-Source: ABdhPJy8hgrd2LxFyAX4SBH6cSNpiZRm1qTOTY9PtiLzl1pzwOaYr+Q+gCysP0BQDCTLObyPCMlvgepQPg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:1430:: with SMTP id
 o16mr9792074qvx.66.1632488063188; Fri, 24 Sep 2021 05:54:23 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:39 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-11-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 10/30] KVM: arm64: Add accessors for hypervisor state
 in kvm_vcpu_arch
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

Some of the members of vcpu_arch represent state that belongs to
the hypervisor. Future patches will factor these out into their
own structure. To simplify the refactoring and make it easier to
read, add accessors for the members of kvm_vcpu_arch that
represent the hypervisor state.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 182 ++++++++++++++++++++++-----
 arch/arm64/include/asm/kvm_host.h    |  38 ++++--
 2 files changed, 181 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 7d09a9356d89..e095afeecd10 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -41,9 +41,14 @@ void kvm_inject_vabt(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 
+static __always_inline bool hyp_state_el1_is_32bit(struct vcpu_hyp_state *vcpu_hyps)
+{
+	return !(hyp_state_hcr_el2(vcpu_hyps) & HCR_RW);
+}
+
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
-	return !(vcpu_hcr_el2(vcpu) & HCR_RW);
+	return hyp_state_el1_is_32bit(&hyp_state(vcpu));
 }
 
 static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
@@ -252,14 +257,19 @@ static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
 	return mode != PSR_MODE_EL0t;
 }
 
+static __always_inline u32 kvm_hyp_state_get_esr(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return hyp_state_fault(vcpu_hyps).esr_el2;
+}
+
 static __always_inline u32 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
 {
-	return vcpu_fault(vcpu).esr_el2;
+	return kvm_hyp_state_get_esr(&hyp_state(vcpu));
 }
 
-static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
+static __always_inline u32 kvm_hyp_state_get_condition(const struct vcpu_hyp_state *vcpu_hyps)
 {
-	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u32 esr = kvm_hyp_state_get_esr(vcpu_hyps);
 
 	if (esr & ESR_ELx_CV)
 		return (esr & ESR_ELx_COND_MASK) >> ESR_ELx_COND_SHIFT;
@@ -267,111 +277,216 @@ static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
 	return -1;
 }
 
+static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
+{
+	return kvm_hyp_state_get_condition(&hyp_state(vcpu));
+}
+
+static __always_inline phys_addr_t kvm_hyp_state_get_hfar(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return hyp_state_fault(vcpu_hyps).far_el2;
+}
+
 static __always_inline unsigned long kvm_vcpu_get_hfar(const struct kvm_vcpu *vcpu)
 {
-	return vcpu_fault(vcpu).far_el2;
+	return kvm_hyp_state_get_hfar(&hyp_state(vcpu));
+}
+
+static __always_inline phys_addr_t kvm_hyp_state_get_fault_ipa(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return ((phys_addr_t) hyp_state_fault(vcpu_hyps).hpfar_el2 & HPFAR_MASK) << 8;
 }
 
 static __always_inline phys_addr_t kvm_vcpu_get_fault_ipa(const struct kvm_vcpu *vcpu)
 {
-	return ((phys_addr_t) vcpu_fault(vcpu).hpfar_el2 & HPFAR_MASK) << 8;
+	return kvm_hyp_state_get_fault_ipa(&hyp_state(vcpu));
+}
+
+static __always_inline u32 kvm_hyp_state_get_disr(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return hyp_state_fault(vcpu_hyps).disr_el1;
 }
 
 static inline u64 kvm_vcpu_get_disr(const struct kvm_vcpu *vcpu)
 {
-	return vcpu_fault(vcpu).disr_el1;
+	return kvm_hyp_state_get_disr(&hyp_state(vcpu));
+}
+
+static __always_inline u32 kvm_hyp_state_get_imm(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return kvm_hyp_state_get_esr(vcpu_hyps) & ESR_ELx_xVC_IMM_MASK;
 }
 
 static inline u32 kvm_vcpu_hvc_get_imm(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_xVC_IMM_MASK;
+	return kvm_hyp_state_get_imm(&hyp_state(vcpu));
+}
+
+static __always_inline u32 kvm_hyp_state_dabt_isvalid(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return !!(kvm_hyp_state_get_esr(vcpu_hyps) & ESR_ELx_ISV);
 }
 
 static __always_inline bool kvm_vcpu_dabt_isvalid(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_ISV);
+	return kvm_hyp_state_dabt_isvalid(&hyp_state(vcpu));
+}
+
+static __always_inline u32 kvm_hyp_state_iss_nisv_sanitized(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return kvm_hyp_state_get_esr(vcpu_hyps) & (ESR_ELx_CM | ESR_ELx_WNR | ESR_ELx_FSC);
 }
 
 static inline unsigned long kvm_vcpu_dabt_iss_nisv_sanitized(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_get_esr(vcpu) & (ESR_ELx_CM | ESR_ELx_WNR | ESR_ELx_FSC);
+	return kvm_hyp_state_iss_nisv_sanitized(&hyp_state(vcpu));
+}
+
+static __always_inline u32 kvm_hyp_state_issext(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return !!(kvm_hyp_state_get_esr(vcpu_hyps) & ESR_ELx_SSE);
 }
 
 static inline bool kvm_vcpu_dabt_issext(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_SSE);
+	return kvm_hyp_state_issext(&hyp_state(vcpu));
+}
+
+static __always_inline u32 kvm_hyp_state_issf(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return !!(kvm_hyp_state_get_esr(vcpu_hyps) & ESR_ELx_SF);
 }
 
 static inline bool kvm_vcpu_dabt_issf(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_SF);
+	return kvm_hyp_state_issf(&hyp_state(vcpu));
+}
+
+static __always_inline phys_addr_t kvm_hyp_state_dabt_get_rd(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return (kvm_hyp_state_get_esr(vcpu_hyps) & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
 }
 
 static __always_inline int kvm_vcpu_dabt_get_rd(const struct kvm_vcpu *vcpu)
 {
-	return (kvm_vcpu_get_esr(vcpu) & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
+	return kvm_hyp_state_dabt_get_rd(&hyp_state(vcpu));
+}
+
+static __always_inline u32 kvm_hyp_state_abt_iss1tw(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return !!(kvm_hyp_state_get_esr(vcpu_hyps) & ESR_ELx_S1PTW);
 }
 
 static __always_inline bool kvm_vcpu_abt_iss1tw(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_S1PTW);
+	return kvm_hyp_state_abt_iss1tw(&hyp_state(vcpu));
 }
 
 /* Always check for S1PTW *before* using this. */
+static __always_inline u32 kvm_hyp_state_dabt_iswrite(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return kvm_hyp_state_get_esr(vcpu_hyps) & ESR_ELx_WNR;
+}
+
 static __always_inline bool kvm_vcpu_dabt_iswrite(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_WNR;
+	return kvm_hyp_state_dabt_iswrite(&hyp_state(vcpu));
+}
+
+static __always_inline u32 kvm_hyp_state_dabt_is_cm(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return !!(kvm_hyp_state_get_esr(vcpu_hyps) & ESR_ELx_CM);
 }
 
 static inline bool kvm_vcpu_dabt_is_cm(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_CM);
+	return kvm_hyp_state_dabt_is_cm(&hyp_state(vcpu));
+}
+
+static __always_inline phys_addr_t kvm_hyp_state_dabt_get_as(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return 1 << ((kvm_hyp_state_get_esr(vcpu_hyps) & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
 }
 
 static __always_inline unsigned int kvm_vcpu_dabt_get_as(const struct kvm_vcpu *vcpu)
 {
-	return 1 << ((kvm_vcpu_get_esr(vcpu) & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
+	return kvm_hyp_state_dabt_get_as(&hyp_state(vcpu));
 }
 
 /* This one is not specific to Data Abort */
+static __always_inline u32 kvm_hyp_state_trap_il_is32bit(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return !!(kvm_hyp_state_get_esr(vcpu_hyps) & ESR_ELx_IL);
+}
+
 static __always_inline bool kvm_vcpu_trap_il_is32bit(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_IL);
+	return kvm_hyp_state_trap_il_is32bit(&hyp_state(vcpu));
+}
+
+static __always_inline u32 kvm_hyp_state_trap_get_class(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return ESR_ELx_EC(kvm_hyp_state_get_esr(vcpu_hyps));
 }
 
 static __always_inline u8 kvm_vcpu_trap_get_class(const struct kvm_vcpu *vcpu)
 {
-	return ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
+	return kvm_hyp_state_trap_get_class(&hyp_state(vcpu));
+}
+
+static __always_inline u32 kvm_hyp_state_trap_is_iabt(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return kvm_hyp_state_trap_get_class(vcpu_hyps) == ESR_ELx_EC_IABT_LOW;
 }
 
 static inline bool kvm_vcpu_trap_is_iabt(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_IABT_LOW;
+	return kvm_hyp_state_trap_is_iabt(&hyp_state(vcpu));
+}
+
+static __always_inline u32 kvm_hyp_state_trap_is_exec_fault(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return kvm_hyp_state_trap_is_iabt(vcpu_hyps) && !kvm_hyp_state_abt_iss1tw(vcpu_hyps);
 }
 
 static inline bool kvm_vcpu_trap_is_exec_fault(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_trap_is_iabt(vcpu) && !kvm_vcpu_abt_iss1tw(vcpu);
+	return kvm_hyp_state_trap_is_exec_fault(&hyp_state(vcpu));
+}
+
+static __always_inline u32 kvm_hyp_state_trap_get_fault(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return kvm_hyp_state_get_esr(vcpu_hyps) & ESR_ELx_FSC;
 }
 
 static __always_inline u8 kvm_vcpu_trap_get_fault(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC;
+	return kvm_hyp_state_trap_get_fault(&hyp_state(vcpu));
+}
+
+static __always_inline u32 kvm_hyp_state_trap_get_fault_type(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return kvm_hyp_state_get_esr(vcpu_hyps) & ESR_ELx_FSC_TYPE;
 }
 
 static __always_inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_TYPE;
+	return kvm_hyp_state_trap_get_fault_type(&hyp_state(vcpu));
+}
+
+static __always_inline u32 kvm_hyp_state_trap_get_fault_level(const struct vcpu_hyp_state *vcpu_hyps)
+{
+	return kvm_hyp_state_get_esr(vcpu_hyps) & ESR_ELx_FSC_LEVEL;
 }
 
 static __always_inline u8 kvm_vcpu_trap_get_fault_level(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_LEVEL;
+	return kvm_hyp_state_trap_get_fault_level(&hyp_state(vcpu));
 }
 
-static __always_inline bool kvm_vcpu_abt_issea(const struct kvm_vcpu *vcpu)
+static __always_inline u32 kvm_hyp_state_abt_issea(const struct vcpu_hyp_state *vcpu_hyps)
 {
-	switch (kvm_vcpu_trap_get_fault(vcpu)) {
+	switch (kvm_hyp_state_trap_get_fault(vcpu_hyps)) {
 	case FSC_SEA:
 	case FSC_SEA_TTW0:
 	case FSC_SEA_TTW1:
@@ -388,12 +503,23 @@ static __always_inline bool kvm_vcpu_abt_issea(const struct kvm_vcpu *vcpu)
 	}
 }
 
-static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
+static __always_inline bool kvm_vcpu_abt_issea(const struct kvm_vcpu *vcpu)
+{
+	return kvm_hyp_state_abt_issea(&hyp_state(vcpu));
+}
+
+static __always_inline u32 kvm_hyp_state_sys_get_rt(const struct vcpu_hyp_state *vcpu_hyps)
 {
-	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u32 esr = kvm_hyp_state_get_esr(vcpu_hyps);
 	return ESR_ELx_SYS64_ISS_RT(esr);
 }
 
+
+static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
+{
+	return kvm_hyp_state_sys_get_rt(&hyp_state(vcpu));
+}
+
 static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_abt_iss1tw(vcpu))
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 280ee23dfc5a..3e5c173d2360 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -373,12 +373,21 @@ struct kvm_vcpu_arch {
 	} steal;
 };
 
+#define hyp_state(vcpu) ((vcpu)->arch)
+
+/* Accessors for hyp_state parameters related to the hypervistor state. */
+#define hyp_state_hcr_el2(hyps) (hyps)->hcr_el2
+#define hyp_state_mdcr_el2(hyps) (hyps)->mdcr_el2
+#define hyp_state_vsesr_el2(hyps) (hyps)->vsesr_el2
+#define hyp_state_fault(hyps) (hyps)->fault
+#define hyp_state_flags(hyps) (hyps)->flags
+
 /* Accessors for vcpu parameters related to the hypervistor state. */
-#define vcpu_hcr_el2(vcpu) (vcpu)->arch.hcr_el2
-#define vcpu_mdcr_el2(vcpu) (vcpu)->arch.mdcr_el2
-#define vcpu_vsesr_el2(vcpu) (vcpu)->arch.vsesr_el2
-#define vcpu_fault(vcpu) (vcpu)->arch.fault
-#define vcpu_flags(vcpu) (vcpu)->arch.flags
+#define vcpu_hcr_el2(vcpu) hyp_state_hcr_el2(&hyp_state(vcpu))
+#define vcpu_mdcr_el2(vcpu) hyp_state_mdcr_el2(&hyp_state(vcpu))
+#define vcpu_vsesr_el2(vcpu) hyp_state_vsesr_el2(&hyp_state(vcpu))
+#define vcpu_fault(vcpu) hyp_state_fault(&hyp_state(vcpu))
+#define vcpu_flags(vcpu) hyp_state_flags(&hyp_state(vcpu))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
@@ -441,18 +450,22 @@ struct kvm_vcpu_arch {
  */
 #define KVM_ARM64_INCREMENT_PC		(1 << 9) /* Increment PC */
 
-#define vcpu_has_sve(vcpu) (system_supports_sve() &&			\
-			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
+#define hyp_state_has_sve(hyps) (system_supports_sve() &&		\
+			    (hyp_state_flags((hyps)) & KVM_ARM64_GUEST_HAS_SVE))
+
+#define vcpu_has_sve(vcpu) hyp_state_has_sve(&hyp_state(vcpu))
 
 #ifdef CONFIG_ARM64_PTR_AUTH
-#define vcpu_has_ptrauth(vcpu)						\
+#define hyp_state_has_ptrauth(hyps)					\
 	((cpus_have_final_cap(ARM64_HAS_ADDRESS_AUTH) ||		\
 	  cpus_have_final_cap(ARM64_HAS_GENERIC_AUTH)) &&		\
-	 (vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH)
+	 hyp_state_flags(hyps) & KVM_ARM64_GUEST_HAS_PTRAUTH)
 #else
-#define vcpu_has_ptrauth(vcpu)		false
+#define hyp_state_has_ptrauth(hyps)		false
 #endif
 
+#define vcpu_has_ptrauth(vcpu)	hyp_state_has_ptrauth(&hyp_state(vcpu))
+
 #define vcpu_ctxt(vcpu) ((vcpu)->arch.ctxt)
 
 /* VCPU Context accessors (direct) */
@@ -794,8 +807,11 @@ static inline bool kvm_vm_is_protected(struct kvm *kvm)
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
+#define kvm_arm_hyp_state_sve_finalized(hyps) \
+	(hyp_state_flags((hyps)) & KVM_ARM64_VCPU_SVE_FINALIZED)
+
 #define kvm_arm_vcpu_sve_finalized(vcpu) \
-	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
+	kvm_arm_hyp_state_sve_finalized(&hyp_state(vcpu))
 
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
-- 
2.33.0.685.g46640cef36-goog


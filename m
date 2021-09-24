Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2647417586
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345170AbhIXNZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345558AbhIXNYy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:54 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFBBC08EAF9
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:26 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id u22-20020a05620a431600b0045dcc8487daso1143812qko.6
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LZOV2dq//fdarSZ1UQXRXLqBKRPy36MQCgMnGFxeKiY=;
        b=i7wNsSyEZO3Xlq4SY8WT2jMhEBq6yM4BseM6UxtVbhob5zKaZA1doTwn0DklaFJS2J
         LjLo/74OYhBloKd6aumy8koxoHfNV7/DYJzKOeMqQ65NyinAyxqchr5aDy0CYpDfOw3t
         JM2pDEncfpfat3Mbl+MfvITadVXzbrAUxqM69iij9wjqJ+8GPmmWmw86KHpz6RuUYLq/
         bt7kxSeLwbBL2g8F9PT4IrcOvb1n3g5mAneeZ2GG+fnnw4rWmPYIEbRrY2TEHKTtuZcC
         fCpIu4w6jLfF+Eaqz8z6+bgq8cwl75ERIOks6W689Aq7x5XtM7RrPYZzgBTyOtyEjH7L
         yyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LZOV2dq//fdarSZ1UQXRXLqBKRPy36MQCgMnGFxeKiY=;
        b=dlk4tlPzEe/KfsZWoA+gRLAVI5xGApPYK9WZ2pyZSAiamJr12oEpuQZYnJHVOotvxY
         aFBlcpwHrFXkvxBm5Jt4WQHssGQ3CCkZLGf+iG2G4cx0G0nyRy91puGQiC+O5kXy3JQQ
         ++TfSzd3EdbDBKq4RuEloPyFdU2g4qHi8AzKokgTSqx9HNkiO/kRMmmkyJaiHL/AOpi4
         RpSRrLCBMM8Fgh4FTfMuqJfeoCWMDNAQ6fvsBU4d74N4lw5hJhYhynHwTia2tm/ZGCxX
         dffCCywSg/ZcqdEjUP7enATAb4Au56voHFODwfGBqXfDG1pzpKG3GsTnr3evEMfj0bkO
         I0Eg==
X-Gm-Message-State: AOAM533EuP7/lGfF7R9YruIRw/rThUj3zcLcUpI4vvo3jeKXsmP+OM/+
        DQH/LGnn6wRPuhzVLNMb9pzpIUIa9A==
X-Google-Smtp-Source: ABdhPJyiUxiESUbsfUSqdfuMXJkScSsmcEa94A8nBj+cCsvl5tfCKO45MzFdUPEtgqstBChxPe4XLicMqw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:1022:: with SMTP id
 k2mr102283qvr.53.1632488065246; Fri, 24 Sep 2021 05:54:25 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:40 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-12-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 11/30] KVM: arm64: create and use a new vcpu_hyp_state struct
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

Create a struct for the hypervisor state from the related fields
in vcpu_arch. This is needed in future patches to reduce the
scope of functions from the vcpu as a whole to only the relevant
state, via this newly created struct.

Create a new instance of this struct in vcpu_arch and fix the
accessors to use the new fields. Remove the existing fields from
vcpu_arch.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 35 ++++++++++++++++++-------------
 arch/arm64/kernel/asm-offsets.c   |  2 +-
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3e5c173d2360..dc4b5e133d86 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -269,27 +269,35 @@ struct vcpu_reset_state {
 	bool		reset;
 };
 
+/* Holds the hyp-relevant data of a vcpu.*/
+struct vcpu_hyp_state {
+	/* HYP configuration */
+	u64 hcr_el2;
+	u32 mdcr_el2;
+
+	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
+	u64 vsesr_el2;
+
+	/* Exception Information */
+	struct kvm_vcpu_fault_info fault;
+
+	/* Miscellaneous vcpu state flags */
+	u64 flags;
+};
+
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 	void *sve_state;
 	unsigned int sve_max_vl;
 
+	struct vcpu_hyp_state hyp_state;
+
 	/* Stage 2 paging state used by the hardware on next switch */
 	struct kvm_s2_mmu *hw_mmu;
 
-	/* HYP configuration */
-	u64 hcr_el2;
-	u32 mdcr_el2;
-
-	/* Exception Information */
-	struct kvm_vcpu_fault_info fault;
-
 	/* State of various workarounds, see kvm_asm.h for bit assignment */
 	u64 workaround_flags;
 
-	/* Miscellaneous vcpu state flags */
-	u64 flags;
-
 	/*
 	 * We maintain more than a single set of debug registers to support
 	 * debugging the guest from the host and to maintain separate host and
@@ -356,9 +364,6 @@ struct kvm_vcpu_arch {
 	/* Detect first run of a vcpu */
 	bool has_run_once;
 
-	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
-	u64 vsesr_el2;
-
 	/* Additional reset state */
 	struct vcpu_reset_state	reset_state;
 
@@ -373,7 +378,7 @@ struct kvm_vcpu_arch {
 	} steal;
 };
 
-#define hyp_state(vcpu) ((vcpu)->arch)
+#define hyp_state(vcpu) ((vcpu)->arch.hyp_state)
 
 /* Accessors for hyp_state parameters related to the hypervistor state. */
 #define hyp_state_hcr_el2(hyps) (hyps)->hcr_el2
@@ -633,7 +638,7 @@ void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
 #ifndef __KVM_NVHE_HYPERVISOR__
-#define kvm_call_hyp_nvhe(f, ...)						\
+#define kvm_call_hyp_nvhe(f, ...)					\
 	({								\
 		struct arm_smccc_res res;				\
 									\
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index c2cc3a2813e6..1776efc3cc9d 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -107,7 +107,7 @@ int main(void)
   BLANK();
 #ifdef CONFIG_KVM
   DEFINE(VCPU_CONTEXT,		offsetof(struct kvm_vcpu, arch.ctxt));
-  DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
+  DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.hyp_state.fault.disr_el1));
   DEFINE(VCPU_WORKAROUND_FLAGS,	offsetof(struct kvm_vcpu, arch.workaround_flags));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_cpu_context, regs));
   DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIAKEYLO_EL1]));
-- 
2.33.0.685.g46640cef36-goog


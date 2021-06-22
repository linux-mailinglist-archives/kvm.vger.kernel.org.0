Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC90B3B0C18
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhFVSCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbhFVSBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:01:31 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8A4C06114C
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:42 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id c3-20020a37b3030000b02903ad0001a2e8so19024278qkf.3
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uVkGf2uzZgS3tEPT7EpWNxKvNU7O+79uJa1mHHSjgeI=;
        b=LztvxDinNhi7QJ0GKXdT+3jSiaw1qx/rK9xIwx6lEyS6S0dqw3hy8rbGDquMwozw6O
         icmZoiOR4DcJmpBJUcypxQd8xDNJwjHrsMcLnCkqyxbpVE02Ll9cRQhhvC8r2z6mfkwe
         Eorcy6QwaXn0odd28qFnpd2zxYgAV9NyViT8zC0wysWZ6d2cG8G7q7TcinUod3rOj+d/
         eIpFRqy9CkXqjfosYszhu4h0uelDYynrjb3HS4uavjY0/kfuwHyJgU9OvHCg9WwScgjH
         YY+uMST8ElyxH169UJTraxOykxZdJmSFzq18VElct6irjw+Q/rrlfE7TOUH4QqgBKep/
         kaig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uVkGf2uzZgS3tEPT7EpWNxKvNU7O+79uJa1mHHSjgeI=;
        b=ZmfRbYWlr9Qs2X/cOQhCw5ZdK9yjeJpHmELoJ1koYd0DXMPtrooJNR9Dolkuiv8HF3
         ajH76HLKvZmWNfBBoAEloFn+ZQQBP2OphjemQSvZ9lUFgztcl65B58SP1WV+1KsOlt0P
         Q1BvrLgpigNyS7bRxrlWLw+0elLGllTZYpYTRssMJEHZsx9IsqgdqLmVjUvWu34kfZ9Q
         r9wntLH/HDTq2Xe+pJqdB1NFxtT8T0pvpQzdJvDu2wI1DwlmI5Mfe1XadMxsi5sBBQHk
         GzNi/RcFGXFyNA0Z+aDQCc1CVxjWLmMRD5F46Lr29Ww8CwALlnXeeYmk/Ef250eipxcZ
         8iAA==
X-Gm-Message-State: AOAM532PHL31pgM7wEEO4212FYiwM40RJupZBrh7KFGQSTCTfzqtsR1e
        QGv0YxyfH9ECkcFC8U+APY8prel/paw=
X-Google-Smtp-Source: ABdhPJzFq/Yzp0nWNjquVeWvLNryMHrezu/m4McgdBNBqWieTYPhl/X7abI0Y5s8nj6wZZW9nNZZ4F1hBSU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:6d88:: with SMTP id i130mr6407406ybc.435.1624384721824;
 Tue, 22 Jun 2021 10:58:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:05 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-21-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 20/54] KVM: x86/mmu: Add struct and helpers to retrieve MMU
 role bits from regs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce "struct kvm_mmu_role_regs" to hold the register state that is
incorporated into the mmu_role.  For nested TDP, the register state that
is factored into the MMU isn't vCPU state; the dedicated struct will be
used to propagate the correct state throughout the flows without having
to pass multiple params, and also provides helpers for the various flag
accessors.

Intentionally make the new helpers cumbersome/ugly by prepending four
underscores.  In the not-too-distant future, it will be preferable to use
the mmu_role to query bits as the mmu_role can drop irrelevant bits
without creating contradictions, e.g. clearing CR4 bits when CR0.PG=0.
Reserve the clean helper names (no underscores) for the mmu_role.

Add a helper for vCPU conversion, which is the common case.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 66 +++++++++++++++++++++++++++++++++---------
 1 file changed, 53 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5e3ee4aba2ff..3616c3b7618e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -176,9 +176,46 @@ static void mmu_spte_set(u64 *sptep, u64 spte);
 static union kvm_mmu_page_role
 kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
 
+struct kvm_mmu_role_regs {
+	const unsigned long cr0;
+	const unsigned long cr4;
+	const u64 efer;
+};
+
 #define CREATE_TRACE_POINTS
 #include "mmutrace.h"
 
+/*
+ * Yes, lot's of underscores.  They're a hint that you probably shouldn't be
+ * reading from the role_regs.  Once the mmu_role is constructed, it becomes
+ * the single source of truth for the MMU's state.
+ */
+#define BUILD_MMU_ROLE_REGS_ACCESSOR(reg, name, flag)			\
+static inline bool ____is_##reg##_##name(struct kvm_mmu_role_regs *regs)\
+{									\
+	return !!(regs->reg & flag);					\
+}
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr0, pg, X86_CR0_PG);
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr0, wp, X86_CR0_WP);
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pse, X86_CR4_PSE);
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pae, X86_CR4_PAE);
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, smep, X86_CR4_SMEP);
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, smap, X86_CR4_SMAP);
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pke, X86_CR4_PKE);
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, la57, X86_CR4_LA57);
+BUILD_MMU_ROLE_REGS_ACCESSOR(efer, nx, EFER_NX);
+BUILD_MMU_ROLE_REGS_ACCESSOR(efer, lma, EFER_LMA);
+
+struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu_role_regs regs = {
+		.cr0 = kvm_read_cr0_bits(vcpu, KVM_MMU_CR0_ROLE_BITS),
+		.cr4 = kvm_read_cr4_bits(vcpu, KVM_MMU_CR4_ROLE_BITS),
+		.efer = vcpu->arch.efer,
+	};
+
+	return regs;
+}
 
 static inline bool kvm_available_flush_tlb_with_range(void)
 {
@@ -4654,14 +4691,14 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
 }
 
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
-				    unsigned long cr0, unsigned long cr4,
-				    u64 efer, union kvm_mmu_role new_role)
+				    struct kvm_mmu_role_regs *regs,
+				    union kvm_mmu_role new_role)
 {
-	if (!(cr0 & X86_CR0_PG))
+	if (!____is_cr0_pg(regs))
 		nonpaging_init_context(vcpu, context);
-	else if (efer & EFER_LMA)
+	else if (____is_efer_lma(regs))
 		paging64_init_context(vcpu, context);
-	else if (cr4 & X86_CR4_PAE)
+	else if (____is_cr4_pae(regs))
 		paging32E_init_context(vcpu, context);
 	else
 		paging32_init_context(vcpu, context);
@@ -4672,15 +4709,15 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 	reset_shadow_zero_bits_mask(vcpu, context);
 }
 
-static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
-				unsigned long cr4, u64 efer)
+static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
+				struct kvm_mmu_role_regs *regs)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role new_role =
 		kvm_calc_shadow_mmu_root_page_role(vcpu, false);
 
 	if (new_role.as_u64 != context->mmu_role.as_u64)
-		shadow_mmu_init_context(vcpu, context, cr0, cr4, efer, new_role);
+		shadow_mmu_init_context(vcpu, context, regs, new_role);
 }
 
 static union kvm_mmu_role
@@ -4699,12 +4736,17 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 			     unsigned long cr4, u64 efer, gpa_t nested_cr3)
 {
 	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
+	struct kvm_mmu_role_regs regs = {
+		.cr0 = cr0,
+		.cr4 = cr4,
+		.efer = efer,
+	};
 	union kvm_mmu_role new_role = kvm_calc_shadow_npt_root_page_role(vcpu);
 
 	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
 
 	if (new_role.as_u64 != context->mmu_role.as_u64)
-		shadow_mmu_init_context(vcpu, context, cr0, cr4, efer, new_role);
+		shadow_mmu_init_context(vcpu, context, &regs, new_role);
 
 	/*
 	 * Redo the shadow bits, the reset done by shadow_mmu_init_context()
@@ -4773,11 +4815,9 @@ EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
+	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
 
-	kvm_init_shadow_mmu(vcpu,
-			    kvm_read_cr0_bits(vcpu, KVM_MMU_CR0_ROLE_BITS),
-			    kvm_read_cr4_bits(vcpu, KVM_MMU_CR4_ROLE_BITS),
-			    vcpu->arch.efer);
+	kvm_init_shadow_mmu(vcpu, &regs);
 
 	context->get_guest_pgd     = get_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
-- 
2.32.0.288.g62a8d224e6-goog


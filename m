Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80633B0C4D
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbhFVSFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbhFVSFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:05:04 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2FAC0698D0
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:38 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id v134-20020a37618c0000b02902fa5329f2b4so4596807qkb.18
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9EgKKDv2eyneOWnDUXvhkE8EvMv/2XlNSaE/g3GbCnE=;
        b=VgzhmExW5EWuOBKT8sYAyFXZVRqLUl3y74ZsDuEycV0aKwNhv/+M2Lf7Vw1MhxexqH
         iw3z/0+TAui+mk9IOpFB9TNgCvGU0hZeflavWWRrwR4rkKx9BUqBk9oc2MT+reARIgLt
         XPLYB30cn7u4MLvl4n7l7KkRlm+54aCXY1c+O1nMX+i8bHUO2IzDV9KU9pIJ3Yzkmd/0
         bd4Skjut5EmowCr1Fvzh64WLqos6BptkUrGPWpFGQSFu8A2242F/E/5y7MVVzcLD/4Yr
         V0XhP/AgnY5okYxC20/b8tGNl2FTIzw26BLf12be9cgHaAbb/tbl8I1UgFjjYQCb7+NC
         6wtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9EgKKDv2eyneOWnDUXvhkE8EvMv/2XlNSaE/g3GbCnE=;
        b=njpPTDWONZJAFwoI3T3ezF8pic//sPVPhMgdrtX/ISc3pfRGTpH+gsgBU/EFKlcwwF
         uMJ1KYumWmb0HYRlpLXgIqtY6T/KiUCfCe1ja7v4NClWKIpC3W1KgdWrmLmo7fmwOikc
         x0et0nGtO7yGfjgu/621QLYHmzr1RJz76Vh/2czU+NU48+u7GA8uKIlgqWbWG+IiTvoo
         TpmGVfCz9LYpaMsifwTD4Kz9XRdWIXCDJV1hsxvd1vGkIDDbaZ5JCKQIxl/MiwSwwUrz
         afx/TfFZ99rNdOuMpDOUU1mzrD/OnbJ4HtmqLqX8JvrXDEXLqy3ppeGkNENBTqWmfqPG
         4gGA==
X-Gm-Message-State: AOAM533jp8hDjue13V83T4zjryucPMHFDY0/SPJSO4Cey1WIGbPNiOIx
        3yB4ndtAph+he6HUVOHjd9VPy7SOyks=
X-Google-Smtp-Source: ABdhPJwFhJhBUprEOYt+YRRpWkw67AmhmFI51QqJAt1nW2b0ySAqTTSjTACYgdInnGHyUcpKAmBqQtNNahs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:b687:: with SMTP id s7mr6448853ybj.138.1624384777562;
 Tue, 22 Jun 2021 10:59:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:29 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-45-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 44/54] KVM: x86/mmu: Add a helper to calculate root from role_regs
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

Add a helper to calculate the level for non-EPT page tables from the
MMU's role_regs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 60 ++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a79871fe5b01..b83fd635e1f2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -238,6 +238,19 @@ struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
 	return regs;
 }
 
+static int role_regs_to_root_level(struct kvm_mmu_role_regs *regs)
+{
+	if (!____is_cr0_pg(regs))
+		return 0;
+	else if (____is_efer_lma(regs))
+		return ____is_cr4_la57(regs) ? PT64_ROOT_5LEVEL :
+					       PT64_ROOT_4LEVEL;
+	else if (____is_cr4_pae(regs))
+		return PT32E_ROOT_LEVEL;
+	else
+		return PT32_ROOT_LEVEL;
+}
+
 static inline bool kvm_available_flush_tlb_with_range(void)
 {
 	return kvm_x86_ops.tlb_remote_flush_with_range;
@@ -3949,7 +3962,6 @@ static void nonpaging_init_context(struct kvm_mmu *context)
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->root_level = 0;
 	context->direct_map = true;
 }
 
@@ -4519,11 +4531,8 @@ static void reset_guest_paging_metadata(struct kvm_vcpu *vcpu,
 	update_last_nonleaf_level(mmu);
 }
 
-static void paging64_init_context_common(struct kvm_mmu *context,
-					 int root_level)
+static void paging64_init_context_common(struct kvm_mmu *context)
 {
-	context->root_level = root_level;
-
 	WARN_ON_ONCE(!is_cr4_pae(context));
 	context->page_fault = paging64_page_fault;
 	context->gva_to_gpa = paging64_gva_to_gpa;
@@ -4532,18 +4541,13 @@ static void paging64_init_context_common(struct kvm_mmu *context,
 	context->direct_map = false;
 }
 
-static void paging64_init_context(struct kvm_mmu *context,
-				  struct kvm_mmu_role_regs *regs)
+static void paging64_init_context(struct kvm_mmu *context)
 {
-	int root_level = ____is_cr4_la57(regs) ? PT64_ROOT_5LEVEL :
-						 PT64_ROOT_4LEVEL;
-
-	paging64_init_context_common(context, root_level);
+	paging64_init_context_common(context);
 }
 
 static void paging32_init_context(struct kvm_mmu *context)
 {
-	context->root_level = PT32_ROOT_LEVEL;
 	context->page_fault = paging32_page_fault;
 	context->gva_to_gpa = paging32_gva_to_gpa;
 	context->sync_page = paging32_sync_page;
@@ -4553,7 +4557,7 @@ static void paging32_init_context(struct kvm_mmu *context)
 
 static void paging32E_init_context(struct kvm_mmu *context)
 {
-	paging64_init_context_common(context, PT32E_ROOT_LEVEL);
+	paging64_init_context_common(context);
 }
 
 static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
@@ -4642,21 +4646,16 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
+	context->root_level = role_regs_to_root_level(&regs);
 
-	if (!is_paging(vcpu)) {
+	if (!is_paging(vcpu))
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
-		context->root_level = 0;
-	} else if (is_long_mode(vcpu)) {
-		context->root_level = ____is_cr4_la57(&regs) ?
-				PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;
+	else if (is_long_mode(vcpu))
 		context->gva_to_gpa = paging64_gva_to_gpa;
-	} else if (is_pae(vcpu)) {
-		context->root_level = PT32E_ROOT_LEVEL;
+	else if (is_pae(vcpu))
 		context->gva_to_gpa = paging64_gva_to_gpa;
-	} else {
-		context->root_level = PT32_ROOT_LEVEL;
+	else
 		context->gva_to_gpa = paging32_gva_to_gpa;
-	}
 
 	reset_guest_paging_metadata(vcpu, context);
 	reset_tdp_shadow_zero_bits_mask(vcpu, context);
@@ -4706,11 +4705,12 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 	if (!____is_cr0_pg(regs))
 		nonpaging_init_context(context);
 	else if (____is_efer_lma(regs))
-		paging64_init_context(context, regs);
+		paging64_init_context(context);
 	else if (____is_cr4_pae(regs))
 		paging32E_init_context(context);
 	else
 		paging32_init_context(context);
+	context->root_level = role_regs_to_root_level(regs);
 
 	reset_guest_paging_metadata(vcpu, context);
 	context->shadow_root_level = new_role.base.level;
@@ -4849,17 +4849,7 @@ kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, struct kvm_mmu_role_regs *regs)
 	 * to "true" to try to detect bogus usage of the nested MMU.
 	 */
 	role.base.direct = true;
-
-	if (!____is_cr0_pg(regs))
-		role.base.level = 0;
-	else if (____is_efer_lma(regs))
-		role.base.level = ____is_cr4_la57(regs) ? PT64_ROOT_5LEVEL :
-							  PT64_ROOT_4LEVEL;
-	else if (____is_cr4_pae(regs))
-		role.base.level = PT32E_ROOT_LEVEL;
-	else
-		role.base.level = PT32_ROOT_LEVEL;
-
+	role.base.level = role_regs_to_root_level(regs);
 	return role;
 }
 
-- 
2.32.0.288.g62a8d224e6-goog


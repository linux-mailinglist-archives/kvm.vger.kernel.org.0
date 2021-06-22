Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70DF3B0C1F
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhFVSCc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbhFVSB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:01:58 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE90C06175F
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:49 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id a193-20020a3766ca0000b02903a9be00d619so19029685qkc.12
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=RzBQgCsPLMSfiL21Nb3UHXwTCCnNz0lNynpBzQ0WNPQ=;
        b=udxkLwPikpq/pPJ8zjcFGVKOLVzptYTJgQl6qKQXKKWAG/cuLL7G8E+8cHVXhhPINp
         zhjXpAN7lTPotXnGGnQIXASLiC9eybO53B0FhP1xAqXonRVjR7Oeuu1hsb5XxHS1rnwD
         /TRSJr7S+hyVJIMyelK9UpAlDOxaGz92wNUdtF/S5avoCEMCnz9cyiNHEfEDeWhnyhq5
         0zOhBXs0boWxPJ/b+miNe1Eu9ymJbbFDQ8l7xegvPhXdAgKQXvat81iO+wcU5zmT4cmT
         tAiTsRQ5UwaKGUDJvkC8eq2hTwyX9JKOEKQPodVMcOC8UrK0bkdtvR4yyaycjO2qe/Wt
         GLtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=RzBQgCsPLMSfiL21Nb3UHXwTCCnNz0lNynpBzQ0WNPQ=;
        b=iIgwcdzXSQf+bggJ1y3JXQS7A8+XgJ09hYnxz/BciKp9jNWXjVydvFC02vvuZ0+uu6
         OgVi9lL41Ai8VUj35elYcidMux2u+WUvWYUay3nB0U6oM9hY8uuNEtDGSqOJ8VW4IZMV
         B0NaQMoPlxV77OMQHFRBt9aEOqaQ0ywbI89lNtasGyx4+VbSm1hZj1IGbAypunOiHrFR
         UtSZJ5sw7Dbwn6jjdYYNA2hUxUHj6L0xut8319v8TZJBdIHEY0NzrMhipgE+dyIYcm1d
         rrtp+sl8nzcv9yjCLXT5cfJmPLQHt2FRRi+Cje76Me5Dka6JizTzEHz5Eo0kkeUdW68k
         Rwjg==
X-Gm-Message-State: AOAM532lGmUz+nYBNgFg28oW+aMP0msGNILHYREJoonLk4ttm5gPD8T2
        C62VACjsLqkJpsG3LpPXsVsW+5Aj+cM=
X-Google-Smtp-Source: ABdhPJyy7aHpbmcQnJkCY2O1Whm5Qt7q3j1zU6OkJMityx8YYUtToUY5Q+TNnNHJzvYBGkQZD1D0V+jfM6Y=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a5b:c:: with SMTP id a12mr6525566ybp.123.1624384728944;
 Tue, 22 Jun 2021 10:58:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:08 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-24-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 23/54] KVM: x86/mmu: Use MMU's role_regs, not vCPU state, to
 compute mmu_role
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

Use the provided role_regs to calculate the mmu_role instead of pulling
bits from current vCPU state.  For some flows, e.g. nested TDP, the vCPU
state may not be correct (or relevant).

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 92 ++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 84a40488eba7..896e92eac28b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4542,17 +4542,18 @@ static void paging32E_init_context(struct kvm_vcpu *vcpu,
 	paging64_init_context_common(vcpu, context, PT32E_ROOT_LEVEL);
 }
 
-static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu)
+static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
+							 struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_extended_role ext = {0};
 
-	ext.cr0_pg = !!is_paging(vcpu);
-	ext.cr4_pae = !!is_pae(vcpu);
-	ext.cr4_smep = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMEP);
-	ext.cr4_smap = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
-	ext.cr4_pse = !!is_pse(vcpu);
-	ext.cr4_pke = !!kvm_read_cr4_bits(vcpu, X86_CR4_PKE);
-	ext.cr4_la57 = !!kvm_read_cr4_bits(vcpu, X86_CR4_LA57);
+	ext.cr0_pg = ____is_cr0_pg(regs);
+	ext.cr4_pae = ____is_cr4_pae(regs);
+	ext.cr4_smep = ____is_cr4_smep(regs);
+	ext.cr4_smap = ____is_cr4_smap(regs);
+	ext.cr4_pse = ____is_cr4_pse(regs);
+	ext.cr4_pke = ____is_cr4_pke(regs);
+	ext.cr4_la57 = ____is_cr4_la57(regs);
 
 	ext.valid = 1;
 
@@ -4560,20 +4561,21 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu)
 }
 
 static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
+						   struct kvm_mmu_role_regs *regs,
 						   bool base_only)
 {
 	union kvm_mmu_role role = {0};
 
 	role.base.access = ACC_ALL;
-	role.base.nxe = !!is_nx(vcpu);
-	role.base.cr0_wp = is_write_protection(vcpu);
+	role.base.nxe = ____is_efer_nx(regs);
+	role.base.cr0_wp = ____is_cr0_wp(regs);
 	role.base.smm = is_smm(vcpu);
 	role.base.guest_mode = is_guest_mode(vcpu);
 
 	if (base_only)
 		return role;
 
-	role.ext = kvm_calc_mmu_role_ext(vcpu);
+	role.ext = kvm_calc_mmu_role_ext(vcpu, regs);
 
 	return role;
 }
@@ -4588,9 +4590,10 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 }
 
 static union kvm_mmu_role
-kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
+kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
+				struct kvm_mmu_role_regs *regs, bool base_only)
 {
-	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, base_only);
+	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs, base_only);
 
 	role.base.ad_disabled = (shadow_accessed_mask == 0);
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
@@ -4603,8 +4606,9 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
 static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
+	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
 	union kvm_mmu_role new_role =
-		kvm_calc_tdp_mmu_root_page_role(vcpu, false);
+		kvm_calc_tdp_mmu_root_page_role(vcpu, &regs, false);
 
 	if (new_role.as_u64 == context->mmu_role.as_u64)
 		return;
@@ -4648,30 +4652,30 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 }
 
 static union kvm_mmu_role
-kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu, bool base_only)
+kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
+				      struct kvm_mmu_role_regs *regs, bool base_only)
 {
-	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, base_only);
+	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs, base_only);
 
-	role.base.smep_andnot_wp = role.ext.cr4_smep &&
-		!is_write_protection(vcpu);
-	role.base.smap_andnot_wp = role.ext.cr4_smap &&
-		!is_write_protection(vcpu);
-	role.base.gpte_is_8_bytes = !!is_pae(vcpu);
+	role.base.smep_andnot_wp = role.ext.cr4_smep && !____is_cr0_wp(regs);
+	role.base.smap_andnot_wp = role.ext.cr4_smap && !____is_cr0_wp(regs);
+	role.base.gpte_is_8_bytes = ____is_cr4_pae(regs);
 
 	return role;
 }
 
 static union kvm_mmu_role
-kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
+kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
+				   struct kvm_mmu_role_regs *regs, bool base_only)
 {
 	union kvm_mmu_role role =
-		kvm_calc_shadow_root_page_role_common(vcpu, base_only);
+		kvm_calc_shadow_root_page_role_common(vcpu, regs, base_only);
 
-	role.base.direct = !is_paging(vcpu);
+	role.base.direct = !____is_cr0_pg(regs);
 
-	if (!is_long_mode(vcpu))
+	if (!____is_efer_lma(regs))
 		role.base.level = PT32E_ROOT_LEVEL;
-	else if (is_la57_mode(vcpu))
+	else if (____is_cr4_la57(regs))
 		role.base.level = PT64_ROOT_5LEVEL;
 	else
 		role.base.level = PT64_ROOT_4LEVEL;
@@ -4709,17 +4713,18 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role new_role =
-		kvm_calc_shadow_mmu_root_page_role(vcpu, false);
+		kvm_calc_shadow_mmu_root_page_role(vcpu, regs, false);
 
 	if (new_role.as_u64 != context->mmu_role.as_u64)
 		shadow_mmu_init_context(vcpu, context, regs, new_role);
 }
 
 static union kvm_mmu_role
-kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu)
+kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
+				   struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_role role =
-		kvm_calc_shadow_root_page_role_common(vcpu, false);
+		kvm_calc_shadow_root_page_role_common(vcpu, regs, false);
 
 	role.base.direct = false;
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
@@ -4736,7 +4741,9 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 		.cr4 = cr4,
 		.efer = efer,
 	};
-	union kvm_mmu_role new_role = kvm_calc_shadow_npt_root_page_role(vcpu);
+	union kvm_mmu_role new_role;
+
+	new_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);
 
 	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
 
@@ -4821,9 +4828,12 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 	context->inject_page_fault = kvm_inject_page_fault;
 }
 
-static union kvm_mmu_role kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu)
+static union kvm_mmu_role
+kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, struct kvm_mmu_role_regs *regs)
 {
-	union kvm_mmu_role role = kvm_calc_shadow_root_page_role_common(vcpu, false);
+	union kvm_mmu_role role;
+
+	role = kvm_calc_shadow_root_page_role_common(vcpu, regs, false);
 
 	/*
 	 * Nested MMUs are used only for walking L2's gva->gpa, they never have
@@ -4832,12 +4842,12 @@ static union kvm_mmu_role kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu)
 	 */
 	role.base.direct = true;
 
-	if (!is_paging(vcpu))
+	if (!____is_cr0_pg(regs))
 		role.base.level = 0;
-	else if (is_long_mode(vcpu))
-		role.base.level = is_la57_mode(vcpu) ? PT64_ROOT_5LEVEL :
-						       PT64_ROOT_4LEVEL;
-	else if (is_pae(vcpu))
+	else if (____is_efer_lma(regs))
+		role.base.level = ____is_cr4_la57(regs) ? PT64_ROOT_5LEVEL :
+							  PT64_ROOT_4LEVEL;
+	else if (____is_cr4_pae(regs))
 		role.base.level = PT32E_ROOT_LEVEL;
 	else
 		role.base.level = PT32_ROOT_LEVEL;
@@ -4847,7 +4857,8 @@ static union kvm_mmu_role kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu)
 
 static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 {
-	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu);
+	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
+	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu, &regs);
 	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
 
 	if (new_role.as_u64 == g_context->mmu_role.as_u64)
@@ -4913,12 +4924,13 @@ EXPORT_SYMBOL_GPL(kvm_init_mmu);
 static union kvm_mmu_page_role
 kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu)
 {
+	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
 	union kvm_mmu_role role;
 
 	if (tdp_enabled)
-		role = kvm_calc_tdp_mmu_root_page_role(vcpu, true);
+		role = kvm_calc_tdp_mmu_root_page_role(vcpu, &regs, true);
 	else
-		role = kvm_calc_shadow_mmu_root_page_role(vcpu, true);
+		role = kvm_calc_shadow_mmu_root_page_role(vcpu, &regs, true);
 
 	return role.base;
 }
-- 
2.32.0.288.g62a8d224e6-goog


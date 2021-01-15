Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E98A2F6FA2
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 01:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731390AbhAOAlh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 19:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbhAOAlg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 19:41:36 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC95C061757
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 16:40:56 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id k126so6165917qkf.8
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 16:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=t8c/Zi1/dJ4uhKjMSCSNdZwekdvteSeGdebcaDLlZ84=;
        b=J08j0qDe02915zC2wJ7Mk1g1vjFzfb/8xM6Fz97phDYXlPIre1A1e3jYGEL3MnRRt1
         cYAXkemNWK3RKolge13RoBcjyl22LWNXyXEi0/fffxt/0v4G7sn8sfoI5BD/s22LcQc9
         DgnEFP9ey8SYkb/GkPHKoLiF0L+WnPLMPWfsMygtYdjuy8zvKsNk2UEa8kFOK8OMEqAC
         MjGyk1/CLfjoZbu3LOTkGCYdNM2OsaOjdTrDeNC7XCU7riXkdWlOEc4yrywwFZEk1gpp
         DFh5I5T86nO1ZRbj5z/YX2mIi/UqsGdmWbbWa/9GSYG2sZdkw4cHLFOF0EtI6YtazJZY
         EUpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=t8c/Zi1/dJ4uhKjMSCSNdZwekdvteSeGdebcaDLlZ84=;
        b=WweKKeO74dOUeSAbR/wgtSadyWuEw705YMkmwoPEefNAvSyJtyi9LYIVQ1Ga23WpMq
         nArpVXYFy6RtcBSVrIlAtTt6OJPZ1Qg/HMqhYn8Yo5Warz4ipP6ZdxRhB9BRCjWQmRZ4
         8krIsVZvs966rmpy+yuIi2pZIu0M9abKbGpEHdxEd2U5nojnR6fQSu5VqBa5FirHhtpi
         wSepPNatxtvO4P7mnhUBoUIozqv6WD9z0pYH5KshY6+jzu3Qo1e1Dp6xg+Ls/diVQGR8
         0OqlRGdEGjM6nrFM6z9pYuGOj02PRRb+/SCXIWuCJJHZZk+V5yrUZ79BWkI2M/MCvjr/
         lXvQ==
X-Gm-Message-State: AOAM532pgXinjYbphT0bGttPkvLIFkiCr55K+eier61OYPx32zeL5MJa
        xoD6Aguuy2q1UP1Jv6sA8wnjilhZRY0=
X-Google-Smtp-Source: ABdhPJzxCxZXjHhtcvLr1Kf9erN9OuaIBz0HqpYidtZRJoouWRl1ju7FoN0eK6DismJIkfKcznYgWNNK+Gk=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:ad4:434e:: with SMTP id q14mr9828287qvs.15.1610671255318;
 Thu, 14 Jan 2021 16:40:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 14 Jan 2021 16:40:51 -0800
Message-Id: <20210115004051.4099250-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH] KVM: x86/mmu: Remove the defunct update_pte() paging hook
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yu Zhang <yu.c.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the update_pte() shadow paging logic, which was obsoleted by
commit 4731d4c7a077 ("KVM: MMU: out of sync shadow core"), but never
removed.  As pointed out by Yu, KVM never write protects leaf page
tables for the purposes of shadow paging, and instead marks their
associated shadow page as unsync so that the guest can write PTEs at
will.

The update_pte() path, which predates the unsync logic, optimizes COW
scenarios by refreshing leaf SPTEs when they are written, as opposed to
zapping the SPTE, restarting the guest, and installing the new SPTE on
the subsequent fault.  Since KVM no longer write-protects leaf page
tables, update_pte() is unreachable and can be dropped.

Reported-by: Yu Zhang <yu.c.zhang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 --
 arch/x86/kvm/mmu/mmu.c          | 49 ++-------------------------------
 arch/x86/kvm/x86.c              |  1 -
 3 files changed, 2 insertions(+), 51 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3d6616f6f6ef..ed575c5655dd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -358,8 +358,6 @@ struct kvm_mmu {
 	int (*sync_page)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
-	void (*update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			   u64 *spte, const void *pte);
 	hpa_t root_hpa;
 	gpa_t root_pgd;
 	union kvm_mmu_role mmu_role;
@@ -1031,7 +1029,6 @@ struct kvm_arch {
 struct kvm_vm_stat {
 	ulong mmu_shadow_zapped;
 	ulong mmu_pte_write;
-	ulong mmu_pte_updated;
 	ulong mmu_pde_zapped;
 	ulong mmu_flooded;
 	ulong mmu_recycled;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481aa29d..3a2c25852b1f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1723,13 +1723,6 @@ static int nonpaging_sync_page(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static void nonpaging_update_pte(struct kvm_vcpu *vcpu,
-				 struct kvm_mmu_page *sp, u64 *spte,
-				 const void *pte)
-{
-	WARN_ON(1);
-}
-
 #define KVM_PAGE_ARRAY_NR 16
 
 struct kvm_mmu_pages {
@@ -3813,7 +3806,6 @@ static void nonpaging_init_context(struct kvm_vcpu *vcpu,
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->update_pte = nonpaging_update_pte;
 	context->root_level = 0;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->direct_map = true;
@@ -4395,7 +4387,6 @@ static void paging64_init_context_common(struct kvm_vcpu *vcpu,
 	context->gva_to_gpa = paging64_gva_to_gpa;
 	context->sync_page = paging64_sync_page;
 	context->invlpg = paging64_invlpg;
-	context->update_pte = paging64_update_pte;
 	context->shadow_root_level = level;
 	context->direct_map = false;
 }
@@ -4424,7 +4415,6 @@ static void paging32_init_context(struct kvm_vcpu *vcpu,
 	context->gva_to_gpa = paging32_gva_to_gpa;
 	context->sync_page = paging32_sync_page;
 	context->invlpg = paging32_invlpg;
-	context->update_pte = paging32_update_pte;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->direct_map = false;
 }
@@ -4506,7 +4496,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->update_pte = nonpaging_update_pte;
 	context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);
 	context->direct_map = true;
 	context->get_guest_pgd = get_cr3;
@@ -4678,7 +4667,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	context->gva_to_gpa = ept_gva_to_gpa;
 	context->sync_page = ept_sync_page;
 	context->invlpg = ept_invlpg;
-	context->update_pte = ept_update_pte;
 	context->root_level = level;
 	context->direct_map = false;
 	context->mmu_role.as_u64 = new_role.as_u64;
@@ -4826,19 +4814,6 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_unload);
 
-static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
-				  struct kvm_mmu_page *sp, u64 *spte,
-				  const void *new)
-{
-	if (sp->role.level != PG_LEVEL_4K) {
-		++vcpu->kvm->stat.mmu_pde_zapped;
-		return;
-        }
-
-	++vcpu->kvm->stat.mmu_pte_updated;
-	vcpu->arch.mmu->update_pte(vcpu, sp, spte, new);
-}
-
 static bool need_remote_flush(u64 old, u64 new)
 {
 	if (!is_shadow_present_pte(old))
@@ -4954,22 +4929,6 @@ static u64 *get_written_sptes(struct kvm_mmu_page *sp, gpa_t gpa, int *nspte)
 	return spte;
 }
 
-/*
- * Ignore various flags when determining if a SPTE can be immediately
- * overwritten for the current MMU.
- *  - level: explicitly checked in mmu_pte_write_new_pte(), and will never
- *    match the current MMU role, as MMU's level tracks the root level.
- *  - access: updated based on the new guest PTE
- *  - quadrant: handled by get_written_sptes()
- *  - invalid: always false (loop only walks valid shadow pages)
- */
-static const union kvm_mmu_page_role role_ign = {
-	.level = 0xf,
-	.access = 0x7,
-	.quadrant = 0x3,
-	.invalid = 0x1,
-};
-
 static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			      const u8 *new, int bytes,
 			      struct kvm_page_track_notifier_node *node)
@@ -5020,14 +4979,10 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 		local_flush = true;
 		while (npte--) {
-			u32 base_role = vcpu->arch.mmu->mmu_role.base.word;
-
 			entry = *spte;
 			mmu_page_zap_pte(vcpu->kvm, sp, spte, NULL);
-			if (gentry &&
-			    !((sp->role.word ^ base_role) & ~role_ign.word) &&
-			    rmap_can_add(vcpu))
-				mmu_pte_write_new_pte(vcpu, sp, spte, &gentry);
+			if (gentry && sp->role.level != PG_LEVEL_4K)
+				++vcpu->kvm->stat.mmu_pde_zapped;
 			if (need_remote_flush(entry, *spte))
 				remote_flush = true;
 			++spte;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a480804ae27a..d9f5d9acccc1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -233,7 +233,6 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
 	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
 	VM_STAT("mmu_pte_write", mmu_pte_write),
-	VM_STAT("mmu_pte_updated", mmu_pte_updated),
 	VM_STAT("mmu_pde_zapped", mmu_pde_zapped),
 	VM_STAT("mmu_flooded", mmu_flooded),
 	VM_STAT("mmu_recycled", mmu_recycled),
-- 
2.30.0.284.gd98b1dd5eaa7-goog


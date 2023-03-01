Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6A56A75F0
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 22:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjCAVKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 16:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjCAVJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 16:09:59 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4596B521F2
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 13:09:53 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id t185-20020a635fc2000000b00502e332493fso4859846pgb.12
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 13:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BJLAJR4lXHPHq3Me/87q0IvvlwMB/K5VaYZ9dQFs+Xs=;
        b=Dbt5hYrRVV8VLJ5SlGd7daEHp0vWm9ZMEz7aKiJPN0eLljSmVxMZX/2kXvZoxkhHL5
         QyHxSsyvYpmWyrRp/bFE8IE9i9eUbJQFj8p5CnW5W6m3sEAkE8rjpbuQJ4xfi/FpRzmn
         i4QpTyV/dChKN4cU+bcJKnc0KDgglI5b6bw95wsI/frmmHL9TYwoW8g5XiqsGLY4xuvh
         VMKRFQdSPVHok2Z1N7ra48CUsuk9FG0JrsUouIHxQ7/2cfxSR0PCNDPnDkxuvyl9KguP
         kQJm9iI+O+aTnq3UgBDpfp9kUap6tEJEz2WCHmgtgXQKA/2xmYljX4D+dZApiAjpbaaE
         vCQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BJLAJR4lXHPHq3Me/87q0IvvlwMB/K5VaYZ9dQFs+Xs=;
        b=dTQklg56qRW5nBmae56YiISmbZy58S1j5TzGZ6+Qr6FEw7CRSxmK9ow6vYpwdRLZS9
         DUYIXFx0w22WklyUWsIVgOdZ0P1j36ZzgnxQ0qQSdeV3GOboYiM41IU7E76qOpWi75X/
         ktaZOnpfIgDClIo8E/xQsDIBWboSoAa+YVe55zU7/Iv5FeGfUKP0JMZ/7eGE4usnIV/1
         1h7/D5r4YaNIo8mQKhmuhqeCBpCurIj+U5NQIwO8AEAGCVfM6zJGxGqj8QjcVHKkUWdw
         tavzwY8REVqDkd7W+ZNX7N4pV0j8ChOHVg790k0hKwdhDTPchSwWUF8Tnxg/Qt9yP0fd
         QUZw==
X-Gm-Message-State: AO0yUKU3/zu5bR7llzqQ698X5VrL2M0NpP5LMn0AbjTTsfWCmD1Cwz1o
        m92psdzvUckuZh7rZXKAdN35BpoXDEgxEw==
X-Google-Smtp-Source: AK7set97vlxCN7m1MDHOD/dkJDNcp8qSFC5ADTWqwufrcbV/A5WHBVqwRi73NB9M3taMFHVuWdTzVJ7m2MckzA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:274b:b0:233:bada:17b5 with SMTP
 id qi11-20020a17090b274b00b00233bada17b5mr4783223pjb.4.1677704992546; Wed, 01
 Mar 2023 13:09:52 -0800 (PST)
Date:   Wed,  1 Mar 2023 21:09:28 +0000
In-Reply-To: <20230301210928.565562-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230301210928.565562-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230301210928.565562-13-ricarkol@google.com>
Subject: [PATCH v5 12/12] KVM: arm64: Use local TLBI on permission relaxation
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

Broadcasted TLB invalidations (TLBI) are usually less performant than their
local variant. In particular, we observed some implementations that take
millliseconds to complete parallel broadcasted TLBIs.

It's safe to use local, non-shareable, TLBIs when relaxing permissions on a
PTE in the KVM case for a couple of reasons. First, according to the ARM
Arm (DDI 0487H.a D5-4913), permission relaxation does not need
break-before-make.  Second, KVM does not set the VTTBR_EL2.CnP bit, so each
PE has its own TLB entry for the same page. KVM could tolerate that when
doing permission relaxation (i.e., not having changes broadcasted to all
PEs).

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  4 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 10 ++++++
 arch/arm64/kvm/hyp/nvhe/tlb.c      | 54 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c       |  2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c       | 32 ++++++++++++++++++
 5 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 43c3bc0f9544..bb17b2ead4c7 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -68,6 +68,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa,
+	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa_nsh,
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
@@ -225,6 +226,9 @@ extern void __kvm_flush_vm_context(void);
 extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
 				     int level);
+extern void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
+					 phys_addr_t ipa,
+					 int level);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 728e01d4536b..c6bf1e49ca93 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -125,6 +125,15 @@ static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
 	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
 }
 
+static void handle___kvm_tlb_flush_vmid_ipa_nsh(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
+	DECLARE_REG(phys_addr_t, ipa, host_ctxt, 2);
+	DECLARE_REG(int, level, host_ctxt, 3);
+
+	__kvm_tlb_flush_vmid_ipa_nsh(kern_hyp_va(mmu), ipa, level);
+}
+
 static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
@@ -315,6 +324,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
+	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa_nsh),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index d296d617f589..ef2b70587f93 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -109,6 +109,60 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	__tlb_switch_to_host(&cxt);
 }
 
+void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
+				  phys_addr_t ipa, int level)
+{
+	struct tlb_inv_context cxt;
+
+	dsb(nshst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt);
+
+	/*
+	 * We could do so much better if we had the VA as well.
+	 * Instead, we invalidate Stage-2 for this IPA, and the
+	 * whole of Stage-1. Weep...
+	 */
+	ipa >>= 12;
+	__tlbi_level(ipas2e1, ipa, level);
+
+	/*
+	 * We have to ensure completion of the invalidation at Stage-2,
+	 * since a table walk on another CPU could refill a TLB with a
+	 * complete (S1 + S2) walk based on the old Stage-2 mapping if
+	 * the Stage-1 invalidation happened first.
+	 */
+	dsb(nsh);
+	__tlbi(vmalle1);
+	dsb(nsh);
+	isb();
+
+	/*
+	 * If the host is running at EL1 and we have a VPIPT I-cache,
+	 * then we must perform I-cache maintenance at EL2 in order for
+	 * it to have an effect on the guest. Since the guest cannot hit
+	 * I-cache lines allocated with a different VMID, we don't need
+	 * to worry about junk out of guest reset (we nuke the I-cache on
+	 * VMID rollover), but we do need to be careful when remapping
+	 * executable pages for the same guest. This can happen when KSM
+	 * takes a CoW fault on an executable page, copies the page into
+	 * a page that was previously mapped in the guest and then needs
+	 * to invalidate the guest view of the I-cache for that page
+	 * from EL1. To solve this, we invalidate the entire I-cache when
+	 * unmapping a page from a guest if we have a VPIPT I-cache but
+	 * the host is running at EL1. As above, we could do better if
+	 * we had the VA.
+	 *
+	 * The moral of this story is: if you have a VPIPT I-cache, then
+	 * you should be running with VHE enabled.
+	 */
+	if (icache_is_vpipt())
+		icache_inval_all_pou();
+
+	__tlb_switch_to_host(&cxt);
+}
+
 void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 75726edba2f3..540f55a14b80 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1148,7 +1148,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level,
 				       KVM_PGTABLE_WALK_SHARED);
 	if (!ret)
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, level);
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr, level);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 24cef9b87f9e..e69da550cdc5 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -111,6 +111,38 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	__tlb_switch_to_host(&cxt);
 }
 
+void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
+				  phys_addr_t ipa, int level)
+{
+	struct tlb_inv_context cxt;
+
+	dsb(nshst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt);
+
+	/*
+	 * We could do so much better if we had the VA as well.
+	 * Instead, we invalidate Stage-2 for this IPA, and the
+	 * whole of Stage-1. Weep...
+	 */
+	ipa >>= 12;
+	__tlbi_level(ipas2e1, ipa, level);
+
+	/*
+	 * We have to ensure completion of the invalidation at Stage-2,
+	 * since a table walk on another CPU could refill a TLB with a
+	 * complete (S1 + S2) walk based on the old Stage-2 mapping if
+	 * the Stage-1 invalidation happened first.
+	 */
+	dsb(nsh);
+	__tlbi(vmalle1);
+	dsb(nsh);
+	isb();
+
+	__tlb_switch_to_host(&cxt);
+}
+
 void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
-- 
2.39.2.722.g9855ee24e9-goog


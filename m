Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833A6526B4B
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384226AbiEMU2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384262AbiEMU2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:28:45 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D76158F8C
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:43 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id x23-20020a170902b41700b0015ea144789fso4848143plr.13
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KfRqqmF6zDPtLKKAI6Hjlm20HsRlaY9ddtgBgjQ2ZrQ=;
        b=pSOwfb/HDpPjSiLxp77s2zj9vUBTDCYx5MAGBseuub+RMk7t2wDDudLuzlnpTswVSy
         HKfOpLmwxm5oFBcrUXFQDWLWyYk8F3EOj9ammQqfuTTaep5FhvuWy6+eu9HWx8d7Kr24
         kgtaFNkjOOZEczd6I5rRRBKjntYA8CXUndljWo7TCnInvdWQX78k3SCw99JfcntSQ/e4
         qyhQfw9B7VDpz9I5Jwyt0MfCK7HKhl95OQBkhdPQeBOno/7JPhN+BWmPQjGxLeHXLAeh
         ApC4yacn/To4ik+tbffSuIOIKvBFhZKsEKj4Na0Orkdv1u2Xuv0fHz5ueL85G4wb8D4O
         w8AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KfRqqmF6zDPtLKKAI6Hjlm20HsRlaY9ddtgBgjQ2ZrQ=;
        b=lys0zuanFjd34n+mJ+GiBynuy1WXDR0iJ49cWCr6k1NFWd61m86nX2q+kv6gr573C5
         EECxeFHJpqiK7jX3cU3g5bA0BK0w+lyVU8UgpouEgwFrSzqRkqonDyt3xgr7F1B54NTj
         6elotVd9gB0z9oUnc0yOtFL0y4e2TH9lB7mlE+bzb3uGZCcMrtHrEr0/oxO58qQxvz/s
         mcHPmHsCgVUv+wJl76ndEp2weSja66uon+zGGUVOKL9SiuN2xCRad+kfN7dEC6U5HV6g
         qovO10TkHI1fGjDbJ7uh6iCurXGfmOE6E/Nho1typ9AY0VoOf5++SWHvOPRKiqDTnAOw
         EuYQ==
X-Gm-Message-State: AOAM532XCsZa/i7SInq4I1x4b1XgGJ4MAojgueLbRYifzhYXLd5q+UPT
        5PpAnVGSfALNsX0EmuPBehvFAj1UoADP8A==
X-Google-Smtp-Source: ABdhPJwDulneZ8adwpak547oF8o9nVIl9FpMqjtWRMC9DmTo/Aa4JVoorIjOxz20OeD4V4A5Q/KZV/1R7WWh+g==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a63:8841:0:b0:3db:2e5f:1271 with SMTP id
 l62-20020a638841000000b003db2e5f1271mr5424446pgd.233.1652473722670; Fri, 13
 May 2022 13:28:42 -0700 (PDT)
Date:   Fri, 13 May 2022 20:28:05 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 07/21] KVM: x86/mmu: Rename shadow MMU functions that deal
 with shadow pages
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        David Matlack <dmatlack@google.com>
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

Rename 2 functions:

  kvm_mmu_get_page() -> kvm_mmu_get_shadow_page()
  kvm_mmu_free_page() -> kvm_mmu_free_shadow_page()

This change makes it clear that these functions deal with shadow pages
rather than struct pages. It also aligns these functions with the naming
scheme for kvm_mmu_find_shadow_page() and kvm_mmu_alloc_shadow_page().

Prefer "shadow_page" over the shorter "sp" since these are core
functions and the line lengths aren't terrible.

No functional change intended.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fd749748b280..4bbb6821f861 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1652,7 +1652,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
+static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 {
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
@@ -2107,8 +2107,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					     union kvm_mmu_page_role role)
+static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
+						    gfn_t gfn,
+						    union kvm_mmu_page_role role)
 {
 	struct hlist_head *sp_list;
 	struct kvm_mmu_page *sp;
@@ -2172,7 +2173,7 @@ static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
 	union kvm_mmu_page_role role;
 
 	role = kvm_mmu_child_role(sptep, direct, access);
-	return kvm_mmu_get_page(vcpu, gfn, role);
+	return kvm_mmu_get_shadow_page(vcpu, gfn, role);
 }
 
 static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
@@ -2448,7 +2449,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
 		WARN_ON(!sp->role.invalid || sp->root_count);
-		kvm_mmu_free_page(sp);
+		kvm_mmu_free_shadow_page(sp);
 	}
 }
 
@@ -3438,7 +3439,7 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 	if (level <= vcpu->arch.mmu->cpu_role.base.level)
 		role.passthrough = 0;
 
-	sp = kvm_mmu_get_page(vcpu, gfn, role);
+	sp = kvm_mmu_get_shadow_page(vcpu, gfn, role);
 	++sp->root_count;
 
 	return __pa(sp->spt);
-- 
2.36.0.550.gb090851708-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146F6767A04
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbjG2As7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236540AbjG2Asz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:48:55 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3760A49CF
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:21 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bb962ada0dso17224645ad.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591646; x=1691196446;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=M/GkaHsFgZHdZLTn2fxQT2lDObwORLA7V2VRgVzEfWk=;
        b=iD3VziV8hgBxcyutWF1XvZhOl+sIJxIv7X1Fi+enNX8drSX/Gg98dsztm6RWppo+SN
         +kltBMqeH+fV52J+uvkM8xyoY7P/A/iHYWHxlA+zjRaI9mwxsgc10t0VDDPCLk1/NLG4
         qu8Nr48zLrb/zv7TbIHuOI5q46l1m1ch1R0YJ2hbbrxZ4DWa3klfNDza7a01GXC+F9N9
         CzllCJ3s4F/4W8oiMKnlaDIK8AmBqpSh+OGfO2Z8nUi6xQ+9ampjq7w+1VjqtUrQS1Jy
         lE2BHnnXsQVFZKVHMxB5U+O2pm54cZVFeCKCbnFlqPJWluGs7+c3KKfWrmvpLBqFjYcU
         0ADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591646; x=1691196446;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M/GkaHsFgZHdZLTn2fxQT2lDObwORLA7V2VRgVzEfWk=;
        b=UVjjaKTNu05tSPTAal/+YL2kJrfUfJi0UElcnw3vT+1NpwzUmtmsGLPT04X300lTv8
         mNN/sd2jqZIw5rESS7sxZte5LfVjEuMsLFFDU6aVctrGN68+KjnB/wAnRzJwVm97acHp
         8sLtt5tooj6kafoz18IgTCtPeN3qOISOayVYFUU9y77xEXuvzQksjluS9hSIBYd1q4jF
         798u0by9gqegPugGNMnfT5KjdrHG6u7HvmAw+g4QidXHLI7wkBqizc0aFXRmIX2xL+DP
         r6iYaJNcHLcT1Edl1RYBiHAFLurYyzfVVgNSD6YP70dbU9VMp9eTPe/1NTdD5gNf9CAJ
         +yRA==
X-Gm-Message-State: ABy/qLbw/RrGRRVOVrrWtA5RoS05WExrYptLNE8tx9J8oJAKNmcY5Ary
        LWYSM7ZZI7JJs1PwSXjUJSNt23M6BCE=
X-Google-Smtp-Source: APBJJlFkOElTp1LyUsaIQNVMRu+5tJ2YPVvbe4lRQqtLkgHv5lg9HLEOYssB4VF+2R6Jr41lklbKJ+gXFYY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c1:b0:1b7:edcd:8dcf with SMTP id
 u1-20020a170902e5c100b001b7edcd8dcfmr14199plf.4.1690591646357; Fri, 28 Jul
 2023 17:47:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:47:11 -0700
In-Reply-To: <20230729004722.1056172-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729004722.1056172-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729004722.1056172-2-seanjc@google.com>
Subject: [PATCH v3 01/12] KVM: x86/mmu: Delete pgprintk() and all its usage
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
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

Delete KVM's pgprintk() and all its usage, as the code is very prone
to bitrot due to being buried behind MMU_DEBUG, and the functionality has
been rendered almost entirely obsolete by the tracepoints KVM has gained
over the years.  And for the situations where the information provided by
KVM's tracepoints is insufficient, pgprintk() rarely fills in the gaps,
and is almost always far too noisy, i.e. developers end up implementing
custom prints anyways.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 17 -----------------
 arch/x86/kvm/mmu/mmu_internal.h |  2 --
 arch/x86/kvm/mmu/paging_tmpl.h  |  7 -------
 arch/x86/kvm/mmu/spte.c         |  2 --
 4 files changed, 28 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ec169f5c7dce..bc24d430db6e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2775,12 +2775,9 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	LIST_HEAD(invalid_list);
 	int r;
 
-	pgprintk("%s: looking for gfn %llx\n", __func__, gfn);
 	r = 0;
 	write_lock(&kvm->mmu_lock);
 	for_each_gfn_valid_sp_with_gptes(kvm, sp, gfn) {
-		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
-			 sp->role.word);
 		r = 1;
 		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 	}
@@ -2938,9 +2935,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	bool prefetch = !fault || fault->prefetch;
 	bool write_fault = fault && fault->write;
 
-	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
-		 *sptep, write_fault, gfn);
-
 	if (unlikely(is_noslot_pfn(pfn))) {
 		vcpu->stat.pf_mmio_spte_created++;
 		mark_mmio_spte(vcpu, sptep, gfn, pte_access);
@@ -2960,8 +2954,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			drop_parent_pte(child, sptep);
 			flush = true;
 		} else if (pfn != spte_to_pfn(*sptep)) {
-			pgprintk("hfn old %llx new %llx\n",
-				 spte_to_pfn(*sptep), pfn);
 			drop_spte(vcpu->kvm, sptep);
 			flush = true;
 		} else
@@ -2986,8 +2978,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	if (flush)
 		kvm_flush_remote_tlbs_gfn(vcpu->kvm, gfn, level);
 
-	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
-
 	if (!was_rmapped) {
 		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
 		rmap_add(vcpu, slot, sptep, gfn, pte_access);
@@ -4443,8 +4433,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu,
 				struct kvm_page_fault *fault)
 {
-	pgprintk("%s: gva %lx error %x\n", __func__, fault->addr, fault->error_code);
-
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
 	fault->max_level = PG_LEVEL_2M;
 	return direct_page_fault(vcpu, fault);
@@ -5634,9 +5622,6 @@ static bool detect_write_misaligned(struct kvm_mmu_page *sp, gpa_t gpa,
 {
 	unsigned offset, pte_size, misaligned;
 
-	pgprintk("misaligned: gpa %llx bytes %d role %x\n",
-		 gpa, bytes, sp->role.word);
-
 	offset = offset_in_page(gpa);
 	pte_size = sp->role.has_4_byte_gpte ? 4 : 8;
 
@@ -5702,8 +5687,6 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	if (!READ_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
 		return;
 
-	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
-
 	write_lock(&vcpu->kvm->mmu_lock);
 
 	gentry = mmu_pte_write_fetch_gpte(vcpu, &gpa, &bytes);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d39af5639ce9..4f1e4b327f40 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -11,11 +11,9 @@
 #ifdef MMU_DEBUG
 extern bool dbg;
 
-#define pgprintk(x...) do { if (dbg) printk(x); } while (0)
 #define rmap_printk(fmt, args...) do { if (dbg) printk("%s: " fmt, __func__, ## args); } while (0)
 #define MMU_WARN_ON(x) WARN_ON(x)
 #else
-#define pgprintk(x...) do { } while (0)
 #define rmap_printk(x...) do { } while (0)
 #define MMU_WARN_ON(x) do { } while (0)
 #endif
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0662e0278e70..7a97f769a7cb 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -456,9 +456,6 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 			goto retry_walk;
 	}
 
-	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
-		 __func__, (u64)pte, walker->pte_access,
-		 walker->pt_access[walker->level - 1]);
 	return 1;
 
 error:
@@ -529,8 +526,6 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
 		return false;
 
-	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
-
 	gfn = gpte_to_gfn(gpte);
 	pte_access = sp->role.access & FNAME(gpte_access)(gpte);
 	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
@@ -758,7 +753,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	struct guest_walker walker;
 	int r;
 
-	pgprintk("%s: addr %lx err %x\n", __func__, fault->addr, fault->error_code);
 	WARN_ON_ONCE(fault->is_tdp);
 
 	/*
@@ -773,7 +767,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * The page is not mapped by the guest.  Let the guest handle it.
 	 */
 	if (!r) {
-		pgprintk("%s: guest page fault\n", __func__);
 		if (!fault->prefetch)
 			kvm_inject_emulated_page_fault(vcpu, &walker.fault);
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index cf2c6426a6fc..438a86bda9f3 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -221,8 +221,6 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		 * shadow pages and unsync'ing pages is not allowed.
 		 */
 		if (mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, can_unsync, prefetch)) {
-			pgprintk("%s: found shadow page for %llx, marking ro\n",
-				 __func__, gfn);
 			wrprot = true;
 			pte_access &= ~ACC_WRITE_MASK;
 			spte &= ~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
-- 
2.41.0.487.g6d72f3e995-goog


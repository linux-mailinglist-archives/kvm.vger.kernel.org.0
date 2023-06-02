Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6BFE71F798
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbjFBBPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbjFBBP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:15:28 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E0C13E
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:15:25 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b02cd4b829so10253755ad.1
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685668524; x=1688260524;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QZyedvEO4VqsOzfsB28/8dG+6mqt6s6B82uH8fSmwq8=;
        b=j6CUWl3a3FC0QTS2njOofjKDlfQDmtDJaHSEouWHPCamUcCop7S0W1f56KyCl2MYCz
         DstIw0CLzrHL+bqnN/88nI8F9zPPVgGPmafeNxh7uQExuP98qW5YpkuGO7fz/JN016ot
         ONsEzzryAmfo9bNAIsMV34WY7aScQG1sHNQQqUac+jFmNo0cLvSgRWIGQnE1Figc4LgJ
         TMq/TnB4/PGyJaxLGEgGG93zTw8uRjt4FOxjcHttzl6sUqQzSHIqeSP3ip5fqROjFUlK
         1n4cxYxyeLfHcXrK9mKx7vMZUAHJl1sv0YgnAkvwpveJ12L1s6NLxOR3dH5ccmW4qY0f
         iT9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685668524; x=1688260524;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QZyedvEO4VqsOzfsB28/8dG+6mqt6s6B82uH8fSmwq8=;
        b=AbTRxWTQwlBTjvlWv/p4R/DXYLY2jnwBN99rPyucwxAAXoFk7/wNzN2OTtJxR+qP/s
         Zn//YzDZF7Nl4cUZz6m1Rf+DTqGn7bGjCpAiFLKXQ2s43tJZm+LfUQYpZO9sGWX1Ccv3
         VV6TnUFwoLde6G7VOjKRbRF7po4OFpT2juOfBvpbJZ5G+ja+ri1AbG3S6dtqne08UkgF
         7UmCfSgCGOaC3gDLHLUq5F+Prw6NwnVMAMbBjaEcjCujHQ/rGnde1dIB7TFKFmKN0bYl
         jpzqLexEQSqKIvYI6/XdWg/A8phkNHY07mMapnR/q4JfqPYy0jiKqYHIRJTDPzLARLF4
         KtGg==
X-Gm-Message-State: AC+VfDwAOxkwzoOc4g07DmTyqiqisSVfOKs5uVEnp+cR0lWSuvraI+35
        Dc/Ds2r33utDdW7CRjdK2288UcmzeX8=
X-Google-Smtp-Source: ACHHUZ5UDykUofDWptpYeKLYKUT4lJwC6hmS67vt4RZ2J9Vlllz6wQ7TTKu52RE+bGzNl7D3clsor4HUmDQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fb85:b0:1a6:8a07:960a with SMTP id
 lg5-20020a170902fb8500b001a68a07960amr166701plb.0.1685668524538; Thu, 01 Jun
 2023 18:15:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Jun 2023 18:15:17 -0700
In-Reply-To: <20230602011518.787006-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230602011518.787006-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230602011518.787006-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: x86: Use standard mmu_notifier invalidate hooks for
 APIC access page
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that KVM honors past and in-progress mmu_notifier invalidations when
reloading the APIC-access page, use KVM's "standard" invalidation hooks
to trigger a reload and delete the one-off usage of invalidate_range().

Aside from eliminating one-off code in KVM, dropping KVM's use of
invalidate_range() will allow common mmu_notifier to redefine the API to
be more strictly focused on invalidating secondary TLBs that share the
primary MMU's page tables.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   |  3 +++
 arch/x86/kvm/x86.c       | 14 --------------
 include/linux/kvm_host.h |  3 ---
 virt/kvm/kvm_main.c      | 18 ------------------
 4 files changed, 3 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8961f45e3b1..01a11ce68e57 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1600,6 +1600,9 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (tdp_mmu_enabled)
 		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
 
+	if (range->slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT)
+		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
+
 	return flush;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ceb7c5e9cf9e..141a62e59d2b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10431,20 +10431,6 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
 		vcpu, (u64 *)vcpu->arch.ioapic_handled_vectors);
 }
 
-void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
-					    unsigned long start, unsigned long end)
-{
-	unsigned long apic_address;
-
-	/*
-	 * The physical address of apic access page is stored in the VMCS.
-	 * Update it when it becomes invalid.
-	 */
-	apic_address = gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
-	if (start <= apic_address && apic_address < end)
-		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
-}
-
 void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
 {
 	static_call_cond(kvm_x86_guest_memory_reclaimed)(kvm);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0e571e973bc2..cb66f4100be7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2237,9 +2237,6 @@ static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
 }
 #endif /* CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL */
 
-void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
-					    unsigned long start, unsigned long end);
-
 void kvm_arch_guest_memory_reclaimed(struct kvm *kvm);
 
 #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cb5c13eee193..844ff6b0b21d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -154,11 +154,6 @@ static unsigned long long kvm_active_vms;
 
 static DEFINE_PER_CPU(cpumask_var_t, cpu_kick_mask);
 
-__weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
-						   unsigned long start, unsigned long end)
-{
-}
-
 __weak void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
 {
 }
@@ -521,18 +516,6 @@ static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
 	return container_of(mn, struct kvm, mmu_notifier);
 }
 
-static void kvm_mmu_notifier_invalidate_range(struct mmu_notifier *mn,
-					      struct mm_struct *mm,
-					      unsigned long start, unsigned long end)
-{
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int idx;
-
-	idx = srcu_read_lock(&kvm->srcu);
-	kvm_arch_mmu_notifier_invalidate_range(kvm, start, end);
-	srcu_read_unlock(&kvm->srcu, idx);
-}
-
 typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
 
 typedef void (*on_lock_fn_t)(struct kvm *kvm, unsigned long start,
@@ -892,7 +875,6 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 }
 
 static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
-	.invalidate_range	= kvm_mmu_notifier_invalidate_range,
 	.invalidate_range_start	= kvm_mmu_notifier_invalidate_range_start,
 	.invalidate_range_end	= kvm_mmu_notifier_invalidate_range_end,
 	.clear_flush_young	= kvm_mmu_notifier_clear_flush_young,
-- 
2.41.0.rc2.161.g9c6817b8e7-goog


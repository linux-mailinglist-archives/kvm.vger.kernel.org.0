Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2F748A162
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 22:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343766AbiAJVFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 16:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239741AbiAJVFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 16:05:04 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E90C06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 13:05:04 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id ik6-20020a170902ab0600b0014a1e5aab34so1994102plb.21
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 13:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SblhaXcWijIzk0Mapv3cGqzGg1Y0/XESvuNWuvJevdk=;
        b=tJhw8ZATrv3Sjy9QhepZUWpfX9dTE8Ja4a0R/EZCvyfUQj/+OWsQL94ONBjWVMpaez
         b2bNJQTqp6okRMwCqrN5Tt4UOCN2V+ptEfZEk3C3g/c8Y//NHMFgSJRgtIdayXr0LemP
         UYcHoRiyjMfoQJC5LpxjbMcsa+oSbLKuBbaungcF3668+S7YF9EKmn4bGkYxiQEmQlke
         wBmpEIHWalDlZEJLoE+Zgt3IZ9NyHxeGMLCwYNIdPApvX/MtGJGslz6BjO464WpeSKwZ
         VEuOU2T24qaEojHNtI8BfU84V+5HoQzHehfcEfTff+Wvb5WL8jlpl/iyJK9Y6IbsYFvY
         w+mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SblhaXcWijIzk0Mapv3cGqzGg1Y0/XESvuNWuvJevdk=;
        b=Q5sauPqisO1ZEgaMg8wwEzUFJPevDLD0Ak3JuWDvh47HFI08abGBygweua3gQM2O42
         dvyFa2d8OY9o96kK35PpT6+FB1SzCcnTrJBQnCzsCtk2BCxTnx+BGjEl4vX9zgc+3sur
         2rA2xe1ZcjEYQUvztP1i39WkaxxN73XfQ4gmb4fAFqdPK0EpjNniUPGe3ifE9HVFd3GE
         H1EWLV999UpRVXISqyY8HCaiNc09NyRC6AGD6CjBNDdl2DAag6gqZcuC2ILXA8NEVMM3
         Ag10ZPmFavcKYv4R96k7YrOsng4RDtT4tpiTAR3rfw7tkoqBtCKo8dM4TAekzwtJvN9Y
         hKHw==
X-Gm-Message-State: AOAM532foVdupRXBl3JUfk8Gwtw7dqFTqGa5s2vW0qDw+rfWy5SHvqE3
        +OwkMLONMnuD2NpvYfz3JzD1aAIxMKeChtc49Yw/PJI6qi3CSiZmyH07gMbexNXgp09Z46OVRkj
        49DaF6216bHrHkMWTx8s9MRGEiQhzIrkcKh27coJ6mLzstQAKYi2NlXhjjOdnYtJBztURs20=
X-Google-Smtp-Source: ABdhPJyZXewBlKNnGyc7EiD71gjJFzijvf+twsuG6PIplDMkIgqq41GFwCDp+OOvS5LS/4e8YnTET8+Nw0N7jOmrdQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:c407:b0:149:2ef4:b6b2 with
 SMTP id k7-20020a170902c40700b001492ef4b6b2mr1490383plk.112.1641848703948;
 Mon, 10 Jan 2022 13:05:03 -0800 (PST)
Date:   Mon, 10 Jan 2022 21:04:40 +0000
In-Reply-To: <20220110210441.2074798-1-jingzhangos@google.com>
Message-Id: <20220110210441.2074798-3-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [RFC PATCH 2/3] KVM: arm64: Add fast path to handle permission
 relaxation during dirty logging
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To reduce MMU lock contention during dirty logging, all permission
relaxation operations would be performed under read lock.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/mmu.c | 50 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cafd5813c949..dd1f43fba4b0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1063,6 +1063,54 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 	return 0;
 }
 
+static bool fast_mark_writable(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+		struct kvm_memory_slot *memslot, unsigned long fault_status)
+{
+	int ret;
+	bool writable;
+	bool write_fault = kvm_is_write_fault(vcpu);
+	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
+	kvm_pfn_t pfn;
+	struct kvm *kvm = vcpu->kvm;
+	bool logging_active = memslot_is_logging(memslot);
+	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
+	unsigned long fault_granule;
+
+	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
+
+	/* Make sure the fault can be handled in the fast path.
+	 * Only handle write permission fault on non-hugepage during dirty
+	 * logging period.
+	 */
+	if (fault_status != FSC_PERM || fault_granule != PAGE_SIZE
+			|| !logging_active || !write_fault)
+		return false;
+
+
+	/* Pin the pfn to make sure it couldn't be freed and be resued for
+	 * another gfn.
+	 */
+	pfn = __gfn_to_pfn_memslot(memslot, gfn, true, NULL,
+				   write_fault, &writable, NULL);
+	if (is_error_pfn(pfn) || !writable)
+		return false;
+
+	read_lock(&kvm->mmu_lock);
+	ret = kvm_pgtable_stage2_relax_perms(
+			vcpu->arch.hw_mmu->pgt, fault_ipa, PAGE_HYP);
+
+	if (!ret) {
+		kvm_set_pfn_dirty(pfn);
+		mark_page_dirty_in_slot(kvm, memslot, gfn);
+	}
+	read_unlock(&kvm->mmu_lock);
+
+	kvm_set_pfn_accessed(pfn);
+	kvm_release_pfn_clean(pfn);
+
+	return true;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
@@ -1085,6 +1133,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 
+	if (fast_mark_writable(vcpu, fault_ipa, memslot, fault_status))
+		return 0;
 	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
 	write_fault = kvm_is_write_fault(vcpu);
 	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
-- 
2.34.1.575.g55b058a8bb-goog


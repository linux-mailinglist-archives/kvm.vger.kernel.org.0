Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1431C5030D8
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiDOWCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356159AbiDOWBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:01:53 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB77DE88
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:24 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id d19-20020a0566022bf300b00645eba5c992so5453372ioy.4
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=we5tUcZWUFX29TKi0tS/Yi5sEjxnPk5PaYrhMJdNw1U=;
        b=O1SErvMM/5NizynFN7dxIWF/wAOfb8Mq9ZfTSGeW0QBIGQpcAPGMZiYPK5b+AIE+yj
         08zA/OxjxYQfyzgWCjGX98P8LIEuoV19f+IbszwnCQUQtevPI3XYw1re2k4fZZe6/vAf
         Qpexkx6ehQQAsh1RxGlFf+N5b4EPHjVdZkItOeRiv/yIkybMfQ6rKCCTjah2MjXE8ysA
         UfJUeFHEmDdjsqYhKAbeH01CdWClTD/JQdzWn2NRgu/MbALmGjnCzElEQCYlDtSQfUul
         EPbBWfGohELG4mrVx0BVrh06dZ/wmMGcdkJN6MSYmZEdZM8jKw5KOVWNj7WfK3JyNrde
         ComQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=we5tUcZWUFX29TKi0tS/Yi5sEjxnPk5PaYrhMJdNw1U=;
        b=o0XHWhKsaiztLT/N9YB2FpaQeS1g5xuPk0Arbb22Oj9Ow3EkiU3gXH3zLPF4LUOMVe
         OvBsN0+ce+pn6X1ACpSE0nuwG0UDW+x3argJXttIYHolf11S2pplyKsuOkdlMGqITPRZ
         9betibpBMY4fT+1XadVQ/vwtqgCSNEgvcGtjhiFS/xHr8VbrMT6iXh3Oj0ULcJB9aGKQ
         ktnNaGeQdkBVpOCafrvsxrDMbH1f/E0Fy7pp8kA587mOScgng6NNeKlb9PnqJfQNgcIU
         0PQS8m4nPks5Y6HCX4fRurakeeYL1TT0SqFJBlhvp9m7pNXQ4DPQ5Kjz+sUBO/+wRsoV
         TCwQ==
X-Gm-Message-State: AOAM532FAXzi0vnNNB+g0VFTmLgrhVlncrAz+nA4PJN2o6qSz8fZo5nj
        Y3xiU67Xe3xx2rqX43jKyALRIju7+mQ=
X-Google-Smtp-Source: ABdhPJzFhPu6MxIliWrYx7BlAqWDvC1LTp6uI8FxSJyQJeYO+JKxmOQwyxXOX0XwY8FpVX7WQSGMEYCJYH0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1807:b0:2ca:4b88:1a42 with SMTP id
 a7-20020a056e02180700b002ca4b881a42mr312136ilv.258.1650059963514; Fri, 15 Apr
 2022 14:59:23 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:59:00 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-17-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 16/17] KVM: arm64: Enable parallel stage 2 MMU faults
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
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

Voila! Since the map walkers are able to work in parallel there is no
need to take the write lock on a stage 2 memory abort. Relax locking
on map operations and cross fingers we got it right.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/mmu.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 63cf18cdb978..2881051c3743 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1127,7 +1127,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
-	bool use_read_lock = false;
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
 	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
@@ -1162,8 +1161,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (logging_active) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
-		use_read_lock = (fault_status == FSC_PERM && write_fault &&
-				 fault_granule == PAGE_SIZE);
 	} else {
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
@@ -1267,15 +1264,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && device)
 		return -ENOEXEC;
 
-	/*
-	 * To reduce MMU contentions and enhance concurrency during dirty
-	 * logging dirty logging, only acquire read lock for permission
-	 * relaxation.
-	 */
-	if (use_read_lock)
-		read_lock(&kvm->mmu_lock);
-	else
-		write_lock(&kvm->mmu_lock);
+	read_lock(&kvm->mmu_lock);
+
 	pgt = vcpu->arch.hw_mmu->pgt;
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -1322,8 +1312,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (fault_status == FSC_PERM && vma_pagesize == fault_granule) {
 		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
 	} else {
-		WARN_ONCE(use_read_lock, "Attempted stage-2 map outside of write lock\n");
-
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
 					     mmu_caches, true);
@@ -1336,10 +1324,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
-	if (use_read_lock)
-		read_unlock(&kvm->mmu_lock);
-	else
-		write_unlock(&kvm->mmu_lock);
+	read_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(pfn);
 	kvm_release_pfn_clean(pfn);
 	return ret != -EAGAIN ? ret : 0;
-- 
2.36.0.rc0.470.gd361397f0d-goog


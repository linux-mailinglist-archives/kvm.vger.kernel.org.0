Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9740179923C
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 00:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343913AbjIHWaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 18:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343915AbjIHWaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 18:30:03 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061721FE8
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 15:29:59 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d7e4151d07aso2543385276.2
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 15:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212198; x=1694816998; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jB1z42QoJJDiLaHgs90ydsyq4F02cKAC+BVC0dKoEvo=;
        b=efumdTe08f4NOcfweGgJYHEyMSVtZZgCREm+aQ7qJ9wpAPD6zOE/EzFGunKilm1HQI
         yUVqvP2wRrgHyz3iA2KOlBERp2RDk1g9HBzLpitvsLlGEvaqY9LWvcQhB3VSvI3dkt2P
         eS0quoF+/O30tqvlV6PCpNMkK3MEKw6mxhi5p8oGQwSOJjuNh+3NjZ+/Uvwp0eB3YW3U
         /CSc2KBAq9dEXhuCyAqWMgzVL0eWxbDfzFg9H+Uc2ScU12b0w9BQ7EqyHBj0pqd92fiS
         Td51hqks67BcoJxB3CG9JcTiobhUffQwyj9iswzpIKF6SVH3QCd7c8zIiZAVafZXYY4u
         IB7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212198; x=1694816998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jB1z42QoJJDiLaHgs90ydsyq4F02cKAC+BVC0dKoEvo=;
        b=FxpEe8CpKplnyEcCwKeUNUAkyjqlB+mWfEFcqvMU/qChnJ0gDIpesX0h74nbKIIPXU
         rSqSYhRG6YFoHpGGpr4id2kv/HdPbrZxZFAp1yT4VvMjrE7gu6l1BHvhj8CnFig+DfeF
         CteTOiFcZymFx090LlX/xqoGF+qwBGEATx+rI7sr8yZRZhPwwUS+FdcQ6Ux5yHC2cZ1q
         09BECQToI3+/3ZreIYFxqUqzdfO/ng3HOh95I5sbMfOYIoVd4e0Czb1AJhrZWaNR1D83
         me9OJBwrIxpnW7qZhDXSJzveK46ag0R0FcQCdEJj5xvruN9HZiy81SsKWC2YBYQpxw9j
         Yg4w==
X-Gm-Message-State: AOJu0YzSSLIPJ2Xw8cUCm1cyA5H5itD2CyKB0YsO5r9Ypyf5gFby3SSE
        4NCPYLSwYVwhcWHC5KanCHU2Lyfepu+5PA==
X-Google-Smtp-Source: AGHT+IEBLxxxYVBptOyfP6KR32iQyaj2s2xoKKyou0JBv0ZaSfmRl920VzlS/FX6mB4CaGl6pX8rcmbMlSRqAw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:d4c9:0:b0:d78:f45:d7bd with SMTP id
 m192-20020a25d4c9000000b00d780f45d7bdmr83912ybf.4.1694212198302; Fri, 08 Sep
 2023 15:29:58 -0700 (PDT)
Date:   Fri,  8 Sep 2023 22:28:57 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-11-amoorthy@google.com>
Subject: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change the "atomic" parameter of __gfn_to_pfn_memslot() to an enum which
reflects the possibility of allowig non-atomic accesses (GUP calls)
being "upgraded" to atomic, and mark locations where such upgrading is
allowed.

Concerning gfn_to_pfn_prot(): this function is unused on x86, and the
only usage on arm64 is from a codepath where upgrading gup calls to
atomic based on the memslot is undesirable. Therefore, punt on adding
any plumbing to expose the 'atomicity' parameter.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/arm64/kvm/mmu.c                   |  4 +--
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  3 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  3 +-
 arch/x86/kvm/mmu/mmu.c                 |  8 +++---
 include/linux/kvm_host.h               | 14 +++++++++-
 virt/kvm/kvm_main.c                    | 38 ++++++++++++++++++++------
 6 files changed, 53 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8ede6c5edc5f..ac77ae5b5d2b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1502,8 +1502,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-				   write_fault, &writable, NULL);
+	pfn = __gfn_to_pfn_memslot(memslot, gfn, MEMSLOT_ACCESS_NONATOMIC_MAY_UPGRADE,
+				   false, NULL, write_fault, &writable, NULL);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 7f765d5ad436..ab7caa86aa16 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -612,7 +612,8 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 		write_ok = true;
 	} else {
 		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
+		pfn = __gfn_to_pfn_memslot(memslot, gfn, MEMSLOT_ACCESS_FORCE_ALLOW_NONATOMIC,
+					   false, NULL,
 					   writing, &write_ok, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 572707858d65..3fa05c8e96b0 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -846,7 +846,8 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 		unsigned long pfn;
 
 		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
+		pfn = __gfn_to_pfn_memslot(memslot, gfn, MEMSLOT_ACCESS_FORCE_ALLOW_NONATOMIC,
+					   false, NULL,
 					   writing, upgrade_p, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index deae8ac74d9a..43516eb50e06 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4297,8 +4297,8 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	}
 
 	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
-					  fault->write, &fault->map_writable,
+	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, MEMSLOT_ACCESS_NONATOMIC_MAY_UPGRADE,
+					  false, &async, fault->write, &fault->map_writable,
 					  &fault->hva);
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
@@ -4319,8 +4319,8 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * to wait for IO.  Note, gup always bails if it is unable to quickly
 	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
 	 */
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
-					  fault->write, &fault->map_writable,
+	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, MEMSLOT_ACCESS_NONATOMIC_MAY_UPGRADE,
+					  true, NULL, fault->write, &fault->map_writable,
 					  &fault->hva);
 	return RET_PF_CONTINUE;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index db5c3eae58fe..fdd386e1d3c0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1188,8 +1188,20 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable);
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn);
+enum memslot_access_atomicity {
+	/* Force atomic access */
+	MEMSLOT_ACCESS_ATOMIC,
+	/*
+	 * Ask for non-atomic access, but allow upgrading to atomic depending
+	 * on the memslot
+	 */
+	MEMSLOT_ACCESS_NONATOMIC_MAY_UPGRADE,
+	/* Force non-atomic access */
+	MEMSLOT_ACCESS_FORCE_ALLOW_NONATOMIC
+};
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool atomic, bool interruptible, bool *async,
+			       enum memslot_access_atomicity atomicity,
+			       bool interruptible, bool *async,
 			       bool write_fault, bool *writable, hva_t *hva);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index aa81e41b1488..d4f4ccb29e6d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2735,9 +2735,11 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
 }
 
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool atomic, bool interruptible, bool *async,
+			       enum memslot_access_atomicity atomicity,
+			       bool interruptible, bool *async,
 			       bool write_fault, bool *writable, hva_t *hva)
 {
+	bool atomic;
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
 
 	if (hva)
@@ -2759,6 +2761,23 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 		writable = NULL;
 	}
 
+	if (atomicity == MEMSLOT_ACCESS_ATOMIC) {
+		atomic = true;
+	} else if (atomicity == MEMSLOT_ACCESS_NONATOMIC_MAY_UPGRADE) {
+		atomic = false;
+		if (kvm_is_slot_userfault_on_missing(slot)) {
+			atomic = true;
+			if (async) {
+				*async = false;
+				async = NULL;
+			}
+		}
+	} else if (atomicity == MEMSLOT_ACCESS_FORCE_ALLOW_NONATOMIC) {
+		atomic = false;
+	} else {
+		BUG();
+	}
+
 	return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
 			  writable);
 }
@@ -2767,22 +2786,23 @@ EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
-	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, false,
-				    NULL, write_fault, writable, NULL);
+	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn,
+				    MEMSLOT_ACCESS_FORCE_ALLOW_NONATOMIC,
+				    false, NULL, write_fault, writable, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, false, NULL, true,
-				    NULL, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, MEMSLOT_ACCESS_NONATOMIC_MAY_UPGRADE,
+				    false, NULL, true, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, true, false, NULL, true,
-				    NULL, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, MEMSLOT_ACCESS_ATOMIC,
+				    false, NULL, true, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
@@ -2862,7 +2882,9 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 	if (!map)
 		return -EINVAL;
 
-	pfn = gfn_to_pfn(vcpu->kvm, gfn);
+	pfn = __gfn_to_pfn_memslot(gfn_to_memslot(vcpu->kvm, gfn), gfn,
+				   MEMSLOT_ACCESS_FORCE_ALLOW_NONATOMIC,
+				   false, NULL, true, NULL, NULL);
 	if (is_error_noslot_pfn(pfn))
 		return -EINVAL;
 
-- 
2.42.0.283.g2d96d420d3-goog


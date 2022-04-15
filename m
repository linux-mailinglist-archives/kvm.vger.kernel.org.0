Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEBC4501FD1
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 02:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241513AbiDOAxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 20:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348238AbiDOAxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 20:53:38 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E8DB8207
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 17:51:11 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id n4-20020a170902f60400b00158d1f2d442so422090plg.18
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 17:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=6JrZgjK1B5w7h8U94glK+C1LeGU/Jol1K2w7lVhvS3s=;
        b=GrC43pd4SIaiHUvku3a88Z3nzDZywLGVP8+2veuqWnG9rDauQSuE2DCk/VFqs6H80T
         HVMn9yvmJ39T9/ziuvIJ+lrk8IQX9cdNgLFv2qpT1nIxniOXwB+FOc1pNV+ABEMYCCQC
         pveTzyagMDFs0XY6g/NNkEW0XKOxNdONurpsRXCsGivaYxzoPq5c1r+Zaot6QUgK1jvh
         uI+jq8TWgZM23nlDFY9Bl98ySb20Nj0/zlM09rAheaiWupsLwaq82Gn6vx6fZi8vkxrv
         EkK7ficFmYbB/OMzqIx4SZi4T0Z9L72mIiMrRcXXG3a95JLvV86xgKAGwA7WX2MeLrWN
         4CKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=6JrZgjK1B5w7h8U94glK+C1LeGU/Jol1K2w7lVhvS3s=;
        b=5Yd+kuyCIovvrQwAQJgSJ8bmYv6Vz90mls3ZKgzwsITGs78XlkzjTAjYXN2gZabsO8
         pBuwxpCfnOovIC3pwsF6rCaWNmR+oxlybViYNpQ3KyoGTBPgb9vLLHIxqzQE5ENJ04zb
         Ya+W4a7a/J8opuxRqN24QQ9QVnk5MUrC17L1guCuCxcLqQBIPXwgnENP5iKMcQgfun3Z
         XfHY+RFeIQqvlQfIb/jNGdRABOVNkaFz9qVkCV1n/fZIKLRXZsmT/Lizii8qZoMUDjPy
         n93xbvqJrq/M0zSyl5kTBxSDq0bWEzLMiCHBfHJEnPil/pVxsFnPrcHFPqfFBv1kd501
         222w==
X-Gm-Message-State: AOAM53051W8MYXHp433H8tWyslyA1hUBovGI4NgEK00YoAq5ImrsRBMb
        UZm0oHu01KNAVoX9BBPiZJMo4Rr3rzo=
X-Google-Smtp-Source: ABdhPJzJsKfhBm14JLzfIMaXG6pQbTDgQz7JIuehsBhP7vcisJfayI4juvmLip0UXvDVclT9bolM+9/Ubyg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:858b:b0:1c6:5bc8:781a with SMTP id
 m11-20020a17090a858b00b001c65bc8781amr198458pjn.0.1649983871123; Thu, 14 Apr
 2022 17:51:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Apr 2022 00:51:07 +0000
Message-Id: <20220415005107.2221672-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH] KVM: x86/mmu: Add RET_PF_CONTINUE to eliminate bool+int* "returns"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
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

Add RET_PF_CONTINUE and use it in handle_abnormal_pfn() and
kvm_faultin_pfn() to signal that the page fault handler should continue
doing its thing.  Aside from being gross and inefficient, using a boolean
return to signal continue vs. stop makes it extremely difficult to add
more helpers and/or move existing code to a helper.

E.g. hypothetically, if nested MMUs were to gain a separate page fault
handler in the future, everything up to the "is self-modifying PTE" check
can be shared by all shadow MMUs, but communicating up the stack whether
to continue on or stop becomes a nightmare.

More concretely, proposed support for private guest memory ran into a
similar issue, where it'll be forced to forego a helper in order to yield
sane code: https://lore.kernel.org/all/YkJbxiL%2FAz7olWlq@google.com.

No functional change intended.

Cc: David Matlack <dmatlack@google.com>
Cc: Chao Peng <chao.p.peng@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 51 ++++++++++++++-------------------
 arch/x86/kvm/mmu/mmu_internal.h |  9 +++++-
 arch/x86/kvm/mmu/paging_tmpl.h  |  6 ++--
 3 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 69a30d6d1e2b..cb2982c6b513 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2972,14 +2972,12 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 	return -EFAULT;
 }
 
-static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
-				unsigned int access, int *ret_val)
+static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+			       unsigned int access)
 {
 	/* The pfn is invalid, report the error! */
-	if (unlikely(is_error_pfn(fault->pfn))) {
-		*ret_val = kvm_handle_bad_page(vcpu, fault->gfn, fault->pfn);
-		return true;
-	}
+	if (unlikely(is_error_pfn(fault->pfn)))
+		return kvm_handle_bad_page(vcpu, fault->gfn, fault->pfn);
 
 	if (unlikely(!fault->slot)) {
 		gva_t gva = fault->is_tdp ? 0 : fault->addr;
@@ -2991,13 +2989,11 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		 * touching the shadow page tables as attempting to install an
 		 * MMIO SPTE will just be an expensive nop.
 		 */
-		if (unlikely(!shadow_mmio_value)) {
-			*ret_val = RET_PF_EMULATE;
-			return true;
-		}
+		if (unlikely(!shadow_mmio_value))
+			return RET_PF_EMULATE;
 	}
 
-	return false;
+	return RET_PF_CONTINUE;
 }
 
 static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
@@ -3888,7 +3884,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
 }
 
-static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault, int *r)
+static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
@@ -3899,7 +3895,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
 	 */
 	if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
-		goto out_retry;
+		return RET_PF_RETRY;
 
 	if (!kvm_is_visible_memslot(slot)) {
 		/* Don't expose private memslots to L2. */
@@ -3907,7 +3903,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			fault->slot = NULL;
 			fault->pfn = KVM_PFN_NOSLOT;
 			fault->map_writable = false;
-			return false;
+			return RET_PF_CONTINUE;
 		}
 		/*
 		 * If the APIC access page exists but is disabled, go directly
@@ -3916,10 +3912,8 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		 * when the AVIC is re-enabled.
 		 */
 		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
-		    !kvm_apicv_activated(vcpu->kvm)) {
-			*r = RET_PF_EMULATE;
-			return true;
-		}
+		    !kvm_apicv_activated(vcpu->kvm))
+			return RET_PF_EMULATE;
 	}
 
 	async = false;
@@ -3927,26 +3921,23 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 					  fault->write, &fault->map_writable,
 					  &fault->hva);
 	if (!async)
-		return false; /* *pfn has correct page already */
+		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
 	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
 		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
 		if (kvm_find_async_pf_gfn(vcpu, fault->gfn)) {
 			trace_kvm_async_pf_doublefault(fault->addr, fault->gfn);
 			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
-			goto out_retry;
-		} else if (kvm_arch_setup_async_pf(vcpu, fault->addr, fault->gfn))
-			goto out_retry;
+			return RET_PF_RETRY;
+		} else if (kvm_arch_setup_async_pf(vcpu, fault->addr, fault->gfn)) {
+			return RET_PF_RETRY;
+		}
 	}
 
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, NULL,
 					  fault->write, &fault->map_writable,
 					  &fault->hva);
-	return false;
-
-out_retry:
-	*r = RET_PF_RETRY;
-	return true;
+	return RET_PF_CONTINUE;
 }
 
 /*
@@ -4001,10 +3992,12 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (kvm_faultin_pfn(vcpu, fault, &r))
+	r = kvm_faultin_pfn(vcpu, fault);
+	if (r != RET_PF_CONTINUE)
 		return r;
 
-	if (handle_abnormal_pfn(vcpu, fault, ACC_ALL, &r))
+	r = handle_abnormal_pfn(vcpu, fault, ACC_ALL);
+	if (r != RET_PF_CONTINUE)
 		return r;
 
 	r = RET_PF_RETRY;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1bff453f7cbe..c0e502b17ef7 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -143,6 +143,7 @@ unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 /*
  * Return values of handle_mmio_page_fault, mmu.page_fault, and fast_page_fault().
  *
+ * RET_PF_CONTINUE: So far, so good, keep handling the page fault.
  * RET_PF_RETRY: let CPU fault again on the address.
  * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
  * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
@@ -151,9 +152,15 @@ unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
  *
  * Any names added to this enum should be exported to userspace for use in
  * tracepoints via TRACE_DEFINE_ENUM() in mmutrace.h
+ *
+ * Note, all values must be greater than or equal to zero so as not to encroach
+ * on -errno return values.  Somewhat arbitrarily use '0' for CONTINUE, which
+ * will allow for efficient machine code when checking for CONTINUE, e.g.
+ * "TEST %rax, %rax, JNZ", as all "stop!" values are non-zero.
  */
 enum {
-	RET_PF_RETRY = 0,
+	RET_PF_CONTINUE = 0,
+	RET_PF_RETRY,
 	RET_PF_EMULATE,
 	RET_PF_INVALID,
 	RET_PF_FIXED,
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 66f1acf153c4..7038273d04ab 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -838,10 +838,12 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (kvm_faultin_pfn(vcpu, fault, &r))
+	r = kvm_faultin_pfn(vcpu, fault);
+	if (r != RET_PF_CONTINUE)
 		return r;
 
-	if (handle_abnormal_pfn(vcpu, fault, walker.pte_access, &r))
+	r = handle_abnormal_pfn(vcpu, fault, walker.pte_access);
+	if (r != RET_PF_CONTINUE)
 		return r;
 
 	/*

base-commit: 150866cd0ec871c765181d145aa0912628289c8a
-- 
2.36.0.rc0.470.gd361397f0d-goog


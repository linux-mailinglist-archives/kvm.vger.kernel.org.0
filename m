Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7EB50C719
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 06:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbiDWDv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 23:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbiDWDvT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 23:51:19 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4ED91C3E6E
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:21 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id z5-20020a170902ccc500b0015716eaec65so5799502ple.14
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=QaIK5hbUNuIoBL/vPKNJJnLGWUg9x9GQfI0ts38CvUw=;
        b=FtNsmllT//XrLcX5ne2kL6yQKkeHsq3D2zI2Xzn8HpzZA6vzUqDZtNKOsa0PYyP+eL
         eSe6NitmPB4/hX1Mxolr+zv/gnK/yMOGcxLurUDIv71cWfwbnq1iA9RM9IreHWlO58uM
         dT4PKcEbwuI6NyNaJIQFCNIBFZ40Hc/MrA2ywsy6q7zFb1jhgb4e20lM0kXbmotCACTx
         3MI09l6cGQkKCuQlB/DzvHLdb0/vGIL4gnFQrrqE5ltI3gqw4NxJnpnMuFNE0SYM7o3M
         7Xfj5Jd8Ct7hGwx5fJJFyy77vN52n3Z/pmXnEunqjRBUz/qbFX8M36SZLEEtJXLkrnFB
         vdVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=QaIK5hbUNuIoBL/vPKNJJnLGWUg9x9GQfI0ts38CvUw=;
        b=tcQeu72uz0lFn0fzklS8BNFeYSA4oh7d9q9eqZzPNeKwTuQpHQYOZzzr1RkNSw7r1t
         eN+UsjmpQLtO2SFDh4jbtJvlw+ta273bSbEn005LP0X15rdU7Bj4FgnkNpKTItY4HTVq
         bR7an3Mgg1KdbgwaKcbgYUMhxGaznUy23uVCkpxp1QX7EMcmhMX5heeJBnM9zm84V6Vi
         8RSwy1CQUfMSoBj1XUsBekAnqZoOteloFNwbRos59EwYoT/7sKjbtKxI0vAlIlkHgbrA
         IcQ94cK6iokK367L4FqxzNlB/oKrmrgwERx/V0astP2CQ2l/xswrvz1SteQiTYqK5KLv
         AKVA==
X-Gm-Message-State: AOAM533ZorVOiBDpgResKAlH7HRX6FBdD2pbuRBC2UeCzsRIxp7wO7gG
        Dhdmzu90UoG8Q4lI9Ogur5pkMG3Iw7I=
X-Google-Smtp-Source: ABdhPJzewDqgk9TdQxLpF903Hqz7WXWv0VBiYFXxfvQYdLhtDL8p/28Ud5xlsAjN3E7FvZ7kT2AvsFpyJbI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1256:b0:4fb:1374:2f65 with SMTP id
 u22-20020a056a00125600b004fb13742f65mr8305139pfi.72.1650685701202; Fri, 22
 Apr 2022 20:48:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 03:47:46 +0000
In-Reply-To: <20220423034752.1161007-1-seanjc@google.com>
Message-Id: <20220423034752.1161007-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220423034752.1161007-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 06/12] KVM: x86/mmu: Add RET_PF_CONTINUE to eliminate
 bool+int* "returns"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
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
 arch/x86/kvm/mmu/mmutrace.h     |  1 +
 arch/x86/kvm/mmu/paging_tmpl.h  |  6 ++--
 4 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f1618d8289ce..f1e8d71e6f7c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2970,14 +2970,12 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
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
@@ -2989,13 +2987,11 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		 * touching the shadow page tables as attempting to install an
 		 * MMIO SPTE will just be an expensive nop.
 		 */
-		if (unlikely(!enable_mmio_caching)) {
-			*ret_val = RET_PF_EMULATE;
-			return true;
-		}
+		if (unlikely(!enable_mmio_caching))
+			return RET_PF_EMULATE;
 	}
 
-	return false;
+	return RET_PF_CONTINUE;
 }
 
 static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
@@ -3903,7 +3899,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
 }
 
-static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault, int *r)
+static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
@@ -3914,7 +3910,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
 	 */
 	if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
-		goto out_retry;
+		return RET_PF_RETRY;
 
 	if (!kvm_is_visible_memslot(slot)) {
 		/* Don't expose private memslots to L2. */
@@ -3922,7 +3918,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			fault->slot = NULL;
 			fault->pfn = KVM_PFN_NOSLOT;
 			fault->map_writable = false;
-			return false;
+			return RET_PF_CONTINUE;
 		}
 		/*
 		 * If the APIC access page exists but is disabled, go directly
@@ -3931,10 +3927,8 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
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
@@ -3942,26 +3936,23 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
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
@@ -4016,10 +4007,12 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index 12247b96af01..ae86820cef69 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -54,6 +54,7 @@
 	{ PFERR_RSVD_MASK, "RSVD" },	\
 	{ PFERR_FETCH_MASK, "F" }
 
+TRACE_DEFINE_ENUM(RET_PF_CONTINUE);
 TRACE_DEFINE_ENUM(RET_PF_RETRY);
 TRACE_DEFINE_ENUM(RET_PF_EMULATE);
 TRACE_DEFINE_ENUM(RET_PF_INVALID);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index b025decf610d..7f8f1c8dbed2 100644
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
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog


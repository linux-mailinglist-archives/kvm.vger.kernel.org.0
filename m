Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47AF50C718
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 06:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbiDWDvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 23:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbiDWDvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 23:51:14 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2998F1C37AE
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:18 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id a16-20020a62d410000000b00505734b752aso6564118pfh.4
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=s1FdvFSZ5B4eOljesil+5nZQsUnLyQTrJ9BbjzQR3zY=;
        b=dG4roe8tmNBs3teFZlh8AQCmDvgQZvVdbxLP3lsVzH1JbCuuVevt2rKfOqBKh9FwzH
         0L++ZsjttRWY8LjRlxb/2k8UzTLWR8IaheYNrtUBIGyfM0MpPto/9X/66EV5ytOqfI4N
         ZhSg5a5+4WtQpkXd08lpYFN8748PHSodN8+GXDDzsXBsEH9mKY/hQC2LN8Tq6/47EDOf
         kO6N0oP2vaHXSS4JMTFRKcjp/1nPA6FuLe8nJGUOnUNJAZ6LsdaGbx4RZtsYWjzUjRqb
         yF6Y0tPVEgcgFOIsUfHPmbU8nlWxYadO/5uCTOZjEQrZF65AvNMKw2uwprWDATQ5Gl/s
         Vz3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=s1FdvFSZ5B4eOljesil+5nZQsUnLyQTrJ9BbjzQR3zY=;
        b=T5yDSmE8NEJHBYA3IBUu3FnFZond4ks+jJuv1z9At0CnQr6wc+0QctW0sRZuTauo6q
         tVEOfXU9PdebJ0fL8LjPG+Fl55NfeD9tTumVaBYUrlBMB5k76euGsTAbAPvNq+nkpLBi
         P9c2vMkuQb+7eeABbGA9xCs7hnm2Y1wJNWDj5n6FKjLl/TvUt3M0+IYUhX307IKLfmhn
         /GUNQGdonfWuDcUjfN7NI6snt+NjUx6ExBMH5Td22IRgZNfDbRIRCf5AlUBuEgz8vABB
         oFSeVtWofruwriBqPDT/pB7UFZslCa6d8vDcx8SUjNv1Ts6IwmAlzOmvkvIPj46yz19P
         1Ejw==
X-Gm-Message-State: AOAM532xGYSbdBWuMFW20ChxbfwXBXb39DNmR5DhNarcWfv4F5rLM9OW
        dP4DWTMNLLKvwP4FV8+iLLSUkg+RnW8=
X-Google-Smtp-Source: ABdhPJz5NQNv1hdLtAQq4ffsV/hY9ndFZZJXFkD5aX28NMEWgpojXPxIe+Priq6HJRRLcXS48lPt84zpYlU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5d08:b0:1d7:9587:9288 with SMTP id
 s8-20020a17090a5d0800b001d795879288mr9142204pji.204.1650685697637; Fri, 22
 Apr 2022 20:48:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 03:47:44 +0000
In-Reply-To: <20220423034752.1161007-1-seanjc@google.com>
Message-Id: <20220423034752.1161007-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220423034752.1161007-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 04/12] KVM: x86/mmu: Don't attempt fast page fault just
 because EPT is in use
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check for A/D bits being disabled instead of the access tracking mask
being non-zero when deciding whether or not to attempt to fix a page
fault vian the fast path.  Originally, the access tracking mask was
non-zero if and only if A/D bits were disabled by _KVM_ (including not
being supported by hardware), but that hasn't been true since nVMX was
fixed to honor EPTP12's A/D enabling, i.e. since KVM allowed L1 to cause
KVM to not use A/D bits while running L2 despite KVM using them while
running L1.

In other words, don't attempt the fast path just because EPT is enabled.

Note, attempting the fast path for all !PRESENT faults can "fix" a very,
_VERY_ tiny percentage of faults out of mmu_lock by detecting that the
fault is spurious, i.e. has been fixed by a different vCPU, but again the
odds of that happening are vanishingly small.  E.g. booting an 8-vCPU VM
gets less than 10 successes out of 30k+ faults, and that's likely one of
the more favorable scenarios.  Disabling dirty logging can likely lead to
a rash of collisions between vCPUs for some workloads that operate on a
common set of pages, but penalizing _all_ !PRESENT faults for that one
case is unlikely to be a net positive, not to mention that that problem
is best solved by not zapping in the first place.

The number of spurious faults does scale with the number of vCPUs, e.g. a
255-vCPU VM using TDP "jumps" to ~60 spurious faults detected in the fast
path (again out of 30k), but that's all of 0.2% of faults.  Using legacy
shadow paging does get more spurious faults, and a few more detected out
of mmu_lock, but the percentage goes _down_ to 0.08% (and that's ignoring
faults that are reflected into the guest), i.e. the extra detections are
purely due to the sheer number of faults observed.

On the other hand, getting a "negative" in the fast path takes in the
neighborhood of 150-250 cycles.  So while it is tempting to keep/extend
the current behavior, such a change needs to come with hard numbers
showing that it's actually a win in the grand scheme, or any scheme for
that matter.

Fixes: 995f00a61958 ("x86: kvm: mmu: use ept a/d in vmcs02 iff used in vmcs12")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 45 ++++++++++++++++++++++++--------------
 arch/x86/kvm/mmu/spte.h    | 11 ++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
 3 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 65b723201738..dfd1cfa9c08c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3013,19 +3013,20 @@ static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
 
 	/*
 	 * #PF can be fast if:
-	 * 1. The shadow page table entry is not present, which could mean that
-	 *    the fault is potentially caused by access tracking (if enabled).
-	 * 2. The shadow page table entry is present and the fault
-	 *    is caused by write-protect, that means we just need change the W
-	 *    bit of the spte which can be done out of mmu-lock.
 	 *
-	 * However, if access tracking is disabled we know that a non-present
-	 * page must be a genuine page fault where we have to create a new SPTE.
-	 * So, if access tracking is disabled, we return true only for write
-	 * accesses to a present page.
+	 * 1. The shadow page table entry is not present and A/D bits are
+	 *    disabled _by KVM_, which could mean that the fault is potentially
+	 *    caused by access tracking (if enabled).  If A/D bits are enabled
+	 *    by KVM, but disabled by L1 for L2, KVM is forced to disable A/D
+	 *    bits for L2 and employ access tracking, but the fast page fault
+	 *    mechanism only supports direct MMUs.
+	 * 2. The shadow page table entry is present, the access is a write,
+	 *    and no reserved bits are set (MMIO SPTEs cannot be "fixed"), i.e.
+	 *    the fault was caused by a write-protection violation.  If the
+	 *    SPTE is MMU-writable (determined later), the fault can be fixed
+	 *    by setting the Writable bit, which can be done out of mmu_lock.
 	 */
-
-	return shadow_acc_track_mask != 0 || (fault->write && fault->present);
+	return !kvm_ad_enabled() || (fault->write && fault->present);
 }
 
 /*
@@ -3140,13 +3141,25 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 		new_spte = spte;
 
-		if (is_access_track_spte(spte))
+		/*
+		 * KVM only supports fixing page faults outside of MMU lock for
+		 * direct MMUs, nested MMUs are always indirect, and KVM always
+		 * uses A/D bits for non-nested MMUs.  Thus, if A/D bits are
+		 * enabled, the SPTE can't be an access-tracked SPTE.
+		 */
+		if (unlikely(!kvm_ad_enabled()) && is_access_track_spte(spte))
 			new_spte = restore_acc_track_spte(new_spte);
 
 		/*
-		 * Currently, to simplify the code, write-protection can
-		 * be removed in the fast path only if the SPTE was
-		 * write-protected for dirty-logging or access tracking.
+		 * To keep things simple, only SPTEs that are MMU-writable can
+		 * be made fully writable outside of mmu_lock, e.g. only SPTEs
+		 * that were write-protected for dirty-logging or access
+		 * tracking are handled here.  Don't bother checking if the
+		 * SPTE is writable to prioritize running with A/D bits enabled.
+		 * The is_access_allowed() check above handles the common case
+		 * of the fault being spurious, and the SPTE is known to be
+		 * shadow-present, i.e. except for access tracking restoration
+		 * making the new SPTE writable, the check is wasteful.
 		 */
 		if (fault->write && is_mmu_writable_spte(spte)) {
 			new_spte |= PT_WRITABLE_MASK;
@@ -4751,7 +4764,7 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	role.efer_nx = true;
 	role.smm = cpu_role.base.smm;
 	role.guest_mode = cpu_role.base.guest_mode;
-	role.ad_disabled = (shadow_accessed_mask == 0);
+	role.ad_disabled = !kvm_ad_enabled();
 	role.level = kvm_mmu_get_tdp_level(vcpu);
 	role.direct = true;
 	role.has_4_byte_gpte = false;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 098d7d144627..43ec7a8641b3 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -220,6 +220,17 @@ static inline bool is_shadow_present_pte(u64 pte)
 	return !!(pte & SPTE_MMU_PRESENT_MASK);
 }
 
+/*
+ * Returns true if A/D bits are supported in hardware and are enabled by KVM.
+ * When enabled, KVM uses A/D bits for all non-nested MMUs.  Because L1 can
+ * disable A/D bits in EPTP12, SP and SPTE variants are needed to handle the
+ * scenario where KVM is using A/D bits for L1, but not L2.
+ */
+static inline bool kvm_ad_enabled(void)
+{
+	return !!shadow_accessed_mask;
+}
+
 static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
 {
 	return sp->role.ad_disabled;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e9033cce8aeb..a2eda3e55697 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1135,7 +1135,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 			   struct kvm_mmu_page *sp, bool account_nx,
 			   bool shared)
 {
-	u64 spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
+	u64 spte = make_nonleaf_spte(sp->spt, !kvm_ad_enabled());
 	int ret = 0;
 
 	if (shared) {
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog


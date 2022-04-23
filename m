Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF1A50C720
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 06:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbiDWDvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 23:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiDWDvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 23:51:35 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7DD1C894F
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:30 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id bj12-20020a170902850c00b0015adf30aaccso3953835plb.15
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KV4Fo5a3dO6FFB3wbKkacVHrutnN8NJ0VpRE3b0g+kk=;
        b=ThnwOxcxDHHiupsaV5coB0vY0mPhYkihbiu/nKoipSLxRlJ9HOECjsKGcDZ/w/dCHV
         1NjwYL9dPQSTzddEpXngi6QF6VduMTNkE3mLZRzUme8A8QeKB/cmshdzB3FvKRhhk56q
         mWGXCGPmcjmxijCDOfuXjJTmCmgQVXs6C4XKVGpISvLBUVxgG71ZEZlSCgFsxG+qgj3m
         pyNLMVNriQc8aS9M2NMrbgfxsP+oPIfQXkVhQaIplsik43HRLOk2LFwrbo5iCEYL+tYg
         o9+IQvS8I/u/OwJuQYW32vFl3WT1II00K2rNZ9caop4bO79G8/aOWd3t8/mVt2938tgL
         T8zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KV4Fo5a3dO6FFB3wbKkacVHrutnN8NJ0VpRE3b0g+kk=;
        b=t0ORlcL4/Nk+1+WsQwURq77sEUjdNHgJ87u546YA4b+uqZobhdOlpqHxG0AWDfKDwA
         K0S/BO7VBC5OMvzBsEhOBpjdHMxVrLMQ0xddEU1+OT3onqL6wBotdSwBOv7wzRRpm4K7
         A/2t+urhyINr66PKOsjDmXNGFRq+z2TE85AvETwAxwJayt/9zHIkZZhWzai2eXVj11SM
         bSM4x8gT8O7GdLQSpcp8iCBRb/FW8UdCG8WJnbacBcDcqKeD4S+ow1kcrbqkwuJjOwfm
         y+lNhUusuIEGrUrQ31wxl2hR7XggqXF3+7OOhaA8J6TD6j8c+TVRqFnSyT2Q8LwYt3zq
         tl6Q==
X-Gm-Message-State: AOAM531LnmH0W4/j+YLC7HodPDTa2JEiAYk+/a9vaX5bEe0jT8Q0hgTC
        rjQcDRIR90OnUA06flIs5lwre3Y/Eyo=
X-Google-Smtp-Source: ABdhPJyKn4ZJL97YgXahf8sfZNpuwamE7Zun/i+Q2+UR6ydkW1QVf8xSlffiFad4YurJYsK65Kx50GZqWoU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:a50a:0:b0:506:cef:44f5 with SMTP id
 v10-20020a62a50a000000b005060cef44f5mr8215010pfm.22.1650685710013; Fri, 22
 Apr 2022 20:48:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 03:47:51 +0000
In-Reply-To: <20220423034752.1161007-1-seanjc@google.com>
Message-Id: <20220423034752.1161007-12-seanjc@google.com>
Mime-Version: 1.0
References: <20220423034752.1161007-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 11/12] DO NOT MERGE: KVM: x86/mmu: Use fast_page_fault() to
 detect spurious shadow MMU faults
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sounds good in theory, but in practice it's really, really rare to detect
a spurious fault outside of mmu_lock.  The window is teeny tiny, so more
likely than not, spurious faults won't be detected until the slow path,
not too mention spurious faults on !PRESENT pages are rare in and of
themselves.

Not-signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 28 ++++++++++++++++++----------
 arch/x86/kvm/mmu/paging_tmpl.h |  8 ++++++++
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7ba88907d032..850d58793307 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2994,7 +2994,7 @@ static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fau
 	return RET_PF_CONTINUE;
 }
 
-static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
+static bool page_fault_can_be_fast(struct kvm_page_fault *fault, bool direct_mmu)
 {
 	/*
 	 * Page faults with reserved bits set, i.e. faults on MMIO SPTEs, only
@@ -3025,8 +3025,12 @@ static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
 	 * either the primary MMU or the guest's page tables, and thus are
 	 * extremely unlikely to be resolved by KVM.  Note, instruction fetches
 	 * and writes are mutually exclusive, ignore the "exec" flag.
+	 *
+	 * KVM doesn't support resolving write-protection violations outside of
+	 * mmu_lock for indirect MMUs as the gfn is not stable for indirect
+	 * shadow pages. See Documentation/virt/kvm/locking.rst for details.
 	 */
-	return fault->write;
+	return fault->write && direct_mmu;
 }
 
 /*
@@ -3097,7 +3101,8 @@ static u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte)
 /*
  * Returns one of RET_PF_INVALID, RET_PF_FIXED or RET_PF_SPURIOUS.
  */
-static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+			   bool direct_mmu)
 {
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_INVALID;
@@ -3105,7 +3110,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	u64 *sptep = NULL;
 	uint retry_count = 0;
 
-	if (!page_fault_can_be_fast(fault))
+	if (!page_fault_can_be_fast(fault, direct_mmu))
 		return ret;
 
 	walk_shadow_page_lockless_begin(vcpu);
@@ -3140,6 +3145,14 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			break;
 		}
 
+		/*
+		 * KVM doesn't support fixing SPTEs outside of mmu_lock for
+		 * indirect MMUs as the gfn isn't stable for indirect shadow
+		 * pages. See Documentation/virt/kvm/locking.rst for details.
+		 */
+		if (!direct_mmu)
+			break;
+
 		new_spte = spte;
 
 		/*
@@ -3185,11 +3198,6 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		    !is_access_allowed(fault, new_spte))
 			break;
 
-		/*
-		 * Currently, fast page fault only works for direct mapping
-		 * since the gfn is not stable for indirect shadow page. See
-		 * Documentation/virt/kvm/locking.rst to get more detail.
-		 */
 		if (fast_pf_fix_direct_spte(vcpu, fault, sptep, spte, new_spte)) {
 			ret = RET_PF_FIXED;
 			break;
@@ -4018,7 +4026,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (page_fault_handle_page_track(vcpu, fault))
 		return RET_PF_EMULATE;
 
-	r = fast_page_fault(vcpu, fault);
+	r = fast_page_fault(vcpu, fault, true);
 	if (r != RET_PF_INVALID)
 		return r;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index db80f7ccaa4e..d33b01a2714e 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -812,6 +812,14 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return RET_PF_RETRY;
 	}
 
+	/* See if the fault has already been resolved by a different vCPU. */
+	r = fast_page_fault(vcpu, fault, false);
+	if (r == RET_PF_SPURIOUS)
+		return r;
+
+	/* Indirect page faults should never be fixed in the fast path. */
+	WARN_ON_ONCE(r != RET_PF_INVALID);
+
 	fault->gfn = walker.gfn;
 	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog


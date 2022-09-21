Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5B05C0558
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 19:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiIURgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 13:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiIURf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 13:35:58 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C64DA2635
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:35:57 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id ay1-20020a056a00300100b0053e7e97696bso3879729pfb.3
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=ZUXH2KhTaaeE9Toa4N2Y/qisHqn5Wrtu+fWXta18cWY=;
        b=TXNqEriqINa5qwtUCqOSA9p0YTVUR7LsPsoyfSI8eFTUISRH5s7JcWUPAEea1J6KIO
         LfZJTetMyGSC8EmXisoLyqZbxJNQPnpYn8zcI0hfX6hhLOlPofEezUgjSazpWyYWcL+D
         i3B3g5CfnZTFQcjzrWwlbJwZhdUpHmrj9yewzHoyq5e4/DTVO0CMiSuS+OuomY675wZU
         8IGDTD8ItJwH0c7kyh4SYSWX9i5dnosUfi1A1hnvBkkXG2MJA5McdIRQ/6ekt9J/BnLT
         6L4rvmdbquV/1aPwOEzWCvS9DAQVhropcPHsVR+72DLsx27M6oArKuWmdSGyql4RJXpP
         8w6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=ZUXH2KhTaaeE9Toa4N2Y/qisHqn5Wrtu+fWXta18cWY=;
        b=0Bm/2m9b63m1RNo/OYxgejj2uPUlA9STL9sv+HTDN4kH7m/WXUFJgLvV3XSAukOMpr
         xiXM7VbM3fZgIUpUpHPLyuSZVThr1+V5f+O/Ma9GwftsT2J80RzXrgBo3s4ld6gXvj0/
         G1a4T+rOgAthYlWkIad49X+d5iwAjTtL7jx3yr0oPttTz7Fkzb7yf/YFkuZwtm+SJ8rz
         bmrMhE+/6KAn1ouSIi5Xo98+xmwUtwAW6IbcxGKogXqIEiGSW8HYDpuUmaRiGAsAqEKd
         Y2GeIYfOTe97xyD1thXJ7SHTnnCDBScmN+a5XILzdXl3HOWfNqA277Wt2hbIRFyyjp0q
         BLKw==
X-Gm-Message-State: ACrzQf2SKsOK4uo70Om7nyVd6CpWxLG5xB91a8RcJlZk5zLNa8Xn9O+E
        Ksgkd+xIjtxuPX+U1tKinqirpb2GnMvREw==
X-Google-Smtp-Source: AMsMyM75a8O0NE87klELHjMCON0/apfFB2x8KLgbFiEn7c1sPxlXbn0vXmY2YRJ8ZNVE6gCfX4o9VXWpIW+ueA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:10a:b0:200:2849:235f with SMTP id
 p10-20020a17090b010a00b002002849235fmr813728pjz.1.1663781756623; Wed, 21 Sep
 2022 10:35:56 -0700 (PDT)
Date:   Wed, 21 Sep 2022 10:35:39 -0700
In-Reply-To: <20220921173546.2674386-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220921173546.2674386-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220921173546.2674386-4-dmatlack@google.com>
Subject: [PATCH v3 03/10] KVM: x86/mmu: Grab mmu_invalidate_seq in kvm_faultin_pfn()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
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

Grab mmu_invalidate_seq in kvm_faultin_pfn() and stash it in struct
kvm_page_fault. The eliminates duplicate code and reduces the amount of
parameters needed for is_page_fault_stale().

Preemptively split out __kvm_faultin_pfn() to a separate function for
use in subsequent commits.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 21 ++++++++++++---------
 arch/x86/kvm/mmu/mmu_internal.h |  1 +
 arch/x86/kvm/mmu/paging_tmpl.h  |  6 +-----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dd261cd2ad4e..31b835d20762 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4129,7 +4129,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
 }
 
-static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
@@ -4185,12 +4185,20 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return RET_PF_CONTINUE;
 }
 
+static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+{
+	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+	smp_rmb();
+
+	return __kvm_faultin_pfn(vcpu, fault);
+}
+
 /*
  * Returns true if the page fault is stale and needs to be retried, i.e. if the
  * root was invalidated by a memslot update or a relevant mmu_notifier fired.
  */
 static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
-				struct kvm_page_fault *fault, int mmu_seq)
+				struct kvm_page_fault *fault)
 {
 	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
 
@@ -4210,14 +4218,12 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 		return true;
 
 	return fault->slot &&
-	       mmu_invalidate_retry_hva(vcpu->kvm, mmu_seq, fault->hva);
+	       mmu_invalidate_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva);
 }
 
 static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
-
-	unsigned long mmu_seq;
 	int r;
 
 	fault->gfn = fault->addr >> PAGE_SHIFT;
@@ -4234,9 +4240,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		return r;
 
-	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
-	smp_rmb();
-
 	r = kvm_faultin_pfn(vcpu, fault);
 	if (r != RET_PF_CONTINUE)
 		return r;
@@ -4252,7 +4255,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	else
 		write_lock(&vcpu->kvm->mmu_lock);
 
-	if (is_page_fault_stale(vcpu, fault, mmu_seq))
+	if (is_page_fault_stale(vcpu, fault))
 		goto out_unlock;
 
 	r = make_mmu_pages_available(vcpu);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 582def531d4d..1c0a1e7c796d 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -221,6 +221,7 @@ struct kvm_page_fault {
 	struct kvm_memory_slot *slot;
 
 	/* Outputs of kvm_faultin_pfn.  */
+	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
 	hva_t hva;
 	bool map_writable;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 39e0205e7300..98f4abce4eaf 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -791,7 +791,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 {
 	struct guest_walker walker;
 	int r;
-	unsigned long mmu_seq;
 	bool is_self_change_mapping;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, fault->addr, fault->error_code);
@@ -838,9 +837,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	else
 		fault->max_level = walker.level;
 
-	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
-	smp_rmb();
-
 	r = kvm_faultin_pfn(vcpu, fault);
 	if (r != RET_PF_CONTINUE)
 		return r;
@@ -871,7 +867,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
 
-	if (is_page_fault_stale(vcpu, fault, mmu_seq))
+	if (is_page_fault_stale(vcpu, fault))
 		goto out_unlock;
 
 	r = make_mmu_pages_available(vcpu);
-- 
2.37.3.998.g577e59143f-goog


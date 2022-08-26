Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D717F5A3265
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 01:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344648AbiHZXMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 19:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345227AbiHZXMj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 19:12:39 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCCBD87F2
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:37 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-337ed9110c2so47550897b3.15
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=/h7NR+5YLyhr7liO75I183qpM/K3LGiktPqMTh28caI=;
        b=cTqFFfUv3s+E5rT2vmVjFjL0iW8RaTYjR7jvOHGOlbuuTcMS2mXO1qDK034sO4mS46
         f49VsEstZ47cDB1zy8uafdkL/vBccLB7/ENO19TIbzjHQZO4RyxxEXm4mHq9smvtWxkN
         C9ca8IeaEfvbfPCSXBEwkDkenZDFow0OAamSopW6md7rXI1x01LFFv76XfpCSdoUaEER
         baBi5Yish8+iH9CP1H5swqrIBvoph7/w21L86hC3KJAPvYz3mO3andEDceFy2pIyJ+5o
         F4b3inIQV4vxKNcHEx3g+YbGkIfgeeJ7Nz2nsdqV/N9+Ath7DcVk+oDEnSxkjWCe4fT9
         d/kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=/h7NR+5YLyhr7liO75I183qpM/K3LGiktPqMTh28caI=;
        b=1Q2CLNuRhPrULnKFQw6kMLutnva49d/brtPTsgkOE3rdqgDy4O+Ds/EnLgCz1KEgqh
         rUJTkZXx9xhtKCt8p3WQCCLPUGKRRwBmKcQKKQRXd2a5dPBxZ+8vrRhP5Q+klUVk9vot
         oKxRya6UBwhSqy9iM4MMOVBa/iEdQRcVF8dQNv0tOfrNggu5sPON3LtMnry1E6KqE5xa
         E7jC/LEdM6qtTGYJQhW0lzHqLEvqt7jMdatT/XmdptwFsg40URtFbhyU2+wxjJ05GuJG
         tOu/rJKyycxE4nCSoJE9vjUOomaMUt054ZdSIRkTIJER4GFIh/1VYOfmAdlxf23UuCJ4
         uRYQ==
X-Gm-Message-State: ACgBeo3PFGGCmpAH5SzGQrpNp2U2PbFcY1imJ5cop7Gu9dRmNtBjWZjk
        79aRwKpoVKuJqKC5yT7ugjh1rFCK3vklCg==
X-Google-Smtp-Source: AA6agR755Iw6DLHa8JCqMzw05jZNiAzNiLEAtht3shAKopXpRaSQpvQ7ZmrOKzEc0X2VfEeqy2tFzK7Ed3aoXg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:df0a:0:b0:33d:ab83:e816 with SMTP id
 i10-20020a0ddf0a000000b0033dab83e816mr1986660ywe.187.1661555557229; Fri, 26
 Aug 2022 16:12:37 -0700 (PDT)
Date:   Fri, 26 Aug 2022 16:12:20 -0700
In-Reply-To: <20220826231227.4096391-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220826231227.4096391-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826231227.4096391-4-dmatlack@google.com>
Subject: [PATCH v2 03/10] KVM: x86/mmu: Grab mmu_invalidate_seq in kvm_faultin_pfn()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, Peter Xu <peterx@redhat.com>
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
index ff428152abce..49dbe274c709 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4132,7 +4132,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
 }
 
-static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
@@ -4188,12 +4188,20 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
 
@@ -4213,14 +4221,12 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
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
@@ -4237,9 +4243,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		return r;
 
-	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
-	smp_rmb();
-
 	r = kvm_faultin_pfn(vcpu, fault);
 	if (r != RET_PF_CONTINUE)
 		return r;
@@ -4255,7 +4258,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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
2.37.2.672.g94769d06f0-goog


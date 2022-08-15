Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F654594EC2
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 04:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiHPCjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 22:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiHPCir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 22:38:47 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2831F83069
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:25 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33352499223so9113117b3.8
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=AEO9GH/YZ9oUnLZkd+DVKYY1R95ljJTtzDWVCxIGzlc=;
        b=q2DmOmfI/yKmjX6XHCy+FxeRXO62oLQbt/9lsXPZmf0VwtdGNmTq20/vcIKEJyeiWv
         Ji+SVOyNZbz8UsWlVMARp6at8PrDJ/hQQs7QcLPqu6QqucLySGOukHqwg4EZCRYqwyCt
         PrmH+RQL1ds/gkmAvC3CdJyZ3LGK3FJh26J6NMCtQJka3WeoAeLbaCPXp3lAF4Gtptjq
         1HfwdOfkjjJYwMJn0gwk8lWiU6b1pigQrjRIr3WSAn3gOSWyHX3wDyL0XvPMJdeLT0xl
         Q01kAAB94vVU2YizEgO9d9maLt7uEQOoChUoEhipY1e2YUfNL3ygMOgQC1ULQnTMR1CE
         ZKWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=AEO9GH/YZ9oUnLZkd+DVKYY1R95ljJTtzDWVCxIGzlc=;
        b=3uvx3hICIaFOm9ifqqperrpDLp7Atbr7e0+rUkTis4AmFaddDbgdnyvk+aV5vRsPxF
         2or5p22DYJc2JIdHA8P1vbd70NlL2VtRP2Ng2Jb+e1sX4alXYPUGZK2Kc88tjoJ+taGP
         10bUfqAXzdf8XS/YZb1+LCOUxQabgMyVKFyBL9XrbgYOsO0HnVk3YUAuyh0b8+IRRgFT
         kROTHI6HHAau0tboFQFb66RalZXMo9w95Qcz4CY9nbLKz/KqXP5TDpk+RW1v1eF9spsd
         maZNO6nbgvNfsXdYeC8PPJy5wMqAU1/fILHLim4RFeFBegSCTSFB3BXKRTmbU8U/MChp
         wOHw==
X-Gm-Message-State: ACgBeo3NfTPpC02yfh++yKTzH4bEFMW7c2Hga2ikK2+GH3ulUSA4jVsi
        m+bLX+kgjX3ZgDCFjFgoKmrGdxxa8tJQqg==
X-Google-Smtp-Source: AA6agR7EVG32s0u8XvvKYGGRUdS5BS37LnpdVWVNHgXmNPbn5mwp5jjMva+zKd/V7GnLOmVZk3GNlZ+4/p8chA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:e401:0:b0:66e:280a:98cd with SMTP id
 b1-20020a25e401000000b0066e280a98cdmr12850357ybh.540.1660604484454; Mon, 15
 Aug 2022 16:01:24 -0700 (PDT)
Date:   Mon, 15 Aug 2022 16:01:06 -0700
In-Reply-To: <20220815230110.2266741-1-dmatlack@google.com>
Message-Id: <20220815230110.2266741-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20220815230110.2266741-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 5/9] KVM: x86/mmu: Separate TDP and non-paging fault handling
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
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

Separate the page fault handling for TDP faults and non-paging faults.
This creates some duplicate code in the short term, but makes each
routine simpler to read by eliminating branches and enables future
cleanups by allowing the two paths to diverge.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 77 +++++++++++++++++++++++++++---------------
 1 file changed, 50 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3e03407f1321..182f9f417e4e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4209,11 +4209,15 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 	       mmu_notifier_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva);
 }
 
-static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int nonpaging_page_fault(struct kvm_vcpu *vcpu,
+				struct kvm_page_fault *fault)
 {
-	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
 	int r;
 
+	pgprintk("%s: gva %lx error %x\n", __func__, fault->addr, fault->error_code);
+
+	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
+	fault->max_level = PG_LEVEL_2M;
 	fault->gfn = fault->addr >> PAGE_SHIFT;
 	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
 
@@ -4237,11 +4241,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return r;
 
 	r = RET_PF_RETRY;
-
-	if (is_tdp_mmu_fault)
-		read_lock(&vcpu->kvm->mmu_lock);
-	else
-		write_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 
 	if (is_page_fault_stale(vcpu, fault))
 		goto out_unlock;
@@ -4250,30 +4250,14 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		goto out_unlock;
 
-	if (is_tdp_mmu_fault)
-		r = kvm_tdp_mmu_map(vcpu, fault);
-	else
-		r = nonpaging_map(vcpu, fault);
+	r = nonpaging_map(vcpu, fault);
 
 out_unlock:
-	if (is_tdp_mmu_fault)
-		read_unlock(&vcpu->kvm->mmu_lock);
-	else
-		write_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
 
-static int nonpaging_page_fault(struct kvm_vcpu *vcpu,
-				struct kvm_page_fault *fault)
-{
-	pgprintk("%s: gva %lx error %x\n", __func__, fault->addr, fault->error_code);
-
-	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
-	fault->max_level = PG_LEVEL_2M;
-	return direct_page_fault(vcpu, fault);
-}
-
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len)
 {
@@ -4309,6 +4293,11 @@ EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
+	int r;
+
+	fault->gfn = fault->addr >> PAGE_SHIFT;
+	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
+
 	/*
 	 * If the guest's MTRRs may be used to compute the "real" memtype,
 	 * restrict the mapping level to ensure KVM uses a consistent memtype
@@ -4324,14 +4313,48 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (shadow_memtype_mask && kvm_arch_has_noncoherent_dma(vcpu->kvm)) {
 		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
 			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
-			gfn_t base = (fault->addr >> PAGE_SHIFT) & ~(page_num - 1);
+			gfn_t base = fault->gfn & ~(page_num - 1);
 
 			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
 				break;
 		}
 	}
 
-	return direct_page_fault(vcpu, fault);
+	if (page_fault_handle_page_track(vcpu, fault))
+		return RET_PF_EMULATE;
+
+	r = fast_page_fault(vcpu, fault);
+	if (r != RET_PF_INVALID)
+		return r;
+
+	r = mmu_topup_memory_caches(vcpu, false);
+	if (r)
+		return r;
+
+	r = kvm_faultin_pfn(vcpu, fault);
+	if (r != RET_PF_CONTINUE)
+		return r;
+
+	r = handle_abnormal_pfn(vcpu, fault, ACC_ALL);
+	if (r != RET_PF_CONTINUE)
+		return r;
+
+	r = RET_PF_RETRY;
+	read_lock(&vcpu->kvm->mmu_lock);
+
+	if (is_page_fault_stale(vcpu, fault))
+		goto out_unlock;
+
+	r = make_mmu_pages_available(vcpu);
+	if (r)
+		goto out_unlock;
+
+	r = kvm_tdp_mmu_map(vcpu, fault);
+
+out_unlock:
+	read_unlock(&vcpu->kvm->mmu_lock);
+	kvm_release_pfn_clean(fault->pfn);
+	return r;
 }
 
 static void nonpaging_init_context(struct kvm_mmu *context)
-- 
2.37.1.595.g718a3a8f04-goog


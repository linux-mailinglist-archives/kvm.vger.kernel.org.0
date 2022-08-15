Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B94E594EC4
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 04:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbiHPCjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 22:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbiHPCis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 22:38:48 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C715D122
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:20 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-324989683fdso79495647b3.12
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=312y1r9DCcSJg69qR46Ujpn+LlXoc7aI9JqL7JICd70=;
        b=mpSeVasYOQbfUNwE6J9yQ20WftzXqvE8cZzjRHK4RQGz7RavF1k6Bbk7iDFM7LEJqA
         W7/OCCTc54GpB+WxUj25VPx3PmL8DBx85TE2WZKMebRWT6pnxRqKBQg5rQqxXTooUMiA
         eqv2XUNnIeLqvejKGe+UYEUANQdez1ymh2fKXIgmhmkuDeEGROe/6DXWdcuyplfSnYYC
         cNg3DUsD1QydsFRMws3MFS6MJawMzW0Lxzyg3RDK1qv2kO6rWy6wCPYnG0qkZ6LjODL6
         5guQXo8A97dijr55Ja+2zXAVF6EPL8XpgvZMzfYH/2a2tieJ/d/ATxhiUwlv1ViHTwBv
         24xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=312y1r9DCcSJg69qR46Ujpn+LlXoc7aI9JqL7JICd70=;
        b=TclzsvA6I28j6+3sbNIPY0UEa9FiXLFCrUeldg6GyJ0aFvnSLmE9cIXEgdqwavN1KR
         28JdMp6cnR7Bcw6Q1QKnKA1v/LR9b71wqKQq6dLs/n0Uyk1vRxLsQksq2CecPrNqKs/4
         n8hbiXs1LjxCoWA/v7UvIdrNcwMiYG5/lkrloZwOWYpGZZvucLYLZDr6cTSz0v/8LJ4j
         turfN80ZUJ3oXMlQlZnaQzwl0OWeRjgp7HnrBqlYVJfwjCIPCeQv2T27xAzN58ydqhv7
         mGVsFzRk9uUXB27H8NfD0NW6QO19e/kIUV7m72omQ75V4kSSxC+VO1Oatq8wP0IbprMW
         QiMQ==
X-Gm-Message-State: ACgBeo2RWrB+Oqd7r57FEJd1/kkEnMs4xWU++25lxyOFMMEOg5S5IVJ7
        /DooKD95o3jk5YjWnMvUJxb8bAsR2miUNQ==
X-Google-Smtp-Source: AA6agR4/090qsVeE3DKFoiC5NO46mHWopxigcGkI/MIMAGp0lnHoX4ypkTjt8irb3Mz1nmn8qlCzC0/tuqET3Q==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:8145:0:b0:323:26f5:2c8a with SMTP id
 r66-20020a818145000000b0032326f52c8amr14288041ywf.261.1660604480062; Mon, 15
 Aug 2022 16:01:20 -0700 (PDT)
Date:   Mon, 15 Aug 2022 16:01:04 -0700
In-Reply-To: <20220815230110.2266741-1-dmatlack@google.com>
Message-Id: <20220815230110.2266741-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20220815230110.2266741-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 3/9] KVM: x86/mmu: Consolidate mmu_seq calculations in kvm_faultin_pfn()
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

Calculate mmu_seq during kvm_faultin_pfn() and stash it in struct
kvm_page_fault. The eliminates duplicate code and reduces the amount of
parameters needed for is_page_fault_stale().

Note, the smp_rmb() needs a comment but that is out of scope for this
commit which is pure code motion.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 14 ++++++--------
 arch/x86/kvm/mmu/mmu_internal.h |  1 +
 arch/x86/kvm/mmu/paging_tmpl.h  |  6 +-----
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8c293a88d923..af1b7e7fb4fb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4127,6 +4127,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
 
+	fault->mmu_seq = vcpu->kvm->mmu_notifier_seq;
+	smp_rmb();
+
 	/*
 	 * Retry the page fault if the gfn hit a memslot that is being deleted
 	 * or moved.  This ensures any existing SPTEs for the old memslot will
@@ -4183,7 +4186,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
  * root was invalidated by a memslot update or a relevant mmu_notifier fired.
  */
 static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
-				struct kvm_page_fault *fault, int mmu_seq)
+				struct kvm_page_fault *fault)
 {
 	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
 
@@ -4203,14 +4206,12 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 		return true;
 
 	return fault->slot &&
-	       mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva);
+	       mmu_notifier_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva);
 }
 
 static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
-
-	unsigned long mmu_seq;
 	int r;
 
 	fault->gfn = fault->addr >> PAGE_SHIFT;
@@ -4227,9 +4228,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		return r;
 
-	mmu_seq = vcpu->kvm->mmu_notifier_seq;
-	smp_rmb();
-
 	r = kvm_faultin_pfn(vcpu, fault);
 	if (r != RET_PF_CONTINUE)
 		return r;
@@ -4245,7 +4243,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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
index f5958071220c..a199db4acecc 100644
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
 
-	mmu_seq = vcpu->kvm->mmu_notifier_seq;
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
2.37.1.595.g718a3a8f04-goog


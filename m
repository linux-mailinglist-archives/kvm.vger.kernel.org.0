Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE79C75D7B7
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 01:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbjGUXAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 19:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjGUXAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 19:00:14 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83323A8C
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:00:12 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d052f58b7deso858394276.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689980412; x=1690585212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zPxDuw7GeJQotzB/CPJITWYq84dGkPo6Sdy7hiPXZfA=;
        b=hx05lOSKevEnFTjhQmIFaPmCZWGUtEHn8FPIM5Bki+UcSqPi4IntQeAWTUj+y16Q3C
         VsMT2vKpEPje3bE2F0xUf0GMW5chsQEeSL/rUzNBHYE0ccg3hQtfK6AT50tUNffQ+8JG
         2lay9BL2a9yTqI12d+ssVhmL3OUE4QhP5T2TLWlFFWWHXSAqQObIEcB/e+q7NdsNjEj4
         UCEjIIafqyus+s+Yz/Sjnh+LhYRgVyo596begODfAr9zRbpusbnFttvuh4cZFl+MJM9s
         LeXrJ1BKKbDZ6/OgzBfbvkzPH93TO2gneJJqKXJtvdEHeUxwyOVwVtabahG+/177jK4Z
         NLSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689980412; x=1690585212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zPxDuw7GeJQotzB/CPJITWYq84dGkPo6Sdy7hiPXZfA=;
        b=gpYO02Cwj/2sKWyAUL94tAt70KTR9MbxepTZv0OJ8+dDryCLcrW+NoIjhAaTTGdRGb
         tNZP0bC2v2z1pqkemDiNI1nJn50oZRJnisHc7ccwilyfFRqvXTk+q782CxcIoqUzJgxe
         iRCshaftI/TS5o5wCAH1TQRmvnLARkRDAIfUxzcZHJ0O9vmzHyD5Bnq9W6ie5pyK4ok8
         9qgnAgvV/8wJZ8K0WwTrgJFqSIYEsnmB3U6K8wOOoHmua7/kLErunmjpkK+0DFsHjcNY
         B3O0av4U0c/vZ5FnmQslugSMexQ1c+jyQ1e58hrzxj0gy9oKTwhfRIptk+8I1DRMn769
         1wvg==
X-Gm-Message-State: ABy/qLb1cnYLmHuUNxiA6Ps3VhVRJc3FU9LxMxxUdQjajOGNItdrnUup
        TIzCbRpdlHQBSJLSB1VbU67VuWvQvzA=
X-Google-Smtp-Source: APBJJlFJ/eOkeJGXEeW0uRAXDqLwIw2mNwIfFaPZWB6Xz5oFPGi7eUqiR679QoROZxoeZJEJY3G6J0NMJ0g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1388:b0:d05:38ba:b616 with SMTP id
 x8-20020a056902138800b00d0538bab616mr12927ybu.6.1689980411985; Fri, 21 Jul
 2023 16:00:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 15:59:58 -0700
In-Reply-To: <20230721230006.2337941-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721230006.2337941-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721230006.2337941-2-seanjc@google.com>
Subject: [PATCH v2 1/9] KVM: x86/mmu: Delete rmap_printk() and all its usage
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Delete rmap_printk() so that MMU_WARN_ON() and MMU_DEBUG can be morphed
into something that can be regularly enabled for debug kernels.  The
information provided by rmap_printk() isn't all that useful now that the
rmap and unsync code is mature, as the prints are simultaneously too
verbose (_lots_ of message) and yet not verbose enough to be helpful for
debug (most instances print just the SPTE pointer/value, which is rarely
sufficient to root cause anything but trivial bugs).

Alternatively, rmap_printk() could be reworked to into tracepoints, but
it's not clear there is a real need as rmap bugs rarely escape initial
development, and when bugs do escape to production, they are often edge
cases and/or reside in code that isn't directly related to the rmaps.
In other words, the problems with rmap_printk() being unhelpful also apply
to tracepoints.  And deleting rmap_printk() doesn't preclude adding
tracepoints in the future.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 12 ------------
 arch/x86/kvm/mmu/mmu_internal.h |  2 --
 2 files changed, 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bc24d430db6e..8e36e07719bf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -941,10 +941,8 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 	int count = 0;
 
 	if (!rmap_head->val) {
-		rmap_printk("%p %llx 0->1\n", spte, *spte);
 		rmap_head->val = (unsigned long)spte;
 	} else if (!(rmap_head->val & 1)) {
-		rmap_printk("%p %llx 1->many\n", spte, *spte);
 		desc = kvm_mmu_memory_cache_alloc(cache);
 		desc->sptes[0] = (u64 *)rmap_head->val;
 		desc->sptes[1] = spte;
@@ -953,7 +951,6 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 		rmap_head->val = (unsigned long)desc | 1;
 		++count;
 	} else {
-		rmap_printk("%p %llx many->many\n", spte, *spte);
 		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
 		count = desc->tail_count + desc->spte_count;
 
@@ -1018,14 +1015,12 @@ static void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 		pr_err("%s: %p 0->BUG\n", __func__, spte);
 		BUG();
 	} else if (!(rmap_head->val & 1)) {
-		rmap_printk("%p 1->0\n", spte);
 		if ((u64 *)rmap_head->val != spte) {
 			pr_err("%s:  %p 1->BUG\n", __func__, spte);
 			BUG();
 		}
 		rmap_head->val = 0;
 	} else {
-		rmap_printk("%p many->many\n", spte);
 		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
 		while (desc) {
 			for (i = 0; i < desc->spte_count; ++i) {
@@ -1241,8 +1236,6 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 	    !(pt_protect && is_mmu_writable_spte(spte)))
 		return false;
 
-	rmap_printk("spte %p %llx\n", sptep, *sptep);
-
 	if (pt_protect)
 		spte &= ~shadow_mmu_writable_mask;
 	spte = spte & ~PT_WRITABLE_MASK;
@@ -1267,8 +1260,6 @@ static bool spte_clear_dirty(u64 *sptep)
 {
 	u64 spte = *sptep;
 
-	rmap_printk("spte %p %llx\n", sptep, *sptep);
-
 	MMU_WARN_ON(!spte_ad_enabled(spte));
 	spte &= ~shadow_dirty_mask;
 	return mmu_spte_update(sptep, spte);
@@ -1480,9 +1471,6 @@ static bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 restart:
 	for_each_rmap_spte(rmap_head, &iter, sptep) {
-		rmap_printk("spte %p %llx gfn %llx (%d)\n",
-			    sptep, *sptep, gfn, level);
-
 		need_flush = true;
 
 		if (pte_write(pte)) {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 4f1e4b327f40..9c9dd9340c63 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -11,10 +11,8 @@
 #ifdef MMU_DEBUG
 extern bool dbg;
 
-#define rmap_printk(fmt, args...) do { if (dbg) printk("%s: " fmt, __func__, ## args); } while (0)
 #define MMU_WARN_ON(x) WARN_ON(x)
 #else
-#define rmap_printk(x...) do { } while (0)
 #define MMU_WARN_ON(x) do { } while (0)
 #endif
 
-- 
2.41.0.487.g6d72f3e995-goog


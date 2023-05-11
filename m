Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1946FFD8C
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 01:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239619AbjEKX71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 19:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239118AbjEKX7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 19:59:24 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40BA49F9
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:59:22 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-24e16918391so5078510a91.3
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683849562; x=1686441562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VIjrZedVYHUazO+QEAuS++mQjGlxrOf/5Ry3YdZ2+oU=;
        b=o016p9C1l7Bf40QWW5hZhlJ6UNhvoepg3EV6HlxcEYKweG3hyj3sX9GCUcRyUaOCgw
         1EsWeEZWAF5yt9PC1IvGCqyts1dY1FMyo9VyyOnzVniVn1OOjUz/rJcvRoKtyYpf9oYW
         xjmQozf8TMPhASSJoL9Qgtz7Jnj1N6K3BmfgneVnlwAuEKLZ5/r47TvU4fS4y6XX6aJV
         eKnjIqfLnrUfCd+h9dNaC9E78ttRH6SvCz+F63h2Op6/U3ZNBVEJJmavoSBz2hwqF+Gr
         6k8Fp7hpwoCAq/i3vHBs0AguuohmxIjuP9c2uDco58HxBUqso8q2sogF9Szz/CBXk6qn
         MrEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683849562; x=1686441562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VIjrZedVYHUazO+QEAuS++mQjGlxrOf/5Ry3YdZ2+oU=;
        b=NT7YOP+m0jcIzgZa6I/mFDGMkryb3OEV57xxjOEQGNdPutbCZq46VjZrFFQA2FAV4y
         Vj60lELAAt953rScxqbCDj3y4Qhvkz9Rjy5Ev1/7Ny47ufxbPnrVZzduil8yr3smKulH
         oMgpF/4Yb0/Ig5YupdFZ5bwnPGF6J1CFaFZFMjEFVP3yW2VhQH0Gjvw0DDmfEzTI2nSN
         Z0+FLj3mbx/3SbH2+H8lLG22dUM6YPb3Y1pag4+JjET9yqwmGcXZdnNQAYlZo8v5V/lo
         ud+wPaeITSxmtiWPvf/KX1oeSkELQdLxK2wjLFjQln2lhZ0UoBYUmW6/DstU9x4TtKEN
         QZig==
X-Gm-Message-State: AC+VfDzQ7Ktnoo8H7GIZIzVLm/vhaB41iROfPa0LHdFlERQBJ57d/h52
        BoEcXVKp+AGKa/iQnJlZP2P5gUZttmE=
X-Google-Smtp-Source: ACHHUZ5ncEZoSbrKYktLcseA8fx7EMsUd80/dPDRz+xO8GX7szwGTZ2sEmLLJw4b5O1/sROyqSHmg/wxPCI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d80d:b0:252:8154:790c with SMTP id
 a13-20020a17090ad80d00b002528154790cmr1368698pjv.9.1683849562448; Thu, 11 May
 2023 16:59:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 May 2023 16:59:10 -0700
In-Reply-To: <20230511235917.639770-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230511235917.639770-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230511235917.639770-3-seanjc@google.com>
Subject: [PATCH 2/9] KVM: x86/mmu: Delete rmap_printk() and all its usage
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
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
index cb70958eeaf9..f6918c0bb82d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -938,10 +938,8 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 	int count = 0;
 
 	if (!rmap_head->val) {
-		rmap_printk("%p %llx 0->1\n", spte, *spte);
 		rmap_head->val = (unsigned long)spte;
 	} else if (!(rmap_head->val & 1)) {
-		rmap_printk("%p %llx 1->many\n", spte, *spte);
 		desc = kvm_mmu_memory_cache_alloc(cache);
 		desc->sptes[0] = (u64 *)rmap_head->val;
 		desc->sptes[1] = spte;
@@ -950,7 +948,6 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 		rmap_head->val = (unsigned long)desc | 1;
 		++count;
 	} else {
-		rmap_printk("%p %llx many->many\n", spte, *spte);
 		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
 		count = desc->tail_count + desc->spte_count;
 
@@ -1015,14 +1012,12 @@ static void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
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
@@ -1238,8 +1233,6 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 	    !(pt_protect && is_mmu_writable_spte(spte)))
 		return false;
 
-	rmap_printk("spte %p %llx\n", sptep, *sptep);
-
 	if (pt_protect)
 		spte &= ~shadow_mmu_writable_mask;
 	spte = spte & ~PT_WRITABLE_MASK;
@@ -1264,8 +1257,6 @@ static bool spte_clear_dirty(u64 *sptep)
 {
 	u64 spte = *sptep;
 
-	rmap_printk("spte %p %llx\n", sptep, *sptep);
-
 	MMU_WARN_ON(!spte_ad_enabled(spte));
 	spte &= ~shadow_dirty_mask;
 	return mmu_spte_update(sptep, spte);
@@ -1477,9 +1468,6 @@ static bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
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
2.40.1.606.ga4b1b128d6-goog


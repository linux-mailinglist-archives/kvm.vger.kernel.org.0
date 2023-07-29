Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F289E767A07
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbjG2AtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbjG2As4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:48:56 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6B749EC
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:22 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-585fb08172bso254597b3.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591648; x=1691196448;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zPxDuw7GeJQotzB/CPJITWYq84dGkPo6Sdy7hiPXZfA=;
        b=tfJreDiVdxqrWTn17eDz9CQ1prR4OaY8R72gsdHx5b0HfSm06muHlq6/VU8VmbJ/69
         QTkeIaV9d0VbA+DjT9ug4lgckuxEQEmnyA+gGWYj4GDEnhCs1swodjbX/M0Sd1+mLAGP
         GjD90stCM9Q8l2RXDOAZpahBB9xD2Os888pcdmciu7sBhKYpsuMILtmlSIRHv8S5ZG45
         umHo9TXIvRmOMlFEzXsGR045vYHfeinM2oRiITQfJst61DZLkVDEDnSYdeejwQmFgwcH
         IO9UnRimsDRL2mV/XKV1dI5RJZjxAvUXRoEO3btpR/9vV1d3JeH3R4Hlc5949Es//XYU
         pPJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591648; x=1691196448;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zPxDuw7GeJQotzB/CPJITWYq84dGkPo6Sdy7hiPXZfA=;
        b=Qm7nowP3/CD3P8iJVUGL9bMDJeXm3V1ydcU+Ga2SGcblI+0sZ3PrktFJDbteMrMlQk
         9bTf30J9tpSvh+5arrSSuvkxHO33OfczOrKT+HEVE3vAR7rTWcJm2ZDt5j44DFI0LMjS
         Ik3uO5grcFmjyslZ46T0jRdnRwPCHG5IYipttJnl2MPNzyqzIjinRIJxv4rkQPkMYiXq
         Ad9aEUmhQ+E9DRaPI7xls3hgUyqSDYTyq04q7EuXRQz0UfNELfoOvewtAwPOU39nRLLO
         8SaI52OsnUzZeDZOq0BAcKprlndPqEXH58ujuYNYalXCTsWSBoedcjhH5pEARU1TMaeB
         iEFg==
X-Gm-Message-State: ABy/qLZ7c8M8DRuCw2HYssu84qfC3V00Q0NJHOXjEKWbKIS8lEAuUevN
        tDkFbEZjXrBCvMKjaZlr3D1g3VhPUsg=
X-Google-Smtp-Source: APBJJlH5CMrCcIbJEX3F3Vv06Tdao406OfSUM981PUaHzDHpUx0xmQUNwcMXKWHraA+hv5ypdYYbC4WaYcI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4304:0:b0:565:a42c:79fe with SMTP id
 q4-20020a814304000000b00565a42c79femr24190ywa.1.1690591648271; Fri, 28 Jul
 2023 17:47:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:47:12 -0700
In-Reply-To: <20230729004722.1056172-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729004722.1056172-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729004722.1056172-3-seanjc@google.com>
Subject: [PATCH v3 02/12] KVM: x86/mmu: Delete rmap_printk() and all its usage
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


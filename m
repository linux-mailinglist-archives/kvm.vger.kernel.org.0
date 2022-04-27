Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA274510E28
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 03:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356919AbiD0Bnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 21:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356892AbiD0Bnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 21:43:33 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2980186D1
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:40:22 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id d127-20020a633685000000b003ab20e589a8so167948pga.22
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8PeOWxVB/PV7PL/FCA2ORAOWJEpKNecTkJJHdcIaayE=;
        b=RrD+i50ol54Uu6raUIuaeZDx2/6IdM834axlPG+4v5t83Bf9s8q3RaAPFfrz1UDbux
         f/PCyC6/ueKE9KKAUHYT+3LIrReYWTVceR/SULzRLFt4My46cLHXHeJZeR5XF5GYJ1cH
         f9oq80168EdgIAO6wyQ9mkgLs656o3yPhX8AkI8exP2MCNUFPICdISLS99kzW+5x1Jfu
         4HHLekp8Enb15xRwxsc0I875BdqXGInclxYZBRyLIfmlKh6w3kosxb5ByXEWTGz9vnju
         zohLS8zFYF8QVQOd6o/XgkptJgI6RDkugHI5+57hIj3NIQFz9JXt5HVcb2kYEYrD50J/
         SaMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8PeOWxVB/PV7PL/FCA2ORAOWJEpKNecTkJJHdcIaayE=;
        b=5q4OtKAQxJATLH3ItHwtHr7blJ/Mr31v9oHG5RHKr6R4+hcwR0yjiRj6PiCaSj/bvV
         iK7jEtO2viux7AnN2Umso/rOZ6Wc2oiStm3UrGzRzWJJNmvs6avPtFhDRk4wFtXikHDy
         QYhD1ockX8wC9DeNvV+Y5F2B4Txynv25tTl5o9gjh+sP/mefX9c6X3oCCFlcV0DpoWZi
         gjxRVnqHAkPOP6cdD4wINJaWSG/33Dws7Gfmd6gjdl8aKQnSNrDR2Y+zXaPi+Pw6iclp
         GEpneXwDev0dzIKR6grts71IHpEsr/3WmtngtM8oCzyExkxX2QD3vIrND3ueyKiJiN6i
         ZYXw==
X-Gm-Message-State: AOAM5323NL+69eBpIlYHtCqgDVia47mJjmJ+I75VzzSZdeevulJvqMcf
        3c/JCvVQ3c4UnTwYce/YNRrVnlXt+L0=
X-Google-Smtp-Source: ABdhPJzwMIlXwOTbAjJI80e2LYtYIqs3I3Oa8m6URYknPp/DdPTBkA86ZY2PcpnMUvkflq+1sIRo5oMw3vs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:11c7:b0:151:7290:ccc with SMTP id
 q7-20020a17090311c700b0015172900cccmr26601873plh.95.1651023620966; Tue, 26
 Apr 2022 18:40:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 27 Apr 2022 01:40:03 +0000
In-Reply-To: <20220427014004.1992589-1-seanjc@google.com>
Message-Id: <20220427014004.1992589-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220427014004.1992589-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 7/8] KVM: Do not pin pages tracked by gfn=>pfn caches
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
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

Put the reference to any struct page mapped/tracked by a gfn=>pfn cache
upon inserting the pfn into its associated cache, as opposed to putting
the reference only when the cache is done using the pfn.  In other words,
don't pin pages while they're in the cache.  One of the major roles of
the gfn=>pfn cache is to play nicely with invalidation events, i.e. it
exists in large part so that KVM doesn't rely on pinning pages.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index b1665d0e6c32..3cb439b505b4 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -95,20 +95,16 @@ bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_check);
 
-static void gpc_release_pfn_and_khva(struct kvm *kvm, kvm_pfn_t pfn, void *khva)
+static void gpc_unmap_khva(struct kvm *kvm, kvm_pfn_t pfn, void *khva)
 {
-	/* Unmap the old page if it was mapped before, and release it */
-	if (!is_error_noslot_pfn(pfn)) {
-		if (khva) {
-			if (pfn_valid(pfn))
-				kunmap(pfn_to_page(pfn));
+	/* Unmap the old pfn/page if it was mapped before. */
+	if (!is_error_noslot_pfn(pfn) && khva) {
+		if (pfn_valid(pfn))
+			kunmap(pfn_to_page(pfn));
 #ifdef CONFIG_HAS_IOMEM
-			else
-				memunmap(khva);
+		else
+			memunmap(khva);
 #endif
-		}
-
-		kvm_release_pfn(pfn, false);
 	}
 }
 
@@ -147,10 +143,10 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 			 * Keep the mapping if the previous iteration reused
 			 * the existing mapping and didn't create a new one.
 			 */
-			if (new_khva == old_khva)
-				new_khva = NULL;
+			if (new_khva != old_khva)
+				gpc_unmap_khva(kvm, new_pfn, new_khva);
 
-			gpc_release_pfn_and_khva(kvm, new_pfn, new_khva);
+			kvm_release_pfn_clean(new_pfn);
 
 			cond_resched();
 		}
@@ -222,6 +218,14 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 	gpc->valid = true;
 	gpc->pfn = new_pfn;
 	gpc->khva = new_khva + (gpc->gpa & ~PAGE_MASK);
+
+	/*
+	 * Put the reference to the _new_ pfn.  The pfn is now tracked by the
+	 * cache and can be safely migrated, swapped, etc... as the cache will
+	 * invalidate any mappings in response to relevant mmu_notifier events.
+	 */
+	kvm_release_pfn_clean(new_pfn);
+
 	return 0;
 
 out_error:
@@ -315,7 +319,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 	write_unlock_irq(&gpc->lock);
 
 	if (old_pfn != new_pfn)
-		gpc_release_pfn_and_khva(kvm, old_pfn, old_khva);
+		gpc_unmap_khva(kvm, old_pfn, old_khva);
 
 	return ret;
 }
@@ -342,7 +346,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 
 	write_unlock_irq(&gpc->lock);
 
-	gpc_release_pfn_and_khva(kvm, old_pfn, old_khva);
+	gpc_unmap_khva(kvm, old_pfn, old_khva);
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_unmap);
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog


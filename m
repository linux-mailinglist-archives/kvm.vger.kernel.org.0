Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4321251564D
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 23:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381217AbiD2VEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 17:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381183AbiD2VEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 17:04:02 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E7AD3AD7
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 14:00:43 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id ij27-20020a170902ab5b00b0015d41282214so4711177plb.9
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 14:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=zP2FwEa8Nl8vyFhUbOzmbrhYzn9cxhFMqsrmIQIuWwA=;
        b=QK+xPeiwXa6e33Pjngc5P2E6KIFwQs9puOhH3flfkWXWJjvTKXQ4n91xk7xnBs0MNz
         CaTaxYpqw7PaqazqF3yUJGpzzeZ8ns3tbtrUYeByfLzUy3PLjdebI4YjLp7A2sYGkYzT
         EJp9fMGmqRLDPZUA4odmFAcwCLnNP35Um8+Ftl6Mr0VdEz0WeJ89UzdHtM8aL34pgIgy
         tO32M5MDejwBUSal0KDQviidOrx3DfvdQKvqZNAUCp0SKJi4yDWbB8NKxbUMzOvfSKvn
         J40p4UHDnCJHgrukR+KdzHhjTuPl+GWEBtkh6ZGhIpNnM/nV03UA8bWZWwuJuPOYiD5i
         CdtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=zP2FwEa8Nl8vyFhUbOzmbrhYzn9cxhFMqsrmIQIuWwA=;
        b=P4QG9CSFdEU0B7/pT3rDCg9BZ7lsa/56VgWBFVcyNnZTXCQzB/Czfi+odCw0byMdu/
         Q8pVA9gH2zrdl0RgG1Zb8GkAaUgOwN0E9u2uH7N9po8DdIWcB5AOd8dCl8WikFgQ91JT
         PL5foH46bmMenjwETZ9kaUySMdwpLOyEgju9TorVRPVd9KB2hTYdpenO8RviMSfYmWKB
         000x9Wx0z/yMFaRo36MY2EZQvrWvQ+ufSSMoHmlRyQPb1AS4eR0oLldX51k8N4xiHUfG
         vAokAB0c554JW4ImYBfedqys1TWoQyEyHvEr1sKax4mZ0/Y+j87qpYn4FtQ1fdV/DDnf
         6E7g==
X-Gm-Message-State: AOAM533h/iQhplgTQDY0eP2gpm2AUKdwzyvyNdnOR9fPeP0eCdTggxpn
        Zoj4s98sa0v1omYAZbgmpPAhbkU6SJA=
X-Google-Smtp-Source: ABdhPJz4W33FH39XL8rGj5+zrdiDe0gJH35R1ZBKg0xwvpX8Ebhc6cVEBCEMyApi7dDt9qXfs+Vz2pnMXrs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:851:b0:50d:62f6:5494 with SMTP id
 q17-20020a056a00085100b0050d62f65494mr799201pfk.75.1651266042949; Fri, 29 Apr
 2022 14:00:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 29 Apr 2022 21:00:25 +0000
In-Reply-To: <20220429210025.3293691-1-seanjc@google.com>
Message-Id: <20220429210025.3293691-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220429210025.3293691-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v3 8/8] KVM: Do not pin pages tracked by gfn=>pfn caches
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>
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
index 0535669ea2a1..c4fb81929663 100644
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
@@ -308,7 +312,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 	mutex_unlock(&gpc->refresh_lock);
 
 	if (old_pfn != new_pfn)
-		gpc_release_pfn_and_khva(kvm, old_pfn, old_khva);
+		gpc_unmap_khva(kvm, old_pfn, old_khva);
 
 	return ret;
 }
@@ -335,7 +339,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 
 	write_unlock_irq(&gpc->lock);
 
-	gpc_release_pfn_and_khva(kvm, old_pfn, old_khva);
+	gpc_unmap_khva(kvm, old_pfn, old_khva);
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_unmap);
 
-- 
2.36.0.464.gb9c8b46e94-goog


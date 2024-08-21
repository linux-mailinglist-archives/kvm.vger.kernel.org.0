Return-Path: <kvm+bounces-24795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92EDB95A5D7
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 22:28:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B448F1C22CC1
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 20:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63D9F1741C6;
	Wed, 21 Aug 2024 20:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eXX/uEbu"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE8F170A2C;
	Wed, 21 Aug 2024 20:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272107; cv=none; b=hh7PQzO6Ww/r8fnRPsERvwuHZMRD7e6GQztqVKuKbvsfe54Amak6eYdneAltdn7CmHuWsFP+Me4I5NZGmIWV3qi+VFFO7tYPV33Dh+vQSS9Tb8BiteGp/EYnCEEqmy5dqxZaHOr3qflEN4aPsSRscQX/8nvE7jrAHdm/w5dzKYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272107; c=relaxed/simple;
	bh=SXtWlXXJvfMzOc3hdKl16HGzmbsTfSjUfArfRvLm3Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pfoNtRy28v6eiVUxYn1b3XEiYYPYnKWkNn72KujNCzDKqa9CSNujXAinItcWWZXa0jbZ/yL9ak0zEJl81nN97MUXOHWTDsbox6Yz84WxV+TBVabqdwQyB7vCBqX4NhEyUTialyQ3wr/t/fW7wIGLl385iMAErczf5O+Ehqg/vkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eXX/uEbu; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=kj3JEAu7EiqwY4Qhm6ZqPD9191IkjGRIRHW3y1xsTyg=; b=eXX/uEbuUPtEKsR1cEsF4mJNW1
	UJEqGGmOQMAdHhp0sCbN5tT9iGGGO+YoKzGRg3EtBz3blON0n4yS+dtxRPqyKMcXpLxv4MaWWGG2M
	3Z+7C/2DXo+5qsvl7I7W7TxbdXUTHuZUX3pQl5CySYmR9AnHBVmeHM9A0y0Id7MtWjag4xTgeMe06
	SYGVK3+/eGHw22tNNRzo+JFXS+9q3EwN3sLeEhyN9VbJ7Xk30uFC3SyhZZqj+XY21NlMfa+qyerzG
	IdPd7mUqmXY2tjjclU4lsStH6xBjAFKuRV0TKmac0PgoeebGOKCL9bAS2Wnbv1lQBPUL1MtvW3i9Y
	01SSfeVw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgrwF-00000009fuS-0vJO;
	Wed, 21 Aug 2024 20:28:15 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgrwE-00000002z8p-0LiG;
	Wed, 21 Aug 2024 21:28:14 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Hussain, Mushahid" <hmushi@amazon.co.uk>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Jim Mattson <jmattson@google.com>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mingwei Zhang <mizhang@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 1/5] KVM: pfncache: Add needs_invalidation flag to gfn_to_pfn_cache
Date: Wed, 21 Aug 2024 21:28:09 +0100
Message-ID: <20240821202814.711673-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

This will be used to allow hva_to_pfn_retry() to be more selective about
its retry loop, which is currently extremely pessimistic.

It allows for invalidations to occur even while the PFN is being mapped
(which happens with the lock dropped), before the GPC is fully valid.

No functional change yet, as the existing mmu_notifier_retry_cache()
function will still return true in all cases where the invalidation
may have triggered.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/linux/kvm_types.h |  1 +
 virt/kvm/pfncache.c       | 29 ++++++++++++++++++++++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 827ecc0b7e10..4d8fbd87c320 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -69,6 +69,7 @@ struct gfn_to_pfn_cache {
 	void *khva;
 	kvm_pfn_t pfn;
 	bool active;
+	bool needs_invalidation;
 	bool valid;
 };
 
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index f0039efb9e1e..7007d32d197a 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -32,7 +32,7 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 		read_lock_irq(&gpc->lock);
 
 		/* Only a single page so no need to care about length */
-		if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
+		if (gpc->needs_invalidation && !is_error_noslot_pfn(gpc->pfn) &&
 		    gpc->uhva >= start && gpc->uhva < end) {
 			read_unlock_irq(&gpc->lock);
 
@@ -45,9 +45,11 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 			 */
 
 			write_lock_irq(&gpc->lock);
-			if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
-			    gpc->uhva >= start && gpc->uhva < end)
+			if (gpc->needs_invalidation && !is_error_noslot_pfn(gpc->pfn) &&
+			    gpc->uhva >= start && gpc->uhva < end) {
+				gpc->needs_invalidation = false;
 				gpc->valid = false;
+			}
 			write_unlock_irq(&gpc->lock);
 			continue;
 		}
@@ -93,6 +95,9 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
 	if (!gpc->valid)
 		return false;
 
+	/* If it's valid, it needs invalidation! */
+	WARN_ON_ONCE(!gpc->needs_invalidation);
+
 	return true;
 }
 
@@ -175,6 +180,17 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		mmu_seq = gpc->kvm->mmu_invalidate_seq;
 		smp_rmb();
 
+		/*
+		 * The translation made by hva_to_pfn() below could be made
+		 * invalid as soon as it's mapped. But the uhva is already
+		 * known and that's all that gfn_to_pfn_cache_invalidate()
+		 * looks at. So set the 'needs_invalidation' flag to allow
+		 * the GPC to be marked invalid from the moment the lock is
+		 * dropped, before the corresponding PFN is even found (and,
+		 * more to the point, immediately afterwards).
+		 */
+		gpc->needs_invalidation = true;
+
 		write_unlock_irq(&gpc->lock);
 
 		/*
@@ -224,7 +240,8 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		 * attempting to refresh.
 		 */
 		WARN_ON_ONCE(gpc->valid);
-	} while (mmu_notifier_retry_cache(gpc->kvm, mmu_seq));
+	} while (!gpc->needs_invalidation ||
+		 mmu_notifier_retry_cache(gpc->kvm, mmu_seq));
 
 	gpc->valid = true;
 	gpc->pfn = new_pfn;
@@ -339,6 +356,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	 */
 	if (ret) {
 		gpc->valid = false;
+		gpc->needs_invalidation = false;
 		gpc->pfn = KVM_PFN_ERR_FAULT;
 		gpc->khva = NULL;
 	}
@@ -383,7 +401,7 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm)
 	gpc->pfn = KVM_PFN_ERR_FAULT;
 	gpc->gpa = INVALID_GPA;
 	gpc->uhva = KVM_HVA_ERR_BAD;
-	gpc->active = gpc->valid = false;
+	gpc->active = gpc->valid = gpc->needs_invalidation = false;
 }
 
 static int __kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long uhva,
@@ -453,6 +471,7 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 		write_lock_irq(&gpc->lock);
 		gpc->active = false;
 		gpc->valid = false;
+		gpc->needs_invalidation = false;
 
 		/*
 		 * Leave the GPA => uHVA cache intact, it's protected by the
-- 
2.44.0



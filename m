Return-Path: <kvm+bounces-26312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB03C973D58
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:35:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5ACD41F26DE2
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 170B11A76C7;
	Tue, 10 Sep 2024 16:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="L/x6q0sZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0261A76BD;
	Tue, 10 Sep 2024 16:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985903; cv=none; b=Qayr0fnFqp96GQpS+5cPjigCqScg/90HA5kp8EU6+KbDUj6nJehJdXci00nGuKgS8n9WY/JZ3zo5yl4S0/XXkskbzQQuFdZnZS5qhUmSamE2s8+UoHltQfk/Gs5SPJiWQxm9iQ6YEMKgyNvpyN8r7DRtOKXiHdIDl1mJr9vR43I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985903; c=relaxed/simple;
	bh=WiMd1fQnJ68uRJs7o1MvaQ3hErm2TB0gEsTi8l3L3mo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WLEErpPk9dZ7zXYJeVdRi2b6kBwRoXGippwrFY7JmNz3EYwfQtOci+W8aR/3BGOSj8U9ycICrmgBSuNVeqFNhsQJweB4LGHWUUn53ho5nFO3Fj9GEMzW13O8WsBHoy4GMl5fev6zWMGEF4FVTegY2L2Hk4ukJqRmCYVYe7NE9gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=L/x6q0sZ; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1725985902; x=1757521902;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nrEWCAm2NUlH3H3kjrWi9+hHd8dgkyixf/clN7dg47w=;
  b=L/x6q0sZWZg6KJQiavFHq6sKC9wGFqBhmSWtOa6NRVqbl3vNml9+WA4X
   lM8idV5vgYXiojVMNEIoJiKgtO6dUQyOjHJboF6XFgyVVYDcHbBhc7/OR
   Dg9kK2+Yyiqpabg1xYmY4eyZy2ubj+lQN9cDkf6FtghbTma7Ses9+qLDd
   4=;
X-IronPort-AV: E=Sophos;i="6.10,217,1719878400"; 
   d="scan'208";a="432478644"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 16:31:39 +0000
Received: from EX19MTAUEB001.ant.amazon.com [10.0.44.209:27167]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.42.209:2525] with esmtp (Farcaster)
 id f943c050-93c0-47aa-b307-1815f2e5f7c0; Tue, 10 Sep 2024 16:31:37 +0000 (UTC)
X-Farcaster-Flow-ID: f943c050-93c0-47aa-b307-1815f2e5f7c0
Received: from EX19D008UEA004.ant.amazon.com (10.252.134.191) by
 EX19MTAUEB001.ant.amazon.com (10.252.135.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:31:32 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D008UEA004.ant.amazon.com (10.252.134.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:31:31 +0000
Received: from ua2d7e1a6107c5b.home (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Tue, 10 Sep 2024 16:31:27 +0000
From: Patrick Roy <roypat@amazon.co.uk>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <mathieu.desnoyers@efficios.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <quic_eberman@quicinc.com>,
	<dwmw@amazon.com>, <david@redhat.com>, <tabba@google.com>, <rppt@kernel.org>,
	<linux-mm@kvack.org>, <dmatlack@google.com>
CC: Patrick Roy <roypat@amazon.co.uk>, <graf@amazon.com>,
	<jgowans@amazon.com>, <derekmn@amazon.com>, <kalyazin@amazon.com>,
	<xmarcalx@amazon.com>
Subject: [RFC PATCH v2 08/10] kvm: pfncache: Support caching gmem pfns
Date: Tue, 10 Sep 2024 17:30:34 +0100
Message-ID: <20240910163038.1298452-9-roypat@amazon.co.uk>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910163038.1298452-1-roypat@amazon.co.uk>
References: <20240910163038.1298452-1-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Inside the `hva_to_pfn_retry` loop, for gpa based gpcs, check whether
the gpa has KVM_MEMORY_ATTRIBUTE_PRIVATE set, and if so, use
`kvm_gmem_get_pfn` with `KVM_GMEM_GET_PFN_SHARED` to resolve the pfn.
Ignore uhva based gpcs for now, as they are only used with Xen, and we
don't have guest_memfd there (yet). Gmem pfns that are cached by a gpc
have their sharing refcount elevated until the gpc gets invalidated (or
rather: until it gets refreshed after invalidation) or deactivated.

Since during the refresh loop the memory attributes could change between
private shared, store a uhva anyway, even if it will not be used in the
translation in the end.

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 include/linux/kvm_types.h |  1 +
 virt/kvm/pfncache.c       | 63 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 827ecc0b7e10a..8903b8f46cf6c 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -70,6 +70,7 @@ struct gfn_to_pfn_cache {
 	kvm_pfn_t pfn;
 	bool active;
 	bool valid;
+	bool private;
 };
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 6de934a8a153f..a4f935e80f545 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -16,6 +16,7 @@
 #include <linux/highmem.h>
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/pagemap.h>
 
 #include "kvm_mm.h"
 
@@ -145,13 +146,20 @@ static void *gpc_map(kvm_pfn_t pfn)
 #endif
 }
 
-static void gpc_unmap(kvm_pfn_t pfn, void *khva)
+static void gpc_unmap(kvm_pfn_t pfn, void *khva, bool private)
 {
 	/* Unmap the old pfn/page if it was mapped before. */
 	if (is_error_noslot_pfn(pfn) || !khva)
 		return;
 
 	if (pfn_valid(pfn)) {
+		if (private) {
+			struct folio *folio = pfn_folio(pfn);
+
+			folio_lock(folio);
+			kvm_gmem_put_shared_pfn(pfn);
+			folio_unlock(folio);
+		}
 		kunmap(pfn_to_page(pfn));
 		return;
 	}
@@ -203,6 +211,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	void *old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
 	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
 	void *new_khva = NULL;
+	bool private = gpc->private;
 	unsigned long mmu_seq;
 
 	lockdep_assert_held(&gpc->refresh_lock);
@@ -235,17 +244,43 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			 * the existing mapping and didn't create a new one.
 			 */
 			if (new_khva != old_khva)
-				gpc_unmap(new_pfn, new_khva);
+				gpc_unmap(new_pfn, new_khva, private);
 
 			kvm_release_pfn_clean(new_pfn);
 
 			cond_resched();
 		}
 
-		/* We always request a writeable mapping */
-		new_pfn = hva_to_pfn(gpc->uhva, false, false, NULL, true, NULL);
-		if (is_error_noslot_pfn(new_pfn))
-			goto out_error;
+		/*
+		 * If we do not have a GPA, we cannot immediately determine
+		 * whether the area of guest memory gpc->uhva pointed to
+		 * is currently set to shared. So assume that uhva-based gpcs
+		 * never have their underlying guest memory switched to
+		 * private (which we can do as uhva-based gpcs are only used
+		 * with Xen, and guest_memfd is not supported there).
+		 */
+		if (gpc->gpa != INVALID_GPA) {
+			/*
+			 * mmu_notifier events can be due to shared/private conversions,
+			 * thus recheck this every iteration.
+			 */
+			private = kvm_mem_is_private(gpc->kvm, gpa_to_gfn(gpc->gpa));
+		} else {
+			private = false;
+		}
+
+		if (private) {
+			int r = kvm_gmem_get_pfn(gpc->kvm, gpc->memslot, gpa_to_gfn(gpc->gpa),
+						 &new_pfn, NULL, KVM_GMEM_GET_PFN_SHARED);
+			if (r)
+				goto out_error;
+		} else {
+			/* We always request a writeable mapping */
+			new_pfn = hva_to_pfn(gpc->uhva, false, false, NULL,
+					     true, NULL);
+			if (is_error_noslot_pfn(new_pfn))
+				goto out_error;
+		}
 
 		/*
 		 * Obtain a new kernel mapping if KVM itself will access the
@@ -274,6 +309,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	gpc->valid = true;
 	gpc->pfn = new_pfn;
 	gpc->khva = new_khva + offset_in_page(gpc->uhva);
+	gpc->private = private;
 
 	/*
 	 * Put the reference to the _new_ pfn.  The pfn is now tracked by the
@@ -298,6 +334,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	kvm_pfn_t old_pfn;
 	bool hva_change = false;
 	void *old_khva;
+	bool old_private;
 	int ret;
 
 	/* Either gpa or uhva must be valid, but not both */
@@ -316,6 +353,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	old_pfn = gpc->pfn;
 	old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
 	old_uhva = PAGE_ALIGN_DOWN(gpc->uhva);
+	old_private = gpc->private;
 
 	if (kvm_is_error_gpa(gpa)) {
 		page_offset = offset_in_page(uhva);
@@ -338,6 +376,11 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 			gpc->gpa = gpa;
 			gpc->generation = slots->generation;
 			gpc->memslot = __gfn_to_memslot(slots, gfn);
+			/*
+			 * compute the uhva even for private memory, in case an
+			 * invalidation event flips memory from private to
+			 * shared while in hva_to_pfn_retry
+			 */
 			gpc->uhva = gfn_to_hva_memslot(gpc->memslot, gfn);
 
 			if (kvm_is_error_hva(gpc->uhva)) {
@@ -395,7 +438,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	write_unlock_irq(&gpc->lock);
 
 	if (unmap_old)
-		gpc_unmap(old_pfn, old_khva);
+		gpc_unmap(old_pfn, old_khva, old_private);
 
 	return ret;
 }
@@ -486,6 +529,7 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 	struct kvm *kvm = gpc->kvm;
 	kvm_pfn_t old_pfn;
 	void *old_khva;
+	bool old_private;
 
 	guard(mutex)(&gpc->refresh_lock);
 
@@ -508,6 +552,9 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 		old_khva = gpc->khva - offset_in_page(gpc->khva);
 		gpc->khva = NULL;
 
+		old_private = gpc->private;
+		gpc->private = false;
+
 		old_pfn = gpc->pfn;
 		gpc->pfn = KVM_PFN_ERR_FAULT;
 		write_unlock_irq(&gpc->lock);
@@ -516,6 +563,6 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 		list_del(&gpc->list);
 		spin_unlock(&kvm->gpc_lock);
 
-		gpc_unmap(old_pfn, old_khva);
+		gpc_unmap(old_pfn, old_khva, old_private);
 	}
 }
-- 
2.46.0



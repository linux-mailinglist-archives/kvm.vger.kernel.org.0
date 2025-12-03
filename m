Return-Path: <kvm+bounces-65218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AFA2C9F552
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 15:42:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sto.lore.kernel.org (Postfix) with ESMTPS id 8BF103000B13
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 14:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB02E3002A9;
	Wed,  3 Dec 2025 14:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="Sa83EOV4"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC3D2FB98D
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 14:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764772942; cv=none; b=o9JlZXwWwteOD0vFbaB8m9gDPpOplnH1hZtEUJ6zlF5W+qwPaSaK5OWLC8YBacwydJrMO9vfX5xUCqpzLtWw39oRxZ1Z5pN6ow5Tnle2P+1iDdXQ74X5hD2yTqSct/o++H1TQWTbx9HqixtESqWnGvqBInokUyQGN6z3vmUuBqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764772942; c=relaxed/simple;
	bh=VBVOYMNu7wQPHk0cdGsQc1sfQFI3uJV2R4AH85YUTd4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UZhyahv0bc/Y5Y/RVvcQnTbLE6vUVcwldI0v9T4BikuCBStSKEqrid7WV56dqp9050UPKnPLMXjqDADI/ucejDawMYaCHbY7guS8AG88Kba0M2mQGUhoC8D23fuOH8lD2zBNa++urtTe5NQIcpKnU/XYfTMZoUm/4ZeWDNIIoJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=Sa83EOV4; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764772941; x=1796308941;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2yU7GhsrzYKyIg9t6c+2Jr/967yoOw56UVwzZM5U8PU=;
  b=Sa83EOV4EOo5b88K6ijRFBhFdJ+UV/q/84kingMkHmgGls2sAdBBUAqr
   TMd4HoQNLGMEInIPIP7PXjFQRwVy5HzRfS40bBIWQ91JNn807F76vuqr1
   BN5KQcFeaEZ0ethO7Pg2e3c/Ahssr4Ndhkis9B3eYgNdY/8V+0LIwbG2U
   BoDupNXtN5A8OEnwv33bRTZdMK/E8o2A4KzVhNCm1M1yS73quZUSqOsmT
   Psn2bfUpyUNcLXpBUhcjjUbHxPT/bgibpoAxwTddqEPBonXKazqhjrsMF
   wDMGMVy4CwYtYIXcp4PzOKdnKzbYLYfbyt7QUenrP5xF7zplfhUBleT88
   w==;
X-CSE-ConnectionGUID: a+DIFNiKT2e3iG29gxKzKA==
X-CSE-MsgGUID: ENucAAs+S4KdtZyQ0JGpmA==
X-IronPort-AV: E=Sophos;i="6.20,246,1758585600"; 
   d="scan'208";a="8334966"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 14:42:18 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:27999]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.237:2525] with esmtp (Farcaster)
 id b516f777-0690-4732-8da9-47f4621b8e5d; Wed, 3 Dec 2025 14:42:18 +0000 (UTC)
X-Farcaster-Flow-ID: b516f777-0690-4732-8da9-47f4621b8e5d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Wed, 3 Dec 2025 14:42:17 +0000
Received: from dev-dsk-itazur-1b-11e7fc0f.eu-west-1.amazon.com (172.19.66.53)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Wed, 3 Dec 2025 14:42:15 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov
	<vkuznets@redhat.com>, Fuad Tabba <tabba@google.com>, Brendan Jackman
	<jackmanb@google.com>, David Hildenbrand <david@kernel.org>, David Woodhouse
	<dwmw2@infradead.org>, Paul Durrant <pdurrant@amazon.com>, Nikita Kalyazin
	<kalyazin@amazon.com>, Patrick Roy <patrick.roy@campus.lmu.de>, "Takahiro
 Itazuri" <zulinx86@gmail.com>
Subject: [RFC PATCH 2/2] KVM: pfncache: Use vmap() for guest_memfd pages without direct map
Date: Wed, 3 Dec 2025 14:41:47 +0000
Message-ID: <20251203144159.6131-3-itazur@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203144159.6131-1-itazur@amazon.com>
References: <20251203144159.6131-1-itazur@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D032UWA004.ant.amazon.com (10.13.139.56) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

gfn_to_pfn_cache currently maps RAM PFNs with kmap(), which relies on
the direct map.  guest_memfd created with GUEST_MEMFD_FLAG_NO_DIRECT_MAP
disable their direct-map PTEs via set_direct_map_valid_noflush(), so the
linear address returned by kmap()/page_address() will fault if
dereferenced.

In some cases, gfn_to_pfn_cache dereferences the cached kernel host
virtual address (khva) from atomic contexts where page faults cannot be
tolerated.  Therefore khva must always refer to a fault-free kernel
mapping.  Since mapping and unmapping happen exclusively in the refresh
path, which may sleep, using vmap()/vunmap() for these pages is safe and
sufficient.

Introduce kvm_slot_no_direct_map() to detect guest_memfd slots without
the direct map, and make gpc_map()/gpc_unmap() use vmap()/vunmap() for
such pages.

This allows the features based on gfn_to_pfn_cache (e.g. kvm-clock) to
work correctly with guest_memfd regardless of whether its direct-map
PTEs are valid.

Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
---
 include/linux/kvm_host.h |  7 +++++++
 virt/kvm/pfncache.c      | 26 ++++++++++++++++++++------
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 70e6a5210ceb..793d98f97928 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -15,6 +15,7 @@
 #include <linux/minmax.h>
 #include <linux/mm.h>
 #include <linux/mmu_notifier.h>
+#include <linux/pagemap.h>
 #include <linux/preempt.h>
 #include <linux/msi.h>
 #include <linux/slab.h>
@@ -628,6 +629,12 @@ static inline bool kvm_slot_dirty_track_enabled(const struct kvm_memory_slot *sl
 	return slot->flags & KVM_MEM_LOG_DIRTY_PAGES;
 }
 
+static inline bool kvm_slot_no_direct_map(const struct kvm_memory_slot *slot)
+{
+	return slot && kvm_slot_has_gmem(slot) &&
+	       mapping_no_direct_map(slot->gmem.file->f_mapping);
+}
+
 static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
 {
 	return ALIGN(memslot->npages, BITS_PER_LONG) / 8;
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index bf8d6090e283..87167d7f3feb 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -96,10 +96,16 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
 	return true;
 }
 
-static void *gpc_map(kvm_pfn_t pfn)
+static void *gpc_map(struct gfn_to_pfn_cache *gpc, kvm_pfn_t pfn)
 {
-	if (pfn_valid(pfn))
-		return kmap(pfn_to_page(pfn));
+	if (pfn_valid(pfn)) {
+		struct page *page = pfn_to_page(pfn);
+
+		if (kvm_slot_no_direct_map(gpc->memslot))
+			return vmap(&page, 1, VM_MAP, PAGE_KERNEL);
+
+		return kmap(page);
+	}
 
 #ifdef CONFIG_HAS_IOMEM
 	return memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
@@ -115,6 +121,11 @@ static void gpc_unmap(kvm_pfn_t pfn, void *khva)
 		return;
 
 	if (pfn_valid(pfn)) {
+		if (is_vmalloc_addr(khva)) {
+			vunmap(khva);
+			return;
+		}
+
 		kunmap(pfn_to_page(pfn));
 		return;
 	}
@@ -224,13 +235,16 @@ static kvm_pfn_t gpc_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 
 		/*
 		 * Obtain a new kernel mapping if KVM itself will access the
-		 * pfn.  Note, kmap() and memremap() can both sleep, so this
-		 * too must be done outside of gpc->lock!
+		 * pfn.  Note, kmap(), vmap() and memremap() can sleep, so this
+		 * too must be done outside of gpc->lock! Note that even though
+		 * the rwlock is dropped, it's still fine to read gpc->pfn and
+		 * other fields because gpc->fresh_lock mutex prevents those
+		 * from being changed.
 		 */
 		if (new_pfn == gpc->pfn)
 			new_khva = old_khva;
 		else
-			new_khva = gpc_map(new_pfn);
+			new_khva = gpc_map(gpc, new_pfn);
 
 		if (!new_khva) {
 			kvm_release_page_unused(page);
-- 
2.50.1



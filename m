Return-Path: <kvm+bounces-65216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id AAEA3C9F54F
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 15:42:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sto.lore.kernel.org (Postfix) with ESMTPS id CB97A30004F4
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 14:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36CD32FFFA9;
	Wed,  3 Dec 2025 14:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="fP8pDq/Y"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC5E2FFFA4
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 14:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764772936; cv=none; b=RYRDOGhJyqK/EP3utVrs+Qn5ftIxIjR7qJQgklK4pumTVv37IYk28vvlY/FuuwsdEE+Rc9ptf2Ov9QlljxyBusY+DO/ROSADlLvgZ2uxQ5nwytDoZCKmZiP+tsUWfncSqMgQwoaiZ983/AYtQJA5Zt1AjsaDwEZlFCDWdQAuNqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764772936; c=relaxed/simple;
	bh=SAGNXwBosm6yut7uN0xXIwWXCZGLmIzyf7BpwClrva8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RySfmTqOH4694BK6EUMNst1Vs1w2y9EKwErGqHfKDaCOcrXjwji4I0gZiFTmX6i8V1zvxMBgYwkBdgrKk3c1K4tAUZTO1eUWLplXhFH9bYP0zCJ6/M/09jQwF8br/4kQXRv9kkwwsXcupquXN6zR/bp0GZ13v+OUYnbac9JB/HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=fP8pDq/Y; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764772934; x=1796308934;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u47O+xc6R9eNQyRA9e0w3wXnAgXGd+h4K/q7vHsneTY=;
  b=fP8pDq/Y82Y0N/uxeGgQ1S3sKGBVON9on3LIpkvYKg7a4B4XaIDhZAAE
   KRq/UdzgYSM0lPugFj3/W4dzgE9Is7I3a1z+y/bJiXp8tldGeYdXiKv4Y
   ixpOS0teO/ffcQdwQCR2Nhj0qjiVfLx4cog9aDhjv8vQTDJHHnsBgzHjo
   nXCIL9a8gq0LQsEOr8wwLE2Xb1F0mzoKwWmbCkW5P/m1WjIlASdBOA9ib
   2BOAYJ+3Z+SngZyQ4suCVuEOxF7LgEUVI4iBeLJbs+JBOJ3AiGjWbf+Hq
   B5/lIUmMgWZF1Xqmo0FUUE/MtfODg2fO4yeoLzuRTct8hfpqtPZNQsmj7
   w==;
X-CSE-ConnectionGUID: 7Si7EHrPTaaEfuRYXjGPXw==
X-CSE-MsgGUID: yWqK0VSwTHW+N4BXsIPPow==
X-IronPort-AV: E=Sophos;i="6.20,246,1758585600"; 
   d="scan'208";a="8332067"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 14:42:12 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:29368]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.51.184:2525] with esmtp (Farcaster)
 id fb4d1649-ee3e-4787-ac41-872cc54f0023; Wed, 3 Dec 2025 14:42:11 +0000 (UTC)
X-Farcaster-Flow-ID: fb4d1649-ee3e-4787-ac41-872cc54f0023
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Wed, 3 Dec 2025 14:42:11 +0000
Received: from dev-dsk-itazur-1b-11e7fc0f.eu-west-1.amazon.com (172.19.66.53)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Wed, 3 Dec 2025 14:42:09 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov
	<vkuznets@redhat.com>, Fuad Tabba <tabba@google.com>, Brendan Jackman
	<jackmanb@google.com>, David Hildenbrand <david@kernel.org>, David Woodhouse
	<dwmw2@infradead.org>, Paul Durrant <pdurrant@amazon.com>, Nikita Kalyazin
	<kalyazin@amazon.com>, Patrick Roy <patrick.roy@campus.lmu.de>, "Takahiro
 Itazuri" <zulinx86@gmail.com>
Subject: [RFC PATCH 1/2] KVM: pfncache: Use kvm_gmem_get_pfn() for guest_memfd-backed memslots
Date: Wed, 3 Dec 2025 14:41:46 +0000
Message-ID: <20251203144159.6131-2-itazur@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203144159.6131-1-itazur@amazon.com>
References: <20251203144159.6131-1-itazur@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D045UWC004.ant.amazon.com (10.13.139.203) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

gfn_to_pfn_cache currently relies on hva_to_pfn(), which resolves PFNs
through GUP.  GUP assumes that the page has a valid direct-map PTE,
which is not true for guest_memfd created with
GUEST_MEMFD_FLAG_NO_DIRECT_MAP, because their direct-map PTEs are
explicitly invalidated via set_direct_map_valid_noflush().

Introduce a helper function, gpc_to_pfn(), that routes PFN lookup to
kvm_gmem_get_pfn() for guest_memfd-backed memslots (regardless of
whether GUEST_MEMFD_FLAG_NO_DIRECT_MAP is set), and otherwise falls
back to the existing hva_to_pfn() path. Rename hva_to_pfn_retry() to
gpc_to_pfn_retry() accordingly.

Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
---
 virt/kvm/pfncache.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 728d2c1b488a..bf8d6090e283 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -152,22 +152,34 @@ static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_s
 	return kvm->mmu_invalidate_seq != mmu_seq;
 }
 
-static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
+static kvm_pfn_t gpc_to_pfn(struct gfn_to_pfn_cache *gpc, struct page **page)
 {
-	/* Note, the new page offset may be different than the old! */
-	void *old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
-	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
-	void *new_khva = NULL;
-	unsigned long mmu_seq;
-	struct page *page;
+	if (kvm_slot_has_gmem(gpc->memslot)) {
+		kvm_pfn_t pfn;
+
+		kvm_gmem_get_pfn(gpc->kvm, gpc->memslot, gpa_to_gfn(gpc->gpa),
+				 &pfn, page, NULL);
+		return pfn;
+	}
 
 	struct kvm_follow_pfn kfp = {
 		.slot = gpc->memslot,
 		.gfn = gpa_to_gfn(gpc->gpa),
 		.flags = FOLL_WRITE,
 		.hva = gpc->uhva,
-		.refcounted_page = &page,
+		.refcounted_page = page,
 	};
+	return hva_to_pfn(&kfp);
+}
+
+static kvm_pfn_t gpc_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
+{
+	/* Note, the new page offset may be different than the old! */
+	void *old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
+	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
+	void *new_khva = NULL;
+	unsigned long mmu_seq;
+	struct page *page;
 
 	lockdep_assert_held(&gpc->refresh_lock);
 
@@ -206,7 +218,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			cond_resched();
 		}
 
-		new_pfn = hva_to_pfn(&kfp);
+		new_pfn = gpc_to_pfn(gpc, &page);
 		if (is_error_noslot_pfn(new_pfn))
 			goto out_error;
 
@@ -319,7 +331,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 		}
 	}
 
-	/* Note: the offset must be correct before calling hva_to_pfn_retry() */
+	/* Note: the offset must be correct before calling gpc_to_pfn_retry() */
 	gpc->uhva += page_offset;
 
 	/*
@@ -327,7 +339,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	 * drop the lock and do the HVA to PFN lookup again.
 	 */
 	if (!gpc->valid || hva_change) {
-		ret = hva_to_pfn_retry(gpc);
+		ret = gpc_to_pfn_retry(gpc);
 	} else {
 		/*
 		 * If the HVA→PFN mapping was already valid, don't unmap it.
-- 
2.50.1



Return-Path: <kvm+bounces-21196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8837292BAF2
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 15:24:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4923FB295D6
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 13:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BFF816C842;
	Tue,  9 Jul 2024 13:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="R7+fxuFK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9105.amazon.com (smtp-fw-9105.amazon.com [207.171.188.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35A215ECCD;
	Tue,  9 Jul 2024 13:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720531285; cv=none; b=u8gyp1kQm0zTSTpk+Xxq8Z9M/k+kwiExpM1GTSLSMZ0KtEnmzchDZlI0LhyLAMCJXi9kt3Ehl+ildbtMFj0jokX1My/KOSVzeCfX3Q+vZ62Q7SLAM4egg9qKETzrknWpizkU3pmkSK1mwOP7zmEHymCc5422Xor8vinDZpy3D2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720531285; c=relaxed/simple;
	bh=rTxQSgURDcpl3BzGNJ8JiwifVeB4Xnp57taZkMVuTnc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FoMkwEld2wWvAcoHWetbrOyaWmUcGrIsc1g+EWlF64uaRwmjWSBo4v71zxMJ0N2QCTbZ9sF4C+4/VBsX0q+mZqGXe41Orm719ZJ6xQlV869jnhwexLKseWk8c8ikYfdprBDx6Sy9JUfU1IoDpuD0GIU9SnxKPYYB/TOplO3IKH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=R7+fxuFK; arc=none smtp.client-ip=207.171.188.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1720531284; x=1752067284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mg7XA6znVd/yr9yTmGtkTxgi1xD8jDw5CHJVcz9oSG8=;
  b=R7+fxuFKMCvUVaJbOHGUaP5+qo6Lkyn0xTP2vgyjB2xh+mZYh8e6woHM
   2hrN8zJ62WjREEsesMOpme6iHOJ0CEMGeILOCSxk4mVLvL75XX/ke97i/
   lzWT7qkMu0ThKp19nES/VBsXj/AdvaKjTiVtJhl0ywfSxupHKmQ2BwRSf
   Q=;
X-IronPort-AV: E=Sophos;i="6.09,195,1716249600"; 
   d="scan'208";a="739970210"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9105.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 13:21:17 +0000
Received: from EX19MTAUEA002.ant.amazon.com [10.0.0.204:6203]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.50.89:2525] with esmtp (Farcaster)
 id 2ee5a019-f3c3-4312-aa43-5ccfe349ee40; Tue, 9 Jul 2024 13:21:15 +0000 (UTC)
X-Farcaster-Flow-ID: 2ee5a019-f3c3-4312-aa43-5ccfe349ee40
Received: from EX19D008UEA002.ant.amazon.com (10.252.134.125) by
 EX19MTAUEA002.ant.amazon.com (10.252.134.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 9 Jul 2024 13:21:13 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D008UEA002.ant.amazon.com (10.252.134.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 9 Jul 2024 13:21:13 +0000
Received: from ua2d7e1a6107c5b.ant.amazon.com (172.19.88.180) by
 mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34
 via Frontend Transport; Tue, 9 Jul 2024 13:21:11 +0000
From: Patrick Roy <roypat@amazon.co.uk>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <akpm@linux-foundation.org>,
	<dwmw@amazon.co.uk>, <rppt@kernel.org>, <david@redhat.com>
CC: Patrick Roy <roypat@amazon.co.uk>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <willy@infradead.org>, <graf@amazon.com>,
	<derekmn@amazon.com>, <kalyazin@amazon.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <dmatlack@google.com>,
	<tabba@google.com>, <chao.p.peng@linux.intel.com>, <xmarcalx@amazon.co.uk>
Subject: [RFC PATCH 6/8] kvm: gmem: Temporarily restore direct map entries when needed
Date: Tue, 9 Jul 2024 14:20:34 +0100
Message-ID: <20240709132041.3625501-7-roypat@amazon.co.uk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709132041.3625501-1-roypat@amazon.co.uk>
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

If KVM_GMEM_NO_DIRECT_MAP is set, and KVM tries to internally access
guest-private memory inside kvm_{read,write}_guest, or via a
gfn_to_pfn_cache, temporarily restore the direct map entry.

To avoid race conditions between two threads restoring or zapping direct
map entries for the same page and potentially interfering with each
other (e.g. unfortune interweavings of map->read->unmap in the form of
map(A)->map(B)->read(A)->unmap(A)->read(B) [BOOM]), the following
invariant is upheld in this patch:

- Only a single gfn_to_pfn_cache can exist for any given pfn, and
- All non-gfn_to_pfn_cache code paths that temporarily restore direct
  map entries complete the entire map->access->unmap critical section
while holding the folio lock.

To remember whether a given folio currently has a direct map entry, use
the PG_private flag. If this flag is set, then the folio is removed from
the direct map, otherwise it is present in the direct map.
Modifications of this flag, together with the corresponding direct map
manipulations, must happen while holding the folio's lock.

A gfn_to_pfn_cache cannot hold the folio lock for its entire lifetime,
so it operates as follows: In gpc_map, under folio lock, restore the
direct map entry and set PG_private to 0. In gpc_unmap, zap the direct
map entry again and set PG_private back to 1.

If inside gpc_map the cache finds a folio that has PG_private set to 0,
it knows that another gfn_to_pfn_cache is currently active for the given
pfn (as this is the only scenario in which PG_private can be 0 without
the folio lock being held), and so it returns -EINVAL.

The only other interesting scenario is then if kvm_{read,write}_guest is
called for a gfn whose translation is currently cached inside a
gfn_to_pfn_cache. In this case, kvm_{read,write}_guest notices that
PG_private is 0 and skips all direct map manipulations. Since it is
holding the folio lock, it can be sure that gpc_unmap cannot
concurrently zap the direct map entries while kvm_{read,write}_guest
still needs them.

Note that this implementation is slightly too restrictive, as sometimes
multiple gfn_to_pfn_caches need to be active for the same gfn (for
example, each vCPU has its own kvm-clock structure, which they all try
to put into the same gfn).

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 virt/kvm/kvm_main.c | 59 +++++++++++++++++++++---------
 virt/kvm/pfncache.c | 89 +++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 123 insertions(+), 25 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4357f7cdf040..f968f1f3d7f7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -52,6 +52,7 @@
 
 #include <asm/processor.h>
 #include <asm/ioctl.h>
+#include <asm/set_memory.h>
 #include <linux/uaccess.h>
 
 #include "coalesced_mmio.h"
@@ -3291,8 +3292,8 @@ static int __kvm_read_guest_private_page(struct kvm *kvm,
 					 void *data, int offset, int len)
 {
 	kvm_pfn_t pfn;
-	int r;
-	struct page *page;
+	int r = 0;
+	struct folio *folio;
 	void *kaddr;
 
 	if (!kvm_can_access_gmem(kvm))
@@ -3303,13 +3304,24 @@ static int __kvm_read_guest_private_page(struct kvm *kvm,
 	if (r < 0)
 		return -EFAULT;
 
-	page = pfn_to_page(pfn);
-	lock_page(page);
-	kaddr = page_address(page) + offset;
-	memcpy(data, kaddr, len);
-	unlock_page(page);
-	put_page(page);
-	return 0;
+	folio = pfn_folio(pfn);
+	folio_lock(folio);
+	kaddr = folio_address(folio);
+	if (folio_test_private(folio)) {
+		r = set_direct_map_default_noflush(&folio->page);
+		if (r)
+			goto out_unlock;
+	}
+	memcpy(data, kaddr + offset, len);
+	if (folio_test_private(folio)) {
+		r = set_direct_map_invalid_noflush(&folio->page);
+		if (r)
+			goto out_unlock;
+	}
+out_unlock:
+	folio_unlock(folio);
+	folio_put(folio);
+	return r;
 }
 
 static int __kvm_vcpu_read_guest_private_page(struct kvm_vcpu *vcpu,
@@ -3437,8 +3449,8 @@ static int __kvm_write_guest_private_page(struct kvm *kvm,
 					  const void *data, int offset, int len)
 {
 	kvm_pfn_t pfn;
-	int r;
-	struct page *page;
+	int r = 0;
+	struct folio *folio;
 	void *kaddr;
 
 	if (!kvm_can_access_gmem(kvm))
@@ -3449,14 +3461,25 @@ static int __kvm_write_guest_private_page(struct kvm *kvm,
 	if (r < 0)
 		return -EFAULT;
 
-	page = pfn_to_page(pfn);
-	lock_page(page);
-	kaddr = page_address(page) + offset;
-	memcpy(kaddr, data, len);
-	unlock_page(page);
-	put_page(page);
+	folio = pfn_folio(pfn);
+	folio_lock(folio);
+	kaddr = folio_address(folio);
+	if (folio_test_private(folio)) {
+		r = set_direct_map_default_noflush(&folio->page);
+		if (r)
+			goto out_unlock;
+	}
+	memcpy(kaddr + offset, data, len);
+	if (folio_test_private(folio)) {
+		r = set_direct_map_invalid_noflush(&folio->page);
+		if (r)
+			goto out_unlock;
+	}
 
-	return 0;
+out_unlock:
+	folio_unlock(folio);
+	folio_put(folio);
+	return r;
 }
 
 static int __kvm_vcpu_write_guest_private_page(struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 6430e0a49558..95d2d5cdaa12 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -16,6 +16,9 @@
 #include <linux/highmem.h>
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/pagemap.h>
+
+#include <asm/set_memory.h>
 
 #include "kvm_mm.h"
 
@@ -99,10 +102,68 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
 	return true;
 }
 
-static void *gpc_map(kvm_pfn_t pfn)
+static int gpc_map_gmem(kvm_pfn_t pfn)
 {
-	if (pfn_valid(pfn))
+	int r = 0;
+	struct folio *folio = pfn_folio(pfn);
+	struct inode *inode = folio_inode(folio);
+
+	if (((unsigned long)inode->i_private & KVM_GMEM_NO_DIRECT_MAP) == 0)
+		goto out;
+
+	/* We need to avoid race conditions where set_memory_np is called for
+	 * pages that other parts of KVM still try to access.  We use the
+	 * PG_private bit for this. If it is set, then the page is removed from
+	 * the direct map. If it is cleared, the page is present in the direct
+	 * map. All changes to this bit, and all modifications of the direct
+	 * map entries for the page happen under the page lock. The _only_
+	 * place where a page will be in the direct map while the page lock is
+	 * _not_ held is if it is inside a gpc. All other parts of KVM that
+	 * temporarily re-insert gmem pages into the direct map (currently only
+	 * guest_{read,write}_page) take the page lock before the direct map
+	 * entry is restored, and hold it until it is zapped again. This means
+	 * - If we reach gpc_map while, say, guest_read_page is operating on
+	 *   this page, we block on acquiring the page lock until
+	 *   guest_read_page is done.
+	 * - If we reach gpc_map while another gpc is already caching this
+	 *   page, the page is present in the direct map and the PG_private
+	 *   flag is cleared. Int his case, we return -EINVAL below to avoid
+	 *   two gpcs caching the same page (since we do not ref-count
+	 *   insertions back into the direct map, when the first cache gets
+	 *   invalidated it would "break" the second cache that assumes the
+	 *   page is present in the direct map until the second cache itself
+	 *   gets invalidated).
+	 * - Lastly, if guest_read_page is called for a page inside of a gpc,
+	 *   it will see that the PG_private flag is cleared, and thus assume
+	 *   it is present in the direct map (and leave the direct map entry
+	 *   untouched). Since it will be holding the page lock, it cannot race
+	 *   with gpc_unmap.
+	 */
+	folio_lock(folio);
+	if (folio_test_private(folio)) {
+		r = set_direct_map_default_noflush(&folio->page);
+		if (r)
+			goto out_unlock;
+
+		folio_clear_private(folio);
+	} else {
+		r = -EINVAL;
+	}
+out_unlock:
+	folio_unlock(folio);
+out:
+	return r;
+}
+
+static void *gpc_map(kvm_pfn_t pfn, bool private)
+{
+	if (pfn_valid(pfn)) {
+		if (private) {
+			if (gpc_map_gmem(pfn))
+				return NULL;
+		}
 		return kmap(pfn_to_page(pfn));
+	}
 
 #ifdef CONFIG_HAS_IOMEM
 	return memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
@@ -111,13 +172,27 @@ static void *gpc_map(kvm_pfn_t pfn)
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
+			struct inode *inode = folio_inode(folio);
+
+			if ((unsigned long)inode->i_private &
+			    KVM_GMEM_NO_DIRECT_MAP) {
+				folio_lock(folio);
+				BUG_ON(folio_test_private(folio));
+				BUG_ON(set_direct_map_invalid_noflush(
+					&folio->page));
+				folio_set_private(folio);
+				folio_unlock(folio);
+			}
+		}
 		kunmap(pfn_to_page(pfn));
 		return;
 	}
@@ -195,7 +270,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			 * the existing mapping and didn't create a new one.
 			 */
 			if (new_khva != old_khva)
-				gpc_unmap(new_pfn, new_khva);
+				gpc_unmap(new_pfn, new_khva, gpc->is_private);
 
 			kvm_release_pfn_clean(new_pfn);
 
@@ -224,7 +299,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		if (new_pfn == gpc->pfn)
 			new_khva = old_khva;
 		else
-			new_khva = gpc_map(new_pfn);
+			new_khva = gpc_map(new_pfn, gpc->is_private);
 
 		if (!new_khva) {
 			kvm_release_pfn_clean(new_pfn);
@@ -379,7 +454,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	write_unlock_irq(&gpc->lock);
 
 	if (unmap_old)
-		gpc_unmap(old_pfn, old_khva);
+		gpc_unmap(old_pfn, old_khva, old_private);
 
 	return ret;
 }
@@ -500,6 +575,6 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 		list_del(&gpc->list);
 		spin_unlock(&kvm->gpc_lock);
 
-		gpc_unmap(old_pfn, old_khva);
+		gpc_unmap(old_pfn, old_khva, gpc->is_private);
 	}
 }
-- 
2.45.2



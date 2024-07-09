Return-Path: <kvm+bounces-21195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 07CA492BAEA
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 15:23:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16DDCB28841
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 13:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66AC21684B9;
	Tue,  9 Jul 2024 13:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="SJ4rfNYq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9105.amazon.com (smtp-fw-9105.amazon.com [207.171.188.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399F016B381;
	Tue,  9 Jul 2024 13:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720531283; cv=none; b=Lw/IERPqyn2VdZUFBNlC1ugBGQbTr2reTp0eFZBlObYWm6SAMaOfM+V2yiTf5IiP029+2Ojg33gH+dKXBMBKMoYcTckOgfNLJbzJ8vkMiTuuffnB114Eg1ugsbaF6FtG6EL3CGuRiimbiEQbTnigjo+eGeM9YUi6n/PSTj953I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720531283; c=relaxed/simple;
	bh=I23lBRGUQaayc5ffZ+uZ4QKT658elNyo5piW8m0re7U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=by55RGRrzxTHknCRz0m7NlOofkzf6DPMEW3OR6jQ14ncwc1rR2YQtzomNphtgmUj+C4876PD5OV5kjtKGo3cwudjJwBwmgy9RFvW3bj2iWUUgf/k/glHV7CRXpl1vZE6gZu2Liu+Li5LsCnOaKObYECdGLzO7luIfEn1nQWOZjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=SJ4rfNYq; arc=none smtp.client-ip=207.171.188.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1720531283; x=1752067283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+mzO007algvViExHdnpknhkipITD3cHhlfbBcPgvLYk=;
  b=SJ4rfNYqkGBW89jP4cSGSgwSqCGGFeraGPQGashE8UVRJol6I0HjpRPE
   ZKIvfahZlC7ki/iojpPdOr4CVcPyZSJniPUKUatv1wdSmvy3ikqrp2QOY
   0BBbE0rdpBQt+luO4kYI/0djHT7jlSBT/xH8wAyC//2eFVhNLxPzgEnTI
   Q=;
X-IronPort-AV: E=Sophos;i="6.09,195,1716249600"; 
   d="scan'208";a="739970201"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9105.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 13:21:15 +0000
Received: from EX19MTAUEC001.ant.amazon.com [10.0.0.204:50152]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.92.61:2525] with esmtp (Farcaster)
 id 1a418e6e-d33b-4bef-8883-26ade4dd88c5; Tue, 9 Jul 2024 13:21:13 +0000 (UTC)
X-Farcaster-Flow-ID: 1a418e6e-d33b-4bef-8883-26ade4dd88c5
Received: from EX19D008UEA004.ant.amazon.com (10.252.134.191) by
 EX19MTAUEC001.ant.amazon.com (10.252.135.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 9 Jul 2024 13:21:10 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D008UEA004.ant.amazon.com (10.252.134.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 9 Jul 2024 13:21:10 +0000
Received: from ua2d7e1a6107c5b.ant.amazon.com (172.19.88.180) by
 mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34
 via Frontend Transport; Tue, 9 Jul 2024 13:21:07 +0000
From: Patrick Roy <roypat@amazon.co.uk>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <akpm@linux-foundation.org>,
	<dwmw@amazon.co.uk>, <rppt@kernel.org>, <david@redhat.com>
CC: Patrick Roy <roypat@amazon.co.uk>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <willy@infradead.org>, <graf@amazon.com>,
	<derekmn@amazon.com>, <kalyazin@amazon.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <dmatlack@google.com>,
	<tabba@google.com>, <chao.p.peng@linux.intel.com>, <xmarcalx@amazon.co.uk>
Subject: [RFC PATCH 5/8] kvm: gmem: add option to remove guest private memory from direct map
Date: Tue, 9 Jul 2024 14:20:33 +0100
Message-ID: <20240709132041.3625501-6-roypat@amazon.co.uk>
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

While guest_memfd is not available to be mapped by userspace, it is
still accessible through the kernel's direct map. This means that in
scenarios where guest-private memory is not hardware protected, it can
be speculatively read and its contents potentially leaked through
hardware side-channels. Removing guest-private memory from the direct
map, thus mitigates a large class of speculative execution issues
[1, Table 1].

This patch adds a flag to the `KVM_CREATE_GUEST_MEMFD` which, if set, removes the
struct pages backing guest-private memory from the direct map. Should
`CONFIG_HAVE_KVM_GMEM_{INVALIDATE, PREPARE}` be set, pages are removed
after preparation and before invalidation, so that the
prepare/invalidate routines do not have to worry about potentially
absent direct map entries.

Direct map removal do not reuse the `KVM_GMEM_PREPARE` machinery, since `prepare` can be
called multiple time, and it is the responsibility of the preparation
routine to not "prepare" the same folio twice [2]. Thus, instead
explicitly check if `filemap_grab_folio` allocated a new folio, and
remove the returned folio from the direct map only if this was the case.

The patch uses release_folio instead of free_folio to reinsert pages
back into the direct map as by the time free_folio is called,
folio->mapping can already be NULL. This means that a call to
folio_inode inside free_folio might deference a NULL pointer, leaving no
way to access the inode which stores the flags that allow determining
whether the page was removed from the direct map in the first place.

Lastly, the patch uses set_direct_map_{invalid,default}_noflush instead
of `set_memory_[n]p` to avoid expensive flushes of TLBs and the L*-cache
hierarchy. This is especially important once KVM restores direct map
entries on-demand in later patches, where simple FIO benchmarks of a
virtio-blk device have shown that TLB flushes on a Intel(R) Xeon(R)
Platinum 8375C CPU @ 2.90GHz resulted in 80% degradation in throughput
compared to a non-flushing solution.

Not flushing the TLB means that until TLB entries for temporarily
restored direct map entries get naturally evicted, they can be used
during speculative execution, and effectively "unhide" the memory for
longer than intended. We consider this acceptable, as the only pages
that are temporarily reinserted into the direct map like this will
either hold PV data structures (kvm-clock, asyncpf, etc), or pages
containing privileged instructions inside the guest kernel image (in the
MMIO emulation case).

[1]: https://download.vusec.net/papers/quarantine_raid23.pdf

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 include/uapi/linux/kvm.h |  2 ++
 virt/kvm/guest_memfd.c   | 52 ++++++++++++++++++++++++++++++++++------
 2 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e065d9fe7ab2..409116aa23c9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1563,4 +1563,6 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+#define KVM_GMEM_NO_DIRECT_MAP                 (1ULL << 0)
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9148b9679bb1..dc9b0c2d0b0e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -4,6 +4,7 @@
 #include <linux/kvm_host.h>
 #include <linux/pagemap.h>
 #include <linux/anon_inodes.h>
+#include <linux/set_memory.h>
 
 #include "kvm_mm.h"
 
@@ -49,9 +50,16 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
 	return 0;
 }
 
+static bool kvm_gmem_not_present(struct inode *inode)
+{
+	return ((unsigned long)inode->i_private & KVM_GMEM_NO_DIRECT_MAP) != 0;
+}
+
 static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool prepare)
 {
 	struct folio *folio;
+	bool zap_direct_map = false;
+	int r;
 
 	/* TODO: Support huge pages. */
 	folio = filemap_grab_folio(inode->i_mapping, index);
@@ -74,16 +82,30 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool
 		for (i = 0; i < nr_pages; i++)
 			clear_highpage(folio_page(folio, i));
 
+		// We need to clear the folio before calling kvm_gmem_prepare_folio,
+		// but can only remove it from the direct map _after_ preparation is done.
+		zap_direct_map = kvm_gmem_not_present(inode);
+
 		folio_mark_uptodate(folio);
 	}
 
 	if (prepare) {
-		int r =	kvm_gmem_prepare_folio(inode, index, folio);
-		if (r < 0) {
-			folio_unlock(folio);
-			folio_put(folio);
-			return ERR_PTR(r);
-		}
+		r = kvm_gmem_prepare_folio(inode, index, folio);
+		if (r < 0)
+			goto out_err;
+	}
+
+	if (zap_direct_map) {
+		r = set_direct_map_invalid_noflush(&folio->page);
+		if (r < 0)
+			goto out_err;
+
+		// We use the private flag to track whether the folio has been removed
+		// from the direct map. This is because inside of ->free_folio,
+		// we do not have access to the address_space anymore, meaning we
+		// cannot check folio_inode(folio)->i_private to determine whether
+		// KVM_GMEM_NO_DIRECT_MAP was set.
+		folio_set_private(folio);
 	}
 
 	/*
@@ -91,6 +113,10 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool
 	 * unevictable and there is no storage to write back to.
 	 */
 	return folio;
+out_err:
+	folio_unlock(folio);
+	folio_put(folio);
+	return ERR_PTR(r);
 }
 
 static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
@@ -354,10 +380,22 @@ static void kvm_gmem_free_folio(struct folio *folio)
 }
 #endif
 
+static void kvm_gmem_invalidate_folio(struct folio *folio, size_t start, size_t end)
+{
+	if (start == 0 && end == PAGE_SIZE) {
+		// We only get here if PG_private is set, which only happens if kvm_gmem_not_present
+		// returned true in kvm_gmem_get_folio. Thus no need to do that check again.
+		BUG_ON(set_direct_map_default_noflush(&folio->page));
+
+		folio_clear_private(folio);
+	}
+}
+
 static const struct address_space_operations kvm_gmem_aops = {
 	.dirty_folio = noop_dirty_folio,
 	.migrate_folio	= kvm_gmem_migrate_folio,
 	.error_remove_folio = kvm_gmem_error_folio,
+	.invalidate_folio = kvm_gmem_invalidate_folio,
 #ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
 	.free_folio = kvm_gmem_free_folio,
 #endif
@@ -443,7 +481,7 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 {
 	loff_t size = args->size;
 	u64 flags = args->flags;
-	u64 valid_flags = 0;
+	u64 valid_flags = KVM_GMEM_NO_DIRECT_MAP;
 
 	if (flags & ~valid_flags)
 		return -EINVAL;
-- 
2.45.2



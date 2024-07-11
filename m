Return-Path: <kvm+bounces-21432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5810692EE5D
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 20:08:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11721282B00
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 18:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6BE16EB63;
	Thu, 11 Jul 2024 18:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fw/sPpjR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0029416D9B3
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 18:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720720993; cv=none; b=C3pBXH7AeLjfw/xSm5ArmJufHPV1LTvteXSeNYFwaOLJY1JaCcRcCKd7eKR+BHl7N4I4zrkYgMc1/ikAN6HtWQYphYa8RH8HjEpI08W8pj1dxJrzAlhpqByW3UenQWmexjgr4dY1XzvthH99pX6At+Ar8uHWU6HgDtKwQAurFCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720720993; c=relaxed/simple;
	bh=ul6wGmGvayvF7Q/3RVvFFs/ZrscnpCnqpBv/fiyLAp0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=T2TNpeNopHDc+CIlkPXVepGWmMeudg3Dy057pHTsa0RuCC9dyUH+hjlSsomQTl23tzBlTJD8JNphP0Q4opzzgewCuAk2mk7KdusTovOgW/4FAMA3Xp2JxRM8tTfpaY3DxtIEAntDV9wzRFT+Zmr3OMPOOYC3p/G5LUGIrrKwwjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fw/sPpjR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720720990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6Na0W+nnqCLAJBaL4aydebl5apHkb67BzyZZfMsvY/s=;
	b=fw/sPpjRum0Sfl2aRvJxJ5FPoCJAL0yJIpDsXFm1kXp1FZ8G/09F84qts7v2okovdKgxEi
	nVaBIT6hLhodE7oLn7vUBIxhkv2qxrK+ZLrwSELM9on7vD5/LJT7XN4lDrm3ImVJvY0MWf
	gV4NZ9muDDH/FAeBRRjakPiuhR94fqI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-emnnUYtQMXm4Ny4efZh3iw-1; Thu,
 11 Jul 2024 14:03:09 -0400
X-MC-Unique: emnnUYtQMXm4Ny4efZh3iw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0A631954B31;
	Thu, 11 Jul 2024 18:03:07 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8132E1955E89;
	Thu, 11 Jul 2024 18:03:06 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: vbabka@suse.cz,
	david@redhat.com,
	seanjc@google.com,
	michael.roth@amd.com,
	linux-mm@kvack.org
Subject: [PATCH] mm, virt: merge AS_UNMOVABLE and AS_INACCESSIBLE
Date: Thu, 11 Jul 2024 14:03:05 -0400
Message-ID: <20240711180305.15626-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The flags AS_UNMOVABLE and AS_INACCESSIBLE were both added just for guest_memfd;
AS_UNMOVABLE is already in existing versions of Linux, while AS_INACCESSIBLE was
acked for inclusion in 6.11.

But really, they are the same thing: only guest_memfd uses them, at least for
now, and guest_memfd pages are unmovable because they should not be
accessed by the CPU.

So merge them into one; use the AS_INACCESSIBLE name which is more comprehensive.
At the same time, this fixes an embarrassing bug where AS_INACCESSIBLE was used
as a bit mask, despite it being just a bit index.

The bug was mostly benign, becaus AS_INACCESSIBLE's bit representation (1010)
corresponded to setting AS_UNEVICTABLE (which is already set) and AS_ENOSPC
(except no async writes can happen on the guest_memfd).  So the AS_INACCESSIBLE
flag simply had no effect.

Fixes: 1d23040caa8b ("KVM: guest_memfd: Use AS_INACCESSIBLE when creating guest_memfd inode")
Fixes: c72ceafbd12c ("mm: Introduce AS_INACCESSIBLE for encrypted/confidential memory")
Cc: linux-mm@kvack.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/pagemap.h | 14 +++++++-------
 mm/compaction.c         | 12 ++++++------
 mm/migrate.c            |  2 +-
 mm/truncate.c           |  2 +-
 virt/kvm/guest_memfd.c  |  3 +--
 5 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ce7bac8f81da..e05585eda771 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -208,8 +208,8 @@ enum mapping_flags {
 	AS_RELEASE_ALWAYS,	/* Call ->release_folio(), even if no private data */
 	AS_STABLE_WRITES,	/* must wait for writeback before modifying
 				   folio contents */
-	AS_UNMOVABLE,		/* The mapping cannot be moved, ever */
-	AS_INACCESSIBLE,	/* Do not attempt direct R/W access to the mapping */
+	AS_INACCESSIBLE,	/* Do not attempt direct R/W access to the mapping,
+				   including to move the mapping */
 };
 
 /**
@@ -310,20 +310,20 @@ static inline void mapping_clear_stable_writes(struct address_space *mapping)
 	clear_bit(AS_STABLE_WRITES, &mapping->flags);
 }
 
-static inline void mapping_set_unmovable(struct address_space *mapping)
+static inline void mapping_set_inaccessible(struct address_space *mapping)
 {
 	/*
-	 * It's expected unmovable mappings are also unevictable. Compaction
+	 * It's expected inaccessible mappings are also unevictable. Compaction
 	 * migrate scanner (isolate_migratepages_block()) relies on this to
 	 * reduce page locking.
 	 */
 	set_bit(AS_UNEVICTABLE, &mapping->flags);
-	set_bit(AS_UNMOVABLE, &mapping->flags);
+	set_bit(AS_INACCESSIBLE, &mapping->flags);
 }
 
-static inline bool mapping_unmovable(struct address_space *mapping)
+static inline bool mapping_inaccessible(struct address_space *mapping)
 {
-	return test_bit(AS_UNMOVABLE, &mapping->flags);
+	return test_bit(AS_INACCESSIBLE, &mapping->flags);
 }
 
 static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
diff --git a/mm/compaction.c b/mm/compaction.c
index e731d45befc7..714afd9c6df6 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1172,22 +1172,22 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (((mode & ISOLATE_ASYNC_MIGRATE) && is_dirty) ||
 		    (mapping && is_unevictable)) {
 			bool migrate_dirty = true;
-			bool is_unmovable;
+			bool is_inaccessible;
 
 			/*
 			 * Only folios without mappings or that have
 			 * a ->migrate_folio callback are possible to migrate
 			 * without blocking.
 			 *
-			 * Folios from unmovable mappings are not migratable.
+			 * Folios from inaccessible mappings are not migratable.
 			 *
 			 * However, we can be racing with truncation, which can
 			 * free the mapping that we need to check. Truncation
 			 * holds the folio lock until after the folio is removed
 			 * from the page so holding it ourselves is sufficient.
 			 *
-			 * To avoid locking the folio just to check unmovable,
-			 * assume every unmovable folio is also unevictable,
+			 * To avoid locking the folio just to check inaccessible,
+			 * assume every inaccessible folio is also unevictable,
 			 * which is a cheaper test.  If our assumption goes
 			 * wrong, it's not a correctness bug, just potentially
 			 * wasted cycles.
@@ -1200,9 +1200,9 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 				migrate_dirty = !mapping ||
 						mapping->a_ops->migrate_folio;
 			}
-			is_unmovable = mapping && mapping_unmovable(mapping);
+			is_inaccessible = mapping && mapping_inaccessible(mapping);
 			folio_unlock(folio);
-			if (!migrate_dirty || is_unmovable)
+			if (!migrate_dirty || is_inaccessible)
 				goto isolate_fail_put;
 		}
 
diff --git a/mm/migrate.c b/mm/migrate.c
index dd04f578c19c..50b60fb414e9 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -965,7 +965,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 
 		if (!mapping)
 			rc = migrate_folio(mapping, dst, src, mode);
-		else if (mapping_unmovable(mapping))
+		else if (mapping_inaccessible(mapping))
 			rc = -EOPNOTSUPP;
 		else if (mapping->a_ops->migrate_folio)
 			/*
diff --git a/mm/truncate.c b/mm/truncate.c
index 60388935086d..581977d2356f 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -233,7 +233,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 	 * doing a complex calculation here, and then doing the zeroing
 	 * anyway if the page split fails.
 	 */
-	if (!(folio->mapping->flags & AS_INACCESSIBLE))
+	if (!mapping_inaccessible(folio->mapping))
 		folio_zero_range(folio, offset, length);
 
 	if (folio_has_private(folio))
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9148b9679bb1..1c509c351261 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -416,11 +416,10 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	inode->i_private = (void *)(unsigned long)flags;
 	inode->i_op = &kvm_gmem_iops;
 	inode->i_mapping->a_ops = &kvm_gmem_aops;
-	inode->i_mapping->flags |= AS_INACCESSIBLE;
 	inode->i_mode |= S_IFREG;
 	inode->i_size = size;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
-	mapping_set_unmovable(inode->i_mapping);
+	mapping_set_inaccessible(inode->i_mapping);
 	/* Unmovable mappings are supposed to be marked unevictable as well. */
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
 
-- 
2.43.0



Return-Path: <kvm+bounces-59479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE37BB861C
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 01:27:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6723F4E7EBC
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 23:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F65829E117;
	Fri,  3 Oct 2025 23:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SZjAlzG2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFE8285050
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 23:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759533980; cv=none; b=Ek86fPjklMIYz0Ug92uP8vEqVKiik/jLfpAdZzXyk/YcQ1iTHwMMF6n6Z316Nt1HRtrOWuTB0lmTHB0/yTt/6UVozICRedrfTOaq7lSvNkVLgL5V26HNkmHnEBCWMaf4C1gm4501ZiGYpH3RfdhblTb/ynVxLTNrfxhlqTePjJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759533980; c=relaxed/simple;
	bh=JgwH0hhK2IifgJKiBLx6g54yKAN8QI8WbPcCajKH/V4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O/1yq+fvplHK1ikuNQT4RhfDs0ApsjW95ILCBCF2Njej78ockZGKNeGDskL1JBCNtnRJA/LP7KKtStTjVYO0xENsXYm1eUi5YYlYpV9AtnDJRUfWIjcfFJ7rwCWzVrmFJMZhVluqXy6roi2r1+NS/AlwZaDt9cGwjYEsl3nQIUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SZjAlzG2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befb83so3193874a91.1
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 16:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759533978; x=1760138778; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=q3IgVVV1CLaiYzreC9VyBw/7/0EpP82vzJ1yumnTCCo=;
        b=SZjAlzG2W+bLG6As50V1PFG8uQlnKbeDcov/xbx3DC0cp0L8JEUk+sM9F8EG+nPuxu
         GKbpTPgAMvpFpoP+FffR/Wey2WHX7dRDIJtOA5UrqDm2DJDy9mRNh1NTwxSxcMEn1QYX
         ZmlfKBE0TzBpvxpjjs911Y59YKDyEQ6ERJe5lyMMln8vlMIlXBM7BQdBH8ZTtrw9xHLD
         MPObWDCO0cJMTZyzqfwdIlnLmG4QfaiIXdycYHV8L9At1d2FokHlvZ43QCZ7k2hEEP65
         VLSV4w/NaRm2YT9DGp8hv1MtpHvW6ZRZVpGEq3UA0pBtQsAeu1Jv9/hqjqcBULJIP8Ko
         xqug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759533978; x=1760138778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q3IgVVV1CLaiYzreC9VyBw/7/0EpP82vzJ1yumnTCCo=;
        b=YgtnHYHGN8OiZLcDaYyupsxpZXsNTpDVAvLuPbuYyLlFDU6/OdZfV9A1bU/d1tora0
         s5JFtKPDDuXNa85+sn84E3V3igZ9L+QrdNhWJ257RdA2IHbA7mE3Q/zEZj9eGjPg8JUT
         UCMwLG4lVSl7sZXRYzMP5MCVcbHaKpZDdhDpJjOV8/SX1AqyB4UWaE529NwFYsZ26pjb
         jGqqcBL22+qTzLw0yVRUh6QKkxU/5wm/9rAJX9M9ZHPJNOeyBv2BW2aj8vO4Bb7leroI
         2TLXkDoJnZVGAg3WY3SaXYv94ocxWg5yWwp/7A2p6WnDmU8OktSitS6xzDgK3MqSejrI
         LLcw==
X-Gm-Message-State: AOJu0YwoS6BnDIFlDFvC09EhlTThPdaEYd9HCcjrRAQVuXrxMBzyBXKV
	dZwtYCZ7kr1Gmoa8ig7DTfDEB0iu+3UALVXm2TfhSBs0RS8SBBbfBH4K3R77ribn5WccTx8Gd8i
	wQiv6hQ==
X-Google-Smtp-Source: AGHT+IEdnj/mdwvT2YHCE2J52BB93ym2M0LRhBZ2QTLnlqPMuHTXLV4zwanffN79lJZAvxv4138mpDLAJ3U=
X-Received: from pjbkb13.prod.google.com ([2002:a17:90a:e7cd:b0:330:604a:1028])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:388b:b0:32e:24cf:e658
 with SMTP id 98e67ed59e1d1-339c2716d84mr5349640a91.3.1759533978267; Fri, 03
 Oct 2025 16:26:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Oct 2025 16:25:56 -0700
In-Reply-To: <20251003232606.4070510-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003232606.4070510-4-seanjc@google.com>
Subject: [PATCH v2 03/13] KVM: guest_memfd: Invalidate SHARED GPAs if gmem
 supports INIT_SHARED
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

When invalidating gmem ranges, e.g. in response to PUNCH_HOLE, process all
possible range types (PRIVATE vs. SHARED) for the gmem instance.  Since
since guest_memfd doesn't yet support in-place conversions, simply pivot
on INIT_SHARED as a gmem instance can currently only have private or shared
memory, not both.

Failure to mark shared GPAs for invalidation is benign in the current code
base, as only x86's TDX consumes KVM_FILTER_{PRIVATE,SHARED}, and TDX
doesn't yet support INIT_SHARED with guest_memfd.  However, invalidating
only private GPAs is conceptually wrong and a lurking bug, e.g. could
result in missed invalidations if ARM starts filtering invalidations based
on attributes.

Fixes: 3d3a04fad25a ("KVM: Allow and advertise support for host mmap() on guest_memfd files")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 64 +++++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 20 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index cf3afba23a6b..e10d2c71e78c 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -102,8 +102,17 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	return filemap_grab_folio(inode->i_mapping, index);
 }
 
-static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
-				      pgoff_t end)
+static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
+{
+	if ((u64)inode->i_private & GUEST_MEMFD_FLAG_INIT_SHARED)
+		return KVM_FILTER_SHARED;
+
+	return KVM_FILTER_PRIVATE;
+}
+
+static void __kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
+					pgoff_t end,
+					enum kvm_gfn_range_filter attr_filter)
 {
 	bool flush = false, found_memslot = false;
 	struct kvm_memory_slot *slot;
@@ -118,8 +127,7 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 			.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
 			.slot = slot,
 			.may_block = true,
-			/* guest memfd is relevant to only private mappings. */
-			.attr_filter = KVM_FILTER_PRIVATE,
+			.attr_filter = attr_filter,
 		};
 
 		if (!found_memslot) {
@@ -139,8 +147,21 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 		KVM_MMU_UNLOCK(kvm);
 }
 
-static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
-				    pgoff_t end)
+static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
+				      pgoff_t end)
+{
+	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
+	enum kvm_gfn_range_filter attr_filter;
+	struct kvm_gmem *gmem;
+
+	attr_filter = kvm_gmem_get_invalidate_filter(inode);
+
+	list_for_each_entry(gmem, gmem_list, entry)
+		__kvm_gmem_invalidate_begin(gmem, start, end, attr_filter);
+}
+
+static void __kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
+				      pgoff_t end)
 {
 	struct kvm *kvm = gmem->kvm;
 
@@ -151,12 +172,20 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
 	}
 }
 
+static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
+				    pgoff_t end)
+{
+	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
+	struct kvm_gmem *gmem;
+
+	list_for_each_entry(gmem, gmem_list, entry)
+		__kvm_gmem_invalidate_end(gmem, start, end);
+}
+
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
-	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
 	pgoff_t start = offset >> PAGE_SHIFT;
 	pgoff_t end = (offset + len) >> PAGE_SHIFT;
-	struct kvm_gmem *gmem;
 
 	/*
 	 * Bindings must be stable across invalidation to ensure the start+end
@@ -164,13 +193,11 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	 */
 	filemap_invalidate_lock(inode->i_mapping);
 
-	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_begin(gmem, start, end);
+	kvm_gmem_invalidate_begin(inode, start, end);
 
 	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
 
-	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_end(gmem, start, end);
+	kvm_gmem_invalidate_end(inode, start, end);
 
 	filemap_invalidate_unlock(inode->i_mapping);
 
@@ -280,8 +307,9 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
-	kvm_gmem_invalidate_end(gmem, 0, -1ul);
+	__kvm_gmem_invalidate_begin(gmem, 0, -1ul,
+				    kvm_gmem_get_invalidate_filter(inode));
+	__kvm_gmem_invalidate_end(gmem, 0, -1ul);
 
 	list_del(&gmem->entry);
 
@@ -403,8 +431,6 @@ static int kvm_gmem_migrate_folio(struct address_space *mapping,
 
 static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *folio)
 {
-	struct list_head *gmem_list = &mapping->i_private_list;
-	struct kvm_gmem *gmem;
 	pgoff_t start, end;
 
 	filemap_invalidate_lock_shared(mapping);
@@ -412,8 +438,7 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
 	start = folio->index;
 	end = start + folio_nr_pages(folio);
 
-	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_begin(gmem, start, end);
+	kvm_gmem_invalidate_begin(mapping->host, start, end);
 
 	/*
 	 * Do not truncate the range, what action is taken in response to the
@@ -424,8 +449,7 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
 	 * error to userspace.
 	 */
 
-	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_end(gmem, start, end);
+	kvm_gmem_invalidate_end(mapping->host, start, end);
 
 	filemap_invalidate_unlock_shared(mapping);
 
-- 
2.51.0.618.g983fd99d29-goog



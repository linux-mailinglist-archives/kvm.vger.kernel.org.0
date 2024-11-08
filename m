Return-Path: <kvm+bounces-31300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B4E549C21F2
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:21:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D82C91C21303
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E39DE199FBF;
	Fri,  8 Nov 2024 16:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mNLFtrbU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C0919922F
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 16:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731082862; cv=none; b=IJukS/LWUCCL6iRToXDsCsxtDrqS84BOQAjInvJVoVxgOGw6oOX8llv0t+6JrjlvpRSpodzaZEo0Y3BL94MclRwtc/flRqOHliWn/2I9Qg9ILMtUhQI9F4FlphHWDgL6g/apcepqWFOexeq6up7mgZNkSG+WlzbiLa2g+LsYISM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731082862; c=relaxed/simple;
	bh=0CzrKZAjiGyTLtq31cuunQlobWkpgK5KVAaAiEa5a4o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hPxWxCi2o0a84x4Yp72N+SV7jl9mFOhK0qUXCs4eMot9tFexXrIMDIkEjq3ER7vHL2VZWppdyoDoU/tGjqF3kjUdJEfHG24CZevwFdvsTRB4GxLIZSNOvBa95P5JLqDkOdO+V05ZqBaTqwLha532w+2wEwPB5/U3b0axviKlWpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mNLFtrbU; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-37d5016d21eso1218046f8f.3
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 08:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731082858; x=1731687658; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z1UKVDyubm+0FNKQOmqAnK7wACyIXxMp06jV3hLqPe8=;
        b=mNLFtrbUiEjNHHmVzFdhnnZBxcAfHBXrJBhe3msSA5stgw/V/XBIy8FzWeVLYZgIZV
         fGu6MbkUyXnnZZajSTuTzi9Hcbn5K+Ela1iBsFQexv4FqHyszXDYgLbvYJ59/U/aK6tp
         kXrW0DmbAAKShJR3PwAgTXLEKp7xCkPSawUZJFVwk4CrlbusmbJakSsuVfPMdphVEta2
         W2Xb3+9Gtz1+Q9GwmryAygp/gVBwxt9sF3IDgpnRTbEbDRHn0rhOTc0QaA+NHJy2HJ28
         zeRVYMWaCfxXbwfTWJJSoV0rmS/mDuiLp+Ux9yfL2qiZqKyEGHGoL4E8lJsP4vsD7R4p
         9M3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731082858; x=1731687658;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z1UKVDyubm+0FNKQOmqAnK7wACyIXxMp06jV3hLqPe8=;
        b=bsjjj7Qp6UuIYUyIgFNHADqF7UUTKob0XKn+HMaBy1hozut1phhRMKPcl250LTigIh
         mGMcBWXsQfp6N0FrTfPvn2kdd1U2CsEKV5UdR/YqQWEE2Q7unug5RRH8SPyUWwjitVjr
         d4zm/5DxzDTPWARdJHJTNJf1UCnkXuIF6l1y1K0/iJZEsMCZoyBDEyGpjDwCFe1uMut/
         SmdKH6Z6BT1r9FQRxUu+/4iGUrkpbR1gF6jyavnfxXvY5OU6PPjiISv/9qadJXAz3itn
         jm9jwi2uk7BThomHB6hOdBDLvPUqhBDLLkred/0xf2vqjOgSofgOT0OViwSbRDzXBryn
         vU4Q==
X-Gm-Message-State: AOJu0YyCpYHEnoy1KcGEkzbBCHO5gGX7Nm9shyL7w3hXk7BnKTrUhnvK
	tzTIza6jAKmNe/tM0Nd+dt0FKbQDpcmtroexv2yXn3TrU6Ai+T+RnsUJuhAu4pS+FcsQWCqjiA=
	=
X-Google-Smtp-Source: AGHT+IHkZAD0auPV4emIDnQo0+EU0NmTafyVDODnqw54sbX8+2pfhiQ95jeQsPF/8IsVn+XR42DkmZua1Q==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:ffca:0:b0:37d:4cee:559 with SMTP id
 ffacd0b85a97d-381f1862148mr2432f8f.3.1731082858585; Fri, 08 Nov 2024 08:20:58
 -0800 (PST)
Date: Fri,  8 Nov 2024 16:20:37 +0000
In-Reply-To: <20241108162040.159038-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241108162040.159038-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241108162040.159038-8-tabba@google.com>
Subject: [RFC PATCH v1 07/10] mm: Introduce struct folio_owner_ops
From: Fuad Tabba <tabba@google.com>
To: linux-mm@kvack.org
Cc: kvm@vger.kernel.org, nouveau@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, david@redhat.com, rppt@kernel.org, 
	jglisse@redhat.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	simona@ffwll.ch, airlied@gmail.com, pbonzini@redhat.com, seanjc@google.com, 
	willy@infradead.org, jgg@nvidia.com, jhubbard@nvidia.com, 
	ackerleytng@google.com, vannapurve@google.com, mail@maciej.szmigiero.name, 
	kirill.shutemov@linux.intel.com, quic_eberman@quicinc.com, maz@kernel.org, 
	will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Introduce struct folio_owner_ops, a method table that contains
callbacks to owners of folios that need special handling for
certain operations. For now, it only contains a callback for
folio free(), which is called immediately after the folio
refcount drops to 0.

Add a pointer to this struct overlaid on struct page
compound_head, pgmap, and struct page/folio lru. The users of
this struct either will not use lru (e.g., zone device), or would
be able to easily isolate when lru is being used (e.g., hugetlb)
and handle it accordingly. While folios are isolated, they cannot
get freed and the owner_ops are unstable. This is sufficient for
the current use case of returning these folios to a custom
allocator.

To identify that a folio has owner_ops, we set bit 1 of the
field, in a similar way to that bit 0 of compound_head is used to
identify compound pages.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/mm_types.h | 64 +++++++++++++++++++++++++++++++++++++---
 mm/swap.c                | 19 ++++++++++++
 2 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 365c73be0bb4..6e06286f44f1 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -41,10 +41,12 @@ struct mem_cgroup;
  *
  * If you allocate the page using alloc_pages(), you can use some of the
  * space in struct page for your own purposes.  The five words in the main
- * union are available, except for bit 0 of the first word which must be
- * kept clear.  Many users use this word to store a pointer to an object
- * which is guaranteed to be aligned.  If you use the same storage as
- * page->mapping, you must restore it to NULL before freeing the page.
+ * union are available, except for bit 0 (used for compound_head pages)
+ * and bit 1 (used for owner_ops) of the first word, which must be kept
+ * clear and used with care.  Many users use this word to store a pointer
+ * to an object which is guaranteed to be aligned.  If you use the same
+ * storage as page->mapping, you must restore it to NULL before freeing
+ * the page.
  *
  * The mapcount field must not be used for own purposes.
  *
@@ -283,10 +285,16 @@ typedef struct {
 	unsigned long val;
 } swp_entry_t;
 
+struct folio_owner_ops;
+
 /**
  * struct folio - Represents a contiguous set of bytes.
  * @flags: Identical to the page flags.
  * @lru: Least Recently Used list; tracks how recently this folio was used.
+ * @owner_ops: Pointer to callback operations of the folio owner. Valid if bit 1
+ *    is set.
+ *    NOTE: Cannot be used with lru, since it is overlaid with it. To use lru,
+ *          owner_ops must be cleared first, and restored once done with lru.
  * @mlock_count: Number of times this folio has been pinned by mlock().
  * @mapping: The file this page belongs to, or refers to the anon_vma for
  *    anonymous memory.
@@ -330,6 +338,7 @@ struct folio {
 			unsigned long flags;
 			union {
 				struct list_head lru;
+				const struct folio_owner_ops *owner_ops; /* Bit 1 is set */
 	/* private: avoid cluttering the output */
 				struct {
 					void *__filler;
@@ -417,6 +426,7 @@ FOLIO_MATCH(flags, flags);
 FOLIO_MATCH(lru, lru);
 FOLIO_MATCH(mapping, mapping);
 FOLIO_MATCH(compound_head, lru);
+FOLIO_MATCH(compound_head, owner_ops);
 FOLIO_MATCH(index, index);
 FOLIO_MATCH(private, private);
 FOLIO_MATCH(_mapcount, _mapcount);
@@ -452,6 +462,13 @@ FOLIO_MATCH(flags, _flags_3);
 FOLIO_MATCH(compound_head, _head_3);
 #undef FOLIO_MATCH
 
+struct folio_owner_ops {
+	/*
+	 * Called once the folio refcount reaches 0.
+	 */
+	void (*free)(struct folio *folio);
+};
+
 /**
  * struct ptdesc -    Memory descriptor for page tables.
  * @__page_flags:     Same as page flags. Powerpc only.
@@ -560,6 +577,45 @@ static inline void *folio_get_private(struct folio *folio)
 	return folio->private;
 }
 
+/*
+ * Use bit 1, since bit 0 is used to indicate a compound page in compound_head,
+ * which owner_ops is overlaid with.
+ */
+#define FOLIO_OWNER_OPS_BIT    1UL
+#define FOLIO_OWNER_OPS        (1UL << FOLIO_OWNER_OPS_BIT)
+
+/*
+ * Set the folio owner_ops as well as bit 1 of the pointer to indicate that the
+ * folio has owner_ops.
+ */
+static inline void folio_set_owner_ops(struct folio *folio, const struct folio_owner_ops *owner_ops)
+{
+	owner_ops = (const struct folio_owner_ops *)((unsigned long)owner_ops | FOLIO_OWNER_OPS);
+	folio->owner_ops = owner_ops;
+}
+
+/*
+ * Clear the folio owner_ops including bit 1 of the pointer.
+ */
+static inline void folio_clear_owner_ops(struct folio *folio)
+{
+	folio->owner_ops = NULL;
+}
+
+/*
+ * Return the folio's owner_ops if it has them, otherwise, return NULL.
+ */
+static inline const struct folio_owner_ops *folio_get_owner_ops(struct folio *folio)
+{
+	const struct folio_owner_ops *owner_ops = folio->owner_ops;
+
+	if (!((unsigned long)owner_ops & FOLIO_OWNER_OPS))
+		return NULL;
+
+	owner_ops = (const struct folio_owner_ops *)((unsigned long)owner_ops & ~FOLIO_OWNER_OPS);
+	return owner_ops;
+}
+
 struct page_frag_cache {
 	void * va;
 #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
diff --git a/mm/swap.c b/mm/swap.c
index 638a3f001676..767ff6d8f47b 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -110,6 +110,13 @@ static void page_cache_release(struct folio *folio)
 
 void __folio_put(struct folio *folio)
 {
+	const struct folio_owner_ops *owner_ops = folio_get_owner_ops(folio);
+
+	if (unlikely(owner_ops)) {
+		owner_ops->free(folio);
+		return;
+	}
+
 	if (unlikely(folio_is_zone_device(folio))) {
 		free_zone_device_folio(folio);
 		return;
@@ -929,10 +936,22 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 	for (i = 0, j = 0; i < folios->nr; i++) {
 		struct folio *folio = folios->folios[i];
 		unsigned int nr_refs = refs ? refs[i] : 1;
+		const struct folio_owner_ops *owner_ops;
 
 		if (is_huge_zero_folio(folio))
 			continue;
 
+		owner_ops = folio_get_owner_ops(folio);
+		if (unlikely(owner_ops)) {
+			if (lruvec) {
+				unlock_page_lruvec_irqrestore(lruvec, flags);
+				lruvec = NULL;
+			}
+			if (folio_ref_sub_and_test(folio, nr_refs))
+				owner_ops->free(folio);
+			continue;
+		}
+
 		if (folio_is_zone_device(folio)) {
 			if (lruvec) {
 				unlock_page_lruvec_irqrestore(lruvec, flags);
-- 
2.47.0.277.g8800431eea-goog



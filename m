Return-Path: <kvm+bounces-37416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4751FA29D7C
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 00:19:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AB433A728B
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 23:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83BF821CFE8;
	Wed,  5 Feb 2025 23:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dBSvzIHU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BF821C9F4
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 23:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738797503; cv=none; b=WnMbugwBpSiXnvY2rSY+w2CNe+GtKeIypMdm6GyIV4TgosIuux2oSHNdMc9NMTBXWiuefBGpNuKVOssVt239L+tup4+17tFHMvkjZVg8wvER7sD3RiectjbBJ95oB/KAMLdWlFOw4ozkcy3R3pRhOdLdx8p5xOiPrAipZLng0G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738797503; c=relaxed/simple;
	bh=mkgLg5sls7QullkSGR+WNjErlAYFR3INSBiq+3o4Oks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VR1x14htQ7sZHunokcyhzkwQOzMZ3rHg62Es78UOVO7kHhEEHG0oXJ0u23fKifLAuMuev9j0PGCeuxihDSKGxsQRbLWGv8qLkceLi1eldiNP9385Qj7a+x5psw1WTRUHE5Iib+W9U+9wb3ewwMaZwcXPZl2Xhq2BwHgBuFBoAic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dBSvzIHU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738797500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8W4JP+Fju0ACXLthBx+3G3GONe8TLTlsBTTA1Q3RDZE=;
	b=dBSvzIHUvuuID8kMBdlA2Z9nkJ6J0dQzZakl/nSK7OiOJJqH3VvP/jqMTt/F0mTagqsmMh
	mW5VQXkIWTFCovKQHLsucKhof2tSpNEey1vu/IbYKRrzeurEeo/8StJzEdhMyzdgr5tMk3
	cXBN8RQAiA4orPTqTNnp2NdnaRE2Las=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-FkNDRqmMM9yE_UzeBVYLPQ-1; Wed,
 05 Feb 2025 18:18:17 -0500
X-MC-Unique: FkNDRqmMM9yE_UzeBVYLPQ-1
X-Mimecast-MFC-AGG-ID: FkNDRqmMM9yE_UzeBVYLPQ
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 871FF1800985;
	Wed,  5 Feb 2025 23:18:16 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.81.141])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9D68A1800570;
	Wed,  5 Feb 2025 23:18:14 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	peterx@redhat.com,
	mitchell.augustin@canonical.com,
	clg@redhat.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 4/5] mm: Provide page mask in struct follow_pfnmap_args
Date: Wed,  5 Feb 2025 16:17:20 -0700
Message-ID: <20250205231728.2527186-5-alex.williamson@redhat.com>
In-Reply-To: <20250205231728.2527186-1-alex.williamson@redhat.com>
References: <20250205231728.2527186-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

follow_pfnmap_start() walks the page table for a given address and
fills out the struct follow_pfnmap_args in pfnmap_args_setup().
The page mask of the page table level is already provided to this
latter function for calculating the pfn.  This page mask can also be
useful for the caller to determine the extent of the contiguous
mapping.

For example, vfio-pci now supports huge_fault for pfnmaps and is able
to insert pud and pmd mappings.  When we DMA map these pfnmaps, ex.
PCI MMIO BARs, we iterate follow_pfnmap_start() to get each pfn to test
for a contiguous pfn range.  Providing the mapping page mask allows us
to skip the extent of the mapping level.  Assuming a 1GB pud level and
4KB page size, iterations are reduced by a factor of 256K.  In wall
clock time, mapping a 32GB PCI BAR is reduced from ~1s to <1ms.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 include/linux/mm.h | 2 ++
 mm/memory.c        | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b1c3db9cf355..0ef7e7a0b4eb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2416,11 +2416,13 @@ struct follow_pfnmap_args {
 	 * Outputs:
 	 *
 	 * @pfn: the PFN of the address
+	 * @pgmask: page mask covering pfn
 	 * @pgprot: the pgprot_t of the mapping
 	 * @writable: whether the mapping is writable
 	 * @special: whether the mapping is a special mapping (real PFN maps)
 	 */
 	unsigned long pfn;
+	unsigned long pgmask;
 	pgprot_t pgprot;
 	bool writable;
 	bool special;
diff --git a/mm/memory.c b/mm/memory.c
index 398c031be9ba..97ccd43761b2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6388,6 +6388,7 @@ static inline void pfnmap_args_setup(struct follow_pfnmap_args *args,
 	args->lock = lock;
 	args->ptep = ptep;
 	args->pfn = pfn_base + ((args->address & ~addr_mask) >> PAGE_SHIFT);
+	args->pgmask = addr_mask;
 	args->pgprot = pgprot;
 	args->writable = writable;
 	args->special = special;
-- 
2.47.1



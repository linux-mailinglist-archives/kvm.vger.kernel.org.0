Return-Path: <kvm+bounces-14533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07E2A8A306E
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:22:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3780285912
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 14:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E70E8615F;
	Fri, 12 Apr 2024 14:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="af1XAyL1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8D58615C
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 14:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712931722; cv=none; b=OJYRjonAJ8WGdmMNoDW4k5jjAWRwIovxLWr15Q/RdXIcC9U9Wm00OKLPk+tHXum+GtM1fQQ+2lGXjaatR36z4Jg1sS2eiC8JXkWMwFvKed6WNx1bfndApFtO2tIG53HpFYRgwcb5OMNX4iD+H6CoHNW8/N1yZOHlNBj15hGlbPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712931722; c=relaxed/simple;
	bh=6fBfLn1F0T/o+E+4HUx46WIsuzu8qJCxEFjOoOqxYuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPCvyanFHsG6pZk10nc+PrRYd4hu68hjhUI45TAY69PmGwiRPesfPuNntsx/OQwWX2kcZ45JQY/bKh4nO/XNbDMW6JEp556S9mh2VE93lV6et6X/UF1KBiobqVrl3mLYAdPUSbrFb9tl83YdFXi7jeYV3Ge3TAUmLvk2PtGhfAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=af1XAyL1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712931720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UqesERZ4v5DDEN2i8HY7U82j76k04tcHkpQ5V/iITyc=;
	b=af1XAyL1JHLm490AYAEcjSZ1MRhRuoUfDSSyQ34V+Uq6JTrB1YJ4jkepmtKuTVPNdCz3Xx
	N30bMpDi9AqqMbduAH9FPO7rNiKchQnQxLV6xut7IiO/VaZ4Rhi8tXarYWBnqSGmjHzFvr
	xu0vQxYhdQKkOdmR/HJ8OQaK5jEXLo8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-3RdVJAd9MG2A_gljV7dFoA-1; Fri, 12 Apr 2024 10:21:57 -0400
X-MC-Unique: 3RdVJAd9MG2A_gljV7dFoA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 267DF1044572;
	Fri, 12 Apr 2024 14:21:56 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.193.165])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A38B940C6CBF;
	Fri, 12 Apr 2024 14:21:52 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Matthew Wilcox <willy@infradead.org>,
	Thomas Huth <thuth@redhat.com>
Subject: [PATCH v2 03/10] s390/uv: split large folios in gmap_make_secure()
Date: Fri, 12 Apr 2024 16:21:13 +0200
Message-ID: <20240412142120.220087-4-david@redhat.com>
In-Reply-To: <20240412142120.220087-1-david@redhat.com>
References: <20240412142120.220087-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

While s390x makes sure to never have PMD-mapped THP in processes that use
KVM -- by remapping them using PTEs in
thp_split_walk_pmd_entry()->split_huge_pmd() -- there is still the
possibility of having PTE-mapped THPs (large folios) mapped into guest
memory.

This would happen if user space allocates memory before calling
KVM_CREATE_VM (which would call s390_enable_sie()). With upstream QEMU,
this currently doesn't happen, because guest memory is setup and
condiitonally preallocated after KVM_CREATE_VM.

Could it happen with shmem/file-backed memory when another process
allocated memory in the pagecache? Likely, although currently not a
common setup.

Trying to split any PTE-mapped large folios sounds like the right and
future-proof thing to do here. So let's call split_folio() and handle the
return values accordingly.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/kernel/uv.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 25fe28d189df..3c6d86e3e828 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -338,11 +338,10 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 		goto out;
 	if (pte_present(*ptep) && !(pte_val(*ptep) & _PAGE_INVALID) && pte_write(*ptep)) {
 		folio = page_folio(pte_page(*ptep));
-		rc = -EINVAL;
-		if (folio_test_large(folio))
-			goto unlock;
 		rc = -EAGAIN;
-		if (folio_trylock(folio)) {
+		if (folio_test_large(folio)) {
+			rc = -E2BIG;
+		} else if (folio_trylock(folio)) {
 			if (should_export_before_import(uvcb, gmap->mm))
 				uv_convert_from_secure(PFN_PHYS(folio_pfn(folio)));
 			rc = make_folio_secure(folio, uvcb);
@@ -353,15 +352,35 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 		 * Once we drop the PTL, the folio may get unmapped and
 		 * freed immediately. We need a temporary reference.
 		 */
-		if (rc == -EAGAIN)
+		if (rc == -EAGAIN || rc == -E2BIG)
 			folio_get(folio);
 	}
-unlock:
 	pte_unmap_unlock(ptep, ptelock);
 out:
 	mmap_read_unlock(gmap->mm);
 
 	switch (rc) {
+	case -E2BIG:
+		folio_lock(folio);
+		rc = split_folio(folio);
+		folio_unlock(folio);
+		folio_put(folio);
+
+		switch (rc) {
+		case 0:
+			/* Splitting succeeded, try again immediately. */
+			goto again;
+		case -EAGAIN:
+			/* Additional folio references. */
+			if (drain_lru(&drain_lru_called))
+				goto again;
+			return -EAGAIN;
+		case -EBUSY:
+			/* Unexpected race. */
+			return -EAGAIN;
+		}
+		WARN_ON_ONCE(1);
+		return -ENXIO;
 	case -EAGAIN:
 		/*
 		 * If we are here because the UVC returned busy or partial
-- 
2.44.0



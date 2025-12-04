Return-Path: <kvm+bounces-65292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D6A8CA42B0
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 16:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B2DD53020151
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 15:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0F6D2DAFA4;
	Thu,  4 Dec 2025 15:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eoUsYMq5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nBYoZ53O"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443392D73A7
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 15:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764861014; cv=none; b=SCSpPthA2BCbNBMU5IcINc9R8FMgCGU3NAEzAKswSfWSfdGVaeDmo0nkpOvAAnDmN+EX+/Z1cheZxbGztfALQMV7IidgYVTgKiz5r9/tIZR7l6gnKdNuNocR0YjZZmBDVxhCW9q0b/SJT8Hzk/qa49poaPO1pW7z6GSmWwGQjZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764861014; c=relaxed/simple;
	bh=LzIu679OiSRplUOyBus7rxkVzujQbIAxT1+bCdZbvbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mm46pGlS7sFIwn0ZAVOwomXD+satZdEPgnIWYfDYIJkwghuo6oCBUjPpYS2KLTNj1M9mNlGRoslD/Ck1XVxIZ+1U3/bGMr8H6wgmUaByiK8CzZMYFLoOSQEQme/3PEvXgnOGwnsXxEgiTxtGqVhGLDgdpYNEqrZpddrDehJx72w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eoUsYMq5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nBYoZ53O; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764861011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sakCo68nQ8rcVde6IgWDv4cz9Y66spTur3aP7RQqpdI=;
	b=eoUsYMq5FMZ97wfB9nSl4ymGnTJfu+6858NfysvCJLKTNzoXn2PYnglIFLyixGnR+U/gYo
	x9uhqrkN6gKOcpOafW+0BboCDFVBheItuiyq78uAOnWIXuDZhq8ZbS0Rpdr+Y/MtGUTJBi
	yfc+jW+15LSV79tc9dSQUEkP90dEp5c=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-QBsTMwmrOTyBDBznW7mc8A-1; Thu, 04 Dec 2025 10:10:09 -0500
X-MC-Unique: QBsTMwmrOTyBDBznW7mc8A-1
X-Mimecast-MFC-AGG-ID: QBsTMwmrOTyBDBznW7mc8A_1764861009
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8b26bc4984bso379096485a.1
        for <kvm@vger.kernel.org>; Thu, 04 Dec 2025 07:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764861009; x=1765465809; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sakCo68nQ8rcVde6IgWDv4cz9Y66spTur3aP7RQqpdI=;
        b=nBYoZ53OI9D+n6WTEpUvJaS1+bP/a4FNup7tkOFV0yKm/k8W0nCa7vWfr5KaKistZB
         15mSEsvDRB09oSsxTi4aaMpHYK+vZkR2C5oGJZmrr8Dvq/2lRYeQEx92y1Ck1EIEClni
         3BYBXNs0/fgHpZDreyjnpcTVajO5NTQTz6RK8ZuxspoklQimjFyu8EkslMlsbJSZQ7JA
         yEM2/TNPWJCR4gS5WzJOHsNDD6o8NIVYVxoIRp8KMRy5xN74ElZAdvkpyhuvtvIAcwrE
         ID+a7GBLSflQ3MXxXk0Ql9d6mBjqJs+0gZno6aPtAlkbwTehs69qRVzp3U5Ks+61AnYL
         klzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764861009; x=1765465809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sakCo68nQ8rcVde6IgWDv4cz9Y66spTur3aP7RQqpdI=;
        b=tepf7Gh5cNQhsulRHexVQfb//Sm3qd52o6PCvNoprAlFHvWyTaajKtMqCyz4DJe5Gd
         S1xfXzU71QS+OAJEFgWyRn1dsd5S8Jz8DJSa/bE2vPqL5U+bh2Uv3VqU0YnPWm/TCSyb
         sYX3EuTAFufK6Y5Kv5bO1lRpwtoLR4chgQJwG5ylZSAZGzVClODZh2qWLTFK9dOmzOS3
         To7EytOQqzSRGFhdrs7NvSvbbCvO4S6cy3wbv/Kv1AJs4Un1lyR1NYHnkNq5aChgk1BD
         asZ8eMIPDhiiVXJWnhz5st4U/rXvouS9P66Ism1+TXA8wGqfQdVyeDL+AqIUvqolUfEt
         9O/A==
X-Gm-Message-State: AOJu0YzDyeUREwvyZ/MZ0+F5J45MBZ3qw9Z7Ep5PRWtUBSmuANCrPP2H
	FVhqBMR4UfTa1nkBiqLcOdpTV67FIa9qjxQpRZi27XvSuwTsidr8ZvuDc1bdIpJR8lPgcD/yQml
	jUIekxA2vm6u/oYMOJoPgjxgKuhK3SX6dSxAMyb5Ifvdxt7MtjtQiHB2exA8rgJD6wPWXbHtUSO
	A169gqZnUQzctID9CbauWrCHvMxT5nrZyXj3Y=
X-Gm-Gg: ASbGncvg4vtSpiI4CgmVfwaI2Ktw0ugAGDoJkEtSryOrBhaEgLOQO8u6KsBp309N6fh
	zg8u3BAUMTOBFKOtQIfvf+KtWgaZ3N8qpHAqelVgOrnpHZMz27wHDj6s2klHs1B2+eGPSKZJraP
	4EfklWjtB4AK+Clq9H6mbImtCPwnB5zlDYgMC/f3giJnc1cw4hLLGwnwv6WLLPZDUF2nKrU29Yo
	PfTCe+IiupCKeoVJ2kDOgZ9qa8QisXI2OUZfwPYjMq+Xxa7/lxbv5rCZLX1Z92EKwp5ThBV2yxl
	56U1aaePXC3UE2jKwKFiLPv6U3FTlf/mMEYlySWsleq2XjwahNANgoKIasOWLuX5uZfKYKnza7A
	A
X-Received: by 2002:a05:620a:414d:b0:84a:d3ce:c749 with SMTP id af79cd13be357-8b5e6f7aedcmr934171985a.64.1764861008731;
        Thu, 04 Dec 2025 07:10:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHDVl5FRV7K1/nE3AfLW2VTsm3DwP3EmQWe4gJ+Y9zdrDlKNoHx1ohilHm+3n6BN0372Ep4EA==
X-Received: by 2002:a05:620a:414d:b0:84a:d3ce:c749 with SMTP id af79cd13be357-8b5e6f7aedcmr934161985a.64.1764861008037;
        Thu, 04 Dec 2025 07:10:08 -0800 (PST)
Received: from x1.com ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b627a9fd23sm154263285a.46.2025.12.04.07.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 07:10:07 -0800 (PST)
From: Peter Xu <peterx@redhat.com>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	peterx@redhat.com,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 1/4] mm/thp: Allow thp_get_unmapped_area_vmflags() to take alignment
Date: Thu,  4 Dec 2025 10:10:00 -0500
Message-ID: <20251204151003.171039-2-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251204151003.171039-1-peterx@redhat.com>
References: <20251204151003.171039-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add "align" parameter to thp_get_unmapped_area_vmflags() so that it allows
get unmapped area with any alignment.

There're two existing callers, use PMD_SIZE explicitly for them.

No functional change intended.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/huge_mm.h | 5 +++--
 mm/huge_memory.c        | 7 ++++---
 mm/mmap.c               | 3 ++-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 71ac78b9f834f..1c221550362d7 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -362,7 +362,7 @@ unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags,
-		vm_flags_t vm_flags);
+		unsigned long align, vm_flags_t vm_flags);
 
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
 int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
@@ -559,7 +559,8 @@ static inline unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 static inline unsigned long
 thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
 			      unsigned long len, unsigned long pgoff,
-			      unsigned long flags, vm_flags_t vm_flags)
+			      unsigned long flags, unsigned long align,
+			      vm_flags_t vm_flags)
 {
 	return 0;
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6cba1cb14b23a..ab2450b985171 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1155,12 +1155,12 @@ static unsigned long __thp_get_unmapped_area(struct file *filp,
 
 unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags,
-		vm_flags_t vm_flags)
+		unsigned long align, vm_flags_t vm_flags)
 {
 	unsigned long ret;
 	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
 
-	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE, vm_flags);
+	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, align, vm_flags);
 	if (ret)
 		return ret;
 
@@ -1171,7 +1171,8 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags)
 {
-	return thp_get_unmapped_area_vmflags(filp, addr, len, pgoff, flags, 0);
+	return thp_get_unmapped_area_vmflags(filp, addr, len, pgoff, flags,
+					     PMD_SIZE, 0);
 }
 EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 5fd3b80fda1d5..8fa397a18252e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -846,7 +846,8 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		   && IS_ALIGNED(len, PMD_SIZE)) {
 		/* Ensures that larger anonymous mappings are THP aligned. */
 		addr = thp_get_unmapped_area_vmflags(file, addr, len,
-						     pgoff, flags, vm_flags);
+						     pgoff, flags, PMD_SIZE,
+						     vm_flags);
 	} else {
 		addr = mm_get_unmapped_area_vmflags(current->mm, file, addr, len,
 						    pgoff, flags, vm_flags);
-- 
2.50.1



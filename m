Return-Path: <kvm+bounces-31295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E6989C21ED
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:21:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62D18B2284A
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561111991B4;
	Fri,  8 Nov 2024 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ShGxO+vf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71C7198E79
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 16:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731082850; cv=none; b=h2EsLZHhTLU/3A8krCmORcluVPFe04uUYczNglFqeEkUqEHlV1vMqQr4aoFkn0R19w+kB5CxEGGyDWDCF8pJFLqkatCY4eyHuZ4b10pW1MHCw9Yfw6LLaqsTK5qNsE9odgxkXO09wqN/6TkUDRleJKPJ9VFJbFRyJ7815Ci0siw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731082850; c=relaxed/simple;
	bh=IVBBSwWW0KNtO1gvsYz3uY6Z0B8g8Q/OX1T0J6vziwE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P0VqxEdtWzJF4jjFrQpEZzkd/x5+RF3PuL6zT/fNMMidGezyy3ZFHgLNooTYUisg2ZecBft6RPAvCR8+tvK71TcwBILiRl69C8lSuBNgRPwgbQzaUq8bEbXo8NiGDCSx4BMqKfWlrweVEDX/+ecTLfNXeGvwfaFbzk854TYztA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ShGxO+vf; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4314f023f55so15932225e9.2
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 08:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731082847; x=1731687647; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YSD3xsyZZCSV87kyUY/RPMIHEZzslYpSJkMBD8vjd+E=;
        b=ShGxO+vfYWC5uTGZD8WOqyaes4rkhh93j8KH7/NfkkKfjsZErb9V1TfEM6DnFa8b6B
         YllGLJ0AN60POg1IUD/2cg/VNKrgqKizs00u6oz3oZVRCkhPT8r7XLCFpuLzWsYhaevw
         RPpcRQu+m/gR/yFDymtOxh0WL4s3rlOPa8n4eF6N2VmWTRB/sL9L9qKpPw4F7Qqb763O
         5VSnI0uFCbu+jCQSJDsKBNSeMbh3Q9R/x5dVrp9Zhd9O1KGOKmgSV/++UrW1PlXe6FUI
         GzPLt3LHLLqH8B+tAUTNNlbbJI2k72sY7gnppefnB3TdpDP2JPETsDN/7MSZg013RiS3
         U1QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731082847; x=1731687647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YSD3xsyZZCSV87kyUY/RPMIHEZzslYpSJkMBD8vjd+E=;
        b=ukG0zEMw0+cKca2SykXTJsy9fgz/fDoxGAkkx4cInOZsX5rWOD5+QBAHcaLXMUhpXr
         jhnKTIKWQpOkWGAXCnvSjenZKT6H10z0FqWaMRxAJUH+VZztEif9TuSs1maZtpVxU2Oy
         TocoUKxWhQVa1KQ3dRVwlRocUJ1h9lW4KrVTYNaaXjmCH8C9Q/Gy4MdaaUHWfrVmmwU/
         Bf/oevOJYPzfVvx3YeipEMp5X23/jbgEKhTjzpeMeZD+x8v3LE35Pn9IZNVetFfilTaG
         UOSTshKoKrOhvPK+ZT0QMrlt+E1Wq2xAIFM7LoztxqrDoCAdVkd5N0H6PtxD9ovxTSPY
         jQnA==
X-Gm-Message-State: AOJu0YwaVEuX2dc8sWBfxMSyt8jRECYFw+/W4TxQywZpZV2NVuiFhuNU
	VichIWWiNZ8MYCwNMytTWT1hjiJ86URewlPr++ED5W/nURO7H96JZ10QAVi8rqoyo/yUgKULVQ=
	=
X-Google-Smtp-Source: AGHT+IFgJCvqHUnZF2sVggmAky7vOXqPzIu1h0GscO2JqqplWhQ8XkVaucC9oHlByVAHMi0UBju5RAkHJw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:6a84:b0:42c:a8b5:c26 with SMTP id
 5b1f17b1804b1-432b74fc1e5mr108415e9.2.1731082847148; Fri, 08 Nov 2024
 08:20:47 -0800 (PST)
Date: Fri,  8 Nov 2024 16:20:32 +0000
In-Reply-To: <20241108162040.159038-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241108162040.159038-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241108162040.159038-3-tabba@google.com>
Subject: [RFC PATCH v1 02/10] mm/migrate: don't call folio_putback_active_hugetlb()
 on dst hugetlb folio
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

From: David Hildenbrand <david@redhat.com>

We replaced a simple put_page() by a putback_active_hugepage() call in
commit 3aaa76e125c1 (" mm: migrate: hugetlb: putback destination hugepage
to active list"), to set the "active" flag on the dst hugetlb folio.

Nowadays, we decoupled the "active" list from the flag, by calling the
flag "migratable".

Calling "putback" on something that wasn't allocated is weird and not
future proof, especially if we might reach that path when migration failed
and we just want to free the freshly allocated hugetlb folio.

Let's simply set the "migratable" flag in move_hugetlb_state(), where we
know that allocation succeeded, and use simple folio_put() to return
our reference.

Do we need the hugetlb_lock for setting that flag? Staring at other
users of folio_set_hugetlb_migratable(), it does not look like it. After
all, the dst folio should already be on the active list, and we are not
modifying that list.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 mm/hugetlb.c | 5 +++++
 mm/migrate.c | 8 ++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e17bb2847572..da3fe1840ab8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7508,6 +7508,11 @@ void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int re
 		}
 		spin_unlock_irq(&hugetlb_lock);
 	}
+	/*
+	 * Our old folio is isolated and has "migratable" cleared until it
+	 * is putback. As migration succeeded, set the new folio "migratable".
+	 */
+	folio_set_hugetlb_migratable(new_folio);
 }
 
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
diff --git a/mm/migrate.c b/mm/migrate.c
index 55585b5f57ec..b129dc41c140 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1547,14 +1547,14 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 		list_move_tail(&src->lru, ret);
 
 	/*
-	 * If migration was not successful and there's a freeing callback, use
-	 * it.  Otherwise, put_page() will drop the reference grabbed during
-	 * isolation.
+	 * If migration was not successful and there's a freeing callback,
+	 * return the folio to that special allocator. Otherwise, simply drop
+	 * our additional reference.
 	 */
 	if (put_new_folio)
 		put_new_folio(dst, private);
 	else
-		folio_putback_active_hugetlb(dst);
+		folio_put(dst);
 
 	return rc;
 }
-- 
2.47.0.277.g8800431eea-goog



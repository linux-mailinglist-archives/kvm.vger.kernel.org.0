Return-Path: <kvm+bounces-49656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B503ADC02E
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 06:19:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B60A173ADA
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 04:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72B9A23B62E;
	Tue, 17 Jun 2025 04:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="cxmUiqBG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B34222154D
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 04:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750133941; cv=none; b=Jbeb+s9QZ5asrue2WRfYNGfhbhKI8Xymen9HNNTOqbvImUUv58QEjwAsYgGJmxTvOA7oqXf9nyecfwqhuJqCPy9kUAkA9fQPOX/GgEA6yiYvJnsb4kCi6jJjM9kfwPqXAelj7MKDecBBAzWQM1QZTrvKBOv373nfVl0HGFw1o5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750133941; c=relaxed/simple;
	bh=H1CADXj3QfLh4ujbp1T9SA8yJlYktXA0W6UdRqEgSoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJIYvI688KeLwJKOeyJK/vpByoBGYBFcZO2V4dWDazGsRi3WCbTt2pKGlgs77Ok5VfBL7q1u4NUrZQad5lOfRvTQIR92E4z+EqKl0ZIXpjncS7dNIaOUdNoLJlNUpovZs+UJqG7cX+e7VuJhhq6ByXrmFslF6GnSRV+JAOIerIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=cxmUiqBG; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-236377f00a1so45232555ad.3
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 21:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750133938; x=1750738738; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w56CkoZmOBP7eVY7ps5X3d048z5btToxOlcYqOG+Pe4=;
        b=cxmUiqBG/Od/ZGKoO8Rqlnn0FUp4lbZh2eGFovNfs+b44u8aZ34wdChcxsn7WuQETQ
         KzsJL2SGFn9D1YD0NYiL3K884tbWiMXfxawotMY+Nscf9CbIreGeU9lUjd+X4z6Bff+l
         vSI7AzdSI+kEaqgoius3bXk/YMnIlCkws/02UsoxvKoFbwTtEaeKRdWSr2QkItcyXTCo
         Pi85vVOqoPA9bIGPH2f8ykGaqDnBG/PW8VpNgPctGfsEC7u4lZFaB0Q8f2CJhyIQRscm
         jNTo7IBzjSDyhTNiyt+SHiM1O2CErOxdCmBQr311UHE0qofBM9905fJ44AOADRmofX1W
         TcBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750133938; x=1750738738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w56CkoZmOBP7eVY7ps5X3d048z5btToxOlcYqOG+Pe4=;
        b=lshI1+ZEj3PhOUDREVGeJX/xBSZskdNgASdPAtDn2c0ORM2P337kaoT7No2/sCYuob
         aCguCByA7JTS8fItLFMucuO0LtBbs7O7X9Fj0i6oRHBfAJwb+3CbayfNH0dFT3hGDEYT
         E1Hy+ussLC5x4QxjRIwwh9yEdByMXx+NBDvxJ/gKKfShIOgGot4MlYETkTK0XS7fHWmi
         A/9/dnWeO78dMHD9QpDn0xLYJO/JXJjfO4iq3xCMIrEQnfQgzuFncmZqldrhFMA5eOOx
         L13BWF4o6o3MAiM4rSeJ6MFDeuTRc3C618L/MYrE+NUEHymX3EaGwtpXW6F8+h7t4ESd
         rmXg==
X-Gm-Message-State: AOJu0YwgxWQmF+ICpmLFKpCPFD5lVgr1ojlhOknEr6JrxRkhAOehBoOQ
	geIMwSO7IdKNmH/WrdJyr5h/FvNkKJZo8jDa2DICCXGHpWsl9lQXcq24oDle8KKuXhU=
X-Gm-Gg: ASbGncuP62+16sRvLiC+lO5evw/2+plclxVSnSKlpve70CRIANybB2KFR1OrINmhnmM
	CgY8M8nlV/Pf8LkTdFHzfELMPDyN4T5maRBNSnGojIKscVqJh8O/OrKwIQ0JUnzz4K7gd1ukrEE
	o63H/p1+wzT4cN43XqFmiFRsr4oBNB+3HWuCUeVDnNZ9l3/TPwZ4IlEpC4FzXSqTvYLFIkDSWCC
	9FI4VDTIpkMANfUGRVm8Qxhzt8gC455mOACgi1vD1ThM929cVYWrG7KPR9lAMDNP3EjPceZmyTQ
	Lmpkx2F0Cd+uyCYbnaDsFmWCZ3cvGtR4W5VjvzZKg+kLeRLGwJCwPNuzeKxZplZg0lk8lJVw27g
	zQ3QpQPdh+MlMVg==
X-Google-Smtp-Source: AGHT+IG96Kfj3jnMCouOQtJaFnWQzQIm60pETT4IyUybRMTMZVSaQLyo4ZaTsJAfjEoT+giwIio3Nw==
X-Received: by 2002:a17:903:24f:b0:234:bca7:292e with SMTP id d9443c01a7336-2366afe6223mr187956125ad.14.1750133937768;
        Mon, 16 Jun 2025 21:18:57 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365d88c029sm69798345ad.26.2025.06.16.21.18.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 16 Jun 2025 21:18:57 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	peterx@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com
Subject: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
Date: Tue, 17 Jun 2025 12:18:20 +0800
Message-ID: <20250617041821.85555-3-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250617041821.85555-1-lizhe.67@bytedance.com>
References: <20250617041821.85555-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

Introduce a new interface, unpin_user_folio_dirty_locked(). This
interface is similar to unpin_user_folio(), but it adds the
capability to conditionally mark a folio as dirty. VFIO will utilize
this interface to accelerate the VFIO DMA unmap process.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 include/linux/mm.h |  2 ++
 mm/gup.c           | 27 +++++++++++++++++++++------
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index fdda6b16263b..242b05671502 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1689,6 +1689,8 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
 				      bool make_dirty);
 void unpin_user_pages(struct page **pages, unsigned long npages);
 void unpin_user_folio(struct folio *folio, unsigned long npages);
+void unpin_user_folio_dirty_locked(struct folio *folio,
+		unsigned long npins, bool make_dirty);
 void unpin_folios(struct folio **folios, unsigned long nfolios);
 
 static inline bool is_cow_mapping(vm_flags_t flags)
diff --git a/mm/gup.c b/mm/gup.c
index 84461d384ae2..15debead5f5b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -360,12 +360,7 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
 
 	for (i = 0; i < npages; i += nr) {
 		folio = gup_folio_range_next(page, npages, i, &nr);
-		if (make_dirty && !folio_test_dirty(folio)) {
-			folio_lock(folio);
-			folio_mark_dirty(folio);
-			folio_unlock(folio);
-		}
-		gup_put_folio(folio, nr, FOLL_PIN);
+		unpin_user_folio_dirty_locked(folio, nr, make_dirty);
 	}
 }
 EXPORT_SYMBOL(unpin_user_page_range_dirty_lock);
@@ -435,6 +430,26 @@ void unpin_user_folio(struct folio *folio, unsigned long npages)
 }
 EXPORT_SYMBOL(unpin_user_folio);
 
+/**
+ * unpin_user_folio_dirty_locked() - conditionally mark a folio
+ * dirty and unpin it
+ *
+ * @folio:  pointer to folio to be released
+ * @npins:  number of pins
+ * @make_dirty: whether to mark the folio dirty
+ *
+ * Mark the folio as being modified if @make_dirty is true. Then
+ * release npins of the folio.
+ */
+void unpin_user_folio_dirty_locked(struct folio *folio,
+		unsigned long npins, bool make_dirty)
+{
+	if (make_dirty && !folio_test_dirty(folio))
+		folio_mark_dirty_lock(folio);
+	gup_put_folio(folio, npins, FOLL_PIN);
+}
+EXPORT_SYMBOL_GPL(unpin_user_folio_dirty_locked);
+
 /**
  * unpin_folios() - release an array of gup-pinned folios.
  * @folios:  array of folios to be marked dirty and released.
-- 
2.20.1



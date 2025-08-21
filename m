Return-Path: <kvm+bounces-55353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ACD96B3042F
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:14:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1539158008D
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 206EB2FC013;
	Thu, 21 Aug 2025 20:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EefwOLeJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563E62C028E
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 20:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806854; cv=none; b=tu/XVdsFjWjNLzdUhI2TOxEOgtqOfxRD17efP58ftMZicgGvmadM2VznJHgzpeeSNIERztNT/ws3Fpiea8xSr0UxxitipojNkiqSLnfGPP5yo8FtBRw+Us9rd7DSwtNQp4ppNVTz12CskOv/6SnUqg3PMqWeCU35rmYTraSqytE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806854; c=relaxed/simple;
	bh=s79Oeg502W4xdw3NRVnr9AKhHVyvkgzn8FY1ksnzdKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzuOQ82Y52KspX4++VVYaHe+69jfyWYVh81RI7w/gY4IPaxsVrM97K7d9nvRjvSpHXJlTjVrzchAW6GDOXz5ug0TWaEkABzEoLYpRBNgQZv7S4YBDVH9/v9F5iFj/SBBhQJRJmts/wHfFxnq9MPybfmsK/rFGJXX0PLb0STFSik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EefwOLeJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A9Znt0atqEjtEUkbTSfKRsvBJ9rEcbnqI7Kn1XkJSrA=;
	b=EefwOLeJaYEE4YIyOWMP6dZRF088fTzPpqOG1vMgx+x7xiXsIWh4xSLoaETXnH+BpEcZ28
	F0i/V+du33A1+3kFZCHikhjo/rtqdF0gd0aKKKaTfpbdkwsyYdxGPB3UUavDV80w4ZXek+
	GvzM9O44NLiF7XgF1oJLrUdahYnxebU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-6CwokzH0Poyynfi20ewbWw-1; Thu, 21 Aug 2025 16:07:28 -0400
X-MC-Unique: 6CwokzH0Poyynfi20ewbWw-1
X-Mimecast-MFC-AGG-ID: 6CwokzH0Poyynfi20ewbWw_1755806847
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0b2b5cso10135925e9.2
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 13:07:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806847; x=1756411647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A9Znt0atqEjtEUkbTSfKRsvBJ9rEcbnqI7Kn1XkJSrA=;
        b=EBOrAdusMuvb/dbj7xkmFU5U23gIzNIOan9sgjHdFgFXUXg6/m5wKCj8CCsaOtaLKP
         OmtS/oIvauG9BnFX1TtAwaUzzrU5ZKZm7IZyH6t44cMTarXtBIH9cUXlaOK097xO9MNx
         zVvDY81/z8e//35Ua2Ztp1JUkU1inMxt2oOyfd5S2AYSBcIj7Y+OCcfOptutF3lJHkOo
         DksXAduMKptPYobtRGiAn1QkTRlSzs1o9Knhl9zefV/DGl8ID39d9z4VZwLk9sjDPbDl
         lgh6G46ueGlGQhUiQ2HkuQrNIqgyvRFFDBVSUvC3ZBW6VwXnOjHjyS2dlZffPKuqSjiZ
         Xu1g==
X-Forwarded-Encrypted: i=1; AJvYcCVDIC4PUiJx5gc1nJ/xAPTQJTMhuLjQWjFk3Aft051/VkLieyCNETQcWiylPsv5xT4L420=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpojAw6bSo+LzhFw2tx2IccxmTqnxR4pLUKlW4tWeF0/c701U5
	TruPd4QUkWbz9osGUCwdhvox1DVvJHfbO3dy/tgs01C3Ki+sjHM7jD22SYgnFcFZq2MwPo6I3CF
	TvKbtsTVzW0HI1pUAprNVpSuILLeQYDE3WapxKBIKvaeyemLJiEKnuA==
X-Gm-Gg: ASbGncu44cy6ajGzEFgydhm3e+vIy1DXVIyZp9ujoQ0+GSisRosa1qmqxMMqxvqyHho
	Y8Q8zhvcPycz7jiwGaxExzCjbW8ZOQtrFoI4m0bNv8sctAt5PesQvciC2KuqxExWfU0LOG/PcyY
	8b2Ej6MJ9iLU5/fA45qFlLQ3237gG4ZzNg93QBqd32HLpY7AKfl96fyROJJeLKERtAQT632pwLZ
	lG9dz+02x0HSxG5+7hJ5jvhhI6v1Ler9NOUfv9dwc/svjPJQrZlAPZAlkXpR/rKKt7oSlPgeIJk
	pPUcusmekZ0kFViqI5mS4XBx93xpItG6iTp60QX1PsX7eaON3bszg6FHBC7I6J/C0miShcOngoL
	bkFiIe7Aeb+qi4G5cPD0szA==
X-Received: by 2002:a05:600c:3552:b0:459:dde3:1a33 with SMTP id 5b1f17b1804b1-45b517d26d4mr2922155e9.26.1755806847217;
        Thu, 21 Aug 2025 13:07:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUeapMM5JkcwJNJXC+LM6ICHu4lGUEF2ir46AAuHXhYXAFzTcPIdec/q/lplZD/isU7mGEgg==
X-Received: by 2002:a05:600c:3552:b0:459:dde3:1a33 with SMTP id 5b1f17b1804b1-45b517d26d4mr2921795e9.26.1755806846742;
        Thu, 21 Aug 2025 13:07:26 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50d62991sm9535385e9.0.2025.08.21.13.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:26 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 07/35] mm/memremap: reject unreasonable folio/compound page sizes in memremap_pages()
Date: Thu, 21 Aug 2025 22:06:33 +0200
Message-ID: <20250821200701.1329277-8-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let's reject unreasonable folio sizes early, where we can still fail.
We'll add sanity checks to prepare_compound_head/prepare_compound_page
next.

Is there a way to configure a system such that unreasonable folio sizes
would be possible? It would already be rather questionable.

If so, we'd probably want to bail out earlier, where we can avoid a
WARN and just report a proper error message that indicates where
something went wrong such that we messed up.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/memremap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memremap.c b/mm/memremap.c
index b0ce0d8254bd8..a2d4bb88f64b6 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -275,6 +275,9 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 
 	if (WARN_ONCE(!nr_range, "nr_range must be specified\n"))
 		return ERR_PTR(-EINVAL);
+	if (WARN_ONCE(pgmap->vmemmap_shift > MAX_FOLIO_ORDER,
+		      "requested folio size unsupported\n"))
+		return ERR_PTR(-EINVAL);
 
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
-- 
2.50.1



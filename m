Return-Path: <kvm+bounces-55376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B860AB30537
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:27:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 038391CE7F41
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B0D37F204;
	Thu, 21 Aug 2025 20:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZPTZ1a7y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543E237E8E8
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 20:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806921; cv=none; b=a6fLADTJnukNbV37OIgLI33mPAp1r1pfpKxTzZOXZ/tOfP6BpdgK5pEXkNbyHlWva4DZNbSUy6YfoCkwM1peOvtzNXaztbrM/kRkmuOjo9LUw9DIPBCbbPIfY/XC4Ibv3qp8N3FYKRwS6NaHtlyJ1U81gIl1PkCv0VjO0sePYRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806921; c=relaxed/simple;
	bh=I4BkP0poqeOVnf4Ccw0GJyYkhfaxRMDSlYagPRdC1UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTuB3PBeYcBKM9ssiKzkX5n7SnbKdodxDGpeedk4k2zuUWh/5bkOA4FaAv40ehAQmXJMzphyC6hz+CYgOqws7bkajVcHsyxo6lhbkyQuWlWDp0JekaBOi515hWqqj/DAhlFeq8nlYz7qJhIu6wzyCzIKt3a/MqHHV7mHDVViyOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZPTZ1a7y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3CqHI+s+zbpAzQhGC/xWDVPQsQNUZt86Ikrf9EwImgM=;
	b=ZPTZ1a7yBN7KvuzGfvzjt4ms5jvmv7IqzrkeqD7qIbQchOr5sViG0dxt5Bgy8+T7fuNLpu
	30OKGZioliSDOiRpRsLP3J4V6OrJgVUscGgB9x8PCCutwuNXueQXhL915WHJh97EWdN/V3
	+aK5J8gx+BYPrFfNfady8GCHJGkkCH4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-JEy_bnEbNs296g8-hN5idw-1; Thu, 21 Aug 2025 16:08:36 -0400
X-MC-Unique: JEy_bnEbNs296g8-hN5idw-1
X-Mimecast-MFC-AGG-ID: JEy_bnEbNs296g8-hN5idw_1755806915
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b05b15eso10525445e9.1
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 13:08:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806915; x=1756411715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3CqHI+s+zbpAzQhGC/xWDVPQsQNUZt86Ikrf9EwImgM=;
        b=LlFkbKrGOGgTiliNCy/+H2V5QBlJzMIdu/SixZIb/aWkyAFmqgj7R40KEbPxMfmsQn
         T5ywPa98DSAnK8QwgumCOKFWeCVJhSvuU1k0EdHYqBuLzRSgQqAHlE3f1UUXHNQEYq8G
         8uj0syzAnqICirsnbOTHGXGM/3tr13scX0R4qd3e5X4z2+AgwwYs5CKVXWJOACY6rplD
         EDIesYrQoYi/x8djfTAJSYq0MeM6ferDLH1U2DPpFYIiAHJLIH0eFuH5VlYW71Q3IxGT
         tAkDJhLvFwsCvqkbgd3NRKi4R8SQCq++1+W9a3CnYAu0i2xQ0N12jhVYBgka088zxI5g
         5Zkg==
X-Forwarded-Encrypted: i=1; AJvYcCW46o6DPiBRpTbaY9Ea/dfUVktnKV6PtGbPsaSnGjD3ti49AQIpjCrQvBSjzQSAQadxRWE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3b1XUjN3PKuTYCRmcSZWq2Q4L3mWJkQo4AP6mAnNXDjgIAdZ3
	zojD6rJ+aUB16A56ykuahZrHTLD2HKe6OG5xUfQqVPNKacw0Cwv8YAbRRSR9YnA1rok1vhiMyky
	VkQAX8a+tXjf5w/DZPmjYV+357AJ7139339jQcdYmXU23MqjgFTiWjQ==
X-Gm-Gg: ASbGncswKd10vViP/8BuQGW65pm0q25PT8g27W42WVCy2ydt7ALqRKCV11T2pWpsaIG
	OGNJX+gg8BgXdIlOsNl17C41tZmtozF2T0LBkwpvEfnYq2SiB9/zr5W49YXevIQuU3mLH56Dbiv
	C8VQG/ZySHJEPIWdALSOV/s3Q8NHnEULD8NuF8qckYroWi+xxLLgKLJQFbX930nDu8XQuIELlMi
	FcVo8DPCm23FoWGqec/+SaKNpPrUQ2XmPe6jiByQbu5kTgMovdsfExgArKj+e8t8Mp07zghrmeO
	3XyxZSAX+YeTVM26Qlw8QNbPzKTGMqVNNIRxj0+IqVBJZSg1L4ZacV4YG4K9994Lu+wVekIKfK3
	4LpboVzw1onzC7FGB90OLgw==
X-Received: by 2002:a05:600c:1e85:b0:456:1006:5418 with SMTP id 5b1f17b1804b1-45b5179f0d8mr2710865e9.13.1755806915052;
        Thu, 21 Aug 2025 13:08:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNGUbCcltH4em232KOd7NJpwM5baGf2Rerwczj+dvqvR7jiogPR9NbFTOrLGPDkQDJL8nGzQ==
X-Received: by 2002:a05:600c:1e85:b0:456:1006:5418 with SMTP id 5b1f17b1804b1-45b5179f0d8mr2710565e9.13.1755806914568;
        Thu, 21 Aug 2025 13:08:34 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c074d43b9asm12707153f8f.24.2025.08.21.13.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:34 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
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
Subject: [PATCH RFC 31/35] crypto: remove nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:57 +0200
Message-ID: <20250821200701.1329277-32-david@redhat.com>
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

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 crypto/ahash.c               | 4 ++--
 crypto/scompress.c           | 8 ++++----
 include/crypto/scatterwalk.h | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index a227793d2c5b5..a9f757224a223 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -88,7 +88,7 @@ static int hash_walk_new_entry(struct crypto_hash_walk *walk)
 
 	sg = walk->sg;
 	walk->offset = sg->offset;
-	walk->pg = nth_page(sg_page(walk->sg), (walk->offset >> PAGE_SHIFT));
+	walk->pg = sg_page(walk->sg) + walk->offset / PAGE_SIZE;
 	walk->offset = offset_in_page(walk->offset);
 	walk->entrylen = sg->length;
 
@@ -226,7 +226,7 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 	if (!IS_ENABLED(CONFIG_HIGHMEM))
 		return crypto_shash_digest(desc, data, nbytes, req->result);
 
-	page = nth_page(page, offset >> PAGE_SHIFT);
+	page += offset / PAGE_SIZE;
 	offset = offset_in_page(offset);
 
 	if (nbytes > (unsigned int)PAGE_SIZE - offset)
diff --git a/crypto/scompress.c b/crypto/scompress.c
index c651e7f2197a9..1a7ed8ae65b07 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -198,7 +198,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 		} else
 			return -ENOSYS;
 
-		dpage = nth_page(dpage, doff / PAGE_SIZE);
+		dpage += doff / PAGE_SIZE;
 		doff = offset_in_page(doff);
 
 		n = (dlen - 1) / PAGE_SIZE;
@@ -220,12 +220,12 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 			} else
 				break;
 
-			spage = nth_page(spage, soff / PAGE_SIZE);
+			spage = spage + soff / PAGE_SIZE;
 			soff = offset_in_page(soff);
 
 			n = (slen - 1) / PAGE_SIZE;
 			n += (offset_in_page(slen - 1) + soff) / PAGE_SIZE;
-			if (PageHighMem(nth_page(spage, n)) &&
+			if (PageHighMem(spage + n) &&
 			    size_add(soff, slen) > PAGE_SIZE)
 				break;
 			src = kmap_local_page(spage) + soff;
@@ -270,7 +270,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 			if (dlen <= PAGE_SIZE)
 				break;
 			dlen -= PAGE_SIZE;
-			dpage = nth_page(dpage, 1);
+			dpage++;
 		}
 	}
 
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 15ab743f68c8f..cdf8497d19d27 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -159,7 +159,7 @@ static inline void scatterwalk_map(struct scatter_walk *walk)
 	if (IS_ENABLED(CONFIG_HIGHMEM)) {
 		struct page *page;
 
-		page = nth_page(base_page, offset >> PAGE_SHIFT);
+		page = base_page + offset / PAGE_SIZE;
 		offset = offset_in_page(offset);
 		addr = kmap_local_page(page) + offset;
 	} else {
@@ -259,7 +259,7 @@ static inline void scatterwalk_done_dst(struct scatter_walk *walk,
 		end += (offset_in_page(offset) + offset_in_page(nbytes) +
 			PAGE_SIZE - 1) >> PAGE_SHIFT;
 		for (i = start; i < end; i++)
-			flush_dcache_page(nth_page(base_page, i));
+			flush_dcache_page(base_page + i);
 	}
 	scatterwalk_advance(walk, nbytes);
 }
-- 
2.50.1



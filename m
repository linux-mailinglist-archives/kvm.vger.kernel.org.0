Return-Path: <kvm+bounces-55380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59005B30577
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:30:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0261A034F0
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:25:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A25D381032;
	Thu, 21 Aug 2025 20:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gfRnDWql"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3DB37FBF4
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 20:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806928; cv=none; b=T1BqkbbDr6eBCm2nw1oEiwATeo8a7rm4lTdOC/cDXe0B7CE79k+ZZ2idj2YYKTElqeok0Z+7j3rAd0y0VvxYofbZS191rq3L0cToQIS/TPj33wg1PHsRJfmJLd32FfNeqMz/mpR6VSim1lLmp3JgdjdLp/3Tz05TICLLQdzwU0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806928; c=relaxed/simple;
	bh=izYuZWtM9expuJ4aw1W3JEFW5k9djBINp3Pti4HydYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQEDw5O4ma4QLkU6aDAp/ByHsmRdb5F5VdqTI3cnC9IpE+dP4NNwPm0XpWuCOL6ePK6YMkBN/IRNGpomTm720l7tTB5CNG1IAlBa5taUXiGpxd7NbxapbNN4TwImLNV41S5LO2JqtlHA5PDXXZ3o/SY57UZpudWP9D1qmTJOTEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gfRnDWql; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z7iPpUiW3LrFM0W3XrB+Z82uodwKTsefoCzXwhLbLUo=;
	b=gfRnDWqleQo/tZ4QAtrPQMKR/aUg3yes98cmHPGjoTSRneXIVL//IQrG0SWTbax/+5Iz/9
	ozw1hgbIbhMaJIcm3hzSqiWVfzGZ7WLufLzSMczJFDkBKFPEMw5zlWpb1ZFHB2I2YPlnlr
	vg9CY6UzsMjU9WGLhao23urW1yfcuAI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-z3R8NvMkN0G1xOwwIw4dZA-1; Thu, 21 Aug 2025 16:08:44 -0400
X-MC-Unique: z3R8NvMkN0G1xOwwIw4dZA-1
X-Mimecast-MFC-AGG-ID: z3R8NvMkN0G1xOwwIw4dZA_1755806923
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b9edf80ddcso517665f8f.3
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 13:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806923; x=1756411723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z7iPpUiW3LrFM0W3XrB+Z82uodwKTsefoCzXwhLbLUo=;
        b=NtXilkFn5x9dh+EBhDa5nEc3FNs7SjwR1mH8BDKtKkfAYBafhPCoCO8H3Y55dLpea6
         PR24jidzgsTS+bopOFzhAjuAi+mSKsnme4S0pvIAeMSY/t4+N+FPHJd1DAOaW7VI/5D2
         +Hdh7xaKuW8XOuHZo9eH3DZh7WKKT8z5K1vMfp5DnIqXUeh0k6s/+zkPv/XTTMykN1zm
         CSqp6w+w8J7jRj/3NZVmMBmn1cY4UwIxmowhPPS5doDVyoBQeRYVGHULWptZh4l3UhL2
         jrhtHqNcpVmBJlLoKUWHIR6jyDW6bsXSlofu+tbhz9/OQx3AGUAfuTtbFh2TvVE/nJRr
         ImqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJ3Gr9bDAZH0Ayd72zHNef1R0goAzrOQUNISMiTw7KfpYF02IRqOAu/t9OAy12Lx51y38=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyG6wAkxl6kg4wVRKaH2hc1lYSuURM0KjwioNAk3EdycBUvzRU
	fcKlIfUh9LzRTyEu85WZvCS93HZDvdZR3z6+m1HJCdrYZjwOXphMCzD4kG/lQ9gUrS/1msk1u5W
	rHt+sUEGVfJuTnavSN4OVcLtP/3cFyn7krdCxPRUvC0I4Ic6upZpCyJ0FxCkjjnhL
X-Gm-Gg: ASbGncvvnu6X8mfGZrefqKVKSvjeiKdbwgvVZHTW5l0HeVs1S1w2spWLhMhpz1kiwnw
	prhqsFuW13RxIW3WRgBhZQOcPuuHN5q6QsqxUpiOGQGQM01/BZOVc/UuV1TVx4ZJ9bWL+g6v2A8
	CQkieLkQ967LSNpwAQaV1/PmpdCpXCmvyblwv7kOP5jdpLMP0bNcw4BN7FAKl2T6AZ9HGe+Kid9
	UxWpt8kfeDviHc/0fEYeG9924zM/Oc0o8gnDszxPewPEdCUKroBat57LXeX7MaCiTJrkAgZwmhX
	NUf4UCOpPYL8OPdy02dTy1aWcPo0soF3PlDeKVESeuYYs93ETTfebAV6f2iv9zPHpQccKMflB8a
	zXHs6r65wqziiLzKWY8f51Q==
X-Received: by 2002:a5d:64ed:0:b0:3b5:dafc:1525 with SMTP id ffacd0b85a97d-3c5dc7313famr204677f8f.33.1755806922950;
        Thu, 21 Aug 2025 13:08:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnHzRKC08dohUKQD/XdldMc6IWYVddiLtTh8Yidep5vx+5++gzVG23SiimMwYZ+HldR36Zkg==
X-Received: by 2002:a5d:64ed:0:b0:3b5:dafc:1525 with SMTP id ffacd0b85a97d-3c5dc7313famr204645f8f.33.1755806922505;
        Thu, 21 Aug 2025 13:08:42 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e3a587sm10028205e9.18.2025.08.21.13.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:42 -0700 (PDT)
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
Subject: [PATCH RFC 34/35] block: update comment of "struct bio_vec" regarding nth_page()
Date: Thu, 21 Aug 2025 22:07:00 +0200
Message-ID: <20250821200701.1329277-35-david@redhat.com>
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

Ever since commit 858c708d9efb ("block: move the bi_size update out of
__bio_try_merge_page"), page_is_mergeable() no longer exists, and the
logic in bvec_try_merge_page() is now a simple page pointer
comparison.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/bvec.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 0a80e1f9aa201..3fc0efa0825b1 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -22,11 +22,8 @@ struct page;
  * @bv_len:    Number of bytes in the address range.
  * @bv_offset: Start of the address range relative to the start of @bv_page.
  *
- * The following holds for a bvec if n * PAGE_SIZE < bv_offset + bv_len:
- *
- *   nth_page(@bv_page, n) == @bv_page + n
- *
- * This holds because page_is_mergeable() checks the above property.
+ * All pages within a bio_vec starting from @bv_page are contiguous and
+ * can simply be iterated (see bvec_advance()).
  */
 struct bio_vec {
 	struct page	*bv_page;
-- 
2.50.1



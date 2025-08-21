Return-Path: <kvm+bounces-55365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A8F6B304A8
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 874AB189B0F0
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A2F3369352;
	Thu, 21 Aug 2025 20:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A8Y/z55w"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF60A3629BD
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 20:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806887; cv=none; b=mC2MqH0sxKSJ7G4ZCoGdCVz3Wjanm+aEhc73lvZzH2QvVRLZ+UwM6c1wXZmzJelYzx8bmx9n4oShZklzr/GZQx8HS9yOZGNi2WutnzbmBy/xznxdLaOTtUTmykmMIo7DZ451229LaB9WKSQyWYq3F8WYZSWfldjMVzi5qu7uKVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806887; c=relaxed/simple;
	bh=E88hXeAEs+yXdxHqIfTWo/GvQIeDr+kkFObDidynu1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwOUvMAmDvV06Skp8kiGQW962wof7rssf10cqawZFfYsOcTElNk7ZNT+Wt1sGkjaMeCNwyW3maOvh3bfQoYQi73EP593xORtHwYoky8o/Uvr7IqF+v5+qx/GIdbZRBQwgnwjNRUKx46woQbU4DFblozaFOYnFfWaWHFJsJmv2jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A8Y/z55w; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w6VkvDa+3msZeC5nA9B9+aDln+Mg2ABReefULBX94/4=;
	b=A8Y/z55whALu5jqaXnjs712aVYLHqF67dWfcHgxKHZmTKO15vFqYgm6IipQfXBlddnyuA1
	RZYJ63hZY0NJMOIqNrnpdJhIP3tv/7T+fyT56ysyvrcSKeis+Pi5fzo5tiq8r7hX68Se3U
	q18q7jTiHvKbMFln/PhXwPJpbZhgang=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-jvqpaoLLP5q0KrWInFIKRA-1; Thu, 21 Aug 2025 16:08:01 -0400
X-MC-Unique: jvqpaoLLP5q0KrWInFIKRA-1
X-Mimecast-MFC-AGG-ID: jvqpaoLLP5q0KrWInFIKRA_1755806880
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so14273475e9.0
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 13:08:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806880; x=1756411680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w6VkvDa+3msZeC5nA9B9+aDln+Mg2ABReefULBX94/4=;
        b=Mlq/hpml4inNaI8HT6WUocvrP5E3gB5sMGqAf2JYlpe/VnARbqbSK7Fjtlkt0K70Nt
         X5w+pZ/tEoj1zZ0rBgZVTikg14i5Qww7PyAFGwQiYJtOhBnCcZsoI7VIZCapz3r+Ugq9
         u2SuCVmsAPj6jLOd31joo0vpeTu/9dx6d6kEC3HOBk45BdlbBuYeQ5/dE7Sak6C/2FU+
         0+D8PLEFy7ljes4ZQQcCD1V+m9q+KsJThCJ8gmzB1GY41C/YRMjUG3UuiB+EABuVJ34H
         IOn43h9v+E1aVimAkgs3hA0SSB/CmakhCg9Gq1P2ZchtnnT+9krMxwfXqP010WX/vX1z
         u9EQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKYLg4Cj4FL9fi0o+quKL/BrlKB8DJrBJpb8Tqg7ALe7t12mkR/pJ6Pkx8E0b2TdK5QpY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8XWtnEOQJ21NaakPWvpTg2SwNucmyrELqICxkyCIVGI7nkfzY
	0Se+YTUkdwcEFFbjazzJ1ZLneC978xYOvgm4YJQbL8Z+KAANpsJzdn1h33lRcsElgqeQBBNGPzR
	+6DpRi+SIIIIElrfR1YYqaJwqCtQgfIBgFtlzBtQ7msijNOvR9w7c/A==
X-Gm-Gg: ASbGnctr2ZzPfv94M/AveMV3YfAFCFt2Gx6m64lxaU+NRzLuL9KvCcd2Uk1Ux6YPXzP
	D57xQiHx46HZ5Z1V5K9bc9W2y5d8bUjE93GvReyF4LX6sPOefjSL1Y5JR2jDC7ecs0dVSDw5RM2
	7EbeMHwbC9IpXipxrmO9HuNWw1o8IBJNCun2xYMViLQRjZpQU4O7X7+Yb9jkMZHCbZ8BNB+MbWb
	Gg2OHeTTC935cgZ1lz4ve54LCIxzQADNWzfOJJL5HMTiDX3fvNCVuhHyo665K1vZpW8ItI5+KC5
	S5fftx/9sTqg/xPUz81dcr2SWg0Psin0A1cQ7AzmIUtl7/DWSwkH4ra33Ia6ZDQBEPQewpdqRO0
	pzA8cG8VVHEEsYXmSW4pkMw==
X-Received: by 2002:a05:600c:1c87:b0:456:942:b162 with SMTP id 5b1f17b1804b1-45b51792539mr3328535e9.11.1755806880029;
        Thu, 21 Aug 2025 13:08:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9ciI0WdoI3CxhUtu7m/cESVsdReJmvmXFWCMaWsO+hhXySreox2GeOL2sJ8kVyLPwCYhbEA==
X-Received: by 2002:a05:600c:1c87:b0:456:942:b162 with SMTP id 5b1f17b1804b1-45b51792539mr3328365e9.11.1755806879543;
        Thu, 21 Aug 2025 13:07:59 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c07778939bsm12219075f8f.46.2025.08.21.13.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:59 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
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
Subject: [PATCH RFC 19/35] io_uring/zcrx: remove nth_page() usage within folio
Date: Thu, 21 Aug 2025 22:06:45 +0200
Message-ID: <20250821200701.1329277-20-david@redhat.com>
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

Within a folio/compound page, nth_page() is no longer required.
Given that we call folio_test_partial_kmap()+kmap_local_page(), the code
would already be problematic if the src_pages would span multiple folios.

So let's just assume that all src pages belong to a single
folio/compound page and can be iterated ordinarily.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index f29b2a4867516..107b2a1b31c1c 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -966,7 +966,7 @@ static ssize_t io_copy_page(struct page *dst_page, struct page *src_page,
 		size_t n = len;
 
 		if (folio_test_partial_kmap(page_folio(src_page))) {
-			src_page = nth_page(src_page, src_offset / PAGE_SIZE);
+			src_page += src_offset / PAGE_SIZE;
 			src_offset = offset_in_page(src_offset);
 			n = min(PAGE_SIZE - src_offset, PAGE_SIZE - dst_offset);
 			n = min(n, len);
-- 
2.50.1



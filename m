Return-Path: <kvm+bounces-55375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 789D2B30539
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:27:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4932722A16
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C412637DF11;
	Thu, 21 Aug 2025 20:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GlBHpnYq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D5737D5BC
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 20:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806916; cv=none; b=hi6zwKd21j5ZJgNmE5lwtSkTVJ3cLZUpizNRkqDZucscqvbO1nwjO69FMMHdnVwpCmlc0BEg3fHdP5vFuthdWcBr/eNC/RLHgWrZknecQxLZDsLpTRuipRLgZDtFoJYKavuL1zEoXcufRmMciNzSsdgS6CMvrLWJqe/gxuUbj2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806916; c=relaxed/simple;
	bh=o0B/aIsMAhafmNCelOfWp+ALdEBw0Dyti3dxNNba1Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=et0Hi6qcuO83zlGOyiCmWAgCdJdIsV50KnYWng/6TUgsiSo4K4NaCItVzhH0DKUf/NbhHIoPoB0PmbFFbkigHkzaE7l/TW+dClVexYfYBS4FC/BK40DsHR76Ip2wtcBKkz+8/U+ISlvJ18VNcmrqe3id11plKHj7W52dqIUsFaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GlBHpnYq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qEz5al18caSg7WeU7/xaDhHrA43/vq8xaUIrOF+uMyw=;
	b=GlBHpnYq/Hds5CFbE3iT+3iWBYvE0yD9rKJpHK3oOXqIqifH4yJkGqazlTT2Hzkf3iXKMX
	4w5pVgkjPqpCRL2biL7cfa8Z1lcd3ih+WbFCfnPTfN2ybpkMj1JojjxlpyfoLDfAVSCYcC
	DILrR7C1cFjRK9mOSd5ZmvxMK/YYozU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-KW4BfV9vMjmJ2_28TXta2g-1; Thu, 21 Aug 2025 16:08:21 -0400
X-MC-Unique: KW4BfV9vMjmJ2_28TXta2g-1
X-Mimecast-MFC-AGG-ID: KW4BfV9vMjmJ2_28TXta2g_1755806895
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9e743736dso787484f8f.3
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 13:08:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806894; x=1756411694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qEz5al18caSg7WeU7/xaDhHrA43/vq8xaUIrOF+uMyw=;
        b=cWnpKCZJ44Zmn28DtajQT6OpKiq1VUmH9rp6n3CLTKPm1nHZ0Ta9gEqPXvKKv9IjWb
         5hB4LNDGbyyS5Bri4OYeVy6KHKNaVhBDwpIqS6zfQZ5yXwkKkCfLnVjkM0NaWMlApCa3
         W25OLjBXkVsMief88t2z9FsKzVOUEEhythRT1C1oyi5tw6MWQ6afqB4o0dbgsOGIQad3
         DmVA5nFO6KtHu96y8iNsYahgMNLAP3TCyqiPbQY3Lh6gvnDnOpgjTdsciTeoSSacgc2T
         nFkn/oxAM62ca4iRnz1/6R8A+3kn4ANIuTTbxKjqf8cvAC5YCl/pEir3+x8Bf0ANzGKb
         Wu4g==
X-Forwarded-Encrypted: i=1; AJvYcCVRVlc/SQEwh8hBu2FUPZY3ieJa5Q0LWrWAzKCZep8tUA6eo4bS7Ejs0guzPf17ETjQ3cU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWSrNBEmejJywkYgAewRReUKMOb/epBAJ1rrtrMOldB4SzzAJ3
	Kco+F1ezQH0wwXB7WMar5HTjiDqFZTmVtdSjCYSLTYIVcN47EoCC5C/oSoOj2gzwcUNjX1wd513
	TPJBZBVMKa4Y4fDZ3kbszqhpN+HZRTaeK6s+fh9XOwVrhWKISFfNUEw==
X-Gm-Gg: ASbGncvFL6qFrU0DMgfoSqE6gW/2Fb57Te5M4hccI8Q3bGtWXWj0o7Gr7QNPfLt9LYe
	gYO5YoWk2ss/Pq18LHLNqoahc20l7PfsMjX+fCO/LPlDNO9vp8QUQJn4N0P9qSI4bwGiO7NwE/G
	YRZjPzwdeXfyxU+4+FnBTa6Ie/KVd4TP6WSCciXwQWsHTsreqxqVfwdhwVmqRbkPWOc8OVFGwen
	zqs0ZL4h1k1q78Ny8/FZTAGLdPpbI6OVD0F/ax340lJhM/cCMFDV1z4HDn0Cnd8YVOPpeo1fSzf
	Tf+Kk0VadxvCjQH0NyrQGcRFPx1yrvFuge24IaIxVVT3vq1lNn0dczGzhikNcWS8IsQ5lN2JJ5U
	ZcLFzA5GvCa6I888QahC2kA==
X-Received: by 2002:a05:6000:18ad:b0:3b7:9c79:32bb with SMTP id ffacd0b85a97d-3c5dcdf9bd9mr215823f8f.44.1755806894479;
        Thu, 21 Aug 2025 13:08:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYrE9N2OTZOZSEOVxEUY9xhX4UsF8UOhI+5wOqBRpd/3VSIxUjVMLdiea20BiXkc+w3FSZ8A==
X-Received: by 2002:a05:6000:18ad:b0:3b7:9c79:32bb with SMTP id ffacd0b85a97d-3c5dcdf9bd9mr215789f8f.44.1755806894010;
        Thu, 21 Aug 2025 13:08:14 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c074e38d65sm12982954f8f.27.2025.08.21.13.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:13 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
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
Subject: [PATCH RFC 24/35] ata: libata-eh: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:50 +0200
Message-ID: <20250821200701.1329277-25-david@redhat.com>
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

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Niklas Cassel <cassel@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/ata/libata-sff.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 7fc407255eb46..9f5d0f9f6d686 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -614,7 +614,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 	offset = qc->cursg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
-	page = nth_page(page, (offset >> PAGE_SHIFT));
+	page += offset / PAGE_SHIFT;
 	offset %= PAGE_SIZE;
 
 	/* don't overrun current sg */
@@ -631,7 +631,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 		unsigned int split_len = PAGE_SIZE - offset;
 
 		ata_pio_xfer(qc, page, offset, split_len);
-		ata_pio_xfer(qc, nth_page(page, 1), 0, count - split_len);
+		ata_pio_xfer(qc, page + 1, 0, count - split_len);
 	} else {
 		ata_pio_xfer(qc, page, offset, count);
 	}
@@ -751,7 +751,7 @@ static int __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
 	offset = sg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
-	page = nth_page(page, (offset >> PAGE_SHIFT));
+	page += offset / PAGE_SIZE;
 	offset %= PAGE_SIZE;
 
 	/* don't overrun current sg */
-- 
2.50.1



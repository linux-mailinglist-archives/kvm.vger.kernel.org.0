Return-Path: <kvm+bounces-46796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2860CAB9C5A
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 14:41:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63CCB7A8053
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 12:39:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58D2244674;
	Fri, 16 May 2025 12:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FPkqyini"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4686424336D
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 12:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747399203; cv=none; b=utxXhnDNWyucAEiR+u+kmI49qFDpafi4uq911bjWilKoGKhPmvHTyFNyKaLLUCzQhLVhx25kaO2z5tG/4Fx9a8xOZq737wH6iDxIawvqtcHzkK/Nme5vBYw0zY4bAHOLPlsc9Z2uGcZhPWeCLssByCSoqdt0IQ7Mj3/Rs9UqtJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747399203; c=relaxed/simple;
	bh=rdOAlDn565rE1FqMI4nBJDb9BzleRulrsucs0xSkJLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKV0xHi4OAt8rCuEfdGPZK3D4UaUkcjtBKL3c2x/JSCMgKntxD5dkxmFYVfQ4m2bX8wIqmvTawKbbA4LYs0awREnNMyk1ZGialm7jd6v3CHd9g8MeUpWmFmqB5AAlSXMbPnZu1Jn+6M6fqdjVP+rN2Ys6NcAPrU4Qy4/ovIrSng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FPkqyini; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747399200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hiLZZy7QAtq/50XMExKGpNPia0HeTXt82qBD/QjAX4s=;
	b=FPkqyiniFF+1BIjQ42qbT9ml+S5MjfjDcV4CKb7zKl7aNPs0rSvE7uUMsUDvHUe348LPx0
	s3iCX9Hmx7ZPuZU8glULaTAZr2DJvRBH+Jc7R4NXt+/bJz3KBnAxadcraUKJ0W0Rmnw8uP
	cyJF1iP/cXPI/KyDY4ZlaghTsy2amlA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-eqCcYsoAO4WFBV5AutCi-A-1; Fri, 16 May 2025 08:39:57 -0400
X-MC-Unique: eqCcYsoAO4WFBV5AutCi-A-1
X-Mimecast-MFC-AGG-ID: eqCcYsoAO4WFBV5AutCi-A_1747399196
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43efa869b19so15713565e9.2
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 05:39:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747399196; x=1748003996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hiLZZy7QAtq/50XMExKGpNPia0HeTXt82qBD/QjAX4s=;
        b=RvgUgvO5+pdAMFSI/ivac77EsGEu2tvSksS6Ix7v40np7VMdzgzw3Wtud42whHXc8P
         WQAWF7S9mwnDAxVwx+g6QH/LpvY/PdBV3Gg831D5IyWGppd29QO03JcGfQpZlWyS1lLC
         P/8BDwSBywlfhqCfhEED4MNTWSFyKlVnH0tlbFXlHkdcHmK+XXA6KnR07CNxK8c4P7Rf
         VWosBPDw8VVpyiY5UijXIRXKKudvVnVNw4jJvx53SEUjLzzFM/XpRFFEe1va4+lCh0E4
         GOrlRiReQHv2IHfA2bxbT259cJWgwh1jwJfFLE8OTXTH5mczYpde5h3sMYyOthtPbSBd
         4tnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgJGXIYV+qtOHzouW9cOc722MfoVwTjzNXxZawW1BvLa3zFp/g6q7RO+nhRVRgH6n5v+A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpFYqtqtUy//XRpipP1IsxPd7mcm8RkYW0q+Pj3V9uVU8/OIVB
	yjoJp2Kuw6XdSu6zAfHOxQG1Og7nqBcIZ7g809RAfVeO9VKTxVsr/vDontDbJ52LfXCGprzHbxd
	LlNRU+d5jJz+niZfzvFJcpv8+stxRp2Cs6cxCTTw6NM9z3Zlwj73GMg==
X-Gm-Gg: ASbGncu0gtNfakPnwDWBz/wT6SbJ7CtzdOAsJbE9fjkyJAFqP7WQ8gqtINMAD2JiExQ
	r9qlPd0Wj+QayEDdrgXpG7wgrhrKt9SiDTsQrynxDWvOv25287lAYv1kfLspLezpBqd2OsxO7F9
	eWc114HZR/AjZpWVK0k9IqvPv9w2+zlWxMssQnfQTYT2o0wDRJz/pWejKY6fgb0/Kgz1lLwzh+l
	xIU96ah+BrF1EOIwws4qm1Vj68R905h6SZYNS0+jeg2QfJXRVx26zHb+BZFSExVGcJkwYRCZNDT
	byfhwJTTbYeTTRd/IQxixrbyoiYw2dOxt1p5XQTcb4yLnNkE4ERL9DM+s9AwwyHLQMVFAnsj
X-Received: by 2002:a05:600c:c1b:b0:43c:e481:3353 with SMTP id 5b1f17b1804b1-442feffbb8dmr28003385e9.17.1747399195774;
        Fri, 16 May 2025 05:39:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPCjYc5Wqc+yI//ttOUMN3UV92gYVHaHXlQYA3K8J/bBkEM9DoFCaA+VbVbF4V9/mI2J6diA==
X-Received: by 2002:a05:600c:c1b:b0:43c:e481:3353 with SMTP id 5b1f17b1804b1-442feffbb8dmr28002955e9.17.1747399195319;
        Fri, 16 May 2025 05:39:55 -0700 (PDT)
Received: from localhost (p200300d82f474700e6f9f4539ece7602.dip0.t-ipconnect.de. [2003:d8:2f47:4700:e6f9:f453:9ece:7602])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-442f3380498sm108750375e9.11.2025.05.16.05.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 05:39:54 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Sebastian Mitterle <smitterl@redhat.com>
Subject: [PATCH v1 3/3] s390/uv: improve splitting of large folios that cannot be split while dirty
Date: Fri, 16 May 2025 14:39:46 +0200
Message-ID: <20250516123946.1648026-4-david@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250516123946.1648026-1-david@redhat.com>
References: <20250516123946.1648026-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, starting a PV VM on an iomap-based filesystem with large
folio support, such as XFS, will not work. We'll be stuck in
unpack_one()->gmap_make_secure(), because we can't seem to make progress
splitting the large folio.

The problem is that we require a writable PTE but a writable PTE under such
filesystems will imply a dirty folio.

So whenever we have a writable PTE, we'll have a dirty folio, and dirty
iomap folios cannot currently get split, because
split_folio()->split_huge_page_to_list_to_order()->filemap_release_folio()
will fail in iomap_release_folio().

So we will not make any progress splitting such large folios.

Until dirty folios can be split more reliably, let's manually trigger
writeback of the problematic folio using
filemap_write_and_wait_range(), and retry the split immediately
afterwards exactly once, before looking up the folio again.

Should this logic be part of split_folio()? Likely not; most split users
don't have to split so eagerly to make any progress.

For now, this seems to affect xfs, zonefs and erofs, and this patch
makes it work again (tested on xfs only).

While this could be considered a fix for 6795801366da ("xfs: Support
large folios"), df2f9708ff1f ("zonefs: enable support for large folios")
and ce529cc25b18 ("erofs: enable large folios for iomap mode"), before
commit eef88fe45ac9 ("s390/uv: Split large folios in gmap_make_secure()"),
we did not try splitting large folios at all. So it's all rather part of
making SE compatible with file systems that support large folios. But to
have some "Fixes:" tag, let's just use eef88fe45ac9.

Not CCing stable, because there are a lot of dependencies, and it simply
not working is not critical in stable kernels.

Reported-by: Sebastian Mitterle <smitterl@redhat.com>
Closes: https://issues.redhat.com/browse/RHEL-58218
Fixes: eef88fe45ac9 ("s390/uv: Split large folios in gmap_make_secure()")
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/kernel/uv.c | 66 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 60 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index f6ddb2b54032e..d278bf0c09d1b 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -15,6 +15,7 @@
 #include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <linux/pagewalk.h>
+#include <linux/backing-dev.h>
 #include <asm/facility.h>
 #include <asm/sections.h>
 #include <asm/uv.h>
@@ -338,22 +339,75 @@ static int make_folio_secure(struct mm_struct *mm, struct folio *folio, struct u
  */
 static int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio)
 {
-	int rc;
+	int rc, tried_splits;
 
 	lockdep_assert_not_held(&mm->mmap_lock);
 	folio_wait_writeback(folio);
 	lru_add_drain_all();
 
-	if (folio_test_large(folio)) {
+	if (!folio_test_large(folio))
+		return 0;
+
+	for (tried_splits = 0; tried_splits < 2; tried_splits++) {
+		struct address_space *mapping;
+		loff_t lstart, lend;
+		struct inode *inode;
+
 		folio_lock(folio);
 		rc = split_folio(folio);
+		if (rc != -EBUSY) {
+			folio_unlock(folio);
+			return rc;
+		}
+
+		/*
+		 * Splitting with -EBUSY can fail for various reasons, but we
+		 * have to handle one case explicitly for now: some mappings
+		 * don't allow for splitting dirty folios; writeback will
+		 * mark them clean again, including marking all page table
+		 * entries mapping the folio read-only, to catch future write
+		 * attempts.
+		 *
+		 * While the system should be writing back dirty folios in the
+		 * background, we obtained this folio by looking up a writable
+		 * page table entry. On these problematic mappings, writable
+		 * page table entries imply dirty folios, preventing the
+		 * split in the first place.
+		 *
+		 * To prevent a livelock when trigger writeback manually and
+		 * letting the caller look up the folio again in the page
+		 * table (turning it dirty), immediately try to split again.
+		 *
+		 * This is only a problem for some mappings (e.g., XFS);
+		 * mappings that do not support writeback (e.g., shmem) do not
+		 * apply.
+		 */
+		if (!folio_test_dirty(folio) || folio_test_anon(folio) ||
+		    !folio->mapping || !mapping_can_writeback(folio->mapping)) {
+			folio_unlock(folio);
+			break;
+		}
+
+		/*
+		 * Ideally, we'd only trigger writeback on this exact folio. But
+		 * there is no easy way to do that, so we'll stabilize the
+		 * mapping while we still hold the folio lock, so we can drop
+		 * the folio lock to trigger writeback on the range currently
+		 * covered by the folio instead.
+		 */
+		mapping = folio->mapping;
+		lstart = folio_pos(folio);
+		lend = lstart + folio_size(folio) - 1;
+		inode = igrab(mapping->host);
 		folio_unlock(folio);
 
-		if (rc != -EBUSY)
-			return rc;
-		return -EAGAIN;
+		if (unlikely(!inode))
+			break;
+
+		filemap_write_and_wait_range(mapping, lstart, lend);
+		iput(mapping->host);
 	}
-	return 0;
+	return -EAGAIN;
 }
 
 int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
-- 
2.49.0



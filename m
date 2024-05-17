Return-Path: <kvm+bounces-17575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9042A8C809F
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 07:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B401B21912
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 05:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E8B10A31;
	Fri, 17 May 2024 05:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MBlRc0Gq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f193.google.com (mail-oi1-f193.google.com [209.85.167.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AE010A0B
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 05:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715924112; cv=none; b=eaML5hATeWaz3uz7Da5XhNoamQsNVvv8yjZ/plSK3BFjOfbvJ1AXCx5s0zIsDaW5hOsrbB+CQl7Tq5Lx91Dyzx7ZTTGZSjnuJMUsPelOAALw1clK0RCP+FFmSEru4ux2+PTuUie4v75PszORUYjbrwjXMinsdibN0gdFd5+vUk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715924112; c=relaxed/simple;
	bh=pGrY5t6tYxJ+Ol4BPllW2+FIJlPa9HzXLo7RcvJ3oGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbJZ9ly/sbdzDPa0/K1WTgwIE9EAiVK+IF4KmNI5MeNXdY2VYZqbn/Zpn3N55nMxTMXFWLecBLq8wySiLSJ5yd4s+qFOh3BGSzRnoJQlULdzqxT1w9J8jBYE2vHeI0O/FRY85MRnniBQ5O0v2dN0dm+elWGMIh78JFliYbCI1Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MBlRc0Gq; arc=none smtp.client-ip=209.85.167.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f193.google.com with SMTP id 5614622812f47-3c9cc681ee4so179141b6e.0
        for <kvm@vger.kernel.org>; Thu, 16 May 2024 22:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715924110; x=1716528910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uCiaoaoXNeiwrVzi+T413aFo5GLUosF3kcMYkiNgPQw=;
        b=MBlRc0GqdjelkiZh5NqwXJ5YIg/eBElvvMmjLaU6wcGx1s/fBsSJizzLz+480uT3Rc
         eU5c2zTAvhObnIsZEqGKMJxV7aaSS0NXWT/jbTlTaV0zI7NYDvbf+EaGRP2aHQSZX2Un
         nnvMDQ4epaX1vraceXxwa3GuSsg0t4rqKIgeJlwZLqAXbwQPwLcUNSYxCilqwMhwTtiq
         M4adUxQrPZ3FrrsrjTaMwtSfTNx2KDgtEoguEnvU3iyKSTJA0j9WLEtdBgj3G/yP95aA
         hLqbeSAeuCV64PuUSzpENJxUKLaN91kPgq9y+/nqxA+nbT3cVKlPSjKKNVh6UHPve+QI
         IC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715924110; x=1716528910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uCiaoaoXNeiwrVzi+T413aFo5GLUosF3kcMYkiNgPQw=;
        b=g447kMV7JJ33qKIsefzt7L6bq0b36eCWNFipLq9C2g7xtvnFMBgBIR6DzUlmvE9zR5
         l67ibIRrZH/ZXgufkIze61VWUJ3OMnQGUIPko2QhV8MZsOi10FVMkLKbExUiSRXvYZze
         kJMZfoIW1ubIZTSByqscvTZCdPrKxokMz8CDsbsSmpBtIzmKyLwBdKZ0tiEN61xIPmIZ
         uHCtWjLzOq0vjJMJUPSX7sunxPcfu1SltzSGLivplJed7GNtmf/xrmKBz4NCOuWSeQE4
         5iLtU7a9U+fc52fXgFqP6ERo5Wwp7EkGnhxPXXCgwsKVZFyiluvryLCgoQprgTAT4WcO
         UuiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCGuzulKC+BfEShsdPIBu506yVO6dUhLO0lOyAHpSdgtuOFbKxj7kP/+2i3dakBd9ujB8EErLC3eOaZQmINiYB7S15
X-Gm-Message-State: AOJu0YxfrKRhEhMEx549uPsAcAWi0MLK3rEycBRpYFvTwQZMEmrNSJ0k
	wAia57pY177/1HDnVT7M9+oSf4Yp1EVUBf1WvCyoprgkgma7ZQNx
X-Google-Smtp-Source: AGHT+IHfaXGHiU68JYr23tVt2b4s8EoAl3p/ZFwW9L40JxLBGCgWyaJ3rMLtYHINMq+OVLW9r+I8oA==
X-Received: by 2002:a05:6808:3ae:b0:3c9:68ba:6e14 with SMTP id 5614622812f47-3c9970b1152mr22597474b6e.44.1715924109947;
        Thu, 16 May 2024 22:35:09 -0700 (PDT)
Received: from localhost.localdomain ([112.30.116.152])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f67b526b44sm3269834b3a.149.2024.05.16.22.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 May 2024 22:35:09 -0700 (PDT)
From: Lynch <lynch.wy@gmail.com>
X-Google-Original-From: Lynch <Lynch.wy@gmail.com>
To: andrey.zhadchenko@virtuozzo.com
Cc: jasowang@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	Lynch <Lynch.wy@gmail.com>
Subject: [PATCH] Fix Issue: When VirtIO Backend providing VIRTIO_BLK_F_MQ feature, The file system of the front-end OS fails to be mounted.
Date: Fri, 17 May 2024 05:34:51 +0000
Message-ID: <20240517053451.25693-1-Lynch.wy@gmail.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <5bc57d8a-88c3-2e8a-65d4-670e69d258af@virtuozzo.com>
References: <5bc57d8a-88c3-2e8a-65d4-670e69d258af@virtuozzo.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

---
 drivers/vhost/blk.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/blk.c b/drivers/vhost/blk.c
index 44fbf253e773..0e946d9dfc33 100644
--- a/drivers/vhost/blk.c
+++ b/drivers/vhost/blk.c
@@ -251,6 +251,7 @@ static int vhost_blk_bio_make(struct vhost_blk_req *req,
 	struct page **pages, *page;
 	struct bio *bio = NULL;
 	int bio_nr = 0;
+	sector_t sector_tmp;
 
 	if (unlikely(req->bi_opf == REQ_OP_FLUSH))
 		return vhost_blk_bio_make_simple(req, bdev);
@@ -270,6 +271,7 @@ static int vhost_blk_bio_make(struct vhost_blk_req *req,
 		req->bio = req->inline_bio;
 	}
 
+	sector_tmp = req->sector;
 	req->iov_nr = 0;
 	for (i = 0; i < iov_nr; i++) {
 		int pages_nr = iov_num_pages(&iov[i]);
@@ -302,7 +304,7 @@ static int vhost_blk_bio_make(struct vhost_blk_req *req,
 				bio = bio_alloc(GFP_KERNEL, pages_nr_total);
 				if (!bio)
 					goto fail;
-				bio->bi_iter.bi_sector  = req->sector;
+				bio->bi_iter.bi_sector  = sector_tmp;
 				bio_set_dev(bio, bdev);
 				bio->bi_private = req;
 				bio->bi_end_io  = vhost_blk_req_done;
@@ -314,7 +316,7 @@ static int vhost_blk_bio_make(struct vhost_blk_req *req,
 			iov_len		-= len;
 
 			pos = (iov_base & VHOST_BLK_SECTOR_MASK) + iov_len;
-			req->sector += pos >> VHOST_BLK_SECTOR_BITS;
+			sector_tmp += pos >> VHOST_BLK_SECTOR_BITS;
 		}
 
 		pages += pages_nr;
-- 
2.25.1



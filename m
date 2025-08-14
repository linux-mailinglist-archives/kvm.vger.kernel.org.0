Return-Path: <kvm+bounces-54645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D6A8B25C26
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 08:49:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B335188BC24
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 06:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE7E259CB6;
	Thu, 14 Aug 2025 06:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="NuVnxbKd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1FE259CAC
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 06:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755154082; cv=none; b=Nhxwm2o1VLfcvp6eCeDUQyyrZbPByKo+JLHVjDrZan0M87sM+hJVXxHSLtoUIE7S5rDpwnfPRPTJ/TXG12j1wwDaJxt0otmGgwMhhxiFNjVi6qOG6vDQ8Pz3fBqL7ds5BCv5eESc/HgLOMQ0Gr1YV0sxCDoUQLwXYQRlVPXBC6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755154082; c=relaxed/simple;
	bh=kEDSBCSyc2RkmDkHA6/+45PuSFBXpNcPQN4gtWslwwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FcfKBZ2N/jv0SrVszpWLrBt0Ahw8v44FVQoZVeaXkOGiQSQUwEcxLLqIeRVFwDLp/S4vFkB4q2OTBDcDddZmZ78LBml9/lFXTLy6UMOWGjhov2jwFpTygkvUdGlOqAYR8nZJSy5nh14q9L1qUXLjXrAGWmMcHWRBrI1feCX6pUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=NuVnxbKd; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-323267bc0a8so1153497a91.1
        for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 23:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755154080; x=1755758880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8U9qCHhrJhIaN9YgK8JZU+6qrUbPYoXJVCAPiBgbC8=;
        b=NuVnxbKdhcmxJWmim8G1OAe7s85ZFFEx0lev6S0M5Rjl3kKtKrXlWDaoI6dTVtx7Uz
         Ue18VuQ+x5r2pETczntKsqJNP7GS7uIF1PDGj1Kpu6uDhbsqNBcnBwS2GtshtmxsK0DA
         BS9kTaLwKqU2L1ygC01jOhbSeewQ+gFSpgJ/M5OJPItoNGF29gUY/A9t8RXQC8cndEBh
         1AJ/i085gUgrgYmvxoAijoE+Dg7tS7StGK9ZgtOKeBYdmf/Y8Eui0Ioi1Md4yhP1ubeb
         qSLxdXCQBuMYcNzy9h6HRbVguB+ZXvi8bx7HBpdWuIpS//nToXHfBLBhkxVp107my2es
         TewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154080; x=1755758880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O8U9qCHhrJhIaN9YgK8JZU+6qrUbPYoXJVCAPiBgbC8=;
        b=JPttiXYsi5/yUxjYwScy+yGEj2YPsCQcrUk9Jea6Dek/qtVr5OSVyWVal9Q0ivsDbi
         ZE7p+J05kxNCLDcQi/eKXjSVFfqSx5JwJinlGZ2vf7aJX86q9FfXRzYC73kfOsr6O/IA
         xSyVYmsIEN2xmLZO49QjkMW7pURpFUfFIFRNBIKknaE5G0MGmn0lNyUWIbrhM2XuRT3L
         Cjc1EzvFMtHzeGuWBclufJeHxhwYbQyCL8UtiPEATWN63QWNv+HJHEunJqaqiAtPxHM/
         k8Cb+xOKl/x99NJLYpRFvzqdbkkBn8f1kPOAKJj/M59bWjqsOR8f6VIPw86GKv5ayxzO
         tFtg==
X-Forwarded-Encrypted: i=1; AJvYcCUMLs6IasUsksqk2A06gpp5rSRUNmbXFx7o2B+HshjpfmYakT0CKo/T9eVYiDjAuUtub/U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/8nYQWwrCnr6msmvJxWLbN+LY+KwXB1TJusUI8pA3hiwhXsx2
	GLgAl1Uwhe2eevQcIQhGtdftPIW+DtFO5Qrqe7U5ke6WmyD0dtDl18TtjUES3sCpYCQ=
X-Gm-Gg: ASbGncuQKxFCnRJFS2Fw0eK0IGFzg6vzJWMgcviKU/sQSPqlKlk3Hmz4kIRdCrnGw8c
	wImRlgYbx9oQwiS469vY+eJAvPCMv5LYnn2M0To4gjo1IA6TIjvLP9kLJElcFBgcgl7akYcmlJr
	/kOlg8nJxAjMj6xworf0ZeR91OhBA3TauJKDIfL7H4YBcQZCU8CH/3Sx0bmPgZ2Kyptx16QnZKc
	ejfFp7dYbYLxuPfRztCc7xXCjNCi0utsaDXlXQ++XkGhVbvX7z5MH45t/7RhdDLMc7PxOjyftGd
	xUXhVpVdmJas3BMKocx0U4BVqdJeuaVcGjf3tD2Ci0RtKwAHcRCnPYDdHZPnA3HEfWviLWyD0yM
	biX6JOo5F1sWG1ZBpWXdmnIIwZ51yCDCPs9kupUfHMq8FIxgyir6kMUrvkwzt
X-Google-Smtp-Source: AGHT+IH8fEM06ZvKhW2tHNMx4HCm1V4KHJ9G5sskVwcxUnvZdDTuwB+WAVO8lbZmBThC3Oe5fZtcYQ==
X-Received: by 2002:a17:902:d505:b0:242:cf0b:66cd with SMTP id d9443c01a7336-244586bf675mr28557835ad.34.1755154080047;
        Wed, 13 Aug 2025 23:48:00 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef6a8fsm340923605ad.23.2025.08.13.23.47.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Aug 2025 23:47:59 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	david@redhat.com,
	jgg@nvidia.com
Cc: torvalds@linux-foundation.org,
	kvm@vger.kernel.org,
	lizhe.67@bytedance.com,
	linux-mm@kvack.org,
	farman@linux.ibm.com
Subject: [PATCH v5 3/5] vfio/type1: batch vfio_find_vpfn() in function vfio_unpin_pages_remote()
Date: Thu, 14 Aug 2025 14:47:12 +0800
Message-ID: <20250814064714.56485-4-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250814064714.56485-1-lizhe.67@bytedance.com>
References: <20250814064714.56485-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

The function vpfn_pages() can help us determine the number of vpfn
nodes on the vpfn rb tree within a specified range. This allows us
to avoid searching for each vpfn individually in the function
vfio_unpin_pages_remote(). This patch batches the vfio_find_vpfn()
calls in function vfio_unpin_pages_remote().

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 drivers/vfio/vfio_iommu_type1.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 7829b5e268c2..dbacd852efae 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -802,16 +802,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 				    unsigned long pfn, unsigned long npage,
 				    bool do_accounting)
 {
-	long unlocked = 0, locked = 0;
+	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
 	long i;
 
-	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
-		if (put_pfn(pfn++, dma->prot)) {
+	for (i = 0; i < npage; i++)
+		if (put_pfn(pfn++, dma->prot))
 			unlocked++;
-			if (vfio_find_vpfn(dma, iova))
-				locked++;
-		}
-	}
 
 	if (do_accounting)
 		vfio_lock_acct(dma, locked - unlocked, true);
-- 
2.20.1



Return-Path: <kvm+bounces-51655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 78EFBAFAC21
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 08:51:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75896189DD07
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 06:51:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52DD7286424;
	Mon,  7 Jul 2025 06:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="OepFZ09r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2953227A926
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 06:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751871025; cv=none; b=ucv+WABFbc8Q0Oju8ZfzBMBG8P/R6BIypN1zDG512W/W9otZiVRmUv3TfHSRnfjDgq0apzHeQMJ36Q9YZ3SLS0MQ0lc5jnDg3ntCZADutkKbATRq0MX57NIqSGyucLP2RiOGvKtGR7j5D5KmtMSjIskdd5GMJTIpzxlGamzO/20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751871025; c=relaxed/simple;
	bh=2Ck7da429bj6tPACUdRedQc7kvHlhF/GdsKaHEkLWBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZsBWMwBdnHl6rg439e7vQU7HIahmrbEdQVpvWQFSHHg7DIopj5JC0uM4EZcjZHCxsAhX2x9sx6YoiInyIYWcRaifgRjkQaIPVHFWT4kJ17eu5x/2ZQqV06TFpveH5vdaIOHmaDGUyort9sclGvqCrlmyYD0+lCmgIfMlJ6oDoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=OepFZ09r; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-234fcadde3eso40772845ad.0
        for <kvm@vger.kernel.org>; Sun, 06 Jul 2025 23:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751871024; x=1752475824; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QiHfvwOVI0/DzO8i0IezA1Z19+xb67OoONslKakPCGo=;
        b=OepFZ09ry0Y45kaLbmmVB9g2ZxOIGKThy4FQfyDq2cijzMnT7B/OupDrRWOOK+E/pV
         znqaUrRUGwksQFKcDkPduIMHfHZzpMWNSiwiIrTfy+vVXsY5ID1rj75AiLkr4UhCUOg6
         SRyt4THFnpg/vDLT2QOBm3p4FPyTV9D2gmoS8OeUmR/REj9kjxQXUPm3N0UhJ5h30Kfs
         QeHZMv6LWkHO370X1h5a4uHq9M3tuQj1o9526MAXzjL+5hLpQoG0g27klR81CWrd8Gvk
         9fzM3KnxI+VaWeM7SbiTydNOtHswL+S2wmP0058b9cmQI/ezElMcTb8lzqP+A6gWQDZL
         MLtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751871024; x=1752475824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QiHfvwOVI0/DzO8i0IezA1Z19+xb67OoONslKakPCGo=;
        b=fEyFvtVeXwWXRKhJhyXS2ODwp3S3SkLFZILhqlH5CCjeDAAJkSkSvVQQ2xjnHD6G4d
         a93e73uxIXl5NIDo/+GqUMA8DInC2oPMhpgLDgBgsSMcxzhxRWc1D8TkrJ/SfH31ci2+
         XTwMQnz4T7P1NBye1YmqpDhoxLdiPkq0W/KvXFlpOkBAaHTOJ6tqWQ+1dn3MLpXLT+8d
         CAod7cGJ0fJpZ/1I1ozxj3Ubl5/eyBsEgmSiHAejXFWKWHLJP9APDC5k/u+MiKC5yhSr
         lOQhprwNa8htv0bM0i/SwCxnCe9qHHzl3u4aIAee4rVvRq4GPnrnvJFshXTcLjW4hInG
         lpkg==
X-Gm-Message-State: AOJu0Yy4uSQp3mGi4fzhIIo2AW6FHUhYE236lNaCaBbz++wF0GXdXVKI
	11IXeGgL2X/tXU9ZxmeecAxA0TuyEIVL8hmLixY382qOaQS6Nrwtng8dA/zPe9WPoo0=
X-Gm-Gg: ASbGnct+FhfXn4OWbJ+yi7nLhjqLSrcz7ZYAO98lPuXjo0jVRQ7c5kJZSlCs1/uuze9
	069M2TZbfBuIq4MvZnYkOJxBtPSbGePqTCWP8kAHKPZSep6t81i8PowJ6BqkqS684fbdGr6jS3r
	y+f2ELAkRmPPX+KztIi121LSiC3fAuNHRQVmwff8qIm24zNdcQHf2YYRjdXU7tR2yFOiRZtwoOQ
	slIwa/EYJyCuajdRAVTQhprapVJH2G3FatMsAnsMCcR84Gbhy+e/YxSzIhNhUxF0QsEul+vLWL5
	enqAdJZdnk4Z1Q9ygRmcm+ymc0JPociuAD8onH58DP3QDyb10l4YqvuGMfxMSukcnwdE9WCRsjP
	MWgPQJRyQ7JX4jO3UirJ/qew=
X-Google-Smtp-Source: AGHT+IFMBY0822v4rgg5psHQsiI89RRrF9TLtvLgFYQSnw9DJEUz57tWFMIxOBTqvqWWyVw9h1H5CA==
X-Received: by 2002:a17:903:1b4d:b0:23a:bc47:381f with SMTP id d9443c01a7336-23c8759dbb3mr181052285ad.36.1751871023683;
        Sun, 06 Jul 2025 23:50:23 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8431a1aasm77377635ad.15.2025.07.06.23.50.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 06 Jul 2025 23:50:23 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	jgg@ziepe.ca,
	peterx@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com
Subject: [PATCH v3 3/5] vfio/type1: batch vfio_find_vpfn() in function vfio_unpin_pages_remote()
Date: Mon,  7 Jul 2025 14:49:48 +0800
Message-ID: <20250707064950.72048-4-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250707064950.72048-1-lizhe.67@bytedance.com>
References: <20250707064950.72048-1-lizhe.67@bytedance.com>
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
index 03fce54e1372..b770eb1c4e07 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -794,16 +794,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
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



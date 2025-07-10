Return-Path: <kvm+bounces-52023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 731AAAFFCE8
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 10:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94FF71C86B4F
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 08:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C804291C04;
	Thu, 10 Jul 2025 08:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="RBbP7lt5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4370928DF2E
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 08:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752137662; cv=none; b=FsZz6BjjjcoJfpaxak+Y2JlrfvMa+KjB/iwAiabNx9xpNZxUX6/TX7LJiwv/qsclxCOTTLEuI2/yMUVuM4wp8mUcKfiTiPj1aCKnCjD0emHmeFJDjzJyExGIF1Ab8P3CCKvNEUfkhCJZerTzA/nJX/G2TKChrWDCQGu82iCIFew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752137662; c=relaxed/simple;
	bh=4N5I2w5e2jHfjeqUUs8UP8e7d+l4qfu2b+4DBY6K2Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiLAbUjotb49Jh87Mt2dYJBlRy6MNwCp2Ya3MHsg8C6tcUNs6K94FOkVfhBdRLiX+f3d8c/jUTLdyvg+e7nSgQJHU/3v5vOhHS6F815YcszQ4GtpM891qwlJeFqe46LkMmY2iei25EE3tMwvv9eRVNwTNVEs1LsuTq85Xvv7kVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=RBbP7lt5; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-23c8a505177so7273245ad.2
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 01:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1752137660; x=1752742460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nx6tn515BmvVRbPQz9Ke+EyJMh4nGWIC6oD4cxq1tFQ=;
        b=RBbP7lt5E2/ic+C0dUkuLmZYndw7LSu9MUGrM5BB8v1z+2l8K8zJMnWsjYN+7ilOiH
         TQGinApXthUPYA4B0dLDGJDpsa5qn25lcRzzqg7QMaVqyk3wdyIG7DCorP6eVjTqfHip
         i2ZDWrtt7ZnIi/35+nMXuKmO8z00lXQ3giisi3oYU8Kf5cw4W5ayCgGRXL8CPB5hdZgc
         1TyEmDzLuDGTddmhcxggefBzBd6ZEd+YFi+ciiDwsAejhb1Q8i4YC3JIumT11l4A7zmZ
         x66Tl+o7OlQu7SDZcAAv9sVnzsleTr5SPHqcajHML6KvDiZ21Q2N1ElwMFYkd571G0GY
         kDFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752137660; x=1752742460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nx6tn515BmvVRbPQz9Ke+EyJMh4nGWIC6oD4cxq1tFQ=;
        b=gac7u4gRgxnq1URbmQ/jCAjYN0x1Odn+81gw93Ad2DJ7GNuOrFjdDUcGKUoKkSZlKN
         Vs76kvmuUui1d6o+cDajVSLUjWSPm61jYxVQ91winE4RUtyUoEZiEmxfWDQWYv30OQ9Y
         44uix/XXsUfsqaZ4Y9AXUQoczMq5l4bxsqS12EGDDYAK18wflFmLPb+iZ/9ePemjhXoF
         hr9GwAtyJPhs5zW1T82N+OUrENCXFpPCTnLkNw+Y3CIn9fiCMGbLsd+Xcay7bQudlBZJ
         VfhGa9gb3vbixtVR7EuF63YVLinYsA+WCIFuNu8DcEYh5Ywqp+exnuhVLvf4zMjIkE/Z
         2Ijw==
X-Gm-Message-State: AOJu0Yy5AWuI5bta8uFmlA9RyYbj97NgtqcUlIqeYFk06PSg5VA0mq4p
	aLe95BphQLusQtVzKXQZiC+Dg6tKeiAuld/gAYuFZ3aDaG2Bd0KuNVGQZj3RnMyZ+Ps=
X-Gm-Gg: ASbGnct7zdkiw0gaKL3pqp3F1fBDiCB730CE3gOT4amknJnM1R1e8YhDbdvdbtRUrJr
	jjrXwLgGPC8D1vrDHdL0BML2FDsljvakEQgyP4uC0wqMi5w3dVDLQ+Wc05qOOPastCHVNa2yzGj
	qzlXqciC9jHs0pCIjnHOUoNnA9EsLVShl42xhpKZonNGDRpVcYz0JBu8z7gnTODcKwlAe4LFwAX
	jJZRHRbDlXmlty7fJSFJD+x4ToDBKTHlqYzj7gpW1wIJVjDv4GuN7flXjrb4XqzxKWLoCd0BP5d
	93C4p4Ns3yWzKtLqQd9KV4iB4vG4/grLGVEHK1pSEdlKE0dsGCTfMXDoZpw0UTVjPgxZk9ixGu1
	xTupENTBgf27udRv/jeankOR7
X-Google-Smtp-Source: AGHT+IHinmUo1Q8JyIR8mVroxGH87B3iRX98m8gWf3ZeXBpz/jGd0mYLjHRrHOq8wekDWW+AqoXtuQ==
X-Received: by 2002:a17:902:db0b:b0:235:225d:3087 with SMTP id d9443c01a7336-23de24d9865mr39979545ad.30.1752137660449;
        Thu, 10 Jul 2025 01:54:20 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.12])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c3e975d41sm1650228a91.13.2025.07.10.01.54.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Jul 2025 01:54:20 -0700 (PDT)
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
Subject: [PATCH v4 3/5] vfio/type1: batch vfio_find_vpfn() in function vfio_unpin_pages_remote()
Date: Thu, 10 Jul 2025 16:53:53 +0800
Message-ID: <20250710085355.54208-4-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250710085355.54208-1-lizhe.67@bytedance.com>
References: <20250710085355.54208-1-lizhe.67@bytedance.com>
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
index 6909275e46c2..cade7ac25eea 100644
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



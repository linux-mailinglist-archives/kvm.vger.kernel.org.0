Return-Path: <kvm+bounces-51547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C42EAF87FF
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:28:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C3D65878E1
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 06:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A44B2522BA;
	Fri,  4 Jul 2025 06:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="arY4hajF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECBB2505CE
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 06:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751610422; cv=none; b=G7wG0l+OZvG0jcMI2DQG//b4gFiUpa+i39XW2qE9/u2T6JP3sMFAFoZXbEtIm1fuWkjxHt8RLHm0eZJqNfLPgvhwVNnGe5R8JICMbk/9bKO8xc4NuLtSY+hlXziTR74BibUw87OuQhhfJUMbuxndz/HP9z+vfpvoxmFNl6XV8u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751610422; c=relaxed/simple;
	bh=2Ck7da429bj6tPACUdRedQc7kvHlhF/GdsKaHEkLWBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgNso0m7pzU5DSIABqML0kcMftvXDUzmPoOr2vjZo97fhiqmEKHQlvknDzwRkX5lPfJHvWx2ZKQtZPhPn2d61LAjjDAn5Mu6er4NXj2vevyQ/ROmYsqGdg3J89tS+NRgk6Jk2eNzLsr1fCacpj27cj37GV6frBYWR8CTwCOzWvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=arY4hajF; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-23508d30142so9048725ad.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 23:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751610420; x=1752215220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QiHfvwOVI0/DzO8i0IezA1Z19+xb67OoONslKakPCGo=;
        b=arY4hajFESXaQEwzEyNLZeMh6o5+kMlYtLy3wdGrRrm1gmPg1PoSDJ1WhCGA2hDxAV
         9U+n4+TgNX/alA3fZHaKUFoXUMsuFsf5ZzVJ29gx7eMueUUOxaFWqHCF35rZDWe20Jfr
         z5ZMcfQ6oz8fnuUphcxMRB7ePKzByXvU/y1u4hlreEEt++u+VTdXkwmEifbl2xOUUV2T
         FTGNZZnK7vvUtFXuJZDgaDSmsazcNbKv+xN0AeaY927S4GrDI6VNXzNP1wc3n6rjMxcL
         3dnen0UP7QNA6Xa4pu+CvGZpCRgSrH1ArPImhhMwQpVoPSwIWI/BweL8jnn0Q8a5FGa/
         3lbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751610420; x=1752215220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QiHfvwOVI0/DzO8i0IezA1Z19+xb67OoONslKakPCGo=;
        b=UdcKumlme658qI7akejP/3vkJC83LugHeBKFb8Y6xPGknIUwH3U5kHo5GLabluk0zj
         bJR1MtxUPoRSpMPhy5schXAna6IX+pr+AagFdOm/xHaRpl1P98Mb93+eoQLiQBxcFJVm
         6AtxAo6af3MllnFxPr+WhXlNfZuRFuVaQXMJkHixWcqTf6uovQMEC0Kcwolmk7nDIbMw
         IsDskBBC58t4noaECcBChvLxJcN94Z+UxR3eoZxjGIPAc/qMdfawTNJ3B5Tox+C010/I
         N4m8z44w3aagAMMUv7g7XZT3yAPfHSvnAf/+mLE3KGbaCQQpKf0ASZRuVgRRWokA/vGu
         xgvw==
X-Gm-Message-State: AOJu0Yy7LZl1pr+O8rq1pafjFSAFsuFmVwOq+ZwGLuNoTBp/q2/fwr5a
	Icj8tdivrZtyEh04+7oTZmLNI3wuazj5tn8OjPQO3JPde07ral+LIPP6OhS0NbH6+Xw=
X-Gm-Gg: ASbGncsJSes5APocE2n+dLU9Xgajfe8ZVK2CAMy3kATTjSh3qVwiTFY+8xdvS5dDnuy
	c3cmtqxXFudsgiGcGH5QCHHxRe+h10Frl4HifsIR79d1mmmQr0OVfUlHuiiuWsulRv1CegnD/Tt
	+gVE3k4PgL/+CZCJyVqs+kZifiA9On5b3RjB/4yAUEAdyPa9ea87h4zLpaI2rJH/+R1FO1w9HiC
	36oj+d+Hp+DFW1hfEJHq/NwSlK0UDFJ0iOgRaRl95LgCy7v3aRU2C9QienbDKm5ujBinOK5fgAK
	mSNk4/851oA6yPN9gOmhj5DgYU8J2kTuxJtMTG1mA2iSbVEM4WIJcyh/Pn5MiftrZM0AKyxWOca
	wuykT0qOTM9M5
X-Google-Smtp-Source: AGHT+IFXOrpM+FeRqzRx01wW+29lMpHFGQ2PU6Rtc5xxE9IkYr1rATfhqAIwp0ljrPlZY65KFR/JyQ==
X-Received: by 2002:a17:902:d592:b0:235:799:eca5 with SMTP id d9443c01a7336-23c85eb051dmr27110365ad.44.1751610420130;
        Thu, 03 Jul 2025 23:27:00 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b38ee5f643dsm1183240a12.37.2025.07.03.23.26.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 23:26:59 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	peterx@redhat.com,
	jgg@ziepe.ca
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com
Subject: [PATCH v2 3/5] vfio/type1: batch vfio_find_vpfn() in function vfio_unpin_pages_remote()
Date: Fri,  4 Jul 2025 14:26:00 +0800
Message-ID: <20250704062602.33500-4-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250704062602.33500-1-lizhe.67@bytedance.com>
References: <20250704062602.33500-1-lizhe.67@bytedance.com>
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



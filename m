Return-Path: <kvm+bounces-49580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35A54ADA9E7
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 09:53:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F0333A9E83
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 07:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3534211484;
	Mon, 16 Jun 2025 07:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="IWJK+0wG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801E31494C2
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 07:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750060394; cv=none; b=fJfZruLMEfTegMTEWB5D/FUFivqCiqp/EQgu0zgbjqegk9S+4vcpv7BjL+hhvhc9HmaAa7NBBGb03qqSUl53PL1Mp55U7rabc/cL8C1VHFDHFarZXg5sPJhUPREIcePL3Wc34at3ZJZsAmx5OAepiKB76GWAnmisGxk9O0+oqns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750060394; c=relaxed/simple;
	bh=uV3cHhXrkTvBqdB8VYyLYO8kapwhTK0/BJjfokGJUfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQUM1RJhxEDL89e44THCofrUMKod9tpo+MZIwQ7PfzP0FJzzjQnpIzuP818xdE0FBRZ/r8zjOI8KBuVBv994yteE1c5nbcksP8jX2pBiKvA+LThLAhu3dDD1CylPWsChsaj0Zsnfh+LWFUtET4+Boi3VqX8vmHHJi4iqSJdnlnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=IWJK+0wG; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b2f0faeb994so4652374a12.0
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 00:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750060392; x=1750665192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DSlkXQNydyRdWXir99epy9/y/pcz1kH+JURzeIlDKkA=;
        b=IWJK+0wGiTj7Ld36WfheEiPGYvP18BL2EZ97r80p+1e12oHPKDnNF7xg5RY9JE+u8X
         TaYGR925UK3fZix6/fP0LEjI1RhBPPqnGvHRAmRTCdfbO6Qli2wXOCDDoJCJWwW12+m8
         whnKhfjHh72G966uj5fsfPzJhvGtIaG7i8ipTL9JvY+Pk9K1JLM1y2WuzPYm54oq2NeI
         Nw7OJ686e6XIUbYH6LBWLP9O9KQcL0XjLvDyB155ApCF2TLzPbryHUEMM7XDlsB9qfAu
         OmxwggYFn/2Iejr1Yq+7/Tt56IeNLsGPgYpTLZKmWhz9I1wf02UXgJMlcI3+0skb4Q27
         iL6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750060392; x=1750665192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DSlkXQNydyRdWXir99epy9/y/pcz1kH+JURzeIlDKkA=;
        b=hrh/TYDPfoqzCKQVZr3ymoRAP/ssb+EEDwFLN7wEimEOpbcJRBf86XHMTvB8KLUH+T
         XVqhr2Iy1j8YuIuUHYiED3/9J5WIke7sWmo043sIAos473ND+ylDLJupHaD4jgbpcvTv
         J7VbatF1qpqXY/+8/5gcrfQTDy+Kkza1481h3sUuIsnzRoZZL2Y9kU3ffFy727nktI3T
         TZYiEYmIBLYkcmXfu/djzlzs6OR0b9yumIeCdPlqjnk9pEvLIc4bK7tYA9y4tho2RekB
         paOto3Gs0o44geUiEaRDUC6Pkq+RnlEW9x1T3Bs5hD2vjuIwrD8dlrZVnybI3Of8KRRi
         0Qog==
X-Gm-Message-State: AOJu0YyrbGIyEpH+e7rA+nq5egYcl+EzXqltLiduiJqb5DdMcAD2fTrL
	0n4gh1cqxQxmElO4+KQnUcbyEf1vmevXqZ9/LJprn0OJ4mQ+GNOX18KaHEDhnWMdy8c=
X-Gm-Gg: ASbGncuIy598WnbFKuBbJ8s57YNjDNf+I/sZeDn6e2+NiairjwiysWtixav34fi4aky
	kn5/SAjzBpW/AiAu84mZcO+3g6KyCJ00Fsm5EHIUvEnFefclhA3dAYoo4uag6lMXh8cN0aDbrfG
	KJI3ERoC05p0Ctsv59ClaaAjP6NWm7xz01NRzaBjPB3RTGPBVWvH5jMJ3IDYA6lw+FtQrwjbyBi
	iHYp3192MWGtFBCxlXrpI1TQVwDuBhigOvGsjiPmLwvpJE6B5eIS6NkW7Ij+qdmYIdfJ9R1mTIy
	Zepup14OiwYtnUJbYaOIKB7ro/dWcYTaON6EIu0cDJCny4HNVsIo6J0OlmsBkPewvatLCzKQmgq
	yd8Div61oOjEpLw==
X-Google-Smtp-Source: AGHT+IFkQq+r+R5vPmo66EJyLVVT4eyNNzFZY8X02FLwCwquyWl/ce/oM9dxva7DNQF336iW+fZi4g==
X-Received: by 2002:a17:903:1c5:b0:235:eb71:a398 with SMTP id d9443c01a7336-2366b3e0352mr136058955ad.53.1750060391791;
        Mon, 16 Jun 2025 00:53:11 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.13])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365d88be76sm55179045ad.32.2025.06.16.00.53.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 16 Jun 2025 00:53:11 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	david@redhat.com,
	peterx@redhat.com,
	lizhe.67@bytedance.com
Subject: [PATCH v3 1/2] vfio/type1: batch vfio_find_vpfn() in function vfio_unpin_pages_remote()
Date: Mon, 16 Jun 2025 15:52:50 +0800
Message-ID: <20250616075251.89067-2-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250616075251.89067-1-lizhe.67@bytedance.com>
References: <20250616075251.89067-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

This patch is based on patch 'vfio/type1: optimize
vfio_pin_pages_remote() for large folios'[1].

The function vpfn_pages() can help us determine the number of vpfn
nodes on the vpfn rb tree within a specified range. This allows us
to avoid searching for each vpfn individually in the function
vfio_unpin_pages_remote(). This patch batches the vfio_find_vpfn()
calls in function vfio_unpin_pages_remote().

[1]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 drivers/vfio/vfio_iommu_type1.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 28ee4b8d39ae..e952bf8bdfab 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -805,16 +805,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
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



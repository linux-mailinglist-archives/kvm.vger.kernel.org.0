Return-Path: <kvm+bounces-36105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DF6FA17D06
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 12:29:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D86C161305
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 11:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D8521F1920;
	Tue, 21 Jan 2025 11:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XJXg5s98"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23591BBBEA;
	Tue, 21 Jan 2025 11:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737458947; cv=none; b=MU4Lwja0LDvGhzmUQdrHJldEC1rwToLB4DJ3tILyPeCxGSEb71s1xdfb+pfhetAbZpnQZlFDd6SZZS3Sg03IkT0l842ZAfr7dyynMgP5ZaVOTlIJgnkVkuAgnlr2KOhaGWHc/DAvOYUy5KwbaeFql6o9TVxb4lCRH5Dk2A1G7/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737458947; c=relaxed/simple;
	bh=DtILGrM3+rfRXWqQcTGk9nG1XMGIAOFuySX5/0Wg8L0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZM6C+bC+SgmZ6s/ST1T61HkWNWJfAvT4YlBm2H6kmkeI6EITep9pCxlkNdf8mniWCczkQRLHgxHywip8FSKmwdVAFY2mxQUlKAmTk7NwOa9+gwuMq927iE3xlY7F9rAP5ldPeb/YUvq50fosVu++6MgxcZ9zn8xPO6J0KR/49Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XJXg5s98; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21644aca3a0so121499545ad.3;
        Tue, 21 Jan 2025 03:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737458945; x=1738063745; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WXagEzywweo8G/6OstGzvbkfhs6k8bp2kHQoB/L2HB8=;
        b=XJXg5s98lOGoxQDd0O6MGNLUGuQTX9v8N8CsRh8JWUxETwYaNvpPZjx2ErVRS2wPi3
         1d5wHQV+VT6pNHdepGlOf1g6iEDKXvw4nh10cnPfk3gcK3hZu794vJZ3hKBJ3N87rPj2
         fFlPBJsPzsTmtqSgJQkfmkRHqKAdXzZhn2d40Oysin4L7SU7IXbAFGSuN4/uLl2999dY
         ZkpVrKwvzrQhfKLXzboXwkx+G067LCAIuUdhY9SyiHzkZA3hIAAX4ZTnqiFAsfANN7KR
         sR4d3ImLcTTPYY9PvR1pn7DWi/5yzii6Fufccjd3Ea/Sza1U7blwzGRJIn4wIswmff/P
         nGvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737458945; x=1738063745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WXagEzywweo8G/6OstGzvbkfhs6k8bp2kHQoB/L2HB8=;
        b=oN8I9k9U17fmpOgQM9PcXT1A2SfebcUvamhMX3dOYGWnPY4UBdng/GSHDXVZiBuQ3J
         C5cyyMNs9Q1rWZDJELLFPZEAl1ifkFsUidQ8SRqSApqpzJrmC8t2Mgnyl12M1mxBNTLJ
         nLtlD3c1Gui5LZVGZb8YGPs6DZfwvjjQ9VTmt1aJFwukQbxWeFLGAQGMH+/GYrXF3sXp
         UXIWvGflShecCLcwgaV79wIPSRksKDKmm0b7RtiLPqgXbD5v8626Qv0nMblDA8UwMu30
         LEWZtq425hGF/Ahyao9MIMVdBv5g0T7C1GPwuX0mMj8In9rC2bgzkfP7Ka/TZUCwQ1av
         Q+cQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJF+NvEPYVxMQ/fJ2vf1Sx1gevWqsOLaLqYdveO5Ow4xEhhqnqj0mjafeDrjucIdJTehSk5EMlme3ZZlkZ@vger.kernel.org, AJvYcCVRfFXwYAjPk19kintxaOP8NV/yudM8ZzRHK5rxNNUFG41jq9ZvRIJSdE1BrtR6Ckk9C5g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwoWp2ovKzYGYxnmLc/iw1buNo4MVvtamHbCQEX+sQEmeFWH9R
	cpKvucRYjyh5OAnslzAWO5naooS+6/0i/bsVNqvvybcwVd7AiSbs
X-Gm-Gg: ASbGncviRxjGpvbBo94koREr8bBloQH0ttIw1dgXsbB7judF61YY5pfLdcpI3k3fBNz
	zqlVQYtp7IbJ0ag9RlUBaIZzClwixSZTmJuCfHP/vW3Mj+4HDFBTfKo7sMsw9ooU3OWLc5AB//W
	JIdF2vZ/y7pVCh+SHARFWsUniuFySfH6w8qhulexr9+x0R0APvV5WkeEK/y4r/sGovA3FGk6LxA
	npzg9/lHyME878cwJWbTwq3GpIhCJZlWsUxp8PPUp04A3m9sbhOa/rStGu2nuegBXoQ5X/O20Mq
	MX7QgSYD
X-Google-Smtp-Source: AGHT+IH6fqnSkGAu0RzR1hL/8eMgnirYGIBDu4gvagajjQRKR4xYSTPHDLM/zXZ9hh02Fhhkq69ucQ==
X-Received: by 2002:a17:902:f7ce:b0:215:773a:c168 with SMTP id d9443c01a7336-21c352de425mr254278285ad.1.1737458945192;
        Tue, 21 Jan 2025 03:29:05 -0800 (PST)
Received: from tiger.hygon.cn ([112.64.138.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2cea1fdesm75385965ad.26.2025.01.21.03.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 03:29:04 -0800 (PST)
From: Wencheng Yang <east.moutain.yang@gmail.com>
To: east.moutain.yang@gmail.com,
	alex.williamson@redhat.com,
	jgg@ziepe.ca
Cc: iommu@lists.linux.dev,
	joro@8bytes.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	robin.murphy@arm.com,
	suravee.suthikulpanit@amd.com,
	will@kernel.org
Subject: [PATCH v3 2/3] vfio/vfio_iommu_type1:convert VFIO_DMA_MAP_FLAG_MMIO to IOMMU_MMIO flag
Date: Tue, 21 Jan 2025 19:28:35 +0800
Message-ID: <20250121112836.525046-2-east.moutain.yang@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250121112836.525046-1-east.moutain.yang@gmail.com>
References: <CALrP2iW11zHNVWCz3JXjPHxyJ=j3FsVdTGetMoxQvmNZo2X_yQ@mail.gmail.com>
 <20250121112836.525046-1-east.moutain.yang@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refer to commit: 31e6850e0fdb iommu: Add MMIO mapping type (Robin Murphy),
IOMMU needs to know the type of mapping to setup IOMMU page table,
if the mapping is for device MMIO region, on some platforms, IOMMU page
table entry attrs should be different versus regular memory.

Signed-off-by: Wencheng Yang <east.moutain.yang@gmail.com>
---
 drivers/vfio/vfio_iommu_type1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 50ebc9593c9d..08be1ef8514b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1557,6 +1557,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		prot |= IOMMU_WRITE;
 	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
 		prot |= IOMMU_READ;
+    if (map->flags & VFIO_DMA_MAP_FLAG_MMIO)
+        prot |= IOMMU_MMIO;
 
 	if ((prot && set_vaddr) || (!prot && !set_vaddr))
 		return -EINVAL;
@@ -2801,7 +2803,7 @@ static int vfio_iommu_type1_map_dma(struct vfio_iommu *iommu,
 	struct vfio_iommu_type1_dma_map map;
 	unsigned long minsz;
 	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE |
-			VFIO_DMA_MAP_FLAG_VADDR;
+			VFIO_DMA_MAP_FLAG_VADDR | VFIO_DMA_MAP_FLAG_MMIO;
 
 	minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
-- 
2.43.0



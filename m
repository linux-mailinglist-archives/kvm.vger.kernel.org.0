Return-Path: <kvm+bounces-25032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18B3995EA38
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 09:18:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C33DF1F2181C
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 07:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 984EC13C669;
	Mon, 26 Aug 2024 07:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UXcf/bD9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3035913BC1B
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 07:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724656629; cv=none; b=XAPMHiZtsGdGd+cvzGrLs1tMep7Y0WC1rloj5ynDh5JxjJSay613/Vo8A6OWoK7ZQlKQzjYW1bfSLNBS2JsI0K4eRRW4tRDTWG+RVMRlwmOdmU4hL3y0DzlVFJQVOkyK1ZoIxg0EikRZo3zoCSga/sft0bsZM+tgSeJUxx64gDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724656629; c=relaxed/simple;
	bh=MZZj2SAvpagdGOtXPGGnDmJg+RAzKw+H3OQrffzD+8w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MMJu1S6/k6Qcwy82o36hg+BChgeIWUsf+6tMAlGRdnSMJNHqklXwNoYzjSeLPxn+6FdiOh4QhQXmsaqoqXC1r7KHMzTe6zp7ph+vrPx4059NjG0AGyq9vXlbZvnkyIUU4+waIoVmgCLj/D91E6LV7ugOXJc32nTkJhqBBgTQ/sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--manojvishy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UXcf/bD9; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--manojvishy.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6b198ecf931so50453957b3.1
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 00:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724656626; x=1725261426; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=glhE4wUH8upwh3h840zUvzyaLndPAI9WWeySK76KAe4=;
        b=UXcf/bD9d6JZBbxuUTzPYT8zpr4pYMPLj8VX0tGZHpyA2VbKkuvrmS2um2l/mwJDeH
         Leay1xl6dfAHMzrW1HnFf77Qh3jjMOuUtJzp3kEF57furKynJzGY1TZqdzITq+s1AFHa
         IJW8QwuMv5JXbTDt7ZAUT82FGnE/NjcbyUUI/sBu9zPjh7QAKCrABhCxV2zJKXq8PsBR
         iDybzlVeBNuO5T4rAYcenFqVKAerfMfW8J0zybLT5qdmq19ijebqhLQPEvrQ/XdPdUQ3
         RmAiTlM4nrQvvJgm4ejxgJaVl6Ie26IH5DUBtHdRBUvQbPeoJ1afszizfzDT0tDMNHVT
         h2aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724656626; x=1725261426;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=glhE4wUH8upwh3h840zUvzyaLndPAI9WWeySK76KAe4=;
        b=LLDhMpLLCZwWLvhjR+WSVmTmuldvbOiIlTs1zbHQEOODK58qmENb92AeEcAiJjZ73G
         AiO7Uq/2m4e+gacp0FoUGQyBnDXXR5rvLT7HinO1THfW/DfugX9tjkzMuUg1BLH9ZWTc
         oVqiGh+REx/FT/dBXHhZH0HLiJ2Mx6zpVHEchtk2AcWedviNAgq896G+o5LM1wsXs0H9
         IxHdYns3ZASNjEQEvfGhLolVALY2vfrqBxJml2ukgVS7R9t/aMOet5ToDeFrbyggRIa8
         8w/9STcUBQ/RzeEEGqVcNC2dNJ0ZrEZh2VnvfG9Bq/KiDdrhiMhcxCSU5VWj6PbLogrQ
         auUg==
X-Gm-Message-State: AOJu0YzU59+rn1z35q7yBg6pv8A4JHNnHrTmMqf2saeiR72fVKUOeOt+
	NorGTLDHs/knCvdLGqAXZbNNYT/ea419tdWOur7CFUzK2bje5UDVJGqo8+e/3Cz8pLKpppGXOUU
	P7GMz3v4ZvP6gyfF2Ww==
X-Google-Smtp-Source: AGHT+IHNO2NOT8z5pjPX4FeBdIeAVLHmjqUYd3PJJUwIcYAFNDV3F2bzyhnKkfV2wlyMcU549dbh9KtZHmBsNHWt
X-Received: from manojvishy.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:413f])
 (user=manojvishy job=sendgmr) by 2002:a25:aa85:0:b0:e11:593b:b8e7 with SMTP
 id 3f1490d57ef6-e17a7a6905amr147799276.3.1724656626199; Mon, 26 Aug 2024
 00:17:06 -0700 (PDT)
Date: Mon, 26 Aug 2024 07:16:41 +0000
In-Reply-To: <20240826071641.2691374-1-manojvishy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240826071641.2691374-1-manojvishy@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240826071641.2691374-5-manojvishy@google.com>
Subject: [PATCH v1 4/4] vfio/type1: Add support for VFIO_DMA_MAP_FLAG_SYS_CACHE
From: Manoj Vishwanathan <manojvishy@google.com>
To: Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Joerg Roedel <joro@8bytes.org>, Alex Williamson <alex.williamson@redhat.com>, 
	linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	David Dillow <dillow@google.com>, Manoj Vishwanathan <manojvishy@google.com>
Content-Type: text/plain; charset="UTF-8"

Introducing the VFIO_DMA_MAP_FLAG_SYS_CACHE flag to control
whether mapped DMA regions are cached in the system cache.

Signed-off-by: Manoj Vishwanathan <manojvishy@google.com>
---
 drivers/vfio/vfio_iommu_type1.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0960699e7554..c84bb6c8b12f 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1562,7 +1562,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		prot |= IOMMU_WRITE;
 	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
 		prot |= IOMMU_READ;
-
+	if (map->flags & VFIO_DMA_MAP_FLAG_SYS_CACHE)
+		prot |= IOMMU_SYS_CACHE;
 	if ((prot && set_vaddr) || (!prot && !set_vaddr))
 		return -EINVAL;
 
@@ -2815,7 +2816,7 @@ static int vfio_iommu_type1_map_dma(struct vfio_iommu *iommu,
 	struct vfio_iommu_type1_dma_map map;
 	unsigned long minsz;
 	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE |
-			VFIO_DMA_MAP_FLAG_VADDR;
+			VFIO_DMA_MAP_FLAG_SYS_CACHE | VFIO_DMA_MAP_FLAG_VADDR;
 
 	minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
-- 
2.46.0.295.g3b9ea8a38a-goog



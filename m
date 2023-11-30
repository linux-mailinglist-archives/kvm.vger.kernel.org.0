Return-Path: <kvm+bounces-3020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04B8E7FFBFF
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 21:09:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35E341C20D00
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 20:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8150D53E25;
	Thu, 30 Nov 2023 20:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="b5FIJOpV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71671B9
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 12:09:04 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-41ea8debcdaso7851871cf.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 12:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1701374943; x=1701979743; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Be1KAg53A/Objdu3EOp617iDWrhswh7WogUdBagnrZg=;
        b=b5FIJOpVYc3V2YCNIasCpGTREL3vAWocW8+79kcTkTMx0nfDV+HD1T2xJmBet1i9pu
         rVyOq8XG7n6Y/YO4R9V6zuM9DjmwvNKMyeMoWrsmjDuN3tINbzflZJPjwVf+jr4PbdZa
         yukFQo/OaZti3gowl5KJ5X3bJHheD0ukYFVwvOlxjgip4PrdFNyJAZajeCT1qRgZHCpo
         Ria6nd/mH3TdWGxB+WsXFnBUSNOLBMzlkjOF4waX+eeEAC6dcHAA1b9aylAVkWsGekpC
         4/LqhrdnoCeNX27w376QS/KneCBtzpm67TgBRyPc1Un7CiwmwzpDC9OHN+EaTjmTqEm7
         9mBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701374943; x=1701979743;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Be1KAg53A/Objdu3EOp617iDWrhswh7WogUdBagnrZg=;
        b=Q/4scVQwXPmhilcwlKd8x7nwhhUWyEJIbkSP2bExwnFRjtaSHMU2w8cSpvnfUB+bbx
         IqN3wb9UriOBp7W1ZutSr1GAMmFfQSLmA8pZBXd09P4Qp0AtOu6FFT9g0qoQqx5O3PIH
         6h4fKls1WdHMV/OqtCPc62Pbq7AMdpn20jgWKvSdX5BCic/lzUpHIvScsy6776vaqdkW
         H2RybA8iML8eAp1Tiw5gAnhsqewbwlcnAZHur8bYbzRo01Acn8nVsd8pQz8qeYNHFBLL
         MJx7sqpym8GhpvOiZ8fkM6tfGOuZriIQ2feF8zTPJRNoPVzJUnz3d/rkTQIT3FLxPmY3
         qIqw==
X-Gm-Message-State: AOJu0YwHK/4PuNRmPMWJ+F6QKxUSApgACgjfozalg2GwssJ+hyXr/XEB
	dcyjLAU/88bXm7gmrF3aXPCJKw==
X-Google-Smtp-Source: AGHT+IGyZ1MVJbpF5QMDxLNeNlkaL79u3htakyAB6E9jsA5aoQ8faIPkDh3Pm0do6EH90LCTcQ3f/g==
X-Received: by 2002:a05:622a:1389:b0:41e:1d15:69a6 with SMTP id o9-20020a05622a138900b0041e1d1569a6mr28803241qtk.31.1701374943507;
        Thu, 30 Nov 2023 12:09:03 -0800 (PST)
Received: from soleen.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id c7-20020ac86e87000000b0041cb8947ed2sm786258qtv.26.2023.11.30.12.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 12:09:03 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	pasha.tatashin@soleen.com,
	alex.williamson@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] vfio: account iommu allocations
Date: Thu, 30 Nov 2023 20:09:00 +0000
Message-ID: <20231130200900.2320829-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iommu allocations should be accounted in order to allow admins to
monitor and limit the amount of iommu memory.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 drivers/vfio/vfio_iommu_type1.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

This patch is spinned of from the series:
https://lore.kernel.org/all/20231128204938.1453583-1-pasha.tatashin@soleen.com

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index eacd6ec04de5..b2854d7939ce 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1436,7 +1436,7 @@ static int vfio_iommu_map(struct vfio_iommu *iommu, dma_addr_t iova,
 	list_for_each_entry(d, &iommu->domain_list, next) {
 		ret = iommu_map(d->domain, iova, (phys_addr_t)pfn << PAGE_SHIFT,
 				npage << PAGE_SHIFT, prot | IOMMU_CACHE,
-				GFP_KERNEL);
+				GFP_KERNEL_ACCOUNT);
 		if (ret)
 			goto unwind;
 
@@ -1750,7 +1750,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 			}
 
 			ret = iommu_map(domain->domain, iova, phys, size,
-					dma->prot | IOMMU_CACHE, GFP_KERNEL);
+					dma->prot | IOMMU_CACHE,
+					GFP_KERNEL_ACCOUNT);
 			if (ret) {
 				if (!dma->iommu_mapped) {
 					vfio_unpin_pages_remote(dma, iova,
@@ -1845,7 +1846,8 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *
 			continue;
 
 		ret = iommu_map(domain->domain, start, page_to_phys(pages), PAGE_SIZE * 2,
-				IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE, GFP_KERNEL);
+				IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE,
+				GFP_KERNEL_ACCOUNT);
 		if (!ret) {
 			size_t unmapped = iommu_unmap(domain->domain, start, PAGE_SIZE);
 
-- 
2.43.0.rc2.451.g8631bc7472-goog



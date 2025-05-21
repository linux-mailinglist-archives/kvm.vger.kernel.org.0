Return-Path: <kvm+bounces-47217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D624BABEA7F
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 05:47:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B62103B80B9
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 03:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD05E22DFA7;
	Wed, 21 May 2025 03:47:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8979B125D6;
	Wed, 21 May 2025 03:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747799257; cv=none; b=IGLIQAiiMJD9+MWqgx9jb/zckJHqLLQj71i4ZwM5kBkQZGfoQm2QrUqoqeQZjp5Bq5NlP1G9zKKFP0WW1ovPItJneFBrTdedo+AkoBLj50VTtcW5LBtlQOB7jPtaUKtuKkBOdflREJFz8FZDTj1cG4X9pdrRr6CCkX2ZGFMESE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747799257; c=relaxed/simple;
	bh=scoXlmc+F0clhdkke8G66hbM+VSuWs0kzFoGtA/DhT0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=l51vr5yaWLianragFEFmvaprhrthYppE4Pqy9V1vfygIZ28p90dAEdSTpS5R1KJoKw7sMN61ibq115MqBUnq/WFc1XX5haE3RPeGAJa+PH+13xdqtRLn058hWoHhBxmX3v35JF6/3aMHYbhv0wqAQQ25juRYV6o5AAJ6voSyt+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: <alex.williamson@redhat.com>, <kwankhede@nvidia.com>,
	<yan.y.zhao@intel.com>, <cjia@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] vfio/type1: fixed rollback in vfio_dma_bitmap_alloc_all()
Date: Wed, 21 May 2025 11:46:47 +0800
Message-ID: <20250521034647.2877-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: BC-Mail-Ex15.internal.baidu.com (172.31.51.55) To
 BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex15_2025-05-21 11:46:54:611
X-FEAS-Client-IP: 10.127.64.38
X-FE-Policy-ID: 52:10:53:SYSTEM

From: Li RongQing <lirongqing@baidu.com>

The vfio dma bitmap of p should be freed, not n

Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0ac5607..ba5d91e 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -293,7 +293,7 @@ static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
 			struct rb_node *p;
 
 			for (p = rb_prev(n); p; p = rb_prev(p)) {
-				struct vfio_dma *dma = rb_entry(n,
+				struct vfio_dma *dma = rb_entry(p,
 							struct vfio_dma, node);
 
 				vfio_dma_bitmap_free(dma);
-- 
2.9.4



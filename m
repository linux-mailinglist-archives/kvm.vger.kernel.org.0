Return-Path: <kvm+bounces-47936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BA58AC77F1
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 07:44:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5296AA4174A
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09C125A62B;
	Thu, 29 May 2025 05:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LoO2Vo3f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D900259CA9;
	Thu, 29 May 2025 05:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748497331; cv=none; b=UUyVkZpj+8n1Fvs6bBU0V+HGZh6paPMzQmvb6VEHvax0/eeM6Lhttip5boN0AxpkaGUzYOzQmcu4hbc/eG0ksYLrVvCRQXl0+PoKJTBHGQvYRFLeExz4iGO6UaQTPINBgU7+D8yfgK8rUxQQPP51rfPvhse9kjqixd015FJ6F+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748497331; c=relaxed/simple;
	bh=SszxCmsQ/alnLjPMaj/qHpVpVa5oHlCJl3O95fFvP8o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KZUlmk54ogw0GW1qSK4Q9/5CR5lxlZVgOS/CdG3YA3cqcjb/3yU05WWWWqREjcCcKC516QdS7P9xBlRP+po5n/BFi6ycwWYlh9qX6kXnYm+Ya5lDMeHO8fbu2BCi6EkvrTVonfxFcuj8ow5Iw8LQclPQC3DF22ONihxyZyOvJy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LoO2Vo3f; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748497331; x=1780033331;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SszxCmsQ/alnLjPMaj/qHpVpVa5oHlCJl3O95fFvP8o=;
  b=LoO2Vo3fV7n2BunwX1rdMkVOXuelDaX0YsqTNQun7eHl0ph9t2i2xrZX
   /VdQaZAhew8fjKccU+4Ykur4PGoRQF9HzVkASz8vUzaAWh2G8xfqAz4yB
   5pBi6H9XLx7Kim5Rhhle5J4o7aEJuT+5uqaLvkgb6voJUiuXgNDR8Mcxk
   IU0hwO4B34rb1ryNF8bvWAHqBZO+4eOKQC1Bi7ItxxXrpJIIjyJ8OyQ1k
   O2xsw8bZs66z5p/e1SmUZZcajk53mw6Qo29iUVsFuY8KyD3jZeEE4Js6a
   UGAjxyJYKq3UZKG35tHjYxYc2154UNhuE77rIWQwJxG5O13cGr21kGgWW
   g==;
X-CSE-ConnectionGUID: UdAqw97RRIGTfcj6s9KU8w==
X-CSE-MsgGUID: VwBmHPeJTFmtJGQQJsRYDw==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="67962958"
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="67962958"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 22:42:10 -0700
X-CSE-ConnectionGUID: eCitUIkpQa2RjTiX6bzOHQ==
X-CSE-MsgGUID: gVKSKMYHTUWyYpK329M9qA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="144443296"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2025 22:42:04 -0700
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	dan.j.williams@intel.com,
	aik@amd.com,
	linux-coco@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com,
	yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com,
	linux-pci@vger.kernel.org,
	zhiw@nvidia.com,
	simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com,
	aneesh.kumar@kernel.org,
	iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: [RFC PATCH 05/30] fixup! vfio/pci: fix dma-buf revoke typo on reset
Date: Thu, 29 May 2025 13:34:48 +0800
Message-Id: <20250529053513.1592088-6-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixed the patch:

  vfio/pci: Allow MMIO regions to be exported through dma-buf

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index efccbb2d2a42..7ac062bd5044 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -911,7 +911,7 @@ static int vfio_exp_config_write(struct vfio_pci_core_device *vdev, int pos,
 			vfio_pci_dma_buf_move(vdev, true);
 			pci_try_reset_function(vdev->pdev);
 			if (__vfio_pci_memory_enabled(vdev))
-				vfio_pci_dma_buf_move(vdev, true);
+				vfio_pci_dma_buf_move(vdev, false);
 			up_write(&vdev->memory_lock);
 		}
 	}
@@ -996,7 +996,7 @@ static int vfio_af_config_write(struct vfio_pci_core_device *vdev, int pos,
 			vfio_pci_dma_buf_move(vdev, true);
 			pci_try_reset_function(vdev->pdev);
 			if (__vfio_pci_memory_enabled(vdev))
-				vfio_pci_dma_buf_move(vdev, true);
+				vfio_pci_dma_buf_move(vdev, false);
 			up_write(&vdev->memory_lock);
 		}
 	}
-- 
2.25.1



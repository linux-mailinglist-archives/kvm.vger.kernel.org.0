Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9736269A9A
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 02:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgIOAoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 20:44:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:45263 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbgIOAn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 20:43:58 -0400
IronPort-SDR: 1Up+GFju8envoAmLu3FoFsfvzgqvXumtNijq0y3iGibMAnvIiZKf7N2iVQFVg5QQz8Wvz6OZbh
 sIn+ZS/eW4bQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="156573620"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="156573620"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 17:43:55 -0700
IronPort-SDR: Sqrps9y2ydj609JLDQUfGitBQvgcxizdUXcJzRbozyNTCBtT1qTGIA+afnTIcv8tjcyHAojjK+
 OQXg9UpjAHtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="335468562"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga008.jf.intel.com with ESMTP; 14 Sep 2020 17:43:53 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] vfio/type1: fix dirty bitmap calculation in vfio_dma_rw
Date:   Tue, 15 Sep 2020 08:32:51 +0800
Message-Id: <20200915003251.14343-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

the count of dirtied pages is not only determined by count of copied
pages, but also by the start offset.

e.g. if offset = PAGE_SIZE - 1, and *copied=2, the dirty pages count is
2, instead of 0.

Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty
pages tracking")

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5fbf0c1f7433..d0438388feeb 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2933,7 +2933,8 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 			 * size
 			 */
 			bitmap_set(dma->bitmap, offset >> pgshift,
-				   *copied >> pgshift);
+				   ((offset + *copied - 1) >> pgshift) -
+				   (offset >> pgshift) + 1);
 		}
 	} else
 		*copied = copy_from_user(data, (void __user *)vaddr,
-- 
2.17.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C17269A84
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 02:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgIOAl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 20:41:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:7242 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbgIOAls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 20:41:48 -0400
IronPort-SDR: IiWUILalpR7mKwqG4MjOQsNs/3M1AdZJEBoAGjLF8oF7770rIhRt92ohp+KEht3UsB9wW6H6Og
 lRAoDvC/QAIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="220737094"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="220737094"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 17:41:47 -0700
IronPort-SDR: UHdHRSDT6ynMHG/BOqPGJGlYkT48sgCUB/JPojSv8IWSFV7CfCxbwPvaIXCwiJMFSa8tjwsgxh
 JEgDLY7zLqiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="335468034"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga008.jf.intel.com with ESMTP; 14 Sep 2020 17:41:45 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] vfio: add a singleton check for vfio_group_pin_pages
Date:   Tue, 15 Sep 2020 08:30:42 +0800
Message-Id: <20200915003042.14273-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_pin_pages() and vfio_group_pin_pages() are used purely to mark dirty
pages to devices with IOMMU backend as they already have all VM pages
pinned at VM startup.
when there're multiple devices in the vfio group, the dirty pages
marked through pin_pages interface by one device is not useful as the
other devices may access and dirty any VM pages.

So added a check such that only singleton IOMMU groups can pin pages
in vfio_group_pin_pages. for mdevs, there's always only one dev in a
vfio group.
This is a fix to the commit below that added a singleton IOMMU group
check in vfio_pin_pages.

Fixes: 95fc87b44104 (vfio: Selective dirty page tracking if IOMMU backed
device pins pages)

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/vfio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 5e6e0511b5aa..2f0fa272ebf2 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2053,6 +2053,9 @@ int vfio_group_pin_pages(struct vfio_group *group,
 	if (!group || !user_iova_pfn || !phys_pfn || !npage)
 		return -EINVAL;
 
+	if (group->dev_counter > 1)
+		return  -EINVAL;
+
 	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
 		return -E2BIG;
 
-- 
2.17.1


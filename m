Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A76D26BA4B
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 04:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgIPClp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 22:41:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:17839 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbgIPClp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 22:41:45 -0400
IronPort-SDR: cYuKMYz4px8i0wZ/lRCMk7uQndwo7kdffUlX9VByWknnLA5niweuc/C0piifeUJJhqd84hcW0d
 ff2NfzQftp4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="158667533"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="158667533"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 19:41:43 -0700
IronPort-SDR: WvYV8c7liVIQ9zCjn3jIyAHwjA96a9TXWHx0PHavH7nGVbLaikka5HSnwL6bBZCVJ81GKPdzE8
 54weBgBOa3sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="335875192"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga008.jf.intel.com with ESMTP; 15 Sep 2020 19:41:41 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2] vfio: add a singleton check for vfio_group_pin_pages
Date:   Wed, 16 Sep 2020 10:28:33 +0800
Message-Id: <20200916022833.26304-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Page pinning is used both to translate and pin device mappings for DMA
purpose, as well as to indicate to the IOMMU backend to limit the dirty
page scope to those pages that have been pinned, in the case of an IOMMU
backed device.
To support this, the vfio_pin_pages() interface limits itself to only
singleton groups such that the IOMMU backend can consider dirty page
scope only at the group level.  Implement the same requirement for the
vfio_group_pin_pages() interface.

Fixes: 95fc87b44104 ("vfio: Selective dirty page tracking if IOMMU backed device pins pages")

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

---
v2:
1. updated the commit message to declare the issue clearly. (Alex)
2. updated the format of the Fixes: line.
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


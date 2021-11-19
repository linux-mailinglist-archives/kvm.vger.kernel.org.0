Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288C0456B6C
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 09:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbhKSIR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 03:17:26 -0500
Received: from mga06.intel.com ([134.134.136.31]:27212 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232838AbhKSIRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 03:17:25 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="295193522"
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="295193522"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 00:14:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="647090238"
Received: from debian-skl.sh.intel.com ([10.239.160.66])
  by fmsmga001.fm.intel.com with ESMTP; 19 Nov 2021 00:14:22 -0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     Colin Xu <colin.xu@gmail.com>, Dmitry Torokhov <dtor@chromium.org>
Subject: [PATCH] vfio/pci: Fix OpRegion read
Date:   Fri, 19 Nov 2021 16:14:35 +0800
Message-Id: <20211119081435.3237699-1-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is to fix incorrect pointer arithmetic which caused wrong
OpRegion version returned, then VM driver got error to get wanted
VBT block. We need to be safe to return correct data, so force
pointer type for byte access.

Fixes: 49ba1a2976c8 ("vfio/pci: Add OpRegion 2.0+ Extended VBT support.")
Cc: Colin Xu <colin.xu@gmail.com>
Cc: Dmitry Torokhov <dtor@chromium.org>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 drivers/vfio/pci/vfio_pci_igd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 56cd551e0e04..dad6eeed5e80 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -98,7 +98,7 @@ static ssize_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev,
 			version = cpu_to_le16(0x0201);
 
 		if (igd_opregion_shift_copy(buf, &off,
-					    &version + (pos - OPREGION_VERSION),
+					    (u8 *)&version + (pos - OPREGION_VERSION),
 					    &pos, &remaining, bytes))
 			return -EFAULT;
 	}
@@ -121,7 +121,7 @@ static ssize_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev,
 					  OPREGION_SIZE : 0);
 
 		if (igd_opregion_shift_copy(buf, &off,
-					    &rvda + (pos - OPREGION_RVDA),
+					    (u8 *)&rvda + (pos - OPREGION_RVDA),
 					    &pos, &remaining, bytes))
 			return -EFAULT;
 	}
-- 
2.33.1


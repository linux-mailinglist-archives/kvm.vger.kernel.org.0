Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC2345D415
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 06:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhKYFWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 00:22:17 -0500
Received: from mga18.intel.com ([134.134.136.126]:3688 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232989AbhKYFUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 00:20:16 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="222316702"
X-IronPort-AV: E=Sophos;i="5.87,262,1631602800"; 
   d="scan'208";a="222316702"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 21:13:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,262,1631602800"; 
   d="scan'208";a="591829833"
Received: from debian-skl.sh.intel.com ([10.239.160.66])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Nov 2021 21:13:02 -0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     Colin Xu <colin.xu@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Dmitry Torokhov <dtor@chromium.org>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Gao, Fred" <fred.gao@intel.com>
Subject: [PATCH] vfio/pci: Fix OpRegion read
Date:   Thu, 25 Nov 2021 13:13:28 +0800
Message-Id: <20211125051328.3359902-1-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <CAB4daBTAci-ygY0sXbK7v8x84r7Q33WGunKLYjR8jQNjt4BZNQ@mail.gmail.com>
References: <CAB4daBTAci-ygY0sXbK7v8x84r7Q33WGunKLYjR8jQNjt4BZNQ@mail.gmail.com>
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
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Dmitry Torokhov <dtor@chromium.org>
Cc: "Xu, Terrence" <terrence.xu@intel.com>
Cc: "Gao, Fred" <fred.gao@intel.com>
Acked-by: Colin Xu <colin.xu@gmail.com>
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


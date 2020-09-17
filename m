Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2A126D1E5
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 05:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgIQDs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 23:48:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12772 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726118AbgIQDs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 23:48:26 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DE49E15AE79EDA874EF2;
        Thu, 17 Sep 2020 11:32:18 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.226) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 11:32:08 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <wanghaibin.wang@huawei.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 2/2] vfio/pci: Remove bardirty from vfio_pci_device
Date:   Thu, 17 Sep 2020 11:31:28 +0800
Message-ID: <20200917033128.872-2-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20200917033128.872-1-yuzenghui@huawei.com>
References: <20200917033128.872-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It isn't clear what purpose the @bardirty serves. It might be used to avoid
the unnecessary vfio_bar_fixup() invoking on a user-space BAR read, which
is not required when bardirty is unset.

The variable was introduced in commit 89e1f7d4c66d ("vfio: Add PCI device
driver") but never actually used, so it shouldn't be that important. Remove
it.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 drivers/vfio/pci/vfio_pci_config.c  | 7 -------
 drivers/vfio/pci/vfio_pci_private.h | 1 -
 2 files changed, 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index d98843feddce..e93b287fea02 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -507,8 +507,6 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
 		*vbar &= cpu_to_le32((u32)mask);
 	} else
 		*vbar = 0;
-
-	vdev->bardirty = false;
 }
 
 static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
@@ -633,9 +631,6 @@ static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
 		}
 	}
 
-	if (is_bar(offset))
-		vdev->bardirty = true;
-
 	return count;
 }
 
@@ -1697,8 +1692,6 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 	if (ret)
 		goto out;
 
-	vdev->bardirty = true;
-
 	/*
 	 * XXX can we just pci_load_saved_state/pci_restore_state?
 	 * may need to rebuild vconfig after that
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 61ca8ab165dc..dc96a0fda548 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -122,7 +122,6 @@ struct vfio_pci_device {
 	bool			virq_disabled;
 	bool			reset_works;
 	bool			extended_caps;
-	bool			bardirty;
 	bool			has_vga;
 	bool			needs_reset;
 	bool			nointx;
-- 
2.19.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B8C271A35
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 06:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgIUEvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 00:51:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13736 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726011AbgIUEvk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 00:51:40 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EBD527101C9BF283D53A;
        Mon, 21 Sep 2020 12:51:37 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.226) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 12:51:29 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <wanghaibin.wang@huawei.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 2/2] vfio/pci: Don't regenerate vconfig for all BARs if !bardirty
Date:   Mon, 21 Sep 2020 12:51:16 +0800
Message-ID: <20200921045116.258-2-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20200921045116.258-1-yuzenghui@huawei.com>
References: <20200921045116.258-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now we regenerate vconfig for all the BARs via vfio_bar_fixup(), every time
any offset of any of them are read. Though BARs aren't re-read regularly,
the regeneration can be avoid if no BARs had been written since they were
last read, in which case the vdev->bardirty is false.

Let's predicate the vfio_bar_fixup() on the bardirty so that it can return
immediately if !bardirty.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
* From v1:
  - Per Alex's suggestion, let vfio_bar_fixup() test vdev->bardirty to
    avoid doing work if bardirty is false, instead of removing it entirely.
  - Rewrite the commit message.

 drivers/vfio/pci/vfio_pci_config.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index d98843feddce..5e02ba07e8e8 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -467,6 +467,9 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
 	__le32 *vbar;
 	u64 mask;
 
+	if (!vdev->bardirty)
+		return;
+
 	vbar = (__le32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
 
 	for (i = 0; i < PCI_STD_NUM_BARS; i++, vbar++) {
-- 
2.19.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA4611867
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 13:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfEBLs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 07:48:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbfEBLs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 07:48:57 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C60D73082E8E;
        Thu,  2 May 2019 11:48:56 +0000 (UTC)
Received: from maximlenovopc.usersys.redhat.com (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13D2417DDF;
        Thu,  2 May 2019 11:48:51 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-nvme@lists.infradead.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "Paul E . McKenney " <paulmck@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liang Cunming <cunming.liang@intel.com>,
        Liu Changpeng <changpeng.liu@intel.com>,
        Fam Zheng <fam@euphon.net>, Amnon Ilan <ailan@redhat.com>,
        John Ferlan <jferlan@redhat.com>
Subject: [PATCH v2 05/10] nvme/pci: use the NVME_CTRL_SUSPENDED state
Date:   Thu,  2 May 2019 14:47:56 +0300
Message-Id: <20190502114801.23116-6-mlevitsk@redhat.com>
In-Reply-To: <20190502114801.23116-1-mlevitsk@redhat.com>
References: <20190502114801.23116-1-mlevitsk@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 02 May 2019 11:48:57 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When enteriing low power state, the nvme
driver will now inform the core with the NVME_CTRL_SUSPENDED state
which will allow mdev driver to act on this information

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 drivers/nvme/host/pci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 1c844c66ecaa..282f28c851c1 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2406,7 +2406,8 @@ static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown)
 		u32 csts = readl(dev->bar + NVME_REG_CSTS);
 
 		if (dev->ctrl.state == NVME_CTRL_LIVE ||
-		    dev->ctrl.state == NVME_CTRL_RESETTING)
+		    dev->ctrl.state == NVME_CTRL_RESETTING ||
+		    dev->ctrl.state == NVME_CTRL_SUSPENDED)
 			nvme_start_freeze(&dev->ctrl);
 		dead = !!((csts & NVME_CSTS_CFS) || !(csts & NVME_CSTS_RDY) ||
 			pdev->error_state  != pci_channel_io_normal);
@@ -2852,6 +2853,9 @@ static int nvme_suspend(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct nvme_dev *ndev = pci_get_drvdata(pdev);
 
+	if (!nvme_change_ctrl_state(&ndev->ctrl, NVME_CTRL_SUSPENDED))
+		WARN_ON(1);
+
 	nvme_dev_disable(ndev, true);
 	return 0;
 }
-- 
2.17.2


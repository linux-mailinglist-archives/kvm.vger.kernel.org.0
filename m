Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96051643CEC
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 06:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbiLFF7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 00:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbiLFF7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 00:59:07 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE7927140;
        Mon,  5 Dec 2022 21:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670306343; x=1701842343;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9CnQAmoATTPKUFpttCxBP0OKKTyZY2W0SyyLmyVLCtc=;
  b=m2gUfz2/TTX/k3a63KziwsFuG894D2E3LRLNIX28gQhFis6EtJAZi1aM
   6aO1ymb0Yq8FX7w6cNLvGRjeaqLX/vfhRcloON+ESzVxOLisVMypHlXKO
   sTL0ZTHh9xjbaM5/iW7oLgveH9fRtRrUdpwKUhEsg6C4oWj/Rqn8r18pb
   D5bM13ypNjE7p4y9olRN6U5WxjD6wXVAlOVSYlMwwaD4I+mWK3B+SF6Ic
   imcCP31KqIN3GAUILzxGj/oigphWzn7vd7dkGxtyipq5+aenabJvp+2hl
   F/S8ow0HsPPy+YlAXF9cT5OSH9eHxVRndNjrSzzP7P8C6S9pIZTwa5AZo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="378706716"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="378706716"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 21:58:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="648211408"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="648211408"
Received: from leirao-pc.bj.intel.com ([10.238.156.101])
  by fmsmga007.fm.intel.com with ESMTP; 05 Dec 2022 21:58:48 -0800
From:   Lei Rao <lei.rao@intel.com>
To:     kbusch@kernel.org, axboe@fb.com, kch@nvidia.com, hch@lst.de,
        sagi@grimberg.me, alex.williamson@redhat.com, cohuck@redhat.com,
        jgg@ziepe.ca, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org
Cc:     eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com,
        Lei Rao <lei.rao@intel.com>
Subject: [RFC PATCH 4/5] nvme-vfio: check if the hardware supports live migration
Date:   Tue,  6 Dec 2022 13:58:15 +0800
Message-Id: <20221206055816.292304-5-lei.rao@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206055816.292304-1-lei.rao@intel.com>
References: <20221206055816.292304-1-lei.rao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

NVMe device can extend the vendor-specific field in the identify
controller data structure to indicate whether live migration
is supported. This patch checks if the NVMe device supports
live migration.

Signed-off-by: Lei Rao <lei.rao@intel.com>
Signed-off-by: Yadong Li <yadong.li@intel.com>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Eddie Dong <eddie.dong@intel.com>
Reviewed-by: Hang Yuan <hang.yuan@intel.com>
---
 drivers/vfio/pci/nvme/nvme.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/vfio/pci/nvme/nvme.c b/drivers/vfio/pci/nvme/nvme.c
index 698e470a4e53..2ffc90ad556d 100644
--- a/drivers/vfio/pci/nvme/nvme.c
+++ b/drivers/vfio/pci/nvme/nvme.c
@@ -473,6 +473,36 @@ static void nvmevf_pci_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
+static bool nvmevf_check_migration(struct pci_dev *pdev)
+{
+	struct nvme_command c = { };
+	struct nvme_id_ctrl *id;
+	u8 live_mig_support;
+	int ret;
+
+	c.identify.opcode = nvme_admin_identify;
+	c.identify.cns = NVME_ID_CNS_CTRL;
+
+	id = kmalloc(sizeof(struct nvme_id_ctrl), GFP_KERNEL);
+	if (!id)
+		return false;
+
+	ret = nvme_submit_vf_cmd(pdev, &c, NULL, id, sizeof(struct nvme_id_ctrl));
+	if (ret) {
+		dev_warn(&pdev->dev, "Get identify ctrl failed (ret=0x%x)\n", ret);
+		goto out;
+	}
+
+	live_mig_support = id->vs[0];
+	if (live_mig_support) {
+		kfree(id);
+		return true;
+	}
+out:
+	kfree(id);
+	return false;
+}
+
 static const struct vfio_migration_ops nvmevf_pci_mig_ops = {
 	.migration_set_state = nvmevf_pci_set_device_state,
 	.migration_get_state = nvmevf_pci_get_device_state,
@@ -489,6 +519,10 @@ static int nvmevf_migration_init_dev(struct vfio_device *core_vdev)
 	if (!pdev->is_virtfn)
 		return ret;
 
+	/* Get the identify controller data structure to check the live migration support */
+	if (!nvmevf_check_migration(pdev))
+		return ret;
+
 	nvmevf_dev->migrate_cap = 1;
 
 	vf_id = pci_iov_vf_id(pdev);
-- 
2.34.1


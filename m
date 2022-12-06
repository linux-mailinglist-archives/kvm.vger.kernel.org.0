Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543C7643CE4
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 06:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiLFF6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 00:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233338AbiLFF6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 00:58:36 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E50C24F28;
        Mon,  5 Dec 2022 21:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670306315; x=1701842315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9tscb8eIosHw9BslFqEXbDs27VxieMXwgkEh6RsBQDE=;
  b=aHuBepdwiqmRB6NerVm44L6r7YWbGKK1kQGiyivS//+h3RfVSE+hwTGc
   TkbAk71WZwmMamn3kyDZrX8tmS9/+0uXOQvlkogI2BeOx3xdr804pgh7k
   lABz2NklRnytnEifZCkM/ZdejZ/9qL05XPbtdui6GHhRHd87HXddj0t9Z
   GkccAXwK22Su2jL2sCfgQIpJYjt05IDSOttuwpaC8gAoAdi6r0uu9v+1H
   QLUt0uv+iwww3tyF7YEi1rh7XuVzGVYFymQSw8XYRmrG9da7dTpySpf2W
   iEO7sEeGZWHp/qLQ9aDyp3kp4CM5LsyC8H/tSsJrxfLIRTqjUQ6bXyOpq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="378706621"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="378706621"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 21:58:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="648211267"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="648211267"
Received: from leirao-pc.bj.intel.com ([10.238.156.101])
  by fmsmga007.fm.intel.com with ESMTP; 05 Dec 2022 21:58:29 -0800
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
Subject: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to issue admin commands for VF driver.
Date:   Tue,  6 Dec 2022 13:58:12 +0800
Message-Id: <20221206055816.292304-2-lei.rao@intel.com>
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

The new function nvme_submit_vf_cmd() helps the host VF driver to issue
VF admin commands. It's helpful in some cases that the host NVMe driver
does not control VF's admin queue. For example, in the virtualization
device pass-through case, the VF controller's admin queue is governed
by the Guest NVMe driver. Host VF driver relies on PF device's admin
queue to control VF devices like vendor-specific live migration commands.

Signed-off-by: Lei Rao <lei.rao@intel.com>
Signed-off-by: Yadong Li <yadong.li@intel.com>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Eddie Dong <eddie.dong@intel.com>
Reviewed-by: Hang Yuan <hang.yuan@intel.com>
---
 drivers/nvme/host/pci.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 488ad7dabeb8..3d9c54d8e7fc 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3585,6 +3585,24 @@ static struct pci_driver nvme_driver = {
 	.err_handler	= &nvme_err_handler,
 };
 
+int nvme_submit_vf_cmd(struct pci_dev *dev, struct nvme_command *cmd,
+			      size_t *result, void *buffer, unsigned int bufflen)
+{
+	struct nvme_dev *ndev = NULL;
+	union nvme_result res = { };
+	int ret;
+
+	ndev = pci_iov_get_pf_drvdata(dev, &nvme_driver);
+	if (IS_ERR(ndev))
+		return PTR_ERR(ndev);
+	ret = __nvme_submit_sync_cmd(ndev->ctrl.admin_q, cmd, &res, buffer, bufflen,
+			      NVME_QID_ANY, 0, 0);
+	if (ret >= 0 && result)
+		*result = le32_to_cpu(res.u32);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvme_submit_vf_cmd);
+
 static int __init nvme_init(void)
 {
 	BUILD_BUG_ON(sizeof(struct nvme_create_cq) != 64);
-- 
2.34.1


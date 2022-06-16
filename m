Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DD654EE32
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 01:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378261AbiFPXxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 19:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379489AbiFPXx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 19:53:28 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2082.outbound.protection.outlook.com [40.107.101.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5644262CD0;
        Thu, 16 Jun 2022 16:53:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6SoMtY780l5Z2c87ko3cmO/yUjw+UPtZclBhdrauiJ6wpXdeKR4Sf2qhw+zRCO/NiS8+2uhbyx42e0/fLx9m151qVd6MRL+snsFRO9A6xt3lKCvp4VpiAvNcIYdBeNO/vRInKeLJx3jA89nt4Nl//GABdRwSmIZAjzHdW+7RvQi3LQHBzFKNxyrHqreQw4lbPMD/N0f7psEzQaJgPxvxwt2Io27+nK5QHloQZv2tv4vovwP129xRn6POCwYx146/9o+FSIGoxWHY9bQk2IP0/TxAtw4ChjIVvEbOEbJ/PD5svG01OXnKADL9n/WuzyH2ssiaUaOhlPAuCYWPPJNVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFNZsGBCDxfqUphlaOCqP79AapiVjpQbmEEA/myi6D8=;
 b=LI8o49bgNyljsj7Dw8VN5tXxGhV1bJDtn3UAqnrPYKfSAhjkLEnQmpvuCTaDbv8uZli/wLtSrTEyy/Wv8pLjF4gPAmDVzWaTQIGyXj2sKQDKLOlqbfOKqyCnsHrKk7dBG/JF1eMorflXFCOUZf5YQlg4cHsu7c6y09uGyJuX5g6VRa6qyKc7TQYglNCazK4tBA5Nq4Cdx9lnHgdqqZFWbWf0D/nZ8ZwvYoJx9V0WcdeRcEFQ+Z9v/ZAmb+/aIdFlqm1nhO9PpjLEDAOgdRvh877G15TBj/cXrqsh/fzub4/w1unjWol519CMDCWhylNXzTUlHX/+hJC3KA6Rw0B9ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFNZsGBCDxfqUphlaOCqP79AapiVjpQbmEEA/myi6D8=;
 b=X4oprvStYNKKgazKYFsV/3GjtsZfvnYN9BVPC/vvTbll39PuIWaP6zT1BkICF5dfZCNhaZ6I2+Vl9wCdx60uhMejJWeuDPZX/a+rYPT155zEPfCgsLvDncI0JszDFmpILEFdBC38AZdkxH8W8J223QP7Fn1BQhDskpazDSYh45HYs+mvKUXcREZnendQ2QN6NMdXIt096lAzboq6YF5iDCN9lEHhay8vOL0xqqeAh6B5In0+hR7Qglw7CQgyE/C2Td1UQ9EojSk72gvVgBUv11HXaEsiDgBcrgbe+V2EQyeRx/DV4XPlK4QVGaa0XpP2Wgi/6rjOlGSrd+E5TYzpag==
Received: from BN0PR03CA0014.namprd03.prod.outlook.com (2603:10b6:408:e6::19)
 by MN2PR12MB3583.namprd12.prod.outlook.com (2603:10b6:208:c5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Thu, 16 Jun
 2022 23:53:25 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::d1) by BN0PR03CA0014.outlook.office365.com
 (2603:10b6:408:e6::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16 via Frontend
 Transport; Thu, 16 Jun 2022 23:53:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Thu, 16 Jun 2022 23:53:25 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 16 Jun
 2022 23:53:24 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 16 Jun
 2022 16:53:24 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Thu, 16 Jun 2022 16:53:21 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <kwankhede@nvidia.com>, <corbet@lwn.net>, <hca@linux.ibm.com>,
        <gor@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <borntraeger@linux.ibm.com>, <svens@linux.ibm.com>,
        <zhenyuw@linux.intel.com>, <zhi.a.wang@intel.com>,
        <jani.nikula@linux.intel.com>, <joonas.lahtinen@linux.intel.com>,
        <rodrigo.vivi@intel.com>, <tvrtko.ursulin@linux.intel.com>,
        <airlied@linux.ie>, <daniel@ffwll.ch>, <farman@linux.ibm.com>,
        <mjrosato@linux.ibm.com>, <pasic@linux.ibm.com>,
        <vneethv@linux.ibm.com>, <oberpar@linux.ibm.com>,
        <freude@linux.ibm.com>, <akrowiak@linux.ibm.com>,
        <jjherne@linux.ibm.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <jgg@nvidia.com>, <kevin.tian@intel.com>
CC:     <jchrist@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Subject: [RFT][PATCH v1 4/6] vfio: Rename user_iova of vfio_dma_rw()
Date:   Thu, 16 Jun 2022 16:52:10 -0700
Message-ID: <20220616235212.15185-5-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220616235212.15185-1-nicolinc@nvidia.com>
References: <20220616235212.15185-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da82bf85-5f9d-4729-9a50-08da4ff36757
X-MS-TrafficTypeDiagnostic: MN2PR12MB3583:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB358347EA693E7DCCE90A644FABAC9@MN2PR12MB3583.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9u2pejSwLvfYXbdImUVEjs89imlwKrmzgZFrW2b8eU/t01QygbIaiy+IZEX0Q1rqUCF/j+aCa0oyf1Y0BnOKr74NBzG1AQ32WiJxCTlC44cGjli8iECy42gs7tkTNx46OfyQYrouMdQCtSw/aJiSd8KpmChfaklHLBo5qTSsfUprlUXPk11mzVcDKfx5scZIemSB7+t2QK8oWp3cZwBoLrz7VFU3va/zdn/gfAiBqi8I1jwqPcd+Jl0ZIY761GuzU+QMTUjs+jONjWbtkzqhv7G+T3G8yV2/ySu+ru9D6gtM4ZWGABoA8h8cGsiJN+S2MwL9J40Ay1OpFhvDEecIr++UPPHF8QP/prs2lbR+6i31JlnHx8G0v4SAQdhFd59YEdNFRfbR6cyM8XvKv6e16QVMJ8gy0CyhfMwiySYkYREkuSoo1EshMArrbZMcasrzhwA9Ge9kYgxQ7CC6PZMXMnElalrmJfZvDjO373QDiNxGhPoph2VGTAXdqGpXzkBcAr+yA4aBQsYhU495A5xrWRcn77S80Vj1TFjEZRWqWCn0McJFeE5uygi2RoUe2aREYlIJY6bxiMyJhBTb+nCdqWtK/7T67yIqGkbx6w/tNBBgOznzoROhuOwpyU0EqW4DbQ6QLWwpNwwMhvawVkFhKU2VyKBq8GHHXs+eKU+cZz4yMzl5J1Xla6gLx0PhvsTEHlnJAM/7cLcQgkZX+lYZzqeL5rfDpKhpYplNXlT4MRnnW/JGARIZD5TqTZLClNRH+55FBOZsWgzcj96ma8qq7A==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(40470700004)(36840700001)(4326008)(82310400005)(336012)(2616005)(47076005)(426003)(54906003)(110136005)(81166007)(7406005)(7416002)(8676002)(36756003)(83380400001)(86362001)(921005)(36860700001)(8936002)(70206006)(7696005)(316002)(186003)(356005)(5660300002)(26005)(1076003)(2906002)(70586007)(40460700003)(508600001)(6666004)(83996005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 23:53:25.4225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da82bf85-5f9d-4729-9a50-08da4ff36757
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3583
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Following the updated vfio_pin/unpin_pages(), use the simpler "iova".

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio.c  | 6 +++---
 include/linux/vfio.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 861594dd461a..e8dbb0122e20 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1996,13 +1996,13 @@ EXPORT_SYMBOL(vfio_unpin_pages);
  * not a real device DMA, it is not necessary to pin the user space memory.
  *
  * @device [in]		: VFIO device
- * @user_iova [in]	: base IOVA of a user space buffer
+ * @iova [in]		: base IOVA of a user space buffer
  * @data [in]		: pointer to kernel buffer
  * @len [in]		: kernel buffer length
  * @write		: indicate read or write
  * Return error code on failure or 0 on success.
  */
-int vfio_dma_rw(struct vfio_device *device, dma_addr_t user_iova, void *data,
+int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
 		size_t len, bool write)
 {
 	struct vfio_container *container;
@@ -2018,7 +2018,7 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t user_iova, void *data,
 
 	if (likely(driver && driver->ops->dma_rw))
 		ret = driver->ops->dma_rw(container->iommu_data,
-					  user_iova, data, len, write);
+					  iova, data, len, write);
 	else
 		ret = -ENOTTY;
 	return ret;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index edbad5d3d50a..99c3bf52c4da 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -151,7 +151,7 @@ extern int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
 			  int npage, int prot, unsigned long *phys_pfn);
 extern int vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova,
 			    int npage);
-extern int vfio_dma_rw(struct vfio_device *device, dma_addr_t user_iova,
+extern int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova,
 		       void *data, size_t len, bool write);
 
 /* each type has independent events */
-- 
2.17.1


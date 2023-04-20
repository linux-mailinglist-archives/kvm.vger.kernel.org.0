Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8996E8BAA
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 09:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbjDTHso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 03:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbjDTHse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 03:48:34 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2049.outbound.protection.outlook.com [40.107.102.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE7344B9;
        Thu, 20 Apr 2023 00:48:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7rIhnEzKaYvtHfOWezEpnAIFjKFZG7OmAbpusbQnfwxZpqtDawgrVDFmuhQ3fBUd68ylDkC2vyjuMeHeAgZETLS3vGPnoZJAtIq94hbtJSWUE3cDeAzLeYgYcZeCYzc6ZLh/bXsZZOTwePUi44wyDyuq7a0TahhjdGsctBZ9dw/W8Kkqc/HhLURJuDTFx9cIon/EqtCs5SOXhXIlHjZHHh/kutHcIJlq58SgMHhOK1Gt0R4sJNFYBbZixCOwm85t1+QxulGhajHteP5G3KbD13FKlDUuhgzkEc5KLpe+OOALZrW0l/6g9ePWiosJeW0KxQ+7YftmnL3mFcrd5LYGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hf53zDrbQHzWCN6M+4n/hVt2zAAGtcY0Lvjjgb119bI=;
 b=GNquYl8BjupPEROx2Cl+SquGfK8XV/db7HwJUnqzFADyXUS4+qaslGe6CVls5VvM56pi//EAUln9s4yfjsVL5GGHn5U/11GhoMFdLUzJah6cnhPp1NfHwmpAf4tRLoILg9jCFqKniMMkh4sncPIZtFfm7PJem3AB8Nk7atUOWePInsymSOFd8XMGo8F+12YjtYnyMm2pFxwFrW2kehYE9rF/6jnj1kKWVnh1kGyXlKRIhBBC96qvFiY7SzrK1VjTrfANZ7L/k43S/jtFZYfW1V1ATARsgFm67zHwJhpLMTmUd2Cre8mcJT52yskvLj3zEyVeU3u+II3+Grj5IkUaDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hf53zDrbQHzWCN6M+4n/hVt2zAAGtcY0Lvjjgb119bI=;
 b=GRqKCDddx/iX1Yxpi5IiXixwNksDRLKcQQkOEOJGz0ANM362Nbaf1as6dYiEWBi2vnvuXP/PC+rrwd6ZYt4olcd5lEu5DM7CldxxwwTDi5pU+Q/eJx9ArXRlg3AUDU9kJH1bO2GkYX4F7T5rD3J4DMi3qy70ZuFMxNjAW+w+k7QzWZZg6qSRrKiRWVpTEgZ1MekCjvhKvohxC32/YJRKUU7NCWsumRSLTGLNu1/6H0lucR+l0IMNsgD9xghJk4XGnv+VIsmZCFf09rQ1b6iFWcHM4kYImRFDYKwNLF6GBFCobF58pyAF7v+WGrASNX5vrZeWnbAtpKNovR19n0Tlfg==
Received: from DM6PR01CA0023.prod.exchangelabs.com (2603:10b6:5:296::28) by
 IA1PR12MB6043.namprd12.prod.outlook.com (2603:10b6:208:3d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Thu, 20 Apr
 2023 07:48:29 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::b8) by DM6PR01CA0023.outlook.office365.com
 (2603:10b6:5:296::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Thu, 20 Apr 2023 07:48:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.25 via Frontend Transport; Thu, 20 Apr 2023 07:48:28 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 20 Apr 2023
 00:48:16 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 20 Apr
 2023 00:48:16 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Thu, 20 Apr 2023 00:48:15 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <kevin.tian@intel.com>,
        <alex.williamson@redhat.com>
CC:     <robin.murphy@arm.com>, <eric.auger@redhat.com>,
        <yi.l.liu@intel.com>, <baolu.lu@linux.intel.com>,
        <will@kernel.org>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 1/3] iommu: Add set/unset_dev_data_user ops
Date:   Thu, 20 Apr 2023 00:47:45 -0700
Message-ID: <9361299fb200c1153868d8197c69cc67eef13149.1681976394.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681976394.git.nicolinc@nvidia.com>
References: <cover.1681976394.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT017:EE_|IA1PR12MB6043:EE_
X-MS-Office365-Filtering-Correlation-Id: eed695c6-8839-4875-1de3-08db4173a17e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EbHPfdHa2fYFgxhCv7AKFiQLgV3wMupwc0L/iWxH+kYGhTcdgdP+dxKDhMNEOVuv2vdVbVG/RAlkqQCKIZO0HHVR5p7jljXE9gkR2e5YIcSX2REY+j0+/sKABKpDA41l64+Sofutiialhpjnteg+bTNMxu7Z33XB0KkLVKe6g+VNyItRNNOvAjYWmtFFU5fCBNIcBHGVj1XWHJbK+fTVGQZEEWEIj5/MOqSTH+1heuL1dw7QMsbUFRfNofJcCeEmBCkkU5PAVnUd2a6wAxIkFAox44p+GoJqL7GhGgATxSPYw2EBsF7YRVWyClQIxfN4Nnkfv92JROBaZtd3ICnVba5zXJOSNF1YOZQMu+GBGhxTrWXWECccXGAmojKzibP/zXXr1LeoAWf5AQFCgR+eGrfn+grENwxGVVdtqWbXRZLaPn2hSuXKs/8mL5Az25b+9o43MRvbmy6pBPs12DSSWq2vHtptxUalF0jXtCSKIj0v6DJzSMx4wAZ8+CNXxVDa5fOfSDrm7NfXfyFVCMzBvDDEBNckTegHAv4SolyCXoZ+qpN57jE9BbYxYgQ2ih44Lv509+bdr20AcmJLB4e8uA0WRBQPvIij4FPaj1OR99rrThZ765M3HExbcbR6a2+Vx/t6SWyUOZCyDfMffnnslqrqOII9u5HWsP48A9xhyBpo3YZOBGMmjDYV/0dTdXHuxPt8LYA/UXtGCNY2IEffMy0hni1clT608ku8jcWgwythCFTIuWlV81L536v4PvhD6LZojp/tgxetozqVhKtdsHrD+xOtOJMStA1VMBQhaaI=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(2906002)(34020700004)(2616005)(36860700001)(40460700003)(478600001)(6666004)(82310400005)(86362001)(26005)(7696005)(186003)(36756003)(40480700001)(336012)(426003)(41300700001)(82740400003)(7636003)(54906003)(356005)(8676002)(8936002)(47076005)(4326008)(83380400001)(70586007)(70206006)(110136005)(316002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 07:48:28.8092
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eed695c6-8839-4875-1de3-08db4173a17e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6043
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The device behind an IOMMU might be used in the user space by a VM. So, it
might have some user space data. For example, a device behind an SMMU has
a static stream ID. In a virtualization use case, both a host environment
and a guest environment have their own Stream IDs. A link (a lookup table)
between the physical Stream ID and the virtual (user) Stream ID is needed
when the host handles the user cache invalidation commands.

Add a pair of new ops to allow user space to forward user_data of a device
via iommufd.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/iommu.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 5c99aeaccd1d..c87f0f1527dd 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -257,6 +257,9 @@ struct iommu_iotlb_gather {
  * @remove_dev_pasid: Remove any translation configurations of a specific
  *                    pasid, so that any DMA transactions with this pasid
  *                    will be blocked by the hardware.
+ * @set/unset_dev_data_user: set/unset an iommu specific device data from user
+ *                           space. The user device data info will be used by
+ *                           the driver to take care of user space requests.
  * @hw_info_type: One of enum iommu_hw_info_type defined in
  *                include/uapi/linux/iommufd.h. It is used to tag the type
  *                of data returned by .hw_info callback. The drivers that
@@ -303,6 +306,9 @@ struct iommu_ops {
 	int (*def_domain_type)(struct device *dev);
 	void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid);
 
+	int (*set_dev_data_user)(struct device *dev, const void *user_data);
+	void (*unset_dev_data_user)(struct device *dev);
+
 	const struct iommu_domain_ops *default_domain_ops;
 	enum iommu_hw_info_type hw_info_type;
 	unsigned long long hwpt_type_bitmap;
-- 
2.40.0


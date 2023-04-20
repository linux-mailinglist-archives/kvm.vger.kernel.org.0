Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280A36E8BAC
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 09:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbjDTHs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 03:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234154AbjDTHsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 03:48:40 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8716446BB;
        Thu, 20 Apr 2023 00:48:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ee97OuntGs10m+Pl8S81TZZ1HjJua3lwDsW2pvIyXQ2S2Mh51N3uMqN3zQkFalqU8Rc/cr1rYejf4Ysy3wcepbp+6qlj+IZDRpcUOiapZBapxgIFGxfB3oTItSJg3Xo+J02r134pHpFuiREeGtBLnFawb8Ph0gu84foiGxi6TMEYbYnP5jP/rTMr8nQpt3smVg2V+Unb6xWQh0gpuIGC7uVzgqOJGNgOt/yNShzk0tyKaRb4LMzJysyWr+eci2oPNe+mIKw4FSJJtXJfps0TG/tMSmQhWKpWzfNmTbVncUCV8l1cj0I+AHwXMiA2Gf9aaOX7KjzdKHw7/Fbf56IAmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BUU49S5Qxv2DN+8BkUjn6g2JPJVJ8Eq13zKQh4ZygSc=;
 b=eYxUyldo3RImXQ4tLrk2fWKoFgOZRQlL+58oACg9G4tpMQL5rCCdkTB950I2h2YxtPMtOmARMtB/TIUZkGucMviBmPY06d4P4zq2w8s0cBFiSf4taZAUWhoG3J/EB9i8lg3LgycLjKzTWas+1ilWlPetLCJCmv+R7H2AwZbk0V5W3HddrNB37svLOfUw+o2qF+2Zh5rNRfSUNFDl7o9s819Zq/6WszGMttckIqqFR315xW4eFelyhTKdBZj0BI2ZxhS9aMIKtSwFchDKyH7xIMDwnT7QsdSalaE5w+S9bYU37SYmENpR5TAG1hT8YDXcLFFvMpJzJAoWlU4ucZL1Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUU49S5Qxv2DN+8BkUjn6g2JPJVJ8Eq13zKQh4ZygSc=;
 b=fOT1UxmE/9f2AUTw0VVWMv5rnOb0MYfCUbufBM5K7LKP+fOQMmERP4fh7S7hhyUo0nSkB+/DuylEqfL57SnWYQ8T6j32L+aP9emCSr9g9xQj2o21CQ/s3uD37n8CATl5+tRQbbPHD/eoVOn8XyQxqebvONVUfYVBxVlG3OCHRSe9vWtX7AyEZoB0zCZWLM5r1ix7GcF7bQpsLhPqSeSMHQ3d9ApqX7Yagm3FDH7eU7x4xFG9pp4d1ICzpaL7xo/QyBQw/A7eiWt9IJBOaeWcjrUteYum9o8kvOaZ2GQ73bXWKGGuIzy0VBxVPIQlUuvolasaHIEUCAMhTqMYKI/+7A==
Received: from DS7PR07CA0012.namprd07.prod.outlook.com (2603:10b6:5:3af::20)
 by SN7PR12MB7323.namprd12.prod.outlook.com (2603:10b6:806:29a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 07:48:37 +0000
Received: from DS1PEPF0000E638.namprd02.prod.outlook.com
 (2603:10b6:5:3af:cafe::72) by DS7PR07CA0012.outlook.office365.com
 (2603:10b6:5:3af::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Thu, 20 Apr 2023 07:48:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E638.mail.protection.outlook.com (10.167.17.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.17 via Frontend Transport; Thu, 20 Apr 2023 07:48:36 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 20 Apr 2023
 00:48:18 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 20 Apr
 2023 00:48:17 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Thu, 20 Apr 2023 00:48:16 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <kevin.tian@intel.com>,
        <alex.williamson@redhat.com>
CC:     <robin.murphy@arm.com>, <eric.auger@redhat.com>,
        <yi.l.liu@intel.com>, <baolu.lu@linux.intel.com>,
        <will@kernel.org>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 2/3] iommufd: Add iommufd_device_set_data and iommufd_device_unset_data APIs
Date:   Thu, 20 Apr 2023 00:47:46 -0700
Message-ID: <93edbb5af7d11f95921eb10ba929bccde0917bea.1681976394.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681976394.git.nicolinc@nvidia.com>
References: <cover.1681976394.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E638:EE_|SN7PR12MB7323:EE_
X-MS-Office365-Filtering-Correlation-Id: a0bde68b-f090-4e6c-1660-08db4173a60c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gwzHfYR5Ma92DiYNAWS3Ccmx0How0JuafH8h9fZjUT4zwrEMJ3qocqsgRyerjB7b7/mpAP38xPckvwmKPf0nXe6zUhud9BL5rzCfQ8+dt650FiiB8uybYpECpoEqQCk2J7F+Dn3IFgMd1uQm/oOWs9MijtL8JBH5VLR2C94qZalFqxjkTE6Z+MN26hKSvxo+DLJ6VR1NOzRkQGxGvlV9ivQFYXQS7JPGjAZPusYmIZYV9favlfau681j2tvGHOOyAKai6kvgIBlalAIgHrIT2xTA1xtDKPmBjmq031oa8SJK98S5NJ6et87F0y2Btw48uX+/roOo0crbD+tERb6VNnpG3HAyzvpqCKXgwZarhyjUdmGVZzJ9WRPpRgKrJXsh5QzANdVoRRmtwzSuFNvlaXV6/CRw2KB3u+rE7SDJo0j0vFy+wS0tMO6HTksdaBm1WYptvfSkRnAhP3eO/Ft1vwkWw63Sub/M89hXzpdZm/5sKejP1h27aTQlD2uIXAC5paOgiT2XLcvS2YMK6A7k8Ndxkrr8zhafq7EnDruSfkPr0sBkt2ZWxKJiLby+XDSA6iXsFUL327r9Y4x5G9yNljWichex9BL8ZOe7jOw24Tf4E47lUKmZby5VJKmLnyTNJ7+Elid+GHqwrZ20nWk4QBOesxiPfPAK7idgpWv66aiIPYcgySXFn4Msq/GhCEMIrWFLPTzwGe1FFavUdv49YAfDmKaNE4eP7OpzEKbLlO0AxbA2GF5Qb50dJra5r28s
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(396003)(136003)(451199021)(46966006)(36840700001)(40470700004)(40460700003)(6666004)(478600001)(7636003)(356005)(82740400003)(82310400005)(2616005)(186003)(26005)(47076005)(36860700001)(426003)(7696005)(336012)(86362001)(4326008)(54906003)(110136005)(70586007)(36756003)(40480700001)(41300700001)(8676002)(8936002)(316002)(70206006)(7416002)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 07:48:36.4505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0bde68b-f090-4e6c-1660-08db4173a60c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E638.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7323
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The uAPI handlers can call these two functions to set or unset an iommu
specific device data. For example, the SMMUv3 driver would get a virtual
Stream ID using this interface to tie it to the device's physical Stream
ID, for sanity at the device-specific invalidation commands.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/device.c | 65 ++++++++++++++++++++++++++++++++++
 include/linux/iommufd.h        |  4 +++
 2 files changed, 69 insertions(+)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 16fdf4a16643..c4e895239486 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -610,6 +610,71 @@ iommufd_device_auto_get_domain(struct iommufd_device *idev,
 	return destroy_hwpt;
 }
 
+/* size of iommu specific device data, indexed by enum hw_info_type. */
+static const size_t iommufd_device_data_size[] = {
+	[IOMMU_HW_INFO_TYPE_NONE] = 0,
+	[IOMMU_HW_INFO_TYPE_INTEL_VTD] = 0,
+};
+
+/**
+ * iommufd_device_set_data - Set an iommu specific device data
+ * @idev: device to set data
+ * @data_uptr: User pointer to an iommu specific device data
+ * @data_len: Length of the iommu specific device user data
+ *
+ * This sets an iommu specific device data from the user space.
+ */
+int iommufd_device_set_data(struct iommufd_device *idev,
+			    void __user *data_uptr, size_t data_len)
+{
+	const struct iommu_ops *ops = dev_iommu_ops(idev->dev);
+	void *data = NULL;
+	u32 klen = 0;
+	int rc;
+
+	if (!data_uptr || !data_len)
+		return -EINVAL;
+	if (!ops->set_dev_data_user || !ops->unset_dev_data_user)
+		return -EOPNOTSUPP;
+	if (ops->hw_info_type >= ARRAY_SIZE(iommufd_device_data_size))
+		return -EOPNOTSUPP;
+
+	klen = iommufd_device_data_size[ops->hw_info_type];
+	if (!klen)
+		return -EOPNOTSUPP;
+
+	data = kzalloc(klen, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	if (copy_struct_from_user(data, klen, data_uptr, data_len)) {
+		rc = -EFAULT;
+		goto out_free_data;
+	}
+
+	rc = ops->set_dev_data_user(idev->dev, data);
+out_free_data:
+	kfree(data);
+	return rc;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_set_data, IOMMUFD);
+
+/**
+ * iommufd_device_unset_data - Unset a device's iommu specific data
+ * @idev: device to unset data
+ *
+ * This unsets an iommu specific device data that is previously set from user
+ * space, calling ops->unset_dev_data_user.
+ */
+void iommufd_device_unset_data(struct iommufd_device *idev)
+{
+	const struct iommu_ops *ops = dev_iommu_ops(idev->dev);
+
+	if (ops->unset_dev_data_user)
+		ops->unset_dev_data_user(idev->dev);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_unset_data, IOMMUFD);
+
 static int iommufd_device_change_pt(struct iommufd_device *idev, u32 *pt_id,
 				    attach_fn do_attach)
 {
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 6752c58226d1..4b3a70faa409 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -25,6 +25,10 @@ int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id);
 int iommufd_device_replace(struct iommufd_device *idev, u32 *pt_id);
 void iommufd_device_detach(struct iommufd_device *idev);
 
+int iommufd_device_set_data(struct iommufd_device *idev,
+			    void __user *data_uptr, size_t data_len);
+void iommufd_device_unset_data(struct iommufd_device *idev);
+
 struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev);
 u32 iommufd_device_to_id(struct iommufd_device *idev);
 
-- 
2.40.0


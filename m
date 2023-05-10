Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3591B6FD45D
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbjEJDfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235540AbjEJDeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:34:50 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2045.outbound.protection.outlook.com [40.107.102.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4C43C00;
        Tue,  9 May 2023 20:34:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TPW+vSAlHTTi4NdlARaR3d/dgi9tLMh9kuqMxAokXKDrUCduJq8xobMJ0nF+QYsI1W3bLrrshu01LCshhvIyI4Ea6OxgwhfeYGQoSIpGuF5eE19m+BQZ4Xt4JFGWccfMq9+RS3E84LtIdzwd3wHG1zkhoOy2CRXuTNA2a+BxEo+yUPBampXj/x5aXJkA+VBMvxvw3iDYP/gVIls0YFL1KGXRNPKS+6Z9dNw5G3XWVkfKqI49M9uBmcEr61y0C+1aj87D6eQs6XC1rfB+WOpqJIfc4G5rjOf1BiNS9PsDnJtICd6pjx9YxVl1mMs4phWuabV5b6YjTbW+7pRcG6Sa4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8a6MaHRoRL4e1jrwRkkp6NkI75mJYRczGK5OsDxgW94=;
 b=Etq1q8g9Hoqmk4IPboBoczwFLBPBerdfB9TMV4eILVg9FBEZk1KBrPmo9nn0UurL/z3kC28LmqiAZH4hvYwTwl+ZOeGer4A5DO8/6gBeEwBLS3VAb9Tw4c+pYW8/WXyiHcmemK7Sq4AxHlMGXzUjY/ed8yVMw67euEhreMPVO1x7VmmRYTBj8ck+BTNxtaNtkflmVziEJv7WvNA1wFXWggInnkpjUl9PwAmD9NWP+ACJC2W2FwJNam5/lFVhvv3pBsPMmpQVqptq59QT+2ImubQNylHdrDh2G3Q0XoJDejelOe98ED/MRGMQEGMxdfuJndNgVsYrhiLLhENYCDNFCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8a6MaHRoRL4e1jrwRkkp6NkI75mJYRczGK5OsDxgW94=;
 b=Gx3QiiKwsAHBtRfP8ybqgcRA9GciguA9qF4LY04QRf+88VAoW2eiGUE4bXbU+sSRM257Wp7tGHKaW96nMrpzLt+ovb8a25WdmLjJcX0zXNuO3Sa26YA03+iYAMURqh4haOpMPKuUXUE4jOa2yZghoIWcJIHFFFOh1wiJt6JA+QssHGAeMMKsrzG05lbADJOtOcCMGQzbkWmeRXHxE5a0BiEqAUmCMz0Fndmb7bWQ6FVEuAyYb3UKr3ZSrAdEdbn74KaAU8Tswi0pITO5Bspozy+x9U1W1Le4PBaoJthfT4n7AeCRgWq4b2IJhrYH+5J7IwjTzsqVY746QXYYNT7JKw==
Received: from BN9P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::6)
 by SJ2PR12MB8925.namprd12.prod.outlook.com (2603:10b6:a03:542::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 03:34:31 +0000
Received: from BL02EPF000145B8.namprd05.prod.outlook.com
 (2603:10b6:408:13e:cafe::46) by BN9P220CA0001.outlook.office365.com
 (2603:10b6:408:13e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33 via Frontend
 Transport; Wed, 10 May 2023 03:34:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000145B8.mail.protection.outlook.com (10.167.241.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.19 via Frontend Transport; Wed, 10 May 2023 03:34:30 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:16 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:16 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:15 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 06/17] iommu/arm-smmu-v3: Add arm_smmu_set/unset_dev_user_data
Date:   Tue, 9 May 2023 20:33:26 -0700
Message-ID: <9bcf79fe2b93eca097b4ea8eaef43c4c2a4bc8d3.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145B8:EE_|SJ2PR12MB8925:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e9c8be0-efb9-47c0-238c-08db51077739
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f9B/zjpSuc7eSN4/7FgKXqsBsvxQPUcZs36dVAM+VT8LFCd5tf5XuScDLhsA3+YzPdFJc84AwmuGfYzV4hDtdBzQxc6yVm3NqT0jFGjyD8ASRWy+nfAHqpa2Urx28yf5gwqJSnShgRy9MFPY+cyN6XQ8cw35jniiuWdbJuWEiYknlEHETDgZBjHMI4eI75fcxzeHta0Fz6tYfhT85f0QNLNPFRg1ccW9mV4CYVbrrIjGeZI8VqhBuCff3JkyzlnCAXDiNkN/HBh2k1SZDC3N9SAXEvnrXbnttdwmojDB3Gelw+hFEvSuOV58y+yamFHhRdm+it2ktEm5iyhFGShPSE81vfsx4k7a+y2t+ab5B5ghM1sVM//wuus7wNiQcjK5WnO8W2zlN+fi5XUBDP/yn0mAHeTjLkKeYxsWH6X/JkFhnOEzIFmM3Xu8E6aFtYHrRqcTGtvco8LprjgC3G6bB1UK/bWWSnr/omNNcqBXb8AaFWcNpLPfwsu3PlGtVaMbMEy4fIvBdcY7/LQFArkEXJYThQSoPmMcnHr/zbKIkvzCupG44qVmZI8KbjcppyWB5pprtTVSLWBeIB/BQQAq4Ax6NA64/5OgxSw5AJuTN5fcGtrcByq+TZSzwhoAukgConeJrd1OqZ1VYPr1j32WPjbPTe0JIVtxGuljeEoufTffwuVCJSxByCGYX0DXlLB8qLK8NPYpAM4PRWKInVuYSA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199021)(46966006)(36840700001)(40470700004)(86362001)(426003)(36756003)(6666004)(4326008)(110136005)(54906003)(316002)(70206006)(70586007)(7696005)(478600001)(40480700001)(82310400005)(82740400003)(5660300002)(2906002)(7416002)(8676002)(8936002)(41300700001)(7636003)(356005)(186003)(47076005)(36860700001)(336012)(26005)(2616005)(83380400001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:30.8036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e9c8be0-efb9-47c0-238c-08db51077739
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000145B8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8925
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement the new set_dev_user_data and unset_dev_user_data ops, by using
an xarray to store the stream pointer indexed by a given user Stream ID.
This will be used by the user cache invalidation hypercall, to check the
SID field of an ATC_INV command and replace it with the physical SID.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 44 +++++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 +
 include/uapi/linux/iommufd.h                | 10 +++++
 3 files changed, 56 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 89daf50be87b..327819663547 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2746,6 +2746,46 @@ static void arm_smmu_release_device(struct device *dev)
 	kfree(master);
 }
 
+static int arm_smmu_set_dev_user_data(struct device *dev, const void *user_data)
+{
+	const struct iommu_device_data_arm_smmuv3 *user = user_data;
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_stream *stream = &master->streams[0];
+	struct arm_smmu_device *smmu = master->smmu;
+	u32 sid_user = user->sid;
+	int ret = 0;
+
+	if (!sid_user)
+		return -EINVAL;
+
+	ret = xa_alloc(&smmu->streams_user, &sid_user, stream,
+			XA_LIMIT(sid_user, sid_user), GFP_KERNEL_ACCOUNT);
+	if (ret)
+		return ret;
+	stream->id_user = sid_user;
+	return 0;
+}
+
+static void arm_smmu_unset_dev_user_data(struct device *dev)
+{
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_stream *stream = &master->streams[0];
+	struct arm_smmu_device *smmu = master->smmu;
+	u32 sid_user = stream->id_user;
+
+	if (!sid_user)
+		return;
+
+	xa_lock(&smmu->streams_user);
+	stream = __xa_erase(&smmu->streams_user, sid_user);
+	if (stream != master->streams) {
+		WARN_ON(__xa_alloc(&smmu->streams_user, &sid_user, stream,
+				   XA_LIMIT(sid_user, sid_user),
+				   GFP_KERNEL_ACCOUNT));
+	}
+	xa_unlock(&smmu->streams_user);
+}
+
 static struct iommu_group *arm_smmu_device_group(struct device *dev)
 {
 	struct iommu_group *group;
@@ -2873,6 +2913,9 @@ static struct iommu_ops arm_smmu_ops = {
 	.domain_alloc		= arm_smmu_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
+	.set_dev_user_data	= arm_smmu_set_dev_user_data,
+	.unset_dev_user_data	= arm_smmu_unset_dev_user_data,
+	.dev_user_data_len	= sizeof(struct iommu_device_data_arm_smmuv3),
 	.device_group		= arm_smmu_device_group,
 	.of_xlate		= arm_smmu_of_xlate,
 	.get_resv_regions	= arm_smmu_get_resv_regions,
@@ -3108,6 +3151,7 @@ static int arm_smmu_init_structures(struct arm_smmu_device *smmu)
 
 	mutex_init(&smmu->streams_mutex);
 	smmu->streams = RB_ROOT;
+	xa_init_flags(&smmu->streams_user, XA_FLAGS_ALLOC1 | XA_FLAGS_ACCOUNT);
 
 	ret = arm_smmu_init_queues(smmu);
 	if (ret)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 5fa010c6fe20..1951a80af241 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -676,10 +676,12 @@ struct arm_smmu_device {
 
 	struct rb_root			streams;
 	struct mutex			streams_mutex;
+	struct xarray			streams_user;
 };
 
 struct arm_smmu_stream {
 	u32				id;
+	u32				id_user;
 	struct arm_smmu_master		*master;
 	struct rb_node			node;
 };
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index b1fe4c59ab82..2ecb6240ec69 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -592,6 +592,16 @@ struct iommu_hw_info {
 };
 #define IOMMU_DEVICE_GET_HW_INFO _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DEVICE_GET_HW_INFO)
 
+/**
+ * struct iommu_device_data_arm_smmuv3 - ARM SMMUv3 specific device data
+ * @sid: The Stream ID that is assigned in the user space
+ *
+ * This should be passed via the VFIO_DEVICE_BIND_IOMMUFD ioctl.
+ */
+struct iommu_device_data_arm_smmuv3 {
+	__u32 sid;
+};
+
 /**
  * enum iommu_hwpt_intel_vtd_invalidate_flags - Flags for Intel VT-d
  *                                              stage-1 page table cache
-- 
2.40.1


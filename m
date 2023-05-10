Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA986FD453
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbjEJDeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjEJDe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:34:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099B110CF;
        Tue,  9 May 2023 20:34:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HD8tRB0IPEw+Yp09ezmjSd5GYpS9WKkjIa8+wRpUceEywCy3XzRZZZ7CzlspHVisxW9BzCea2mHBNw6RjF/s+jfVbYh1TBH4tHIHgN+XDR90mcIKjsRmjlYwqAaq3ZvUpyVcoWm/jTS9qpJAh42m4YRSpzbXsLqcOvJNf5ZDE087VRy43g4cSOBTR+iRTQvFCyaDMXfKkpWdEUUzxQsYuqvkVOmpJKtABaxPBVqG8m7xVUpI4zJgvxTQ2Wk/xIGKDuNCq5ec1Uy3djyEA+RR1VD2DQeP0sLAZ2xXboAi86kCCx0AucGIPfJD0bgrnVk51V5/ODb5OC3WZfM3kdWAIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywo+aUUeXF8oao0a2+KD1hp1U0/c3xW3/reF5Dp9LNE=;
 b=WFlZLocKT4GSA5AsmrbFzufH2Kjs+YIbhg/GjTTatTmwopOl175yHdadayH9srxg5tJhCuZDalTqYaJ1GUA5ZSkVhi2OyfglTy7EzSm1kM/cY3XGB/UGBFeh99X5rnGUt/rfAb0Cfn9E3Cy/c0yn1P/KV4vCF6A9om5qgI9TPPtq+dR2lzqUEj8MagHUUzw0UHBpw+/7M7M6dKw6Vd4gL9zJulO1lVwTLII8MUGVC9rvQCO5bWKqk/IaDfi1PSeTGpZX9tysx2bitSefvo7YT9cI16kd97UNAilwmBGRExWaQ0qCKoECPu/5hj+wLn2mNBUCPbhzLLfXQnhtev/Ccw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywo+aUUeXF8oao0a2+KD1hp1U0/c3xW3/reF5Dp9LNE=;
 b=NmMkPIJJWIUOHjmEmKvM3DtwVuwahN5CSew1kFCG0pmm1ctwbQI07YFaa/KuQ4yU0H3l1Jk+yFDBwsYCy3GTfYfPbn6SM0cLqlnWRm6qIj6hvzVI6OzItorJyQI1PDUof6hXqRgs6gSXkpEdSys65OA3aDDFbtcvP9KcUFa5xrxCR3wmipSQVzzjEuzzHivI4A1lL3sLPUqrkHvM8G4v40kBL+nAgEY4LoJNiIT+dnBxrX1MPqNayEtxRN/T8natTEnp7Giq/U1j76BGFZCHB+GN0wfxsP/5YeLdo2FX0NAAolWofwtuCHTKOJT7ueXLp5cgOstMi3GOnXhmqlvBww==
Received: from BN9P220CA0004.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::9)
 by BL1PR12MB5190.namprd12.prod.outlook.com (2603:10b6:208:31c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 03:34:24 +0000
Received: from BL02EPF000145B8.namprd05.prod.outlook.com
 (2603:10b6:408:13e:cafe::8a) by BN9P220CA0004.outlook.office365.com
 (2603:10b6:408:13e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33 via Frontend
 Transport; Wed, 10 May 2023 03:34:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000145B8.mail.protection.outlook.com (10.167.241.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.19 via Frontend Transport; Wed, 10 May 2023 03:34:23 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:12 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:12 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:11 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 03/17] iommufd: Add nesting related data structures for ARM SMMUv3
Date:   Tue, 9 May 2023 20:33:23 -0700
Message-ID: <be0135dac695825fdf56f1cc3f0d2181ff35afa5.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145B8:EE_|BL1PR12MB5190:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dd222a3-07f6-4038-f5cf-08db5107729c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ud7BcwgHJ63Nrjs30POp4n56YBr6R9l++6mgn3WNVElIatGs0uOmrwLQW60Hh5Xu9o9pcVep/MycmbOdibO1NcnLHAzQ4k6BFlKNjAAhEpZKK4Cf6nMS2KwwCARaR8zmixknt4uqB0JYA0TOxHvggDk8/rKpmjjAfwOnVUK+YqPvIR9B3hUT8BigufW4cbeYVUctNHKtHx2nKYB54ma4PpPUFQTBefi5UymzjUIYBESKqZhP014mu2HBxJQ0LS7SBI1h9NOx136oMCCuDTLETooJpFn+hXrKLwN2cx7uQZXACWLc9cVEWyoMHu314jTqp+sjz3U5Qgc1TjtIZjeU4IOzQb2gxtg6uCGEcJYJmo4Aa4Q/GsOe3hEFdIiaJ891b8gJM2hpFG0ruVQNLKj/vXm4MqVqtE+OoSb/UWm63uRVZiI9eiUvgFNZ8PNeiZpl/tXaykO5LuF8w3IbY0Ckwi6XIpxGjE/K7F96OvhgTbNfIjyn/KcVawLMz+UjWQDbB57mm2BPlR2+XoxieO+CebQZlSMABI/sbu3YmPO3/nXSQfsnpvL2vg3bAnOMYwfwdAEXYcsoV4JvSBBXQ5UvCatJb4wslOfkDvtzPai7a2acXKC0d9+KhaRGvrasSest41aCR9uI2gYaFPrqkm1g+cdDKNcwUWk1yKAlbb3XQTc8ugEazzE5KV4rXNoFV7gyZcPV/D3jhq9H4JOpiEPM6Q==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199021)(46966006)(36840700001)(40470700004)(7636003)(26005)(356005)(47076005)(70206006)(70586007)(86362001)(40480700001)(7416002)(2906002)(40460700003)(4326008)(336012)(8676002)(82310400005)(316002)(54906003)(5660300002)(41300700001)(8936002)(110136005)(478600001)(82740400003)(83380400001)(2616005)(426003)(7696005)(6666004)(36860700001)(36756003)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:23.0692
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dd222a3-07f6-4038-f5cf-08db5107729c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000145B8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5190
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

Add the following data structures for corresponding ioctls:
               iommu_hwpt_arm_smmuv3 => IOMMUFD_CMD_HWPT_ALLOC
    iommu_hwpt_invalidate_arm_smmuv3 => IOMMUFD_CMD_HWPT_INVALIDATE

The iommu_hwpt_arm_smmuv3 is a data structure to allocate an SMMU specific
translation table, either a stage-1 Context Descriptor table or a stage-2
translation table, which would need the user Stream Table Entry or just a
simple S2 flag respectively.

The iommu_hwpt_invalidate_arm_smmuv3 is a data structure for a request of
stage-1 cache invalidations that could be for TLB invalidations, Context
Descriptor invalidations, and Address Translation Cache invalidations. The
data structure contains all the necessary information about a user-space
Command Queue, so the kernel can handle all invalidation commands with a
single batch.

Also, add IOMMU_HWPT_TYPE_ARM_SMMUV3 and IOMMU_HW_INFO_TYPE_ARM_SMMUV3.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/main.c |  1 +
 include/uapi/linux/iommufd.h | 59 ++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 7d7c11c1c912..8461b12c43b7 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -288,6 +288,7 @@ union ucmd_buffer {
 	 */
 	struct iommu_hwpt_invalidate_intel_vtd vtd;
 	struct iommu_hwpt_invalidate_request_intel_vtd req_vtd;
+	struct iommu_hwpt_invalidate_arm_smmuv3 smmuv3;
 };
 
 struct iommufd_ioctl_op {
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index c8f5801d3439..6845ce6e1e76 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -354,10 +354,12 @@ struct iommu_vfio_ioas {
  * enum iommu_hwpt_type - IOMMU HWPT Type
  * @IOMMU_HWPT_TYPE_DEFAULT: default
  * @IOMMU_HWPT_TYPE_VTD_S1: Intel VT-d stage-1 page table
+ * @IOMMU_HWPT_TYPE_ARM_SMMUV3: ARM SMMUv3 Translation table
  */
 enum iommu_hwpt_type {
 	IOMMU_HWPT_TYPE_DEFAULT,
 	IOMMU_HWPT_TYPE_VTD_S1,
+	IOMMU_HWPT_TYPE_ARM_SMMUV3,
 };
 
 /**
@@ -413,6 +415,32 @@ struct iommu_hwpt_intel_vtd {
 	__u32 __reserved;
 };
 
+/**
+ * struct iommu_hwpt_arm_smmuv3 - ARM SMMUv3 specific translation table data
+ *
+ * @flags: Translation table entry attributes
+ * @ste_len: Length of the user Stream Table Entry
+ * @ste_uptr: User pointer to a user Stream Table Entry
+ * @event_len: Length of the returning event
+ * @out_event_uptr: User pointer to a returning event, to report a C_BAD_STE upon
+ *                  an STE configuration failure
+ *
+ * If event_len or out_event_uptr is unset, remainning at value 0, an STE
+ * configuration failure during the hwpt allocation will not be reported.
+ *
+ * The data structure can be used to allocate a stage-2 translation table, in
+ * which case only IOMMU_SMMUV3_FLAG_S2 would matter, i.e. all other ste_* and
+ * envent_* inputs would be ignored.
+ */
+struct iommu_hwpt_arm_smmuv3 {
+#define IOMMU_SMMUV3_FLAG_S2	(1 << 0) /* if unset, stage-1 */
+	__u64 flags;
+	__u64 ste_len;
+	__aligned_u64 ste_uptr;
+	__u64 event_len;
+	__aligned_u64 out_event_uptr;
+};
+
 /**
  * struct iommu_hwpt_alloc - ioctl(IOMMU_HWPT_ALLOC)
  * @size: sizeof(struct iommu_hwpt_alloc)
@@ -448,6 +476,8 @@ struct iommu_hwpt_intel_vtd {
  * +------------------------------+-------------------------------------+-----------+
  * | IOMMU_HWPT_TYPE_VTD_S1       |      struct iommu_hwpt_intel_vtd    |    HWPT   |
  * +------------------------------+-------------------------------------+-----------+
+ * | IOMMU_HWPT_TYPE_ARM_SMMUV3   |      struct iommu_hwpt_arm_smmuv3   | IOAS/HWPT |
+ * +------------------------------+-------------------------------------------------+
  */
 struct iommu_hwpt_alloc {
 	__u32 size;
@@ -465,10 +495,12 @@ struct iommu_hwpt_alloc {
 /**
  * enum iommu_hw_info_type - IOMMU Hardware Info Types
  * @IOMMU_HW_INFO_TYPE_INTEL_VTD: Intel VT-d iommu info type
+ * @IOMMU_HW_INFO_TYPE_ARM_SMMUV3: ARM SMMUv3 iommu info type
  */
 enum iommu_hw_info_type {
 	IOMMU_HW_INFO_TYPE_NONE,
 	IOMMU_HW_INFO_TYPE_INTEL_VTD,
+	IOMMU_HW_INFO_TYPE_ARM_SMMUV3,
 };
 
 /**
@@ -603,6 +635,31 @@ struct iommu_hwpt_invalidate_intel_vtd {
 	__u64 inv_data_uptr;
 };
 
+/**
+ * struct iommu_hwpt_invalidate_arm_smmuv3 - ARM SMMUv3 cahce invalidation info
+ * @cmdq_uptr: User pointer to a user command queue
+ * @cmdq_cons_uptr: User pointer to the consumer index of a user command queue,
+ *                  allowing kernel to read and also update the consumer index
+ *                  for a successful call or a failure with a CERROR_ILL code.
+ *                  This pointer must point to a __u32 type of memory location.
+ * @cmdq_prod: Producer index of user command queues
+ * @cmdq_entry_size: Entry size of a user command queue
+ * @cmdq_log2size: Queue size as log2(entries). Refer to 6.3.25 SMMU_CMDQ_BASE
+ * @__reserved: Must be 0
+ *
+ * Both the consumer index and the producer index should be in their raw forms,
+ * i.e. the raw values out of the SMMU_CMDQ_PROD and SMMU_CMDQ_CONS registers,
+ * which include the WRAP bits also instead of simply the two index values.
+ */
+struct iommu_hwpt_invalidate_arm_smmuv3 {
+	__aligned_u64 cmdq_uptr;
+	__aligned_u64 cmdq_cons_uptr;
+	__u32 cmdq_prod;
+	__u32 cmdq_entry_size;
+	__u32 cmdq_log2size;
+	__u32 __reserved;
+};
+
 /**
  * struct iommu_hwpt_invalidate - ioctl(IOMMU_HWPT_INVALIDATE)
  * @size: sizeof(struct iommu_hwpt_invalidate)
@@ -620,6 +677,8 @@ struct iommu_hwpt_invalidate_intel_vtd {
  * +------------------------------+----------------------------------------+
  * | IOMMU_HWPT_TYPE_VTD_S1       | struct iommu_hwpt_invalidate_intel_vtd |
  * +------------------------------+----------------------------------------+
+ * | IOMMU_HWPT_TYPE_ARM_SMMUV3   | struct iommu_hwpt_invalidate_arm_smmuv3|
+ * +------------------------------+----------------------------------------+
  */
 struct iommu_hwpt_invalidate {
 	__u32 size;
-- 
2.40.1


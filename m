Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B889C6FD45B
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbjEJDfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbjEJDeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:34:50 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E5B2708;
        Tue,  9 May 2023 20:34:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUj9u377C6xgshN1vntxfqCEIli+5SjaEi6UNcQo2Nir3oBTRgF49rcS2tF+N2LSK/p4DXrrv5aqGRAsDAqMmZjVhs2s42U6HAplw94aIWKm/8B2tnAw/7gVC6HYCIPvRomXYIlY8g2dzyCD1Kt8v7v7ANCF4mte+eLEUJZbENO7lr0yDKw/xwHIpVQrlGm/PD4QmBm6w7egrD9Upqq7xcExAQXGnFF7cwywTgV0TofE3BjLL1TAuye+ydgjkWs3Tp894VYFOkQRJwXq5/n8cZaFWa4tg9K/VNBOZsB8Pew3OKu8RIN2lLlZQEEw4qGjo0BJrMBbVrf0NujLa6ly3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KilUKsgNQaYyodsalejBktPmpC1gJMYroH2P450/6Ew=;
 b=dnsFl/dXAQbmaML698y59iOUfVy6lwKO8WUFgRv7gA6lgUB8Ig14xl4zmnaK60UGP4bZKwMoGwb5Zu+GIpFM+cs//PMyjBh26j1GuEmo+HYm66bxYHIn12Qdfi/nC1BQFnLce5qa0l+XLX/Eub26mnZGc0/D9VUTH2hTkenZTahpd/Ic5L9v5hXMrBFw0Es4NlTOEEOgMbrpUxOBPlJQ18zGqNRKNR9pK73YOVIASLCxpRgVkxq0f+I6P3CuF6oiPOFVcxqSzsZxRvpmD94WdWZwsi9X0acW093HPTCbRgiQ44M/JvH0erLtYVZWnrEmPfVxPAF3uyMnifSTf4R+xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KilUKsgNQaYyodsalejBktPmpC1gJMYroH2P450/6Ew=;
 b=kAJ2/biJJAlJooQL06FzDI+0lzyIktOszM/3YpeRLyCXBbc/ZrRd8QPsfA2vQJSE40ntHOZu6w8o8FjbqAfuyhHwXdRqaU3uxCA4U52cHmtAjwPDDjUYYRBptn4geu5rtILzke2p80hpoa4pHNY/OL55Q7PH8mSTFrb75+mUEPPLhenovd2AmChdYCnhjjmw+DD8ejrwRZSd/mJPNO2sKb5fQviJGIrnG6XzC2QGFoVifGDQBHte/7iHaKZ5kvKknXTvbrDooZwzAXLxm8JwF/lzfn7gg6kKHKKRsxXdTvBqBSA670Ya0mPxQWzdUkdfAexS7RPLoUTftti/u21/Rw==
Received: from MN2PR11CA0027.namprd11.prod.outlook.com (2603:10b6:208:23b::32)
 by BN9PR12MB5162.namprd12.prod.outlook.com (2603:10b6:408:11b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Wed, 10 May
 2023 03:34:32 +0000
Received: from BL02EPF000145BB.namprd05.prod.outlook.com
 (2603:10b6:208:23b:cafe::cc) by MN2PR11CA0027.outlook.office365.com
 (2603:10b6:208:23b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33 via Frontend
 Transport; Wed, 10 May 2023 03:34:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000145BB.mail.protection.outlook.com (10.167.241.211) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.20 via Frontend Transport; Wed, 10 May 2023 03:34:31 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:17 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:17 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:16 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 07/17] iommu/arm-smmu-v3: Remove ARM_SMMU_DOMAIN_NESTED
Date:   Tue, 9 May 2023 20:33:27 -0700
Message-ID: <1cf96ebe77f52c9f9114827ffb905ffc17a570af.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145BB:EE_|BN9PR12MB5162:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a6f6353-193b-4dd7-34cc-08db510777b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: viwcTidQvCWMZor8jDZgZ2XE1R2vX2GbLo/dAuN7oT7r0Aao+fJkHdiWKVmYmUVWOoYjaEalyMFZgzqQsVvHEx3WjR4FBGoIEL8YAhlxUMxHABcqr/7x2tlcY+uOwp4b0o8ZEjj7PF8xu5ZHFWD+1jnVR1+S9RbmF3sLVyVsq/+HJzT6vqfWIDZtlhzXZREQqv2qEu5o+DzY52sigkS6UMfyQDME/oFMZGqKusvloFJMQ3jHFEzseV6jm1dz3tg/wg9/y+WdCyv8Fky+fZWKEo+viTifbfvLzFyZN5mGsWRQLFe6Ry9dSsfGEJT3vAXYjrzC4JHYJiw/q3HSIiORA4IMvVycWoQk9tGM89okBmRWyASBxy/PMyBaRTnjdBSHzHQdVbVUcATilQaHdW0BwRl7ODFmoThbHpUEarmqLwfadWI5TWt0L6G+a3I3jNs6Edd5mf46XPeLzGdmlq3OBP8hVVsBxrsZw3TdXc0axbzkpk1gzVeMcVF+e7BhyF0XZcHdPHtN16FFNjbGBVmO/azY20GkIzRjnJc1PMbSwIN/ye8yb72XgxQ7T1EbzO6GUs8KhayikdED77/oMOq0DsZ7pE3md1NnOGS/xj7qnDO7hpU9ZutXDVUVEGUGs07a/ez+M7BbyTOyClhjP/m/HIwYGXS2iF1qZIFo40DW5UwXfkGvAcOPEZPG2bqw/JjU5DN2dLlebuj+7GuQoJx55sCm30ZZaTEyB5VT23fi22Gjg+vkTb6E5Up2l4lDLb04
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(2616005)(86362001)(2906002)(83380400001)(186003)(36756003)(4326008)(70586007)(70206006)(26005)(47076005)(36860700001)(426003)(336012)(5660300002)(7416002)(40460700003)(7696005)(82310400005)(41300700001)(54906003)(110136005)(6666004)(40480700001)(7636003)(356005)(316002)(82740400003)(8936002)(8676002)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:31.5879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a6f6353-193b-4dd7-34cc-08db510777b3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000145BB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5162
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

IOMMUFD designs two iommu_domain pointers to represent two stages. The S1
iommu_domain (IOMMU_DOMAIN_NESTED type) represents the Context Descriptor
table in the user space. The S2 iommu_domain (IOMMU_DOMAIN_UNMANAGED type)
represents the translation table in the kernel, owned by a hypervisor.

So there comes to no use case of the ARM_SMMU_DOMAIN_NESTED. Drop it, and
use the type IOMMU_DOMAIN_NESTED instead.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 2 --
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 327819663547..c57c70132c0b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1291,7 +1291,6 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 			s1_cfg = &smmu_domain->s1_cfg;
 			break;
 		case ARM_SMMU_DOMAIN_S2:
-		case ARM_SMMU_DOMAIN_NESTED:
 			s2_cfg = &smmu_domain->s2_cfg;
 			break;
 		default:
@@ -2229,7 +2228,6 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
 		fmt = ARM_64_LPAE_S1;
 		finalise_stage_fn = arm_smmu_domain_finalise_s1;
 		break;
-	case ARM_SMMU_DOMAIN_NESTED:
 	case ARM_SMMU_DOMAIN_S2:
 		ias = smmu->ias;
 		oas = smmu->oas;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1951a80af241..e9e45ce7a899 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -706,7 +706,6 @@ struct arm_smmu_master {
 enum arm_smmu_domain_stage {
 	ARM_SMMU_DOMAIN_S1 = 0,
 	ARM_SMMU_DOMAIN_S2,
-	ARM_SMMU_DOMAIN_NESTED,
 	ARM_SMMU_DOMAIN_BYPASS,
 };
 
-- 
2.40.1


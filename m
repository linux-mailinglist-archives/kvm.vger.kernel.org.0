Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEC956245A
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 22:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237256AbiF3Uhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 16:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237243AbiF3UhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 16:37:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063104882B;
        Thu, 30 Jun 2022 13:37:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RakfE45KZrEFPPdqka9VoxV2PcQkQhd68B247y4UwoyAhH7i24rSsOgSEGSLWw9QjCMlvNPY6Ey3iBSZyKLP/W2aCOS4obhCZT8UnrQmNWIO5tjpH13La80YdU+H5rvBg6sGkWznci85pHk75WdZd2HFPDauI4Dq5YJqIKu46ef2NhjcePk2DWKriAs1DGW8IEEDt4yBtmAi+d+Cs9jiZdcDMGxjuW/KMKlpJJshTG2OpnX9WUY4eRSmh8JCfiM7NP1wRR4pf+FIpG2iUzkHqYhyMKS9v3XgoVlcoMPG0kFyz/+u42eNwcJzpIdxqZxVi1GBdQwP66xkrro6zSF3YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iiLl+1qlIiZ2p5XtsJlrm1t+tPCrFaHsdr1121XcM/M=;
 b=ZDnT4Ispy/MVgyWVQGwQuC/MnZ6G5Hp6lSH/85hY3Swi6XQuY7/f7/UJBuvHzdZS6KABUDUfNdNwInfXKOVyWYq7tqTzZ/F8ZetqlDVKE768I9bCnOMSQKYCnDmX4UbAsnwkC9m7S8VqDx1RWaNCCdk8hGUr5Clq9x7uSaxYeXof4Ty9YERfXilIVbksx31JDyxymVEZSvD+2LCbZiD3L5yJMRj7VNKdUGMArSccvvRg4dijMIspwedou7MlW8TEJeTxbog8gQsDkKhW32I70aS8ql/rcbTnAby+ES6YsmWa40IAUG2Q10ifhQ3YTqKi5am8uqhtduXJrMQZAevX5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iiLl+1qlIiZ2p5XtsJlrm1t+tPCrFaHsdr1121XcM/M=;
 b=EyYLUsqfXq4lBhi35yZxln1Z81KSQspUQJue51KxYXV3NNIZnmR6sUg4eBf444o7H8XCd/QN625C6VsWAVkK+q3bhw4TFFUQUiBnwoTBZQm12jk1fjt9FL4N5alywVUP8Yo0wDHotAA/maNumCzoHGghr2YIlAskMCIoZqg3pL1Eir0rtErcY5yajejcLAr1hoiTJPZbxK+vUubkitKaxDPjsKzaBsDAW36xQbjSiUBOR+/5eeAP1+VtpfVgS8MUgpLbrh/J5RDQKm3B5BHrT4Rz2OyV+y5EujcqfHKXpFC0JcQaoRuKWE89/25x3mK89jzt9MFKTllnP9SgV1vaDg==
Received: from CO2PR04CA0149.namprd04.prod.outlook.com (2603:10b6:104::27) by
 DM6PR12MB4601.namprd12.prod.outlook.com (2603:10b6:5:163::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.14; Thu, 30 Jun 2022 20:37:06 +0000
Received: from CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:0:cafe::aa) by CO2PR04CA0149.outlook.office365.com
 (2603:10b6:104::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Thu, 30 Jun 2022 20:37:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT047.mail.protection.outlook.com (10.13.174.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 20:37:06 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 20:37:05 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 13:37:05 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 13:37:03 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <baolu.lu@linux.intel.com>,
        <orsonzhai@gmail.com>, <baolin.wang7@gmail.com>,
        <zhang.lyra@gmail.com>, <jean-philippe@linaro.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>
CC:     <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <thierry.reding@gmail.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <chenxiang66@hisilicon.com>, <john.garry@huawei.com>,
        <yangyingliang@huawei.com>, <iommu@lists.linux-foundation.org>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH v4 3/5] vfio/iommu_type1: Remove the domain->ops comparison
Date:   Thu, 30 Jun 2022 13:36:33 -0700
Message-ID: <20220630203635.33200-4-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220630203635.33200-1-nicolinc@nvidia.com>
References: <20220630203635.33200-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f630e631-73c6-487d-5c54-08da5ad84c08
X-MS-TrafficTypeDiagnostic: DM6PR12MB4601:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?EQBRonUZOLE/0u2ORBuMgcQvpZlwROFXSjwk5QyAGpXGbe7KTUMkAspRxXCd?=
 =?us-ascii?Q?zOnVE3LFRLTwmVJOph7hD70FpPUGr1Gj40CMYrqPEikZttuM1yE6wnszdrH5?=
 =?us-ascii?Q?jxdeuuBK9LHezFBv843pzvTO6lSk8Rl2v5dJne97YzJ71UKdVwRbTQG91H9B?=
 =?us-ascii?Q?Syur5Kn92ghT3aWBZg7Z+QKBm0lUitvNijvYuEOvEqu53HOJcRlGBZT4+UdS?=
 =?us-ascii?Q?RJqK1RGPRUvpov5ByNVTjagoKduu74FdV8s51aXCJtN+cCluZvnfF0+ogxjN?=
 =?us-ascii?Q?3VVzjiVekT/HsZeJ8MyxMDaXvXY305zlvp95ojSqUcucev90Mc7NyRcAY/jy?=
 =?us-ascii?Q?owrAr9dqhFfwXFkfbHigg0FDpfpGY8inhYV0fnpMlbKwq/hdgiTRPpveqFQq?=
 =?us-ascii?Q?4mrRA8qOPIKDi49Ej2Jf+Lo+EvJ+jFG8Y2ENd9vKMrppyMwg2zwGbyRcRFYm?=
 =?us-ascii?Q?9SMeJ5ovMOnvMtu/n4PMP+b3QN7wl78BIVGhkp+1Ba/Uc+XrD/KPM1rE4lDq?=
 =?us-ascii?Q?ne6P6cWhf23C2eGhgwiBheyL0Qn9cO73cZgOuvmqwQejpvbCGDODqCBU1ecn?=
 =?us-ascii?Q?uz7gIFeR7z7kWCpprHPOw61N5MkKC/bY+fxtZE/OirD+hH0PmT2vOy2679OV?=
 =?us-ascii?Q?GE6YWthHUopmrO0GgU1EZWwduM6UM4bSC4rkcrdOf+e+Se3CpW7DC3ew+Ae/?=
 =?us-ascii?Q?9gYeduiUFApu53/k5IlHQzMuusA9A/5jcUYZzzRTSPHmmBRwfbc9+gicQMD3?=
 =?us-ascii?Q?iWCBYE9rZrPzvaRd3J2CKiwFfz5mlNX3X/grBQVy7w7LuZ91oNgRoYarsQxl?=
 =?us-ascii?Q?QZl5aYmVEwCiSnfABBuY8ZiNpCByy60+z5b/cf2w3ZuRRrX8iZI+AjC1POMH?=
 =?us-ascii?Q?rvgBNLbITZZ6JK4rLjZkV/G35EyBRSxobb7JYI3QdBircdCniE/6zln6gdgJ?=
 =?us-ascii?Q?5m4kU5f4VvfLy3BZ00KptASd/yf1DoMjpzMlzUt1liVU6X3/Y9hPgYP4L5DO?=
 =?us-ascii?Q?iXq5PLMmc8fFE8YNzzChsPJBvx1fCixZtxtDI9+G5gogoC0=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(136003)(396003)(46966006)(40470700004)(36840700001)(36756003)(81166007)(2906002)(7696005)(40480700001)(8936002)(41300700001)(82310400005)(7416002)(36860700001)(83380400001)(966005)(5660300002)(316002)(921005)(1076003)(426003)(336012)(4326008)(8676002)(356005)(6666004)(86362001)(186003)(26005)(82740400003)(54906003)(110136005)(70206006)(478600001)(47076005)(70586007)(40460700003)(2616005)(7406005)(83996005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 20:37:06.0304
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f630e631-73c6-487d-5c54-08da5ad84c08
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4601
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The domain->ops validation was added, as a precaution, for mixed-driver
systems.

Per Robin's remarks,
* While bus_set_iommu() still exists, the core code prevents multiple
  drivers from registering, so we can't really run into a situation of
  having a mixed-driver system:
  https://lore.kernel.org/kvm/6e1280c5-4b22-ebb3-3912-6c72bc169982@arm.com/

* And there's plenty more significant problems than this to fix; in future
  when many can be permitted, we will rely on the IOMMU core code to check
  the domain->ops:
  https://lore.kernel.org/kvm/6575de6d-94ba-c427-5b1e-967750ddff23@arm.com/

So remove the check in VFIO for simplicity.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f4e3b423a453..11be5f95580b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2277,29 +2277,19 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 			domain->domain->ops->enforce_cache_coherency(
 				domain->domain);
 
-	/*
-	 * Try to match an existing compatible domain.  We don't want to
-	 * preclude an IOMMU driver supporting multiple bus_types and being
-	 * able to include different bus_types in the same IOMMU domain, so
-	 * we test whether the domains use the same iommu_ops rather than
-	 * testing if they're on the same bus_type.
-	 */
+	/* Try to match an existing compatible domain */
 	list_for_each_entry(d, &iommu->domain_list, next) {
-		if (d->domain->ops == domain->domain->ops) {
-			iommu_detach_group(domain->domain, group->iommu_group);
-			if (!iommu_attach_group(d->domain,
-						group->iommu_group)) {
-				list_add(&group->next, &d->group_list);
-				iommu_domain_free(domain->domain);
-				kfree(domain);
-				goto done;
-			}
-
-			ret = iommu_attach_group(domain->domain,
-						 group->iommu_group);
-			if (ret)
-				goto out_domain;
+		iommu_detach_group(domain->domain, group->iommu_group);
+		if (!iommu_attach_group(d->domain, group->iommu_group)) {
+			list_add(&group->next, &d->group_list);
+			iommu_domain_free(domain->domain);
+			kfree(domain);
+			goto done;
 		}
+
+		ret = iommu_attach_group(domain->domain,  group->iommu_group);
+		if (ret)
+			goto out_domain;
 	}
 
 	vfio_test_domain_fgsp(domain);
-- 
2.17.1


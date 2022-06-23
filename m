Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82EEF5589C8
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 22:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiFWUB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 16:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiFWUBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 16:01:49 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE863A722;
        Thu, 23 Jun 2022 13:01:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/9CMReayZBOn1ygd2ecmJGVY7DOuKrYNstgTJpspixhjSxAANL45XZIHR2l80dcr4ELNMW+beEl9hzPvd4csnntZvdaowb57OXnt4hI6Baa7zUPf/HtxLKQyMVhinq3ywdcNVQRdN9j2h1Y0KFkGznrbJaIhIyTGpj1M2giu1w8RoQXg3ZvRqW/sBi4YHVt/QexLyqb5vcUbqW7lEQ8/3lWpw76dUnC+MouOW09VZ/76o4vtbtT4FF/Gz/KwGLxoB/W1wM9QqLRB2WHt1jVXxzeVQ+Q1P3fFbmNmw1tz3qtkyFhtJitguK4xLgPx6iotp3+JO/Tus/18C/80RhdPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RpJ/cMMHOAAeva/rgHTbXEVWpkRp2h2y74yQttJGbTk=;
 b=FQWAHQZGhsItCcQKja7seG8UpyYPFdzzke4oqz8uMokFGt0YnBYm4nPhi4jeumbDzCWSsWwyMylqsrXZvywjg0pBVGi2ADR/WW1D5JEdAdpHp3WtPp334sMqtXgWMHCThKq6Ct3jOb3blBE242yv2hlkmbQZLT+jyc7EX090eSFx+/xC2I0OZCzzRK4Gt82AWvnek1KG/4f/CKkkLQvSCnhvYQu33kSX46BNfQRPltA3PkcjNg22Z8YvShqdVWQBhunthvEEclWyzJ1LYrnwrji7RTJfNXJ4PlTZiX7pa1ZFbTb3GF1FwGvFAWyac6yPqQlWLs1EvLOR/8KoBOUPOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpJ/cMMHOAAeva/rgHTbXEVWpkRp2h2y74yQttJGbTk=;
 b=o3qYFm4x16wY3f/OJcRnIND/ctz0sMPykoUZj3znGdj80GTBQqH9a+n8UuSFOE1Rk4HPVXZ0PBel0c1oT1HgLuK9tGY7psd+0arUr1RRmcVaTZEmYxPlXniv8OKUBsrS84jF9JgU26qkdV6dV9CZSFRNUR63x2+I/mEblAIQ2EqpmSGcuqIebMIlrdcIKrU6Bv2Hx+6XrBZL2hki943AzG+R6PW8SyXvESEmGDWT+RmFD1rrdnJyddrgKW7i04SL5CYpvakYtLgiw9aP/cf6SpIpgiY4Quke6qHEOm5PmxEpH6EknZFcI/lgqb+AKMBaXTyHzSPwKeuiieDlbQRCtQ==
Received: from DM6PR06CA0060.namprd06.prod.outlook.com (2603:10b6:5:54::37) by
 CH2PR12MB3765.namprd12.prod.outlook.com (2603:10b6:610:25::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.15; Thu, 23 Jun 2022 20:01:42 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::8b) by DM6PR06CA0060.outlook.office365.com
 (2603:10b6:5:54::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.19 via Frontend
 Transport; Thu, 23 Jun 2022 20:01:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 20:01:42 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 23 Jun
 2022 20:01:42 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 13:01:41 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 23 Jun 2022 13:01:38 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <baolu.lu@linux.intel.com>,
        <matthias.bgg@gmail.com>, <orsonzhai@gmail.com>,
        <baolin.wang7@gmail.com>, <zhang.lyra@gmail.com>,
        <jean-philippe@linaro.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <kevin.tian@intel.com>
CC:     <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <yong.wu@mediatek.com>,
        <mjrosato@linux.ibm.com>, <gerald.schaefer@linux.ibm.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <tglx@linutronix.de>,
        <chenxiang66@hisilicon.com>, <christophe.jaillet@wanadoo.fr>,
        <john.garry@huawei.com>, <yangyingliang@huawei.com>,
        <jordan@cosmicpenguin.net>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 4/5] vfio/iommu_type1: Clean up update_dirty_scope in detach_group()
Date:   Thu, 23 Jun 2022 13:00:28 -0700
Message-ID: <20220623200029.26007-5-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220623200029.26007-1-nicolinc@nvidia.com>
References: <20220623200029.26007-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a549c545-b365-4285-a2bf-08da55533174
X-MS-TrafficTypeDiagnostic: CH2PR12MB3765:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oXI9S+yoP+6Yq+ctwi/ubAqakKZup4PFl18u8YOw7ArHXSAtBim758E8OAw4lPss/MHBNB+2BNNHNucspUqnggiMpvdvuYVyL2xaCZNa2Kp8Ck0o3GLwFOoQV2pLMi4mG/rLYmv9NMT9VB95UizIG3Yi+owoOWBWQyChAa07jJB4L6ND99CV4E44M4IhERCs3b1h3XII/ZVr9Rxn+HBTNTBjcHHDxs1Zc3pHljodX0F4PRq512X1Acxp9a25kS8xLJWT4lxhQFIl1Yp/LlU9V3Ti+VhvQFfJLD8OGxQ+bda9J3ARZwP6tCthyMlG8Co9GSWV9MGbll7xObpj/LQZhdEek29m90s20zGsUyvBIt8iDY5xnEQuvD2V5TdWk6NIINRI/d817lM35zPw+7uQNMSb4CsFo5G3KJrmUW/vXnDBL3ssUnBiFMht9H0JqjmUu+tmmn1SO5ioKFUfzPsOuBkNq42dua/aPNs5Te6auUGHC5VPgYu79JuHTN63fjYQz2A2pD5KRO4XF0mWKS9+bqZdmvGOQAoHq55mz5vlNkGyWA7c5Uurp7vS+Cr7ggnj+0D3mlXWVdp7l5ZbzO6vWi1L8aKuq5hHSTnE+RkPr4AJ/SaNWRNl7kUxXR4iC3Fwt2zUM3dhizKInnXcFcoaZx5jpjnn0jBqyUiE3XmFgdsn4QTmCVTpp2dHKqXXV3kFcskr1PLZY3mnN83BEpzaTlK5THkp/YI94rRhphFlQo/uTIN23KQYCvjIzbWN2no8tnDuTL6V4KLM0FehZWg2/0PQUqUlOqkiGhGOkJdsrphXLvXTanLefUkUVCvoOJjSK4jAcCcq5ZXZbW7He9rhQHqoOn+FB5Vh4or3JhATyqwiEysdKqxWip5hTJX+DlpsufTq5/y+FOg41TdDutMnLp64Vpd3lydDf36QAIn7v80=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(39860400002)(136003)(36840700001)(40470700004)(46966006)(186003)(1076003)(40460700003)(83380400001)(336012)(47076005)(426003)(6666004)(82310400005)(4326008)(36756003)(82740400003)(81166007)(7416002)(70206006)(356005)(2616005)(921005)(7696005)(40480700001)(36860700001)(41300700001)(110136005)(86362001)(478600001)(316002)(2906002)(54906003)(70586007)(15650500001)(8676002)(7406005)(5660300002)(26005)(8936002)(14143004)(2101003)(36900700001)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 20:01:42.5470
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a549c545-b365-4285-a2bf-08da55533174
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3765
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All devices in emulated_iommu_groups have pinned_page_dirty_scope
set, so the update_dirty_scope in the first list_for_each_entry
is always false. Clean it up, and move the "if update_dirty_scope"
part from the detach_group_done routine to the domain_list part.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 11be5f95580b..b9ccb3cfac5d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2453,14 +2453,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_domain *domain;
 	struct vfio_iommu_group *group;
-	bool update_dirty_scope = false;
 	LIST_HEAD(iova_copy);
 
 	mutex_lock(&iommu->lock);
 	list_for_each_entry(group, &iommu->emulated_iommu_groups, next) {
 		if (group->iommu_group != iommu_group)
 			continue;
-		update_dirty_scope = !group->pinned_page_dirty_scope;
 		list_del(&group->next);
 		kfree(group);
 
@@ -2469,7 +2467,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			WARN_ON(iommu->notifier.head);
 			vfio_iommu_unmap_unpin_all(iommu);
 		}
-		goto detach_group_done;
+		mutex_unlock(&iommu->lock);
+		return;
 	}
 
 	/*
@@ -2485,9 +2484,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			continue;
 
 		iommu_detach_group(domain->domain, group->iommu_group);
-		update_dirty_scope = !group->pinned_page_dirty_scope;
 		list_del(&group->next);
-		kfree(group);
 		/*
 		 * Group ownership provides privilege, if the group list is
 		 * empty, the domain goes away. If it's the last domain with
@@ -2510,6 +2507,16 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			vfio_iommu_aper_expand(iommu, &iova_copy);
 			vfio_update_pgsize_bitmap(iommu);
 		}
+		/*
+		 * Removal of a group without dirty tracking may allow
+		 * the iommu scope to be promoted.
+		 */
+		if (!group->pinned_page_dirty_scope) {
+			iommu->num_non_pinned_groups--;
+			if (iommu->dirty_page_tracking)
+				vfio_iommu_populate_bitmap_full(iommu);
+		}
+		kfree(group);
 		break;
 	}
 
@@ -2518,16 +2525,6 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	else
 		vfio_iommu_iova_free(&iova_copy);
 
-detach_group_done:
-	/*
-	 * Removal of a group without dirty tracking may allow the iommu scope
-	 * to be promoted.
-	 */
-	if (update_dirty_scope) {
-		iommu->num_non_pinned_groups--;
-		if (iommu->dirty_page_tracking)
-			vfio_iommu_populate_bitmap_full(iommu);
-	}
 	mutex_unlock(&iommu->lock);
 }
 
-- 
2.17.1


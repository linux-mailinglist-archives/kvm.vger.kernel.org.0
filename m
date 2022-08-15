Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF4A593537
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 20:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240130AbiHOSVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 14:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240495AbiHOSUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 14:20:19 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734932A719;
        Mon, 15 Aug 2022 11:16:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hLMzVn2yMkrkIfEZ/eE4cLdbNQZLUdKpUDkYIeVtjLHq0vs/idtfpkTh0uCbpjX89Mq2cvx+Dl11zGG6H8LmovVmLKxZXpIe9POpb64KQ95c3RHdgmK8wXQ6M41JhGsf7s6YQ0rpRwyLBqrUw4sERW/rOQ/a4Aw+SCELbQ9tq5Ypp7+0Dkz0j5/4WRGqNA/i1mGb9TIAq2/j01p85oQiXM3qUmK/XRAryi5AGkHGOAzRCD8G/+2CAKFiC+RTPNG8zQc4e+tXjn+PbzMr25O8fTKu0y60QKmmqB2rCF/MPe1Y1c2Y5c31lXDNVXtUntfo6yuwJ/U1FpY41s5v559r2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcakuXyxFswuCTVAy8lc/1Px7kpmxatALTQ0BFKkvrg=;
 b=XlqIUei/fOa5PQFz2yu+5qWO3WF6ctlYoBeOeEqWDeW/qYEoSAppVgkCRet7PRocQSI4RhyRhacZ+ubhpyPhdmSpD3NiQvnSE1fJ5C7dKzJ3G0T4eHILUB5iUKRJ1tYW2uT8NTy5brultLyrn2r528XbRBP5tRW31Mlz/T/kiCaIOOtuawZSW+LqjZWri9vvl1hvxhLAKSGiqonch+ScFGJ+SrAHKq8J3UkU9F0XIOLOBTjiQVYtdYJNfn2ECnQ9aJEJbnml2ZeN+qUNq60TzvQmQBD0rGmnINzOoTGg6/beUlnT6SFlUT3rtnc5//EiyXRMIQbVpr7EBuUGqWc8Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=rosenzweig.io smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcakuXyxFswuCTVAy8lc/1Px7kpmxatALTQ0BFKkvrg=;
 b=RdMjUVsib/EQeYoY0hAPyk/lD8ZNhuvqMhoDOJAmzOGgGlBIjb4EkXFiCaBiaEKm6HF50/WTJu4647/0G4B/so4c6sCXbpO9A0F89Z3vyVRquiaULLxs56EKszhZpxB2Aj8tAGDiHwfRTQTcWpjyPTADZOU2djSHKeFcnLD/2OaZVmgIyX8r11vV5K+HIlob0yJrNYH9a1PunZEGS6616nbV8lW9WZ8NK4HqYORPfO6aP8yvBbMHIjZrL1qwEyRWJk4mvkipfRB1WuurFGZpO1m/+vpwdm2FDILJkbcpcrbxyZuO7+9iI4dLZu63eFH6/ilcVjZJVzVlIr0FMEnnXA==
Received: from DM6PR12CA0010.namprd12.prod.outlook.com (2603:10b6:5:1c0::23)
 by PH8PR12MB6721.namprd12.prod.outlook.com (2603:10b6:510:1cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Mon, 15 Aug
 2022 18:16:38 +0000
Received: from DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::54) by DM6PR12CA0010.outlook.office365.com
 (2603:10b6:5:1c0::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Mon, 15 Aug 2022 18:16:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT113.mail.protection.outlook.com (10.13.173.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Mon, 15 Aug 2022 18:16:38 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 15 Aug 2022 18:14:53 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 15 Aug 2022 11:14:53 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 15 Aug 2022 11:14:51 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
        <alex.williamson@redhat.com>
CC:     <suravee.suthikulpanit@amd.com>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <alyssa@rosenzweig.io>,
        <robdclark@gmail.com>, <dwmw2@infradead.org>,
        <baolu.lu@linux.intel.com>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <orsonzhai@gmail.com>,
        <baolin.wang@linux.alibaba.com>, <zhang.lyra@gmail.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <jean-philippe@linaro.org>,
        <cohuck@redhat.com>, <jgg@nvidia.com>, <tglx@linutronix.de>,
        <shameerali.kolothum.thodi@huawei.com>,
        <thunder.leizhen@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <yangyingliang@huawei.com>, <jon@solid-run.com>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <asahi@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kevin.tian@intel.com>
Subject: [PATCH v6 4/5] vfio/iommu_type1: Clean up update_dirty_scope in detach_group()
Date:   Mon, 15 Aug 2022 11:14:36 -0700
Message-ID: <20220815181437.28127-5-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220815181437.28127-1-nicolinc@nvidia.com>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9b34f92-e9f9-4975-5d64-08da7eea4ba2
X-MS-TrafficTypeDiagnostic: PH8PR12MB6721:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ExOFm/y6kqAJyyXyMEHI5xa77a/BkOIt+blXUTjRUVi06Zd+p7EjYkBbHhVjHsPaSuVUp/oRq1Bjf5ewy/+7BvDY1VtcjsKj7lvYhdAhoBRL05ze0NM4RHM4ZcOSewvAqjB09QLMl18F/zPxR47s4sSqisXXuJQQjZXfsxE9xsQxW8XJXYNi4+XvxUFKvxYGY0VqtdwdMD4PL0C80HMQsIRUCT2hiXIxFZt0qauDTBANjy2UqqKmbqRUeNP5U77xgUaRlhbwfagAHTwr2ZJShhMdT52VABJgONqmcuDL+osDY26zRjQVAw+C77YGKEBOcz07NQxUeNjH37AZ/04I9jQuEUyKim2tduR9cb5RBH1/ulkD1/QUiDNBLAaFuO3Z59WnN38fcq868EA9HhMkn5OhB9sZbopJNGSQ38S6DJpFdWZQVt/MkEJZnPq2jqYkRvsU3bb+KD2gtTACzioU208kR/O/sjuNkhJRw6XMVaLNVTbCc1Iza3dUWYFe2O19/yZb/Fq41qLdiUMFn0qqn3SFSgpLuIUb/nGlNIOeXAM21QPS5OeuNt6H/a5UBYqHB1ZLgVkoS09Vxo0h6yUQD3/cXUER/GxJqqmC2tjYD3fiHySghk0+O7n0OGE2AYSyYOUOGbafdM8dHyaik6rtaynbQ0emh+sYL7pHZ7X3qlDw07/BLW4GltxcSBoDgAncX6JOGL7dcCFdMl2AtYKkGCGGC0TSNJjkiIiW4NpKmcwO7jkVkMIh2sXEDMVmSWrn5W4zTkvrzKiv3UB9ThjasB5qKf73tf1i312M+A3DdQDbVbKeXGbxSMv8mCqa6eu+YqtcXccKufwILAhXhcIiXDCpSV7H9/ZLon7Jo8kfyk=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(396003)(376002)(36840700001)(40470700004)(46966006)(478600001)(36756003)(6666004)(7696005)(86362001)(2616005)(26005)(186003)(1076003)(41300700001)(336012)(426003)(47076005)(83380400001)(82310400005)(40480700001)(5660300002)(70586007)(8676002)(4326008)(54906003)(110136005)(316002)(40460700003)(70206006)(81166007)(356005)(36860700001)(8936002)(7406005)(7416002)(82740400003)(2906002)(15650500001)(14143004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 18:16:38.1319
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9b34f92-e9f9-4975-5d64-08da7eea4ba2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6721
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 523927d61aac..3b63a5a237c9 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2464,14 +2464,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
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
 
@@ -2480,7 +2478,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			WARN_ON(!list_empty(&iommu->device_list));
 			vfio_iommu_unmap_unpin_all(iommu);
 		}
-		goto detach_group_done;
+		mutex_unlock(&iommu->lock);
+		return;
 	}
 
 	/*
@@ -2496,9 +2495,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			continue;
 
 		iommu_detach_group(domain->domain, group->iommu_group);
-		update_dirty_scope = !group->pinned_page_dirty_scope;
 		list_del(&group->next);
-		kfree(group);
 		/*
 		 * Group ownership provides privilege, if the group list is
 		 * empty, the domain goes away. If it's the last domain with
@@ -2522,6 +2519,16 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
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
 
@@ -2530,16 +2537,6 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
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


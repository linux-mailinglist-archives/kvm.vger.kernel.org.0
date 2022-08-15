Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C985934E3
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 20:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239753AbiHOSRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 14:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239469AbiHOSQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 14:16:38 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAF32A429;
        Mon, 15 Aug 2022 11:14:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enbsh/gZhks53b2941Kv0NJjbaH6QaODQHh4I4xnuxxOfQnyrhl9VVAiYdSTRxz4/VElBBnI8isDLrMZYILteC/LAYYuVokHNZE55o/c3fxUzOKeKyqxk3/8O4qvoddN3ZhL4TJbmlQ8eAklje1sP8zVJG//jR9Sqm3Yx9AfynLeL6/HyzrVP6fAAa0h7ywTNQQWsMANGXbNsq9DrttsMkALRoNg/p0YX10XDjhylk2nMu2JP2LMWthEiFzynCEOXl8H7Crh/pBqnrHxDNiuCik09koBWLVIIERkyW4k6wtFPp8uolHiMA3ewV5ZW8GOvX28Bjm5h2eU4Vwir+0UrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qpnpNwONrQeADt3Y29AcpqghT/neGKgKsz7BqqQHeHQ=;
 b=nl1OohM6GwU02CSXjqfMaup6eXUbiUmrjpKeuznBJJlVPixYKdP/Z+Ibg4P0DjaeC2uQpBWfI5oNxUNGAYyBi30X/z9FZ3mWNeOCT6Gge5Bnb+aJ7cUKl8zkyvXjW2E9lud8i4hLy8+QR7SMstDyHFILM25wQMgWpuYoQ4WaWfSU7nYVV0QSmAfBQo7C2mate9b7YE2X/dY2n9TxJa0VXqUkz/rh0YHzIPMqk9Aob+FGXgBWjMcluE9RI1dVxoIjcV+xlxi1HzOn4ggITNlOmjGyenTWmJqWkqubyxk0TiO7nWl2HkhYyxZ2zuYpbrilX5FJsRyGmdAGrKddV1RnUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=rosenzweig.io smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpnpNwONrQeADt3Y29AcpqghT/neGKgKsz7BqqQHeHQ=;
 b=QT6tez7TV4kxYK52kJd6dJcr5R4Br9Twa4ltZt+kVrDwUCfDrjbh003sP4CZZSUekEWsBwCwd/seAlVY38ynxsRFXOUocLU4j2UibtxlBGF3HithMufjNuUnzRLQvkIcYI8COcWLQEQknussymfQL8vvdqD4idbYX7P3ZE4BVB4sPnMj2wSZ9lnL7EoPFsOZsEStKBym1+arMXBbNEHgmT8pBDKiJfwhrBZFvTd+5vVD8BcByAK7jo08iE2zc96IavqUsUrZMzbb6AoqU0wTFqio19IJHdloTWdAx+OPwBsZxjlEszEfaTxMhfIrz9Wato40nLgFyZOVJJe3p953Lw==
Received: from BN6PR17CA0024.namprd17.prod.outlook.com (2603:10b6:404:65::34)
 by BN8PR12MB2849.namprd12.prod.outlook.com (2603:10b6:408:6e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Mon, 15 Aug
 2022 18:14:53 +0000
Received: from BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:65:cafe::4b) by BN6PR17CA0024.outlook.office365.com
 (2603:10b6:404:65::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17 via Frontend
 Transport; Mon, 15 Aug 2022 18:14:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT073.mail.protection.outlook.com (10.13.177.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Mon, 15 Aug 2022 18:14:52 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 15 Aug 2022 18:14:51 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 15 Aug 2022 11:14:51 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 15 Aug 2022 11:14:49 -0700
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
Subject: [PATCH v6 3/5] vfio/iommu_type1: Remove the domain->ops comparison
Date:   Mon, 15 Aug 2022 11:14:35 -0700
Message-ID: <20220815181437.28127-4-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220815181437.28127-1-nicolinc@nvidia.com>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92de01a5-53b0-4d26-9bdd-08da7eea0cb6
X-MS-TrafficTypeDiagnostic: BN8PR12MB2849:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7XAL1soosE8cJlW4iZAxAZehDcxIR3gTd2K5bI9U4Xa2ZvNaUAl5+/lhsNJq?=
 =?us-ascii?Q?rx1QtmJQzwx90OGql6Fh86FDwdj4llPPJBwI9iTj6JTdXtAu0wfFYE54cDZp?=
 =?us-ascii?Q?RxoVJRUUqJDLc/t6f5V3uvXMVBMDMUMAAXclpb2EjE/FHvb4qztrIJwkqHhY?=
 =?us-ascii?Q?ewPUaRvQpIpN/sRjUZiw2SzskihTK7sz1BKcTbT5thuwZbwvv3dZM4A46pt6?=
 =?us-ascii?Q?cI35RzB+aNW5wkGBYOgpBy1gNJCrh4CH3QOhYA8Hx70tqFXTNoB6LiAs8jVT?=
 =?us-ascii?Q?MxUnrprzWO4BejPqAs2GFQm9wOwjkN8VdzARvuD6Ew+qTOaeU8dxCRVP/zlM?=
 =?us-ascii?Q?8gARQ8MqVwIDEJrFfL3apUOp9iFrRoQXcsxxnJ/6UwvdEwiIAhZ4fGt1GMTu?=
 =?us-ascii?Q?Vc+lH6YIAD8NQNkSDlHSmk5H+M/DVa7OOsFN1AGjg78NB8vF/Klit9r1JjUo?=
 =?us-ascii?Q?3xpNIsnmgFH6LFp6cfH2GMuSD28WwIO43oEIrXavyK6wPPrg58/RDpUxNMcw?=
 =?us-ascii?Q?TdKH/mh1pyR0dhkG6N50TZ0z0B44FDJIMaIaFMnXvk3TP47BZ61adOkFMqNI?=
 =?us-ascii?Q?ZJjwTJYKtWrZBtPSlicAdQvrV7TGoFjuV96vPjEMAOFQjOlPCNttGFj+y9KQ?=
 =?us-ascii?Q?7wq7xAA7fcw+a/I2ogFWlhADHlp7zN3d9JDk3UCXaGum5qKVrO4Lf8peBXqC?=
 =?us-ascii?Q?QjJP/AW3c9Q9GMWAk2r+qVAFfUlWYNuuCvcR9kDRUDk0rfuXIuYFzyvusReh?=
 =?us-ascii?Q?hVVHyTETvRjbLMEt6vGJPdBGmgzXVGdcAs6J7yxVGHZPupuVU2ZV1JfbCQvy?=
 =?us-ascii?Q?K0x5EYYEDpvjmEKd8qGuQIWpCioNQ+VduQjTYeXsKjcSYVcf7Pd/RfbS+EaM?=
 =?us-ascii?Q?Ye5o5Qa4ia6e5TDrYdo8DNhwAKCK6wYpYIlGzUV9wkcxeo7Lz7Le7Q2FOx3l?=
 =?us-ascii?Q?PWNBWgpiee8T6Zh65P+B2Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(346002)(136003)(46966006)(36840700001)(40470700004)(70586007)(8676002)(4326008)(40460700003)(316002)(54906003)(110136005)(40480700001)(82310400005)(5660300002)(7416002)(7406005)(8936002)(82740400003)(81166007)(70206006)(36860700001)(356005)(36756003)(2906002)(478600001)(41300700001)(7696005)(6666004)(86362001)(26005)(83380400001)(966005)(2616005)(1076003)(426003)(47076005)(336012)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 18:14:52.5368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92de01a5-53b0-4d26-9bdd-08da7eea0cb6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2849
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 88ee6aaf1c88..523927d61aac 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2288,29 +2288,19 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
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


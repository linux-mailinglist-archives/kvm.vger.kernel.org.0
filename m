Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94DE658B8E
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 11:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbiL2KQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 05:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiL2KNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 05:13:46 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C55513D5B
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 02:08:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Po+bmBhqEZiDNE6l/Uo7vDqSP2qBTJniehmkvOZfOaR+FX+NnAD38m+haLHTPssocahi17iBY1kCK9WOu6ujrTb2EsnjGdBxGp+8QVyfvuqi+P0AZREdGZtVL6MhiK8bjL+NjH0QjJ4Jm9FPm3UrSViP1xx9LsWefS7NWiKDcPBxfmcvFmKxf98MOx2M73BhrHqeHRLdfLVB0pwX0ODu6WrtXQFoUwVxurDl1TsIYlXz8kmqaCERJiUSVzy3dnKU3FjtH8Ax/8U7OZVnWeA8YsNxGhjw+mw7oY18s4yuC9XJPJz11z7/3KTUNmRqYacXx+ySbHzQ9Z5tB2ehPLqghg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yVl5ZCxDwtAQIqnOXSYR5+CBDbOPiF+dzxqRUGVZgaQ=;
 b=meJw6vbMozUUKRno1ty14q81YG3c0ivWMR8XorIAnSd+M3rsSQsZswHv8EY2kkCEdRIBkIGSPTn1adoPlrepMjIWGgk3wJN8Osub9KWS3dP5dxWGlyoIX9v1xsf0HKywa1YXzvI6KZxAiMjQSC3Xe6f5UHmAwBL6lJ2GdsicAT6EpElwzhClskY8gSmy6dZakKlhGFHtqROFWYjg8NpuRmbc9ItL4poabyhmVQF6m201PdOXM6Hflih40/NXY0GI0YkblLeE2IogE/ps8uvohga9B0R9ha8aUVByT9FJ2Ud/+TBYENeUKIVch/vTD9t+qg+u9ZfMLE7Z60gP6n3Kfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVl5ZCxDwtAQIqnOXSYR5+CBDbOPiF+dzxqRUGVZgaQ=;
 b=kpMVxRpbehvrgOVfnGKuyr6mOMrdyraovOjidYGLhElAFXu2FxHARQVNUVHBMJdRUpPvD4Fuc8Ec/NuqxAM6PhqOTHF+1egScJ56dmJDVztXnRCkp5dNS6u4Jd3AwOSs3WrRSURYPYkmbL6MtFcy5LYt2dxYLYPrbjbPGLq5Q4DbqJMlyFK8+6OFCTXpCEY9THkLygcJyx485zZ6zJ7F3Zisn2cYUv6BpQMQZWanFZD2WvZDP/OISPow3wG4UgtewE5Y0sr9i4OL2RpNCOUAw2Cj7QCTetH1F0GvCqe3g69X3B+r6F8H74JhUI7vY3dkZGUOgQ74icpSxW01BwJ+kQ==
Received: from MW4PR04CA0092.namprd04.prod.outlook.com (2603:10b6:303:83::7)
 by MN0PR12MB5908.namprd12.prod.outlook.com (2603:10b6:208:37c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 10:08:52 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::f5) by MW4PR04CA0092.outlook.office365.com
 (2603:10b6:303:83::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16 via Frontend
 Transport; Thu, 29 Dec 2022 10:08:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.17 via Frontend Transport; Thu, 29 Dec 2022 10:08:51 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 29 Dec
 2022 02:08:38 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 29 Dec
 2022 02:08:38 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 29 Dec
 2022 02:08:35 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH vfio 6/6] vfio/platform: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
Date:   Thu, 29 Dec 2022 12:07:34 +0200
Message-ID: <20221229100734.224388-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221229100734.224388-1-yishaih@nvidia.com>
References: <20221229100734.224388-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT066:EE_|MN0PR12MB5908:EE_
X-MS-Office365-Filtering-Correlation-Id: f0c67505-5760-4c54-ba02-08dae984afcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OnArHT5JIjR/Bzq++pBRQO7kzTx6iVa/aJ7FOkUyPO2pmwiUK3OXBlfRWHAB5OWqFQFhxNAlD7DqxxvkPqh3KS3Frv5lK1x/bm4Xh+HggtlZH5xRAJ9BvT3r6xvBlzns51luqqBFkHmBJ7uX2WpnJsZvGkKwFPvfrzkVTpYDLH7PFtTsn0E1in6H+LHLSCQwLb8V5mg4KvxuCJV2MWOjYEUu3pWAhMVgw0IdjIEvuaDPfgKZi1tyY3t8xjbSkll0ii5sDSkJ3RMGngVy5+zrg87lBEGuU9C9Mw93//FHKyDnXXBwV2bgZ32Xqh1VzbaIKhJwlEMzhopjXEgEAKnzU7oPSjZFfyAizG5JClwSQ9uCHdSdG+E0Sl5AFp8QqVqujfEJJ9BKKv5Is5e3eSn3bEAWQwOwUaag9cz7rJ+/2Axjam3EnJvHOUiS+/HezQ5ZRiONCb1ynTCVK9RFeFsz2bbHyLxyePh6KSRTDvGKbQpsvEQcZU5QtNF2Kqh2rhyz20eyCqO5t4zYtHztQjxY8Bax12Ma44jjeLjvZpD79/OFwoU+bxEIc8NYLB3DXhsl8zJqGTxKNk3nG75PmTO7Fd4BAlatnF9SVpUvsIHSFUafUctvF0vwMbY1xXDz5fEC3w7WN9eJ3qMB69xcHpPpKhyVCcbt9bvxwRDBGgOMjPYpsCuJfMdlKuGmthbfy3tiM9i5FDJl3MJy8Qf5A2o7/Q==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(36756003)(70206006)(41300700001)(70586007)(54906003)(6636002)(86362001)(8676002)(4326008)(83380400001)(7636003)(82740400003)(356005)(36860700001)(7696005)(47076005)(426003)(478600001)(110136005)(5660300002)(8936002)(2906002)(40460700003)(316002)(40480700001)(2616005)(186003)(336012)(26005)(1076003)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 10:08:51.9990
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0c67505-5760-4c54-ba02-08dae984afcf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5908
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use GFP_KERNEL_ACCOUNT for userspace persistent allocations.

The GFP_KERNEL_ACCOUNT option lets the memory allocator know that this
is untrusted allocation triggered from userspace and should be a subject
of kmem accountingis, and as such it is controlled by the cgroup
mechanism.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/platform/vfio_platform_common.c | 2 +-
 drivers/vfio/platform/vfio_platform_irq.c    | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 1a0a238ffa35..278c92cde555 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -142,7 +142,7 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
 		cnt++;
 
 	vdev->regions = kcalloc(cnt, sizeof(struct vfio_platform_region),
-				GFP_KERNEL);
+				GFP_KERNEL_ACCOUNT);
 	if (!vdev->regions)
 		return -ENOMEM;
 
diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index c5b09ec0a3c9..665197caed89 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -186,9 +186,8 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 
 	if (fd < 0) /* Disable only */
 		return 0;
-
-	irq->name = kasprintf(GFP_KERNEL, "vfio-irq[%d](%s)",
-						irq->hwirq, vdev->name);
+	irq->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-irq[%d](%s)",
+			      irq->hwirq, vdev->name);
 	if (!irq->name)
 		return -ENOMEM;
 
@@ -286,7 +285,8 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 	while (vdev->get_irq(vdev, cnt) >= 0)
 		cnt++;
 
-	vdev->irqs = kcalloc(cnt, sizeof(struct vfio_platform_irq), GFP_KERNEL);
+	vdev->irqs = kcalloc(cnt, sizeof(struct vfio_platform_irq),
+			     GFP_KERNEL_ACCOUNT);
 	if (!vdev->irqs)
 		return -ENOMEM;
 
-- 
2.18.1


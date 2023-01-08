Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D25C661646
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 16:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbjAHPqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 10:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbjAHPpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 10:45:54 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A2AAB
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 07:45:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvXYrryaik8LgxQdQe80NFlf1MBF72g7qSFMcURyXLuHw7d9QiLotlNlfjqS1VjfZfCmPU1Sy8T+C2F4Lwv+vRcSUY83W492IO9/TS7P9kz2M80ZNXt5pqZEw/pdSghL0E1F3sQ6ZPyqMtyHQzSQT3J5Q5ZKLPkwxrvRBiBd7ZBU0mCFuO4u7Po7bHrC14S8Vooyy/9+yFgOSl5mPXjo3TxFX/5GXjDKqiepCVMGtX+6vyEIwt4u56OD3KerK1EhfDkbwQwxpRxxiYia87VIjboMueC6Fe0UvSeJzjchFYB8rmHmvjOpWC48QoMhtu1uQNIHIhUG8lammEWqX5Tj7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yVl5ZCxDwtAQIqnOXSYR5+CBDbOPiF+dzxqRUGVZgaQ=;
 b=Penji9ZxBGYQlHu8gF3XMAh1PXZDI7wdkLn2JAG+6eMg2siH+9FxD3MBVb4LmcIzU08h9bzbqD705RVtKIkVoxowkKq5Kjb4fSrFxDJDKdeNWnHVZkIzE28eiLZLimwTUoeefU2A8wbOk2AUkUaDW3u2GO0mPIJqCGghBvtgbp9DmfaywZGWkgotoH27IUbFAbbNjimp+dxG/tTDh/K7//3w5ghd4S3u6MOpgqCB+YuFxjf2ze0VFbEoeY41IyGr6329cc0X1gAvKgGNAH9waswyQ5rHvOlF4Sql5ZfzJFJLS/f38/yB2YNrkraneDHuYVx/sL5/PHizcLgA4z1Lag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVl5ZCxDwtAQIqnOXSYR5+CBDbOPiF+dzxqRUGVZgaQ=;
 b=SCbZ9VqywfGGPEZDtMSbD9UnYCnHbZLgZDJYmJrufBF5tjUWMgxcEVbjQAFzYEd7FggPN6ZQhPO3aWGrjSObx/Ydu8abnNUGReFMVJIdsPWi8aNwO5LYPUmFt8YdHMNJdap25g9doeBKsRpls0zg/Nf7v+/VIn0X+pMfguwV0OeIXGyFfxKSjwe6iv+tpRh4qEu4BkHwnwbX7rnVJto6HVmVbtmF/ulJmkOWQzV37+ht02oxAZFDi+mOTevZSF/bgG1H+nYfPs2mLBKr/ONzwousCqs8Fi0aPkPyQxPXolTJX3NM/sRIAilRI1CHtbMKcDZpmleE+kKLLoD8G1Y1vQ==
Received: from MW4PR04CA0224.namprd04.prod.outlook.com (2603:10b6:303:87::19)
 by SJ0PR12MB7082.namprd12.prod.outlook.com (2603:10b6:a03:4ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Sun, 8 Jan
 2023 15:45:48 +0000
Received: from CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::7d) by MW4PR04CA0224.outlook.office365.com
 (2603:10b6:303:87::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Sun, 8 Jan 2023 15:45:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT103.mail.protection.outlook.com (10.13.174.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Sun, 8 Jan 2023 15:45:48 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 8 Jan 2023
 07:45:29 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 8 Jan 2023
 07:45:28 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Sun, 8 Jan
 2023 07:45:25 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V1 vfio 6/6] vfio/platform: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
Date:   Sun, 8 Jan 2023 17:44:27 +0200
Message-ID: <20230108154427.32609-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230108154427.32609-1-yishaih@nvidia.com>
References: <20230108154427.32609-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT103:EE_|SJ0PR12MB7082:EE_
X-MS-Office365-Filtering-Correlation-Id: fe90e122-1a62-4839-dac8-08daf18f69bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lzv3eC2pEss7q3dvS07avJ4zw6xQnV+HPDQBiTiUe8MjELliYWuLECRkU4mEQXJP5PiAjzFcA/oWJcMtF+ujCu2gkCyVz/59sj/KwmbHbpehdHlCSbrI7bnZBEUx5xL/9jGKhrLpKjFDrRYYHt+w/PuNby9/5tJ/C3O4Zz2sN6BOjb17sm5eRIw8d1itu+Gqs7B5HIX8GgENP1ueHbSoF8R7flgnTCLqiUdB5oOpFza72VPbg7jbX8VJKxWtjBPUIyTLSd2pn7VtoFQd3KvBR652OK5EinLGs5C7JAheMHNi8CYpOtrPfFeCBgbb5TgHx2Bmw6t4fnBRB6XeXoV2m/RYJKCQ5CKXNSDsATRHX6DT5oodkr+C+gC/zSTYADImS3JrMfHe4k44X6Z/lJ70e6vbHZTm1CHvXQpG5Wz/CTHaCjLQ5xZp+x4kSR4bBPkR8Y8AdaQ0ga1faEeI1k7+xhqRMwHHsfweAA3m/3NjfGeC8AZGKHI3PfVXhguHP624lbVkwi+2eeerTlsbVnveGxKtzc0pTfz5lO7h29ilUZLLNhwo/0T5M9ZTQrEvd5QoXe3zaBFm/E4t2jTZmi+x4yvD6QWhIt4krgFV7KBg3sqIUwZOJBQavtMTZpkRvSMzg6J9KdHsc2DutoReMBAw3jD1MpgFgpfmNeVrgGAmOxkZsNB+XJwHBsGuLRXkp7XFGG/pEjRI3roTH8oO5cZaOQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(346002)(396003)(451199015)(46966006)(36840700001)(40470700004)(426003)(1076003)(7696005)(83380400001)(47076005)(26005)(336012)(40480700001)(82310400005)(7636003)(86362001)(40460700003)(36756003)(36860700001)(82740400003)(356005)(186003)(2616005)(478600001)(41300700001)(316002)(4326008)(8676002)(5660300002)(2906002)(8936002)(54906003)(70206006)(70586007)(6636002)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2023 15:45:48.1542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe90e122-1a62-4839-dac8-08daf18f69bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7082
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


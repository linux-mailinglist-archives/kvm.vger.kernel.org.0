Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C59F661645
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 16:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbjAHPpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 10:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbjAHPps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 10:45:48 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE16FD3B
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 07:45:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xv7Ir2yTcR1hnJUHhmVSBlrnNCDBa5YHXUbp5vVfXPCcqzLQwOhqlhfWt+xGqUVhANTackiWfdB9Dutk9Tfm6JWk/ORl1mXeIfxjJjc0+d7Rkxtcm1+7JYUfUj+tDBFPrJjyt0E+UGGeL4L2UtHVpVunkqDkJ8eOOVQNopyjW/pIjHnn8t1hxPLuzcI4E5SM+Ypvlc8XuwhB4xpiFpwcIlHGFApZnKKPaRI7CI/OYV5N3ON6f9yDziAJbMJFdPi/kQf9fpBJLYwo9iyZrfM0CeeIyI8+QofMlph1MmJrcs6aNzz9mwLj1VPjBghvWtFrKcUl1mdfyluCoIUjqpGrMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0XGCOkgyuv8m0nwvRX4wOpn+ZvdjTqENu8sAo2WW1M=;
 b=bgvVYjbFGU7sN2NMFtI9vGCy2c5ZwGXrrBqPJMZfrXBdRHdBX7dXFD1gsWF4tJ2PttXGcqmQ1HxQuOHa/1i/gF7lOPOfFLOroSDJ8eAfoWqhA630BpxwB6nTwleyO0dCDdeqkksSEA6IA2npiw9/+WM7+5bg7wO3Ewa9W811ZTPR4GJ741xQvTcaSegS1wGfqLVZ6TzryktT4NEC3Y/o9rhKuARBA2Cjh3NX7ZHBV3qRdankKPsEL9+FjwZlnHfGSJGGZr+inmMSew6vA6vm6nFEZfY5kbLp6jZE7IXewVryhvb2evfJiHVnUXz2mpjJB7rbsqDaCGz/s1/YvCnM8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0XGCOkgyuv8m0nwvRX4wOpn+ZvdjTqENu8sAo2WW1M=;
 b=J4AvZYIwTVMzzyWoA/5QSAqoigN/IqbPBBD2XYy7QOmnzzqeHU0K+pHAm05J7b/y/eUUXluIJIRFk10prJZG9+HoDvNnJwwPnxpDlnp/Oyxrvkg1x8vkibzhcPgwDlRZe04iMeq88v9m8uYab2S7MDzTorOram0hZt8OoQ5+ZwdY2wTQLwlMdoKCyVxyM6T45iJoonYfdyST47ECVps++7ECnntHUGe86RuO8ERTDanNTiukoQ2omr5x1kN1FFeHV9STA7mc+bXMNoQ5mZQwIUpS0mrGXTNNIiHQTyuf0Btq9JkV33dUjVG4hZmgSsWLf1E+ZjvVZH+/X9fPCOdy+Q==
Received: from BN8PR04CA0045.namprd04.prod.outlook.com (2603:10b6:408:d4::19)
 by DS0PR12MB8574.namprd12.prod.outlook.com (2603:10b6:8:166::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Sun, 8 Jan
 2023 15:45:41 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::7e) by BN8PR04CA0045.outlook.office365.com
 (2603:10b6:408:d4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Sun, 8 Jan 2023 15:45:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Sun, 8 Jan 2023 15:45:40 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 8 Jan 2023
 07:45:25 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 8 Jan 2023
 07:45:24 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Sun, 8 Jan
 2023 07:45:21 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V1 vfio 5/6] vfio/fsl-mc: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
Date:   Sun, 8 Jan 2023 17:44:26 +0200
Message-ID: <20230108154427.32609-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230108154427.32609-1-yishaih@nvidia.com>
References: <20230108154427.32609-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT026:EE_|DS0PR12MB8574:EE_
X-MS-Office365-Filtering-Correlation-Id: c38d811b-3bf5-4fb5-b9e6-08daf18f656b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4TLb3AokNpfeUX0tZ7+kRcdvsHYYFH0OcFST7YC3yVsH67F+31Vrn/XWd4qRroK+ICGQpczAZJSXbJ/+wuqyQy9FNNJVkp1ti76OOgQR6EDYsdxtQ1mmh8BABbWqZCW/QK+owznXKGJtHGQ+ANWv9fjU7YC7Tn159ADGLmh3++o+MtN90HgElhwjopeBhKjT9p6IlKaQ3KGG0f38GerqVCc2HmjqhKYEZ2W4jocV/BF72zkDjqJy/qdSI2wp6Vmje/BklXwMO0fqrhs8uZdWQ//msOXLGQqx9rGLqee6LV5Oyt4YaFcvYJhinSWP7l9lW4xUILFgZtzyP8MjljnbsnR0wXq/aemEmMKA/YKYaEYnGXKxSwMFr6uVphYvZV23W2nesK+4KAN/XtTXaC+U63Rs0i708WF8a0hmadp78Tx7/uY0S+Pp+2YTKSRHeX1mgsH4uiSvjtIRZP8grECG7MGvKwLxrqmGwym/VyyLetM3wZ5CnShX35z/EGDCYDuZq7OCUmHMZQvsumQmiSU4nVR6WYYSCyWhE5k5mmnS9XmizTRajdGmWRmvFVp/V66EDgkcl7z3HZDJWp/4Nqz2tJDpKxwFkcheMvW/TSAa9L3laPTbs7+IfbjmhzyVab6Pd9cFkLM6mC4/usNGj/0Wr/buGdXUGHdL8Euei15iep0Sh88Qi+i8PLHcn5Nbnt2naSVTecRPJq4KdKIMb+ePhw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199015)(36840700001)(46966006)(40470700004)(2906002)(478600001)(186003)(7696005)(26005)(6636002)(110136005)(54906003)(316002)(2616005)(36756003)(8676002)(70586007)(1076003)(70206006)(4326008)(336012)(47076005)(426003)(40460700003)(41300700001)(8936002)(40480700001)(83380400001)(5660300002)(82740400003)(82310400005)(36860700001)(86362001)(356005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2023 15:45:40.8491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c38d811b-3bf5-4fb5-b9e6-08daf18f656b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8574
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
 drivers/vfio/fsl-mc/vfio_fsl_mc.c      | 2 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index defeb8510ace..c89a047a4cd8 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -28,7 +28,7 @@ static int vfio_fsl_mc_open_device(struct vfio_device *core_vdev)
 	int i;
 
 	vdev->regions = kcalloc(count, sizeof(struct vfio_fsl_mc_region),
-				GFP_KERNEL);
+				GFP_KERNEL_ACCOUNT);
 	if (!vdev->regions)
 		return -ENOMEM;
 
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
index 64d01f3fb13d..c51229fccbd6 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
@@ -29,7 +29,7 @@ static int vfio_fsl_mc_irqs_allocate(struct vfio_fsl_mc_device *vdev)
 
 	irq_count = mc_dev->obj_desc.irq_count;
 
-	mc_irq = kcalloc(irq_count, sizeof(*mc_irq), GFP_KERNEL);
+	mc_irq = kcalloc(irq_count, sizeof(*mc_irq), GFP_KERNEL_ACCOUNT);
 	if (!mc_irq)
 		return -ENOMEM;
 
@@ -77,7 +77,7 @@ static int vfio_set_trigger(struct vfio_fsl_mc_device *vdev,
 	if (fd < 0) /* Disable only */
 		return 0;
 
-	irq->name = kasprintf(GFP_KERNEL, "vfio-irq[%d](%s)",
+	irq->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-irq[%d](%s)",
 			    hwirq, dev_name(&vdev->mc_dev->dev));
 	if (!irq->name)
 		return -ENOMEM;
-- 
2.18.1


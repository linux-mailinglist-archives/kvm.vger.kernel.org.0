Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87933658B90
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 11:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbiL2KQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 05:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiL2KNp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 05:13:45 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2042.outbound.protection.outlook.com [40.107.100.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803BE12D3C
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 02:08:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YS1BA+HbOhpr0yzcPX4wAZ3gGTaRaQhC+TF5nf0kcsKSk4nyq0w8xYVkkbUMmGP4Ma555YiBgYqFj3lnyLuP1NmobHAbCZghvEDs4VCpGSTOaBM/70PkuVYc15aWMG5sUD+e5ACd6McAJemvIEKeZbkQGbo0HqNACFK565sq7f0hSykVL6NHpq298j/bFubn7sgrTJDZTXCsEs5N37QwUJQ0Jp6HThUXNiNxvXCfVM88/0viM/kcM2gKla09yFaeYrXrXpD8fFKklVW4btdXiEoEgDy4Z5K9ETchnNhFaGu9/90uKcDdosghCIdf9n9ekxgPNuw2h4JKpc/8fcklEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0XGCOkgyuv8m0nwvRX4wOpn+ZvdjTqENu8sAo2WW1M=;
 b=aIqNIdx4ALIHB2ElRJKXBekjdXpIzLWlnNIP18eS2zfodPuukb2uMLAY21fMC07sMiPsdpNg7bYRks01xeAR/h+wo0zfWTb+hj0yVyFQtLjs6EnXE53ahXuZwXGkC9vilRn1e6XK6evZ/d9r00+YxGg6x71SxTK9J8t3XpoGYaFMTdSg0rMKDCidezCKDfDB/TCNcRLjAqW/4y0OJEXSI1PEt11aAvrYNkyY2R3LE96llhfjEQeKv2AFw2u6IFIF7gqvWdMUQSlJPz/yuPizcnMDzg+4WZAeiT3agYCx6ovjp5jVYETg7mgR9p5/kpP3xwXJ2gskox6J//Pd1KjytA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0XGCOkgyuv8m0nwvRX4wOpn+ZvdjTqENu8sAo2WW1M=;
 b=FbIw/rDBU7XGZ/ltCUZt7Erfr1xok99AG8s+FCW11ltQKQMln6U048f/5bkLYsMvEo7p3bRXeeCZtDzSB8IxSga4d0v+hqO0C8IzBR+yjAxEWucHMK20uDA05KMsYVPCQ8oyONootyCEWoP8uomQavvVsy9LUacUidFiB+IGOG9lPMmVRSAyqgFGNBDtUHiQpiljOp7BlztJjL965by/xX6v4DOKafFFLdkh0DkmoYao5dYdQvhjkW6oxavjMUqciE/mM1Q/DXZxXQ5ZD3MHAvDB+mhpQnreIYb7UCPevqqgdLrhoCpfANi7kTJ09aVTaWf9enLK8GM+8OIBlpcuVQ==
Received: from BN1PR13CA0024.namprd13.prod.outlook.com (2603:10b6:408:e2::29)
 by DM4PR12MB6011.namprd12.prod.outlook.com (2603:10b6:8:6b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 10:08:47 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::aa) by BN1PR13CA0024.outlook.office365.com
 (2603:10b6:408:e2::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.7 via Frontend
 Transport; Thu, 29 Dec 2022 10:08:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.18 via Frontend Transport; Thu, 29 Dec 2022 10:08:47 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 29 Dec
 2022 02:08:35 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 29 Dec
 2022 02:08:34 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 29 Dec
 2022 02:08:31 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH vfio 5/6] vfio/fsl-mc: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
Date:   Thu, 29 Dec 2022 12:07:33 +0200
Message-ID: <20221229100734.224388-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221229100734.224388-1-yishaih@nvidia.com>
References: <20221229100734.224388-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT005:EE_|DM4PR12MB6011:EE_
X-MS-Office365-Filtering-Correlation-Id: f57d3ce2-fc01-4106-ec79-08dae984ad0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0pJQCoRIyXhS/9lsmAkS6Zu1JvWZ+BHqD6lIIWHg0h4TI01clkNAdqnfFMWnXrbf51xy6qqCFcBaZipBo5MmnlxVcijok1k6L5ngsaNBx8bs8NjL4eTblgEBM3xtRYS7yQe6iVnd71DlaLxYRoPalyo3WQT/6rdC+7Uxs0qip0KTcaID/FQerkvf6RviLOej3EGALdjwalftiDijZ8VxwEVJVuuFFBF8wqEfkxQRkYKUihuZDohNN0LIEKk521WfwyNVJvZ5EDV76iLxg7jXBjXNuBUCPuA5E8SgyhP8bzMYoMLuKp7auevCiD7M7E4R8QpyQ604pmYDEHBvU9rmfzYtk/0sD6wRAcXzbUdpz2ySAyzUhO1uuZJkBe5wdhk+yA+IbTy3pQANkkQxRD9hLWUkC/ugKoQUOo431XzVF9oS5P07/vDFS6EQT9EZg46d5U/PTZevT1kotWQLGrpkMM/X1+bQ+QQYxaVSgFCCLrw32PXvigLakzNW5FLfbrciLqrsAUCmt5/EppvGwbbk6zfSOM1jTK6cy72wuRW9WaG8Ye0sZvz9yHefet8ujnU9Erf7LxhfhI9Wsn+Msjtrelaarjjgn9Ro5NoRAfaDs2RsGj/S51mgChXczReBvSsdafobH2t4RNV+0klytrPsdZm3zJHKW+/GoH0xe1BpWlpez/unjrTG3XRvhCZgjNQOHTf+zS+AGxMF5PrvV1XARA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(346002)(136003)(451199015)(36840700001)(40470700004)(46966006)(6636002)(54906003)(316002)(110136005)(40460700003)(36756003)(186003)(26005)(356005)(5660300002)(2906002)(83380400001)(82310400005)(36860700001)(82740400003)(7636003)(70586007)(4326008)(8676002)(70206006)(2616005)(336012)(40480700001)(1076003)(426003)(47076005)(8936002)(41300700001)(86362001)(478600001)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 10:08:47.2706
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f57d3ce2-fc01-4106-ec79-08dae984ad0e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6011
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


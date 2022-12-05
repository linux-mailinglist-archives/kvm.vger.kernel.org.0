Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA836642AA9
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 15:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbiLEOt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 09:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbiLEOt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 09:49:26 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0E51BEAB
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 06:49:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvpJ4c2sCsTgtgIcbP+oOz4+PCXaFFcSrHD1zlWLiKIOF3Dz0e8VPtEaZZGmpeKjput8YCiapOH8mXcI2QRxJZKn/TGVG+azrvLkfIEmjHrVhxiTZ+LlGu1X0inhabbMRdIRRnC2zl8gdnY65dyWu/03CHhc6HBlqKC/jQe+5OREBxmL/1d/uQikq9VFTwQQJHO1Rs6ke7KrQkwJwd5zg7u9WuTac+1L3TklgizR0d4eCbNEje8oVafugWfiUYxJGzPDxpfZK7N4XPODkYA7NfZcgcKIupScyW+10vmuRHlwlWQH6z2wDX6H/V1YN0HdHs8kZzYRA8q1QFKCpNzh0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJI2trT55PVHXIAkqqeIO5OfjZXn9lo+ApMxNa4PUok=;
 b=kwzvxNM7heBW3KOKBzQpik2Et/8JfBScqBoLyiGZJyoplQWZ5ki+dhGYQ5T51RWAVg6EjQiWmduPhW4eY9zUFA7eURVY4nXDZBVeq/3H2Wu1aaak/0vW3tm3GOIYJ8kkKL6TPrIZgpdrHVxowocY5NtV+CixeU1+oXqYoa0jbxyipA5u17rI7fomCjhT2w8oHricqqRec4yhRwXcjhAQ/idR1p1wsXUnZtG+Ib6s6yi0+dhxEnh8M87DVhOsFkgsbjPvc47Pw1fZxp5kUpjCqQZKcMUHuzbWaHyPqrWipE424FkjPg+SJ0HOGh8tjMoB7+G8WqE4UmYTFZFmu6Z2Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJI2trT55PVHXIAkqqeIO5OfjZXn9lo+ApMxNa4PUok=;
 b=fMzcPnTSCqw8koho0LMd+CLtipToMCe/SAjTIU2eanzNPCV2919Xh2LaCD3756f1Et95T27uw/opnY+1m2ltuWyjs2BqOUzUd/WvSe/0odfmr01l+1HrU5EaIYKBEAhYyc2sJZ1jBSmcSMktBheNIkexsSpiAK7W58k4cNHpAsWBmpQdY4bl5D55GrAH/X7XJwUkJvmdNwcx+e0W3Sag7muWj4FX1GdJOWhzjHTybT0Yxeuadm1ptToOkVJ1cLIJMqmhU1nYSpgMJQPiKcDhoLbFudqbhC4Kj5Sv3x6fF4czOWRtU2JxPKZ+NTaBe0ipRErNjPQbItLnpn/V3Q4fgA==
Received: from CY5PR15CA0106.namprd15.prod.outlook.com (2603:10b6:930:7::8) by
 PH7PR12MB6563.namprd12.prod.outlook.com (2603:10b6:510:211::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 14:49:24 +0000
Received: from CY4PEPF0000B8E8.namprd05.prod.outlook.com
 (2603:10b6:930:7:cafe::f3) by CY5PR15CA0106.outlook.office365.com
 (2603:10b6:930:7::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Mon, 5 Dec 2022 14:49:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8E8.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.11 via Frontend Transport; Mon, 5 Dec 2022 14:49:24 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:15 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:14 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 5 Dec
 2022 06:49:11 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V3 vfio 03/14] vfio/mlx5: Enforce a single SAVE command at a time
Date:   Mon, 5 Dec 2022 16:48:27 +0200
Message-ID: <20221205144838.245287-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221205144838.245287-1-yishaih@nvidia.com>
References: <20221205144838.245287-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8E8:EE_|PH7PR12MB6563:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bd371a2-e4d0-4f1c-e923-08dad6cfe6a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hjDtUYiWGsOaS0imASwJgRJDZzGHfF0UAbbG5nqn/DuRo34IWFHg3qGENB4BFOhYzszrxUtewf/xwTkATaT7FRxrF7aFPdXJDYkP/bYA9dlRoeUhoPvIWTQXuR0Ri/66PlzNY13WL1NiCG9ezWBle+sLVU8WthhRPA+TLEx6UtGSC6lDjPABMJFHniN/yB3LMX1IFgQS+ne2VAhT9vE4OZK8nHfoUzMxwPRAIQ4cOmUUgQshz+VsJt9avfokQGZ71hWsFsy9XjYtSCBz1DIz9RihrToOKaBA7Dk3bfKISbOYnFHp6BCw9YVg4S/7ONxiYZO+uvCS1mC4xJWBPVUc9KDrMaZhId7CpCfeEi4w24W6fbA0RkSoceLVl819pRGAlAF3ezUM8OlhTE9V0UHKzedFGYRkkn2nLuMtCd2Qbq1yB55ESrQc7ANREFDmzuqmECRCuZS4r6tbi+xwewLnVs7CEX0LQL84vhckhxmLSkbWFc9Vqf7QNKWEk57Mb+aAl661TxBWvk/VGR6UnzX0hI1WAYy/XSQu2Fo49UdGptthGm7KZRDZBRrRM68vpQhAnmWFH54Br+kZDtKLz1orVvb1VyUJVWdZGXDIU74jDB8wGzfVSCMXuUHZyvkQozGja3OgVDirPtHYkX7o83Ue8B3Ei/lhiiEUHwZmNKDtHaNavU0voVFYczaaC+tYhba9cHexkslBWO+GmltjNHJq4A==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199015)(40470700004)(36840700001)(46966006)(66899015)(2906002)(8936002)(83380400001)(8676002)(4326008)(36756003)(86362001)(7636003)(356005)(336012)(186003)(426003)(2616005)(47076005)(82310400005)(70206006)(1076003)(41300700001)(5660300002)(82740400003)(6636002)(316002)(110136005)(26005)(54906003)(7696005)(6666004)(36860700001)(70586007)(40460700003)(478600001)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 14:49:24.1082
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd371a2-e4d0-4f1c-e923-08dad6cfe6a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6563
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enforce a single SAVE command at a time.

As the SAVE command is an asynchronous one, we must enforce running only
a single command at a time.

This will preserve ordering between multiple calls and protect from
races on the migration file data structure.

This is a must for the next patches from the series where as part of
PRE_COPY we may have multiple images to be saved and multiple SAVE
commands may be issued from different flows.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 6 ++++++
 drivers/vfio/pci/mlx5/cmd.h  | 1 +
 drivers/vfio/pci/mlx5/main.c | 7 +++++++
 3 files changed, 14 insertions(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 0848bc905d3e..55ee8036f59c 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -281,6 +281,7 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
 	mlx5_core_dealloc_pd(mdev, async_data->pdn);
 	kvfree(async_data->out);
+	complete(&migf->save_comp);
 	fput(migf->filp);
 }
 
@@ -321,6 +322,10 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 		return -ENOTCONN;
 
 	mdev = mvdev->mdev;
+	err = wait_for_completion_interruptible(&migf->save_comp);
+	if (err)
+		return err;
+
 	err = mlx5_core_alloc_pd(mdev, &pdn);
 	if (err)
 		return err;
@@ -371,6 +376,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
 err_dma_map:
 	mlx5_core_dealloc_pd(mdev, pdn);
+	complete(&migf->save_comp);
 	return err;
 }
 
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 921d5720a1e5..8ffa7699872c 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -37,6 +37,7 @@ struct mlx5_vf_migration_file {
 	unsigned long last_offset;
 	struct mlx5vf_pci_core_device *mvdev;
 	wait_queue_head_t poll_wait;
+	struct completion save_comp;
 	struct mlx5_async_ctx async_ctx;
 	struct mlx5vf_async_data async_data;
 };
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 6e9cf2aacc52..0d71ebb2a972 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -245,6 +245,13 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
 	init_waitqueue_head(&migf->poll_wait);
+	init_completion(&migf->save_comp);
+	/*
+	 * save_comp is being used as a binary semaphore built from
+	 * a completion. A normal mutex cannot be used because the lock is
+	 * passed between kernel threads and lockdep can't model this.
+	 */
+	complete(&migf->save_comp);
 	mlx5_cmd_init_async_ctx(mvdev->mdev, &migf->async_ctx);
 	INIT_WORK(&migf->async_data.work, mlx5vf_mig_file_cleanup_cb);
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
-- 
2.18.1


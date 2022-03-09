Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9824D2A50
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 09:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiCIIEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 03:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiCIIEs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 03:04:48 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2043.outbound.protection.outlook.com [40.107.236.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151654D614
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 00:03:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+odDzz9qxZIjPzsVSkUH3K8TN8od7/H/ut5MySLX+uFt0c8EYNWojImtfbMqZyfMh+bwDUPrssTpfAg89o13hwtDrBeaM3msJFCfZ432tqoKOVzDfsNSXEaiVZmK9CaCHALtYzeao8GRQq0yY3+aC9Be/0Y6JruumoQZtaF3Ca12w9Eou3FLH1iycfe0+JRKgyYHNxzPO/TPlApuq8oWemrpn+2DghVuOCbCljRIs+W9h9e0vdftaNUxfc1NLB6kM0nQMVnt5J7UNgmecfz8TW36tj0XSsiJgPb2go2anWE2eZN4DVKiZks4RvV6CfZ/wTMSmLOFGddmQ5ouIh4aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWSRu0L6dGTRinv9dsNnXBLG6jD7DPwhVP3BG3X6YiQ=;
 b=hFSDrQ8qa8skuOmarDJykcrvdSdGtlJi/4YDUz2jGT+0yd72QJYxd3v/JK8QWmU6ZMu5ytiVZLcAg5RT0jIRNluklv8G885vNhMl/bFyYZSfYDeUMDGrgLc2JPTy39/M5KCh/wyGJR7j6iqKaRDf7pg5FEqE62P7zwxdYlh15jC9zOeF3xPVaBcbqwvmsTROIfT515LfJpvTdHNp76730gFxXZ4xlM/VzMgE+tinHRRHUFEfzVdNUThZ6DzRh6NMYUYiU1v98Sr4Lb+MFxtNGAxWhYpBJeZoV73E+iWUX8R9kO5xjR9+VWt+VFIIXnQw3gNHlMaNuzzeItqSUVIaDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWSRu0L6dGTRinv9dsNnXBLG6jD7DPwhVP3BG3X6YiQ=;
 b=nV6NihqD2qM0uEktl/ZApHUxyzx6IqBLLqs5v3bA2wbED/tGk3SzBbSYDXvJPOZsTAWzCJtsDJDd9H74GXvNlPhsOYwVqyVq7iShDbr04QHQCmCuzsuY6rds+96pFcFFpOPzakbvslhbLoGpBnD0RwZiGC5tB7ba6Gk4uScu2YzBYx81SGm0aamZe7Kk8anKwY/srPtTPDdDcJGiyKIN+aN37h1IMAdGroZcLZXvCX+OAe/ZAQAxbIwZ20RtdfZYbMbYZHGAFyIS/UX3JaiAPts5OaMOurhZAgHKRboTLw9ZR0ulV4IOq9YTfTSZ4rutsE0fM41FZvr+iW2XPZyfAw==
Received: from BN6PR16CA0043.namprd16.prod.outlook.com (2603:10b6:405:14::29)
 by CY4PR12MB1208.namprd12.prod.outlook.com (2603:10b6:903:3d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.20; Wed, 9 Mar
 2022 08:03:46 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::fc) by BN6PR16CA0043.outlook.office365.com
 (2603:10b6:405:14::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Wed, 9 Mar 2022 08:03:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Wed, 9 Mar 2022 08:03:46 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 9 Mar
 2022 08:03:45 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 9 Mar 2022
 00:03:44 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Wed, 9 Mar
 2022 00:03:42 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <leonro@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] vfio/mlx5: Fix to not use 0 as NULL pointer
Date:   Wed, 9 Mar 2022 10:02:17 +0200
Message-ID: <20220309080217.94274-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2c97062-ced1-4b69-b990-08da01a35674
X-MS-TrafficTypeDiagnostic: CY4PR12MB1208:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB120847A7E499FBFD24499C56C30A9@CY4PR12MB1208.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p+f8ayCS485H7mNd6pnsXCzFJX8FfYoc65f9sD2Ac+WsnHtGUm27aPd8sOJmnwe6vFQ15de2xzTFXWG1qsBOHaav54kFQPNk2s+zrEXFpylQ92LroGwSYLr1zk5T7UJ0n7PCg1AXMkK8yvFjtRpkyd00nU+jzfqJsjNWHPuTDyrmCEH46iX8eHHfwM3BXnJGCGd+l7MVtEvC61265zBd888ey1cI39P1miHqb7yD53cObe/stRiZWKtMj9Ga6nm1D+EcoztbImtmBeuUQ33S3DRO19VYpLrfFYnGrUmX5lPHk3lpEvMOVquoCtK75fvLqdkwMHhPAtuxxceN6S2lfTVsfae3GhL2LFFG7KkD0xW9LkT+XOalyfp01+PvuljXBBq0upEUGRzjrCh5g4e8CclRGrXT50wgH1enE1g6AgUvr888zBoaNnNY9S2S0mCF5CkQZGUF8WDvT/gbSjLRiNGpKz9ZdOfcEswkM+PFZeIjxM4zA2sT4Hy8rW+N/VvqcSb/3lQbEuAJFnhx/6t/ijsdPl1zW3UHxsIq6mL37tOlcS+QldpzIZ1nisw5zET3I/57QE745CmWbREbav1nBwSQWXNULLa1zY+FWXjXLpKZoHjhpIQBoezYeVnJSlQ/Q+JMaFhJQf8GCA5y0iiVn16LnIqE9b/eOgiI/etcEU4fYgdlHx2RAF8uHkwjiUrCMILxb8FsqX8sBVETr4edmw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(1076003)(54906003)(2906002)(8936002)(36756003)(6916009)(316002)(186003)(83380400001)(2616005)(26005)(86362001)(5660300002)(81166007)(356005)(70586007)(70206006)(36860700001)(8676002)(7696005)(4326008)(47076005)(508600001)(336012)(6666004)(426003)(40460700003)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 08:03:46.6258
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c97062-ced1-4b69-b990-08da01a35674
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1208
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix sparse warning to not use plain integer (i.e. 0) as NULL pointer.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 282a9d4bf776..bbec5d288fee 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -409,7 +409,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 
 	if ((cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP)) {
 		mlx5vf_disable_fds(mvdev);
-		return 0;
+		return NULL;
 	}
 
 	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RESUMING) {
@@ -430,7 +430,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 		if (ret)
 			return ERR_PTR(ret);
 		mlx5vf_disable_fds(mvdev);
-		return 0;
+		return NULL;
 	}
 
 	/*
-- 
2.18.1


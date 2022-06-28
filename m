Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1EA55E41C
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346083AbiF1NNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346072AbiF1NNJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:13:09 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111E223E
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 06:13:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AReTZmKaYYNfJ03yMVqzA/nef70gdebWuJr4mJWzOOgLPqs5PHgNY9Ymulh9zw2yQ9Cw4BMZcKbcw/8zo7j5muako/X0QVuxwFb+z3JvV9d4PxT056MVxSf6bxEMFeYKXBRIRdkZ7sagD8/15mXzdr0V7eUTSsdCNLN0NQgthl6/65XdO9UIotiOlMNvXvAURmQl1Pnijgu7GhatqmcR0TxIjK7w2aj0+/ezeKCd8Btttm/04x8TmkFomkKopOYqtRWqGQ7/j3PFCPflW6tsOt4dBbT5MOTJ065lsaNDCSZD60VC4wNVtQwATDsA6sPCTkKYxJBp87/lmG34AUNsWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FU0SF+R3sQDwmMMK0dPHFM1NO3T31njTmSiF9pYpZ4=;
 b=VDqwdknIHlfnZS9JWNpIzJ3qB7WV/R6oTBAG4/CODR/eM5kmqRF6+uUP9ZT4kyPwkeBCy/v/jepE97kI5LzBYjNoEvfwL0hSiVUUMezZZevjf3F3JmP7Nk4xexQMlPnVUkFlXj3QeQfxd/WDy7f4fKYrnnkT5a/lOR/ubT9Ifb5C8xzNWPYukYhaHZjnxQnVRcMl6EJLd/CIbDW55Q5XK3xn/eXuDrchIIHR6an88vaszNq49Opg8ktbnbJLO+9S+GYk2Uz1rnpcRkKGYi6QxZkaBJNB4Tcoz0xngducPpmht9Zr1yreuh3g4Bo1rEpBqpDPnMFbmExvtE0GoL12QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FU0SF+R3sQDwmMMK0dPHFM1NO3T31njTmSiF9pYpZ4=;
 b=tg4tjZSrHrq7TKARq6dt7v7JBA7+et5aH0+jt7dAxntpg2F1YUgIxVOh5fUI6ko5EeJISEDWVcpoXD5SOIjRPn3F5U+n+5XKHjuoew+erYv7yOx/pkbRwyXuRBYdFxiIxN1pO8HXNITmAsqT/JxqyB/sF6Ka6iV2Eft0pBG6om9JhVK5aDG9/yXMaZJUXhWeypJoSekeZWLhEkbz15fLr7whyR4iADy2tlVed5kg2gJL0MwCdHHtIfhS/Lh8dMU3tJ41QvKwB8GnMf28tq9V9w8SlebxcP3DZnlWRUnqU/vdNaTTmz4lnTavxrz2px/i0LRM3hpTKD33RI1ATdupxQ==
Received: from BN9PR03CA0134.namprd03.prod.outlook.com (2603:10b6:408:fe::19)
 by DM5PR12MB2567.namprd12.prod.outlook.com (2603:10b6:4:b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 13:13:00 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::90) by BN9PR03CA0134.outlook.office365.com
 (2603:10b6:408:fe::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Tue, 28 Jun 2022 13:13:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 13:13:00 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 28 Jun 2022 13:12:59 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 28 Jun 2022 06:12:59 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 28 Jun 2022 06:12:56 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>
CC:     <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>,
        <liulongfang@huawei.com>
Subject: [PATCH V2 vfio 1/2] vfio/mlx5: Protect mlx5vf_disable_fds() upon close device
Date:   Tue, 28 Jun 2022 16:12:12 +0300
Message-ID: <20220628131213.165730-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220628131213.165730-1-yishaih@nvidia.com>
References: <20220628131213.165730-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d8ba286-926c-4a99-6e58-08da5907ed18
X-MS-TrafficTypeDiagnostic: DM5PR12MB2567:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GKkau88nWnCFxDqDsRlVObmi7E2SBZvtEjI3TGmMl4Gwr265SnEUQLOaIwbYnFC2HE8o5YjKZ27sQe36C5Z3rfADdYxKg14Uu9jDv5T5Xoxo03LaDZ7CEiww7+BpEvwdpLW2AmHKa7Nan0AsIDef65ZYbDu41kNS+bMR6UiYlAaanIKV4UQ4uFrZzja4YJM73Bhy4NQN9XxSql+de6GfZbDWVwVD8og0n1SdVqrKhsiMnlAklbjL9DUqQIGt/Kb2QRf8wRv7Th63S1vZ3b1SKzfC9Ml1qanUwnKjQGeU/O7R+RGkx/7NeXJAmazaA2xLgxGQBv/ALAh5cCm0YtyaZ/gZIeSuEbAYsHgrBkwI9p+vM/fk4O6qvMNzcmPLqt5EevLHqbX2UCMeuepj5LcgyP1tlJKLqWDTH+naqctLh1lIbRpUOa0UbS8YM9ZPrm4AAbb5+MVZgV71WLXkHw2pDQFVU98CQVOnTD+Er2UTTqeU/rgqyh4MFpvvEQ/XI+Tpa/tnkxI22TV7afvGCah7uG/L0033h56AOtqBgiDOHH+Imr+oy1Ow8X9WjHMCfAsrP1OENeE7c4nIVKfHN3XNTrCvQQjju/r1mZVbVnwG6hYHgEqb5FTp4qowo2P8pPDOCoaym+4sIKHCbnvnrsDu9ZJHUNueOj9Luthl4ehkahKljtMLvbTD8IPkMgNtL9St5Vtm8LaPz9kTY+PoQ4q6TO/YIj5/cBdO/jPm535BExn3SvRyi8fUX32UywsvxLunUNmPhKK5/I971UhyEIywqt8hTyBEu9aQaZb+/8nn+KAEXL58yhUgh+5qgP4uCXwFrkF26gd3oCzGEZLuCv5w6ahSkMJAYIjecWUFEIT1uwLKkRxVEEmzMEUOEIU/nOV2
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(396003)(136003)(376002)(46966006)(40470700004)(36840700001)(86362001)(8676002)(26005)(83380400001)(82740400003)(7696005)(4326008)(40480700001)(70586007)(8936002)(70206006)(81166007)(1076003)(36860700001)(478600001)(356005)(2616005)(40460700003)(36756003)(41300700001)(110136005)(47076005)(6666004)(336012)(82310400005)(186003)(54906003)(426003)(5660300002)(2906002)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 13:13:00.2072
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8ba286-926c-4a99-6e58-08da5907ed18
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2567
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Protect mlx5vf_disable_fds() upon close device to be called under the
state mutex as done in all other places.

This will prevent a race with any other flow which calls
mlx5vf_disable_fds() as of health/recovery upon
MLX5_PF_NOTIFY_DISABLE_VF event.

Encapsulate this functionality in a separate function named
mlx5vf_cmd_close_migratable() to consider migration caps and for further
usage upon close device.

Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 10 ++++++++++
 drivers/vfio/pci/mlx5/cmd.h  |  1 +
 drivers/vfio/pci/mlx5/main.c |  2 +-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 9b9f33ca270a..cdd0c667dc77 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -88,6 +88,16 @@ static int mlx5fv_vf_event(struct notifier_block *nb,
 	return 0;
 }
 
+void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev)
+{
+	if (!mvdev->migrate_cap)
+		return;
+
+	mutex_lock(&mvdev->state_mutex);
+	mlx5vf_disable_fds(mvdev);
+	mlx5vf_state_mutex_unlock(mvdev);
+}
+
 void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
 {
 	if (!mvdev->migrate_cap)
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 6c3112fdd8b1..aa692d9ce656 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -64,6 +64,7 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 					  size_t *state_size);
 void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
+void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev);
 int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf);
 int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 0558d0649ddb..d754990f0662 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -570,7 +570,7 @@ static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
 	struct mlx5vf_pci_core_device *mvdev = container_of(
 		core_vdev, struct mlx5vf_pci_core_device, core_device.vdev);
 
-	mlx5vf_disable_fds(mvdev);
+	mlx5vf_cmd_close_migratable(mvdev);
 	vfio_pci_core_close_device(core_vdev);
 }
 
-- 
2.18.1


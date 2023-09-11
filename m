Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C877179AF9A
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 01:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbjIKUte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235818AbjIKJkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 05:40:04 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2074.outbound.protection.outlook.com [40.107.101.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9AC102
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 02:40:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3PfkrHE5yZNlGUFupmGRkjWxkQIhdF73ZrJVG7XYhLq/jcZokVfdldFsI4ZvMrl3F/ENwDcgguj5vNqaTA/GMSKozNyGSZ0RjvAWExLJvZfDFqN0x739eh818JBKSuptbPQ3VpDqNq/veqPoebYYLBh1jmRHQ9Hak4omTFjRscbrEeDc7EUWYMr+4yqfgJ4VIJvu5Dw8wHk+auOS4Nxz/u8KBexiis5lTs7ctjju2qtzRxMPVAdwG/UFD+aMnFk7hB/HSs8MNbdg67u1isy1a9Oj0CmkEKs0IU4sZUXmCNzsVXfWc2MWGPy26nE7K4AccSJRO69ewJlo1THoIvdLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Or5AbvCH7sJ24Bq2MKMAvnM7iApt0EvyiarRXA/H41k=;
 b=gFa76YT3bUQ7KExEHSt/5sdGg2Ak8Ao+YNOlgWDYiUhFWShu72tP1xfiUYn0lkjk7h7+H5+Xba4YkxVL7D1fV0xWxDhdBRK5qJVHjhByk79HIGOeOHzIULpNrTvn8fqiBBQ0g1tYpKfpSuduONf+3qK8FOayvmzsn7VDjpwraKNIwmvCokdaj47QSU3gj2OGZcWirLKMZaWRO1cu6EvkzggFFx0Pz6Df53OylLT/KdxR/T0zjMJPDmh+TtmgUEEDtFygVhGJ/IcyiQHBzvxYZfa8rJBMm/WOMt3GOFRpzdo9fTVcO5rjoxt6hb79vQn89l4eIt45lnsyNyPbxfjrqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Or5AbvCH7sJ24Bq2MKMAvnM7iApt0EvyiarRXA/H41k=;
 b=CH+yFjGWNEwykAFl/QsTxjaO8SrvZjZi72N0Ruk+9PIGVoq6q0ph44L76RDXSEo99z0ryyq+FNoipL+qcxZXEYrw8Nu9XzkopdEAUfhQXKvUizytgyqlrsj6jAZShoDOK0HPF6d0PWZXSmoCWEJ+52EVeC9TH3Yq9b/zn9qroa9KFII/b80gA9hM0uISQbRD+HQNTTI/hjyZsL1nDlYNkrvFg6ME9QkBS9tfzyHdo4iSluW3rcQBDCuFVCtjCScXiaUd7lMxPXY+Uv2sZlczLXs1swt1P+PTltxrWQOAUuGX00XlQSQQsl53tiXyHtL3FcWJYRIRBAzSFwRBmEV9tQ==
Received: from MN2PR02CA0021.namprd02.prod.outlook.com (2603:10b6:208:fc::34)
 by MW3PR12MB4505.namprd12.prod.outlook.com (2603:10b6:303:5a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Mon, 11 Sep
 2023 09:39:58 +0000
Received: from BL6PEPF0001AB59.namprd02.prod.outlook.com
 (2603:10b6:208:fc:cafe::3e) by MN2PR02CA0021.outlook.office365.com
 (2603:10b6:208:fc::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35 via Frontend
 Transport; Mon, 11 Sep 2023 09:39:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB59.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.17 via Frontend Transport; Mon, 11 Sep 2023 09:39:57 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 11 Sep 2023
 02:39:47 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 11 Sep
 2023 02:39:47 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 11 Sep
 2023 02:39:45 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 2/9] vfio/mlx5: Wake up the reader post of disabling the SAVING migration file
Date:   Mon, 11 Sep 2023 12:38:49 +0300
Message-ID: <20230911093856.81910-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230911093856.81910-1-yishaih@nvidia.com>
References: <20230911093856.81910-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB59:EE_|MW3PR12MB4505:EE_
X-MS-Office365-Filtering-Correlation-Id: d06f14b6-27ad-4faa-e5c0-08dbb2ab0fcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Stm0W7yNZ17d+KchCwSyrs6s3J6InPYS1YYD0SshSih72uGbVmlc4bZvFs7MiW2vDqjep/Ju5MBUQPOrG7wBV7HvuNeYI0ptyLRd1bzkE3DCu7iPx2cPjOkw7REn/yDpIj6g8d4n3yzwmhcRdHGWuvF16MJrO5T/uyMgwI+721rfo1Xly4FAmrEb9NStmeQnJovg4A6ScNO2+duaSvav/m3syCLPldGy290QZVbt8ulYiu+THK2QYDFZ9dzC+AwZzH++lD2/hN1A6srfuNAmza+tsJlus84dfYZKRoJK+ChFcHcDAQaAKvgL0D0gxEbmw/f0XuYoW+Vt6iea1jt8LsM41FDnyIt1cqPk1mwsHYrSHIYYq36+9b5lZPtVoljZWzZlFUIV0oBaa/nlBVcZxdIyyBC3IK9a7gRt6/6Eqr3zYzr/RDSUmoYHpjSKK5JbjITVgOAbgJEdUgl3KXp6mvJz9lj9hXGWU07Y15gZtiAXQsRieWMIOY0N3aH7ts8re+nXTxFCi22L89SYPYBseeEe5n1FO6yvbUGNfUt01WDs0IWDZgqmWUfdrZxFFByyLb2X0AQ+F3R7MbPdE4DsKwIytslFP4zbP9RL3clIiF+u3IXmSVBRdt43W9P7B5TBSDISexP/lEkPB8nvYe3sfv9bgIxUc0B4ggIc5D2jstT+qmShEp5xDiSqcXAZUuiaLBEtFowmHLmeiKTEueP/wnHsnPkBuIzE4yiX3lgB138=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(39860400002)(396003)(346002)(186009)(451199024)(82310400011)(1800799009)(40470700004)(36840700001)(46966006)(5660300002)(4326008)(70206006)(41300700001)(8676002)(8936002)(316002)(6636002)(54906003)(110136005)(70586007)(40460700003)(47076005)(478600001)(36756003)(40480700001)(7696005)(2616005)(107886003)(2906002)(86362001)(1076003)(336012)(426003)(26005)(82740400003)(356005)(7636003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 09:39:57.5329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d06f14b6-27ad-4faa-e5c0-08dbb2ab0fcd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL6PEPF0001AB59.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4505
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Post of disabling the SAVING migration file, which includes setting the
file state to be MLX5_MIGF_STATE_ERROR, call to wake_up_interruptible()
on its poll_wait member.

This lets any potential reader which is waiting already for data as part
of mlx5vf_save_read() to wake up, recognize the error state and return
with an error.

Post of that we don't need to rely on any other condition to wake up
the reader as of the returning of the SAVE command that was previously
executed, etc.

In addition, this change will simplify error flows (e.g health recovery)
once we'll move to chunk mode and multiple SAVE commands may run in the
STOP_COPY phase as we won't need to rely any more on a SAVE command to
wake-up a potential waiting reader.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 42ec574a8622..2556d5455692 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -1019,6 +1019,7 @@ void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev)
 		mlx5_cmd_cleanup_async_ctx(&mvdev->saving_migf->async_ctx);
 		cancel_work_sync(&mvdev->saving_migf->async_data.work);
 		mlx5vf_disable_fd(mvdev->saving_migf);
+		wake_up_interruptible(&mvdev->saving_migf->poll_wait);
 		mlx5fv_cmd_clean_migf_resources(mvdev->saving_migf);
 		fput(mvdev->saving_migf->filp);
 		mvdev->saving_migf = NULL;
-- 
2.18.1


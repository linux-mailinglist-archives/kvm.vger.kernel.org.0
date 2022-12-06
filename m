Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773D9643ECC
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiLFIgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234087AbiLFIf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:35:56 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE81D10557
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 00:35:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKDIYKlQBwm9B/2PIWpyWQta0I0lPGDLL/tVjfzWYjsj4iR8XQjNDyM/T+rO3V6QoQtKKwu+9DsZI2KFM9POg6b5r2TIGdQcTEjEsFQiUWXsckaM4wX+jbPh5cE2yX5SdVLMrJxjl3BmiTpwfqXq8Wms0eg45/rf6ZDW7R6UQZRT7qMSRTADKUK3YTHI5kR59ExQHBdOjv/NYn2/DkwentnOPyVTrYgku8gMIUXRoGK856r/daS5TpxiUdfcpm4CILpBpEugWXlCWW2OHH5mG4UIEvgsQNWZPEI3Ts8J3XRfA0W1YDsrdl5mWLPFxGpmFo21wDxd5LBxb2Qt88tJ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GIV4Ourelq5LgR69e5dtig0n8mGW+SmX+Z8CVOFcIKY=;
 b=HQwofpM2V7L3Ip6PRw3iDQEg0ZF/d8+yj0/kjAncZf3rm9dNUQKspo7o01j5EuH7Wh0ngTtycVORJJLaZG0KF5BQ0vg3Nv6hrZtMSyrNFHmtUYrVspqlAZHLmN+F1wRcQZkGvAteYR4mGc8syHDVVIaBvP7QbbJebGGhTOGsmqFm0JamSsB6rxwrdVmZagJzZVoeOCEcbXJOiw0cnvSu5IKnRXDd1W0tmnCBjomGmOnIc6Ec+kbrp3G9NQqwGdqKPLi4bohrsOuaeC7KnnpeVZCIHY4kjEdR5+5G3xZCL3kiCPv+hXEZpWxN0adnNKEEuWRs8FjipDkko8s79KjzCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GIV4Ourelq5LgR69e5dtig0n8mGW+SmX+Z8CVOFcIKY=;
 b=iUADJsALL8E2bXVseKoPk1FQgqxdzxoxlpRy03MScdYwNZbz2yPE2ELaf9oyYJMExzOh+x5akN+F63hTXrB8EXn/WMnfsIBe67HckbL4JmtsOhaMaZOy33dYsrHtk2DqvjL4QDEI8R4KRVQQSte7WUtARYQCvWaA+fw/PfXy+h1Ie/B1U0j8fo1+01n+vS9Oos3I7YyJOWpeCQqbenNANGFrIlPgg64swLoA6pThA7coM+W2KdNg2mVJhM6saEJ+bJ+bS0Hm/TTeRXiS9KsvOyobg1XDAoxJORYCH5Ho6Dy5ruwdlJTrhObJVJq1T+nA8GZpxGk4hxxArV84X86EZw==
Received: from CY5PR14CA0011.namprd14.prod.outlook.com (2603:10b6:930:2::20)
 by MN2PR12MB4111.namprd12.prod.outlook.com (2603:10b6:208:1de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 08:35:47 +0000
Received: from CY4PEPF0000C976.namprd02.prod.outlook.com
 (2603:10b6:930:2:cafe::2c) by CY5PR14CA0011.outlook.office365.com
 (2603:10b6:930:2::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 08:35:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000C976.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 08:35:46 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 00:35:33 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 00:35:32 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 6 Dec 2022 00:35:29 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V4 vfio 06/14] vfio/mlx5: Refactor migration file state
Date:   Tue, 6 Dec 2022 10:34:30 +0200
Message-ID: <20221206083438.37807-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221206083438.37807-1-yishaih@nvidia.com>
References: <20221206083438.37807-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C976:EE_|MN2PR12MB4111:EE_
X-MS-Office365-Filtering-Correlation-Id: 966b6884-f362-4397-67b3-08dad764df2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EhqJZ/eoQPdIRTGNpCLBc2Nf/rpfbjXA11Vid3r6qypj26Xk31BIE0XH+aKislkyaQicEmABM2KFHacQyxdHDiLzbOuBnxdE6NcHlMJDtNsYIInK68kI5Ujd+GZ3Wl4yk3+D/3+62vK9mMW0GZTcuISM6nm5HE3G0acKnd7FdtdgfVX/Dxw6sCdS3mHodhkbppe+5jt40mZLLpSiLyhNZMTg3k7vlS7PJEaYoVOtqObjw1lz0fwS5gBvqUdK3GeOWdufyz3UNbcdfReag3gQMGink2unnyxTFqbpC3h5KKHTDri88EoqqEVRwYbwC6iAB0Kh8Akln/BqQ1WigGD7Mc6dfH0+DFLwNkjHl5BBNvUpvOdrWkcmc0xi5lRUnNkKv2INx6v2gw1+nHBnH37hl6XXJMWkwQ/m2jTXf4gbn3ZJob5gH4RVJmHglpOhIo9ePhO3jZLPCXcoCNT4MfWTHTfZlFpp/jhm1404w6NOjPbHI1x/GNf9aPqRO/+WyGkct0/FDwMY/WFnHTAm0S3nzyXBdr/Q2PtyZ6qo9Nz5244GALaJejTgnR26gSkGcmsM8IEhIm6twJ2pu81mODMLRGNcDL0V6P2SUANziEYUUEdGtron4nk7vdJXuuzMrGjpfHuvkO/+/zJ7LNymmGXikjn7KdWK22JXU0zXiNEv0q+ybMXS9C5b4luFAY8gWePZfFsg7jfiqEAFGGcP/o8gwA==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199015)(36840700001)(40470700004)(46966006)(36756003)(82740400003)(5660300002)(86362001)(7636003)(356005)(8936002)(2906002)(40460700003)(4326008)(41300700001)(36860700001)(83380400001)(54906003)(70586007)(316002)(70206006)(6636002)(110136005)(2616005)(40480700001)(8676002)(478600001)(82310400005)(1076003)(426003)(6666004)(47076005)(336012)(186003)(7696005)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 08:35:46.6314
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 966b6884-f362-4397-67b3-08dad764df2e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C976.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4111
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor migration file state to be an emum which is mutual exclusive.

As of that dropped the 'disabled' state as 'error' is the same from
functional point of view.

Next patches from the series will extend this enum for other relevant
states.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  |  2 +-
 drivers/vfio/pci/mlx5/cmd.h  |  7 +++++--
 drivers/vfio/pci/mlx5/main.c | 11 ++++++-----
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index ed4c472d2eae..fcba12326185 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -351,7 +351,7 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 
 	mutex_lock(&migf->lock);
 	if (async_data->status) {
-		migf->is_err = true;
+		migf->state = MLX5_MIGF_STATE_ERROR;
 		wake_up_interruptible(&migf->poll_wait);
 	}
 	mutex_unlock(&migf->lock);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index b0f08dfc8120..14403e654e4e 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -12,6 +12,10 @@
 #include <linux/mlx5/cq.h>
 #include <linux/mlx5/qp.h>
 
+enum mlx5_vf_migf_state {
+	MLX5_MIGF_STATE_ERROR = 1,
+};
+
 struct mlx5_vhca_data_buffer {
 	struct sg_append_table table;
 	loff_t start_pos;
@@ -37,8 +41,7 @@ struct mlx5vf_async_data {
 struct mlx5_vf_migration_file {
 	struct file *filp;
 	struct mutex lock;
-	u8 disabled:1;
-	u8 is_err:1;
+	enum mlx5_vf_migf_state state;
 
 	u32 pdn;
 	struct mlx5_vhca_data_buffer *buf;
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 5f694fce854c..d95646c2f010 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -109,7 +109,7 @@ int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 static void mlx5vf_disable_fd(struct mlx5_vf_migration_file *migf)
 {
 	mutex_lock(&migf->lock);
-	migf->disabled = true;
+	migf->state = MLX5_MIGF_STATE_ERROR;
 	migf->filp->f_pos = 0;
 	mutex_unlock(&migf->lock);
 }
@@ -137,7 +137,8 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 
 	if (!(filp->f_flags & O_NONBLOCK)) {
 		if (wait_event_interruptible(migf->poll_wait,
-			     READ_ONCE(vhca_buf->length) || migf->is_err))
+			     READ_ONCE(vhca_buf->length) ||
+			     migf->state == MLX5_MIGF_STATE_ERROR))
 			return -ERESTARTSYS;
 	}
 
@@ -150,7 +151,7 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 		done = -EINVAL;
 		goto out_unlock;
 	}
-	if (migf->disabled || migf->is_err) {
+	if (migf->state == MLX5_MIGF_STATE_ERROR) {
 		done = -ENODEV;
 		goto out_unlock;
 	}
@@ -199,7 +200,7 @@ static __poll_t mlx5vf_save_poll(struct file *filp,
 	poll_wait(filp, &migf->poll_wait, wait);
 
 	mutex_lock(&migf->lock);
-	if (migf->disabled || migf->is_err)
+	if (migf->state == MLX5_MIGF_STATE_ERROR)
 		pollflags = EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
 	else if (READ_ONCE(migf->buf->length))
 		pollflags = EPOLLIN | EPOLLRDNORM;
@@ -298,7 +299,7 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 		return -ENOMEM;
 
 	mutex_lock(&migf->lock);
-	if (migf->disabled) {
+	if (migf->state == MLX5_MIGF_STATE_ERROR) {
 		done = -ENODEV;
 		goto out_unlock;
 	}
-- 
2.18.1


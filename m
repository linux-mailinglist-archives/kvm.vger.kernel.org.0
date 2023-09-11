Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C9379BF2B
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbjIKUtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbjIKJkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 05:40:09 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0474EE
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 02:40:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRKz0qLAWpG0v1+6RxPvF5TpZ6epjFXCs79nw96vZzU54rn+NVzhWlWokinYaUCbYyvvsE0SP9iagysNxIvJxVZvh1JLHzuPpm2Q0GKlPC1sLkmiMWbnjTjTIS+QtTuTNWnx6m6lQLEzKns5CU2Qkfjs2jFoNjdKMEATRbhZpjx7GVbSCuG1FJmL+4lXmpmT63rM/hXex5gkQBmiyWanYpnFzDq4t6S5AoTloT7Jned7j0RBVdTWVFxhEfiGoUb/mDlJwe84ucuT8EbxFHE5Pi38P+jTLhMuZ/V/WSVWBU0qpGf+I7SArfWpMVqHRXdN16ZIk6bhpkhqSqSgGRpwwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3VH0NJpkdpCgq8xc2T+j5SYgVVT+2nIMq9vUQOPGzpQ=;
 b=hAfsVFlES1btziA/KH4oHWfM79qa7V4WQj01JQ/Ig/hVVpmGBMS7RPoK53HkaXd2V9m4rUyMpuLSozliX/SMDaiD4Z5hxyIRum2n3F8RTiLUqj2eRGIQlja8nsQCKk1I+qliHCkIkV3Vvb78jD58lwnkxwiRejYRULDsLawEIMTx9zKIDZUTOZTfKFLA/8jtEK+pDnqjOYmbyyBnO3A1uwl1RaNKFotX/HWnUjhNLRsnOZKWoJ3O9zZGiLCFLi5QPF9giS0Q1xHvdyVDBwnXfvv8vUCcWQdXziCBwqz2mh8leBPvnN11iak7T5wI/MUVxZLUzMm4MBLq6Ux1s4LVHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VH0NJpkdpCgq8xc2T+j5SYgVVT+2nIMq9vUQOPGzpQ=;
 b=e3nduhClP1CBefZEXNT5noUS/MWC8/Fo8QPlxnuduKGovO9D5YVP7U1jU6cmyPRDyjOKCbYXtn1Wjxi137x111/+1VImQiOCToGv5YewcNadtU8SCyaslQyHB0O77HRrrg/lwMg/p5O8K2QeH4bK48qBziUcQlwBiy/AkJjOHM5yJPjllEAivXhJPkq899yu0btdKEwsA/Nh8r/D5zHWXsEGViawJxaGs+Qyqm/TDqRKeH6wLgKxypmfJu+Jrs3w97xirSK00GZotrb1ymQVnHcpFGcKfjbzxmosc26TyGzT7wpn2NEONO78jmPAFa95DIEmy5ajqAg+Tbx3vbV1iw==
Received: from CY5PR15CA0242.namprd15.prod.outlook.com (2603:10b6:930:66::18)
 by SA1PR12MB6679.namprd12.prod.outlook.com (2603:10b6:806:252::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.31; Mon, 11 Sep
 2023 09:40:00 +0000
Received: from CY4PEPF0000FCC5.namprd03.prod.outlook.com
 (2603:10b6:930:66:cafe::ff) by CY5PR15CA0242.outlook.office365.com
 (2603:10b6:930:66::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.41 via Frontend
 Transport; Mon, 11 Sep 2023 09:40:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCC5.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.17 via Frontend Transport; Mon, 11 Sep 2023 09:40:00 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 11 Sep 2023
 02:39:50 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 11 Sep
 2023 02:39:50 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 11 Sep
 2023 02:39:48 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 3/9] vfio/mlx5: Refactor the SAVE callback to activate a work only upon an error
Date:   Mon, 11 Sep 2023 12:38:50 +0300
Message-ID: <20230911093856.81910-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230911093856.81910-1-yishaih@nvidia.com>
References: <20230911093856.81910-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC5:EE_|SA1PR12MB6679:EE_
X-MS-Office365-Filtering-Correlation-Id: af712363-f86e-4b24-1d5d-08dbb2ab116b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lpPQc3DD3xZ+wDKNMuqdW5NOjVwbyxlGoiV4FEhr5PLQsrbuq3vNM+ZLlIlg97hcSb06ZPckJkCUy2SrjHJ2g67eUvH751wKueJ4IwOWD0Ge7yUlRlDdHsT2ARQi6TASXJW3nEt1eIB5yj40pXXm3jwZ2T0hsol+VwfcKSKwSOKmP0p39EaEfo2qIgJob7kqCxraNZcV+uxwmfjxzO3xyZss2KW3AQKtyY6+lWFgzNdWX607BVk7hwtYYkNf5Zd7GCXYJfLvA8b3n/4Y3AW1Mm8AMK0Y8KuU8Qa4FaOrbNNxEp7EV8vSRYJEamxt0EyHXgPGOzML9+/Vnd8RjsxZvDQn0K0PY4gbOuaBLW9RPVdo2l4Bp0woq4FrZoh8R6Qo+sU/+Q6O/bixihm9Wlc7To5N6tL+Iti+TfC1eXYjezvFgd0FlkHsdoxUJ5GYEThoHuFxGEACttgtJeHtoo4sS8th1QdpoWj/KL4FWrlmN63tJmV1DE27FQzNY25Xd8dj0tkWgYZS9biHsCiaG3Slw5NIGHqNFf/i2peYirvFYhUa32Ofcs9JxVxW09w/LDw0TKmptCN4Tyrnd0cbVuVxwJ/M9rr6P+bhWTstGKOsW603v35bmJat9eDsZp8C0hx7oskShIS73c+DM6red9slw8vUXse5Sptn9narXu55F5qae5sP2ZWzV5xvbz1vX5MI7a065+y4EfUYgwdNuzE1GUqQ6l9z70CU6d81qDmX8x4EQYR3I6tscB8cQelo+03t
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(136003)(39860400002)(396003)(82310400011)(186009)(451199024)(1800799009)(40470700004)(36840700001)(46966006)(40460700003)(7696005)(6666004)(83380400001)(356005)(82740400003)(7636003)(86362001)(36860700001)(47076005)(36756003)(2616005)(426003)(336012)(107886003)(1076003)(40480700001)(26005)(6636002)(316002)(41300700001)(8936002)(70206006)(8676002)(54906003)(2906002)(70586007)(4326008)(110136005)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 09:40:00.3035
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af712363-f86e-4b24-1d5d-08dbb2ab116b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCC5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6679
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upon a successful SAVE callback there is no need to activate a work, all
the required stuff can be done directly.

As so, refactor the above flow to activate a work only upon an error.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 33574b04477d..18d9d1768066 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -475,6 +475,15 @@ mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
 	return buf;
 }
 
+static void
+mlx5vf_save_callback_complete(struct mlx5_vf_migration_file *migf,
+			      struct mlx5vf_async_data *async_data)
+{
+	kvfree(async_data->out);
+	complete(&migf->save_comp);
+	fput(migf->filp);
+}
+
 void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 {
 	struct mlx5vf_async_data *async_data = container_of(_work,
@@ -494,9 +503,7 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 		wake_up_interruptible(&migf->poll_wait);
 	}
 	mutex_unlock(&migf->lock);
-	kvfree(async_data->out);
-	complete(&migf->save_comp);
-	fput(migf->filp);
+	mlx5vf_save_callback_complete(migf, async_data);
 }
 
 static int add_buf_header(struct mlx5_vhca_data_buffer *header_buf,
@@ -560,13 +567,12 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 		migf->state = async_data->last_chunk ?
 			MLX5_MIGF_STATE_COMPLETE : MLX5_MIGF_STATE_PRE_COPY;
 		wake_up_interruptible(&migf->poll_wait);
+		mlx5vf_save_callback_complete(migf, async_data);
+		return;
 	}
 
 err:
-	/*
-	 * The error and the cleanup flows can't run from an
-	 * interrupt context
-	 */
+	/* The error flow can't run from an interrupt context */
 	if (status == -EREMOTEIO)
 		status = MLX5_GET(save_vhca_state_out, async_data->out, status);
 	async_data->status = status;
-- 
2.18.1


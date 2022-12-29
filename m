Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D142A658B89
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 11:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiL2KQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 05:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbiL2KNp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 05:13:45 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CBEE0D0
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 02:08:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMh/mhvyMVFGSucNo6Pi4g3tIP1i0staiizsJmD0eFwyJ5vhi0vuUWihvAzkxtkwsHi0Nyj4cK/4+UuiUCF4uTw5AJc7VumbbDKsrSIya/flE/mnnWc5H0Ma+tlF9LYIlIvuvbDne8AfeURGiyibN63QlWucDTjislk+3l9NhKicMxcf2d12I6kMy+OyuG+wnBy8RUlaApdhmECZBU67Pepe1zmFH3MYrpI/rpWfgyXohnvKOal7L2QjP4xvz8zqw1Bzcep1N007qqSiFCt5bCiKM8Frgze4WteMHxzTpDjA0D4GxbZDPRcPnjqHRnsm7HvjZfFTa+QnY452idPz5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FRwQek0anxxy0zZiASG8tv0VCq12SKcFXfGRel+KhjQ=;
 b=krLUUS3dWBdWKCkvtkBPiL9na3GvMbcWMelQogNNJ2yQJ8jNKlYqQ4pPMiFKcex2p0u8S3lIMjIqAB0EefkZNaDp4IRcgdhkylzWhfrjRWWr3te8hXciV/bt1VtK4aQlKmNfbGcnMQyC0HgzGZTpGXW93cwsTua6CCgqMnkCVgl0PRILHtnivSc9xgo6HnhmdRaPNnn2fjPqhqw+ArYGhZp57XPljwEg5QFkHrIzqBypLItmuvEkmEmMNW2yZnCZsSLoL9YAMfAlShjoAk6P8NZso0YcWOJcM86mvJkkn871xN88l1tfDP3QliouL7rHK7XGqIgOY+UBdo0SNY6Umw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRwQek0anxxy0zZiASG8tv0VCq12SKcFXfGRel+KhjQ=;
 b=a0hS99hgT19MWd9RdTYvkemFueXsWRYZ4Mkx8KK5MnB1Eg9PMRePvRu4D/mDOVODi/fj84IY8bbH5Ml9X1CSSAy6OTQjzqczazqpSXEClH0yfUXab1q+6qB8RMfYtsAMQWSerGMhEQ6RtkpEQEmcq4NNG+OFr0KYyUKi8aDrOkmWdKJBXDz8AymyV1pYNR9vG16vmtdRaJANV9mFsGrP92LLOKtXINE2JZIhF1lCwkFy0sBhjjWRi3GMPkguOXbWsf/YEUXibyibvCTFFX33g4+XSANHd5sCa95iTraKzGwJUT+Cspgixx4hANdavc1rmrntSbHT49IPvrSS8A6xRw==
Received: from BN1PR13CA0014.namprd13.prod.outlook.com (2603:10b6:408:e2::19)
 by PH8PR12MB7135.namprd12.prod.outlook.com (2603:10b6:510:22c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 10:08:33 +0000
Received: from BN8NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::e9) by BN1PR13CA0014.outlook.office365.com
 (2603:10b6:408:e2::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.7 via Frontend
 Transport; Thu, 29 Dec 2022 10:08:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT071.mail.protection.outlook.com (10.13.177.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.17 via Frontend Transport; Thu, 29 Dec 2022 10:08:33 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 29 Dec
 2022 02:08:24 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 29 Dec
 2022 02:08:23 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 29 Dec
 2022 02:08:20 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH vfio 2/6] vfio/mlx5: Allow loading of larger images than 512 MB
Date:   Thu, 29 Dec 2022 12:07:30 +0200
Message-ID: <20221229100734.224388-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221229100734.224388-1-yishaih@nvidia.com>
References: <20221229100734.224388-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT071:EE_|PH8PR12MB7135:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e01960c-569e-4a03-45ad-08dae984a4ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u8lkVbHHFTf41HzfVYxlzUhw6ryAG5ZzVbucih8WZNMWHrthXDnEZ0udzkMcMsaV5yOdlSDku2mJY5+Y1PXNktuKaisJMf/GOrZWKTjfDvDTTdNOOUDv0hIpzy+UA8bzhxl+41HMnvvaJAIiZSLu3F2cUDWnKCHjC35s7mOpqh4SufqyaB78B8FpKyGtFhfIQxOqyK4ZDGUNH9PhZvUYJWyBGPBmwArvBuRNKTY3VmA2Izx0I1Ut3VLaWMETfBM2C3Kjr7ErEhLDddzEguKBz6GzyizGRFkNBN933TXB9H26RVxUYuW6gnw9JykjVKV2Z6CrPCrSwJiuzxDZpLEkcwzNehIMo+E6DA/QWk+8jJRLfcQWNfZIy8aTKJuGSVhmBxSXc1hDdA3Bdeu4WxKqo5XE92bbgxQWzPA2wueir6ol8xo5LZLvqPzmXFXQ4jgqaqj9Fc5NVL1/3cju5qpRSeZtZ8PHrLU3G1BKC7XVUnSDveS0331pQ3CLo6SIV0qOYcioqARUzdqnHZxfO3/F0QASY0dz4ytNPTWI4Ii0ZzA7GOjEeg4vfEmKXJ4bJh39agKb1wUzkOx7rJjkidBc/34W7KEq8aUMOf7Lx5F1UWyPHei1m2TavFYsqfEcO77X4IgtQdXgKORt2xvORj4pYAxoEl8PaDsjOIAXJ/iKyji9SeM3RNUQYAzrsI7wO9APAtkJiL305quLKl8gbcwKtg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199015)(46966006)(40470700004)(36840700001)(478600001)(6666004)(26005)(186003)(7696005)(83380400001)(2616005)(1076003)(47076005)(41300700001)(336012)(426003)(82310400005)(36860700001)(4326008)(8676002)(7636003)(6636002)(54906003)(110136005)(82740400003)(36756003)(40480700001)(86362001)(8936002)(40460700003)(70586007)(5660300002)(316002)(356005)(70206006)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 10:08:33.2089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e01960c-569e-4a03-45ad-08dae984a4ad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7135
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow loading of larger images than 512 MB by dropping the arbitrary
hard-coded value that we have today and move to use the max device
loading value which is for now 4GB.

As part of that we move to use the GFP_KERNEL_ACCOUNT option upon
allocating the persistent data of mlx5 and rely on the cgroup to provide
the memory limit for the given user.

The GFP_KERNEL_ACCOUNT option lets the memory allocator know that this
is untrusted allocation triggered from userspace and should be a subject
of kmem accountingis, and as such it is controlled by the cgroup
mechanism.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 11 ++++++-----
 drivers/vfio/pci/mlx5/main.c | 19 ++++++++++---------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index c5dcddbc4126..0586f09c69af 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -373,7 +373,7 @@ mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
 	struct mlx5_vhca_data_buffer *buf;
 	int ret;
 
-	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL_ACCOUNT);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
@@ -1032,7 +1032,7 @@ mlx5vf_create_rc_qp(struct mlx5_core_dev *mdev,
 	void *in;
 	int err;
 
-	qp = kzalloc(sizeof(*qp), GFP_KERNEL);
+	qp = kzalloc(sizeof(*qp), GFP_KERNEL_ACCOUNT);
 	if (!qp)
 		return ERR_PTR(-ENOMEM);
 
@@ -1213,12 +1213,13 @@ static int alloc_recv_pages(struct mlx5_vhca_recv_buf *recv_buf,
 	int i;
 
 	recv_buf->page_list = kvcalloc(npages, sizeof(*recv_buf->page_list),
-				       GFP_KERNEL);
+				       GFP_KERNEL_ACCOUNT);
 	if (!recv_buf->page_list)
 		return -ENOMEM;
 
 	for (;;) {
-		filled = alloc_pages_bulk_array(GFP_KERNEL, npages - done,
+		filled = alloc_pages_bulk_array(GFP_KERNEL_ACCOUNT,
+						npages - done,
 						recv_buf->page_list + done);
 		if (!filled)
 			goto err;
@@ -1248,7 +1249,7 @@ static int register_dma_recv_pages(struct mlx5_core_dev *mdev,
 
 	recv_buf->dma_addrs = kvcalloc(recv_buf->npages,
 				       sizeof(*recv_buf->dma_addrs),
-				       GFP_KERNEL);
+				       GFP_KERNEL_ACCOUNT);
 	if (!recv_buf->dma_addrs)
 		return -ENOMEM;
 
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 9feb89c6d939..79de38931d24 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -21,8 +21,8 @@
 
 #include "cmd.h"
 
-/* Arbitrary to prevent userspace from consuming endless memory */
-#define MAX_MIGRATION_SIZE (512*1024*1024)
+/* Device specification max LOAD size */
+#define MAX_LOAD_SIZE (BIT(__mlx5_bit_sz(load_vhca_state_in, size)) - 1)
 
 static struct mlx5vf_pci_core_device *mlx5vf_drvdata(struct pci_dev *pdev)
 {
@@ -73,12 +73,13 @@ int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 	int ret;
 
 	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
-	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL);
+	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
 	if (!page_list)
 		return -ENOMEM;
 
 	do {
-		filled = alloc_pages_bulk_array(GFP_KERNEL, to_fill, page_list);
+		filled = alloc_pages_bulk_array(GFP_KERNEL_ACCOUNT, to_fill,
+						page_list);
 		if (!filled) {
 			ret = -ENOMEM;
 			goto err;
@@ -87,7 +88,7 @@ int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 		ret = sg_alloc_append_table_from_pages(
 			&buf->table, page_list, filled, 0,
 			filled << PAGE_SHIFT, UINT_MAX, SG_MAX_SINGLE_ALLOC,
-			GFP_KERNEL);
+			GFP_KERNEL_ACCOUNT);
 
 		if (ret)
 			goto err;
@@ -467,7 +468,7 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 	size_t length;
 	int ret;
 
-	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
+	migf = kzalloc(sizeof(*migf), GFP_KERNEL_ACCOUNT);
 	if (!migf)
 		return ERR_PTR(-ENOMEM);
 
@@ -564,7 +565,7 @@ mlx5vf_resume_read_image_no_header(struct mlx5_vhca_data_buffer *vhca_buf,
 {
 	int ret;
 
-	if (requested_length > MAX_MIGRATION_SIZE)
+	if (requested_length > MAX_LOAD_SIZE)
 		return -ENOMEM;
 
 	if (vhca_buf->allocated_length < requested_length) {
@@ -648,7 +649,7 @@ mlx5vf_resume_read_header(struct mlx5_vf_migration_file *migf,
 		u64 flags;
 
 		vhca_buf->header_image_size = le64_to_cpup((__le64 *)to_buff);
-		if (vhca_buf->header_image_size > MAX_MIGRATION_SIZE) {
+		if (vhca_buf->header_image_size > MAX_LOAD_SIZE) {
 			ret = -ENOMEM;
 			goto end;
 		}
@@ -781,7 +782,7 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	struct mlx5_vhca_data_buffer *buf;
 	int ret;
 
-	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
+	migf = kzalloc(sizeof(*migf), GFP_KERNEL_ACCOUNT);
 	if (!migf)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.18.1


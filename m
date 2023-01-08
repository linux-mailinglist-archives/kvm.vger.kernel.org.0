Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239FC661641
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 16:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbjAHPp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 10:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbjAHPp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 10:45:27 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EC0FCF6
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 07:45:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZzvJl8IIEzjjOHEKlFfvnPltdgUg1ApGNWgdkAxFcSc88ZgtQbK6rUk/6IiRglWt6maiskTTtPgbm8ewycTlrAm40qdqqM+rP+W/KtWiIiwpftffdzV9ut/8ZniWm09F2jnYcQ/xiF/z8ko4Vn/jwu/7i5Czq4HcUxLKUfogp96sYTO4gjTuHlcKZGTMT2UoctRpz8HyTvjltCu1cyYeAuVtxdUgRc+Om8fENlfUl+Fxl6fJS38ncwyfkDT/26hVuWmAem10ZxK3PpQc/czJCvpvIOnQRwEcktFOy6UsIIA+LV1Eefrw39uQVCj9R5b6Usf2iFZl4Jlhm+ZB6bMYMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uEr5Sq2CAJ+a1zrebdR3kAnoRJuPrqSklQgjRfrVNRI=;
 b=K7P9TYXY8t9o2ovmvcGSYMdKS/foHaDBreVXPYbZti9yKmxdI6d3wEtsA+9hOHcG8+TXMueZ5LIx18LX93HcIrbjZmO5JK75ulDqTUyiKNSib4EBGoqqCTJZOQfxYs8bUoNJREPTVk3gmsRYWcj8H7xyTrowkgMLWnXESBX77i56vuj/0y5zARk63SeI9fY/zS3WVnO+on6LHUFCEvRswe8v9egyjz21NceJ1ZLrg9/aEMoyrCIZIlpSJ7j6IVZLVaaIeVIZ1wuXgdiP+jveGIoxXYYIZvwcM6Kr8zwlKnIXPRuP9mfe037kAp86lhBo0S23qlkl8/YscBYOGM1UcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uEr5Sq2CAJ+a1zrebdR3kAnoRJuPrqSklQgjRfrVNRI=;
 b=TjD/xtjo49yMEmu+c5OcQuol3MvAwWOwE4eN4iH+AjXgrfDRRIr4RY97c/UdQvNbGbj3aAb6f6O/JspIXvUSfFn6/ZSXvtlBv6MLlIBCkv3sdA7UA0eFjt1WDXjZFOawY4TcjPXx3rcjxRzHvu7EV+acbA5oQTs6w4o3BeD+wpJSF+BzTwd09vglJPXcnvItwr8OpUx96f7fl5wdBcDBBDKekwGxsJxKAsQkzxrV+yVNujexZ54S7Wd0V+KcJmxnbVNXEdmObe6WBy6Kb9jzMeXsc6dP2m04ANIZg6WiUheJeHnlzYr3a9DbadXpTBdnAd7APBr0IIbXmIEoGB7MnA==
Received: from BN9PR03CA0593.namprd03.prod.outlook.com (2603:10b6:408:10d::28)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Sun, 8 Jan
 2023 15:45:24 +0000
Received: from BN8NAM11FT091.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::ee) by BN9PR03CA0593.outlook.office365.com
 (2603:10b6:408:10d::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Sun, 8 Jan 2023 15:45:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT091.mail.protection.outlook.com (10.13.176.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Sun, 8 Jan 2023 15:45:24 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 8 Jan 2023
 07:45:13 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 8 Jan 2023
 07:45:13 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Sun, 8 Jan
 2023 07:45:10 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V1 vfio 2/6] vfio/mlx5: Allow loading of larger images than 512 MB
Date:   Sun, 8 Jan 2023 17:44:23 +0200
Message-ID: <20230108154427.32609-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230108154427.32609-1-yishaih@nvidia.com>
References: <20230108154427.32609-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT091:EE_|SA0PR12MB4432:EE_
X-MS-Office365-Filtering-Correlation-Id: b751032f-8a83-48a7-4635-08daf18f5ba2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kjJhFxizepvUsGH9RkPQyfD9jEFfuULmF2Ud6Cx7bZzQfwMYHRNtlGTI9wsUfk6fObXVdv2YQFi1XjqlKUHwqnrJYUYISmfjKV5zTSabT5yXxYckoit+WOJF5wLPuxoEcV5opbu+RBoGkP+ztXPyHcV6CLIAAsvUC1/CA6xJVMgsX7+JQTa+iwADRnK9Fxg09ofDpd0goY2vdkqFVp6N0KYeiq3RqBwXoVnTboE9zT8l77qOzjU0PwNhP7n++sQSYg73rE8/ClI6xFjZCD91oOpmKaDqIsL8kTRZeaamdxCNFCkaqLMAY6eBPOQE2cDAfkYp4jszTP6Kymys3rTH7zIhVameIoYbQ1ZG9yL7V/jIQ4W19GcmBg8TqQcGJTiwevhkrzBflzzXvk78UJaBGY/Vv+rTXacE8HhvscMWBQloRg8gF8dhdaCLJtDrA3A3q9+Tqn0kU9FZgMSQY1Ua9zJcmqphVJqRrTZHftD0Wc2CFTYVWw451ZXom9zLI/UC+jwbl7KK/95duP+bHtMNBZgN8bog5N5mVx1sM0jODErsufLHDHbbIh58EUrKrA3EboAlqA2Wj8xjrwtwJMGebVhSfeEvuuhT5pRRvFohAGcaUMU00AWTvtOFvezuj6Q00Qp0zcSHju80e85jfHqnNY1qpjtmID7e/la9gGSrnYFW5qr4oHlRctrtMD3qXLmlWhbwDKmxmhk/7BlNfTv7vw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199015)(46966006)(40470700004)(36840700001)(1076003)(316002)(5660300002)(40480700001)(7696005)(26005)(186003)(478600001)(2616005)(426003)(41300700001)(40460700003)(47076005)(6636002)(70586007)(110136005)(54906003)(4326008)(336012)(8676002)(70206006)(83380400001)(82310400005)(8936002)(86362001)(36756003)(6666004)(36860700001)(82740400003)(356005)(2906002)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2023 15:45:24.4137
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b751032f-8a83-48a7-4635-08daf18f5ba2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT091.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 9feb89c6d939..7ba127d8889a 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -21,8 +21,8 @@
 
 #include "cmd.h"
 
-/* Arbitrary to prevent userspace from consuming endless memory */
-#define MAX_MIGRATION_SIZE (512*1024*1024)
+/* Device specification max LOAD size */
+#define MAX_LOAD_SIZE (BIT_ULL(__mlx5_bit_sz(load_vhca_state_in, size)) - 1)
 
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


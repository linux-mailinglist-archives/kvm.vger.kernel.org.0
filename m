Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5319A642AAA
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 15:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiLEOtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 09:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbiLEOth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 09:49:37 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97311B9E2
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 06:49:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJl58uBVVJdmgwmRsnsCKLXjWUL/MxbTmLBVSTYmdPyBCFCaDj0GrLmB4TR/zPpRJW3MokBbzIumW5Ia7o61vRs1dPpKRhlu0qcZFfTh1YE8rYNf/ASf+hPpEo38h0wCAAQCjIs7qYsUbjfNUWDPIqXLkunsgNJ0/5oXlEgJwjSvOXCVmvq6nPBswCEGsHpVhSAUraBcabiWs4FT06jYRZt/jRAhCmpaIYg8GlvqQmOJjKBqs3GAPOVFKmgwndbG0XLdx4dqPLWGHocekaKk/FFXIU6mleajW65gv2hcT/HjqoAcC5XCyZ1nXkVrK3iTTlB2VH69AmSdlanhiQdZNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63ZDIov65xUAtsNyUPnhuO5+SlQ6Ybtku7UX42sImbc=;
 b=E5YofLOdNkLmiY1qBTSdaJwYJ5h2C4e90VQfDuxbDDWN403ztCaK3gKeWFPxiIOL206xsbwvEIXajFYaUcDD+RgMJJWLPpGiqyM4MdAhXqLpBAHtbVxM8nwyLfCfyCnI3TmZo5hv73krPWf4nVEf0s5+4HMHywPc92n9arEXseO+Uj1EMhpj5tx/BTdpSBG38LkDjMzmg3jFzCS1UJZauYeeg8nm7BulnN5EwMMr2SSi69BFH3TElxmLVzbPLyoI8zmn9CeS1HZ5EaT+vvndy9jrqUZ1VaCllfN3c8K8LIAihu9AKpXNhaik6J9QnufkcRW32sHcOVQOJ45X6UCCeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63ZDIov65xUAtsNyUPnhuO5+SlQ6Ybtku7UX42sImbc=;
 b=VYJ9HsHONX3yJVCsy5HYF0UsLlZF9VImmdbxhECsTzDb99qFpf8vpZMY0A24aplkd+GRKMMR+Lig2eZ/gbAJGWHZRk5xDgATwPQOhJfuHdPp01nkniVrcvCYJ2WF5K6RAYBds/wtNl8JL+fwgEr91/3kykFGJ03X5p7tNoM53ypzxMssItcf+aIOLugIhXiAOcMQa5YOu8ccCX7W3fp50rdAqlLvO+Q/WwzZ7VXPQVd+bDsQ3lKNDLzHFfqB3Z2+8bHWiWFmRFrPAzjqM3uE8H5H7pRpPpMQbTTXiuohV+CjiYv+kxa1ewWq+rl8VIyO8pAT8+AeuajnX+LKGQnLiQ==
Received: from MW4PR03CA0294.namprd03.prod.outlook.com (2603:10b6:303:b5::29)
 by IA1PR12MB6162.namprd12.prod.outlook.com (2603:10b6:208:3ea::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 14:49:30 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::d8) by MW4PR03CA0294.outlook.office365.com
 (2603:10b6:303:b5::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Mon, 5 Dec 2022 14:49:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14 via Frontend Transport; Mon, 5 Dec 2022 14:49:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:22 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:21 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 5 Dec
 2022 06:49:18 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V3 vfio 05/14] vfio/mlx5: Refactor MKEY usage
Date:   Mon, 5 Dec 2022 16:48:29 +0200
Message-ID: <20221205144838.245287-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221205144838.245287-1-yishaih@nvidia.com>
References: <20221205144838.245287-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT049:EE_|IA1PR12MB6162:EE_
X-MS-Office365-Filtering-Correlation-Id: 62474361-3f3a-40fa-d45e-08dad6cfea1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DnQpuOCi5pvojw0pZmF81FVDb37ndcuFT3AGJJZ1VsezyL2ntO06yGWXqec+k42fjlSrLQVEEW7EG++K/JdkuDykRolh8J6A9amWXJRRoCm7jN5aI07DbXNF3AR08DKJrxlpXKvAPTqvFHsMtSvsWgutcdk5+x+fmvOrPXHhanWHRw2wCRap4Lb7R/IVtoXzjWtOE03lyosxqe5OQKGI4WghczrXOtdUMAziz5VKtPP+285xVVNY0aic/npwEl1H1UQY0lMYPdG0cp+9mJ+esucwJQgn4DxE71BfShveQh4NN6iHKDClVhddPhpS0mDX6s9dHtlrxECYRLCVO4R9DtlHzdPVOHZfbdkvcemsQ+RYJTB4vXL2v4ZwnaG6CXCMB/02i/O0RRyHMVR9LEusAMWFf8PMuCnQXOJdn/zM/zdd7doskVIoEPIof0bhtH190TJRasggXC7Fi4ubGdNNHyJjffhlYsJmCRJwSsdbIsM3kGJeqiyoB7V5WBQV2ytWtfqjNf8G0sXC011BVtHpvoEzBIQl4IfTNP+8sYXwYV3LKKGqmj3fXq1Ad4LcgVNhl24itiy/o1XMG4X/3AWIAbROv0Ojxb8Erk8yZa2UIOD+mtAnVIogwhII5zqlEskWaQaKfOs5qKm9x24cpExwu8m02XtELNq1azWOccNsVym64/WwVvy2wpK/nLZDVLILSIJHE9g38jJx8U5c+py8cw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199015)(46966006)(40470700004)(36840700001)(83380400001)(47076005)(426003)(66899015)(336012)(86362001)(40460700003)(478600001)(40480700001)(36756003)(82310400005)(82740400003)(36860700001)(1076003)(2616005)(7636003)(356005)(4326008)(186003)(6666004)(5660300002)(26005)(8676002)(7696005)(30864003)(70206006)(54906003)(2906002)(110136005)(316002)(41300700001)(70586007)(6636002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 14:49:29.9741
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62474361-3f3a-40fa-d45e-08dad6cfea1c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6162
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch refactors MKEY usage such as its life cycle will be as of the
migration file instead of allocating/destroying it upon each
SAVE/LOAD command.

This is a preparation step towards the PRE_COPY series where multiple
images will be SAVED/LOADED.

We achieve it by having a new struct named mlx5_vhca_data_buffer which
holds the mkey and its related stuff as of sg_append_table,
allocated_length, etc.

The above fields were taken out from the migration file main struct,
into mlx5_vhca_data_buffer dedicated struct with the proper helpers in
place.

For now we have a single mlx5_vhca_data_buffer per migration file.
However, in coming patches we'll have multiple of them to support
multiple images.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 162 ++++++++++++++++++++++-------------
 drivers/vfio/pci/mlx5/cmd.h  |  37 +++++---
 drivers/vfio/pci/mlx5/main.c |  92 +++++++++++---------
 3 files changed, 178 insertions(+), 113 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index a97eac49e3d6..ed4c472d2eae 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -210,11 +210,11 @@ static int mlx5vf_cmd_get_vhca_id(struct mlx5_core_dev *mdev, u16 function_id,
 }
 
 static int _create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
-			struct mlx5_vf_migration_file *migf,
+			struct mlx5_vhca_data_buffer *buf,
 			struct mlx5_vhca_recv_buf *recv_buf,
 			u32 *mkey)
 {
-	size_t npages = migf ? DIV_ROUND_UP(migf->total_length, PAGE_SIZE) :
+	size_t npages = buf ? DIV_ROUND_UP(buf->allocated_length, PAGE_SIZE) :
 				recv_buf->npages;
 	int err = 0, inlen;
 	__be64 *mtt;
@@ -232,10 +232,10 @@ static int _create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 		 DIV_ROUND_UP(npages, 2));
 	mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
 
-	if (migf) {
+	if (buf) {
 		struct sg_dma_page_iter dma_iter;
 
-		for_each_sgtable_dma_page(&migf->table.sgt, &dma_iter, 0)
+		for_each_sgtable_dma_page(&buf->table.sgt, &dma_iter, 0)
 			*mtt++ = cpu_to_be64(sg_page_iter_dma_address(&dma_iter));
 	} else {
 		int i;
@@ -255,20 +255,99 @@ static int _create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	MLX5_SET(mkc, mkc, log_page_size, PAGE_SHIFT);
 	MLX5_SET(mkc, mkc, translations_octword_size, DIV_ROUND_UP(npages, 2));
-	MLX5_SET64(mkc, mkc, len,
-		   migf ? migf->total_length : (npages * PAGE_SIZE));
+	MLX5_SET64(mkc, mkc, len, npages * PAGE_SIZE);
 	err = mlx5_core_create_mkey(mdev, mkey, in, inlen);
 	kvfree(in);
 	return err;
 }
 
+static int mlx5vf_dma_data_buffer(struct mlx5_vhca_data_buffer *buf)
+{
+	struct mlx5vf_pci_core_device *mvdev = buf->migf->mvdev;
+	struct mlx5_core_dev *mdev = mvdev->mdev;
+	int ret;
+
+	lockdep_assert_held(&mvdev->state_mutex);
+	if (mvdev->mdev_detach)
+		return -ENOTCONN;
+
+	if (buf->dmaed || !buf->allocated_length)
+		return -EINVAL;
+
+	ret = dma_map_sgtable(mdev->device, &buf->table.sgt, buf->dma_dir, 0);
+	if (ret)
+		return ret;
+
+	ret = _create_mkey(mdev, buf->migf->pdn, buf, NULL, &buf->mkey);
+	if (ret)
+		goto err;
+
+	buf->dmaed = true;
+
+	return 0;
+err:
+	dma_unmap_sgtable(mdev->device, &buf->table.sgt, buf->dma_dir, 0);
+	return ret;
+}
+
+void mlx5vf_free_data_buffer(struct mlx5_vhca_data_buffer *buf)
+{
+	struct mlx5_vf_migration_file *migf = buf->migf;
+	struct sg_page_iter sg_iter;
+
+	lockdep_assert_held(&migf->mvdev->state_mutex);
+	WARN_ON(migf->mvdev->mdev_detach);
+
+	if (buf->dmaed) {
+		mlx5_core_destroy_mkey(migf->mvdev->mdev, buf->mkey);
+		dma_unmap_sgtable(migf->mvdev->mdev->device, &buf->table.sgt,
+				  buf->dma_dir, 0);
+	}
+
+	/* Undo alloc_pages_bulk_array() */
+	for_each_sgtable_page(&buf->table.sgt, &sg_iter, 0)
+		__free_page(sg_page_iter_page(&sg_iter));
+	sg_free_append_table(&buf->table);
+	kfree(buf);
+}
+
+struct mlx5_vhca_data_buffer *
+mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
+			 size_t length,
+			 enum dma_data_direction dma_dir)
+{
+	struct mlx5_vhca_data_buffer *buf;
+	int ret;
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	buf->dma_dir = dma_dir;
+	buf->migf = migf;
+	if (length) {
+		ret = mlx5vf_add_migration_pages(buf,
+				DIV_ROUND_UP_ULL(length, PAGE_SIZE));
+		if (ret)
+			goto end;
+
+		ret = mlx5vf_dma_data_buffer(buf);
+		if (ret)
+			goto end;
+	}
+
+	return buf;
+end:
+	mlx5vf_free_data_buffer(buf);
+	return ERR_PTR(ret);
+}
+
 void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 {
 	struct mlx5vf_async_data *async_data = container_of(_work,
 		struct mlx5vf_async_data, work);
 	struct mlx5_vf_migration_file *migf = container_of(async_data,
 		struct mlx5_vf_migration_file, async_data);
-	struct mlx5_core_dev *mdev = migf->mvdev->mdev;
 
 	mutex_lock(&migf->lock);
 	if (async_data->status) {
@@ -276,9 +355,6 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 		wake_up_interruptible(&migf->poll_wait);
 	}
 	mutex_unlock(&migf->lock);
-
-	mlx5_core_destroy_mkey(mdev, async_data->mkey);
-	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
 	kvfree(async_data->out);
 	complete(&migf->save_comp);
 	fput(migf->filp);
@@ -292,7 +368,7 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 			struct mlx5_vf_migration_file, async_data);
 
 	if (!status) {
-		WRITE_ONCE(migf->total_length,
+		WRITE_ONCE(migf->buf->length,
 			   MLX5_GET(save_vhca_state_out, async_data->out,
 				    actual_image_size));
 		wake_up_interruptible(&migf->poll_wait);
@@ -307,39 +383,28 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 }
 
 int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
-			       struct mlx5_vf_migration_file *migf)
+			       struct mlx5_vf_migration_file *migf,
+			       struct mlx5_vhca_data_buffer *buf)
 {
 	u32 out_size = MLX5_ST_SZ_BYTES(save_vhca_state_out);
 	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
 	struct mlx5vf_async_data *async_data;
-	struct mlx5_core_dev *mdev;
-	u32 mkey;
 	int err;
 
 	lockdep_assert_held(&mvdev->state_mutex);
 	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
-	mdev = mvdev->mdev;
 	err = wait_for_completion_interruptible(&migf->save_comp);
 	if (err)
 		return err;
 
-	err = dma_map_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE,
-			      0);
-	if (err)
-		goto err_dma_map;
-
-	err = _create_mkey(mdev, migf->pdn, migf, NULL, &mkey);
-	if (err)
-		goto err_create_mkey;
-
 	MLX5_SET(save_vhca_state_in, in, opcode,
 		 MLX5_CMD_OP_SAVE_VHCA_STATE);
 	MLX5_SET(save_vhca_state_in, in, op_mod, 0);
 	MLX5_SET(save_vhca_state_in, in, vhca_id, mvdev->vhca_id);
-	MLX5_SET(save_vhca_state_in, in, mkey, mkey);
-	MLX5_SET(save_vhca_state_in, in, size, migf->total_length);
+	MLX5_SET(save_vhca_state_in, in, mkey, buf->mkey);
+	MLX5_SET(save_vhca_state_in, in, size, buf->allocated_length);
 
 	async_data = &migf->async_data;
 	async_data->out = kvzalloc(out_size, GFP_KERNEL);
@@ -348,10 +413,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 		goto err_out;
 	}
 
-	/* no data exists till the callback comes back */
-	migf->total_length = 0;
 	get_file(migf->filp);
-	async_data->mkey = mkey;
 	err = mlx5_cmd_exec_cb(&migf->async_ctx, in, sizeof(in),
 			       async_data->out,
 			       out_size, mlx5vf_save_callback,
@@ -365,57 +427,33 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	fput(migf->filp);
 	kvfree(async_data->out);
 err_out:
-	mlx5_core_destroy_mkey(mdev, mkey);
-err_create_mkey:
-	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
-err_dma_map:
 	complete(&migf->save_comp);
 	return err;
 }
 
 int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
-			       struct mlx5_vf_migration_file *migf)
+			       struct mlx5_vf_migration_file *migf,
+			       struct mlx5_vhca_data_buffer *buf)
 {
-	struct mlx5_core_dev *mdev;
 	u32 out[MLX5_ST_SZ_DW(load_vhca_state_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(load_vhca_state_in)] = {};
-	u32 mkey;
 	int err;
 
 	lockdep_assert_held(&mvdev->state_mutex);
 	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
-	mutex_lock(&migf->lock);
-	if (!migf->total_length) {
-		err = -EINVAL;
-		goto end;
-	}
-
-	mdev = mvdev->mdev;
-	err = dma_map_sgtable(mdev->device, &migf->table.sgt, DMA_TO_DEVICE, 0);
+	err = mlx5vf_dma_data_buffer(buf);
 	if (err)
-		goto end;
-
-	err = _create_mkey(mdev, migf->pdn, migf, NULL, &mkey);
-	if (err)
-		goto err_mkey;
+		return err;
 
 	MLX5_SET(load_vhca_state_in, in, opcode,
 		 MLX5_CMD_OP_LOAD_VHCA_STATE);
 	MLX5_SET(load_vhca_state_in, in, op_mod, 0);
 	MLX5_SET(load_vhca_state_in, in, vhca_id, mvdev->vhca_id);
-	MLX5_SET(load_vhca_state_in, in, mkey, mkey);
-	MLX5_SET(load_vhca_state_in, in, size, migf->total_length);
-
-	err = mlx5_cmd_exec_inout(mdev, load_vhca_state, in, out);
-
-	mlx5_core_destroy_mkey(mdev, mkey);
-err_mkey:
-	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_TO_DEVICE, 0);
-end:
-	mutex_unlock(&migf->lock);
-	return err;
+	MLX5_SET(load_vhca_state_in, in, mkey, buf->mkey);
+	MLX5_SET(load_vhca_state_in, in, size, buf->length);
+	return mlx5_cmd_exec_inout(mvdev->mdev, load_vhca_state, in, out);
 }
 
 int mlx5vf_cmd_alloc_pd(struct mlx5_vf_migration_file *migf)
@@ -445,6 +483,10 @@ void mlx5fv_cmd_clean_migf_resources(struct mlx5_vf_migration_file *migf)
 
 	WARN_ON(migf->mvdev->mdev_detach);
 
+	if (migf->buf) {
+		mlx5vf_free_data_buffer(migf->buf);
+		migf->buf = NULL;
+	}
 	mlx5vf_cmd_dealloc_pd(migf);
 }
 
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index ba760f956d53..b0f08dfc8120 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -12,11 +12,25 @@
 #include <linux/mlx5/cq.h>
 #include <linux/mlx5/qp.h>
 
+struct mlx5_vhca_data_buffer {
+	struct sg_append_table table;
+	loff_t start_pos;
+	u64 length;
+	u64 allocated_length;
+	u32 mkey;
+	enum dma_data_direction dma_dir;
+	u8 dmaed:1;
+	struct mlx5_vf_migration_file *migf;
+	/* Optimize mlx5vf_get_migration_page() for sequential access */
+	struct scatterlist *last_offset_sg;
+	unsigned int sg_last_entry;
+	unsigned long last_offset;
+};
+
 struct mlx5vf_async_data {
 	struct mlx5_async_work cb_work;
 	struct work_struct work;
 	int status;
-	u32 mkey;
 	void *out;
 };
 
@@ -27,14 +41,7 @@ struct mlx5_vf_migration_file {
 	u8 is_err:1;
 
 	u32 pdn;
-	struct sg_append_table table;
-	size_t total_length;
-	size_t allocated_length;
-
-	/* Optimize mlx5vf_get_migration_page() for sequential access */
-	struct scatterlist *last_offset_sg;
-	unsigned int sg_last_entry;
-	unsigned long last_offset;
+	struct mlx5_vhca_data_buffer *buf;
 	struct mlx5vf_pci_core_device *mvdev;
 	wait_queue_head_t poll_wait;
 	struct completion save_comp;
@@ -124,12 +131,20 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
 void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev);
 int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
-			       struct mlx5_vf_migration_file *migf);
+			       struct mlx5_vf_migration_file *migf,
+			       struct mlx5_vhca_data_buffer *buf);
 int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
-			       struct mlx5_vf_migration_file *migf);
+			       struct mlx5_vf_migration_file *migf,
+			       struct mlx5_vhca_data_buffer *buf);
 int mlx5vf_cmd_alloc_pd(struct mlx5_vf_migration_file *migf);
 void mlx5vf_cmd_dealloc_pd(struct mlx5_vf_migration_file *migf);
 void mlx5fv_cmd_clean_migf_resources(struct mlx5_vf_migration_file *migf);
+struct mlx5_vhca_data_buffer *
+mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
+			 size_t length, enum dma_data_direction dma_dir);
+void mlx5vf_free_data_buffer(struct mlx5_vhca_data_buffer *buf);
+int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
+			       unsigned int npages);
 void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 1916f7c1468c..5f694fce854c 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -33,7 +33,7 @@ static struct mlx5vf_pci_core_device *mlx5vf_drvdata(struct pci_dev *pdev)
 }
 
 static struct page *
-mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
+mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
 			  unsigned long offset)
 {
 	unsigned long cur_offset = 0;
@@ -41,20 +41,20 @@ mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
 	unsigned int i;
 
 	/* All accesses are sequential */
-	if (offset < migf->last_offset || !migf->last_offset_sg) {
-		migf->last_offset = 0;
-		migf->last_offset_sg = migf->table.sgt.sgl;
-		migf->sg_last_entry = 0;
+	if (offset < buf->last_offset || !buf->last_offset_sg) {
+		buf->last_offset = 0;
+		buf->last_offset_sg = buf->table.sgt.sgl;
+		buf->sg_last_entry = 0;
 	}
 
-	cur_offset = migf->last_offset;
+	cur_offset = buf->last_offset;
 
-	for_each_sg(migf->last_offset_sg, sg,
-			migf->table.sgt.orig_nents - migf->sg_last_entry, i) {
+	for_each_sg(buf->last_offset_sg, sg,
+			buf->table.sgt.orig_nents - buf->sg_last_entry, i) {
 		if (offset < sg->length + cur_offset) {
-			migf->last_offset_sg = sg;
-			migf->sg_last_entry += i;
-			migf->last_offset = cur_offset;
+			buf->last_offset_sg = sg;
+			buf->sg_last_entry += i;
+			buf->last_offset = cur_offset;
 			return nth_page(sg_page(sg),
 					(offset - cur_offset) / PAGE_SIZE);
 		}
@@ -63,8 +63,8 @@ mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
 	return NULL;
 }
 
-static int mlx5vf_add_migration_pages(struct mlx5_vf_migration_file *migf,
-				      unsigned int npages)
+int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
+			       unsigned int npages)
 {
 	unsigned int to_alloc = npages;
 	struct page **page_list;
@@ -85,13 +85,13 @@ static int mlx5vf_add_migration_pages(struct mlx5_vf_migration_file *migf,
 		}
 		to_alloc -= filled;
 		ret = sg_alloc_append_table_from_pages(
-			&migf->table, page_list, filled, 0,
+			&buf->table, page_list, filled, 0,
 			filled << PAGE_SHIFT, UINT_MAX, SG_MAX_SINGLE_ALLOC,
 			GFP_KERNEL);
 
 		if (ret)
 			goto err;
-		migf->allocated_length += filled * PAGE_SIZE;
+		buf->allocated_length += filled * PAGE_SIZE;
 		/* clean input for another bulk allocation */
 		memset(page_list, 0, filled * sizeof(*page_list));
 		to_fill = min_t(unsigned int, to_alloc,
@@ -108,16 +108,8 @@ static int mlx5vf_add_migration_pages(struct mlx5_vf_migration_file *migf,
 
 static void mlx5vf_disable_fd(struct mlx5_vf_migration_file *migf)
 {
-	struct sg_page_iter sg_iter;
-
 	mutex_lock(&migf->lock);
-	/* Undo alloc_pages_bulk_array() */
-	for_each_sgtable_page(&migf->table.sgt, &sg_iter, 0)
-		__free_page(sg_page_iter_page(&sg_iter));
-	sg_free_append_table(&migf->table);
 	migf->disabled = true;
-	migf->total_length = 0;
-	migf->allocated_length = 0;
 	migf->filp->f_pos = 0;
 	mutex_unlock(&migf->lock);
 }
@@ -136,6 +128,7 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 			       loff_t *pos)
 {
 	struct mlx5_vf_migration_file *migf = filp->private_data;
+	struct mlx5_vhca_data_buffer *vhca_buf = migf->buf;
 	ssize_t done = 0;
 
 	if (pos)
@@ -144,16 +137,16 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 
 	if (!(filp->f_flags & O_NONBLOCK)) {
 		if (wait_event_interruptible(migf->poll_wait,
-			     READ_ONCE(migf->total_length) || migf->is_err))
+			     READ_ONCE(vhca_buf->length) || migf->is_err))
 			return -ERESTARTSYS;
 	}
 
 	mutex_lock(&migf->lock);
-	if ((filp->f_flags & O_NONBLOCK) && !READ_ONCE(migf->total_length)) {
+	if ((filp->f_flags & O_NONBLOCK) && !READ_ONCE(vhca_buf->length)) {
 		done = -EAGAIN;
 		goto out_unlock;
 	}
-	if (*pos > migf->total_length) {
+	if (*pos > vhca_buf->length) {
 		done = -EINVAL;
 		goto out_unlock;
 	}
@@ -162,7 +155,7 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 		goto out_unlock;
 	}
 
-	len = min_t(size_t, migf->total_length - *pos, len);
+	len = min_t(size_t, vhca_buf->length - *pos, len);
 	while (len) {
 		size_t page_offset;
 		struct page *page;
@@ -171,7 +164,7 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 		int ret;
 
 		page_offset = (*pos) % PAGE_SIZE;
-		page = mlx5vf_get_migration_page(migf, *pos - page_offset);
+		page = mlx5vf_get_migration_page(vhca_buf, *pos - page_offset);
 		if (!page) {
 			if (done == 0)
 				done = -EINVAL;
@@ -208,7 +201,7 @@ static __poll_t mlx5vf_save_poll(struct file *filp,
 	mutex_lock(&migf->lock);
 	if (migf->disabled || migf->is_err)
 		pollflags = EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
-	else if (READ_ONCE(migf->total_length))
+	else if (READ_ONCE(migf->buf->length))
 		pollflags = EPOLLIN | EPOLLRDNORM;
 	mutex_unlock(&migf->lock);
 
@@ -227,6 +220,8 @@ static struct mlx5_vf_migration_file *
 mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 {
 	struct mlx5_vf_migration_file *migf;
+	struct mlx5_vhca_data_buffer *buf;
+	size_t length;
 	int ret;
 
 	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
@@ -257,22 +252,23 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	complete(&migf->save_comp);
 	mlx5_cmd_init_async_ctx(mvdev->mdev, &migf->async_ctx);
 	INIT_WORK(&migf->async_data.work, mlx5vf_mig_file_cleanup_cb);
-	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
-						    &migf->total_length);
+	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length);
 	if (ret)
 		goto out_pd;
 
-	ret = mlx5vf_add_migration_pages(
-		migf, DIV_ROUND_UP_ULL(migf->total_length, PAGE_SIZE));
-	if (ret)
+	buf = mlx5vf_alloc_data_buffer(migf, length, DMA_FROM_DEVICE);
+	if (IS_ERR(buf)) {
+		ret = PTR_ERR(buf);
 		goto out_pd;
+	}
 
-	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf);
+	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf);
 	if (ret)
 		goto out_save;
+	migf->buf = buf;
 	return migf;
 out_save:
-	mlx5vf_disable_fd(migf);
+	mlx5vf_free_data_buffer(buf);
 out_pd:
 	mlx5vf_cmd_dealloc_pd(migf);
 out_free:
@@ -286,6 +282,7 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 				   size_t len, loff_t *pos)
 {
 	struct mlx5_vf_migration_file *migf = filp->private_data;
+	struct mlx5_vhca_data_buffer *vhca_buf = migf->buf;
 	loff_t requested_length;
 	ssize_t done = 0;
 
@@ -306,10 +303,10 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 		goto out_unlock;
 	}
 
-	if (migf->allocated_length < requested_length) {
+	if (vhca_buf->allocated_length < requested_length) {
 		done = mlx5vf_add_migration_pages(
-			migf,
-			DIV_ROUND_UP(requested_length - migf->allocated_length,
+			vhca_buf,
+			DIV_ROUND_UP(requested_length - vhca_buf->allocated_length,
 				     PAGE_SIZE));
 		if (done)
 			goto out_unlock;
@@ -323,7 +320,7 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 		int ret;
 
 		page_offset = (*pos) % PAGE_SIZE;
-		page = mlx5vf_get_migration_page(migf, *pos - page_offset);
+		page = mlx5vf_get_migration_page(vhca_buf, *pos - page_offset);
 		if (!page) {
 			if (done == 0)
 				done = -EINVAL;
@@ -342,7 +339,7 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 		len -= page_len;
 		done += page_len;
 		buf += page_len;
-		migf->total_length += page_len;
+		vhca_buf->length += page_len;
 	}
 out_unlock:
 	mutex_unlock(&migf->lock);
@@ -360,6 +357,7 @@ static struct mlx5_vf_migration_file *
 mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 {
 	struct mlx5_vf_migration_file *migf;
+	struct mlx5_vhca_data_buffer *buf;
 	int ret;
 
 	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
@@ -378,9 +376,18 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	if (ret)
 		goto out_free;
 
+	buf = mlx5vf_alloc_data_buffer(migf, 0, DMA_TO_DEVICE);
+	if (IS_ERR(buf)) {
+		ret = PTR_ERR(buf);
+		goto out_pd;
+	}
+
+	migf->buf = buf;
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
 	return migf;
+out_pd:
+	mlx5vf_cmd_dealloc_pd(migf);
 out_free:
 	fput(migf->filp);
 end:
@@ -474,7 +481,8 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 
 	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
 		ret = mlx5vf_cmd_load_vhca_state(mvdev,
-						 mvdev->resuming_migf);
+						 mvdev->resuming_migf,
+						 mvdev->resuming_migf->buf);
 		if (ret)
 			return ERR_PTR(ret);
 		mlx5vf_disable_fds(mvdev);
-- 
2.18.1


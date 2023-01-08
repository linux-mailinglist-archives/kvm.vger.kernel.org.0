Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB05D661640
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 16:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjAHPpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 10:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjAHPpV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 10:45:21 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D76FCEC
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 07:45:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcVY/byAeek81AS/tEVdqcz/PbuQU8krZb9KwTbY7gjpSVY2N9P7iAZCEUHCM2MHv2Jl0mGFmaTPZoiBJJMpeOKSA7t6CvWi5AN8ry/HrttALKV6BVp5Q5nMKxHLRSZCShMYtMPnYgUhChpddtWtJU9L2Aazkh5Vzp8vjvB4jymGcltWdDnS/qLAqy4B721MRu6FZeZhshWjvEaEppHUCem770Le/4qtKVapp9xpO20FuhKha3rxciyxHSiQS3DSYOkxhJh17af9WDobx5AX5C5FLmmS8xfKSZOlb41z1J8P9JhTc3qda1MWodoElQTK2XnjWg0l19Kuey7YioHkhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+TcsfW/dp/8PqsCSSvTuVvqWyYIokfo7N8BoKIYBpKE=;
 b=Sv4qHcVAO8zN9mXQW//Wl54MAo0lsPcV4HZqMxMiBH/UcylJ+wgyzpgwjJqmDwdUODw5y/v6I96KWWP88l3EFPEpkyJjo9VgSPE2UsnRps/VhM5sxAhAapzLOWS6mF9L4Nm6tKrmjZTKOrpK2aEkCkjfxuZoTG++rhmSzNZFWSXr4n3doPBxQGIwXCfvqdVD1ZszzNzHLLUa7olyK8d3uYsjFYN8NTuh6OQKEWPFZIRY4/7d/qRiIi9ALFfpDRitrdRyJ8nZWWpTtvVPkFhWcKVn6iEAJ1iJYhcW8VA6gwWBzPddQisTlRTD1M8PsCfPa3X4EAJH4idUlqmWc2ZZdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TcsfW/dp/8PqsCSSvTuVvqWyYIokfo7N8BoKIYBpKE=;
 b=Zs0BEbAZzZpz4aq2Pu3hKb4K4hWpN1tvAFhnSpq13EvU4WJf0cjNUrHBVSEuSk3rrOa5L7SpUQmIg4zaC9OpRr2kx05Nmxrm/BnXuCcxZz4OKPHksyLqBybiOyrWQP5x81ZEql/FKDr5qbaZQgHjq4xjXDkTKMvHGAGoooXQn4y78PQUpuqAdVJR5v0P/kUuxNonq+EMMSQANVlCX4Yu53eZ/qTNDAMoVo3kpFizRH48gIY0joR4rcRBS7RSd8QgG3zQGUYwzk6SO1NdBy6qDuVL/7eB4BscFtOuj2/7uZp7w0pbV0tFFlxdoWGqsR9v9zTdBVpfuP24OeHrgGy7cw==
Received: from BN9PR03CA0577.namprd03.prod.outlook.com (2603:10b6:408:10d::12)
 by MN0PR12MB6247.namprd12.prod.outlook.com (2603:10b6:208:3c1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Sun, 8 Jan
 2023 15:45:19 +0000
Received: from BN8NAM11FT091.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::9) by BN9PR03CA0577.outlook.office365.com
 (2603:10b6:408:10d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Sun, 8 Jan 2023 15:45:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT091.mail.protection.outlook.com (10.13.176.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Sun, 8 Jan 2023 15:45:19 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 8 Jan 2023
 07:45:09 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 8 Jan 2023
 07:45:09 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Sun, 8 Jan
 2023 07:45:06 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V1 vfio 1/6] vfio/mlx5: Fix UBSAN note
Date:   Sun, 8 Jan 2023 17:44:22 +0200
Message-ID: <20230108154427.32609-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230108154427.32609-1-yishaih@nvidia.com>
References: <20230108154427.32609-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT091:EE_|MN0PR12MB6247:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a66b009-5af4-4842-7752-08daf18f5870
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SLA9BX8MKpFNJKU0E33/vdoCK7p7H7ZHYPcThb1wXyzMSwDP9dFx1Pet711ChQ13ikmPT7FI5JZ4kwpif6oRty+9MJW+oGkLjgTIUCH5a50N1Klj2YKf9hC6NZrP80J3EkldEhWGLKi4qjaxDx+LK0qvRV+A/wQp96qjrnHjRCqrWzqyC+YKSwB1y8/mau4j1H2Rvk+trTkd7SB+HXYwuY8ysMSwM4hZsw71U0zlDTDkGctBT+JsG6hRoMk6rXkBR0dhXiSL6q6vELCmxV+gc7RVufE9Pxbr0H6mf0qBf3uUPqSM9LQFg8aeZEHRWIUmEsQ4Au15rTe5f73PvdOPfJoL28FeUbPlKCaF/lbtAfytogGPKhEKA0a4kH/x2zMDyHkaFjvxD620HI1Q3r2dsxi/DjAShCjuyN1sHNFJ5ddZzNWvDVhDP1BwBI6/XksCRXafLL+X9fh94OY0+2DyEFg/h6wo9TUevk/zP5uXnENM2PcX9KcO5K8IVyCfAdaRyvw++FxMTcZVchkXJxRkBqeBKo9xv8GSwQAnjHHLmQl1x9sLT+rD2ZX19B9CeAbJydAgcKtTgDRqLlW6wlpOP3o/Z/aV2XA7TLxwmGdjPBJaC5ssoT4ElvXT2E4T1U68hFp32vkGWcukDO6Rx/CQunznvrRFEU60ReM9U+zCjOjDwwlfEoeCAoHy4YoKge9rmCXUF48tTe7GI+ZMQosEwg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199015)(36840700001)(40470700004)(46966006)(36756003)(82740400003)(356005)(8936002)(83380400001)(5660300002)(426003)(2906002)(110136005)(47076005)(36860700001)(86362001)(41300700001)(54906003)(70586007)(7636003)(70206006)(6636002)(6666004)(40460700003)(26005)(7696005)(2616005)(4326008)(478600001)(40480700001)(1076003)(186003)(316002)(82310400005)(8676002)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2023 15:45:19.0698
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a66b009-5af4-4842-7752-08daf18f5870
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT091.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6247
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prevent calling roundup_pow_of_two() with value of 0 as it causes the
below UBSAN note.

Move this code and its few extra related lines to be called only when
it's really applicable.

UBSAN: shift-out-of-bounds in ./include/linux/log2.h:57:13
shift exponent 64 is too large for 64-bit type 'long unsigned int'
CPU: 15 PID: 1639 Comm: live_migration Not tainted 6.1.0-rc4 #1116
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
dump_stack_lvl+0x45/0x59
ubsan_epilogue+0x5/0x36
 __ubsan_handle_shift_out_of_bounds.cold+0x61/0xef
? lock_is_held_type+0x98/0x110
? rcu_read_lock_sched_held+0x3f/0x70
mlx5vf_create_rc_qp.cold+0xe4/0xf2 [mlx5_vfio_pci]
mlx5vf_start_page_tracker+0x769/0xcd0 [mlx5_vfio_pci]
 vfio_device_fops_unl_ioctl+0x63f/0x700 [vfio]
__x64_sys_ioctl+0x433/0x9a0
do_syscall_64+0x3d/0x90
entry_SYSCALL_64_after_hwframe+0x63/0xcd
 </TASK>

Fixes: 79c3cf279926 ("vfio/mlx5: Init QP based resources for dirty tracking")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 64e68d13cb98..c5dcddbc4126 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1036,14 +1036,14 @@ mlx5vf_create_rc_qp(struct mlx5_core_dev *mdev,
 	if (!qp)
 		return ERR_PTR(-ENOMEM);
 
-	qp->rq.wqe_cnt = roundup_pow_of_two(max_recv_wr);
-	log_rq_stride = ilog2(MLX5_SEND_WQE_DS);
-	log_rq_sz = ilog2(qp->rq.wqe_cnt);
 	err = mlx5_db_alloc_node(mdev, &qp->db, mdev->priv.numa_node);
 	if (err)
 		goto err_free;
 
 	if (max_recv_wr) {
+		qp->rq.wqe_cnt = roundup_pow_of_two(max_recv_wr);
+		log_rq_stride = ilog2(MLX5_SEND_WQE_DS);
+		log_rq_sz = ilog2(qp->rq.wqe_cnt);
 		err = mlx5_frag_buf_alloc_node(mdev,
 			wq_get_byte_sz(log_rq_sz, log_rq_stride),
 			&qp->buf, mdev->priv.numa_node);
-- 
2.18.1


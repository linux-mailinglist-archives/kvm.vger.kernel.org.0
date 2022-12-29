Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8532A658B88
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 11:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbiL2KQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 05:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiL2KNp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 05:13:45 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C3BD11F
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 02:08:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f6sU7rC8rO9MH5W+s4eTLuxdnfNcZeJRI663A+omR0BawZBT5dqyTcBb1D0dxSeE7fdmOARsrYb3jKY87YMwEoBV+W71ODDPvw5Z1TOr32kJbra8QgsRjAIVWE1qI3LNmzbDxw9xrRLGvIKflcyrmOxNCwmurHQR+uqpCfocq+4anCF4mNUraCCOdP6ev4vXCV8NnH65MycD5MJ7p9ZL2h9cM7DexlFBCMXxpy7OWVfghVYmKUMgLUQwRTPPTlNr10Gj5xIyZwkZfonGbCLxyk0icwuYbSlda1XHyN5aMaRuUlhE83n8xP6M3Z6SL0cG4bqjJ7F2NAb3UcJaIMeb3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+TcsfW/dp/8PqsCSSvTuVvqWyYIokfo7N8BoKIYBpKE=;
 b=ABSu9g1wueaFyW8KQSHteUxDgF7GEs9ARLzHGaycPxfZ9U7FWUCnV+kv+lwsA9QydeZCbp6/vtb9Ez/LUv5tWqaRBJvvZrTl+ITEKanmK2mmrcCZdMtUTxpyEW4beK94jrAbVIAhiD8dhYZSewHKd/CynabSVyYPi7gUI0n//B7Dx3RbAkjd26AMzAaS2Kk6RPeOQ16qVJHcf7A6ldkNoLLSn+M400eawmREkGHBuLy7XLDDkWgg/hGRfmowStrSTDZYERildnUXB9ZkNRfRRo9ySX7GJXUT2O6m7Z/rbs0W1nFebA7dD12VBeKzgyeJCYYRZ09cMNY+4t6xxywnrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TcsfW/dp/8PqsCSSvTuVvqWyYIokfo7N8BoKIYBpKE=;
 b=iU4SNqBFUKZl+O7APPo54R/BpFZ9B7onpXKQtb1S/+spnRHUAWVemxDUZJeRUwDC7lHKaYGsg2LdkvB2K4s9jWai0NC9hPnKs/qwjUAVgbgeyeFHsnDXAbTZi/YC2EXpy9jAhxHHELGN1WwI62rGaLrhbV+aGqP32/Ovu6bWKd80PE1Q/y6z9oTHO8e9wJ7qWZXNquBt+3O2dOzjiKru+NEUnJSpNeVE4h1lJLRz5FzROIiT69gQhzyJ+RPHHKpIFW1434x7UACBXLcpTOZJVs0gycmYpq2x+lM+dwEySfDMAC8HDFy1JToMhxGbh0gsa0QjL/TF4vKZZw38BPbSZA==
Received: from MW4P220CA0008.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::13)
 by BY5PR12MB4998.namprd12.prod.outlook.com (2603:10b6:a03:1d4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 10:08:26 +0000
Received: from CO1NAM11FT081.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::17) by MW4P220CA0008.outlook.office365.com
 (2603:10b6:303:115::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16 via Frontend
 Transport; Thu, 29 Dec 2022 10:08:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT081.mail.protection.outlook.com (10.13.174.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.17 via Frontend Transport; Thu, 29 Dec 2022 10:08:26 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 29 Dec
 2022 02:08:20 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 29 Dec
 2022 02:08:20 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 29 Dec
 2022 02:08:16 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH vfio 1/6] vfio/mlx5: Fix UBSAN note
Date:   Thu, 29 Dec 2022 12:07:29 +0200
Message-ID: <20221229100734.224388-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221229100734.224388-1-yishaih@nvidia.com>
References: <20221229100734.224388-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT081:EE_|BY5PR12MB4998:EE_
X-MS-Office365-Filtering-Correlation-Id: 510d0b7d-4684-495d-7e1d-08dae984a0ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c6wxsdHxCzVK4nIyHMwNtbWWE9dJdiuTZEzfV/3p+asmzSJCofS8nMNeHqJqqEhy4XRes5KlT9M1Lw9P6OcKCIigEp80MSJFOhZqxS5a6P0dj4LH5SQxOnY6nszXKbfNvPtLjr0pylL61kW7ZtRDsYlXc+XJh1Q7zR+LGyUANsJ04q/40+MPkUTZWkrlpryRRvLLZhaLB7ZlcJuXugcTEJvAD/fmGeytMtf/yqlBzcUcXh7YLJFdy9mK699FQqFCdCYlIj+P33hbizqIuOmJTxBXKOzq6rcwQsYQhq7jsyXDQK3sD6vbHj0jmvGouxykwOWxhjo+uB4JJrZQ6A8zysaXa6r08OJmMPvVZk5G9/ufxuRYOuCddSjntV/V2LELbUXfBqkcdcxfiqx5+AoqJlBh+5a1hlbTM2FTh4dSREhnVivdBdqzmwptANvV9pF+XeCejoNvRB09GZfV/kQHuSqEKkvONB6QdidoMwIGjSnHVbUJtzPUNc9A03GBc3smG1DhFh0qtENuxaYUZLNfKG0TYn745/3hqcVWkz+a8D7RddTR2m5jkmAndhplW6ms0ocvNv5H7BfrQWTfugxnE+HXdDXeUIXfT25rlt7JssYbfkeNaqDk1jYLhLHGaogJp+R1gTyhvDTY9mee+9BpZWLK6OT9WBxwkKvJhIhtMK6VHH4z8gJl/FouqW9AhOkQZ3qfa9UVdkNWeY2A6x2wNA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199015)(36840700001)(40470700004)(46966006)(426003)(83380400001)(36860700001)(47076005)(336012)(86362001)(8936002)(356005)(2906002)(41300700001)(5660300002)(70206006)(82740400003)(40460700003)(82310400005)(7696005)(40480700001)(6666004)(478600001)(1076003)(26005)(2616005)(4326008)(186003)(70586007)(54906003)(6636002)(316002)(110136005)(7636003)(8676002)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 10:08:26.6088
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 510d0b7d-4684-495d-7e1d-08dae984a0ad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT081.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4998
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


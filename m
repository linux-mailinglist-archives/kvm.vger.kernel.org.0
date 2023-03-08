Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F2B6B0DDC
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 16:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjCHP6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 10:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbjCHP6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 10:58:30 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC0F423E
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 07:57:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWA8kGABKHhUI4JgpQWjTGaehT5YJXEKTFLFNwUp/Z+raUmbQjPT9M6ly9t67slK/uyrUF37uyMmsBWOi9SVR5avcyUoHWMvcRT+0M6nzBzLTQv+6O0R64zNoggyKTgWnUE2OoIDTnl0BHzgvwStl7wxPNQORUMTQbiIPSR3G7+s4jMXHpVWRLhOWx7+8zFSh8snvSe1EyPHXeETlHBekv6ysGYEA3FabaW1oZ9tu2o5D/E/oxpdmJK34YfcmjXk4LAmoKe2bTfHnRgr30QtlzuTG97XGo1yz8pwVdJfIIBarM29UTgxxPwt04z6wINb+6jccPDN9s/t2JgoHXVu3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dW7rFo8qtcgetoDZ6slUIfKhUx9+KDLVACIkwUS8M9U=;
 b=RPiRJ/YNsFxM8ofniPRPAsOVMsAAnC5RIYli9oBDOIKZDKKdFab7p2/VtsFTOnq84je7vzxYKqYASgEZ1r3s7zlP/dftwUUA6cL3ipNORF3f+sOdCp/I+cYKboa5ggEs1MgPiCe7rvCzW69loLNKhDz6d8VfBcrfRUunmEBkrszcMr9sBWuCN0F6Es3P2KV3GVVWQ5S3ob3EPczR/0QDVFZvr0TV/NlzQrMCMARj+Faf0+L9Wm8gGiGsmC3Psk+8gbaq5NMvU1ZzYLwRtTDX78D5erDdmooxytRcCibxYGKjxgx9vKNewo8GIuQ58tBjkoMGjIc0TMW1yvUhzSAZWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dW7rFo8qtcgetoDZ6slUIfKhUx9+KDLVACIkwUS8M9U=;
 b=Uaqo5A3yKPATD1itcSn+jj27+/VQkEEUNUz8bKW4BUdkzC2SfvJOeS6O9LKk4swqymq6OvUzNrXIkLYfaDgwJlwgvvV/kesUj59pitX6Kf0MIfisLlNWmmTHv5HF3HZ7BY1cAL+xWyXbNVS53XJwrn5TNQnuZ13tbx+8mNE3t1hLhUbVnSYXypBO2ICxxzdxDTQkHQego0l5qUfPceCykfb2LSn3Zi2icku5Xivmh958RNXi9J5BGNQ5LdiH86sx9vKQHVfjA3hueXN/Tvp6A5PFfjMMiMW6t80YH1mp+K+1ycKCxKTXdsxoiVbVLa54yeyTOzxYUXIlunaJIJwYDw==
Received: from CY8PR02CA0001.namprd02.prod.outlook.com (2603:10b6:930:4d::7)
 by CH2PR12MB4294.namprd12.prod.outlook.com (2603:10b6:610:a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 15:57:43 +0000
Received: from CY4PEPF0000C96A.namprd02.prod.outlook.com
 (2603:10b6:930:4d:cafe::19) by CY8PR02CA0001.outlook.office365.com
 (2603:10b6:930:4d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18 via Frontend
 Transport; Wed, 8 Mar 2023 15:57:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000C96A.mail.protection.outlook.com (10.167.241.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Wed, 8 Mar 2023 15:57:43 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 8 Mar 2023
 07:57:43 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 8 Mar 2023 07:57:42 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.5 via Frontend
 Transport; Wed, 8 Mar 2023 07:57:40 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <avihaih@nvidia.com>
Subject: [PATCH vfio] vfio/mlx5: Fix the report of dirty_bytes upon pre-copy
Date:   Wed, 8 Mar 2023 17:57:23 +0200
Message-ID: <20230308155723.108218-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96A:EE_|CH2PR12MB4294:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ff56436-a41c-4a4c-4f71-08db1fedda7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /WzcDYlWWYzVN63vD6uHFFCtzKQ5008Ij50WIC5gPl6KHMwlxVf/iirUhDqFuHuVv75QO2v19VlqEmaLFhgaoWaXITp47HgYs0TKORM5I4mRsb8tmrW+GrUgPFOJ4A9RNSgCthzm+71VS7JHiLlQ2MkG4uOz9BlxN3z5AcIZb2i9Dmi8Xvk0Y+VAgz/Q0MrTVd3f+HSOpmzJDpwjhGmLrYAoW79tY+1mcp/5gagqGTDPzwRBr2Nc35dpfccwXPYRdxXxej2d0qShwWwl/cLRvIxeyq52ifBiwD7+g4mdZuFIV+CIWbjFzu66NPqdc2fygP4XHaayShpJWPPSg/LKOBjfb8whjb5rZesNmmy5FKYrKkDGDGphUJgDNwIq4ks+Ez6d3tXXgwDzHHGJGEDJjwWmS/9dhURftmVJLEh2j23x8deVRBCivjQXnQb6UfoW12M7B344pTpki+DrZZq3wGBz6rwNt+s5cAXwrg0g0JvRsaBilgrvdAI+le5CAOUTyJY/9Wn5mh14rmcZmeyHMS/JunLtejypsHPTghSs6aeYSWjx8u5kq8n2PpNe/0GT0p9CTY6TvXI8uu9GnAFeTQWeeJQ8Ab16kXsKjNAdVj7OEUDMoSB16ryrNCvNR3J/DiEvXpFxv9ckG+4G8MBBBTjKSaeSUDs5hxB04jtV4ZHXN9C+zCJIjY3z5tFwlzTgTr8rzsAEOtLN8jF4r9FEeQngVr05lIa4AqAKay7DgwI=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199018)(36840700001)(46966006)(40470700004)(336012)(47076005)(478600001)(5660300002)(86362001)(426003)(36756003)(1076003)(40460700003)(186003)(7696005)(2906002)(2616005)(26005)(82310400005)(70206006)(40480700001)(70586007)(7636003)(8676002)(82740400003)(4326008)(107886003)(83380400001)(6666004)(8936002)(356005)(36860700001)(316002)(110136005)(41300700001)(6636002)(54906003)(14143004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 15:57:43.5122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff56436-a41c-4a4c-4f71-08db1fedda7a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4294
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the report of dirty_bytes upon pre-copy to include both the existing
data on the migration file and the device extra bytes.

This gives a better close estimation to what can be passed any more as
part of pre-copy.

Fixes: 0dce165b1adf ("vfio/mlx5: Introduce vfio precopy ioctl implementation")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/main.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index e897537a9e8a..d95fd382814c 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -442,16 +442,10 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 	if (migf->pre_copy_initial_bytes > *pos) {
 		info.initial_bytes = migf->pre_copy_initial_bytes - *pos;
 	} else {
-		buf = mlx5vf_get_data_buff_from_pos(migf, *pos, &end_of_data);
-		if (buf) {
-			info.dirty_bytes = buf->start_pos + buf->length - *pos;
-		} else {
-			if (!end_of_data) {
-				ret = -EINVAL;
-				goto err_migf_unlock;
-			}
-			info.dirty_bytes = inc_length;
-		}
+		info.dirty_bytes = migf->max_pos - *pos;
+		if (!info.dirty_bytes)
+			end_of_data = true;
+		info.dirty_bytes += inc_length;
 	}
 
 	if (!end_of_data || !inc_length) {
-- 
2.18.1


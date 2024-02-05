Return-Path: <kvm+bounces-8014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A56C849B18
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 13:55:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96363B25091
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 12:55:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAC9728E09;
	Mon,  5 Feb 2024 12:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cRouBr1m"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FA94D9E4
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 12:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707137347; cv=fail; b=bdGASh9T6IwlhJymQ0ddcWGBvnnqGJCQlxDNKampTjLQT1uMbWPtMrof29KujAcLbcd9xkMzubZW+LL2cGg5ZQxrLVohFkMtTeddJDyIAzbzIx446+3FLQ+43fRsTtYsmgOJyZIsttMhWvT4gPwpg0OF7s353LN3uHP3zcZxSu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707137347; c=relaxed/simple;
	bh=bEStpGhp/jxgcocrPeRlB2Z2Aq4KVLJWW81SgF4OK+s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QDR24nzGJ5vFiVTrfjXae/68iCyc0qf03bQz5vvxxRSbDKjG6xiDY5h+qbL9P9xiNO1ZDK8Vfh6ixuYeoCd6DHCJDX9tVhabBg97317irAPhFUlRHP02lU0jFPggoDdDdKNsltIiRz9hcqLhJpl1PgoKZPvhAZgJWJYn9+niV+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cRouBr1m; arc=fail smtp.client-ip=40.107.92.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpXhDbAjbXD3JANTKDYvbvHdK2yxxYqtXHMNCU5W7E1jT6lGlfTnZ+eyM4u9C1BcHLD68uzkLmG0VyQqsQBt/n3KIPQ1OXLlx8+s+Yca3N+BXuMpYdLjjf+e+tO2cqATkqh4SdcAo7JvDWNxecMQRy8hk3IdHy0Etfz4ST44UxgJEeMo20kS44OFCkLnsxTMC3YhtVK83zHPu+z507Mro8mbVO0yGa+ToVdDmCnFRyHbvaf7Mcs4oDuEIKzTbltUXEwLzhsHM7TvSn4quxcn/e/lWswYDdKUlem3kwnGyAGtJcf/YiJYDvq8Wa/8BNJYYEUnPyaqoAB42K50925jWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9m5z4j22vPdJjJPs+MBTWAJbpLlAEXZmcstO+GhBDys=;
 b=VZYln1Cbs1gTSAHr1HFXmXJO5rcQVBOwRrpU59Ik3qoZN0cExjzDKdVcJJdZPkZuEeaZY3ugWrSmGu6KllaUDUaOoBulv7SBNOStNSDl8Y5zFce3Vae2p9tqEJIFwzadYka9AKeeVwKkqnSjWavFaQZEHb7le1V/8Ob6mDYBwtStbQ/Un37DBfAQQx19ERoxjuj9o120MwHKS00wefgbFcHmG/2Sp3tARI6otOOz5JX7zBHafizNE4AZOkfnG4UCqdeEo/3OpE4vvryY+TnnHbtWVey9BQPJSHWwDqfHJn/ygG4clJ4PKDapB/S5Kb5TMv9KddwPZ36+e45Ab85r8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9m5z4j22vPdJjJPs+MBTWAJbpLlAEXZmcstO+GhBDys=;
 b=cRouBr1mMBWK3Qrw+fV9HSzpZbYrMKDtoHkqtmbaO0pJvgI2K930jzPWtMG2Rqt2RXTBgtRJID9DW1wMMolQZFQXb/EOpS0a2ReZc99sThFGPX9Wm0I0iHPL+xFAoInOho/W5jO/Vi+zeEaMv4o9tgjAh9mXUoG59qc52caPFkLXq67VI0KJjiTuDe1Pss6MgkdAun/eIPkpGWk5QbTADulzKNzoyI4Mr007ED3+Hk0rq4FsFLd9/kH3Vwv49yLe78xNNaxCec+DYe/T95lSeJo5MqfjnlQCjXgz2n4slxlEA1I7No8553eOzLU837tbJc15ostv2CtySyPdm8zirQ==
Received: from MN2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:208:23a::12)
 by DM4PR12MB7670.namprd12.prod.outlook.com (2603:10b6:8:105::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.15; Mon, 5 Feb
 2024 12:49:02 +0000
Received: from MN1PEPF0000F0DF.namprd04.prod.outlook.com
 (2603:10b6:208:23a:cafe::bb) by MN2PR03CA0007.outlook.office365.com
 (2603:10b6:208:23a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36 via Frontend
 Transport; Mon, 5 Feb 2024 12:49:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0DF.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Mon, 5 Feb 2024 12:49:01 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 04:48:50 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 04:48:50 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1258.12 via Frontend Transport; Mon, 5 Feb
 2024 04:48:48 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V1 vfio 1/5] net/mlx5: Add the IFC related bits for query tracker
Date: Mon, 5 Feb 2024 14:48:24 +0200
Message-ID: <20240205124828.232701-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20240205124828.232701-1-yishaih@nvidia.com>
References: <20240205124828.232701-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DF:EE_|DM4PR12MB7670:EE_
X-MS-Office365-Filtering-Correlation-Id: 9333d91c-27fe-40f8-85af-08dc2648d432
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nHeJ4RqfgJ8pXOtBVZWadCmgY+4eTXy3p/D+MSKpBPqeG7+AmMt9xOqLU/UXGeXHtfWL9ijRbY5HqBWVstEbbqUX/XULnBj9x1rrB4nTvuJ2I4MN9iaktnU7PFn3w2mGr0QUZd5ebOobwRbGz/QxLottfWPdAkV5Ifp0PfNV3NnLgFY32hGufipHRZchhp9wL77AmUKb17fF/+mdEVoWtFN1lpN+8UPeM1vVU+yXPOoF62/fVbHRfi6ohVau2U31NIbHLH1qgzYmqPz8HuD2EThNFxtIG+qSu4K+zxvGQBwsdtZouMKpj4tniWIQ6sVBwgu6Yy4AcgujeftF/PZpftqKDJN6N3WoEnotZwpy+0WYXi56DZnjKuYgrQWdwZvEBM+87EvvoscEismo7gIOWoQjJsyUxGGCXCqas0wwXfCActl0oLdQ3VnuBP3oE6B8CNr6wxGebftdWCYELhDxF6++ddMcjNKITIBWnzulvoKPCHLV1U4qDxRvPyJ1Gn2CJm1FbxX2tjY+skYKhc4p56KzLBnwRehi/2m9TGIQyRzW1fuAxzMe3p3Y3fKj0lD938O3zzzxrrfPBa/zL714TfOJJ9mq/qCFY52yP9kEqWD6R3E9DyG9j80wWyd7JvtdZsC7Db+pE6ixiXKd3g3G1v4sP/B4mpUyM6h85sD6oa0UrNgZ/mMIVg49LxdgnM4+arFZ2z1UXU6Ucp7IzafaaaowSizK785V3dgtSXdwS8aca64Aul6HE3u6h/UuxG/w
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(376002)(136003)(39860400002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(82310400011)(36840700001)(40470700004)(46966006)(36756003)(4326008)(8936002)(5660300002)(4744005)(41300700001)(2906002)(8676002)(2616005)(1076003)(107886003)(36860700001)(86362001)(6666004)(47076005)(7696005)(316002)(6636002)(40480700001)(40460700003)(478600001)(110136005)(70586007)(54906003)(70206006)(82740400003)(7636003)(356005)(26005)(426003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 12:49:01.7161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9333d91c-27fe-40f8-85af-08dc2648d432
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7670

Add the IFC related bits for query tracker.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 6f3631425f38..cb08b5e36c21 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -12619,6 +12619,11 @@ struct mlx5_ifc_modify_page_track_obj_in_bits {
 	struct mlx5_ifc_page_track_bits obj_context;
 };
 
+struct mlx5_ifc_query_page_track_obj_out_bits {
+	struct mlx5_ifc_general_obj_out_cmd_hdr_bits general_obj_out_cmd_hdr;
+	struct mlx5_ifc_page_track_bits obj_context;
+};
+
 struct mlx5_ifc_msecq_reg_bits {
 	u8         reserved_at_0[0x20];
 
-- 
2.18.1



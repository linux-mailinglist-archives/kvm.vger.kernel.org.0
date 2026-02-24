Return-Path: <kvm+bounces-71593-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id INw/N65gnWkDPAQAu9opvQ
	(envelope-from <kvm+bounces-71593-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:26:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 784CF1839FF
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:26:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 780F6317254E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B389C39FCE;
	Tue, 24 Feb 2026 08:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ADR1NyJT"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012016.outbound.protection.outlook.com [52.101.48.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49B8364EBB
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 08:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771921319; cv=fail; b=YIBK21h5PFyZp5AbwGpyEWdHk0mRiXPGFgSzZru75PV7LN4edo5xl9+CIKl6wqtlG+qIm4rIMnqH/uWClijLXIhP5bwr+ePZGbVRDvXpdjWmdW31m+ocoQsToTsAyINcrNvHPoDVF+bqZ6ASnrg7k9ktNRCglmc3YIiinia2j0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771921319; c=relaxed/simple;
	bh=AkzlrcPM0cju9otixYf8GDK/gg6rPSQH3/blI70KIjA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OrXoFFIqZGtafWxNaiXFKLNQWpHQt1ifGP85PnshZ3+sJtWTW4HLfezpcitcS9QoH9xOZVAfd5RpfDQ6UGWWAkOGdHrTerF8OSpBlbT1BMgsBPS+yvFtCOf0CZRhZWquI30T3VKEEpFG+OnQ3hwYD9fmYON9J5s0FtORuCwevME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ADR1NyJT; arc=fail smtp.client-ip=52.101.48.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X57fZIaeFW4U5kD0qTrn/vh3a6LaTORovU/2d8kakUPJxqU8eBOMOe2LFkpDDual9O+yHg0wIuuY31REHtoK9Bn1rxmynZYzJAk/YOO+B4AxAXY2wQDzagRKgElLRDC3ymx0cWluKR82osmLRc9b30PbeDIxYQgV6gOWdAcn0d1yrSKNcGE9qc1iOo64/s92stxaAkddUY0Kg7lZYPKAKPR2WaXyf+Fz/s3ZGdofxeFSdpZDHtdwpDAv8kIiY1AGiZaHau7oEuXQEkoAsoJ5voMDpeO5gx/gaEz5strNprpVaeLsTqI2eY1vovaZjaVAAVtX9X8j1V7auyqUEGvr6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0PsgkAPD7bopNVkBU8kxxWc0dnm/RYb+2mn8564OmtI=;
 b=hQvRbl4guIduam7zu928ObBxLTFNLm5wyQHwiPe/vB4yVZ31Q20D6WBNGsrkduMI5E+39LM/nRPrsDsnya5C2gmAwOOzAJL8lLBBW3THOB8k1htpsMtU4tt0h3DKXUOKCwbs8/Ma/kO6vwIQwHGWgR5xzntg5etBQWnkkSDFVhYW0YyeDZoBQOiQHSFAzMSXqdqqR4pO/HfgoHVgsBfQhznXwG9e+1SrNc41g150iJInPuLIdlFYWTqNbBlewacyqccGghcSuh/yetj0ETr/PMLj0shzThKy//hnvO27WsrzwiePw/FqMrulJGa6UKfcOC4f5qaGgb3U3MiM/ek9dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0PsgkAPD7bopNVkBU8kxxWc0dnm/RYb+2mn8564OmtI=;
 b=ADR1NyJTXXgJijQ02hkHL8fSo5dcLC0MD2HKikXd2zxh+uFRK8ewL5tfCtrWf07sqDUXP2XWDUybQsnNr6PMu3Whs1Vn+nCfINb/N52pNBmKmCs8fJsjaCEwKSB2TaLlzEViQSxJKhXXxADXv3Yz/M8rZW10ZunggACeLJG5e036NIuochdqhf2HzAvignbEbmeOsH2+aICcm/8rF5LkKQ8f7PRGadcZ/1dDaY8O9OSSAaqg1sGCKA/6asVVdV+KBZDlVpMzBTXt51aUo9Dc3EzSdLdyBrln1T3qTwjlfkToX1/R84NXBSBbPKps6ch24GpX8kK16tTb+bGFkgQQuQ==
Received: from BL0PR0102CA0057.prod.exchangelabs.com (2603:10b6:208:25::34) by
 LV2PR12MB5776.namprd12.prod.outlook.com (2603:10b6:408:178::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.19; Tue, 24 Feb
 2026 08:21:54 +0000
Received: from BL6PEPF0001AB56.namprd02.prod.outlook.com
 (2603:10b6:208:25:cafe::ef) by BL0PR0102CA0057.outlook.office365.com
 (2603:10b6:208:25::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Tue,
 24 Feb 2026 08:21:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB56.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 24 Feb 2026 08:21:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Feb
 2026 00:21:40 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Feb
 2026 00:21:39 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Tue, 24
 Feb 2026 00:21:36 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>, <avihaih@nvidia.com>, <liulongfang@huawei.com>,
	<giovanni.cabiddu@intel.com>, <kwankhede@nvidia.com>
Subject: [PATCH vfio 4/6] net/mlx5: Add IFC bits for migration state
Date: Tue, 24 Feb 2026 10:20:17 +0200
Message-ID: <20260224082019.25772-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20260224082019.25772-1-yishaih@nvidia.com>
References: <20260224082019.25772-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB56:EE_|LV2PR12MB5776:EE_
X-MS-Office365-Filtering-Correlation-Id: 763595eb-2555-43e5-c4a5-08de737dc4c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xLy2i5tE7zfZ9BPlj0srNUgstmjc2KmGu4LKvKTRjztuI7eH+vPJyBmS+uyf?=
 =?us-ascii?Q?xCF4LZGLMqj9PuFA320zC9ejjuIzEWKT8RcLoEL1TWnt0VyhDLlGIQrjgj48?=
 =?us-ascii?Q?5H8rQckgnK5kdm4bMMSmFmmuQXgvVCCnEIrSSil81lsWVcktpfJjh+zlqTb6?=
 =?us-ascii?Q?8NIPPRadR8GeAiV/Gw/JpPJFI2cVMzBT+9RL+LQEKBZdsExgpA+gCsOWegTU?=
 =?us-ascii?Q?pQ9hsbE/vwiBiGhx4ko0cRp8TvEzIGbwWymRNyNK7i035ZMHrR4UgjUgiYjz?=
 =?us-ascii?Q?Ss9rLzKrkjSZcsG51l8zF721EfSEtiWQwuzf0Wn29oamhw6uJM+Etbed/p1V?=
 =?us-ascii?Q?RsP9m0IkblzUZO1q+jvolc2qoUXIRRs4zbVF3XjirIx1qfWgxcEPMexK9mBV?=
 =?us-ascii?Q?m1wQHVIb9CeEoiYrX+Rrt4bc/C0qIZGmITgZkjGgpzHov1TtvkosoM3Nh5oQ?=
 =?us-ascii?Q?p9BRbiutIyC6gdTzBdZ6h81jHW9oEWkN43wqBEwFLEa57KZwRVxdk3o+y80C?=
 =?us-ascii?Q?Nz3F/C7pCanmP6oYQ+5kPAmK5TyX3ngw2KRh0xc93U7EL8iBupZVQzHF8W3G?=
 =?us-ascii?Q?Jb2xheW+Jr9TM08whVOf23/N8EFzoP/4c157HfGl6ijI6ZedH+DVy6otnmy5?=
 =?us-ascii?Q?o9smtGZzqrEbMTAYsp3rQsT9jZcHXYYBUWYd5cN5dUi3RH+QYVl6ELVMpjxe?=
 =?us-ascii?Q?iV5eiYVklUvNkXruGQtUzMTt1p84rUpUsbgWxwpQAUlv23wZKx8KZM3eF4W0?=
 =?us-ascii?Q?v5PSyBcDEXZ+lKTMlMPSMHlOfPsTFw/Tcgrskm1G6EuAhtVgRP2vJVIeKhN5?=
 =?us-ascii?Q?6aPNbHyjpdzVrt2r04RrXXKzMbsrdmyphne4UHDWvQqZaGVf6E2Euak48Vt4?=
 =?us-ascii?Q?bVIEm6L7gnkmScVHIPPNQjadBykMYJZBxzON2GXdFjP/kH1wO28Toa2wmZ13?=
 =?us-ascii?Q?xe5jdUbnOH85NiceSCU+JIGabCWZJXUs+aGlItzTTyXGD+1riICuMYa7NBET?=
 =?us-ascii?Q?ZSsVwruW3SpFQKotb8HcWNeIda/uq9DD8ENW7pQdO70ymteK8+UrpY5T8GOp?=
 =?us-ascii?Q?/OKQapKKqObvNL7h4h1BfCS6UngdnmtREK4n+QNPhRlrrcnRrXy0qxHHhuRl?=
 =?us-ascii?Q?QoMhe4TPOF2gJmY+/72nTlMuSAWJLNXopriS+k5pfQnzj9mXNuLVYxTzqjKl?=
 =?us-ascii?Q?7/lwODIiGvCRbfKBDkRiyizqAdpIpLpGWcotK0iQkIaJ7iM+xhc/uPGVDHIv?=
 =?us-ascii?Q?HrNzd4Sq+UgiNrCEn/4DYvw9Dq+aWQjSYMpSsKoW4+D5mWwtmsScoGtWXEZ+?=
 =?us-ascii?Q?H6/W4aHkSurH8jRXk3XL1jrvhLV6JIOL2pY1xqGe92Z9j5dnZtIsrQl+g9k2?=
 =?us-ascii?Q?yCM5xakXDM4ktYA4E4l+MS+7yTpycLvSJyCMnrBcndTjon7kYsbQFPQ0QN6l?=
 =?us-ascii?Q?e2Rbfgs/qfpeDIQ1L6p8hMeHpF/Btp+qCE3vk3SxV9WzU7I+7/08nZrxAgGd?=
 =?us-ascii?Q?cZfHtZy7zr3+pV+7pDsRz91vjvTOq+m7o/y5ueNyPF5G1x8aSvflAiKZoOhP?=
 =?us-ascii?Q?hWJbjtg9wRu7H+ML09uCQI7PwPgvlW3WHYhrB0DiSdpS4BM5v3ZmYNVRy5oj?=
 =?us-ascii?Q?GhDwgWlAEpFeVsD2JE2yeubITZzJQ6j2IOBW0zojOuyE6BlVb4UU+PTS47/d?=
 =?us-ascii?Q?E05K4A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kvjo2Q4KpRGCQO834JsuqcvHj3rVTv2eESiCTeUAgBPzg3cq5KNWlTCThziu9ylh0c0+gPOhBbHS6xddJXgUpAN7yu30DIijVgJhhOFNCujHdURCHNZEz30FK6kw8C4w+WHww1kIUWTNTeXhKNXlds5XTYpVRCLhs9GJaaCzk5doNF6mB3emuU4+NnSZ9OCyzevKRo5eafli7MZdW7nht+XzrE3fNWniNlSt+Je15o9BQgKeKFZit/9OudQfd/5d4Ucz0EYbdQ+vgqpm0Vvuo+yrouwxKL1Ou9+q1wfVxbQwYqDrHh6ny9V+u0jUfGrM2HQjkFb6oRZJcvHnUkdfMNGLRKvYEeeceDnQCTI0NMOJlKaJz1bkUE83GFYRzjkhmYzpn85Dau1vSXxx+QZGOujn5XE/lnxtmOKYQ/L6MVQnMWQ09+NJj894fzqCyMVN
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 08:21:54.0446
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 763595eb-2555-43e5-c4a5-08de737dc4c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB56.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5776
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71593-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yishaih@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:mid,nvidia.com:email,Nvidia.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 784CF1839FF
X-Rspamd-Action: no action

Add the relevant IFC bits for querying an extra migration state from the
device.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 775cb0c56865..1c8922c58c8f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -2173,7 +2173,8 @@ struct mlx5_ifc_cmd_hca_cap_2_bits {
 	u8	   sf_eq_usage[0x1];
 	u8	   reserved_at_d3[0x5];
 	u8	   multiplane[0x1];
-	u8	   reserved_at_d9[0x7];
+	u8	   migration_state[0x1];
+	u8	   reserved_at_da[0x6];
 
 	u8	   cross_vhca_object_to_object_supported[0x20];
 
@@ -13280,13 +13281,24 @@ struct mlx5_ifc_query_vhca_migration_state_in_bits {
 	u8         reserved_at_60[0x20];
 };
 
+enum {
+	MLX5_QUERY_VHCA_MIG_STATE_UNINITIALIZED = 0x0,
+	MLX5_QUERY_VHCA_MIG_STATE_OPER_MIGRATION_IDLE = 0x1,
+	MLX5_QUERY_VHCA_MIG_STATE_OPER_MIGRATION_READY = 0x2,
+	MLX5_QUERY_VHCA_MIG_STATE_OPER_MIGRATION_DIRTY = 0x3,
+	MLX5_QUERY_VHCA_MIG_STATE_OPER_MIGRATION_INIT = 0x4,
+};
+
 struct mlx5_ifc_query_vhca_migration_state_out_bits {
 	u8         status[0x8];
 	u8         reserved_at_8[0x18];
 
 	u8         syndrome[0x20];
 
-	u8         reserved_at_40[0x40];
+	u8         reserved_at_40[0x20];
+
+	u8         migration_state[0x4];
+	u8         reserved_at_64[0x1c];
 
 	u8         required_umem_size[0x20];
 
-- 
2.18.1



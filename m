Return-Path: <kvm+bounces-71477-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +JY/Map5nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71477-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:00:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A7CB1793EA
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:00:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2B91D30BA427
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 976D030BB93;
	Mon, 23 Feb 2026 15:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MLOQ8roD"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012041.outbound.protection.outlook.com [40.93.195.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5409D2F363F;
	Mon, 23 Feb 2026 15:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862140; cv=fail; b=qC7Q8zdq5UxDN7NBQt5n5MXAzMEo8Hzmy4iE0zkiD2kUvlbNmPglzk5Y0m+sZUTKCmkQN2v2ltfDxrAQYbquhy0B3WuruuY1GrXDL67WgieIIjMxRhVw76FGI/8GZhKAHzD1OuQeccPRxGHU1SGLPYptt7O4p7WGbWYD5Jg0vV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862140; c=relaxed/simple;
	bh=YO8moe29foWCl3XIUM3N3zbxtanwcSlho464Xzcr4as=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A+FKOvUezt7UCKehCot8fFhBX8L5/3HTgvzFtcj4LJyvhVfEFCtQmrDguqTXztQ6WW/l40m63LK2BTogzg1HIhOwaf/F/oRuIfAD+TKVjlfT85KIPHdrPgP8X1qGEQ3oP7lk4qKiLSABkY/uWj3C/2Z7dVXzMODqbzR7icQojJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MLOQ8roD; arc=fail smtp.client-ip=40.93.195.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GHAtBp7zX1eUiFsl1tMsnGOLWhxKrdJuaZRI+f28o9i6I22WKFI1XLqemqc30kcnsAiZH8nccFPpm74Ylzmn8g4nbC+rflZASlfhdQUX1VLf2HyUxsArAL3AuDtjSyl8D8GZQHVgUFoO47mY9V0Ky3HIK9ece6fBBgy5kuTF9ZueITY7uQqp7znAuyuvfDPl4/gtbcr9Y5m54c2RZrmyLhLbx8z1eoN5Kg3S1eQgV7oILQqEuhGFHTzo1CTF534JCUbASSo36ZS+NIInHI5X9xKNBRdHjF596ZvR/dtF55LWKZH0ZGPuS33Da1NuZMDRvdzJFJXAzXoUsP3EjBQVfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mo8VLK1SUlVSQGIwKVqulaxuYfV522PjTVGPrkJfYhw=;
 b=KWcwTDeKBxp0abocJKnEACbU9PBZof6YN9pjiTux3vlDzm9W7Ccd2afP5c1UTpkSrKK7q8nu3MzQOccBFJSXEBTRKZluL1eSCu+sRCsDPzWQLC9L3o7D3cg47kaykE3QEfgjrkkAk4M2tS8XyTxkO7HMiqwZQXjzSVIKZQQ0iFM7Xk4lD/4l21yroilq+vIDM1Vq/bz9UCkXhZqu7Kt3T1cb+tgkWhPG5xb6qhIJ/F/95UpCmDDXOkVLiP4ng1eIqKHkE+JgaYVLx//0jG6H0yT2kfg+mt6ymoCM0FZbEDD9Y/+mO4wEHKtt7HQYFRemYF8GNZTS79ZB4zmilj1WPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mo8VLK1SUlVSQGIwKVqulaxuYfV522PjTVGPrkJfYhw=;
 b=MLOQ8roDYFlsK5vV0S/vYlI4Obovr2HpA9CMBVdOEuJMHwhF9Vfm0O7jAz3NhBpyz+oJaECeP9iTKKaZYQGBVSzHOgGiU46T4yYjDMHoxFERvBZX4F0Uexwqsp2au+0P4iRWpMWk3VqtcsiMLxGrKtY5qd1Iy+GKUn6awVbmT8jLK94JzHwz0WOoCqSv1drAVPBqD82GNhC9tieV9cCnQRrCOqdu47CZSiCJmamViEIXllF+6KCc/wou9yK33LB0kBo9fnKf2NnGM7YLR0nYTWk/PI2A7+FHSbpb+cVqEUR6FzlH+NyJWIql8/SpxqHzC+qVS6OeM3mlsP2O3F6HeA==
Received: from CH0PR04CA0040.namprd04.prod.outlook.com (2603:10b6:610:77::15)
 by CY8PR12MB7634.namprd12.prod.outlook.com (2603:10b6:930:9d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 15:55:36 +0000
Received: from CH2PEPF00000099.namprd02.prod.outlook.com
 (2603:10b6:610:77:cafe::42) by CH0PR04CA0040.outlook.office365.com
 (2603:10b6:610:77::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 15:55:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH2PEPF00000099.mail.protection.outlook.com (10.167.244.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 15:55:35 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 07:55:18 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 23 Feb 2026 07:55:17 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 07:55:17 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 07/15] vfio/nvgrace-egm: Register auxiliary driver ops
Date: Mon, 23 Feb 2026 15:55:06 +0000
Message-ID: <20260223155514.152435-8-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260223155514.152435-1-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000099:EE_|CY8PR12MB7634:EE_
X-MS-Office365-Filtering-Correlation-Id: 1385ea5c-2b10-4566-2a85-08de72f3fbc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Iby/Jb1605ccQhd8yUdnDk9SEz4BQ5FS6rqum03IT0AGBHxXDB9uX0iTqrnf?=
 =?us-ascii?Q?TD6msLPkUe42VfRrO3vBGLwz6F5Z/t0yJiv7Rp5TspS10YidQpP5je4QG9pE?=
 =?us-ascii?Q?x9/II15UHGZGXYj0ODF7WQoi535jeE2YZ6Pn/vqK/TAoxCmUTJaxk1vsXr5B?=
 =?us-ascii?Q?W/pv70ztDlpzXVPP9Rme6IsgxKoNxhsKMJxen3rF55l/yKOCYjhNBPq/maju?=
 =?us-ascii?Q?kDCOaUkboA7gpxTXsvFWqFZX0PUsBUQ7kXVEJvfx5Qna6znvvfrAfJzL6hFg?=
 =?us-ascii?Q?JcjkNdK4JPVHIIXkTgCCNgaFn1I3NgZkOPAZBWxYooELdBjzEjEb8eZAM8ti?=
 =?us-ascii?Q?F1dOmpYsC9CKi/YLlgjYhFb4r/zW++im8lpMpl6erHP9NDc7I8jnZt57/14m?=
 =?us-ascii?Q?8lI3SzygcoaogAeL0jx/YGuA1o9xgFysb+8jRawO7UYGKk5NWTu4nCJaPrHV?=
 =?us-ascii?Q?pMtFX4vmi5g8IdMeUgR7mVgd2v6yqLMTAhwK55KAxUDWxrJeCQLAd5ywvjnE?=
 =?us-ascii?Q?usYLdr4dWwyx8c76f1xU17hs1Lcy2o0hOXqNC+cjQUHo3ABXDmI0nqjH8BLK?=
 =?us-ascii?Q?NIZ05yrvE9NqpQVrFZM3KF8aFrPha4JECkUd0puLFmZdoUUZDlD5sqW+49OA?=
 =?us-ascii?Q?0j4Pp5yZA/ViC/r5R6FY6L3zeRc8jNj9YFUTsEIQbYbB247ATauPiwhbcYBa?=
 =?us-ascii?Q?RTSc/NmjrNWLUNvg78dWwwlIT+XZB4fncDLHsIUi3zQ7qoHW/AYr9H3tukWY?=
 =?us-ascii?Q?q3A4Ugi8ki+vkxFcvPyfFkCchrkpg4GGaKnCBsc0AyxDVhe6xStdhtUl0AI2?=
 =?us-ascii?Q?Ht/XVGhKTUx4sWVna72z2Sw01C7mDdKujgDDpTHEMjbrhDHK1hqBuIdjluFo?=
 =?us-ascii?Q?1EX0nhQzLDiqT9vuRe1WG6+cUv1PNk/8Aegbxf7MWT+3RCzlhZq0+uS6RAA1?=
 =?us-ascii?Q?pVnguCTN45xOjIlOrlJfAg9w52Rw39GuLAN5ufXabOIznjGOK20DYJ6brftr?=
 =?us-ascii?Q?uFpS02SGbNquDPWVq0cM4uRNl8zTl4dZBd8rq2bIOTrLgpb+YD1vG9N4pzOO?=
 =?us-ascii?Q?gzk3NJktHmC5q852gNsrd6TneLKw/vUUHNSxsnJiHo87D3sFOM9l6iNJYHJJ?=
 =?us-ascii?Q?TmhAo7Dtbk+4rEYj2P+LpZO6IOZrRpR6SNSgBR1djveRXm1BMQS5/1F0CtAN?=
 =?us-ascii?Q?c56uEJA2CCHczIsa4iVsF/QKrfKKfAlbbWBGC1MvMuZYsQj3mzIpSa/eRkTo?=
 =?us-ascii?Q?iO5fs/hn8ZjnZxdj8mwJ5zB5jmKXzljLM/avK+J8UMuiodA8Iq6NyPGcUxEO?=
 =?us-ascii?Q?K2t8N/LCDo/9HudxjqquLdn5pJH6vHYLwRqxBoXlQtb7fw0fvCPdy9KbxYd/?=
 =?us-ascii?Q?goL3dd/YFmekC0Ktnh6kOPBzlrJnoVulf2L47f2sCgTPL5jybtG1nEkEg3ly?=
 =?us-ascii?Q?OIuI5Pg21MHwod+vxIMXZr7TpmIGJsSSTEPji/L2CNBuutq8XQeIChS0M+hQ?=
 =?us-ascii?Q?7dhnbtkc31zTtGXVK3oMTlwGmwLcAWmj0vo1Rlqt65CzRQX2swytCj1sWNCq?=
 =?us-ascii?Q?SkuRB0XOcF5QCuIOHhbuzxxcCri+SOa8MeBDuOJFmarcXj18Ag36TGR1Slip?=
 =?us-ascii?Q?vaBPcNBiVc2LK2rBFOEExQU9WMUe6jOPQJHIkSGctFkT0m24qFpIhJHQ2uoH?=
 =?us-ascii?Q?+oOwlg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tTtndsj40g2S1KPElDstLu0DF2eEGJginW4+t9Ghba3JFGVvXjsP5BNXf1MvjwoeAbNcotAcGz+l7jO9o1xSTiEoUcMCkOmjBuKQxbwSGWWMyEBTVhYK0eH8v4yIAQIJ8UJsQEscQa81Q4Z9hUzyO9YQR6/Gg01/34WXWN+ZyNecBO77sZYkmVC8SXyj7QaCk4C9S8kKHFCAjfTYw78NDgxrsPjYHQmhbqPX6N6ZqoPIZVImbisF8Ej9fAclXsJnXCkj5WUeq1HWSmyL6vaz9PK9S1ov9S2zLoLIjjfnCU/UuhNqWYMmqqE+83Hju7QeYlVVQRbXVB6W1ru/u427cl/O48aMyVlQjN668ZDbFirXfO77prlTpVC/4jfZceGJCeqo0aRtSUKuZXXtYEGOZVtOrBdRdQzRgFaReITIiRHiHa9ZA8jxEqKK3F14XJMr
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:35.8072
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1385ea5c-2b10-4566-2a85-08de72f3fbc1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000099.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7634
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71477-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	FROM_NO_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ankita@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,nvidia.com:mid,nvidia.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 3A7CB1793EA
X-Rspamd-Action: no action

From: Ankit Agrawal <ankita@nvidia.com>

Setup dummy auxiliary device ops to be able to get probed by
the nvgrace-egm auxiliary driver.

Both nvgrace-gpu and the out-of-tree nvidia-vgpu-vfio will make
use of the EGM for device assignment and the SRIOV vGPU virtualization
solutions respectively. Hence allow auxiliary device probing for both.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm.c | 38 +++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index 6bab4d94cb99..6fd6302a004a 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -11,6 +11,29 @@
 static dev_t dev;
 static struct class *class;
 
+static int egm_driver_probe(struct auxiliary_device *aux_dev,
+			    const struct auxiliary_device_id *id)
+{
+	return 0;
+}
+
+static void egm_driver_remove(struct auxiliary_device *aux_dev)
+{
+}
+
+static const struct auxiliary_device_id egm_id_table[] = {
+	{ .name = "nvgrace_gpu_vfio_pci.egm" },
+	{ },
+};
+MODULE_DEVICE_TABLE(auxiliary, egm_id_table);
+
+static struct auxiliary_driver egm_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = egm_id_table,
+	.probe = egm_driver_probe,
+	.remove = egm_driver_remove,
+};
+
 static char *egm_devnode(const struct device *device, umode_t *mode)
 {
 	if (mode)
@@ -35,17 +58,26 @@ static int __init nvgrace_egm_init(void)
 
 	class = class_create(NVGRACE_EGM_DEV_NAME);
 	if (IS_ERR(class)) {
-		unregister_chrdev_region(dev, MAX_EGM_NODES);
-		return PTR_ERR(class);
+		ret = PTR_ERR(class);
+		goto unregister_chrdev;
 	}
 
 	class->devnode = egm_devnode;
 
-	return 0;
+	ret = auxiliary_driver_register(&egm_driver);
+	if (!ret)
+		goto fn_exit;
+
+	class_destroy(class);
+unregister_chrdev:
+	unregister_chrdev_region(dev, MAX_EGM_NODES);
+fn_exit:
+	return ret;
 }
 
 static void __exit nvgrace_egm_cleanup(void)
 {
+	auxiliary_driver_unregister(&egm_driver);
 	class_destroy(class);
 	unregister_chrdev_region(dev, MAX_EGM_NODES);
 }
-- 
2.34.1



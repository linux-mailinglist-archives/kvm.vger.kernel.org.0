Return-Path: <kvm+bounces-71486-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uNmsKpB5nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71486-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:00:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 57AAC1793D4
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:00:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5CCE2315E3D8
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F50B3126C4;
	Mon, 23 Feb 2026 15:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GpuvIa9S"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011030.outbound.protection.outlook.com [40.93.194.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12D23033FB;
	Mon, 23 Feb 2026 15:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862149; cv=fail; b=p01GO4/fT6RBOyT+TLYhmkWYoKQKq2OY2Kr84rTRj3BxwwJNU2gt0bcZffjnt6+XCIIIm6n5oclXw7ybF4GhLitTjjJlCD06s7DJgiFswH1qizPP4NBHG/2aq+qXvNwy63HiRUasUbaPnFmUlGgWTQUOjD+dp+xX6pcY5mHmMAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862149; c=relaxed/simple;
	bh=g9WGhvD9ngoFTjnzO0NsB0gWhptpyW6E12+YgNdnhGU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a0sjuQcWimYV+wVVpxLwIClRjkljQAWYKhJN97tNGaxQZclafOEcm1bGNlJvos2V1KAuO07hHchC4IcAMabMdgbaaEEKnnnf6J1ifXJX4XVSxfKQpb7W8nnm4gghC6xT+sHzM765VFTeucI9pjAXdtr9TglzHVcbvaGXnvsfRRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GpuvIa9S; arc=fail smtp.client-ip=40.93.194.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CgM2MmLdCi5gyb0IGeR2dt+VLe9Ua0aJdzCKJXq3acgdex/LQqNKVPb9B5F1izg6SUMQS3w5367zK5qUWeGtgSpiM6P3s7odQeBdWHHoWMOjz4xaKVeR2SFgpgh56bRSSzfzeppDzL456MTr7+MYK0bPfIHuYFFLiUt8bR+ToHOFOhMQWRPbAQCg7JBgU7pSLVeLTWgqmIRgGPS6Guik4Zv8t3GQ8V2UhbIleQCL3c7z5Lqg2Et6acBQy8dbqXQmJ4KoVX1l6FnxSCGCbdxoaiq6RoExlqHm62pSyAvCXkvRvu8cV6BNO6RUjkz65BQu61YsIMLohsuBxwcwhtaAbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wE57MkPHKMH6S3M6xJWU835IV+am9ffEU6YlWoEmW78=;
 b=mbfPVTcXaBLm1pTcNlYRhVSUjJroi2e0Z4jSYptOD1QZmm2ZKTDNmZGafR2THYFaGInW1RWMtW5Z6WR2e626qZ4MO4L5drMWzdTWX+TdNYIMP3eIoRmWiH6g64hRVegEFnwsuXO7sxn8ObSN++snFK41a+4SRJiBOsbkbEH5H9ukg2ZO92rWTzqUbn1AixGJNbbhlfYNmm1CVnYZAtKy70TAvBfi+zDW4NnUflggkh7KYpu6qSmPGCvWGY1YbG1f2kZHGsgqhB/6PzYspfn0fR9wn23nEqNSgOVtsiXOYZSAI+FERaFNlJ3cDriRLBOtupautt20hPMsbWATTE3ycg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wE57MkPHKMH6S3M6xJWU835IV+am9ffEU6YlWoEmW78=;
 b=GpuvIa9SVMUiP0yTogbc/0eKcT56Sjz4hs5JJafJ4RMYdJ0Srx++bYJP6i0Atc1KyrGpaXCb6gQ/BlaKuS4o8vHz+ButpkKqcQOvLXrw8RASNG/BazjlSFfalTW6+ywFMOe3DNUFgtgIWRCbLQfl6YDcktl24A5r94TMcUQbOk9uW1UtzWPhaZKRzLKlXTH4e3cNJV74+w4LaX4Vzttj2uzJwdeq1PtdaojIb2cfOtDfVZ2bi0yD5QGRjrf9CvYY4yZz8n/LwIfwc2nBPi7qvl1gylXS/BKG+iACv6SyrANIlf6Z7Cc7hYQkClqP4luV8rV3z7Mt0fdX9sdPWFFJ1g==
Received: from DM5PR08CA0027.namprd08.prod.outlook.com (2603:10b6:4:60::16) by
 DS0PR12MB8044.namprd12.prod.outlook.com (2603:10b6:8:148::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.21; Mon, 23 Feb 2026 15:55:38 +0000
Received: from DS3PEPF0000C37B.namprd04.prod.outlook.com
 (2603:10b6:4:60:cafe::6f) by DM5PR08CA0027.outlook.office365.com
 (2603:10b6:4:60::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 15:55:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF0000C37B.mail.protection.outlook.com (10.167.23.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 15:55:38 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 07:55:19 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 23 Feb 2026 07:55:18 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 07:55:18 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 10/15] vfio/nvgrace-egm: Clear Memory before handing out to VM
Date: Mon, 23 Feb 2026 15:55:09 +0000
Message-ID: <20260223155514.152435-11-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37B:EE_|DS0PR12MB8044:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c802257-a8da-45f1-8f07-08de72f3fd59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IOY9QG53JE+lt/ZaYYKw7beFTrGMLWaVZcREiP96Tm5kD6MaIbYRDKfLW+EG?=
 =?us-ascii?Q?Y/FKB0nFx171phm7yfhxBEmfvCmcGaD+48k8Gww7AV4W2x8gqjSvgOBFkF7a?=
 =?us-ascii?Q?SXOHMPRGdoirBMxyqGvRzRzuvRSYyLmBnK87Pt0gfpwZrpedH5k2ACg8uuo8?=
 =?us-ascii?Q?I3nhXryO1RszGk8Kcy5HX1a9+PthlwOhjyridtpt5Ng29+BSoAN0cGQnoYJD?=
 =?us-ascii?Q?ufTm07Rf90MARDjEzRLrdX9gTP6mtv00AKxGrKuvhaRFhGj7M633fwiFUL8i?=
 =?us-ascii?Q?x/IIlXXxz7m8LE7Semw8grS1leYrp2d+dN6JPy5T+YU4Xt2K2yM6AWX8k9W1?=
 =?us-ascii?Q?RINx957oei8g9S/lOzk2qLMVoPHbYgQxPxTnghBQGx/+ZkEToIszVuSPBbcp?=
 =?us-ascii?Q?VMTeQ9yhY8N9qpHWIHqEWXy7JmYjcs/KaAHbkUyOxOd9xUkcwmMb+e+1zRLp?=
 =?us-ascii?Q?2jH+HXPhrJ/ljp5qs4MMWGPETYsk0GWTLLJnbeyu5HkCDAR53vNgo3UhkvUF?=
 =?us-ascii?Q?dfueBmBJPz6Ibc8fdwfJWpvMUJpyhNboUbc2IrJdV4nA2tPNL1DMTVdappnr?=
 =?us-ascii?Q?H8YZXNZNM4W8wWSWkaDRt/R3nkfND3FVkTMF+1CT2bl8gOU1AGH2XyFEQTJ3?=
 =?us-ascii?Q?aur06NzZ5u14J7nH5KyGWV87h2z5MQ+8ziDM1fQQWkQAmhUTuj88L4B6CLbq?=
 =?us-ascii?Q?VBvFib9sZ5/mOvpCTB2ea89+4JcXqrWT07NbYoi5rZnLeLiTYVpoxPPD0g8R?=
 =?us-ascii?Q?AAFLBLOSCn4F3FxistEwran5wwRHd8aN4PfYy8JbyokejK5T5Mo8t3Asrj7I?=
 =?us-ascii?Q?Smc7PhwifVlcjvwRbsIlLkImomsLtvXzDXnKlAuZso5IUPudoKFGv9UBRAsg?=
 =?us-ascii?Q?4zi9/Q5CGos2Tb3QC8+0BWPAme0soT9FxYKkiN5VQCTfAlXRv0341zFsyhKM?=
 =?us-ascii?Q?HUqq84XmW7XXSW0VuMTpGAZ6RQGkBx8pJ3eYUzXgqyVy4WYCz8m9/7T+/LZp?=
 =?us-ascii?Q?rdjScTQJYvA8eZp/KBCu/+JX4kQCiZJB8zIF0CKmCyV2DCI/Esk9UcoWYdG0?=
 =?us-ascii?Q?fmaB/Fe2SKLE+w32/7qtTHhEdR82dK+f2B/GCCAE36sIvE1x0tq9raOWEi6n?=
 =?us-ascii?Q?y1uUlv9nrtlD0+hX7k+w2AX0xCpbkMXrprbhaB7E0SlNMWWM1Q0Cv/Q+tFnr?=
 =?us-ascii?Q?CYLkT7BdBOXiMFNl11ODTUMk34oyhE04HZizApbNqUgoafsQkjsI98oo/fpn?=
 =?us-ascii?Q?B/V2bOB5v34R/15OZI55qngp4Ft8Rad4quW2pqKFfakhx+L+K5J91sdOVPgf?=
 =?us-ascii?Q?L53UnkL16Yv1FhfQWRQU+mzEnK+RtjtvWKt+EijoLD2USwOE60K5QKqHSxi3?=
 =?us-ascii?Q?Ha+WgOZqRU3JT9h4kruHeAJIsni+azpaBa7bCUZMs5tna9WqPK0xNQPoQ4kG?=
 =?us-ascii?Q?3+0TIxx5Hf13niuNXBzlWyy9J3zd345UTnP0IATaCB66dnnK1v9OEBu0WVAs?=
 =?us-ascii?Q?/xmu4io7FllSoq2GVPzAYafpx31vjbtnCcHhi3S/Lwy5hFX8Lg9zu3FZFUSE?=
 =?us-ascii?Q?ZJCk6SRRDEdyh2pJ5UT2DBvckvp0av6znDTGjJHpp3/2zPAftwV/EIHdJF8X?=
 =?us-ascii?Q?a69Pe2ZBa6kBKnaVo9WUjlTUpm1FGwvkngvZmIb5zGGlicqBg2Z73FPHBwGG?=
 =?us-ascii?Q?spJD4Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	m/oCOBcoo6Vt3BLohvRkupBC7Y3y+0ZvkClAMaUnb+eMO8Ltc5Av41NJSp9Z+lKJdjfo2qrEMl/bHcx3xtPWDCkENcZMoQjGku5qsZvahVLHqao653osHsY5DMMWoRIT2UOg2omXLODVAtBdtwI86P2l9AzBs3q22WfIOm2mX//+/aIG3mZt0lPKEG6flkpPQmOuKWtwqJDmXHMO5+sOOY2gkUFKoWmd4PCZKDxJnuG/AchMoWLdNf03zdDbrLTwLk/6Cfxm6LMgA5R84ZfHHny5MwnRpCNztihhbLckmgxuTsHX1ytHooUcq9ziclr/ZYG2EaMjwky1szJi6Zwi8NbfRxGW3MyxuenaGeAj+h0bFd6CTt+AtvamT9GKp/Z+bhSueFU9psWySgu0faJf2xVLTikZMMIf64uSkMcWlP0I0alzVE7YIesDbYdjddqm
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:38.4758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c802257-a8da-45f1-8f07-08de72f3fd59
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8044
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71486-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,nvidia.com:mid,nvidia.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 57AAC1793D4
X-Rspamd-Action: no action

From: Ankit Agrawal <ankita@nvidia.com>

The EGM region is invisible to the host Linux kernel and it does not
manage the region. The EGM module manages the EGM memory and thus is
responsible to clear out the region before handing out to the VM.

Clear EGM region on EGM chardev open. To avoid CPU lockup logs,
zap the region in 1G chunks.

Suggested-by: Vikram Sethi <vsethi@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm.c | 43 ++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index 5786ebe374a5..de7771a4145d 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -15,6 +15,7 @@ static DEFINE_XARRAY(egm_chardevs);
 struct chardev {
 	struct device device;
 	struct cdev cdev;
+	atomic_t open_count;
 };
 
 static struct nvgrace_egm_dev *
@@ -30,6 +31,42 @@ static int nvgrace_egm_open(struct inode *inode, struct file *file)
 {
 	struct chardev *egm_chardev =
 		container_of(inode->i_cdev, struct chardev, cdev);
+	struct nvgrace_egm_dev *egm_dev =
+		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
+	void *memaddr;
+
+	if (atomic_cmpxchg(&egm_chardev->open_count, 0, 1) != 0)
+		return -EBUSY;
+
+	/*
+	 * nvgrace-egm module is responsible to manage the EGM memory as
+	 * the host kernel has no knowledge of it. Clear the region before
+	 * handing over to userspace.
+	 */
+	memaddr = memremap(egm_dev->egmphys, egm_dev->egmlength, MEMREMAP_WB);
+	if (!memaddr) {
+		atomic_dec(&egm_chardev->open_count);
+		return -ENOMEM;
+	}
+
+	/*
+	 * Clear in chunks of 1G to avoid CPU lockup logs.
+	 */
+	{
+		size_t remaining = egm_dev->egmlength;
+		u8 *chunk_addr = (u8 *)memaddr;
+		size_t chunk_size;
+
+		while (remaining > 0) {
+			chunk_size = min(remaining, SZ_1G);
+			memset(chunk_addr, 0, chunk_size);
+			cond_resched();
+			chunk_addr += chunk_size;
+			remaining -= chunk_size;
+		}
+	}
+
+	memunmap(memaddr);
 
 	file->private_data = egm_chardev;
 
@@ -38,8 +75,13 @@ static int nvgrace_egm_open(struct inode *inode, struct file *file)
 
 static int nvgrace_egm_release(struct inode *inode, struct file *file)
 {
+	struct chardev *egm_chardev =
+		container_of(inode->i_cdev, struct chardev, cdev);
+
 	file->private_data = NULL;
 
+	atomic_dec(&egm_chardev->open_count);
+
 	return 0;
 }
 
@@ -108,6 +150,7 @@ setup_egm_chardev(struct nvgrace_egm_dev *egm_dev)
 	egm_chardev->device.parent = &egm_dev->aux_dev.dev;
 	cdev_init(&egm_chardev->cdev, &file_ops);
 	egm_chardev->cdev.owner = THIS_MODULE;
+	atomic_set(&egm_chardev->open_count, 0);
 
 	ret = dev_set_name(&egm_chardev->device, "egm%lld", egm_dev->egmpxm);
 	if (ret)
-- 
2.34.1



Return-Path: <kvm+bounces-71483-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uLxiCv55nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71483-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:02:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A56D17944C
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:02:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0474730D67E5
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E8AD30F94B;
	Mon, 23 Feb 2026 15:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kI3cHlx5"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010026.outbound.protection.outlook.com [52.101.56.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3CF30AD1C;
	Mon, 23 Feb 2026 15:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862148; cv=fail; b=SpIa8z2OKuhdBi6Lz7P9UzvesoxEA4lAe9J6s1gMSeFu1Nxr3o2Y6/ttaer7R+jZlm/5Ym1eBW2Gt+xui5Z9HGpULaqzhY3iqE5bSDaadgvIsctUM6LJHKn2b0c06LwNdrnwzEOUtFmcm2BMZjnw9bodknsf3mm2FnHn1TlHgHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862148; c=relaxed/simple;
	bh=bOGbzPt8MfbN/aZ31VmNMTcjTO2DVU8Ic/EGhVEvRds=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bPFj6VbSF0eRuu5t0inU+TAIq7pOo8+tRO2JJKZ4z/x365cxAusAqqCWnAaOwpRq5vzlZ6/nFwBlrFEqHASAtarKuu4/PSIijzIq6bxrmIEDv3XC3895YF6HWfD1VqkhpNA4h+gF69of/S8t0LX/CKn+lwxtVK7GGrLtQFFOlPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kI3cHlx5; arc=fail smtp.client-ip=52.101.56.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XIdjSqQHdrVkfNVSQLY+ncWmLypdToLCxPzucT3eUL2MiHVNCZj7AUHxi0j4o+2HPSf9aozJQJiqlMzpFDmV4n+MFB8ORM7tYB88+17Bnoylb0ldFzmZq5Cclj2Gz4CYaLxb51i0aMw/scv1h51gV5AKm3XfiiFPUK9YJVqyYuoDboV+Exhx3p1TKN50tFNz7ZhVM2UqIRA9w8pmRqH+1bE0Erwr/70yj3N/70l0fiKJhZF00//ghyF1S98+8GAuiougolNP2dKs8RWB3Cc3wPoOe9MLRodYAIVCz0jTl+zcZbznMoEQa1Q4YrpQIeB3/42ZhhaMIc1TREKRI6iZ2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30IoT7g6Kq7hzEuadLEEVccSblTtGObHoN1VGPOrVmQ=;
 b=s2il03oFw9r2GKLnHKLCeAy7eTs6KA6gZcQyLMy+QZLsVrDPMOi8aKebiXCGolRoZWWSedMUqGc4JuBB3WjaToVlpluX0dXDgxptrlcnrNkF4B70i7pkVQF9mRG33pahNlHMHxOjiDSimQlxlZxXF5GKwoklfNywpmzbKcaZ1xT7kQhiWo82IyDT7rmGGBkKpmHa5kv2hgYJXEcOznxQSLbqYmDUWW/9q5u/4CbUVqv/ErhLkbXFSqXaJkTgI43HmQr3SmrBNyJwRVOtCGwEoh37SG8hzwjmacjD2vGqFLruSD0+abDjmNbs4HfdSULMcsgV4iUbrcn1Ot2DrmbgXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30IoT7g6Kq7hzEuadLEEVccSblTtGObHoN1VGPOrVmQ=;
 b=kI3cHlx5Y5fJuffDmM2mnb/wh4scnL9sVdSNq4NY2JnHocAUuslaUW0vLTuDrZhcK1yhNZj17bIhskaxRZMU4wjyMA4y+aJsMhQOE90h9l1JTobEfHOApfF80cB9Em9Nk8HaWKabgG8AVlBP0DG7BywOOezlnuYBRQnIMqfBcqglQg4RFz0pLOCjLna3Jmm3KW6YR+/Bh4tsqoOwUOW3zbFYQQ6JECcMItSbjs0sTM/cL7pbL6fTaWXWKmuIC98vtxryIZUxlxCfdzwsOTpvJ3KO31fihxNrM8wjuffA0PeYgkvbaai/r/qm5N+R6c+buPWIvpyf38c7s84FboqXJw==
Received: from DM6PR14CA0067.namprd14.prod.outlook.com (2603:10b6:5:18f::44)
 by IA0PR12MB8975.namprd12.prod.outlook.com (2603:10b6:208:48f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 15:55:38 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:5:18f:cafe::c0) by DM6PR14CA0067.outlook.office365.com
 (2603:10b6:5:18f::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 15:55:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 15:55:37 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 07:55:19 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
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
Subject: [PATCH RFC v2 09/15] vfio/nvgrace-egm: Add chardev ops for EGM management
Date: Mon, 23 Feb 2026 15:55:08 +0000
Message-ID: <20260223155514.152435-10-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|IA0PR12MB8975:EE_
X-MS-Office365-Filtering-Correlation-Id: 9de9ecab-c1da-418a-2343-08de72f3fccd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y9/SQLhRAHw/dXQ8geoIpsesfQw4sn8Xdmgx9JFLK2e0jCBHoTfSrOL6M+H/?=
 =?us-ascii?Q?Yvv9FEz9cyaizQft0BLpZG5O+axz8KmXj3XtYohkf0PPvAS0RHe+1XG/RQrm?=
 =?us-ascii?Q?blR0zrfKzT+TY5Jrx/qzR2kgDGf8QnuQmfBpQZJ1PGtmzoMQj98xniUmU2+J?=
 =?us-ascii?Q?SHn+0DnCaaCr8zhKrd4FVEI9eDfPKlQyZwY+5Yp3sOU40xE1VeHw+D2Qt0MC?=
 =?us-ascii?Q?jgbirYwJissk8e2l9PKfayKeRUG+y5rlQwjcSRM8MIuUe9ZhFxRQaxG+xV+L?=
 =?us-ascii?Q?tbon1kfWu6NA2I9QxIS9TBqSbfU9rWdPbvEOBniCBlz7shW2HSS5qqcGbqjt?=
 =?us-ascii?Q?eOEMnr7eFWD+FAZhZq93/wSEg560Wv8hBnImuw4QasUMvdTtsyeKWR+TkNVE?=
 =?us-ascii?Q?NrGAoYFtzVfdTppD0BUFxZY40V7uaHboZoCK46DHoZOG+rzAYD90FW9rkQ65?=
 =?us-ascii?Q?SXRz8a5oREhYeomXBc9cG3IqUOFNu+bP6vNYsRscivNAuXGLrRPZpHTB64Zc?=
 =?us-ascii?Q?2vUxAxJzH042b2an8bH9HwTmysNwzDyH7hpnvBTNoNUQD+wZf/uz5tPM5gn+?=
 =?us-ascii?Q?d6oquVIZPLFbcnrILfVNnon5Pt1dFPEKt9K079Zi7DN8qjWNpIl0QyjLMtD5?=
 =?us-ascii?Q?oascHpjk4EssAsMe+o9n5xH10oQ50n6fUo5R24ITdP0mcKsK/+LLW+hx8zLd?=
 =?us-ascii?Q?IctVYuc30n2zJDVceMo5QBCg4Eeg3ke5U/Vo6Pt4me9WUipa1n6vY3hTRdOx?=
 =?us-ascii?Q?OrBHSv9xXG1iBI4rJSc0DFZk7oQ0pH54U44eEs8X0McIbhXzv5vHsxFyPky8?=
 =?us-ascii?Q?IH7SYvh9N2MWoWhIdotSNhBej7OexANjTvlwdtFgMOplQudY155vKz/YNX0d?=
 =?us-ascii?Q?DFzKQYNmYuy8A3IcPx5iZh97aVzaJEHwurjc+smKbqFmn4+9poTD+1eMTuOD?=
 =?us-ascii?Q?sKTaZyBc1l4HWdzryjaoJM+cpquCj2pnSyHmUHhV2XaJ9snRn5nrSmnHk6Vw?=
 =?us-ascii?Q?txDD4QGKfaz/rBTzspB8qrt7GTq5FFtjM3oUKYkfxhJLHJhBbctCpLVIwXiB?=
 =?us-ascii?Q?IZePQeLieZaRVvyYwMrdJHo7+jLjZWu6LKWfhwcdCUGnBrF7FmVwGlnDlGaT?=
 =?us-ascii?Q?Q/pZwn7C2FdNa3luB4Qqd2h2DPqidapBRyqfe8QdRBWbwiOJgAkyCZHDJiWz?=
 =?us-ascii?Q?C/ITZrfyPIkngn1rEHSjs96UvfSifjOu1f3rSmot9IJTlXYDm8i/wXRgD6t7?=
 =?us-ascii?Q?tZsqY+3MRP3PM6x3KjVGQWTpYwG8n4Kcp7FTCWT0vm8zsaG6TzEqcdClbKWf?=
 =?us-ascii?Q?FhMGKp8MdoVfMUlmGltTznNmzjFwK0AgYp5CN/4IRy3HpnufdjX8awaxMbEs?=
 =?us-ascii?Q?CHTIkCx7Xau4QKeDTHpaF+rFgyggiNtTlkz2ORMxZFJhR67Icf3a9UR2EAIf?=
 =?us-ascii?Q?raXJVMrTFClPfv4ATApuHCyElhgVE8NO1nhHhQnXwnFBZ1k/gQvd4Ezolsun?=
 =?us-ascii?Q?5eXNjBqjR9BfnLgccWSy/NatbGBHh+DEr0f16wf33Lz5QoaQh7SVmnQB04PL?=
 =?us-ascii?Q?B+vLdtnM1BGy1LCnvhoKV1PSMFZUvrRt3fL2E0GsIoAWrEhENtb1VURXNLYV?=
 =?us-ascii?Q?PyZXVKJuT4IQ1sLDA/rYcc2rrmYHHZk9FxdgdRkRohIwONUw/YRpjQylp+Ib?=
 =?us-ascii?Q?E6HOyQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4Z30cAC4cu64saco+EtATyWQe08wB8GNjU5YZwlEfWz/Q7mYxgjAo4y/+RDEvrGsCRMB1sM62VeZVwNw30lgzAy7BEHI7S+cBxkXKXuMl8CkthbAkbq4oJUhDfAWi5it8FRc5dXaq5mv8sxGm80bAtkq6ju40NMdN3om1boLeK8+9tcbwacRlhJTKKhwrD5dzcIjbkUTwzmErcQ8rN1WAn20jrvTr2T5Tdp4LqTUvsDEtL1Rtx0S6bnAh+b/5dgcXvsgKemVy74rIPdwMaO8dQTrToNl8YUPSlzv5TQssnKpP00HwdgPw3kx5kVKiG+Mi9F8YqJGLqjRbNSD/nEaKmIFPsWGwCBZq8PnVRseZteQV0fMMdWNy1EGP7SARAiU0XjVOtux6Cxc8aOuA2DFfYbmVoCTbIk4e9Fh3zy0Wf1/bUBA1iL1+mMNXRL8QmtM
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:37.5815
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de9ecab-c1da-418a-2343-08de72f3fccd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8975
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
	TAGGED_FROM(0.00)[bounces-71483-lists,kvm=lfdr.de];
	RCVD_COUNT_SEVEN(0.00)[9];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	FROM_NO_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ankita@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,nvidia.com:mid,nvidia.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4A56D17944C
X-Rspamd-Action: no action

From: Ankit Agrawal <ankita@nvidia.com>

EGM module implements the mmap file_ops to manage the usermode app's
VMA mapping to the EGM region. The appropriate region is determined
from the minor number.

Note that the EGM memory region is invisible to the host kernel as it
is not present in the host EFI map. The host Linux MM thus cannot manage
the memory, even though it is accessible on the host SPA. The EGM module
thus use remap_pfn_range() to perform the VMA mapping to the EGM region.

Suggested-by: Aniket Agashe <aniketa@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm.c | 41 +++++++++++++++++++++++++++++-
 include/linux/nvgrace-egm.h        |  1 +
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index d7e4f61a241c..5786ebe374a5 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -17,19 +17,58 @@ struct chardev {
 	struct cdev cdev;
 };
 
+static struct nvgrace_egm_dev *
+egm_chardev_to_nvgrace_egm_dev(struct chardev *egm_chardev)
+{
+	struct auxiliary_device *aux_dev =
+		container_of(egm_chardev->device.parent, struct auxiliary_device, dev);
+
+	return container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
+}
+
 static int nvgrace_egm_open(struct inode *inode, struct file *file)
 {
+	struct chardev *egm_chardev =
+		container_of(inode->i_cdev, struct chardev, cdev);
+
+	file->private_data = egm_chardev;
+
 	return 0;
 }
 
 static int nvgrace_egm_release(struct inode *inode, struct file *file)
 {
+	file->private_data = NULL;
+
 	return 0;
 }
 
 static int nvgrace_egm_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	return 0;
+	struct chardev *egm_chardev = file->private_data;
+	struct nvgrace_egm_dev *egm_dev =
+		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
+	u64 req_len, pgoff, end;
+	unsigned long start_pfn;
+
+	pgoff = vma->vm_pgoff &
+		((1U << (EGM_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+
+	if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
+	    check_add_overflow(PHYS_PFN(egm_dev->egmphys), pgoff, &start_pfn) ||
+	    check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
+		return -EOVERFLOW;
+
+	if (end > egm_dev->egmlength)
+		return -EINVAL;
+
+	/*
+	 * EGM memory is invisible to the host kernel and is not managed
+	 * by it. Map the usermode VMA to the EGM region.
+	 */
+	return remap_pfn_range(vma, vma->vm_start,
+			       start_pfn, req_len,
+			       vma->vm_page_prot);
 }
 
 static const struct file_operations file_ops = {
diff --git a/include/linux/nvgrace-egm.h b/include/linux/nvgrace-egm.h
index a66906753267..b9956e7e5a0e 100644
--- a/include/linux/nvgrace-egm.h
+++ b/include/linux/nvgrace-egm.h
@@ -9,6 +9,7 @@
 #include <linux/auxiliary_bus.h>
 
 #define NVGRACE_EGM_DEV_NAME "egm"
+#define EGM_OFFSET_SHIFT   40
 
 struct gpu_node {
 	struct list_head list;
-- 
2.34.1



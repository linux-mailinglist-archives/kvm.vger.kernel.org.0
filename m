Return-Path: <kvm+bounces-71487-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qIqEFit6nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71487-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:02:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A7484179473
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:02:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9F56230F527C
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DD3F31283E;
	Mon, 23 Feb 2026 15:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lVasQ/b3"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012001.outbound.protection.outlook.com [40.107.209.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E945930BF4E;
	Mon, 23 Feb 2026 15:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862149; cv=fail; b=uv07MbN6NKUTqgDb7OzgFfAH70QuVgUokJZ8htyMxfFtlYxu2PD+BXGyaASL4KIZ+AqInZmbIOFmtGD3IBj9ioL0OGOv4v1g5ZAPZFFMHuyGB/9uZHcCSPaMhlGYeHiIoxImk7Zvbu6ROmHLqepq/T3Wr3okt5Ab3L2cQ8oZN4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862149; c=relaxed/simple;
	bh=0nAnMzpd4HZk6HLjn3GC6O2yU1yT9WOtR/w7lr7UGZU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AQI2RDRKwxTmqHTywGpMyTZcDVimKN6YPiXbuX1Y0rmewBWR/B7ICm/ID2C5A0m2JDljM/dpJWbS1FboGdNMpOzgtXH1UwfI6MCzLm4iQfWfXGI3FYOZ8nplQZQBbQyI5cojLLHVKAe8iqAT7Tl1cvvaYGspWpCZxecYMirl6uM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lVasQ/b3; arc=fail smtp.client-ip=40.107.209.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h1gSelVqFAuaqjpQF7L/k9m8QvwLX9jXoA9vIfKky8pPbTu56skw5I6Zo0tCilMANFsmaFk+XNQLviH6kz9hz1R/N6SRZWjSggSyZoGwBQ44sff6fg8GolZyGIWNGQl/1EuzvaQmcSDhMdAA3DVioPHri+oLocfspqKAGyXw1TTggSch54zu7CyiHVcCHTw1/PMZ7JzNjhc9UL3QbvA7mKonDVMbvtuuOdQ/nWqgsbvqkPNL2ZuUI7oiDv8E/zKsjTg7XqWrfiJkY7FXTmq+klw8QcDOyfiadecCWAj+zWUd7CuuEBOlMd0iHNcYZs1lZQP3UptJeiEsN8diNJlkWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+I25YG4LtbfsLnMnjEVrZbpE+juFFCg8XJlnCv4ZLVU=;
 b=lW+8Dh7jImjN0fTtZQaC101DWhq9MunJBOknlDVUQZnVl+8kQ6pO60ia6phIIHDmMeIdfE91Ls+YxbdnNZasedTk1xlHbVFYxMe3uapGwv3vYtiEEV6vvUHdxNOP10a9c/wj0cfk20Lpt5lnKI26UQVRQX4BatFTDqc/Bwhud3ws9E/ADZwZ2FWMPbUOvddSuXFWmrwY3/vzNyXJ4BKRgssuL1uYZCVygaD+FQT28iQzaljQybEr1UVBkA7YCEW3yQ8jSIdfoZgK64oGyMuxdGzMpFk/Gs0iDVuwOkQXsqhw0Rj8jD4mD/hE7OmV3TpJsFtUcMmv8VtjktvzUqUe7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+I25YG4LtbfsLnMnjEVrZbpE+juFFCg8XJlnCv4ZLVU=;
 b=lVasQ/b35qgEIJZIooEuQjIPuDC7B4KTooOehQ38mJklA1Dy08988YBsCVdF8cg0ZIciZx93iEmf3gPO1cw3TD0k//SKcwRhnCwLvrJ9ZKCNnV3RYrEVlDgV5TTRHg23aHpX4mJ5xTIL56tQO4P8QB1wNR6RidQdr2rmVJd9PfQyyjvtV1NDxVg1itJOR7sxX3jwbgltOFG1OGx2MiojoyVx1mcULdkdqF5PjwwOuNMK5a5m5N2NfP2qK2qORuy74HpMF7mQ3+Jdd6a2Dni7ac8UibQZMMsT+h6Hmrikbu/PrMrTguDIn5ZiMZK42UIoR3HLmkZ6uFScw4Ojx3aloQ==
Received: from CH2PR05CA0050.namprd05.prod.outlook.com (2603:10b6:610:38::27)
 by SJ0PR12MB5634.namprd12.prod.outlook.com (2603:10b6:a03:429::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.15; Mon, 23 Feb
 2026 15:55:38 +0000
Received: from CH2PEPF0000009D.namprd02.prod.outlook.com
 (2603:10b6:610:38:cafe::8f) by CH2PR05CA0050.outlook.office365.com
 (2603:10b6:610:38::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 15:55:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH2PEPF0000009D.mail.protection.outlook.com (10.167.244.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 15:55:37 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 07:55:18 -0800
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
Subject: [PATCH RFC v2 08/15] vfio/nvgrace-egm: Expose EGM region as char device
Date: Mon, 23 Feb 2026 15:55:07 +0000
Message-ID: <20260223155514.152435-9-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009D:EE_|SJ0PR12MB5634:EE_
X-MS-Office365-Filtering-Correlation-Id: 3845b4f7-7aa1-448c-f2df-08de72f3fcdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vAVEM4KCrUw/Ab7PQNmDyA2J3SsuebhkvVaIN+crqNefOVuBQ2GR4Gw/iJlG?=
 =?us-ascii?Q?Gr/Q/nd7GHGuM8blEnQYCrPFscOjkU86mvuHxdQt79WAynJYg/El6fCL6rka?=
 =?us-ascii?Q?H04bUn0zDOIww7aTePfk//vbtVwLXmYfV+ue2uMV39QUmTDYJpl59J3Sde0g?=
 =?us-ascii?Q?+4y1dWiQerpbWjm4IUVqlAYsdkJ/5I82tVP3EQje6Bv8osAG6DSuCvNxsweU?=
 =?us-ascii?Q?1IrjZi30ER3z3hp3IVoMFMxsgi0O5CIbUZt0Nq/iSubzTvmgjVlZE3CbVqkj?=
 =?us-ascii?Q?hI1/wvjwca3s/Gz97+o0TlTxjuw7i/HjpvEmpwWbH07h8sZJuHFNSd3zE0/5?=
 =?us-ascii?Q?h7TafMssIz9o4w00/nW9Dx+SUUGImxAPirI4dvRln566P4mDzQsYO7sAsgvu?=
 =?us-ascii?Q?0oZ5CcJ7/ZgMOAM0PEBQL31l/5TdQl/khIruoVfLQoJROd+G24lwcuVahW91?=
 =?us-ascii?Q?keUmuH1m3d2GFLDZAD1FTFtEsx/kKvsxOL8vQX/6BHSPlc83iSgU2RtbpeFk?=
 =?us-ascii?Q?wqnVDrGyijQaYSFeLBFPOcBOa4KT7ePjLiAinOsrnvCgLbkTEXSszcF/TjpW?=
 =?us-ascii?Q?Xf4VzX5Qp4QKRWedRJhRN1s3dDdukFUP9ZKrwSlQpJWy6aa1r+I7R0vlVC0s?=
 =?us-ascii?Q?iJinVFI+YJ1ofabxlGu9bpqaDE9xFR+qYAT3GI6WA38E28d+HYOHGw/D72zr?=
 =?us-ascii?Q?bpKF6kKrSwtDRe7W3X850Xz3gY9gx23/z9HhccAFSZ1289TUJflBM/PKU3E2?=
 =?us-ascii?Q?BcYx2Z2JTqwTnIrPRTX201uhHH81OHJ0KgLtN85hlwhHnxkrRxsadJf/6j0x?=
 =?us-ascii?Q?3Nv0U8QvJVNRY2J8/Y9vhLqHiCL6HjcxfZxFKfqHTaECeuyI1dU3CYJBMDWJ?=
 =?us-ascii?Q?hbHu7oUztgwXbhX+SWCbOd2n9stIPQAjnKtnmdCSYtZLyHyV79rt0ZqnGMmr?=
 =?us-ascii?Q?Ez2szK1FyJN7/QHR474wFdjc5mG9R+kBbuF2bQcXIzUdzRHAiC15sGypztMu?=
 =?us-ascii?Q?iEA2A46nJQXioUlLXF0DwZok9NU2RVwxuZJlkRwOIpIpoeHc3UxwM2RPE37m?=
 =?us-ascii?Q?2c7mM6q4EZhwqLUUHl9+hDQv8aed6Ut66Z+8h/ef9ERQpIATdP9eg9WVy2ZE?=
 =?us-ascii?Q?re0XFv68RrMVpexcwXHZW9MZRfB68oVHoLNxwEI4ByV0AW5fU8UF1o+ZNzFU?=
 =?us-ascii?Q?SE54EEgjXF6fDWBRK4fOkcYGBjCLekKrANQCa0wU24EbIT+uXBHZm1wOJP6P?=
 =?us-ascii?Q?zsN8CEDnSkZTg102RfiktEzy2H3H3zJxPMJbThhGRPoJohbIp+h98chqt6GF?=
 =?us-ascii?Q?JwPBgHK8BBRth/e92Wtr4jZYpX+DOmwEHRveKwmrRUYKha00Cbx/pBM5lceh?=
 =?us-ascii?Q?ingrVnIXAMNcCKPF0s+KaZc5053GwLosNxE41kdLIeE0ZqbcQ5Y+QDTl/ZQ+?=
 =?us-ascii?Q?6770pgUFLmY0Ks9VoQ5PMT5Vs6VszlwF68JoYeNI9X33AZh8FX4TeEXyKwbT?=
 =?us-ascii?Q?R8iu3N1GGp9SaSgQ15fzk6axFvBajPkkMod7aaZHCHseG28oVa+vPUJWSBX0?=
 =?us-ascii?Q?BwP9F+fhYBPmyAf68623MHHc/GWT0JRqIFPl64oq1njd8eWsATjjMA/a1oQN?=
 =?us-ascii?Q?W1O6Bm61q1u4uhTg6193FTheIL8Mw8SrwQaoBKE01qcCgMzdAX5D8jiQGwNm?=
 =?us-ascii?Q?LOVLKQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qNq7v5EjV/iElsuPUOpBlI2NvtGGGM0SvPDF1nOe+ZvedZRFOqOxu10FOTBd4UvFrPXje8nWufT9bc32HrcCTVnUJbpHWtXi/Q3LFnZSk2Kiksb0p3qwXk09SXZ9YalLe1rD7JzOfC2l3yAXFsQm9HESmXRGekjTouOl9PXN3qaYvoYkxrleQEyE4R5L8EDFZCa5FgiIzCcwO0C4mHZ68LeQEewb99QqCLvKormNFcMg83YDfXm8Mu8NyjivY2hfvZFI2lnwfXQDZsRr3PIEsK438yTX31qdhckHZxL4Ndp0J/nNfzNoRU4+uyB53CwxbyC7xaKG7wt9OOMQzwssyBKhFUiE6PTV4+O2Qm9APUoc9iTeKmrJf/MMZmO7jIudaMOndioB/XVvGJBlCLS3HKhgNkcRkD6AQwnnWtm5Ey5Bhp2hGElME5VRQUzvh8//
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:37.6683
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3845b4f7-7aa1-448c-f2df-08de72f3fcdc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5634
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71487-lists,kvm=lfdr.de];
	ASN_FAIL(0.00)[1.2.3.5.c.f.2.1.0.0.0.0.0.0.0.0.c.6.3.0.1.0.0.e.4.0.c.3.0.0.6.2.asn6.rspamd.com:query timed out];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[9];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ankita@nvidia.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,Nvidia.com:dkim,nvidia.com:mid,nvidia.com:email]
X-Rspamd-Queue-Id: A7484179473
X-Rspamd-Action: no action

From: Ankit Agrawal <ankita@nvidia.com>

The EGM module expose the various EGM regions as a char device. A
usermode app such as Qemu may mmap to the region and use as VM sysmem.
Each EGM region is represented with a unique char device /dev/egmX
bearing a distinct minor number.

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
 drivers/vfio/pci/nvgrace-gpu/egm.c | 99 ++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index 6fd6302a004a..d7e4f61a241c 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -10,15 +10,114 @@
 
 static dev_t dev;
 static struct class *class;
+static DEFINE_XARRAY(egm_chardevs);
+
+struct chardev {
+	struct device device;
+	struct cdev cdev;
+};
+
+static int nvgrace_egm_open(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static int nvgrace_egm_release(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static int nvgrace_egm_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	return 0;
+}
+
+static const struct file_operations file_ops = {
+	.owner = THIS_MODULE,
+	.open = nvgrace_egm_open,
+	.release = nvgrace_egm_release,
+	.mmap = nvgrace_egm_mmap,
+};
+
+static void egm_chardev_release(struct device *dev)
+{
+	struct chardev *egm_chardev = container_of(dev, struct chardev, device);
+
+	kfree(egm_chardev);
+}
+
+static struct chardev *
+setup_egm_chardev(struct nvgrace_egm_dev *egm_dev)
+{
+	struct chardev *egm_chardev;
+	int ret;
+
+	egm_chardev = kzalloc(sizeof(*egm_chardev), GFP_KERNEL);
+	if (!egm_chardev)
+		goto create_err;
+
+	device_initialize(&egm_chardev->device);
+
+	/*
+	 * Use the proximity domain number as the device minor
+	 * number. So the EGM corresponding to node X would be
+	 * /dev/egmX.
+	 */
+	egm_chardev->device.devt = MKDEV(MAJOR(dev), egm_dev->egmpxm);
+	egm_chardev->device.class = class;
+	egm_chardev->device.release = egm_chardev_release;
+	egm_chardev->device.parent = &egm_dev->aux_dev.dev;
+	cdev_init(&egm_chardev->cdev, &file_ops);
+	egm_chardev->cdev.owner = THIS_MODULE;
+
+	ret = dev_set_name(&egm_chardev->device, "egm%lld", egm_dev->egmpxm);
+	if (ret)
+		goto error_exit;
+
+	ret = cdev_device_add(&egm_chardev->cdev, &egm_chardev->device);
+	if (ret)
+		goto error_exit;
+
+	return egm_chardev;
+
+error_exit:
+	put_device(&egm_chardev->device);
+create_err:
+	return NULL;
+}
+
+static void del_egm_chardev(struct chardev *egm_chardev)
+{
+	cdev_device_del(&egm_chardev->cdev, &egm_chardev->device);
+	put_device(&egm_chardev->device);
+}
 
 static int egm_driver_probe(struct auxiliary_device *aux_dev,
 			    const struct auxiliary_device_id *id)
 {
+	struct nvgrace_egm_dev *egm_dev =
+		container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
+	struct chardev *egm_chardev;
+
+	egm_chardev = setup_egm_chardev(egm_dev);
+	if (!egm_chardev)
+		return -EINVAL;
+
+	xa_store(&egm_chardevs, egm_dev->egmpxm, egm_chardev, GFP_KERNEL);
+
 	return 0;
 }
 
 static void egm_driver_remove(struct auxiliary_device *aux_dev)
 {
+	struct nvgrace_egm_dev *egm_dev =
+		container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
+	struct chardev *egm_chardev = xa_erase(&egm_chardevs, egm_dev->egmpxm);
+
+	if (!egm_chardev)
+		return;
+
+	del_egm_chardev(egm_chardev);
 }
 
 static const struct auxiliary_device_id egm_id_table[] = {
-- 
2.34.1



Return-Path: <kvm+bounces-71594-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ACwPH7dgnWkoPQQAu9opvQ
	(envelope-from <kvm+bounces-71594-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:26:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AF1E183A0E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:26:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 771F2317727A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F222364EBB;
	Tue, 24 Feb 2026 08:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lu+lIhry"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013014.outbound.protection.outlook.com [40.93.201.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02319366803
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 08:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771921323; cv=fail; b=crb6qM97RTLn1ZJWavCsPBf7MG3ajuRdbMaOScM7W28ifxa+RvcPGz8rTPuXJTUAYbY3cCNe0QmfOVxexuV18vRqUpjbsSyWlqnsPYhUy3dIfQ1AAK3Y3Dws2xdEWyMdW9xtLOd9rwCZkDTQXSl9f2K5677nxJoCurUIbbwx1tA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771921323; c=relaxed/simple;
	bh=LXz4gd4KpWTrSUL9w4gooFEdowRvESkQMlUQvmcD1V4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OdXqcBk7SKdtfPUUSPGAAX4sTVVH/h8FQmoHKvL7pQ1NbH/MElzyh2aQGvVt8uC+NM0bCDVoQsxDOrBG/cuS/kOAbu4ebHvsTuKawfWiMU4c84Gfa2wjtByQnVC5jWnlTVw4wrxuLm/9iOtWUZcumFS6XAyfGHhzRR9NODX8ZTs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lu+lIhry; arc=fail smtp.client-ip=40.93.201.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qWOfEOMKaZbliInOqzwY7oihpZNqY3cUwkdx83Uw8moKrJlN4oZ2LHsJXRc79VTSoYScuYqTa1xvfME4X8tQC5LNriSVjwZGRzUcBKS2Ss0Ch/kYeX3FlH3ILZrao8gsJnkwMIhF2N/s+CGifPSuUzs+xutWSa52LJv71h/sTrpqvwagFyfvTHqfJzest+1LSkGviL46lTHX//MYTSVfery6puV3w5/VTtC/gyi8/IpXnT/tKNLKYpvpWnPRBMimOqFxHpfxFr6bHpB1EsiRUGYegARaemU4zaW0IWmSXQLA7c3C3QiDsSd8dub2j26mU0Pwf4l/kPdvKVH1o/Okww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WqLdaXCKxAgOXJhg5zrvJ9Ssz6mFV44KAfp5cpRJILc=;
 b=LXm9zwQuTtYVQx78WVUDLElhuuH+mSwQRxAm3XagFrBYN5DC4UzIiGpW/u7s8gUGKlOjHFX/MJpV0SYmlpsSslofPOMLay5TVmS/3R0BhJ+26RWGfIXeygsoDpcMv4yCGvVkdPhCOhWzdwYYTcCPIUSECTSpGkxCtS0qfCPpTpu3ln0W7mnWa+LkDzy7L6dbpqlczk6YlI5fgbAbeSO/HXF0kz+NdYsG23U8o+C/z+WasN3A/v7RO3tSjbgl9RODEGdMCE+o79xmBnYVDTlvFiEsYopZWnfbD/ayaI6P2XL7RX8z7/kkx7Lxax1zxZ/dVp7UstlRqzEdnC4NySnm+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqLdaXCKxAgOXJhg5zrvJ9Ssz6mFV44KAfp5cpRJILc=;
 b=lu+lIhryRuq0BiAiPYVfDaTIp6hNUfl1rJscEHh6I2OhxlK7msiTHHNtCJXYB6e5X745a0k7cj7CzedfCJcEkpifv2GbzhrNufnExDMwJfhK4/OckWvLnHIW/cONIuALrEKpgqvqHlPS1sPWqued72NvNzTFE00HioRBl6R/2JBZf/qVucuomopU3paSNPP2ySDabSXcziFqtaoLjIlmTUpx2OEgvU7Y9Zk7QXUGivFya9ct41X3lzNrj292yxLV0qbluAn9xyBNrYzfNTjJOAd2ntb51CFzTc2ZGuxYumUYSX2R3VR4XnmpZrTZefK4hcZlydlGs2HkgYXnVxYbCQ==
Received: from SJ0PR13CA0120.namprd13.prod.outlook.com (2603:10b6:a03:2c5::35)
 by SJ2PR12MB7846.namprd12.prod.outlook.com (2603:10b6:a03:4c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 08:21:54 +0000
Received: from CO1PEPF000075F0.namprd03.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::95) by SJ0PR13CA0120.outlook.office365.com
 (2603:10b6:a03:2c5::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Tue,
 24 Feb 2026 08:21:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000075F0.mail.protection.outlook.com (10.167.249.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 24 Feb 2026 08:21:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Feb
 2026 00:21:36 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Feb
 2026 00:21:36 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Tue, 24
 Feb 2026 00:21:33 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>, <avihaih@nvidia.com>, <liulongfang@huawei.com>,
	<giovanni.cabiddu@intel.com>, <kwankhede@nvidia.com>
Subject: [PATCH vfio 3/6] vfio: Adapt drivers to use the core helper vfio_check_precopy_ioctl
Date: Tue, 24 Feb 2026 10:20:16 +0200
Message-ID: <20260224082019.25772-4-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F0:EE_|SJ2PR12MB7846:EE_
X-MS-Office365-Filtering-Correlation-Id: 279ff03a-319f-41e3-41b8-08de737dc4da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RjV8dHnGEMaSC4vOE+OGDqR14ysQ0VVngGmdgnXNcaMtusg0yZz2qXXaAUr+?=
 =?us-ascii?Q?97F/aoF1pL4zK6kgUvoDvFDPSIsphwhxIN8e/x2ZBhMf7EV9K17ZzJcmpcB0?=
 =?us-ascii?Q?IRi/Zc3OG+xJjZPArGPMvZrErQMhAHkZIMj5Yw5t02tpmI2cvxFZKUEjJCQo?=
 =?us-ascii?Q?xeRTUFf5Djdx5Nkwmc1FJxZShaBbrONlIy8yfeGFmydvsLGXYRYdt8MmTNll?=
 =?us-ascii?Q?8vXGYbwtekKpTZWRyELCsjBOL4J52D4Y9qVcVE1UlMtWcmUTweR4KfsRG30X?=
 =?us-ascii?Q?QukrmyVezDoeuQg0c2PQnrSOIwN0PcuE0O+CDqs6wiiUpTYkWiA7RRdiFeS4?=
 =?us-ascii?Q?TYQMmfiXnx8TPgsNzA7OppBOAkbh2ipu2EMbmjZXmim8ihoHAnH+P7VpGE59?=
 =?us-ascii?Q?qWRuyNU5N+5kZQ3czFnSSAVQFgJSgbikGJK6ncgfUOCdiGoDc3efdUZSDyKg?=
 =?us-ascii?Q?4aDtvvW7OQ/JblG9npTZg6kx/nXmdUTKus+UZ9K2tqkJYWqrAcfHOrjWjGPM?=
 =?us-ascii?Q?J00mJ0FFyyVfbNMFjn8XCzO5msAXsAThG8AjiP6gay/Sa5iRWswEUEGMBqhH?=
 =?us-ascii?Q?iWaBFeMOo9I8q1LksVC85XICNz7qpkYO8XRE4TxP1QPJDR4324s7PQ873si0?=
 =?us-ascii?Q?cgYwgiJvIvE+zvjqGQvr8YKJ9cXriVrS0bOix4j/cZNUUygwy7x4PY5HHxPe?=
 =?us-ascii?Q?7ut3AQtCq6YpPzGBsidT2rHEwntPOEI8RuOxmizJxwI+sc9LzRD8fEitExmi?=
 =?us-ascii?Q?gBy9KwmkDkb7wxH33M1Xz6ar9mFlRrfErIf2csvYPqwUiWISoRp8AxKdrmtG?=
 =?us-ascii?Q?zPkcpqFAynfs4sJMObpK1ufTExDYJ8pvcXxkW2+QAxQiGFyPcwCYP0JE7Z1G?=
 =?us-ascii?Q?WKUsHC1zS0lmOOC7fqxpl4fsMea4BQzSHa3xMLeKhSfhhX6ERotBT9AZ2pQh?=
 =?us-ascii?Q?lQRgwqJFaK4LTc/8LRKhLhwRGD+/zf1JkPyfMwwUgsMKqqhNlfvcZy3oILMR?=
 =?us-ascii?Q?d/G8iZUjYdqALc2ePGtG3FsPsGk1wfv4Ypm4h5Jf58TvhEOuCJIDbQHMRXmj?=
 =?us-ascii?Q?dv6aEnhVDal+sRwlCQ/ly0/ZvoXCPAiuiAKrw14yuIjkMgF3AwVKKmgj+bl5?=
 =?us-ascii?Q?5dKQReUxD9tTdtOcbt5YiW190xYIluIH6hbshaafvWlKnBtJfTFs3BoqhCeU?=
 =?us-ascii?Q?EBvTGMybwxjz7UVAd417VKfMPy85AXeYnMwt4UebnADbcmMKY0f3hJLLlTno?=
 =?us-ascii?Q?BYvBxvdohh3EItc7Vsd47qmRYS27h04E3o93iJtgJ62ondXXPDkFZsc4JehP?=
 =?us-ascii?Q?F9F9dyIMtvAowaEmFltddaRL93t6FeBS5GkkcTJQ67SuI3lrVTJy10T1aej/?=
 =?us-ascii?Q?5YVD2es6eBdu+601S9P7CCpAo/UtDJiQcfz1pj9XqQooqmGbM3eUj4yvj07k?=
 =?us-ascii?Q?e8msf0Kh/HWeHMzaIEPCmteEvqHKrOQ5ssahW+29UR9ns7hIsBVJUdx26/fR?=
 =?us-ascii?Q?Mumv3YSGJPoH7AbxJXGYka6PhEfrntjoPTMlTvhRwX77moT/TSN8HoH0A8ha?=
 =?us-ascii?Q?Sf/GJB2xsWNgUjBxOR4z8eB9T1eEyvQxOgX9dMwJfVK5o63BUB4rfUM7fOli?=
 =?us-ascii?Q?jzv9QJLUTtYquT1KB3i1bwwhPd/dJapaC5A9xUe6QwPKFjplF/fSj62V1QLO?=
 =?us-ascii?Q?n8eF2g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vDp4mRP6gYG/L5xfA7oAAe2E3zUfbNd+JWONjvvucFUQoaPIyoAfwbkWM4Msn1whDONQwQdvp2GhWkBNw2KZLw2P7wy2C6st9/z+4jcbQG4YjWZ/+XmS/mEG5x+zFpNPU2rbT08OGKx8nb7gRLGaGxlU4EbJNwV6dn4hRiEzlvNGXS+rOwfrD5ZTVd7rPnx5dguqO4ACvSCNdTdHlDYiSBazQeuPCbW9n+p70rmK/uCpzwGHFGyzZp+7X/H7rzuwcOSvH7te94uU50gBiciC7fYpZDX3Ph++Vq4AhsB/mQLrYxDREBcZD9sehFKm0T2VBoGDhWet7ucH2wbycO96Px+4y755JvmBhKehfzUtczdo27O5idXYSvIOc/wSkIx1EMeYN48EFoqEvF1XhFYJKk2Xs3m/KZt2ajIde9OcAuSBNKOovrjaFWLeoMwYAC9W
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 08:21:54.2483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 279ff03a-319f-41e3-41b8-08de737dc4da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7846
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71594-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yishaih@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:mid,nvidia.com:email,Nvidia.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 1AF1E183A0E
X-Rspamd-Action: no action

Introduce a core helper function for VFIO_MIG_GET_PRECOPY_INFO and adapt
all drivers to use it.

It centralizes the common code and ensures that output flags are cleared
on entry, in case user opts in to VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2.
This preventing any unintended echoing of userspace data back to
userspace.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 17 +++-----
 drivers/vfio/pci/mlx5/main.c                  | 18 +++------
 drivers/vfio/pci/qat/main.c                   | 17 +++-----
 drivers/vfio/pci/virtio/migrate.c             | 17 +++-----
 include/linux/vfio.h                          | 39 +++++++++++++++++++
 samples/vfio-mdev/mtty.c                      | 16 +++-----
 6 files changed, 68 insertions(+), 56 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 1d367cff7dcf..bb121f635b9f 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -857,18 +857,12 @@ static long hisi_acc_vf_precopy_ioctl(struct file *filp,
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = migf->hisi_acc_vdev;
 	loff_t *pos = &filp->f_pos;
 	struct vfio_precopy_info info;
-	unsigned long minsz;
 	int ret;
 
-	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
-		return -ENOTTY;
-
-	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
-
-	if (copy_from_user(&info, (void __user *)arg, minsz))
-		return -EFAULT;
-	if (info.argsz < minsz)
-		return -EINVAL;
+	ret = vfio_check_precopy_ioctl(&hisi_acc_vdev->core_device.vdev, cmd,
+				       arg, &info);
+	if (ret)
+		return ret;
 
 	mutex_lock(&hisi_acc_vdev->state_mutex);
 	if (hisi_acc_vdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY) {
@@ -893,7 +887,8 @@ static long hisi_acc_vf_precopy_ioctl(struct file *filp,
 	mutex_unlock(&migf->lock);
 	mutex_unlock(&hisi_acc_vdev->state_mutex);
 
-	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
+	return copy_to_user((void __user *)arg, &info,
+		offsetofend(struct vfio_precopy_info, dirty_bytes)) ? -EFAULT : 0;
 out:
 	mutex_unlock(&migf->lock);
 	mutex_unlock(&hisi_acc_vdev->state_mutex);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index dbba6173894b..fb541c17c712 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -463,21 +463,14 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 	struct mlx5_vhca_data_buffer *buf;
 	struct vfio_precopy_info info = {};
 	loff_t *pos = &filp->f_pos;
-	unsigned long minsz;
 	size_t inc_length = 0;
 	bool end_of_data = false;
 	int ret;
 
-	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
-		return -ENOTTY;
-
-	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
-
-	if (copy_from_user(&info, (void __user *)arg, minsz))
-		return -EFAULT;
-
-	if (info.argsz < minsz)
-		return -EINVAL;
+	ret = vfio_check_precopy_ioctl(&mvdev->core_device.vdev, cmd, arg,
+				       &info);
+	if (ret)
+		return ret;
 
 	mutex_lock(&mvdev->state_mutex);
 	if (mvdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY &&
@@ -545,7 +538,8 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 
 done:
 	mlx5vf_state_mutex_unlock(mvdev);
-	if (copy_to_user((void __user *)arg, &info, minsz))
+	if (copy_to_user((void __user *)arg, &info,
+			 offsetofend(struct vfio_precopy_info, dirty_bytes)))
 		return -EFAULT;
 	return 0;
 
diff --git a/drivers/vfio/pci/qat/main.c b/drivers/vfio/pci/qat/main.c
index b982d4ae666c..b3a4b7a55696 100644
--- a/drivers/vfio/pci/qat/main.c
+++ b/drivers/vfio/pci/qat/main.c
@@ -121,18 +121,12 @@ static long qat_vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 	struct qat_mig_dev *mig_dev = qat_vdev->mdev;
 	struct vfio_precopy_info info;
 	loff_t *pos = &filp->f_pos;
-	unsigned long minsz;
 	int ret = 0;
 
-	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
-		return -ENOTTY;
-
-	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
-
-	if (copy_from_user(&info, (void __user *)arg, minsz))
-		return -EFAULT;
-	if (info.argsz < minsz)
-		return -EINVAL;
+	ret = vfio_check_precopy_ioctl(&qat_vdev->core_device.vdev, cmd, arg,
+				       &info);
+	if (ret)
+		return ret;
 
 	mutex_lock(&qat_vdev->state_mutex);
 	if (qat_vdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY &&
@@ -160,7 +154,8 @@ static long qat_vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 	mutex_unlock(&qat_vdev->state_mutex);
 	if (ret)
 		return ret;
-	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
+	return copy_to_user((void __user *)arg, &info,
+		offsetofend(struct vfio_precopy_info, dirty_bytes)) ? -EFAULT : 0;
 }
 
 static ssize_t qat_vf_save_read(struct file *filp, char __user *buf,
diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
index 35fa2d6ed611..7e11834ad512 100644
--- a/drivers/vfio/pci/virtio/migrate.c
+++ b/drivers/vfio/pci/virtio/migrate.c
@@ -443,19 +443,13 @@ static long virtiovf_precopy_ioctl(struct file *filp, unsigned int cmd,
 	struct vfio_precopy_info info = {};
 	loff_t *pos = &filp->f_pos;
 	bool end_of_data = false;
-	unsigned long minsz;
 	u32 ctx_size = 0;
 	int ret;
 
-	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
-		return -ENOTTY;
-
-	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
-	if (copy_from_user(&info, (void __user *)arg, minsz))
-		return -EFAULT;
-
-	if (info.argsz < minsz)
-		return -EINVAL;
+	ret = vfio_check_precopy_ioctl(&virtvdev->core_device.vdev, cmd, arg,
+				       &info);
+	if (ret)
+		return ret;
 
 	mutex_lock(&virtvdev->state_mutex);
 	if (virtvdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY &&
@@ -514,7 +508,8 @@ static long virtiovf_precopy_ioctl(struct file *filp, unsigned int cmd,
 
 done:
 	virtiovf_state_mutex_unlock(virtvdev);
-	if (copy_to_user((void __user *)arg, &info, minsz))
+	if (copy_to_user((void __user *)arg, &info,
+			 offsetofend(struct vfio_precopy_info, dirty_bytes)))
 		return -EFAULT;
 	return 0;
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 3ff21374aeee..cd71261b6d01 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -16,6 +16,7 @@
 #include <linux/cdev.h>
 #include <uapi/linux/vfio.h>
 #include <linux/iova_bitmap.h>
+#include <linux/uaccess.h>
 
 struct kvm;
 struct iommufd_ctx;
@@ -285,6 +286,44 @@ static inline int vfio_check_feature(u32 flags, size_t argsz, u32 supported_ops,
 	return 1;
 }
 
+/**
+ * vfio_check_precopy_ioctl - Validate user input for the VFIO_MIG_GET_PRECOPY_INFO ioctl
+ * @vdev: The vfio device
+ * @cmd: Cmd from the ioctl
+ * @arg: Arg from the ioctl
+ * @info: Driver pointer to hold the userspace input to the ioctl
+ *
+ * For use in a driver's get_precopy_info. Checks that the inputs to the
+ * VFIO_MIG_GET_PRECOPY_INFO ioctl are correct.
+
+ * Returns 0 on success, otherwise errno.
+ */
+
+static inline int
+vfio_check_precopy_ioctl(struct vfio_device *vdev, unsigned int cmd,
+			 unsigned long arg, struct vfio_precopy_info *info)
+{
+	unsigned long minsz;
+
+	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
+		return -ENOTTY;
+
+	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
+
+	if (copy_from_user(info, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (info->argsz < minsz)
+		return -EINVAL;
+
+	/* keep v1 behaviour as is for compatibility reasons */
+	if (vdev->precopy_info_flags_fix)
+		/* flags are output, set its initial value to 0 */
+		info->flags = 0;
+
+	return 0;
+}
+
 struct vfio_device *_vfio_alloc_device(size_t size, struct device *dev,
 				       const struct vfio_device_ops *ops);
 #define vfio_alloc_device(dev_struct, member, dev, ops)				\
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index bd92c38379b8..c1070af69544 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -837,18 +837,11 @@ static long mtty_precopy_ioctl(struct file *filp, unsigned int cmd,
 	struct mdev_state *mdev_state = migf->mdev_state;
 	loff_t *pos = &filp->f_pos;
 	struct vfio_precopy_info info = {};
-	unsigned long minsz;
 	int ret;
 
-	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
-		return -ENOTTY;
-
-	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
-
-	if (copy_from_user(&info, (void __user *)arg, minsz))
-		return -EFAULT;
-	if (info.argsz < minsz)
-		return -EINVAL;
+	ret = vfio_check_precopy_ioctl(&mdev_state->vdev, cmd, arg, &info);
+	if (ret)
+		return ret;
 
 	mutex_lock(&mdev_state->state_mutex);
 	if (mdev_state->state != VFIO_DEVICE_STATE_PRE_COPY &&
@@ -875,7 +868,8 @@ static long mtty_precopy_ioctl(struct file *filp, unsigned int cmd,
 	info.initial_bytes = migf->filled_size - *pos;
 	mutex_unlock(&migf->lock);
 
-	ret = copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
+	ret = copy_to_user((void __user *)arg, &info,
+		offsetofend(struct vfio_precopy_info, dirty_bytes)) ? -EFAULT : 0;
 unlock:
 	mtty_state_mutex_unlock(mdev_state);
 	return ret;
-- 
2.18.1



Return-Path: <kvm+bounces-71489-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iJ2CJdB4nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71489-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:57:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C2DFF1792CF
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:57:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BB6A9303AD8C
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9936313E14;
	Mon, 23 Feb 2026 15:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JE20e0au"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012051.outbound.protection.outlook.com [52.101.53.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0694130DEA5;
	Mon, 23 Feb 2026 15:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862150; cv=fail; b=te3R0eTrzZwiZl2hsOZbTWKCgiW8WxqTa2LpxgiWNLZs/YEEM05gUOnlqz683WShenbNczFuxwJsZL6fPSb6rjoeWbgo0G0WrJEbYWawAoJ5DaXrDhWYGF2FXgD/OBV0P8oyFogBG42xvPWB6Sd9T/byhciE1/tCeeISRp2SC2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862150; c=relaxed/simple;
	bh=clOsIYpjBZFOCHZhqZ7UzYD0rE0bHaXlQftHPfx91uQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gefP20I+iSix1eY2LNEH0jaZkbdA2zvro+v2a9CLYD4WnrZudPyOzeVImLtZ495JQVJuEZGG2MogNdOdJBIWvof6U5sRqVNzZ0hZAgTuy2UR97z+2BgMf9DubNPglvlhxHN0b6l/rfmspd2kg72d96XlO+g2ZWlwkcleUxKV9As=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JE20e0au; arc=fail smtp.client-ip=52.101.53.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ox3r/bqZNpbFoDZ0gOI7sjFxT8scbG54Zx3kRTIdNcHZdO27X8BUs9dj0p2T3TX+vpchMls/sAVeRfrYuzahfhvHFOBZ4zzBFqcTgFTZLhRXfhr2S6NaC8hBxTAvq79bKZC897JdsTyg8phh9LSKt7u0yF7UEx3/5e7awqqcBMldgKP6Hwn/hqtQvJPfkjT8yPiCrGP+USjX5xwcpvNQjHDXuyj8OepT3a3bK30wx6H6dQzf+e7yJ4QnLRN6YsERR+S0pqLVycOWbmRT9xHA5E1uC6o8RK6r/8HNdj4c2pd+cpS4oJ+Ubr4QllBYKVC9pRUAB4Ygw1aUATPekAyH2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z84dVII1echT0RJNM7JQ/br7x45aqd+bmTWnuqhB4bA=;
 b=YNVct1gwjczQ9cvVybHE9aMCpsXthlNEmHgF/c3xvz8MQk5BSgDh+WJh0unAEi/Qq5Ht5oR/gMSMO3Q7iEtCAN8Cp1i8n7/Yh22TxQWCiv6oV4ufJMM5FV747mTnBMd2Z573OtAiaBwmiPZWEtLPPJkddzTep69+Zbeb1ScanxcF5WiViWorLZXJkjQMuIyOFW+exEEEgdMkL/5MuURxB59A7GSw1/aCusjEHo+ZGSNRks6/DGvJLyVUGXx+n/DKhiuoD7cYDWxiCN24c72ZER/oal+gw+sxic00c/bYRmU8UpgNwA65yk158SCulRIvuh64RRML79IutTJ8f7QC4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z84dVII1echT0RJNM7JQ/br7x45aqd+bmTWnuqhB4bA=;
 b=JE20e0au5PlSTMbGVlAaB2zglgQOA734tdxdOAhbeRGxUY6CEU/BUEUjQC3Oz8WOul+aUDGoCENZNEkgsGZRz+3QvxuR8hOi3Z5pX1lkxN6czz521lBQcAPGM7LO/BtErANb0hvy56vghceDlI1Q30EogOsQ5Xe8PGnC4R659CD2BYdUSCmwVc6SN9TRW6avSPUeihYKmFCq8ut578BJ14o8XTK2TROHBamjsojsuX4i/YUqhX/VIQ89XjnQoUYlDC7g3AdFwxaFrbNTR6qT+hR3Xt8C15HOauWLN0bJXrxVNcD7iw9mHRYqsfWxKqpo/Cej3N15RcoKwmxS3DhcnA==
Received: from DM5PR08CA0033.namprd08.prod.outlook.com (2603:10b6:4:60::22) by
 CH8PR12MB9837.namprd12.prod.outlook.com (2603:10b6:610:2b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 15:55:39 +0000
Received: from DS3PEPF0000C37B.namprd04.prod.outlook.com
 (2603:10b6:4:60:cafe::fe) by DM5PR08CA0033.outlook.office365.com
 (2603:10b6:4:60::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 15:55:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF0000C37B.mail.protection.outlook.com (10.167.23.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 15:55:39 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 07:55:20 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 23 Feb 2026 07:55:19 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 07:55:19 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 12/15] vfio/nvgrace-egm: Introduce ioctl to share retired pages
Date: Mon, 23 Feb 2026 15:55:11 +0000
Message-ID: <20260223155514.152435-13-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37B:EE_|CH8PR12MB9837:EE_
X-MS-Office365-Filtering-Correlation-Id: 578c90c7-c672-4867-8284-08de72f3fdf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7S9K+p4Bxmy0SJMHtvGkjRo9r/QkrFy79QTDrDBacTfIklOjpC7gGBTRspTT?=
 =?us-ascii?Q?ivEhYNt/WIIoYF0qzzzwzUoFNP7kFL5xsB6Ca6LLbIdhQZxiS4m8rh8ZRMmq?=
 =?us-ascii?Q?igQyN2bvfHsvLjRBM5T4B99gXM2JaekB7omMh79i+rV2/h5PbYGaMT74Nm3O?=
 =?us-ascii?Q?K6f85ZIC38FPVA1P6vGPGfet6p1634khQAJfmp7M0+rlenWEFiu1XNKauO2N?=
 =?us-ascii?Q?H5x1Obu/5aVQYAQnejDbm+SzX5NnkmsWnjyb0bXz0GuC2RKXYwe+G1k3Lrkr?=
 =?us-ascii?Q?P042SjSMzYOpTkgYdXY9UGD+su4OVe/fjP7+gD1ktjwiqvURBz1V0s/07LwR?=
 =?us-ascii?Q?B5KVIhnoTlDqtPVzoNhClEr+IY3RvpcxJciOWNTn5L+JjrAQw1v+r5M8kCTA?=
 =?us-ascii?Q?g1KdrUDzIyzOKnA9w/vp560OKckCiQdtyE8A6T/5QwnC6rMtR4Q4s4lApEED?=
 =?us-ascii?Q?mCT3qDHYWWDOyRQCJlGbAnmzOij4Ul/yFj+ywAOvj5lrVjUUmv+djXazDDTS?=
 =?us-ascii?Q?mMmO786xsD1TXTSKK3b8MUY+trIbrtC9XZWgTZgnxzSQoPQzaM+Dbyv/aalx?=
 =?us-ascii?Q?6eLpmWKQ/jW9OhQYm/YQ9utJT6868Z828zSjy1vwRb6RH9xUH0Y6iDDCZivo?=
 =?us-ascii?Q?juL5ejPOoJjKAQVMxxOB2ijBL86cr45MOzOjXKAnPsXEAoLd9/XDfSWaFKnU?=
 =?us-ascii?Q?OX4icBySfNzi/Xwda8DL7xhHyMYlcOIQdpwTukraMoOXhGdI9jd8ro6wsbb9?=
 =?us-ascii?Q?/Qm3U8Rx0sgg+ARkaHRBq5uo/WG3tP+EqEl04R7cKxg+kIQgPGUhjzIG/Lfb?=
 =?us-ascii?Q?XaP/P6xzg9QTIY8NKm9u/4DWjoM6l9b3fRYVxw/ErDmIjSvVOrDhwqGPExuL?=
 =?us-ascii?Q?nVNBC7NNz0dXCLJKw8fsOu8sD7jZbnwjzUKvPKN37ZHl3MvfxLtSlKCpjHmm?=
 =?us-ascii?Q?IppM7ArAbqdZBRy5/eLCRqDFbFDj9/6yM/kIHQN3U0Golde7l8Pt+ocATYU5?=
 =?us-ascii?Q?O8YAnBmjebvwAY9qJhec08+MeYSotZxo7/dakIifklLZseofAu9OwvS67cyn?=
 =?us-ascii?Q?47V6bPtQpoUJh0CFqaSlAmkIH1KFCEM0E1510cMSuY1d9fzMOwDerxfFcix1?=
 =?us-ascii?Q?66haUQZ8sEVDUSN3c2m98+taOM66Mc7UG9oDMG0Uoe4XhE2siDiVlwYbF6Uu?=
 =?us-ascii?Q?KjVqx03hjHs1wng+Ap8UYMA+nlsJxwUJq3TzGovKail86PlxH13bj1PyzvI6?=
 =?us-ascii?Q?Nl4hsf884dGRadtBPvvyDuAdv4gyhkhBlNmn5iseqHYE0GOisKEXFy3dOJOg?=
 =?us-ascii?Q?DF53X76OrN5ApN9QgOAOe513ORE1OEHPsxbl+hWnkrtdAYQx/1/LaZHIhsor?=
 =?us-ascii?Q?4ao6F6wcolSsK0HcXRLQyQ0NJbvfHE9ofJrARq8hfylYh1LHV9zFbMQLcbaE?=
 =?us-ascii?Q?W4GnoDKX7N1K4tiMIhMpJXbxSXffQOPlQw437ItmeE9c6R0TKXGuhE2YHW3o?=
 =?us-ascii?Q?Db/71HEzm3hmVrx4LwjdnM2oOu++UeRu1Ircl9iycdHmLsC73xnH7Rrh4z4A?=
 =?us-ascii?Q?B/s1pisFrXBeE4tFuph8MhY2A/UYMsrR8f/KQHDjzUTO+vV3pmG5K74G6WfX?=
 =?us-ascii?Q?PlwIhOu0+QmuHONHSzz9POUD25/1FG/fdA6WRkpZRB6cu4EEmppKq1wFbDE6?=
 =?us-ascii?Q?bl0Bmw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NSapZZ0tLyqAwJUGYY2XPMRU1tW53iKPzlcmQKcKqryy+yFU2mMTwMLj4KItF9lgj/gPponY61g6/vLlUyAwjHHjwd2mJbZvyjACaEGWLBgXbdHXTIXj9xp2JTmXmeeRst5PGmL+GqHRyCQN8+NWeyHjkqHiVe7RilbTyvGuMsnjZJ6gvt/1WZwxCeNPo6AYkLPVK2HbHIf0pT9XjdnX8MKU60BZwCx4CZXp55c1JDwV4aolxlwqeyuze7tDWQE99CiRD1rshWaQghAf7gk/tEPhnQk8CJlcuYd2YjnqxxjamiE28ZB50EzufYU2l9aHChsEpAVatSuVoI5U/CwdWSpUYsmUPwM43H2FyoRvaQoKieZ5oys9Qkfdufhd1SYlve8sJRJR+K6Jl4nYrGAHZj8iNp/kl2x48mHHPrZMk00FjBXeUgV/Qm+gTBv5Z6yM
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:39.5493
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 578c90c7-c672-4867-8284-08de72f3fdf9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9837
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71489-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	FROM_NO_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ankita@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: C2DFF1792CF
X-Rspamd-Action: no action

From: Ankit Agrawal <ankita@nvidia.com>

nvgrace-egm module stores the list of retired page offsets to be made
available for usermode processes. Introduce an ioctl to share the
information with the userspace.

The ioctl is called by usermode apps such as QEMU to get the retired
page offsets. The usermode apps are expected to take appropriate action
to communicate the list to the VM.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 MAINTAINERS                        |  1 +
 drivers/vfio/pci/nvgrace-gpu/egm.c | 67 ++++++++++++++++++++++++++++++
 include/uapi/linux/egm.h           | 28 +++++++++++++
 3 files changed, 96 insertions(+)
 create mode 100644 include/uapi/linux/egm.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 1fc551d7d667..94cf15a1e82c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27389,6 +27389,7 @@ M:	Ankit Agrawal <ankita@nvidia.com>
 L:	kvm@vger.kernel.org
 S:	Supported
 F:	drivers/vfio/pci/nvgrace-gpu/egm.c
+F:	include/uapi/linux/egm.h
 
 VFIO PCI DEVICE SPECIFIC DRIVERS
 R:	Jason Gunthorpe <jgg@nvidia.com>
diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index 077de3833046..918979d8fcd4 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -5,6 +5,7 @@
 
 #include <linux/vfio_pci_core.h>
 #include <linux/nvgrace-egm.h>
+#include <linux/egm.h>
 
 #define MAX_EGM_NODES 4
 
@@ -119,11 +120,77 @@ static int nvgrace_egm_mmap(struct file *file, struct vm_area_struct *vma)
 			       vma->vm_page_prot);
 }
 
+static long nvgrace_egm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	unsigned long minsz = offsetofend(struct egm_retired_pages_list, count);
+	struct egm_retired_pages_list info;
+	void __user *uarg = (void __user *)arg;
+	struct chardev *egm_chardev = file->private_data;
+
+	if (copy_from_user(&info, uarg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz || !egm_chardev)
+		return -EINVAL;
+
+	switch (cmd) {
+	case EGM_RETIRED_PAGES_LIST:
+		int ret;
+		unsigned long retired_page_struct_size = sizeof(struct egm_retired_pages_info);
+		struct egm_retired_pages_info tmp;
+		struct h_node *cur_page;
+		struct hlist_node *tmp_node;
+		unsigned long bkt;
+		int count = 0, index = 0;
+
+		hash_for_each_safe(egm_chardev->htbl, bkt, tmp_node, cur_page, node)
+			count++;
+
+		if (info.argsz < (minsz + count * retired_page_struct_size)) {
+			info.argsz = minsz + count * retired_page_struct_size;
+			info.count = 0;
+			goto done;
+		} else {
+			hash_for_each_safe(egm_chardev->htbl, bkt, tmp_node, cur_page, node) {
+				/*
+				 * This check fails if there was an ECC error
+				 * after the usermode app read the count of
+				 * bad pages through this ioctl.
+				 */
+				if (minsz + index * retired_page_struct_size >= info.argsz) {
+					info.argsz = minsz + index * retired_page_struct_size;
+					info.count = index;
+					goto done;
+				}
+
+				tmp.offset = cur_page->mem_offset;
+				tmp.size = PAGE_SIZE;
+
+				ret = copy_to_user(uarg + minsz +
+						   index * retired_page_struct_size,
+						   &tmp, retired_page_struct_size);
+				if (ret)
+					return -EFAULT;
+				index++;
+			}
+
+			info.count = index;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+done:
+	return copy_to_user(uarg, &info, minsz) ? -EFAULT : 0;
+}
+
 static const struct file_operations file_ops = {
 	.owner = THIS_MODULE,
 	.open = nvgrace_egm_open,
 	.release = nvgrace_egm_release,
 	.mmap = nvgrace_egm_mmap,
+	.unlocked_ioctl = nvgrace_egm_ioctl,
 };
 
 static void egm_chardev_release(struct device *dev)
diff --git a/include/uapi/linux/egm.h b/include/uapi/linux/egm.h
new file mode 100644
index 000000000000..4d3a2304d4f0
--- /dev/null
+++ b/include/uapi/linux/egm.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#ifndef _UAPI_LINUX_EGM_H
+#define _UAPI_LINUX_EGM_H
+
+#include <linux/types.h>
+
+#define EGM_TYPE ('E')
+
+struct egm_retired_pages_info {
+	__aligned_u64 offset;
+	__aligned_u64 size;
+};
+
+struct egm_retired_pages_list {
+	__u32 argsz;
+	/* out */
+	__u32 count;
+	/* out */
+	struct egm_retired_pages_info retired_pages[];
+};
+
+#define EGM_RETIRED_PAGES_LIST     _IO(EGM_TYPE, 100)
+
+#endif /* _UAPI_LINUX_EGM_H */
-- 
2.34.1



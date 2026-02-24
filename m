Return-Path: <kvm+bounces-71591-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qLTFCrhfnWmxOgQAu9opvQ
	(envelope-from <kvm+bounces-71591-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:22:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B3FD818393C
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:22:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 38C783078FD9
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F409D366552;
	Tue, 24 Feb 2026 08:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hHgDIMCP"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012009.outbound.protection.outlook.com [52.101.48.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F476364EBB
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 08:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771921312; cv=fail; b=Q7k8PpbuL0xcgouV0nlDL8fy0dMW3qfIQs3+/sXQtZ8AWEbAfrSnW5+FqDtZ/bet1LKOZyyWZPTCJTKIHlbpa+5xYsnJRw2RFzKX9jYZmfS9M0czwyCnYGDkkX5443RLEk5cjh+re6WZEAnjBEwNDxCRv91X0/h1Xw7R7fv/1x8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771921312; c=relaxed/simple;
	bh=2PHgaScjBqC/Ve6qFXbA53WYXOGXD8o85pbQYUNQCxo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pBS2WzFgwYyebGnR7y1kUCyBzC0H0zgO1Rk/aSQ8CEWDVdwi6Uomr/eOEsM5oR0m9OTXl3jAzhD9sB7vorPPHXIAuSuTfKlnYjKjCdUouYolpOfd8PCStQEyVYx+1jd49qi5Vq1D1NhLj+Zwc+ZP2TTcw1uznfb/jW7Gr++H3Is=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hHgDIMCP; arc=fail smtp.client-ip=52.101.48.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nPm0zhYdp9XZgXO0KC7nc8Ty4k8Vc6cbyasaMzrf/QHmukZPzIs30TU4uHHogQUAkO7T5spHH6X7w3mGRj/Q3HyRsAWZcjYDlzZ3y4ul8PgfLqSea2ATRWv1fIfpySU+KZVxa79mwquFkdV+lby1p53fBmFEpDzIeK4TH7ZDf91Vbz45osta8UAOKueyHPZOXFdSy94Mr2oykYanfUHYdg3LfFS+roQuYJVUqWsC8j+s28mu2Yb/LkYMgvQ82E5R9REpcbR53ZGdtigmPGlpYrqwvDmIBqXgnuQtL3kAnAknHRYMX859EVA/DCIeLuUVSlXQTQLI2dYD+PkAd/N8uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x6fBmYi82UX72BIKB8JR1Ku3IcmxpG0XoLFcLnoQ7ic=;
 b=k/2Fy2r+tr7yOuQduYLhly8vrYfJ9oalOPFmHHtQEyqFT/8reoeHxGpljn/9pfUv8VX1OR4azy68kpxy9epcIuMNeEqVjli4ofblGRyy7NcdOGFrTbfqhuhzZiCnfkGfIYtOozP9k0x0zyUs+FyZ1WW8oe0ZzP/EJLGZQm52W04qvXmLCia9lfaL7aIQDN5P+osOwyxnNMVUu1j3HNyavqyf/OrgK5vZQjq0gzJM3GdV8toKohUSAy/FO7Q69M0+FkLs+892x7cCZhZezl0r451XWcjs8POiZ+vA0B68IyqMtx3R1lQUUUmrPq1uGVCIzqDYhWuQ9VrzFU0AFU7/qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6fBmYi82UX72BIKB8JR1Ku3IcmxpG0XoLFcLnoQ7ic=;
 b=hHgDIMCPmZ3anpRJRL887HcIcu2Yll+ySIntFvVaeiDUHYqiKUuQ2lfjbS1EPNXQnprZU6AMTxbfGPbJs4Xz48ae98sdlCqsGDYkdLEnIDb0eMuoxUvCLAAzWqevOiqCC6Vj1hi9EJOE0KuSblQUoK+PylSive6qIqnFSVp5nQUhn2cVzQwtlrQKFmAF6hAECZjTMrf0Egkynv/l/b29adhAXNMxc3SMP5++Ydmo2850IPOBvwRYnjCr1j160r6vMXG+RraqDlwxPO+41FZIScGwrz2rh7LKuZHzDcalho3LRxk06JtCqSbx/AN2nHy3pn9y697Rd6qfgpLyo/D6wg==
Received: from BYAPR02CA0021.namprd02.prod.outlook.com (2603:10b6:a02:ee::34)
 by SJ5PPFABE38415D.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::99e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Tue, 24 Feb
 2026 08:21:48 +0000
Received: from CO1PEPF000075F1.namprd03.prod.outlook.com
 (2603:10b6:a02:ee:cafe::4e) by BYAPR02CA0021.outlook.office365.com
 (2603:10b6:a02:ee::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Tue,
 24 Feb 2026 08:21:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000075F1.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 24 Feb 2026 08:21:47 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Feb
 2026 00:21:29 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Feb
 2026 00:21:29 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Tue, 24
 Feb 2026 00:21:26 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>, <avihaih@nvidia.com>, <liulongfang@huawei.com>,
	<giovanni.cabiddu@intel.com>, <kwankhede@nvidia.com>
Subject: [PATCH vfio 1/6] vfio: Define uAPI for re-init initial bytes during the PRE_COPY phase
Date: Tue, 24 Feb 2026 10:20:14 +0200
Message-ID: <20260224082019.25772-2-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F1:EE_|SJ5PPFABE38415D:EE_
X-MS-Office365-Filtering-Correlation-Id: 676b5569-1f32-4fa6-5e89-08de737dc112
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1UHMTxFDL7HeAQK7MZJVw8Dm/qidB9QxKo1LXogTtsuJM7BM0i4PNko1p1fs?=
 =?us-ascii?Q?vH3KH/yp9nCrpjlvNRQ/41lr9NLkJY1QG1EBaOWWV/3YI3Uhd5MHOhjHZg5z?=
 =?us-ascii?Q?9PclHn+mFekjBfo6HFs9Ycon/6Va4iN1oyJiYamV5ImvDGX0+O4uusFWcdjN?=
 =?us-ascii?Q?8TxWc6/GMEgcPP2By7VA1vDU9Pz7MW151qUkSfZD5rYvsJuqQiLcSQMRQPsh?=
 =?us-ascii?Q?PazUTB3LnI+cTKG19lD1wd1lQexFzYISDu+aO0Nw1FMJGKmmjsUsBDbyBbIF?=
 =?us-ascii?Q?XqqvWhyUi4S4U451LGDdn2eaArHSz94wUjl5IqZeIqivA69bkv15f3XWy2Y2?=
 =?us-ascii?Q?yuVWnkBUhxb4cCq2oAxNyuLMBoE6o1O6llTomHnpTlHDzSO5bW/L8Ecnp8kW?=
 =?us-ascii?Q?bwBRqcu7UD49Uv5ccR/mYLJT4c3EgpMc2u5Qqgg3VzXpeWU48m6rpZde9bg/?=
 =?us-ascii?Q?z0gLSW/ZnFUtykRruu4doe2Y2zT4In1WArEeUemA0G8gHBA76Ej16sVlATKI?=
 =?us-ascii?Q?9R2hiKfcUJprqjmxiyXN+U5rafXsLWnWM1Od118TDiLwysOye0J8HXMcucSF?=
 =?us-ascii?Q?lEeq05WO0twSucXP8LdYLslRxNNppRrCKNPVSHnP3yCf7hEyIvnbxSPnypbS?=
 =?us-ascii?Q?qV10IlL42C2gcJlRgsve4naavD/fDiWWAzAsVjwRs5+YwIJY7KsHhrCI4NtS?=
 =?us-ascii?Q?CVJeINVQ3BPFuibaibtRGU0JAFT8ULPUzVEFQJsbSJzbgDlC0Akd1FnQAXFa?=
 =?us-ascii?Q?lZSgznC0ZvRENXlRZVE/gyH4EM1bKbnttcItB8DkUTI0bcsXS9s9Op2aEExU?=
 =?us-ascii?Q?p/kcT1egfFQIX9JzkFkTy375gFqCBSXY9SKG8fFpKzvXmGVkS1YJaO2468YM?=
 =?us-ascii?Q?a3FiOmPZE6y6ZqJ8M9UZD24IZX4/iPpsj8kvVDwIGGQJmkYYZ884iw4yWu+5?=
 =?us-ascii?Q?wE8Wv1oYn/G3kRhLsgeBo3RAj0pKBw74fVBfuqDN7ELDZIGI3dzQtk+qThhw?=
 =?us-ascii?Q?3KJ2+oiBBwWRzjWlojNQ39gVICchNLfqGTLNkbU3wXCnlZ07uU7IlCypf5Tq?=
 =?us-ascii?Q?sGJTFordC54EbGKr+L/Fg0VoEBoz6+w85dX/W4BQzw10VaQz0dtFb28Q7gFd?=
 =?us-ascii?Q?pS+ErpLsZs3BgoKzjwBrsdWp7GalVPz6p1wqCa/MmUO+mQlfVieW56QzG70j?=
 =?us-ascii?Q?A3Y6MJSTefggnleibii15FmkhfQvvhW+5tYO0g54tsfYbodyWtEgDr8xDhno?=
 =?us-ascii?Q?LqDMI6w844+GZAyFRhpUUVF1/28iTkFIBj6M9jPtn9sQCPaT++vQAZVUwVuv?=
 =?us-ascii?Q?TN+156dXIpUzbP/EWMLcopwZ7VT0jffRCm2nXe542F9tmLXwhGV9H8pVIt8n?=
 =?us-ascii?Q?uA8Pj1OG70OykD9Im6EQ5k4J3F6JgTjnbp6U0wsdBguMiu68BWb14LJwxpHH?=
 =?us-ascii?Q?yXaWMSWq99oPyAuaVGaDmu3CGQcW/2e945n2R/E66iwnxCbTBhedvNUlavME?=
 =?us-ascii?Q?uMQ9b2MbqQuoW2NC4iCIMZ1NnW2AZlsFecwQ8HGnGq1m+PQdahkBORpHXsqL?=
 =?us-ascii?Q?8Qwd/c1Y5IcF8O1ScAMGLlYiUddvurCrvRAmQyCk4FITFKxPogDB5B48jpN3?=
 =?us-ascii?Q?yfPBMk2x1NA/YpMXVzAnn/0OuaE/5eVgusQ6eEw4utRxdy1uxBjfjlwqLqUG?=
 =?us-ascii?Q?Sns5rw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kv9kDqXXou3/RDZP2b2wLfaMS1HTfccdkVfqOOekvClkHtg86bZbXwCpYy/nVi2kHvTwcxx1INIao0LTcC9KvDz8NFDL+49zgVs/bsN3PXytU6PWGgmZOcPnL0Qt3G0QH4dP1BF5Ow/dJvORnnetc/8OXoWq+jIHEG9N7bDkE7B3AgXOwcqZxT27+DIz0xxeNXFc9N5JJWWAoHAPN95BPhCty+oNIBLFlfB3RyJd4zo29I15nL/4hlaQnOHrVNzcNe+WcFLHVenXzB0TSpWXJdn9Yq+3hJ5C6idRV4rp0ckUsAx3qkzdpa70BNKH5zLvcAcNp7jqJkrNVA3vVPJV2H0S5CaI7hYJoj/rRkwkQG+tJ3+ko14RmhvPzBr8rtlHhHi+W2Hz7GMeYRhKi5Ztlgv/DuqoL7xyM8fffxALtXC2k0oDewE2XXkTG/eNyZQ2
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 08:21:47.9037
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 676b5569-1f32-4fa6-5e89-08de737dc112
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFABE38415D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71591-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yishaih@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,nvidia.com:mid,nvidia.com:email];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: B3FD818393C
X-Rspamd-Action: no action

As currently defined, initial_bytes is monotonically decreasing and
precedes dirty_bytes when reading from the saving file descriptor.
The transition from initial_bytes to dirty_bytes is unidirectional and
irreversible.

The initial_bytes are considered as critical data that is highly
recommended to be transferred to the target as part of PRE_COPY, without
this data, the PRE_COPY phase would be ineffective.

We come to solve the case when a new chunk of critical data is
introduced during the PRE_COPY phase and the driver would like to report
an entirely new value for the initial_bytes.

For that, we extend the VFIO_MIG_GET_PRECOPY_INFO ioctl with an output
flag named VFIO_PRECOPY_INFO_REINIT to allow drivers reporting a new
initial_bytes value during the PRE_COPY phase.

Currently, existing VFIO_MIG_GET_PRECOPY_INFO implementations don't
assign info.flags before copy_to_user(), this effectively echoes
userspace-provided flags back as output, preventing the field from being
used to report new reliable data from the drivers.

Reliable use of the new VFIO_PRECOPY_INFO_REINIT flag requires userspace
to explicitly opt in by enabling the
VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2 device feature.

When the caller opts in, the driver may report an entirely new
value for initial_bytes. It may be larger, it may be smaller, it may
include the previous unread initial_bytes, it may discard the previous
unread initial_bytes, up to the driver logic and state.
The presence of the VFIO_PRECOPY_INFO_REINIT output flag set by the
driver indicates that new initial data is present on the stream.

Once the caller sees this flag, the initial_bytes value should be
re-evaluated relative to the readiness state for transition to
STOP_COPY.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/vfio.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index bb7b89330d35..b6efda07000f 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1266,6 +1266,17 @@ enum vfio_device_mig_state {
  * The initial_bytes field indicates the amount of initial precopy
  * data available from the device. This field should have a non-zero initial
  * value and decrease as migration data is read from the device.
+ * The presence of the VFIO_PRECOPY_INFO_REINIT output flag indicates
+ * that new initial data is present on the stream.
+ * In that case initial_bytes may report a non-zero value irrespective of
+ * any previously reported values, which progresses towards zero as precopy
+ * data is read from the data stream. dirty_bytes is also reset
+ * to zero and represents the state change of the device relative to the new
+ * initial_bytes.
+ * VFIO_PRECOPY_INFO_REINIT can be reported only after userspace opts in to
+ * VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2. Without this opt-in, the flags field
+ * of struct vfio_precopy_info is reserved for bug-compatibility reasons.
+ *
  * It is recommended to leave PRE_COPY for STOP_COPY only after this field
  * reaches zero. Leaving PRE_COPY earlier might make things slower.
  *
@@ -1301,6 +1312,7 @@ enum vfio_device_mig_state {
 struct vfio_precopy_info {
 	__u32 argsz;
 	__u32 flags;
+#define VFIO_PRECOPY_INFO_REINIT (1 << 0) /* output - new initial data is present */
 	__aligned_u64 initial_bytes;
 	__aligned_u64 dirty_bytes;
 };
@@ -1510,6 +1522,16 @@ struct vfio_device_feature_dma_buf {
 	struct vfio_region_dma_range dma_ranges[] __counted_by(nr_ranges);
 };
 
+/*
+ * Enables the migration prepcopy_info_v2 behaviour.
+ *
+ * VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2.
+ *
+ * On SET, enables the v2 pre_copy_info behaviour, where the
+ * vfio_precopy_info.flags is a valid output field.
+ */
+#define VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2  12
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.18.1



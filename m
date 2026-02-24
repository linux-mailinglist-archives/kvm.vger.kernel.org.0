Return-Path: <kvm+bounces-71592-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8KhxGKRgnWkDPAQAu9opvQ
	(envelope-from <kvm+bounces-71592-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:26:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6E711839F8
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:26:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7A97B316C659
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E12E364E8F;
	Tue, 24 Feb 2026 08:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RUgNqLJS"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011062.outbound.protection.outlook.com [52.101.52.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FF936657D
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 08:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771921315; cv=fail; b=c9RsT26pOTPGnnVdJM7DiXs4IgoZoexf9ssXrX2zZ4q8axwEXMQYGw4kjaww874iavxqxno/GJPjQhwVfPrH0PLUPtVoAd7pQ3R5KJ2dTOlQi2xD8Dukbou9PXsRhlv4gmMhYdGnqrOwIjK39oIzMeqfxuubgo2eproHAH6xrwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771921315; c=relaxed/simple;
	bh=Gp3CfnsajItluhSCh1sTVAOCRFc8giia5cJ/hoGE4uQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C01XT3rmGcn32VHwCUbTo+tvQkxd8wnaNPIHP88PisQopB9uUTnKWma2yEKEWw9EbAVEMECxwpE47vrTpguqeT2Yq/Vv3FfK77hxmlsueUagT6sDMYxE1vwzFndtbrDWsn1CUOGDzmkkKckjvo/u7GUfjHOotNt35CpKxJCGFXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RUgNqLJS; arc=fail smtp.client-ip=52.101.52.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MJynWJQuHZvx5Rtq4IaL/RhOzEyUSX0SmBVy0ZxO8Pz+s1S6ZHZUyVWPruI+ovMHXtfJSlzlU6nTTDf5Jpox2C9CyLHSuvCZ9aDpBYcotJzJ7DtXtxPVA7L+Vi1H/5Q/mahka9Owir64bSiEjCadNkFbarTTLMeWJIP1dbDbv6VUL39AJ9+w0NQLFhVj1Kv3fP1Z2yqgOtsM2ulKBvmvnWMCAt34OoCJlazbDDEqd7vXCyA4EfUAi1H7NaM9hgO4kjsY2PvhsroQIhzxF+UG9RCsbA13w6JTbnirFj6kP7scmBsCcOk4Ru0Pgj2eqgEdBcDpBC11ZJnU3eJO76RFnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OgIX+Hu8iExhnSHFQzKg0IFBtBczwCgtyDOAuF4vH9E=;
 b=FYrWzQt1U86ESHf/qNeLwRdyaqmMmdCY0ayY/XEL3gEQitqdt1TlBlmwQa+K44ZGdIv3ejfd6swiR0cBQ9FkVNV/7NYJ3EhJAAgucdpnafSOj1hJ5jqLSPOOqJAbyEECL1HdHGHdO03FQynsXOdkn2AR9GSA6XnmDxpTdjQiGEXnmjzx9Yx6gWSeL/OD02dKweJPZGOGwnzHAOEwC98UNnpvMBpdWYLYxiFTOhn20vD7JWRUjLS/zgP1pKeVylJpS54KplCFxy7HXiB73rlKG6EaxxFlVQm/uF3AM5stuE/g7kwZS3AE4AR7I/z+V+EIHf4wqgmTB6E3I+uCI5v42g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OgIX+Hu8iExhnSHFQzKg0IFBtBczwCgtyDOAuF4vH9E=;
 b=RUgNqLJS3JSEmi+CCjkiAujmUM6mEUq6s6cZdt/uLeD0TpZ1TcvwDYSLPEXdPMKX2Z8uErXPy9fr8agzxRkYYp9ChXzO0DZyj8G6Qt2f6NYPke0ewSVtSNWM7OJ8DUaZh32xdaMU8N+xyVn8oOH5r4vBaWy5wTVoqHvrnPQkYDu7nVcvjkYFzVEy4/teKANDUZP4z9icQBoFGSKtveGMLAeNpfkbxV3VSakcFbAQIvQMoBcVlC+Il81kv1y8BYkMj+OaowP5OAFiUzMhIHpi2q2mW0l7BAWdCLQuCuB3vGy590ZUnTBMxhScR4UOrrbYzN4PibaW3GxwOLPPNReZhg==
Received: from BYAPR21CA0021.namprd21.prod.outlook.com (2603:10b6:a03:114::31)
 by SA5PPF6CDAEAF48.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8cf) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Tue, 24 Feb
 2026 08:21:50 +0000
Received: from CO1PEPF000075F2.namprd03.prod.outlook.com
 (2603:10b6:a03:114:cafe::fe) by BYAPR21CA0021.outlook.office365.com
 (2603:10b6:a03:114::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.6 via Frontend Transport; Tue,
 24 Feb 2026 08:21:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000075F2.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 24 Feb 2026 08:21:49 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Feb
 2026 00:21:33 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Feb
 2026 00:21:32 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Tue, 24
 Feb 2026 00:21:29 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>, <avihaih@nvidia.com>, <liulongfang@huawei.com>,
	<giovanni.cabiddu@intel.com>, <kwankhede@nvidia.com>
Subject: [PATCH vfio 2/6] vfio: Add support for VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2
Date: Tue, 24 Feb 2026 10:20:15 +0200
Message-ID: <20260224082019.25772-3-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F2:EE_|SA5PPF6CDAEAF48:EE_
X-MS-Office365-Filtering-Correlation-Id: e9aa9684-c9bc-415f-0701-08de737dc223
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WVV076Ve5qTT3IXpOgfVudUkkMONQSOU3Yi7RTm7P75FR94QDx/8IE+0B97Y?=
 =?us-ascii?Q?8IBGlESHgv3vpnFfXrg+w/2QVeq2I9HJ80ZzIWFllsrZOiTkzX96L5xd73P7?=
 =?us-ascii?Q?GhW1l4MnDkXvCSg8jdUpOlWwrY/sC6KlvCx9LMB1EbCmDmckqEG1/TBzmEok?=
 =?us-ascii?Q?extcKqSts26KfuKr4Cca94stUwVeOtvcmW5g+xx6StQ0lPSJLnMHIeHv0WBH?=
 =?us-ascii?Q?/+aqQ8Vg85jVDqQQ4KDd6STkpMLXl/SJsHo7S8AIe5rH8YCsxHPXSv6NDgbV?=
 =?us-ascii?Q?NrlBI1Gw8G2oBMqzp9sZp1dbe8ohpx9l6YegDBIl9K9bbrOSAJKITg0VTQGU?=
 =?us-ascii?Q?kgy2vr5bzsCYmIEuyC5bBnrURx7YrNcqcoxY6K2wMzCrBUbpLItli/SxQcAI?=
 =?us-ascii?Q?6pn2zS0YGSR/VuWN9M4ix3dGRMoMsk5uU6HH82gbJPZ5yQvRxy7UKTgoK1QP?=
 =?us-ascii?Q?4Xx7nTdbhe2xVj5do1llcd/fknUuE9sveQoDfVzyxUVlRp5CjHPnhIF6ROO0?=
 =?us-ascii?Q?A6wig7d0lcxe0JQMCIf1S7NfDGJhIiPaVDKT+W0ieXm0PAlhRvTBRkFpWu0I?=
 =?us-ascii?Q?kVseIzQI0veHEfccqIUpP86Xk/foyqvKXz8WfEdNSYdd8xsml/iNQ2b+5xS9?=
 =?us-ascii?Q?HaEgkJk/5DwgdIWBHGurSm6Vh/LJcYVa7LoPsVBOX62I8t2bM+g6akE9FLfy?=
 =?us-ascii?Q?LAFRIi4s9G0Lti9xvFAj0C+s63sgQVyrOdSobnnk/c4psr/JakLoF39QUEwe?=
 =?us-ascii?Q?uBNqM85+PbjWLJMkeMQQx3By0rKdFH5PCBNoDq/2UZU0tqa/KMaiS6kznthY?=
 =?us-ascii?Q?nmI1IuE+1rK/zEPfYwDCRIOyLKTcldFstXnSeU/yaCFX97Cns9xA+t4jptFl?=
 =?us-ascii?Q?O2yQ33+U/jCt322cMAdqLEQRHl3IIvLy9E2k7Qk8qVhqvVQLMLf6k5AaGrR8?=
 =?us-ascii?Q?MwhP4wU2X80j/oScE71IxU48YpJIFlkBmcwVTXeQNwIw3pS/kkg50rrKMMhc?=
 =?us-ascii?Q?xX5VrigYWjnmvufqvtJEVPtSRR9LkMbcHWDgS/PtZxxiNT80LUODJrwlhGLs?=
 =?us-ascii?Q?ZqlOko8KkbyMBNRPF3m0z+rNv1BPJNE1kToZLtYkuT9VN1jB0YmWJPWP9kDB?=
 =?us-ascii?Q?WS08wrNEWAfL0RwxGHQyemkb+YUR+D4x3xj1IIOPVCvetCl6RTVhXFnXUS70?=
 =?us-ascii?Q?A9BPsBA8D5cYoS0YDvUPrtldTtaeLH3jTYUxKNxOovD62SqO0B57ZNr75KrP?=
 =?us-ascii?Q?/0Ko+Z0dY+yVh1xM41GuJheyR7DVQfXVa47iJaXrJub6xGc95Wa4JI/Wkp34?=
 =?us-ascii?Q?fgRJhs1Zwl4Aes4w16Pl76OLxJiWDBKXl12mOYLi/sykhn3YYtTGRT7i3G6m?=
 =?us-ascii?Q?p5POVrlIq+Ovvi7WYcFAw5kNnpgAA5dVhMn22Dr1cglrasdyEkkOPUNsJSE4?=
 =?us-ascii?Q?DBt+Y+uLdRsz3C695PYtiVPTxmhzTHfgE0c2LzJaFFHV006ZPbE3B334Gu0+?=
 =?us-ascii?Q?9fWdYC4ehtJKeUPhKAKUvX/+2FAJ4VCTfnFuaqsSdNJSAbHHVtFPiAHgcYGk?=
 =?us-ascii?Q?IO1ocYkFT+pB26M2t4R76vpo8vfihPV6ADLOyPzRyo/96tsK0v116Ol0QmJk?=
 =?us-ascii?Q?BIJ5NvDrEJEg3tNCLZwetIrC1jKWK0n15Hq5QG9TGqHcldnjSNQqv57DdoAK?=
 =?us-ascii?Q?enIjtw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BsSqzk/NVFtTi3FrPu5J7JwPMx97t9vGtSlHpoPjse13gcJ91H5rDXCmlXmdP6PtEuA0Sh1Gs97ejroWef25OF+wKlhK2vBTpw/yqrqI5hiDhLmskpKyPQ46WM0to2f5JmD/+H5LCBAjFkVpcUx0rWTghLaCdNOK7a2h/do3QkZXGtq77bLSlr6BfFPFEzpViX9AFRalalaFSO21eVJWM0l/+EyzKDmv+uT5xqo2Iu8AHPBbXdxNU8+DWUEWtT6mCMcoGj02uUbn8BWH1mU8dGhKGpurUCZrPS1OHJOLElqIzkCpQO+lFxjh8v64kUJQE8fq2Ibcf3WmbG63ADOqQc5SHVOXI5nEn89U70A46b27bejzmhAk9oZo3RdY6XNZUARJeC1gnwvYawlOCZiL1Jn7FGtAk2Gv4gTSWp476X0o16Rw2mGsAF+BYBmVZuV8
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 08:21:49.6992
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9aa9684-c9bc-415f-0701-08de737dc223
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF6CDAEAF48
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
	TAGGED_FROM(0.00)[bounces-71592-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: B6E711839F8
X-Rspamd-Action: no action

Currently, existing VFIO_MIG_GET_PRECOPY_INFO implementations don't
assign info.flags before copy_to_user().

Because they copy the struct in from userspace first, this effectively
echoes userspace-provided flags back as output, preventing the field
from being used to report new reliable data from the drivers.

Add support for a new device feature named
VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2.

On SET, enables the v2 pre_copy_info behaviour, where the
vfio_precopy_info.flags is a valid output field.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c |  1 +
 drivers/vfio/vfio_main.c         | 20 ++++++++++++++++++++
 include/linux/vfio.h             |  1 +
 3 files changed, 22 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d43745fe4c84..e22280f53ebf 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -736,6 +736,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 #endif
 	vfio_pci_core_disable(vdev);
 
+	core_vdev->precopy_info_flags_fix = 0;
 	vfio_pci_dma_buf_cleanup(vdev);
 
 	mutex_lock(&vdev->igate);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 742477546b15..2243a6eb5547 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -964,6 +964,23 @@ vfio_ioctl_device_feature_migration_data_size(struct vfio_device *device,
 	return 0;
 }
 
+static int
+vfio_ioctl_device_feature_migration_precopy_info_v2(struct vfio_device *device,
+						    u32 flags, size_t argsz)
+{
+	int ret;
+
+	if (!(device->migration_flags & VFIO_MIGRATION_PRE_COPY))
+		return -EINVAL;
+
+	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET, 0);
+	if (ret != 1)
+		return ret;
+
+	device->precopy_info_flags_fix = 1;
+	return 0;
+}
+
 static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 					       u32 flags, void __user *arg,
 					       size_t argsz)
@@ -1251,6 +1268,9 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
 		return vfio_ioctl_device_feature_migration_data_size(
 			device, feature.flags, arg->data,
 			feature.argsz - minsz);
+	case VFIO_DEVICE_FEATURE_MIG_PRECOPY_INFOv2:
+		return vfio_ioctl_device_feature_migration_precopy_info_v2(
+			device, feature.flags, feature.argsz - minsz);
 	default:
 		if (unlikely(!device->ops->device_feature))
 			return -ENOTTY;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e90859956514..3ff21374aeee 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -52,6 +52,7 @@ struct vfio_device {
 	struct vfio_device_set *dev_set;
 	struct list_head dev_set_list;
 	unsigned int migration_flags;
+	u8 precopy_info_flags_fix;
 	struct kvm *kvm;
 
 	/* Members below here are private, not for driver use */
-- 
2.18.1



Return-Path: <kvm+bounces-71481-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uIlaLM15nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71481-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:01:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3795C17941C
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:01:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4561A30C3673
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4617E3064B5;
	Mon, 23 Feb 2026 15:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FH2W0DUx"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012004.outbound.protection.outlook.com [52.101.48.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4D23043DB;
	Mon, 23 Feb 2026 15:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862144; cv=fail; b=sTsKoKV7wRMriJu+rN6HLMUhnFErJw/V3c/uc6hLIILiDd/tEpb2erRcZcxmMaOqC/6GGzPEjHRarFm5/dVZYo7niCrSG1WhdyQkFD7saYuV8UR6XtJ01qApXL6c5znXeme4e5KGsmj2wSVDkXhU0HGEtYZzFlMYg4QfmqcUc+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862144; c=relaxed/simple;
	bh=uuWHGNSkAP94jR/fgsXeb9oI1YhjojJJgRJNLCGhess=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bv7U9ESLiTUg1vyFLrDlHJMIX+P2eej/pOiNahegxlqJsT5ey/aqBGX/sBsYcSfKsmweljUSjUwE0XuxBI2vKLeR9YIzcIBuWAixdk6QDc7KCMsTHTHswhdZh+akNrqL3bwPYVBti+FNPB5cLu++jV/ET3+oS8f34ppEMtzb0O8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FH2W0DUx; arc=fail smtp.client-ip=52.101.48.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qc/WsehQLKLGlEYMbBrgos30fjd8Nqqs2/WPH+WqLYnHSJ5XT+c7fba+B0yJU37+9enY3rTYandFfngR30uZCEPZHPZlh0Mey0L0dSmG0Kt5urNQRzmOzX+lR05qR/jaswwJHfeEkFTIfW4SfooPA9VA7GFZLKnrbIIx4d/ih1nB2qysSYGpcvC+Rqpc5ZteR3FBoDZQDJkn2Io9OZQri04Cmrlw31pl9brgt8xB9eExC4TIN76QvdgDDEpXv51hFJn0Mb8LIMGkZQ73FJjNyY4VtUzpdqDOdDVkRoqvPT3jrVQuSOFDlQA5jooxDyhJ88Xfk+TUS4nMol6VFskFuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1OfFU20yP01Dw8OSK9Q+I6UX8mB9z4UZamfT8Vu8x+A=;
 b=L8eav1agQLed00u4rMU5x/Pn1FAF4BfEGb/Skdfw1/0bJyuzMxILkLJdGw4oNtpo1WtWoAcowsTqEUeaxBEx1pOKVsyw/lneObxG4/fEHBXbeZM6pB67T+MKSmGHYSasnDlPygeWOBwubnUFAyR7wM5FgV53vDkw9E5+SYroVq+1JH8le/uOztcDpGBMyyUYTMrQCojcf8dOD5nHD7lDrn/qPG6CPnuVD1G2NRbNFmUhRad3pfg2oJhDenaXlJaY7pr4MPIbuzheOrMD7I4cTJU8jhyIFkbiJb1XwsQ+mkQ4NhJWrNGAWZdcQsUSpm3WPga4PY6VL6Jey6MgjoQTpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1OfFU20yP01Dw8OSK9Q+I6UX8mB9z4UZamfT8Vu8x+A=;
 b=FH2W0DUxW+n/uokoFtlh0t6dMXnC42nOdmKNw8HJVWPg5SpywDYGH+rFQo/dwMGoErEC+ouUr+iocoqC7P0O+LBiNRtDdPiJBLoXoemgpc4jase9n/bM8Prlf0beqaQe9wL4Ew7GY0JGXYa4ttusRQVEXoGM5I2W7M10dgmqaPXqYTJHDp+aZvmOXQ6W2h1eIOtXna98mQanmH2qSlidziJeQor2Rl9rhcUVmlPtEebSOU7TGLEA002k0X1+73BmMWr7vcFePn/KVHRXmddvbEvIeXaKU4sP7y0vlRtVNagUz9jhp7yYG4YfvWAHl2FiOzewLGTkoWmifC4RqUeksw==
Received: from CH0PR04CA0044.namprd04.prod.outlook.com (2603:10b6:610:77::19)
 by IA0PR12MB8225.namprd12.prod.outlook.com (2603:10b6:208:408::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 15:55:34 +0000
Received: from CH2PEPF00000099.namprd02.prod.outlook.com
 (2603:10b6:610:77:cafe::2c) by CH0PR04CA0044.outlook.office365.com
 (2603:10b6:610:77::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 15:55:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH2PEPF00000099.mail.protection.outlook.com (10.167.244.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 15:55:32 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 07:55:16 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 23 Feb 2026 07:55:15 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 07:55:15 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 02/15] vfio/nvgrace-gpu: Create auxiliary device for EGM
Date: Mon, 23 Feb 2026 15:55:01 +0000
Message-ID: <20260223155514.152435-3-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000099:EE_|IA0PR12MB8225:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e76e54c-4bbe-4606-b0ac-08de72f3f9f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dkyR7aaf1fIWMsvjFlTVf68jQ4NfDou480QafN3fjiEqCYTTbMS8/RFUr3qq?=
 =?us-ascii?Q?COSgNJ1LT0HnejWj1NF43EU5WPUMYNHeWhpLyVgvRFhyAYMp+zkMA3Pf7kfH?=
 =?us-ascii?Q?Dqxla10koJHv3P1sd+8H1y0uJJYQdNZozQt9wUHB9ys+nKpwpTrWnSKK8AdI?=
 =?us-ascii?Q?7DjcDZ7rqMxiwr6IF1v1lNcJ1ZgqK4VFmjF5RsBzVUtpERSMIhp824CXJQhJ?=
 =?us-ascii?Q?gvBRLobW5p09i0WnSuFPOwApNGEBnX7MJkMhWYQNV9BOu0s9C6+dQj+GWhF6?=
 =?us-ascii?Q?Jgo9nLts1P9KEcRPbk7w9lgrI/prQU3y9MWNbVyZrrDFyJegvua+wMUiDV2C?=
 =?us-ascii?Q?apLXXndL1NbHkH8uzswZA0eU1I63LKZG0Pu22whEGpCusDfbh+N1IF/7SrGS?=
 =?us-ascii?Q?fpQ4XZiysoK67h0h+UCim6bCHklx43o7GnP/G0BjWQhcxMExSgcsXlWOPaP/?=
 =?us-ascii?Q?jE1OawjOsyIqGfxxU6T8aLBXwHMGh1CR6KQyfT2h8ccZKCk+3fqf+TzpyaB8?=
 =?us-ascii?Q?DV9CYwqNJ6s978vyu69ABKjJ9W3niedMgXyas1SteIbZMriLi8yhQ6ONR3zt?=
 =?us-ascii?Q?eF6uSe9j5XFf15HEfM/CHs3q4LzdgPZmBR6AqH80u5xoE05S6NtDcJL8l10F?=
 =?us-ascii?Q?yc/dijL7Tq0rJnl7FUEvTBhffX7OA66JxXkWjsw6kFLoBhDWJ7nNPl0O0baU?=
 =?us-ascii?Q?HIroOsyOWSHCtSX8o4zEa1Jr5y7h+QCaZ9AJAaXxrF0hBN7sQbvn1EurxwDI?=
 =?us-ascii?Q?wO7TGEECRvlsjTywLLGsAmUNIoG0oQ/iK7AbPoZoMwtKFcGMG0m6WEL1OafX?=
 =?us-ascii?Q?ao7EWOPauL0ngPJilanC8rQhIhG8RBHAQeVjvw/0EfsBQzTcN5yz8LiH/RVa?=
 =?us-ascii?Q?jVH2Mo4822aOt3RgvtOTCN484ILnAMdXgiZF722cH4aE9iT2+Cq6dZDHLU/c?=
 =?us-ascii?Q?S/FV6kmX0P613aGzQBiaFgNbNyF3YhnGxN9KVLxKMfBrblRJRmLX51k0IZCm?=
 =?us-ascii?Q?7f/HNblb3ogQpTPkiIUMaiQyxoOz9N4TwpA/vfCpm3rF76P9Prr8A2pf5iJl?=
 =?us-ascii?Q?m5fAMPRRx8eIh8thmFLFVyuFteHvo8AtJDaSSrWM6RB7EpVumDYYkLK+QX9q?=
 =?us-ascii?Q?sh74VvWJqYV8yi2DPKvFlDndhMnQYYCHEFmlp83Td1LPOWwcHD772GBqj2HK?=
 =?us-ascii?Q?II8HmpCle8tbq4yAVZZ6r/1UWNpUIHIjzqV44aZ59zQmlkSMF+L5p4vE+wH+?=
 =?us-ascii?Q?6bRIvrwECs2/lPiyKRmLRz5dSjoJpEpWJLbXQI/XSUqdxxjU7CsZ8jPbzM41?=
 =?us-ascii?Q?CMfGUW1HnPI4gZqZdzkIcKGOtQUHwycr8EVfaiJKr8fbxhOfHzjH9YLdGQPq?=
 =?us-ascii?Q?3Mi+7tS0/Tl6HXyNYRwUSR3F/PBp8pMgPprXZpAuYI6GrkWMcgNuNLzTazMU?=
 =?us-ascii?Q?Mh97X54Y52hZenZMMzMY6z4r9bAydvZQdIQ/bqwNG+8n+qjdQPHnMYluNv8x?=
 =?us-ascii?Q?ojcsbNMtVwHisaDGXFE6VOohbESKxZljhu4QzEDmaxipGMxTBvj22Wqhki4c?=
 =?us-ascii?Q?yaqlSK7dBh71MYeK2cf9ycllmU7stj5tnrv0tz9knOa27HEf90GZ/Y5o9i4D?=
 =?us-ascii?Q?OuyRYxodS4mNyDhTE3hfYCNl9c67s3M+MILH5gdDYnCB7ltX3Jf1LgosJ9uD?=
 =?us-ascii?Q?AghEww=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pNysskSZ8cUSDa2fW2p2GfrFY4jjIh4jz+c78GsmHVwSTQ+hYvlo2n1bgw9HoTEEjk50xXoriRz3RB58l9TJYPn6HnqeblaTy7jUYulhxtoaKioDcm9wMnm08ekU8EAgdRfr/deHFk2I3bBLdnnzp7MnfbGEIzo8TUsW/DnInfGfbDGfGkzL749Y0Ca1DkDXZh+iyhTUAFvjVhA3HOlG7OWLHL9ZjI5OW679YlPXuDmto7SYpJMjI0/LhUKLlHS9TGEre7jnJwVU2/ZtJyxW61Iz2m5Z7yXjYSYA4pnLTBj5gxy30NPimwMwVKGCEOCztEOzA9WEN1lA6moK+6oAkepYgRuqeM/Onms6/pZlWQVx2H7S8V+1/DGT9FEPKO12fCfU80Qlic87o97Zlvieo0SOXKjpcWitRX9c/XiNl8t/VJJSW/RRsoYZmwOJadqU
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:32.8250
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e76e54c-4bbe-4606-b0ac-08de72f3f9f9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000099.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8225
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
	TAGGED_FROM(0.00)[bounces-71481-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,nvidia.com:mid,nvidia.com:email];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 3795C17941C
X-Rspamd-Action: no action

From: Ankit Agrawal <ankita@nvidia.com>

The Extended GPU Memory (EGM) feature enables the GPU access to
the system memory across sockets and physical systems on the
Grace Hopper and Grace Blackwell systems. When the feature is
enabled through SBIOS, part of the system memory is made available
to the GPU for access through EGM path.

The EGM functionality is separate and largely independent from the
core GPU device functionality. However, the EGM region information
of base SPA and size is associated with the GPU on the ACPI tables.
An architecture wih EGM represented as an auxiliary device suits well
in this context.

The parent GPU device creates an EGM auxiliary device to be managed
independently by an auxiliary EGM driver. The EGM region information
is kept as part of the shared struct nvgrace_egm_dev along with the
auxiliary device handle.

Each socket has a separate EGM region and hence a multi-socket system
have multiple EGM regions. Each EGM region has a separate nvgrace_egm_dev
and the nvgrace-gpu keeps the EGM regions as part of a list.

Note that EGM is an optional feature enabled through SBIOS. The EGM
properties are only populated in ACPI tables if the feature is enabled;
they are absent otherwise. The absence of the properties is thus not
considered fatal. The presence of improper set of values however are
considered fatal.

It is also noteworthy that there may also be multiple GPUs present per
socket and have duplicate EGM region information with them. Make sure
the duplicate data does not get added.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 MAINTAINERS                            |  5 +-
 drivers/vfio/pci/nvgrace-gpu/Makefile  |  2 +-
 drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 61 +++++++++++++++++++++
 drivers/vfio/pci/nvgrace-gpu/egm_dev.h | 17 ++++++
 drivers/vfio/pci/nvgrace-gpu/main.c    | 76 +++++++++++++++++++++++++-
 include/linux/nvgrace-egm.h            | 23 ++++++++
 6 files changed, 181 insertions(+), 3 deletions(-)
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm_dev.c
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm_dev.h
 create mode 100644 include/linux/nvgrace-egm.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 765ad2daa218..5b3d86de9ec0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27379,7 +27379,10 @@ VFIO NVIDIA GRACE GPU DRIVER
 M:	Ankit Agrawal <ankita@nvidia.com>
 L:	kvm@vger.kernel.org
 S:	Supported
-F:	drivers/vfio/pci/nvgrace-gpu/
+F:	drivers/vfio/pci/nvgrace-gpu/egm_dev.c
+F:	drivers/vfio/pci/nvgrace-gpu/egm_dev.h
+F:	drivers/vfio/pci/nvgrace-gpu/main.c
+F:	include/linux/nvgrace-egm.h
 
 VFIO PCI DEVICE SPECIFIC DRIVERS
 R:	Jason Gunthorpe <jgg@nvidia.com>
diff --git a/drivers/vfio/pci/nvgrace-gpu/Makefile b/drivers/vfio/pci/nvgrace-gpu/Makefile
index 3ca8c187897a..e72cc6739ef8 100644
--- a/drivers/vfio/pci/nvgrace-gpu/Makefile
+++ b/drivers/vfio/pci/nvgrace-gpu/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu-vfio-pci.o
-nvgrace-gpu-vfio-pci-y := main.o
+nvgrace-gpu-vfio-pci-y := main.o egm_dev.o
diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
new file mode 100644
index 000000000000..faf658723f7a
--- /dev/null
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/vfio_pci_core.h>
+#include "egm_dev.h"
+
+/*
+ * Determine if the EGM feature is enabled. If disabled, there
+ * will be no EGM properties populated in the ACPI tables and this
+ * fetch would fail.
+ */
+int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm)
+{
+	return device_property_read_u64(&pdev->dev, "nvidia,egm-pxm",
+					pegmpxm);
+}
+
+static void nvgrace_gpu_release_aux_device(struct device *device)
+{
+	struct auxiliary_device *aux_dev = container_of(device, struct auxiliary_device, dev);
+	struct nvgrace_egm_dev *egm_dev = container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
+
+	kvfree(egm_dev);
+}
+
+struct nvgrace_egm_dev *
+nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
+			      u64 egmpxm)
+{
+	struct nvgrace_egm_dev *egm_dev;
+	int ret;
+
+	egm_dev = kzalloc(sizeof(*egm_dev), GFP_KERNEL);
+	if (!egm_dev)
+		goto create_err;
+
+	egm_dev->egmpxm = egmpxm;
+	egm_dev->aux_dev.id = egmpxm;
+	egm_dev->aux_dev.name = name;
+	egm_dev->aux_dev.dev.release = nvgrace_gpu_release_aux_device;
+	egm_dev->aux_dev.dev.parent = &pdev->dev;
+
+	ret = auxiliary_device_init(&egm_dev->aux_dev);
+	if (ret)
+		goto free_dev;
+
+	ret = auxiliary_device_add(&egm_dev->aux_dev);
+	if (ret) {
+		auxiliary_device_uninit(&egm_dev->aux_dev);
+		goto free_dev;
+	}
+
+	return egm_dev;
+
+free_dev:
+	kvfree(egm_dev);
+create_err:
+	return NULL;
+}
diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
new file mode 100644
index 000000000000..c00f5288f4e7
--- /dev/null
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#ifndef EGM_DEV_H
+#define EGM_DEV_H
+
+#include <linux/nvgrace-egm.h>
+
+int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm);
+
+struct nvgrace_egm_dev *
+nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
+			      u64 egmphys);
+
+#endif /* EGM_DEV_H */
diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 7c4d51f5c701..23028e6e7192 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -10,6 +10,8 @@
 #include <linux/pci-p2pdma.h>
 #include <linux/pm_runtime.h>
 #include <linux/memory-failure.h>
+#include <linux/nvgrace-egm.h>
+#include "egm_dev.h"
 
 /*
  * The device memory usable to the workloads running in the VM is cached
@@ -66,6 +68,68 @@ struct nvgrace_gpu_pci_core_device {
 	bool reset_done;
 };
 
+/*
+ * Track egm device lists. Note that there is one device per socket.
+ * All the GPUs belonging to the same sockets are associated with
+ * the EGM device for that socket.
+ */
+static struct list_head egm_dev_list;
+
+static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
+{
+	struct nvgrace_egm_dev_entry *egm_entry;
+	u64 egmpxm;
+	int ret = 0;
+
+	/*
+	 * EGM is an optional feature enabled in SBIOS. If disabled, there
+	 * will be no EGM properties populated in the ACPI tables and this
+	 * fetch would fail. Treat this failure as non-fatal and return
+	 * early.
+	 */
+	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
+		goto exit;
+
+	egm_entry = kzalloc(sizeof(*egm_entry), GFP_KERNEL);
+	if (!egm_entry)
+		return -ENOMEM;
+
+	egm_entry->egm_dev =
+		nvgrace_gpu_create_aux_device(pdev, NVGRACE_EGM_DEV_NAME,
+					      egmpxm);
+	if (!egm_entry->egm_dev) {
+		kvfree(egm_entry);
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	list_add_tail(&egm_entry->list, &egm_dev_list);
+
+exit:
+	return ret;
+}
+
+static void nvgrace_gpu_destroy_egm_aux_device(struct pci_dev *pdev)
+{
+	struct nvgrace_egm_dev_entry *egm_entry, *temp_egm_entry;
+	u64 egmpxm;
+
+	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
+		return;
+
+	list_for_each_entry_safe(egm_entry, temp_egm_entry, &egm_dev_list, list) {
+		/*
+		 * Free the EGM region corresponding to the input GPU
+		 * device.
+		 */
+		if (egm_entry->egm_dev->egmpxm == egmpxm) {
+			auxiliary_device_destroy(&egm_entry->egm_dev->aux_dev);
+			list_del(&egm_entry->list);
+			kvfree(egm_entry);
+		}
+	}
+}
+
 static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
 {
 	struct nvgrace_gpu_pci_core_device *nvdev =
@@ -1212,6 +1276,11 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 						    memphys, memlength);
 		if (ret)
 			goto out_put_vdev;
+
+		ret = nvgrace_gpu_create_egm_aux_device(pdev);
+		if (ret)
+			goto out_put_vdev;
+
 		nvdev->core_device.pci_ops = &nvgrace_gpu_pci_dev_ops;
 	} else {
 		nvdev->core_device.pci_ops = &nvgrace_gpu_pci_dev_core_ops;
@@ -1219,10 +1288,12 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 
 	ret = vfio_pci_core_register_device(&nvdev->core_device);
 	if (ret)
-		goto out_put_vdev;
+		goto out_reg;
 
 	return ret;
 
+out_reg:
+	nvgrace_gpu_destroy_egm_aux_device(pdev);
 out_put_vdev:
 	vfio_put_device(&nvdev->core_device.vdev);
 	return ret;
@@ -1232,6 +1303,7 @@ static void nvgrace_gpu_remove(struct pci_dev *pdev)
 {
 	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
 
+	nvgrace_gpu_destroy_egm_aux_device(pdev);
 	vfio_pci_core_unregister_device(core_device);
 	vfio_put_device(&core_device->vdev);
 }
@@ -1289,6 +1361,8 @@ static struct pci_driver nvgrace_gpu_vfio_pci_driver = {
 
 static int __init nvgrace_gpu_vfio_pci_init(void)
 {
+	INIT_LIST_HEAD(&egm_dev_list);
+
 	return pci_register_driver(&nvgrace_gpu_vfio_pci_driver);
 }
 module_init(nvgrace_gpu_vfio_pci_init);
diff --git a/include/linux/nvgrace-egm.h b/include/linux/nvgrace-egm.h
new file mode 100644
index 000000000000..9575d4ad4338
--- /dev/null
+++ b/include/linux/nvgrace-egm.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#ifndef NVGRACE_EGM_H
+#define NVGRACE_EGM_H
+
+#include <linux/auxiliary_bus.h>
+
+#define NVGRACE_EGM_DEV_NAME "egm"
+
+struct nvgrace_egm_dev {
+	struct auxiliary_device aux_dev;
+	u64 egmpxm;
+};
+
+struct nvgrace_egm_dev_entry {
+	struct list_head list;
+	struct nvgrace_egm_dev *egm_dev;
+};
+
+#endif /* NVGRACE_EGM_H */
-- 
2.34.1



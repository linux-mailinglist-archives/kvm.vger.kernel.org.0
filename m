Return-Path: <kvm+bounces-71485-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8GhfAXR5nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71485-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:59:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9446B17939E
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:59:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EB70B314B86E
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B66413101C8;
	Mon, 23 Feb 2026 15:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cYBvgsSl"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012046.outbound.protection.outlook.com [40.107.209.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185162BF00A;
	Mon, 23 Feb 2026 15:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862149; cv=fail; b=a63K5mgUsNY7qUWul9Dd2jGzVZiPmIWUBqaMmK7LYLDYiiOhr8JMSY3Xh8m4wyWBl/H5NkuLmM9KcIi3QbtRlyOU7eZf/bzUColc1GBsjx1OwtchmTeXJG4C5tibeyYFAhafGa5jzES2SgQ4CLV0ebm0mQ4vN0YtFK3knCFngg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862149; c=relaxed/simple;
	bh=/48JkPGcwYBVGJOYTLgYwFZd9pzXcL3Lr8tqCuQndi8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bnN3a8N8cNbHh5RG6miXrmT21MvSIP9qErnqP/VZK2bKUOHBoQwmqM10u3fqDM7Abdg8ZsthzljDK5dspsja6QHVHw1I/leVmV22oax4TrtC3VBreD/rPAtHKnDGAvc1+0NaWmqSFhYt9jD4D5TAYDC0jif/ad70hWbdgOgtqNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cYBvgsSl; arc=fail smtp.client-ip=40.107.209.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YLzSMnYXGggcINqI7+e/7u+1Eo407M7vZL6dZ6Mg2iiA5f1y/IlrLv1oKpM6UpFQDMrsLRBYWGpj2S0esJqfiKYDsqpXZE5Hascaqd1zOK/G35XppuVuTl1EHd7RyryhBEMjOddmXDD/hZ7GeLr6ycbkRnXeRsLrh5R3oOeB3/1Vk03iJFZxvc1JRmSZI6rln4Q4we0FrOS15meN+pc5Mmu1VTykJt5Y564O2jiH7QJuxNw9CV/FpY5JdNq7Kw76URy9Jr4P16MLoK2lgaPM+Zf1hKKcpi/m+4YDYBHT5NBr9fbl543+KHnLCLIoId/RpGNeYHOfN1SAISFsjMbF7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPvQL6+3OunCG9gwbeHmCGLE+4Uf9UnBCcYpn28wJ1o=;
 b=o7kPre/jHOWpV24HPnXixnmlwfYKzeMRGs4JjN70h9NguwXU+iePpwAKhEpkXFgzDnD+3BI3se7n3RDa9WAukbCcn56kiHad12UkyntP44TGVbPdPXCD6m1R2ZVhkeuydS2o83DXsuSnMqvlooiieQEK099euXAegWT3IGUIrrsZCQMnldWqKrInaHoCoZFrbRa1FLNWwPaEuHGDuBJaPsV1L4VUPOfKeuNeg9s6R7xSodf+8DxBcrN3hvMdWTMG//ztMFEufozmBdeXQ7RK3hMtk6RL76t2KiKsdv3qFGdo/ZajgSlQuWge9R8Looc9EKrjMHTpKiIUvGzneJ+wwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPvQL6+3OunCG9gwbeHmCGLE+4Uf9UnBCcYpn28wJ1o=;
 b=cYBvgsSl/CBD9Xamc3NPa2vCQcDiRV7cHEEC6lDbk30IbPkBzjfIEzQqb8clqNOzTZMGodzU5aEgkHUZLEfeg4mHt5wF9HlwQnprlcntU9X7KC/R71ePaxkLddwi7O3TSrZZVpkmzeSoM0jnAfDqOzbu0ldB52IPsSDMWXW/Y34OCJOSYCtSpB9rZV0b0BEGkmAkgzUGLOtRsP1gDT4Sjr4QdgwxISdzmCnZJ1EsBx/XUdDrVyxgj9qNUno8QYsigx5hCJ0pT+HJrWwXu1AS/HLfGr+SH2eDCp8FTcS4bIB6HH2P6DCJSkkM7aolZDY5FFmp1jK3O7j7y+U2uiv1vQ==
Received: from DM6PR14CA0070.namprd14.prod.outlook.com (2603:10b6:5:18f::47)
 by DM4PR12MB6109.namprd12.prod.outlook.com (2603:10b6:8:ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 15:55:40 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:5:18f:cafe::3b) by DM6PR14CA0070.outlook.office365.com
 (2603:10b6:5:18f::47) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 15:55:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 15:55:40 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 07:55:21 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 23 Feb 2026 07:55:20 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 07:55:20 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 14/15] vfio/nvgrace-gpu: Add link from pci to EGM
Date: Mon, 23 Feb 2026 15:55:13 +0000
Message-ID: <20260223155514.152435-15-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260223155514.152435-1-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|DM4PR12MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a424ccd-d7b0-4496-3380-08de72f3fe52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RStEaWREYktQcnZuelY2UjM4MzBvdUszTVNCb2RhUFU0VFhhYnI3T1I3N3NU?=
 =?utf-8?B?Z3lyWUlqK29oa0k1Nm1FZnlHSmQxVUgxNWxjN1Q1VENvL2VNRkgzWGNzWGtt?=
 =?utf-8?B?aUlSMWdyWHZzckVjNkRkOGZ2emdmL1pZVTFBTlo5UVB6RE0xQVBTNjUyUHNj?=
 =?utf-8?B?MW5RbExvRmw2OHRGZ3hEbXVWTzdHbVVGZkVUV0RDSDBmNmhZbDdPZXZCbGdR?=
 =?utf-8?B?UFY1M1Z6RlFvVlZPOThzNkNYcjlDcVhvbjVja1VoUjFPdm04R0lHcnNYQ3My?=
 =?utf-8?B?SXhGbVZMSEYwVWx3NTZFNzBYRnFEc1hJY0VYZnA3Z0JjbUZkQXlMbG53dVBR?=
 =?utf-8?B?QWlwNXF5czU1Ym1tUHRrOTVHdldvbFJIN0xnSVJFeUhDNzNOd2JTWlR1SzRz?=
 =?utf-8?B?L1k0dUJRR1hyd01RaFNOVDlwQnd0amVReENuK2ZvM3Jmd1daMFVuekVWdTBq?=
 =?utf-8?B?c0pqNk54QmJOSnpkS2IzR0hQeTYrNWUrcyt2cU5uQTMwZVFReWtuRUh3N29Z?=
 =?utf-8?B?REpaRkZxaXNIdWw1TmV3Q2VzWElRNVhrNHhtVnlxSUdEWnpxQjlkUXEwTm1D?=
 =?utf-8?B?enhxZmhhZFVXZnFsQ0IzSjhzWFRzUjhXYmVmd2Q1Q09uZ2FYaUJqa1orS05n?=
 =?utf-8?B?RnlId2lJYmo5REQrcTdLTHF2d2t4Y1FRaS9JeHc3SnZXYnB1U3p6VzFRSTYw?=
 =?utf-8?B?SHpGTG5aM1lRa0cyTTBCTkV0SmFBajNhSXB5LzIrUSt4OURXeURXVHFxMjZ2?=
 =?utf-8?B?NzdtYTIvRTRYZ3hIUTdYNExZU2RLRHBjNWVyYUxUa3JPTHducXNEUERyKytU?=
 =?utf-8?B?WDVyYVFqMVNQNEV4OTJKS25HTzBlTnpLVHVsYW1SVnlkUGc1TlRDcUdHc2tW?=
 =?utf-8?B?ZU50eERwcUZZQXhzZzJZYUpVR1M1YnZVZkFXTUpDcHZ6ZlRmU3AwaHJtZElL?=
 =?utf-8?B?MzU2R2tJVjhtUVUvYmEwclQyQ1N5bE1wYW1BZFZpSEdEOTlSYWJnSWJkYnZj?=
 =?utf-8?B?bExYVkhwRFFOZ3NtTWlpYkpHWXMvOXQ0Zi9oWHFYaStjWUZ1bDkvY0c2Rko4?=
 =?utf-8?B?YlR1WjlWQ0lFL015VkN5OW45ck45Q3U2UHpQOVNCd29meTlMM1I4ZVZUVXcx?=
 =?utf-8?B?eE5tdE5tSWdjWmlGU3NmWGtUR2JtRmJQbE1TQlZOTzV4L1NqV2s3dDFrQlAv?=
 =?utf-8?B?bnRpUXUvSFpnY3Q3M2w1Vy9XZ1VSbW1XbUF5TFNtNnVFVmJzZXBvS0E4RTJQ?=
 =?utf-8?B?aDN0aFBSTjVoM1VBSzRqalVqQ2svME96d1cxTWQxNFg2RTE2UWhiKzVybDJR?=
 =?utf-8?B?bkVEanRiSUR1YnNwTmxyTDFQNngrYWUwamo5OGFwN1QvaTlwL290V1BNdy9Z?=
 =?utf-8?B?THgvYWhXYmU4c2dYWDhZMUZKeFYvU2hLTisxNUFmdjZPRVArODM0Q1N1RGlK?=
 =?utf-8?B?a2lHOXpYQ25YS2NXazZ2a3g1TVdRclZSYWcvWHhQTzVBTUJYOG5VZWZPMndK?=
 =?utf-8?B?MkplendFWXZuSFRsaUhVdVc4dW80aVBJWHI4SXU3R3RZb000TmdaRjVoSEZM?=
 =?utf-8?B?aUxYU04xeUhhMnZiU3R5SHpnY3JwdDZyK2Jld0NCc29jQ2dTdk1QMUhtY2VM?=
 =?utf-8?B?YjVSVTFTY2Jjbkx3TXhBNkVtUXYyMEhNdWJtYXVua1BUOHRZR3BYZXo3d280?=
 =?utf-8?B?WjFyNDVIUDFkMENXY0tuUVlQV2xHZ3JaZTZrNG9vbmFzVmtzaDFhWXBPaTlr?=
 =?utf-8?B?NEtxWHFXSUJxVzF6UHF3LzdUaHNwbkFpOUY0Q0R3NSttcE56RGRRU3lBbmo1?=
 =?utf-8?B?b2ZYTGIwaDczaDNMdm0xU29IV0VTaHcwdmVOYUdlcGxRaEZzOWhTcFZzbDJp?=
 =?utf-8?B?dG1iMnJxRFVPZUhXZ3dFQWVLVzVVekpYZ3FjbVZlTXRtSXhza3NlRndDL3dW?=
 =?utf-8?B?U3RPOUZJMFgzeVBnR05lOTc1YVc5M2FFczNQRjl5VVhxdUFNQUFUYTYycHZY?=
 =?utf-8?B?a3ZOMy8rV1R0eCtFL3FpUVl6VGhQNXNoMXpXS0FuaDZFeFFSSEV6dmxVOTZz?=
 =?utf-8?B?VWdITEdmeHBGRzQ4RmZxeUFVWFFWOXdxOXQzUUR2bnBVc3ZVem1KOVhnWGJt?=
 =?utf-8?B?UFd0czVBc2RrdnRRYlFnM21lMnFUMGtXQXJoVENHaXBiTE5jYjBLOWh0aTlq?=
 =?utf-8?B?VWlUNm9SRmRwS29Rb21xM1pERzAzcEFtVEUyWW1wMFpydi9DUHd0VnZhZ2ti?=
 =?utf-8?B?TTZpdmF6K0hCdzYvUjZXQXpSN3dBPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	be/Yg1wsjyzR4JuddN/+CnbTDht/6taQ/OhWqpHTqQDAX0lU6RiS5ZnRTHO3Wd4qPzxiO+nyYJ4Kwec72urXI8VrK4FJtm6Whz3WPV2M+gXvls69D+mYyEdRTJNYbpwwyzqOUSCrtjDCd6GHBlQM9a6FBMyLbu5ITkSGyYgcrN8k0roxPwCJHoTSoLcSsWB+4CrEgq3UaWgGft+ZfnX5fO64qEXzcDCx/saHqkZoHSONASv9nAJTKekyCd0Da9+WqLCh40Nmf0A8tETeyb0XIWHLX1MuFI3k9X8wKcquLWR+tAIPeSKggo2KdHKRZxod0WA2YFNKky+rW7ZQ/BZ7iYyJwxH4lTtZpAD+ZWGMCDM/bIcvk6Kn9CR6ZKdNHEB14JzKlWLVA1v4ZpHqfUQm8DlvMuXBpNiFTFONE719aBUswW+7AyflGPDZvCR8AwjZ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:40.1317
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a424ccd-d7b0-4496-3380-08de72f3fe52
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6109
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71485-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:mid,nvidia.com:email];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 9446B17939E
X-Rspamd-Action: no action

From: Ankit Agrawal <ankita@nvidia.com>

To replicate the host EGM topology in the VM in terms of
the GPU affinity, the userspace need to be aware of which
GPUs belong to the same socket as the EGM region.

Expose the list of GPUs associated with an EGM region
through sysfs. The list can be queried from the auxiliary
device path.

On a 2-socket, 4 GPU Grace Blackwell setup, the GPUs shows
up at /sys/class/egm/egmX.

E.g. ls /sys/class/egm/egm4/
0008:01:00.0  0009:01:00.0  dev  device  egm_size  power  subsystem  uevent

Suggested-by: Matthew R. Ochs <mochs@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 47 +++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
index 6d716c3a3257..3bdd5bb41e1b 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
@@ -56,6 +56,50 @@ int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
 	return ret;
 }
 
+static struct device *egm_find_chardev(struct nvgrace_egm_dev *egm_dev)
+{
+	char name[32] = { 0 };
+
+	scnprintf(name, sizeof(name), "egm%lld", egm_dev->egmpxm);
+	return device_find_child_by_name(&egm_dev->aux_dev.dev, name);
+}
+
+static int nvgrace_egm_create_gpu_links(struct nvgrace_egm_dev *egm_dev,
+					struct pci_dev *pdev)
+{
+	struct device *chardev_dev = egm_find_chardev(egm_dev);
+	int ret;
+
+	if (!chardev_dev)
+		return 0;
+
+	ret = sysfs_create_link(&chardev_dev->kobj,
+				&pdev->dev.kobj,
+				dev_name(&pdev->dev));
+
+	put_device(chardev_dev);
+
+	if (ret && ret != -EEXIST)
+		return ret;
+
+	return 0;
+}
+
+static void remove_egm_symlinks(struct nvgrace_egm_dev *egm_dev,
+				struct pci_dev *pdev)
+{
+	struct device *chardev_dev;
+
+	chardev_dev = egm_find_chardev(egm_dev);
+	if (!chardev_dev)
+		return;
+
+	sysfs_remove_link(&chardev_dev->kobj,
+			  dev_name(&pdev->dev));
+
+	put_device(chardev_dev);
+}
+
 int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
 {
 	struct gpu_node *node;
@@ -68,7 +112,7 @@ int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
 
 	list_add_tail(&node->list, &egm_dev->gpus);
 
-	return 0;
+	return nvgrace_egm_create_gpu_links(egm_dev, pdev);
 }
 
 void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
@@ -77,6 +121,7 @@ void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
 
 	list_for_each_entry_safe(node, tmp, &egm_dev->gpus, list) {
 		if (node->pdev == pdev) {
+			remove_egm_symlinks(egm_dev, pdev);
 			list_del(&node->list);
 			kfree(node);
 		}
-- 
2.34.1



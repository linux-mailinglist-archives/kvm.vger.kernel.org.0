Return-Path: <kvm+bounces-71480-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iFACOeh4nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71480-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:57:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A8B01792FA
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:57:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EE12330DB74F
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6E8030CD92;
	Mon, 23 Feb 2026 15:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XnHiaNcs"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010012.outbound.protection.outlook.com [52.101.201.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E0828C869;
	Mon, 23 Feb 2026 15:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862141; cv=fail; b=SUgDG8y8pa1JtJKVgu0CdNR4Zme/qGLCRwqnb6iJ2v4RyaWO8b9d/bhNjWHAm5GDtSx9vLFCLBG12O0xfncAKdj9qVP4k6Pct0AipqA1UYcFa9A+SQORDUvRPvbuWSy9MTMHAIaouLI7u3+d5XYcDNshvz5LzIIJWcYWonMGZRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862141; c=relaxed/simple;
	bh=eE77p/uPBz8bzbo1g3X5zq4YjVNOu+3Z4h4UsYY1V6Q=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KtDA1OH1fZAV4pdoU+D7v97Uu6IF75izhE/xLsy4ns98LG3jwqXorQtXsWjHiSWsqzIVSdJ7HZN3OnXMbeqoH2UzIN3L4MR/nP4IYnOrSGvVDa4oNPYQoDpVcVE/1EoxoKtRDQn6eZoGWk7WvSZOKS32XDHvfeeYTFjHaI1H2ws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XnHiaNcs; arc=fail smtp.client-ip=52.101.201.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hYIYvZos7pwKQ0UvU+IxTwpPoLIQk9le5lOJ273WXD+1cdSAEhTAJzW1xkvOPIH44g9UdHqrW6ZiX2A0yrS+hh6W5vvjT76bCFVx9k57Wowli8JMdOH3eBXkIfL3TOa1f+Yy2bBa7/CRIWvHYF6swpacZj867eS08S8W2o3X7Fvl4VZ8dOnj60r80fwqOggRWmaZoCa6QpIn0b00/ceTQxJFOir1UnzXcseIik6fOYGFwE+dqr9YyUnDH5YsAXksN/qKN+4LcVgD6zC+s9fnpJrbAyEkYKzEMidN9GW6w6jvJErl65+iDZZeZmI2ngQP2xPiQpQqTqCP5Kup324+cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xKsstWUNkKHeQmhrJa0BEEa/kp9idqXOqMAikvKrThU=;
 b=R7vqtI/4Up8N5kombmfh/MlsNwrPtdqkLdHNPESC7KnoBU1LUhWfyvcJq49onap2g6Z1IUGoGg3KD9R/Zt9vBdnxmZ9YZFwaHhh8XVIwXxBH76H6ZRnZnbAh9XC5wC14Tg4blV5qOAjLtJdeN52ZtZTqehqa6pojgn0voycCLmOhB6ww9Fe5trhrVpLLrsgD8bSL2Iebps3yQsR7GAKLWEQj1AzmqqPcmwJAyQ9mnhuy4GGtbsYCi3U0XQ+XoK3ZmchAfJ84U7mtjIpazOI00JyHK4s2Pf9PpY3x7VUUX5EwOATm9Wp76N4ABfmFgYjFtg2pUBkxEPyUyn/frnj4mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKsstWUNkKHeQmhrJa0BEEa/kp9idqXOqMAikvKrThU=;
 b=XnHiaNcsHXANMGAgBaG7T4Nx40V91K8CMVZlNQ6xddcAc6tjCofai0ugJ5zkTupS6Y00LucM60Jpxyg5/QjmhCcQvt9lLAe1eFGfBhp12L0FA+W1rTM8mmikqjJd30gYBL5u+IWA1cR81sw+MySLcIGwOf4Oq+4JsJZSAn98hGNd51AJL0QmjQP7OSWDYU/Zajb+7/L32Kfp3zg8UXMoGo3ADHBHS+/0Ts7QhZxms5aGXuEAgBsRnuZ++IyWCsSor6gZHl3LceLtCp2KBtpIbUJk9Dbi2CwCAPTAXlsVyzbqcyzjMoikEoMIhC8txuDBFa9LGF1XfxPSjZn0pBwN3g==
Received: from DM5PR08CA0036.namprd08.prod.outlook.com (2603:10b6:4:60::25) by
 SA0PR12MB4493.namprd12.prod.outlook.com (2603:10b6:806:72::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.21; Mon, 23 Feb 2026 15:55:32 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:4:60:cafe::7a) by DM5PR08CA0036.outlook.office365.com
 (2603:10b6:4:60::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Mon,
 23 Feb 2026 15:55:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 15:55:31 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 07:55:15 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 23 Feb 2026 07:55:14 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 07:55:14 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 00/15] Add virtualization support for EGM
Date: Mon, 23 Feb 2026 15:54:59 +0000
Message-ID: <20260223155514.152435-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|SA0PR12MB4493:EE_
X-MS-Office365-Filtering-Correlation-Id: c66932ef-111e-44fa-4cbe-08de72f3f95a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bUpqUmFPZEtuNjZQMXA2aWZsL1owUHdGSDZRMXJKY3VGSm1IWVd6dlNkTE5t?=
 =?utf-8?B?WWFralFXMUp1aGRmNXc4elUxVk00M0VNWXFZWUQ4NVRKWlRzM0dLMHhuOWFY?=
 =?utf-8?B?VVpzNTVWSE5KeTlKY1ltVDU5U0s5VFpUNHFkUHhiL201QVRpTTRkeStaQmQ3?=
 =?utf-8?B?T0RzcUJia1p6bmxaODJPQjR5cjBaa2dRT203OGNEWmdVQkFBa25vWlhad09i?=
 =?utf-8?B?aFhNeEkzenkwdS9BK04zSnlIYlBxK3FpNlZRQUdMQTY5cVRYUnkyV0NGajFn?=
 =?utf-8?B?bno2Ry9NQUpOc01tM2ZMOHRrQmNjN3QwbGRTMGpDUmZKbUlmc1FieEVGVTVy?=
 =?utf-8?B?NkYrYktNRXp6TCt6aTljS2pEaWVtdE8wYytHeHpXTVlPUUVXUW1adC9CYWkx?=
 =?utf-8?B?am5RTDV2OFRMTWNTYm1BWVZUTWJ1Y1pxQWowcG5meGJ3dXVPSzU5cDRaaFB2?=
 =?utf-8?B?OVRrVThDREZBalJkUTR6V0k0ZUI0UVBLSE1BUTlBRHBma3VrV1ZvZm10ZWM3?=
 =?utf-8?B?bUtTUC96Yk5TWU4vUldlb0xvekZDV292SlZGU2FjbURiWUhJOXZsMDREMlFt?=
 =?utf-8?B?cHpSMW15dndESHphL1M2Y0tXV0NLOUcyNGY1TjB5R0RNQ1ZsSWNOV0NJd0xr?=
 =?utf-8?B?OGUyVW83Yi9rSTZMelJCQ2t1UzZLQWh6cFIxVThFcEFDdjkyejJpcWJFN2VJ?=
 =?utf-8?B?Y2JOMzBLTHh4cHc3eXdPdFB5WDk4MW5wMHBaclVJUjZNTnhmemxUWW9aRkZZ?=
 =?utf-8?B?eVA2YWsvYzZocUhEdEVpcnFtaFFuOWc4MTJPc2x1VFJuMDF6QU1hRUJrQVBz?=
 =?utf-8?B?eG1ML1dIaXVuNkhqb2Z0dG1Ia01NN1hlbXVuZHpTY0srWjh2UkR6VFBBR1k1?=
 =?utf-8?B?WG13dS90aDhTSmNwQjV1SWoyMzNGZFlKNjVRZDZjSXVPcmpJZXhkc2E5dzRK?=
 =?utf-8?B?VTJ6YjhZazVnZ2ZxazhqZlpwY0NUWXkyR05CYkErdEpyZFM0WlYraE83RkMv?=
 =?utf-8?B?eW5MdzlEdE1zejBPejU3ZTVKVk9HUjRleUp5T2ZlVFEySWxKamlWdkgxNmlt?=
 =?utf-8?B?bm9Jd0VCN0hXdUJkaVFDajE5cUtHRmJQRHZMd0JGZWxVcElNelNaYVB4dE5i?=
 =?utf-8?B?VlF6eDJ0Y0E2UG5XejVYZS9mY2RraTdiTk52ZWVzZGIvYVNHYUdDYkQwRDlT?=
 =?utf-8?B?ZXJjVDNzdndJa1JVeUFpeG5qTlpYRmFIYmMwUTFpUVcxTVJKZ0d0VExlS2hL?=
 =?utf-8?B?Z2hXOFk5dnNubWQ0dWllek5JcWdnRmlzWGdGWXJqRzFTSG5zbEZZSGNaSnM5?=
 =?utf-8?B?NXU1TmlWSGNxVDRaem43OGdJU1VQZTdwTDEyOGRjZko4ODA1RzlwWVdOSzk3?=
 =?utf-8?B?a0Izbm1uY1pLaU5hS1Z1UGowMVdpTUlKNnk3azZFWlZ4UzRCaGhxczVHUTcw?=
 =?utf-8?B?WnhGMmkyMkFocVBUV1dsUVJzQmtFQjV0THVDdlRlYkZuTHNUTk1xNnhRTUQz?=
 =?utf-8?B?NXJ1LzQrN3RPR0w4L3J1QS9kcDRPb1QyazB3T3RJWmI5RElNaU41R0R5SXB2?=
 =?utf-8?B?Rk5YaWFoejBaMjZMcVJvN0JFQm5FQ2xDOFZJb1JQWWZ3bE1MaktFNDUwZnEy?=
 =?utf-8?B?MjZWazFIMkRPbXVKcDBMT1A2eHNCc2VqSE9Yd1VaOG5xc000ejNPS2lKY0VJ?=
 =?utf-8?B?U3hDZlNqK1RWbEJCWnMwS3RlL3lHaTNNNHE0WVJLRFV3dDk0eHhZdUdDY2kz?=
 =?utf-8?B?aGV1cVNXdTNGcjduaVI3SStGcnR6VE8weHVuUXRjR3F3TE4rZmhWNHF1UzNj?=
 =?utf-8?B?R0xQY204eVpxZFFRS3FxV2RHa08vdEtua3NFb1VwZ1lZUXdGNElVZ2JKT0dO?=
 =?utf-8?B?am1RL2Y3UzY0WnlaU3lxODJDQnJVRHE0N1BOcXhxQXkzZG5Gc01GM0ZWRkl3?=
 =?utf-8?B?Uk1NdFFRc01JOUowLzF4d1Y2bDJKY2RNekpObkg4RG03SXJ2UUtMTDBIQVlU?=
 =?utf-8?B?SnRTaXpLeE1KQ2pxRXRpd2ZFVHNIUEJTbnAzbnV3VU5Ld0lialRsdmtUZzZv?=
 =?utf-8?B?MkFXRXprQUJQTmJUUG9UUk11cFRsdm9IeDQxSW93ZWIyR1VSV1VGU3N4eVg2?=
 =?utf-8?B?MksrYUlFQkFXUXFLUUZoMnR0UkZIaEtRUGU4MzdzZ2FSMkVFMUtRQ0xwN0tw?=
 =?utf-8?B?Q3BVTkhMY29rQmx0NWI2SU14K3ZvZXFNazBnZk5pV0FCdGd5NGU5bGI3VTZj?=
 =?utf-8?Q?5yUU2i2CjwSe1vgtDSlx3+Elc6JGItPdwdihhNMY/g=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RMg5g/EYo9tNV4Jz9jGKW3AGGvU/F9Bw198Kr/Q+QnDLn8dFNru3GwOryJGYg45QGd6ecYNtSNsSC9+vmOvGgovXACIXKuWCyuybXZCsm34dZ+5UW1TppNPE4MP+/9Pj7l+Y7JRJ16ovdwxeV4TscA4gSOLZv4gn9s1sK4Es3ywksb/lpumzJd5shFoiaX208ybPX1rq8tlMduZrd7bEGjDVZB5jcS4BXh67P5Q8tYlNRisvGlCbGEkGb+1FuqyxvKsPGfZXU/OmxIiuegYmHfC/oz4XlTMpbJ2C8VKXzAIaa6np93ZVBv2iIvVh2e9fm5/7xrFQn998KNfamgjkOiH8uS4OjzjwB4QfrfKroKDaeKZu24QsaxEqF+pDB0oU01sHpnWa04HNUhZ7o4V5EBIeN82nhnu9Bx1iydmrZBqN4g3wqRMZBMCxpElbq7v5
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:31.7879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c66932ef-111e-44fa-4cbe-08de72f3f95a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4493
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[9];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ankita@nvidia.com,kvm@vger.kernel.org];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_FROM(0.00)[bounces-71480-lists,kvm=lfdr.de];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+]
X-Rspamd-Queue-Id: 4A8B01792FA
X-Rspamd-Action: no action

From: Ankit Agrawal <ankita@nvidia.com>

Background
----------
Grace Hopper/Blackwell systems support the Extended GPU Memory (EGM)
feature that enable the GPU to access the system memory allocations
within and across nodes through high bandwidth path. This access path
goes as: GPU <--> NVswitch <--> GPU <--> CPU. The GPU can utilize the
system memory located on the same socket or from a different socket
or even on a different node in a multi-node system [1]. This feature is
being extended to virtualization.


Design Details
--------------
EGM when enabled in the virtualization stack, the host memory
is partitioned into 2 parts: One partition for the Host OS usage
called Hypervisor region, and a second Hypervisor-Invisible (HI) region
for the VM. Only the hypervisor region is part of the host EFI map
and is thus visible to the host OS on bootup. Since the entire VM
sysmem is eligible for EGM allocations within the VM, the HI partition
is interchangeably called as EGM region in the series. This HI/EGM region
range base SPA and size is exposed through the ACPI DSDT properties.

Whilst the EGM region is accessible on the host, it is not added to
the kernel. The HI region is assigned to a VM by mapping the QEMU VMA
to the SPA using remap_pfn_range().

The following figure shows the memory map in the virtualization
environment.

|---- Sysmem ----|                  |--- GPU mem ---|  VM Memory
|                |                  |               |
|IPA <-> SPA map |                  |IPA <-> SPA map|
|                |                  |               |
|--- HI / EGM ---|-- Host Mem --|   |--- GPU mem ---|  Host Memory

The patch series introduce a new nvgrace-egm auxiliary driver module
to manage and map the HI/EGM region in the Grace Blackwell systems.
This binds to the auxiliary device created by the parent
nvgrace-gpu (in-tree module for device assignment) / nvidia-vgpu-vfio
(out-of-tree open source module for SRIOV vGPU) to manage the
EGM region for the VM. Note that there is a unique EGM region per
socket and the auxiliary device gets created for every region. The
parent module fetches the EGM region information from the ACPI
tables and populate to the data structures shared with the auxiliary
nvgrace-egm module.

nvgrace-egm module handles the following:
1. Fetch the EGM memory properties (base HPA, length, proximity domain)
from the parent device shared EGM region structure.
2. Create a char device that can be used as memory-backend-file by Qemu
for the VM and implement file operations. The char device is /dev/egmX,
where X is the PXM node ID of the EGM being mapped fetched in 1.
3. Zero the EGM memory on first device open().
4. Map the QEMU VMA to the EGM region using remap_pfn_range.
5. Cleaning up state and destroying the chardev on device unbind.
6. Handle presence of retired poisoned pages on the EGM region.

Since nvgrace-egm is an auxiliary module to the nvgrace-gpu, it is kept
in the same directory.


Implementation
--------------
Patch 1-4 makes changes to the nvgrace-gpu module to fetch the
EGM information, create auxiliary device and save the EGM region
information in the shared structures.
Path 5-10 introduce the new nvgrace-egm module to manage the EGM
region. The module implements a char device to expose the EGM to
usermode apps such as QEMU. The module does the mapping of the
QEMU VMA to the EGM SPA using remap_pfn range.
Patch 11-12 fetches the list of pages on EGM with known poisoned errors.
Patch 13-14 expose the EGM topology and size through sysfs.
Patch 15 register EGM memory to memory_handle and track runtime poison errors


Enablement
----------
The EGM mode is enabled through a flag in the SBIOS. The size of
the Hypervisor region is modifiable through a second parameter in
the SBIOS. All the remaining system memory on the host will be
invisible to the Hypervisor.


Verification
------------
Applied over v6.19-rc4 and tested using qemu repository [3]. Tested on the
Grace Blackwell platform by booting up VM, loading NVIDIA module [2] and
running nvidia-smi in the VM to check for the presence of EGM capability.

There is a dependency on iommu support for generic dmabuf exports being
worked on by Jason Gunthorpe (jgg@nvidia.com). Need to use the patch [4]
until then.


Changelog
---------
v2:
* Replaced vmalloc calls with kmalloc for small structures in multiple
  files (Shameer Kolothum)
* Updated sysfs representation of the egm nodes in 14/15 (Jason Gunthorpe)
* Split EGM memory clearing in 1G chunks to avoid softlock logs in 10/15.
* Added EGM memory registration with memory_failure in 15/15.
* Updated aux device cleanup path to fix improper sequence in 8/15
  (Shameer Kolothum)
* Range checks for remap_pfn_range in 9/15 (Jason Gunthorpe)
* Miscellaneous cleanup (Shameer Kolothum, Jason Gunthorpe)

Link: https://lore.kernel.org/all/20250904040828.319452-1-ankita@nvidia.com/ [v1]


Recognitions
------------
Many thanks to Jason Gunthorpe, Vikram Sethi, Aniket Agashe for design
suggestions and Matt Ochs, Neo Jia, Kirti Wankhede among others for the
review feedbacks.


Links
-----
Link: https://developer.nvidia.com/blog/nvidia-grace-hopper-superchip-architecture-in-depth/#extended_gpu_memory [1]
Link: https://github.com/NVIDIA/open-gpu-kernel-modules [2]
Link: https://github.com/NVIDIA/QEMU/tree/nvidia_stable-10.1 [3]
Link: https://github.com/ankita-nv/linux/commit/6f92e3ca1995d17c3dd45f3e0a074b0b5806f681 [4]


Github Branch
-------------
Link: https://github.com/ankita-nv/linux/tree/v6.19-egm-180226

Ankit Agrawal (15):
  vfio/nvgrace-gpu: Expand module_pci_driver to allow custom module init
  vfio/nvgrace-gpu: Create auxiliary device for EGM
  vfio/nvgrace-gpu: track GPUs associated with the EGM regions
  vfio/nvgrace-gpu: Introduce functions to fetch and save EGM info
  vfio/nvgrace-egm: Introduce module to manage EGM
  vfio/nvgrace-egm: Introduce egm class and register char device numbers
  vfio/nvgrace-egm: Register auxiliary driver ops
  vfio/nvgrace-egm: Expose EGM region as char device
  vfio/nvgrace-egm: Add chardev ops for EGM management
  vfio/nvgrace-egm: Clear Memory before handing out to VM
  vfio/nvgrace-egm: Fetch EGM region retired pages list
  vfio/nvgrace-egm: Introduce ioctl to share retired pages
  vfio/nvgrace-egm: expose the egm size through sysfs
  vfio/nvgrace-gpu: Add link from pci to EGM
  vfio/nvgrace-egm: register EGM PFNMAP range with memory_failure

 MAINTAINERS                            |  12 +-
 drivers/vfio/pci/nvgrace-gpu/Kconfig   |  12 +
 drivers/vfio/pci/nvgrace-gpu/Makefile  |   5 +-
 drivers/vfio/pci/nvgrace-gpu/egm.c     | 540 +++++++++++++++++++++++++
 drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 179 ++++++++
 drivers/vfio/pci/nvgrace-gpu/egm_dev.h |  24 ++
 drivers/vfio/pci/nvgrace-gpu/main.c    | 124 +++++-
 include/linux/nvgrace-egm.h            |  34 ++
 include/uapi/linux/egm.h               |  28 ++
 9 files changed, 954 insertions(+), 4 deletions(-)
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm.c
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm_dev.c
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm_dev.h
 create mode 100644 include/linux/nvgrace-egm.h
 create mode 100644 include/uapi/linux/egm.h

-- 
2.34.1



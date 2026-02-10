Return-Path: <kvm+bounces-70703-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8LufNlbVimnrOAAAu9opvQ
	(envelope-from <kvm+bounces-70703-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:51:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4159D117826
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:51:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9EA74303FFC1
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 06:46:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C8D32D439;
	Tue, 10 Feb 2026 06:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Rpg4mDoC"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010022.outbound.protection.outlook.com [52.101.61.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41EF26B0B3;
	Tue, 10 Feb 2026 06:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770706002; cv=fail; b=D5t8NqLYOA7A7mVLHG4FA4BKzr3m07o7EeqLTXSphzGTxmhuWZiguo6r4+7bgFB11n15L1LyGHbj0eN6yQQ8gN75xaHMy0BXoqfgeOoLqF/ASejJJt8rsedN0p9m62q0bxPDQDTq9ZIlbhr7nDWJbCQ/5HE28/p/eWsBVw2a98I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770706002; c=relaxed/simple;
	bh=wxPtN20p12FVHAplBl5gcM1jC1q4AjGAoPxB6c2AVjQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VpHMTsdkUfA4Zujs+Fd4gkybkkAs4Ky8EsN+iHco46DJM6LRwqML4Qbtq7LkD4ZE77Rg9qKE9Cp1v87qf4xD+WC8j6tAY/jU3UwZvZeJADWwnM3wFdwmCB/3wy2WQLqED+oa06uCkpM9AZFpdg68waIA2xRD2iB4767dIe0T9TU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Rpg4mDoC; arc=fail smtp.client-ip=52.101.61.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cxUflyQ6EO+UANm3rPh/99ZZblJ6p8gVc5Kx3id05NaNKJdt1nx1PImD5K4XMDDSoNsNhHRA3gsfgYh9A7swSDc79lmp/cxC7M0OkEJJNFmXn9gzIxszog5QxxsyKmBGhJJi/3YtdOUvjlwT9uMLY8Zbw6vT8CAHTPi37W4BEVqAr5xJPzsJwH8WD79QRMSQC1KHskeXiXLBISe4RT9hasQUb1jN4ovyLrr2dwPbphjxd713MyCcAPa34zeeNvMLd9CjoYf3IYeHVJ/0xJ+PqKlza6Qj9+ORAWG31NqWTmb8JCD694ccfrvJv28qTgmVEI0cqCdnTlU8LrYJ6aLVzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67oJR2oGiGVczQLgYktHKh9p3OKeN8/6JYAOaGycJ2M=;
 b=HA9T5OEuAwvHKV/fjJ+l0/GZ8jJxH10JiXA6F3Pyzh1jf3mLYpOS1SeRUyMIW2TmrWfptcDWMSN2WHdEb98DtYkuTsP8ZYRhhzoQAFJ2Hb4ioO7tsnh1HDeIjS88mEYcRvZ6nCFOa2+TG/FtrsEv+y4/X9LVOr2nm8Sy8rclOlI4f+AcYwR/TIngNpGPeUqYh9srzIyQ5fo7XCwuoNORaxaudi9BoDhqIbok8DCmJPwLBv7d3ZnCXmjFPGwbvcQkKYh4GZL+AW0p+PsaZUP2wEIItC6R8YwNuCx6OWX1GHiG5jRJbYBCgMNWH0L7k13gWfemhkEvD7Sp37ef3Z9HJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67oJR2oGiGVczQLgYktHKh9p3OKeN8/6JYAOaGycJ2M=;
 b=Rpg4mDoCw5srvyj9XpFiWrhziQvi2KkA6C9U05RkZnt/dCAuhIhbKXr2PSX0H0eEeFW5/HwpchUIfSqJf741+4S/0XzP9/lXo57/Aa5d29DqAqPnfjc8LbunWhFIkAKb+hWi3eylRG4rJ7oDJ3pAbaxDiupK+dCyYsIyG36BDjrXmMuO5iJlUXpKXvHzGKPdT7dptHUKu0V5HQc5nNJHvLPyLPbdoiNBhtMgKWZIWSaEM4BcMtEcg5a5UyIM2SruXQJQxkcXtXNdebjNLvYdfcrRxIaN8M9iW75E4R8XI4Uk7hZ5+Si9AvHtHSF/z57xKsEK0u3Txj72whydrDRKew==
Received: from SJ2PR07CA0006.namprd07.prod.outlook.com (2603:10b6:a03:505::18)
 by SN7PR12MB6689.namprd12.prod.outlook.com (2603:10b6:806:273::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Tue, 10 Feb
 2026 06:46:32 +0000
Received: from SJ1PEPF00002316.namprd03.prod.outlook.com
 (2603:10b6:a03:505:cafe::e4) by SJ2PR07CA0006.outlook.office365.com
 (2603:10b6:a03:505::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.8 via Frontend Transport; Tue,
 10 Feb 2026 06:46:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002316.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Tue, 10 Feb 2026 06:46:32 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 9 Feb
 2026 22:46:22 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 9 Feb
 2026 22:46:22 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Mon, 9 Feb
 2026 22:46:19 -0800
From: Gal Pressman <gal@nvidia.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Naveen N Rao <naveen@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Gal Pressman <gal@nvidia.com>
Subject: [PATCH 0/2] KVM: x86: Fix UBSAN bool warnings in module parameters
Date: Tue, 10 Feb 2026 08:46:19 +0200
Message-ID: <20260210064621.1902269-1-gal@nvidia.com>
X-Mailer: git-send-email 2.52.0
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002316:EE_|SN7PR12MB6689:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dd1c2fc-5a27-4752-cf17-08de687020b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9FKAILBtsVurfij2vCQpzMwIqVtfB20TbCff2SHKrpixGiAqlN11BQAOyeiK?=
 =?us-ascii?Q?Cvq3gdltV89aws+8VARpvJAk4aaXs7lcbsToZ1eyQJJrnWepZO8F0hv9aH8w?=
 =?us-ascii?Q?7gtBJTz1/l1IJT/NjxVATJzNY12NfG6GUrTV3U/Ix4ysmdUMrdm7yQu+h6ek?=
 =?us-ascii?Q?couRYYfEXKOBBOhGZZNnQNr4lPpHXViwiuILjqcBiAe1TVJpax1INLEEwtG7?=
 =?us-ascii?Q?ibTZ8TTfJkNMeBt6m5ntXDnYpIpMcftTTrvn4SMh6UfEFkc3xcJE1KLVr72J?=
 =?us-ascii?Q?CHsW4TUU1dH5LTjTHz71aTYTVux8DpvBv1DR367ncEHKUi+0EvReNUaUuyXn?=
 =?us-ascii?Q?HmQdj6w/TWEQ9YgI0ctWmQ/vpac+yEuOxcp/lStNNup1uSdE/RuNa8R9rsdZ?=
 =?us-ascii?Q?+BRJUpAy5ffHwiUvV6Aik4W+qYP5qjqqafXuk8+/8yZ7B2ymLz8e2dnUwjHW?=
 =?us-ascii?Q?0vB5GtBtoi0lQiEwL414efyCJN5XpHdBDXhM7+dTovVrSFdf7QDpu3Gl0PaF?=
 =?us-ascii?Q?QsiMFXLO9gdS3WN8J4vZaM5F6+ko7hZido+dsbPl4s0orAbxxY3uX6gYLrp5?=
 =?us-ascii?Q?QwpkXW9tjpWeB6OaBqdzKXKsGvdie+YjGAa7oGKqbyKNK5jpIFlEr6AXeTIq?=
 =?us-ascii?Q?Zd+4LZlZNn7tidqNcj48/btVWhwJuQVLdXLPpYmbiwWRIBNbqSFNV7Kq4JXT?=
 =?us-ascii?Q?n/fPOP41vb9mApyr6XKPpvoJPyxIVogdd2Ez4d9ZEMTjz5DiKgSdRQ4d4Vp0?=
 =?us-ascii?Q?i+4B0kc8Lyn14wk/ebdoCe9gFq3A5rPJ0ImH4qej0yKZ2KehVnoSbuTEHQ4Q?=
 =?us-ascii?Q?DguzIwZ+Q9pI/BMRatO5teNilZjjay8LM/KyP9hNpZze/+IFuwg4nrGg6nqm?=
 =?us-ascii?Q?3PT2E+xQ34EDO9n/AsMmH/3jtBZDaDGjtT8msSS9vjY+AOg14BSFWR1tMU80?=
 =?us-ascii?Q?cZFqeio0fmUeLqHCdDkaTOMpzZwfNucrvIU/eWD4vvsvVxGWJN3hDhLHzwpE?=
 =?us-ascii?Q?Y4uEGvdZ0d/wQo90jffcfTsA0RPIZ+5zuycI4pxRU4HvLJUwTNcUEac0pBql?=
 =?us-ascii?Q?MWyQpRzwUbvgeb0FqlQ8NLETwpaNu9tOeiC+ykFB0uZBWNtzYd/P47KEjfbr?=
 =?us-ascii?Q?G1bXJ1ahqeYl78v/rHAjVg2dnzunN4jMAjyLBzozgVofCOUzLVjamcQO07+W?=
 =?us-ascii?Q?Oit/MdZ4rDCsNzKaopd87SLdvpjXC3lknoHZeuovshvgSPr331Iluz19usyc?=
 =?us-ascii?Q?lJnIamT3YZUJoznEp3pXJdZqW8mDdIw6wYLnttCMhfL8hfWYIeiY+64nMqPB?=
 =?us-ascii?Q?mWIlkEnicCHz17ULRQo3T1wk3moIfyuXaMS0TmfNiY3VhCAQ6e35llkUN4rL?=
 =?us-ascii?Q?lA/bDq4Befl1hvzyUDISXOJ5qDHHFrG3/eC+NDosIyv/1mToMPc3864hzoCA?=
 =?us-ascii?Q?sr01gCGOmTDJ4W00pWOH2W+DOrAcIfLLz1xHz/ie6euLO+URCDcs99pI6TTF?=
 =?us-ascii?Q?baI+/wlFPzCfWUcMxFqPKKaxKk9Qnyl/hSEz3DWG1NwG/BQzDltBBaQqwbEY?=
 =?us-ascii?Q?qAi+tGyhSfkYb9w9G9UPUc0rE8f+bKQVSazQ2bNu2OMG6uQvegIzru6p/mX2?=
 =?us-ascii?Q?xYyGkDGORrqXSX91bHiURhV85lGWBlsb7ThZGc05womcUwXbkMTONuTLORxA?=
 =?us-ascii?Q?P1GdBJrqV030n4Xt1qieZSAW6tg=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lzKR/IRVVFLFT9L6//xoRVVqFetNQvcPsoXwjGb+u645LiiKbnHOnq54wSwDm1qBovi4ZmD/09X1eX5BXHMzmvlVEdaA9GFq1wV2ABj4Tfb0ietCLKtLb3hgKBrPgogs/JdCt86/AhfwlWmVISDJyvwIBdKawZRGdDvDqrdP6PXIXVDNVrbAX5k9GcsFR0nCxBj5jTSTNPp0HrNJtnT8QrzikIpRNDuhCD1P92AnnDpFipUqKdZ26Cws6sTEUuvSBKC1xLdsa0hj201mVCaeBS+LSCU763BJ36QTotWJlTFIn0vUZyWE2JK28i2RRlEN9JfPFaWBKo6ml8jkXGIYdw3Qf1RxazQsJocVhs7IU2tqs3rLWQZxAOhl6lzbloK7vMBbMGLCqCZniOGAGd5ph35+v+1lL0lJ97tOLhvuHLEGKFufZKJreAMx5s8XmEI7
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 06:46:32.7467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dd1c2fc-5a27-4752-cf17-08de687020b7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002316.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6689
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_FROM(0.00)[bounces-70703-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gal@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:mid,Nvidia.com:dkim];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 4159D117826
X-Rspamd-Action: no action

Several KVM module parameters use int to support a special -1 (auto)
value, but rely on param_get_bool() for the sysfs getter.
When userspace reads these parameters before the auto value is resolved,
param_get_bool() interprets the int as a bool, triggering UBSAN "load of
value 255 is not a valid value for type '_Bool'" warnings.

Fix both instances by implementing getter functions that handle the -1
case before falling through to param_get_bool().

Gal Pressman (2):
  KVM: SVM: Fix UBSAN warning when reading avic parameter
  KVM: x86/mmu: Fix UBSAN warning when reading nx_huge_pages parameter

 arch/x86/kvm/mmu/mmu.c  |  5 +++++
 arch/x86/kvm/svm/avic.c | 13 ++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

-- 
2.52.0



Return-Path: <kvm+bounces-71788-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMaMIWqLnmltWAQAu9opvQ
	(envelope-from <kvm+bounces-71788-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:40:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D5DE919212A
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:40:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A92F9305A419
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:40:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275F52DECA1;
	Wed, 25 Feb 2026 05:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WeEgeYAU"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010026.outbound.protection.outlook.com [52.101.85.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B812D949C;
	Wed, 25 Feb 2026 05:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771998044; cv=fail; b=m1WlSBgoxAMij8m9BsIuRYEmtmnKpD+sYipKPbVIIPMnNVF3Yc1zyNuHzJQeyRg9x/kUw6sh5jhxkKiwTdMeCegZfndI5W3P1zh/jgxCop3wtoRxrzJWuFN6YJ5VgFYdFJZwE0/h3zd7m3Fv/TNZ/xw83hSmdUEm12WJmtS1bps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771998044; c=relaxed/simple;
	bh=y4elLim+ekXe7XMv4YfAJmjHkdX4Jy2AZUjP3jMi3Yw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=db6B18PYNMNpQ3kExrM3NnElRyzpO97OMuHUO05iNsjQOBWS2TiLfC1F7zoNEygmOYHST6Uabw4b7wHaZzqF/bl/MuJWx0A5hwbzJloVuC1/xANNIfwcpS0k+wrzHbFJfTrbbf7lWfUN3wylo6fUZIr5MKdks65M/3tj7Ji+Ivc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WeEgeYAU; arc=fail smtp.client-ip=52.101.85.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OYEYmwBQzqfpyDEdRSlIm96WCt3K64+UiEuk9LK/cMHZn0KedWxA/8QAp5O1snlKLp263blu0Ypwvrbgu9ejl56r2ggGXicxHtvl0Uu66w1phvlrPyKjwOVBsu7llZoacZ1Er8h4U2HQccFkIN4vkYDMUjohXt290PH0dpUip4L6F5LSy3qBUOVED9UwsiC+9tR8T33+ljJygJTFOsuA0Rb6NS9cFeXQ3dhvGLrmXJD2HuvvpGAR7PZwRV/APEWcO9m0pBPtvm1V6wYHHoLuTvps3S2DLYgzLdBWUz5As9QOV9fsEyuNP+nLB7ol+hbuioID46sKq5OscknENXqskw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8P6+pQXMc3u8jCoYcMCYPSMfZcJ6nDvkJqpSuXL/15w=;
 b=XCueWDataUOSqGmJCd9gqhmugEz9GYVqaChROk7ByrjjxZwF7Ks+4HZrJhzj/b5P5+6TG637GX7oPniAw2RHrjb2Ke3NKMypi5nEYiiPn1oIxT8cMU/CrC8XHTwZM/+ATlkLtusMVgA5ElQiKdqzsQQoTMX70z3jlhwuA/ZWg7AbGIyE1uQ+7q99FtsSUY8elVAgO4PhVcOpB4GQLXrdguOPh4J+HmmU+eBTDbIeX8L3eNR3KLa4pZfbnY6TH93F1Cy4cGB1EVCDjwJC/i8hrO8rvXvMqEziA2FBLQgcQ1JeUEe3+92fUVK1aZaQjMcF2PXmVDqpqHl8/LPiDVpQdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8P6+pQXMc3u8jCoYcMCYPSMfZcJ6nDvkJqpSuXL/15w=;
 b=WeEgeYAUBzYdBcxdvbz5yFUNQna47kCpqTW5xvgeF442RiQudbsN+2qzcuQ4M883jyc3m4M0kbPfgQ0B6ZFz5KzlKBIbygRU/3EPXYLf9hffy0ojxzoxXFn3tKRS8utsJu2leoR9uPDrIWP0dvgKoNA0tWJDmEGBvHXbdoAufx0=
Received: from BLAPR03CA0088.namprd03.prod.outlook.com (2603:10b6:208:329::33)
 by CY3PR12MB9606.namprd12.prod.outlook.com (2603:10b6:930:102::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 05:40:36 +0000
Received: from BN3PEPF0000B06D.namprd21.prod.outlook.com
 (2603:10b6:208:329:cafe::d4) by BLAPR03CA0088.outlook.office365.com
 (2603:10b6:208:329::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Wed,
 25 Feb 2026 05:40:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B06D.mail.protection.outlook.com (10.167.243.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.0 via Frontend Transport; Wed, 25 Feb 2026 05:40:36 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 23:40:15 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Andy Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Bjorn Helgaas" <bhelgaas@google.com>, Dan Williams
	<dan.j.williams@intel.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>, "Mike Rapoport" <rppt@kernel.org>, Tom
 Lendacky <thomas.lendacky@amd.com>, "Ard Biesheuvel" <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>, Stefano Garzarella <sgarzare@redhat.com>, Melody Wang
	<huibo.wang@amd.com>, Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel
	<joerg.roedel@amd.com>, "Nikunj A Dadhania" <nikunj@amd.com>, Michael Roth
	<michael.roth@amd.com>, "Suravee Suthikulpanit"
	<suravee.suthikulpanit@amd.com>, Andi Kleen <ak@linux.intel.com>, Kuppuswamy
 Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, Tony Luck
	<tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Denis Efremov
	<efremov@linux.com>, Geliang Tang <geliang@kernel.org>, Piotr Gregor
	<piotrgregor@rsyncme.org>, "Michael S. Tsirkin" <mst@redhat.com>, "Alex
 Williamson" <alex@shazbot.org>, Arnd Bergmann <arnd@arndb.de>, Jesse Barnes
	<jbarnes@virtuousgeek.org>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, "Aneesh Kumar K.V (Arm)"
	<aneesh.kumar@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>, "Konrad
 Rzeszutek Wilk" <konrad.wilk@oracle.com>, Stefano Stabellini
	<sstabellini@kernel.org>, Claire Chang <tientzu@chromium.org>,
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [PATCH kernel 3/9] coco/sev-guest: Allow multiple source files in the driver
Date: Wed, 25 Feb 2026 16:37:46 +1100
Message-ID: <20260225053806.3311234-4-aik@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260225053806.3311234-1-aik@amd.com>
References: <20260225053806.3311234-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06D:EE_|CY3PR12MB9606:EE_
X-MS-Office365-Filtering-Correlation-Id: a14dc5a8-77b8-43e3-e5a1-08de7430668a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?armgCULQtlrXNZKDxPpLAg46QGqMAWEEUFtjtODydpzhwSPMiCbjrxcl/LEX?=
 =?us-ascii?Q?Dsd3Z01Yi6EOY+7XwzR+uypp/wZXCguZrKvaPLh+ciCQgT7ldW4gWHUZC8VO?=
 =?us-ascii?Q?JWFvAG3BCHM/DW6NlxDnDm//1XkVZBwotHGlQWvZEbP9nK9zNMZYFyNJFXGI?=
 =?us-ascii?Q?/uI3zTOm3X3tYcLO4e0VecRl0JF0YIgsP+xpibOXmRswRW0VnbwVJACMhQIZ?=
 =?us-ascii?Q?Z+Cyz8IHtFNxB208bZbi5LsurJyxLdeoU45JvApDoLvTranbRj4aRO8kZmEv?=
 =?us-ascii?Q?S7QGcue3/yFzZSE6w9Ih9mXaM8p/J+/PBcYC8xs/U3BE/gC/pmvTavM/74jV?=
 =?us-ascii?Q?PUKb7AxmiMTcYsQQPKlV+OFPxgQYJPMrGPZPFSxAn7H2PsGr/jbEIAjExwv2?=
 =?us-ascii?Q?7WNJA8S5uTLtR2NMdjgVtPrL+JAmlSvPRtogg/wBVMEOCqccHf1ZgdXbnraD?=
 =?us-ascii?Q?u/z6dsEwvkzzNPMhnwgI8v80N5dSRHPlD0qH+FLG0wtTFAqxoXwOXE/jMFyl?=
 =?us-ascii?Q?u7ieRJIrfsRoKwoEeyWSOcLhbcPEsGmov5n98WxD4YiFD+Sps/0eZsqoXzK/?=
 =?us-ascii?Q?gC9nlyHi19fAIr0mG3/hyFg7OlMW9B1Ww0IbLCwstinxC+mH3kCbEfnpJWuo?=
 =?us-ascii?Q?XlimJXKWM9yyC99RhepAOMVL8JKpadSSGfjyB3cq0mOLSr4+koC+VcZhDAZZ?=
 =?us-ascii?Q?Bk57C74JvrWr4qUClrLZwn/OR2fnBSRy7fv0Bt5owBfoh4gwDV5jvqMRMc/o?=
 =?us-ascii?Q?E5FTizi38GA7kSfKLWavYUHqrli409qWYe/jogq1XP9LFTfJPSQVhRgtDinV?=
 =?us-ascii?Q?5NEfrsBz1akgQZUX6R2JqX86S1yk3TArzdnMX7PnzfDzvF3mJvdcRa5IWksb?=
 =?us-ascii?Q?KlCC2/PCSujcKWooKP1nRd/AD6NR0kSdkrZDqBrA9PyAq3YFKO+RBR5hQseM?=
 =?us-ascii?Q?QLXcgM1xcGDftffgBnfLR/wUJ4m17Tb3H1nuuVVZnCFYiLLi9iFYLEg5OIVo?=
 =?us-ascii?Q?9wu13z74C+IN2Wf+v/P0cMwkeShU4LADpve2eBPWk8rxjyRioQtZVG921N2E?=
 =?us-ascii?Q?oJxEIkBqQJ3c7rF7JFtdAqIYW8MSUcSn5/pWN7of/wBe/94Tb7K0KoSi/E4R?=
 =?us-ascii?Q?MoWCAYu92Ils/5Ig/sFTmYODK9KzPKpjg5V+FZA+0j0yARIqr+9kb4HrS5iz?=
 =?us-ascii?Q?3zre/dbrwPYM/0zyMKkhFq4GUrGCxHXlKUdoxl6pL+VpqaHgpKnvuBWjJmri?=
 =?us-ascii?Q?bYsBC4fZ9jFAcff3nWIKfLGVXQ/rSm057fFKFTBr7sv/6+X9j/mr5wadQam6?=
 =?us-ascii?Q?QTeTc3SGL+IwuKvm0zfNtSGjyrzZ9nFpJTesZHyP2vGgB4wF6vZwuj2Gd+4X?=
 =?us-ascii?Q?JvKbNoCxiW7mbkV8cA0aOhhBTOf+QNN2HsY8MJCNnRLvXelAfpO1dh8R0sJB?=
 =?us-ascii?Q?OjC5qk9y99cwDdlQsow2MQqQd8ROSt3YlkoviquBbt2a9mG7rci5t3nL2URj?=
 =?us-ascii?Q?riOzHohD5geksV7xudsbADIkNNfExk4uVRS0rs1Yn0DKZnDW8AAoFokV46GX?=
 =?us-ascii?Q?mVWNsTRXqMY+qa/HeAzDah92SZ7XAazlGnNhZrQ8yY5zqgTbqLlmcLrb4PYW?=
 =?us-ascii?Q?OOeHEqFYyfz9xS0OGQ3csiBYD4oitw0mqhfIUH/Z8AVK7eVQ2/K/Idq3l1R4?=
 =?us-ascii?Q?bYryCw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QlPf8opLIXWZzv/5ERIiKGYXe577t0gk+UrGCumhzP7yn9T9e7q0ii3cCoX39Kxv/QN648ypSSgOVHAIMbcYDVZzSiqxv+MG+RO6jKprqAzNMuucGfD73eigqMI7oQz9lVRlvsAMTHfM2zI00B4t7+iUPkXOVWSdF0dcDiZjBwdeaqKka7OT9o3+gV1wW/JN5Lsw6G/SlwB/c5JuRoyNq15k0uldR7uiwhRo76K3MkKy4wXN7GzNIuXIxi8rfWKr+6UZ1fujb6Jtac2doqaT816uxjnp30sB68QcX1ICl+uk04cm0/gIyDTVz1BS15qiEDprRVhi0L/ZBmO5DoEUMiIMaP307QLbymIbKg7Jhr0lmpX93XpZXkryOMW7mEkgDmUdYYVAxPKX/XCrhVeMa6tk5k25ikyI4KMWmqGYiNJ9UBuuiCbGGB5QL2VbtoKL
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 05:40:36.0384
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a14dc5a8-77b8-43e3-e5a1-08de7430668a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9606
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71788-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_GT_50(0.00)[58];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: D5DE919212A
X-Rspamd-Action: no action

Prepare for SEV-TIO support as it is going to equal or bigger
than the existing sev_guest.c which is already 700 lines and
keeps growing.

No behavioural change expected.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/virt/coco/sev-guest/Makefile    |  3 ++-
 drivers/virt/coco/sev-guest/sev-guest.h | 16 ++++++++++++++++
 drivers/virt/coco/sev-guest/sev-guest.c | 10 ++--------
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/Makefile b/drivers/virt/coco/sev-guest/Makefile
index 63d67c27723a..9604792e0095 100644
--- a/drivers/virt/coco/sev-guest/Makefile
+++ b/drivers/virt/coco/sev-guest/Makefile
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_SEV_GUEST) += sev-guest.o
+obj-$(CONFIG_SEV_GUEST) += sev_guest.o
+sev_guest-y += sev-guest.o
diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
new file mode 100644
index 000000000000..b2a97778e635
--- /dev/null
+++ b/drivers/virt/coco/sev-guest/sev-guest.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __SEV_GUEST_H__
+#define __SEV_GUEST_H__
+
+#include <linux/miscdevice.h>
+#include <asm/sev.h>
+
+struct snp_guest_dev {
+	struct device *dev;
+	struct miscdevice misc;
+
+	struct snp_msg_desc *msg_desc;
+};
+
+#endif /* __SEV_GUEST_H__ */
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index b01ec99106cd..e1ceeab54a21 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -28,19 +28,13 @@
 #include <uapi/linux/psp-sev.h>
 
 #include <asm/svm.h>
-#include <asm/sev.h>
+
+#include "sev-guest.h"
 
 #define DEVICE_NAME	"sev-guest"
 
 #define SVSM_MAX_RETRIES		3
 
-struct snp_guest_dev {
-	struct device *dev;
-	struct miscdevice misc;
-
-	struct snp_msg_desc *msg_desc;
-};
-
 /*
  * The VMPCK ID represents the key used by the SNP guest to communicate with the
  * SEV firmware in the AMD Secure Processor (ASP, aka PSP). By default, the key
-- 
2.52.0



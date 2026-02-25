Return-Path: <kvm+bounces-71794-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mIaaAEeMnmltWAQAu9opvQ
	(envelope-from <kvm+bounces-71794-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:44:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 48F501921E0
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:44:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 99914305C289
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1550F2DEA75;
	Wed, 25 Feb 2026 05:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XLdoGDVo"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010001.outbound.protection.outlook.com [52.101.85.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC38B2C0F75;
	Wed, 25 Feb 2026 05:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771998262; cv=fail; b=mk/Dz/j3WgFWYaqOODqCCTBcfaLOO/buYa0Kagt/X5rEvaFPvG9D7AOwHOby1Ic93LA42iQ2wYQbSPW9EEAtstYmG4cHZZjLvLozxsdNCVjUscs/ok6l8+D+uvhm6S/gMRL8htwB07g9lf6ahyInRiEam6rSvn/1dYXwq0VXcSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771998262; c=relaxed/simple;
	bh=8m2UCofCjqGP3DwA71nzuh2GGX8dDRucPiL6PkCbKgQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cD2vVIsNBPH14+HFr8xo44GDgrgBu+hCWpVBuesowbbTUCY3ZsuUJcQfXQQW0rhRcBBBmKkzFKk+wDizxhDFb7VP/EEy+GeAZO6EAnOYmrQKrwdgO80jYd8aqLNxOPobcAdfJvtZeSrTJT41TZ//xMfd1YLsAKF3AM6a/0TZAqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XLdoGDVo; arc=fail smtp.client-ip=52.101.85.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ir8+EW/TU44PhjQsbVbBeNbS9DMTynSnzYDWpETCcvnUtSR13h90wexlxyLolES9IILcpdK8RWsrg/XWwEVn6xlhy68VdUtJdTWx01CnOXHy1qBLLZJYh3SOmbc/Ig/xO1z+eX+ZKctC71o/xIET/lGTDEB027d7Q4GjB6KInBqjwucKuRg9MXAmm1icwsDmdXFkLEsSwPsrg649/hYD2xAmorOoLybixg+z7WU8xVCtpf1hbx/DPjC0GA29DrjtAT3cIxM/8MtYUI0dcDGwf14t+W7J5mlArh5loaAK9jtX+o093ehLXy2PHpNuZVHealrgQkFhPeiu661fBczGnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dIQnA54gnCTyjuh5Kmoe4u2mxRSnSQedBCtvanenEVs=;
 b=ieN1ujKndc8HQ+30OK2JqxfViMRcBcu9vaxPwiI97aPTgD7POKbiMU9mnpbojrwvnf0IBo7rQvZP1l2sIen38xkyKaelSlwGcrh9sY/1F7axOWsdiecFV/PRY+DCBU59ZVCLAmaTDdvbirNS0SeKIbq4wPfB+pmIth3Az6Y58MTnif//eProU4uOPa3rlpDxvtrl+nykZFn6iqeL9OOjkRP08oHY9Ga7PPhWByQCugtv9F0+Dkht57s4aHvTbfdzndstX+nhiCBGM/4vHPVEiddg6j7cIYRxYuzKocDb0Nz+6Hg3oyLGuEokjXhXZKPYDpaqCHsiLdkOoRLijUpeew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIQnA54gnCTyjuh5Kmoe4u2mxRSnSQedBCtvanenEVs=;
 b=XLdoGDVoeHjfBpv5QhySrmfwsmB/B0deaI2z8LyYCnW/uyEVQ6xgvDdk6bpaJ9owghVxAKE0Fr4ZhF3y85pcOuunlRHSYAzUtJNkjc8uZNMTbyLzVlUIRtgIbSjZvyhlFA6IhIjo8B9sFJNXbtwl3a2ciQoWSsgP1jWtPmD5+uc=
Received: from MW4PR03CA0213.namprd03.prod.outlook.com (2603:10b6:303:b9::8)
 by BL1PR12MB5828.namprd12.prod.outlook.com (2603:10b6:208:397::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 05:44:13 +0000
Received: from CO1PEPF00012E65.namprd05.prod.outlook.com
 (2603:10b6:303:b9:cafe::41) by MW4PR03CA0213.outlook.office365.com
 (2603:10b6:303:b9::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Wed,
 25 Feb 2026 05:43:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF00012E65.mail.protection.outlook.com (10.167.249.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 25 Feb 2026 05:44:12 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 23:43:52 -0600
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
Subject: [PATCH kernel 9/9] pci: Allow encrypted MMIO mapping via sysfs
Date: Wed, 25 Feb 2026 16:37:52 +1100
Message-ID: <20260225053806.3311234-10-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E65:EE_|BL1PR12MB5828:EE_
X-MS-Office365-Filtering-Correlation-Id: fd8b043c-f391-48c9-216b-08de7430e78b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FbfWWMs/iWpOxIrmuSTAvqxKMiwl6XCn6v1AO3+F4Vz48hHhOcQjffUI83zS?=
 =?us-ascii?Q?hZmtVss6pFlibv/U3aBkdQqM2NLeHo3otGbdj5H2Zp91Z9rXjbExyLRVzo5I?=
 =?us-ascii?Q?KIFfF6M8uNgMf0qJ6nkiESYcJvHKk2WnbpPTzq8NOroRnR8OviQSaZ9rcA1D?=
 =?us-ascii?Q?Uu5XVF69Q4HSpmbx6RePoVATTj4h6iLrI4A8QXdAJ85fEx2omQi4iOZpOu/8?=
 =?us-ascii?Q?drPb5/Tki7C878P9ENBQlQpocFQ0g89I1X55wi2tbw23/4Hh9FcFx/fkf34G?=
 =?us-ascii?Q?rBtDDdzOhasMI7zRoI06DYk2cSNvJJSr89Z77RBCuQDAu7pLi8PnYU5x6fAd?=
 =?us-ascii?Q?xqfQI5Q7CdCM2yT34U77BGCyC27nySCSMheA+aP0AzwrrlWjOkP1QEXtfwah?=
 =?us-ascii?Q?63DoDq/K46QO8AJhzE0pc4z0sE9rb054QUXOvwD/TQW98e8PflnM5JoX9wLd?=
 =?us-ascii?Q?xAN9u1w4VXUCDmYdhb0QnD9EqpHXbzXGCYn8JmO7TirSeAeyl/JzVWbmuVg6?=
 =?us-ascii?Q?fbM9c1RITNyYiQh5escRTeBs3I/uvhWrlNV6abSG9zNLUMhc+ZsXuKNAwqR1?=
 =?us-ascii?Q?nPklG6vprpUmQdK70m1SQR1hVEnFg3jhd+pE54FqAnhI7AJt9eRHhTq30uJR?=
 =?us-ascii?Q?wikgOJAsC7Gj+0EeIxo4dsmHYjTGyg424BDU+CoOadnEYc+zJRtF90+4trq0?=
 =?us-ascii?Q?uKKQBn6tHvyGVjspGORrzUu1aYai7kC1/JpGeiOxMWSFlvYYlV89zCu7cTTG?=
 =?us-ascii?Q?Yp4lBaEmjU22kDoFogKAGac8eaWTwxDZvyi9AEqFaoKdJiMH9flgjS9ng9HQ?=
 =?us-ascii?Q?pIcQgWhNO+KFpkIsMQIh4Boknn9RbmNU9y9QWJGf4xuBuL1lcTUPCmW6/iKX?=
 =?us-ascii?Q?rSX877FEdGYiUmHE/HN/GTkSeg1dUu+kH84Kq1SqMST/LLbhqH/tZ6K9ZTg6?=
 =?us-ascii?Q?1tZw/oXVgX8d/Z2EEb1bylQjBEN87Uf1Mc4lDAWNtGTWcpZsnD7wIJBQfV8b?=
 =?us-ascii?Q?vX7+JCF/u0Z7oCPoa0fQQF32saFvhCzdDIGzWUqbSsiInMTL54obrYWt2vHs?=
 =?us-ascii?Q?NC/8tnTaO7yZIBZXbojym33irugT6nxj4x8qkJGagxBgrJvnOKSPkuKAUMH9?=
 =?us-ascii?Q?e3Su9xGVJLI3kQT6rho+nPOgj3sJ8yk7knYIHC8BYTvXhn5LmWh+1jKJRkY5?=
 =?us-ascii?Q?SjHjEb+HfnAwXnyaZg6pHie4ergWv/iyCWckcYt2PMwncvCJaRiAPpsv0p5u?=
 =?us-ascii?Q?17T99iaVULV/kUexGXnuDAX6ewdUm0vSQEjvf3dvuIBN4GSVPdVdyASExj2x?=
 =?us-ascii?Q?aYSAQYfS34ow+YIgSZ1z/a669ypliOedxmAclhs2XfOWm66Mn4q0XzqHU9XL?=
 =?us-ascii?Q?RYFJyyplF5yQjPAGgP2oRtaCYpImPfUJ0rjvvDWH8JLAH5nqsseHwvx/uvWX?=
 =?us-ascii?Q?f7mVDlNx31C7Unhkp1NHz1RyjFKdpjSq/asUNpEmj6ub0vMk/op0zIDF6HNv?=
 =?us-ascii?Q?n4REqymhvs+XXOxCDkooq9VGh11wI/epLbYQWMZRlINF/8EXoRaS8V/ntYTv?=
 =?us-ascii?Q?/CTvgj7x93SpTWAwYDu47DaokPytvd/G4oAhUC433COoLb0RDR0DONpPYWQp?=
 =?us-ascii?Q?pwMzuMeyN9e34fKdLfTp66WvAsTSOeMngw86dCes0vSWt5YEMRnCBme5l6bO?=
 =?us-ascii?Q?YQBIcg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ze1W3Kx9ZbDLgcj3QlovEw1KMHKpoNQIFsbsZdN+5tQb3Gj/BSjhQ7VRXKxXzksG8SmUw9o/2sl4BRn87J88TbRaVNGKQ1ucNiLjOMjaaNuMb+degFBjzqhG++2NrKI0Y0+0ISko9I0umX0Ol9+BURwq9KwbdGWu3tGtHgqSKPXupC4I+/d03wPzmy+M7Kxh8OsES4L6R3bqqzjd8r6ioTJ00PHy7rSpcgcrIH2P7MxnBtvJUs8slQaOtd5NKfAyNGhp0Xjh+h+4LYr2Yv30ZhhmgzAZNMkdekXIxsfOqHr2N4WYf+s2h7uRYB3vpWeGcfKgje7wCKgoD9Hzj4IWEJ5Db9zBkIY+32ZrxNM4oKgjpJ3iAMWwqs9KgfesxIB8jAwpfpWFGKvFMaI9gCM1xoXOEmKGYpaPKkLCokV/DulDZbSTyz3ym1XipW9ZQ0ov
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 05:44:12.3745
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd8b043c-f391-48c9-216b-08de7430e78b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E65.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5828
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
	TAGGED_FROM(0.00)[bounces-71794-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 48F501921E0
X-Rspamd-Action: no action

Add another resource#d_enc to allow mapping MMIO as
an encrypted/private region.

Unlike resourceN_wc, the node is added always as ability to
map MMIO as private depends on negotiation with the TSM which
happens quite late.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 include/linux/pci.h     |  2 +-
 drivers/pci/mmap.c      | 11 +++++++-
 drivers/pci/pci-sysfs.c | 27 +++++++++++++++-----
 drivers/pci/proc.c      |  2 +-
 4 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1a31353dc109..6e258b793278 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2217,7 +2217,7 @@ pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
  */
 int pci_mmap_resource_range(struct pci_dev *dev, int bar,
 			    struct vm_area_struct *vma,
-			    enum pci_mmap_state mmap_state, int write_combine);
+			    enum pci_mmap_state mmap_state, int write_combine, int enc);
 
 #ifndef arch_can_pci_mmap_wc
 #define arch_can_pci_mmap_wc()		0
diff --git a/drivers/pci/mmap.c b/drivers/pci/mmap.c
index 8da3347a95c4..90a8ab4753b8 100644
--- a/drivers/pci/mmap.c
+++ b/drivers/pci/mmap.c
@@ -23,7 +23,7 @@ static const struct vm_operations_struct pci_phys_vm_ops = {
 
 int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
 			    struct vm_area_struct *vma,
-			    enum pci_mmap_state mmap_state, int write_combine)
+			    enum pci_mmap_state mmap_state, int write_combine, int enc)
 {
 	unsigned long size;
 	int ret;
@@ -46,6 +46,15 @@ int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
 
 	vma->vm_ops = &pci_phys_vm_ops;
 
+	/*
+	 * Calling remap_pfn_range() directly as io_remap_pfn_range()
+	 * enforces shared mapping.
+	 */
+	if (enc)
+		return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+				       vma->vm_end - vma->vm_start,
+				       pgprot_encrypted(vma->vm_page_prot));
+
 	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 				  vma->vm_end - vma->vm_start,
 				  vma->vm_page_prot);
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 7f9237a926c2..715407eb8b15 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1104,7 +1104,7 @@ void pci_remove_legacy_files(struct pci_bus *b)
  * Use the regular PCI mapping routines to map a PCI resource into userspace.
  */
 static int pci_mmap_resource(struct kobject *kobj, const struct bin_attribute *attr,
-			     struct vm_area_struct *vma, int write_combine)
+			     struct vm_area_struct *vma, int write_combine, int enc)
 {
 	struct pci_dev *pdev = to_pci_dev(kobj_to_dev(kobj));
 	int bar = (unsigned long)attr->private;
@@ -1124,21 +1124,28 @@ static int pci_mmap_resource(struct kobject *kobj, const struct bin_attribute *a
 
 	mmap_type = res->flags & IORESOURCE_MEM ? pci_mmap_mem : pci_mmap_io;
 
-	return pci_mmap_resource_range(pdev, bar, vma, mmap_type, write_combine);
+	return pci_mmap_resource_range(pdev, bar, vma, mmap_type, write_combine, enc);
 }
 
 static int pci_mmap_resource_uc(struct file *filp, struct kobject *kobj,
 				const struct bin_attribute *attr,
 				struct vm_area_struct *vma)
 {
-	return pci_mmap_resource(kobj, attr, vma, 0);
+	return pci_mmap_resource(kobj, attr, vma, 0, 0);
 }
 
 static int pci_mmap_resource_wc(struct file *filp, struct kobject *kobj,
 				const struct bin_attribute *attr,
 				struct vm_area_struct *vma)
 {
-	return pci_mmap_resource(kobj, attr, vma, 1);
+	return pci_mmap_resource(kobj, attr, vma, 1, 0);
+}
+
+static int pci_mmap_resource_enc(struct file *filp, struct kobject *kobj,
+				 const struct bin_attribute *attr,
+				 struct vm_area_struct *vma)
+{
+	return pci_mmap_resource(kobj, attr, vma, 0, 1);
 }
 
 static ssize_t pci_resource_io(struct file *filp, struct kobject *kobj,
@@ -1232,7 +1239,7 @@ static void pci_remove_resource_files(struct pci_dev *pdev)
 	}
 }
 
-static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
+static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine, int enc)
 {
 	/* allocate attribute structure, piggyback attribute name */
 	int name_len = write_combine ? 13 : 10;
@@ -1250,6 +1257,9 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 	if (write_combine) {
 		sprintf(res_attr_name, "resource%d_wc", num);
 		res_attr->mmap = pci_mmap_resource_wc;
+	} else if (enc) {
+		sprintf(res_attr_name, "resource%d_enc", num);
+		res_attr->mmap = pci_mmap_resource_enc;
 	} else {
 		sprintf(res_attr_name, "resource%d", num);
 		if (pci_resource_flags(pdev, num) & IORESOURCE_IO) {
@@ -1310,11 +1320,14 @@ static int pci_create_resource_files(struct pci_dev *pdev)
 		if (!pci_resource_len(pdev, i))
 			continue;
 
-		retval = pci_create_attr(pdev, i, 0);
+		retval = pci_create_attr(pdev, i, 0, 0);
 		/* for prefetchable resources, create a WC mappable file */
 		if (!retval && arch_can_pci_mmap_wc() &&
 		    pdev->resource[i].flags & IORESOURCE_PREFETCH)
-			retval = pci_create_attr(pdev, i, 1);
+			retval = pci_create_attr(pdev, i, 1, 0);
+		/* Add node for private MMIO mapping */
+		if (!retval)
+			retval = pci_create_attr(pdev, i, 0, 1);
 		if (retval) {
 			pci_remove_resource_files(pdev);
 			return retval;
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 9348a0fb8084..e0c0ece7f3f5 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -288,7 +288,7 @@ static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
 	/* Adjust vm_pgoff to be the offset within the resource */
 	vma->vm_pgoff -= start >> PAGE_SHIFT;
 	ret = pci_mmap_resource_range(dev, i, vma,
-				  fpriv->mmap_state, write_combine);
+				  fpriv->mmap_state, write_combine, 0);
 	if (ret < 0)
 		return ret;
 
-- 
2.52.0



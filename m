Return-Path: <kvm+bounces-71180-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uNaNEC3LlGluHwIAu9opvQ
	(envelope-from <kvm+bounces-71180-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:10:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DDDC514FD85
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:10:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 71B663014A17
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 20:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA3EE378822;
	Tue, 17 Feb 2026 20:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eCMOPqnL"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010023.outbound.protection.outlook.com [52.101.46.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2518C29AB02;
	Tue, 17 Feb 2026 20:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771359013; cv=fail; b=SRyo3zSrAA6kpRUik/2gIWndfri0z2KoefuUWMKqeoM11rbuAQi5oUcri1owwKNUJyAb7ebTLm2ESFW7KNR4ja95efuvR7tSDxcdJFXoy6sbvS/qbR+/4KRZalFBXd0/SJ3l/npl2Zk8/TbD9VcOWATlC6t3jkKa+ylw+0flxpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771359013; c=relaxed/simple;
	bh=irm0AV/BBM+hoBfm2PertYbnFTUV630FgmgQmZQPuOs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KLDVUKcJYQ9cz2+99BecvUuz7NEI2/UqcgFy4na4U2O7UoJOTAkHnm6vHfw5kyVsFD+MaB3iPPrnPSVZAFg8W6MNqWiHXRvdQkJVA/Jh3ILbjppWUItFRXkemcD/ak2fveXVH8LcPMIttBrR0NGtb4z8w79PFk4t1n1S9nKJ0zU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eCMOPqnL; arc=fail smtp.client-ip=52.101.46.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kTA/svDaD7nP0OAolTn0ECjBItCPK33C+j7LCHvKFS9tUfAzhx8c8/kMEeQ7xmPRQ/M0AW9qMZCiibwvc6iZfYFPMxfh+hEZyjLdIhh1JztzKuA172APZUS+hJo7yzrg34Pb70MShMi4+PxxBg1Y9bjg6VtV0svSH7hZi3/72sgtYlpe8Wb/JyTv41Aj19IwLv4PP61pWeaNnt9gu8qAImvYwzIuVL2Hh/rzKLq6rSgbEYGaPwRE87Uc4E6SYWIYDT5Na1yb8+IQP9sALohiQqcE4+4OgUQvj2Lcb8FYFD5Jwx0x/BW2zGOyAnSiDIyOoqzUvCyEpk5L6YCWT01u9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6H55bDHXnN45QFYf5ocQP/NfuUwiYO7JnPmh6ik+5vk=;
 b=cOBE74p1xcLmc5yKDC/X81KSEUjbhOJEwZxA81QtrnOCSFknT4HmI7SFU0XtxHC6F9PifMK+cAr2/T4gIcMrxZnrVBRcW5PQJ6ioWk0CICksgtrjJPq94Dib5OeW9iIIC2M5D00ZTLSxyRJQojOdLAam6WMP1dQTjXHVnvjTFUvoZzfIOyuP6gtesDdpVqrSENinY6/5OyX35V0Mu767wlOxcDabiuD02cm/EYg/gRdgdyThzL0pdga0q80wVYkSwTQPrKiTbTRjhMESNMj2YN4eEFU/Fr0KZKw5DbVsXZOqHIjUrZIv8ladEItWWHrlkRP7qvZgdS++kMM0SrLZLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6H55bDHXnN45QFYf5ocQP/NfuUwiYO7JnPmh6ik+5vk=;
 b=eCMOPqnLAQS2oftG3h/gO2P/WAcgBz6lb7L10qQk8IGDlTfBLm3CRcBsWC/6a+2lh+RIelpzzC8h1A469eZoW4nFJpXB42c2FDtA4s/Y9vap3QEMH+tNm/+vpLWqhWfvuv9YJVlTmL36ijVHUWEkU4mqzXvow4l8xIby2cPPF/k=
Received: from BLAPR03CA0108.namprd03.prod.outlook.com (2603:10b6:208:32a::23)
 by MW4PR12MB7358.namprd12.prod.outlook.com (2603:10b6:303:22b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 20:10:07 +0000
Received: from BL6PEPF0001AB52.namprd02.prod.outlook.com
 (2603:10b6:208:32a:cafe::28) by BLAPR03CA0108.outlook.office365.com
 (2603:10b6:208:32a::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.16 via Frontend Transport; Tue,
 17 Feb 2026 20:10:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB52.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 17 Feb 2026 20:10:06 +0000
Received: from nigeria-2635-os.aus-spse (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 17 Feb
 2026 14:10:05 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH 0/6] Add RMPOPT support.
Date: Tue, 17 Feb 2026 20:09:55 +0000
Message-ID: <cover.1771321114.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB52:EE_|MW4PR12MB7358:EE_
X-MS-Office365-Filtering-Correlation-Id: d6f67e6c-90d2-44b1-5bdc-08de6e608b7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EHI0X66lB+jIFGu8bB+W5Y+cB06E4pMsRAfwRL5Q4CNS2NB+UxWUzdO0Iwp0?=
 =?us-ascii?Q?DpHsXE+7AVJb/usABUxdoQYyIvmrEGvpH/VgQH97nVghMiKvuR/jOTEmXlaH?=
 =?us-ascii?Q?AEDMyzO6QhsXNQ1bPO4KQFUMV5zoVqvKWfAEU9PYIsZjV2IFEbi/vZPHOl35?=
 =?us-ascii?Q?n/GoH9q75c6Cmuq1/RvC+Frw882ZdLmBZaQbwPJGYzyH0qiS2sXYw3EMBX4t?=
 =?us-ascii?Q?f7oYYxQca1EJ8b8CK7GNaMbG73GadzMk5yPpGNru/2X6VH0UWQ668FiaEVwK?=
 =?us-ascii?Q?nYeG370DvppYttDR8ypWsf/tOBQHLvX5Hs3EWC0M8U6IoSEYdRyer1aQQ2Aq?=
 =?us-ascii?Q?KH/vTCxrgvkL5hAwJ5x8s4TP4BOFahf77OB1Mt3XVFa1kwrnmf9RCa+vv5bw?=
 =?us-ascii?Q?4h+cdli3eZDBmjcRSwep5BlbPX1KIjFXcOnAPPvo29wDmRIsIFbHO6spJcmN?=
 =?us-ascii?Q?wa3p62y251WAYh5UhSJmlcWysq6oarLFb8VWd/zt3vtn5M08dI5DIcFuQB8Q?=
 =?us-ascii?Q?OE5CIPDG1yt4ymnOpDTwlObUEOnjIan/HCeNaZMf8LzskktOvYa9HNmHu3Yg?=
 =?us-ascii?Q?/S6zDcmx0vRYfOIPU520s5BHwY85Bcc3KvHMEQ+/267CGrclMWGJFbOT4/Bw?=
 =?us-ascii?Q?Q+8fiXuIIGmjshneLRj2cvqUm5l5yzoEcJ6ppD2PS2hDgWQYW+zRnTQPxt7U?=
 =?us-ascii?Q?QGx45MhgiqGYXgtL5c2cQBfyLd0WJIv4UFJMk5UjWECoJ7Ry6KYcAuKpAJIr?=
 =?us-ascii?Q?0o0xaxa4EAsvbscfZhSCqw8QmQrNpesaE+20qBzSi3Eo1s8ez8bobXSkiPgs?=
 =?us-ascii?Q?ogVVYAsR24jBV/1eEuEmawbzKsQunAIT2+1Kac4dF+DI5ZRZ1xkjLf4eztX/?=
 =?us-ascii?Q?oy48JQT4OABmqGE8t66aDJ7CzbvOxTuaF8UhtGlWRdbdvwBWfY4kBX3zCa7q?=
 =?us-ascii?Q?I0intuWNUewjNt+b8aF4hGXt63aLF5lskz+jpKh9Qf+JPjuvXfOeH2miZX00?=
 =?us-ascii?Q?2K9knzvlwpkWg626Hhm/j7lLHECX/6NvKR8pCSfezguyseMX/dwoGKI9h6qB?=
 =?us-ascii?Q?7xl3pCwubShSTHb1X6ffyvI5S60+WgmCEU8FqPrs5aBDIDjlc7TJJSxkg7bZ?=
 =?us-ascii?Q?UYd9Hx5CEAATB9PwvC0FKYk3d5pZ7XZc15iQMgmbDNLQQV82QOGV6E6ZuLYq?=
 =?us-ascii?Q?sQZ1BSrmh5/ITRtVByVXX0RBodzPDIvBmiTmHfEL5x7uY/IoheBr+pIDDU6M?=
 =?us-ascii?Q?KDb+HMi0SFZC4hq+JW7C67OUZRhdcO8SLgSI2fFwLcSRRLmyr+38LM6uF1NB?=
 =?us-ascii?Q?YegTMSlrrz7hOS3L4kg2vaeV34QF4N4PatWxE31w2lhZbiJYDWpHCmyyyBMv?=
 =?us-ascii?Q?++lNkwM2KaAHmmZ4KTYUPUY234waN00AVckqJBptc0vzQ1QJm29M2cPuA0gv?=
 =?us-ascii?Q?EhTXMjOQjDffvWW5DqI/MqyKkyfk079tUb7w8hS8HNJy5EeCjlKs/Tigbu7e?=
 =?us-ascii?Q?RkQ2SCOg2skZmYpQoEzVh42dM2PDVCjpUgUU9bhoGFjkwC1fZZ5UAi/R/MEy?=
 =?us-ascii?Q?fTs7DcWnNTNC8r4Jx7dK88q+qvjI+vO6KMfVH1hUgDnXV9htrZwZkhmNEmw7?=
 =?us-ascii?Q?ZL92X+QwS4c8iJgmf9DtREx4Tvgb06y29/2jJRiJQtQln6VFiY4L/gTDQ5c4?=
 =?us-ascii?Q?Z9KVHg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DWDWN9w6AZOPyOcusQUuJwSWIuMgfNeu5Lhu4I5f9h9Rx/sjKGfLsfGkHDMraqZ6nhxDXKWGo821x8wPP5VnKMkU7zHKFyDgYwvW73p/gKe0DmMSI5gIJCBPBaso+UBI3MI0pyp8722+8kdxEZd4XNZqjT/cW+lduH9r35hT2INBfvlUPO12tWlx+Q9FQ6NF7ftjhj/6NLLs6+mn9ZIZkqCdUYrgZk8yG/8fLfOzHp9wTsHEuDseqtvL6HnewdgDBmg2ePNbJCfKAVGdhID465PELzcyDyxY5cZDB8zUiSa24jKZ5/TvXHDT8VxUzmv6XdFyZYwfZlUDOrPrl1ZJY+qXPB3LZZlMqCbrQ41IiiAvGhgvTUXem2MPcM6P2huUe584u20AsnVDkqY5jn0M12rOR1CY7Vpx1e6dQjAHk/w8GoRE2sDyfbH7xVd3d/JJ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 20:10:06.9039
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6f67e6c-90d2-44b1-5bdc-08de6e608b7f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB52.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7358
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71180-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[33];
	FROM_NEQ_ENVFROM(0.00)[Ashish.Kalra@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim,amd.com:email];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: DDDC514FD85
X-Rspamd-Action: no action

From: Ashish Kalra <ashish.kalra@amd.com>

In the SEV-SNP architecture, hypervisor and non-SNP guests are subject
to RMP checks on writes to provide integrity of SEV-SNP guest memory.

The RMPOPT architecture enables optimizations whereby the RMP checks
can be skipped if 1GB regions of memory are known to not contain any
SNP guest memory.

RMPOPT is a new instruction designed to minimize the performance
overhead of RMP checks for the hypervisor and non-SNP guests. 

As SNP is enabled by default the hypervisor and non-SNP guests are
subject to RMP write checks to provide integrity of SNP guest memory.

This patch series add support to enable RMPOPT optimizations globally
for all system RAM, and allow RMPUPDATE to disable those optimizations
as SNP guests are launched.

Additionally add a configfs interface to re-enable RMP optimizations at
runtime and debugfs interface to report per-CPU RMPOPT status across
all system RAM.

Ashish Kalra (6):
  x86/cpufeatures: Add X86_FEATURE_AMD_RMPOPT feature flag
  x86/sev: add support for enabling RMPOPT
  x86/sev: add support for RMPOPT instruction
  x86/sev: Add interface to re-enable RMP optimizations.
  x86/sev: Use configfs to re-enable RMP optimizations.
  x86/sev: Add debugfs support for RMPOPT

 arch/x86/include/asm/cpufeatures.h |   2 +-
 arch/x86/include/asm/msr-index.h   |   3 +
 arch/x86/include/asm/sev.h         |   2 +
 arch/x86/kernel/cpu/scattered.c    |   1 +
 arch/x86/kvm/Kconfig               |   1 +
 arch/x86/virt/svm/sev.c            | 471 +++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c       |   4 +
 7 files changed, 483 insertions(+), 1 deletion(-)

-- 
2.43.0



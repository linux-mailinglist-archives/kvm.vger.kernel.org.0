Return-Path: <kvm+bounces-71785-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eAA9GPeKnmltWAQAu9opvQ
	(envelope-from <kvm+bounces-71785-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:39:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C8F231920C5
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:39:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C86203080F1B
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 201F52DB781;
	Wed, 25 Feb 2026 05:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Wsys2JUQ"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010017.outbound.protection.outlook.com [52.101.85.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D681ADC97;
	Wed, 25 Feb 2026 05:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771997927; cv=fail; b=sJvoiHvKD0EiktA+EPEL9g8tVgmSc3mAeW35nSNjjO4TfTT0kmwYidCww1fyQEijiSgmIfWeFaARbOv72NgNX6toMnKtUiVJLZH+YnCIL2+wC62RwToj/oQ/khtkLX8MIgNTI+dgHhhS01yqIblv8mXnICyoeJoCidgwKyrdZW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771997927; c=relaxed/simple;
	bh=IvZ3tfPjx6m9VEPH+TTLEY1g2ZzCXODxwnkRYVNGa7M=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=POaHC3WFzpG4ynUqfjPqh/pFP5g5BPTO2MU2cw0rLLpwPUTiB+t39TtHYmMUnOgKe4qLcs/Kt54VbT1jUEJd0+n+v5ALPAPPr9NbokfiiqRn7KFr/3d1ngFk9ckbsgQS5fmxvC8ZsQuxbqao2iK0mDrk6YFvr2/kCtMXc+hGyYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Wsys2JUQ; arc=fail smtp.client-ip=52.101.85.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UxSBN54FDr0BFf8VcGWglS3sn7ikpud3f2yTVH6sLQTLyyLnSV0Zrno+kVRS1kHLYXtJMIHCB+sZ6Fr0nRsTstlr1OLT8SZ5d+etGG4TBHKiE58+LT02RBOfTKtFrFjDQD7Xxub+wtAbftzpzdq07HH9JEK0xtarFXpn/lhgP9OxVuq0cFFdIf78yiEkhSTUooP9PMx5FqRFpofgFtI46X0yHro5MxFWTzLCmnDWAPROdmdcUJHsSi8P4TKnBSEWC2pIf8v04FWgjC3CECtidOREHEQNjnYOOq8JyDIy6IZxZUuz9y40qpQd/cTP9+uiIUx3MkurMoEYkhT85PGTPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gEcXqix1FcxZDGvHB5O42Rf1EVfLADdGkL0kx2L9UwA=;
 b=C0t+guV2aL6nU83dKgOb9OKjROrajTAIG70mpZVOl7PF5bcpgj+pLowbLt4NocNtzmCFSnP/NhxKwbpARBkkzrRf4aWsDGCdEizW5A3tPm1rd2JYMCPhNh40/SkxuVT6G3KP20+fUgtJhk8IviVerMP/MypDn3ST2IShbYT6g8iTitCpNyUZQ+xbp/9yar01xI6iGc6NPCBUEFpxMY2ooQcxUilzbiHzKpjrZlMXa1Ce4oH+T4QKMedbFBNT/vvVobepo52b7oiOskhzp2gW0/o2tUnxFu9NCfadT/i4gY/9C4/byK1sx1bCrhErmMSueVvIn2j3ZXXcE8wWmqzr0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gEcXqix1FcxZDGvHB5O42Rf1EVfLADdGkL0kx2L9UwA=;
 b=Wsys2JUQQd6TgdkHtPaU7F1Itv0EXKBMQGaNxI/9QSYJoWflWvTNMmpDkuNh/6DlTOM6Xsc00vUSAS45ugyZOco9S3omwtHsmiriefuTDDMc7/Ln0oPaORuuIJ1c6+DE07ZpTk7qzjC5omdO/vzar+0kqudxnMhq6ObE8WJdt+o=
Received: from BN0PR04CA0011.namprd04.prod.outlook.com (2603:10b6:408:ee::16)
 by LV9PR12MB9808.namprd12.prod.outlook.com (2603:10b6:408:2e7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 05:38:42 +0000
Received: from BN3PEPF0000B06E.namprd21.prod.outlook.com
 (2603:10b6:408:ee:cafe::bc) by BN0PR04CA0011.outlook.office365.com
 (2603:10b6:408:ee::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Wed,
 25 Feb 2026 05:38:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B06E.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.0 via Frontend Transport; Wed, 25 Feb 2026 05:38:41 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 23:38:22 -0600
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
Subject: [PATCH kernel 0/9] PCI/TSM: coco/sev-guest: Implement SEV-TIO PCIe TDISP (phase2)
Date: Wed, 25 Feb 2026 16:37:43 +1100
Message-ID: <20260225053806.3311234-1-aik@amd.com>
X-Mailer: git-send-email 2.52.0
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06E:EE_|LV9PR12MB9808:EE_
X-MS-Office365-Filtering-Correlation-Id: 6145cbdb-a345-4bd7-5ca1-08de74302291
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0aoAF81zS/ka8d5MMMD1yI0+0wyN18DRhds4LB4v9ouGH3iHrtCrU2KoOfK6?=
 =?us-ascii?Q?wO212tOiwIoKZk9PLRS3Ki20+kZcanBPWsz5hE1zNBcYlBLLRvbvMRpyVlR+?=
 =?us-ascii?Q?lFmsXukBxU9Mt99MiVHLyfOZsEupESCwEwQmTVgNvqukvVIHcaS5+t+u04Ct?=
 =?us-ascii?Q?1f716l9MZmtzSVED8PwJyCPCYBQkYRJ+vf036BVf8B0UE4m11tzC0YA8333p?=
 =?us-ascii?Q?kXHOYiSpwNQId7XETZIGZxXJ1Nfjvfb+zeB+CBEBskIHe0TXtY4UBC6VuHAo?=
 =?us-ascii?Q?5vNADBdvLQw/dWJ1LhxQbjVXHHPRv2unEi2N8F6OMAQq+Sd7qzTGSzyOESQc?=
 =?us-ascii?Q?BPZY/XoStWxxRa89xqucy2iitw9CLv+srKw7nxUk9e26Jff6IHTBl4j7WfWC?=
 =?us-ascii?Q?nX+3MiWNEFpiuTY2pSyjqgNYOKrlMCKZgfuGPn0fvKKT1i1fZOQkrJDKKWBd?=
 =?us-ascii?Q?UxiHBLryfAjaQbjUjBpCeIJhJViSyanJDWpY5E33NG0r+Ui96PA4iBmNgUha?=
 =?us-ascii?Q?zruu0wpcOQttQLXS1c9SY9xkYdYg8QX1M8lmu2A43CuZnu9EQURTCdIrjdyx?=
 =?us-ascii?Q?YvUsduhbkgPjL3KrK6S9Rdu2J8A8eukpcsN9iYm/P3aFrPKiRQPEbH4kRII7?=
 =?us-ascii?Q?XHb9CxaZZ1KxWBQKUj0oX/2f9QzWn1I/8nYRlOac4KW8+FgyZfVF/DkvIK/M?=
 =?us-ascii?Q?ty6KbhGyWvsB6gZoeO5vk2otFatqlg3TmT0dm5NxHbwBgaHVkLLlMHh5UIyp?=
 =?us-ascii?Q?w47YtppWQ7Kk8qKSkriW9xn2MKTsZIzGPkw+mqwrDrA7mtlowOTKqYVRf/vX?=
 =?us-ascii?Q?B9ZvsK8564PIHFQCAhJXra1BAPy2+wWCEsciBuUIpqVBGCG2ni4XMYVdiCaK?=
 =?us-ascii?Q?3aLnSJdV+cdFpjUfYNap/doPQrwkali/CUq/ahdPDgs02tn8fDjyU+Q4jtkU?=
 =?us-ascii?Q?hRDKAF06sdeuIgpVP0xOVjCXHOkcZ5RBGv1esxiS94HYq0xSXqAvD5+K6/jN?=
 =?us-ascii?Q?GweWDddR42Mijul7T3TYpoBfRlbmviAs4q3BBZNnjuSNfKqyWa0A0blpy9b0?=
 =?us-ascii?Q?xQVCCr8uTxkKS7fDmMjvx6b76PJSvlml/Mc6AXkjfOwSiBIWZP/PJ08Rlimc?=
 =?us-ascii?Q?H4BLzZcYd8N8y20Fgbpgr3ZRKrpXThyGihtqszbO9A/1p7MUQdYB/8/8Zd1G?=
 =?us-ascii?Q?r33Bf4Mz5JEXx3FIWReZ0J+mnOcYh52xMeGKVxncdbU+oFHlianQ6obLIyL5?=
 =?us-ascii?Q?3gZxClNTnuPu4H6l1IM5MMn5LjiFMi61LBYrvvJiS4Y+wRGNLUdOGRRvR8Yn?=
 =?us-ascii?Q?6nhCMwj7NL7nJ7t5lBR1ZS9n5l3zgFgbKb93aU3vGuGBBWf1JE1HWdZBFhGf?=
 =?us-ascii?Q?Io6Y/crDOkOo+M1ZqjnlfolbA1Fzk5+ggQ3OfnP8XhnnYsAoYDReev4Q+PWp?=
 =?us-ascii?Q?MUeNrxl8lD5R0urA19QdZQB2vhP8N6qaZq2rv5nPNI/uTnGeulvAuPV1nmmd?=
 =?us-ascii?Q?boR/KOe+2JfCOkcRvIJtLEzLgbV7AcbDr0fZcA+4rBRWjEWsVuQXEMi8JLUD?=
 =?us-ascii?Q?Q+Z9sw7fyTSJrqKlRWWcyC9AqdjfN2Oxynp8sUC2ue0aH1JJvX5aYQvLRp4y?=
 =?us-ascii?Q?83o2wF8/HRzvFCX91hgqabXs143UkMEwbFzYE9f/TGyN35PS7tIG5IR6lTFX?=
 =?us-ascii?Q?86CADA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	L6ZrePEp+ap4jMJBKre66wMakyBaTFjY7V/Gnc165oGMq91ot9iCfgmZMI/hNsDiT3adaHf/BmIv+KkgKznpr3K0nnGTOP8MVsuyWvybI6CB42MH2AM8SXq02TDOeLtwnC/d4RFT+dKK4WdXUUqEf2MsDYvM3IXTJ1Ojir0CckGOmVluXnYzhxOZ/EXwGHpIxV5twQPyK7HwwgDtqAkVSH8uH+txUTK/OH2lANQSNVH5MvIdS16WDckXD8q8RKUGr2XVg8AOQ/t8kqSknfIrmrvq2lbyHAuFxy0UZ9tutb55PwNNOp74oUyUOrfd+dxjR/q2x4WNp83VX0rHz1//NPaDEiJvoKRpN0RRPv13WTlit6s67ZfZXni6+cLxQKdZ7qomfnt79iuh4ENd6GcSgOpN5kJPX3oNzfpcydSwgs+dFu1ilCd2elyfETv/UxVF
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 05:38:41.9947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6145cbdb-a345-4bd7-5ca1-08de74302291
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06E.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9808
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71785-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_GT_50(0.00)[58];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: C8F231920C5
X-Rspamd-Action: no action

Here are some patches to continue enabling SEV-TIO on AMD.

SEV-TIO allows guests to establish trust in a device that supports TEE
Device Interface Security Protocol (TDISP, defined in PCIe r6.0+) and
then interact with the device via private memory.

In order to streamline upstreaming process, a common TSM infrastructure
is being developed in collaboration with Intel+ARM+RiscV. There is
Documentation/driver-api/pci/tsm.rst with proposed phases:
1. IDE: encrypt PCI, host only
2. TDISP: lock + accept flow, host and guest, interface report
3. Enable secure MMIO + DMA: IOMMUFD, KVM changes
4. Device attestation: certificates, measurements

This is phase2 == basic guest support allowing TDISP CONFIG_LOCKED and RUN states, and unlocking as well.

Acronyms:
TEE - Trusted Execution Environments, a concept of managing trust between the host and devices
TSM - TEE Security Manager (TSM), an entity which ensures security on the host
PSP - AMD platform secure processor (also "ASP", "AMD-SP"), acts as TSM on AMD.
SEV TIO - the TIO protocol implemented by the PSP and used by the host, extension to SEV-SNP
GHCB - guest/host communication block - a protocol for guest-to-host communication via a shared page
TDISP - TEE Device Interface Security Protocol (PCIe).



Flow:
- Boot guest OS, load sev-guest.ko which registers itself as a TSM
- PCI TSM creates sysfs nodes under "tsm" subdirectory in for all
  TDISP-capable devices
  - lock the device via:
  	echo tsm0 > "/sys/bus/pci/devices/0000:01:00.0/tsm/lock"
  - accept the device via:
  	echo 1 > "/sys/bus/pci/devices/0000:01:00.0/tsm/accept"
  - load the device driver:
  	- DMA to encrypted memory should work right away
	- MMIO regions reported in TDISP interface report will be mapped as encrypted


Since one of my test devices does not use private MMIO for the main function,
there is 9/9 which allows https://github.com/billfarrow/pcimem.git mapping MMIO as private.


The previous conversation is here:
https://lore.kernel.org/r/20250218111017.491719-1-aik@amd.com 

This is based on sha1
4fe8662d1a9c Dan Williams PCI/TSM: Documentation: Add Maturity Map
from
https://git.kernel.org/pub/scm/linux/kernel/git/devsec/tsm.git/log/?h=staging
and 3 cherrypicks on top, please find the exact tree at:
https://github.com/AMDESE/linux-kvm/commits/tsm-staging

The host support is pushed here:
https://github.com/AMDESE/linux-kvm/commits/tsm

The SEV TIO spec:
https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58271.pdf

Individual patches have extra "---" comments (could have been "RFC"?)

Please comment. Thanks.

ps: quite a cc list from get_maintainers.pl.



Alexey Kardashevskiy (9):
  pci/tsm: Add TDISP report blob and helpers to parse it
  pci/tsm: Add tsm_tdi_status
  coco/sev-guest: Allow multiple source files in the driver
  dma/swiotlb: Stop forcing SWIOTLB for TDISP devices
  x86/mm: Stop forcing decrypted page state for TDISP devices
  x86/dma-direct: Stop changing encrypted page state for TDISP devices
  coco/sev-guest: Implement the guest support for SEV TIO (phase2)
  RFC: PCI: Avoid needless touching of Command register
  pci: Allow encrypted MMIO mapping via sysfs

 arch/x86/Kconfig                        |   1 +
 drivers/virt/coco/sev-guest/Kconfig     |   1 +
 drivers/virt/coco/sev-guest/Makefile    |   6 +-
 arch/x86/include/asm/dma-direct.h       |  39 ++
 arch/x86/include/asm/sev-common.h       |   1 +
 arch/x86/include/asm/sev.h              |  13 +
 arch/x86/include/uapi/asm/svm.h         |  13 +
 drivers/virt/coco/sev-guest/sev-guest.h |  20 +
 include/linux/pci-tsm.h                 | 110 +++
 include/linux/pci.h                     |   2 +-
 include/linux/psp-sev.h                 |  31 +
 include/linux/swiotlb.h                 |   9 +
 include/uapi/linux/sev-guest.h          |  43 ++
 arch/x86/coco/sev/core.c                |  53 ++
 arch/x86/mm/mem_encrypt.c               |   5 +-
 drivers/pci/mmap.c                      |  11 +-
 drivers/pci/pci-sysfs.c                 |  27 +-
 drivers/pci/probe.c                     |   5 +
 drivers/pci/proc.c                      |   2 +-
 drivers/pci/quirks.c                    |   9 +
 drivers/virt/coco/sev-guest/sev-guest.c |  23 +-
 drivers/virt/coco/sev-guest/tio.c       | 707 ++++++++++++++++++++
 drivers/virt/coco/tsm-core.c            |  19 +
 23 files changed, 1129 insertions(+), 21 deletions(-)
 create mode 100644 arch/x86/include/asm/dma-direct.h
 create mode 100644 drivers/virt/coco/sev-guest/sev-guest.h
 create mode 100644 drivers/virt/coco/sev-guest/tio.c

-- 
2.52.0



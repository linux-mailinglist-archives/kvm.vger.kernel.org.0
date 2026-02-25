Return-Path: <kvm+bounces-71791-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UMdWN9SLnmltWAQAu9opvQ
	(envelope-from <kvm+bounces-71791-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:42:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A17E192197
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:42:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3632630967EF
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3E829E113;
	Wed, 25 Feb 2026 05:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Sw5odYoy"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011041.outbound.protection.outlook.com [40.107.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F431ADC97;
	Wed, 25 Feb 2026 05:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771998147; cv=fail; b=Ntn4BpghZxf4mUhNihLfwMamK8hphPlpvHMugwAsqDEwgu1CuyMHlpaq3pWFdO0xYqzZwQjfAq3r/94FyLOE6VLmCxctdYjDfsXhk5F6bzviPRfxiFku4xcUlDPGFPzUSSAIviYycFqyqyiFFZAo/bDfNvgGMS1mGyVrRznIelA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771998147; c=relaxed/simple;
	bh=yZSR6+uWmHDTjlHGGXlFFUaDNYSLsxWb4bU8kKWFJeo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PwLWAAcbEw47ceNL1cnwZahaM7RW7dlsF/Vxi8IPiXjdjL5HvbBtCZUuLFXOwwzDqyFzMqok81U36BMNMEOKQySWECtTDU+I1r0KifSgXMLFEgOdyHRPWsQTaOVtrT13RIysSrTCf+FxAzy74PnBFts8QBq0/7/7XeKSIOTnfJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Sw5odYoy; arc=fail smtp.client-ip=40.107.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LPsIbYbksLMWBUSQlWb+vJxQXvKxdiM7E/z6A6B0fHYTdQLtTHKLf6P7Zcc8rcSV+5T1SbehzNWs2+7grSoaMLi1P+FXRLg42KIm57J67EpbEAJbQhrD+9uNYn66ElDKKApHSZmJBpcM+DsM71WYt844tabCm8xK0UBUfi2BMavI1JarE8oC/8qHZg2z2aFkHVQlfesEk+q7mNIlbdp9lKqe6YNvX5gYrdu9HvOlKX9lVud02OTzi78DF4gHjvofK56CqWA5edYARp91mUKwwbmoUWEpvajVgaXyw/Act/k3TT+KTx4AncFdwHPA2On2W7/SdZKoTjgctfaYOGGhww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W+shdEUfkiyMBsshsjFG87m3FzBr3vO9c5zginCzlnc=;
 b=WCcexP/UrPi1lr+Gn+qloyjhxBHLj9Mq5gR5yrRtjXUOXY7hsyF7eD/rQgfN2sUFTCkfUN9QmaEa+bH+rJT69Ht2bwIn+wkzTWAclk7pe6RhAOKyJ8boCpEgo/FqHyWOYJtEQcnfmWmh9M/h19EkTebZFNJGwayhiJXdCyOO22q5n6KtKvAOfc0qTZVHRfzgySFOeXsALOmMu4neD7aDilDsTclWnCl28tPuudllXXfZO+TYZQqLiIsjnTuwSX1uGLU/aM8O/sZZdgPDCsFEzm9g5NyVFJJINVncDFDGbsMUCFR327ufg3RbSvZT5MCDMHv7pmFWMMI5N+6qHQwKSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+shdEUfkiyMBsshsjFG87m3FzBr3vO9c5zginCzlnc=;
 b=Sw5odYoygZQnvwEPhckow5yebZg84aw8Uw1fGMYzQci2+1xnpjycdXLykL4Q97Q1LY1/V0vo8KeWXU3wJd9E7uHhxWRlSRjLpj+TW5e794RsnxDxxkKb+kgcO/YlAL5J78G+A8iF0lqApyk5C0z6+fOhG4MFw7wlmY41NeES0tQ=
Received: from BYAPR01CA0067.prod.exchangelabs.com (2603:10b6:a03:94::44) by
 DM4PR12MB7528.namprd12.prod.outlook.com (2603:10b6:8:110::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.22; Wed, 25 Feb 2026 05:42:20 +0000
Received: from SJ5PEPF000001EF.namprd05.prod.outlook.com
 (2603:10b6:a03:94:cafe::fc) by BYAPR01CA0067.outlook.office365.com
 (2603:10b6:a03:94::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Wed,
 25 Feb 2026 05:42:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001EF.mail.protection.outlook.com (10.167.242.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 25 Feb 2026 05:42:19 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 23:41:58 -0600
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
Subject: [PATCH kernel 6/9] x86/dma-direct: Stop changing encrypted page state for TDISP devices
Date: Wed, 25 Feb 2026 16:37:49 +1100
Message-ID: <20260225053806.3311234-7-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EF:EE_|DM4PR12MB7528:EE_
X-MS-Office365-Filtering-Correlation-Id: cddd397d-85e1-4aab-7012-08de7430a47f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B36H1ujzRW0BXco37sGYQ+xOWU4y9q0Bf7qc2go/3P/ndjG19iju/D+ue2ou?=
 =?us-ascii?Q?e1hjyUUXwWdU8HotGkZAcrOh8YiRigwNPsERjVOsgcNB2lFNKjM2roGsydW8?=
 =?us-ascii?Q?4ouYAOGeN5Y6fz7b9OROEDOHjN5bJ79Z1ptdHkmXgcYEvJ1GNGrgfUxITHFo?=
 =?us-ascii?Q?YXv0B12IRFInihSPKlFSpQjXYQSEHFJhwkGoOfkbGkuUKdEQ38nhh4mcHphl?=
 =?us-ascii?Q?eMzXEH1RHIYBIYziJ6JTQb3a/zFV06IqT+L3viinCA5uFa8WqcklksoCxd85?=
 =?us-ascii?Q?NRQRAnj+3V575YAgqMF+sG5lVXC5V7bTmZVKKvs3jiO7qhH2cgNRIIXnUC9e?=
 =?us-ascii?Q?c6XnCULYRr46O9kdDfLTekBJE0qbyrOnn4OV1sp6/smghYrarsY8LhhfYLgT?=
 =?us-ascii?Q?vpSp+pVowq6nS0ZU8csJ8SbKxXudUWTPEPggFPyulbpOSQERo0y1uxtjQDGc?=
 =?us-ascii?Q?KB7fTgbhzu8f1liwvJBev7hJvaPPT0OdNwop6vODSl3XsoD25sSp7sSVtFGV?=
 =?us-ascii?Q?DdyBfgf8yqpUlJb+nboZoEPfvNsRh4pd6hIZ8yy6U+ztyb09Jv8KkxU+8FlF?=
 =?us-ascii?Q?RxMmIEr0EVZkLepFYHQeZWN+UxeNC0RvwXL6mR4e3xqIcam761/kpkAgieBL?=
 =?us-ascii?Q?1k3qQXP1AIuvQ6hELd2W16WPoJ+Xs7WihRMy0kaT+85HxR/pSF2xiWszMwzZ?=
 =?us-ascii?Q?y0JJE4uaFL0uCPFS+fTdzFsSG8V6f2EHIiYu1X3wdw+di4Y4czwCMcZ31jfx?=
 =?us-ascii?Q?kqgo733AbBdLNauGkb+SQl53vFEsDrmQkexRD6TiQ7GcGJ+0lga+KuRH9dZA?=
 =?us-ascii?Q?MFtRU22UX9DAFO7KlVRc1BH3oEZK6yAIODpbmSolLwMpbqg4cBlYocc2X1+p?=
 =?us-ascii?Q?5mIM2yL121v97duCknIUyCQ0d9DiyTr56WioUKrOjQz1sxdvcAqPpO8yPhnd?=
 =?us-ascii?Q?swBOPOOK88JZi9+3MV/o6L7GmJbtzHjZikMnA/OpDKXc57LH7fwWyf7uND19?=
 =?us-ascii?Q?WSw8OL9x5/0WFPk7638lLjoYGu75RDuPZ2Og6kBQAlxIc9KMTDbTEbRxPjun?=
 =?us-ascii?Q?q6MdvgV8eI4eOTb0ZLFDsPnpQEwipShGD4h+uhX1g1Lb4rfsjdXbf8zO49lK?=
 =?us-ascii?Q?AsIUwlEMRVq3xknSOlHs5T+qVb6+otE7PTAcJlMcBxWPvEZEACO+WYiuLyEo?=
 =?us-ascii?Q?GC0V+I255+34DZBuEdQlnUPqH//MHucXaDdSh11abkMwH4TcSXynZMVAceV8?=
 =?us-ascii?Q?/XryDNgPJPp6u+qQxx/9B1eOIRsDoNTWV680nN4piT7g6UngcCznSeEp0ULD?=
 =?us-ascii?Q?+yYP7slsqTxlF7TfoQ9/08800jWtzMYxpXa+dLRxwdTnXcBJBFtvniX+MwF+?=
 =?us-ascii?Q?bASm3sBIRIqeHZAsd1M3RJZVPfkSjVZpcYMVfsYfcd5Vg7ZxeDVvNIx9gj8i?=
 =?us-ascii?Q?ZsB9Qsb5nNblcsVxLv3svoyC88BnipqHxjHbPzHcKxYyax0/zUjZXnYCKuzt?=
 =?us-ascii?Q?24e0ukBW6NPiy//gzEujvEFlTmUbJy6gZeBHBHYV1sgOEB/0KlTVlWP/INaq?=
 =?us-ascii?Q?PSlsO+PyXFx4/Vo21UTuz7V3Dr7w1CTz6ik5iSmrJ8Q9RzqbJiTjlTt7h2B5?=
 =?us-ascii?Q?quzFstVx1ga5MG0fI4Di+PkCZKrkoqnf9HKVriuikHMs24khMT22bnoyPnCj?=
 =?us-ascii?Q?2zz3tg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LLemo8+Quz9DXard1pjo49ZH1MzpCg8Jgg8bh1Cx9Nt4512a+a8RxdEWQysZ1f0T7Es2brbsTyqFfpeXe2UqN8nCpSw4EXLVauSxeUuGPMwiGTrtbQo8oTw98t0190/LvoDF3bD77Ou3JmNKFnLZQG4CE2qOs7oPNuKs9KzisHMh51dsGHMrpDWrVvrqvf3Xy13yYCW1t/D/ft5YsiWSLHiyOXNcgdIi9n3mXaKgoAFx2PY7+rVwLRUZTccZsgdU7iWqMLrOf3tYV96tKNuV9zsUFHfriy9Kxzaqm2s1xNF2GvGCFkbHeo29JrKExP2CbxAq/Z/d9SqtTMqLYVt/utmyFZ66QjNs6SpvMB90fhep/LRxfQ6tZeOXY9mo5YfYHTkIax8ozVDkWcMf/U2J4j/fyH4IBINNQonEEa6iWObFkDHBnbu7OzizfoFNl05S
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 05:42:19.9091
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cddd397d-85e1-4aab-7012-08de7430a47f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7528
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
	TAGGED_FROM(0.00)[bounces-71791-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 4A17E192197
X-Rspamd-Action: no action

TDISP devices operate in CoCo VMs only and capable of accessing
encrypted guest memory.

Currently when SME is on, the DMA subsystem forces the SME mask in
DMA handles in phys_to_dma() which assumes IOMMU pass through
which is never the case with CoCoVM running with a TDISP device.

Define X86's version of phys_to_dma() to skip leaking SME mask to
the device.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---

Doing this in the generic version breaks ARM which uses
the SME mask in DMA handles, hence ARCH_HAS_PHYS_TO_DMA.

pci_device_add() enforces the FFFF_FFFF coherent DMA mask so
dma_alloc_coherent() fails when SME=on, this is how I ended up fixing
phys_to_dma() and not quite sure it is the right fix.
---
 arch/x86/Kconfig                  |  1 +
 arch/x86/include/asm/dma-direct.h | 39 ++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fa3b616af03a..c46283064518 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -112,6 +112,7 @@ config X86
 	select ARCH_HAS_UBSAN
 	select ARCH_HAS_DEBUG_WX
 	select ARCH_HAS_ZONE_DMA_SET if EXPERT
+	select ARCH_HAS_PHYS_TO_DMA
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_HAVE_EXTRA_ELF_NOTES
 	select ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
diff --git a/arch/x86/include/asm/dma-direct.h b/arch/x86/include/asm/dma-direct.h
new file mode 100644
index 000000000000..f50e03d643c1
--- /dev/null
+++ b/arch/x86/include/asm/dma-direct.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef ASM_X86_DMA_DIRECT_H
+#define ASM_X86_DMA_DIRECT_H 1
+
+static inline dma_addr_t __phys_to_dma(struct device *dev, phys_addr_t paddr)
+{
+	if (dev->dma_range_map)
+		return translate_phys_to_dma(dev, paddr);
+	return paddr;
+}
+
+static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
+{
+	/*
+	 * TDISP devices only work in CoCoVMs and rely on IOMMU to
+	 * decide on the memory encryption.
+	 * Stop leaking the SME mask in DMA handles and return
+	 * the real address.
+	 */
+	if (device_cc_accepted(dev))
+		return dma_addr_unencrypted(__phys_to_dma(dev, paddr));
+
+	return dma_addr_encrypted(__phys_to_dma(dev, paddr));
+}
+
+static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
+{
+	return daddr;
+}
+
+static inline dma_addr_t phys_to_dma_unencrypted(struct device *dev,
+						 phys_addr_t paddr)
+{
+	return dma_addr_unencrypted(__phys_to_dma(dev, paddr));
+}
+
+#define phys_to_dma_unencrypted phys_to_dma_unencrypted
+
+#endif /* ASM_X86_DMA_DIRECT_H */
-- 
2.52.0



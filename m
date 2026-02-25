Return-Path: <kvm+bounces-71787-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id PlrbGHCLnml8WAQAu9opvQ
	(envelope-from <kvm+bounces-71787-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:41:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E43A9192141
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:41:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 810C13095208
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7DFA2DC772;
	Wed, 25 Feb 2026 05:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RsfnFk9Y"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012070.outbound.protection.outlook.com [52.101.43.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06752DA762;
	Wed, 25 Feb 2026 05:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771998006; cv=fail; b=N6838wh+i7yMwi+9JSuOT6f7vhMG16SfZG6aGD6j6DQUVh+qPStlrp8gcbEnrgAdd7V8A6yntc7Hd+RQqXe1J3Yez5KbFveFhY53btv8ysVd3cGreaY2pbdPlTPa3cfzyazaL6ZzAFsYHth9FsMBM4Kd2r4rx41f9w0IV/HkdXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771998006; c=relaxed/simple;
	bh=x5/WXep9MVU/9aYgUP/n5gezMcRmFTbEOZChd1kjCFQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=demM0M/LnVKuZ+c0n0OxmgEju2yCUKhVq9Gs8nDjCgvYnGhDQZ9yaIH8gA/mLgKrP2eXQuFQ0ZZknCDYA+ZmQM1LQNXxFmCizZ1420T2wjrQMMqjPM2Nnjdmy0fqmVsWYdusxjVtWXs76M3H0WCIUnCJy7ekIirb9VNKNONkD4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RsfnFk9Y; arc=fail smtp.client-ip=52.101.43.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VwQ6NUFBOdZZZJf7xM3n2nEJYcwNNVUiQm0SPzIN5+TAMX7qOunJkoFDTd3xc4krybv6MS6AShkGYs5PU/VoU6Rw/LOBtQacUW1YUR0XQIXfrruktVsmNHUdzGuhF0Q8Wsv9QlD2Q+u8BxPxbXKoVukCIh9s90g8ZO0XcO5a7Fx1DWeU+ZnnZTixLDGbLM0qamI2JscKaIZA/MEJDYe17vWzPK1l03CaCZzhRRZkeD2U9zbdTNmB6+TKEQ3sgysWfednH3QpH6Lawhj1knmaqDDP6j73KfmBKr+6BUwKjftnT2PPH3DNWTawrwrhVHyXH0/UbeXoFDg0Wwb69iqoNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60f8et0XKEGhYtH2CjBVgdAVSd68X7jQsaMj8tNgX0M=;
 b=h+J5QARpNHAO57xgXn5+mdds/0sU9e2e1urhEcezV+MgxZ6gXjNGfnkXHIPZLRdIYBubwmLa6DwNKGRZTWHEdSmMZ+BVz3FnkzeFkInUjjHlnvseh/dNpZu2tagEdjmfTtclccdFEE6Ez4N0+Yhx+akGPJiO3Px8R4LyTCCzcSXZBC7t/XepULfxUvuPw2+J8+q2p5SsP9ZIlI++tGko+wPHFKrPlV2xblXWMlDKWJMCMBjY594gtvOfCX48c66X1uUppPbAkuBr0Ydte3td6fJrvnniR+XyZ7Ltwwl8DUn30e9ZQOd0eSvTMJze/I27zJCYBXnuK3+eaGAxuLvcZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60f8et0XKEGhYtH2CjBVgdAVSd68X7jQsaMj8tNgX0M=;
 b=RsfnFk9YD4UDHElH0v0j2/ApSx9tLphvvwSEmE/px1nodY95rrhQLNpc5bTansi2WPtfyQ+06aWq/qTSx9kiYMu7sVEmOLaI3jkQauwyzwI7g7K2jemQ0L5BPVIdD+2XYUaCyS9MILJZRf1lV81DOoDQnUBtRVCeUJkPsfLboBw=
Received: from BN9PR03CA0584.namprd03.prod.outlook.com (2603:10b6:408:10d::19)
 by MN6PR12MB8541.namprd12.prod.outlook.com (2603:10b6:208:47a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Wed, 25 Feb
 2026 05:39:57 +0000
Received: from BN3PEPF0000B06B.namprd21.prod.outlook.com
 (2603:10b6:408:10d:cafe::6b) by BN9PR03CA0584.outlook.office365.com
 (2603:10b6:408:10d::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Wed,
 25 Feb 2026 05:39:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B06B.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.0 via Frontend Transport; Wed, 25 Feb 2026 05:39:56 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 23:39:36 -0600
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
Subject: [PATCH kernel 2/9] pci/tsm: Add tsm_tdi_status
Date: Wed, 25 Feb 2026 16:37:45 +1100
Message-ID: <20260225053806.3311234-3-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06B:EE_|MN6PR12MB8541:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ce9827f-8a97-455f-b9d8-08de74304f27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wYVdbUWt0XQnV4sACQPeA3OFP3YuUw9GLzanqGhOKDFsmltPKOJ6KdOC1NzX?=
 =?us-ascii?Q?wSbmKun4XVW0kJufYRM7n7ivNNBXlV7Qq7iM1Z2DIizxh+1gTrA2YTXRb4HX?=
 =?us-ascii?Q?PRwUzuoATTFbaqGz37PdRk17MQvYQ238iDyKKeO/IcWWxGeeFWtV9xbjkJgJ?=
 =?us-ascii?Q?JvdAyBXJLEhxjU/q/c+Hl4xhdz1ZcasBnBt1zVoByFmL9JVk/htWqqM7c5NJ?=
 =?us-ascii?Q?Hr0Tgku7fANIASV0weiaQDTxwDitEqKhYEsoocUVybxJZDmTVV7knOxARHtT?=
 =?us-ascii?Q?5QBHaXuDO7VIQvuFXZ/weARlLxu2jknL01tTx8wimTyMkwRWUGsnY3Sch/oc?=
 =?us-ascii?Q?UQEyiJm1Jda/LwmNPKMz+fPLW9Je9cfSMvOjCn8Y/GAvgGfOuD3v2HZPQb33?=
 =?us-ascii?Q?re3n4KX89HAUu4j0+oNdvbIv5g2CYzZpDU6ZUz4q9FFT4eMEyMps7HcYtyBx?=
 =?us-ascii?Q?i+vOIoeklT/ow8G4XiGoTIL0sJ49uAxlrReIjxEV9BGZbz9zsTJpUNc+AC6f?=
 =?us-ascii?Q?+NSk01Z+Tr4Trc5WaF9WTHC42E59LWQpoAdnzuJEBgbSNKNZLBT2WFmWm8z5?=
 =?us-ascii?Q?m7Po14nP+1PoTPVaAWnW5u4xNmVRH8zoUdYskcYxOZg4D1DUBmse3YPAEvNn?=
 =?us-ascii?Q?H5LxWax25kxQmCcLsCpDg0uP/bgh7XLu6sTL1Tv0oZDJ14ET2ziYXaI9H6xB?=
 =?us-ascii?Q?3yLmDaFDKkXi9o1GgIxpw2/7Auz5wU1aWzbbdxbtbi/MNUPZjkxAOR74R5qg?=
 =?us-ascii?Q?ZyTuMl3kBjviclWQD1kn1O5AT465pMfzrCIczBXHIV2yLn8VnHxbnj0UWD9B?=
 =?us-ascii?Q?kl7g6oQwoc+PKkfP1aM2xQrRuc5smBoVcAZrzSaPE3On9jfUBfcpVUOyR5mt?=
 =?us-ascii?Q?6yiCxxYeu8YP4cLtCwwyCNsdm5Zey/YDAv19ao+zUFoPKMhTJ+LH5gflh9+U?=
 =?us-ascii?Q?8gUAFNCn3KDiWviwUt+HnKz9tPWfAQ1+tQfqCZ6hKOqmJW8H3luLX/ZjO/WX?=
 =?us-ascii?Q?gSERqA9reyc6ZCIYyeTxf6bFjNnGLv2HrtrC3FcXB2MWNF/nicof+4awkDqe?=
 =?us-ascii?Q?YoB+bsiMLnMoV26oCXvpy0/yVE9J6H63DF+R+3W0Of62swh3q96D/gQ/5TDe?=
 =?us-ascii?Q?KrpdRgSMGznP+Vmj4PAMyXrJGM542nk0GrOttQ9V8Z3tBUM0nDcPjjAy13iJ?=
 =?us-ascii?Q?iDg/dH60YS1Qkxir7IxI3XcF1e03Vd/6WQkybWyPPt/ed1/l/8crW5r+se0u?=
 =?us-ascii?Q?Bw7p8fXYl0P9xz+AjF1wJxZqfkNzf8kyurYKc1OeaxAG3JwOMKeAZJLLqaoj?=
 =?us-ascii?Q?a/worNB37xi3SCrxaGoBor1HKfq7z3HBTBinSHgBcUg/VL9MjruJk8ilbmmL?=
 =?us-ascii?Q?/zULTnOSie6tc0E+AEfjVzXry704M0Ar94slw5wpIEaqx1gLogMvjCHW7f1W?=
 =?us-ascii?Q?Xc9uk/15mJN7COQudHpstJ5ZfgMgusO3OeB/MofyCsvPrGVcI4atOx3WXdrE?=
 =?us-ascii?Q?ZTYptRVvtj8AE5I+WqcAi805ZbaNADWEb29zK0MAx/d3Q+o2cxtiY1qI7Fn0?=
 =?us-ascii?Q?cok8TakKHJer1LT1O6CtSFV4OQbrv/XP5XFb2RQvaYrq6zprOHr/fiQCrAbd?=
 =?us-ascii?Q?etJsl0GusX6qZhAKLSrEqhbu4svT5uha0f7PGVbIvqhCYGpsGJHKtFlCpN0h?=
 =?us-ascii?Q?rl+8Rg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FD/YqDhrt+5ul8hVZrjtmoH5rtddbogI/ggYLEP78BedfAQAmJbJJlyLWWiB91aIqhQdI+dl7dnZhlk6sfJUL2WwT0P5imCd5KnfG4DFExIW7+mJ0PvLZdsvu4rovVRplR8wCP22Vqfmrq9wbRNq9kbIEQ+kyV2j6G2OJ1a+da+TkJeavXvv6Jz7osdOW7AuEa9cqgW/5ZxXA0rw6T6GmAWlVUEoRoEttd27G28Xq12nCHmeonJl0rYyRsPCtI+CJ6sAsereG5aRUxCau8oW+nj01zpPMlQnOYo/3+2kQVYr7Plpjd4GECIDioQ3s4FF9CtdPT2+MaTu2f1vjjNFZzPVjjqeISC5TKj4KfYdKyI6UZdp2xjnNZoJAqDblyquqkqklIA3KqcqatT2RXwZ6bARpSYPYyDz4m1S9yqrYRCbkmuonohNqsK2SsySQzP2
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 05:39:56.8013
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce9827f-8a97-455f-b9d8-08de74304f27
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06B.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8541
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
	TAGGED_FROM(0.00)[bounces-71787-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: E43A9192141
X-Rspamd-Action: no action

Define a structure with all info about a TDI such as TDISP status,
bind state, used START_INTERFACE options and the report digest.

This will be extended and shared to the userspace.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---

Make it uapi? We might want a sysfs node per a field so probably not.
For now its only user is AMD SEV TIO with a plan to expose this struct
as a whole via sysfs.
---
 include/linux/pci-tsm.h | 26 ++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index 7987ede76914..8086f358c51b 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -355,4 +355,30 @@ struct tdi_report_footer {
 #define TDI_REPORT_FTR(rep)		((struct tdi_report_footer *) &TDI_REPORT_MR((rep), \
 					TDI_REPORT_MR_NUM(rep)))
 
+enum tsm_tdisp_state {
+	TDISP_STATE_CONFIG_UNLOCKED = 0,
+	TDISP_STATE_CONFIG_LOCKED = 1,
+	TDISP_STATE_RUN = 2,
+	TDISP_STATE_ERROR = 3,
+};
+
+enum tsm_tdisp_status {
+	TDISP_STATE_BOUND = 0,
+	TDISP_STATE_INVALID = 1,
+	TDISP_STATE_UNBOUND = 2,
+};
+
+struct tsm_tdi_status {
+	__u8 status; /* enum tsm_tdisp_status */
+	__u8 state; /* enum tsm_tdisp_state */
+	__u8 all_request_redirect;
+	__u8 bind_p2p;
+	__u8 lock_msix;
+	__u8 no_fw_update;
+	__u16 cache_line_size;
+	__u8 interface_report_digest[48];
+	__u64 intf_report_counter;
+	struct tdisp_interface_id id;
+} __packed;
+
 #endif /*__PCI_TSM_H */
-- 
2.52.0



Return-Path: <kvm+bounces-71793-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MKHqOSyMnmltWAQAu9opvQ
	(envelope-from <kvm+bounces-71793-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:44:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 623AB1921CA
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:44:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CDC8330BC586
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1BAC2DF152;
	Wed, 25 Feb 2026 05:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lcFZrKuo"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010068.outbound.protection.outlook.com [52.101.85.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CFE27FB2E;
	Wed, 25 Feb 2026 05:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771998225; cv=fail; b=MHIY71IfWn1Ryz6NdwU2vUmYv8Hn2LTSp+FQFoTOlhrHPw3QWPP5HApqH3IqnV5DFKTfnAiP1Tk6jpGtotz8WrT0Kxw1CrsHj1cRsfivnbySLoSHha8AQAcEbuheUAmRISV+C3HiC8Ue5rNBSA1J8SkiKTbAzpYaywugio8vEJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771998225; c=relaxed/simple;
	bh=yb+MB4JzhAMhVdHLfxAMWaWVrQJGAHR5qQjqp22EMwI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rKXpiREQsfTXiBLi4swtHcYpKlTmpNjjcnEbzyuBHXMzIkje3trCBGmQlYy5iUIM8iiVRB+/8AfGPH9laptdwcIA7FFyX3zhu8LokQyEE4qSNqtEfe+DkRETodj3pbOw6I/BzjsnN8+4yBTdXw4pMiqt87koUhla4TU/FyLQBPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lcFZrKuo; arc=fail smtp.client-ip=52.101.85.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OORH1PGraId+LkqXFEtOgT1V0w4gRarexRrvR3IS4QetaGiJTnD1cNXQzl6QyuRF+FNatuC9wSDW3aKtqVWPycpat/XDk9lYn00zc8RaEP80qnPiTrZTZqnDdoarUCdE7hyzbow74a1fRW5tKiqQXj1Ec3h/QuelTL/lRxFf6qLaZjoNN692ZmjXq5plHp+tV4ax+VJqnXfrUxt+iL+Dckb0M6kZpwVzAnlIBFpzzKDr1W35jCAa4nof/xZkrXfk+XCzY1qR00/q9XgCdfNM8NW4lhqAKn77IA0xFLtoxuadEXQIlnzegM01zVPxabrEhZqYHxtEz1OSTHTVyEeJig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0qOHi1i3UZ/7j1ArEf84IuK+wfeGixTzmnjwaMbK/Q=;
 b=yNijtELPgNq530Ll7+plKaTneYUXdoyKmMgoRUu3enWaezALSinz/yFIBO4rVXZXrLXD5BTH8Lpr9h1lHbNsZHrxBG54CEOyRqPI3Y3oxiBZ/OqGBFpRLcr0NvqyRfeXAXzbpLPdRTv9WHKekiYODVFHlEMMt9CfWiRLfHcS0gBiWHOUvbbdG1zmnaXQejcjIfFyjIt+AgoEnxRzWK0XBBtbPlotOEyiRMTVljx4sm+yKzreobgAdyvQg0twXxcH85hi2vVUabalSp915EC9vOUyvIwDU21wOWFi5AIJlHQEs/cR9H9lweTMje32nSeIETpRbacHzkHVKpQTODLg9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0qOHi1i3UZ/7j1ArEf84IuK+wfeGixTzmnjwaMbK/Q=;
 b=lcFZrKuomFMWAjkGnx5KkgoIxIaGEkwayu7/4Pwdj2ZH5r2tEH1cATLSvnSaiFA2EznEXQ5QV2ye/aMY9J0HCZYsKG3y1Wk7TJy8aHTYeDHmOBhezBh+ONVvgVBQMN79VrC1iKsDpw6u/UTMrGatsyHbSB83jO5kTFefEseUuOw=
Received: from BY3PR03CA0025.namprd03.prod.outlook.com (2603:10b6:a03:39a::30)
 by IA0PR12MB7627.namprd12.prod.outlook.com (2603:10b6:208:437::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 05:43:38 +0000
Received: from SJ5PEPF000001EE.namprd05.prod.outlook.com
 (2603:10b6:a03:39a:cafe::95) by BY3PR03CA0025.outlook.office365.com
 (2603:10b6:a03:39a::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Wed,
 25 Feb 2026 05:43:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001EE.mail.protection.outlook.com (10.167.242.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 25 Feb 2026 05:43:38 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 23:43:18 -0600
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
Subject: [PATCH kernel 8/9] RFC: PCI: Avoid needless touching of Command register
Date: Wed, 25 Feb 2026 16:37:51 +1100
Message-ID: <20260225053806.3311234-9-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EE:EE_|IA0PR12MB7627:EE_
X-MS-Office365-Filtering-Correlation-Id: b9bcf4d3-61ce-4229-6331-08de7430d36c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5ephTRnUL0djjIrbx71Io0FkSw4YQ8vqZTckhrWApKQcZYUa2c7aeW/jd/05?=
 =?us-ascii?Q?S5TISdFcZ9reCyJfCinNuFQOdfgEXCtFRuOH02ul0xkgIIs7tt50lKxXHc6A?=
 =?us-ascii?Q?//c28Iu/+oRUtlPliu55DwedGu5nsnnyhxTy+sR15plC5B2DE+gDD/ihxUEh?=
 =?us-ascii?Q?/Ux8BqtYqwwMXDkSq50Efa8q0TLOTwYWgXSPbp9X0ZBxmII1jMJmpTzFw3Fi?=
 =?us-ascii?Q?IDUZNoEpBNRbPv1TIRYtOAAjEbrxtyTVnOSLj5gQclFwlduGE20eMd/RQUnF?=
 =?us-ascii?Q?T0zeXbvgUH160cGT9c19anHejye5GxyoKwk25FR2rpZHXMXk1PENBtSR3cya?=
 =?us-ascii?Q?7YppKJS7C0xmy2SFchvwj1WpA2cMilrfok3982oTGX+Wq2BGJoQEPuiw5LWh?=
 =?us-ascii?Q?yZJw7ayPYNgXKKpMMeNBVaHx6Q9IGr7IYar454uUyI10xwGqaZUOqggFyLBS?=
 =?us-ascii?Q?Wey+xVwxLTeV5+5n/E7sf42YxK2ZTcg3kPj0mnPNPadZVKVKaIrgXda0DswZ?=
 =?us-ascii?Q?x8VEX7aklZjOoD5coGFjahSPTQjk8QlcFvzZCDBOBVMbhUPAiF4aOQgxpl/y?=
 =?us-ascii?Q?ESF5lkV9nluMnReDHZREGGBFVUpOJFrYXkzN5dGRnohj7p+ih9sKmcqodQVc?=
 =?us-ascii?Q?xQcV8bstgyn25FAVjAdbojbPHh51jsk5aLnhkGHBm4ACUwM8bcDmAdO/H6/k?=
 =?us-ascii?Q?rR9zvyzWNKbQEqY4+4ZSoSAmazw9l9PABYyjpVPH5cjhi6L+nGOGk6gNGluV?=
 =?us-ascii?Q?vf9YxTAfv9rjGr5bpJygK3ANg/ScNiQCD4cH13g5thCrLAV0aaW9fKbvWkGL?=
 =?us-ascii?Q?Zxt9WOkmOchNyCtd2NwdEr6cK4+1yiKA6Xb6yGs/owRRZR/HNw6gEZuPg8Wx?=
 =?us-ascii?Q?AS/mridDThCq9CpLX2JJEVtwdred4nIKn3QHb7qgy8/pS+TFVERpPbEqTt5Z?=
 =?us-ascii?Q?xT0elLNUJtFB/OoRSvIvoDM5J92WtbNNrbXq8qZ7Ylk23Lqf9E6kqErWYkyv?=
 =?us-ascii?Q?qCPywOCxkJZqhNTeezE3Xm/nvUmASQiMbdc/5xOYtlOg5Ds2pa+ZSBKWfRNu?=
 =?us-ascii?Q?Xs1lwpBuYNo7UBm26ZRfxSpXJ8N+L8QL0jPKkstNBrYSfckUs5Pzu6/Zb3zH?=
 =?us-ascii?Q?yIRnpba7p8/CEFZtB9PPxRawIzH4dIxyEV25V7C4Y6dGaQrs+NHHAnvzfBPp?=
 =?us-ascii?Q?5dZmzIpf5tBDn3toNwvOKtDk3g1MJ55vLl3EhDadoU+HeFHMBwEgDE7ctaPp?=
 =?us-ascii?Q?H4Cuapwr4IhJAjodEV1laQca+4+Roj7UVGm4Biyn1H+tVGnaVkAgg8ggQLYD?=
 =?us-ascii?Q?V/j/k7QOkfdk4AKNjNaVOnjNV7RWbRHoPGM5qnJODLoEA6v25VzCIQ6VQejX?=
 =?us-ascii?Q?BJSDX255pIEjnroETOvXeb2Dhz6aUlKqXP1LahHx6arxMfVgrL8GSAIKZqt9?=
 =?us-ascii?Q?ns1kbTnO/TZnoeC2Jx6DiZePTTJPynsFBWLWOsfVmLmsXBVXkhzIRIR2LWe8?=
 =?us-ascii?Q?8JiunfRdYllJ1+47P2zc5o1nfuQcY8xU187ZJIs7QTid9RubcR0ULTS4+lUM?=
 =?us-ascii?Q?gIJdv9n+OFtbp3HX18bxfd07EZlM2NZyE3BC6vGyniL6deKWWkUi70XhtVdB?=
 =?us-ascii?Q?nDazHwEtHoIEKYuhxiJnQwog8tzbAJuccGSrTzM69i3dsWza/gTBxgGOt3pu?=
 =?us-ascii?Q?UWCkxw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	10g9krEdChxyQ4dRzEqmNVi1O9Qs6xiAm1ZmUw/F31lNKH2dLgnVZhGak+lhdlxMI7BBzKZb5iO5o6e0NIbZ+2z/UtHrtTP7pnIvjoLgP5Cizxv0PvNNdwUupJafxJJ3BP9+wFc7lOC2n/6y/0ajxRK1LAjSHgfUIjFMmeU2SEzBZBxqw/C3ljBfFyHn08yTsqC5M6KTvRBR17n6uBtd3oW3Qb8Bm7pA9DvYLW1fwr/ihN4s2zVEpX9tpm4ye9ijcaj41Jn95Um8ATI2adXfIEt93Jb0YLu831ucHLQeeLJlQUGz8k1zxfm6iG8h6HNwIwuJc0Gf0nY5Bf84m/g/IU7h0RoX2vXGjqYjrUTVDg7qXeSG/tR4VjB2mmQVbIjoEEIEaQhPPquZb0SMi8pVeKx6POU4RszOW5lkyYN9VVth42XzoXRsmugA3N9vVO6v
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 05:43:38.6117
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9bcf4d3-61ce-4229-6331-08de7430d36c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7627
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
	TAGGED_FROM(0.00)[bounces-71793-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 623AB1921CA
X-Rspamd-Action: no action

Once locked, a TDI's MSE and BME are not allowed to be cleared.

Skip INTx test as TEE-capable PCI functions are most likely IOV VFs
anyway and those do not support INTx at all.

Add a quirk preventing the probing code from disabling MSE when
updating 64bit BAR (which cannot be done atomically).

Note that normally this happens too early and likely not really
needed for the device attestation happening long after PCI probing.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---

This is also handled in QEMU - it will block clearing BME and MSE
(normally happening on modprobe/rmmod) as long as the TDI is
CONFIG_LOCKED or RUN.

This only patch is not enough but reduces the number of unwanted
writes to MSE/BME.

Also, SRIOV cannot have INTx so pci_intx_mask_broken() could skip
VFs too, should it?
---
 drivers/pci/probe.c  | 5 +++++
 drivers/pci/quirks.c | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 4c3aec1fd53e..cc0613e7c905 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1930,6 +1930,11 @@ static int pci_intx_mask_broken(struct pci_dev *dev)
 {
 	u16 orig, toggle, new;
 
+	if (dev->devcap & PCI_EXP_DEVCAP_TEE) {
+		pci_warn_once(dev, "(TIO) Disable check for broken INTX");
+		return 1;
+	}
+
 	pci_read_config_word(dev, PCI_COMMAND, &orig);
 	toggle = orig ^ PCI_COMMAND_INTX_DISABLE;
 	pci_write_config_word(dev, PCI_COMMAND, toggle);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 214ed060ca1b..b875859699ba 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -316,6 +316,15 @@ static void quirk_mmio_always_on(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
 				PCI_CLASS_BRIDGE_HOST, 8, quirk_mmio_always_on);
 
+static void quirk_mmio_tio_always_on(struct pci_dev *dev)
+{
+	if (dev->devcap & PCI_EXP_DEVCAP_TEE) {
+		pci_info(dev, "(TIO) quirk: MMIO always On");
+		dev->mmio_always_on = 1;
+	}
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_ANY_ID, PCI_ANY_ID, quirk_mmio_tio_always_on);
+
 /*
  * The Mellanox Tavor device gives false positive parity errors.  Disable
  * parity error reporting.
-- 
2.52.0



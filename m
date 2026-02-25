Return-Path: <kvm+bounces-71786-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mFo8A0GLnmltWAQAu9opvQ
	(envelope-from <kvm+bounces-71786-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:40:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A65B819210B
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:40:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0B2F530DE2A6
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12132DC331;
	Wed, 25 Feb 2026 05:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="E9MdPTF3"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010032.outbound.protection.outlook.com [52.101.85.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4802D949C;
	Wed, 25 Feb 2026 05:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771997964; cv=fail; b=SFpC8EM65mtDZeXTMuox1wzYJTcKEfChlRzPlSSXYovxnXTLT8Te5/z2QcOavW8BgwBQlag/lUNEzNEX5QC02lFdBsoqhoWWzmeDaf6RZ9nQWc+eLTDVCPt5YOQ4y47xIVZfR7BH5iYotlQz7kM1GBoQ4JiCjFWOo2vM6a1c4dw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771997964; c=relaxed/simple;
	bh=UzbmdYKBoJv3JTwm/EJ1SDhzcL4dUhHNI6PL9sarYi8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oZB1HKZa+Tmj1UsYM8n//i+Xkbw1uUL3O1QWM7hTGOag8KT6mA1FMAaqbxoum7T1BlgMPttCel0lQpXO0GCKRfrZIY85oD7UW40KdyTKTYrlsGzZ+9rpmwggosglBv7Jt7jJFk+dN6mxSRshtGj6KSVtCUiwPahSg1qTUOjWUnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=E9MdPTF3; arc=fail smtp.client-ip=52.101.85.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KOVc4a4Cbe5tyyeSZkp1YGiZfXiTCse1h5qSclDTwvmM9rpqDd/oUfL8UOr+cGWoH49EuIiAInCoPfb+O8d8OtIhMcaQXuE082JJcij5XYJWx1arJ52UY3zyqjswRw/Ny93qE4hUiQs0cfc48pSJdCi7yosVYBI2nGcB62J+Pplv4Kem8nCBgGDGTE7Qv4SRoD8iSFKlbZjtQt9Vti9+M6GokQX0RMHNA9J5SLkvWE2wZeyt8IgzVJPQwxMqwZRCtH3UTZavQPOzWApdjuyWgylX9Q7QUf8rCO6q/bI2d/1R6j6BJRCuXsSPWEUIDqtBH/WtwmxtcIDxAZB+tglzHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AfXT2WHLsuEL10HLxY7D5Mdha+wbkxyxFnRzZsyWAKI=;
 b=gRAhbGSrRxHK9JDg52BsE/0D23T1SRa+y7e9m+xqrAhAbMYdnzNVl4PRkkVdk2ELQZKzUwipoFQ5UR999NLt3o3tDON59+llhm0SH9I2FF/35eLpYLV84R8AhIQfNVXnkv5mmvuWHE4tjAIBkyDk/DK7J2OvnvY2LH8zv/Wyx/rUZSqGw6rvVHlNJFs+SuELsHwKvUz/RP78UOjR4J88rlSB7ukr+eqd0ek5hP9O0RHABnG+0NmLtnRWswAtwybdWgkjKTovN/LfzWtp1VCR/9/D3Do46G8Fz7z45U9KdVffCEHwPP33XBSu9VYknVnRqT9nhoX0KRwqIbYrvI1WMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfXT2WHLsuEL10HLxY7D5Mdha+wbkxyxFnRzZsyWAKI=;
 b=E9MdPTF3Gqnhy9wUXOkK929flyVlJoxyldKDeWFSL8+wFpamOo7Ut/imS/Y/bS3LDduIJF8EZAM+FLGONDQtYp824I2W4AGWSCswszKqXTuSWp3C7OO1g8pirXjksg6Q8KwpWJumEVsaljDvx9+RFpBP8WIsfegTMTmAupq/apo=
Received: from IA4P221CA0001.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:559::16)
 by BY5PR12MB4067.namprd12.prod.outlook.com (2603:10b6:a03:212::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 05:39:18 +0000
Received: from BN3PEPF0000B06C.namprd21.prod.outlook.com
 (2603:10b6:208:559:cafe::fc) by IA4P221CA0001.outlook.office365.com
 (2603:10b6:208:559::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Wed,
 25 Feb 2026 05:39:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B06C.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.0 via Frontend Transport; Wed, 25 Feb 2026 05:39:18 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 23:38:56 -0600
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
Subject: [PATCH kernel 1/9] pci/tsm: Add TDISP report blob and helpers to parse it
Date: Wed, 25 Feb 2026 16:37:44 +1100
Message-ID: <20260225053806.3311234-2-aik@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260225053806.3311234-1-aik@amd.com>
References: <20260225053806.3311234-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06C:EE_|BY5PR12MB4067:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c2d5419-87e0-4cf6-4b9f-08de74303824
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmtFeDExcmlodndpTXFjVjgzRWlqR0JubkxrUnpZekhJSlNQT3h1R0pzd28w?=
 =?utf-8?B?UFYyN0JVeEJNVEhlUjB5K3pBMFRyQjU3RGdKbHFlRVZTelZQKzJHZWpiL2xx?=
 =?utf-8?B?d25idVF4S2RoSThNSVpKd0I3dVZ6WkF1UFdQUjNCV2djOHNHc2FEOUhrY0FN?=
 =?utf-8?B?M0NXMlVCQkhDYzFDcEQySGJGM25Na21lNE9ZbTN2b09VcFRTZHY4cWdXdzNF?=
 =?utf-8?B?clJaY0gzb3V6cFBhT2s5V0MwZ0NlWDNYWmwrSjJxTFhQMUlNSG53bTJaVUcy?=
 =?utf-8?B?NWtDbktwOSt2L05QK3lreUxpSTVhenZKOVZNd3c4eHJxM1V5WjRTTEEwYi9G?=
 =?utf-8?B?d2xCSkhLQm8rWGs4Zks0b2svNERmL0drTW8zWE4weUtFVEFvNmUwdzlnTG1Y?=
 =?utf-8?B?TVVLcVBLTG9hYVhMY2F1bDhuZ3hJK1U1QXZ4TEU2QkMwM1BaNktIWklKbXVE?=
 =?utf-8?B?NVdMbDFBYno4Wk92OG0xOFVBeGtZRDRndHg5VGhwL1AvV2VqZHozK3RXVnp4?=
 =?utf-8?B?VXdwNWx2dG1DQzRsY1p0U3ZMUnBGRVhJWmNqbTY1aEltUXBlK3R3NjZjalkr?=
 =?utf-8?B?c2VKbFYxTWtlRm5mVVhkV2cvdzdic21zUndNWTNnMGNTQ05IbkQrUmROY0o3?=
 =?utf-8?B?SzhPWHQ4TGE1VnZpSVJZZW9GV2Z4YThvWEhnaFpyaDFSQ2FVOUJYK2ZmemVI?=
 =?utf-8?B?aG1jUWRLWk1rMkxpZ0sxQzRwa2xtNEhTcVRtWU1QOW45OU5mSjNBVWRXeVZT?=
 =?utf-8?B?VzZQRzlPbE4xNkwvdms0Z0FXOU9wSkVDNElSTDJLVThGaUF1R3VvMXd0UnMw?=
 =?utf-8?B?dDM2bUN0YmFWUkpmRC8wTzZORno3c2w2WGN1REplamRjMnFmaXVFVEU4ZWJv?=
 =?utf-8?B?V2RSa0dJOU5jMHY4OEUwWnFCNW5yMVMrYUxuM2NPbmtkZjNMcndPM2pYQlkr?=
 =?utf-8?B?MDVPSjRla0JvZU4rQkpteFB6NzdsWTVVNW4yVTM1V0xxT3JTWDlmZ0FZK3FQ?=
 =?utf-8?B?Ri9Ja1g3QUk0Sks5MXdmWGZRQUd3OXowQmZyOEQwalpWYk9lS29YSmQ5c0Mx?=
 =?utf-8?B?VDJwMmc1M2YwNThuTDJmaFYxZVpEbWpodk9xSlNDRFlqK3UreXREcUJuU2Zo?=
 =?utf-8?B?T2NKdzB0RHJYUStXWGVtdDd2S3NUUXcySTVxS2ZpTlhuRkFLY0l0d1lzRGJH?=
 =?utf-8?B?NXlZbEhZY1Rtbk5GaEQrV2FoOXRQOTNpS1l1cFhhVHY1Yk9pcGVNMmt0dDJI?=
 =?utf-8?B?R0FXMVVSeE9jSVRVVzhhWHkzTng3YnhMN0g5azd6dEN5Ym1xUU43bWlYTWpV?=
 =?utf-8?B?Q3RMUXN1cWRmdkVGaU02SGg1Mzdaamw4RW4yVmNGRHRoeCtYaHNVUmRrblFr?=
 =?utf-8?B?OXczeGdtL3M4enc3MnhrdmNpMTZLajZBWFA5bDBRMXRNS0tUU2VNRTVZa0Nk?=
 =?utf-8?B?MnRNeThaSnRIeExSM2djbVhrTUEzZU1VNkdTekd5TmNvM01hc1IrS0xJVFpJ?=
 =?utf-8?B?bkNLcE5Ra0tZeFpxRHNhTlpJbUUwcEMzM3k2MlhVVVVXYkh2R29SZ0Rxb3Jx?=
 =?utf-8?B?Y0E3R3VkZnVjYjBMaFlTTDBNMUFxcDZkV091TndPVE04MThOaU1sYVBKM2Vh?=
 =?utf-8?B?VzliZXlrdXlCMjdUcUdCM29ZNzZ1ajBxVzZaeUdMSCtjQkI0U2grU3I5NlJY?=
 =?utf-8?B?aUJBNDIxeHBTK2xEeDFRdmtBaGhIbnU1Uy84azRnK3pJVDlmdnJaMS9XRkph?=
 =?utf-8?B?VS9KWXo3d0wwcnh6NDNDR0V0SFErd3Y1UkZjYnB4YS96ZnNtUHNzejdxT2hJ?=
 =?utf-8?B?UFFDNFlXaEM0N2NoTjNyUmJjSStORGVJa2lrNWJ2QXlrTEZOTEtZdWEzamJW?=
 =?utf-8?B?MGxCYXdSNk9WdjlBa3ZQYUhXMWt1bFVxQzc0VlZkTFB2YlRvYjBFYWNiRTI1?=
 =?utf-8?B?aVBueUN1M2pmY25rNjhtWU1MZW8rb0RrbUU2L0c3TzcyUUdLUzJraWpKQjlj?=
 =?utf-8?B?L0gzZ2lXWVRWbmxManpQTEZONkNDR3owcjdlUkRVYjkvR0J6OVg0RUZHbjZV?=
 =?utf-8?B?WlhjMXBMRDU2TlhlSTJQUlV3ZjNqZHNkSzQyWmlzd3lCcUlxN1dtVk44WGlK?=
 =?utf-8?B?ZExQMU5HZEt5S1RFMjJrOS9pWWpvNk44cTdNOTlwTWlBbjVTTFJ1SFAzbnk4?=
 =?utf-8?B?QU5EVDR1aUpmd1F5RUVEakhNcnliVSthTVdlRzRVSlNLWVRnMzJhbjJmZGJ5?=
 =?utf-8?B?eHd6ZzFKcU5ZeHI5NWluMG14a25RPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NiEEf0D3gGcRZAtTx9IgPg31bTONcV2EJuyR0VmBvTvq+Dw4AvAZM+veHVso8siZuvyM9ssghVq/fbEJrNea/mtR1xdwFa81C3eCvU6F+uLKO8KKHRoXSvCX+Z7mOWltJiRcV1JVgZFsyCkBkH784eP96MuyuQawR43Q+aPgEv57IpCMgn/VuFg7/4K6ynsaW66s4E3DigXz36DxaKP1Z75VVHCp9XUDk7nbpNrTkFfb34OMENK/RIOQKIeNTDr9nRffmEfEtTHhxxtDrQoK7XFXa4lUte38e0yxo44OSALkb7WXGzXU0ddKQEaQT0E2eECBDz8s12WkzaiYSO4p4Ql3reM2XUFm81T4tdzrkoCk1pqm1h6944BeVgEC6dYWPMifz8Li2QxSkbRkpgV2O69MoQlZnS4Ar5HyLQiuqYoSjjXij9HDejQ0n1B7o5dM
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 05:39:18.1914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2d5419-87e0-4cf6-4b9f-08de74303824
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06C.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4067
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_SEVEN(0.00)[7];
	RCPT_COUNT_GT_50(0.00)[58];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71786-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: A65B819210B
X-Rspamd-Action: no action

The TDI interface report is defined in PCIe r7.0,
chapter "11.3.11 DEVICE_INTERFACE_REPORT". The report enumerates
MMIO resources and their properties which will take effect upon
transitioning to the RUN state.

Store the report in pci_tsm.

Define macros and helpers to parse the binary blob.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---

Probably pci_tsm::report could be struct tdi_report_header*?
---
 include/linux/pci-tsm.h      | 84 ++++++++++++++++++++
 drivers/virt/coco/tsm-core.c | 19 +++++
 2 files changed, 103 insertions(+)

diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index b984711fa91f..7987ede76914 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -10,6 +10,18 @@ struct tsm_dev;
 struct kvm;
 enum pci_tsm_req_scope;
 
+/* Data object for measurements/certificates/attestationreport */
+struct tsm_blob {
+	void *data;
+	size_t len;
+};
+
+struct tsm_blob *tsm_blob_new(void *data, size_t len);
+static inline void tsm_blob_free(struct tsm_blob *b)
+{
+	kfree(b);
+}
+
 /*
  * struct pci_tsm_ops - manage confidential links and security state
  * @link_ops: Coordinate PCIe SPDM and IDE establishment via a platform TSM.
@@ -123,6 +135,7 @@ struct pci_tsm {
 	struct pci_dev *dsm_dev;
 	struct tsm_dev *tsm_dev;
 	struct pci_tdi *tdi;
+	struct tsm_blob *report;
 };
 
 /**
@@ -271,4 +284,75 @@ static inline ssize_t pci_tsm_guest_req(struct pci_dev *pdev,
 	return -ENXIO;
 }
 #endif
+
+/*
+ * struct tdisp_interface_id - TDISP INTERFACE_ID Definition
+ *
+ * @function_id: Identifies the function of the device hosting the TDI
+ *   15:0: @rid: Requester ID
+ *   23:16: @rseg: Requester Segment (Reserved if Requester Segment Valid is Clear)
+ *   24: @rseg_valid: Requester Segment Valid
+ *   31:25 – Reserved
+ * 8B - Reserved
+ */
+#define TSM_TDISP_IID_REQUESTER_ID	GENMASK(15, 0)
+#define TSM_TDISP_IID_RSEG		GENMASK(23, 16)
+#define TSM_TDISP_IID_RSEG_VALID	BIT(24)
+
+struct tdisp_interface_id {
+	__u32 function_id; /* TSM_TDISP_IID_xxxx */
+	__u8 reserved[8];
+} __packed;
+
+#define SPDM_MEASUREMENTS_NONCE_LEN	32
+typedef __u8 spdm_measurements_nonce_t[SPDM_MEASUREMENTS_NONCE_LEN];
+
+/*
+ * TDI Report Structure as defined in TDISP.
+ */
+#define _BITSH(x)	(1 << (x))
+#define TSM_TDI_REPORT_NO_FW_UPDATE	_BITSH(0)  /* not updates in CONFIG_LOCKED or RUN */
+#define TSM_TDI_REPORT_DMA_NO_PASID	_BITSH(1)  /* TDI generates DMA requests without PASID */
+#define TSM_TDI_REPORT_DMA_PASID	_BITSH(2)  /* TDI generates DMA requests with PASID */
+#define TSM_TDI_REPORT_ATS		_BITSH(3)  /* ATS supported and enabled for the TDI */
+#define TSM_TDI_REPORT_PRS		_BITSH(4)  /* PRS supported and enabled for the TDI */
+
+struct tdi_report_header {
+	__u16 interface_info; /* TSM_TDI_REPORT_xxx */
+	__u16 reserved2;
+	__u16 msi_x_message_control;
+	__u16 lnr_control;
+	__u32 tph_control;
+	__u32 mmio_range_count;
+} __packed;
+
+/*
+ * Each MMIO Range of the TDI is reported with the MMIO reporting offset added.
+ * Base and size in units of 4K pages
+ */
+#define TSM_TDI_REPORT_MMIO_MSIX_TABLE		BIT(0)
+#define TSM_TDI_REPORT_MMIO_PBA			BIT(1)
+#define TSM_TDI_REPORT_MMIO_IS_NON_TEE		BIT(2)
+#define TSM_TDI_REPORT_MMIO_IS_UPDATABLE	BIT(3)
+#define TSM_TDI_REPORT_MMIO_RESERVED		GENMASK(15, 4)
+#define TSM_TDI_REPORT_MMIO_RANGE_ID		GENMASK(31, 16)
+
+struct tdi_report_mmio_range {
+	__u64 first_page;		/* First 4K page with offset added */
+	__u32 num;			/* Number of 4K pages in this range */
+	__u32 range_attributes;		/* TSM_TDI_REPORT_MMIO_xxx */
+} __packed;
+
+struct tdi_report_footer {
+	__u32 device_specific_info_len;
+	__u8 device_specific_info[];
+} __packed;
+
+#define TDI_REPORT_HDR(rep)		((struct tdi_report_header *) ((rep)->data))
+#define TDI_REPORT_MR_NUM(rep)		(TDI_REPORT_HDR(rep)->mmio_range_count)
+#define TDI_REPORT_MR_OFF(rep)		((struct tdi_report_mmio_range *) (TDI_REPORT_HDR(rep) + 1))
+#define TDI_REPORT_MR(rep, rangeid)	TDI_REPORT_MR_OFF(rep)[rangeid]
+#define TDI_REPORT_FTR(rep)		((struct tdi_report_footer *) &TDI_REPORT_MR((rep), \
+					TDI_REPORT_MR_NUM(rep)))
+
 #endif /*__PCI_TSM_H */
diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index e65ab3461d14..3929176b8d3b 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -16,6 +16,25 @@ static struct class *tsm_class;
 static DECLARE_RWSEM(tsm_rwsem);
 static DEFINE_IDA(tsm_ida);
 
+struct tsm_blob *tsm_blob_new(void *data, size_t len)
+{
+	struct tsm_blob *b;
+
+	if (!len || !data)
+		return NULL;
+
+	b = kzalloc(sizeof(*b) + len, GFP_KERNEL);
+	if (!b)
+		return NULL;
+
+	b->data = (void *)b + sizeof(*b);
+	b->len = len;
+	memcpy(b->data, data, len);
+
+	return b;
+}
+EXPORT_SYMBOL_GPL(tsm_blob_new);
+
 static int match_id(struct device *dev, const void *data)
 {
 	struct tsm_dev *tsm_dev = container_of(dev, struct tsm_dev, dev);
-- 
2.52.0



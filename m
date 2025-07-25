Return-Path: <kvm+bounces-53442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1D43B11C51
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 12:29:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAFD9542C31
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 10:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A772B2E0400;
	Fri, 25 Jul 2025 10:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WfOTK9A9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B7D2DE6ED;
	Fri, 25 Jul 2025 10:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753439346; cv=fail; b=MAY+UW5NIzLPL7USOnqfjYCyeVJDcIWgulGAc7m6A9yhwglboU6oJujaRFBe0Xom+KhodDVU1GKZzoCUv76+pLwalUC35eqgpx5RVzr7kg7B1cHVQwMjT02H/eiGKUeEpsBdGY6F0w5f2WvfB4DvBhYB8tjkhOJp2wAM97QUHz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753439346; c=relaxed/simple;
	bh=Z13+IH3KNV0EJPr4rRkAXt6lpLUpG2TE9+CNIhg1qYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=pnwpRniiYXK730ad8wRUV/XOxbF9icieF5QplB9be5cG8EKaWTAKrdAhSx9tSXQK51M4L6gbldCmzA00qrnGhinbTL/MI6xsZUKu/ddlYInxBYxqhMTFAcU3ShOk84cXRNSGzbQTH/DrJMjun/niQrBU7BuJp1hdbYu4cpxkXmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WfOTK9A9; arc=fail smtp.client-ip=40.107.223.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mwMNpbKgiy1aV7xCJhVLvQEBvHV6PCvp57ajGyHDKROAMV+1q+GapHfAOh3kwh4Kt83FdBNWO/GSfLRUPzkT3K2RsKdgoIcFNWOCihPV4h3Zx3kwjQMrQLt53fEQeyrf80il2U3op4198M0bNEAzN1s5qvDH1Aac00fHaqmVByuCRYj4G8G4OeuEEoY8kfpCPSbtk8t5n4CF/DCafZFWx7DqSvGtN1ZemX7HLKQVlDtriAJ73s2qVGe54x+r4JwtEA4kKzEhQokpVR3YOVEqJEygnIzuhkWvukA47oFJLgY8Bod4zlg/zspWAw+1DNNFLJ0H3gwV1B48lTAuZyQElw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IrIgOP06zM2s8BQ4/mT/0gveqxUtew3v9b0S+k49Qoc=;
 b=TGna/h+brDme64CDPirMaBxySn5YrObk4R7M8sN1wOKV53dQWv2OC8MewY52MTdI38D/MUqhkRkjH72IWrxprR/9mDRh4X1G0zsYyqm97rE+s/7MjwbD+LAVdyRsleKx6qOO2Ewk/fPadNlAcUtkm4Dm45lPJjuD9ODXk5YOQgqpZKxhnQBWZi2Bvd7ylssus/Hw/sEMVBdPtbnkmuWAyU2pomI5Ao0s1Hy4X3Fukq0lr8oaZaY7OwkOk7X6jkvKY1ujV1UZNb1Fmsv1+WlSzg1jg6qaPU6ZdsaN+yZ8KimC6b/SDu878oDAZaOF2qDNtxc0FZo0pJZKfkrL5E/jkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrIgOP06zM2s8BQ4/mT/0gveqxUtew3v9b0S+k49Qoc=;
 b=WfOTK9A9zgFb4qAqN1k0EJj32pCWKuqQdFiBVYu2eUw4IfiiHMgidGRhnoob6opBnPqmoenmF4RCMEZsyAkQKRYlXEHsLtMGypD4q6iqi6y6VFlqt2Vwcsw8y8G3EFRWIqdfO2arvooacRg5a8qk+6hMM78JqQP6u8yGFjP7GC4=
Received: from SJ0PR13CA0092.namprd13.prod.outlook.com (2603:10b6:a03:2c5::7)
 by MW4PR12MB7165.namprd12.prod.outlook.com (2603:10b6:303:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Fri, 25 Jul
 2025 10:29:00 +0000
Received: from CO1PEPF000075F0.namprd03.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::43) by SJ0PR13CA0092.outlook.office365.com
 (2603:10b6:a03:2c5::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.7 via Frontend Transport; Fri,
 25 Jul 2025 10:29:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000075F0.mail.protection.outlook.com (10.167.249.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Fri, 25 Jul 2025 10:29:00 +0000
Received: from [10.136.41.253] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 25 Jul
 2025 05:28:55 -0500
Message-ID: <4134f54f-9b01-47fc-be40-6829aeae1fcd@amd.com>
Date: Fri, 25 Jul 2025 15:58:52 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] iommu/amd: Add support to remap/unmap IOMMU
 buffers for kdump
To: Ashish Kalra <Ashish.Kalra@amd.com>, <joro@8bytes.org>,
	<suravee.suthikulpanit@amd.com>, <thomas.lendacky@amd.com>,
	<Sairaj.ArunKodilkar@amd.com>, <Vasant.Hegde@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
References: <cover.1753133022.git.ashish.kalra@amd.com>
 <6a48567cd99a0ef915862b3c6590d1415d287870.1753133022.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <6a48567cd99a0ef915862b3c6590d1415d287870.1753133022.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F0:EE_|MW4PR12MB7165:EE_
X-MS-Office365-Filtering-Correlation-Id: 407b3152-fbda-4f9a-52ff-08ddcb6611cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WnNEYmVOb2NPK1lySzRNYmR4QjFpYzN5WnJnbTBBazJIUmY4Rlg1RmJjRXhK?=
 =?utf-8?B?U3FuM2wxYjNzUWhDM294eS9nYnB4YnhMRGhIYW1RYTlDc1FhdmU5aXVuU29D?=
 =?utf-8?B?dVdLWnR2bld4dnhBR2V2aERaTzIzVDZxN1gyZFlCSkJ0RHZOaFg5dWxrV2wr?=
 =?utf-8?B?Rm5LVXBDN01GU3BCejlJMVJ4LzM2TDM2ZFhOUHFxY202UU9DQjJsQm5NenZY?=
 =?utf-8?B?aHdGMmdrUFNyRTdMUit4bCtGWllNUmJPQnlxNkwyREg1TnFJUm4ranp4VkRB?=
 =?utf-8?B?QWhZSXAwY3Z2WWY4Rkw3TlZOWE5FZDdZYmI3VFVKcTc2Q2MyNVJhTWk5S01s?=
 =?utf-8?B?a01odm1rQzlOeXoxVnhKblFEMjN3Yy8vWGFoMXUxZVpaZnNJeUNjUU93TG9p?=
 =?utf-8?B?UHZZMDRiUHRjZGxFZFFiYTMxbERNRlZwY1FnK0FHQWFBOUxEMktCNmh5T3BU?=
 =?utf-8?B?cWV2K1FtbkZqZUIxbVg0YS9GQkhuUGFwcXczWU9IL1RZUVNXOTdTdVM1bHV0?=
 =?utf-8?B?d2RNdmJNTFAzZDlhTU05YXl4bDhvRlhDSy9rYWQwZWJHV3pwRXEwM0RNSlBF?=
 =?utf-8?B?K05JV3htRCtOc0lGUytRcTZRWjRrVDl6bmw0cGFOcXUvU2x1TzYyQ0ovNFBp?=
 =?utf-8?B?SkNRdWpEWXd5bld3bHcvcFBadVd4UjJYYmdzbU92UVV2bmRaODFBRld1SHVF?=
 =?utf-8?B?YXFPemgramRpYUZUQkh3NmpJdUFMVzdyY0E2eXcvaXVHbjBsMUoyM2dscUxm?=
 =?utf-8?B?NDNrYkVMem53L2pNVXFuc3hacHhwa01IQVZoUng1M0pDWGVpdURMTTZKakRq?=
 =?utf-8?B?TVd4TEZoRVZSMHA3cHhDaG5saUJ3S0Zkdk9ydFZ4WkJuM0xoVG5veHNVYUo1?=
 =?utf-8?B?R2NXd2Vwa3VKcThIV0thbWhYc3BWd3FsTXlHMWNUbE10a2hHNE5FNHh0RHlS?=
 =?utf-8?B?NmNKUHBjOGVHbTFuYkMyMGo2bVFpZTRlendIWkFIY1FXQjhlM28yMFFzU2FV?=
 =?utf-8?B?SXpuL0pFVHlubW84QmV4bnVhS0NDSmw0V3MwOGdFa2QvZVRVU2licGJGdkJo?=
 =?utf-8?B?bkM5NGNIT0VheVZlZmtBYzlWbG9rQXFCZ0F1ZmtKNFBDVHVBUW1kVzUrdUZV?=
 =?utf-8?B?elFCWDJRVUtjenVCMXVDOTAyYzNrbG82b0FaZDlVMFpyUFd2dWdmNHdTMDI0?=
 =?utf-8?B?OGZ0YjBmb2Jpa0Q4SCtnUm1DWkxRUFFIYkllSmh0SVdsQXA5WVEwMmdvUFlj?=
 =?utf-8?B?MDZTY043WFc3Q0VpMmdLRXZOejVVZ3laeU9QeC9hdHJpOEp5Z0EvYjZLam5l?=
 =?utf-8?B?OW5CMURSWVd4VGZQZmVuNTdqLy9aOWtYSG1wNHN5TTVvQmFhSVB1THhMcmdJ?=
 =?utf-8?B?bkgyUDJ0UjNWUVd0cktlL1JtMS9jQmNpSzh1d0F2R2xQNmFNNGdUdmlOOHNn?=
 =?utf-8?B?cU1ISzd5cHRwQ3FIbEhNUC9zaXJSNDduMVpPME01VVVNNHdRRzJyamEwMk1O?=
 =?utf-8?B?RnpyOVhaVGhQYnNiVThCUTQ3NndZemRHa2dCWnhoRWU4YlpDMHhydEhUUFor?=
 =?utf-8?B?eGFURUJBbEhObC9ZRG9ObWhiUEgraUpxUFFvTVpEU2gwTVlZVHFGcGUrNmhE?=
 =?utf-8?B?Sk5Rb1RlSEx3OWgwdFNOTENCejZCdzI3c2lha1Raa2d6T2lza003SlgzNWdM?=
 =?utf-8?B?WEx5NUEwMnp5NWlXRXJ4ZVBwUlhkczFCWWdESDVKS3BqOXo0TWNwKytlWlpn?=
 =?utf-8?B?Y3ByK3hLWjNjc0VMaGdLaTh5MUZuNHZkbGg1OHhBdVdxakdkVlhsSGs3QWJv?=
 =?utf-8?B?YWlsQTR2NXYwZlZpMURpcjViUEt1dnpTYzg2ZXQrYXc2NDM3OXFHS2dONkRk?=
 =?utf-8?B?ZysxY0VNWU1kcXlkZlEzUU9Kb0t6b3BETlhxY003U2ZJK3hiNkgwbmJRS2VS?=
 =?utf-8?B?NE1YS3FWcHVCc1UyNmpSRFVOMGhpamFXQjhvdDdiUXNJbWo5SDhzZ05DTTF4?=
 =?utf-8?B?bDZ3blFFYU5KNmN0Z1hMRmZ6NitYVElLWm4yN3E3M0JhZXpNMlV4VkFiSHFP?=
 =?utf-8?B?NXk3aCtGNEtoSk9uWDVHbjNqa1I0R05ZQ2ZJZz09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 10:29:00.0846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 407b3152-fbda-4f9a-52ff-08ddcb6611cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7165



On 7/22/2025 3:22 AM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> After a panic if SNP is enabled in the previous kernel then the kdump
> kernel boots with IOMMU SNP enforcement still enabled.
> 
> IOMMU completion wait buffers (CWBs), command buffers and event buffer
> registers remain locked and exclusive to the previous kernel. Attempts
> to allocate and use new buffers in the kdump kernel fail, as hardware
> ignores writes to the locked MMIO registers as per AMD IOMMU spec
> Section 2.12.2.1.
> 
> This results in repeated "Completion-Wait loop timed out" errors and a
> second kernel panic: "Kernel panic - not syncing: timer doesn't work
> through Interrupt-remapped IO-APIC"
> 
> The list of MMIO registers locked and which ignore writes after failed
> SNP shutdown are mentioned in the AMD IOMMU specifications below:
> 
> Section 2.12.2.1.
> https://docs.amd.com/v/u/en-US/48882_3.10_PUB
> 
> Reuse the pages of the previous kernel for completion wait buffers,
> command buffers, event buffers and memremap them during kdump boot
> and essentially work with an already enabled IOMMU configuration and
> re-using the previous kernel’s data structures.
> 
> Reusing of command buffers and event buffers is now done for kdump boot
> irrespective of SNP being enabled during kdump.
> 
> Re-use of completion wait buffers is only done when SNP is enabled as
> the exclusion base register is used for the completion wait buffer
> (CWB) address only when SNP is enabled.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>


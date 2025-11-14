Return-Path: <kvm+bounces-63188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A53BC5C15A
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 09:51:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C913E3AFB47
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 08:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF5F3019AB;
	Fri, 14 Nov 2025 08:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0iXF0whF"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012026.outbound.protection.outlook.com [52.101.43.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093E5301036;
	Fri, 14 Nov 2025 08:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763110250; cv=fail; b=NXx6gqzMAybW2i6rQ4KN2aNgPGPGL+nqqvSiI1spHVRYY03Wlk6UgnHr02LPFolaWVmIAomuuAS0H0EgwypMYXG1v594p3TeUaV3qYs/+8+MSUL0tabsNG+yXFlX9i9OwFe/QvrKWJcWGRW+8sWcA8zsObSvPhovAmOZm61XyS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763110250; c=relaxed/simple;
	bh=Jatfh1LqFT0Z6g0fRaiwhQcH5BCN+WtED0LUX4gU92g=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=a9yWSvvwU5HFxeH4fDcHeZ3r31PaCUCX48nBJOn3XgfQ/uXdIzgXpI+Vja8D3fGf9mz6F1IMIsxmOL0+bg4s2RaFtJM6KVqU7oPgJd0agQOZf1cjr/AVY4kidVwiNxgeGjYBX8R/gjFekAS4XjAfnkegN1VjMaBvZ45o8X2o7gQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0iXF0whF; arc=fail smtp.client-ip=52.101.43.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KxhvSQJ5asEZKDL1dJJHhmlUy6UqKv457SNRQXQwsKgKKvF6f/n1TrOni+QJ1M7V+ANn69y7AsTenBa6If97pgVBPW20Sw3k95N74BBKznZgswLmyaPrNMUE1LOHruMQHA7NVepqt3NF/wnyJWb8KQ6GU5ylhnJ5ia/+ak63iCcwgQrEZ0AWNz+ejxyesNX05sjc9eSbjat+a/FuOFXfUu2+1DdYVIUWI7BDNZFqEkLKAnl7Faajr0uio0kb9UT+4SqKluMRW8wXjGNzxWXFgDgMd+au206AGXfH8QLkrgVRKFfxXxg03ekwpbws74u8VRoNodz7mcBNfTTubhqzqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=41wlrGX3X017tGUy9+1TJFC+zNr8bm15+YZC87sQFjY=;
 b=VgWwxaBwmkxEvg4wo8wWx3rcJU5jywOxwYCCw2ZBosstM+L5rW89jjwEiXLk1pE8Tp4xVRQiozaB/U69vx3rVLUTE9icJSmZ1wJR1fLrLueXWWNAMcCQ2m1kJAhhswrAuKFzOuA/nT3eTzAyzrrXmQDeP9o9aPhAKjlXArR4A7ciYUpzpW9vbKxa6GRe1Xni+veg2eIu1/48y2LoMpdGIhuCKZfUS75i8lsBCXq2zwLWGQh4DXwleI0iKQn2ZG9v6IS0p38T9mYJoRTvSWhMLjRzFkVGPKJJLkKOg9crt10o9brj2JX/dfA0AMaTS0ujha63A9ebyjGbysP6+31M1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=41wlrGX3X017tGUy9+1TJFC+zNr8bm15+YZC87sQFjY=;
 b=0iXF0whFKDWFi1hxozAG4LjkvfS3N3s/IZ7GB+utratVCBeWE9wNkGajLG8uG/vGSx66PCceMfM9KfgMIfHkt43n0nryVAfEp1BBteF54npOJU36QDUSX4AFiW62vR9E8VfA06uBSNcIE6TUiW47esHJ1LfbMuOEMJOSODDZHyQ=
Received: from PH3PEPF000040A5.namprd05.prod.outlook.com (2603:10b6:518:1::54)
 by CH2PR12MB4054.namprd12.prod.outlook.com (2603:10b6:610:a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Fri, 14 Nov
 2025 08:50:41 +0000
Received: from CY4PEPF0000EE36.namprd05.prod.outlook.com
 (2a01:111:f403:f912::2) by PH3PEPF000040A5.outlook.office365.com
 (2603:1036:903:49::3) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.7 via Frontend Transport; Fri,
 14 Nov 2025 08:50:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CY4PEPF0000EE36.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Fri, 14 Nov 2025 08:50:40 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Fri, 14 Nov
 2025 00:50:22 -0800
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 14 Nov
 2025 02:50:21 -0600
Received: from [10.136.45.190] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 14 Nov 2025 00:50:15 -0800
Message-ID: <5fbd65ae-40a2-4434-af44-84c749e5fdd2@amd.com>
Date: Fri, 14 Nov 2025 14:20:14 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] KVM: SVM: Add Bus Lock Detect support
To: Sean Christopherson <seanjc@google.com>
CC: Ravi Bangoria <ravi.bangoria@amd.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<pbonzini@redhat.com>, <thomas.lendacky@amd.com>, <jmattson@google.com>,
	<hpa@zytor.com>, <rmk+kernel@armlinux.org.uk>, <peterz@infradead.org>,
	<james.morse@arm.com>, <lukas.bulwahn@gmail.com>, <arjan@linux.intel.com>,
	<j.granados@samsung.com>, <sibs@chinatelecom.cn>, <nik.borisov@suse.com>,
	<michael.roth@amd.com>, <nikunj.dadhania@amd.com>, <babu.moger@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<santosh.shukla@amd.com>, <ananth.narayan@amd.com>, <sandipan.das@amd.com>,
	<manali.shukla@amd.com>, <yosry.ahmed@linux.dev>
References: <20240808062937.1149-1-ravi.bangoria@amd.com>
 <20240808062937.1149-5-ravi.bangoria@amd.com> <Zr_rIrJpWmuipInQ@google.com>
 <a704b1f7-a550-4c38-b58d-9bc0783019f1@amd.com> <aRNTADUbIGze6Vyt@google.com>
Content-Language: en-US
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
In-Reply-To: <aRNTADUbIGze6Vyt@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE36:EE_|CH2PR12MB4054:EE_
X-MS-Office365-Filtering-Correlation-Id: d28416f0-5eae-4335-2efc-08de235ae3d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Ty9QSm85NGJadU9IVDRvaWJHS0R0UWhLSk9sTTdveUFiY0R4Z1BnZ0s2d3JL?=
 =?utf-8?B?UExJcWZUQS9HNEVmSitiV01xdFVGSWNoekw2cUFwWGpYbUc5VVg0dEExcUhj?=
 =?utf-8?B?SHcvMG1Ib2tBZkpIQ2NJbC93cm5MRFVuRno0SkFncXlsQWRJQ2FndFA3c2Vs?=
 =?utf-8?B?Mi9wUEZTck5yelJEZWdWTVc0RlNnTVpaSHQrbExxd1c2b3YrOWlIenFvREs4?=
 =?utf-8?B?OERiVjZpb0txcllSSW5pMGNVajl6ZW9aMTI3MWJmYThiM2tSZXI2Q1dxdGVj?=
 =?utf-8?B?YzFIcm9Ea2NhYURMUXlWd25FNG90MnlZcXpzM21BYVB6VXpLVkdvUy84ZG0z?=
 =?utf-8?B?T0tJTnB6QjRjUWN6MkVRTFUzV2E5OXR4b0dLanhUbXBscmtNZFY1T003VVVS?=
 =?utf-8?B?d0dRT0RFWlFLT2kwZU56cUxLbk5CTG9meGgyV0xCVWJhYjgwRU9hZEx1UFhD?=
 =?utf-8?B?QXRDdWRjQytZbm9MUEtzSkJ4azdLMzF6SktYd1ExYWQyci9zemFZMUR4UVB3?=
 =?utf-8?B?MndhaWkvM2lHRXo2L0Urdmc0OEZnZytYYSttckQ5T05XT1dxQmhSQ21hVEtO?=
 =?utf-8?B?eE1PSDgvUmtISHJKeXB0Z1BXRE9lOVhhbldXSGErY2dmWXJVN0tCS01OOUFZ?=
 =?utf-8?B?ZVN0c01qaGYyQ2tlN0Y5Z281T1A1cHVnT2NSQzdBbjBLblpJT2V1RmVDb3lE?=
 =?utf-8?B?Q3dpSGhWbENNbjdtS1JXMjhweXBsZ0JxcG56S0VCTnp5NktrZ3cxZmVlbzdn?=
 =?utf-8?B?SFJJQlRmU1lkNlV4UWhwMGxQbVJpclZDMTlzbldLTFZlcFRQMGZkdDMrdS9q?=
 =?utf-8?B?L3pSbm1STUpRM0tFd1htQjh1R0h2SndDc1BFZ3kzNU1CMVBlUnZ4akZFMmRv?=
 =?utf-8?B?RUFta3V2QVB3MmtZblcydi9DTGY3QVJzYWZjMWFxT2RzWFljTVpFVDJEVEhD?=
 =?utf-8?B?ajRqcG5veWlPL21BRTV2T2pBWHhWdnpOdGU3SXgrdXJoVVVYb29OVVRMR2hy?=
 =?utf-8?B?Z3NHOFF0RUdDZnNPSVN0citnNUtvaVY5Q3B2bXpOUnJvQmp5OTIxQ0VLNG4x?=
 =?utf-8?B?emNRbFY1OU1pVlRFQzIzT00zcVJmWHBSTjNiRWZqTHRhTUdIeWI4b1F3bGlT?=
 =?utf-8?B?ZjFXWjBmQ1dtMTVoVkt0V01RU0ZlVlJiMGhUOTFvSkRyTzd0dUZVeVJ2V25r?=
 =?utf-8?B?YjdmRFNyU0haam03Sk1nTVNmdnZ1TWNZTkdmTEliK0ZwR1FkZzY0SGJDZG53?=
 =?utf-8?B?bjhmNExmVWlIcmVFV29zMDk5QWZNZDZCdmhTazAzQkpUN1BGS0NVdnlsNWJi?=
 =?utf-8?B?bDloK1ExTGh3VXB5NFEya1d0L3pCS1RqYjVlVXlaa1UyemdKN3c0NEZGcmsx?=
 =?utf-8?B?akxvVGZDZTJzNWpyVGF1OEFGQlJiRHBUdHhMOEEvSGYwT25lWWFESlpPbXl2?=
 =?utf-8?B?YkxLK2IwblRiKzJZNzhjczBRTUJQYjhjVWtwaHQ3T2lhdkdEREVsVUEvOVpG?=
 =?utf-8?B?Zy84MTVnQ1R5N1pFdmVLMjBoWmt5aGVHWmVpekJVT3hhdVF5OHg3SVFOTC9U?=
 =?utf-8?B?alNORGVFWDNNWEQ5QzZCdW9TM3NsVkNJSXY3b1Y4NWVaZk9UeU1SOHB4d3Z5?=
 =?utf-8?B?U0o0NWJHUHZ1ZFNXVXRYYkc3cXFEcWVlbU5ZdGkrZGpQRGtSOGNUVmJzU1Vt?=
 =?utf-8?B?UnZPMGdINmVOZ3BDazZLMlBUWGg0S1lmNllHUlFhR0hBaE9ZRGtpeGYxd3Vq?=
 =?utf-8?B?TUtqR2NjSlNrV0swSFNZSWo0dDdwNWZIYXdTNEo2UE5kanFmZ0U3WVdTdGtt?=
 =?utf-8?B?M2dlSGhwUE5iYm1iaHlOZmtwUEE2NmZNak1IOEJSc3lyeWlZbzRLSlR3aGty?=
 =?utf-8?B?ODd6a1QzTkdyU2xEUjNoL01IdTFpOHJzOXlGcitjdGxJWTZvSlJSREs0dk1u?=
 =?utf-8?B?SUR6QmhqY3VMNEhtUktTSHZxS3ZHaTN0USszYzFYeFJxYnNjVEpta2JPY0pX?=
 =?utf-8?B?YU14UFI4bnZnTVk3cFZUT3hhMkdDSDJic1VTd3ZjbmcyQlNVWjFCTFQ3K2ND?=
 =?utf-8?B?ejV4S2ZiRjlaRTYzVEVOekNwMjJhLzVwc2dDdnlXTTl4VmJ4Z3llQVU4bTR3?=
 =?utf-8?Q?9t3c=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 08:50:40.8408
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d28416f0-5eae-4335-2efc-08de235ae3d0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE36.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4054

On 11-11-2025 20:45, Sean Christopherson wrote:
> On Tue, Nov 11, 2025, Shivansh Dhiman wrote:
>> On 17-08-2024 05:43, Sean Christopherson wrote:
>>> On Thu, Aug 08, 2024, Ravi Bangoria wrote:

...

> 
>> ===========================================================
>> Issue 1: Interception still enabled after enabling LBRV
>> ===========================================================
>> Using the 6.16 upstream kernel (unpatched) I ran the KUT tests and they passed
>> when run from both the bare metal and from inside a L1 guest. However for L2
>> guest, when looking at the logs I found that RDMSR interception of LBR MSRs is
>> still enabled despite the LBRV is enabled for the L2 guest. Effectively, the
>> reads are emulated instead of being virtualized, which is not the intended
>> behaviour. KUT cannot distinguish between emulated and virtualized RDMSR, and
>> hence the test passes regardless.
> 
> I haven't looked closely at your patch or at Yosry's patches, but I suspect this
> was _just_ fixed:
> 
> https://lore.kernel.org/all/20251108004524.1600006-1-yosry.ahmed@linux.dev

Thanks Sean. I tested Yosry's patches and they indeed have solved this issue.

> 
>> ===========================================================
>> Issue 2: Basic LBR KUT fails with Sean's implementation
>> ===========================================================
>> After using your implementation, all KUTs passed on the bare metal. With LBRV
>> enabled for L2, RDMSR interception of LBR MSRs is disabled as intended.
>> However, when running KUT tests inside an L1 guest, the tests fail.
> 
> Same story here: I haven't had cycles to actually look at code, but Yosry also
> posted a pile of changes for KUT:
> 
> https://lore.kernel.org/all/20251110232642.633672-1-yosry.ahmed@linux.dev

This issue was also related to buggy LBRV in the kernel. Yosry's patches have
fixed this issue as well and I've verified it. There was a slight flakiness in
the KUT which was later fixed by another patch by Yosry's. [1]

Thanks,
Shivansh

1. https://lore.kernel.org/all/20251113224639.2916783-1-yosry.ahmed@linux.dev/






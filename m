Return-Path: <kvm+bounces-57814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F803B7EAE4
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:57:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 10BA94E1A4D
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 03:31:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67BE52940B;
	Wed, 17 Sep 2025 03:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pXxzve6p"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011066.outbound.protection.outlook.com [40.107.208.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C06288A2
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 03:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758079880; cv=fail; b=PmA58+XiyQ76cbNXOkSSbZM+MB7Rje4yRdCb3ePADsqU9MIRk6E3yY1f2CjtnooSa1Hcu2XCTyeSJ541kmjdzpLnQ40sYUdb+D9Gq1+ZaFTLUVOOtpip5vYarjftkWqiBWWVWeGCMnQ9wkdfNEAU2Eq9Xi9hQ+S7DIqeDv36/HA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758079880; c=relaxed/simple;
	bh=t5vQcu3/+k4Wp47GOt3gu1SSGwO3oXkFBfmliBBUCCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CKJMzUMe7+QcU0qrwcv+vIVExhnMQcXo1w704FPC9Mt8nDF9HEE/g4Lq8LOleSVxz33mbzSx0mqcEW2oC2sVu+THpb2J0E78RszKZekssDaT3C1SuvG/YQScDyr5L39mKqTDdZjJKX1tBoaPESAGnXBBkRwAbabsUkZe9wphqrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pXxzve6p; arc=fail smtp.client-ip=40.107.208.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BTuMJQvb/K1UgZY9k+vUkz9n2w5ElR7H+jnh4p4lxC0ZU5WxEJ/naHegm9/C1hq9raSJt936EpLxlgptH/3jGFYwypmH6Ige6YdMmu3cClY5T4FS3wB8qaL8qih9sxTNcGDxiC8QT1OvWuNimJT/UGgfXXzziLUbfEtDeUcqzyZORvKsP+02q/+TFx2CWaVoTXKX4JNxLF56z4eXhCL+jVFSz/x2w+SpEGnvnEXWvXtt6wZa/gJVCm+NeGaLQTcEsHQWYRMbSQvJXq/hDxKOB+2S44trV5PYhpMwIwjfNr0ihGWhk6oZyPRtYUu52pm76ExAtBsCcd/iL1vIjGYS8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ftj+S248p3lBLj/jUvBhp3Jv+60FdER5R/ye/BGwcgM=;
 b=NvczOkOxVgEx4Mijn6+EKhk9NsTWujEYWmtTwJbap4D/V1SEUMZ9sqhqIFAtgYiiWTxIRftW6cDzIdd20sudIVidp05IWMRXIRzKZfUg08AN9t4fdqmemFCvclSp4PHQs2SOwOpeLvYAfMk0cpUCd+3GNurEequpTpbae6xmg8nZpLA5Cz2Sj8T8qsedPc5UuqKXCiykY3dhEDA/IULzTuigUSwjjoE+JZ/b6SNLoE5+xMneGPrSox0Pg7ngNt2iY3i4ZD0+UdTbmDi7oF5n2Ama6UKp8hIpr6+pI/E0YvTNv6e6H7uk3sjgJeuWxHEbMlmN2ZeuovkcOtI5Yt3GAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ftj+S248p3lBLj/jUvBhp3Jv+60FdER5R/ye/BGwcgM=;
 b=pXxzve6pu6Ml5sKdqDP/Pwdq12mMFdmse6OZ9a19R+PB8+QXxQIbHfRfIEyvLLSds1nwM9/a+I7hpRr0lXkfVcjvhU+BIJ8hodxu9yZdXy0XpJxrO+NIve+Cjv5nTJAdLvEWf0lUp6Jps+uefdq6kcQ2zKwvEoc5edNEKsDeu0g=
Received: from BL1PR13CA0396.namprd13.prod.outlook.com (2603:10b6:208:2c2::11)
 by CYXPR12MB9317.namprd12.prod.outlook.com (2603:10b6:930:e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Wed, 17 Sep
 2025 03:31:12 +0000
Received: from BN3PEPF0000B06F.namprd21.prod.outlook.com
 (2603:10b6:208:2c2:cafe::99) by BL1PR13CA0396.outlook.office365.com
 (2603:10b6:208:2c2::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.11 via Frontend Transport; Wed,
 17 Sep 2025 03:31:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B06F.mail.protection.outlook.com (10.167.243.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.0 via Frontend Transport; Wed, 17 Sep 2025 03:31:11 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Tue, 16 Sep
 2025 20:31:11 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 16 Sep
 2025 22:31:10 -0500
Received: from [10.252.207.152] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 16 Sep 2025 20:31:08 -0700
Message-ID: <80fd025b-fd3b-4cf1-bcab-20d5b403666a@amd.com>
Date: Wed, 17 Sep 2025 09:01:11 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] KVM: x86: Move PML page to common vcpu arch
 structure
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
References: <20250915085938.639049-1-nikunj@amd.com>
 <20250915085938.639049-3-nikunj@amd.com>
 <fa0e2f42a505756166f4676220eff553c00efb1e.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <fa0e2f42a505756166f4676220eff553c00efb1e.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB05.amd.com: nikunj@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06F:EE_|CYXPR12MB9317:EE_
X-MS-Office365-Filtering-Correlation-Id: de65ff0f-ccf9-42f1-c72a-08ddf59aa610
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TDZieHduYmM1TGhQb1VrZTRhTFpGdnlJRDMzZlZBZHEzOTNhUXRkbnVCMVIx?=
 =?utf-8?B?elFjbzBSL3pINGt0dncyOUhLd0NuRjA4R3kwc1pkZTl3dmhrTXpuQXhxVklw?=
 =?utf-8?B?MmJrRnFuWVR0Snc0M1VROUlFYnJLR2ErQnVza0Nqay9BTEluU1lKenA0VHFy?=
 =?utf-8?B?RG9xTzl2ZnBRNnhRd0svOHJVVUpndTJqcno0MGIxb21uaHRrbW5vOGRIc1A4?=
 =?utf-8?B?RmJWWVJvUVdtaHRSS0pLNm0rZUZwQXFlZHpod0l0SHU4Y1hnL3prZkZGMlVp?=
 =?utf-8?B?OTZ1WlVoQzc1ei9XVDd3a1BwNGtlTTNBY2NzZEMzNERHVFhVWTR6SGlaa1do?=
 =?utf-8?B?OXhtTUhuU3BlbmhxYzRJZnprRktSN0phWlFjWTdqWFNpeGNJWHh4cjB5c1JN?=
 =?utf-8?B?VXJFZ0Z2cmViQlNtUTlLK3hXeG96SVBxd1dSMTZlVVFPbEZQNUp0U3FuNnRS?=
 =?utf-8?B?Q0JKRlNWRUxESHdhNWRZZTY5L2Mxa0MwWFpuTUVpSlhISk9UZEJQSmdncFpv?=
 =?utf-8?B?SDJIdWllY0pzZHFFdnU1Wms4V1B6Tm1qWW96ZGxrV1pCVmk3QWVLNlI5MGNq?=
 =?utf-8?B?bnVjaVpWZXVVUzRHY01tb3kzMi90MUVkT09yR1ltUVlidkhENHhMcGNQYVpB?=
 =?utf-8?B?aDZrOC8xSHBzVjFYYXl0VTd6VXo1U0V1cVorMzZaa3YvY09iU1I1d1hZZko3?=
 =?utf-8?B?MWgxVHptdVgxYk5EQjlUSFpCNkdrU1hYL0xHck5WeUZncW1SSmFmcXlka1p3?=
 =?utf-8?B?UENVTzF5NW5TbmVxdlhiR2ZpajQ2L2xxYzBFSnpDTjBzQ0pNZFFrR1RjWVg0?=
 =?utf-8?B?Z1VVVW1vRS9oQkFURTBTc0M4TnJ0RW5LNEdYemZQTXYzclpuUzhFUWt1cEth?=
 =?utf-8?B?U1VBUE1ocW9HZ1pZcFhlTWhHNnpjRUw1RzB4NmhRYWFDMWlkYnFkb0s0R2lJ?=
 =?utf-8?B?SG9lYTBtUm9MVEF4dXY1emwxUCtCY0htUFpJOEd0RmdjVWxwT1lnZ2dGaFJK?=
 =?utf-8?B?eFpRVVRlRWtXZndZVVZlOFhtcC94NXR3RkI5bzQvaWxBTWFVSzNCNVZQV2Z6?=
 =?utf-8?B?SmxnbWU0RmhqN1JpbG45K29vM3RHK0xPTHRrU1VMUmJETXRydklsMXRvcit2?=
 =?utf-8?B?YnNRUkZmYys0YXA0RHZSZ25OR0R2RjRMRGhnNG50Z3ozQTRONlBPRDY3WUNJ?=
 =?utf-8?B?MnhCVHhaRjUvVDRrOThaNm8rZUgrR04rMUtuZzh6UlUxdGJBR3BmbFY3SWtN?=
 =?utf-8?B?NUhyendjZjk2OEREdUc5ZitIeVFtem01dWFJN1haYjFWQUxXeC9QS0k4NnU4?=
 =?utf-8?B?OG9Xd0lQZnM1RE4xcXBNaXhIUVhYZGVnSnlMdU1lRU1PaVVjeWdoc05wdXdS?=
 =?utf-8?B?SmZqeW5aSnRJYzNoMHIwZFM3N2oyK0EvS2Zyc1M5STZhMjdWdVNsK0gwbU92?=
 =?utf-8?B?YUtjS2pLRFJwMnFZZ1lFbHpER1ViOFhSUC9Xd2lZS1lPOHUyVzNoNXF1TEZQ?=
 =?utf-8?B?SWpWL2hMZk4wQm5aeFNjTGcvY1hjR1ptcS9pWSs3OGJCc2JYbDFvdjVUSDNx?=
 =?utf-8?B?Ym9lV1F6Q0ZCWGZkdng0azNnMVMrblMvZno4ekpWN09HM0tPSko3R254dW4v?=
 =?utf-8?B?N1R5UkxNc0R4RjdmZ2cxdkdiSTNmUDZMNm9EODJrc1Z5T2FpMEZkZVpqM1Zk?=
 =?utf-8?B?eHlpeFp0TFV0ajE1bFpEU0NUMXFYR1hxTUJ0MEJ2ekgxRVBnNU0wbHZ5NEl1?=
 =?utf-8?B?V0d6bm1xYjgrN0tvaWc5N0JvaVdBMDZ5YVdYcmxRamNCQ1lGcU9XRktrcjlT?=
 =?utf-8?B?ejJJalp5OGVINEgzekN1RmplTjFKVHlZYmt1OUkyV0lEVzBlV2E1ODI4M1pB?=
 =?utf-8?B?eHJFUFF4eTJsc0ZVZTJPM0N6WWJ5RUx1NHRvKzlSVUhRdlpmbDhsU0JhWXkx?=
 =?utf-8?B?ZnhSVTBodkxNQ0svZE1uNlRMa2UySHZBb0VWdDlvT0NDNi9Xdm1TMlBPQmdQ?=
 =?utf-8?B?dCtYQ21JK3RySlRCSmxMLzJrb3c1N1hZRStqOWtEMEZoZnptWUppYTZxSDR5?=
 =?utf-8?Q?LizBt+?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 03:31:11.5948
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de65ff0f-ccf9-42f1-c72a-08ddf59aa610
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06F.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9317



On 9/16/2025 3:57 PM, Huang, Kai wrote:
> On Mon, 2025-09-15 at 08:59 +0000, Nikunj A Dadhania wrote:
>> Move the PML page from VMX-specific vcpu_vmx structure to the common
>> kvm_vcpu_arch structure to share it between VMX and SVM implementations.
>>
>> Update all VMX references accordingly, and simplify the
>> kvm_flush_pml_buffer() interface by removing the page parameter since it
>> can now access the page directly from the vcpu structure.
>>
>> No functional change, restructuring to prepare for SVM PML support.
>>
>> Suggested-by: Kai Huang <kai.huang@intel.com>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> Nit: IMHO it's also better to explain why we only moved the PML buffer
> pointer but not the code which allocates/frees the PML buffer:
> 
>   Move the PML page to x86 common code only without moving the PML page 
>   allocation code, since for AMD the PML buffer must be allocated using
>   snp_safe_alloc_page().

Ack

Regards
Nikunj



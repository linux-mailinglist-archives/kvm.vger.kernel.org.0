Return-Path: <kvm+bounces-55127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5054DB2DD75
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:14:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 635415C7F45
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 13:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD9C631B138;
	Wed, 20 Aug 2025 13:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Q8V8kCGi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628E73093CB;
	Wed, 20 Aug 2025 13:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755695520; cv=fail; b=VjGObirwsgbKfpmSFKe8Q9eWuXOZbuJrXgpG44EATTrOFSObxmEiu1Ilg9+6IH+2hAxZV40t9uN/ncAYfY3ZT/ghEwlNyfapOHFHYJt6ow92Di5AzwjEvhqSXFRn8mAOy/gwKB8d9uL3tGdCPSNY+6Ia/DwcIOZin3xzSv3sV4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755695520; c=relaxed/simple;
	bh=hBlTHcHcheWHku2jVxDaCfGpHfdItGosuQuY17KYBCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hfuRXNi6SEzPgSrppqJnykxQLcr3RKJRuwSHSS5EBMvWwbv4EcE/nXvrmzT1wkDnzH9V0Q8F8Mg6PamApIFATiAN/AtJMlWEQM+cpi5SBqOzA598QpKip/qrFcYKfIgOaKggUTDkRKvWEqsHbiQRExJpRGXqmzp07JfRSxjRBjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Q8V8kCGi; arc=fail smtp.client-ip=40.107.223.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uBKLMfRVpxpGoNv4E4RjARnEK4itPG41M1ruKMiwXbGthq1OnoJ2MzMclKsWShvZClYh19UaQdlHDnh0SmLTMpP1IcOO8lzDW2eZzea2oiNCYLQSTmUZc9ZW1umTi9fHHFGCACBDnVi1FWZUKir05s5xpPn82HyZ0lPMBqYY+XKKMxDD/TG5B/Vl8j/P8VgAr49dbvMthcX4D6GZP6AOahThvuMbyUojsUPchyUO1umhDOPNr9n9lhrAP9QPsdHCduMFi03fU1qEuBon/1wGnz/PCey/OuFIlZyPwfEntNbKGuFOZcuN4D+SAXSSW9vyk6akJEr1ozdLaXJnVOlNGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rOdbunPn0S0VYOYrCOw48s/STZrEfsQJBRdv+YuXVs=;
 b=hxDE4wJZ/WAea822Pu9DXoOZYDImx1lz41rVwHW/Bfho3h5QfM9rNEb1WiKtHFcscYMHRkhdb24G1G09WvfOmVWhgnveYJAyLZAcP6eXy2uw7TQh09SXbqxJaaWjyygXeACM1nadbOwX+DJQjo6JQeQSsXCnsgO43w1nFslvpFwN4+spnNEe0FBoLyYwHQRMnYbJtRq9TxyJt7LAqYsBsg7Yn1oI2i1lHhHIBkkU/wwM+Z7K+KDquzk8YyWItu/B8Ec/L3t2b030obteYvgTqTIfu88ZgsmK9dvO2o56WKt7y+2qF7jQuiwFDcpTFLOWgCzXzAgDbeGbpRScz2qgSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rOdbunPn0S0VYOYrCOw48s/STZrEfsQJBRdv+YuXVs=;
 b=Q8V8kCGit1MvlPwG3IE9UaQnrBx3SddEAvwmbACazkj9D81M82edf4NC8PqiBds98TX19zXVGn3Qr+/QTJcRg1wLmZvJr66SDjYtPY+QN78b0WAaA8k5oFbwRUqcIgLAku97Mja7Tuh5g4jCjY2T8uqhY2u12qOpETXjdPPQsKs=
Received: from CH3P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::32)
 by DS7PR12MB8202.namprd12.prod.outlook.com (2603:10b6:8:e1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Wed, 20 Aug
 2025 13:11:55 +0000
Received: from CH1PEPF0000AD7D.namprd04.prod.outlook.com
 (2603:10b6:610:1e8:cafe::c7) by CH3P220CA0012.outlook.office365.com
 (2603:10b6:610:1e8::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.14 via Frontend Transport; Wed,
 20 Aug 2025 13:11:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7D.mail.protection.outlook.com (10.167.244.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 13:11:54 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 08:11:54 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Wed, 20 Aug
 2025 06:11:54 -0700
Received: from [10.252.207.152] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 20 Aug 2025 08:11:51 -0500
Message-ID: <6652929c-1e14-451f-afce-c5b4c2b7af9d@amd.com>
Date: Wed, 20 Aug 2025 18:41:50 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 8/8] KVM: SVM: Enable Secure TSC for SNP guests
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Thomas Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Borislav Petkov <bp@alien8.de>, Vaishali
 Thakkar <vaishali.thakkar@suse.com>, Kai Huang <kai.huang@intel.com>,
	<David.Kaplan@amd.com>
References: <20250819234833.3080255-1-seanjc@google.com>
 <20250819234833.3080255-9-seanjc@google.com>
 <c3e638e9-631f-47af-b0d2-06cea949ec1e@amd.com> <aKXHNDiKys9y8Xdw@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <aKXHNDiKys9y8Xdw@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7D:EE_|DS7PR12MB8202:EE_
X-MS-Office365-Filtering-Correlation-Id: eafade8b-ad08-4efe-3c31-08dddfeb22c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QVNIZU1pUXRRVVAxSXE2MVFNQzczWlRZbFQ1eEhqRldZdjhLQWxRMFNoYlF0?=
 =?utf-8?B?Wk5MQ29ZQjkyb053WFBCYW1JQ3l3U1ZNU0NFRmZKM0JBQjhhTXliY3dyUmxY?=
 =?utf-8?B?aGczQ1IrcHppUDVkak9obVB1QlJMejVEY1p5Z1hxUjJ6aENoU05Pemc4eEVa?=
 =?utf-8?B?SXdXSmZWLzc3eHhMWlB6K09IOGpGNnZiRXFJeTVOMjQxZWJpbm9CU1IrOGUr?=
 =?utf-8?B?R2tDRG5GL0EwazdoeTlVZ1JXTXZDRzhYRnFjTUlwcFVvQ2hXL3hKNW5WL0li?=
 =?utf-8?B?VGh3ckxid0xTQldVU3JXaWVaSkZoVmR4czduLzY2c2lBMWZ0ZEhjZ2p1cCs4?=
 =?utf-8?B?aG85b25mVkhLZy9oN0l5T3hOa1NPY0pVenRrVHEwOFVjQWN6bUoyY3hDcFZ5?=
 =?utf-8?B?bllJOERQUFpEV3RzVFdOdkFmME0zUElMZ2lFQmZSczJueFI0a1FTZUl1TG5v?=
 =?utf-8?B?Q0s2Y0xOTzhVVGFXVDNVTVM4NGJJWFVTenpqanNaUVptOFVud0MvZWN2WFBR?=
 =?utf-8?B?MGViZVBBTlJmV1Y4SkY2bnJSREdXQ3FBVDRuQ0JCVHNibngrZ3Z0S21scXpa?=
 =?utf-8?B?NkRwNFQwYjczVHVPUllyc1ozY2dhNG9tZldmbUxNMHJjcGJoVWRKNFVRNTd2?=
 =?utf-8?B?VlpKRzFzaDZCcHRCVnpjSSsyS3JPb2FlQnVMNUdKUlpsRHZQUkVWL1VPSVd6?=
 =?utf-8?B?SUMwdHdFUWlya1ZXbHpuZ2o0cTNmMnRHVW14ZHRKaUF4dmhFaDdvdHlTRXBa?=
 =?utf-8?B?bktsZFl6cHdENlNvRmtGd3hMTURtclVHT3c1R21iSHVhMGtIMEpFcFpOZXM2?=
 =?utf-8?B?L040Ynh1akcvR01ySkttejUvOUdLVGQxdEZqcnhHWDJ4d24vcG4xYytJMmNG?=
 =?utf-8?B?MzlIcGgxSjN6SmhNRDczWXcwN0tXVmREaGx4UFRKcWxDMFhRbnVvcjRwN1Qz?=
 =?utf-8?B?c1UxZDhpTURHSjRIM1VzR29hOFp3M2ZXR2ZBN01Td24wN25sV1ZkWEhXemVE?=
 =?utf-8?B?N3pUNjI1UDN5OE5xOTZHY2pxTEtpV3hPYzFIYXltdTdwRjlNWHplblB0R0Zp?=
 =?utf-8?B?NnNnSWFhZE1MTU1HditXblRVRmdnR0VMNDZ2Qitua0hJZnVtR1ZYVDNFMnRN?=
 =?utf-8?B?cmNBd1oyQTZ3VEhOMFpwY09ncklVVEV0N1E4NUNYeVdNWXhBWk84VFp2bXdi?=
 =?utf-8?B?NE53UktOSFA5M1RMU0VjRjVIM2xIWjh3OEMwb2svbnF3RFYvZTUxYjk1QnRF?=
 =?utf-8?B?Wm9IRUNTaHhhd1B5U3YrNmJiTmFxeExqckwxSGp0N3BmejdYbzRNQ0NVWUF1?=
 =?utf-8?B?TkpVUmR6d09GTld4UjR6WXo1WHZERFNRNGVsdGRFWXFnaTIyVGRWYUtUYlpH?=
 =?utf-8?B?dnlIcEtheXN3NzRLY3ozUW1YOUdqcE1LYU13d1ZkMU1mTEtGRkx0MXJaZ1BC?=
 =?utf-8?B?SW9TNWYzUjgwZngrVjBlVzVIN2dibkRLbkdaT1BwR1lQTUtGSHZoQWNRUmNk?=
 =?utf-8?B?OENwUTlBYVY2clRES0FWeXFZTjVQN015ZlBZNXRuMm9DdG1nS1JlUTRseW1C?=
 =?utf-8?B?WWFzVFlKVy9oSXFHRWVqNGhzd2VzcXYzZzBrVEhrdVRFcTVvYmNUQXRLdHJ6?=
 =?utf-8?B?NTBqNUNjR2FwYzdQcUNuWVVXbUNRVjkxWW41ZTFicGhsWFVEWk8zNXlYVXRB?=
 =?utf-8?B?ejdBL3dLS0cwb0ZvL0lMNkhFZVJuZXk4bE9tSURMQmlvdGdyNVZMUkxaMHJ1?=
 =?utf-8?B?WWJyVytsb2hKRTdCcG4yRzNKOWhqMkRpMjE2Kzc2Q3FCWGc3QVJ4T1NuMlZa?=
 =?utf-8?B?VVhWWUhnMGR2eXNWMFpabUpERDhlWFdRYTRISlJJQjdQV2M4TG0wckQzVTVw?=
 =?utf-8?B?dkRoUE9qK3dpN3E5cjJ4ZmFRWFp4ZGVLOTFJMHZySHMwa0Z5MSt3NmVRY1E4?=
 =?utf-8?B?NmpGeHJQd1Y5V2ZSdTBvUXowakxFWmttcXBkSGVEeDZ1VkRXcmp6cERvYjJ0?=
 =?utf-8?B?aWtrbWt1TXpvUDJDVTA1UnlDa1lXZ2RiU0tCVmhETnI1bzJYOWdIUmN4dktK?=
 =?utf-8?B?OTZMcnVVVldrbWNMOEV4eWhoNWpQcUoveldpQT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 13:11:54.9668
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eafade8b-ad08-4efe-3c31-08dddfeb22c6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8202



On 8/20/2025 6:31 PM, Sean Christopherson wrote:
> On Wed, Aug 20, 2025, Nikunj A. Dadhania wrote:
>>
>>
>> On 8/20/2025 5:18 AM, Sean Christopherson wrote:
>>> From: Nikunj A Dadhania <nikunj@amd.com>
>>>
>>> @@ -2195,6 +2206,12 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>  
>>>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>>>  	start.policy = params.policy;
>>> +
>>> +	if (snp_is_secure_tsc_enabled(kvm)) {
>>> +		WARN_ON_ONCE(!kvm->arch.default_tsc_khz);
>>
>> Any particular reason to drop the the following change: 
>>
>> +		if (WARN_ON(!kvm->arch.default_tsc_khz)) {
>> +			rc = -EINVAL;
>> +			goto e_free_context;
>> +		}
> 
> Based on this conversation[*], both Kai and I expected KVM to let firmware deal
> with the should-be-impossible situation.
> 
>   On Tue, Jul 8, 2025 at 9:15 PM Nikunj A. Dadhania <nikunj@amd.com> wrote:
>   > On 7/8/2025 8:04 PM, Sean Christopherson wrote:
>   > > On Tue, Jul 08, 2025, Kai Huang wrote:
>   > >>>> Even some bug results in the default_tsc_khz being 0, will the
>   > >>>> SNP_LAUNCH_START command catch this and return error?
>   > >>>
>   > >>> No, that is an invalid configuration, desired_tsc_khz is set to 0 when
>   > >>> SecureTSC is disabled. If SecureTSC is enabled, desired_tsc_khz should
>   > >>> have correct value.
>   > >>
>   > >> So it's an invalid configuration that when Secure TSC is enabled and
>   > >> desired_tsc_khz is 0.  Assuming the SNP_LAUNCH_START will return an error
>   > >> if such configuration is used, wouldn't it be simpler if you remove the
>   > >> above check and depend on the SNP_LAUNCH_START command to catch the
>   > >> invalid configuration?
>   > >
>   > > Support for secure TSC should depend on tsc_khz being non-zero.  That way it'll
>   > > be impossible for arch.default_tsc_khz to be zero at runtime.  Then KVM can WARN
>   > > on arch.default_tsc_khz being zero during SNP_LAUNCH_START.
>   >
>   > Sure.
> 
> https://lore.kernel.org/all/c327df02-c2eb-41e7-9402-5a16aa211265@amd.com
> 
>>
>> As this is an unsupported configuration as per the SEV SNP Firmware ABI Specification: 
> 
> Right, but what happens if KVM manages to pass in '0' for the frequency?  Does
> SNP_LAUNCH_START fail?  

SNP_LAUNCH_START succeeds, and the guest kernel starts and panics during early boot [*]

> If so, bailing from KVM doesn't seem to add any value.

As firmware does not bail out, I had kept this check.

RegardsNikunjhttps://lore.kernel.org/all/afcf9a0b-7450-4df7-a21b-80b56264fc15@amd.com 



Return-Path: <kvm+bounces-63175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E52BC5B595
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 05:57:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5230A4E4CFB
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 04:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B5D2D372D;
	Fri, 14 Nov 2025 04:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TPDojZIA"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010055.outbound.protection.outlook.com [52.101.201.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA5D2D2490;
	Fri, 14 Nov 2025 04:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763096237; cv=fail; b=OQZiEAKDsB57kh9+zrb8/jTOuvIfbtPKP+ktRV263Hc2vVeqL9OOZRngmg2GgiEyheWTOP9Wz9tYfqTk/mQv2uEjw0jx7EmKZlhk23Ux/lSEVl75aKBeldiAFbv5WdpuYJ0PqCjfL0stJHwWKgJklBD1BZofaQZjHmRVH1WJhys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763096237; c=relaxed/simple;
	bh=vhvo7rJq+FJn9ZsIaLUBVWpVWrP/QT+VzPGIdy9Gx+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=h9/e3T93rbm3MaBc8J+/ErQcqudJdx7NdKUDNmX5lWFw7XTqStltfOqZ4h9/otur0m5fSh2s6nXPHALlWM2kUVz2Srdao+yBMzxTcVW9NBz8JFVQPJaOmARZPM+Q99beue7FIMO1eVA2xQWz2IwOz3SG0dl4go3qm+9WBDoY5DI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TPDojZIA; arc=fail smtp.client-ip=52.101.201.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WcMDveYQkOB/eCs0ALZOKd46ftZdHARFAPxiMJgtxi645ZlguHKBkK+atGJLiRWTHEAD5J025W1RneIcN2CoLQpv4/5w/wiERXG546Pd0uY0uoD7o194vKodOVhvI+1m5uKY1jAXWwDCjCBWoPDFWqEZm7XxZWkdlt/oYpRIwBx/Cj+/Sy3SXQVbzZfJ6Pcbm1ol0XhlNVbgMm77uLKk/ntO9LXeZ2GODqt8bFyv6FxaHMUZJ9cJEnl8xtrGaC5WbZ7GKsxqjDcbMd9/hTjmLjZtiq4kZXIw+bPbjxmkbPnsbC0Tdix1bNIsHr3kbGOwIBvDLg6vVE5XUu9FzjM8eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xA3Fgme7KaqT6leQALAjZ0lyTr531Z0TrAi8d+L4gMA=;
 b=RGP1LONWBt2kNsnJiA2L9gZWxGM0JR22wbOygDnSlnwpRaLdgpOKje6khniA1Dl61UawknZdQ/OBaXuAEpaG4GP9saKdlBPWsJnLKY6o5yATmPq9NfO/cWDJYJiYwK+wEP7VpvzQFMjqLYNfkSZBySjYys0xKLkUED7epSExJWsoyHGyj622+FGyU7MpUUkfbytTtLbUIJxVFBGgu/5jbYiPoEEAHbPP6lGhJ6chcedlYFr19O6C9xXE/mg5oTVHhgEcUFHJ9M6ayxMMl+hXT8pee0U/1HiStL8IkPMGYCOaahHM0tD1kGN2E4PVNN8y5WJgTYAPcozvFKSXyxZm9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.dev smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xA3Fgme7KaqT6leQALAjZ0lyTr531Z0TrAi8d+L4gMA=;
 b=TPDojZIAw4GT6sh0RHtTyItz8J1vvScADmGr82r2QgKj4o4d2Uv8TDogQUZsjI9HPB0fumVIB/QoIP+qfFx8cNqSwfkreEhmQfTgICUPFaHl7d1h/OnbaR3lh2CDF0W5yhFDj0V4qCzti2QuxuPxXOxDTOF8A2vtko/TXszztl4=
Received: from SN6PR05CA0022.namprd05.prod.outlook.com (2603:10b6:805:de::35)
 by MN0PR12MB6366.namprd12.prod.outlook.com (2603:10b6:208:3c1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 04:57:11 +0000
Received: from SN1PEPF0002636D.namprd02.prod.outlook.com
 (2603:10b6:805:de:cafe::bc) by SN6PR05CA0022.outlook.office365.com
 (2603:10b6:805:de::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.7 via Frontend Transport; Fri,
 14 Nov 2025 04:57:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636D.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Fri, 14 Nov 2025 04:57:10 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Thu, 13 Nov
 2025 20:57:09 -0800
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 13 Nov
 2025 22:57:09 -0600
Received: from [10.136.45.190] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 13 Nov 2025 20:57:08 -0800
Message-ID: <76608bf1-a47d-4974-8ec9-28e8df7bd43a@amd.com>
Date: Fri, 14 Nov 2025 10:27:07 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/14] x86/svm: Cleanup LBRV tests
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Kevin Cheng <chengkev@google.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20251110232642.633672-1-yosry.ahmed@linux.dev>
 <20251110232642.633672-13-yosry.ahmed@linux.dev>
 <1f39d5a3-e728-4b2b-a9c6-50cbc4fffd17@amd.com>
 <66tns2r4rgrugltijbrxoqyvrpxy6udebpod2udcjnuu6qhsj7@roagtke7znaq>
Content-Language: en-US
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
In-Reply-To: <66tns2r4rgrugltijbrxoqyvrpxy6udebpod2udcjnuu6qhsj7@roagtke7znaq>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB05.amd.com: shivansh.dhiman@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636D:EE_|MN0PR12MB6366:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cdc7171-47c1-4b00-3783-08de233a4507
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUdrNmxGMkZ4bE5sUktYR3hMYnZPU2NYUTd2NDNEb0lhRkNQYTM5MTFHZ20r?=
 =?utf-8?B?RzV2dm1NZDFVMDBSYWxVRTRuUVRGWmJ5SFA1YUcxMUZTQVFDNmNWc24vSUc3?=
 =?utf-8?B?RWJMVmxRZ3d0eGg1WGdselI5RGt1ekpWek5EWDNqSkpnZ2NCRG10T01pZWg2?=
 =?utf-8?B?Q1d5RHBINGpFSC9IOTUvOVk3YkptWGhCVTM3VSt6dTAyejJBRVltcFVnTi9i?=
 =?utf-8?B?QjlTTEVESFRGaTRLTlFKM0ZXdk53c1pQMjhuOXlOQTNqM1o2LzU0OUxhTW9G?=
 =?utf-8?B?R3RkS2tKUlMySThlNGozb1pxU244Q3ZyNG5ENUtoRGs3MUt0dTBDMjZtR3c2?=
 =?utf-8?B?cDU4cGk1dkVRLzBxMDZ6RFB6K3R3aU9NU0dER21KbHZHT1RYRW9WZUliQmZw?=
 =?utf-8?B?VzdrdWM3R25FeVdZNi9RZ0NVZU9HM1pUcUZRd2R5dUJacGFqNGNhSHhhb0tN?=
 =?utf-8?B?Rm51M0tBS3dRSCtFdWs5bXRMb2tuUi83UkhsWnh4S3VHQlJtOHQzV2RjNmxY?=
 =?utf-8?B?SzRpVWFrTnlrcTZUNXVUMm1TSVU2NnpkTWJiZmt3N2RCWkVFZ0RYejVxRG1I?=
 =?utf-8?B?S0J0SDczczVEY3BsRjcvbGI1UlVyc1o0dHhpdndIODN2MU9XRXhITTRFakUv?=
 =?utf-8?B?aytBK1k2aDd0bDJFSHBzZlFrUVdtMk1HdHIrNDMxTnF4T09tRlB4aUl5d1Y2?=
 =?utf-8?B?dU0rem00OVZCRVc2QXhSOVhEY2tLUFVScFEvdWZ6cWlhd1Jhd1NBU0JwajY1?=
 =?utf-8?B?WHZWWnNTMFBMUjF6YmtTbi9qUW5VdXRadjV1emZQNXpzamxhZW1JbFlhcnFV?=
 =?utf-8?B?eVNQY0FNOFl1dy82WXA0SklYMWQ2dHRCem81SHR1Z2ppNGIvYlZGQkQvWmtL?=
 =?utf-8?B?bnB4dktEOWRobnprVVBxaTY0cjRKZ2x4Y3FlcW41WGF2VHl4c3pXQWxSQXc2?=
 =?utf-8?B?ekg2dEZXdlNLWVY4ZmxTN1BsZkw4VTNIakI1OEk5aGJvNG1IL1RDdEdyeHk5?=
 =?utf-8?B?Z2oxYndjMXdnbEo5Z1NDZ2tFQmtjL1BPQmVWRFIvU1NwVTZVNFNiMVZkdnVo?=
 =?utf-8?B?MWZ2TFNFZjA2a0pkZlhUM0JZQnZnK3hvZHZTa3JtOEZyZXowUlRHOEMxNE5z?=
 =?utf-8?B?STk5S0t5cmpQWktINkZSMTFPWXBPSFJuWDFmdmJWR3V4ZkJZRktjSEhKcFVW?=
 =?utf-8?B?ai9ldzNpRGlPSXA1VU43STI2Y3hFc3ByMXMwbndpMEJ5MkQvMDlTSmk4bWlH?=
 =?utf-8?B?NzZ2aG9mTWwxRWdUajdYbnVUclRlYUJkMTErcUEzOS9yQWFzaThuVVJFVVBF?=
 =?utf-8?B?ak1tV2lIM0NSeFhwSUFicXZxRDl4dHQ5anhsSk9BYUhPYVpub1JhUUcxKzBB?=
 =?utf-8?B?cFdDbjRTMGlRS1JtdHM4dEI4aEdlUnVDQ01QbnJqbmh4SUR2MnQ2TVI4RmIx?=
 =?utf-8?B?S3ZnME1PSmRBaEM3VHE1dWh4N09oeDFyWVh2dzhQZXJ3WjVKazZuU09qWnZT?=
 =?utf-8?B?Zk43bjRVSkJNRjQrVXdXV3NFMWRUN0JXNXozOGlpd2xYblFNZ1RpZTlYTlI4?=
 =?utf-8?B?c3lEY3ltTG5nQWptYkQzMTFDNDhlLzVUSHRWQnZNejhZMmVWdzlkSi9zOEx4?=
 =?utf-8?B?azg2MkdFN2JWT1JQSkRIbHRENkYxSFJUY2lveDZrQ0NGL1Q5ZXBlTEVwQTEr?=
 =?utf-8?B?bTNsNnpueklPSkw5SS9rQ2RxS200MzJ0aU1keGlMWFRLSWtTbVpMeUhib3pI?=
 =?utf-8?B?aW96UE5lT3RDdG55K2x2VjZlNDFIeEUza2dOSkU3bjFDbk0yMzlldjdPbFM4?=
 =?utf-8?B?aDAwY2JTckVEWnlwQXBnVTFWQnB2bnoyQXpkZDNKK2Y2YmxjMXRoZlp4cXJh?=
 =?utf-8?B?Y0lWL0trSEdmNkFqUjZZeTRsV2Q1bWluZ0tzSGpydDduWGxmdUM4bjRJRFM0?=
 =?utf-8?B?UDhhWTdHNG9MUi81ZWxmUTQ0SklIRXN0cTdncDNidEJkdGtsMUhDdVk3em8v?=
 =?utf-8?B?UlNFUXVCVVN5ZktUOXJabER5Ry9BUGtaclYvK0x3QVQ0bFFvcFlqN3RYZlZP?=
 =?utf-8?B?TjJXL0dyUG4xK2pleUtJTlVGbFZCSDBOakcwZz09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 04:57:10.5717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cdc7171-47c1-4b00-3783-08de233a4507
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6366

Hi Yosry,

On 13-11-2025 20:29, Yosry Ahmed wrote:
> On Thu, Nov 13, 2025 at 05:28:11PM +0530, Shivansh Dhiman wrote:
>> Hi Yosry,
>>
>> I tested this on EPYC-Turin and found that some tests seem to be a bit flaky.
>> See below.
> 
> Which ones? I was also running the tests on EPYC-Turin.

Most of the nested LBRV tests had this issue. I checked your other patch to fix
this. I tested it and it does fixes it for me. Thanks.

>>
>> On 11-11-2025 04:56, Yosry Ahmed wrote:
>>> @@ -3058,55 +3041,64 @@ u64 dbgctl;
>>>  
>>>  static void svm_lbrv_test_guest1(void)
>>>  {
>>> +	u64 from_ip, to_ip;
>>> +
>>>  	/*
>>>  	 * This guest expects the LBR to be already enabled when it starts,
>>>  	 * it does a branch, and then disables the LBR and then checks.
>>>  	 */
>>> +	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>>> +	TEST_EXPECT_EQ(dbgctl, DEBUGCTLMSR_LBR);
>>
>> This TEST_EXPECT_EQ is run when LBR is enabled, causing it to change last
>> branch. I tried to move it below wrmsr(MSR_IA32_DEBUGCTLMSR, 0) and it works
>> fine that way.
> 
> It shouldn't matter though because we execute the branch we care about
> after TEST_EXPECT_EQ(), it's DO_BRANCH(guest_branch0) below. Is it
> possible that the compiler reordered them for some reason?
> 
> I liked having the check here because it's easier to follow when the
> checks are done at their logical place rather than delayed after
> wrmsr().

Correct, that should be the natural order.

>>
>>>  
>>>  	DO_BRANCH(guest_branch0);
>>>  
>>> -	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>>> +	/* Disable LBR before the checks to avoid changing the last branch */
>>>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);> +	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>>> +	TEST_EXPECT_EQ(dbgctl, 0);
>>>  
>>> -	if (dbgctl != DEBUGCTLMSR_LBR)
>>> -		asm volatile("ud2\n");
>>> -	if (rdmsr(MSR_IA32_DEBUGCTLMSR) != 0)
>>> -		asm volatile("ud2\n");
>>> +	get_lbr_ips(&from_ip, &to_ip);
>>> +	TEST_EXPECT_EQ((u64)&guest_branch0_from, from_ip);
>>> +	TEST_EXPECT_EQ((u64)&guest_branch0_to, to_ip);
>>>  
>>> -	GUEST_CHECK_LBR(&guest_branch0_from, &guest_branch0_to);
>>>  	asm volatile ("vmmcall\n");
>>>  }
>>>  
>>>  static void svm_lbrv_test_guest2(void)
>>>  {
>>> +	u64 from_ip, to_ip;
>>> +
>>>  	/*
>>>  	 * This guest expects the LBR to be disabled when it starts,
>>>  	 * enables it, does a branch, disables it and then checks.
>>>  	 */
>>> -
>>> -	DO_BRANCH(guest_branch1);
>>>  	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>>> +	TEST_EXPECT_EQ(dbgctl, 0);
>>>  
>>> -	if (dbgctl != 0)
>>> -		asm volatile("ud2\n");
>>> +	DO_BRANCH(guest_branch1);
>>>  
>>> -	GUEST_CHECK_LBR(&host_branch2_from, &host_branch2_to);
>>> +	get_lbr_ips(&from_ip, &to_ip);
>>> +	TEST_EXPECT_EQ((u64)&host_branch2_from, from_ip);
>>> +	TEST_EXPECT_EQ((u64)&host_branch2_to, to_ip);
>>>  
>>>  	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
>>>  	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>>> +	TEST_EXPECT_EQ(dbgctl, DEBUGCTLMSR_LBR);
>>
>> Same thing here as well.
>>
>>> +
>>>  	DO_BRANCH(guest_branch2);
>>>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
>>>  
>>> -	if (dbgctl != DEBUGCTLMSR_LBR)
>>> -		asm volatile("ud2\n");
>>> -	GUEST_CHECK_LBR(&guest_branch2_from, &guest_branch2_to);
>>> +	get_lbr_ips(&from_ip, &to_ip);
>>> +	TEST_EXPECT_EQ((u64)&guest_branch2_from, from_ip);
>>> +	TEST_EXPECT_EQ((u64)&guest_branch2_to, to_ip);
>>>  
>>>  	asm volatile ("vmmcall\n");
>>>  }
>> Reviewed-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
>>
>> Other tests look good to me, and work fine.
>>
>> Tested-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
> 
> Thanks!


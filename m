Return-Path: <kvm+bounces-54666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 62540B264C1
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 13:55:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4110B6244B8
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 11:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B622FB97C;
	Thu, 14 Aug 2025 11:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DkVQwwI7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2047.outbound.protection.outlook.com [40.107.236.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AF51EF39E;
	Thu, 14 Aug 2025 11:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755172458; cv=fail; b=YqIQZntckHxtctRE1giNBg6TTQQ23CTSxXTsJGiaAZTkwO/50Ps4Ctt/kNs5YUulhcruHhUwEhAkkw83C5413qMW9G7A/BPeqUUv+pJXSsm+L/pFTJD1lVARCUTTahjcd/m9Jbp5rZdtq6dmDYu55H4LDAKX6GFdBHOxxVyzaec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755172458; c=relaxed/simple;
	bh=o0AyGzig3ZIEJW3H+D/rGLve7duWvkFSAA1n6xO6C0E=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=O1RzBpFH5dKNwCpNLGs7Ol4bWYwY4iX3JMkBsaPw4KD9/49o0rpy2LZS5IMWTMVxzPeIQXslzzqTA5f0sLWgB56zuIry0vpX9Rc0VAQeQokZ4vCbc6YLDtGjXTRDdxcc8UWF7Smbnu+EH0yqNr+kjCLmvNGA3sGxvX5XP8yAtQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DkVQwwI7; arc=fail smtp.client-ip=40.107.236.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sXJMn2dNMBPsyCSobuhlSyzDin9v1DJhnUbjJpBaKm+62wiYNMM1xbyxoM4UrhPY/o9w/xS+AADsFiPW8tciCjHpWvpiTK/+4j4yNws7hC2WEhbJNiNDdvOrAcF2dV1hzYh221ZjnOFgQf2FOtgOLs694lPMV8lHFoZSaWry8EM2PQNdoIzF9mF/j/VFgkS0m4zCvp202XeevqhJ0tzCasneBOIOIPrpwuB5dR0zEknzsCVHSacr8ylFsIOO0tB+m51voNrNHpID/1ldDECkX3IBZiHObWrHlIC0y9nFgHJ0AjW43pTLEO5izxRmSwXdPY4wf3StR2Or5oK3daNmLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O70hckIml9NhwQQH2EYZR3a6VcWYdEmeK/wMML9xIwc=;
 b=oO7UK+eCaHw05s8fg9yTW705oMLrLpOtKzkr0pLCOa6uVL3rgchY5TtGXsxVsPtyFAXgH1GIQpH9YGiLuLRG26uwukBFh4wc82ipla6HnS0TWGbIdywEfWnpQNaoZ9B0exJF1CW27H3dxApzEatvH8KXQyM2DXjNMDmqmPRBi2GLZDzb+zrmP7dgHqS0kWfO/bnDUDQw2LYyj4DqUN9i2nI8FkexohDJB3S4SmqrLx70GGtVAZV97EpVYU1EoATDYc7qVGrJ9J9YMgHE6fV+EKdEOFYJFVHLnLFK86IkzsW5MaeLyqyhtzUDWI0LXe8avaQ8FkK/KbD3b65H7A9y7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O70hckIml9NhwQQH2EYZR3a6VcWYdEmeK/wMML9xIwc=;
 b=DkVQwwI7X53DxPY8FhouTcKsPbin2qtqC4zOEjLfTNJbLZTlB8dtTY1EoG2DUFml5uGCQFkIup1mKLduR/jMC/JuorHLPUlYE0xAX8y8pGAT04X5hSSUJR+57c2YoKyVGuyDSme2GOfgaE2SdxAEOs5bWahZC6lGd1gIra9qsMk=
Received: from CH2PR04CA0007.namprd04.prod.outlook.com (2603:10b6:610:52::17)
 by SJ1PR12MB6148.namprd12.prod.outlook.com (2603:10b6:a03:459::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Thu, 14 Aug
 2025 11:54:13 +0000
Received: from CH1PEPF0000AD76.namprd04.prod.outlook.com
 (2603:10b6:610:52:cafe::22) by CH2PR04CA0007.outlook.office365.com
 (2603:10b6:610:52::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.17 via Frontend Transport; Thu,
 14 Aug 2025 11:54:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD76.mail.protection.outlook.com (10.167.244.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 11:54:12 +0000
Received: from [10.236.30.53] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 06:54:10 -0500
Message-ID: <e32a48dc-a8f7-4770-9e2f-1f3721872a63@amd.com>
Date: Thu, 14 Aug 2025 06:54:10 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
From: Kim Phillips <kim.phillips@amd.com>
To: "Kalra, Ashish" <ashish.kalra@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, <corbet@lwn.net>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <john.allen@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <akpm@linux-foundation.org>, <rostedt@goodmis.org>,
	<paulmck@kernel.org>
CC: <nikunj@amd.com>, <Neeraj.Upadhyay@amd.com>, <aik@amd.com>,
	<ardb@kernel.org>, <michael.roth@amd.com>, <arnd@arndb.de>,
	<linux-doc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <44866a07107f2b43d99ab640680eec8a08e66ee1.1752869333.git.ashish.kalra@amd.com>
 <9132edc0-1bc2-440a-ac90-64ed13d3c30c@amd.com>
 <03068367-fb6e-4f97-9910-4cf7271eae15@amd.com>
 <b063801d-af60-461d-8112-2614ebb3ac26@amd.com>
 <29bff13f-5926-49bb-af54-d4966ff3be96@amd.com>
 <5a207fe7-9553-4458-b702-ab34b21861da@amd.com>
 <a6864a2c-b88f-4639-bf66-0b0cfbc5b20c@amd.com>
 <9b0f1a56-7b8f-45ce-9219-3489faedb06c@amd.com>
 <96022875-5a6f-4192-b1eb-40f389b4859f@amd.com>
 <5eed047b-c0c1-4e89-87e9-5105cfbb578e@amd.com>
 <506de534-d4dd-4dda-b537-77964aea01b9@amd.com>
 <47783816-ff18-4ae0-a1c8-b81df6d2f4ef@amd.com>
 <a747227c-c194-47c4-89be-ba509c0633e4@amd.com>
Content-Language: en-US
In-Reply-To: <a747227c-c194-47c4-89be-ba509c0633e4@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD76:EE_|SJ1PR12MB6148:EE_
X-MS-Office365-Filtering-Correlation-Id: 99b99215-85d6-4286-5d30-08dddb294972
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q0Jlb1NlTVNMSEE5WEk2eG81M0VrSUY3dUx4ZC9nVEJucTJmNHdOZUNXY3ly?=
 =?utf-8?B?RCtHME5iQmRtbUNGSXd1ZGVuWVQycFJTY00xTCt0MEc0Z0JyaWwxcEtJMmZw?=
 =?utf-8?B?bjdxS2RUbm9PUmVSTWNCSTRJOEZtaTQ1THNoWTNYUUJ6WjRsdWNyZTNucWJa?=
 =?utf-8?B?dkMvVzk0OU04SHA5U0taZjBqazlpZ0NPdXVvdGZ2SmxYN1NIOU0zTmxyblN6?=
 =?utf-8?B?VHlIQ3pTWVlsMHc3THo1a1JoTG9wV29SazRyZ0txRERXWkNPazFXRk9vbVJG?=
 =?utf-8?B?anBGUVBRNUJ2QVIzb0kwZ0VwVXhoMDFPTzh4SzBxUnpuMGVVOEpXOG0ySTJQ?=
 =?utf-8?B?ZnNLVUl1bStEdlB4dE5EUkJVKzkzd25UaEJWaGRTUnVLbHlHMytycUlReUxX?=
 =?utf-8?B?bVRNZVd4WElDNHlPdlVjaUQ5UkhnUkZvb3pZZjNxZDVhTGhIWTV5Z1lQbXBo?=
 =?utf-8?B?dXhsWFNCa25NRWVFSnRNVW5LY2RYZ0tNN3J2eXQxaVR1c2pRa0JOZEMrMjhi?=
 =?utf-8?B?bisxZW1MMGk1OUpyMmM1VEwycllwd0lPSzRhcGc1c2FzYWo3Nll6cEdlNjdX?=
 =?utf-8?B?Z2hKTk13dExCSGZFaXZlV1dJdmg4Q1ZiTnNyQk5xMU5iRk1wWUlhak5OSVJi?=
 =?utf-8?B?c1piL2docmZsMGxyU2tMN3Bybytxc0lBeFpMUlZYMWUvZGhNeisydjNEQXdk?=
 =?utf-8?B?eERlUW13eEZCM1JPUDExaVYwbXpNL2dQdFI0bHFtV0tISllzVUk2c2ppOFg3?=
 =?utf-8?B?UE1mdlRRb1ZHTEpXZ0dNdGRkcW92NmY2M3hXR0Q1ZjlWdkpET2lBT2oyQkNL?=
 =?utf-8?B?aURwS2p2eGovMjlsRVNCcWIvVmpQSFNETU1Vc3U1ZzljakVyVUZCWXpkS0RS?=
 =?utf-8?B?YnhHNG0xNGFkcGhzU2ljTUVzRTlTV0c4RWJFNTlwME55VlozVWR2d3F4S1dW?=
 =?utf-8?B?bVJ5TFpKdjJpWE00UkZzZUwrQmRWby9qSEo0d0J1M2REWnBqck9oY2UvelRK?=
 =?utf-8?B?Uzc0UDhESU94Y3FqZk9kZnpBR2FzQnBjbjJaTUpOSFF6RjFHSXVPRnBySENL?=
 =?utf-8?B?UllyZ3ZXQWd2K1BiWDlhVUNDdUtoTTdqTUhGNUFBcHpJZHc4ZjlkUzVnbFBT?=
 =?utf-8?B?ZDFTQVJabm9SSlRrZ0x6ajZ6L2hRYUYzL0pvT20vcUpkZTF3S1R5WkVtNDB0?=
 =?utf-8?B?SERha2ZxL203Y2tYeFQ1dlVSOHVKUHgvcHdBMDdXRDZObHB5ZEc2ZGVyekNF?=
 =?utf-8?B?WFM2bDhwMUxRa0ZEcUI4cFp1dmMzeU45blhIUDNwTi9nYkY0N3pkcHVoeDla?=
 =?utf-8?B?bFhwU01yVXlFdDUraFBpcGJkbjJnQjluY2lYMk1vdG9ENjJVakZBR1hTdy94?=
 =?utf-8?B?cDlOTFdHL1cwV3dOL2tXWks3QWxqZFFnS3JkZDB0NldPWU84YnFNZjE1aWh5?=
 =?utf-8?B?c0hZaXFjc0ZpWEY2SXkvbHE2UUtKU25Bek9SajZaa1dPRjUya25kQzFvMDJs?=
 =?utf-8?B?RG5TdEYrUHc2bU5zVDFwbWhBeldpUTg0K3BGV3M4MzJ5bDlCb0VLNzRzYmZm?=
 =?utf-8?B?VG1oUTZLTXZ5UG0rQldsekhPajZobDd0ZDVseHNSSmN0V0lxUEtGcUUzYVdE?=
 =?utf-8?B?WENzSnQyQ1BHZDU0Q3JOWUxwY0l4cFlLamIzRTRZTEM1VFRzRnRtcTR6clpE?=
 =?utf-8?B?bkpyVUJlcXRpVHg2eSt4UWpEOXBKVEwvTFJUUmhibngxRS9tUGxHdHBOQ01E?=
 =?utf-8?B?UE5XS2x4R1ByY0JCTkpFT2Q5cHFaVHJlaC9Oeklma25VOUtOMHpOYWtFc2pm?=
 =?utf-8?B?cjVTWERNRnd5a2ZqTVZOMnV6ZEZicm80cjRwL1dMSHZvOGwzTDNuVTJvWVRD?=
 =?utf-8?B?bXlkUzVoR1UrSE9SeUlRM0pCYU04OGdKQkY2ZmxydVhTNW5CMHZHRW12WGNK?=
 =?utf-8?B?SW1ibjQ0VGlMcFl6N25ZZ3V6bmdibDJPMHVESkpuVlhQbTBWWWxsdDdPVVhh?=
 =?utf-8?B?U1BzclpHZUpOcUxWQm1Kc2owTWFGd1RKTDZZRjRISldNZzBqTyt6dnBTVmh2?=
 =?utf-8?B?ZkZCUFYwVFQyZUNrTG1hWW5kaFRYd0VONmlMQT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 11:54:12.8293
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b99215-85d6-4286-5d30-08dddb294972
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD76.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6148

On 8/12/25 6:30 PM, Kim Phillips wrote:
> On 8/12/25 2:38 PM, Kalra, Ashish wrote:
>> On 8/12/2025 2:11 PM, Kim Phillips wrote:
>>> On 8/12/25 1:52 PM, Kalra, Ashish wrote:
>>>> On 8/12/2025 1:40 PM, Kim Phillips wrote:
>>>>>>> It's not as immediately obvious that it needs to (0 < x < 
>>>>>>> minimum SEV ASID 100).
>>>>>>> OTOH, if the user inputs "ciphertext_hiding_asids=0x1", they now 
>>>>>>> see:
>>>>>>>
>>>>>>>         kvm_amd: invalid ciphertext_hiding_asids "0x1" or !(0 < 
>>>>>>> 99 < minimum SEV ASID 100)
>>>>>>>
>>>>>>> which - unlike the original v7 code - shows the user that the 
>>>>>>> '0x1' was not interpreted as a number at all: thus the 99 in the 
>>>>>>> latter condition.
>>>>>> This is incorrect, as 0 < 99 < minimum SEV ASID 100 is a valid 
>>>>>> condition!
>>>>> Precisely, meaning it's the '0x' in '0x1' that's the "invalid" part.
>>>>>> And how can user input of 0x1, result in max_snp_asid == 99 ?
>>>>> It doesn't, again, the 0x is the invalid part.
>>>>>
>>>>>> This is the issue with combining the checks and emitting a 
>>>>>> combined error message:
>>>>>>
>>>>>> Here, kstroint(0x1) fails with -EINVAL and so, max_snp_asid 
>>>>>> remains set to 99 and then the combined error conveys a wrong 
>>>>>> information :
>>>>>> !(0 < 99 < minimum SEV ASID 100)
>>>>> It's not, it says it's *OR* that condition.
>>>> To me this is wrong as
>>>> !(0 < 99 < minimum SEV ASID 100) is simply not a correct statement!
>>> The diff I provided emits exactly this:
>>>
>>> kvm_amd: invalid ciphertext_hiding_asids "0x1" or !(0 < 99 < minimum 
>>> SEV ASID 100)
>>>
>>>
>>> which means *EITHER*:
>>>
>>> invalid ciphertext_hiding_asids "0x1"
>>>
>>> *OR*
>>>
>>> !(0 < 99 < minimum SEV ASID 100)
>>>
>>> but since the latter is 'true', the user is pointed to the former
>>> "0x1" as being the interpretation problem.
>>>
>>> Would adding the word "Either" help?:
>>>
>>> kvm_amd: Either invalid ciphertext_hiding_asids "0x1", or !(0 < 99 < 
>>> minimum SEV ASID 100)
>>>
>>> ?
>> No, i simply won't put an invalid expression out there:
>>
>> !(0 < 99 < minimum SEV ASID 100)
>
> When not quoted out of context, it's not an invalid expression (in the 
> 99 case) because it's preceded with the word "or:"
>
> ..., or !(0 < 99 < minimum SEV ASID 100)
>
>>> If not, feel free to separate them: the code is still much cleaner.
>> Separating the checks will make the code not very different from the 
>> original function, so i am going to keep the original code.
>
> Take a look at the example diff below, then.  It's still less, simpler 
> code because it eliminates:
>
> 1. the unnecessary ciphertext_hiding_asid_nr variable
>
> 2. the redundant isdigit(ciphertext_hiding_asids[0])) check
> and 3. the 'invalid_parameter:' label referenced by only one goto 
> statement. 

Re-posting, since I believe the previous email's diff got mangled:

  arch/x86/kvm/svm/sev.c | 44 ++++++++++++++++++++------------------------
  1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7ac0f0f25e68..1b9702500c73 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2970,8 +2970,6 @@ static bool is_sev_snp_initialized(void)

  static bool check_and_enable_sev_snp_ciphertext_hiding(void)
  {
-       unsigned int ciphertext_hiding_asid_nr = 0;
-
         if (!ciphertext_hiding_asids[0])
                 return false;

@@ -2980,32 +2978,28 @@ static bool 
check_and_enable_sev_snp_ciphertext_hiding(void)
                 return false;
         }

-       if (isdigit(ciphertext_hiding_asids[0])) {
-               if (kstrtoint(ciphertext_hiding_asids, 10, 
&ciphertext_hiding_asid_nr))
-                       goto invalid_parameter;
-
-               /* Do sanity check on user-defined 
ciphertext_hiding_asids */
-               if (ciphertext_hiding_asid_nr >= min_sev_asid) {
-                       pr_warn("Module parameter 
ciphertext_hiding_asids (%u) exceeds or equals minimum SEV ASID (%u)\n",
-                               ciphertext_hiding_asid_nr, min_sev_asid);
-                       return false;
-               }
-       } else if (!strcmp(ciphertext_hiding_asids, "max")) {
-               ciphertext_hiding_asid_nr = min_sev_asid - 1;
+       if (!strcmp(ciphertext_hiding_asids, "max")) {
+               max_snp_asid = min_sev_asid - 1;
+               min_sev_es_asid = max_snp_asid + 1;
+               return true;
         }

-       if (ciphertext_hiding_asid_nr) {
-               max_snp_asid = ciphertext_hiding_asid_nr;
-               min_sev_es_asid = max_snp_asid + 1;
-               pr_info("SEV-SNP ciphertext hiding enabled\n");
+       if (kstrtoint(ciphertext_hiding_asids, 10, &max_snp_asid)) {
+               pr_warn("ciphertext_hiding_asids \"%s\" is not an 
integer or 'max'\n", ciphertext_hiding_asids);
+               return false;
+       }

-               return true;
+       /* Do sanity check on user-defined ciphertext_hiding_asids */
+       if (max_snp_asid < 1 || max_snp_asid >= min_sev_asid) {
+               pr_warn("!(0 < ciphertext_hiding_asids %u < minimum SEV 
ASID %u)\n",
+                       max_snp_asid, min_sev_asid);
+               max_snp_asid = min_sev_asid - 1;
+               return false;
         }

-invalid_parameter:
-       pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
-               ciphertext_hiding_asids);
-       return false;
+       min_sev_es_asid = max_snp_asid + 1;
+
+       return true;
  }

  void __init sev_hardware_setup(void)
@@ -3122,8 +3116,10 @@ void __init sev_hardware_setup(void)
                  * ASID range into separate SEV-ES and SEV-SNP ASID 
ranges with
                  * the SEV-SNP ASID starting at 1.
                  */
-               if (check_and_enable_sev_snp_ciphertext_hiding())
+               if (check_and_enable_sev_snp_ciphertext_hiding()) {
+                       pr_info("SEV-SNP ciphertext hiding enabled\n");
                         init_args.max_snp_asid = max_snp_asid;
+               }
                 if (sev_platform_init(&init_args))
                         sev_supported = sev_es_supported = 
sev_snp_supported = false;
                 else if (sev_snp_supported)



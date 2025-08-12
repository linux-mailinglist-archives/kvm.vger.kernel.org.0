Return-Path: <kvm+bounces-54556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1BE6B23C49
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 01:30:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E33DE584E68
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 23:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F1BD2E1C57;
	Tue, 12 Aug 2025 23:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RM9uDAaN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF00D15ADB4;
	Tue, 12 Aug 2025 23:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755041420; cv=fail; b=E7Y90XN99Sluzj076PftgrVFf3WuEZPiC4Q4GpSEiX/gFfE5WDNDvFJ2YMEZ5IcMeCgjnItI50V6wMQe7MKqEmWxaY08QrnP7ybbRhvDJ8QB2FrxiULpuKh3RcLKcE5hFXC6ZVJftCI38oeZ/UvSHWz2VUJha8Ytboh49ALqBTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755041420; c=relaxed/simple;
	bh=Vt4xcgcWsLcJoau+FI8I332Olicf9urWqFLbvW28XUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FSHbxsWKRiNrZFuWVdiRw5NLI8zuHbb24RIUabLUlq3fkKwoVT3IWaX5f0utfMsfv9dzMb5UogQJ2IWGQC9cOX6jy9WqQx/WtzOsk9z2s9eaumjICF6opQP1bRD3J8BjSSHymNeaThxceIr4UccFNNF/pI0ZFx/WNNexpzNf+RA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RM9uDAaN; arc=fail smtp.client-ip=40.107.94.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LlzU9UqMgJiDtqd4gxCQi4GH99HM6n4KS/p2EZEzE2iRWpLrfJm60dYdl/Jsvj62oDzzVShWTS2v5I38Q0QkhdJP32El+rDSzjh2UI1IBTQzttssUknNb5vWE7jGxev1NuSJoPu6sin6bG+QQBBwKpbJYJoLMcHyaErxIdtWY6c9obHnCC4mUkrE9Ik3K0/95rbc8K5WW6yVn/WhTv6lfzpex0+HavtUYlXkxDUC7FvzA9ZaHEkmfyPVbWMzp0FnZvTkVKN6nxO8mmztDU1GRhFuxJA9HeQw84ZuIIT/i+Z8vnxvQxee2B7C3gF3HHlqYsx5Yir8dFzzCKO2U7Z4KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xn7IYtW5qhOzA7a8J6Lb8NWTRhzCpNnEESk8UHRx2u4=;
 b=ylL1x4EVHh4wZmMkdoyfygu3LkyqgKWFnWmWStBVhFqMwukPtJHrljfaLGtVkzYqrbcf60NSqSRxNJg58hWT4AG9dlIb/ZqhKJX6xFa06QRDXuyXcz+s5GSQfuLMzSnlPEvn9CAFSAOgsvWMaAkvcV57p1+QkVrwtFycIit3JHufFrVqwhcOkLwKJPJR4LEM8YzrR9h6i4zVQGtgMf+wvXtIawmKsMADL6RHEnV+Z1PnZNKBHlYLSt5l+dzclW3W3ksLyL8kAEJzOVr+ydt1Vgn3fY39g6GgnXwH/S1eNGQdiX/UaWvWckgst0mkiQaVfiReY12no98hW6XC+m4+MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xn7IYtW5qhOzA7a8J6Lb8NWTRhzCpNnEESk8UHRx2u4=;
 b=RM9uDAaN6toMz6n0vf3vyNPitqF/1xf4DSboVYcP/udAMq6RxtnxmW8TnnIrd4EL8kIKzRU0isLUFr6LYeaiHgQDyYvi4RpNNRVNyQxWCBNob2WVlF9G5re/9vvAo5n2JoA6EHZET8dGsX5wDuG06WOXKq+8B6R3wD4OKWlPvls=
Received: from BN9PR03CA0945.namprd03.prod.outlook.com (2603:10b6:408:108::20)
 by DS7PR12MB5861.namprd12.prod.outlook.com (2603:10b6:8:78::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.24; Tue, 12 Aug
 2025 23:30:15 +0000
Received: from BN2PEPF00004FBD.namprd04.prod.outlook.com
 (2603:10b6:408:108:cafe::84) by BN9PR03CA0945.outlook.office365.com
 (2603:10b6:408:108::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.15 via Frontend Transport; Tue,
 12 Aug 2025 23:30:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FBD.mail.protection.outlook.com (10.167.243.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Tue, 12 Aug 2025 23:30:13 +0000
Received: from [10.236.30.53] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 12 Aug
 2025 18:30:12 -0500
Message-ID: <a747227c-c194-47c4-89be-ba509c0633e4@amd.com>
Date: Tue, 12 Aug 2025 18:30:11 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
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
From: Kim Phillips <kim.phillips@amd.com>
Content-Language: en-US
In-Reply-To: <47783816-ff18-4ae0-a1c8-b81df6d2f4ef@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBD:EE_|DS7PR12MB5861:EE_
X-MS-Office365-Filtering-Correlation-Id: 4799a590-aaf8-48c1-078f-08ddd9f8302a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Sk01UENBOGR5SHRoRWdwbk5EcWFYbmtvbmpFa3FHSHZiSVNkSjJHWTNqVjJR?=
 =?utf-8?B?MTB6ZU5NWEZaenJ2WWg4N2RCUXNia0NQSXdXZmhhNGZtZ3lTdnNsbnQwTUlZ?=
 =?utf-8?B?TzloUytOWkZSTW9YTHpocFpMSWV3VW1hbXR1dS9XZWdQTkFadzdQUkY0NHc0?=
 =?utf-8?B?VXcwWjdRbFEvRUpFRFRMMFY2RnkwSlRFeEdFUC9kYitnbHQwNllqelRFSG5T?=
 =?utf-8?B?MmRTbFdkeldNUG81ZmVPOWNrRXA3Z2JXUTBpMGRlK0xOUXBjdkdwZEZnY0NT?=
 =?utf-8?B?VlhUemdsc3RNYjA3dCtTTTdvVXIrVG9tSGJFZTJVVUNXZ1VNY2pJSEswS3I0?=
 =?utf-8?B?TnZ6ZzB6cC9QZzJlaC9GQS9CVDdMUWo3Rm5MMFR1QTFNTEZnUlN1RklwTlpJ?=
 =?utf-8?B?aFhDU3p6cFVWLzdpT2VLTWZoTkNpL0Nkcmd6TWt4ZXl0QUhlYnIyanZ3WVAy?=
 =?utf-8?B?UmVxdFhtWEM1cG5NVERPNUlhdFVGSFVzbjR4QTRyY2JPY1dhSXUrVmRmc0l5?=
 =?utf-8?B?SVQ4MVFYNkp4WUg5R1YvVldwalpjS2hiME83eTVHNEg3bnNiRUxwOHRHTEt6?=
 =?utf-8?B?N0FoQWtoWUNCWVNFbHFQcWgxcVVqdlFYSlBKZlpSeERiRWZZTG5NVklqZExi?=
 =?utf-8?B?U3Z6RjllN0M1b0JDdmpSQ2pranBKV3dxUm9vT1FVb3NJaWE2eTIvZ3NzdDgy?=
 =?utf-8?B?THg0YmtIN2xsbnN6WWsxajVZM09LbFhZN1JHQTByQnM2TWZDc3MzTEN0WVF6?=
 =?utf-8?B?b0VXZ3NYRlhpLzJyYVpUcXZvVmNSUk95eFlpTUhpZmV4bXRqN1ZYU1lLbTFa?=
 =?utf-8?B?N2FiVlBIMkRWcE55R3kxTXdhNEh5VFhwdnZGcnNaS0dCSURLUDkyNWdzRm15?=
 =?utf-8?B?NWxCSVYyV2Q1Q0Voc0NtQnlDOWEwQ3B6b1JqTmR6U1lsSVhodFdlcGFxZDFF?=
 =?utf-8?B?RlpZMDZkWGpXQlRaaHFxVVlvcEZ2bmdvcldBMVozZEgycEp6bkIzZ1d2VUtM?=
 =?utf-8?B?L21jSWt3RC9Pc0xhWm1Gd0JJZ2plSGpZSGtFbXloU3h6cWI4NjhWT1R0aDhC?=
 =?utf-8?B?Nk14NjVJcHFHL0cyMlM4VFNyM2wyTGtzVlQveGFndXMzRTZmSHhVZWxEZUlt?=
 =?utf-8?B?RWNGalMwN0VBa3JXeURMbEJwczVqQndyd0tkWDY5cmxRQlJWNHJaNnpTbXJi?=
 =?utf-8?B?Y25FRjRyaUhwNGpIU3ZqV2IySlFvNWlMNzU0b25LRC81TWVWN0RLbUllOU43?=
 =?utf-8?B?Qk0xSEdBeTdaVG15Q2V5Y1NYNXUrRHRSZ0JqUDQyWXpQbXpuWXJxNXZ3N2x1?=
 =?utf-8?B?elg5Tk0yVnRHdjhLTWppYzlOYmsrL0lUSjBuNUxxd09zWm9Xc0p0cDlNaW9Y?=
 =?utf-8?B?dDZHakd3M05hajhVK3lkSDg0RUtZcVZxSGwwK0xoYnMwcVdoM3E3bzAzSUpR?=
 =?utf-8?B?bm9tZ2VzSURKUTdLTTgrdkhEZS94QzBXNkRrMXlxWVdBTXUzcGZteHRDMnc0?=
 =?utf-8?B?clBOMFcxUFJzNHUrbDJ4c0U4ZEZxNTlyY2pzYTg0SXVjVlJNZ0RQMWlvbHhq?=
 =?utf-8?B?dVJLOXZkcXZKcHEzWFRSRHQ1M21CM3JYU3EwTVh5L0NTMDFGdHZ1Nnowek1n?=
 =?utf-8?B?bk1oR2xHbmRobEU0K013MkhnSlRGZ1JaZzJkVUNldURsN1VUa3M1ZG9kajRh?=
 =?utf-8?B?cVdHRWs1WDVwZGRiRjNhVmhHdnhndlVaS3psQ0w0dVg0QWZ0UlBaNFBuUExM?=
 =?utf-8?B?YSt6OWIzVkVuYnVJQjhISlZIWG5vS1c0UTNrdEdDU3JEeTdpOXdsdGQ2L3Bk?=
 =?utf-8?B?MGUxMlBvbjdNVHY5bWpjeWpvb0pJakZBM05DeFFQbzluMnh5bUdRSU5FMGtx?=
 =?utf-8?B?WVliTTRxc0JRNTg3RVo2YzRudmpPb2V4Yk9aU0kyRXpDTXRteEtHbFYwdEFV?=
 =?utf-8?B?c3ZaRk1DWkcrR08xaUhLTkJtTjhwUnRUcHlyTnJFZHY5Zm0xOVV2TExOaFVs?=
 =?utf-8?B?NC9kWkZFL0RyeWVtVTY3RFkyNWQzQTIrUVZYb3pPVUJTcFVudFQrUWtqa0xa?=
 =?utf-8?B?b0tlWkFpb2ZOelRGWW1HUG45Tllrc0xybmR5QT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 23:30:13.9254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4799a590-aaf8-48c1-078f-08ddd9f8302a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5861

On 8/12/25 2:38 PM, Kalra, Ashish wrote:
> On 8/12/2025 2:11 PM, Kim Phillips wrote:
>> On 8/12/25 1:52 PM, Kalra, Ashish wrote:
>>> On 8/12/2025 1:40 PM, Kim Phillips wrote:
>>>>>> It's not as immediately obvious that it needs to (0 < x < minimum SEV ASID 100).
>>>>>> OTOH, if the user inputs "ciphertext_hiding_asids=0x1", they now see:
>>>>>>
>>>>>>         kvm_amd: invalid ciphertext_hiding_asids "0x1" or !(0 < 99 < minimum SEV ASID 100)
>>>>>>
>>>>>> which - unlike the original v7 code - shows the user that the '0x1' was not interpreted as a number at all: thus the 99 in the latter condition.
>>>>> This is incorrect, as 0 < 99 < minimum SEV ASID 100 is a valid condition!
>>>> Precisely, meaning it's the '0x' in '0x1' that's the "invalid" part.
>>>>> And how can user input of 0x1, result in max_snp_asid == 99 ?
>>>> It doesn't, again, the 0x is the invalid part.
>>>>
>>>>> This is the issue with combining the checks and emitting a combined error message:
>>>>>
>>>>> Here, kstroint(0x1) fails with -EINVAL and so, max_snp_asid remains set to 99 and then the combined error conveys a wrong information :
>>>>> !(0 < 99 < minimum SEV ASID 100)
>>>> It's not, it says it's *OR* that condition.
>>> To me this is wrong as
>>> !(0 < 99 < minimum SEV ASID 100) is simply not a correct statement!
>> The diff I provided emits exactly this:
>>
>> kvm_amd: invalid ciphertext_hiding_asids "0x1" or !(0 < 99 < minimum SEV ASID 100)
>>
>>
>> which means *EITHER*:
>>
>> invalid ciphertext_hiding_asids "0x1"
>>
>> *OR*
>>
>> !(0 < 99 < minimum SEV ASID 100)
>>
>> but since the latter is 'true', the user is pointed to the former
>> "0x1" as being the interpretation problem.
>>
>> Would adding the word "Either" help?:
>>
>> kvm_amd: Either invalid ciphertext_hiding_asids "0x1", or !(0 < 99 < minimum SEV ASID 100)
>>
>> ?
> No, i simply won't put an invalid expression out there:
>
> !(0 < 99 < minimum SEV ASID 100)

When not quoted out of context, it's not an invalid expression (in the 
99 case) because it's preceded with the word "or:"

..., or !(0 < 99 < minimum SEV ASID 100)

>> If not, feel free to separate them: the code is still much cleaner.
> Separating the checks will make the code not very different from the original function, so i am going to keep the original code.

Take a look at the example diff below, then.  It's still less, simpler 
code because it eliminates:

1. the unnecessary ciphertext_hiding_asid_nr variable

2. the redundant isdigit(ciphertext_hiding_asids[0])) check
and 3. the 'invalid_parameter:' label referenced by only one goto 
statement. Thanks, Kim arch/x86/kvm/svm/sev.c | 44 
++++++++++++++++++++------------------------ 1 file changed, 20 
insertions(+), 24 deletions(-) diff --git a/arch/x86/kvm/svm/sev.c 
b/arch/x86/kvm/svm/sev.c index 7ac0f0f25e68..d0a13f1b0572 100644 --- 
a/arch/x86/kvm/svm/sev.c +++ b/arch/x86/kvm/svm/sev.c @@ -2970,8 +2970,6 
@@ static bool is_sev_snp_initialized(void) static bool 
check_and_enable_sev_snp_ciphertext_hiding(void) { - unsigned int 
ciphertext_hiding_asid_nr = 0; - if (!ciphertext_hiding_asids[0]) return 
false; @@ -2980,32 +2978,28 @@ static bool 
check_and_enable_sev_snp_ciphertext_hiding(void) return false; } - if 
(isdigit(ciphertext_hiding_asids[0])) { - if 
(kstrtoint(ciphertext_hiding_asids, 10, &ciphertext_hiding_asid_nr)) - 
goto invalid_parameter; - - /* Do sanity check on user-defined 
ciphertext_hiding_asids */ - if (ciphertext_hiding_asid_nr >= 
min_sev_asid) { - pr_warn("Module parameter ciphertext_hiding_asids (%u) 
exceeds or equals minimum SEV ASID (%u)\n", - ciphertext_hiding_asid_nr, 
min_sev_asid); - return false; - } - } else if 
(!strcmp(ciphertext_hiding_asids, "max")) { - ciphertext_hiding_asid_nr 
= min_sev_asid - 1; + if (!strcmp(ciphertext_hiding_asids, "max")) { + 
max_snp_asid = min_sev_asid - 1; + min_sev_es_asid = max_snp_asid + 1; + 
return true; } - if (ciphertext_hiding_asid_nr) { - max_snp_asid = 
ciphertext_hiding_asid_nr; - min_sev_es_asid = max_snp_asid + 1; - 
pr_info("SEV-SNP ciphertext hiding enabled\n"); + if 
(kstrtoint(ciphertext_hiding_asids, 10, &max_snp_asid)) { + 
pr_warn("ciphertext_hiding_asids \"%s\" is not an integer\n", 
ciphertext_hiding_asids); + return false; + } - return true; + /* Do 
sanity check on user-defined ciphertext_hiding_asids */ + if 
(max_snp_asid < 1 || max_snp_asid >= min_sev_asid) { + pr_warn("!(0 < 
ciphertext_hiding_asids %u < minimum SEV ASID %u)\n", + max_snp_asid, 
min_sev_asid); + max_snp_asid = min_sev_asid - 1; + return false; } 
-invalid_parameter: - pr_warn("Module parameter ciphertext_hiding_asids 
(%s) invalid\n", - ciphertext_hiding_asids); - return false; + 
min_sev_es_asid = max_snp_asid + 1; + + return true; } void __init 
sev_hardware_setup(void) @@ -3122,8 +3116,10 @@ void __init 
sev_hardware_setup(void) * ASID range into separate SEV-ES and SEV-SNP 
ASID ranges with * the SEV-SNP ASID starting at 1. */ - if 
(check_and_enable_sev_snp_ciphertext_hiding()) + if 
(check_and_enable_sev_snp_ciphertext_hiding()) { + pr_info("SEV-SNP 
ciphertext hiding enabled\n"); init_args.max_snp_asid = max_snp_asid; + 
} if (sev_platform_init(&init_args)) sev_supported = sev_es_supported = 
sev_snp_supported = false; else if (sev_snp_supported)



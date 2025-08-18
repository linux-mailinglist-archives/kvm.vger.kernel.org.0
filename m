Return-Path: <kvm+bounces-54927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD49CB2B495
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 01:24:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AB484E5B66
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 23:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716DA27146F;
	Mon, 18 Aug 2025 23:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Rpsiob6B"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CE53451BF;
	Mon, 18 Aug 2025 23:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755559442; cv=fail; b=dK/qOOx40wE23BXblsqXpPovXqLtakHRFZt1Gos+KSNWQ3U84uwEPCGrjP23HVm/VJcOrXLk8YX6igOee6CMe1ry/lYLwDUcpU6XdmDnqSa7t8xGr3AjIrhxk5Uw90sUrNWDiNpCXRuag5GiXshsYQdp+lABGna2RzZM8bhgBkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755559442; c=relaxed/simple;
	bh=LgiSbm2Shu6LPQSgqbEXTCNIRlUlXFm7wYW11YISOVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=espkTGaOW03IE7GUFtEg8YVUXQ7g39HrFjqeWJvfIZhTfBTRWEReWTC6beXTp9TWgWNtHPBH4A6V4Kg4jhpxFqFdyTWbgjaazRIjwYvn8rj4Y4pmbv4+Xv2N0HOmhmgiU3UDQEXcsPtB+DwRHK5aswwvzUY1HsXSeYvXMyqWm2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Rpsiob6B; arc=fail smtp.client-ip=40.107.220.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BALuyTM7Xk/gCG/zGF+p8f+8ZeMOECpNiZW7UoNSLZmv8XEbOEPM/ZIMlpzoJBS+ntFP8xnRusqOCLOsEQDXPMrcKM5o5zvteuDMwGcxKLrgO3X5lxhClXi/U6DvY/aLdeEjfMJBlCC320/qebUFz/g3K7pdY9B1XXg8KTu4ZF3GWCSayRRwnlMVQetxG4/4zwEANayNflmonp1s5SeJgx2qG2Lwg4Pnj5Iz1Me1wfXmDcdpZT5YSuKBeZjxH3vPQaE2LjvK0bNhYTHChmzcOtCzMK4pbOctnSgAxGG0jQEmfaICsOkL8/eLU3b6II5MVZuQU/df6rKsxXDnTJS6jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qb7BcD36UB6pV/zvOuGc9DLIBGAVQMDkM7YIadwpprQ=;
 b=ZTINLXtPk/PX/ivKbHjuo9OCVIhHQM8jakf9puETYehcd8spC3qd0jik01r4amcEGVjIK2bKQ/KgK2Ffl/8X7EpyOHmbL9lsM4nGudyBTco2dH8jVUJ1nKCHU88HdE8voEdg7pDCz+EJzZM7aU4hywvI7dv5BjfkJg9BwMlKoEkehdISxNDY+3CcCKiiiV6tc+X2ED6bbPk9d0JkyXSXyqMHLzjXFgv43kKf9KlVlCm4H97aKdQp9fPECh+IS+Fba54W1B/Yh1EPlLuoydkqdK0rctHJUhSAIom/P7o62K482IL7CxYjkmMTWsC1BQdy9vzH+Z8SmOtmHl50AXtIFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qb7BcD36UB6pV/zvOuGc9DLIBGAVQMDkM7YIadwpprQ=;
 b=Rpsiob6BtfrRxVMzLMMveX6LigMOBVthLUzrIBQsE16c/mC8/SKJQL0NzR9wgWQUXfNo3A/jQqF5Q8D9zoYlzxqtTGeWgTGjKa/4vl9DjMX1FtXSoh0BnK50WHTXWnybksBIy3M3ciYMtnHJ17xxn+nYUT90lRRjQD6G4v33Vqo=
Received: from BYAPR02CA0051.namprd02.prod.outlook.com (2603:10b6:a03:54::28)
 by CH3PR12MB8712.namprd12.prod.outlook.com (2603:10b6:610:171::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 23:23:56 +0000
Received: from CO1PEPF000066E7.namprd05.prod.outlook.com
 (2603:10b6:a03:54:cafe::97) by BYAPR02CA0051.outlook.office365.com
 (2603:10b6:a03:54::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.20 via Frontend Transport; Mon,
 18 Aug 2025 23:23:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000066E7.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 18 Aug 2025 23:23:55 +0000
Received: from [10.236.30.53] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 18 Aug
 2025 18:23:53 -0500
Message-ID: <a16f1420-fe20-4c3c-9b75-806b1da22336@amd.com>
Date: Mon, 18 Aug 2025 18:23:53 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] Add SEV-SNP CipherTextHiding feature support
To: "Kalra, Ashish" <ashish.kalra@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>
CC: <Neeraj.Upadhyay@amd.com>, <aik@amd.com>, <akpm@linux-foundation.org>,
	<ardb@kernel.org>, <arnd@arndb.de>, <bp@alien8.de>, <corbet@lwn.net>,
	<dave.hansen@linux.intel.com>, <davem@davemloft.net>, <hpa@zytor.com>,
	<john.allen@amd.com>, <kvm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<michael.roth@amd.com>, <mingo@redhat.com>, <nikunj@amd.com>,
	<paulmck@kernel.org>, <pbonzini@redhat.com>, <rostedt@goodmis.org>,
	<seanjc@google.com>, <tglx@linutronix.de>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <20250811203025.25121-1-Ashish.Kalra@amd.com>
 <aKBDyHxaaUYnzwBz@gondor.apana.org.au>
 <f2fc55bb-3fc4-4c45-8f0a-4995e8bf5890@amd.com>
 <51f0c677-1f9f-4059-9166-82fb2ed0ecbb@amd.com>
 <c17990ac-30b2-4bdc-b31a-811af6052782@amd.com>
From: Kim Phillips <kim.phillips@amd.com>
Content-Language: en-US
In-Reply-To: <c17990ac-30b2-4bdc-b31a-811af6052782@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066E7:EE_|CH3PR12MB8712:EE_
X-MS-Office365-Filtering-Correlation-Id: ac4b4607-fe41-4cc1-a26f-08dddeae4d47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VEszREJsZ3gxcEwvVytOdUZrQXdLS25HWk1HQTZDR0xaUGxQYmxlNGNjYzE3?=
 =?utf-8?B?THEyOWRaek54aWlqM25WckRrTVVrUzFYT2tmVnpOV3hJcTUxQUhBWGNVTWNV?=
 =?utf-8?B?VnZsWDY1eUh6Q1BhMWRheWZ0SG5ocnE2TlVwVVRVZng3TWYrMEo5bHVZdFo0?=
 =?utf-8?B?cUQ4L2R5VVREZ1d4dlc0eVZoakFNUjE1VXBTWTNwVkVVbkw1a3pZVjVIU3NR?=
 =?utf-8?B?cXB5WUZFd2x5aVE3L0IwQnd1MndkWjhQamhyOU5kSXVRZW9uZmVPb0RBOGZU?=
 =?utf-8?B?djBJSmRWalNsRjVVSG9QQlM2aFRxeXc5KzdYK1E4ZGU4eUl4b1dXVzdsZFRv?=
 =?utf-8?B?aCtscFpNRFRQSUNmNWZSR05aTmsxdmovaWxiVXdoL3MwRHJxV3NNOTFNTlB3?=
 =?utf-8?B?eDNLUkRsY2R5V090LzZMM1VKNXB2Y2g4MTlKd3Y1c2hGVE4yQlU1cW5QenNv?=
 =?utf-8?B?dGsrS2RJVHEwd2ZHYUxWTTNPeHZ5cDZJZk8rZXlTUlhZcTNPb2xSWGIzYkVr?=
 =?utf-8?B?aEVtdE03dGVaaU5namt2Y1hZaWZ6WnMxWkNCRWd3YXVMNU16bWxtUFBOWUc4?=
 =?utf-8?B?aUtVbUpDcm9EdGk5RkNORWhZcnZnS2ZOY1A5cGJHRjZ5bFpNaElzMXdsZS9C?=
 =?utf-8?B?SUxhNlV3ZXBMcUZuWnlnZ3hIdGErb1pYalZTUWtZODlDWDdJSkZ5R0VZUldx?=
 =?utf-8?B?dFVuTnJ4N3V6L3I2RXFtdFVXK3kwY0wxMTFuNnErZE96ZzRvZWNFVjBmcnlG?=
 =?utf-8?B?Z0xTSG1pMWI0VHg3Nk9SZ3l3NjM4b3E5d0ZpV3NGcTlrcG1oSDB1N2lMTHJG?=
 =?utf-8?B?cHhPclh3U09LajZ3YjIzK3pwTmxBZC9PV21JWGtZRFY1ekcyVk1xYlQrb1dQ?=
 =?utf-8?B?Y2tYRHdxTzNqcHJWNkdDV2hJNjJEdXhiVWx0TitUSTFOT1NmeUlXUys4bW8w?=
 =?utf-8?B?cm94blo2ejAwY3VTN2Q2ZWYwZVpzbWhiendHZHJqWnZGYzh2RG5xaHVhU0l0?=
 =?utf-8?B?VC92TjRPallmdTdMUlcxanhhWVZ2QktWUGY1UXIyNnBmMTg1ZjF0ejBuWlRO?=
 =?utf-8?B?b2RxaUFFV25WQmhXV09EL1RRWjdycEtTb0ZlcmdJczIwZnRTL2VpZXljTUs2?=
 =?utf-8?B?aThNVjNYdDJsbCtXUGZScHhHdG1sY0VLK0hjREtZdWNteWlmUmwwKzBCcXZY?=
 =?utf-8?B?eE5YSVAxbm05K0dSMnA4b2o0d2EvZ2Q0emwya2hMcmZ3bEhXcytveU43dnlF?=
 =?utf-8?B?WVRURGZHNGhWU2hITGdXYWtEZkN4S3k2OVhvUFVYS05oSWYyL1NnR0ZtcGZQ?=
 =?utf-8?B?N1kxS0Z2UEpaYlpPNTVENWRTb1RyMDgvWkNBcE5hZi9PQVIxQkJPeWFhaUV4?=
 =?utf-8?B?R01HVkZHVFhvVWRQU0VzOTgrR3lZVFpCWUNjSXlzb3M5ZHdaSE9aUjhacm9Y?=
 =?utf-8?B?ZGo3MU1wSzV2WkZZUlkvSnliVk1STUJYb0tHSkdtOXBPWGN5OSs2bE14aVpx?=
 =?utf-8?B?Yk96YVNJby8rNk5JYXdwR2tOdDBST1pxN21zRUNvRy9oNkN3TStCMVk0aXc2?=
 =?utf-8?B?Tm4yc0J4Z2ErOGtvbkJzVzN0K096NXozMjgzYy8vZ28wM3FuR1Rmd3Y1c09L?=
 =?utf-8?B?cmN6cGlWWWVXLzZ0dHVjMVFuaTNVcFAyVzloWGxtRlVkdFBudW9xOTNHVFl4?=
 =?utf-8?B?NVgvVGVVWjlKdE5xT2s1aHVqSVlsOHZYUDh5YiszdTZqeVdvb3FnRW0zSDNN?=
 =?utf-8?B?ZGQzcmJ4c0tPNHRYSE8xV1RVbXdVeEpSc1NZaEZWbUNGMmRwbTBHazBLbVZT?=
 =?utf-8?B?WUh5TWI5RnpleCtGOVJTQW5yZjZqbVpvMlZLNWhhTWk5MkhDNU90TWkyQUM2?=
 =?utf-8?B?VE5Oa0dHZmYzem04U3lDYi9pMlM1cDM4OVRlaFBwR3Z6MUZMdHZsbmM1Uk5l?=
 =?utf-8?B?cGJrV0ZkR0szVWFNY2tadXFyMXYwcSt3K1FmSUhGeERZdWU4Mzd1YnFsRkZn?=
 =?utf-8?B?SzAvd1dUWnBBPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 23:23:55.7342
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac4b4607-fe41-4cc1-a26f-08dddeae4d47
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066E7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8712

On 8/18/25 3:39 PM, Kalra, Ashish wrote:
> On 8/18/2025 2:38 PM, Kim Phillips wrote:
>> On 8/18/25 2:16 PM, Kalra, Ashish wrote:
>>> On 8/16/2025 3:39 AM, Herbert Xu wrote:
>>>> On Mon, Aug 11, 2025 at 08:30:25PM +0000, Ashish Kalra wrote:
>>>>> Hi Herbert, can you please merge patches 1-5.
>>>>>
>>>>> Paolo/Sean/Herbert, i don't know how do you want handle cross-tree merging
>>>>> for patches 6 & 7.
>>>> These patches will be at the base of the cryptodev tree for 6.17
>>>> so it could be pulled into another tree without any risks.
>>>>
>>>> Cheers,
>>> Thanks Herbert for pulling in patches 1-5.
>>>
>>> Paolo, can you please merge patches 6 and 7 into the KVM tree.
>> Hi Ashish,
>>
>> I have pending comments on patch 7:
>>
>> https://lore.kernel.org/kvm/e32a48dc-a8f7-4770-9e2f-1f3721872a63@amd.com/
>>
>> If still not welcome, can you say why you think:
>>
>> 1. The ciphertext_hiding_asid_nr variable is necessary
> I prefer safe coding, and i don't want to update max_snp_asid, until i am sure there are no sanity
> check failures and that's why i prefer using a *temp* variable and then updating max_snp_asid when i
> am sure all sanity checks have been done.
>
> Otherwise, in your case you are updating max_snp_asid and then rolling it back in case of sanity check
> failures, i don't like that.

Item (1):

The rollback is in a single place, and the extra variable's existence 
can be avoided, or, at least have 'temp' somewhere in its name.

FWIW, any "Safe coding" practices should have been performed prior to 
the submission of the patch, IMO.

>> 2. The isdigit(ciphertext_hiding_asids[0])) check is needed when it's immediately followed by kstrtoint which effectively makes the open-coded isdigit check  redundant?
> isdigit() is a MACRO compared to kstrtoint() call, it is more optimal to do an inline check and avoid
> calling kstrtoint() if the parameter is not a number.

Item (2):

This is module initialization code, it's better optimized for 
readability than for performance.  As a reader of the code, I'm 
constantly wondering why the redundancy exists, and am sure it is made 
objectively easier to read if the isdigit() check were removed.

>> 3. Why the 'invalid_parameter:' label referenced by only one goto statement can't be folded and removed.
> This is for understandable code flow :
>
> 1). Check module parameter is set by user.
> 2). Check ciphertext_hiding_feature enabled.
> 3). Check if parameter is numeric.
>      Sanity checks on numeric parameter
>      If checks fail goto invalid_parameter
> 4). Check if parameter is the string "max".
> 5). Set max_snp_asid and min_sev_es_asid.
> 6). Fall-through to invalid parameter.
> invalid_parameter:
>
> This is overall a more understandable code flow.

Item (3):

That's not how your original v7 flows, but I do now see the non-obvious 
fall-through from the else if (...'max'...).  I believe I am not alone 
in missing that, and that a comment would have helped. Also, the 'else' 
isn't required

Flow readability-wise, comparing the two, after the two common if()s, 
your original v7 goes:

{
...
     if (isdigit() {
         if (kstrtoint())
             goto invalid_parameter
         if (temporary variable >= min_sev_asid) {
             pr_warn()
             return false;
     } else if (..."max"...) {
         temporary variable = ...
         /* non-obvious fallthrough to invalid_parameter iff 
temporary_variable == 0 */
     }

     if (temporary variable) {
         max_snp_asid = ...
         min_sev_es_asid = ...
         pr_info(..."enabled"...)
         return true;
     }

invalid_parameter:
     pr_warn()
     return false;
}

vs the result of my latest diff:

{
...
     if (..."max"...) {
         max_snp_asid =
         min_sev_es_asid = ...
         return true;
     }

     if (kstrtoint()) {
         pr_warn()
         return false
     }

     if (max_snp_asid < 1 || >= min_sev_asid) {
         pr_warn()
         max_snp_asid = /* rollback */
         return false;
     }

     min_sev_es_asid = ...

     return true;
}

So, just from an outright flow perspective, I believe my latest diff is 
objectively easier to follow.

> Again, this is just a module parameter checking function and not something which will affect runtime performance by eliminating a single temporary variable or jump label.
With this statement, you self-contradict your rationale to keep your 
version of the above to Item (2): "isdigit() is a MACRO compared to 
kstrtoint() call, it is more optimal to do an inline check and avoid 
calling kstrtoint() if the parameter is not a number". If not willing to 
take my latest diff as-is, I really would like to see:

Item (1)'s variable get a temporary-sounding name,
item (2)'s the isdigit() check (and thus a whole indentation level) 
removed, and
item (3)'s flow reconsidered given the (IMO objective) readability 
enhancement.

Thanks,

Kim



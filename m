Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33ED637AE7C
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 20:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhEKSaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 14:30:21 -0400
Received: from mail-dm6nam10on2083.outbound.protection.outlook.com ([40.107.93.83]:47521
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231329AbhEKSaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 14:30:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVf9mUBzc2onnPzsYaw52eHAOsolEmhsmTPej4e3Hr/1mjtMXeCBb/e+ChSbMSff5+kXPFYGUXlEG7YRzi89LxNVEabvgtja8rKNhBZLpTrn7V+IDF28wvXsm+54wivePeLjYrLtPOXEiDpYcgjFCcDaH95jia+rRtckxU2F2/o/vzsT+I8i45TYkAIM0a+vywqr2PyRQcZmQ+uSz0Vut77Kdtw8yhQ+bebsKHUjHzCXE+5d5C5L/LXpI0FFthRMSDcP6695QcYYqK2hdyzWHErqkbJu03OvH/jSozlQWXc4iHLMuHXEcgbSIcHzQVs1/EXLHNlEhRcqLtz1hYwqYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4bqp8QF99fty+LTgozKn9SocY984CaQPtTO3GgT5Mk=;
 b=oc5BBVhIE7WsVqn6p6n1Z3U0llrW+icuf5rpOSFKdS6gic2IuGjIMGKD6poWCZUlK37hwrLPcg/E3w3UKxuIr4Y/j83GBPmpptVwuypdhJWIn511VySb0wTxbBgp1rPkPmUFwbPjJNctoZMmJvRiE0HGEvF3OYN1bbkqw3ozKoIc9GgfTJRrMBvJWtHoPImOgdi4VhFChMvI/AuwBKz/IBfVSMkHzlJtRniNIVKLMeNTyAOXp0GOSqgrNqNoh3b1Wo9NIfZkuIS8BhdgEMwkxSQeKYgIs6XkplUdfARfDD5oU+zvaK+3QqCN5FJzg87429KydPRav4uhTOhK1PAWYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4bqp8QF99fty+LTgozKn9SocY984CaQPtTO3GgT5Mk=;
 b=zEMwuSkpYp+JPYCcRSUaVrfaZlBbD/rxrzi/wy6GaPqad8t7FC/J/2sCX/p5Rni+LVohvTZs7WTaYcrqSYiroYC5B6oLvaKJwgkjU/chWPbSYPFu7m2HYWPn5pcftWiB+TCOT+5evEOjWnnB1bWVuUQVrv540M26I5A8ZqUpILM=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4429.namprd12.prod.outlook.com (2603:10b6:806:73::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Tue, 11 May
 2021 18:29:03 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4129.025; Tue, 11 May 2021
 18:29:03 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 02/20] x86/sev: Save the negotiated GHCB
 version
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-3-brijesh.singh@amd.com> <YJpM+VZaEr68hTwZ@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <36add6ab-0115-d290-facd-2709e3c93fb9@amd.com>
Date:   Tue, 11 May 2021 13:29:00 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YJpM+VZaEr68hTwZ@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0501CA0099.namprd05.prod.outlook.com
 (2603:10b6:803:42::16) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0501CA0099.namprd05.prod.outlook.com (2603:10b6:803:42::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.12 via Frontend Transport; Tue, 11 May 2021 18:29:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8afea1ff-637a-40c6-9298-08d914aaa700
X-MS-TrafficTypeDiagnostic: SA0PR12MB4429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44292F077CB2262236D00C7CE5539@SA0PR12MB4429.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zN0kF67vEu9ZxH1L65Z0LAOSXqOdhIcOBt/82A0zwJlJIJNgIxq5B51Sz0k+BhJGL8ofAbL49dGgQbhHujOuu7eIhuPo7ZBnhptD3N1P08pOxdrq/WQEi2ZWgfLSz5p164TaWlUMfVLvE6FclMR2LCUvY74JuI4bvrYNyCeo6Mr9OsxWQILpdb4pcDhlYXO9IcsQT1fa1tbFL0TVLI+v95qAnN8mCndZYqr2HCrRTUgB1B/LRxpcjV2UU/QQT0JI2FK2I1301Bh5ooNLwC8H7W6bsHH/JZDI9oMmtwmyOqMo18RPqroq2c/mMUcq63MamUmS2Y/NXYPYGxYQIaPfbRjfgv/4EnLYGUtAG1iRfIFBm9Euznz09rk0/Rijj/k0Vlh9KlIVdO7ZJTLoXZtt8pk4JqXqABQdotRPvISrlwY6TDvpw9bzNe2s1dF8Ablivp+6l9wDy59mtFGpHcjZoJKpvr7+QHd70eMiDkFRduw5EKJssiYBRvsXJ0meTJxlILk/MV4AQNaZxFh0dXIjEmrKEfKRGZ3c2MMXTmzOMSdt7v3H6bEtOsbgzEH9/r26Bkc0pODXx8AyQBi5woE9ToOBkvBYkyTFzZChEzQIpTPJENDUgVvueRGxqAs7RF3IlXFty8tqQq40me5eInG0n7C20gTVIi811aCPc3PHg1q0o3hPvDuawoE80CBkAJ0XxFZMTr037Z8D2x+wcwLTCbr3hiE1wfOPQgqh12s+9cQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(8676002)(16526019)(186003)(8936002)(6506007)(53546011)(6486002)(36756003)(31696002)(478600001)(52116002)(66476007)(38100700002)(44832011)(6512007)(66556008)(6916009)(26005)(5660300002)(956004)(4326008)(38350700002)(31686004)(7416002)(2616005)(86362001)(2906002)(83380400001)(316002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TU1lbmRlcUVFeThVSGxQTXllS0hCOWJGbGtjSGdlVkdud2JvRXdsenB0dTM2?=
 =?utf-8?B?SjkvMEhhRHQwUklYclJnYTdwVXZLbXN2SU03d2lzc01jVE5zczRzdDhwYUVV?=
 =?utf-8?B?cFRad1p1OTlSVUxWVUtXa05SR0o1bEpqUmJ6bE14SlR5SHYxQ0FDWEtTVWFF?=
 =?utf-8?B?RVRFbXVSTzFmZjhHSDE2Q1ZwM0JVM2hVWm9vdmxTUkNHdEtCQ1g4Mkk2dk1t?=
 =?utf-8?B?MHdBUlEyTEdEdjM2c1NQdmNhUnJWN1NOWmhmU1FlQ0xPUml5MUJTeTdYQkMx?=
 =?utf-8?B?QVBKNDFUdzNLTDNLUWRaVGtSblRFRDFzYVFlaFQ3cUdyOW10c0Q4OFhJbGlV?=
 =?utf-8?B?VnE0S2IrYm1HNE9MTXJEZDlvQndESW91YVlEaHpTaVVoNGY2b0NmU000Mito?=
 =?utf-8?B?ZU5La2NPM2creERad3JSMXdXVnN1eTN4OXFIK25OMXdNUnJSSmRTTUE4NzZz?=
 =?utf-8?B?THFWZ2pobjhNL01IOTBHYjIrWGUzbDBmQzhXajI2V2x4LzBCcU5YRURWTFRZ?=
 =?utf-8?B?YkRnTWFpeEsxaG9Yd0xhVEVFYXVvTEZsaWdIWXAyWThBcmxlVExXVmJiQS9K?=
 =?utf-8?B?a29XekZPb2xMUk4rTGFDeXZDTmNvTUlkZzNxOGlqbkFVWG5LNkpJR00yVG9X?=
 =?utf-8?B?c2x6OFJwSm03VStQOXZNbUhhVzhaNjdPMWRadGt4aU9lWUdJcWUxZGtKMHdh?=
 =?utf-8?B?UW0yZlhMMVRrWGdTb1pkR2JnSUhNdXNZSFdhS0ZVaXEzc3Q4UGVNMHIzaVhJ?=
 =?utf-8?B?bFR4Y0JDc0UwNEpXeUpaQmtLYk5sZTYxWmFUR1d5aVJOTUNqenI5dEhQank3?=
 =?utf-8?B?ejdZV1JXa25GS0t1RHN4WUh5d2FMMUNlb0V1M2x6L0ZEQTZUcDBleHV0dDR6?=
 =?utf-8?B?NkN0N0lTOWVNQmR1b1pCVjdUcnJrc0ZaNXZxeWlKdTJRSWxRUWtJZldJY3Fp?=
 =?utf-8?B?eXE3U0g2RFJBaWRrZ3IwM1ltM0JkNTlwR2htRkhsSDgwdDhkRXNqb2pkZ3ZV?=
 =?utf-8?B?c0tGU0JpbWJyUTZUUjF0R3E2RnEzZlIzVjVTbVdLWjJzODBoSDlSdmx1RnNZ?=
 =?utf-8?B?TkZ4UUpPUmRtOERHT0M4N2RnYzZCekJ4WFhFb0ZocE1LWGtaQmFHSTNlQnlS?=
 =?utf-8?B?ejRXZC9GdStVSFZIbTh4L2RvSmNLTzUzU0FOdnFPeEU2N1Z3MVdaUThEdkRR?=
 =?utf-8?B?TGR5S084OG82RW54dXdheW84R3QxZ05LWFY0QkV3dHhqQ3EwYXBrNmNUTTZX?=
 =?utf-8?B?QXhXTVBkNTI1T1hvOEJsYmxscjlhcHJYWWdIamNnRi9tWGdYei9EOWFjWk83?=
 =?utf-8?B?UTN4R0ZnQ3pua2NCZnpIdURqY1QwL29JWjZjdDhQWnlndDcxRytsSmtMRHZO?=
 =?utf-8?B?dnJkVm5RM0JMcHV6blFkNTJ1dE5wOE5zV1lvV2RNMkFwdjNmNE4yUnB6WXdu?=
 =?utf-8?B?UkV5WGlxclRvSGdzRlNzMzNvRkNxUTUzVVR5aVZ3L0JaZDlwaGNvcXg3NjBx?=
 =?utf-8?B?RHJsdkhqdXFaT1pjQW93aUpIZWNMY1A2akNBL05OeEZPS1RpZmRsUUI0Z2pQ?=
 =?utf-8?B?djhnbTRuTlZsK0UwenE2a3daMC9OQkxDMi94K1hvWUJONEMxMllaaDg1eEVY?=
 =?utf-8?B?Zk9URThScXBFTlVPN0luYmIvNWMxejF2eVRSS0xlRFVJSkJvMTNtL0ZOb2Rt?=
 =?utf-8?B?TDkrSnBWYWNiWExlSTlRWWliRDRzL1R2NDMvMUdhczVkdmNUZ0YreW40L0hQ?=
 =?utf-8?Q?7qlXFhVFxpLQUmoSaMZKiVwMfk/JgJ7RzkY+qu8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8afea1ff-637a-40c6-9298-08d914aaa700
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 18:29:03.0822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vmU4kMIePtjluHjgFDzx9qOUTJzUFqGmAUn+7keYSGpMNdh3A3AZmZvbIQOhlYnxclvc9Hj7wcE2iCWYm5FTCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4429
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/11/21 4:23 AM, Borislav Petkov wrote:
> On Fri, Apr 30, 2021 at 07:15:58AM -0500, Brijesh Singh wrote:
>> The SEV-ES guest calls the sev_es_negotiate_protocol() to negotiate the
>> GHCB protocol version before establishing the GHCB. Cache the negotiated
>> GHCB version so that it can be used later.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  arch/x86/include/asm/sev.h   |  2 +-
>>  arch/x86/kernel/sev-shared.c | 15 ++++++++++++---
>>  2 files changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index fa5cd05d3b5b..7ec91b1359df 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -12,7 +12,7 @@
>>  #include <asm/insn.h>
>>  #include <asm/sev-common.h>
>>  
>> -#define GHCB_PROTO_OUR		0x0001UL
>> +#define GHCB_PROTOCOL_MIN	1ULL
>>  #define GHCB_PROTOCOL_MAX	1ULL
>>  #define GHCB_DEFAULT_USAGE	0ULL
>>  
>> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
>> index 6ec8b3bfd76e..48a47540b85f 100644
>> --- a/arch/x86/kernel/sev-shared.c
>> +++ b/arch/x86/kernel/sev-shared.c
>> @@ -14,6 +14,13 @@
>>  #define has_cpuflag(f)	boot_cpu_has(f)
>>  #endif
>>  
>> +/*
>> + * Since feature negotitation related variables are set early in the boot
>> + * process they must reside in the .data section so as not to be zeroed
>> + * out when the .bss section is later cleared.
>   *
>   * GHCB protocol version negotiated with the hypervisor.
>   */
>
>> +static u16 ghcb_version __section(".data") = 0;
> Did you not see this when running checkpatch.pl on your patch?
>
> ERROR: do not initialise statics to 0
> #141: FILE: arch/x86/kernel/sev-shared.c:22:
> +static u16 ghcb_version __section(".data") = 0;
>
I ignored it, because I thought I still need to initialize the value to
zero because it does not go into .bss section which gets initialized to
zero by kernel on boot.

I guess I was wrong, maybe compiler or kernel build ensures that
ghcb_version variable to be init'ed to zero because its marked static ?


>>  static bool __init sev_es_check_cpu_features(void)
>>  {
>>  	if (!has_cpuflag(X86_FEATURE_RDRAND)) {
>> @@ -54,10 +61,12 @@ static bool sev_es_negotiate_protocol(void)
>>  	if (GHCB_MSR_INFO(val) != GHCB_MSR_SEV_INFO_RESP)
>>  		return false;
>>  
>> -	if (GHCB_MSR_PROTO_MAX(val) < GHCB_PROTO_OUR ||
>> -	    GHCB_MSR_PROTO_MIN(val) > GHCB_PROTO_OUR)
>> +	if (GHCB_MSR_PROTO_MAX(val) < GHCB_PROTOCOL_MIN ||
>> +	    GHCB_MSR_PROTO_MIN(val) > GHCB_PROTOCOL_MAX)
>>  		return false;
>>  
>> +	ghcb_version = min_t(size_t, GHCB_MSR_PROTO_MAX(val), GHCB_PROTOCOL_MAX);
> How is that even supposed to work? GHCB_PROTOCOL_MAX is 1 so
> ghcb_version will be always 1 when you do min_t() on values one of which
> is 1.
>
> Maybe I'm missing something...

In patch #4, you will see that I increase the GHCB max protocol version
to 2, and then min_t() will choose the lower value. I didn't combine
version bump and caching into same patch because I felt I will be asked
to break them into two logical patches.


>

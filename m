Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C727E4A74A2
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 16:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345476AbiBBPct (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 10:32:49 -0500
Received: from mail-bn1nam07on2045.outbound.protection.outlook.com ([40.107.212.45]:37694
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230120AbiBBPcr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 10:32:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+cqvol+g+QzTUJsgfVhjnCZnGYyRVcrMZeeBClUnhEbRFOBzSqymzxICAwQCoNw201+Saw1fYV9rCxur5jmL1R9A0DEu/kTeiHwY1l+LsEcRuE0ustMIDf1oqFqvHoESt/rItIqf16VK3kjTA6KaMwdC/AAo9AvECXmQL6WPmHxAsCNF36bGWM96DUm24+5dNih+iw6+CUwDVkDss6jiCtShvmiNLyAs0mYl4iSpmQqVXOD491lw1aM4Q139pcvCIQHvCmZawvDoQFomaEv4m9BvcgyeZtzQn7sjh6+7z6gWsPKN541JYnjsh4Erq3kw1XgR7euviRHrYx5BKgf4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQWt4PAIIW3pwXHBCcaLusXejxz1NzE6ZzAR9y9curg=;
 b=Jou9UIAdvPzSdX69pI5di4zRs+oIXYv92BRbZr9L6kgYoHV1RVrHPfmM69spoxQRVCoF3xMwtpZ8AYTxAIHlir7EAG2101mWT1IsHgucKJ20SwZhhmawhWmxZ9vmsriN+kZyFmaz18MnSwMkvmhEqJSDIaUi1mzS6WzzCc57lwohe2SFyZPhJv9rplPAxdprPHWW5xfgdzyYNdahC70rZcymRb9keePSaFoMxSCLqjUZTIf0CYtPal4aHbbiUtMurtCy7AZW0UFEdmXAezhTDnc1XdDBl+9Aw51Scf+KrzVLpA2btbAriTW5dv4Q8dOqzBmHCCxC6ByjMKwlfsQPjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQWt4PAIIW3pwXHBCcaLusXejxz1NzE6ZzAR9y9curg=;
 b=vIqxVYqG0ANCHuKh568fmYYZZw45+yhtGBUZB0mH7UXVXSVs4C4Kr+0mhVPcSiEwi9o8yV1pMr6XebZJX3L608RvqrRCS86jkG2Wxge3OOw5fb0Bg5RRfdI5br+7cc/7M6mMqP5zCQBzy9AslIBRAd7Tm9WJgG02T781BJBKS64=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3053.namprd12.prod.outlook.com (2603:10b6:208:c7::24)
 by MN2PR12MB3471.namprd12.prod.outlook.com (2603:10b6:208:c8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Wed, 2 Feb
 2022 15:32:46 +0000
Received: from MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::10c4:c928:bb18:44bc]) by MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::10c4:c928:bb18:44bc%5]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 15:32:46 +0000
Message-ID: <fe53507b-9732-b47e-32e0-647a9bfc8a80@amd.com>
Date:   Wed, 2 Feb 2022 21:02:28 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v2] perf/amd: Implement erratum #1292 workaround for F19h
 M00-0Fh
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     like.xu.linux@gmail.com, jmattson@google.com, eranian@google.com,
        santosh.shukla@amd.com, pbonzini@redhat.com, seanjc@google.com,
        wanpengli@tencent.com, vkuznets@redhat.com, joro@8bytes.org,
        mingo@redhat.com, alexander.shishkin@linux.intel.com,
        tglx@linutronix.de, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org, ananth.narayan@amd.com,
        kim.phillips@amd.com, Ravi Bangoria <ravi.bangoria@amd.com>
References: <2e96421f-44b5-c8b7-82f7-5a9a9040104b@amd.com>
 <20220202105158.7072-1-ravi.bangoria@amd.com>
 <20220202143657.GA20638@worktop.programming.kicks-ass.net>
From:   Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <20220202143657.GA20638@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0004.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:d::14) To MN2PR12MB3053.namprd12.prod.outlook.com
 (2603:10b6:208:c7::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d728ee63-485a-40bf-5e03-08d9e66142c5
X-MS-TrafficTypeDiagnostic: MN2PR12MB3471:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3471F56E3673AACC422E315AE0279@MN2PR12MB3471.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 95Zjs2QZy4RuFQGVF9nBOXHBXckIz+AulHRgym0Mrmizolvsu8ypSPXPjbH52Jw/Ka8cXbPBR/R5Z9j6x/2abrzVzBYxQ7//KemNx5NwQ9z3AQiByMdFRxjrLe7LwSubOw57lYT/ytMy2IWaFSNI5cWKXHM6rGwXW/4FAD/Z40YCcwMvpSy7pGv7Zx36axoX+SIDckEUyXDzEy9PSl39/HVBRzYQCOvI2PK1H1eEhPQkEShfsR+2EhZ5kt+KIoL089a1GYZyZYfrUDsbRb1kFAILMrmIDqzoxqYbppEFRCNbS8vlN0qDHzq8dQTvGQEjSxlGCsRRKTepQy7S0kqg994pwkQX71Jljm/YR1B0eHV8Peck56o6qMN9bRqyJ4ReCpG5jEYnA1MxXl8Uc/DVENQaYq4Wtiy8ExpaRcIgsyyNN6vu0kMcT/f7bXFsTUk4UtDn8ILjw6luZJhmTrq9REyL/DjbOTP8JA45Ne2rQOLaGp9vSBzuVGHKRo5L8R93i/7NCBpU+K0OOeK+h1eQD1ZiCt5cqcuXrLZzZjCjzE8Qe9aG/j4TvEtSFFThpMCLGVrmaJYT5bdonfoTkAVH6itD+vsNqXO7ApjrIxjJ8MV22Nx7ha/2dE6ynkGpwNpz238EhFd+KL1a3HMLb3W3XPvt7OQPDpZLzkMq2ngbm6c3lyo3cV6Y55sl0HsInFaipJqgkd91kVCKlYvYxCERfEw/pQW+RCi7IOaP9jI6nNI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3053.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(6666004)(508600001)(5660300002)(6506007)(6486002)(53546011)(8676002)(6916009)(8936002)(66556008)(4326008)(66476007)(66946007)(31696002)(6512007)(86362001)(31686004)(2616005)(316002)(36756003)(7416002)(44832011)(38100700002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dExhM09tQUpWcjVWNDNUZkx4U0g2ejB2OWxKaW85aGg0TlpCOW1vbzAyWkFI?=
 =?utf-8?B?Q1g0cndqUVhCMVRVVFFFR2ozcnBHQTZKcmJzcWg1d01VcjFEU2VpTGhLVkdz?=
 =?utf-8?B?UW1pV2w3MTdFQjJTVEowdy93Y3I1WmhMUmNRcjRleUJhR2w3Vzc2cHlxbFdC?=
 =?utf-8?B?UkdpckZnYUNYNnVITzZoTUtPTVNzS2d3NkJray85NjB5Y0RWelg4VFI0VmRN?=
 =?utf-8?B?REVrUlpSbEJiWUtwRi90NVhhUkdQL1lUUElIMXBEelUzMitEbkpUa0RoRmhJ?=
 =?utf-8?B?MjN5SkNjTUVjRHdoL1pJRkQrSUtsRWlQY3J6TzhjajJrWUhLNTFncEEvdUow?=
 =?utf-8?B?K2NzeHFYbWwyendwY1JWTVBIZlhJNnVaTFpoWWFWMjJsM0hEcnZoa2liWm5v?=
 =?utf-8?B?WDk1NXNWR1dhR0Nnb1lYa1ZsU1I2aU41TndPM1gxNFR1Z2FUMGRqMGpJQm4r?=
 =?utf-8?B?M2xjMS82S3JDa0o3Q2p3SnBFYjVmemRZUXhUTDlZalRNSVA0SDMvOWRXM0FQ?=
 =?utf-8?B?Umpuand3RjJWMWJkd3FjMWRQN284ZFF5Sk9pOW5EUmFmelVYNzVxQXk3Z2xS?=
 =?utf-8?B?d1Vucjk0amowMjJGeE11L21udVVibVlNb01vSzRKMjJ4Zmtvd214QzRrN2ov?=
 =?utf-8?B?MTlTUnJMcVZVSEs4aFk2em5UNWIrcnFVbDd4Vm11K3BTRjMwUnREQXBNQ2pF?=
 =?utf-8?B?Q0JpQ2xsYi93Vm4zUnBmRGhGKzNXaTJtb2tzbG9ycHRkL01LM1pSUC8zZTJs?=
 =?utf-8?B?WGhRUkh6R2ZLaXNGYWtxZGw4cnc1MTY2dUdhRUVJTEJJNENyQURNUW1OYzha?=
 =?utf-8?B?dm5qNjlPZlQxUytzc1Q2UnV0MWZDMXJtZUlvVmZkRjQ4cTJzQU9Gd3oycWRI?=
 =?utf-8?B?WFI3WjVoNWttNGs5Q2VwQzhVUXVMOGJWRTJkT1lTNGxCRDhsWHBtN05DM2p4?=
 =?utf-8?B?byszdnRmblZuRWhLUEt6S1IzL1ZyMmdWbHIwekRhNzFXc1U1WS96dDVlNEli?=
 =?utf-8?B?WjR1QkdQTlZ4bTdyaUxhc1gyaS9CZmhhYkpINmI2VUlsRkhiemI2ZEc2WEhY?=
 =?utf-8?B?WVl6akJJVllEOTdWWmMzdnBNRU82OVVXVmZHYXNkTEQwU1NRY3ExOGRlMVB6?=
 =?utf-8?B?b2x6TE56YUl6M3Rtd0ViN3RGcThCQU13bVk4L3hRR0RMaFFFa0RTaUFXOVpw?=
 =?utf-8?B?dTJpNVl6elJNcmNpekhUMGYrVVYyOS9ETEhHcEhlaXRGS29OcEtrSit0MTVT?=
 =?utf-8?B?cVdmRmt4S0k3UTIvOHIyWXF4YWdDdmgrMStrZmc2Z3JMUXlxaGdIbzhTK29n?=
 =?utf-8?B?dDk4TmZIVFBvVXNSeGdDNGEyZGloNlA5eXF3aXp1U0NueHdsKytvcGhWLzd2?=
 =?utf-8?B?Vkc2dkhmdDArRlpGdTI2VW5PWndRUHNWQlFrMUlnRVZHUldzaENVQU1QZkw3?=
 =?utf-8?B?M0p5NHZPWEVqczNIUTc2REVLdEhYdUJkTHpxQmJhSGVWYmk5ZDZqYkxHQkt2?=
 =?utf-8?B?SGt5VDcySmxtaTdGUEtDUUtVQnhnRmliYlFwK2ZidFJVTG8wK3h4aU1VVk9t?=
 =?utf-8?B?Q0tGVUpsa0NRYzMvUkl1UjdObGpmUTRkTW9QMFF0bjlSVU5WMmxFWlhQeVM1?=
 =?utf-8?B?NC83QTRlKzhVOTEyNEJzdExBenZrajlMamhMeC9QSGtzSXh5Wm91SVJjdlU5?=
 =?utf-8?B?VkFxZndTdGJQMHRLcGtBK1dRbWs3MUtBcThYallIK21Qazd4TmgxS0FQandy?=
 =?utf-8?B?SlN2OSs0TGVlMFpYL2hUYWlMVlU0ckc4ZkludEVEQ1BkcFprTDhxbnFTc0tL?=
 =?utf-8?B?Z3kvd1g5RHcvdlZtek9nMDlveFZhUWwzcHMvQy9TY3hicE0rTXBuRDJqSjVB?=
 =?utf-8?B?VDVzc0lqRHFpQTM0bFg4SkZQa2ZUWHNFbnYrWVI5S2JNaHZIU0tmaHo1ZVlL?=
 =?utf-8?B?dUpkUmJYbThBNnBmSXluUXdKR0VNWFV1MkwvVXQvVnQ3WFdBdjBiVG9JQlNu?=
 =?utf-8?B?R1VjK0k0SU4yMmVUUGlSbnRpeXNLMmFuWmg2cktIOGtLaUcxaGJXamxFSytT?=
 =?utf-8?B?bEZIZlQ4ZGJPWmFHUTk3NUxCMmw4Y3M1bVkrS0wvS2drUkY3NVk0dmR0a1BG?=
 =?utf-8?B?ZTRPS0VUMkg4UFUrSmxqYXl1TXFzNjJLbkZKdWllS1gwcVRWM1dmVkVDeURO?=
 =?utf-8?Q?1tQ8K4ydWVwUKSS0/B/9RdE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d728ee63-485a-40bf-5e03-08d9e66142c5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3053.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 15:32:45.9207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CDwOuxAdmjGupalL8/Z6k2dJzVacNcnjW0DjdyK1jTStHCZVxrv68QkSJZgdh/Lbb1PyRo6ygMgOoT2lAyde0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3471
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 02-Feb-22 8:06 PM, Peter Zijlstra wrote:
> On Wed, Feb 02, 2022 at 04:21:58PM +0530, Ravi Bangoria wrote:
>> +/* Overcounting of Retire Based Events Erratum */
>> +static struct event_constraint retire_event_constraints[] __read_mostly = {
>> +	EVENT_CONSTRAINT(0xC0, 0x4, AMD64_EVENTSEL_EVENT),
>> +	EVENT_CONSTRAINT(0xC1, 0x4, AMD64_EVENTSEL_EVENT),
>> +	EVENT_CONSTRAINT(0xC2, 0x4, AMD64_EVENTSEL_EVENT),
>> +	EVENT_CONSTRAINT(0xC3, 0x4, AMD64_EVENTSEL_EVENT),
>> +	EVENT_CONSTRAINT(0xC4, 0x4, AMD64_EVENTSEL_EVENT),
>> +	EVENT_CONSTRAINT(0xC5, 0x4, AMD64_EVENTSEL_EVENT),
>> +	EVENT_CONSTRAINT(0xC8, 0x4, AMD64_EVENTSEL_EVENT),
>> +	EVENT_CONSTRAINT(0xC9, 0x4, AMD64_EVENTSEL_EVENT),
>> +	EVENT_CONSTRAINT(0xCA, 0x4, AMD64_EVENTSEL_EVENT),
>> +	EVENT_CONSTRAINT(0xCC, 0x4, AMD64_EVENTSEL_EVENT),
>> +	EVENT_CONSTRAINT(0xD1, 0x4, AMD64_EVENTSEL_EVENT),
>> +	EVENT_CONSTRAINT(0x1000000C7, 0x4, AMD64_EVENTSEL_EVENT),
>> +	EVENT_CONSTRAINT(0x1000000D0, 0x4, AMD64_EVENTSEL_EVENT),
> 
> Can't this be encoded nicer? Something like:
> 
> 	EVENT_CONSTRAINT(0xC0, 0x4, AMD64_EVENTSEL_EVENT & ~0xF).
> 
> To match all of 0xCn ?

I don't think so as not all 0xCn events are constrained.

But I can probably use EVENT_CONSTRAINT_RANGE() for continuous event
codes:

	EVENT_CONSTRAINT_RANGE(0xC0, 0xC5, 0x4, AMD64_EVENTSEL_EVENT),
	EVENT_CONSTRAINT_RANGE(0xC8, 0xCA, 0x4, AMD64_EVENTSEL_EVENT),

Thanks,
Ravi

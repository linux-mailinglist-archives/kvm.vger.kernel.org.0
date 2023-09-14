Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9616E79FBA5
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 08:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbjINGJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 02:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjINGJ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 02:09:58 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2075.outbound.protection.outlook.com [40.107.241.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB55E3;
        Wed, 13 Sep 2023 23:09:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JP0GegTz4V6VSkM1M0qD7/p6xGap6aazw7EAB92YM6xWtcnC2bUtsBvBXElfSlHBt325F9KJDBz2H/iROxp8ZNC43ka0M8AdnW5TCk6Qs9UmnYkfsk+E12Gag4Dq7sgUFza4GV8NxLqdmcTZMFPDqTKfNZ5cNRTWNLkgBv6boNXEuH3JVWfYieo5AfP0i37WcDgYFk2JHtECZEW/3S2PyPSD0POXzVNe06b2tMZbQDvLOkZHhmAHdYXP6NoQOyylXwB7VZxLp90NLbquIf05u1BM74XvWG5kvXhx/mSxeyH6O0n4L05qsoR77AsZ5FKWwCMqfVBey3faPgZcpAElCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MEy4IUaf5cUi8IK0G4opsT0gBczRJ/R2VnGDqT/kfVo=;
 b=W7fuyHHTfvJg9BATNmCfI0hyAYWa72n0xPYMj06ZKJBJkeSIIdR3FugWVLMNHCAOBL/f7k9hnDoCLs395/XnKK7YIh3qLbT3JMfCOvesbGjOsfVBKVdPESk3/U38hRZbNyAIxyLbqzMGtyHRo7uiGKLVMuy6AO8dxZL7/UYh7/Ie54QkEE684nyyRYcbapkvjg671/lTgC4JIWhUBINPbEzazRmlrW3Gwb8yWs8gCV9B0kREm/pyHbsCtcWBqLn+NS/JeLu25/4c37yrlVpC4HbROKD/JS6DO0nhKIM+5FZ3mZM43UDREJ36I0ZM5ayKna9Rrsz6n13HZmY6PXxQ9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MEy4IUaf5cUi8IK0G4opsT0gBczRJ/R2VnGDqT/kfVo=;
 b=d5Y8QqABosnmDze9p4pXnlRmQ2p2+beecoVBrfGVmaRDs9fFRgPSghZt7pUta8VSCQ9mMGMwyB8WPSIK0uUY24SuxZ/HyYoFsv/3YImJaq0ebiGHu5l24TbLMK1ZULuHZVJLKMjkS/dodkBGxSFByNO+H4108Fq9VczD3jBdeoyHQ1nhU6bSeeVYUS1QZl/pWsgK8SIPszDAXl50CT1Y1PTyiDhLfP6XNrnRWLN8so90kvc8ZP/3jn6LdWEJlDC8L+INu0YVDbTBuSWYcFEhyxHWtY6fkWHBGiec03moDnxxhvF2oPTrGBtaoPWbIPbeun+TpiMXMsN0RRVn16JCuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DU2PR04MB8790.eurprd04.prod.outlook.com (2603:10a6:10:2e1::23)
 by PA4PR04MB7871.eurprd04.prod.outlook.com (2603:10a6:102:c2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19; Thu, 14 Sep
 2023 06:09:50 +0000
Received: from DU2PR04MB8790.eurprd04.prod.outlook.com
 ([fe80::f749:b27f:2187:6654]) by DU2PR04MB8790.eurprd04.prod.outlook.com
 ([fe80::f749:b27f:2187:6654%6]) with mapi id 15.20.6792.020; Thu, 14 Sep 2023
 06:09:50 +0000
Message-ID: <77ca8680-02e2-cdaa-a919-61058e2d5245@suse.com>
Date:   Thu, 14 Sep 2023 08:09:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v10 08/38] x86/cpufeatures: Add the cpu feature bit for
 FRED
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com, Xin Li <xin3.li@intel.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-9-xin3.li@intel.com>
 <d98a362d-d806-4458-9473-be5bea254db7@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <d98a362d-d806-4458-9473-be5bea254db7@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0261.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b5::15) To DU2PR04MB8790.eurprd04.prod.outlook.com
 (2603:10a6:10:2e1::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2PR04MB8790:EE_|PA4PR04MB7871:EE_
X-MS-Office365-Filtering-Correlation-Id: 806d7972-93e4-4ab2-4e95-08dbb4e93449
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KWaEJDUOoRD2yo+953anBmMLZ4WDoPaZ2xIfPS/XzrcXk/umUQti5z6zSPyXvMLCa91RWmtti2UEIS/lmQaT//owF77Z5jANJ1ERwcWgMrKYONESnkK+0oTudEIxcpf0We8Ambu4/hc6G1migmQNsppG+zQ1ifD8OIiYS7nsyK5gkA79dUv6EuYtt1RJuSKJlVVX86VCP2gGH6S5i7vIVikzpP/4PIuPoN18xhcW7GPJ2Yvvc4HSRMbsh3EnrTnidIxgQ6ah7dKaTrd1KunxWyrmNJLRHOIzr+mqOAstmd0CshS+VAiBrq6Dhe7QAHGOnTWrPa8aDKpqowp2ku6JK32/dyPDhrxxBQBBu6kQ22i8UVyUuKFdfl7jTRrFGqbHG+LUFOdyqEJfKdxOwFTrzC3mzFZjOMJ6H6wNRQ3v1rM5fktzxKocBUSFQTQiReDb5LfEEJ/g4S0ypO1mUaX7TsLHS2CraCpbbHik8SBp5aT77iGiprsr0KDqa/jDno5NhuktxJoKRcaBbKfpQJiTME7vBba8CD1aUDQLxtljLwkNGDBkdCMWI/w5iJmSxrZgoio55PEZwhtXqz+ZST6O7Qzp+EMe2+b8ViZGKXruMsJicHtS80/aaw4xmxUJZGd+pGV7I6KXk8N3gepMqWzqNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(376002)(346002)(451199024)(186009)(1800799009)(478600001)(31686004)(6666004)(6506007)(53546011)(6512007)(6486002)(38100700002)(31696002)(86362001)(26005)(2616005)(83380400001)(8676002)(6862004)(5660300002)(4326008)(8936002)(6636002)(66476007)(41300700001)(37006003)(316002)(2906002)(66556008)(7416002)(4744005)(36756003)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjBvTi9Ja2pMK1M2bUlCeC9qdk8vbkF4Qm4vK0UxelI3TXlmazhUTHQ1blY5?=
 =?utf-8?B?bjB2dmR5SklaN3RVaDRMcmpDeXB2My9SSzNYSEtxZFNvV29Cb1FRRWg0bjhY?=
 =?utf-8?B?dmU2WlZFTncyVTdmSkR6VUgzTjdaNEo1OVdMSFhhaVYzSTB2N3hqRUp0dmJq?=
 =?utf-8?B?dGVNN29oSms3ZSsycmtsMG5jbnZhS2MwVEVOZnB4YkhqeDM3L2pFNGRTSjhX?=
 =?utf-8?B?UElibDRtTGxVWkpyRkh5UUlRUU1JK0dMclNLVVRrWGhVQmxjSzlYUlNPWEEz?=
 =?utf-8?B?T1ZEd1c1RUpkWWZWamVQLzNMT1ZMQ3A5M2FDbjdaKzJXM1AvNGxLZXBiZWE1?=
 =?utf-8?B?dXE2cHF1SENsTFA5VmNiQnJxeE5hNmxrTlhtYks3SjJqYkpwS3NOUmdORURh?=
 =?utf-8?B?bWZBbVpXbEw1VXNSelRnV1JuUnFjei8xUDBDYURsU1JydE5jWXRoam5KSXdP?=
 =?utf-8?B?S0puTDlmNHhseTNCaWRuOUZqbGV5YUQ2ZzlWVmY1aUJGK1d5U1VCVnlaY0to?=
 =?utf-8?B?RWVrSnhNTC9FUHhvc3VQWWVUVXJLZlMvaXJOWTdFTzV2MTVXL1lGMGZkM0Nu?=
 =?utf-8?B?d3QzUUhQK1J2cjRheGpjRDFlWlY5NXVYSUxLdHZJOURMa1BNbUsvY0dTQ3py?=
 =?utf-8?B?UmJEMDJwQXdHaXdzZ0U3ZW8vVVV3NjR6am4ybDA1VUNsZzNDaE0zQm15V3Rl?=
 =?utf-8?B?dURYWHFQQTBDb0tTb3NsSzdpVVZjYXFXcHJiOE5wc1NKN3VqUnJDR2tvUXJY?=
 =?utf-8?B?SElPZGFQOVdSQmQrODVQRmZBV2V5WHJaSnNJUjRiWDB2cjVOelZibGdDMEIv?=
 =?utf-8?B?eXN0aWs0dGoxdHIwaGlrRVhtOVV4NE9ObmNWeU9PTHhPUGR6UHN1dmtUdjJD?=
 =?utf-8?B?V3NlQ2NrL0lZNGJEMkpmTVdwekZ0RmQzSFdHUVdqR09MUFZEVk02WlF4Q0xo?=
 =?utf-8?B?ZTFCMW1lbHVTdWtKODBiUTEycGt5UUFJVU9obkdGejd5S1MrQlNPcG5hbndv?=
 =?utf-8?B?RlZ2ZThtb3J3cWlDNzl0N1RBTHB3R3kxektlYUFvclZ0UmpIQnR5TEVqdHh2?=
 =?utf-8?B?VGNRaUxtSmxmZHVZM3VXcklYR2VTR3FpbU43RVg2NEZROEpaNFFQNWRXSUNp?=
 =?utf-8?B?b3JsQU5ST0dHZVVpeWdYYzJKZDhPV3c0Q3ZrdFFoQmQvWkZMNW1FWmFkMWQ0?=
 =?utf-8?B?ZGFpbzhtOHVPdWJHVUszMVNFTDIvbW1SblZaN3lRMENZdmJYM2xMRnY3TnRI?=
 =?utf-8?B?K1VKQUxtTGJzSWdNSWJybGYwbFFsdEhIQzkxOWw3cTE5VE1YQklkeDhjaE5v?=
 =?utf-8?B?dkV3bGh0QzRxZUhPaWUyQ2ZxZkliT2RsM3pIQVBnb09MNmlpcVZSSXl6UzhV?=
 =?utf-8?B?MnpUOG9QeVVsRWtQRFFvUTRWVEdvNXRIZmlJZkdTYWs2am5IVVhWYi92bk45?=
 =?utf-8?B?eXIyTFU3Q1hzTGtXa21TdkppVGtjSDQzcHpsd3dtMC93TE4xaDV4Z05FVUVl?=
 =?utf-8?B?QlBScWNwckxLQVQ3S0FmT3JiM1dwUEl1T1BjZ3lhMFRXai81b0hQTlZPOVZm?=
 =?utf-8?B?SmsydjZoMVVoRnF2clhuZ1A3clk0czZmNDIwOUdwVVBSZ215UWZJTmZIVDVn?=
 =?utf-8?B?K1I1N2wyeFgrWERSc21temU0MW5QS2ptTzJXZGVoV0dPdVRDNkdZNEVzbG80?=
 =?utf-8?B?U3RZYWwyeElvdVQ2T2ZKcXM0dyt3VFUwRHdHSHZrOWswbzV4Y0kyRWhFRjk4?=
 =?utf-8?B?S0JnTS9pUmZZSkM4NjJRSzU5VktLMThCajk5VXZZTGNwK1JlSDhxeVI0TUo5?=
 =?utf-8?B?RnhHRlR0c0hBYmw0OUdldFlXN29Lc0xaWGxjZFFrWnBrRkdneHA5OWUreGdk?=
 =?utf-8?B?UHlKSE0vYTVycWZnS0hJWVc4a1EwUGkvU3BueU9BUWc0bWFmaDRDVjF5V0Mx?=
 =?utf-8?B?WStCN1JTellrb3EyY3c1Q2kzVVIwS2F4SmJmU0gzcVFYeEVjZDlzc1k0ZkhU?=
 =?utf-8?B?R3l2aDIrbFVSQ3pDUnFrUHI0U1dOemlYVnU2dW9qQnhvUjN0TytxaGZ0ZlF6?=
 =?utf-8?B?MmpxRTJrVlFQOWFVNm9mekZqazNzc2pFZ1VMTnVLTDJLeHF2WVg4dmx1T24v?=
 =?utf-8?Q?53FhIdYCMZcIQOduW3exKBz4O?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 806d7972-93e4-4ab2-4e95-08dbb4e93449
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 06:09:50.1963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BCLw+CAFW1aJcU55mlZhikd/VPGevQAhTJlQ27gFTAGyd6fa7md5ugy3nz5mrsfoT7ss/+annV760dKj50+lWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7871
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.09.2023 08:03, Juergen Gross wrote:
> On 14.09.23 06:47, Xin Li wrote:
>> From: "H. Peter Anvin (Intel)" <hpa@zytor.com>
>>
>> Any FRED CPU will always have the following features as its baseline:
>>    1) LKGS, load attributes of the GS segment but the base address into
>>       the IA32_KERNEL_GS_BASE MSR instead of the GS segment’s descriptor
>>       cache.
>>    2) WRMSRNS, non-serializing WRMSR for faster MSR writes.
>>
>> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
>> Tested-by: Shan Kang <shan.kang@intel.com>
>> Signed-off-by: Xin Li <xin3.li@intel.com>
> 
> In order to avoid having to add paravirt support for FRED I think
> xen_init_capabilities() should gain:
> 
> +    setup_clear_cpu_cap(X86_FEATURE_FRED);

I don't view it as very likely that Xen would expose FRED to PV guests
(Andrew?), at which point such a precaution may not be necessary.

Jan

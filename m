Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2616991DC
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 11:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjBPKkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 05:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjBPKkj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 05:40:39 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20606.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::606])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2EA55E4F;
        Thu, 16 Feb 2023 02:40:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SlZlzhT7CAazYoAuiTqNMnGRCKZo3M6dM0VhZBD9wDtfs8/zr/X2s1gCLLDL6mA4i0pNQ+SbMGH0X7NAd/pQINCXvlh08C5BX1QT8l9GgvmDfBOJh8m5pQ7WhI24XuXSd+72cfsoUfgJ6BAlkcXSZHCLzkkA/qGj/2UMAJi++8Eus25p8WyOyCQlO5NweaZ2315ijFoZ57tSAjxWCAV1pYbKJePusIZfpJJI/6GtlMggeZ/ebb//PJfLiP4ELlD1bRh4O8/6c1kkJesnuj5fRHM+NjhMX8UrqcdpPGHo/bDOvvLWaT1YnjqE7XSIjnbBoXgNXuMG+9BhUvUARUdVbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2b4nB+fZmSHtcbYBDmdR2c4NcJ0tfgB8VizjDY7Jx4k=;
 b=amIj6NENyaQBovy6Q+KGQhfgxZtuTDp9o1HfTCt/DY47oHnVY94YHkuB4UUUl9sMhW+WtIwYI0u9Q6RmxMJEwfQBSxXRoMIfgLPEmiEaDb76cQERKq6Sp8hoS6klvTfdHabg8VaQNuSPrVnZZ921Sc81VxwvyCHWRdHyFDpOq1O3M0dRiqyUDiQ5bJbIZznbJhM/NfXiIPcHMYhXqr8hfSjjTo6ESXbXkJVNyMeT1qgzUvzSC6oB4c2ANi3VFIu5pLked2BnW/epzCplsGpvWOj7ZjfS5naHR2hFLr8hSjWhufs2A79uL6y8h0nqYM7yU8K0trjSCYVT5Z14LHz6vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2b4nB+fZmSHtcbYBDmdR2c4NcJ0tfgB8VizjDY7Jx4k=;
 b=brcQKFLKxO/n3hYeFJWovH9w0AyDW2LFaC6grhJSfCucXFj7zGGEippM2k/M2n6ZZrLjCtShA4bBd6a2MMX6o8w+76dV4ZDy3FyDNJFgcV5Evs193Z1o/xc/2YMgPsjmKeBPS/b+FgyrIDF0l12eL3c8iV+FyYAwHNGC1QjdGtU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 MN0PR12MB6319.namprd12.prod.outlook.com (2603:10b6:208:3c0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 10:39:48 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::7000:c45:e56a:9cae]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::7000:c45:e56a:9cae%3]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 10:39:48 +0000
Message-ID: <4463b0ae-edcd-eb91-9ef3-a3596a98616f@amd.com>
Date:   Thu, 16 Feb 2023 16:09:29 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH kernel 1/2] perf/x86/amd: Add
 amd_prevent_hostibs_window() to set per-cpu ibs_flags
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, mingo@redhat.com, acme@kernel.org,
        jolsa@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, jpoimboe@kernel.org,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        sandipan.das@amd.com, jmattson@google.com, thomas.lendacky@amd.com,
        nikunj@amd.com, ravi.bangoria@amd.com, eranian@google.com,
        irogers@google.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org
References: <20230206060545.628502-1-manali.shukla@amd.com>
 <20230206060545.628502-2-manali.shukla@amd.com>
 <Y+o23lcYHbYWua62@hirez.programming.kicks-ass.net>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <Y+o23lcYHbYWua62@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0175.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::20) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|MN0PR12MB6319:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b05ba8f-8091-4389-973f-08db100a1ffd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zrZ8YM0fLSWRBvzLHOWVs5WN1gZipvnOifV294k9hbpbqsDzplVBSj/6gfDIz+NAm5CaF4RzybQ9IQLalESagGE2PW1t/aUKLiDpXw3ThZMt2oAknp6UEypuMhDV25IpH/2NYI/SBqZJCvVkneQ4/tgh7Z/IAQev77MuiLidBC3KTDGmxKGos81n+f33es03fRl38ANCE6Um3fUYRK+7QcWHtOGpLTk+lZ0xZPROzYTnn93bVmmTSliZi7FTAZECcFdz8l+FPkfUBGdI47i8x5VnJ9l6NUGasSlV4cXN8u8KUdLAFeecpwP2+POuIuQ44kcfWPYpFWQP9Irhir20iEgj9ffT0dgj2DoZwFPDmwvBEEFMZH4UckADVyyelKVZZsbduOVw+8MDT+n6zIP3KcJMQfUVJEn3oMlF28u/qDRnL+Dsxu+mAlaJjD27o6E4xGY/f+cMbc3StlcSYvqdFyvaeaiSApVEnIMCW9+QJXzwuWvuznTRbLwYRI/M8ITLRgaQ4JPcFX5FPGxO34SE2hX+9x+EfSdSWnW+LeZJSfjIM7Z38Li7fjBHpaWoGVIO9MJS84z65ydDRUMGzlCvpVwYf9iiDY5qArXMfe2iMv6ShDpcDrEGE1ZhC5B8gXUAAOvwC0SzhO5Tg9qR40eEbpEX3RLb9nDaM6Bk1zjpLFD8HZHhZwPFrSI52A2sdini3gJtgrSFoGaVSnZRwB8oLC8vjPb8lmkAmP78EIbLEjA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(451199018)(83380400001)(316002)(5660300002)(2906002)(38100700002)(7416002)(36756003)(31696002)(66946007)(6916009)(8676002)(4326008)(66556008)(66476007)(6666004)(2616005)(478600001)(6512007)(6506007)(6486002)(53546011)(186003)(8936002)(31686004)(41300700001)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFpmUnZLbm12SGlPSDVLVVhFcnRtSHd2eFhySWZiZnFWTW11Q0RLRTY4ZmNz?=
 =?utf-8?B?WDZrTGE3RXlTRkhRNFhXMnVMWjBsNk5pVVhxSXI2VGxpWkZ1dnkrbmVGY1c2?=
 =?utf-8?B?OTJNaDJQVWV1R005Mlhoc0JSdmRVODBZL1h1Q1NVbmx4Q0h0N2VJYzNhcVdh?=
 =?utf-8?B?ZzJIbzJ4Q0FOSWxkLzhWUjFiMnoydjFHRHNXS1RmZXBDVXByclFvalA2d20z?=
 =?utf-8?B?bDhjUkNzSHhGQ1Mzd3NXTE5CcUFKWkRVSlhyaGpqT2FxdDdoa1BZci90Q0NL?=
 =?utf-8?B?dDljaHdhQjVPWG9iaWE0NlF0eUlmVXZLdEtIOHBZeFVKOGlwd2pkQ2VyWmM2?=
 =?utf-8?B?cUJOWVZlb3pHNzRORHV4SWErbDJTemVVajAzZElBN3ViNWRmNUk5TjM4cmFZ?=
 =?utf-8?B?YVRPNEZtcEhvWnRibXV0WGJoVWJabzFrZGhLNW1zWitPcitpMk9OaUU3Wlk3?=
 =?utf-8?B?ajVBc1NJNGRoWHh3N3BWTUZHNTZVNWdRMnVKdTV4TGdBQ0V3TndyVTM3UUsz?=
 =?utf-8?B?TklHMlFYbGMyYjNvT2s1elVTaXVnRXp3S3BDT1REWFpJREZGaU5xMGR6TVpI?=
 =?utf-8?B?Y3hWNjBDaFhuNDF6L0NQK1RhRkRHRndhWlVZZkdIMW41dWFqcXRoa1JPejNi?=
 =?utf-8?B?T1RnS2RCbWRTdFFZbHVpZmIyVGZ2MDNlejZOKzIvMmtvN0t2dXoyQTRFZVU0?=
 =?utf-8?B?MVA0RHlkNzdsYzZEM0ErTzd6UEhXajNwbVpvem84akc0SUd5b1FLeWxaL1N0?=
 =?utf-8?B?WENUV1N2dGJuYUNFQVh0SmdseVZaZFlrVEFNUE1NUThOQ0IraGRJNVFLK2pD?=
 =?utf-8?B?V09VbWowc2ZVUmcyNW4vZEk5RFpoNHB3S0pnRGp4a21sTGVGVGVyVUY5NEpM?=
 =?utf-8?B?NVd6MERUeWxpNDYxR2dkTzJzcmZCL1dPWXBBVjdCTjlaQXNsR0xobGRsU1Vk?=
 =?utf-8?B?d3VNSDJOZk9OeURrcVQ4NE01SS9oaTY2NzNCOVhrRzNBM3BHcnBkSEFyaUcx?=
 =?utf-8?B?dFNrSVdreHV1ZEl6djFMYWV5T3I5WFJWc1pkRy93UDZlM3hVQjRWUnNhMTdZ?=
 =?utf-8?B?ckxhaFNwYW1kY3lmbE5zTEoxaDJ4dkE0Q3MyWWtEUGU1Y3RCUEZtazNOWGla?=
 =?utf-8?B?eC9ySFdMM3ZyMlZJeE9QaFR2QjFiVDJBTVczVDNYb2JleWozY3k4VkJRNGxM?=
 =?utf-8?B?cjBrUVNBZW42ZnpQN2I1TzJwMC8zcWYrTlFEQWNEbDdkK1hYOEZtNHM0cXZ2?=
 =?utf-8?B?WUlmN0Jid1F0MXJiVGpXUmp1aklaNURFbTVIeDNpemJvZndkOGhNNzZlRXBF?=
 =?utf-8?B?dXN2d3IxWXFaUmNwUVFWbHpmZlozb1IzM044Z2xlL2RiWHRpZGsyTmdjVFo3?=
 =?utf-8?B?V0JwN2RFdHJodkU3WEExWFNOZHQ1ZzJjVC9CK2dMVXNsMEladXFpZ2ZLU0My?=
 =?utf-8?B?YWdqbDdROEJ1WFVFc3A0VFZUeEN2YTBJQ29vWjRnNjR1MURhQXZjZFF1bkhT?=
 =?utf-8?B?VFFGbEdxZWM3Nys2UnE0STNPVjEzWWxMQmE2U3FNcG91cDA2MlBSWVVWMlUw?=
 =?utf-8?B?OFNUWkZ3aHpLcG9LYlBkbGo2TCtiM1kxbUFxR2R4VldzbE10NlFLaVdUZkV1?=
 =?utf-8?B?S1BZbURFTXZXTDhjenRGL1F0Q1d6NlcxWmlUYzdJNzhUOTg1b2RDbGZkTEtv?=
 =?utf-8?B?YTcvdlp3RHFhcUxkSGZaNjQzb2QxS2FvNFZ5RnBKeWhFaHQyenRYbzF0dThK?=
 =?utf-8?B?ZGJkemtNbUNNRkNXTzV2MERKY2NEQXlXODJQMWtObUt1QW56ZmdZYkJ4WXhO?=
 =?utf-8?B?ckxvZkJ3K09iK3ZpclZtbEZiYTNWOEFpQXBXaUIvTU9Ld1ZOT1FGMWFSNm04?=
 =?utf-8?B?M29Ya0t5VlhHSVVFbXRVMG1yVHZ1blQ4VzFCSFpFL3Z2bUNHREtuQktEcnJ3?=
 =?utf-8?B?NENPWTRuVkxralZaeVNYcy9mNVBUOXcwbUo1MXVIY09QQjFIaGdPWkMzMWZn?=
 =?utf-8?B?eGJaOWx5UGRpYU05YWxLU3MvUnZSU3AwckMzeGVmQXpDUUJ1STMvZjVISDY2?=
 =?utf-8?B?V0xaa21ITVh6aFRKV0VkYmMwVDhwZktubHNJRjZOUkcyeVR3bzdFRTVMM1FO?=
 =?utf-8?Q?IqYYI5FcMmedj4/o7sLsaC6Nu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b05ba8f-8091-4389-973f-08db100a1ffd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 10:39:47.9393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C+4BJE0IYh/TZfy+onopN4BKp2XRdSdmD0uRKtRvZWjNkXJeab6tDIWEiWu3VV0ERgBb/51nfNiwdFhMt6Kl2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6319
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/13/2023 6:40 PM, Peter Zijlstra wrote:
> On Mon, Feb 06, 2023 at 06:05:44AM +0000, Manali Shukla wrote:
>> Add a function to set per-cpu ibs_flags based on an active or inactive
>> PreventHostIBS window.
>>
>> MSR_AMD64_IBSFETCHCTL[IbsFetchEn] and MSR_AMD64_IBSOPCTL[IbsOpEn] bits
>> need to be cleared for PreventHostIBS feature to be enabled before VMRUN
>> is executed.
>>
>> ENABLE bit and VALID bit for MSR_AMD64_IBSFETCHCTL are contained in the
>> same MSR and same is the case with MSR_AMD64_IBSOPCTL.
>>
>> Consider the following scenario:
>> - The IBS MSR which has ENABLE bit set and VALID bit clear is read.
>> - During the process of clearing the ENABLE bit and writing the IBS MSR
>>   to disable IBS, an IBS event can occur that sets the VALID bit.
>> - The write operation on IBS MSR can clear the newly set VALID bit.
>> - Since this situation is occurring in the CLGI/STGI window
>>   (PreventHostIBS window), the actual NMI is not taken.
>> - Once VMRUN is issued, it will exit with VMEXIT_NMI. As soon as STGI is
>>   executed, the pending NMI will trigger.
>> - The IBS NMI handler checks for the VALID bit to determine if the NMI
>>   is generated because of IBS.
>> - Since VALID bit is now clear, it doesn't recognize that an IBS event
>>   is occurred. Due to this reason, the dazed and confused unknown NMI
>>   messages are generated.
>>
>> amd_prevent_hostibs_window() is added to avoid these messages when
>> PreventHostIBS window is active and PreventHostIBS feature is enabled
>> for the guest.
>>
>> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> 
> URGH... so am I reading this right that this is a sodding terrible
> software implementation of perf_event_attr::exclude_guest ?

Not exactly. 
Unlike exclude_guest where profiler decides whether it wants to trace
guest data or not, PreventHostIBS gives control to the Guest. Secured 
guests(SEV-ES/SEV-SNP) can disallow the use of IBS by the hypervisor,
in order to limit the information which can be gathered by host from
its execution.

-Manali

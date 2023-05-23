Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8362E70DB85
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 13:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236636AbjEWLeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 07:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236516AbjEWLeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 07:34:03 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2048.outbound.protection.outlook.com [40.107.100.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28108186;
        Tue, 23 May 2023 04:33:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maPCO1Vx9yWlEX31Cxi3fz52p7k75xG6YmdZfoMcrOBy5YVRvm9qO+R8qxgNGv4GBMOmwx31JtSMDMAlBbiHFfs5YOojCB5kgU4mqDEWQjDrEeQuSyk6vQt5YfuqDEyR3q70qVu2vBfpHBrjsxYtLMUmz6/840Nq67m81mNRULHQFsdT8zYau+rl3JC+dVuTAE5I24swt29uXlNqBa1jjvEe0fjUOXC8fO8DVvC1COx7lhTzTbQvYkuDI6jBCgRNc7Lx5mOhnZt/PnWLqW477p883UA8+g9+IoR076npggcIyotG8XMdL/MaCvSPMXjCprl4QjLyBWcGRDns92pZxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WeuGuuv73wGMVUtJ8Con1S3LjdY6zKE6mJ1b1jxii6Y=;
 b=JbrE+81VUmBltiLUhMXg32uAoLoXGpFoQcAv84Nh7wqrbJ9TEFgx31af1ZaeZaAYeIv1Nyk0sfiwB/vi1yfbjTB4bVyITu6AzKD3zQ+XhpxCouN9EQaXy7rANrvoOB9XB4zRZpcrruqq2qv27qLK+byeXPbRTT1FzXo/hkPiuL8gk1VG14el7GWjIVU0oFQmDvCVKQKmh/KuZWqbPfSAS5DIH9EY6B8XaJGa6QNJtx5DaomKMP7/jjuFFmnOVhbKdvmVB4Uvjf8OEAhDnh3eQzljXfLs3Orxp5gpNiEvmpn30A59T3mcwr+3/3Dz3JqFF4Bxf6dGtSMIKZgNWj7AsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WeuGuuv73wGMVUtJ8Con1S3LjdY6zKE6mJ1b1jxii6Y=;
 b=Y/oGjXaVvyPqHYRJGYFU/PF4M251/20wTmqjvQNCvdVMph5mINISl9Zpbz2w9XMnb4FMtOCFViylULe6IF7xX+8K2yJojThE3Uxy+VdYlbMdzhEsDodR/pHm0ZjKHcyucUeNn6FQZYMQEuPw8YbzUPzpjHdaswT+lz7DVPw3o90=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 CH3PR12MB8331.namprd12.prod.outlook.com (2603:10b6:610:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 11:33:55 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::d2ef:d75e:d9b2:835f]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::d2ef:d75e:d9b2:835f%7]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 11:33:55 +0000
Message-ID: <719a6b42-fd91-8eb4-f773-9ed98d2fdb07@amd.com>
Date:   Tue, 23 May 2023 21:33:45 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH kernel v5 5/6] KVM: SEV: Enable data breakpoints in SEV-ES
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
References: <20230411125718.2297768-1-aik@amd.com>
 <20230411125718.2297768-6-aik@amd.com> <ZGv9Td4p1vtXC0Hy@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZGv9Td4p1vtXC0Hy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SYBPR01CA0111.ausprd01.prod.outlook.com
 (2603:10c6:10:1::27) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|CH3PR12MB8331:EE_
X-MS-Office365-Filtering-Correlation-Id: e50bd907-d629-4188-c378-08db5b81972a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ejWIDI1Em2luIeIEmeNm1dTxkr2tjvkK104Xa6VujlJmizDDlm4SFuAuwgVKGwAwUzg951uknykeiNla2WRN+iN7U59yNZ8+GTe2WKzT9oMt+7OZPupqStMh8K58V7Qpl2IIhnbvGG27VWmiHqmE2fWi8wQaFUPDTuKgI5QMVnPPiZ7oAWUustwrYk28Fzw2096OSEEdxTQIpzaGYSeSOyg5GQu2LySl5PXI9JUGsM/Qh/Tz6xRFaHZk10lTcW0elLYyxXPvMQ+awp7mEiU8DxpxQyTGfTaYVFs9am0sE8uogw5o1/TE3aRtrKiuDbA3hb5lIUhsTs+EFP8+edHVI+wak26UGw7tuXu9nm3IK6onr12CqBo8mFtY3zKzmIfEd3+GWEfAiMJWaZ4bsEg9ZthwaQ0mDcxzFszzacSWTJnIWV6YgZaMT/ol8Limcm2BwbVHLw3p+mFozJBl1kjEg2+LgRBXaPlNK9iprRcU3LfEqKu9ItJIp3q9WOEIA851nEeuVTwLLWEA/4ZZ7araaBwW5Zwq80DS1ttZFF9XSZ2IlQTUzwQiEi70haKVgcOu6hS6xTwFZqOwaRnvczHF2rI4ND6rkDO2V+UiHcb/WOwnUcc0C6Wg3Sx5GJY8u/BEYmxRWJsCpwnlMVQnLh/D0Dn9yBOvZHdoVqsOZt8Bp0AKh/Ns0KKVt+kKu38717dt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199021)(31696002)(54906003)(38100700002)(41300700001)(6486002)(66476007)(316002)(6916009)(4326008)(66556008)(6666004)(66946007)(66899021)(966005)(5660300002)(8676002)(8936002)(478600001)(31686004)(83380400001)(6506007)(26005)(6512007)(2906002)(53546011)(186003)(36756003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHdObkI1OGJ6cTd3dzJ0ei8wVTBzOGxqbWdPY1hUK3ZaZEFnNEN5L09kL2Zn?=
 =?utf-8?B?VTVMYVVYeU9NcGVPVUg3ZzF5ak1lZVVFOGtlR0paWlNKYm1yMGxzRGNYcUNJ?=
 =?utf-8?B?ZDZWZXFVdk9qeGRCbisrSWV5K1lFWDB0L0hJMityVWdDYi9TOXZra1U1aEdh?=
 =?utf-8?B?eFg2NXBxYm1qcnYzL3plVWJOWU12UEhCeWNQOFYxSThTVGtnK0FVVlprd2xn?=
 =?utf-8?B?emlBSld5dUsrZG5JQ3Rob1hVTTFQNFB3YnRkWlFXdk9LeFNxalA3cCtPcnh3?=
 =?utf-8?B?dFhoSHVmRHZrNXlJNGlqelpUWUdzM2h5aXIxL3FFMlZCU3ovbFFySENLNTdw?=
 =?utf-8?B?NTN1aVA1enYvVDgzTzdYM3dTQmRGU1FNSUZuWmNNUk9SSHpab1FPTVlzVkph?=
 =?utf-8?B?cGNQUGVnaVJSVERwdnBBTlFxUHI5d2NCM2lZdnBKYk5OYnJHRTV3Q0dibjZu?=
 =?utf-8?B?akJOVkhRbFRuQjlVbmtLVTdud0YxK2d0ZFZTRmZZczhtNzd2QUNrblJnbFZD?=
 =?utf-8?B?bEJNQ24yeTF6bGYzVHMyOGp4V0tRV2lQMURGUWhPQ1FIK0FQUW13dEl4bGN0?=
 =?utf-8?B?bjlVRzVISGVBbG82WWZ0UjUzMkJ3V3V0ZjU1WUcrN0ZoeTQ1UE9FWkVuOXda?=
 =?utf-8?B?aUd3UExGeFBtbW5SMzhkTVdoMkFEelVOSGRnK2c4UmlVcndQcHRPbHh6T1Vu?=
 =?utf-8?B?NTlCMzNJSlVBTzdGNjBCSmdjYXloR2lVazEzL04zamttelh2bnhydGE4ZzZy?=
 =?utf-8?B?QkxGUDRmVW1IMXZKSDlLK21QaElBNXArZjZNZmhkejRtd0ZzQUpjbC9PY2ZK?=
 =?utf-8?B?Y2NJOFZBYk5hSzNscWxsU0VKN3BvUGxmcUpjR0FXY3FMTFB3K1N1eHN4STA0?=
 =?utf-8?B?QTU2UHpzc1NoMnhPTmZwdWdVVG5hRm9ZZjhGbldMdDlZSmo0TW5qOHFoV3NK?=
 =?utf-8?B?NUlJSGVqQ2pyV21QWkhRaVpVWmJXRjNlMWpiTkNSbk1zell1czJVYVRnM1FQ?=
 =?utf-8?B?VkRtOW9BNy9MWTBVYlM3aDVQSFc5S0xRenRyeDRTd1VDa2xpN3F2SkY0RE83?=
 =?utf-8?B?ZDdSY0hQamkxSDFibkZFZHFwUlRYb2ZEd2liVkU5cU5tb0Zjd0VFbmJjV0Q1?=
 =?utf-8?B?em04Q0V4Z1haNTFiUFlQQXlIaG5jNjRubis4QWdzK3Y2SVFGaUdwWmZZQmFy?=
 =?utf-8?B?aXlSMEdCeFdXaDR2Q0xJY1RJMTdjY0s0N3NPZHlYWDF0Zm1TWkJhd1FXMmFY?=
 =?utf-8?B?L2Z2VzNEV05JR1ZETjZwcWlwTlVNbm5WWVJKQlRTWnJJZU8zMEp3V0RtVlRs?=
 =?utf-8?B?dDIwSElTT0pQQzEzZDJ2UnVBUDNHVFhvSmNWa3ZlSjYzL2xmVUNmVE4yTmxM?=
 =?utf-8?B?L1VBTHIrSW9WeUFTNGxlOXlmQ3NJaDhvRjVsWEg1QVpuWnR3NjZldmJVdjdE?=
 =?utf-8?B?NDNsN1MzRFA4dkErU01rd2kyV2lyd1oxbjVKUHk0M2FKT0wzaEd3SHFwWG1W?=
 =?utf-8?B?RUJNTjJjZFFFeFhRcDVYMGkwbVk0RmJWd3NVaXppelM4QlZxQytrQlFPSFBI?=
 =?utf-8?B?KzA1VWlhUndObHF2aUIwK21jZld4NGZpVXhNaGZmaWdzblU5MFVmVXVid1Jt?=
 =?utf-8?B?TS8vdVhSZFozL0FNSWxLVmJmS2FMUHd5bDlCclNZakxKWk1xY3d5UFN1NkZJ?=
 =?utf-8?B?VC9Sc1AwSEZzQjA4bG9OTTdHMHM1bFJFUkZSK2xnM1NUNTVPVllCdTRhSkhM?=
 =?utf-8?B?azhXWCsrWkRtSWZLdk92b0F6S05rMU4yUXpmd0I4ZGp6S2JMaGVJc3F4TzJZ?=
 =?utf-8?B?bS9pNmNHQy9vTUNPS3lSSHZlOFhTOGlSU3Q1WkJLaWZtNFo1ODhISXZaTGdH?=
 =?utf-8?B?ZGRwdHpTMk1jTW1MWk50WTBSb1YxaWRwT2dYZHFzclVocCt0SFlvWFhkOFAz?=
 =?utf-8?B?dm1BUEd5QXVPSzlncEdZQXlqbWovK2tWOWpZbjdVTjNzM3lGWDBUSHB5RTl4?=
 =?utf-8?B?czdXUmJyQUFRc1dNRXExdG9OTnVybWlYUlNDZVN6Yk1YQ1VYYjVxYUJFODJC?=
 =?utf-8?B?MzFMOWJqb2k2QUdCOTZBODhYL0lpb0hBYVoxeGFhR1QxdDlUcExhQ1J1WWl5?=
 =?utf-8?Q?MabJO6yRPmg5DWjkspIq6d0Lo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e50bd907-d629-4188-c378-08db5b81972a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 11:33:55.1598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LLfR8B2wGYadsUhMe8OxdBHg1llfkFsmQ88Yd9asRtyGL/fE1zy9PlPOyTNbCWaw+Z9L4VcaRstiRp1rGIW77Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8331
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23/5/23 09:39, Sean Christopherson wrote:
> On Tue, Apr 11, 2023, Alexey Kardashevskiy wrote:
>> Prior to SEV-ES, KVM saved/restored host debug registers upon switching
>> to/from a VM. Changing those registers inside a running SEV VM
>> triggered #VMEXIT to KVM.
> 
> Please, please don't make it sound like some behavior is *the* one and only behavior.
> *KVM* *chooses* to intercept debug register accesses.  Though I would omit this
> paragraph (and largely the next) entirely, IMO it's safe to assume the reader has
> a basic understanding of how KVM deals with DRs and #DBs.

Out of curiosity - is ARM similar in this regard, interceptions and stuff?

>> SEV-ES added encrypted state (ES) which uses an encrypted page
>> for the VM state (VMSA). The hardware saves/restores certain registers
>> on VMRUN/VMEXIT according to a swap type (A, B, C), see
>> "Table B-3. Swap Types" in the AMD Architecture Programmer’s Manual
>> volume 2.
>>
>> The DR6 and DR7 registers have always been swapped as Type A for SEV-ES
> 
> Please rewrite this to just state what the behavior is instead of "Type A" vs.
> "Type B".  Outside of AMD, the "type a/b/c" stuff isn't anywhere near ubiquitous
> enough to justify obfuscating super simple concepts.
> 
> Actually, this feature really has nothing to do with Type A vs. Type B, since
> that's purely about host state. 

Mmm. Nothing? If the feature is enabled and DR[0-3] are not saved in 
HOSTSA, then the host looses debug state because of the working feature.

> I assume the switch from Type A to Type B is a
> side effect, or an opportunistic optimization?

There is no switch. DR[67] were and are one type, and the other DRs were 
not swapped and now are, but with a different Swap Type.

And the patch saves DR[0-3] in HOSTSA but not DR[67] and this deserves 
some explaining why is that.

> Regardless, something like this is a lot easier for a human to read.  It's easy
> enough to find DebugSwap in the APM (literally took me longer to find my copy of
> the PDF).

It is also easy to find "Swap Types" in the APM...

>    Add support for "DebugSwap for SEV-ES guests", which provides support
>    for swapping DR[0-3] and DR[0-3]_ADDR_MASK on VMRUN and VMEXIT, i.e.
>    allows KVM to expose debug capabilities to SEV-ES guests.  Without
>    DebugSwap support, the CPU doesn't save/load _guest_ debug registers,

But it does save/load DR6 and DR7.

>    and KVM cannot manually context switch guest DRs due the VMSA being
>    encrypted.
> 
>    Enable DebugSwap if and only if the CPU also supports NoNestedDataBp,
>    which causes the CPU to ignore nested #DBs, i.e. #DBs that occur when
>    vectoring a #DB. 

(english question) What does "vectoring" mean here precisely? Handling? 
Processing?

> Without NoNestedDataBp, a malicious guest can DoS
>    the host by putting the CPU into an infinite loop of vectoring #DBs
>    (see https://bugzilla.redhat.com/show_bug.cgi?id=1278496)

Good one, thanks for the link.

> 
>    Set the features bit in sev_es_sync_vmsa() which is the last point
>    when VMSA is not encrypted yet as sev_(es_)init_vmcb() (where the most
>    init happens) is called not only when VCPU is initialized but also on
>    intrahost migration when VMSA is encrypted.
> 
>> guests, but a new feature is available, identified via
>> CPUID Fn8000001F_EAX[14] "DebugSwap for SEV-ES guests", that provides
>> support for swapping additional debug registers. DR[0-3] and
>> DR[0-3]_ADDR_MASK are swapped as Type B when SEV_FEATURES[5] (DebugSwap)
>> is set.
>>
>> Enable DebugSwap for a VMSA but only do so if CPUID Fn80000021_EAX[0]
>> ("NoNestedDataBp", "Processor ignores nested data breakpoints") is
>> supported by the SOC as otherwise a malicious SEV-ES guest can set up
>> data breakpoints on the #DB IDT entry/stack and cause an infinite loop.
>> Set the features bit in sev_es_sync_vmsa() which is the last point
>> when VMSA is not encrypted yet as sev_(es_)init_vmcb() (where the most
>> init happens) is called not only when VCPU is initialized but also on
>> intrahost migration when VMSA is encrypted.
>>
>> Eliminate DR7 and #DB intercepts as:
>> - they are not needed when DebugSwap is supported;
> 
> "not needed" isn't sufficient justification.  KVM doesn't strictly need to do a
> lot of things, but does them anyways for a variety of reasons.  E.g. #DB intercept
> is also not needed when NoNestedDataBp is supported and vcpu->guest_debug==0, i.e.
> this should clarify why KVM doesn't simply disable #DB intercepts for _all_ VMs
> when NoNestedDataBp is support.  Presumably the answer is "because it's simpler
> than toggling #DB interception for guest_debug.

TBH I did not have a good answer but from the above I'd say we want to 
disable #DB intercepts in a separate patch, just as you say below.

> Actually, can't disabling #DB interception for DebugSwap SEV-ES guests be a
> separate patch?  KVM can still inject #DBs for SEV-ES guests, no?

Sorry for my ignorance but what is the point of injecting #DB if there 
is no way of changing the guest's DR7?


> As for DR7, the real justification is that, as above, KVM can't modify guest DR7,
> and intercepting DR7 would completely defeat the purpose of enabling DebugSwap.
> 
>> - #VC for these intercepts is most likely not supported anyway and
>> kills the VM.
> 
> I don't see how this is relevant or helpful.  What the guest may or may not do in
> response to a #VC on a DR7 write has no bearing on KVM's behavior.

Readers of the patch may wonder of the chances of breaks guests. 
Definitely helps me to realize there is likely to be some sort of 
panic() in the guest if such intercept happens.


>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
> 
> ...
> 
>> @@ -3048,6 +3066,18 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>>   
>>   	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
>>   	hostsa->xss = host_xss;
>> +
>> +	/* The DebugSwap SEV feature does Type B swaps of DR[0-3] */
> 
> Since dangling a carrot didn't work[*], I'm going to resort to extortion :-)
> Can you fold the below somewhere before this patch, and then tweak this comment
> to say something like:
> 
> 	/*
> 	 * If DebugSwap is enabled, debug registers are loaded but NOT saved by
> 	 * the CPU (Type-B).  If DebugSwap is disabled/unsupported, the CPU both
> 	 * saves and loads debug registers (Type-A).
> 	 */

Sure but...

> 
> [*] https://lore.kernel.org/all/YzOTOzUzKPQSqURo@google.com/
> 
> 
> From: Sean Christopherson <seanjc@google.com>
> Date: Mon, 22 May 2023 16:29:52 -0700
> Subject: [PATCH] KVM: SVM: Rewrite sev_es_prepare_switch_to_guest()'s comment
>   about swap types


... I am missing the point here. You already wrote the patch below which 
1) you are happy about 2) you can push out right away to the upstream. 
Are you suggesting that I repost it?


> 
> Rewrite the comment(s) in sev_es_prepare_switch_to_guest() to explain the
> swap types employed by the CPU for SEV-ES guests, i.e. to explain why KVM
> needs to save a seemingly random subset of host state, and to provide a
> decoder for the APM's Type-A/B/C terminology.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 25 +++++++++++++++----------
>   1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 69ae5e1b3120..1e0e9b08e491 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3017,19 +3017,24 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
>   void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>   {
>   	/*
> -	 * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
> -	 * of which one step is to perform a VMLOAD. KVM performs the
> -	 * corresponding VMSAVE in svm_prepare_guest_switch for both
> -	 * traditional and SEV-ES guests.


When I see "traditional", I assume there was one single x86 KVM before 
say 2010 which was slow, emulated a lot but worked exactly the same on 
Intel and AMD. Which does not seem to ever be the case. May be say "SVM" 
here?


> +	 * All host state for SEV-ES guests is categorized into three swap types
> +	 * based on how it is handled by hardware during a world switch:
> +	 *
> +	 * A: VMRUN:   Host state saved in host save area
> +	 *    VMEXIT:  Host state loaded from host save area
> +	 *
> +	 * B: VMRUN:   Host state _NOT_ saved in host save area
> +	 *    VMEXIT:  Host state loaded from host save area
> +	 *
> +	 * C: VMRUN:   Host state _NOT_ saved in host save area
> +	 *    VMEXIT:  Host state initialized to default(reset) values
> +	 *
> +	 * Manually save type-B state, i.e. state that is loaded by VMEXIT but
> +	 * isn't saved by VMRUN, that isn't already saved by VMSAVE (performed
> +	 * by common SVM code).

Like here - "common SVM"?

Thanks for the comments!


>   	 */
> -
> -	/* XCR0 is restored on VMEXIT, save the current host value */
>   	hostsa->xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
> -
> -	/* PKRU is restored on VMEXIT, save the current host value */
>   	hostsa->pkru = read_pkru();
> -
> -	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
>   	hostsa->xss = host_xss;
>   }
>   
> 
> base-commit: 39428f6ea9eace95011681628717062ff7f5eb5f

-- 
Alexey

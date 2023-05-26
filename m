Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D25711E59
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 05:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjEZDQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 23:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjEZDQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 23:16:47 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E4E90;
        Thu, 25 May 2023 20:16:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BHo4sIXaUJ4vNkTaGTwgCxomzodFIWoOIfrJMfnlZHFe6/uTnd/lMZw3YxsGFYd/OSRTxpyzwzDrEUjDHlb3HIJbfr7YPJOQDCRR9vOkjnjTSUpb9KEu+t6xQpZGXGVziOYlrN2srGPuOx/sPP9pAOa8qVUoKEPMf8TWa0NV8vPP8eW6JE3Q6iNyq6e7LjtQTMxNonu4ot9Vpa31J1bXcUEKqFLFYlaKtvlVWZBEZuoZD+bdt+8+dtzDS2QGnocG5P0bmKEAsNkfsnIeyNAQCnu4wX4XvkatXKGnDwx+5CrbJmUjhr/M0wqRVAOjIJKckcIawTWwnEjd858OjTldQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tp1CpruJ1bpqb2zZfo2F1iESQlsJ/G8PQMu1NuY5EDE=;
 b=DuJONcCBJrqYugNcPi7kPJEhcMkdLBA6pq1e5MnwuXhdE0NCuAXLpbOZ6tFuOkPgRkAqC0GxRDHcynrpduuiLElNxtmX46b6/hrqYjs/mH/El6S0Y8FQTveRyTUIJeX6apxT0WQ8tM86mspjlCyclhcvmA70G8scn5djILn4bP/L1gRSQZzZE4XSIGvqxa/+lv9jDZEIzoCn6osPeL4XN4rcsK2gRFUpvOfdUkgm58JW593pHrvL1/T+vMk1+t2MQVfo0jEyuzh0LvEAgv9KcI4c3A4XRYAbFgvhA/0hQGipNeL7PrS+CeUfKcKnldCuHONmvrPZU1Na5lvBTHGaLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tp1CpruJ1bpqb2zZfo2F1iESQlsJ/G8PQMu1NuY5EDE=;
 b=mqgnF/CsGCnEKBcH1dxX5uTpF/xzuRVjbxl8IDhtUKxMP7P/hwO7CuddnF99Kx5t9De8tXCBOIHE1WJyRSxi+ReUzHUqHkHMmNPgxC/RUhc25Q/Mat6Ws5UqQQGmce536S9Y1+PANfOHqMpRaodJdWJBTvn0uTMTj/nTtOZ/KGM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 BL0PR12MB4996.namprd12.prod.outlook.com (2603:10b6:208:1c6::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.17; Fri, 26 May 2023 03:16:40 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::d2ef:d75e:d9b2:835f]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::d2ef:d75e:d9b2:835f%7]) with mapi id 15.20.6433.016; Fri, 26 May 2023
 03:16:40 +0000
Message-ID: <fc82a8a7-af38-5037-1862-ba2315c4e5af@amd.com>
Date:   Fri, 26 May 2023 13:16:32 +1000
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
 <719a6b42-fd91-8eb4-f773-9ed98d2fdb07@amd.com> <ZGzfWQub4FQOrEtw@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZGzfWQub4FQOrEtw@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5PR01CA0035.ausprd01.prod.outlook.com
 (2603:10c6:10:1f8::12) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|BL0PR12MB4996:EE_
X-MS-Office365-Filtering-Correlation-Id: 34a8ef19-8e60-4b4c-886b-08db5d979f91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SQlXEuEKLP9EKy9gbPmQjKLtmAsqscjxjVWPtXRKlTfzoQMgRH/bYxALc+yfakQimOOvAE6kdYg2CqR7jFyQYfkSoI6BHcQtdz7lfAu88ukYNIyY3rRsCoX/k3GgphU3ztrG5BqLw6tV/hqOzNbtj+aQ87380C8JtMtbg5HEzz8tvfLT7V9GmWcRhJ/YYhycpSWjX9csdXLlCThzL3Q+uWVkThYqrjhC2LOmzUex9C6iK0ylOm1+UYem2dSSWmV0NV3Qifh3tmurwxJtNNaoMYkcD/rSKijO0TA+G0ksYib+a17GZuIu76Ag06E1GkrCiLa4yxohqkqbfACWMIznrgUvlwYVpOQR8XCD9NRn4CtEUAwpl4+VxT3ke6Bmf8yY7e7zXLUCT+amwkWGaPM7zN84Nalcefu2BGaixMa1yNgSTg4YqfSOytkcJ3lwJIatEECZHmKLjKtq+GV+I2lxLL+Mu+g+9IJCi4DpSs9ZonchqxqJvROn8gwCyLL3wCBr4M8u6q7cMZY0hbpgnT9PRSdZgOpMNebAzZIBqL01g1zy0kNzHhVjtVwooH0+1Qp0kk59vmtf1HzHSTvN+Yv/CWmcIPjCuspAOF8tDhN9pparus2ypTmBZJl3hJ+eeWOb8DpBR7lQMooXUWqYhaiRFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(39860400002)(376002)(136003)(451199021)(26005)(6512007)(2616005)(53546011)(6506007)(966005)(478600001)(41300700001)(316002)(4326008)(6916009)(66476007)(66946007)(66556008)(36756003)(6486002)(6666004)(31696002)(83380400001)(38100700002)(8676002)(8936002)(54906003)(5660300002)(2906002)(186003)(31686004)(66899021)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXRTRFYvQ2xYMFFjVGRzZmJOUlFDSncrV1Q2WnA1d2VpWjhFbDRwa2x4aTFT?=
 =?utf-8?B?d2RISzdyZlZiWlNnYmdybXkxYStEMktDM1k3Ukpnek1NdWMvenZnb1RTVmRU?=
 =?utf-8?B?ajNVT0ZORG9CWDJmc0UzTFZoa0ZsaFRjc2xOWm5HRGpHRlhMYVBRRm5sVHJR?=
 =?utf-8?B?TENwcnJSd3gyVWo3M1ZPWi9XWm5MMGdMUjluRVpGZkNweDc1WDRPVnlRelFY?=
 =?utf-8?B?N2tZU1RvMWVpRnNMYTVHS2ZscklLczRTNnlhWE5iUFV0cnlFRzhkVFYzRzZi?=
 =?utf-8?B?bzV1TEpQYTlGN3d2MUhyZGVoVmVIWVJWc0VlSXBRNXlZS010aVRqSXl3K0FU?=
 =?utf-8?B?Uy82VTByVDRtN0xnL0F0MUdoNHdtMXdLSHZXODY4NHVMMjE0U2hIQlRhVW85?=
 =?utf-8?B?NTVJTkFCdXJ5RWQ2RDMvcUY5Yk85QzFXdDJKUDFRRTJjalV1S1FjOExoM3Fp?=
 =?utf-8?B?YXZaanFYM21qTXc4eUdia0ZiLzlnNGt6RVB3Yk04MDhzdlI4Z0FvMURYcHBo?=
 =?utf-8?B?M1ZsR2RibExybDR6MHNxejJScDMrdG9NRjRtTk53Q1NXck5KNHQ3QjkyejAr?=
 =?utf-8?B?Z3RMOFo5SkpuNGIwbUYzQS9vSDVVdUpraHk3eWpWdE1mUnIzRURSeG1LcXAr?=
 =?utf-8?B?V1BjbVdCSk9XOVhRRUVsSVpWeEFEK3VTZWJ0d29pYTVSVkNNMWh3dXJFbnox?=
 =?utf-8?B?UUFOc1VUaFI3UGhGN2djUmczZjhXM0F1bVoyMU52NkJVcWhiMTdUOXNFTXlR?=
 =?utf-8?B?TWZ3MlAvZnVCWHNhamNGTURocFp1eDkvbVI2ZzNNUVR3M0xNOVF4aXpNRlVU?=
 =?utf-8?B?VUNLTkIwMnFucGphb0JtWXlNQVdhYnlQeXlNUmhBTEVBR29ReFdBTXJ2UmxS?=
 =?utf-8?B?V2FtU1czTGRaWm9lWDNvdCtCWk5vUWZ1SkRFbVhXeVlobTlaVHc3YmJnUVAr?=
 =?utf-8?B?TXo2V204bytLSnVEc0g0RUpBM3Q5K0dmYkVwZkZ4bWxYc1dOZnhIYTNxZHNs?=
 =?utf-8?B?Z083aFFsTDA5VExnOVhFSnR1aXJKV0JCQzZxYnJyY0lWWFQwWStBcW14eG1k?=
 =?utf-8?B?UkFnMXpENHFOZ0JSVVY4ckxMSGdwTXFJMkxIbzRRWGFEaWN6aml6NWFrM2ZL?=
 =?utf-8?B?bEdNcERwNXo5VzdPeHU3eXMrK0NaTmtxZllYR3AvNlR2MEZESlBxbUhRdTRk?=
 =?utf-8?B?eFUvZW01aVRvcG9GSnI2MU0wUG9ERkNaZ25GZk5BN1ZMWVl1TGdwMjZJN2VC?=
 =?utf-8?B?b2JydllmRzhjdXJzd2c2L01PdXdJTHlpcG9hODFTZndrWHFUaWNMU2l1QlE3?=
 =?utf-8?B?MmQwQ1hWN2x5NmV4ajNIYnBtbGVWUStLQTkyTTBQWFZWcE4rQzh0MmJTQkRL?=
 =?utf-8?B?eXR0YnQyZktpYUFRaEdTT3c0b2RrU2pvcVNrUWE2b0EwOURsSDVndjcvYlhQ?=
 =?utf-8?B?M2hsVUtFSitXdE5McHVPN1JmNDM3c2VNSFkwOWNCemtVaXUwVm5TV3o4TDJS?=
 =?utf-8?B?UnhSYmdKamRvUnM4enlPWlcvdVVXbklNSXgyenNpZnFZTWlKMm55Nkk5YVBM?=
 =?utf-8?B?R0lPUXdoWGVKdk8yT0l4a1hPZXhSRzA1M095cXFYT2JYZnkvRFArbFIwbFZq?=
 =?utf-8?B?ZFFQT2UyZjNoUXBtcUEzaGNEN2NjdGVCTmJQamlMallTYllOeGh3MFZra0x1?=
 =?utf-8?B?SFBWd0UvZ2MveWpGK2Jsc1JMMGs4UTNGbUpSWEdvZWJGSmh6aE9TV1RNTmlu?=
 =?utf-8?B?bi9wZEhLcVFLTlRhWWFLdm01cTQyRDZKajhBTjcwcTZGSDk1SUxzZDV3VVZM?=
 =?utf-8?B?Z3U4MnRvODEwSHhyM2E5c1FlZDBBb0dzL0J4cVJXS21lNktuQnhDZDFxa0ow?=
 =?utf-8?B?czA1Y2drQzJMSHZxdGkzcGgrL0lqY212SDhMdFZIdDJOSFR3TDN3YUtZMVZy?=
 =?utf-8?B?aHVzNjN2RWQrMFExY2hQTFM3Y1N0Yi9WOWJpak5PSmJLUElUWkdKSDJOZm56?=
 =?utf-8?B?Y05XVUV5elduRjJlelFTV0dzeUVURGtaRG9jWHE2UjNIK0FKTEEyL2FwTXJz?=
 =?utf-8?B?TnB2Sm00eXdHM2E0bzhkRkVVMWQwUGVSZXYyalJmMG9VOVQyOW1iL0ZQR2tU?=
 =?utf-8?Q?tfXOJ34G2IKTYdFRNzPas7scb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a8ef19-8e60-4b4c-886b-08db5d979f91
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 03:16:40.3117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +MBVTaU5/PJkupEBdbDlWgDlB6/SQ16cehoyIYl52qK+ODlhyZ/Xl4TcB8WzN+61rm6hThLmRVFuMkNgRvbr2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4996
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



On 24/5/23 01:44, Sean Christopherson wrote:
> On Tue, May 23, 2023, Alexey Kardashevskiy wrote:
>>
>>
>> On 23/5/23 09:39, Sean Christopherson wrote:
>>> On Tue, Apr 11, 2023, Alexey Kardashevskiy wrote:
>>>> Prior to SEV-ES, KVM saved/restored host debug registers upon switching
>>>> to/from a VM. Changing those registers inside a running SEV VM
>>>> triggered #VMEXIT to KVM.
>>>
>>> Please, please don't make it sound like some behavior is *the* one and only behavior.
>>> *KVM* *chooses* to intercept debug register accesses.  Though I would omit this
>>> paragraph (and largely the next) entirely, IMO it's safe to assume the reader has
>>> a basic understanding of how KVM deals with DRs and #DBs.
>>
>> Out of curiosity - is ARM similar in this regard, interceptions and stuff?
> 
> Yes.  The granularity of interceptions varies based on the architectural revision,
> and presumably there are things that always trap.  But the core concept of letting
> software decide what to intercept is the same.
> 
>>>> SEV-ES added encrypted state (ES) which uses an encrypted page
>>>> for the VM state (VMSA). The hardware saves/restores certain registers
>>>> on VMRUN/VMEXIT according to a swap type (A, B, C), see
>>>> "Table B-3. Swap Types" in the AMD Architecture Programmer’s Manual
>>>> volume 2.
>>>>
>>>> The DR6 and DR7 registers have always been swapped as Type A for SEV-ES
>>>
>>> Please rewrite this to just state what the behavior is instead of "Type A" vs.
>>> "Type B".  Outside of AMD, the "type a/b/c" stuff isn't anywhere near ubiquitous
>>> enough to justify obfuscating super simple concepts.
>>>
>>> Actually, this feature really has nothing to do with Type A vs. Type B, since
>>> that's purely about host state.
>>
>> Mmm. Nothing? If the feature is enabled and DR[0-3] are not saved in HOSTSA,
>> then the host looses debug state because of the working feature.
>>
>>> I assume the switch from Type A to Type B is a
>>> side effect, or an opportunistic optimization?
>>
>> There is no switch. DR[67] were and are one type, and the other DRs were not
>> swapped and now are, but with a different Swap Type.
> 
> Ah, this is what I missed.
> 
>> And the patch saves DR[0-3] in HOSTSA but not DR[67] and this deserves some
>> explaining why is that.
>>
>>> Regardless, something like this is a lot easier for a human to read.  It's easy
>>> enough to find DebugSwap in the APM (literally took me longer to find my copy of
>>> the PDF).
>>
>> It is also easy to find "Swap Types" in the APM...
> 
> Redirecting readers to specs for gory details is fine.  Redirecting for basic,
> simple functionality is not.  Maybe the swap types will someday be common knowledge
> in KVM, and an explanation will no longer be necessary, but we are nowhere near
> that point.
> 
>>>     Add support for "DebugSwap for SEV-ES guests", which provides support
>>>     for swapping DR[0-3] and DR[0-3]_ADDR_MASK on VMRUN and VMEXIT, i.e.
>>>     allows KVM to expose debug capabilities to SEV-ES guests.  Without
>>>     DebugSwap support, the CPU doesn't save/load _guest_ debug registers,
>>
>> But it does save/load DR6 and DR7.
>>
>>>     and KVM cannot manually context switch guest DRs due the VMSA being
>>>     encrypted.
>>>
>>>     Enable DebugSwap if and only if the CPU also supports NoNestedDataBp,
>>>     which causes the CPU to ignore nested #DBs, i.e. #DBs that occur when
>>>     vectoring a #DB.
>>
>> (english question) What does "vectoring" mean here precisely? Handling?
>> Processing?
> 
> It's not really an English thing.  "Vectoring" is, or at least was, Intel terminology
> for describing the flow from the initial detection of an exception to the exception's
> delivery to software, e.g. covers the IDT lookup, any GDT/LDT lookups, pushing
> information on the stack, fetching the software exception handler, etc.  Importantly,
> it describes the period where there are no instructions retired and thus ucode doesn't
> open event windows, i.e. where triggering another, non-contributory exception will
> effectively "hang" the CPU (at least on CPUs without Intel's "notify" VM-Exit support).
> 
>>>     the host by putting the CPU into an infinite loop of vectoring #DBs
>>>     (see https://bugzilla.redhat.com/show_bug.cgi?id=1278496)
>>
>> Good one, thanks for the link.
>>
>>>
>>>     Set the features bit in sev_es_sync_vmsa() which is the last point
>>>     when VMSA is not encrypted yet as sev_(es_)init_vmcb() (where the most
>>>     init happens) is called not only when VCPU is initialized but also on
>>>     intrahost migration when VMSA is encrypted.
>>>
>>>> guests, but a new feature is available, identified via
>>>> CPUID Fn8000001F_EAX[14] "DebugSwap for SEV-ES guests", that provides
>>>> support for swapping additional debug registers. DR[0-3] and
>>>> DR[0-3]_ADDR_MASK are swapped as Type B when SEV_FEATURES[5] (DebugSwap)
>>>> is set.
>>>>
>>>> Enable DebugSwap for a VMSA but only do so if CPUID Fn80000021_EAX[0]
>>>> ("NoNestedDataBp", "Processor ignores nested data breakpoints") is
>>>> supported by the SOC as otherwise a malicious SEV-ES guest can set up
>>>> data breakpoints on the #DB IDT entry/stack and cause an infinite loop.
>>>> Set the features bit in sev_es_sync_vmsa() which is the last point
>>>> when VMSA is not encrypted yet as sev_(es_)init_vmcb() (where the most
>>>> init happens) is called not only when VCPU is initialized but also on
>>>> intrahost migration when VMSA is encrypted.
>>>>
>>>> Eliminate DR7 and #DB intercepts as:
>>>> - they are not needed when DebugSwap is supported;
>>>
>>> "not needed" isn't sufficient justification.  KVM doesn't strictly need to do a
>>> lot of things, but does them anyways for a variety of reasons.  E.g. #DB intercept
>>> is also not needed when NoNestedDataBp is supported and vcpu->guest_debug==0, i.e.
>>> this should clarify why KVM doesn't simply disable #DB intercepts for _all_ VMs
>>> when NoNestedDataBp is support.  Presumably the answer is "because it's simpler
>>> than toggling #DB interception for guest_debug.
>>
>> TBH I did not have a good answer but from the above I'd say we want to
>> disable #DB intercepts in a separate patch, just as you say below.
>>
>>> Actually, can't disabling #DB interception for DebugSwap SEV-ES guests be a
>>> separate patch?  KVM can still inject #DBs for SEV-ES guests, no?
>>
>> Sorry for my ignorance but what is the point of injecting #DB if there is no
>> way of changing the guest's DR7?
> 
> Well, _injecting_ the #DB is necessary for correctness from the guest's perspective.
> "What's the point of _intercepting_ #DB" is the real question.  And for SEV-ES guests
> with DebugSwap, there is no point, which is why I agree that KVM should disable
> interception in that case.  What I'm calling out is that disabling #Db interception
> isn't _necessary_ for correctness (unless I'm missing something), which means that
> it can and should go in a separate patch.


About this. Instead of sev_es_init_vmcb(), I can toggle the #DB 
intercept when toggling guest_debug, see below. This 
kvm_x86_ops::update_exception_bitmap hook is called on vcpu reset and 
kvm_arch_vcpu_ioctl_set_guest_debug (which skips this call if 
guest_state_protected = true). Is there any downside?


diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index da28ed69bf4a..a7df5eb4ac00 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1951,9 +1951,15 @@ static void svm_update_exception_bitmap(struct 
kvm_vcpu *vcpu)

         clr_exception_intercept(svm, BP_VECTOR);

+       if (cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
+               clr_exception_intercept(svm, DB_VECTOR);
+
         if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
                 if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
                         set_exception_intercept(svm, BP_VECTOR);
+
+               if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
+                       set_exception_intercept(svm, DB_VECTOR);
         }
  }




-- 
Alexey

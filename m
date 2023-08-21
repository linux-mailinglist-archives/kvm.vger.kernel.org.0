Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FEF7830A0
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 21:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjHUS4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 14:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjHUS4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 14:56:17 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E8B1FC6;
        Mon, 21 Aug 2023 11:54:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8kwNTvTv+6mMsNIxUt6c7Qaz2nfsIoceOoFic6iBXjndDPexclHxyejd1ODRBwTILCxXMqyUU+r9TkTO1So0+Qm1u4bl+epFGp0qeDpTay6C45RIebkBxWve6gS1Byr3LIDyM2+M9eox3YHHwAuDOt2HClwwXJpHsNdYmOYzNQZE2b9MV33lECQAP0CKwjSQGExxi0bNa73ZyvnoDQIUUC3XT3rfsVWh/4oMUDie4OmHrfoKsgE+7eK+x3FjR9WR6PifvGzmr334i8JJwerw73nyR/DTXn8yoSd8R/9n8poj567hKCnQ+mhUy40aKbNUfCKPFLTGkKhhk7dA0oyVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=29ELA0O+zlCnsThKm7H5kDgeNywWjgE0A/chqsljtS8=;
 b=MXPvhvC+N+p9H+wSQ8Z/G29x+zB2jClXkW5Sbpa8oJ31V5agstvCXTUG4p2zT5Qud2tSv7YEswFwX4VkFB1navOGAufH0Uc1VzYSdIvppfVVVe0jvKYhgmsyy+OWRKZc+ABmrLFvtt/+iJ7g8eYy+VE3QQH5Vns/TxMWopQq6YMZsE0zJxIuZnl8lKldl9epTT2oIOM0MpOlDPOvchVoWKsEp+OWWLoUEJjmerHlLHVZG5gpsk5Zq4GCcxjOv+tbDsDwOXNJlV8SJ9Ks9dNDXe1mcT96c2PhgsPD2VnIf7Lk7eHKe00h65WpHDbMPLlvJMOsbve2Pti6dXMdOFwVnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29ELA0O+zlCnsThKm7H5kDgeNywWjgE0A/chqsljtS8=;
 b=tNpoffeIcWQpwyhWrD/pEasIm5cMnuRkmLy8xIJGWJHuQEDlJqLm8rrLCwgfJHf5HADNqQMI4I5XE2yif8Qqz3tKg2enBLtzWU+Xp/TOwUFEDO6x3+bt4NVqzmh7fLSyzpgawj0TX09InQnttlTPNzrXBvTeXQQr7fCXmZGb3pM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CO6PR12MB5393.namprd12.prod.outlook.com (2603:10b6:5:356::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Mon, 21 Aug
 2023 18:53:57 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 18:53:57 +0000
Message-ID: <2a391d50-d474-eec5-76ea-e5dc5590609c@amd.com>
Date:   Mon, 21 Aug 2023 13:53:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] x86/sev: Make early_set_memory_decrypted() calls page
 aligned
Content-Language: en-US
To:     Steve Rutherford <srutherford@google.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David.Kaplan@amd.com,
        jacobhxu@google.com, patelsvishal@google.com, bhillier@google.com
References: <20230818233451.3615464-1-srutherford@google.com>
 <08418fc0-839a-f2fb-1c2e-b4f077d2647b@amd.com>
 <CABayD+cw3s1UDSN7oR4gWfRT4-snWEqOgAN-y4rzOpe-8D=KdA@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CABayD+cw3s1UDSN7oR4gWfRT4-snWEqOgAN-y4rzOpe-8D=KdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0120.namprd11.prod.outlook.com
 (2603:10b6:806:d1::35) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CO6PR12MB5393:EE_
X-MS-Office365-Filtering-Correlation-Id: 05b6f7f7-7775-4a01-e25c-08dba277f961
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1cStbkNpK1vXWZ4HTsBXnusBiC65pENkeQF0i2LmMi4J3cmnxncQ7f81RwmKWmFUQr4GRLMC71ToM4K8BTY2He9mujiP1ohia9spIst9PqxBo7CGwcLFGkS3/9Ttb5t7oqVCDOqyTAzI6RSVVQqyM5sioR2Ivu0/xoX86DoLkGnVn3USQf5IEmVQn5FIdsLUAzAXvJxZXLImJwU4ifhzKaqEb1QyYHHkRiHJsLUeB/TOkl9xmPFf8m4cTKuV8jbAw2UayARsvRQbT6RY2RcDw7U6I/9n1lZhMqMYr5uquhyqBxaXL1mra++jjNmw3tdyzTa/6YBYeJZ0LJsbtfmqn9WOzL6gbRKUyyh+bSOrGs0WjZgK+uEGJDmmkX6XKcQJtinEbiaGuF07lGn3SvuIykd2xtrwkcOo86oJivRitdhIq7tup4droqBQiE1CU55pwj5RQ2Lqh5OyuBwjb4nJw7XuD+aYwFrPXdPEBtldqSmaTK2og0CVXqSoCEPbmenoRSStdhsU28xdHtZdd3EWwB0QsfO760/v7VCjm/Rn2sh80R+/Lu8dpXLJ0t9D9C4fQOpRDxNfCZhKVqoutfM5Sm10sW4aVxPqe6+gn5t+B9xNvystdlXpTWQnuuQmhMQdhiUsHhb0Y1NS0kbdRdMU7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(39860400002)(366004)(186009)(1800799009)(451199024)(54906003)(6916009)(66476007)(66556008)(316002)(66946007)(6512007)(8676002)(8936002)(2616005)(4326008)(36756003)(41300700001)(478600001)(6666004)(38100700002)(53546011)(6506007)(6486002)(83380400001)(2906002)(7416002)(86362001)(31686004)(31696002)(5660300002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWNvQUcvQjhKNGxnRUpZb1ZsdER3SlRVbVh2V1VXTzRwQmx2QlJFUXFCQzZn?=
 =?utf-8?B?VHF3VkprbFpMYmZ5Sis1RDJscmVqb1QzUmkyODJOazVNSXlKS25YdVJLSWZH?=
 =?utf-8?B?MUdYSmc3RU1EalVxUEdUK1NjVTNVM2xNZFdtUUNoVWVRZEtVcjFOUWoxMDA5?=
 =?utf-8?B?eW1hcWxkRkN1a1MvZW02Q3VISHhiQThjOG5rS1hrOEgzT1JkL1h0eFRWcElv?=
 =?utf-8?B?QnZCc2lQRHRnbTFPNWNDVXFMTDBHTkxjbnh2VERDSTNHSFNSMExlekRQdWkw?=
 =?utf-8?B?TW1nMVRtWlE4S1dlVmUxeGkrOUJ4Z1FmZU93a1Q2OFZVbEFURWxTclVkS3pi?=
 =?utf-8?B?ZHhDUHkyZmhNV2RSSDM5NE9WclNCQVlKQkMrczFjdkZIVVh0QXczaDUrRy9N?=
 =?utf-8?B?ajZJd3lpd0lDS3N2MmViRGJKcjVlMDB0dG42RE91NUd0ajR4K3piUUR3V3Vj?=
 =?utf-8?B?THVFNFNrMjl1azdzL09MczhKWk5mR0VpVnlYZENRVDAwVlBHRVJWS1BFTG1I?=
 =?utf-8?B?LzcyRlZnY25uZW5VeEdRdFRXYnRqK3Yvd0VoVGx6MTE3dk52NWIzUkdHWnU2?=
 =?utf-8?B?OXU2dTVEeWk1NHo0bFJQQS9nYzQwWU5PNU96L1d3YzBNdzRCYkRzOC9aeGp6?=
 =?utf-8?B?M1hkSUVPaE9Sb2kwOWZtbnBTcXRscVM2V0kxMEpQMGROSi8yUVVkSXhvZ0Iy?=
 =?utf-8?B?b01LYko0bmFvaE5IY2ZlbnF4K0hmRVlPK3ZlZHRyNXd2dm55aE1DMmR4L0NV?=
 =?utf-8?B?cXQ4cmd3VU9IQ1EySW84bWF0eW9GOTFKV05sYWJtSUhEakRCbmUyZmtIb0ZZ?=
 =?utf-8?B?ZXRQeTlPYjJWRERNV2ZJTi9CZXFjNks3R1dkeVpVaHd5SzdaSlNwVFpPQjhR?=
 =?utf-8?B?Vm5PNkRtZTlpZWRYcVhlWGMvN3RkTmtUdC9QWXVYakhST0VYanlsUWllMyt4?=
 =?utf-8?B?L1RTZGlQWW9ZMzhHK0dYbklCSWh4KzFSRFpJaDZsdnNrOUN5RXZJSFdBdUMr?=
 =?utf-8?B?OUNpZ083QjFtRUlNQW10cTJpQXNKK2duQ2M1UG45QUVUY01KQkpWQWx4SzBi?=
 =?utf-8?B?QmtyQ2VjOGlGUk1NOUFHYXpsUnFDSkVmaEpVSEVKSit6TVNpdHZDSVBCSjh3?=
 =?utf-8?B?SGdhSDFxeEIzSFdPQm51cGkvcTRjRE53Q3I1TGR3eWN5TGtlcEVobFdsdnlG?=
 =?utf-8?B?TGR6eDhyNUZheFRvWU5Gb2FTZkM3U28xd0RKQytvcndWa1YxaWNyQTBNbTlB?=
 =?utf-8?B?b25DbGhXbGpOTlM2ZXRZVW11eWsvaG51M2pJKzBsODJQc1ZndDRXeDhDYjdR?=
 =?utf-8?B?YUdOYUtySEMwT0E5b1VJYitSbC95czFUQk0xcTU0dnRWUnNSMEFEUFY2YVpR?=
 =?utf-8?B?QVdubEd4ZnBBSXJxR2xhZVBzU2RGQ2pqOXIrTCtyZElVQTNMeEhVMHhjYTB5?=
 =?utf-8?B?SXhmdWl0WGhkcGJvMkNZdXhGSGJwckJSUnFXcTVrMFRVbU1rWXVkNTRKR3RJ?=
 =?utf-8?B?eU9wd3pGQUZIZWh5Z0dMZXBhT3hLWitMaFBHRVNseWtUSGxEaGhvSnhQKzhR?=
 =?utf-8?B?RERKNmU0d3p1VVZMUis5V1IwZHM3ZEY1U1NXcDRZWDdTOE8wTllzbG5BZTIz?=
 =?utf-8?B?OFlMQjhvcG9BeW5pVlVpM2REUEpqS1JGVkkrdWVqcDl0MDJQQ1VTaGl5c2lt?=
 =?utf-8?B?aVNiUEdNRGkwSnFpTkc4UGFiOWxoZEpOTkx6QlFVdE5ZSm8zYjJEZXczc2JT?=
 =?utf-8?B?aHpCaW9pZzc3OGcxK0tlSUV4VjZIdVdWVzJGMU1XSDVJbDlOK0JuT2ZhQTdG?=
 =?utf-8?B?YWNlVVdwVFZ4OSsxUlR5c1paVWxDM1pFRTBQVlZySmhJZ0VsUHJheHlERlhL?=
 =?utf-8?B?RlRwTUgxd0UxQjY1eGhEdVo2LzFzV05kU1pldlpaZC9MM0l6WUZvOVRkSy9S?=
 =?utf-8?B?NGhUSlBLOE5xMktDMlJ1T1d0Ty9Va0FVbDNQcjdBMFVZa1RqaGZuSGtVNDdV?=
 =?utf-8?B?bHBZQk9OZmg2T0xiNjArNnFETkNzUzhOdWNlWGFZSXpYaWFVcHZWY2N3UXBi?=
 =?utf-8?B?MnVsLzFpNFpJSWc1U040OEVBeS9UcWhKRktKUHVJY2F2aXdGMDJMZWk2bXVV?=
 =?utf-8?Q?/KQRS4oxhoSyyFmeSOo9GS6qH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b6f7f7-7775-4a01-e25c-08dba277f961
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 18:53:57.3477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6buVv6QfRv777StAUtlm3CbXX+NCPYYc1CnTym82/GujTFKwGkO1pvyKKG1RlJmzXuxgJr3C6HtIQrVuGSDozw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5393
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/21/23 13:15, Steve Rutherford wrote:
> On Mon, Aug 21, 2023 at 6:10 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> On 8/18/23 18:34, Steve Rutherford wrote:
>>> early_set_memory_decrypted() assumes its parameters are page aligned.
>>> Non-page aligned calls result in additional pages being marked as
>>> decrypted via the encryption status hypercall, which results in
>>> consistent corruption of pages during live migration. Live
>>> migration requires accurate encryption status information to avoid
>>> migrating pages from the wrong perspective.
>>
>> Hmmm... I'm not sure this is the proper fix. The code is actually doing
>> the right thing from a encyrption/decryption point of view by checking the
>> c-bit for the PTE associated with the virtual address and the size
>> (possibly crossing page boundaries).
>>
>> I think the problem is on the call to early_set_mem_enc_dec_hypercall()
>> where it doesn't take into account the possible crossing of page
>> boundaries and so can under-count the number of pages, right?
> 
> Right now, if you request decryption of e.g. a non-page aligned 0x40
> byte structure, it rounds the 0x40 bytes up to one page, and then
> hypercalls to mark both the page it's on and the subsequent page as
> decrypted (since the rounding stretches the structure onto the next
> page spuriously). The arithmetic in the combination of
> early_set_memory_enc_dec() and early_set_mem_enc_dec_hypercall() are
> correct if they are called with page aligned vaddrs (non-page-aligned
> sizes are fine iiuc).

Ah, right, correct. It is still related to how the page count is 
calculated for the hypercall, though, right? The encryption/decryption 
operations function properly.

If another caller of early_set_memory_decrypted() gets added, it would 
need to know to do the same thing. So I just wonder if this wouldn't be 
better fixed in early_set_memory_enc_dec() by using a page aligned address 
and proper number of pages when calling early_set_mem_enc_dec_hypercall() 
or in early_set_mem_enc_dec_hypercall() where it would take a size 
argument instead of a page count and does the proper work to get a page 
aligned address and proper page count.

Also, if it is the hypercall that is causing the issue, should the Fixes 
tag be 064ce6c550a0 ("mm: x86: Invoke hypercall when page encryption 
status is changed") since the problem is around the hypercall.

Thanks,
Tom

> 
> Thanks,
> Steve
>>
>> Thanks,
>> Tom
>>
>>>
>>> Fixes: 4716276184ec ("X86/KVM: Decrypt shared per-cpu variables when SEV is active")
>>> Signed-off-by: Steve Rutherford <srutherford@google.com>
>>> ---
>>>    arch/x86/kernel/kvm.c | 14 +++++++++++++-
>>>    1 file changed, 13 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>>> index 6a36db4f79fd..a0c072d3103c 100644
>>> --- a/arch/x86/kernel/kvm.c
>>> +++ b/arch/x86/kernel/kvm.c
>>> @@ -419,7 +419,14 @@ static u64 kvm_steal_clock(int cpu)
>>>
>>>    static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
>>>    {
>>> -     early_set_memory_decrypted((unsigned long) ptr, size);
>>> +     /*
>>> +      * early_set_memory_decrypted() requires page aligned parameters, but
>>> +      * this function needs to handle ptrs offset into a page.
>>> +      */
>>> +     unsigned long start = PAGE_ALIGN_DOWN((unsigned long) ptr);
>>> +     unsigned long end = (unsigned long) ptr + size;
>>> +
>>> +     early_set_memory_decrypted(start, end - start);
>>>    }
>>>
>>>    /*
>>> @@ -438,6 +445,11 @@ static void __init sev_map_percpu_data(void)
>>>                return;
>>>
>>>        for_each_possible_cpu(cpu) {
>>> +             /*
>>> +              * Calling __set_percpu_decrypted() for each per-cpu variable is
>>> +              * inefficent, since it may decrypt the same page multiple times.
>>> +              * That said, it avoids the need for more complicated logic.
>>> +              */
>>>                __set_percpu_decrypted(&per_cpu(apf_reason, cpu), sizeof(apf_reason));
>>>                __set_percpu_decrypted(&per_cpu(steal_time, cpu), sizeof(steal_time));
>>>                __set_percpu_decrypted(&per_cpu(kvm_apic_eoi, cpu), sizeof(kvm_apic_eoi));

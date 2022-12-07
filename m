Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7031664509C
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 01:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiLGAuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 19:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiLGAuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 19:50:16 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339D9CF3;
        Tue,  6 Dec 2022 16:50:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENd4YZWm3JpXSELkO3I76/cgWQ7cVC2YRLeVTPGmd7Xxl4GPs2b5W2b69awWw7CmSSXORvnT/vu78psh6O13T6Vt6z0KNcqqMFkUTyEcS/fpC+Nc2X8y1aR0kCntUI3Mf0kXj7/1b94K0+F41KIwsNCJS9hf4PKmFdj9mNi8uhYhGAaUytkvJKM2OFi4s+211Zz41MX3tlpSZY3f8rJRdASTQGHfSuBj/iiuw5DgPL/iVYfiQadZV6U2yOmeBojOG+fYCToO8HG8gTOnp/UiVJDN/GSm2iQ7romq5m9F60h+YBk4/X/PjkHpB0sndFdrMGYXAn0iD+foqvIuGC+vYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0xIFeDJ0Ir+gttQgw0n5JSusKPnxJED+ysa8OCUA2M8=;
 b=FsHqsDbTPSlF7vaK7hB8eI7bDNivcAdLBstlMYPH4h+H0kHtRfdSxYdNA3bUl0oW/k9leqKp1v3aZHhGI8J3cTHNkTkWkkkoiRny3vE7dh56vVKjtcrg1WNHkRc04yPkuVBQJnzoeGUdMoOizyd4CJSOOKJ6Cf2OQVgj/eU3yCqdksWG0rvYEjaq64q3gNiVHvUo/N/wIsHorPWZ1onwGifw+jlzpaJYVrUlRLPeer97pOzn9Hebk9Q5j/5cGn/eDdI31borNsDNPR9YDTV548ioptOyWeq3nZe68VrnxqdvscoidHhYgq2tgtGgpoj8ryoPQEmy2xwXXUCOFBOeAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xIFeDJ0Ir+gttQgw0n5JSusKPnxJED+ysa8OCUA2M8=;
 b=NEv1mng8g3nSSVLH1on5+Ni/G+ShuEt6RzitGUbGERWUSBvRN8KhCZNW7m/Q5j3Q+RIvHqaGMsZlDAZDDKdIFCWaOlHR7yfNRG586xY5ReZaF4VI9ed8WFJZMnfZ4BfPsUj1NVycWB3/pwN02cbXv0UPYTXvmlIB0TFQfF/PWNc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 CH3PR12MB7641.namprd12.prod.outlook.com (2603:10b6:610:150::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 00:50:13 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::7dc4:8eb:cc3c:3cd4]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::7dc4:8eb:cc3c:3cd4%6]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 00:50:13 +0000
Message-ID: <aa6bdae6-b1ad-238e-d9be-f6c2e7b47ef0@amd.com>
Date:   Wed, 7 Dec 2022 11:50:01 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH kernel 1/3] x86/amd/dr_addr_mask: Cache values in percpu
 variables
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Sterritt <sterritt@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221201021948.9259-1-aik@amd.com>
 <20221201021948.9259-2-aik@amd.com> <Y4jdIl1elcnL8JUU@google.com>
 <b28f0cb9-b321-cc55-db31-61296e1a494e@amd.com> <Y4927u7hjK+REsNr@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Y4927u7hjK+REsNr@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY3PR01CA0089.ausprd01.prod.outlook.com
 (2603:10c6:0:19::22) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|CH3PR12MB7641:EE_
X-MS-Office365-Filtering-Correlation-Id: d278cb72-a70c-48ce-c545-08dad7ecff8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: REou9X/bC7t7LoRI/t4Dgo6mn4epiyKJmDwydC7CUU/NTwOtkfkw70jO4ytr8xxSh5CmnMNfwq7hXBwgeine5WRw1HK95rYiOZYj8w0jilY2eMFWfvXFw1Dw96AHLFJuexVrnUtligAaUUMoSXFdmgamVn8+yFk6DBQT/Oveg7rA3ulBd4dc/6ZpMDXiZ1f91wN8JP+jd0CAmupy+MHYNUX4/I3/FwfmM00vwZXwDxqJh2lyeEBfue95Ql1LVX50KP7L5ta+x4vRlepsnCuP5QcMFM8SMSUVMj8wnm7Ywrgqvgg6Y3Ienf6aEvNitLWYgQkC6HHGyOnzGowG5BpcQPlJslt2gSrCTPyaAOqR8KqvOffx8amz0MUtxdEAX8vzsv9sWkfR0I9JK8ZTmfUdLEbJU/Cqvx0NeYiX2MkQRDN0SwkxXUmARMDdRYlu3z22TdqRDxLSoEGzRKkf7OKaohtMgdz2Ft+0Q64mhtHlaP7xVU+7HyCaRCZJT8NCMPYNvh1OP8WwUEZrhcQzFO6AJCtmiI6eLrvSmhcClfoSO/c6UeOZ8+F+f521g06/YT77/C7gQVLoVgOU8KIDVftVovcqCQv9zn5JU2Ot1bMQdEawkQLqTSfQuiFz3Im1MEiLCY0zPYmvyLDocVOBMwQTnj8mAB8ytrhIifxzxG5MZGAMcxUs6o/U2HwXuTW4hGWHfy8dWewJWqH7v/33Jgd9B1wW60S5CEYq12abcPoIOOprEHWm+c80pvhuJMdb4jF8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(366004)(39860400002)(376002)(451199015)(36756003)(966005)(31696002)(478600001)(6506007)(53546011)(45080400002)(6486002)(6666004)(6512007)(8936002)(5660300002)(7416002)(41300700001)(66556008)(66476007)(316002)(2906002)(54906003)(6916009)(4326008)(8676002)(66946007)(83380400001)(38100700002)(186003)(26005)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjY2RktqeGgzSW5GQUl5TUhnckt4Y2VrTElMc2ZFTDgxQVZwWWVxMjVITEZ1?=
 =?utf-8?B?c05HTkxHUWlnL3V5eXRoY25Bb1A2dmRaVW9zRjh5TWpHU21JTHhGam1haW9O?=
 =?utf-8?B?OXRpd0p2U2FoU2JYWEJ2WGd0SDYyYjFPVVJmZEwyS25rV25mcTE2bG1aVDRE?=
 =?utf-8?B?VGJlSHluY1Rpb294Nk9DLzlPUHhneVg1eVlaQ3dLTVRUOUwybHRKamJWR0Jt?=
 =?utf-8?B?cjgwa1JjUXFOQ1B2TldRY2k3emRLR2J0VGFHdGY4RjV6c0k1Q203a0MzejF6?=
 =?utf-8?B?Q3FHYkp2L2FDQ0NGczFyRVRiRHVVUDdhQ0FmTk4wdmNSZTgxQnY0UU9JWHFx?=
 =?utf-8?B?TkhtbEZMZXkyMnBNZ3IwTEJiRGhXSVZ4QUVuLzlkWVh5NGI3TU1HRWt6c1RP?=
 =?utf-8?B?M0REdEd0K0ZqNVZ6V2t1MHR4TGo5MVVtOGsvdEVxRnZERFIwSUV4UjNTYXBV?=
 =?utf-8?B?MTVGQjNGSUlzazB1SzQ4VEJhR1NQYTlHR09oTS9LdFZwKzY1ZVdHLzRzNlBq?=
 =?utf-8?B?ZTIxc21LZGNaaXMvWHo1dGhKK09nYng5NXhvVjJ4Q0tWR1k4YUVjdldDdFdG?=
 =?utf-8?B?Ky8zMm1KQndjUHBubHpGZFNoQW9EVC8ySnd1ZjZYZkJEaDlRWWR0emRDV016?=
 =?utf-8?B?dUxId0M1SUJneXFSd0dQUmhYc1FHa1Qwd1pneGhCNkxxZ1BCK3VpWTdaNHAr?=
 =?utf-8?B?VFE1MTVMN1RBSHR1blk4d2hCVmpjYVJjckxidm1SeEJSbGxaTEw4K015SzFv?=
 =?utf-8?B?aksvVU8wWlJQZlc2VUE0anV6aGhtcWZScEZxem1MK1d4NCtZSFh6SkMvenFJ?=
 =?utf-8?B?MzE4T1llWlRSVlZwTEhPNlpNMWdHWGlRUnUrempzYWc4Z0UrV2h1c283U24x?=
 =?utf-8?B?ZkZXMkxldDY5amRadnIrZWdhdjA2NTExOUZGT1JxM1VMT2JnL2VDT21aQ2dE?=
 =?utf-8?B?YTVUUkpWZTc0SmRqZnRBQXl5cWNKMjFLVHNvODZ1U0hyUlZydTVId0lyMkRG?=
 =?utf-8?B?QjJxaEU0eXoxWHZ0WTNLcWRHRmFHOWlaN3l0NVM1UlpGWWw5TnlYaXJWc2pH?=
 =?utf-8?B?ZzBqSXZRbFhnbTd4bjVielFPRzJtb3ZuRnZsci9jdmF3RHBMaE5nWWRZckRF?=
 =?utf-8?B?VTdRSWlnaEovY1ozd25qUEdkWVJsWEtGN3pUbXIvckhCY2RtSlR5UlgwQkw1?=
 =?utf-8?B?UmNnaGRtZmY1YjU3QnRkS2lqMUR0K000RTlNUGNwcDRPR2F0d3F0TDJLVS9u?=
 =?utf-8?B?WTI1SDF4WUxjVVBpK1V3SmtjL1ROcXFLUzFTWXFYdHdVVUdUUWIzN3lsZldz?=
 =?utf-8?B?ZGlCOFRJYkEzY1l4cEtnUDdCQ3dNZjhSSk45UngwQ2VZZWE0VDVZTWwwUUVU?=
 =?utf-8?B?NjBEaG8vRzI1WTdwUVZUOVZRczJNYjNxbkRqdjZHRXYxeGFEOEVhNmRMalhl?=
 =?utf-8?B?Znkwd0FVVXZUTHIxYUpadkJXdFVFTkd5bEhsWnVjSVZUYnNYbjJISmZ5eW42?=
 =?utf-8?B?aGFPRkxMbVkxdEdscUY1YTdUQW9PeC9pWGZvUGdFSkpvb1hzTXcrSmFZcytl?=
 =?utf-8?B?RmVrdWRkMys2NTdiWVpQS2tEcHd4MXpEK1gyVVZPaHpJdHBRWUlyQkVJN2Jv?=
 =?utf-8?B?RyswRDdXWWU3NHZhVi90M1gxbTJ4U21RM1hCb3J4SEFWL2NaTmt6ZzQrK203?=
 =?utf-8?B?UnJIMnpZMmgrNzZacGdOdjFad3ArcHU0VXdtM241ZzY5VjZ3bnhYM0dxRjRT?=
 =?utf-8?B?ZmF5enAyZGM0SlhObXgrWGZCenVhQ0RkTUFqUnorbnpMeVh1c0Z6NDI2MGQ3?=
 =?utf-8?B?VzE0SUxrWkwvUStYMyswSWNlMTNpODRhaFJrZVhINithUkFDWms3aFVkLy80?=
 =?utf-8?B?cnlEY3dNNzBIR0Zna3Z0VjdWRTZBcHgxNWtVN0NreVhXV2doU2grMFhkVW1j?=
 =?utf-8?B?dE1RUTlaUW8rRmN4TXRDUGpyS3N3bWwxa2VLNDl2M2xQa3ZRNjNVdlhDZW00?=
 =?utf-8?B?N0l5Tk14TXBPUW1XQzBiQUZBTHN0eGxYaHVldE10WUJaRVppc3V1TFc4RFdm?=
 =?utf-8?B?RnVqcVNYMWtYZWtIVkN4Q1BTTVlVbVNlczJhZS9kWC9ETFhhbm9JblA4R0Fa?=
 =?utf-8?Q?uKnyhCDha99iJVzDL5QT7EGh2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d278cb72-a70c-48ce-c545-08dad7ecff8a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 00:50:12.9634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nb+921auGygfHP9J/bcKKIvfTqUVq+1N6DnVosBwcOBY2jQsHswEDxfY6TX+8if0KsBP12dnRnYJiJt5Wpi9cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7641
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/12/22 04:07, Sean Christopherson wrote:
> On Tue, Dec 06, 2022, Alexey Kardashevskiy wrote:
>>
>> On 2/12/22 03:58, Sean Christopherson wrote:
>>> On Thu, Dec 01, 2022, Alexey Kardashevskiy wrote:
>>>> diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
>>>> index cfdf307ddc01..c4324d0205b5 100644
>>>> --- a/arch/x86/include/asm/debugreg.h
>>>> +++ b/arch/x86/include/asm/debugreg.h
>>>> @@ -127,6 +127,7 @@ static __always_inline void local_db_restore(unsigned long dr7)
>>>>    #ifdef CONFIG_CPU_SUP_AMD
>>>>    extern void set_dr_addr_mask(unsigned long mask, int dr);
>>>> +extern unsigned long get_dr_addr_mask(int dr);
>>>>    #else
>>>>    static inline void set_dr_addr_mask(unsigned long mask, int dr) { }
>>>
>>> KVM_AMD doesn't depend on CPU_SUP_AMD, i.e. this needs a stub.  Or we need to add
>>> a dependency.
>>
>> The new symbol is under CONFIG_CPU_SUP_AMD and so is its only user
>> arch/x86/kernel/cpu/amd.c:
>>
>> arch/x86/kernel/cpu/Makefile:
>> obj-$(CONFIG_CPU_SUP_AMD)               += amd.o
>>
>>
>> Is this enough dependency or we need something else? (if enough, I'll put it
>> into the next commit log).
> 
> No, it's actually the opposite, the issue is precisely that the symbol is buried
> under CPU_SUP_AMD.  KVM_AMD doesn't currently depend on CPU_SUP_AMD, and so the
> usage in sev_es_prepare_switch_to_guest() fails to compile if CPU_SUP_AMD=n and
> KVM_AMD={Y,M}.

Ouch, you are one step ahead, 2/3 fails, not this one. My bad. I'll add 
a stub anyway.

btw I want to do "s/int dr/unsigned int dr/" since I am using an array 
now. Does it have to be patch#1 "fix set_dr_addr_mask" and then patch#2 
"add get_dr_addr_mask" or one patch will do? Thanks,


> 
>    config KVM_AMD
> 	tristate "KVM for AMD processors support"
> 	depends on KVM
> 
> I actually just submitted a patch[*] to "fix" that since KVM requires the CPU vendor
> to be AMD or Hygon at runtime.

>  Although that patch is buried in the middle of a
> large series, it doesn't have any dependencies.  So, if this series is routed through
> the KVM tree, it should be straightforward to just pull that patch into this series,
> and whichever series lands first gets the honor of applying that patch.
> 
> If this series is routed through the tip tree, the best option may be to just add
> a stub to avoid potential conflicts, and then we can rip the stub out later.
> 
> [*] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20221201232655.290720-12-seanjc%40google.com&amp;data=05%7C01%7CAlexey.Kardashevskiy%40amd.com%7C6ee92cb78f8f446b887908dad7ac6fca%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638059432896741545%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=25f18IS6z9HEf0Qtt%2BFDxZdtbTVPg%2FVulsFGhWLH0Rg%3D&amp;reserved=0

-- 
Alexey

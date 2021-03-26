Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFF234AE7B
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 19:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhCZSXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 14:23:01 -0400
Received: from mail-dm6nam11on2043.outbound.protection.outlook.com ([40.107.223.43]:64864
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230254AbhCZSW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 14:22:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUqa4duYE+JPFato+agViP77wfGH3VXyVDco1FxX/DKm68E5PwinmtXt77zmQJYKU/eGU2rFW9E19QN0i10mRQmQf1DDL107yi16tUOktp0aNB5RzbpCfXfVn0tzbDgFk6Pg2YJF4R1PfQjTPWwvbtAkOd6naBgdd5bvh7KbXXLcG3ufOyQoc/fC7GDO2LFnjzXYVN3CmyS/Qlndma9h57XEeZE9MbXd4kgl4nPoGVSW61GhT12xe7f3kWDFVXcvDXOQbVkM3Kg1Fpm+0UEA/5TgcVQs8s9CPWbUng1BeUYav6NPRthJeP7fAvcFow1W7fBpd/P5DM0GBqvskGps6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=viqZ+dxJHXZ049+h5FvABmX2jExCELSVwqTQQlmdU9Y=;
 b=RnCGbcP2sSaH/RzQi+Y35L7ZaWtd6PKk5JZyuGW8dIIwav+QjKGyoNl0reiOPLQRAgQ0Kn2kHYntjV1tjOArJswmD3v52vY4VRFlqWHNo4R8j9De5f698V1hrSXxXCozx2Mb2Q27thAX/mJW3fetdLvTGEAfMBlvaS37MIT6NuVTDN/wtgcP6urD1QYJV/N9waAej0cR8zitbCjaPOfaqvlDvYn7Ms/70C5cqNsB+VdbGGmW+Q7cUJTAAlpAUxpY5+1qPTyPy0j2GjggJKmRBgUY6z2TmjT0nCvKp+zM2a8QEuNvIYT1fX1QVS81gcaadW4nsT4JgzlIQ9BaXN8IXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=viqZ+dxJHXZ049+h5FvABmX2jExCELSVwqTQQlmdU9Y=;
 b=YO39DXnqJjNbINw6JQLfoScbrK6pfsWcuabHgYfCefJuvMn9TF9Lpaspsp427XVAHe2v67tcS1NtQDZrJzUiGyoE9XMmaVwmh6Y8JL4K7GmRp27ENiVXlnJpSZEXOgGQzAu85BULtF0UtziOxJWpxDkg0y6NAqkHDMswOwA/gnA=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 18:22:27 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Fri, 26 Mar 2021
 18:22:27 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, ak@linux.intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 03/13] x86: add a helper routine for the
 PVALIDATE instruction
To:     Borislav Petkov <bp@alien8.de>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-4-brijesh.singh@amd.com>
 <20210326143026.GB27507@zn.tnic>
 <9c9773d1-c494-2dfe-cd2a-95e3cfdfa09f@amd.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <bddf2257-4178-c230-c40f-389db529a950@amd.com>
Date:   Fri, 26 Mar 2021 13:22:24 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <9c9773d1-c494-2dfe-cd2a-95e3cfdfa09f@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN7PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:806:f2::18) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN7PR04CA0013.namprd04.prod.outlook.com (2603:10b6:806:f2::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.28 via Frontend Transport; Fri, 26 Mar 2021 18:22:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 47a1b590-fdaa-4d53-bbf6-08d8f0841bbc
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44311EFDBF6A850BC0E1AC0BE5619@SA0PR12MB4431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rb+dX08BJ1+WqoA09WOckL3xKqay2T3f7jfjD2Q0+zdPArs4DJzSzJP4LYshuovkIoJ0F64iKa2rhTtORR0s3QCdL1BDA4QQcVJqi5GBo14qjB/wt3vYQuhBI5IhrZEeOhmmGj0RMoyfopRox38aySUPWSPlJKTlK/GViB+o6PDeWgsYS93I8lXR+fPASz5qnHn/DxyzDmjfxKpZGR9COXTbqOsvc0ZifgXs6nchEQQeWaXVO7LST86rK1qPujQu8o9YozB2wcbZAIryRUppJIJlhrPjKNE4lygt8FPtAr82h0ULz9pdc7d+HYt+RzDCDWNn87ZonXG3IRxrJSA8YqzXoQWBrtWPYDNK+5sZDcGLf6b0wgD9Pp8FN6pIWISwE8VeR4HTYHYQm0ce5gIMIwDP3HJajianpl/PftCOsyZV4tf19eBUAZruwv4TI/2OgEWgG8Bre8FrHXo2eDhrefQBrnAtn9giLZ9+ouXv2zwnhTJDLh13IZtky12MoUGnBY6OmvUZeeAGEk8z8l1NmzcEXlEXIoZFWc3Gg0n29Uk8LJaQ0lydn4Nm1QZLN1KQvMirqYZd8YK5tuhbSwzqp9P6VjbAQSw6Dnp8jTby+4Fj2SFdYQ1eaO5QX4T25S++drdgD2Z9Rl/CN4UDRDWWnRLaZunMWI445RrKmWqo/mCX7OCy2L1f1Gmi75E5vCCx93BedolFjbmVZvwFojMAWguPS+fxG1LsSs+dUSZHELw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(366004)(39860400002)(6512007)(26005)(186003)(6506007)(53546011)(5660300002)(6486002)(7416002)(66476007)(16526019)(66556008)(36756003)(31686004)(66946007)(38100700001)(2906002)(44832011)(956004)(52116002)(4326008)(2616005)(478600001)(6916009)(316002)(31696002)(8936002)(8676002)(54906003)(83380400001)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q3FuNTNwMStia1JkaGp3N1cwVThsMDBhdE94U2RGODZDUnpQWklMTlA5NnJ4?=
 =?utf-8?B?M0xLMHdqZUkrbFQ5YmcyRmNRaVVDM1J5QU5OUGUxVjROY0krZlByMUFaY25H?=
 =?utf-8?B?V3BlM2ZVeTZMNEt1Y0hRaE1Idlc3QkJZZnZjMHJ5N2UvREkybWlMYXViWWt4?=
 =?utf-8?B?N0VFeUx3OUtqM3ZJWHdPOFlhWTYvNXdpK0JHdzVjdnZ1MTdCOCtUdjdZZFE4?=
 =?utf-8?B?cG1yS2owaXkweExZd3c1MUIzeldyaTVnV1lBSUV1ZW5TNzdZN05Hak5uY3hJ?=
 =?utf-8?B?M2RqTGQycmZaK3pBTFdsSmJIa2xkSHBDVzBPcTBwdVdMTElyN1ZWSW9zelox?=
 =?utf-8?B?bXJ0WlhCQktJV203dE4rNU1Vc3VCTG1HakYvVjFHekF1UkNyclNYcFI2d0sr?=
 =?utf-8?B?TjYyeHc4ZEt6ZlZqWUlQQXZRMUZCbUFVRXpVTS9BcDhCUXJtTGRGcHYyb1lp?=
 =?utf-8?B?QjhWMzlSbGhydkZCN3ZjYWZ1dldhVzEwcC9CWkMrSzRLZnFUNzNKWVNOWnB5?=
 =?utf-8?B?anNWd25ZWHd3OXp5TXl4NlFKQkltQ2xMVkVzY2RIeE1RcG1NVUZyK0d5Zy8y?=
 =?utf-8?B?bFpkZEJ5ZEdFS1p4ZUduNEpxLy9KU09zeVJyRlhXY1MvNjJpUkJGb3QwOUJ3?=
 =?utf-8?B?UVpxOUI0WnNVZmlBZVp6SG5sTDl1eUdwZDVMQTFOWVlRalp1TlNjSXh5K2Nm?=
 =?utf-8?B?MkFQSVExOW1UMitvTDFGOU5jTjk1dndHVGNmOG04MEU3UFpqR1RFWC9NUTNV?=
 =?utf-8?B?YURySWsvdThGYWhMajNJQmFLNW5kYW40cTIybXI4T1JLVFZ5MmxPaU1uS0Vh?=
 =?utf-8?B?T3NqbHUzTlQzN1l3Sk1FVjRJZmZzbjZhV0RXdk5OczNQZ05kU2VpNzV3bFgy?=
 =?utf-8?B?bnU1SmNhWkJTU09uOStMYlI3a3k1dFMybWNrcEdLWWZLcWE2NHQyRVRuS0tR?=
 =?utf-8?B?RVRmNnN3am5sQm1UOFZtTzJaSGRrRzM1TFlPZGVSZUVFb25TYTliV3lWUnFK?=
 =?utf-8?B?MWdtaUI4a3hGc2lrYm1lZ05INklEVmNQSmpoelVYamhpZXdJaTZodHIvUWhQ?=
 =?utf-8?B?ck9BY3BaZmc5ZUF2UGlwWDJXaFgzNG5jT3VGNUEyVXRyeS9FVHRHMS8vdlpx?=
 =?utf-8?B?TTFXMzlFcDYzRzRnMmRIeVJxa1Q1OVZGUlZFRkw4V05BbHVDY1pzaDhpNkFo?=
 =?utf-8?B?SEtQcHRMRkwxa0ZaR29raVcyQVFnOWtTazMzTkk2K0JPa1NZclhRcE5lMkht?=
 =?utf-8?B?dmNxWDFQK21rU2hqaHJUUnJVeENaOXV0R1QvdlZsTUZoUDlySmg5QjJNYU9a?=
 =?utf-8?B?SUpBaWJxeHlnbm5JdVlDSVNTdldDeEdlblFDV3JBaE5EM2hOVldmck10LzVE?=
 =?utf-8?B?WTVLM0M4dEFyUkxJYjFjSmRUeitpazllcklXZjJYdjNHOGtKbXB3VEZvL202?=
 =?utf-8?B?UmV2bFBUVlFlOWF1TCtJVzhqUllsYlo1aW9rUDk1UTY4b2h3d09mM1h2VVdD?=
 =?utf-8?B?cEdzeGE3TVRuaVZTL25RMDNPQWUwck9CSFFMdW9wUkRpNW9GNHMzSDZHTVJm?=
 =?utf-8?B?UFF0NHdsSTdEU0drYkJ3RnRHdVhHUlkwQk4yV1dUWldIY1VvR0hlUytrNmFm?=
 =?utf-8?B?Mmg1bnF2S2tFc3kwN3FKdlVWeTM3UWdJZmIrMTNBRklteVB4YVhaUzMvbEdW?=
 =?utf-8?B?NGhSeVkwREZvR1pMQmR2TlpMWk5yNXlsRlhZYjhrYTlPTjZqSjFpSW5xZEpw?=
 =?utf-8?Q?msz68vLWd6FHa8QUvbrr6ep9R8Shh3KpvVekFmC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a1b590-fdaa-4d53-bbf6-08d8f0841bbc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 18:22:26.8685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mSHdAhrErom24ztz7qCGPr3NWPDN0nyjY/DRMLMyTxFtw4D5S0Q3HQ212sZaTqPaQC/BjTcXIiCZG7+nsvOYfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/26/21 10:42 AM, Brijesh Singh wrote:
> On 3/26/21 9:30 AM, Borislav Petkov wrote:
>> On Wed, Mar 24, 2021 at 11:44:14AM -0500, Brijesh Singh wrote:
>>>  arch/x86/include/asm/sev-snp.h | 52 ++++++++++++++++++++++++++++++++++
>> Hmm, a separate header.
>>
>> Yeah, I know we did sev-es.h but I think it all should be in a single
>> sev.h which contains all AMD-specific memory encryption declarations.
>> It's not like it is going to be huge or so, by the looks of how big
>> sev-es.h is.
>>
>> Or is there a particular need to have a separate snp header?
>>
>> If not, please do a pre-patch which renames sev-es.h to sev.h and then
>> add the SNP stuff to it.
>
> There is no strong reason for a separate sev-snp.h. I will add a
> pre-patch to rename sev-es.h to sev.h and add SNP stuff to it.


Should I do the same for the sev-es.c ? Currently, I am keeping all the
SEV-SNP specific changes in sev-snp.{c,h}. After a rename of
sev-es.{c,h} from both the arch/x86/kernel and arch-x86/boot/compressed
I can add the SNP specific stuff to it.

Thoughts ?

>
>>>  1 file changed, 52 insertions(+)
>>>  create mode 100644 arch/x86/include/asm/sev-snp.h
>>>
>>> diff --git a/arch/x86/include/asm/sev-snp.h b/arch/x86/include/asm/sev-snp.h
>>> new file mode 100644
>>> index 000000000000..5a6d1367cab7
>>> --- /dev/null
>>> +++ b/arch/x86/include/asm/sev-snp.h
>>> @@ -0,0 +1,52 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +/*
>>> + * AMD SEV Secure Nested Paging Support
>>> + *
>>> + * Copyright (C) 2021 Advanced Micro Devices, Inc.
>>> + *
>>> + * Author: Brijesh Singh <brijesh.singh@amd.com>
>>> + */
>>> +
>>> +#ifndef __ASM_SECURE_NESTED_PAGING_H
>>> +#define __ASM_SECURE_NESTED_PAGING_H
>>> +
>>> +#ifndef __ASSEMBLY__
>>> +#include <asm/irqflags.h> /* native_save_fl() */
>> Where is that used? Looks like leftovers.
>
> Initially I was thinking to use the native_save_fl() to read the rFlags
> but then realized that what if rFlags get changed between the call to
> pvalidate instruction and native_save_fl(). I will remove this header
> inclusion. Thank you for pointing.
>
>>> +
>>> +/* Return code of __pvalidate */
>>> +#define PVALIDATE_SUCCESS		0
>>> +#define PVALIDATE_FAIL_INPUT		1
>>> +#define PVALIDATE_FAIL_SIZEMISMATCH	6
>>> +
>>> +/* RMP page size */
>>> +#define RMP_PG_SIZE_2M			1
>>> +#define RMP_PG_SIZE_4K			0
>>> +
>>> +#ifdef CONFIG_AMD_MEM_ENCRYPT
>>> +static inline int __pvalidate(unsigned long vaddr, int rmp_psize, int validate,
>> Why the "__" prefix?
> I was trying to adhere to existing functions which uses a direct
> instruction opcode. Most of those function have "__" prefix (e.g
> __mwait, __tpause, ..).
>
> Should I drop the __prefix ?
>
>  
>
>>> +			      unsigned long *rflags)
>>> +{
>>> +	unsigned long flags;
>>> +	int rc;
>>> +
>>> +	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFF\n\t"
>>> +		     "pushf; pop %0\n\t"
>> Ewww, PUSHF is expensive.
>>
>>> +		     : "=rm"(flags), "=a"(rc)
>>> +		     : "a"(vaddr), "c"(rmp_psize), "d"(validate)
>>> +		     : "memory", "cc");
>>> +
>>> +	*rflags = flags;
>>> +	return rc;
>> Hmm, rc *and* rflags. Manual says "Upon completion, a return code is
>> stored in EAX. rFLAGS bits OF, ZF, AF, PF and SF are set based on this
>> return code."
>>
>> So what exactly does that mean and is the return code duplicated in
>> rFLAGS?
>
> It's not duplicate error code. The EAX returns an actual error code. The
> rFlags contains additional information. We want both the codes available
> to the caller so that it can make a proper decision.
>
> e.g.
>
> 1. A callers validate an address 0x1000. The instruction validated it
> and return success.
>
> 2. Caller asked to validate the same address again. The instruction will
> return success but since the address was validated before hence
> rFlags.CF will be set to indicate that PVALIDATE instruction did not
> made any change in the RMP table.
>
>> If so, can you return a single value which has everything you need to
>> know?
>>
>> I see that you're using the retval only for the carry flag to check
>> whether the page has already been validated so I think you could define
>> a set of return value defines from that function which callers can
>> check.
>
> You are correct that currently I am using only carry flag. So far we
> don't need other flags. What do you think about something like this:
>
> * Add a new user defined error code
>
>  #define PVALIDATE_FAIL_NOUPDATE        255 /* The error is returned if
> rFlags.CF set */
>
> * Remove the rFlags parameters from the __pvalidate()
>
> * Update the __pvalidate to check the rFlags.CF and if set then return
> the new user-defined error code.
>
>
>> And looking above again, you do have PVALIDATE_* defines except that
>> nothing's using them. Use them please.
> Actually the later patches does make use of the error codes (e.g
> SIZEMISMATCH). The caller should check the error code value and can take
> an action to resolve them. e.g a sizemismatch is seen then it can use
> the lower page level for the validation etc.
>
>
>> Also, for how to do condition code checks properly, see how the
>> CC_SET/CC_OUT macros are used.
>
> I will look into it. thanks.
>
>
>>> +}
>>> +
>>> +#else	/* !CONFIG_AMD_MEM_ENCRYPT */
>> This else-ifdeffery can go too if you move the ifdeffery inside the
>> function:
>>
>> static inline int __pvalidate(unsigned long vaddr, int rmp_psize, int validate,
>> {
>> 	int rc = 0;
>>
>> #fidef CONFIG_AMD_MEM_ENCRYPT
>>
>> 	...
>>
>> #endif
>>
>> 	return rc;
>> }
>
> Noted. thanks
>
>
>> Thx.
>>

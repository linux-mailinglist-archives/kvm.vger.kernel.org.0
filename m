Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1C934ABBC
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 16:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhCZPne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 11:43:34 -0400
Received: from mail-bn7nam10on2060.outbound.protection.outlook.com ([40.107.92.60]:4961
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230391AbhCZPnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 11:43:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wn5P1nqNS6MoBBIYmK+xv0z3Em4qEdePb5J1G7II7MTsOp95DYCBuSi9e7o3uqgQPj+Cn16D/0LdSqz4wcKZXV2STnqqRUrn3xHhst/Fx0TutNYWvq77W00BjvGhjq6quOjijzgF5ijR2pG3943hEj9390iLcL5eMUVKIIxaZbjoCoBO57d4sXLOKwvuVUUXDrr3FcKxCp98J9cLgQYEfqrFG9ZfLmXyO+V3v9saRJG/AtPcRUYJmrTHjBOrO8noJplcYcRN5T/vQCF6XxB2i+7nRGgGGdcDb652DW1tR915ETHhabBmY2OQKTpq1t6MjzoRgLCFYyLSqz5zTh5TMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nb1wqx2T2hLTnwKDegSqEQ50xdEAQVWPyZT3MTlkF7k=;
 b=g6mDXQrBCJKRxFBxiH1LeQJDuEpfNMSAqXXZ5mfV3YLZrscQ5XE6dKYC5glDsDn/wu2kHmylqpn01nFJG4sWD5tgfJmvj8c2icG3imdAdlehH0hxaeTqAW1f7sWQuQHwa3iQqiLEVL3u9SqXcxiK0OQR6J3xzhLzf7AkXa/seUzF+AEIccRiA6y6u48gNJ9L5CD7lLd2Fqb5VMHwBIK52NrlgPdnB9Kp0TIisV9a9tNXRvwQ9edPnU210MS/xKXXHIXWcw1tj43VLG1XC5ETZONo2wDve5eMACNB8JvE7yh7RbjMuphV5Mmo54mqkbq3WMqdEwlUYFd9Wv1A/1pl6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nb1wqx2T2hLTnwKDegSqEQ50xdEAQVWPyZT3MTlkF7k=;
 b=sOAY4DH5aWGsbwvNCnhPXogEcNFLsBil5X2qtFmEyUmo7l6jcj+p5pJwNRCtpa60KUje4Y4FJW+BcqEGMTnE/tCb1AN30AXzx/jBypoxmUsvCJamAcUSkUmrFvOnCW/x1Uc6PTUhd0cVf34SmdP4P10jKf9RBZEQxY0oKPyNxmc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2365.namprd12.prod.outlook.com (2603:10b6:802:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 26 Mar
 2021 15:42:58 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Fri, 26 Mar 2021
 15:42:58 +0000
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
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <9c9773d1-c494-2dfe-cd2a-95e3cfdfa09f@amd.com>
Date:   Fri, 26 Mar 2021 10:42:56 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <20210326143026.GB27507@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN6PR04CA0096.namprd04.prod.outlook.com
 (2603:10b6:805:f2::37) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR04CA0096.namprd04.prod.outlook.com (2603:10b6:805:f2::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Fri, 26 Mar 2021 15:42:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: efd7e5d5-2af3-45b2-598f-08d8f06dd481
X-MS-TrafficTypeDiagnostic: SN1PR12MB2365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2365565CBBF8639F34BD16D6E5619@SN1PR12MB2365.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o3EJna8TxI2X37u/fCwJfmBXnlshu+Fhu2iyDSXzvx/yuYVglkxaYffnrrLMWjE4SdLYYsl1mJY7pJhin7zr3nqeTmAu+mE5brU2Tx7Hxxo2SREfYgm/qX7uOXYf5WJ1urM/SI+8bU2Jpkwo/fnKelaWn0zt4Queynil7EV3YrXAkIAwp0ckTzgULBr+ir4NSn1CVbe9yrLgjDi0WFdi72aG4tA+Z1luwcdgIocQlZ9XEhnZITM9xCmpC1p6dehDKklOX2Gz2zxvWmh2vIpcTpaBFL2gJkkbMTy/iCbrnIN1R/520wndQTNPYQcW1Y3C0lBRjpwuGNwsq42j+HKLuml/MDgmE092iXMjR4mA5Kz/A2Yxdr5EYlxSk/HR8+VyvLF72UD+nWF84eqJWvvgKJB+VkZ6lrQ3QpGiIVP77h1yYBcGS9gkKpgfthH7p2f/HfGY6w23R8xFTr7vu1LXXuW30HRuvfJ57qFdkJLVEKs4NC3emZ3yPddlBcxQ5iX4nlQVi8KgaxqUCgB2tD+VYNHzDH+kDCZnUTTVOBtIws4Y18fCKD1MwYwnHY781Jf5FVTxjNAzBlp9kGwNOoOGklz8yt+9GfF3f5jydTfQ8mY52y9w2RqEeP5EuVroaZfJwPFQs4u+rfbiI5KdN3pN5fyaILE/THC6trCh7ukFy3mpni6cBs0emAwCDN/M5jjDdTzM+R944jk+6VSn42/rlz5YABnTHiJ8G+HR7K4Vxik=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(44832011)(66476007)(956004)(8676002)(4326008)(66946007)(5660300002)(52116002)(2616005)(66556008)(7416002)(6916009)(54906003)(83380400001)(36756003)(6512007)(16526019)(478600001)(31686004)(53546011)(86362001)(8936002)(316002)(6486002)(186003)(31696002)(38100700001)(6506007)(26005)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?blBBOFZ3ODBUYUNFUXNrbkk1bXY5cThnK0VhRitKdWY1MzAxL0g3aDZIcElU?=
 =?utf-8?B?cllwVVVCQ0JnM0Q1STBBckd6QW4wdzFuV0l1cXU5TktFQThvQVFlMGlUVUFS?=
 =?utf-8?B?Y1R6bTNkSUV6SjZldHdlN2xSYzh1a1Y5VEQvS01zMDBHY0lZVnIxeVlKOE0z?=
 =?utf-8?B?NGlMOWZwYThpQWYydmduNHlDMklCWUk0MEg2NFBwajBwZ1d3OUwzNlZwVjM3?=
 =?utf-8?B?WlZzTmRucEFaN1hSdDZBNDFERXR6UkZ5a3lRdWR6TnVmTkZtTkRIdkdRb2Vx?=
 =?utf-8?B?aUhqZ3BJSmZqZ2xxais2M1ROdzZuOHlKTjBpK3FnTGFwVllZTElUZUtPUFB1?=
 =?utf-8?B?TzlkMmthR2tXdHhFN2ZvZDNjOWlNaVdZMFd1VFB4Z0pzeEFwd3BwWDJRNVYr?=
 =?utf-8?B?NWg0MXRFNktZd24xZ29RaXhxa1ZZR09IZG90eVhIY29INUxyUWNhd0lSVjZZ?=
 =?utf-8?B?NXVOUG1MTkh4ckpmV2FabmZDeThzQzBqMFF3SHJpQUhtenh1THU0U2tXRkVG?=
 =?utf-8?B?Z0x6VTZaZ1hCVGFxVjlNTEw1Mi9PTWEyMFlTeUovTTg1UldjNjBDWnpsWmFS?=
 =?utf-8?B?Q2VQVktUdmtYd29sZloxaEpyYTJWM0RzUmJTa294bHdSWVlIdWlRdGhRRG1a?=
 =?utf-8?B?NUtWMUV6NTYxUnVOeDRuN3R4RW4rc0h6azZ4cmM4ZVNDUDZ2cFV5bzdNMmRj?=
 =?utf-8?B?emE4RllJSFdIS1YxdjdNYlpNalJlNWJldCtiWWQyNlZvc3d2WW5FcWhnazZ3?=
 =?utf-8?B?bFZ2bjVsenZ6V0twaFJ0dTY2VzY1UEhsWDJlZ21iaDFrblAvQ0VGS0pISU9t?=
 =?utf-8?B?anFNckRUR0laVXVOTXpzVVNnTWhka01kaElTSnVTVERRdmVONmc1cEp6ZlM0?=
 =?utf-8?B?elVEZEZ0Zys4enQzbXVQVzZRNFA4RG9waGJZRnFNWWp3dytLRzhFd3hHRWds?=
 =?utf-8?B?c2k0YUlEcjI1ODBBM3lSTmFpZUF3NmZRYUM1SUlKYjR2ajNZbURYYXVCbU84?=
 =?utf-8?B?bFZVbnpya1ZNQytqSUQveFYwYVg3NmZNY1JVT0JwYjBSL3QwVEVYb1BzWGU3?=
 =?utf-8?B?K1Vxbm1TT212Nk0xS1JLVm9pbnVvdXUxdnBvR2VKbnFMWTVWeVp1QkJrQnpw?=
 =?utf-8?B?U3BQUXVsaHQrZXpGZGw1N0d4R2k2SkRTVmVDeTBpanVDUTk4WWZjckZiV0Z4?=
 =?utf-8?B?R2JWc2lSY3orY0E0ZGN6bVJlQWtFVXlSNDRoY2piMnhDbWNBWm43NlNrdTBx?=
 =?utf-8?B?Yk1mcUZOem1VdzZ5L3FaU1Bkd1VNR2sxNkpMeDMzekkyNkp3dFF5WXlocjRo?=
 =?utf-8?B?K3UrQ1gzNzlKdnYvTVVMaThUM2NNYncxK3ZYNXVZcm5uZ2YxKy9Dbjc3dWYv?=
 =?utf-8?B?azZBQk9ZRVZVcjVFUnJlSWMzeTl3eDk0OEZLN1VWSGZQK1owRER4Mmh2RUhZ?=
 =?utf-8?B?WGl4WDEyMFpieVhDY3hHR3J3YndiWUNnNS9lS0xJSEhzTU4xaHM1OTE5cytj?=
 =?utf-8?B?QTd4bkdUUFREb0FrbDBkZXpRUWxqVHp3SEp0clQrL2xYU3ZhUlJkd0pPRUk5?=
 =?utf-8?B?QTdBSHpLS2pOZEZlSktpNHp6L28vdEVrN2hVSW9NMytJQllQbEVJZVh2ZmI5?=
 =?utf-8?B?a2hFdGJBbitHUWZGN21mc0F2TVhadThFVUtUT2xpNlV0dFIyZGNBQ0NDcDFS?=
 =?utf-8?B?UDZ1Yk1hcU5kdHFWWU9wNGNDcTRUS29Xd053NVpwa3JZcUdMVWFXVUVyRmZw?=
 =?utf-8?Q?eIr+ZDIZ0StIh84Tc8dvGxB9bvFvp5FNDanLAzE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd7e5d5-2af3-45b2-598f-08d8f06dd481
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 15:42:58.3161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /28G6c+RcqvkbAh1CTiVJToB2GI+bCwSMz8GB7b8P1JvK2hociWvwE1ZByr3Ho8PR1L68BWuK89aQKx3ZeuK6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2365
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/26/21 9:30 AM, Borislav Petkov wrote:
> On Wed, Mar 24, 2021 at 11:44:14AM -0500, Brijesh Singh wrote:
>>  arch/x86/include/asm/sev-snp.h | 52 ++++++++++++++++++++++++++++++++++
> Hmm, a separate header.
>
> Yeah, I know we did sev-es.h but I think it all should be in a single
> sev.h which contains all AMD-specific memory encryption declarations.
> It's not like it is going to be huge or so, by the looks of how big
> sev-es.h is.
>
> Or is there a particular need to have a separate snp header?
>
> If not, please do a pre-patch which renames sev-es.h to sev.h and then
> add the SNP stuff to it.


There is no strong reason for a separate sev-snp.h. I will add a
pre-patch to rename sev-es.h to sev.h and add SNP stuff to it.


>
>>  1 file changed, 52 insertions(+)
>>  create mode 100644 arch/x86/include/asm/sev-snp.h
>>
>> diff --git a/arch/x86/include/asm/sev-snp.h b/arch/x86/include/asm/sev-snp.h
>> new file mode 100644
>> index 000000000000..5a6d1367cab7
>> --- /dev/null
>> +++ b/arch/x86/include/asm/sev-snp.h
>> @@ -0,0 +1,52 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * AMD SEV Secure Nested Paging Support
>> + *
>> + * Copyright (C) 2021 Advanced Micro Devices, Inc.
>> + *
>> + * Author: Brijesh Singh <brijesh.singh@amd.com>
>> + */
>> +
>> +#ifndef __ASM_SECURE_NESTED_PAGING_H
>> +#define __ASM_SECURE_NESTED_PAGING_H
>> +
>> +#ifndef __ASSEMBLY__
>> +#include <asm/irqflags.h> /* native_save_fl() */
> Where is that used? Looks like leftovers.


Initially I was thinking to use the native_save_fl() to read the rFlags
but then realized that what if rFlags get changed between the call to
pvalidate instruction and native_save_fl(). I will remove this header
inclusion. Thank you for pointing.

>
>> +
>> +/* Return code of __pvalidate */
>> +#define PVALIDATE_SUCCESS		0
>> +#define PVALIDATE_FAIL_INPUT		1
>> +#define PVALIDATE_FAIL_SIZEMISMATCH	6
>> +
>> +/* RMP page size */
>> +#define RMP_PG_SIZE_2M			1
>> +#define RMP_PG_SIZE_4K			0
>> +
>> +#ifdef CONFIG_AMD_MEM_ENCRYPT
>> +static inline int __pvalidate(unsigned long vaddr, int rmp_psize, int validate,
> Why the "__" prefix?

I was trying to adhere to existing functions which uses a direct
instruction opcode. Most of those function have "__" prefix (e.g
__mwait, __tpause, ..).

Should I drop the __prefix ?

 

>
>> +			      unsigned long *rflags)
>> +{
>> +	unsigned long flags;
>> +	int rc;
>> +
>> +	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFF\n\t"
>> +		     "pushf; pop %0\n\t"
> Ewww, PUSHF is expensive.
>
>> +		     : "=rm"(flags), "=a"(rc)
>> +		     : "a"(vaddr), "c"(rmp_psize), "d"(validate)
>> +		     : "memory", "cc");
>> +
>> +	*rflags = flags;
>> +	return rc;
> Hmm, rc *and* rflags. Manual says "Upon completion, a return code is
> stored in EAX. rFLAGS bits OF, ZF, AF, PF and SF are set based on this
> return code."
>
> So what exactly does that mean and is the return code duplicated in
> rFLAGS?


It's not duplicate error code. The EAX returns an actual error code. The
rFlags contains additional information. We want both the codes available
to the caller so that it can make a proper decision.

e.g.

1. A callers validate an address 0x1000. The instruction validated it
and return success.

2. Caller asked to validate the same address again. The instruction will
return success but since the address was validated before hence
rFlags.CF will be set to indicate that PVALIDATE instruction did not
made any change in the RMP table.

> If so, can you return a single value which has everything you need to
> know?
>
> I see that you're using the retval only for the carry flag to check
> whether the page has already been validated so I think you could define
> a set of return value defines from that function which callers can
> check.


You are correct that currently I am using only carry flag. So far we
don't need other flags. What do you think about something like this:

* Add a new user defined error code

 #define PVALIDATE_FAIL_NOUPDATE        255 /* The error is returned if
rFlags.CF set */

* Remove the rFlags parameters from the __pvalidate()

* Update the __pvalidate to check the rFlags.CF and if set then return
the new user-defined error code.


> And looking above again, you do have PVALIDATE_* defines except that
> nothing's using them. Use them please.

Actually the later patches does make use of the error codes (e.g
SIZEMISMATCH). The caller should check the error code value and can take
an action to resolve them. e.g a sizemismatch is seen then it can use
the lower page level for the validation etc.


>
> Also, for how to do condition code checks properly, see how the
> CC_SET/CC_OUT macros are used.


I will look into it. thanks.


>> +}
>> +
>> +#else	/* !CONFIG_AMD_MEM_ENCRYPT */
> This else-ifdeffery can go too if you move the ifdeffery inside the
> function:
>
> static inline int __pvalidate(unsigned long vaddr, int rmp_psize, int validate,
> {
> 	int rc = 0;
>
> #fidef CONFIG_AMD_MEM_ENCRYPT
>
> 	...
>
> #endif
>
> 	return rc;
> }


Noted. thanks


>
> Thx.
>

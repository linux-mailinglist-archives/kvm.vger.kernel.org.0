Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD7442FCEB
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 22:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238559AbhJOUUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 16:20:34 -0400
Received: from mail-dm6nam12on2051.outbound.protection.outlook.com ([40.107.243.51]:23649
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234408AbhJOUUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 16:20:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMugwG4TE7aNk2NlT5tyxWFSnNj45m5a+VqdYbD1rPXjGGg6DbG+TWl4oOigpX6hy8IoIy/+G7HXRNDZWt9xqa/+cqGtsZqJJq1zyhiddu9d/cdvX95go+fhTwJYrBP/7eDysbtZJiVX68j0r5ejhAXqRdgEfdj0QFKUpOm5Zyl5m80B/QpZDEHBIYqcfZ1UsonJBqKK/DDD5n52ySgpoVRre1Nzx/XS9ZczjK5zg/bXPQmIk8BcFeITFhQ+q/xkSrhrqt64NPYXez86xAh/++zo5geGEiDL79GiUWWP6bD9K0aHzb50SJP9yCFUGhAYrCyWO8bthyoVMAaN68DvTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lgaUzbm5yjU/YABuMFY3LciYctTg7ZStrCZVNelewE0=;
 b=Fc8g/nUa9e4GCdmKCqpFmBrelED67bQZ4xO25uiqBtfKlJauAMTqbrkF/sowm8UnWiXcJ73vtdxy5PiiPwY9Sk5WF2zOSo7xHy4Ni5eC5x1amX2LPDa7uWvbgjM94ry0ELleMCUEp/byLMVmbs9VI53jEe+I4B1ovyxiVSIeaMVqR9U0kk/dMpq3kjTMUXkVOgqR2q/ml7bfNhKrH94UMweUE9DRp7e3eL+R6D+kRQwy7ChlBQqBEPyxBl09xfpqSoVlQM66lJcZDTfCvfS4gBImwc01e5SaAJg+fWuPF9yxuzjDsBkwibX2eGPZbCV8vomn1CFVPwXfxJNBgi0vMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lgaUzbm5yjU/YABuMFY3LciYctTg7ZStrCZVNelewE0=;
 b=P/KjNCBjMGgIHFDPnP4yKUfsDGuOqrkwf/PFW4jueNhR2LhtHo2l4PhoNqojrgsJSQccwEaFJSTNJPam1f6ZlORBAuDspgwqlpwWrYX1AUT6CnHbbE1X366S5YX5//Y4MJ7Inb5pd49/EwvMTEiOb2DVOdV1ZuuqhRoShCdpui0=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Fri, 15 Oct
 2021 20:18:22 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4587.032; Fri, 15 Oct 2021
 20:18:22 +0000
Message-ID: <3fc1b403-73a1-cf2e-2990-66d2c1ecdfa3@amd.com>
Date:   Fri, 15 Oct 2021 15:18:19 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 05/45] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-6-brijesh.singh@amd.com> <YWnC++azH3xXrMm6@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
In-Reply-To: <YWnC++azH3xXrMm6@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0140.namprd05.prod.outlook.com
 (2603:10b6:803:2c::18) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.0.0.5] (70.112.153.56) by SN4PR0501CA0140.namprd05.prod.outlook.com (2603:10b6:803:2c::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.8 via Frontend Transport; Fri, 15 Oct 2021 20:18:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c4fc950-7fa6-4082-5637-08d99018efa9
X-MS-TrafficTypeDiagnostic: SN6PR12MB2718:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2718A13DB2DAD2C839C96951E5B99@SN6PR12MB2718.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lGxuF9ReK275sH946uvMYwfEnZG34io/LMHq2aDiTFIvY1hhTzYl7xkJkdXkm9OtXDxLkjzDt8ksJkKD9PiCRxKeAuODY2MHJaRLL0YK5ugqAburRm6jcj1bL5ig8bEwLux5vBzUAjlvlRbJOGomyMXUPlCCf1/TQWizcKZWIjreT2RyBdC7U31odeL2+wH57u8YCi5wm/vtaPf08DawX2olz66pakwvzKmdmKvRxYuhyQB+2pYA+MHlEvl+eam2dM5EyFNyNnngm5aYBYj4/fF93/AeEvmfG5jwYdDBOYYosap4TZuHgtAR5OSKqojoISk+OOgCt2G3AJ443alW4PlqAPoyGFJmIMweI+fQCYnceYBA8LK13inJcp/pPIrg8KLi5DGlDnSBXAQ/0frnyTVaOQZyJ+csxukBOo8YzkHKbEno6JIWpL1/FRPxgPf4cIMH1p81VIZk40oFIJir+KjqwQabafLWUq/gKm2mYgDlL2EsGcy75QZ9EOGDwQz+p/TTnfAelF7nJjMeHLtzXOs38a8nt6OQ93f0Z1yId9cd8eC4yVsmDii5NMRFwtTEyLHwgvSiQoK8IutsXZh7xkobLZ/yJRFDdtOwYKqy6WvM4tcill+dC/SCmKQ/wS77ptVBbpeErCiKBYqBNF5yB6H7X5PIBo01S1to5qQYeLghnAPfOlWTR6TRr4sMUOsK6HO9XmPj8cGV8go/JxRsbiZ3mG1evcIjpE23FzSSJ6zX4RlS+gHBMdSJtVD4lumGwZmS96zK2UHse3erg7vO4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(44832011)(83380400001)(86362001)(54906003)(8936002)(31696002)(38100700002)(508600001)(36756003)(31686004)(66946007)(53546011)(66556008)(66476007)(4326008)(6916009)(956004)(186003)(26005)(8676002)(5660300002)(7406005)(7416002)(2616005)(6486002)(316002)(2906002)(16576012)(43740500002)(45980500001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0ZHeDRNQ01SMTRYckVEaUM2SEpwbXUya3VyYklFMkRBUkswSVFWSlFYMXcr?=
 =?utf-8?B?bFBzTDZOMFFBdmpDeEFTWC9UYjU0RHRUMmFVYzdERytGSlpPSnRhajRxN2NN?=
 =?utf-8?B?R1lKZTllYlY4NXI1bWNKNjNjNnFFWUpVdW5yV1pwcTdhbUN1OWRFV2lyNXY0?=
 =?utf-8?B?akdEZjRzZ1pTTjd3a2xFdDBqQVIvejNHeXZ4dnZ3SDhqZFl6QmZVZ25YRlNa?=
 =?utf-8?B?Uml4NjJkcUpZN0lqeFdlWjRLWXZ6SzJwSGVqSzdpbUdrL2hQNUx4bnBNSDg5?=
 =?utf-8?B?ZFdZL0p1S04zQ3NDVkhrR2F6cVEwMVVKM3lJK0tkQlZ6Qld2WGl3SFJXV2RN?=
 =?utf-8?B?aDYxVWFJcWhzbDJ0RG9QR3UvRDR5NUQ1V2NFK2ErTlBreUlKMlF2cmhoRjlF?=
 =?utf-8?B?bDY0a0s1b3Z0a1Nld2ZBUDhVN0RXRC9tcHF4akZUeWUwV1g5bEpCRE0wSVhY?=
 =?utf-8?B?MXcyT05rSU54T2wzaXZvYkxTSUJDWlVCRUUwdTdRRy9YZFdadVFtL2xuTzh6?=
 =?utf-8?B?d3c2dnNWMXU3a3BaWmtQa3Y4QTRsT0xpNG94T3FibGtQYVI5czIyS1ptczVi?=
 =?utf-8?B?V3NlaDJpcmlqS0orK2IvR0d1b1pVVElYcXV6ajd6YVF6SjE4RXNKUVJUMCty?=
 =?utf-8?B?WXRXbnBjQnlIRzUvOTU1YnZ2V253RjE2UE9rRnlYUE9qMkFyQ0dEeGxxdm5p?=
 =?utf-8?B?VFNJaTNTUnp0amkzVmhPTlZ2RzhwNXNORlFtV2VZWGFMa2VhNlVTYW5oemhv?=
 =?utf-8?B?UjZZT2w4WmF3amJGSkxZemZYUFJmTjY0Ykt3aExmNnZNL21oRjJpVmpaQW9V?=
 =?utf-8?B?UERmVjUwdXBHcnAyMHlhRzUyRWdkcXJ6QlJjS1FTVmw1WDVCb0NRZWg4MUlu?=
 =?utf-8?B?dnUyTVE0ak9seVhIQnhOV1pFYkdsVzNTTUFhVERxSGdrMFlQRXBZa3VnNE5o?=
 =?utf-8?B?SktkM21aRE5FY0x6YnBtRUd5WWVuTS9vazBJU3RBVWRPTUVvbEUyV1VYdnAr?=
 =?utf-8?B?S0JiZkFVaFd3WGM5YStoS01UeGNOTUtsbFN4S2tLUk9zSDZ2SmZsUHViVG9z?=
 =?utf-8?B?NVU0OXNIak9KMUZiSHIwcG9KSHZpNVgxaDZ1bktPSnp1cXYvTVBsQmFDUW1i?=
 =?utf-8?B?cG96K0ppSWtOZ1R3bXJoUGhiOEw0Z0JKNVZZeXFuKzZsYVEvdEwxRkFRekdX?=
 =?utf-8?B?eHpvMUpmamc3dW5vcXU4Q0UwOHRPejBwWXNNdUtqd3BYWEU4ZTJaQThabmZG?=
 =?utf-8?B?bXIwQ1FuU0VEVlJNOC9JRkpnWXZaL3NtbStMZStyOFk5ZkVMWGdEWERTVkp4?=
 =?utf-8?B?MlNqUklYaXY5b3Z1aXZlaUNZTXduSGg2dGhkMmhzUmY2MENoK2RFSUxxZUZx?=
 =?utf-8?B?VmRoTUx6OG5VNVB5citBMWFUdGN1UW9YK2FhNjl4aldscXRrbUw2czdGZUdp?=
 =?utf-8?B?OXV3UEd6MGswbGNYV2JLMStralhuNnBCMXU0R2xaeTQzR0x6T0crTmJhWEJv?=
 =?utf-8?B?Zkx5eVM1ZUovMnNwdmZFeXlSWXVNcFZSWXlOdHhoYjIvZ1NoUkFYRVBWb1ZZ?=
 =?utf-8?B?RkRIYnp3UGU2UTJmYjZWbWZOQWpHaWxPcFBTYkZPZVIzTi90NS84M0NHcXdE?=
 =?utf-8?B?dVBQQWpYRGlWVmw3Nlo5SXZ2T0lvYnNHOG95RVRaS3J3c3N6blBLZks2cUVm?=
 =?utf-8?B?cWRJZGRSdFNOQjZYbytSUDY5NE16MTM0ZFFnS2RpbWVGWkNQbXQ1Y3gzMmNK?=
 =?utf-8?Q?G0JQjBRGR05t6IC9umip5nDeMSp0pBj2eBHLZBt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c4fc950-7fa6-4082-5637-08d99018efa9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 20:18:22.6781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q7TKxFlk6AbzFsRG56Pd0o7MfYgcA5wMsaOBBzxa91afOmbvKwFty0NAWtMUQRhjoPxyNArS53dYfy8USZvw+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2718
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/15/21 1:05 PM, Sean Christopherson wrote:
> On Fri, Aug 20, 2021, Brijesh Singh wrote:
>> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
>> index f383d2a89263..8627c49666c9 100644
>> --- a/arch/x86/kernel/sev.c
>> +++ b/arch/x86/kernel/sev.c
>> @@ -2419,3 +2419,75 @@ int snp_lookup_rmpentry(u64 pfn, int *level)
>>  	return !!rmpentry_assigned(e);
>>  }
>>  EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
>> +
>> +int psmash(u64 pfn)
>> +{
>> +	unsigned long paddr = pfn << PAGE_SHIFT;
> Probably better to use __pfn_to_phys()?

Sure, I can use that instead of direct shift.


>
>> +	int ret;
>> +
>> +	if (!pfn_valid(pfn))
>> +		return -EINVAL;
>> +
>> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> Shouldn't this be a WARN_ON_ONCE()?

Since some of these function are called while handling the PSC so I
tried to avoid using the WARN -- mainly because if the warn_on_panic=1
is set on the host then it will result in the kernel panic.

>
>> +		return -ENXIO;
>> +
>> +	/* Binutils version 2.36 supports the PSMASH mnemonic. */
>> +	asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
>> +		      : "=a"(ret)
>> +		      : "a"(paddr)
>> +		      : "memory", "cc");
>> +
>> +	return ret;
> I don't like returning the raw result from hardware; it's mostly works because
> hardware also uses '0' for success, but it will cause confusion should hardware
> ever set bit 31.  There are also failures that likely should never happen unless
> there's a kernel bug, e.g. I suspect we can do:
>
> 	if (WARN_ON_ONCE(ret == FAIL_INPUT))
> 		return -EINVAL;
> 	if (WARN_ON_ONCE(ret == FAIL_PERMISSION))
> 		return -EPERM;
> 	
> 	....
>
> or if all errors are "impossible"
>
> 	if (WARN_ON_ONCE(ret))
> 		return snp_error_code_to_errno(ret);
>
> FAIL_INUSE and FAIL_OVERLAP also need further discussion.  It's not clear to me
> that two well-behaved callers can't encounter collisions due to the 2mb <=> 4kb
> interactions.  If collisions between well-behaved callers are possible, then this
> helper likely needs some form of serialization.  Either, the concurrency rules
> for RMP access need explicit and lengthy documentation.

I don't think we need to serialize the calls. The hardware acquires the
lock before changing the RMP table, and if another processor tries to
access the same RMP table entry, the hardware will return FAIL_INUSE or
#NPF. The FAIL_INUSE will happen on the RMPUPDATE, whereas the #NPF will
occur if the guest attempts to modify the RMP entry (such as using the
RMPADJUST).

As per the FAIL_OVERLAP is concerns, it's the case where the guest is
asking to create an invalid situation and hardware detects it.  In other
words, it is a guest bug. e.g., the guest issued a PSC to add a page as
2MB and then asked to add the same page (or one of subpage) as a 4K.
Hardware sees the overlap condition and fails to change the state on the
second request.


thanks


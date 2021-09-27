Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CAB419877
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 18:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbhI0QHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 12:07:49 -0400
Received: from mail-dm6nam12on2066.outbound.protection.outlook.com ([40.107.243.66]:57021
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235261AbhI0QHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 12:07:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0CPOGYJwV6tqMBLuZznrWmAiiaJWZszOHaTiPepwlAsG6W3ifH/mMY6T+apBv31tiLSZ1Md81a7liX/q+ddKMGB7KamlbfUkvgDil8OgevS9McdyuL4TsQ30Sg4Udw8+pTAZJGn0jrUKD0ZliDoyGXQ8XxSd0wnrPKNNm7Acym2QbpT0xu7ZYQbxbYqdveJWd2MBtYhWLnkuZOoJgbO5IdpY1Ra8T5PmR4Zd/nYstx5PP++HrDp1k1Zj8q3NJ7qMoZS26b7L9t5Y0bCbptQvIazZonQQvhCsH2+lhVdrqgPrY2i9Ujt2M2WBHGyi59YVGFiBZ8UXTo3q9yT76Gwrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=yNQp2zxWTpmjD4aSI0tZKUaXcUhDCcQYlacdzK7VXn4=;
 b=KlDfQTIr51muSAD8Cdvsi6kRDpagCkXSnI4IiTMG1mOVOlqd2hGcfAPQU2Yqq4USiEaVh6pnM97gRqfpDQUspFJUd2o2LIWrXLsQZEVJf4cRdI3lyUZKvuecG1VVZ2mnDo/ADlXV4X7MbIlY8bWF6cGyuO2JqF07H3w9UBSrnax6kwn8JuOs55V9S0tUoJqKnsFDrZwVkTAoH+Z/OMu5YaqdbbxTktBO44rzBIYyFliaK1fr8b0TIjERSPopNS4rXbgOaXgWuaIiWKoyjB/am7S1ad1CiOTAPstzOteNpeh3rUoSKQ1GgO4/1SpJo2Pn5yOqK+TaKLF+XfoNoID8jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNQp2zxWTpmjD4aSI0tZKUaXcUhDCcQYlacdzK7VXn4=;
 b=cX6EI+xCYrDvEiTJwbvddLSbzn+8REygULmO1nfVmRFWyPHsQHG/U4STf3OPlKHqgOA0Kefq3EdjvBVOAVLD5+elj37xkdSL2YhZnXlMZp7xnWRpDH1CiLJWP18ik116awirH9mzYjLmF9K0mEjyZ1dS0v0gEICQQwPUgnqPRMs=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2637.namprd12.prod.outlook.com (2603:10b6:805:6b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Mon, 27 Sep
 2021 16:06:07 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 16:06:07 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
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
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 05/45] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
To:     Borislav Petkov <bp@alien8.de>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-6-brijesh.singh@amd.com> <YU3a0N2EfZIGP2IR@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <6d6cf467-028c-4754-a39c-e26d0c51428c@amd.com>
Date:   Mon, 27 Sep 2021 11:06:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YU3a0N2EfZIGP2IR@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0018.namprd21.prod.outlook.com
 (2603:10b6:805:106::28) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.30.107] (165.204.77.1) by SN6PR2101CA0018.namprd21.prod.outlook.com (2603:10b6:805:106::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.1 via Frontend Transport; Mon, 27 Sep 2021 16:06:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f56f7a4-8ffa-4532-b7a8-08d981d0b696
X-MS-TrafficTypeDiagnostic: SN6PR12MB2637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2637116496239B10FEB53EA6E5A79@SN6PR12MB2637.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pnes7Y3EkxKNJUoT8IgIWe/KcZwJt9klLyl8k6YmhYfcbnf73tV71TqO0E19L8byes+qfsO3usM4X9Ht3qWfWew3NAZ1HXoW+GDQjYxTFk2Nvv+11iG38nBj9h1t9HyxjrwcNNNu6nvpczcdy8P7j99hdfgpgSqgPbPejDX6SQP4AkbJUhV4Inf1DSwTbYVwz6gt0iPrGUD3ycrU3DZdzZ8MlLRHeXylkcRubetf8QcSdtBcsdmtzimp6HkC5gUyje6TL1P+mS33zUB+qGOawH87wMFXmKa+SFL+O1PBPvfpTxKXhaPRYZdTXprK4WdqGA9MBFpCMKtSo3ZrdmFdxFRm1yctf7pqBfl2mqXT2brNy+pILBz7dsOgE0CD2IP0ntDVkYPAsOpWjBwgH02oCZotCBvw5nUmbIuCKwmebtz874hYOAs9MrtiUW0kXJhppdb/2NtM7d1ISNNhRIYqhYGqbuBno1/ySkRP4sXbLEKqs/BQg8JAtOh8GsRNqttxz2arUYrz32eCCNC+2Z2Dp3xGVAvqs4h/PA4tnQJtjmF8ccoqaV7KQl6QaxARXCqQOMDIHKCihYquUxXHzX4TxpueWS2Q7z19eFRBnY8L5HjK6e5sS6rF3eUVSQO/oPpNp3qRXoXtvhCrSgpGlrCcaU+FsZH45hMIVoBSrQ91l9kRcbObXIBzaNRGj2ZNvJh2YNgfcdkJdgI82Ot7uXGPG62npCP+f6Ssqw2/G54L2/R3MDAxKEu2kbG4ttxB2JADsPIP2gnCxC2mUgH6fTrSEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(7416002)(2616005)(8676002)(956004)(7406005)(4326008)(6486002)(86362001)(2906002)(38350700002)(316002)(16576012)(66556008)(54906003)(66476007)(5660300002)(8936002)(66946007)(38100700002)(44832011)(31696002)(36756003)(186003)(31686004)(26005)(83380400001)(6916009)(53546011)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVc3WXhkRWtRU01UZkluMTFSeUhwYnBWQ0M1SzNldFcyZEU2ZlVMaXc4Q3ZM?=
 =?utf-8?B?VDByY09DazNxNFV2RVRjWGRFallxc2xkRmwyYWpuaFZaYVhOUEtvNjNSd0dP?=
 =?utf-8?B?STVaa1kvZ3dRM3ROZ3BHT2dqRFJyRHVRVWZBdWM5enJScjVuZlpvTmJhRm15?=
 =?utf-8?B?WE5mZmlkUXBlUnQzTWdpV3JhTEVXMzJBTUN6RTJ6Vlo4eFJWMnBWWGJ0MDNk?=
 =?utf-8?B?OWcyTXpDdFNVWmV1eVhxUHJUTjkzTFlKekE0YTRmaGJUWUdXMW5sRTVqeFFo?=
 =?utf-8?B?R0QrZDhlZSt6bXExa2lMcCtrYlpkSjZ6NFZIOVBzVm1WK2RBbEtBVE9XeThu?=
 =?utf-8?B?c1Ztemw5b25ScXdoYmtQZUE2ZFJoOE0wcm9mTXRyT0dMdS9RVU1xL3I3SG9r?=
 =?utf-8?B?dVZsSmsxYzdtbDJYYjI4RUE5ZkE4RUI4MjdTV3MxZURZcXBhdXhqR3JuekpF?=
 =?utf-8?B?S0JPWmtoaEtFWDkwVGhTY1R6R05qYnFuSmxEUGdoMnJIM3Z5dkVZYW5DMGtz?=
 =?utf-8?B?eXFPRXRPSUdSNzNtSFBZOGFVaGJZNWlTSXlNRXN5WkU1VzRHeEVVQjk4V3VH?=
 =?utf-8?B?UUdxOVlmNHEwMituN2RGSnpXa3RqMlhYRGkyU3RhNkNiRUlqOEp1a0kvMUd0?=
 =?utf-8?B?MUJCWEM1SXkrVy9QaVRrV0kvRUJwZ1JieWZ0Rm5zemZSNHlOYjE0R1JlU1J3?=
 =?utf-8?B?aXVhSEs0YXd5STl1OWh2SlJXQlNyQjRSLzE3Qnc4bTVBbjd3RUk3azRLRzAv?=
 =?utf-8?B?WkgzeUZyRWo1TVRKTkJFZEdDWkVRTVpEaWZFK0xNdDlhekNtSURvZ2lzbzJs?=
 =?utf-8?B?eHc4Z2w2RlJaRnNPOUsyUXM3S2hGRFl6VTNvY2htRlg0VTd1MWU0LzZ2TFMz?=
 =?utf-8?B?dmp4T2NucXJ1M3NCTW1jb1owRjBFbWtYUUxHdGduT1F0Zjhrb0dDcVVkLzli?=
 =?utf-8?B?c3lJa1JDMm9jTGVWKzB4RDMxWlBvUE1BOUdpaXUwcjBkMmY2MlR4NXNBYlp6?=
 =?utf-8?B?U3pSbHkvZG0yVUZtTjE5cTZJMmR6c3M4a0dsRXJIamZpc2IzcjRkdnVEZGVq?=
 =?utf-8?B?OUZySTVZODdOTWJvVytKSXY1cHNlZDh4bjM4ckcyZGxSTHFkd3RrT3FnTFk2?=
 =?utf-8?B?QnNwN25WV3RCYmYwNDRKRExUdStlZlZBZk5hSVZaY2hWRTZjRXY5ZTROYTJu?=
 =?utf-8?B?dFFnSzhrS2J0Vks3aGtGa0RrS1dKUjlVSU16QWdmTWdZMGsyeWpkcVVqRzZJ?=
 =?utf-8?B?dEp3cVZqSXhEMEEwbS9MdXkrbGdyR0hBYy9wV3Fyc05tczUrZ0R0ZWtmWTd3?=
 =?utf-8?B?NE9lWm1ZWDU2dWVPYnNsVU5XWkN1VFM0ZHpJOEdMZ2U5QzNaQkVnNm12TVNH?=
 =?utf-8?B?ZDFETUlFcXdtY0Jkd0gxZEFZd1Noa0VxTHBaVFpUT2tvTDZTbk9iZVVPNjY2?=
 =?utf-8?B?SnlVN1dBQXQ2WVgrdXlWejJoUHduQy9nT2l6MkZpSXZ6UStxU1ZrdGdaQ3J2?=
 =?utf-8?B?Y29LYWh5ZEVrQlFLbXJWOE80S1gwYm9LTkE0bmU4bndnQ3cyTFZQN3oreVZn?=
 =?utf-8?B?VmJqWHp1KzJkMExzTUErSHNqRTJUaE81ZVMycEN5YlIvQVNsV1luVVQ1UHIz?=
 =?utf-8?B?R2VmNXBETmZFSXVwUzhjbldsWnpKSkg4Zy8xNmgxODYyRjZPcC9CUVY5Mjg4?=
 =?utf-8?B?Vi9RMVJEaW8zZU1WV0VZQ2dBN0xtNUhjUjZwQnFqUDZDYVpSbWQ4N2o3eUVo?=
 =?utf-8?Q?WE2CtS/1WRu/w+wDgbn+w2kYhDjbHemxxJuuGnK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f56f7a4-8ffa-4532-b7a8-08d981d0b696
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 16:06:06.8705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1dvwKFdBLWOQpVO2+N0rvDU5DC99nZ8grOwHaDRU9gC8IrCbXTgzy0N4ofN60ldKY47ARGqhhNlYGzYoujGfxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2637
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/24/21 9:04 AM, Borislav Petkov wrote:
> On Fri, Aug 20, 2021 at 10:58:38AM -0500, Brijesh Singh wrote:
>> The RMPUPDATE instruction writes a new RMP entry in the RMP Table. The
>> hypervisor will use the instruction to add pages to the RMP table. See
>> APM3 for details on the instruction operations.
>>
>> The PSMASH instruction expands a 2MB RMP entry into a corresponding set of
>> contiguous 4KB-Page RMP entries. The hypervisor will use this instruction
>> to adjust the RMP entry without invalidating the previous RMP entry.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>   arch/x86/include/asm/sev.h | 11 ++++++
>>   arch/x86/kernel/sev.c      | 72 ++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 83 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index 5b1a6a075c47..92ced9626e95 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -78,7 +78,9 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>>   
>>   /* RMP page size */
>>   #define RMP_PG_SIZE_4K			0
>> +#define RMP_PG_SIZE_2M			1
>>   #define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
>> +#define X86_TO_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
>>   
>>   /*
>>    * The RMP entry format is not architectural. The format is defined in PPR
>> @@ -107,6 +109,15 @@ struct __packed rmpentry {
>>   
>>   #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
>>   
>> +struct rmpupdate {
> 
> Function is called the same way - maybe this should be called
> rmpupdate_desc or so.

Noted.


>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(psmash);
> 
> That's for kvm?

Yes.

...

>> +EXPORT_SYMBOL_GPL(rmp_make_shared);
> 
> Both exports for kvm I assume?

yes, both KVM and CCP drivers need them.

thanks

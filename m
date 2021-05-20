Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49AD38B562
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 19:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbhETRqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 13:46:17 -0400
Received: from mail-mw2nam12on2068.outbound.protection.outlook.com ([40.107.244.68]:7040
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231752AbhETRqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 13:46:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IaUFEPGhmhhMd8ErOwZlFBZS33w/iiGsCObGHu8xGcsgT7pwULhRifydGAA+igFlK/nwos3pTAdIID2IUrKeDObzfJx+xCYSYJAZI1qPvKrRIYkYmEGwNmE7anyezpwAXWZ5W2+Fgubcv66tm0kpPEpWopJsFxY6Od9iQmfQwwmAKDiPPFR7lzlRanZmwcA3KD+haCI0QhblQAVrUy8T3iJ5+ncHudeK+R1BcaOus0cLGcrs4KFkX3WQC6b3VhH5OqdeaFh8n8rze+Ie5teTyYZnidMFnndilB10V3HrJQhhQCXwCCIdFvCu7C9l3oQVylfZwauTPKya/STulgIJCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZA8ILSRDxHl0h94OeVwratOEeoVAiQdHthdfDb+KOw=;
 b=SXQnNsNl18A+zTR2VD1Onc65ASkS33OhQV1bHt4O0MIlnbxRXFz0f1R6KKHy8jYf542mOnAm3RnJtlzt59ovWS+xNIFplFSDrnzblGifAXA6fBT2hg4AwWxzCGPoARPzUSRGhbTeaYcJj0xyxnpQTHBg3TVFMlKL5ugXHgspyP7JMcof/pyy+kAWelHgw0g8ho432AopNRNA9Oatv+pvmvRUZeqV8WVISuTmGq039Esr0dg4rv4FCLPHg+JO/PfG0NdET/x7+a7VK+LHzK/1vxNJKVmjCMoCF+alonrXuwFsa2N5G1f34DTQk7pLkoIfdUq8lVPyFcA0GBOfC2t3OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZA8ILSRDxHl0h94OeVwratOEeoVAiQdHthdfDb+KOw=;
 b=ZYIWSS8Prz99ThDfXdu6PdstNTlGG8KQRaSB45KSZEPbNjZJpGm00Z8ZfmDpsdcHTqmE0tG9q5K0qwwUcriOkHZdvRSKlLVJ9/JuaKouGsxWgd/R7SApYh8P7rs1ETy5hU5q6pe/mxe+MQ5SpHBNMjO1kfgdC1QwEWW89doFRQs=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4429.namprd12.prod.outlook.com (2603:10b6:806:73::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Thu, 20 May
 2021 17:44:53 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4150.023; Thu, 20 May 2021
 17:44:53 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 10/20] x86/sev: Add a helper for the
 PVALIDATE instruction
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-11-brijesh.singh@amd.com>
 <4ecbed35-aca4-9e30-22d0-f5c46b67b70a@amd.com> <YKadOnfjaeffKwav@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <8e7f0a86-55e3-2974-75d6-50228ea179b3@amd.com>
Date:   Thu, 20 May 2021 12:44:50 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YKadOnfjaeffKwav@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA0PR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:806:d2::33) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA0PR11CA0088.namprd11.prod.outlook.com (2603:10b6:806:d2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Thu, 20 May 2021 17:44:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97e12fe7-7289-4fe1-bb8e-08d91bb6f93d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB442919C9D3484CA1B3AD23EAE52A9@SA0PR12MB4429.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gWdh4EVd4B1omrRttLLnEJUe0uW/wGl0CgJZ1FJ+WsqZ+b7nD4HiwtT+kRqLgjI2WNSlWhRFvcB/MX5EtRbIsdNQhoNYOaHJWAz2KDQyFyioHn7rIZg3GRI4X9aqFSrWZdKRLbGh+xcX3ygwtZzbcsoOt5WWGboaP2BHq3sbpSUqLmTBcL0XGT9vImE3vWaxd4Vjr5OELr4nomeO40LU80NfgZvaaQ8tDohu+dedd+F5ONgVRDDW8BX/EXOkXqEfWDBZpdrcQ5MijbYN/rCheRLlgKUC4i5aISE0Ek84P8MU7+qGu9GhMWOhyNKyj+Du3PHg8IMAleIpfFBQ9zJ37pe5yThUS2c5yHJh2KwoPAB16D33q87YItZMudu8yvMYfDEIbr2VzJR06KAfq0YOlEZ9kJhlouqSfxyhzLE7WDnALipGH/IFkKP0pFvdfzj2gBHkG+E7u1SRYqdj2sMViEjgDuN9HYPwyKVcJJRQzEs+TXOZsvSXtx7rQfY65Xdg9lNtLrJgOmLQ5L/oVWvy9YLcOr+WdM2ufj8VQrjOYnYkbOSaPDMi7KhsOSAuFy5NebUKkJFCqkXOuzlTCFYYQsGcjElvEVZu+CJwBLdyCTOyiM9a+5t/6hMdUeQ8soBq7cMeUDEIAcVkLLNlu+d1eui10ePmt9pIafRaLLVLxaDKclv6wQDPswxxydTWltk30jUvUaiMeja+s8wqoFnoEz/0oNmCnwWX4kyvWA3ZUmQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(136003)(39850400004)(7416002)(44832011)(316002)(8936002)(8676002)(6916009)(86362001)(5660300002)(66946007)(36756003)(2906002)(38350700002)(52116002)(66556008)(478600001)(38100700002)(83380400001)(2616005)(4326008)(31696002)(66476007)(6512007)(6506007)(53546011)(6486002)(186003)(956004)(31686004)(16526019)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UVZKV1ExdXYxWGo3aVBXdXU5TmpVcURwSWhsbWJocFlLTVdyZHhRWWRGaWU0?=
 =?utf-8?B?czJ5Skt4V28rTitDM2d3aDA2V3BuM2lnUVRHSW5wUEt6L3RJdG1wekRjaWFh?=
 =?utf-8?B?RmFwUUNIUWQ1U3AveElTeDhsSTd6UlZLSzZkZnZiemhTTDhmR2M4amlxcnFY?=
 =?utf-8?B?QktTaGE1U2RWRk9wcHVqemEvTXBuOGo5cUFXbHNFVFB6NG1sTy9TTnQ0M1Qy?=
 =?utf-8?B?YklCdmR5NXBhK3Q0VGxSTkIrSGRLSUJKU2ZhMkZPQ3g3eS9kbFR2dTA0MmVN?=
 =?utf-8?B?UzFIdUpGNFVrWjdJa3RwTnJDQm9xZXhxM0U3Tzg5SFUwR3BHR1Q1NENjOWxG?=
 =?utf-8?B?bDZkQzdJanlPQllUaEViZXdIazFHSXJMdmdNQ3NxOFVUWWVESkVQY2thdVU1?=
 =?utf-8?B?bEIxdlVpSm5MbVZzZHdZL0NkQVRzVE1PdWpVOUQ2V1Ardi9uUkZiLzJoWnR0?=
 =?utf-8?B?ZldSaDhVbEpLL1pHdU11RVBUVmNYQ0lNanpJVVlYYmdKQ1NPVGdOL1Z5dC9v?=
 =?utf-8?B?a2huK243MFdkWSsraVNOVE9wSGwwWWNNcmtQc29NSFg5cDNBOGswNWVlM0hx?=
 =?utf-8?B?N2tCQnhmNDBzNzBrdDNEUE5ja0hhMFBoK3B5VEgxeEhQbkdLZFNmNUhkdFMx?=
 =?utf-8?B?dU9vZmxvZnl0TWw4dWtwSkNOZmh0bnRpbjlaaUZVb1pHQmY3N2pRWTBrSFk2?=
 =?utf-8?B?d0JLWmRCRGZwRllPanVWZEx1ZmQ1Sm5ETkNCT2VPZWFqdFlTeFJOaUtGLzF6?=
 =?utf-8?B?Q2R5Z1VwQ2VDb2lhcTlLZkxHK3Q4ZzBzWmRXSEwxNzVISk5PNFp2UWdxZmEr?=
 =?utf-8?B?dXdUcXZYNTljdGhJOWl5VUI4d2p5WmtCcTRNaEw1QmdxcXlvK3BJcEw2NHpF?=
 =?utf-8?B?blZjK1lscjJhOFh3NDZDUTkvVjdPeHQySXFpbWJWVVQ4Zk5WN1VnR0MvNUpV?=
 =?utf-8?B?UEhIVnMrR0VjMGpDVzEzeWhIdWE4aThadFU5aFBYckdwSktKTXJ1eVJNTlkv?=
 =?utf-8?B?VTNlNEkwUGJxR1l6TGdNeHI3UjFVcE1LNHROSytsSS9BRmJ1N1pWK08yYjdt?=
 =?utf-8?B?bHN1Z05RRWl0NXNmQndSNDJlUWJra3NDNGFrMkZlM3ZCWEdIbS83a2R5aTN6?=
 =?utf-8?B?d2Jad25QaURWd1F3UGorTXBpOGlXcU1uL0ZaWGd2VDZmMW85M29lTkZtcGFz?=
 =?utf-8?B?bXE5azkxZks3UE4rSlMyZW96d0hrUzJ1YkNZUEZGa0NrVDJSbGhUL3FKSTNa?=
 =?utf-8?B?Z29WaUQyTlFjNDJHVDlQRUdLZFFtSC9EUnhreHBacjY1UXJmSVl6d2s1ZHJk?=
 =?utf-8?B?VjVHZTkxUUp4UkJmOUtkMVVkQ0s1UFI3NkNNVGUzcWpSZVdHSjJzR2ZtbEVl?=
 =?utf-8?B?SkRVaVBXcWt1OHFscFZsaWp0WUJod25kMnBtZnFHMTQ5cXNLMnZXbEZ2N1lW?=
 =?utf-8?B?Z0NjamdrRHRPaGFNSlhLZmJJaWh0VE1QUDJ0eEFtSWZnZnZIdUdzMnZQY0pu?=
 =?utf-8?B?MUV5U1dydXo4b1RGRW1LVks5akRhTlAzZ1ZrczdzTWl4cTJEb3pmMzZaTUJq?=
 =?utf-8?B?Vy9rQVRuWDBLS05OQkFtenRIWU52aSsvQ2FpTlVNQ1NOTDJUc0gvYVZtSUYr?=
 =?utf-8?B?UmFaV01yU2RMRERuakZSaTFsMjdqMk82S0dldmpaYTBORjlWRWwxRE5sL3Bl?=
 =?utf-8?B?dU5PQU9oYnJrMXh5ZlV4dDFWSVpSazdoejkrQmxaWHM2QVpSU1ZvOU1zaVNU?=
 =?utf-8?Q?yW1grKwK4z5KibGf1sPFbmtENkK/BXLRQUACfBZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97e12fe7-7289-4fe1-bb8e-08d91bb6f93d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 17:44:53.0895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ie05BMeK7g5eFQCuDo2WrFnL+KEtP0hU+Jc7GA9RSmpIiruBAUqq3dtDggI/APUMycaSbhQDQrW6s7Q7Q69qVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4429
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/20/21 12:32 PM, Borislav Petkov wrote:
> On Fri, Apr 30, 2021 at 08:05:36AM -0500, Brijesh Singh wrote:
>> While generating the patches for part1, I accidentally picked the wrong
>> version of this patch.
> Adding the right one...
>
>> Author: Brijesh Singh <brijesh.singh@amd.com>
>> Date:   Thu Apr 29 16:45:36 2021 -0500
>>
>>     x86/sev: Add a helper for the PVALIDATE instruction
>>     
>>     An SNP-active guest uses the PVALIDATE instruction to validate or
>>     rescind the validation of a guest page’s RMP entry. Upon completion,
>>     a return code is stored in EAX and rFLAGS bits are set based on the
>>     return code. If the instruction completed successfully, the CF
>>     indicates if the content of the RMP were changed or not.
>>
>>     See AMD APM Volume 3 for additional details.
>>
>>     Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index 134a7c9d91b6..be67d9c70267 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -59,6 +59,16 @@ extern void vc_no_ghcb(void);
>>  extern void vc_boot_ghcb(void);
>>  extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>>  
>> +/* Return code of pvalidate */
>> +#define PVALIDATE_SUCCESS		0
>> +#define PVALIDATE_FAIL_INPUT		1
>> +#define PVALIDATE_FAIL_SIZEMISMATCH	6
> Those are unused. Remove them pls.

Hmm, I use the SIZEMISMATCH later in the patches. Since I was
introducing the pvalidate in separate patch so decided to define all the
return code.


>> +#define PVALIDATE_FAIL_NOUPDATE		255 /* Software defined (when rFlags.CF = 1) */
> Put the comment above the define pls.

Noted.


>
>> +
>> +/* RMP page size */
>> +#define RMP_PG_SIZE_2M			1
>> +#define RMP_PG_SIZE_4K			0
> Add those when you need them - I see
>
> [PATCH Part2 RFC v2 06/37] x86/sev: Add RMP entry lookup helpers
>
> is moving them to some generic header. No need to add them to this patch
> here.

Noted.


>>  #ifdef CONFIG_AMD_MEM_ENCRYPT
>>  extern struct static_key_false sev_es_enable_key;
>>  extern void __sev_es_ist_enter(struct pt_regs *regs);
>> @@ -81,12 +91,29 @@ static __always_inline void sev_es_nmi_complete(void)
>>  		__sev_es_nmi_complete();
>>  }
>>  extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
>> +static inline int pvalidate(unsigned long vaddr, bool rmp_psize, bool validate)
>> +{
>> +	bool no_rmpupdate;
>> +	int rc;
> Adding this for the mail archives when we find this mail again in the
> future so that I don't have to do binutils git archeology again:
>
> Enablement for the "pvalidate" mnemonic is in binutils commit
> 646cc3e0109e ("Add AMD znver3 processor support"). :-)
>
> Please put over the opcode bytes line:

Noted.


> 	/* "pvalidate" mnemonic support in binutils 2.36 and newer */
>
>> +
>> +	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFF\n\t"
>> +		     CC_SET(c)
>> +		     : CC_OUT(c) (no_rmpupdate), "=a"(rc)
>> +		     : "a"(vaddr), "c"(rmp_psize), "d"(validate)
>> +		     : "memory", "cc");
>> +
>> +	if (no_rmpupdate)
>> +		return PVALIDATE_FAIL_NOUPDATE;
>> +
>> +	return rc;
>> +}
> Thx.
>

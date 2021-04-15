Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788AD3611B1
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 20:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbhDOSIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 14:08:38 -0400
Received: from mail-co1nam11on2079.outbound.protection.outlook.com ([40.107.220.79]:18976
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232759AbhDOSIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 14:08:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=byWJY2e/X4B7UQSTU7pLBibzVhKj7ftEQ/HSsCvpUi2oMWICj2DlXUDbpJS+KdEyVWxX3cwYed1aQxsv2co2fxml+uMVahQGlY6RNYUr/lCXnEIFu/4f2jd/VrEIgx+QYDs5l2L9BQI7E1N2t0grtjbznqYn+GWM905hCL2qph2C02dEgzJOFlPz4PDuAyFtJXJL/Hy1dEBk2o35oFVohs5qGSCMHzEp46w7CYNkOVACKBMk9NPNlw+KmvVbbKczck4HBFSpLNdNLB4gV3yBG0VrKCd2ZxUFNSS34S2KvMaPCj+2jq3FObkyjTHf3ID4YrpzXyG2UDkm34HbG87eIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKJyaGJPzCoXoQNV2bqG9M8AtasFSEphNcmoHv2ERpc=;
 b=hbHtZGf+89YPmCgzf/k/ebKFpksyzA8F9UtESIx83pzbCWFKgzeStEZbVl/MTLJxJSEZ0zkCKKFdLVGwwvD75apCCKk1wR90QebJ49pmzKoXnKsMmRSmtICJ2SferL1CRMmYB9Xlit8UG8tK9IBUDh38HI9f9Ue1rfnaZr9Dg82aqqkqpjvo/PU5KNL4xFOCUq3dIU6AmR1k8t/v+a55UJ/xgZoYZNS4T68AIdV0Qr0IewBe8Dv1hv79vH3YaMluw6rY4WquwtDCE0beB5Qj7INxahy8gWC77fyJQoa2XpO7OVdCnhiD56UEckl2PlPSM8Ezl5pCXtsJEmg9dpyk1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKJyaGJPzCoXoQNV2bqG9M8AtasFSEphNcmoHv2ERpc=;
 b=nWECQghcjB1A+ybxvC1SYg/L81nNtfBoa1B9DdxX8i5JN4c04J4eTkVwY57nYJ5X19vHiZ1hUx1KI4BB2rgVpUAaz4wAxZb/rplv3izepI8JQGFQypSFWeflyn02WcaqFyofkUHZoHk+B/0xnAQnmDA4+q0mq/vhfkVyhZyW95Y=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Thu, 15 Apr
 2021 18:08:12 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4020.023; Thu, 15 Apr 2021
 18:08:12 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
        ak@linux.intel.com, herbert@gondor.apana.org.au,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part2 PATCH 02/30] x86/sev-snp: add RMP entry lookup helpers
To:     Borislav Petkov <bp@alien8.de>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-3-brijesh.singh@amd.com>
 <20210415165711.GD6318@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <1813139d-f5f9-3791-dadb-4a684fe1cf46@amd.com>
Date:   Thu, 15 Apr 2021 13:08:09 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210415165711.GD6318@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0501CA0097.namprd05.prod.outlook.com
 (2603:10b6:803:42::14) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0501CA0097.namprd05.prod.outlook.com (2603:10b6:803:42::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6 via Frontend Transport; Thu, 15 Apr 2021 18:08:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 237251de-2b1d-4531-f17b-08d900396ea1
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB268544F896A5868D70F175C0E54D9@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sBQSJvKG/KvMzEmJk5bTLFpZRJPpmuid+VjM5bYFP5JKtPOe9ZnTjwmsXpyiNIu8VuOw6XL/EpGkfibzneZupu84ZDRqMyl51kwTvM+ke32p/B4nxcGFw252sqh+OYlfqI2K7y+33GALHak5qSag7/VFus4tNX0XVoRyWbCkQc8lT5N9srP6zopbZZamT5aVuYo0eb51Y8+6+nPGsRmkPcVT5JVCOPmffFnrbzg4tt69f40cA8mNGNJ/3HBARwPnsIzEjL5+UyOFmDq7yJve3KChFJsCApH7kh2eWIArEg4JPEDpa4/1VMbvYH3DzeaWnKo+ATP+5insbuY24lSXML6m/5JrmSQNQF8fDnMynEZvG2oamxobvXngR65cMXOSmwNPO4JIo2w3o/b3kNkBYveDu0T8cgivF2WZpKp8X+xojaMewpEnPB3XIm9kgR+ALWpFQ66nDzuIFnn8f2v26272E4aMY3RZaUjbiDBwlNFLi3bMjIpqX7/4K92hrBRKUbtOe49nxjF7osej041HYaFV1X2WvjT4AcnfunnP9lFohB8+RWbgzCY3YRX37++8+4DnJhO20IRAmgohD/oVSNBBTH2f7jyLjrjENBppXU6q5ctj9HIaJmodKMD6HD5fG2NcmCq4tiZT0FoUC6FFEoiGVg3e5E28IpJvOUflc5S7b4tx/zjsw+l4koR7cJfZL9h+/ak/1ICoJiRTBACppjSryX+GP4gcsX47WuOX5JB8OYY6zZRqsCYTGE6wVPugWsNRR4A5a8IfThEsrdtisdwMDkk4z0f41aC0aLyR/9jnKXlx5gpTAr5qgxz0F4GS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(7416002)(8936002)(66556008)(66476007)(2906002)(66946007)(54906003)(6916009)(86362001)(83380400001)(316002)(8676002)(6512007)(38350700002)(38100700002)(31696002)(4326008)(6506007)(52116002)(966005)(53546011)(186003)(478600001)(16526019)(31686004)(2616005)(44832011)(36756003)(956004)(5660300002)(6486002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WDB6aGdTMlJaaU41OFlXcUpOOThMRkRYUEZDdi9KRGdTZTJQWEovV2R2ZW14?=
 =?utf-8?B?R25sZ090M1VIZXdmNktzYkVhYWg2Z1hIUVA0Ny92S0V0MkliVk55Z1FHY3VB?=
 =?utf-8?B?ZlhDV2pLbFpHN01odFlEanNHUTZQVjlOdUZPWmtHNWhSMERiK2U5a3psUjNH?=
 =?utf-8?B?dXpjR0NxeFY4SG1SNnB5Z1dCL1dKNTBRR2ZRaHAvQ1FQZUZsVlJONENtNHhB?=
 =?utf-8?B?V3hNNkNJVXk1UEVkVTRiMU11YmgxRy80UHJrbzc2dUZDZlY0NWd0ZjJ5TDJM?=
 =?utf-8?B?WkVJYWZwdUorL1d1UjZyMDl6T0UvOW5QZ0Z6NWlpZWFGOHpibzY3R0JUeGx3?=
 =?utf-8?B?RGtJVkpvWWhLY0kyb2w1ekpwTDRsaDV0RHhIVFR6aXlYdHlUck1LbnVoR1dU?=
 =?utf-8?B?eG5PeTcrSUhxdXZvOTY1L0JMd1ZncE9Md3NkbUVIUzdCYUVaRXU5VlF5VFZC?=
 =?utf-8?B?dStQWlovc1ZvYTNkOHRxVFVkUVVoYnM2OHVoM0MyaHpIMTgrQi9ZdmVBM3Nl?=
 =?utf-8?B?eG53YVA4dG94b2ViSHRseXhxYVEycVZ1eTlyRUp0WUpycE1ZVnJxVDE4T0xk?=
 =?utf-8?B?aHVaWFd0VEM4cEt3U1BkNVBaeWpMZUZXZ0dqY3JVSVp6UVFxRk5MUFFtZWI4?=
 =?utf-8?B?Y001d004RWx6MUs3NTFjWmRGQ0VmRk1CVmVBZlpVN28yM0hudm16MDViMVZr?=
 =?utf-8?B?aEFxWks1cnk2WnZSbEdpVDUzZFF3ZlNRUFJ2bEpjZ3hCckhIamptWXhxeGR2?=
 =?utf-8?B?Snk4RDlydU1mTUxzbXhrQWdGNGU0RGRocWRWQXRQTzFZenFTVHZvazlXaWlx?=
 =?utf-8?B?b3RQbXFXYlBveXhRSStQYWptS1o4K0t0YWJ0WHhnbmZrbmVUc3lmcmdHK21x?=
 =?utf-8?B?VzVMVGx1MndnYUEvSnJoUWNDMEZyanNBb0h6anRYQ29wVE5mZmp1Qys4RXhQ?=
 =?utf-8?B?U01vTkZhR1A5OGFqTWJvZll1SWdwa1dCUWNSM2dVL1NrTTMyYzZGSDFEb2VT?=
 =?utf-8?B?eFE5QnpFVmh2NGsvS0ZUeUdFQWVRMVJQdjM2RHMxalN2MWdVbzNhZ1dkV2gx?=
 =?utf-8?B?MUhzRXhWdHdIWG1GSWlHMllJMXU2SmM1N0E1dXZNb3J2ZTR2RkE1L2w0c1dj?=
 =?utf-8?B?QmxVSW5iUjM3dWtSNVBrdktUNGpLL0NwOGJ4eW1XdHFBL0Q0YXEwbEJjS1VB?=
 =?utf-8?B?eG9JVzdib2pyREROWURBT3VzTFk3eVB5WGtGdDRveFpiL1Bqbm9Nc25BSTR1?=
 =?utf-8?B?TDVJazk5aUpWMU1CaSsrZ2xMYnVLYW5pNVFSNjJuMGFTc1FhVFN0YkpZZ1Ex?=
 =?utf-8?B?TDZVUXgrbW11Y2NuaXF0YU95T0poN0VZcnlndWVRKzIwaVJNc21hZm4xVktj?=
 =?utf-8?B?V0pTL3ltSzdnbFVLRSt6cGRMZ1hlMy9FczlUN1Zyd2RSUjVXeVJ3U1haWjhv?=
 =?utf-8?B?bHVKTE5OcVFqNlBVT2F4aTBUMWFZREk1UVhKT1g0dDZQN0Voa0U2disyNHA4?=
 =?utf-8?B?ajE4OGNsRVpUWXZNWVRHdjBjTjR3M205TEp3NEg0ckxFZ1llRlFqMnc1aFc1?=
 =?utf-8?B?NCsydzhNeWpNM0pqQnByaVBnNllzSW02R09iRGJTeUtoRDlTL0VSSjI4U2ZC?=
 =?utf-8?B?RllHWFZ3S3lJQU9vVGdHUG5pdnFqZ0ZhalVQT2FtRUVYSFZlcVBJdWNkaitm?=
 =?utf-8?B?YVZ1Y1Z1azVsYjU4dzlvMzRqd0pXRW1YL1EwYjJWRUc1ZUdPcnBTRDF3dDBp?=
 =?utf-8?Q?n4nBwZBNOyApygkXuVa0qLF5f0DvLrXjtgYA3io?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 237251de-2b1d-4531-f17b-08d900396ea1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 18:08:12.1127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UAqNGsN1bf/Ea7R3Zvrf2hcdV4An3f1wbfhnqUU7UULz80HBzED31JycCmcQjypt6JCxE+BIjya0ZKCjCLNBUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Boris,


On 4/15/21 11:57 AM, Borislav Petkov wrote:
> On Wed, Mar 24, 2021 at 12:04:08PM -0500, Brijesh Singh wrote:
>> The lookup_page_in_rmptable() can be used by the host to read the RMP
>> entry for a given page. The RMP entry format is documented in PPR
>> section 2.1.5.2.
> I see
>
> Table 15-36. Fields of an RMP Entry
>
> in the APM.
>
> Which PPR do you mean? Also, you know where to put those documents,
> right?

This is from Family 19h Model 01h Rev B01. The processor which
introduces the SNP feature. Yes, I have already upload the PPR on the BZ.

The PPR is also available at AMD: https://www.amd.com/en/support/tech-docs


>> +/* RMP table entry format (PPR section 2.1.5.2) */
>> +struct __packed rmpentry {
>> +	union {
>> +		struct {
>> +			uint64_t assigned:1;
>> +			uint64_t pagesize:1;
>> +			uint64_t immutable:1;
>> +			uint64_t rsvd1:9;
>> +			uint64_t gpa:39;
>> +			uint64_t asid:10;
>> +			uint64_t vmsa:1;
>> +			uint64_t validated:1;
>> +			uint64_t rsvd2:1;
>> +		} info;
>> +		uint64_t low;
>> +	};
>> +	uint64_t high;
>> +};
>> +
>> +typedef struct rmpentry rmpentry_t;
> Eww, a typedef. Why?
>
> struct rmpentry is just fine.


I guess I was trying to shorten the name. I am good with struct rmpentry;


>> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
>> index 39461b9cb34e..06394b6d56b2 100644
>> --- a/arch/x86/mm/mem_encrypt.c
>> +++ b/arch/x86/mm/mem_encrypt.c
>> @@ -34,6 +34,8 @@
>>  
>>  #include "mm_internal.h"
>>  
> <--- Needs a comment here to explain the magic 0x4000 and the magic
> shift by 8.


All those magic numbers are documented in the PPR. APM does not provide
the offset of the entry inside the RMP table. This is where we need to
refer the PPR.

>> +#define rmptable_page_offset(x)	(0x4000 + (((unsigned long) x) >> 8))
>> +
>>  /*
>>   * Since SME related variables are set early in the boot process they must
>>   * reside in the .data section so as not to be zeroed out when the .bss
>> @@ -612,3 +614,33 @@ static int __init mem_encrypt_snp_init(void)
>>   * SEV-SNP must be enabled across all CPUs, so make the initialization as a late initcall.
>>   */
>>  late_initcall(mem_encrypt_snp_init);
>> +
>> +rmpentry_t *lookup_page_in_rmptable(struct page *page, int *level)
> snp_lookup_page_in_rmptable()

Noted.


>> +{
>> +	unsigned long phys = page_to_pfn(page) << PAGE_SHIFT;
>> +	rmpentry_t *entry, *large_entry;
>> +	unsigned long vaddr;
>> +
>> +	if (!static_branch_unlikely(&snp_enable_key))
>> +		return NULL;
>> +
>> +	vaddr = rmptable_start + rmptable_page_offset(phys);
>> +	if (WARN_ON(vaddr > rmptable_end))
> Do you really want to spew a warn on splat for each wrong vaddr? What
> for?
I guess I was using it during my development and there is no need for
it. I will remove it.
>
>> +		return NULL;
>> +
>> +	entry = (rmpentry_t *)vaddr;
>> +
>> +	/*
>> +	 * Check if this page is covered by the large RMP entry. This is needed to get
>> +	 * the page level used in the RMP entry.
>> +	 *
> No need for a new line in the comment and no need for the "e.g." thing
> either.
>
> Also, s/the large RMP entry/a large RMP entry/g.
Noted/
>
>> +	 * e.g. if the page is covered by the large RMP entry then page size is set in the
>> +	 *       base RMP entry.
>> +	 */
>> +	vaddr = rmptable_start + rmptable_page_offset(phys & PMD_MASK);
>> +	large_entry = (rmpentry_t *)vaddr;
>> +	*level = rmpentry_pagesize(large_entry);
>> +
>> +	return entry;
>> +}
>> +EXPORT_SYMBOL_GPL(lookup_page_in_rmptable);
> Exported for kvm?

The current user for this are: KVM, CCP and page fault handler.

-Brijesh


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D543611DB
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 20:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbhDOSPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 14:15:45 -0400
Received: from mail-mw2nam10on2063.outbound.protection.outlook.com ([40.107.94.63]:23905
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234595AbhDOSPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 14:15:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWcYuY0U2i/w9HNK5eBzovdPEdufmk8tsoJTF3LWPXixtAahJ35eMT1A+P/+7PGFTatih5ViNfO4yCPHw8LqjS0u90KPzxYbrK5tZyfVy1uL5xgyRChRWLtp2iglj7YwK9hzRXLRVWqGUyONiHRlauIIddEz+Jdly5B6KWeH0LAR9NNbcCohCbjIDIPCqpzXyZwDR6Uq/Cw2IKYwjojF0hVgoMFvJ1Sv2EP22RdZfWbNoyJEmRKieVe3lNEM8eDgYmQuK9SjQ52UpIhWhadF3zR2Rc5WZoFoXqnxNh1sq3IPOYsGhpXb4dRjCJ44OBLPRgt8YS3DOBxCrQ0vesftyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VG0Jc7H08t2INlSGEre0JimAMye9Uu/TIyvTQjugMWw=;
 b=flfRpXGU/bujpqaqqSv08XvxpC9JB4noXrpbiOn2+cPLMYCp0zyovpDvPy6aRdeqLMdVJP4Hca1bPiniTWumpJ3v0MRO+jYEgGNi/RfoS8AiRtq9i3zv4MH9mHX+CsiiZuHKuX4yNiW94nQHwmy3Hj1Acr/27GiIbJbMyyBEYG25/nTunZoRoE3h7WH6ocNIfYoh9rD+YnxShtmxOiKXED84VmQWgMdpt94EbuxKpfuW4hysB5lugI1gjerG8zpwQ5OQXxvlNnXLbpqaBuw+0bCxZqJNoxbzPoeYh9XnRAv2oxQ+Aogzpv0FPSMVzoVMniHenSy3pPHMxqkrvDmS2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VG0Jc7H08t2INlSGEre0JimAMye9Uu/TIyvTQjugMWw=;
 b=cPY0dqQ3BFqhrcIfswhubatYKotTQnXG7Z+TGIjWkeIdMAHe0WCNBmJ/rpoHlnhluw8cwfv3rcW4lvEuFBzs++xp0U/KfFTB4kgvV9eKK4gfIEt7zO/jrksNIfv2HpSz9zhCEvfX0kmdFPyknQosEBtdOfDXnpOFyqDyFExm68o=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4573.namprd12.prod.outlook.com (2603:10b6:806:9c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Thu, 15 Apr
 2021 18:15:16 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4020.023; Thu, 15 Apr 2021
 18:15:16 +0000
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
Subject: Re: [RFC Part2 PATCH 03/30] x86: add helper functions for RMPUPDATE
 and PSMASH instruction
To:     Borislav Petkov <bp@alien8.de>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-4-brijesh.singh@amd.com>
 <20210415180040.GF6318@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <27306231-9cfc-2b98-49ce-ef0a3cdbb683@amd.com>
Date:   Thu, 15 Apr 2021 13:15:14 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210415180040.GF6318@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN1PR12CA0073.namprd12.prod.outlook.com
 (2603:10b6:802:20::44) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN1PR12CA0073.namprd12.prod.outlook.com (2603:10b6:802:20::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 18:15:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c6de272-a50d-43bf-d5bb-08d9003a6b8c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4573:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4573ADEEE4EC4DA694088D3BE54D9@SA0PR12MB4573.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DQHc1I/INlwOyx0LQLzgH0l4QLgs9/5JoYH+rQAHeRbOcFYRJ5s6mPB6QtV1cM8GdXjL7wNLUQ7h4i0FofHSzE/HzwOGXLhkDwOyR/IARvCGctoZB+jbHpmvlCtXBOCcEw5FlrGX2sY9a8QzgfINfx/NLi0srZWqWE9CPeKZ1BN0D1lTCRx3tyDxmeAhuVbyzNn7MbdRv8/kAJsNQ62m/Udt/YpxRRkjqMDDSGl2lO3NXBbsOCWdtiG7+qbRc9Q7JV31zx89LLf9Q+ixc4F/crrNaWva5ECvXhB+UMk0OWE9wGymRcj3rcgvNeHBaJ/Ef7h2cgUdZpKT56hNeDXDkaq2ZEHhmm1NYNP4esle9M5Zltu4nVtJGEafQCpMbJbhc7S25LrO5TYedGxtEf+bXxkXDgZ0tUqZ3TM5phAL8LUIIX3bQcwCs0IzlT/mAZB8ZxUwZibyqb2l4y0HUUO7JETtchUozUle2vXvN2GwxNCQuS6rNcVj4TvB61ZOCfemskRbZQm43rIm1cRsl6icM++0C7Oek4g07wRTcCZWhwCgSRbidYPWM/C0zgLC9puBNxpSx213/lvAY2Nl2/HtLoOPJKU+1GGI6COimpV2Zghea94BlScnC74CH2nxi2eS603xGuP1ScWW2VvgdhI4/N5XUqQHB0i6az3yJULj+pIcgCbbCJPw8awF6bK5qy1g4znktDZIijoX9UnDx28VVuhmdAnBMmN9FPqPzRvi63s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(39860400002)(376002)(136003)(186003)(16526019)(26005)(44832011)(54906003)(2906002)(6506007)(31696002)(956004)(2616005)(6916009)(8936002)(478600001)(53546011)(316002)(83380400001)(36756003)(66556008)(66476007)(66946007)(5660300002)(86362001)(38350700002)(4326008)(8676002)(7416002)(52116002)(6486002)(31686004)(38100700002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZVo0UHZ4WlpuVnBYTmJ3WTY1RTVsSzN6d0lsVFducTRaaGRyMDIyKzkxcFI5?=
 =?utf-8?B?eUJrQWN2dU1jcExsbk4vSnNLVVFJMUJKaHRlSE0rQm1zMVBLYjVTMVNiZksx?=
 =?utf-8?B?WWVqMEZsQVpocTdDMzkvN0owdlZHREE2cU9SR093MEYrS3Y0M2JzYjRrUnFX?=
 =?utf-8?B?RTkvZzJxTUxIMmhRL0FTanR4c0hSWG5wUmRibWwxQWI3SnNBMnAyL3g5bTRB?=
 =?utf-8?B?ekxKbm9UeWFxejd4ZEF2NE53bm9xQWI3TXBPdlk1enoyc3hGblN4V0dZODU2?=
 =?utf-8?B?ZjFvWGVzTjdld3hyaERCSHBFVEhHNU1iWkVON0I0am0vNWI5elNrMFBUTWhQ?=
 =?utf-8?B?SzN3anpWbWN5ZWxRSVJ4Szc5ai9UbDR4V0IyT2NLemt2Y2V5Z2dxK2h6TVQ3?=
 =?utf-8?B?Vk5FUGR3REtDWVhNSEk1c3NaR20vVnVTaERNcDJtbkcwYUgyWjYvME9FZk1R?=
 =?utf-8?B?RlNnazF5QUdiMlM0eS9zKzUrWXk3eXRpazlzZ2UrVHRhb0ZKNmZsOEprZGdn?=
 =?utf-8?B?clpCV1NUY0lNbzZKMlFEWmZ3TVBJWXdhT0FaeHBheGRaajlJeU03WVoraDZa?=
 =?utf-8?B?eXZBU1lwaHRHT3dsTi9TRlVvMUR0Y05PSnAzN0F0ekxkdGplWFhKK2tWcDlt?=
 =?utf-8?B?NldiZFUxSThjQWIxNnZqV2FEYWNkRGJlbENhdWVzaFl3RTUwUTgrZmIyeVNX?=
 =?utf-8?B?cWFHYTREUGRGcmp4TWQxdGFVRFdXTHBlSnlKTzNxTjQ0cERsbXdFd2RyeWxI?=
 =?utf-8?B?UVZxbksxZk80alRBSlRVeDliTlRhbzZZRy81ejg3N0JIZ2Jvb1VQYk9Xc2Vx?=
 =?utf-8?B?bXJhZS9TbjhlbUhxdUJ5Z09sVTNxdklYOHN4ODVRVys1ZW1SajN4RjdqWllE?=
 =?utf-8?B?Ym82Y3dCbHFSNzI3QzN4RWVGZFJ1b3RKV3h6QzNQZXpoODdYWlhhMWVmRWVu?=
 =?utf-8?B?R2NJQVg3N3RKb09uQ1NrRWRORzRxRVdGZ0dDSTV0NlUwOTc2V0hQN01nR2Nj?=
 =?utf-8?B?d3VmMU41TXFXS2paUmxTem1xRUNnWkRUejFRYkpCSTNpelpGYWhoVGpHa2FJ?=
 =?utf-8?B?bXZtenloM3NmVllhcDIyN096dk82UVM0aHNWdjZOYmpvcHpQWWZuY2RXQXZF?=
 =?utf-8?B?aERRVmE4L0JBTEtPV3pqeHVWMzRCYXpZQkR6VE5ydms5anAwaWQyeDhQM1po?=
 =?utf-8?B?d2hFSmVmcDJrdDRUTDNiR3ltZ0w5ZWprTkVDRHQyR3JNQUFTdFpybGJZTFhr?=
 =?utf-8?B?elNUdGRYQWFLN0FNZnNXWkxxaTJ3SVFXcmkvZktJVDEyRUR1Q2t0V1dHNWM1?=
 =?utf-8?B?MG5zbHVqOXF0N3BxT3VSb0VxekhaRGtaRURQQ1Zha2VYNjlUQm50S1ZzMDN2?=
 =?utf-8?B?eHJjeStIdXU5UzNleWFoM0RWSG5jeFVQdEZpWHd2R3BXZzZSVGVtYjBMRUtO?=
 =?utf-8?B?dklUcGRjMVphWGdxQ2J1bEFtbkdJcU85eUVEN3RkZTlYUHV5ZHVrSnRIa3JQ?=
 =?utf-8?B?dmlwTnNFd2pIVFIxRDg5UVNyUE9NUWliNEFyYk5LQldhQ3Q2bjhKMTJCZGdK?=
 =?utf-8?B?MGRmTDhPTmhYbXdYZFJwamtERlhBdGNBRzY5OGIxUHhidmpWYlBGMm5tNTFT?=
 =?utf-8?B?S0pLUG5XWm56WFFSTU5Hdzd4TFBQSnBObkNjaUNkZ09pVTZqTktvN1hhZ2Y5?=
 =?utf-8?B?L1dVaHVwdFNNcFJUVXdnelMxRlh0eVZNdVJpRzVRMml2azlLeFdWNW80ekxV?=
 =?utf-8?Q?Xb6InoBXi8ulxMph+bqck33Zq74ZyV+vBxKhuSQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c6de272-a50d-43bf-d5bb-08d9003a6b8c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 18:15:16.4169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FZLr49SJbGmv7E3BDpMDSXpSHGIzy8wsEovFiqfxnl99ALCw32HX28LV1BWKYMaMKOqm6oMOjNZUaOaLZ2KA2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4573
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/15/21 1:00 PM, Borislav Petkov wrote:
> On Wed, Mar 24, 2021 at 12:04:09PM -0500, Brijesh Singh wrote:
>> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
>> index 06394b6d56b2..7a0138cb3e17 100644
>> --- a/arch/x86/mm/mem_encrypt.c
>> +++ b/arch/x86/mm/mem_encrypt.c
>> @@ -644,3 +644,44 @@ rmpentry_t *lookup_page_in_rmptable(struct page *page, int *level)
>>  	return entry;
>>  }
>>  EXPORT_SYMBOL_GPL(lookup_page_in_rmptable);
>> +
>> +int rmptable_psmash(struct page *page)
> psmash() should be enough like all those other wrappers around insns.

Noted.


>
>> +{
>> +	unsigned long spa = page_to_pfn(page) << PAGE_SHIFT;
>> +	int ret;
>> +
>> +	if (!static_branch_unlikely(&snp_enable_key))
>> +		return -ENXIO;
>> +
>> +	/* Retry if another processor is modifying the RMP entry. */
> Also, a comment here should say which binutils version supports the
> insn mnemonic so that it can be converted to "psmash" later. Ditto for
> rmpupdate below.
>
> Looking at the binutils repo, it looks like since version 2.36.
>
> /me rebuilds objdump...

Sure, I will add comment.

>> +	do {
>> +		asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
>> +			      : "=a"(ret)
>> +			      : "a"(spa)
>> +			      : "memory", "cc");
>> +	} while (ret == PSMASH_FAIL_INUSE);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(rmptable_psmash);
>> +
>> +int rmptable_rmpupdate(struct page *page, struct rmpupdate *val)
> rmpupdate()
>
>> +{
>> +	unsigned long spa = page_to_pfn(page) << PAGE_SHIFT;
>> +	bool flush = true;
>> +	int ret;
>> +
>> +	if (!static_branch_unlikely(&snp_enable_key))
>> +		return -ENXIO;
>> +
>> +	/* Retry if another processor is modifying the RMP entry. */
>> +	do {
>> +		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
>> +			     : "=a"(ret)
>> +			     : "a"(spa), "c"((unsigned long)val), "d"(flush)
> 					    ^^^^^^^^^^^^^^^
>
> what's the cast for?
No need to cast it. I will drop in next round.
> "d"(flush)?

Hmm, either it copied this function from pvalidate or old internal APM
may had the flush. I will fix it in the next rev. thanks for pointing it.


>
> There's nothing in the APM talking about RMPUPDATE taking an input arg
> in %rdx?
>

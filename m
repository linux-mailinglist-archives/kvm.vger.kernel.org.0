Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFE635FE07
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 00:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbhDNWtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 18:49:22 -0400
Received: from mail-eopbgr750089.outbound.protection.outlook.com ([40.107.75.89]:54483
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232964AbhDNWtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 18:49:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d65tj7pdn6tMVWhaCqHpyjAXTThZwUDhsP2zjpNq2rxAMlLgmnfRvOd/Ua4klmKaGSNfXRQor7hV6V0Cc/AG9+4HmBZ/Jt4scC1n8MJvdeZdo3iSrRg5cyUNrvJ55WY2tG+5krQnuXpc5IxItKELag4kulgb9eTF3iDKzgMGUhiAR0mXKgufMw/qQV1IXcmuwSjYAbIbM1H4Y/vaRSi4YhN0PFq/L5u2+7oJ5sFLtn2wUPho6nFskCmF5FwZvlUkS80QzEPPMI/msLbgF5Bn+5VpJkFiqRh6jD9ZG/jZESV6bLnJo4JhXr7pE2SaKZNQ6NBJ5BIC/TeMC62ED2fN4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNALN64VcQFgXF25eTDux/TpMAJWwH0ynhHa0GEe3AU=;
 b=D3ENZChSjxtOFDdA8fyssjBwGk3iYF5YdcQpN0WsYQ18V164SwaNV4bhtERdP3DeEgGv8IIcwSUpHXYBHI/4vtv1LFRbeDCNrTg5+bZ9kqOSUY/RL4K47kcEM5ba+YBzlt80Cf57YBArUcDM5CagMP2AfUezNnnuOEfQsh8KJCB5V5qWn4nSi0C8mz5u98kaQJmD44cPlaGgqkaryMpOoiRW/ncnfYUnBlYvTuj5ivAQzPdBqXgep55zSriOHwBwXpI8Msyx/ue7SPPXD2GpE673Wp+ECTwFaNulCIUWESCRY89Sajtlpw0N6iTzWVIX9icGlY15eBs/ruo/cj0PAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNALN64VcQFgXF25eTDux/TpMAJWwH0ynhHa0GEe3AU=;
 b=i0mH6MRCcrJXbIjh7keULi8sBYDg5rpn8rLSV65drJsS6Hc9g7kwc+BI9h5KoBDDP+QhcG8nq9fLUd9LxsaayjOTeaXfu/pxG9B8F+xj7ldALgInv6ecMhH+R9aqm3YhvfEGsHOI4kJVmobb5ZvtSRzD/jde0jHVCwKuEmu8RTU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 14 Apr
 2021 22:48:57 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4020.023; Wed, 14 Apr 2021
 22:48:57 +0000
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
Subject: Re: [RFC Part2 PATCH 01/30] x86: Add the host SEV-SNP initialization
 support
To:     Borislav Petkov <bp@alien8.de>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-2-brijesh.singh@amd.com>
 <20210414072747.GA15722@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <47f84ce5-1923-49a0-b3ec-134a35ac9192@amd.com>
Date:   Wed, 14 Apr 2021 17:48:55 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210414072747.GA15722@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN6PR16CA0072.namprd16.prod.outlook.com
 (2603:10b6:805:ca::49) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR16CA0072.namprd16.prod.outlook.com (2603:10b6:805:ca::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Wed, 14 Apr 2021 22:48:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64ce3f34-1da9-4f44-c0a6-08d8ff977cd7
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43825AA19EBEEF244F93B637E54E9@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oPL1v7Rysa1VhvEej89FsTfFT9R8O8vGOuvQAkgQRH4UXgKunEkZkfRq/Va2bSrg1A18XSrrwrnvaJV8n7JgePvxspccKc5yKvNTF0Y9PrJDBgjfuygQcstPEfhB0z40sM/7fbwNkSaoPit7/DsutUgn4/Zf0iWgqo7LpjavcjKirKlYpiyBpQvnLO+rG3G5TjSkdKwXXFYIhObq3Q4ujpsmOr1bLkfpMD8O/9IsWbTNKGb9JOObrvXHx23Ryi7wMoeW4VJKKeigCF6suDZX6lhfKzbWtOOlp9YDbaXm9xBhNiQeX35WdUM/2mpBkI7RbSTnJbdPDpamICvghtFlA7fC3rdEzakNXMOcMFkbBOHEx4KGgMcaKjKq1SVc7WqEQbKOj3V6l40aA68X5fqYLWyTA/yAOCwQqomaQ9Q97I9NMoyuo3sVvt/58vTy2zoaXDbJCQoZ0Xz90M08qMiHChvOnYw+Sui0A+PQ9kCrQkmJjZKsjaIcf17Fn3x+lCWvysGZMXUowkpc8YvYDHYjqeFNlWH0Nm5pXbwY9+WAutFLM+by2hGA5025TNTp0wPYdTKKfyAyN1utVBZiE9VTjj4rBYPYxxrO0+BPiXLYisWL0O6c0mKA7Nz+xIJ87osAgoeMmAdctw7N8Pb7Ky+6RnHBvOAc7cIQubTI8CFkf/Lbr48oNr6sjjf0amsBlg5bpG1F4jsarX8KG4n0SkZPVnemsKFwHHQ7XGbk8dpOC08=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(956004)(2616005)(52116002)(54906003)(4326008)(6486002)(2906002)(8936002)(6916009)(6512007)(38100700002)(66946007)(66476007)(66556008)(38350700002)(6506007)(7416002)(316002)(8676002)(478600001)(44832011)(53546011)(26005)(31696002)(5660300002)(86362001)(83380400001)(16526019)(36756003)(31686004)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZVlUc05yL2p6ci9WR2VJOTdzNWMvWUxkQjc5K1RmOUE4bnhxVk84aHh0U2RE?=
 =?utf-8?B?Q3dIY25JU0hvSTRxdUVBT3V4clJWY25MaEs1Y05XOWVuY0g2TE5WZFpBT1Ur?=
 =?utf-8?B?V1V4U084dUl0N2M0WTg2Q2hEbzdPaWlVNTNRYnpNbFBoL0xEU1h6UjRBWGsx?=
 =?utf-8?B?L2sydVZMam1XY3lWRHBNWEg4VTk4clpFNXkwc3V2N0ZHOWhiSG5WSndTcmNm?=
 =?utf-8?B?dEttdVlzWlNVaVFwbDlNYWM5ZXJYVkZIK3VXWmxCRWFVMVBDWFFCVlMweUI4?=
 =?utf-8?B?OTNra2h2RTJqSW1laXd1cGNRenBwMEREbGIzSFdCUEpLVFovSlVrVzZMYkhx?=
 =?utf-8?B?L3c2aWtpVGFpMmN6b3E2eEpIOHNyYWE4TENqQ1pxejJFWGVRcXVZVGNDSDJD?=
 =?utf-8?B?aVlNbWh0RlFhZVZsdEdKdkJtaHpIYm1HUndGOFg1THNRdU9hYXF1cjJEQkVT?=
 =?utf-8?B?MnlIejc3bW03RkFpRUxmMVRqclFDY2xOSm1Mb1ZCMjEyNCtEY1JZSCtjbExr?=
 =?utf-8?B?MUViNEEzekxxWktZaTZucnFEbGozVWErT3lPZTNwR1J5b1JBdTd4T2FsbHZp?=
 =?utf-8?B?QUlRZGpMWjIvSWx1NjcyRVhpWGxlcVN3NVJrN1lOQXgxVDhqQkMvWmhSSTRY?=
 =?utf-8?B?MkJtQ3A3V01wdXEzcXFFWkJLbnJ4WW9oU2hNS09FWHlrbjBkRVA2ajdQcHlQ?=
 =?utf-8?B?YU5ucHRXOURWYnJsTzZmTHZYYndwRzBlY1R1SytHemtDSFVOU0xrazBDNUdj?=
 =?utf-8?B?ZFVIUmRkaUhkNkdWQWN6T0hjK09nSVJUYWVVcnZicnlRYVdEeXFkUmp0amM0?=
 =?utf-8?B?UTRDZGJtVUNIVzdyUW1iVGhpaW94aHZSdDh6aURZaTJyeUpEL3Q3MmQ4Zk9L?=
 =?utf-8?B?a20zZDAzOE1iZEluWDFscjNZQWlrZERTSnRKNEVvcmFtVHRBaWRGK2tZMjcz?=
 =?utf-8?B?VHBBZ1N1eHNvWnZIWDB4NDhKbTM5SWJvZjRhbXR0N3I0N0FDR1AwYnVLb09P?=
 =?utf-8?B?VnI0QldrR0EvYzlnZVpXdGlxcU81MmFZLy9hYTVTblhXOTV4SkdSSUpjd3pL?=
 =?utf-8?B?cHBKYlJJcU50SzByYzJMdWdJWlRva1NDcGFvMTdyTnpVZ0hLSHNzK1ZpYVMv?=
 =?utf-8?B?b3Z1dVR4TzVDa2ZtTm1sUjFCb0p5Zm1Ca00yUVN4UWEwdDRpSE56ZlgvZ2Uy?=
 =?utf-8?B?MDRjMUQwVWFVNHg2NzVZUWRlR0tpOG40WVVSaVpiQ292QW53Y1F0d2taZzQr?=
 =?utf-8?B?dEIzYnZkR1d6L01hWE9qaHFwNFpzM2draGF1SHRtZDJSSFNWOWZLeER5RXRt?=
 =?utf-8?B?RGhaUWZNU2ZubVBFdWptVFF5aFpzNXlENjM2MWRXbDMzTkFra1htZ1hiNTdD?=
 =?utf-8?B?bXJvdEhoVFR2dnBWMFVjc3d5dG5uK29YaW9wL25wcjBqOEc2WGo1WUJDb2pO?=
 =?utf-8?B?UXpUTFlmVlpucDNWdlVQTEN1bUcvZHViZlREZXlKSUh4NURsVXVBL1BYbmVz?=
 =?utf-8?B?Z2RUR21RNndkd1loUHRId0pUbHFnbmx4YkhRdjdEQVBwNS9zbFZOdHN3L0Ir?=
 =?utf-8?B?TnFQWjBvaHoxeUpTZHZQOHFkMlBBTWVUbVlmNnN5OEtZVEwvYURnazY4UVQr?=
 =?utf-8?B?ZUlJckh0VUJ4WjVvcW5CRlZRMVA3T1dzNW9WZ1ZaalhrZ1VzZmZtUkVUNk01?=
 =?utf-8?B?c1g3bHJtc3RjMkd1NVR4Z1RmWi91N3U3UlN2eTdZcWNKRzlDc2pEQmY2UERV?=
 =?utf-8?Q?LuT/pGAm4f3HkogO1OLc3rxC1cYQLDFF3pz6omg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ce3f34-1da9-4f44-c0a6-08d8ff977cd7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 22:48:57.4882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Yd/aTvMiyh57uQZUs7LTF3ib0yGw9jiBbxUbT001ybGqO0V1XJCxu/vN9uW07HOI6dmZA8c/tRJlumHV8NleA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/14/21 2:27 AM, Borislav Petkov wrote:
> On Wed, Mar 24, 2021 at 12:04:07PM -0500, Brijesh Singh wrote:
>> @@ -538,6 +540,10 @@
>>  #define MSR_K8_SYSCFG			0xc0010010
>>  #define MSR_K8_SYSCFG_MEM_ENCRYPT_BIT	23
>>  #define MSR_K8_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_K8_SYSCFG_MEM_ENCRYPT_BIT)
>> +#define MSR_K8_SYSCFG_SNP_EN_BIT	24
>> +#define MSR_K8_SYSCFG_SNP_EN		BIT_ULL(MSR_K8_SYSCFG_SNP_EN_BIT)
>> +#define MSR_K8_SYSCFG_SNP_VMPL_EN_BIT	25
>> +#define MSR_K8_SYSCFG_SNP_VMPL_EN	BIT_ULL(MSR_K8_SYSCFG_SNP_VMPL_EN_BIT)
>>  #define MSR_K8_INT_PENDING_MSG		0xc0010055
>>  /* C1E active bits in int pending message */
>>  #define K8_INTP_C1E_ACTIVE_MASK		0x18000000
> Ok, I believe it is finally time to make this MSR architectural and drop
> this silliness with "K8" in the name. If you wanna send me a prepatch which
> converts all like this:
>
> MSR_K8_SYSCFG -> MSR_AMD64_SYSCFG
>
> I'll gladly take it. If you prefer me to do it, I'll gladly do it.


I will send patch to address it.

>
>> @@ -44,12 +45,16 @@ u64 sev_check_data __section(".data") = 0;
>>  EXPORT_SYMBOL(sme_me_mask);
>>  DEFINE_STATIC_KEY_FALSE(sev_enable_key);
>>  EXPORT_SYMBOL_GPL(sev_enable_key);
>> +DEFINE_STATIC_KEY_FALSE(snp_enable_key);
>> +EXPORT_SYMBOL_GPL(snp_enable_key);
>>  
>>  bool sev_enabled __section(".data");
>>  
>>  /* Buffer used for early in-place encryption by BSP, no locking needed */
>>  static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
>>  
>> +static unsigned long rmptable_start, rmptable_end;
> __ro_after_init I guess.

Yes.

>
>> +
>>  /*
>>   * When SNP is active, this routine changes the page state from private to shared before
>>   * copying the data from the source to destination and restore after the copy. This is required
>> @@ -528,3 +533,82 @@ void __init mem_encrypt_init(void)
>>  	print_mem_encrypt_feature_info();
>>  }
>>  
>> +static __init void snp_enable(void *arg)
>> +{
>> +	u64 val;
>> +
>> +	rdmsrl_safe(MSR_K8_SYSCFG, &val);
> Why is this one _safe but the wrmsr isn't? Also, _safe returns a value -
> check it pls and return early.
No strong reason to use _safe. We reached here after all the CPUID
checks. I will drop the _safe.
>
>> +
>> +	val |= MSR_K8_SYSCFG_SNP_EN;
>> +	val |= MSR_K8_SYSCFG_SNP_VMPL_EN;
>> +
>> +	wrmsrl(MSR_K8_SYSCFG, val);
>> +}
>> +
>> +static __init int rmptable_init(void)
>> +{
>> +	u64 rmp_base, rmp_end;
>> +	unsigned long sz;
>> +	void *start;
>> +	u64 val;
>> +
>> +	rdmsrl_safe(MSR_AMD64_RMP_BASE, &rmp_base);
>> +	rdmsrl_safe(MSR_AMD64_RMP_END, &rmp_end);
> Ditto, why _safe if you're checking CPUID?
>
>> +
>> +	if (!rmp_base || !rmp_end) {
>> +		pr_info("SEV-SNP: Memory for the RMP table has not been reserved by BIOS\n");
>> +		return 1;
>> +	}
>> +
>> +	sz = rmp_end - rmp_base + 1;
>> +
>> +	start = memremap(rmp_base, sz, MEMREMAP_WB);
>> +	if (!start) {
>> +		pr_err("SEV-SNP: Failed to map RMP table 0x%llx-0x%llx\n", rmp_base, rmp_end);
> 			^^^^^^^
>
> That prefix is done by doing
>
> #undef pr_fmt
> #define pr_fmt(fmt)     "SEV-SNP: " fmt
>
> before the SNP-specific functions.
Sure, I will use it.
>
>> +		return 1;
>> +	}
>> +
>> +	/*
>> +	 * Check if SEV-SNP is already enabled, this can happen if we are coming from kexec boot.
>> +	 * Do not initialize the RMP table when SEV-SNP is already.
>> +	 */
> comment can be 80 cols wide.
Noted.
>
>> +	rdmsrl_safe(MSR_K8_SYSCFG, &val);
> As above.
>
>> +	if (val & MSR_K8_SYSCFG_SNP_EN)
>> +		goto skip_enable;
>> +
>> +	/* Initialize the RMP table to zero */
>> +	memset(start, 0, sz);
>> +
>> +	/* Flush the caches to ensure that data is written before we enable the SNP */
>> +	wbinvd_on_all_cpus();
>> +
>> +	/* Enable the SNP feature */
>> +	on_each_cpu(snp_enable, NULL, 1);
> What happens if you boot only a subset of the CPUs and then others get
> hotplugged later? IOW, you need a CPU hotplug notifier which enables the
> feature bit on newly arrived CPUs.
>
> Which makes me wonder whether it makes sense to have this in an initcall
> and not put it instead in init_amd(): the BSP will do the init work
> and the APs coming in will see that it has been enabled and only call
> snp_enable().
>
> Which solves the hotplug thing automagically.

This function need to be called after all the APs are up. But you have
raised a very good point regarding the hotplug CPU. Let me look into CPU
hotplug notifier and move the MSR initialization for AP inside the AP
bringup callbacks.

>
>> +
>> +skip_enable:
>> +	rmptable_start = (unsigned long)start;
>> +	rmptable_end = rmptable_start + sz;
>> +
>> +	pr_info("SEV-SNP: RMP table physical address 0x%016llx - 0x%016llx\n", rmp_base, rmp_end);
> 			  "RMP table at ..."
>
> also, why is this issued in skip_enable? You want to issue it only once,
> on enable.
>
> also, rmp_base and rmp_end look redundant - you can simply use
> rmptable_start and rmptable_end.
>
> Which reminds me - that function needs to check as the very first thing
> on entry whether SNP is enabled and exit if so - there's no need to read
> MSR_AMD64_RMP_BASE and MSR_AMD64_RMP_END unnecessarily.

We need to store the virtual address of the RMP table range so that RMP
table can be accessed later. In next patch we add some helpers to read
the RMP table.


>> +
>> +	return 0;
>> +}
>> +
>> +static int __init mem_encrypt_snp_init(void)
>> +{
>> +	if (!boot_cpu_has(X86_FEATURE_SEV_SNP))
>> +		return 1;
>> +
>> +	if (rmptable_init()) {
>> +		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
>> +		return 1;
>> +	}
>> +
>> +	static_branch_enable(&snp_enable_key);
>> +
>> +	return 0;
>> +}
>> +/*
>> + * SEV-SNP must be enabled across all CPUs, so make the initialization as a late initcall.
> Is there any particular reason for this to be a late initcall?

I wanted this function to be called after APs are up but your hotplug
question is making me rethink this logic. I will work to improve it.


>

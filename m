Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582AE349499
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 15:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhCYOul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 10:50:41 -0400
Received: from mail-dm6nam10on2059.outbound.protection.outlook.com ([40.107.93.59]:2912
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230419AbhCYOuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 10:50:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WI3M3R0InF5voGVrycqcejlyHNAvLPIVVlkWf9tlc1ayOx2gHemPG4kvbwYzT818ISq16vGqh07uGlfTDG1CocpmsGgSDumbGJSzukafn4SCo4fEer/qVWHb7BIUobJ8X/9LkFwhuqZrG8ET101SIQH7KJXY2+7cXZzBsnzN1CbV9aNPDsOWPFx/FzV1KlMz3jB/4li1Mn78ZbqskQPWGO85dqR+3cyopjdBCtNc35s8v8z1Vjv8CeB7KuLGVs3cNZ+xCwCqAtoxDWBaaZ4feKUHJ9lvpm7SeumF2uPjz569dIvs9s8WjBlrme1XXukQI/cpCMn7fxW7qIx3SuHfYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ajaMoeZlCt2pdAi7zF9IN/tbreaIU+k8sYtbDvq+6M0=;
 b=FQaoDhgRL7wGe2W8V5ibXz8T8KPUhUjhzLeGe1VjVUFV592HK06ZiRLGSSWGD9cleIScLqBKLPVPNdtBwBoBqcb5A0oPdba9JtQV2zHBfP0KiqHEYYMjORrtvh//KvYXcJ1NgCA0ZFTR4kq1hUiIvMz10xiWTVq9GQ92uj/VBq7ECC8WcudStftjwTrTwmqZcDn+AiPuryYvt1ISQaS7HgiIZHS4pm/Wb1wPKkVhm3K4+SxvrWVHqFzTFiDD0uizQAiFKXJkMRPscaPggKRNCppbcOADZkd75TCAVplkkiKNf8ZdVUCeLppOCBlvvvvqR5j6waFRVzMt2fmPNB+flg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ajaMoeZlCt2pdAi7zF9IN/tbreaIU+k8sYtbDvq+6M0=;
 b=fGtrQQevhpPXnw0oO9aN01Ys/rhv1a/pZadQhGhtzczwqAHNboDyMGXOBp4+jOCsfWnIb55yRXFuP1hYNX/827Xb0G1ZvcdiN3/PS8AxjiJhIpiOl02ap6lgiErPu5Zvx//5qZrKNYEk80mWViIJ/exK24hdfm+4LDJPQ4Z4zzI=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2542.namprd12.prod.outlook.com (2603:10b6:802:26::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 25 Mar
 2021 14:50:22 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Thu, 25 Mar 2021
 14:50:22 +0000
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
Subject: Re: [RFC Part1 PATCH 01/13] x86/cpufeatures: Add SEV-SNP CPU feature
To:     Borislav Petkov <bp@alien8.de>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-2-brijesh.singh@amd.com>
 <20210325105417.GE31322@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <98917857-69d2-971c-d78d-b1d60159c037@amd.com>
Date:   Thu, 25 Mar 2021 09:50:20 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <20210325105417.GE31322@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0201CA0033.namprd02.prod.outlook.com
 (2603:10b6:803:2e::19) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0201CA0033.namprd02.prod.outlook.com (2603:10b6:803:2e::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend Transport; Thu, 25 Mar 2021 14:50:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0a608c9a-bf02-4521-0765-08d8ef9d514c
X-MS-TrafficTypeDiagnostic: SN1PR12MB2542:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2542840C91C2515D575257C2E5629@SN1PR12MB2542.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HFRsDHjTQ6RXkhK6c23IV2ZDULez1oa4F1lOY2eHgyXro/FoVhWHDuFLIl98aSOIyBDOVqsMzHaqt3Tx42f4xOJApITkYkFTp55hKuoKVsGmXDqPDsbx2gYxhKQR0g35eZ0nE6kKSkE6eDM2sjaYOfNN3uTJtxZgragb+EzI1jYtdKSQpULTqtbwn3phoUmBVb+/XzBlDUrH4cNg0BiDUU6jR+HK2kmdU+etrxtQDt/zB47G8KbOKUHPLT8vKKDe3dWI+uITYpniu1tH+J1PIxURbwq8z8SpXaGPYwdP6jvOMv8NGaAZvyOZtK6kCsV9Tin3QAfJ6S4LQK4sfnzM1WS9JCAt8d2F7jixl1OTvYAXUnC6xi/yE9y3ccm/7F1rWg0ij0DO0X+DpQZBwNwAcUQGlWN61XPODi+2VMFdF+6eN0yEw5VD8or1sL4D1cW19yqmcuQdRcrM4AkctGSIO8KzVYbG/tzopkDZrUoHGr7o7StYg6598AaqUFOexiNbAmwYXk9d+sc5gxeGJRtXwoJbPlVaqNZbn09tRsCElqCAy0ApDmsH0Dt3tXAPI7YM+tGE3zuWiunQ3Nkg+XKodVjF1pulBcfO4+wDoFAwbet/Da2lgzsN4uoBPz9McmXHCfWhA2ea2IizL6Y+MzDoaTjHas5UZygpcjcs5DE+Dxul+pp2b5Vblwj9Je2YBFT6vmGZ0Xor+d4qBEMyCdxHw0w8HkC6SM5sOobi5GE/rxI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(86362001)(31696002)(16526019)(53546011)(66556008)(956004)(31686004)(83380400001)(38100700001)(6916009)(36756003)(66946007)(26005)(4326008)(52116002)(6486002)(6506007)(2616005)(66476007)(186003)(54906003)(5660300002)(316002)(44832011)(8936002)(478600001)(8676002)(6512007)(7416002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V3g0dTdPNkpobi9zMzFkL0ZyeXo4QnB2SG5qOFpjY3I1NnROdVFJZjRpY2pO?=
 =?utf-8?B?Y1ZZWk4wVkNKZmZSaUlnTGdreUhlRWVLS2V3N2l1SThIQXlqZUhidFZSelR3?=
 =?utf-8?B?TXlGZU1XaU8xZzkwRGllK1RvVmw2ek0zTDFIaXFSOTJ3cENFTTJWSXJOL1RK?=
 =?utf-8?B?cVJPYVVYK1hFdlBwS2pCRVk0djMwSjI0K3BsTnMybHdBNUVEV2pnb1ZKN0pH?=
 =?utf-8?B?L01IWGg2alIvNEJDSGt4WGN2Q29vQWNGeXlIYmh1KzRCQ2E2dTFudmZPbjFk?=
 =?utf-8?B?OTJKMWFENTF0VzBhc0JxQ3FMVnlyRzBlUjIrZVRzbmxHSzI5dTNUR2doZTVi?=
 =?utf-8?B?ZHk1YWd6N2VGbnRyWDB5VlhjSDVYR01JQ3FDUlJmWlFNMUFsMWN1T1ZsaURG?=
 =?utf-8?B?ek5kcmhZTEtCMkUrcDF5Ri8vdzB2Q2JqdHJlSzVUd1VHaGZRekZKYm8vWTkw?=
 =?utf-8?B?c3d5bHlsK2Y0cWlJMU96NlliQnFTdmVBRTYwVVlCR2d3YUd4ZnExN2g4WVZt?=
 =?utf-8?B?TGg4Q0tBei9MM3ovb1dMTzdUTXhuYU45Z0lzOFdVQnBZTUQ3VnhKYXk0MmNT?=
 =?utf-8?B?UkFVd09zYURlck11cGtFdGl4Nk1ZQVdVSFo4YkdoWDkxdFYxU1ZFRU4vaHU0?=
 =?utf-8?B?elR3VHJyNU1LeFI4N2JkMDJZZkVtWlBRQzg3VXpRVjZqNk1xby9YRWVIalJa?=
 =?utf-8?B?TkhyRTRZdy9ab1ZHN2tFOUpUKzFqcWdGSy9wN0FDSHREcFdPYUVtZDlXVGtt?=
 =?utf-8?B?ZG9FN2hVUUFTemdybHAxeHRTMUltMTQvQTR1ekx1eDNaVzNYbm1ROStQdXIv?=
 =?utf-8?B?RHBreFA3b1NuWXlzREZKMlhLckFyVDlkSmdrc2pxd2pMWjNod0wyM0dONkxl?=
 =?utf-8?B?OFFXbTFDZlVLRzVoRFR3aHlPWlFrTy8xNUR1T291NmxRY0M3V1FIYUZTQTRi?=
 =?utf-8?B?M1ZCOFUxQkM1a2IxSmljMFI5UFNORllyL2daUjFXYTh5VS84NjgwY3VUTjJQ?=
 =?utf-8?B?aXk1UWhVZ0xVclpyeGFyei9YVk5qSW12RGM0bm1KaEsrZWNTMlpXS1YzK1pT?=
 =?utf-8?B?Z3BrZzNtZ2l0eU9oV085MzFNdjNSZ0E4dHR2NTAzaExHSnc2UCtCQzUyNVoz?=
 =?utf-8?B?TVFvTkIxZU1IMDJlazR2MDhoSmpaQ3FsOVNoNUZoWTdTN1pYYWQ2eVlUMFpn?=
 =?utf-8?B?WUQyRU5VYlNLUGdadjBqRCtrQ0tOWUE4MEM2L1ZsdGxXdS9xLzMyQ2dHUVJ5?=
 =?utf-8?B?ZU92d1V1a3V0dTd3U2c4SyswczhScXkwWThaYWlyOTNqZ2ZzMkVCOEdDb0Va?=
 =?utf-8?B?dy9jZ3JTQm0wMmhta1RBTFU5UXdxWkEzTlFUN3M2eUZpc25iemhud0pYTExN?=
 =?utf-8?B?ZWhFWHFsRFdQbHdIRFdKT1d3L0l5UFd3Zkd6Q29wWkozZDREcndDanNzU2Zl?=
 =?utf-8?B?Z3d0Njlud1hvbHZmeGxmWDFVYy9pUVV3NmFGOFMwbUdSRjlLS25pNzdyUTB4?=
 =?utf-8?B?b1BHcGhYemxEWkFRRzJRR1Y0UHB2MFlDeFprbmdhT2M0NDdJVUFRMlZkYy9H?=
 =?utf-8?B?ckRLRndJbktDU09VcGl5WklHRkdCak5oNUprZEloNlg5MzFGU3JjRXBFdnBB?=
 =?utf-8?B?QlEvQTY5cWZIWWFUQU5kTlJGQ3NBK0syYitLblQ0OUlhM05TYjdPTk05QVp4?=
 =?utf-8?B?eDBEcmxnUFNGTVRYbnAycEdUcVhNTlhQcWh5SEpzT3IxOE5EU3hUSHRtWWtL?=
 =?utf-8?Q?mDPtH2JNo7reAdgNgjs966C4wT3YI4C1bx1k8iB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a608c9a-bf02-4521-0765-08d8ef9d514c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 14:50:22.7815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0RMYDNJ0cHRBDSM6n5aYftx3mMoprL6WjORnWqbGlR44YelLZa+dGzon2VTkNqWLlU2ZAU1p9u3f+6RGMYNbNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2542
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/25/21 5:54 AM, Borislav Petkov wrote:
> On Wed, Mar 24, 2021 at 11:44:12AM -0500, Brijesh Singh wrote:
>> Add CPU feature detection for Secure Encrypted Virtualization with
>> Secure Nested Paging. This feature adds a strong memory integrity
>> protection to help prevent malicious hypervisor-based attacks like
>> data replay, memory re-mapping, and more.
>>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Joerg Roedel <jroedel@suse.de>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Tony Luck <tony.luck@intel.com>
>> Cc: Dave Hansen <dave.hansen@intel.com>
>> Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: x86@kernel.org
>> Cc: kvm@vger.kernel.org
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  arch/x86/include/asm/cpufeatures.h | 1 +
>>  arch/x86/kernel/cpu/amd.c          | 3 ++-
>>  arch/x86/kernel/cpu/scattered.c    | 1 +
>>  3 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index 84b887825f12..a5b369f10bcd 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -238,6 +238,7 @@
>>  #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* "" VMware prefers VMMCALL hypercall instruction */
>>  #define X86_FEATURE_SEV_ES		( 8*32+20) /* AMD Secure Encrypted Virtualization - Encrypted State */
>>  #define X86_FEATURE_VM_PAGE_FLUSH	( 8*32+21) /* "" VM Page Flush MSR is supported */
>> +#define X86_FEATURE_SEV_SNP		( 8*32+22) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
> That leaf got a separate word now: word 19.
>
> For the future: pls redo your patches against tip/master because it has
> the latest state of affairs in tip-land.


For the early feedback I was trying to find one tree which can be used
for building both the guest and hypervisor at once. In future, I will
submit the part-1 against the tip/master and part-2 against the
kvm/master. thanks


>
>>  /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
>>  #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index f8ca66f3d861..39f7a4b5b04c 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -586,7 +586,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>>  	 *	      If BIOS has not enabled SME then don't advertise the
>>  	 *	      SME feature (set in scattered.c).
>>  	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
>> -	 *            SEV and SEV_ES feature (set in scattered.c).
>> +	 *            SEV, SEV_ES and SEV_SNP feature (set in scattered.c).
> So you can remove the "scattered.c" references in the comments here.
>
>>  	 *
>>  	 *   In all cases, since support for SME and SEV requires long mode,
>>  	 *   don't advertise the feature under CONFIG_X86_32.
>> @@ -618,6 +618,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>>  clear_sev:
>>  		setup_clear_cpu_cap(X86_FEATURE_SEV);
>>  		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
>> +		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
>>  	}
>>  }
>>  
>> diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
>> index 236924930bf0..eaec1278dc2e 100644
>> --- a/arch/x86/kernel/cpu/scattered.c
>> +++ b/arch/x86/kernel/cpu/scattered.c
>> @@ -45,6 +45,7 @@ static const struct cpuid_bit cpuid_bits[] = {
>>  	{ X86_FEATURE_SEV_ES,		CPUID_EAX,  3, 0x8000001f, 0 },
>>  	{ X86_FEATURE_SME_COHERENT,	CPUID_EAX, 10, 0x8000001f, 0 },
>>  	{ X86_FEATURE_VM_PAGE_FLUSH,	CPUID_EAX,  2, 0x8000001f, 0 },
>> +	{ X86_FEATURE_SEV_SNP,		CPUID_EAX,  4, 0x8000001f, 0 },
>>  	{ 0, 0, 0, 0, 0 }
>>  };
> And this too.
>
> Thx.
>

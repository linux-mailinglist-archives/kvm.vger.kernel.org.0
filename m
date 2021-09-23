Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A36E4164D1
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 20:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242687AbhIWSLC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 14:11:02 -0400
Received: from mail-bn8nam12on2070.outbound.protection.outlook.com ([40.107.237.70]:40129
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242152AbhIWSLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 14:11:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AO5z0vxnkjqn4rd4DbhBReJ/Ycp5gjWNmHFcJzMyYHZxamLSljui9j1PZz2Hj2Vdw0QVHVcDmCWyqMR76FBRd1c5LMZ+j3H8tihxIoFVOHmTYH8N3OwY0iEOuGFqc+b02adlYtjmBQ/uoqnVbSlv1crbJg2mcWFD8GtXM4HlcwTYzbUGdcEMiTPTDOgeOwSz4B5Rppf94myskMQ0CW+522u+8NguYkFyUschG5jIObEK2AxVzYqq5ov9X737iuVJmdKMyJBslBk0UagtR7amiBsAOGCXKxdJwt+SJn4BcqanmKur35sNj3naB/RkZ/nIaw5nm0Efj4t0BBgLiCxOTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ELP1PD0whEr5H4gWthwl7cWNk3DL4Gbn1h0gGj2XxF8=;
 b=FcSeMOGS37JuStNjJfFFAYbCVv4iShQOeqFNU2fK0Q20IgdcQOMw0D3epnvfuXmcY/Gbvtj9eFQkH8qV/Okyi2wPLFty2PiVANY5x9guLgVZfW//NK4ds8VUQp7Tu299R2P5kXKRC5NVRAKQg7PDgw0CtVAIWe86i90MWTFvpe3LR1PcQcTfU01DvhSR4HLtMhp1y+JuKkfcsA2sZwr3UVfzUAPN2LqAh+/1ZGPx+tP0WAsnDGIbsXejB19teBuKLQxZ91JQLgw/ivZ/qF4OUZ/ioW34lZSNFhwwvUeqDFKVKFjOp+i02Jo2ZG4oiDRGVFSCzlbYgh3TSOeFjoJIDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ELP1PD0whEr5H4gWthwl7cWNk3DL4Gbn1h0gGj2XxF8=;
 b=bKGsJwm0c6mUS5hpu6SPHMy2P96Ooa9K2osuXTgbdS0nprd5jALZLg+DYVQCHigTl8uG2wcNxLZKa6Z9qKC1LUB0AekJF0p5JB3aKE8+B8eI3gcigxnpdUIzgXE3Pv1cs8vsHo7wOUyypSeU2vD9xePHsonQNTzRKAtH5GWnblM=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Thu, 23 Sep
 2021 18:09:26 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4523.022; Thu, 23 Sep 2021
 18:09:26 +0000
Subject: Re: [PATCH Part2 v5 21/45] KVM: SVM: Make AVIC backing, VMSA and VMCB
 memory allocation SNP safe
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-22-brijesh.singh@amd.com> <YUt8KOiwTwwa6xZK@work-vm>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <b3f340dc-ceee-3d04-227d-741ad0c17c49@amd.com>
Date:   Thu, 23 Sep 2021 13:09:22 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <YUt8KOiwTwwa6xZK@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SN7PR04CA0209.namprd04.prod.outlook.com
 (2603:10b6:806:126::34) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN7PR04CA0209.namprd04.prod.outlook.com (2603:10b6:806:126::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Thu, 23 Sep 2021 18:09:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2e39e02-671a-4140-435d-08d97ebd473b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4510:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4510079FB2D32BDD8A90DE7EE5A39@SA0PR12MB4510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Gplf0Lt3qQgBlcoJ9A+28Jp7kdXmACNnO0RaU4E6vzP0eerSJMuP6FLnAycEqls/VMS+pkYnu5AkF5UNYODO6/fYJgYE2WF/GzBHlm+CYfItU/3m83bPtoqdEL0FgjOPX1AYbyeqJKXVaTVsKhNJockT/iA/nb6rGGBs5IU9U2CSTT7eS3x7kcEUcanNK2PFg6uecZVaqEA/AkRSRFyelnq63tdErmN/AaNfr1aMtG4z3OOZiAQbs4J22OcrSKbOmZLceOr9scQI20WHMl3u4C8VaLd17KSnkq+kreEPQxlu8AVU7P4Va06yjUHdzlzwhsWjIbpUTgLNrxIj23LNLgM1BASznKYSEnKpC1SeyJtO6Kgob8xrg+LPA9NqaGVTK/fdbtsnFCESDyYU2CzHfrinpyhJFmglrL92hmgfX0AiNHu4Hpa7b6wAp29A3MaXWH20ja9c0cdsKn5G6wWz+RAVLarOLxatWBI0E38qKV5SDpkkmuHIe6LyNo7d9b3h5ikjlvct5nYjWMTlXfKahRVT9BVKuGCy7a6Wrh45TQ6aK2yC5RC1CpeOtxKsTf0B+xMq9O23W9rocrLKnaKpJ/7JMi8gAQS86jj8R4nl1q9vzitdCqFoi6kJAgOo+6l2nU5p/rOfGGV+sz1XhiUVf/uUKat2QyJG8gIBdnQfFmg8kuhkwZzbptqRSz3dPaVv9bP1miZwDVbtWagbxGC3q3WeOCqA5mOrH0ZumCIhwNl7+3U+ohwLyDOPc2H6NO64lZWZd41pJFbXHKUKpHiVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(2906002)(54906003)(4326008)(66476007)(8936002)(31686004)(66946007)(83380400001)(5660300002)(38350700002)(44832011)(38100700002)(6486002)(316002)(6512007)(66556008)(8676002)(7406005)(6916009)(6506007)(53546011)(508600001)(186003)(26005)(86362001)(956004)(2616005)(36756003)(52116002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDNkRHIvenJBRkZBbit4am4xSXJsMVZUT2c0Q0pxRGZqUjUyZzlTRzV4ZWJw?=
 =?utf-8?B?bWFiNVM1MWcrTU83WXdLYXU4enRYb0Y0SXRLekJUYWJ1elhpZldzemRpQ1pU?=
 =?utf-8?B?NTAvOHNNa3UreGJheW0vUU1pZUtIeXphd3JHWWxjTjVPS0piUDl3eDhzb0Zt?=
 =?utf-8?B?Mkp3dmhySXM0VCsrdUlXdFhuVXdtQmhnbVRFQytOVTFFMWZYQk9UbFVqZkRa?=
 =?utf-8?B?eG15dWxzNjVCaUFQS0hZenFrUTQxNCs2T253V0VLNGw5Y3FFUjE4K3hVcE8w?=
 =?utf-8?B?VkppYnY0bEo4UTZQNzFrMVU5UC9nT0t0ZnUrbWZvOXNlZzZtWCt0M3BIK3cz?=
 =?utf-8?B?aWNvMlBvY25RdGdXUXNJL3ZBUmdjQktveVYwSG1QbjJZNGptNUhCZndkZzN5?=
 =?utf-8?B?RnVnbDlycVVzc0FaMVNpS0NITUhDUXUrdFJuSGx5Q3VkZms0Y3Qwd1Qrakdh?=
 =?utf-8?B?RDFlaDJmblN2aFdrd1k0WmI3MU5HTDdZU1YxNVpLNVNEL0xXb25PYW5uOXhN?=
 =?utf-8?B?S2NzckNTSGxaSk1hRForUlhsYTBwWkxDMzlaRDdTdmZ5Y3kvOCtieUhMYU9P?=
 =?utf-8?B?Y1UxMFlrbEY3YThvSk9xczhyQ0ozK3Rnbm5oSTFBOEZSMVNVWlh3MFl2aVAx?=
 =?utf-8?B?dlMzSVZrcWFVNTZ5Q3pzMmE0bEFrYk9RdHRRMlhZUUkvR1ZxNkFRb0Fjckpr?=
 =?utf-8?B?SmVRbTlKR2I3RzlrK2tBN1NSUWs5MFdJSmZsZlZpZ0JIajh2S2Yvc1RFMHpn?=
 =?utf-8?B?QW9iV2ROeCsyOHVTWXdFc1NjOVcvdU80ZWIzN3VOUEtqTHphRXQza09icXU1?=
 =?utf-8?B?cEs3eTRQbm9JeVlEdnAzRElFNVZKaDd4RGMxZzlVVXpFVGlpTE9lRkNuVjVw?=
 =?utf-8?B?MkVKSDJvUlJVeFp6dVhWcjJ3bVV3U0cydC94STRWcjdrSmNzRkpaSmJMQUhY?=
 =?utf-8?B?MmlkckVPMWYvRHBMbldZMk1POTF1Yyt6dG9MRVlqWmxydXR2cUdMOFpLcGh2?=
 =?utf-8?B?Q1BOVWRUTmhIK2ZCWlBwbC9rQ1Zza3M5UGtDSnVZREkzTDduR0NVRzE1RUlu?=
 =?utf-8?B?L1VnbWVVenh6UVFNNlphNE9iQjN3VnNBY0pxUXNDVWhyYmErelc2c1k4UGFx?=
 =?utf-8?B?eXF6cmFJNWJQODREblV4SmhKYlRuOVpsWk1KNXNSRi96a25pWXB4b0Z2MGNk?=
 =?utf-8?B?bzUrVjlWdG9FVkJsT0VrY1FxUVMvR3JtbzZKeXhTb1F1MytHTExPdFZpTjAv?=
 =?utf-8?B?WnUxeTY4akY4VUQrOHZhM0xmSGZMVHpKaW5sT2pBSWE3M3pMWjNFZGZUMFQy?=
 =?utf-8?B?RldPa2ZOM2l1Mm1ETkF0aFRIRkNYWWVpcHFPSWlBaXIxa2FqR0VMMDlBc0VX?=
 =?utf-8?B?VmhVS2pYd0ZBZmpZS3ZzZTNMVUUvZmgvRHRQOG9uOGdRaVpOT2t3MHk3bkZ1?=
 =?utf-8?B?NHRiK0ljdHg1dnl3Zko0ckVKS2pZbWFSREE4b2ZoUlVxK3pESGFkcTZpSHcy?=
 =?utf-8?B?K2xCUkphdHgwT3I2UEZMdDdnZUVOdXE4L3UxaGZuWGNIK29ra2tNOTNRcHNH?=
 =?utf-8?B?OGRBc3VFUlJUTUNsUnJuWWh1T1U4UVVPbkdBLzN2T2VycXk2Q20wdGI3bVhs?=
 =?utf-8?B?Y01YZjRXUGhMS0xuU1JBSDFhZ1hVY1F0aGRjYmE5a2xtcUNLREpwQXJRL09I?=
 =?utf-8?B?aFJHYnJmalN4TE1vZEptNm1RR2lRajVsOTEyVDAzMC9qZ1lZRDlWU243aVYy?=
 =?utf-8?Q?EKGXM/VzMTKMuqyaCvhYtHi/C1eP3gcFtcTkYqP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2e39e02-671a-4140-435d-08d97ebd473b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 18:09:26.2068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cDOYiuLjFat0hO1rvsU0fb1z+O9eH3TCCPK3wVSzeC6e/PMADfrSgwrRlCzpJZ9Rb03wtRklRjyTfM6tqRvyxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4510
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/22/21 1:55 PM, Dr. David Alan Gilbert wrote:
> * Brijesh Singh (brijesh.singh@amd.com) wrote:
>> Implement a workaround for an SNP erratum where the CPU will incorrectly
>> signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
>> RMP entry of a VMCB, VMSA or AVIC backing page.
>>
>> When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
>> backing   pages as "in-use" in the RMP after a successful VMRUN.  This is
>> done for _all_ VMs, not just SNP-Active VMs.
> Can you explain what 'globally enabled' means?

This means that SNP is enabled in  host SYSCFG_MSR.Snp=1. Once its
enabled then RMP checks are enforced.


> Or more specifically, can we trip this bug on public hardware that has
> the SNP enabled in the bios, but no SNP init in the host OS?

Enabling the SNP support on host is 3 step process:

step1 (bios): reserve memory for the RMP table.

step2 (host): initialize the RMP table memory, set the SYSCFG msr to
enable the SNP feature

step3 (host): call the SNP_INIT to initialize the SNP firmware (this is
needed only if you ever plan to launch SNP guest from this host).

The "SNP globally enabled" means the step 1 to 2. The RMP checks are
enforced as soon as step 2 is completed.

thanks

>
> Dave
>
>> If the hypervisor accesses an in-use page through a writable translation,
>> the CPU will throw an RMP violation #PF.  On early SNP hardware, if an
>> in-use page is 2mb aligned and software accesses any part of the associated
>> 2mb region with a hupage, the CPU will incorrectly treat the entire 2mb
>> region as in-use and signal a spurious RMP violation #PF.
>>
>> The recommended is to not use the hugepage for the VMCB, VMSA or
>> AVIC backing page. Add a generic allocator that will ensure that the page
>> returns is not hugepage (2mb or 1gb) and is safe to be used when SEV-SNP
>> is enabled.
>>
>> Co-developed-by: Marc Orr <marcorr@google.com>
>> Signed-off-by: Marc Orr <marcorr@google.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>>  arch/x86/include/asm/kvm_host.h    |  1 +
>>  arch/x86/kvm/lapic.c               |  5 ++++-
>>  arch/x86/kvm/svm/sev.c             | 35 ++++++++++++++++++++++++++++++
>>  arch/x86/kvm/svm/svm.c             | 16 ++++++++++++--
>>  arch/x86/kvm/svm/svm.h             |  1 +
>>  6 files changed, 56 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
>> index a12a4987154e..36a9c23a4b27 100644
>> --- a/arch/x86/include/asm/kvm-x86-ops.h
>> +++ b/arch/x86/include/asm/kvm-x86-ops.h
>> @@ -122,6 +122,7 @@ KVM_X86_OP_NULL(enable_direct_tlbflush)
>>  KVM_X86_OP_NULL(migrate_timers)
>>  KVM_X86_OP(msr_filter_changed)
>>  KVM_X86_OP_NULL(complete_emulated_msr)
>> +KVM_X86_OP(alloc_apic_backing_page)
>>  
>>  #undef KVM_X86_OP
>>  #undef KVM_X86_OP_NULL
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 974cbfb1eefe..5ad6255ff5d5 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1453,6 +1453,7 @@ struct kvm_x86_ops {
>>  	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
>>  
>>  	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
>> +	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>>  };
>>  
>>  struct kvm_x86_nested_ops {
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index ba5a27879f1d..05b45747b20b 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -2457,7 +2457,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>>  
>>  	vcpu->arch.apic = apic;
>>  
>> -	apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>> +	if (kvm_x86_ops.alloc_apic_backing_page)
>> +		apic->regs = static_call(kvm_x86_alloc_apic_backing_page)(vcpu);
>> +	else
>> +		apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>>  	if (!apic->regs) {
>>  		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
>>  		       vcpu->vcpu_id);
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 1644da5fc93f..8771b878193f 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2703,3 +2703,38 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>>  		break;
>>  	}
>>  }
>> +
>> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
>> +{
>> +	unsigned long pfn;
>> +	struct page *p;
>> +
>> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
>> +		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>> +
>> +	/*
>> +	 * Allocate an SNP safe page to workaround the SNP erratum where
>> +	 * the CPU will incorrectly signal an RMP violation  #PF if a
>> +	 * hugepage (2mb or 1gb) collides with the RMP entry of VMCB, VMSA
>> +	 * or AVIC backing page. The recommeded workaround is to not use the
>> +	 * hugepage.
>> +	 *
>> +	 * Allocate one extra page, use a page which is not 2mb aligned
>> +	 * and free the other.
>> +	 */
>> +	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
>> +	if (!p)
>> +		return NULL;
>> +
>> +	split_page(p, 1);
>> +
>> +	pfn = page_to_pfn(p);
>> +	if (IS_ALIGNED(__pfn_to_phys(pfn), PMD_SIZE)) {
>> +		pfn++;
>> +		__free_page(p);
>> +	} else {
>> +		__free_page(pfn_to_page(pfn + 1));
>> +	}
>> +
>> +	return pfn_to_page(pfn);
>> +}
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 25773bf72158..058eea8353c9 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1368,7 +1368,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>>  	svm = to_svm(vcpu);
>>  
>>  	err = -ENOMEM;
>> -	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>> +	vmcb01_page = snp_safe_alloc_page(vcpu);
>>  	if (!vmcb01_page)
>>  		goto out;
>>  
>> @@ -1377,7 +1377,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>>  		 * SEV-ES guests require a separate VMSA page used to contain
>>  		 * the encrypted register state of the guest.
>>  		 */
>> -		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>> +		vmsa_page = snp_safe_alloc_page(vcpu);
>>  		if (!vmsa_page)
>>  			goto error_free_vmcb_page;
>>  
>> @@ -4539,6 +4539,16 @@ static int svm_vm_init(struct kvm *kvm)
>>  	return 0;
>>  }
>>  
>> +static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
>> +{
>> +	struct page *page = snp_safe_alloc_page(vcpu);
>> +
>> +	if (!page)
>> +		return NULL;
>> +
>> +	return page_address(page);
>> +}
>> +
>>  static struct kvm_x86_ops svm_x86_ops __initdata = {
>>  	.hardware_unsetup = svm_hardware_teardown,
>>  	.hardware_enable = svm_hardware_enable,
>> @@ -4667,6 +4677,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>>  	.complete_emulated_msr = svm_complete_emulated_msr,
>>  
>>  	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
>> +
>> +	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
>>  };
>>  
>>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index d1f1512a4b47..e40800e9c998 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -575,6 +575,7 @@ void sev_es_create_vcpu(struct vcpu_svm *svm);
>>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>>  void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
>>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
>> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
>>  
>>  /* vmenter.S */
>>  
>> -- 
>> 2.17.1
>>
>>

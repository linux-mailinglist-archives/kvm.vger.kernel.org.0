Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A6542C744
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 19:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237943AbhJMRHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 13:07:42 -0400
Received: from mail-bn1nam07on2047.outbound.protection.outlook.com ([40.107.212.47]:35555
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235869AbhJMRHj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 13:07:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tz/oRIO8WQ2xLkVQKbKH7P8BZl8FoZQQBOUHsBOTo539j3CvEE+ndhHef3KM3GtxMD6kh/l5N24Ym7jI7KnytQ2sRIYukJN4YA244do4xGdUNC432dFfWnzb6Cif8/EPxVJ47xYL82W3Oomp8y6VKhkXO+qFCHkR1sBLK1EkBDebj1lFjju4UgQwqIpQ91kjoVq5m+OIr5IHVKdaOnxYZWyeHVdcO12EGnWMSM3B0/Gj8FMNhLkGugMl9xLTFm8gyVhpx6hnumNRSat9M5wWiD/aeAYNmVg8oH9D9g1cRflaJv0lBlnDSotiJ3+CESRX7fAW5Hr/MRfGT3qR+asEjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tBLoTTjXwB//P+RxrmasS4SG3m0FnPEw0KNuDby8t2c=;
 b=aStp0GGQ0UoNqSTohmmcSEm2mcDAxbnbRckemZt/Y0Ax/8NAmiDqqRSFLf5ltg2JE+/AWkCWp5SVhRhZPFf2NTUxIXE35qq5XZ+RDN+JsxCKcJqVRJotTun7rN8O1vZO4sOiMnz5Yrn2eoY5A6dOlkVWgMCx0WzG3V/3VUQa7NUp2MYpKpvuBucqVv5aA+R0AEshzs33M/RIaMVBkeOthBvub56j/7k9p6yypr7kj20yc1xs/YGvO0pw8PBD8PkPclPhBA6eEC8a6LT61Zjz3gjC0/RIqYE/Bkj/RmyP46efHKZAJgeO0yt3kHYGWUCCsDKgeEL7sN0ExtIeNYhbOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBLoTTjXwB//P+RxrmasS4SG3m0FnPEw0KNuDby8t2c=;
 b=b6eDCWPFesIK6YALtiOTN7oEITAh7tzpxpzfZCjfhTQ+JEsJQi2oheXtd8glIzsDNt99fCc/BtkWhnmfu+IjleVhHvrd31KASnQPSRMX9CExssZI4oJVnbTosfuNDuMBFXjP9cfPKu8of5L0oNYOFi8A058StdlSE0W+tYAjwmw=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4429.namprd12.prod.outlook.com (2603:10b6:806:73::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Wed, 13 Oct
 2021 17:05:32 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 17:05:32 +0000
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
Subject: Re: [PATCH Part2 v5 37/45] KVM: SVM: Add support to handle MSR based
 Page State Change VMGEXIT
To:     Sean Christopherson <seanjc@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-38-brijesh.singh@amd.com> <YWYCrQX4ZzwUVZCe@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <a677423e-fa24-5b6a-785f-4cbdf0ebee37@amd.com>
Date:   Wed, 13 Oct 2021 12:05:28 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <YWYCrQX4ZzwUVZCe@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SA9PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:806:a7::20) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by SA9PR10CA0015.namprd10.prod.outlook.com (2603:10b6:806:a7::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 17:05:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5cad396c-61db-4fa1-6dd3-08d98e6baa86
X-MS-TrafficTypeDiagnostic: SA0PR12MB4429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44291EB022170920AC973880E5B79@SA0PR12MB4429.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b77HDt89nMqtE8KnGKR1Vvp1MdigvEAe6e4IMwp5sImk2V7MU8qLJTVVqZdNcmvwxS/ykL+cipAxluXH838GfHVLerd0vlV05Z40ahb4FxvVfiK5OwuMNsEXWvzSNSleQDs9YCv/hP+QoYxMMVjGNv7trVcfC7MyGDp0vIq9TMvjSgyirsfHk4LGBmgSyujk+/FZz1CYm9EXmoYjoOztGRqcwy5P5/yh14TPe/cyJUfhfruuUnAJS94ZcpwWR02uezwtqSUNLjJUfDYDOzvnUDAGXMgQHS5NmIoAbKB7kjBpG2tmfcqeaMhWwL7jMbfVre0jRVg6SZPjAgMdjQbmMBowoC+5N+mTBx1s0v5qCNuUhXy94gjecEV7bgKIw8I7q5oy2IzymQp1yUCdZz2E5ZEbYc7yGNFtQ/+DxILmcCuduvbbn36mjCvoDYIcYLXPkajuIMljzkC4o9JhwFIjtj34r2bRvIDrff2IoI8tESUFgqaXMfCEyqR4iLaDfvttmuEd26Y2FJbIdmR5zpiXSohSDin26NO01BTW/YA+hZcba1NqVGsZn/iBrMnOqzLG+iJqGdWOIK7QgLCGFkXvjt/s1yITFF5YY9E0wDPLuS2uBbuZJRKyL9Zg1rgGTXr6DbAGfWFs8s4BT7oNj8tvJ8QJBMhEFLN6YOlF7CP8ZwLzer4zA10DbivsBsFS61vAjB3JvMtbDmN+xwTcdVddLHCU0udtQ5n0E8bZMzlBXfzH3wIDJuM6azIDMGc/e4N6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(66476007)(66556008)(26005)(8936002)(53546011)(6506007)(54906003)(83380400001)(7406005)(86362001)(6916009)(2616005)(956004)(5660300002)(66946007)(6512007)(316002)(2906002)(7416002)(36756003)(186003)(6486002)(31696002)(508600001)(8676002)(44832011)(31686004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0x6Q2x0U2xXUWpsbEJmdWd5ZE0vR1lhQUtVUVpraDcxaGhnQWRNY243UTZr?=
 =?utf-8?B?bGJPdkNxVExmbnJUQlp0c0pjbVBENWRCc09mcEpGb2lLSVIwaTFDV0kxOGQ0?=
 =?utf-8?B?QysweWsvQm5GTEFlZ3Rtdkh6Ny9WZnE4L3FJKzJJUTN4SnZkQW9wTEJvcitP?=
 =?utf-8?B?bW5RZXIvMGtyYVFCbkxLTjJSKzE3ZlJNVHNYcXRRcnlOQ2JWTHBwUGhyazZw?=
 =?utf-8?B?OUJBenh3Q1RpeHV6cjliVUZFL0NubGloYjdmM3FUVmRQdWVoTURYZHJYajBJ?=
 =?utf-8?B?RWgvQk15SnlORVVMR25XbHBjU1VVVVZLU1dhb2xKbkcrak5pMWZMN1hiRXls?=
 =?utf-8?B?YXFvSVlxcDZTdXNhTFI5TXhxdVlxekdJMms1cXFreXlVVHhqUVZRdE5MSHN3?=
 =?utf-8?B?ZVFYOFpXRE9ZaGdSTGxIRmUyY2I4bjBsQXVocjhGZ0RHMkNpZldqUTRHTnBh?=
 =?utf-8?B?SGg1RHZ3RFYzUnBVYWhPLzgwaGlqVTYzRFE1Z2JmM2Y1cHRKeHhsU1pwODV4?=
 =?utf-8?B?UFBFVTJXZXF5TkROSGRVY0VoZmQ3a0ZnMzNzZ1N5Zzl1TnBkK3N4bGRraU9L?=
 =?utf-8?B?Rjg2a3NqYVhkWnRza0IzeUU3dWJKT1hFbWU0S1hXdUdhNFl4cllNcUJWcWtr?=
 =?utf-8?B?WGRkczJRTG4ycVVRN0N3Y1hQekF5SDFNd2NTMFNSY1JNeFQ3RkhHUERqUVBH?=
 =?utf-8?B?c3ViYjZwTHhERERsOUtPVnBiYXNFWjJ2OTM2T1I5cnhQT2t4TUFJMGtLa0lI?=
 =?utf-8?B?S0o3Y0duYnA5OHNnUHZyd1FxSEpvREhVUGFTeGIrU0dEZ0N2R1VVcFdaTnJt?=
 =?utf-8?B?RmtCRWRBU0hEeEhyMDVRb0kzZTBPR0dxelVDVU45VHhwMWlHTGlQeFNMYk45?=
 =?utf-8?B?Tlc0ckQzVVd1YmkyTVFua3p6TVY2OFBCeUpSMDBkY0NhbFJYYms3MjhsanhE?=
 =?utf-8?B?QVdzckZpbVVOb1RSYmcxWG83NUpMNUNFQ283b3dtZ1gwUVQrOEJpYzF3RGVX?=
 =?utf-8?B?RklhVHY4bUhCT1pYU1NOZlNwNWdWL3d6WENrWFBFNU5ZNmFmZ09OcXlLK2Vt?=
 =?utf-8?B?bmNBMnI3bFFxL0JMcEtiOU1rODBXZDdobkdyOUNzbmwrVHVrQUJWaXdjUFlF?=
 =?utf-8?B?TFlaSlE0bmpEYjhPSEttRVBwOW1NeHBReUVjQVRKRU5ZOHZ4akd0cGo4T2p6?=
 =?utf-8?B?cXJqSWlqbTJQUnVadkNwY2JQSmVGNDJKUitDMUJMUnk3T242V0wxMjVEUkdO?=
 =?utf-8?B?cFIwdVJjUzd6bXpuS3lZczRSZTFMMklIY2loaWZvT0ZjMkZZZm41QW5kQUp6?=
 =?utf-8?B?N3dPeUtsS3NxemZpeW9oYWlPUWR6MXVoeHVhZEIwZnFTMjV6T0ZXbU9vaGVk?=
 =?utf-8?B?dFMwblIrWGJsL05IVk1qTkIzckhOQ3IxVzRUdzg0YXFySVdZbUU4eXFMQTZh?=
 =?utf-8?B?OUJpMnJXTE1qaE13WUM0ZFRubVo0bUlsQkF6amtXWUlrRFl6RHpzUHg5T2Ew?=
 =?utf-8?B?M3RqSTNQeTluMXNNZmZFdTJzcU1sd1U2bTU1bi90NjhUSUJqd01UNnJEVzNC?=
 =?utf-8?B?dEhhazVkcDVjenJZTlRISm5neW0zM0I4Q1dycm5za0lPVmo0c1JqbmtMT01z?=
 =?utf-8?B?K2FndDdWcXFtL2h4eVJ1OEpoNC83SEdrNTFXNC9NQW1qeURjazRXU1ZEdHZ3?=
 =?utf-8?B?aktnUW1ld1NNTDhsOUpma09tUU1nRzU0bXc3RmFGL3BvVVUyM3FUWUo2WHdE?=
 =?utf-8?Q?LEXG/eWkTQe5+/aVkrRVi0Bay1ozJaqcLwbtMnd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cad396c-61db-4fa1-6dd3-08d98e6baa86
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 17:05:32.5576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EZAWV1oS3EOdtMoL2y+c3SRFZnaJP6BlBGQPYuvhhRM57VZM2vPiq8zxLlcQP0/0HpMEY8NpctVCVeKqVmutsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4429
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/12/21 2:48 PM, Sean Christopherson wrote:
> On Fri, Aug 20, 2021, Brijesh Singh wrote:
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 991b8c996fc1..6d9483ec91ab 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -31,6 +31,7 @@
>>  #include "svm_ops.h"
>>  #include "cpuid.h"
>>  #include "trace.h"
>> +#include "mmu.h"
>>  
>>  #define __ex(x) __kvm_handle_fault_on_reboot(x)
>>  
>> @@ -2905,6 +2906,181 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
>>  	svm->vmcb->control.ghcb_gpa = value;
>>  }
>>  
>> +static int snp_rmptable_psmash(struct kvm *kvm, kvm_pfn_t pfn)
>> +{
>> +	pfn = pfn & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
>> +
>> +	return psmash(pfn);
>> +}
>> +
>> +static int snp_make_page_shared(struct kvm *kvm, gpa_t gpa, kvm_pfn_t pfn, int level)
>> +{
>> +	int rc, rmp_level;
>> +
>> +	rc = snp_lookup_rmpentry(pfn, &rmp_level);
>> +	if (rc < 0)
>> +		return -EINVAL;
>> +
>> +	/* If page is not assigned then do nothing */
>> +	if (!rc)
>> +		return 0;
>> +
>> +	/*
>> +	 * Is the page part of an existing 2MB RMP entry ? Split the 2MB into
>> +	 * multiple of 4K-page before making the memory shared.
>> +	 */
>> +	if (level == PG_LEVEL_4K && rmp_level == PG_LEVEL_2M) {
>> +		rc = snp_rmptable_psmash(kvm, pfn);
>> +		if (rc)
>> +			return rc;
>> +	}
>> +
>> +	return rmp_make_shared(pfn, level);
>> +}
>> +
>> +static int snp_check_and_build_npt(struct kvm_vcpu *vcpu, gpa_t gpa, int level)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	int rc, npt_level;
>> +	kvm_pfn_t pfn;
>> +
>> +	/*
>> +	 * Get the pfn and level for the gpa from the nested page table.
>> +	 *
>> +	 * If the tdp walk fails, then its safe to say that there is no
>> +	 * valid mapping for this gpa. Create a fault to build the map.
>> +	 */
>> +	write_lock(&kvm->mmu_lock);
> SEV (or any vendor code for that matter) should not be taking mmu_lock.  All of
> KVM has somewhat fungible borders between the various components, but IMO this
> crosses firmly into "this belongs in the MMU" territory.
>
> For example, I highly doubt this actually need to take mmu_lock for write.  More
> below.
>
>> +	rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
>> +	write_unlock(&kvm->mmu_lock);
> What's the point of this walk?  As soon as mmu_lock is dropped, all bets are off.
> At best this is a strong hint.  It doesn't hurt anything per se, it's just a waste
> of cycles.

I can avoid the walk because the kvm_mmu_map_tdp_page() will return a
pfn if the NPT is already built.


>> +	if (!rc) {
>> +		pfn = kvm_mmu_map_tdp_page(vcpu, gpa, PFERR_USER_MASK, level);
> Same here.
>
>> +		if (is_error_noslot_pfn(pfn))
>> +			return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int snp_gpa_to_hva(struct kvm *kvm, gpa_t gpa, hva_t *hva)
>> +{
>> +	struct kvm_memory_slot *slot;
>> +	gfn_t gfn = gpa_to_gfn(gpa);
>> +	int idx;
>> +
>> +	idx = srcu_read_lock(&kvm->srcu);
>> +	slot = gfn_to_memslot(kvm, gfn);
>> +	if (!slot) {
>> +		srcu_read_unlock(&kvm->srcu, idx);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/*
>> +	 * Note, using the __gfn_to_hva_memslot() is not solely for performance,
>> +	 * it's also necessary to avoid the "writable" check in __gfn_to_hva_many(),
>> +	 * which will always fail on read-only memslots due to gfn_to_hva() assuming
>> +	 * writes.
>> +	 */
>> +	*hva = __gfn_to_hva_memslot(slot, gfn);
>> +	srcu_read_unlock(&kvm->srcu, idx);
> *hva is effectively invalidated the instance kvm->srcu is unlocked, e.g. a pending
> memslot update can complete immediately after and delete/move the backing memslot.

Fair point, I can rework to do all the hva related updates while we keep
the kvm->srcu. More on this below.


>> +
>> +	return 0;
>> +}
>> +
>> +static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op, gpa_t gpa,
>> +					  int level)
>> +{
>> +	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
>> +	struct kvm *kvm = vcpu->kvm;
>> +	int rc, npt_level;
>> +	kvm_pfn_t pfn;
>> +	gpa_t gpa_end;
>> +
>> +	gpa_end = gpa + page_level_size(level);
>> +
>> +	while (gpa < gpa_end) {
>> +		/*
>> +		 * If the gpa is not present in the NPT then build the NPT.
>> +		 */
>> +		rc = snp_check_and_build_npt(vcpu, gpa, level);
>> +		if (rc)
>> +			return -EINVAL;
>> +
>> +		if (op == SNP_PAGE_STATE_PRIVATE) {
>> +			hva_t hva;
>> +
>> +			if (snp_gpa_to_hva(kvm, gpa, &hva))
>> +				return -EINVAL;
>> +
>> +			/*
>> +			 * Verify that the hva range is registered. This enforcement is
>> +			 * required to avoid the cases where a page is marked private
>> +			 * in the RMP table but never gets cleanup during the VM
>> +			 * termination path.
>> +			 */
>> +			mutex_lock(&kvm->lock);
>> +			rc = is_hva_registered(kvm, hva, page_level_size(level));
> This will get a false negative if a hva+size spans two contiguous regions.
>
> Also, storing a boolean return in a variable that is an int _and_ was already used
> for the kernel's standard 
>
>> +			mutex_unlock(&kvm->lock);
> This is also subject to races, e.g. userspace unregisters the hva immediately
> after this check, before KVM makes whatever conversion it makes below.
>
> A linear walk through a list to find a range is also a bad idea, e.g. pathological
> worst case scenario is that userspace has created tens of thousands of individual
> regions.  There is no restriction on the number of regions, just the number of
> pages that can be pinned.
>
> I dislike the svm_(un)register_enc_region() scheme in general, but at least for
> SEV and SEV-ES the code is isolated, e.g. KVM is little more than a dump pipe to
> let userspace pin pages.  I would like to go the opposite direction and work towards
> eliminating regions_list (or at least making it optional), not build more stuff
> on top.

If we don't nuke the page from the direct map and region_list removed
then we no longer need to have all the above complexity in the PSC.  PSC
can be as simple as 1) map the page in NPF and 2) update the RMP table.


> The more I look at this, the more strongly I feel that private <=> shared conversions
> belong in the MMU, and that KVM's SPTEs should be the single source of truth for
> shared vs. private.  E.g. add a SPTE_TDP_PRIVATE_MASK in the software available bits.
> I believe the only hiccup is the snafu where not zapping _all_ SPTEs on memslot
> deletion breaks QEMU+VFIO+GPU, i.e. KVM would lose its canonical info on unrelated
> memslot deletion.
>
> But that is a solvable problem.  Ideally the bug, wherever it is, would be root
> caused and fixed.  I believe Peter (and Marc?) is going to work on reproducing
> the bug.
We have been also setting up VM with Qemu + VFIO + GPU usecase to repro
the bug on AMD HW and so far we no luck in reproducing it. Will continue
stressing the system to recreate it. Lets hope that Peter (and Marc) can
easily recreate on Intel HW so that we can work towards fixing it.
>
> If we are unable to root cause and fix the bug, I think a viable workaround would
> be to clear the hardware present bit in unrelated SPTEs, but keep the SPTEs
> themselves.  The idea mostly the same as the ZAPPED_PRIVATE concept from the initial
> TDX RFC.  MMU notifier invalidations, memslot removal, RMP restoration, etc... would
> all continue to work since the SPTEs is still there, and KVM's page fault handler
> could audit any "blocked" SPTE when it's refaulted (I'm pretty sure it'd be
> impossible for the PFN to change, since any PFN change would require a memslot
> update or mmu_notifier invalidation).
>
> The downside to that approach is that it would require walking all SPTEs to do a
> memslot deletion, i.e. we'd lose the "fast zap" behavior.  If that's a performance
> issue, the behavior could be opt-in (but not for SNP/TDX).
>
>> +			if (!rc)
>> +				return -EINVAL;
>> +
>> +			/*
>> +			 * Mark the userspace range unmerable before adding the pages
>> +			 * in the RMP table.
>> +			 */
>> +			mmap_write_lock(kvm->mm);
>> +			rc = snp_mark_unmergable(kvm, hva, page_level_size(level));
>> +			mmap_write_unlock(kvm->mm);
> As mentioned in an earlier patch, this simply cannot work.
As discussed in the previous patches, will drop the support for nuking
the page from direct map; this will keep ksm happy and no need to mark
vma unmergable.
>
>> +			if (rc)
>> +				return -EINVAL;
>> +		}
>> +
>> +		write_lock(&kvm->mmu_lock);
>> +
>> +		rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
> Same comment about the bool into int. Though in this case I'd say have
> kvm_mmu_get_tdp_walk() return 0/-errno, not a bool.  Boolean returns for helpers
> without "is_", "test_", etc... are generally confusing.
>
>> +		if (!rc) {
>> +			/*
>> +			 * This may happen if another vCPU unmapped the page
>> +			 * before we acquire the lock. Retry the PSC.
>> +			 */
>> +			write_unlock(&kvm->mmu_lock);
>> +			return 0;
> How will the caller (guest?) know to retry the PSC if KVM returns "success"?

If a guest is adhering to the GHCB spec then it will see that hypervisor
has not processed all the entry and it should retry the PSC.


>> +		}
>> +
>> +		/*
>> +		 * Adjust the level so that we don't go higher than the backing
>> +		 * page level.
>> +		 */
>> +		level = min_t(size_t, level, npt_level);
>> +
>> +		trace_kvm_snp_psc(vcpu->vcpu_id, pfn, gpa, op, level);
>> +
>> +		switch (op) {
>> +		case SNP_PAGE_STATE_SHARED:
>> +			rc = snp_make_page_shared(kvm, gpa, pfn, level);
>> +			break;
>> +		case SNP_PAGE_STATE_PRIVATE:
>> +			rc = rmp_make_private(pfn, gpa, level, sev->asid, false);
>> +			break;
>> +		default:
>> +			rc = -EINVAL;
> Not that it really matters, because I don't think the MADV_* approach is viable,
> but this neglects to undo snp_mark_unmergable() on failure.
>
>> +			break;
>> +		}
>> +
>> +		write_unlock(&kvm->mmu_lock);
>> +
>> +		if (rc) {
>> +			pr_err_ratelimited("Error op %d gpa %llx pfn %llx level %d rc %d\n",
>> +					   op, gpa, pfn, level, rc);
>> +			return rc;
>> +		}
>> +
>> +		gpa = gpa + page_level_size(level);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>>  {
>>  	struct vmcb_control_area *control = &svm->vmcb->control;

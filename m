Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A462142FD88
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 23:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243150AbhJOVik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 17:38:40 -0400
Received: from mail-bn8nam08on2081.outbound.protection.outlook.com ([40.107.100.81]:35425
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238695AbhJOVik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 17:38:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PO8gje/yQCqTn7Em7nYlVvdm024a19UoI32pbcb93zUNCX3elgUkCHw7FYHh3fiJ+tJk/50azVVvZclonhtU2WpWTdkRimSCxGC/9JDAdNYRHz0eFBEf8uz4+Sc4Wc94mn4uZPLqNRkBKlDsqZxhGtRbnG4jPQTptMNtri2FkmQ5Il0Su68jpa7s4r31BxqE3d3Wh+hCLeM7uQuEd3xIH649QKwvgYaPCJxHeEWOtx7Ne/QKDXsaNxADln8Jm0bU4fXuV8ZTksbG8wJ5QIYcPtMsEqbkZRfpL0f9k53XT3YrjG2uRQ8jkDc/dOHLhqmXQYD906QrnENp/TiBCPpmTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P3h9fz5Ki3AHgK4Hewb5FRWNN6JZtTriZgagUjliRao=;
 b=SLvJ3Is7EQbQzt+e1MFqdOM9n2SZjOvIDdIGXpTgEsxZYv7qvHBFzGg6gE8AiJO6Bl0KaxSA9OkGJtN8YPdXu6A9np2hcSt2r2yffAvIAMs8H2Dz7M7rMrPNtrDhsGOsF4U+pXCOnSKVu55EJ4dKV08V5oNNs+HrS0wGVIuoEE0GndVPhax2ATIMrjLc9xJPsTEMmoPY3tg3JQGWXufDXAeG+ukIz88HoMXKiAR3byjQBKQypFPGLnr9XJfm7+5TrjE6gKNO4TrcFuMXFyYJNeWSKU57WBaF3/8m1dyLYuwQQW2lJBOfG0GBAPkvzZdkAFsfBXfZ+kkoD/zAE3THyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3h9fz5Ki3AHgK4Hewb5FRWNN6JZtTriZgagUjliRao=;
 b=ICwO1JirfmwmPb+CT4CqTnVRt5XbKIVBE/GhtQXl6ClPO3w8vaqlnwQQfVWEnD7nAwnXnXFMiXi4i9hpRtMtyQjCkd3Dx/ZOBKvBQkFiJq9VrvPLWAv7LceeKhQPdikoH2KB7Wesiag0934LVr2foLoy7Z5BKHGidzf45ZFSARk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5414.namprd12.prod.outlook.com (2603:10b6:8:3e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 15 Oct
 2021 21:36:31 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%7]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 21:36:30 +0000
Subject: Re: [PATCH 3/5 V10] KVM: SEV: Add support for SEV-ES intra host
 migration
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     Marc Orr <marcorr@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20211012204858.3614961-1-pgonda@google.com>
 <20211012204858.3614961-4-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <00cba883-204e-67ea-8dba-3e834af1aa6e@amd.com>
Date:   Fri, 15 Oct 2021 16:36:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20211012204858.3614961-4-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P221CA0021.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::26) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA9P221CA0021.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 21:36:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f33579e3-7810-47ff-e0c4-08d99023da02
X-MS-TrafficTypeDiagnostic: DM8PR12MB5414:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB5414BCB269F574EA5B18C90CECB99@DM8PR12MB5414.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UVQROzawNa02iis5xy5CBIkU/QV52gf0CG9BKYfItjG/y60pP2rBZNXYvaUwNSZilbW61RRqTbrqmkjO4MckHdc14N7cVYhXHtO/Ac/amHEHqlQflCVcTPTc2Lih/8jb2LJrcFzME1lZ8yosbKZpGcCYEzs6/zcw1bS/OjdrecNDSlQrFZexVGW5CpWLnDxU7eeP7R6zL2PN6ofuO948+fVidlpWcILiuS7fjup6aFVguyaYgFeBtKPdbv6Ckg9w1NRyWRcW34z0fUOzOvkapNCrmctwkqRpob2yJe/xmwkQixmTfQi3XwFYqFFd/uB+Vcuu3zpho+8MC1/fhWKCJPAL4Z0JT6urEIJ/hf8sDjmYaLHfqiHz0nm+ZS4xEpXh353ZwpsbzN7V92pRjHnwEVHvUl6ddyljxGSOVgnlu5N4W7U3QLpyZ1l7aeM3E51uH98f65RUVErBTbOv+QQvCFhfvIi4VJAZidbI0UauJgkSlXFcWyQyy1atVz463XDO4MrmgEAHZnwXlsUk9cKYG6z5QojdM9FQfmlixqI1c3rr4EbxyEfZH08XOINTbdAFqSLEUNuNV0Hbx02pBR0meh5oS0H9G+UUni67FZ7cLdInZvdN7afqMRoiMUN2p39Ur92sOkeAgmGgXsN6i5VXU5vDtzZjic1UbOaNRjsmJlYqy4O6nOIgpfC6pJCbMlH1UINiYITINQzSSjuV5MM5hlSnbMIuDcAsCg2rpEXYq3VLK/+9uv5NhSwn6gxjiUJo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(31696002)(4326008)(508600001)(7416002)(54906003)(86362001)(53546011)(26005)(31686004)(6486002)(8936002)(316002)(36756003)(38100700002)(66556008)(956004)(66476007)(66946007)(2616005)(6512007)(186003)(2906002)(6506007)(5660300002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0x1N2lGSFZLVjRXazRZZW54R1grUEZSRjBkQVgxMU5aZ3RZaUlRdGJxcEs3?=
 =?utf-8?B?L1FISlRPcFV5THU2cTVYc3YrTTVNdm9MNVo3eWU2TkFITlZTelZvRU1jbWtU?=
 =?utf-8?B?MENieCtHM0V1c210YTJraldGa24zb2srNUVlUmFqUUZsUTIvemhRQjVGLy9C?=
 =?utf-8?B?WS81M3Buakpmd3B5VGxJVEkyYWJBZG1QYzVoYkhUZUVsU2VNNjFGYWttVlhB?=
 =?utf-8?B?QnhsbWQ4c2JWNGkzQUoyRXdTejRDM202U0wrcTVPWFpNOHhyVTNaR1dlMWRw?=
 =?utf-8?B?Y2dyUW1qTVlsL0xyMmEwQXZlVHhBWUFtMFEwSkpKK3NNRHZWNENFcnc5cVVs?=
 =?utf-8?B?ZnBKa3dKamtpREtNNFZQVEQyOUF1d01MTmY1WmlBQ1d5Z0d2V0hZT2JLS2cx?=
 =?utf-8?B?a0RtS3JrYW05elFJcDNSQjNQZFNaTmN0SVF3NWljOG5aY2xKdWZWU1lseXps?=
 =?utf-8?B?VHRkQTRRMFNNOEM5cDVtUDljWTh6VTg4Rm9nNjdCWHRKeXdvam1WMmhmaFAy?=
 =?utf-8?B?NlhEVVBndUJZSTdrNm9vYytaZXZkOVU3Sm1SYlFTZ2dvdmYydjV1OFV5RDhx?=
 =?utf-8?B?ZStHY3JReVRod05HOG9vRGhINnMrUmRTQzF0WE5aVGlHRzlRcXVPV1pJVzNh?=
 =?utf-8?B?bGdXSUJoeGtlSS9ISjhjd2xwRVdPU2lNU2xJV1RvaWI3WnhSc0FuUG9qelFr?=
 =?utf-8?B?K2pFTzArTUVhWVkvellET25FY1JOb1NrTm9sVHBRZ0JSLzBFZnMvdDZBQ3Bp?=
 =?utf-8?B?cC9ueUpPRVU3eDFsZ1dFTUJ6dktXcWpNeG0xWFdKeHdPL1F0SHhXQy9BSktH?=
 =?utf-8?B?cXNMaWhCZG9ucXdnVWgyd1NWekNsRUt3QktVWFNBa0VORytNbzlkUktrS0o5?=
 =?utf-8?B?WXhabTg1VHZRTS8zWklQdHFwWXc3Sm9mcEtrei9wZ0o4NGlqM2VQcE5HdGdE?=
 =?utf-8?B?T1duMHByQWw2UzZzcmlSZjl0d1NiM3MrTW50N3lUNkpVR2wwQndHN2VtZWhI?=
 =?utf-8?B?K1ZabkVWN1lzZU9IOVViVUxYUHFrNHlxeXJEUmZWY2xWMm40M1ZxclhpZG05?=
 =?utf-8?B?SzFjVmQ1NE9Kd1RRYUpTbVFPd1Y1TitneWtwOGQ1QXpvcjF6cktCbUFoWXE2?=
 =?utf-8?B?REtVanFla09ZdkdsSUF5OEhKY0hIWjZVbVJYVHNZYkNQMHRPNHg5RWlZbE1s?=
 =?utf-8?B?eFg3c1hSZFhtUE1pa3lwalFyMm81c2c0VjF4YU80MXlmZDR5YzQxTWpyNWhy?=
 =?utf-8?B?RG9GYm9yQ2lESmVsNHlQOXpLNnExTE9iS01pRWVWV3B2eVBVYTVPcmNDeEFX?=
 =?utf-8?B?bmFMWG9EN28wWVFScVhROXNRdVhYRzZnbmpvTWwxQ0JidXlwTHhMcVlUSi9u?=
 =?utf-8?B?ZlNmYVVMdmZqdnZ4eEYvUFJwRTI5OFh5Z3M4TmozRXBBZG0zYmQ3SGFwQjZE?=
 =?utf-8?B?MUVDL0tEbDVSOVZUSHAyR2ZlWmdzQW0rWTZMeVBJTGdBWUdnbHVla282MVRu?=
 =?utf-8?B?MHdINHF6VFJPM2lObFh0L3pRZlBXdklrTTBaN3NldWZRUlBXYkZDTzc1OGFi?=
 =?utf-8?B?SHZDbW9lQVFTdm5udHB0UDJ5bDllVmg0UitNR3ZUTEZOUUZQNno0blFJSHVJ?=
 =?utf-8?B?b2dQemE1MXN6K0JQUHhtd3VhaWNkeGZ1bDFLVjFoanRvRUE1eUZzRTIrRnBV?=
 =?utf-8?B?Tjd2a2MzTlVDZEphdzdIYURFNWV5Y01vZ3FJTnRIRHQ1TjVPb00vbFFsSktj?=
 =?utf-8?Q?0HSBmK4eil+i7cB1L6p5Sh5x/XON0qPHbcOMMj0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f33579e3-7810-47ff-e0c4-08d99023da02
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 21:36:30.6906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mLCjp/iKyUxUiVifTnVyoPugPkKFWhDZKS3UCUGMBS29NdHUhwODPenoVMrN+RELNjr0ZVxaUSBGZhf7RB6vcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5414
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/21 3:48 PM, Peter Gonda wrote:
> For SEV-ES to work with intra host migration the VMSAs, GHCB metadata,
> and other SEV-ES info needs to be preserved along with the guest's
> memory.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   arch/x86/kvm/svm/sev.c | 48 +++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 42ff1ccfe1dc..a486ab08a766 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1600,6 +1600,46 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
>   	list_replace_init(&src->regions_list, &dst->regions_list);
>   }
>   
> +static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
> +{
> +	int i;
> +	struct kvm_vcpu *dst_vcpu, *src_vcpu;
> +	struct vcpu_svm *dst_svm, *src_svm;
> +
> +	if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
> +		return -EINVAL;
> +
> +	kvm_for_each_vcpu(i, src_vcpu, src) {
> +		if (!src_vcpu->arch.guest_state_protected)
> +			return -EINVAL;
> +	}
> +
> +	kvm_for_each_vcpu(i, src_vcpu, src) {
> +		src_svm = to_svm(src_vcpu);
> +		dst_vcpu = kvm_get_vcpu(dst, i);
> +		dst_svm = to_svm(dst_vcpu);
> +
> +		/*
> +		 * Transfer VMSA and GHCB state to the destination.  Nullify and
> +		 * clear source fields as appropriate, the state now belongs to
> +		 * the destination.
> +		 */
> +		dst_vcpu->vcpu_id = src_vcpu->vcpu_id;
> +		memcpy(&dst_svm->sev_es, &src_svm->sev_es,
> +		       sizeof(dst_svm->sev_es));
> +		dst_svm->vmcb->control.ghcb_gpa =
> +				src_svm->vmcb->control.ghcb_gpa;
> +		dst_svm->vmcb->control.vmsa_pa = __pa(dst_svm->sev_es.vmsa);
> +		dst_vcpu->arch.guest_state_protected = true;

Maybe just add a blank line here to separate the setting and clearing 
(only if you have to do another version).

> +		src_svm->vmcb->control.ghcb_gpa = 0;
> +		src_svm->vmcb->control.vmsa_pa = 0;
> +		src_vcpu->arch.guest_state_protected = false;

In the previous patch you were clearing some of the fields that are now in 
the vcpu_sev_es_state. Did you want to memset that to zero now?

Thanks,
Tom

> +	}
> +	to_kvm_svm(src)->sev_info.es_active = false;
> +
> +	return 0;
> +}
> +

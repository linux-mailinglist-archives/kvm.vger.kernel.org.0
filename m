Return-Path: <kvm+bounces-1145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AEEF77E526E
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 10:12:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5088AB21066
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 09:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E6DDF63;
	Wed,  8 Nov 2023 09:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="n5/hAEXf"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D05FDDD1;
	Wed,  8 Nov 2023 09:11:49 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9920D1A7;
	Wed,  8 Nov 2023 01:11:48 -0800 (PST)
Received: from [IPV6:2a02:a420:40:b6ea:bd47:84b4:35b0:c3f1] (77-63-99-98.mobile.kpn.net [77.63.99.98])
	by linux.microsoft.com (Postfix) with ESMTPSA id BC45120B74C0;
	Wed,  8 Nov 2023 01:11:37 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BC45120B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1699434708;
	bh=fSNLSSBG95PkWpM5rxlYaA3C46U8XXsKOZIEDIAiboE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=n5/hAEXf2dzieMftcO0zozxDGKiOud7ouqdRWRPbYAjhcj9YDX3kLItujrlDhh2Px
	 IumdNzPkTleQsQKkPXu9ABOj7og39wtcOiR1e4DDBJsrI7sD+nqGZ6ATkTCM5UjjoV
	 P0i0NRIhvFLS18I+cPLvv7OxYeP4osdJV2s5dz78=
Message-ID: <ec53f4fb-5b87-42db-8751-d7e7224c79ec@linux.microsoft.com>
Date: Wed, 8 Nov 2023 10:11:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/50] x86/sev: Add the host SEV-SNP initialization
 support
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com,
 dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
 ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
 liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-7-michael.roth@amd.com>
 <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
 <4a2016d6-dc1f-ff68-9827-0b72b7c8eac2@amd.com>
 <20231107191931.GCZUqNwxP8JcSbjZ0/@fat_crate.local>
 <20231107202757.GEZUqdzYyzVBHTBhZX@fat_crate.local>
 <250f5513-91c0-d0b5-cb59-439e26ba16dc@amd.com>
 <20231107212740.GFZUqrzK7yzy41dRKp@fat_crate.local>
 <20231107220852.GGZUq1dHJ2q9LYV2oG@fat_crate.local>
 <4b68fd05-5d21-0472-42c3-6cf6f1f9f967@amd.com>
 <20231108061413.GAZUsnNVcmYZNMw2Kr@fat_crate.local>
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <20231108061413.GAZUsnNVcmYZNMw2Kr@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 08/11/2023 07:14, Borislav Petkov wrote:
> On Tue, Nov 07, 2023 at 04:33:41PM -0600, Kalra, Ashish wrote:
>> We will still need some method to tell the IOMMU driver if SNP
>> support/feature is disabled by this function, for example, when CPU family
>> and model is not supported by SNP and we jump to no_snp label.
> 
> See below.
> 
>> The reliable way for this to work is to ensure snp_rmptable_init() is called
>> before IOMMU initialization and then IOMMU initialization depends on SNP
>> feature flag setup by snp_rmptable_init() to enable SNP support on IOMMU or
>> not.
> 
> Yes, this whole SNP initialization needs to be reworked and split this
> way:

I agree with Borislav and have some comments of my own.

> 
> - early detection work which needs to be done once goes to
>   bsp_init_amd(): that's basically your early_detect_mem_encrypt() stuff
>   which needs to happen exactly only once and early.
> 
> - Any work like:
> 
> 	 c->x86_phys_bits -= (cpuid_ebx(0x8000001f) >> 6) & 0x3f;
> 
>   and the like which needs to happen on each AP, gets put in a function
>   which gets called by init_amd().
> 
> By the time IOMMU gets to init, you already know whether it should
> enable SNP and check X86_FEATURE_SEV_SNP.

This flow would suit me better too. In SNP-host capable Hyper-V VMs there
is no IOMMU and I've had to resort to early return from amd_iommu_snp_enable()
to prevent it from disabling SNP [1]. In addition to what Borislav posted,
you'd just need to enforce that if IOMMU is detected it actually gets enabled.

[1]: https://lore.kernel.org/lkml/20230213103402.1189285-6-jpiotrowski@linux.microsoft.com/

> 
> Finally, you call __snp_rmptable_init() which does the *per-CPU* init
> work which is still pending.

Yes please, and the only rmp thing left to do per-CPU would be to check that the MSRs are
set the same as the value read from CPU0.

Running the early_rmptable_check() from early_detect_mem_encrypt() and on every CPU
makes it difficult to support a kernel allocated RMP table. If you look at what I did
for the mentioned Hyper-V SNP-host VMs [2] (which I think is reasonable) the RMP table
is allocated in init_mem_mapping() and the addresses are propagated to other CPUs through 
hv_cpu_init(), which is called from cpuhp_setup_state(CPUHP_AP_HYPERV_ONLINE, ...). So
it would be great if any init works plays nice with cpu hotplug notifiers.

[2]: https://lore.kernel.org/lkml/20230213103402.1189285-2-jpiotrowski@linux.microsoft.com/

Thanks,
Jeremi

> 
> Ok?
> 
> Ontop of the previous ontop patch:
> 
> ---
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 6cc2074fcea3..a9c95e5d6b06 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -674,8 +674,19 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>  		if (!(msr & MSR_K7_HWCR_SMMLOCK))
>  			goto clear_sev;
>  
> -		if (cpu_has(c, X86_FEATURE_SEV_SNP) && !early_rmptable_check())
> -			goto clear_snp;
> +		if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
> +			/*
> +			 * RMP table entry format is not architectural and it can vary by processor
> +			 * and is defined by the per-processor PPR. Restrict SNP support on the known
> +			 * CPU model and family for which the RMP table entry format is currently
> +			 * defined for.
> +			 */
> +			if (c->x86 != 0x19 || c->x86_model > 0xaf)
> +				goto clear_snp;
> +
> +			if (!early_rmptable_check())
> +				goto clear_snp;
> +		}
>  
>  		return;
>  
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 9237c327ad6d..5a71df9ae4cb 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -199,14 +199,6 @@ static int __init snp_rmptable_init(void)
>  	if (!amd_iommu_snp_en)
>  		return 0;
>  
> -	/*
> -	 * RMP table entry format is not architectural and it can vary by processor and
> -	 * is defined by the per-processor PPR. Restrict SNP support on the known CPU
> -	 * model and family for which the RMP table entry format is currently defined for.
> -	 */
> -	if (boot_cpu_data.x86 != 0x19 || boot_cpu_data.x86_model > 0xaf)
> -		goto nosnp;
> -
>  	if (__snp_rmptable_init())
>  		goto nosnp;
>  



Return-Path: <kvm+bounces-1142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1D8A7E51D9
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 09:22:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4A921C20D9B
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 08:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 722A5DDC1;
	Wed,  8 Nov 2023 08:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="hdt7PdHk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8093D52F;
	Wed,  8 Nov 2023 08:22:03 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29945D79;
	Wed,  8 Nov 2023 00:22:03 -0800 (PST)
Received: from [IPV6:2a02:a420:71:5cf3:d970:1912:3461:64ee] (77-63-77-130.mobile.kpn.net [77.63.77.130])
	by linux.microsoft.com (Postfix) with ESMTPSA id 9410320B74C0;
	Wed,  8 Nov 2023 00:21:53 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9410320B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1699431722;
	bh=03JP0tJ3Bi+fFo0pgjJYRDq8To5NVAbwjQsCIdj9JDs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hdt7PdHkf+50r6gE6NWW+/pIDX2zfbYOV7NoETPr3DYDNgijoTrcFeMSI6o0Edrwb
	 vFvYSXQkGL49i3UBCl5+CVuzHGSvTyTJLWc5pIqXwmSvlcd/WdIBtLOcb4TH4GpobD
	 BOs9muG+PEzuUmU9OORX5W0IrTPvUBPzQ3d+Ax6Y=
Message-ID: <503e778f-6324-44ca-b057-afe510ceea0f@linux.microsoft.com>
Date: Wed, 8 Nov 2023 09:21:51 +0100
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
To: Tom Lendacky <thomas.lendacky@amd.com>, Borislav Petkov <bp@alien8.de>,
 Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, hpa@zytor.com,
 ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
 kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
 marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-7-michael.roth@amd.com>
 <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
 <8ec38db1-5ccf-4684-bc0d-d48579ebf0d0@amd.com>
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <8ec38db1-5ccf-4684-bc0d-d48579ebf0d0@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 07/11/2023 19:32, Tom Lendacky wrote:
> On 11/7/23 10:31, Borislav Petkov wrote:
>>
>> And the stuff that needs to happen once, needs to be called once too.
>>
>>> +
>>> +    return snp_get_rmptable_info(&rmp_base, &rmp_size);
>>> +}
>>> +
>>>   static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>>>   {
>>>       u64 msr;
>>> @@ -659,6 +674,9 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>>>           if (!(msr & MSR_K7_HWCR_SMMLOCK))
>>>               goto clear_sev;
>>>   +        if (cpu_has(c, X86_FEATURE_SEV_SNP) && !early_rmptable_check())
>>> +            goto clear_snp;
>>> +
>>>           return;
>>>     clear_all:
>>> @@ -666,6 +684,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>>>   clear_sev:
>>>           setup_clear_cpu_cap(X86_FEATURE_SEV);
>>>           setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
>>> +clear_snp:
>>>           setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
>>>       }
>>>   }
>>
>> ...
>>
>>> +bool snp_get_rmptable_info(u64 *start, u64 *len)
>>> +{
>>> +    u64 max_rmp_pfn, calc_rmp_sz, rmp_sz, rmp_base, rmp_end;
>>> +
>>> +    rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
>>> +    rdmsrl(MSR_AMD64_RMP_END, rmp_end);
>>> +
>>> +    if (!(rmp_base & RMP_ADDR_MASK) || !(rmp_end & RMP_ADDR_MASK)) {
>>> +        pr_err("Memory for the RMP table has not been reserved by BIOS\n");
>>> +        return false;
>>> +    }
>>
>> If you're masking off bits 0-12 above...
> 
> Because the RMP_END MSR, most specifically, has a default value of 0x1fff, where bits [12:0] are reserved. So to specifically check if the MSR has been set to a non-zero end value, the bit are masked off. However, ...
> 

Do you have a source for this? Because the APM vol. 2, table A.7 says the reset value of RMP_END is all zeros.

Thanks,
Jeremi



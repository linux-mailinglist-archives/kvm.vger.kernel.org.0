Return-Path: <kvm+bounces-3934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C514980AA27
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 18:09:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 521C81F21171
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 17:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A69F638DF9;
	Fri,  8 Dec 2023 17:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="BR+eQu4R"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4692AAD;
	Fri,  8 Dec 2023 09:09:24 -0800 (PST)
Received: from [192.168.178.49] (dynamic-adsl-84-220-28-122.clienti.tiscali.it [84.220.28.122])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4D6C620B74C0;
	Fri,  8 Dec 2023 09:09:15 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4D6C620B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1702055363;
	bh=9l5Ru2o2nTcnqhIvnh2spJXetvDDmWSNf5VpeRTEbg8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BR+eQu4RJTh0ceQuXPjHpA9kHIzOrd0+p5df/UHzA0eGNYqc7rUGlPbQK5a/OmO7F
	 BbSngliMq/ni3wzjMbXTyzXGGeWj/BPeGnENYV5rl5q2z1u31ztbdarZNon2OuZnsr
	 0mfhXeVkJmSZMWdfLpcgO7+g7mYQigjJ7RHMbUDM=
Message-ID: <68b2d6bf-bce7-47f9-bebb-2652cc923ff9@linux.microsoft.com>
Date: Fri, 8 Dec 2023 18:09:13 +0100
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
To: "Kalra, Ashish" <ashish.kalra@amd.com>, Borislav Petkov <bp@alien8.de>,
 Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
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
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <4a2016d6-dc1f-ff68-9827-0b72b7c8eac2@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 07/11/2023 20:00, Kalra, Ashish wrote:
> Hello Boris,
> 
> Addressing of some of the remaining comments:
> 
> On 11/7/2023 10:31 AM, Borislav Petkov wrote:
>> On Mon, Oct 16, 2023 at 08:27:35AM -0500, Michael Roth wrote:
>>> +static bool early_rmptable_check(void)
>>> +{
>>> +    u64 rmp_base, rmp_size;
>>> +
>>> +    /*
>>> +     * For early BSP initialization, max_pfn won't be set up yet, wait until
>>> +     * it is set before performing the RMP table calculations.
>>> +     */
>>> +    if (!max_pfn)
>>> +        return true;
>>
>> This already says that this is called at the wrong point during init.
>>
>> Right now we have
>>
>> early_identify_cpu -> early_init_amd -> early_detect_mem_encrypt
>>
>> which runs only on the BSP but then early_init_amd() is called in
>> init_amd() too so that it takes care of the APs too.
>>
>> Which ends up doing a lot of unnecessary work on each AP in
>> early_detect_mem_encrypt() like calculating the RMP size on each AP
>> unnecessarily where this needs to happen exactly once.
>>
>> Is there any reason why this function cannot be moved to init_amd()
>> where it'll do the normal, per-AP init?
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
>>
>>> +
>>> +    if (rmp_base > rmp_end) {
>>
>> ... why aren't you using the masked out vars further on?
>>
>> I know, the hw will say, yeah, those bits are 0 but still. IOW, do:
>>
>>     rmp_base &= RMP_ADDR_MASK;
>>     rmp_end  &= RMP_ADDR_MASK;
>>
>> after reading them.
>>
>>> +        pr_err("RMP configuration not valid: base=%#llx, end=%#llx\n", rmp_base, rmp_end);
>>> +        return false;
>>> +    }
>>> +
>>> +    rmp_sz = rmp_end - rmp_base + 1;
>>> +
>>> +    /*
>>> +     * Calculate the amount the memory that must be reserved by the BIOS to
>>> +     * address the whole RAM, including the bookkeeping area. The RMP itself
>>> +     * must also be covered.
>>> +     */
>>> +    max_rmp_pfn = max_pfn;
>>> +    if (PHYS_PFN(rmp_end) > max_pfn)
>>> +        max_rmp_pfn = PHYS_PFN(rmp_end);
>>> +
>>> +    calc_rmp_sz = (max_rmp_pfn << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;
>>> +
>>> +    if (calc_rmp_sz > rmp_sz) {
>>> +        pr_err("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
>>> +               calc_rmp_sz, rmp_sz);
>>> +        return false;
>>> +    }
>>> +
>>> +    *start = rmp_base;
>>> +    *len = rmp_sz;
>>> +
>>> +    return true;
>>> +}
>>> +
>>> +static __init int __snp_rmptable_init(void)
>>> +{
>>> +    u64 rmp_base, rmp_size;
>>> +    void *rmp_start;
>>> +    u64 val;
>>> +
>>> +    if (!snp_get_rmptable_info(&rmp_base, &rmp_size))
>>> +        return 1;
>>> +
>>> +    pr_info("RMP table physical address [0x%016llx - 0x%016llx]\n",
>>
>> That's "RMP table physical range"
>>
>>> +        rmp_base, rmp_base + rmp_size - 1);
>>> +
>>> +    rmp_start = memremap(rmp_base, rmp_size, MEMREMAP_WB);
>>> +    if (!rmp_start) {
>>> +        pr_err("Failed to map RMP table addr 0x%llx size 0x%llx\n", rmp_base, rmp_size);
>>
>> No need to dump rmp_base and rmp_size again here - you're dumping them
>> above.
>>
>>> +        return 1;
>>> +    }
>>> +
>>> +    /*
>>> +     * Check if SEV-SNP is already enabled, this can happen in case of
>>> +     * kexec boot.
>>> +     */
>>> +    rdmsrl(MSR_AMD64_SYSCFG, val);
>>> +    if (val & MSR_AMD64_SYSCFG_SNP_EN)
>>> +        goto skip_enable;
>>> +
>>> +    /* Initialize the RMP table to zero */
>>
>> Again: useless comment.
>>
>>> +    memset(rmp_start, 0, rmp_size);
>>> +
>>> +    /* Flush the caches to ensure that data is written before SNP is enabled. */
>>> +    wbinvd_on_all_cpus();
>>> +
>>> +    /* MFDM must be enabled on all the CPUs prior to enabling SNP. */
>>
>> First of all, use the APM bit name here pls: MtrrFixDramModEn.
>>
>> And then, for the life of me, I can't find any mention in the APM why
>> this bit is needed. Neither in "15.36.2 Enabling SEV-SNP" nor in
>> "15.34.3 Enabling SEV".
>>
>> Looking at the bit defintions of WrMem an RdMem - read and write
>> requests get directed to system memory instead of MMIO so I guess you
>> don't want to be able to write MMIO for certain physical ranges when SNP
>> is enabled but it'll be good to have this properly explained instead of
>> a "this must happen" information-less sentence.
> 
> This is a per-requisite for SNP_INIT as per the SNP Firmware ABI specifications, section 8.8.2:
> 
> From the SNP FW ABI specs:
> 
> If INIT_RMP is 1, then the firmware ensures the following system requirements are met:
> • SYSCFG[MemoryEncryptionModEn] must be set to 1 across all cores. (SEV must be
> enabled.)> • SYSCFG[SecureNestedPagingEn] must be set to 1 across all cores.
> • SYSCFG[VMPLEn] must be set to 1 across all cores.
> • SYSCFG[MFDM] must be set to 1 across all cores.

Hi Ashish,

I just noticed that the kernel shouts at me about this bit when I offline->online a CPU in
an SNP host:

[2692586.589194] smpboot: CPU 63 is now offline
[2692589.366822] [Firmware Warn]: MTRR: CPU 0: SYSCFG[MtrrFixDramModEn] not cleared by BIOS, clearing this bit
[2692589.376582] smpboot: Booting Node 0 Processor 63 APIC 0x3f
[2692589.378070] [Firmware Warn]: MTRR: CPU 63: SYSCFG[MtrrFixDramModEn] not cleared by BIOS, clearing this bit
[2692589.388845] microcode: CPU63: new patch_level=0x0a0011d1

Now I understand if you say "CPU offlining is not supported" but there's nothing currently
blocking it.

Best wishes,
Jeremi 

> • VM_HSAVE_PA (MSR C001_0117) must be set to 0h across all cores.
> • HWCR[SmmLock] (MSR C001_0015) must be set to 1 across all cores.
> 
> So, this platform enabling code for SNP needs to ensure that these conditions are met before SNP_INIT is called.
> 



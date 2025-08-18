Return-Path: <kvm+bounces-54881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 998EBB2A00E
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 13:08:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F341F7AFBFE
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 11:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91BD6310780;
	Mon, 18 Aug 2025 11:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ScUBnOQk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2716A30DEC8;
	Mon, 18 Aug 2025 11:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755515284; cv=none; b=dd9Z+i4qi2z4s5WXzr2oENA2f0anxSLeCUqunbXsi68wRKiSkSFzox4EJMwz6QW2oCC3psk80Z4IKVjiclw7fK1wN7AKWyFIrs4/G0JNrLibFhChXj05eyxme98Vy/c1jvqdSBQIl1r5x1dbHM7fAXtaQRHQ9E0K6iKpajygEDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755515284; c=relaxed/simple;
	bh=ffgUsvd77TsbspquWzoqIdtZOr+Pid+yR5NKJ3MwtCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WYAB97lU1EowEGZPVhT5fCCxHFE0qUxH6OeDSEPeyEMNQkRouCmk1HL9d6pHWCsnJNrcxykL8LkUwWcuP5287TDSZnMLXgGsD8TwnupRR559LLMzW7mb5B8P3yocup5IMNMVBHnPkxBUEysbN7D8N5TH8OTm6WSczBBaKDVerf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ScUBnOQk; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755515283; x=1787051283;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ffgUsvd77TsbspquWzoqIdtZOr+Pid+yR5NKJ3MwtCY=;
  b=ScUBnOQknEVDRxdb5ityxFoltDfVMpdhNiwEGV4yhZG/7a33LcGHpWCs
   Chx5kWH/c4GrzeWwwE60CboWWfBnVYcXaSKSZAOXZkj3TuaRy3wFFnGIk
   XDdlLiHAbTfVFUrAmZyntZLN7pxV/7Ysa+nPNnga/4d4cEqbOiFFMI8X8
   oNMA/6kZWY1BGjbHrKjK/LbREd/8qUWc9WKrBLP1Zy6OYkv0oaW2IcTDP
   nChDyP0qE8n0grH3u01Jyoy113HngH0vnv2buLt55f1a7aaQn+pPZOzrT
   NABCA652a8E1QSHQZTcVwDghJ1vFVmA9Vs/jxSy0S4rGCoyFyb+v56/oD
   A==;
X-CSE-ConnectionGUID: c3Jd/NTIRlmd9rZMunhKew==
X-CSE-MsgGUID: a7GZ7LoYTdyNNlX0lzYX/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="57882612"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="57882612"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 04:08:03 -0700
X-CSE-ConnectionGUID: qdMmxCq0RFC/pJw5x5ggQQ==
X-CSE-MsgGUID: vdulIUMqRlaK+nanO/DvAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="198400074"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 04:07:57 -0700
Message-ID: <c79d2944-84ba-4c65-bd48-255de39dbace@linux.intel.com>
Date: Mon, 18 Aug 2025 19:07:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
To: Korakit Seemakhupt <korakit@google.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, dionnaglaze@google.com,
 hpa@zytor.com, jgross@suse.com, jiewen.yao@intel.com, jxgao@google.com,
 kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, mingo@redhat.com, nik.borisov@suse.com,
 pbonzini@redhat.com, pgonda@google.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, tglx@linutronix.de, thomas.lendacky@amd.com,
 vkuznets@redhat.com, x86@kernel.org, vannapurve@google.com
References: <ad616489-1546-4f6a-9242-a719952e19b6@linux.intel.com>
 <20250815235552.969779-1-korakit@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250815235552.969779-1-korakit@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/16/2025 7:55 AM, Korakit Seemakhupt wrote:
>>> On 5/28/2025 11:33 PM, Sean Christopherson wrote:
>>>
>>> Summary, with the questions at the end.
>>>
>>> Recent upstream kernels running in GCE SNP/TDX VMs fail to probe the TPM due to
>>> the TPM driver's ioremap (with UC) failing because the kernel has already mapped
>>> the range using a cachaeable mapping (WB).
>>>
>>>    ioremap error for 0xfed40000-0xfed45000, requested 0x2, got 0x0
>>>    tpm_tis MSFT0101:00: probe with driver tpm_tis failed with error -12
>>>
>>> The "guilty" commit is 8e690b817e38 ("x86/kvm: Override default caching mode for
>>> SEV-SNP and TDX"), which as the subject suggests, forces the kernel's MTRR memtype
>>> to WB.  With SNP and TDX, the virtual MTRR state is (a) controlled by the VMM and
>>> thus is untrusted, and (b) _should_ be irrelevant because no known hypervisor
>>> actually honors the memtypes programmed into the virtual MTRRs.
>>>
>>> It turns out that the kernel has been relying on the MTRRs to force the TPM TIS
>>> region (and potentially other regions) to be UC, so that the kernel ACPI driver's
>>> attempts to map of SystemMemory entries as cacheable get forced to UC.  With MTRRs
>>> forced WB, x86_acpi_os_ioremap() succeeds in creating a WB mapping, which in turn
>>> causes the ioremap infrastructure to reject the TPM driver's UC mapping.
>>>
>>> IIUC, the TPM entry(s) in the ACPI tables for GCE VMs are derived (built?) from
>>> EDK2's TPM ASL.  And (again, IIUC), this code in SecurityPkg/Tcg/Tcg2Acpi/Tpm.asl[1]
>>>
>>>         //
>>>         // Operational region for TPM access
>>>         //
>>>         OperationRegion (TPMR, SystemMemory, 0xfed40000, 0x5000)
>>>
>>> generates the problematic SystemMemory entry that triggers the ACPI driver's
>>> auto-mapping logic.
>>>
>>> QEMU-based VMs don't suffer the same fate, as QEMU intentionally[2] doesn't use
>>> EDK2's AML for the TPM, and QEMU doesn't define a SystemMemory entry, just a
>>> Memory32Fixed entry.
>>>
>>> Presumably this an EDK2 bug?  If it's not an EDK2 bug, then how is the kernel's
>>> ACPI driver supposed to know that some ranges of SystemMemory must be mapped UC?
>> On 7/30/2025 3:34 PM, Binbin Wu: Wrote
>>
>> According to the ACPI spec 6.6, an operation region of SystemMemory has no
>> interface to specify the cacheable attribute.
>>
>> One solution could be using MTRRs to communicate the memory attribute of legacy
>> PCI hole to the kernel. But during the PUCK meeting last week, Sean mentioned
>> that "long-term, firmware should not be using MTRRs to communicate anything to
>> the kernel." So this solution is not preferred.
>>
>> If not MTRRs, there should be an alternative way to do the job.
>> 1. ACPI table
>>      According to the ACPI spec, neither operation region nor 32-Bit Fixed Memory
>>      Range Descriptor can specify the cacheable attribute.
>>      "Address Space Resource Descriptors" could be used to describe a memory range
>>      and the they can specify the cacheable attribute via "Type Specific Flags".
>>      One of the Address Space Resource Descriptors could be added to the ACPI
>>      table as a hint when the kernel do the mapping for operation region.
>>      (There is "System Physical Address (SPA) Range Structure", which also can
>>      specify the cacheable attribute. But it's should be used for NVDIMMs.)
>> 2. EFI memory map descriptor
>>      EFI memory descriptor can specify the cacheable attribute. Firmware can add
>>      a EFI memory descriptor for the TPM TIS device as a hint when the kernel do
>>      the mapping for operation region.
>>
>> Operation region of SystemMemory is still needed if a "Control Method" of APCI
>> needs to access a field, e.g., the method _STA. Checking another descriptor for
>> cacheable attribute, either "Address Space Resource Descriptor" or "EFI memory
>> map descriptor" during the ACPI code doing the mapping for operation region
>> makes the code complicated.
>>
>> Another thing is if long-term firmware should not be using MTRRs to to
>> communicate anything to the kernel. It seems it's safer to use ioremap() instead
>> of ioremap_cache() for MMIO resource when the kernel do the mapping for the
>> operation region access?
> Even after changing the ACPI memory resource descriptor from 32-Bit Fixed
> Memory to DWordMemory with caching parameter set to uncached, the ACPI stack still
> tries to ioremap the memory as cachable.

As mentioned above on the "Address Space Resource Descriptors", Linux kernel
currently doesn't use any other information when do the remap for Operation
Region.

If we expect the memory attribute type  in "Address Space Resource Descriptors"
to be used, it requires Linux kernel code change, and IMO this would be too
complicated.

>
> However, forcing the Operation Region to be PCI_Config instead of SystemMemory
> in the ACPI table seems to allow the vTPM device initilization to succeed as
> it avoids the vTPM region from getting ioremapped by the ACPI stack.

You can see the handler used for different space_id types in
acpi_ev_install_space_handler().

- For ACPI_ADR_SPACE_SYSTEM_MEMORY, the handler is
   acpi_ex_system_memory_space_handler(), which will remap the operation region
   before the ACPI method _STA accessing the fields inside the operation region.

- For ACPI_ADR_SPACE_PCI_CONFIG, the handler is
   acpi_ex_pci_config_space_handler(), PIO read/write is used when the offset
   is within 256 bytes.

I am curious how this could work by providing a fake PCI config space information.

Anyway, I don't think it's the right way.

>
> We have also verified that forcing the ACPI stack to use ioremap() instead of
> ioremap_cache() also allows vTPM to initialize properly. The reference change
> I made is below.

This may have some side effect on performance though.
See the commit 6d5bbf00d251, the reason why ACPI code use ioremap_cache():
     ACPI: Use ioremap_cache()

     Although the temporary boot-time ACPI table mappings
     were set up with CPU caching enabled, the permanent table
     mappings and AML run-time region memory accesses were
     set up with ioremap(), which on x86 is a synonym for
     ioremap_nocache().

     Changing this to ioremap_cache() improves performance as
     seen when accessing the tables via acpidump,
     or /sys/firmware/acpi/tables. It should also improve
     AML run-time performance.

>
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index dae6a73be40e..2771d3f66d0a 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -1821,7 +1821,7 @@ u64 x86_default_get_root_pointer(void)
>   #ifdef CONFIG_XEN_PV
>   void __iomem *x86_acpi_os_ioremap(acpi_physical_address phys, acpi_size size)
>   {
> -       return ioremap_cache(phys, size);
> +       return ioremap(phys, size);
>   }
>



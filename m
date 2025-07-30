Return-Path: <kvm+bounces-53718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCFCCB159A7
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 09:34:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB4013A9CE6
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 07:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F52128F515;
	Wed, 30 Jul 2025 07:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A5/g29fm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19E92877F4;
	Wed, 30 Jul 2025 07:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753860864; cv=none; b=MO0TIN0DtxBQLzY9lV1mY0GgOoh7+eQXNUioupY4j3CJJJA9iljq7kDoDKiPNRJCwJiEU/hej6eeOqKj24vgQSLBGcbLB1JeX3m/1MjWDZ6rcdDIqBfKY/9qY8+wWklicDU1ayUsTvQ9NvPbv10PiA/zMvouQlNqCVHGZFBikdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753860864; c=relaxed/simple;
	bh=eprvNsAi4IWBabOP6/raDSimBbRu56gi8+Hx+R9MzPo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jlWJiPuptVToK4HJOj3EIpKKrUt/qYA/gXG9m7ULZMssWMve5Ds0pZ5MtR3loxOGakNE6UG6E7s9Jmzjr6iqKVzC7uZI2e3Lntie82q3Z0ADuKJMQ99pYaxlbaeBzOUfnVZ7/pXFVBjUIqmmNPFGoJTZ3Fcy2GM/vNViQ+tp6nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A5/g29fm; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753860863; x=1785396863;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eprvNsAi4IWBabOP6/raDSimBbRu56gi8+Hx+R9MzPo=;
  b=A5/g29fmcKJcEkhFq4q1qZj/I/1vcq4UbcPPzwgl8D0GhKXUH3Q8zyUV
   nTrrA3T8Fp3PU5btrzSyitay7ptlBRGFPki1ho4KF1VNt8BepdXCBRXqp
   /VX4IjlQnoYY6e9H6J/O3sAurPD6Rw2rWYw2a0aXZ9b+9cvZMTG2jzetj
   7TjhZZQDHOiYrgUomYuPrCLfTc0eT4x6ADwfg8sL2dNwptby1SXqQ1a2d
   qZqcRr5tso09SRTo6xosLwCdpoa8S1N/d3w1TXeJ+YBZNscU8nSxi9i+S
   kB1I+VsKzPx6qoUfEtv/P7FuEH480TohvuXYkx7WicQKdFSLBsuUSgvhn
   g==;
X-CSE-ConnectionGUID: rS+TvGqcQuq+6HOunBpz/g==
X-CSE-MsgGUID: fj/iwkbDSHWklJ80MEqICQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="56240712"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="56240712"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 00:34:23 -0700
X-CSE-ConnectionGUID: 8kTXZKNeSKWoldNGFIDS4w==
X-CSE-MsgGUID: DTMXKjUwQC2s63Zl1Spn5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="162636590"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.26]) ([10.124.240.26])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 00:34:18 -0700
Message-ID: <ad616489-1546-4f6a-9242-a719952e19b6@linux.intel.com>
Date: Wed, 30 Jul 2025 15:34:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
To: Sean Christopherson <seanjc@google.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>, Jianxiong Gao <jxgao@google.com>,
 "Borislav Petkov (AMD)" <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Dionna Glaze <dionnaglaze@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
 jgross@suse.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ingo Molnar <mingo@redhat.com>, pbonzini@redhat.com,
 Peter Gonda <pgonda@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, jiewen.yao@intel.com
References: <CAMGD6P1Q9tK89AjaPXAVvVNKtD77-zkDr0Kmrm29+e=i+R+33w@mail.gmail.com>
 <0dc2b8d2-6e1d-4530-898b-3cb4220b5d42@linux.intel.com>
 <4acfa729-e0ad-4dc7-8958-ececfae8ab80@suse.com> <aIDzBOmjzveLjhmk@google.com>
 <550a730d-07db-46d7-ac1a-b5b7a09042a6@linux.intel.com>
 <aIeX0GQh1Q_4N597@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aIeX0GQh1Q_4N597@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 7/28/2025 11:33 PM, Sean Christopherson wrote:
> +Jiewen

Jiewen is out of the office until August 4th.

>
> Summary, with the questions at the end.
>
> Recent upstream kernels running in GCE SNP/TDX VMs fail to probe the TPM due to
> the TPM driver's ioremap (with UC) failing because the kernel has already mapped
> the range using a cachaeable mapping (WB).
>
>   ioremap error for 0xfed40000-0xfed45000, requested 0x2, got 0x0
>   tpm_tis MSFT0101:00: probe with driver tpm_tis failed with error -12
>
> The "guilty" commit is 8e690b817e38 ("x86/kvm: Override default caching mode for
> SEV-SNP and TDX"), which as the subject suggests, forces the kernel's MTRR memtype
> to WB.  With SNP and TDX, the virtual MTRR state is (a) controlled by the VMM and
> thus is untrusted, and (b) _should_ be irrelevant because no known hypervisor
> actually honors the memtypes programmed into the virtual MTRRs.
>
> It turns out that the kernel has been relying on the MTRRs to force the TPM TIS
> region (and potentially other regions) to be UC, so that the kernel ACPI driver's
> attempts to map of SystemMemory entries as cacheable get forced to UC.  With MTRRs
> forced WB, x86_acpi_os_ioremap() succeeds in creating a WB mapping, which in turn
> causes the ioremap infrastructure to reject the TPM driver's UC mapping.
>
> IIUC, the TPM entry(s) in the ACPI tables for GCE VMs are derived (built?) from
> EDK2's TPM ASL.  And (again, IIUC), this code in SecurityPkg/Tcg/Tcg2Acpi/Tpm.asl[1]
>
>        //
>        // Operational region for TPM access
>        //
>        OperationRegion (TPMR, SystemMemory, 0xfed40000, 0x5000)
>
> generates the problematic SystemMemory entry that triggers the ACPI driver's
> auto-mapping logic.
>
> QEMU-based VMs don't suffer the same fate, as QEMU intentionally[2] doesn't use
> EDK2's AML for the TPM, and QEMU doesn't define a SystemMemory entry, just a
> Memory32Fixed entry.
>
> Presumably this an EDK2 bug?  If it's not an EDK2 bug, then how is the kernel's
> ACPI driver supposed to know that some ranges of SystemMemory must be mapped UC?
According to the ACPI spec 6.6, an operation region of SystemMemory has no
interface to specify the cacheable attribute.

One solution could be using MTRRs to communicate the memory attribute of legacy
PCI hole to the kernel. But during the PUCK meeting last week, Sean mentioned
that "long-term, firmware should not be using MTRRs to communicate anything to
the kernel." So this solution is not preferred.

If not MTRRs, there should be an alternative way to do the job.
1. ACPI table
    According to the ACPI spec, neither operation region nor 32-Bit Fixed Memory
    Range Descriptor can specify the cacheable attribute.
    "Address Space Resource Descriptors" could be used to describe a memory range
    and the they can specify the cacheable attribute via "Type Specific Flags".
    One of the Address Space Resource Descriptors could be added to the ACPI
    table as a hint when the kernel do the mapping for operation region.
    (There is "System Physical Address (SPA) Range Structure", which also can
    specify the cacheable attribute. But it's should be used for NVDIMMs.)
2. EFI memory map descriptor
    EFI memory descriptor can specify the cacheable attribute. Firmware can add
    a EFI memory descriptor for the TPM TIS device as a hint when the kernel do
    the mapping for operation region.

Operation region of SystemMemory is still needed if a "Control Method" of APCI
needs to access a field, e.g., the method _STA. Checking another descriptor for
cacheable attribute, either "Address Space Resource Descriptor" or "EFI memory
map descriptor" during the ACPI code doing the mapping for operation region
makes the code complicated.

Another thing is if long-term firmware should not be using MTRRs to to
communicate anything to the kernel. It seems it's safer to use ioremap() instead
of ioremap_cache() for MMIO resource when the kernel do the mapping for the
operation region access?

>
> [1] https://github.com/tianocore/edk2/blob/master/SecurityPkg/Tcg/Tcg2Acpi/Tpm.asl#L53
> [2] https://lists.gnu.org/archive/html/qemu-devel/2018-02/msg03397.html
>
> On Thu, Jul 24, 2025, Binbin Wu wrote:
>> On 7/23/2025 10:34 PM, Sean Christopherson wrote:
>>> On Mon, Jul 14, 2025, Nikolay Borisov wrote:
>>>> On 14.07.25 г. 12:06 ч., Binbin Wu wrote:
>>>>> On 7/10/2025 12:54 AM, Jianxiong Gao wrote:
>>>>>> I tested this patch on top of commit 8e690b817e38, however we are
>>>>>> still experiencing the same failure.
>>>>>>
>>>>> I didn't reproduce the issue with QEMU.
>>>>> After some comparison on how QEMU building the ACPI tables for HPET and
>>>>> TPM,
>>>>>
>>>>> - For HPET, the HPET range is added as Operation Region:
>>>>>        aml_append(dev,
>>>>>            aml_operation_region("HPTM", AML_SYSTEM_MEMORY,
>>>>> aml_int(HPET_BASE),
>>>>>                                 HPET_LEN));
>>>>>
>>>>> - For TPM, the range is added as 32-Bit Fixed Memory Range:
>>>>>        if (TPM_IS_TIS_ISA(tpm_find())) {
>>>>>            aml_append(crs, aml_memory32_fixed(TPM_TIS_ADDR_BASE,
>>>>>                       TPM_TIS_ADDR_SIZE, AML_READ_WRITE));
>>>>>        }
>>>>>
>>>>> So, in KVM, the code patch of TPM is different from the trace for HPET in
>>>>> the patch https://lore.kernel.org/kvm/20250201005048.657470-3-seanjc@google.com/,
>>>>> HPET will trigger the code path acpi_os_map_iomem(), but TPM doesn't.
>>> Argh, I was looking at the wrong TPM resource when poking through QEMU.  I peeked
>>> at TPM_PPI_ADDR_BASE, which gets an AML_SYSTEM_MEMORY entry, not TPM_TIS_ADDR_BASE.
> ...
>
>> I guess google has defined a ACPI method to access the region for TPM TIS during
>> ACPI device probe.
>>
>>> In the meantime, can someone who has reproduced the real issue get backtraces to
>>> confirm or disprove that acpi_os_map_iomem() is trying to map the TPM TIS range
>>> as WB?  E.g. with something like so:
> Got confirmation off-list that Google's ACPI tables due trigger the kernel's
> cachable mapping logic for SYSTEM_MEMORY.
>
>   Mapping TPM TIS with req_type = 0
>   WARNING: CPU: 22 PID: 1 at arch/x86/mm/pat/memtype.c:530 memtype_reserve+0x2ab/0x460
>   Modules linked in:
>   CPU: 22 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.16.0-rc7+ #2 VOLUNTARY
>   Tainted: [W]=WARN
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/29/2025
>   RIP: 0010:memtype_reserve+0x2ab/0x460
>    __ioremap_caller+0x16d/0x3d0
>    ioremap_cache+0x17/0x30
>    x86_acpi_os_ioremap+0xe/0x20
>    acpi_os_map_iomem+0x1f3/0x240
>    acpi_os_map_memory+0xe/0x20
>    acpi_ex_system_memory_space_handler+0x273/0x440
>    acpi_ev_address_space_dispatch+0x176/0x4c0
>    acpi_ex_access_region+0x2ad/0x530
>    acpi_ex_field_datum_io+0xa2/0x4f0
>    acpi_ex_extract_from_field+0x296/0x3e0
>    acpi_ex_read_data_from_field+0xd1/0x460
>    acpi_ex_resolve_node_to_value+0x2ee/0x530
>    acpi_ex_resolve_to_value+0x1f2/0x540
>    acpi_ds_evaluate_name_path+0x11b/0x190
>    acpi_ds_exec_end_op+0x456/0x960
>    acpi_ps_parse_loop+0x27a/0xa50
>    acpi_ps_parse_aml+0x226/0x600
>    acpi_ps_execute_method+0x172/0x3e0
>    acpi_ns_evaluate+0x175/0x5f0
>    acpi_evaluate_object+0x213/0x490
>    acpi_evaluate_integer+0x6d/0x140
>    acpi_bus_get_status+0x93/0x150
>    acpi_add_single_object+0x43a/0x7c0
>    acpi_bus_check_add+0x149/0x3a0
>    acpi_bus_check_add_1+0x16/0x30
>    acpi_ns_walk_namespace+0x22c/0x360
>    acpi_walk_namespace+0x15c/0x170
>    acpi_bus_scan+0x1dd/0x200
>    acpi_scan_init+0xe5/0x2b0
>    acpi_init+0x264/0x5b0
>    do_one_initcall+0x5a/0x310
>    kernel_init_freeable+0x34f/0x4f0
>    kernel_init+0x1b/0x200
>    ret_from_fork+0x186/0x1b0
>    ret_from_fork_asm+0x1a/0x30
>    </TASK>
>
>> I tried to add an AML_SYSTEM_MEMORY entry as operation region in the ACPI
>> table and modify the _STA method to access the region for TPM TIS in QEMU, then
>> the issue can be reproduced.
>>
>> diff --git a/hw/tpm/tpm_tis_isa.c b/hw/tpm/tpm_tis_isa.c
>> index 876cb02cb5..aca2b2993f 100644
>> --- a/hw/tpm/tpm_tis_isa.c
>> +++ b/hw/tpm/tpm_tis_isa.c
>> @@ -143,6 +143,9 @@ static void build_tpm_tis_isa_aml(AcpiDevAmlIf *adev, Aml *scope)
>>       Aml *dev, *crs;
>>       TPMStateISA *isadev = TPM_TIS_ISA(adev);
>>       TPMIf *ti = TPM_IF(isadev);
>> +    Aml *field;
>> +    Aml *method;
>> +    Aml *test = aml_local(0);
>>
>>       dev = aml_device("TPM");
>>       if (tpm_tis_isa_get_tpm_version(ti) == TPM_VERSION_2_0) {
>> @@ -152,7 +155,19 @@ static void build_tpm_tis_isa_aml(AcpiDevAmlIf *adev, Aml *scope)
>>           aml_append(dev, aml_name_decl("_HID", aml_eisaid("PNP0C31")));
>>       }
>>       aml_append(dev, aml_name_decl("_UID", aml_int(1)));
>> -    aml_append(dev, aml_name_decl("_STA", aml_int(0xF)));
>> +
>> +    aml_append(dev, aml_operation_region("TPMM", AML_SYSTEM_MEMORY, aml_int(TPM_TIS_ADDR_BASE),
>> +                         TPM_TIS_ADDR_SIZE));
>> +
>> +    field = aml_field("TPMM", AML_DWORD_ACC, AML_LOCK, AML_PRESERVE);
>> +    aml_append(field, aml_named_field("TEST", 32));
>> +    aml_append(dev, field);
>> +
>> +    method = aml_method("_STA", 0, AML_NOTSERIALIZED);
>> +    aml_append(method, aml_store(aml_name("TEST"), test));
>> +    aml_append(method, aml_return(aml_int(0xF)));
>> +    aml_append(dev, method);
>
>



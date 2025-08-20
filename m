Return-Path: <kvm+bounces-55118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F857B2DA99
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 13:14:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99C1A5C25E4
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 11:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ED9F2E370C;
	Wed, 20 Aug 2025 11:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AA7nf6yL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302621E51FE;
	Wed, 20 Aug 2025 11:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755688423; cv=none; b=e58t8mi2RGh25tr3SkRo/AiwFavRzvGDC9bjoZ3b7qkvyZKzAFa/pAnghAIfdVEsfZT/03/2j5m8syuMZPKUL6nMDxc7eFPAiuqBjSzQOEcmxY5YytDzpFffQlBQeCcMx9x8wUPGNK0tpA+2lDLX4nd6fa5PYecctCQHPrNRDLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755688423; c=relaxed/simple;
	bh=ftI+0vFd7U3KBelO3oFsMb/B8qrRorPfjjmpchxRluU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=e3DFk4PCOsjZH51mkMi0xyX0GCbNrxzdVN2anNYSB9CfhNHkVLsTNbRS4RsHxbBCczNZn1q+cAIsd+UIdlTUZ0CQDCMvodU4U7ZZlflWPTkb3wP/k4wZvu0FvbWBnjmtiSavrSIqZoUWk2bhm8WVjF87jPLRgObnx/yjmYwJ364=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AA7nf6yL; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755688421; x=1787224421;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=ftI+0vFd7U3KBelO3oFsMb/B8qrRorPfjjmpchxRluU=;
  b=AA7nf6yL/YoEu+0nlFWEKO6v21G9Ve0nEvf0ukcq+UjdK/NyStYuM3nx
   7UHy2mVmSNYYcaplUqqUpCPT+N7o3vk3VMghY7nxrBWacMJ+7EyUqDyZB
   4rD7zRdjq4phcREzJaxjFq0hqW4kMId6sYmnUHMxEXYLXqnHidn7XXv7v
   bc74NflfxHZMB/jN3A4WPE3h45jVqEfDRK2zlWmdal/9x6EnavtL20A2F
   ywd5mQUyuwu0gtGKAk/2ExWqTVabD4HVFEy+9CRv0JQyoHW7E+1QwqTRw
   UfxdPkm/RyRemPvOomnbxSBUOvOl9qefjaaZ3RJ1WRT3sZEZx2uyaZhbe
   w==;
X-CSE-ConnectionGUID: I3X5K5ZPTQ2uxsRoEfAvag==
X-CSE-MsgGUID: UhjEiQAbRXuuhJaBZTyazg==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57903451"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="57903451"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 04:13:41 -0700
X-CSE-ConnectionGUID: /pL1WjWxRn6giaY6/4Nheg==
X-CSE-MsgGUID: Tfnh8Fb4RBatU4MZ+0PL3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="199104527"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.100]) ([10.124.240.100])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 04:13:36 -0700
Message-ID: <697aa804-b321-4dba-9060-7ac17e0a489f@linux.intel.com>
Date: Wed, 20 Aug 2025 19:13:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
From: Binbin Wu <binbin.wu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>
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
 <ad616489-1546-4f6a-9242-a719952e19b6@linux.intel.com>
 <CAGtprH9EL0=Cxu7f8tD6rEvnpC7uLAw6jKijHdFUQYvbyJgkzA@mail.gmail.com>
 <20641696-242d-4fb6-a3c1-1a8e7cf83b18@linux.intel.com>
Content-Language: en-US
In-Reply-To: <20641696-242d-4fb6-a3c1-1a8e7cf83b18@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/20/2025 6:03 PM, Binbin Wu wrote:
>
>
> On 8/20/2025 11:07 AM, Vishal Annapurve wrote:
>> On Wed, Jul 30, 2025 at 12:34 AM Binbin Wu <binbin.wu@linux.intel.com> wrote:
>>>
>>>
>>> On 7/28/2025 11:33 PM, Sean Christopherson wrote:
>>>> +Jiewen
>>> Jiewen is out of the office until August 4th.
>> Hi Jiewen, can we get some help in deciding the next steps here?
>
> Please see below.
>
>>
>>>> Summary, with the questions at the end.
>>>>
>>>> Recent upstream kernels running in GCE SNP/TDX VMs fail to probe the TPM due to
>>>> the TPM driver's ioremap (with UC) failing because the kernel has already mapped
>>>> the range using a cachaeable mapping (WB).
>>>>
>>>>    ioremap error for 0xfed40000-0xfed45000, requested 0x2, got 0x0
>>>>    tpm_tis MSFT0101:00: probe with driver tpm_tis failed with error -12
>>>>
>>>> The "guilty" commit is 8e690b817e38 ("x86/kvm: Override default caching mode for
>>>> SEV-SNP and TDX"), which as the subject suggests, forces the kernel's MTRR memtype
>>>> to WB.  With SNP and TDX, the virtual MTRR state is (a) controlled by the VMM and
>>>> thus is untrusted, and (b) _should_ be irrelevant because no known hypervisor
>>>> actually honors the memtypes programmed into the virtual MTRRs.
>>>>
>>>> It turns out that the kernel has been relying on the MTRRs to force the TPM TIS
>>>> region (and potentially other regions) to be UC, so that the kernel ACPI driver's
>>>> attempts to map of SystemMemory entries as cacheable get forced to UC.  With MTRRs
>>>> forced WB, x86_acpi_os_ioremap() succeeds in creating a WB mapping, which in turn
>>>> causes the ioremap infrastructure to reject the TPM driver's UC mapping.
>>>>
>>>> IIUC, the TPM entry(s) in the ACPI tables for GCE VMs are derived (built?) from
>>>> EDK2's TPM ASL.  And (again, IIUC), this code in SecurityPkg/Tcg/Tcg2Acpi/Tpm.asl[1]
>>>>
>>>>         //
>>>>         // Operational region for TPM access
>>>>         //
>>>>         OperationRegion (TPMR, SystemMemory, 0xfed40000, 0x5000)
>>>>
>>>> generates the problematic SystemMemory entry that triggers the ACPI driver's
>>>> auto-mapping logic.
>>>>
>>>> QEMU-based VMs don't suffer the same fate, as QEMU intentionally[2] doesn't use
>>>> EDK2's AML for the TPM, and QEMU doesn't define a SystemMemory entry, just a
>>>> Memory32Fixed entry.
>>>>
>>>> Presumably this an EDK2 bug?  If it's not an EDK2 bug, then how is the kernel's
>>>> ACPI driver supposed to know that some ranges of SystemMemory must be mapped UC?
>
> Checked with Jiewen offline.
>
> He didn't think there was an existing interface to tell the OS to map a
> OperationRegion of SystemMemory as UC via the ACPI table. He thought the
> OS/ACPI driver still needed to rely on MTRRs for the hint before there was an
> alternative way.
>
>
>>> According to the ACPI spec 6.6, an operation region of SystemMemory has no
>>> interface to specify the cacheable attribute.
>>>
>>> One solution could be using MTRRs to communicate the memory attribute of legacy
>>> PCI hole to the kernel. But during the PUCK meeting last week, Sean mentioned
>>> that "long-term, firmware should not be using MTRRs to communicate anything to
>>> the kernel." So this solution is not preferred.
>>>
>>> If not MTRRs, there should be an alternative way to do the job.
>>> 1. ACPI table
>>>      According to the ACPI spec, neither operation region nor 32-Bit Fixed Memory
>>>      Range Descriptor can specify the cacheable attribute.
>>>      "Address Space Resource Descriptors" could be used to describe a memory range
>>>      and the they can specify the cacheable attribute via "Type Specific Flags".
>>>      One of the Address Space Resource Descriptors could be added to the ACPI
>>>      table as a hint when the kernel do the mapping for operation region.
>>>      (There is "System Physical Address (SPA) Range Structure", which also can
>>>      specify the cacheable attribute. But it's should be used for NVDIMMs.)
>>> 2. EFI memory map descriptor
>>>      EFI memory descriptor can specify the cacheable attribute. Firmware can add
>>>      a EFI memory descriptor for the TPM TIS device as a hint when the kernel do
>>>      the mapping for operation region.
>>>
>>> Operation region of SystemMemory is still needed if a "Control Method" of APCI
>>> needs to access a field, e.g., the method _STA. Checking another descriptor for
>>> cacheable attribute, either "Address Space Resource Descriptor" or "EFI memory
>>> map descriptor" during the ACPI code doing the mapping for operation region
>>> makes the code complicated.
>>>
>>> Another thing is if long-term firmware should not be using MTRRs to to
>>> communicate anything to the kernel. It seems it's safer to use ioremap() instead
>>> of ioremap_cache() for MMIO resource when the kernel do the mapping for the
>>> operation region access?
>>>
>> Would it work if instead of doubling down on declaring the low memory
>> above TOLUD as WB, guest kernel reserves the range as uncacheable by
>> default i.e. effectively simulating a ioremap before ACPI tries to map
>> the memory as WB?
>
> It seems as hacky as this patch set?
>
>
Hi Sean,

Since guest_force_mtrr_state() also supports to force MTRR variable ranges,
I am wondering if we could use guest_force_mtrr_state() to set the legacy PCI
hole range as UC?

Is it less hacky?


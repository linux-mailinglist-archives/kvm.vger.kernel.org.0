Return-Path: <kvm+bounces-55117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8EEBB2D99D
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 12:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 300B93A9FD1
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 10:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B911F2DEA93;
	Wed, 20 Aug 2025 10:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bsfUOjvQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3172749C2;
	Wed, 20 Aug 2025 10:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755684232; cv=none; b=W2LfWYcR+fVQUB5WJEfzDSPXNqLc8gIII/rAlHMSWWi0fm3bqRoJ2AYYpi9smZVt6pp6vwGL2lROtOXX0YBFlulblV7A7x3GqXSv4CcDDQ1v3zvB5gehUp1IRkO8B+VcuO61F6ejM883BUKOnYqhvvPM7RrhDZHZvXENFAzKjuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755684232; c=relaxed/simple;
	bh=t+N6FOaqwslvw/sqlK5GRz1Qw4D7Ojh68kYHPj6SUz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IARvpkpScQab65Qa+nHS2R082nww3s25oiHj+M/oEcS8/VAcyUUiOBlrzOmjN480xzEXidf4ee9yBCok6PIbeciQwd/km3rmDSuri41NWfHk3ti0hM9177kjFoy+z/J/7GDg64s3P08LzKM7uVno/BLmEodvX1lzvivlKWQG7fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bsfUOjvQ; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755684230; x=1787220230;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t+N6FOaqwslvw/sqlK5GRz1Qw4D7Ojh68kYHPj6SUz4=;
  b=bsfUOjvQ15VMoFFOGRu8k2fqss0tCvo+BxTQ69tfRDqIDsjlOnQSB2TP
   Yi2bATkaH9MUBZPNMhpkBkjVgxfxT5GUtbSsBz8O3QxXybTDlmKkU2Pz2
   VoQmZI6fRBem/r0fguUftNjTyzJmC8SjOX0airH5FbRrFyYKTkIXxNX8x
   rXS5SEfHbG/n2h2f6d6t7GegPmBhV2kb/1OTH3z75MOVKw4GFmLoKmxNu
   GWI+UVZoWosxSmn0cTcsos3SIHmJ4mnYIdC14OjLGMCUyV1XnqGoPGpZq
   g6ySnU+t5P3a3Oku8LGtJLcW26PsOiQwY9iSChGtvj+1H2n4mXOGjBEEj
   w==;
X-CSE-ConnectionGUID: y7/RdyGUSBeJ4Atu4Z1A2g==
X-CSE-MsgGUID: XcuKFfgMQhWpx526TlXRcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57898456"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="57898456"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 03:03:48 -0700
X-CSE-ConnectionGUID: XgoySa6TQTm1c7DTODe3YA==
X-CSE-MsgGUID: fkuPTpbIQFyFVbMFxODluw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="167994273"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 03:03:44 -0700
Message-ID: <20641696-242d-4fb6-a3c1-1a8e7cf83b18@linux.intel.com>
Date: Wed, 20 Aug 2025 18:03:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
To: Vishal Annapurve <vannapurve@google.com>,
 Sean Christopherson <seanjc@google.com>
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
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <CAGtprH9EL0=Cxu7f8tD6rEvnpC7uLAw6jKijHdFUQYvbyJgkzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/20/2025 11:07 AM, Vishal Annapurve wrote:
> On Wed, Jul 30, 2025 at 12:34 AM Binbin Wu <binbin.wu@linux.intel.com> wrote:
>>
>>
>> On 7/28/2025 11:33 PM, Sean Christopherson wrote:
>>> +Jiewen
>> Jiewen is out of the office until August 4th.
> Hi Jiewen, can we get some help in deciding the next steps here?

Please see below.

>
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

Checked with Jiewen offline.

He didn't think there was an existing interface to tell the OS to map a
OperationRegion of SystemMemory as UC via the ACPI table. He thought the
OS/ACPI driver still needed to rely on MTRRs for the hint before there was an
alternative way.


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
>>
> Would it work if instead of doubling down on declaring the low memory
> above TOLUD as WB, guest kernel reserves the range as uncacheable by
> default i.e. effectively simulating a ioremap before ACPI tries to map
> the memory as WB?

It seems as hacky as this patch set?



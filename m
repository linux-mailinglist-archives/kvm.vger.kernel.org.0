Return-Path: <kvm+bounces-52411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E50A9B04E04
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 04:53:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A27C4E0BDB
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 02:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F812D0C71;
	Tue, 15 Jul 2025 02:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OayyatsQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101881A5B84;
	Tue, 15 Jul 2025 02:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752547996; cv=none; b=AoTHmd8mGZjD9gOuwwTdwLmiRPytMqqiRwU3Qy1+Rjn1m+v+jB4Tjv6LUwlUiNw5OQEzebFU0RPgc5XjZqVr5Yrci9iNsUYIn+Dbiygv4IkFW4SUeEfLanBnLmlciYKiAkBvVpmNZ0Z3yKnBuysI1hH6LWCwE3d1ZSYt4l3dO7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752547996; c=relaxed/simple;
	bh=J3tdY+zXYeG6ZJJovx/ZvkZlfYqF3Z47aosAbptPIPo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hBbdyrAIBt7geFBrp7CileD+/EqcgJb2TTE0/50a4g+9qZMIB+jUvrWArd2A9KDqbw+wUWEjB6rtTzZmeOStbhmpK3I16HEH7vx9EtvpvJXpAwrPIHZfwo2QnUiHGTiMvar9AqcChdWf4BR8WwgQ4LtELtqYdYXNdaxztxBcNUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OayyatsQ; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752547994; x=1784083994;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=J3tdY+zXYeG6ZJJovx/ZvkZlfYqF3Z47aosAbptPIPo=;
  b=OayyatsQMwc1ULx+nn+mkyVe+Y/+1nljM8BKEo6DDeWDV7FUkxpuWn3j
   YCYUa8zrWFrJYEFnva1KKrQzMLPaoLK4KOV1lP7p0BAPpKsaqH7ZcPksr
   H0B8UHm75Ok63MfyxitzNUTwEfOQKFdOsFTaV6qVXiuKrHYbgp+0MkLaw
   yQHqPYwo/3qWuDQat55VYnPPqbqYNoMImXoD5/5dD5aym+sipiWirVIKt
   Yg7U4l9y/9duWBl4Zm22Gybntzk4Pe+9h3S+5K+ksyv4HIRZV7Ju5JvAt
   brK+lMfuM3JdWeiKsEjLs4toTOYQ3Nx93zk1JXML4fUS/lHEtgVnOfdG8
   w==;
X-CSE-ConnectionGUID: xcRJMWkGTa2bz7XvaevRgg==
X-CSE-MsgGUID: OfMjM/y7SPig/y1nQV0KSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54608076"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="54608076"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 19:53:13 -0700
X-CSE-ConnectionGUID: NnaJ/l+zSBG6lpiZgEmL3Q==
X-CSE-MsgGUID: S6FZIWGYQg+vnSOtfLoiIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="188099069"
Received: from unknown (HELO [10.238.11.128]) ([10.238.11.128])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 19:53:09 -0700
Message-ID: <8137d98e-8825-415b-9282-1d2a115bb51a@linux.intel.com>
Date: Tue, 15 Jul 2025 10:53:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
To: Sean Christopherson <seanjc@google.com>,
 Nikolay Borisov <nik.borisov@suse.com>, Jianxiong Gao <jxgao@google.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Dionna Glaze <dionnaglaze@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
 jgross@suse.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ingo Molnar <mingo@redhat.com>, pbonzini@redhat.com,
 Peter Gonda <pgonda@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, kas@kernel.org,
 "Xu, Min M" <min.m.xu@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
References: <CAMGD6P1Q9tK89AjaPXAVvVNKtD77-zkDr0Kmrm29+e=i+R+33w@mail.gmail.com>
 <0dc2b8d2-6e1d-4530-898b-3cb4220b5d42@linux.intel.com>
 <4acfa729-e0ad-4dc7-8958-ececfae8ab80@suse.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <4acfa729-e0ad-4dc7-8958-ececfae8ab80@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 7/14/2025 7:24 PM, Nikolay Borisov wrote:
>
>
> On 14.07.25 г. 12:06 ч., Binbin Wu wrote:
>>
>>
>> On 7/10/2025 12:54 AM, Jianxiong Gao wrote:
>>> I tested this patch on top of commit 8e690b817e38, however we are
>>> still experiencing the same failure.
>>>
>> I didn't reproduce the issue with QEMU.
>> After some comparison on how QEMU building the ACPI tables for HPET and TPM,
>>
>> - For HPET, the HPET range is added as Operation Region:
>>      aml_append(dev,
>>          aml_operation_region("HPTM", AML_SYSTEM_MEMORY, aml_int(HPET_BASE),
>>                               HPET_LEN));
>>
>> - For TPM, the range is added as 32-Bit Fixed Memory Range:
>>      if (TPM_IS_TIS_ISA(tpm_find())) {
>>          aml_append(crs, aml_memory32_fixed(TPM_TIS_ADDR_BASE,
>>                     TPM_TIS_ADDR_SIZE, AML_READ_WRITE));
>>      }
>>
>> So, in KVM, the code patch of TPM is different from the trace for HPET in the
>> patch https://lore.kernel.org/kvm/20250201005048.657470-3-seanjc@google.com/,
>> HPET will trigger the code path acpi_os_map_iomem(), but TPM doesn't.
>>
>> I tried to hack the code to map the region to WB first in tpm_tis driver to
>> trigger the error.
>> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
>> index 9aa230a63616..62d303f88041 100644
>> --- a/drivers/char/tpm/tpm_tis.c
>> +++ b/drivers/char/tpm/tpm_tis.c
>> @@ -232,6 +232,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info)
>>          if (phy == NULL)
>>                  return -ENOMEM;
>>
>> +       ioremap_cache(tpm_info->res.start, resource_size(&tpm_info->res));
>>          phy->iobase = devm_ioremap_resource(dev, &tpm_info->res);
>>          if (IS_ERR(phy->iobase))
>>                  return PTR_ERR(phy->iobase);
>> Then I got the same error
>> [ 4.606075] ioremap error for 0xfed40000-0xfed45000, requested 0x2, got 0x0
>> [ 4.607728] tpm_tis MSFT0101:00: probe with driver tpm_tis failed with error -12
>
>
> The thing is we don't really want to get into the if (pcm != new_pcm) { branch, because even if it succeeds there then the mapping will be wrong, because we want accesses to the TPM to be uncached since that's an iomem region, whereas this error shows that the new_pcm is WB.
>
> Also looking at memtype_reserve in it there is the following piece of code:
>
> if (x86_platform.is_untracked_pat_range(start, end)) {
>      7                 if (new_type)
>      6                         *new_type = _PAGE_CACHE_MODE_WB;
>      5                 return 0;
>      4         }
>
>
> So if is_untracked_pat_range returns true then the cache mode will always be WB.
So there are two different things per my understanding:
1. The patch set https://lore.kernel.org/all/20250201005048.657470-3-seanjc@google.com/
     applied to "Guest" kernel should be able to dismiss the error message.
     In __ioremap_caller(), when branch "pcm != new_pcm" is triggered, since
     is_new_memtype_allowed() returns true for TPM range, the error message
     shouldn NOT be printed.
     Otherwise, it really confuses me.

2. Setting the PAT to WB for iomem region of TPM is not desired the target type.
    Per my understanding, it should be safe to program the "iomem" to WB.
    - If the iomem region is emulated, it's OK since the accesses will be
      trapped.
    - If the iomem region is passed-through, the EPT will use UC and the
      effective memory type will be UC.


Another solution is using MTRR MSRs as the communication channel b/t guest BIOS
and guest kernel, probably need to do the following things:
For guest BIOS (i.e, OVMF), allow it to program the MTRR MSRs
- Revert 071d2cfab8 ("OvmfPkg/Sec: Skip setup MTRR early in TD-Guest")
- Revert 3a3b12cbda ("UefiCpuPkg/MtrrLib: MtrrLibIsMtrrSupported always return
   FALSE in TD-Guest")
- Make sure OVMF doesn't toggle CR0.CD, which will trigger #VE.
For guest linux kernel
- Revert 8e690b817e38 ("x86/kvm: Override default caching mode for SEV-SNP and
   TDX")
- Make sure guest kernel doesn't toggle CR0.CD, which will trigger #VE.

Sean, do you think this solution is the direction to go?

>
>
>>
>> And with Sean's patch set, the issue can be resolved.
>>
>> I guess google's VMM has built different ACPI table for TPM.
>> But according to my experiment, the issue should be able to be fixed by this
>> patch set, though I am not sure whether it will be the final solution or not.
>



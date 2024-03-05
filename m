Return-Path: <kvm+bounces-10860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F57487140C
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 04:00:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1C541C21981
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07DCE29427;
	Tue,  5 Mar 2024 02:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="arNz0Iln"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B9C18046;
	Tue,  5 Mar 2024 02:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709607572; cv=none; b=dHtWJIatxOaw0+qoTuNjZvmJO3BVuUUxgWUQj7EwW4y9IphE8kcmFfsjiT+Ui+x1MKzBwnvCd+ukC280ifHIiOeraWqzM5aMucpX8ZBTpg6CdscJR5SvofWwKKz2BXO6XlH7+00sRXCT3kk8zaAdg5wSC3htVBwevwL6cqduQPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709607572; c=relaxed/simple;
	bh=m10ogqdrHv106k5OB8fY9EcjuKzov88CtD1qN+O1/PY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NErEqxJ0TqL3P9Su1r5C5ZzPUCViQ1PcpNTRRHXHX5u7Km0RAfeu75ueNWnQW/TIgZBwHTGnLzYu/Tk4jCoSTII2GokSftr8X4ibrugdbiYirJw16hFf+J3MN7A9TaY0ic+OcTVm91IjDLe/UobPBJfShvYbWVJ+18ppby1//O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=arNz0Iln; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709607570; x=1741143570;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=m10ogqdrHv106k5OB8fY9EcjuKzov88CtD1qN+O1/PY=;
  b=arNz0IlntIDIy9vubdTA3qG7snBX0aY/7veKGL/f8MKxW5tFo+wXtcFz
   tbkEc3JfNJBYr9a7LVbELRMUbBr7KejizgIOZtOrmoH4kQ0xVzog0JvTz
   S4zx8N2r4IZeU/w4wqSaSsp+vmEOchL+KAaQn+kejND0E0KvXn0RxAcfb
   t/shN29w3zHFDLILRqXQctgKHfpuBVDywlgUh17gy/K/bIjrX5SSuRrXH
   FluZBw+4XJfP2apvwQvaa7d522xU4JvVOgi92Lrct/4neF7IE7i8/2cpv
   ofz9cqo6G9MlE0dTYXR6NrDXl0bt62ZBAEPlZ2/BJbOVhR+jUOf0EmX31
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="4717479"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="4717479"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 18:59:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="40096009"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 18:59:25 -0800
Message-ID: <8106d06c-4359-47ef-b363-a6302e1271a4@intel.com>
Date: Tue, 5 Mar 2024 10:59:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] kvm: wire up KVM_CAP_VM_GPA_BITS for x86
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Gerd Hoffmann <kraxel@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
 <linux-kernel@vger.kernel.org>
References: <20240301101410.356007-1-kraxel@redhat.com>
 <20240301101410.356007-2-kraxel@redhat.com> <ZeXloHPV1dkOwBTe@google.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZeXloHPV1dkOwBTe@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/2024 11:15 PM, Sean Christopherson wrote:
> On Fri, Mar 01, 2024, Gerd Hoffmann wrote:
>> Add new guest_phys_bits field to kvm_caps, return the value to
>> userspace when asked for KVM_CAP_VM_GPA_BITS capability.
>>
>> Initialize guest_phys_bits with boot_cpu_data.x86_phys_bits.
>> Vendor modules (i.e. vmx and svm) can adjust this field in case
>> additional restrictions apply, for example in case EPT has no
>> support for 5-level paging.
>>
>> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
>> ---
>>   arch/x86/kvm/x86.h | 2 ++
>>   arch/x86/kvm/x86.c | 5 +++++
>>   2 files changed, 7 insertions(+)
>>
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index 2f7e19166658..e03aec3527f8 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -24,6 +24,8 @@ struct kvm_caps {
>>   	bool has_bus_lock_exit;
>>   	/* notify VM exit supported? */
>>   	bool has_notify_vmexit;
>> +	/* usable guest phys bits */
>> +	u32  guest_phys_bits;
>>   
>>   	u64 supported_mce_cap;
>>   	u64 supported_xcr0;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 48a61d283406..e270b9b708d1 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4784,6 +4784,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>   		if (kvm_is_vm_type_supported(KVM_X86_SW_PROTECTED_VM))
>>   			r |= BIT(KVM_X86_SW_PROTECTED_VM);
>>   		break;
>> +	case KVM_CAP_VM_GPA_BITS:
>> +		r = kvm_caps.guest_phys_bits;
> 
> This is not a fast path, just compute the effective guest.MAXPHYADDR on the fly
> using tdp_root_level and max_tdp_level.  But as pointed out and discussed in the
> previous thread, adverising a guest.MAXPHYADDR that is smaller than host.MAXPHYADDR
> simply doesn't work[*].
> 
> I thought the plan was to add a way for KVM to advertise the maximum *addressable*
> GPA, and figure out a way to communicate that to the guest, e.g. so that firmware
> doesn't try to use legal GPAs that the host cannot address.

 From one off-list email thread, Paolo was proposing to change the 
definition of CPUID.0x80000008:EAX[23:16] to "Maximum usable physical 
address size in bits", in detail:

  Maximum usable physical address size in bits. Physical addresses
  above this size should not be used, but will not produce a "reserved"
  page fault. When this field is zero, all bits up to PhysAddrSize are
  usable. This field is expected to be nonzero only on guests where
  the hypervisor is using nesting paging.

As I understand it, it turns bit [23:16] of EAX of CPUID 0x80000008 into 
a PV field, that is set by VMM(e.g., KVM/QEMU) and consumed by guest.

So KVM can advertise maximum addressable/usable physical address bits in 
CPUID.0x80000008:EAX[23:16] via GET_SUPPORTED_CPUID.


> Paolo, any update on this?
> 
> [*] https://lore.kernel.org/all/CALMp9eTutnTxCjQjs-nxP=XC345vTmJJODr+PcSOeaQpBW0Skw@mail.gmail.com
> 



Return-Path: <kvm+bounces-15069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99E3E8A9821
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 13:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCE4D1C210A1
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 11:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A55B15E5A1;
	Thu, 18 Apr 2024 11:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R/LiRZ2O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC39615B969;
	Thu, 18 Apr 2024 11:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713438264; cv=none; b=m6VriwhLdZC1AVZyw+n/cjQxBb9QjWXLW8gLutswBxchRxVwzcGtIsUJ6+0WLm45FxaEsQ5OmuUUhWyz0GsSyXaVY1MK2araI5otOqb2NxFYFX6L0CIyu8hekpKJSLdxAqB/G+LmVbhCrA7p2vWkJulWSJLDEVCd47UUne59hOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713438264; c=relaxed/simple;
	bh=XWOsXsu8uGtDESDHSeuY45wBrDWF50T4U1OxulxwcBA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=bISgBIEdhpN0mffxFZH5YFri9Q7P2QSx344EQAVUT9K08Aq3bb+vYsgmdumSW63OVQb2mqjHD1p7MNg/RqEiKUoHHDf8sLjF2qt9gRt9OX4M2ZQ2IT6VNusYEN3sXYEYxOv7PWzWujHdpRakZrsN9ZQk8Wxi+xbxz+cF3UCNGDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R/LiRZ2O; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713438262; x=1744974262;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=XWOsXsu8uGtDESDHSeuY45wBrDWF50T4U1OxulxwcBA=;
  b=R/LiRZ2OAjdklgtWszC/Uzwb0KBHI1QNnUi/k2SlgGqwjPINzAf8N4vT
   ZnHOWxKGaLhIYGqkTV4CQ7KMe1bI748MJ8XAqx2eXs91O8RQGmQf6WIRD
   ZaYl3MCYXjDfw6R7ChYmPsb500E78ExdXnZkBrA5tYocEL09YGn3RJXAh
   nB7Caky5C4CrJVdr0vozEnX4T+hQmpspwGHhRyl9CU6d+hkNPo0UMKTE+
   6JAsDtV55Fttj7nJ/KkJcXmAMpWZBmbL9HLnuRygAqfBRSBTCCMekRiaS
   YY3nWt4iW7AjAzIFqtDZpI0+w6bR+DAguf/W5U0NTqCN/+EeOg0ctq9KV
   w==;
X-CSE-ConnectionGUID: 4FAnzKocQCmnQItwXzRFvw==
X-CSE-MsgGUID: uLLYlEp1Rde0R6vZKHbpyA==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="12763847"
X-IronPort-AV: E=Sophos;i="6.07,212,1708416000"; 
   d="scan'208";a="12763847"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 04:04:21 -0700
X-CSE-ConnectionGUID: nSZmsw2jSJCxQQYzSBrtBw==
X-CSE-MsgGUID: drCiHTiVRSaTYdjGTz49sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,212,1708416000"; 
   d="scan'208";a="27615952"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 04:04:18 -0700
Message-ID: <dac4aa8c-94d1-475e-ae97-20229bd9ade2@linux.intel.com>
Date: Thu, 18 Apr 2024 19:04:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 110/130] KVM: TDX: Handle TDX PV MMIO hypercall
From: Binbin Wu <binbin.wu@linux.intel.com>
To: isaku.yamahata@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a4421e0f2eafc17b4703c920936e32489d2382a3.1708933498.git.isaku.yamahata@intel.com>
 <e2400cf8-ee36-4e7f-ba1f-bb0c740b045c@linux.intel.com>
In-Reply-To: <e2400cf8-ee36-4e7f-ba1f-bb0c740b045c@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/18/2024 5:29 PM, Binbin Wu wrote:
>
>> +
>> +static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
>> +{
>> +    struct kvm_memory_slot *slot;
>> +    int size, write, r;
>> +    unsigned long val;
>> +    gpa_t gpa;
>> +
>> +    KVM_BUG_ON(vcpu->mmio_needed, vcpu->kvm);
>> +
>> +    size = tdvmcall_a0_read(vcpu);
>> +    write = tdvmcall_a1_read(vcpu);
>> +    gpa = tdvmcall_a2_read(vcpu);
>> +    val = write ? tdvmcall_a3_read(vcpu) : 0;
>> +
>> +    if (size != 1 && size != 2 && size != 4 && size != 8)
>> +        goto error;
>> +    if (write != 0 && write != 1)
>> +        goto error;
>> +
>> +    /* Strip the shared bit, allow MMIO with and without it set. */
> Based on the discussion 
> https://lore.kernel.org/all/ZcUO5sFEAIH68JIA@google.com/
> Do we still allow the MMIO without shared bit?
>
>> +    gpa = gpa & ~gfn_to_gpa(kvm_gfn_shared_mask(vcpu->kvm));
>> +
>> +    if (size > 8u || ((gpa + size - 1) ^ gpa) & PAGE_MASK)
> "size > 8u" can be removed, since based on the check of size above, it 
> can't be greater than 8.
>
>
>> +        goto error;
>> +
>> +    slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(gpa));
>> +    if (slot && !(slot->flags & KVM_MEMSLOT_INVALID))
>> +        goto error;
>> +
>> +    if (!kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
> Should this be checked for write first?
>
> I check the handle_ept_misconfig() in VMX, it doesn't check write 
> first neither.
>
> Functionally, it should be OK since guest will not read the address 
> range of fast mmio.
> So the read case will be filtered out by ioeventfd_write().
> But it has take a long way to get to ioeventfd_write().
> Isn't it more efficient to check write first?

I got the reason why in handle_ept_misconfig(), it tries to do fast mmio 
write without checking.
It was intended to make fast mmio faster.
And for ept misconfig case, it's not easy to get the info of read/write.

But in this patch, we have already have read/write info, so maybe we can 
add the check for write before fast mmio?


>
>
>> +        trace_kvm_fast_mmio(gpa);
>> +        return 1;
>> +    }
>> +
>> +    if (write)
>> +        r = tdx_mmio_write(vcpu, gpa, size, val);
>> +    else
>> +        r = tdx_mmio_read(vcpu, gpa, size);
>> +    if (!r) {
>> +        /* Kernel completed device emulation. */
>> +        tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
>> +        return 1;
>> +    }
>> +
>> +    /* Request the device emulation to userspace device model. */
>> +    vcpu->mmio_needed = 1;
>> +    vcpu->mmio_is_write = write;
>> +    vcpu->arch.complete_userspace_io = tdx_complete_mmio;
>> +
>> +    vcpu->run->mmio.phys_addr = gpa;
>> +    vcpu->run->mmio.len = size;
>> +    vcpu->run->mmio.is_write = write;
>> +    vcpu->run->exit_reason = KVM_EXIT_MMIO;
>> +
>> +    if (write) {
>> +        memcpy(vcpu->run->mmio.data, &val, size);
>> +    } else {
>> +        vcpu->mmio_fragments[0].gpa = gpa;
>> +        vcpu->mmio_fragments[0].len = size;
>> +        trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, size, gpa, 
>> NULL);
>> +    }
>> +    return 0;
>> +
>> +error:
>> +    tdvmcall_set_return_code(vcpu, TDVMCALL_INVALID_OPERAND);
>> +    return 1;
>> +}
>> +
>>   static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>>   {
>>       if (tdvmcall_exit_type(vcpu))
>> @@ -1229,6 +1341,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>>           return tdx_emulate_hlt(vcpu);
>>       case EXIT_REASON_IO_INSTRUCTION:
>>           return tdx_emulate_io(vcpu);
>> +    case EXIT_REASON_EPT_VIOLATION:
>> +        return tdx_emulate_mmio(vcpu);
>>       default:
>>           break;
>>       }
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 03950368d8db..d5b18cad9dcd 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -13975,6 +13975,7 @@ EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>>     EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
>>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
>> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_mmio);
>>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
>>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
>>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index e27c22449d85..bc14e1f2610c 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -2689,6 +2689,7 @@ struct kvm_memory_slot 
>> *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
>>         return NULL;
>>   }
>> +EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
>>     bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
>>   {
>> @@ -5992,6 +5993,7 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum 
>> kvm_bus bus_idx, gpa_t addr,
>>       r = __kvm_io_bus_read(vcpu, bus, &range, val);
>>       return r < 0 ? r : 0;
>>   }
>> +EXPORT_SYMBOL_GPL(kvm_io_bus_read);
>>     int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus 
>> bus_idx, gpa_t addr,
>>                   int len, struct kvm_io_device *dev)
>
>



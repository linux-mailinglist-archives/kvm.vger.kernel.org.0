Return-Path: <kvm+bounces-21815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 347739348F0
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 09:34:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 574351C2191E
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 07:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C47DD78C71;
	Thu, 18 Jul 2024 07:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J8b8RAPY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147FE7D3F1;
	Thu, 18 Jul 2024 07:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721288014; cv=none; b=mgavwKTRDKWObDDeiyTfQi7+k1qKqvQh4X+Dw0UqyLUoDoQcnrcVoo1QD2ptJ6wCKgNRRbMEc8b+EZdzcA47FVYcajiorxQy32QAKyzI+nZnwozu1LHTunWsXPsPaRo5dEqcgdI2SjHAMEnF64iClE1iPmCccCoe7ud94TCeDPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721288014; c=relaxed/simple;
	bh=zVJAdWQ/IwEk/Sy+Dh2nXxrFJn/m57IRKW+sOy81ZwQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NPt3d7TeBCNG+Qw7PoqbqvW0zkUz5nFpnz1ZbRwRXXkWTGT1TQjcRcqeTa5I6DGPpXdGBLlrrw/wzjX6Vh1apeUoc35F5697Pri55M/LkXBvppV76P0E9GWpvJjC3irCA44VQw+NLE1SJOHwhkxb0d3awrIhqPlQ9uJYH4aB9YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J8b8RAPY; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721288013; x=1752824013;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zVJAdWQ/IwEk/Sy+Dh2nXxrFJn/m57IRKW+sOy81ZwQ=;
  b=J8b8RAPYS2vlkytKo9jhcGTgJfZL/OTrxfELx/hlaXhycRuWwe7fgEtP
   Aijj3bG/1Y9LyZ8nrSELNQ50PNSA9SF8qaEkJHNBnshHJWp6XOvulIVhe
   lgGYMkHfHZY/eYhSDtv3rb0/pHio2tAMrRSGoTIoGHi1zgjgcMp/KXmHA
   4tA1BpgMsXAg/KKIWuo5zwALx+ZMjL1hUg4P1eupwLHR38qdYS9s8aZMY
   JO8HRPs46tWl2GDLgA6Q+kwLAepXZAbW44Sr9pMJ7WAMYULoorCgASYBu
   gSl4WycVMJlBBVkELJGKBHm2xKK1HlylFKXOsTmRtgS5ykFvnrjVmnQRP
   Q==;
X-CSE-ConnectionGUID: MQyc43qCSbymRK5Yt2V21w==
X-CSE-MsgGUID: oJqIJm/XQbmGYUbgMD/Ynw==
X-IronPort-AV: E=McAfee;i="6700,10204,11136"; a="22693872"
X-IronPort-AV: E=Sophos;i="6.09,217,1716274800"; 
   d="scan'208";a="22693872"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 00:33:32 -0700
X-CSE-ConnectionGUID: CCVrYolsQm6cirAvmE3Dxg==
X-CSE-MsgGUID: LiZ4Yn0xTK2NwS2i0g7pMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,217,1716274800"; 
   d="scan'208";a="50972881"
Received: from ysheng4-mobl.ccr.corp.intel.com (HELO [10.238.2.30]) ([10.238.2.30])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 00:33:28 -0700
Message-ID: <457184ed-dcda-4363-a0c9-95b43b80a6a4@linux.intel.com>
Date: Thu, 18 Jul 2024 15:33:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 110/130] KVM: TDX: Handle TDX PV MMIO hypercall
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a4421e0f2eafc17b4703c920936e32489d2382a3.1708933498.git.isaku.yamahata@intel.com>
 <560f3796-5a41-49fb-be6e-558bbe582996@linux.intel.com>
 <20240716222514.GD1900928@ls.amr.corp.intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240716222514.GD1900928@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 7/17/2024 6:25 AM, Isaku Yamahata wrote:
> On Tue, Jun 25, 2024 at 02:54:09PM +0800,
> Binbin Wu <binbin.wu@linux.intel.com> wrote:
>
>>
>> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
>>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>>
>>> Export kvm_io_bus_read and kvm_mmio tracepoint and wire up TDX PV MMIO
>>> hypercall to the KVM backend functions.
>>>
>>> kvm_io_bus_read/write() searches KVM device emulated in kernel of the given
>>> MMIO address and emulates the MMIO.  As TDX PV MMIO also needs it, export
>>> kvm_io_bus_read().  kvm_io_bus_write() is already exported.  TDX PV MMIO
>>> emulates some of MMIO itself.  To add trace point consistently with x86
>>> kvm, export kvm_mmio tracepoint.
>>>
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>>    arch/x86/kvm/vmx/tdx.c | 114 +++++++++++++++++++++++++++++++++++++++++
>>>    arch/x86/kvm/x86.c     |   1 +
>>>    virt/kvm/kvm_main.c    |   2 +
>>>    3 files changed, 117 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>> index 55fc6cc6c816..389bb95d2af0 100644
>>> --- a/arch/x86/kvm/vmx/tdx.c
>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>> @@ -1217,6 +1217,118 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
>>>    	return ret;
>>>    }
>>> +static int tdx_complete_mmio(struct kvm_vcpu *vcpu)
>>> +{
>>> +	unsigned long val = 0;
>>> +	gpa_t gpa;
>>> +	int size;
>>> +
>>> +	KVM_BUG_ON(vcpu->mmio_needed != 1, vcpu->kvm);
>>> +	vcpu->mmio_needed = 0;
>> mmio_needed is used by instruction emulator to setup the complete callback.
>> Since TDX handle MMIO in a PV way, mmio_needed is not needed here.
> Ok, we don't need to update mmio_needed.
>
>
>>> +
>>> +	if (!vcpu->mmio_is_write) {
>> It's also needed by instruction emulator, we can use
>> vcpu->run->mmio.is_write instead.
> No because vcpu->run->mmio is shared with user space.  KVM need to stash
> it independently.
>
>
>>> +		gpa = vcpu->mmio_fragments[0].gpa;
>>> +		size = vcpu->mmio_fragments[0].len;
>> Since MMIO cross page boundary is not allowed according to the input checks
>> from TDVMCALL, these mmio_fragments[] is not needed.
>> Just use vcpu->run->mmio.phys_addr and vcpu->run->mmio.len?
> ditto.
>
>
>>> +
>>> +		memcpy(&val, vcpu->run->mmio.data, size);
>>> +		tdvmcall_set_return_val(vcpu, val);
>>> +		trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
>>> +	}
>> Tracepoint for KVM_TRACE_MMIO_WRITE is missing when it is handled in
>> userspace.
> tdx_mmio_write() has it before existing to the user space.  It matches with
> how write_mmio() behaves in x86.c.
>
> Hmm, to match with other code, we should remove
> trace_kvm_mmio(KVM_TRACE_MMIO_READ) and keep KVM_TRACE_MMIO_READ_UNSATISFIED
> in tdx_emulate_mmio().  That's how read_prepare() and read_exit_mmio() behaves.
>
> For MMIO read
> - When kernel can handle the MMIO, KVM_TRACE_MMIO_READ with data.
> - When exiting to the user space, KVM_TRACE_MMIO_READ_UNSATISFIED before
>    the exit.  No trace after the user space handled the MMIO.

For MMIO read, in the emulator, there is still a trace after the 
userspace handled the MMIO.
In complete_emulated_mmio(), if all fragments have been handled, it will
set vcpu->mmio_read_completed to 1 and call complete_emulated_io().
complete_emulated_io
     kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE)
         x86_emulate_instruction
             x86_emulate_insn
                 emulator_read_write
                     read_prepare
                         At this point, vcpu->mmio_read_completed is 1,
                         it traces KVM_TRACE_MMIO_READ with data
                         and then clear vcpu->mmio_read_completed

So to align with emulator, we should keep the trace for KVM_TRACE_MMIO_READ.


>
> For MMIO write
> - KVM_TRACE_MMIO_WRITE before handling it.
>
>
>> Also, the return code is only set when the emulation is done in kernel, but
>> not set when it's handled in userspace.
>>
>>> +	return 1;
>>> +}
>> How about the fixup as following:
>>
>> @@ -1173,19 +1173,18 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
>> static int tdx_complete_mmio(struct kvm_vcpu *vcpu) { unsigned long val = 0;
>> - gpa_t gpa; - int size; - - vcpu->mmio_needed = 0; - - if
>> (!vcpu->mmio_is_write) { - gpa = vcpu->mmio_fragments[0].gpa; - size =
>> vcpu->mmio_fragments[0].len; + gpa_t gpa = vcpu->run->mmio.phys_addr; + int
>> size = vcpu->run->mmio.len; + if (vcpu->run->mmio.is_write) { +
>> trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, size, gpa, &val); + } else {
>> memcpy(&val, vcpu->run->mmio.data, size); tdvmcall_set_return_val(vcpu,
>> val); trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val); } + +
>> tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS); return 1; }
>>
>>
>>
>>> +
>>> +static inline int tdx_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, int size,
>>> +				 unsigned long val)
>>> +{
>>> +	if (kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev, gpa, size, &val) &&
>>> +	    kvm_io_bus_write(vcpu, KVM_MMIO_BUS, gpa, size, &val))
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, size, gpa, &val);
>>> +	return 0;
>>> +}
>>> +
>>> +static inline int tdx_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, int size)
>>> +{
>>> +	unsigned long val;
>>> +
>>> +	if (kvm_iodevice_read(vcpu, &vcpu->arch.apic->dev, gpa, size, &val) &&
>>> +	    kvm_io_bus_read(vcpu, KVM_MMIO_BUS, gpa, size, &val))
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	tdvmcall_set_return_val(vcpu, val);
>>> +	trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
>>> +	return 0;
>>> +}
>>> +
>>> +static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
>>> +{
>>> +	struct kvm_memory_slot *slot;
>>> +	int size, write, r;
>>> +	unsigned long val;
>>> +	gpa_t gpa;
>>> +
>>> +	KVM_BUG_ON(vcpu->mmio_needed, vcpu->kvm);
>>> +
>> [...]
>>> +
>>> +	/* Request the device emulation to userspace device model. */
>>> +	vcpu->mmio_needed = 1;
>>> +	vcpu->mmio_is_write = write;
>> Then they can be dropped.
> We may drop mmio_needed. mmio_is_write is needed as above.
>
>
>
>>> +	vcpu->arch.complete_userspace_io = tdx_complete_mmio;
>>> +
>>> +	vcpu->run->mmio.phys_addr = gpa;
>>> +	vcpu->run->mmio.len = size;
>>> +	vcpu->run->mmio.is_write = write;
>>> +	vcpu->run->exit_reason = KVM_EXIT_MMIO;
>>> +
>>> +	if (write) {
>>> +		memcpy(vcpu->run->mmio.data, &val, size);
>>> +	} else {
>>> +		vcpu->mmio_fragments[0].gpa = gpa;
>>> +		vcpu->mmio_fragments[0].len = size;
>> These two lines can be dropped as well.
> ditto.



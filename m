Return-Path: <kvm+bounces-15062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2BD78A9630
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 11:30:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EE931F22C22
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 09:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0954E15AD9B;
	Thu, 18 Apr 2024 09:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IOvOXYGu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164AA15AAB3;
	Thu, 18 Apr 2024 09:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713432610; cv=none; b=lelzGS7unv8MGBNFmCrpv5PwykAmnBP59T3l2mqafE0bE2n+z5AasVglgtepqEQNHb7a+o/PvynB0Qia/L6OC3oQhtMTTHJS/1KfRHcbytzOkdT9rhjR6U8pBJ0G7i3/BgKaw4md8YwvVbIBzi3iR6U6MFuJg75eYxHkSLiYO6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713432610; c=relaxed/simple;
	bh=KTC/5h+4P88i8jlp71n8fmWzUjluo3avp8IXAeXSmCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Htqj2hXdTJlrAScOEeGxsme+P0A3PaMr3xhZRPZmHyaEDyyGKlCz5k0uwJo1m3B0jOBpPL/OrWTeQHp9AQHUNLKiyjMkZbBPSSQItJYvQOjb+OJ5J2zcSrRJbyg6gcQX58qt59mdaXVRpD6UeUWHVgBmO1+HS2bxh6Lf8LdLgdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IOvOXYGu; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713432608; x=1744968608;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KTC/5h+4P88i8jlp71n8fmWzUjluo3avp8IXAeXSmCc=;
  b=IOvOXYGuCWtSpJg0FFdiJQhIXbe0YLexH0ur/WHE8fJUQ+ztQorJo2dT
   Kz5xki4xmWK07HIRy2lFeHfrMKYjwui99VFzgTOFUc7Kt/Qa7d3MYP2O7
   wCtCm/PJqBPEDg751VAvH7C0HWFu+FuwvamdmFtweQGn60SdHkW5K1243
   QVJ1aYhWMLaRI7DPga4rk3VU+vMqBrs6PWMMkztbLZOTNaXPbLPxm5gfy
   ZSKltaf7vNR6wgKrC7Qbus7+qaALApXtlhjb2uzhEzzrCHpumDHztTAza
   msCTOkqVGxe7DQWzQMEaIX6zK4vWS8NoB3nGLzqWuTXF5NAdxJG0z2S4y
   g==;
X-CSE-ConnectionGUID: O5LTIcxTQlKLnBlE0psyvA==
X-CSE-MsgGUID: Y7KaU8yDSwqfyid5RRKcWw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="8832523"
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="8832523"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 02:29:50 -0700
X-CSE-ConnectionGUID: fKVN5g7GQ5SES0YEOJM/rA==
X-CSE-MsgGUID: 6fyCwlNXSn68Add3gP9mmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="23009598"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 02:29:46 -0700
Message-ID: <e2400cf8-ee36-4e7f-ba1f-bb0c740b045c@linux.intel.com>
Date: Thu, 18 Apr 2024 17:29:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 110/130] KVM: TDX: Handle TDX PV MMIO hypercall
To: isaku.yamahata@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a4421e0f2eafc17b4703c920936e32489d2382a3.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <a4421e0f2eafc17b4703c920936e32489d2382a3.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Export kvm_io_bus_read and kvm_mmio tracepoint and wire up TDX PV MMIO
> hypercall to the KVM backend functions.
>
> kvm_io_bus_read/write() searches KVM device emulated in kernel of the given
> MMIO address and emulates the MMIO.  As TDX PV MMIO also needs it, export
> kvm_io_bus_read().  kvm_io_bus_write() is already exported.  TDX PV MMIO
> emulates some of MMIO itself.  To add trace point consistently with x86
> kvm, export kvm_mmio tracepoint.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 114 +++++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/x86.c     |   1 +
>   virt/kvm/kvm_main.c    |   2 +
>   3 files changed, 117 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 55fc6cc6c816..389bb95d2af0 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1217,6 +1217,118 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
>   	return ret;
>   }
>   
> +static int tdx_complete_mmio(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long val = 0;
> +	gpa_t gpa;
> +	int size;
> +
> +	KVM_BUG_ON(vcpu->mmio_needed != 1, vcpu->kvm);
> +	vcpu->mmio_needed = 0;
> +
> +	if (!vcpu->mmio_is_write) {
> +		gpa = vcpu->mmio_fragments[0].gpa;
> +		size = vcpu->mmio_fragments[0].len;
> +
> +		memcpy(&val, vcpu->run->mmio.data, size);
> +		tdvmcall_set_return_val(vcpu, val);
> +		trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
> +	}
> +	return 1;
> +}
> +
> +static inline int tdx_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, int size,
> +				 unsigned long val)
> +{
> +	if (kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev, gpa, size, &val) &&
> +	    kvm_io_bus_write(vcpu, KVM_MMIO_BUS, gpa, size, &val))
> +		return -EOPNOTSUPP;
> +
> +	trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, size, gpa, &val);
> +	return 0;
> +}
> +
> +static inline int tdx_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, int size)
> +{
> +	unsigned long val;
> +
> +	if (kvm_iodevice_read(vcpu, &vcpu->arch.apic->dev, gpa, size, &val) &&
> +	    kvm_io_bus_read(vcpu, KVM_MMIO_BUS, gpa, size, &val))
> +		return -EOPNOTSUPP;
> +
> +	tdvmcall_set_return_val(vcpu, val);
> +	trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
> +	return 0;
> +}
> +
> +static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_memory_slot *slot;
> +	int size, write, r;
> +	unsigned long val;
> +	gpa_t gpa;
> +
> +	KVM_BUG_ON(vcpu->mmio_needed, vcpu->kvm);
> +
> +	size = tdvmcall_a0_read(vcpu);
> +	write = tdvmcall_a1_read(vcpu);
> +	gpa = tdvmcall_a2_read(vcpu);
> +	val = write ? tdvmcall_a3_read(vcpu) : 0;
> +
> +	if (size != 1 && size != 2 && size != 4 && size != 8)
> +		goto error;
> +	if (write != 0 && write != 1)
> +		goto error;
> +
> +	/* Strip the shared bit, allow MMIO with and without it set. */
Based on the discussion 
https://lore.kernel.org/all/ZcUO5sFEAIH68JIA@google.com/
Do we still allow the MMIO without shared bit?

> +	gpa = gpa & ~gfn_to_gpa(kvm_gfn_shared_mask(vcpu->kvm));
> +
> +	if (size > 8u || ((gpa + size - 1) ^ gpa) & PAGE_MASK)
"size > 8u" can be removed, since based on the check of size above, it 
can't be greater than 8.


> +		goto error;
> +
> +	slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(gpa));
> +	if (slot && !(slot->flags & KVM_MEMSLOT_INVALID))
> +		goto error;
> +
> +	if (!kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
Should this be checked for write first?

I check the handle_ept_misconfig() in VMX, it doesn't check write first 
neither.

Functionally, it should be OK since guest will not read the address 
range of fast mmio.
So the read case will be filtered out by ioeventfd_write().
But it has take a long way to get to ioeventfd_write().
Isn't it more efficient to check write first?


> +		trace_kvm_fast_mmio(gpa);
> +		return 1;
> +	}
> +
> +	if (write)
> +		r = tdx_mmio_write(vcpu, gpa, size, val);
> +	else
> +		r = tdx_mmio_read(vcpu, gpa, size);
> +	if (!r) {
> +		/* Kernel completed device emulation. */
> +		tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
> +		return 1;
> +	}
> +
> +	/* Request the device emulation to userspace device model. */
> +	vcpu->mmio_needed = 1;
> +	vcpu->mmio_is_write = write;
> +	vcpu->arch.complete_userspace_io = tdx_complete_mmio;
> +
> +	vcpu->run->mmio.phys_addr = gpa;
> +	vcpu->run->mmio.len = size;
> +	vcpu->run->mmio.is_write = write;
> +	vcpu->run->exit_reason = KVM_EXIT_MMIO;
> +
> +	if (write) {
> +		memcpy(vcpu->run->mmio.data, &val, size);
> +	} else {
> +		vcpu->mmio_fragments[0].gpa = gpa;
> +		vcpu->mmio_fragments[0].len = size;
> +		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, size, gpa, NULL);
> +	}
> +	return 0;
> +
> +error:
> +	tdvmcall_set_return_code(vcpu, TDVMCALL_INVALID_OPERAND);
> +	return 1;
> +}
> +
>   static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   {
>   	if (tdvmcall_exit_type(vcpu))
> @@ -1229,6 +1341,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   		return tdx_emulate_hlt(vcpu);
>   	case EXIT_REASON_IO_INSTRUCTION:
>   		return tdx_emulate_io(vcpu);
> +	case EXIT_REASON_EPT_VIOLATION:
> +		return tdx_emulate_mmio(vcpu);
>   	default:
>   		break;
>   	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 03950368d8db..d5b18cad9dcd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13975,6 +13975,7 @@ EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>   
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_mmio);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e27c22449d85..bc14e1f2610c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2689,6 +2689,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
>   
>   	return NULL;
>   }
> +EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
>   
>   bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
>   {
> @@ -5992,6 +5993,7 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
>   	r = __kvm_io_bus_read(vcpu, bus, &range, val);
>   	return r < 0 ? r : 0;
>   }
> +EXPORT_SYMBOL_GPL(kvm_io_bus_read);
>   
>   int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>   			    int len, struct kvm_io_device *dev)



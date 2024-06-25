Return-Path: <kvm+bounces-20453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F09A915F19
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 08:54:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9A6E284552
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 06:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A9B41465A5;
	Tue, 25 Jun 2024 06:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CdVbKaah"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB46214658A;
	Tue, 25 Jun 2024 06:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719298457; cv=none; b=oRw1oYzzc/fEN9axkBjufSHWGDhGMRpBnaDJeoeA5icW+XAJwaMyVVyBo/6Kypd3C3pw9wmq0RIKGiFkeYnNibKUjf09z/iOkONvorStWFROizH+5wTWB+iSTg8DUoNuhsI+81gemm74NezRs8Brotb4tIAyso/9vx02ZgNd/rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719298457; c=relaxed/simple;
	bh=nURvJHOP/lB/uSDflYgcOfxhZAfVduoFmIpGCwV123g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KbmN0qQzoFtYcSFVmWr6pNiFJCa1watWfMNeduo2uTbiFZDDLNU7dKfwViPDCPzu/1Tf3E69qt8sRDLh/CgaL6o5WurMHTTPgmWVe009G8hIHadVUmozqVWm/YcFEzPV31e0X7JaHj8A8NtEi7NH7llKw17ITcZvnCsZGCPCNkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CdVbKaah; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719298456; x=1750834456;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nURvJHOP/lB/uSDflYgcOfxhZAfVduoFmIpGCwV123g=;
  b=CdVbKaah/Sf9sFrZuQe99AXF5BDWT4xxrelu84vuqs3Uko+RlHYxebY1
   dPGMUUzG1FtWo3Y3TghcBekPdVzwuIxtMWHR7O8/cIlpOXYNqQSpNtnvO
   gb+Chh+kXrMwx+SwHn7xCv5MytW4Jw2MwaXm45b9JcfGFqhmyADHeGjS/
   8/3hAhfjIhJZClLVRmIhPu9Nvqtu1fbFrJYHx6+iqtu9q2AKJuREjaaL5
   vChIr0tdkw1w2EjGASVaxrULfbyC6XH5idEqqiuTjKbEwwkL+ES/GP7an
   KjYIAYYpTskafRlrPy+giFnm7UKZ4SKwUqxT0/uKXvHGtANve1A98ceAw
   w==;
X-CSE-ConnectionGUID: jAS2PaqLRsS4ejRPx2KPzw==
X-CSE-MsgGUID: Ch/8BhoTQOGhkmcI58w4Dg==
X-IronPort-AV: E=McAfee;i="6700,10204,11113"; a="20106954"
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="20106954"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 23:54:16 -0700
X-CSE-ConnectionGUID: P/vW7aK1QPe6uoCk6Kdxvw==
X-CSE-MsgGUID: 6uxTPI2BTk2Z8rK1sAYhjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="48506360"
Received: from qunyang-mobl1.ccr.corp.intel.com (HELO [10.238.2.59]) ([10.238.2.59])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 23:54:12 -0700
Message-ID: <560f3796-5a41-49fb-be6e-558bbe582996@linux.intel.com>
Date: Tue, 25 Jun 2024 14:54:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 110/130] KVM: TDX: Handle TDX PV MMIO hypercall
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a4421e0f2eafc17b4703c920936e32489d2382a3.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
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
mmio_needed is used by instruction emulator to setup the complete callback.
Since TDX handle MMIO in a PV way, mmio_needed is not needed here.

> +
> +	if (!vcpu->mmio_is_write) {
It's also needed by instruction emulator, we can use 
vcpu->run->mmio.is_write instead.

> +		gpa = vcpu->mmio_fragments[0].gpa;
> +		size = vcpu->mmio_fragments[0].len;

Since MMIO cross page boundary is not allowed according to the input 
checks from TDVMCALL, these mmio_fragments[] is not needed.
Just use vcpu->run->mmio.phys_addr and vcpu->run->mmio.len?

> +
> +		memcpy(&val, vcpu->run->mmio.data, size);
> +		tdvmcall_set_return_val(vcpu, val);
> +		trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
> +	}

Tracepoint for KVM_TRACE_MMIO_WRITE is missing when it is handled in 
userspace.

Also, the return code is only set when the emulation is done in kernel, 
but not set when it's handled in userspace.

> +	return 1;
> +}

How about the fixup as following:

@@ -1173,19 +1173,18 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu) 
static int tdx_complete_mmio(struct kvm_vcpu *vcpu) { unsigned long val 
= 0; - gpa_t gpa; - int size; - - vcpu->mmio_needed = 0; - - if 
(!vcpu->mmio_is_write) { - gpa = vcpu->mmio_fragments[0].gpa; - size = 
vcpu->mmio_fragments[0].len; + gpa_t gpa = vcpu->run->mmio.phys_addr; + 
int size = vcpu->run->mmio.len; + if (vcpu->run->mmio.is_write) { + 
trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, size, gpa, &val); + } else { 
memcpy(&val, vcpu->run->mmio.data, size); tdvmcall_set_return_val(vcpu, 
val); trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val); } + + 
tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS); return 1; }



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
[...]
> +
> +	/* Request the device emulation to userspace device model. */
> +	vcpu->mmio_needed = 1;
> +	vcpu->mmio_is_write = write;
Then they can be dropped.


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
These two lines can be dropped as well.

> +		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, size, gpa, NULL);
> +	}
> +	return 0;
> +
> +error:
> +	tdvmcall_set_return_code(vcpu, TDVMCALL_INVALID_OPERAND);
> +	return 1;
> +}
> +

- /* Request the device emulation to userspace device model. */ - 
vcpu->mmio_needed = 1; - vcpu->mmio_is_write = write; 
vcpu->arch.complete_userspace_io = tdx_complete_mmio; 
vcpu->run->mmio.phys_addr = gpa; @@ -1265,13 +1272,11 @@ static int 
tdx_emulate_mmio(struct kvm_vcpu *vcpu) vcpu->run->mmio.is_write = 
write; vcpu->run->exit_reason = KVM_EXIT_MMIO; - if (write) { + if 
(write) memcpy(vcpu->run->mmio.data, &val, size); - } else { - 
vcpu->mmio_fragments[0].gpa = gpa; - vcpu->mmio_fragments[0].len = size; 
+ else trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, size, gpa, NULL); 
- } + return 0;




Return-Path: <kvm+bounces-69738-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SCKMGDTafGlbOwIAu9opvQ
	(envelope-from <kvm+bounces-69738-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 17:20:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 99227BC78F
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 17:20:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EB0313036EE1
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 16:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CAA34D4E3;
	Fri, 30 Jan 2026 16:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HjGvYwte"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFF2343D83;
	Fri, 30 Jan 2026 16:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769789890; cv=none; b=dHApFzgh0dynl9PYnK95JVtb+o51C5HS2EzDstEndWnQGiUayrgCCJDsMKX5Nx5HU2LXpHuR3Tt7TzihMH/9iRcvmV8qQm/Mfw+r7KV+qryYZLtA8cXmEjbxpocvh3gISBQgLfMOtdvAKD8OPkwQohaF88H9TCn3ZKL2F523uSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769789890; c=relaxed/simple;
	bh=CBv56p/C/4HkXTGIlcnQssZIfh83utlvy45BPJ2NIN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GkfDffmmSBRn+xYzrw4NcHJ73idZv7dHV3/5oGKAwQLJkmS0oBdWx8z8EMRio+8y/nycUJ892mac7pMRw8fj5oV+wToSuoTb8YlkwI6LyqwAfk+rM+gDyk1L1bdC7NbfFFQiTZ18pvYEzxBYPj1SuwSdFJU6KREot5DH5N5fhgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HjGvYwte; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769789889; x=1801325889;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CBv56p/C/4HkXTGIlcnQssZIfh83utlvy45BPJ2NIN4=;
  b=HjGvYwtegQlVMNyYq1FjNkj6TYZS6R3HF3iOblvkECDRKv2uz0obDb46
   X1SWzY2mV4T0u2pQrw3SCQw6tmxkhq9qfuMEer7Zx0Lcwabht9hcMwB6o
   HIwZnX3PGhFoyUNOryVhJJw1oEg7BFrXiuIEEZdAVZXOXN3TcI4d1ppp5
   lGkZcxGhwp8qdvwpqu8mid3TK9MgYt9mqpMn4kzODzDVF4tjcwoALGKtf
   Wq8l4JdlvTcUYKwWNb8j0rrySQNLU9oeug2cWansr5Fb1CeGg4a05wLEB
   da039XZaM4usWpbZBXjQdbP/RpfFmRJPLy3A4CgKqfTa85BAWoQYNR/yT
   w==;
X-CSE-ConnectionGUID: JQQIKozqTf+3nZF+FOD3iw==
X-CSE-MsgGUID: 5KFS2r/+TWmH3oBmML/jEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="82152081"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="82152081"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 08:18:08 -0800
X-CSE-ConnectionGUID: BH3AAYN3RNWA2+IfAioolg==
X-CSE-MsgGUID: nVSLshoDQuG/ACh9yUVA+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="208127765"
Received: from cjhill-mobl.amr.corp.intel.com (HELO [10.125.110.58]) ([10.125.110.58])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 08:18:08 -0800
Message-ID: <fedb3192-e68c-423c-93b2-a4dc2f964148@intel.com>
Date: Fri, 30 Jan 2026 08:18:07 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/26] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
 ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
 yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
 paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
 seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
 dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
 Farrah Chen <farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-8-chao.gao@intel.com>
 <301f8156-bafe-440a-8628-3bf8fae74464@intel.com> <aXywVcqbXodADg4a@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aXywVcqbXodADg4a@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	TAGGED_FROM(0.00)[bounces-69738-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.hansen@intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim]
X-Rspamd-Queue-Id: 99227BC78F
X-Rspamd-Action: no action

On 1/30/26 05:21, Chao Gao wrote:
...
>>> +	/*
>>> +	 * SEAMRET from P-SEAMLDR invalidates the current VMCS.  Save/restore
>>> +	 * the VMCS across P-SEAMLDR SEAMCALLs to avoid clobbering KVM state.
>>> +	 * Disable interrupts as KVM is allowed to do VMREAD/VMWRITE in IRQ
>>> +	 * context (but not NMI context).
>>> +	 */
>>
>> I think you mean:
>>
>> 	WARN_ON(in_nmi());
> 
> This function only disables interrupts, not NMIs. Kirill questioned whether any
> KVM operations might execute from NMI context and do VMREAD/VMWRITE. If such
> operations exist and an NMI interrupts seamldr_call(), they could encounter
> an invalid current VMCS.
> 
> The problematic scenario is:
> 
> 	seamldr_call()			KVM code in NMI handler
> 
> 1.	vmptrst // save current-vmcs
> 2.	seamcall // clobber current-vmcs
> 3.					// NMI handler start
> 					call into some KVM code and do vmread/vmwrite
> 					// consume __invalid__ current-vmcs
> 					// NMI handler end
> 4.	vmptrld // restore current-vmcs
> 
> The comment clarifies that KVM doesn't do VMREAD/VMWRITE during NMI handling.

How about something like:

	P-SEAMLDR calls invalidate the current VMCS. It must be saved
	and restored around the call. Exclude KVM access to the VMCS
	by disabling interrupts. This is not safe against VMCS use in
	NMIs, but there are none of those today.

Ideally, you'd also pair that with _some_ checks in the KVM code that
use lockdep or warnings to reiterate that NMI access to the VMCS is not OK.

>>> +	local_irq_save(flags);
>>> +
>>> +	asm goto("1: vmptrst %0\n\t"
>>> +		 _ASM_EXTABLE(1b, %l[error])
>>> +		 : "=m" (vmcs) : : "cc" : error);
>>
>> I'd much rather this be wrapped up in a helper function. We shouldn't
>> have to look at the horrors of inline assembly like this.
>>
>> But this *REALLY* wants the KVM folks to look at it. One argument is
>> that with the inline assembly this is nice and self-contained. The other
>> argument is that this completely ignores all existing KVM infrastructure
>> and is parallel VMCS management.
> 
> Exactly. Sean suggested this approach [*]. He prefers inline assembly rather than
> adding new, inferior wrappers
> 
> *: https://lore.kernel.org/linux-coco/aHEYtGgA3aIQ7A3y@google.com/

Get his explicit reviews on the patch, please.

Also, I 100% object to inline assembly in the main flow. Please at least
make a wrapper for these and stick them in:

	arch/x86/include/asm/special_insns.h

so the inline assembly spew is hidden from view.

>> I'd be shocked if this is the one and only place in the whole kernel
>> that can unceremoniously zap VMX state.
>>
>> I'd *bet* that you don't really need to do the vmptrld and that KVM can
>> figure it out because it can vmptrld on demand anyway. Something along
>> the lines of:
>>
>> 	local_irq_disable();
>> 	list_for_each(handwaving...)
>> 		vmcs_clear();
>> 	ret = seamldr_prerr(fn, args);
>> 	local_irq_enable();	
>>
>> Basically, zap this CPU's vmcs state and then make KVM reload it at some
>> later time.
> 
> The idea is feasible. But just calling vmcs_clear() won't work. We need to
> reset all the tracking state associated with each VMCS. We should call
> vmclear_local_loaded_vmcss() instead, similar to what's done before VMXOFF.
> 
>>
>> I'm sure Sean and Paolo will tell me if I'm crazy.
> 
> To me, this approach needs more work since we need to either move 
> vmclear_local_loaded_vmcss() to the kernel or allow KVM to register a callback.
> 
> I don't think it's as straightforward as just doing the save/restore.

Could you please just do me a favor and spend 20 minutes to see what
this looks like in practice and if the KVM folks hate it?

>>> diff --git a/drivers/virt/coco/tdx-host/Kconfig b/drivers/virt/coco/tdx-host/Kconfig
>>> index e58bad148a35..6a9199e6c2c6 100644
>>> --- a/drivers/virt/coco/tdx-host/Kconfig
>>> +++ b/drivers/virt/coco/tdx-host/Kconfig
>>> @@ -8,3 +8,13 @@ config TDX_HOST_SERVICES
>>>  
>>>  	  Say y or m if enabling support for confidential virtual machine
>>>  	  support (CONFIG_INTEL_TDX_HOST). The module is called tdx_host.ko
>>> +
>>> +config INTEL_TDX_MODULE_UPDATE
>>> +	bool "Intel TDX module runtime update"
>>> +	depends on TDX_HOST_SERVICES
>>> +	help
>>> +	  This enables the kernel to support TDX module runtime update. This
>>> +	  allows the admin to update the TDX module to another compatible
>>> +	  version without the need to terminate running TDX guests.
>>
>> ... as opposed to the method that the kernel has to update the module
>> without terminating guests? ;)
> 
> I will reduce this to:
> 
> 	  This enables the kernel to update the TDX Module to another compatible
> 	  version.

I guess I'll be explicit: Remove this Kconfig prompt.

I think you should remove INTEL_TDX_MODULE_UPDATE entirely. But I'll
settle for:

	config INTEL_TDX_MODULE_UPDATE
		bool
		default TDX_HOST_SERVICES

so that users don't have to see it. Don't bother users with it. Period.


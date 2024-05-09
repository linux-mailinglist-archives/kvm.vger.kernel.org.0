Return-Path: <kvm+bounces-17083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F98A8C0A23
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 05:26:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 997191F2331D
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 03:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7FB1482FE;
	Thu,  9 May 2024 03:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M3j9/MRu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCEB13B5A9;
	Thu,  9 May 2024 03:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715225182; cv=none; b=af5fn/QNMwDjLpnCyjZ/MUFBZAAyv0JcH4KR/A0h7rVixy7sbmiLW7NMwUw2zKL+Ii6az1Cmiv6ocT4V+m1Hbc4Ljti4/3pHCmMof/vpMKUrcwRF0Gm6b7WFr+EXA2/oazFtqz3AkAL2gAP+9RlLgXSWtdIavTrYrVJ49icK17g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715225182; c=relaxed/simple;
	bh=lzuT4z6a9h6QUPjj6mXTlc70SHZOnKy2AEOR8TPJIso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EXLuAnHbClSC6NfFQya1cH3exCMI7AwPbCy3pmS5hhliOCVkPE06sNaIyLDyU9IZhfP25fUScJVN5cKASiiSU6sMAbVcDMJI3TJn1ncSpnZ61qItZ6cbso2jmCFYios8Yp+hWCylXyfDUbRZ3SvDqKKkfBqm+2V4Fa+G8y2a7hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M3j9/MRu; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715225180; x=1746761180;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lzuT4z6a9h6QUPjj6mXTlc70SHZOnKy2AEOR8TPJIso=;
  b=M3j9/MRu06rtoH3nMjaIElw7To0nl9/01HE+3aB9Eo1DQb2TkIRGInM3
   BnNELu8pm/v2mozaQ74CieDxtYFzz8N4WUx+QCmi8IPAAJktPL4HwED9H
   dw9ouUlLvYjngsi+ytAGDmBU5QgWpJmocHPUmPBUzRwIFC43QFsTRF3oX
   ytvYxZaE8dNRE+cs3l74I78ejgwtK850rRu+OmmHQIff6YHRdWO1LHfBC
   b8b+63Z0WPDG8kCJKoSrv2v7vFt/oYxXJiQSqFI+37DHuMcVYOAvBtTFB
   2gX7v5vxV9Hm+JSG+oGMWZAcp2dxg8w/IsrSfTrtKM+YZlEyq9cdEMjxU
   g==;
X-CSE-ConnectionGUID: xLG4SS6ZSEy0KWQqoDILeg==
X-CSE-MsgGUID: qGuxJexHRZC6VzV2g24WsQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="36502860"
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="36502860"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 20:26:20 -0700
X-CSE-ConnectionGUID: ydmmEwPyQh6tgRLtlGYBYg==
X-CSE-MsgGUID: 9imKpPHkRZ6p62ZLMDK67Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="66533744"
Received: from unknown (HELO [10.238.8.173]) ([10.238.8.173])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 20:26:16 -0700
Message-ID: <e6b80db6-bfc8-47c7-94f0-673884646b80@linux.intel.com>
Date: Thu, 9 May 2024 11:26:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 097/130] KVM: x86: Split core of hypercall emulation
 to helper function
To: Isaku Yamahata <isaku.yamahata@intel.com>, Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 isaku.yamahata@linux.intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <d6547bd0c1eccdfb4a4908e330cc56ad39535f5e.1708933498.git.isaku.yamahata@intel.com>
 <ZgY0hy6Io72yZ9dF@chao-email>
 <20240403183420.GI2444378@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240403183420.GI2444378@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/4/2024 2:34 AM, Isaku Yamahata wrote:
> On Fri, Mar 29, 2024 at 11:24:55AM +0800,
> Chao Gao <chao.gao@intel.com> wrote:
>
>> On Mon, Feb 26, 2024 at 12:26:39AM -0800, isaku.yamahata@intel.com wrote:
>>> +
>>> +int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>> +{
>>> +	unsigned long nr, a0, a1, a2, a3, ret;
>>> +	int op_64_bit;
>>> +	int cpl;
>>> +
>>> +	if (kvm_xen_hypercall_enabled(vcpu->kvm))
>>> +		return kvm_xen_hypercall(vcpu);
>>> +
>>> +	if (kvm_hv_hypercall_enabled(vcpu))
>>> +		return kvm_hv_hypercall(vcpu);
>>> +
>>> +	nr = kvm_rax_read(vcpu);
>>> +	a0 = kvm_rbx_read(vcpu);
>>> +	a1 = kvm_rcx_read(vcpu);
>>> +	a2 = kvm_rdx_read(vcpu);
>>> +	a3 = kvm_rsi_read(vcpu);
>>> +	op_64_bit = is_64_bit_hypercall(vcpu);
>>> +	cpl = static_call(kvm_x86_get_cpl)(vcpu);
>>> +
>>> +	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
>>> +	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
>>> +		/* MAP_GPA tosses the request to the user space. */
>> no need to check what the request is. Just checking the return value will suffice.
> This is needed to avoid updating rax etc.  KVM_HC_MAP_GPA_RANGE is only an
> exception to go to the user space.  This check is a bit weird, but I couldn't
> find a good way.

To be generic, I think we can use
"vcpu->kvm->arch.hypercall_exit_enabled & (1 << nr)" to check if it 
needs to exit to userspace.

i.e.,

+       ...
+       ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, 
op_64_bit, cpl);
+       if (!ret && (vcpu->kvm->arch.hypercall_exit_enabled & (1 << nr)))
+               /* The hypercall is requested to exit to userspace. */
+               return 0;

>
>>> +		return 0;
>>> +
>>> 	if (!op_64_bit)
>>> 		ret = (u32)ret;
>>> 	kvm_rax_write(vcpu, ret);
>>>
>>> -	++vcpu->stat.hypercalls;
>>> 	return kvm_skip_emulated_instruction(vcpu);
>>> }
>>> EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
>>> -- 
>>> 2.25.1
>>>
>>>



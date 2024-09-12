Return-Path: <kvm+bounces-26727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EAC63976C88
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A197E1F24A8C
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 14:47:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFDC51BBBFE;
	Thu, 12 Sep 2024 14:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PH7ncove"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0153A1DB;
	Thu, 12 Sep 2024 14:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726152355; cv=none; b=jAJgG1efFgl6veCVJEnFKwcfaj34XIyTbI8d9Sh4y2ruDoqo1VoXQcmCR+Szz0KH9LH8W4MgleERqEwMMtI5bu4IqIx/MF/buvdgQkkDEJNeGd7ObW4Rj/C1nrImAg38rhnsrv+fjhBY6SvF6gmxy2zMZjQbV9eXkxIu8f3lylg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726152355; c=relaxed/simple;
	bh=FWIWJhbC+YhtqzC3zdmfLYeQqacvFMaqlLEVi/oubFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BmihlAn2eIex++2e1FYL1ULFCbKlvIxCBf7f9xs9BQgx3hJYtP8dTezKkP03xbQVHecgSF4PHLGS02dFZsu9h/NpbTTUVkjae/lnh4Hsf3r82Lqb7SmyFaBhhrjKiWi2nLe6ZczemKEY220bRM5kdeA+RML6GTiCqF4OqG2HLQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PH7ncove; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726152354; x=1757688354;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FWIWJhbC+YhtqzC3zdmfLYeQqacvFMaqlLEVi/oubFs=;
  b=PH7ncove/wSPYj9wzQ9sPjlKZzTSURvGAjlW8cYH5nOCPX7b6z20JVL0
   y1rVohUGqxXHaCvoDmacfG8PBAUyXc+zOCTuY69vaXjEKBe9P/G4Xt5V3
   cz92/wmYUB02G2i4HvQmKgxSZszVSqFajQSzmzCjOeDU0JjMVYEXLRCle
   f01EL63fG9vjz/XA7nKDQ6rCZI4R87fOiRe01MW/bOhbjaARTA1SpnfKb
   3gVSjtq2kdskE0AJrmj1N7WYPdcxuX3Z/GXPx1822MPo6lIVQDKGKsYrG
   K+suqDhxqqeH3j1YA0u0KTtSZvTWvXo0eyGUhJr/k8sN+4xK/Z3/wcfiL
   w==;
X-CSE-ConnectionGUID: dUaKcokyQX+ia3Q0wsg87g==
X-CSE-MsgGUID: 4rD5kHxRSX6pgn4+dvlTmg==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="24833082"
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="24833082"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 07:45:46 -0700
X-CSE-ConnectionGUID: bTWZPzvvQpG2UlgNaeWI2g==
X-CSE-MsgGUID: UxRluXfsQkKvmn1DZekJ7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="67985421"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.38]) ([10.124.224.38])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 07:45:42 -0700
Message-ID: <df05e4fe-a50b-49a8-9ea0-2077cb061c44@intel.com>
Date: Thu, 12 Sep 2024 22:45:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org, kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
 <05cf3e20-6508-48c3-9e4c-9f2a2a719012@redhat.com>
 <cd236026-0bc9-424c-8d49-6bdc9daf5743@intel.com>
 <CABgObfbyd-a_bD-3fKmF3jVgrTiCDa3SHmrmugRji8BB-vs5GA@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CABgObfbyd-a_bD-3fKmF3jVgrTiCDa3SHmrmugRji8BB-vs5GA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/12/2024 10:09 PM, Paolo Bonzini wrote:
> On Thu, Sep 12, 2024 at 9:48 AM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>> On 9/11/2024 1:52 AM, Paolo Bonzini wrote:
>>> On 8/13/24 00:48, Rick Edgecombe wrote:
>>>> For KVM_TDX_CAPABILITIES, there was also the problem of bits that are
>>>> actually supported by KVM, but missing from get_supported_cpuid() for one
>>>> reason or another. These include X86_FEATURE_MWAIT, X86_FEATURE_HT and
>>>> X86_FEATURE_TSC_DEADLINE_TIMER. This is currently worked around in
>>>> QEMU by
>>>> adjusting which features are expected.
>>
>> I'm not sure what issue/problem can be worked around in QEMU.
>> QEMU doesn't expect these bit are reported by KVM as supported for TDX.
>> QEMU just accepts the result reported by KVM.
> 
> QEMU already adds some extra bits, for example:
> 
>          ret |= CPUID_EXT_HYPERVISOR;
>          if (kvm_irqchip_in_kernel() &&
>                  kvm_check_extension(s, KVM_CAP_TSC_DEADLINE_TIMER)) {
>              ret |= CPUID_EXT_TSC_DEADLINE_TIMER;
>          }
> 
>> The problem is, TDX module and the hardware allow these bits be
>> configured for TD guest, but KVM doesn't allow. It leads to users cannot
>> create a TD with these bits on.
> 
> KVM is not going to have any checks, it's only going to pass the
> CPUID to the TDX module and return an error if the check fails
> in the TDX module.

If so, new feature can be enabled for TDs out of KVM's control.

Is it acceptable?

> KVM can have a TDX-specific version of KVM_GET_SUPPORTED_CPUID, so
> that we can keep a variant of the "get supported bits and pass them
> to KVM_SET_CPUID2" logic, but that's it.
> 
>>> This is the kind of API that we need to present for TDX, even if the
>>> details on how to get the supported CPUID are different.  Not because
>>> it's a great API, but rather because it's a known API.
>>
>> However there are differences for TDX. For legacy VMs, the result of
>> KVM_GET_SUPPORTED_CPUID isn't used to filter the input of KVM_SET_CPUID2.
>> But for TDX, it needs to filter the input of KVM_TDX_VM_INIT.CPUID[]
>> because TDX module only allows the bits that are reported as
>> configurable to be set to 1.
> 
> Yes, that's userspace's responsibility.
> 
>> With current designed API, QEMU can only know which bits are
>> configurable before KVM_TDX_VM_INIT, i.e., which bits can be set to 1 or
>> 0 freely.
> 
> The API needs userspace to have full knowledge of the
> requirements of the TDX module, if it wants to change the
> defaults provided by KVM.
> 
> This is the same as for non-TDX VMs (including SNP).  The only
> difference is that TDX and SNP fails, while non-confidential VMs
> get slightly garbage CPUID.
> 
>> For other bits not reported as configurable, QEMU can know the exact
>> value of them via KVM_TDX_GET_CPUID, after KVM_TDX_VM_INIT and before
>> TD's running. With it, QEMU can validate the return value is matched
>> with what QEMU wants to set that determined by users input. If not
>> matched, QEMU can provide some warnings like what for legacy VMs:
>>
>>     - TDX doesn't support requested feature: CPUID.01H.ECX.tsc-deadline
>> [bit 24]
>>     - TDX forcibly sets features: CPUID.01H:ECX.hypervisor [bit 31]
>>
>> If there are ioctls to report the fixed0 bits and fixed1 bits for TDX,
>> QEMU can validate the user's configuration earlier.
> 
> Yes, that's fine.
> 
> Paolo
> 



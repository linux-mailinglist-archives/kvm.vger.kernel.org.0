Return-Path: <kvm+bounces-49227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 457C0AD676C
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 07:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2039D3A33AF
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 05:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1A591E9B28;
	Thu, 12 Jun 2025 05:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l9CKBv36"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0482F1798F;
	Thu, 12 Jun 2025 05:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706896; cv=none; b=KlWJkf0z5MGex4sF+Xhr9ILHiRlGGAqW/Guc5WdD466QE5VZqdZnBE+afEXR1uoc2DhvNJIRc1pT8qyDq2cJd3oVZ2OA+5b5imL03nbQJez1NqXCAooCZBd3PswZc3Rpg1F2R6+Io3bRLGSSZXhl2j5Z+UV5UGrCTrZkMAd4hfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706896; c=relaxed/simple;
	bh=MVwiMWOB+RZa3CMd6OW3EQuZjFNX92K9tTPczDmVAYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jyW3SOOr43CslKAY2vGbQAul2eFae5LEsQUh4Hrfq8HRrj64qEUg51Iii3wQ7409zqZBqjvaStXsdx8q+NKKgyOZzUInA8CIAdpuc883jexmi0vX6EM7m8Qs+Qz2KHBlud8X7wtYMdyW2eX58mH3OkM6lzfgTC4gbbDd1fK3a2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l9CKBv36; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749706895; x=1781242895;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MVwiMWOB+RZa3CMd6OW3EQuZjFNX92K9tTPczDmVAYM=;
  b=l9CKBv36GlirXtVzy3++/HbCYLb014CQeE/enEmB73XYPQL7SBG48q+H
   q0YMyq1ZR2/QTdL/9ur3dcdckQigDD9N74dyohnsrP1x0Q1toXDMz6sj4
   +dXhJRFGXs0yqvSJY+tpKBMk7+YR+C6h7kQD9vneLBz9G5KWyjGMxby/o
   UcGGBSvH6t6kixe4JRbvjB6pLJxTljyPMst56CozXQ0F1FlrIjEHq6xLW
   tAvXOoS293tSOlOzXtmrNVVIiA/Cz14e2HI7/u2oJ8iPJZ4RG+uLDX/wB
   3WUoVpDNJg1S8fwUPXpcGLoj1EsczABufNqT9q9/I6ziUoOLI5cF2P90P
   g==;
X-CSE-ConnectionGUID: 8TuH7jsER3KaVQITx/hS2Q==
X-CSE-MsgGUID: eof6/NbzTfG5qFMPYV0ypw==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="55669806"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="55669806"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 22:41:34 -0700
X-CSE-ConnectionGUID: YiPn0AsZS4GnJnRX2ah+cQ==
X-CSE-MsgGUID: aGRd18cHTaqjiib4PQLfng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="178375661"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 22:41:32 -0700
Message-ID: <d5f528c2-3518-4251-a50b-2d1f36c1662e@intel.com>
Date: Thu, 12 Jun 2025 13:41:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/mmu: Reject direct bits in gpa passed to
 KVM_PRE_FAULT_MEMORY
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
 yan.y.zhao@intel.com
References: <20250612044943.151258-1-pbonzini@redhat.com>
 <cfd99e56-551b-49c5-b486-05c9f6d8cf11@intel.com>
 <CABgObfafukOFkeR09krA5GVb3itfpHNHjBM0aRZj5t4EKJv7Dw@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CABgObfafukOFkeR09krA5GVb3itfpHNHjBM0aRZj5t4EKJv7Dw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/2025 1:34 PM, Paolo Bonzini wrote:
> On Thu, Jun 12, 2025 at 7:29 AM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>
>> On 6/12/2025 12:49 PM, Paolo Bonzini wrote:
>>> Only let userspace pass the same addresses that were used in KVM_SET_USER_MEMORY_REGION
>>> (or KVM_SET_USER_MEMORY_REGION2); gpas in the the upper half of the address space
>>> are an implementation detail of TDX and KVM.
>>>
>>> Extracted from a patch by Sean Christopherson <seanjc@google.com>.
>>>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>>    arch/x86/kvm/mmu/mmu.c | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index a4040578b537..4e06e2e89a8f 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -4903,6 +4903,9 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>>>        if (!vcpu->kvm->arch.pre_fault_allowed)
>>>                return -EOPNOTSUPP;
>>>
>>> +     if (kvm_is_gfn_alias(vcpu->kvm, gpa_to_gfn(range->gpa)))
>>> +             return -EINVAL;
>>
>> Do we need to worry about the case (range->gpa + range->size) becomes alias?
> 
> No, because the function only processes a single page and everything
> in the non-aliased part of the address space *can* be prefaulted.
> 
> KVM's generic kvm_vcpu_pre_fault_memory() call will see the EINVAL on
> a later invocation and will stop processing the part of the request
> that is has the shared/direct bit set.

reasonable..

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Paolo
> 
>>
>>>        /*
>>>         * reload is efficient when called repeatedly, so we can do it on
>>>         * every iteration.
>>
> 
> 



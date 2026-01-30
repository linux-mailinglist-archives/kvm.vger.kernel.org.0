Return-Path: <kvm+bounces-69660-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UISbHAEffGmgKgIAu9opvQ
	(envelope-from <kvm+bounces-69660-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 04:01:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F02AB6A9D
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 04:01:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 033613007A7D
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 03:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 902852D7DC0;
	Fri, 30 Jan 2026 03:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RAb+05qH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54CA7FBA2;
	Fri, 30 Jan 2026 03:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769742075; cv=none; b=sHMK5RZjTIDA4ER9OZWefJoG79xxuTDwWC0xnWUaaWkIOdYSDY89xWfX5D9FqV257pBSGSiekQZDeDX96NYbW7Ib3cQMbxiYB++V2bMmZv4tGuImcghSwgq8lC5NHg6myHHMtq1C2eiWkngyiTNoqJUy10UvvaeCJ7Z9pZnrz4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769742075; c=relaxed/simple;
	bh=JeSwyXIdACV/POu/NYe6CulJqvPy0V3Q1CYHZaVJP2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=scPF6rt0rUcFgJxu+cQKQqoJVfNowP+DuhsOKSyW6Ot+HeG0wmBebBOTZDsn5cG8lCzLrDUJO5lmbSHwfTY8TDT/qaMEtkyXqIxr/ZWN3U5mArmZpSDRpxXVjq4IxV74jRhLpkG5Vpf3lHYR4JlDO5ZQnQ9S2y/Bv7LbfeaM73g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RAb+05qH; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769742073; x=1801278073;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JeSwyXIdACV/POu/NYe6CulJqvPy0V3Q1CYHZaVJP2c=;
  b=RAb+05qHV3CzFLn6YSm/syEv8L16sRnSkB+j5hqAHRX/Xf9rI9Xqn7i2
   PCEbzsHaZ1Uy9ydx3zkwvZNz3JUO25SWsglPP+yddAOkGu24McbChgfDL
   JQ+KuCADxlsIp96jtqhrOcRUWpt1GkaEmrOeuXn836QBTZMAvaW2AYnHu
   629kzoqUd5m11cuL6DyaveGw0yuk6nrxPMZyZB86VJwu/Om7Q5DIXDDb9
   fLmyy6+nF+bHdlM17jBTdOYfvtOPl29xhm8szwcLJOapl9KooXFWlRqwk
   SVH7K9DFPGAy1o+gN4WqIfRM8T0ezKc3sg3D/7L+yOn0/WpiTtjSHC12c
   Q==;
X-CSE-ConnectionGUID: iwGiKtgLRICCnHM53HHpLg==
X-CSE-MsgGUID: jRl8fToIRr6cg5uIhQ1rFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="73592582"
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="73592582"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 19:01:12 -0800
X-CSE-ConnectionGUID: yCV884jCQseKY+FLmPAdzw==
X-CSE-MsgGUID: dal7hHisSaCcn8HzZzDBJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="231658009"
Received: from unknown (HELO [10.238.3.203]) ([10.238.3.203])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 19:01:10 -0800
Message-ID: <3f2a7037-cbed-49d2-ab31-b174eaae0f1e@intel.com>
Date: Fri, 30 Jan 2026 11:01:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] KVM: x86: Harden against unexpected adjustments to
 kvm_cpu_caps
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
 John Allen <john.allen@amd.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Jim Mattson <jmattson@google.com>
References: <20260128014310.3255561-1-seanjc@google.com>
 <20260128014310.3255561-3-seanjc@google.com>
 <7f045418-6ce4-4f2f-a3ee-4ddc3cf2fda5@intel.com>
 <aXt4wf6Vpo5da2rc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aXt4wf6Vpo5da2rc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69660-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xiaoyao.li@intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim]
X-Rspamd-Queue-Id: 8F02AB6A9D
X-Rspamd-Action: no action

On 1/29/2026 11:12 PM, Sean Christopherson wrote:
> On Thu, Jan 29, 2026, Xiaoyao Li wrote:
>> On 1/28/2026 9:43 AM, Sean Christopherson wrote:
>>> Add a flag to track when KVM is actively configuring its CPU caps, and
>>> WARN if a cap is set or cleared if KVM isn't in its configuration stage.
>>> Modifying CPU caps after {svm,vmx}_set_cpu_caps() can be fatal to KVM, as
>>> vendor setup code expects the CPU caps to be frozen at that point, e.g.
>>> will do additional configuration based on the caps.
>>>
>>> Rename kvm_set_cpu_caps() to kvm_initialize_cpu_caps() to pair with the
>>> new "finalize", and to make it more obvious that KVM's CPU caps aren't
>>> fully configured within the function.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/x86/kvm/cpuid.c   | 10 ++++++++--
>>>    arch/x86/kvm/cpuid.h   | 12 +++++++++++-
>>>    arch/x86/kvm/svm/svm.c |  4 +++-
>>>    arch/x86/kvm/vmx/vmx.c |  4 +++-
>>>    4 files changed, 25 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index 575244af9c9f..7fe4e58a6ebf 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -36,6 +36,9 @@
>>>    u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
>>>    EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_cpu_caps);
>>> +bool kvm_is_configuring_cpu_caps __read_mostly;
>>
>> I prefer the name, kvm_cpu_caps_finalized. But not strongly, so
> 
> "finalized" reads too much like the helper queries if the caps are already
> finalized, i.e. like an accessor.

And after a second thought, I find my preference is not good. Because it 
only tells the end of allowed stage while kvm_is_configuring_cpu_caps 
defines both the start and end.

So withdraw my preference.


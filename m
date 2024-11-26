Return-Path: <kvm+bounces-32487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B12049D9022
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 02:44:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D22F3B2258B
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 01:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B90E711185;
	Tue, 26 Nov 2024 01:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VxSpwR3n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D54811712;
	Tue, 26 Nov 2024 01:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732585477; cv=none; b=SMl/FAmr9R+jRFyqJvyqmjdW4PNHGZ0BeWv0tftRAreSZgdrc+ruGwXy9F67DWaBOG5/f74THOOJ9hMMGQWzbuzeneJ3FcLKR6eBeAzNsqZHcBDhPynk9RO5Qqh3kggMglt2/Bn2qgwro0b8Q90RP40hYsQCTOSdalDKEwLX4HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732585477; c=relaxed/simple;
	bh=Z1MfXI+7J5O/Z/+IMb1ubuLYsxon/6Weg0mWusfqz58=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ndrijRVsY/tkF/EoM3Oedu/CK6WBpEfxmUaUFLaL4cYTlyAb4EfVm+Cx0Wqs3a2uFSmwVBFw4q+XI0ik+tn9T2UFJqBbFUqiK+n0T29XkU7VmfV3BI1Z0uDR/ay7iAizrH46FtljbWgZWIwFyHMqmYB5F9+dJX2mID+FX/bS5xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VxSpwR3n; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732585476; x=1764121476;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Z1MfXI+7J5O/Z/+IMb1ubuLYsxon/6Weg0mWusfqz58=;
  b=VxSpwR3nStZN7DDVACKX6zZ5iLNVYXkpOzDkIvWquGowRv8tdDCkYrgG
   6z7W3HDzJ/3x2Gy2k6GV3XmFRwP7LYJHNF3Hsu3rHtZXMMSCSp1MltHVn
   mxRPMb6M9KbNN6A+R1cvQ6kluMN6HihdqMKIf4QCxnRkD8z1R6EAKWYRt
   mfzGDzqjKNMAd9hrMcr7St4kE/jZcCwMtx+/flco53lCNRK7BqSc40f6q
   Mx/VS5wZjpjqVJjAYZeLOvukGIKt+WWfdYXAreR3KK+74s69HJADNbWHk
   GwDRrRC0Cx/DYV8G/0th0DsuWPD/y37rd2Ck6tlTt1TrmSZkkF+rWZBkg
   Q==;
X-CSE-ConnectionGUID: 6Y9tXlaOR4638ck19eh1lw==
X-CSE-MsgGUID: 6XtR9JSuRQ+IpTmvBPoDJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="43216939"
X-IronPort-AV: E=Sophos;i="6.12,184,1728975600"; 
   d="scan'208";a="43216939"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 17:44:35 -0800
X-CSE-ConnectionGUID: 59mmIaKJSaqr8IaifxUMBg==
X-CSE-MsgGUID: udwNEhFYSZCcf+km8NIa8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,184,1728975600"; 
   d="scan'208";a="91393496"
Received: from unknown (HELO [10.238.10.67]) ([10.238.10.67])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 17:44:31 -0800
Message-ID: <57aab3bf-4bae-4956-a3b7-d42e810556e3@linux.intel.com>
Date: Tue, 26 Nov 2024 09:44:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] KVM: TDX: TD vcpu enter/exit
To: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Weijiang Yang <weijiang.yang@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 "dmatlack@google.com" <dmatlack@google.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 Chao Gao <chao.gao@intel.com>, Rick P Edgecombe
 <rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <86d71f0c-6859-477a-88a2-416e46847f2f@linux.intel.com>
 <Z0SVf8bqGej_-7Sj@google.com>
 <735d3a560046e4a7a9f223dc5688dcf1730280c5.camel@intel.com>
 <Z0T_iPdmtpjrc14q@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z0T_iPdmtpjrc14q@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 11/26/2024 6:51 AM, Sean Christopherson wrote:

[...]
> When an NMI happens in non-root, the NMI is acknowledged by the CPU prior to
> performing VM-Exit.  In regular VMX, NMIs are blocked after such VM-Exits.  With
> TDX, that blocking happens for SEAM root, but the SEAMRET back to VMX root will
> load interruptibility from the SEAMCALL VMCS, and I don't see any code in the
> TDX-Module that propagates that blocking to SEAMCALL VMCS.
I see, thanks for the explanation!

>
> Hmm, actually, this means that TDX has a causality inversion, which may become
> visible with FRED's NMI source reporting.  E.g. NMI X arrives in SEAM non-root
> and triggers a VM-Exit.  NMI X+1 becomes pending while SEAM root is active.
> TDX-Module SEAMRETs to VMX root, NMIs are unblocked, and so NMI X+1 is delivered
> and handled before NMI X.

This example can also cause an issue without FRED.
1. NMI X arrives in SEAM non-root and triggers a VM-Exit.
2. NMI X+1 becomes pending while SEAM root is active.
3. TDX-Module SEAMRETs to VMX root, NMIs are unblocked.
4. NMI X+1 is delivered and handled before NMI X.
    (NMI handler could handle all NMI source events, including the source
     triggered NMI X)
5. KVM calls exc_nmi() to handle the VM Exit caused by NMI X
In step 5, because the source event caused NMI X has been handled, and NMI X
will not be detected as a second half of back-to-back NMIs, according to
Linux NMI handler, it will be considered as an unknown NMI.

Actually, the issue could happen if NMI X+1 occurs after exiting to SEAM root
mode and before KVM handling the VM-Exit caused by NMI X.


>
> So the TDX-Module needs something like this:
>
> diff --git a/src/td_transitions/td_exit.c b/src/td_transitions/td_exit.c
> index eecfb2e..b5c17c3 100644
> --- a/src/td_transitions/td_exit.c
> +++ b/src/td_transitions/td_exit.c
> @@ -527,6 +527,11 @@ void td_vmexit_to_vmm(uint8_t vcpu_state, uint8_t last_td_exit, uint64_t scrub_m
>           load_xmms_by_mask(tdvps_ptr, xmm_select);
>       }
>   
> +    if (<is NMI VM-Exit => SEAMRET)
> +    {
> +        set_guest_inter_blocking_by_nmi();
> +    }
> +
>       // 7.   Run the common SEAMRET routine.
>       tdx_vmm_post_dispatching();
>
>
> and then KVM should indeed handle NMI exits prior to leaving the noinstr section.
>   
>>> TDX is also different because KVM isn't responsible for context switching guest
>>> state.  Specifically, CR2 is managed by the TDX Module, and so there is no window
>>> where KVM runs with guest CR2, and thus there is no risk of clobbering guest CR2
>>> with a host value, e.g. due to take a #PF due instrumentation triggering something.
>>>
>>> All that said, I did forget that code that runs between guest_state_enter_irqoff()
>>> and guest_state_exit_irqoff() can't be instrumeneted.  And at least as of patch 2
>>> in this series, the simplest way to make that happen is to tag tdx_vcpu_enter_exit()
>>> as noinstr.  Just please make sure nothing else is added in the noinstr section
>>> unless it absolutely needs to be there.
>> If NMI is not a concern, is below also an option?
> No, because instrumentation needs to be prohibited for the entire time between
> guest_state_enter_irqoff() and guest_state_exit_irqoff().
>
>> 	guest_state_enter_irqoff();
>>
>> 	instructmentation_begin();
>> 	tdh_vp_enter();
>> 	instructmentation_end();
>>
>> 	guest_state_exit_irqoff();
>>



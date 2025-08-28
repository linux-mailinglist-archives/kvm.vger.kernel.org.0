Return-Path: <kvm+bounces-56074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B4408B39941
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 12:12:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 238B21C2831F
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 10:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CCB53081D6;
	Thu, 28 Aug 2025 10:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WPxHq3lO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965153081B6;
	Thu, 28 Aug 2025 10:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756375913; cv=none; b=k/e6ZH/czfpyveMng8fmry2JDk1EIsYzdeGo/ZxnuNnH2cu+EDjmAEsSplzAW5rVrwCkbT7v7wa2eTRouBhi3P70PEzMb3gYtW806bZvEE4ZFpJsa4jWm7v/FmRfYgQoynqbXYE4at6nftqrKKrSHrDGbrbxVC71EM0/OzTiFl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756375913; c=relaxed/simple;
	bh=Nyv56jdJyPYMI8gKpIokw2JpojiScUeg14lmkOgrgHI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OjaGY1JClWQzkvZ+mVV0E3cJ6JPHWyU/A67dap7Ext02t2wg4RQIilMGdnRi3Fn4uWs79idfShd/eoimn7YOmCrYP9z7PVdXeLaGAOq8h7ASh2Mr7eLHu+4K9gjpLkQcgYNDenX49mVMvgLPh1hIcoM7Uc2mHTm4MIXpLg0XV0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WPxHq3lO; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756375912; x=1787911912;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Nyv56jdJyPYMI8gKpIokw2JpojiScUeg14lmkOgrgHI=;
  b=WPxHq3lOHEuANW+eC1oC4Y9UqHqAwVUFHMX78QMpAsu5HFd9AIXD7WgH
   0Hlkt1/GrNSIAWAxjR4F4iN+FzyowEyVE+f91CysBdoSagGnHzJTAGbmI
   N/MrXv+nE5NUsCFCAKHfGpbzu7l2lwvEwOHKTDrdBbOYbfKPRPOD09Etb
   HZIBbs7wZ2u2iIWWP0Lgc+q7qPSwAz4WC2LHzq8wBYq5RNxLcMWzR4gkW
   ZKK+QtF5VVSKTbEo86VpsZurmLj5qKN3Yq+qUBYCxwFGLh3YW5/pvMm6a
   4Uqegby065LXK2Ip6IpryHOcuSlJJrVQNwtd06GrJXzL25mI9FXb7A4Y5
   A==;
X-CSE-ConnectionGUID: YusEYHcgT3WURsZheeasoQ==
X-CSE-MsgGUID: OJUK091KQnOYBo4v74VTrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="61275051"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="61275051"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 03:11:51 -0700
X-CSE-ConnectionGUID: IksLcVIuSKiOiKUjLE5WDg==
X-CSE-MsgGUID: D/cWZQBsQ5Sy8Z83dA780Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="169972658"
Received: from unknown (HELO [10.238.11.127]) ([10.238.11.127])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 03:11:47 -0700
Message-ID: <6b1ec845-4e24-4aa9-b262-49b2fc57553f@linux.intel.com>
Date: Thu, 28 Aug 2025 18:11:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/2] KVM: TDX: Disable general support for MWAIT in
 guest
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
References: <20250816144436.83718-1-adrian.hunter@intel.com>
 <20250816144436.83718-2-adrian.hunter@intel.com>
 <aKMzEYR4t4Btd7kC@google.com>
 <136ab62e9f403ad50a7c2cb4f9196153a0a2ef7c.camel@intel.com>
 <97d3090d-38c5-40df-bab0-c81fc152321d@linux.intel.com>
 <b7ee32f9e343a10094b21bed455262fecd2e071e.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <b7ee32f9e343a10094b21bed455262fecd2e071e.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/19/2025 11:59 PM, Edgecombe, Rick P wrote:
> On Tue, 2025-08-19 at 13:40 +0800, Binbin Wu wrote:
>> Currently, KVM TDX code filters out TSX (HLE or RTM) and WAITPKG using
>> tdx_clear_unsupported_cpuid(), which is sort of blacklist.
>>
>> I am wondering if we could add another array, e.g., tdx_cpu_caps[], which is the
>> TDX version of kvm_cpu_caps[].
>>
>> Using tdx_cpu_caps[] is a whitelist way.
> We had something like this in some of the earlier revisions of the TDX CPUID
> configuration.
>
>> For a new feature
>> - If the developer doesn't know anything about TDX, the bit just be added to
>>     kvm_cpu_caps[].
>> - If the developer knows that the feature supported by both non-TDX VMs and TDs
>>     (either the feature doesn't require any additional virtualization support or
>>     the virtualization support is added for TDX), extend the macros to set the bit
>>     both in kvm_cpu_caps[] and tdx_cpu_caps[].
>> - If there is a feature not supported by non-TDX VMs, but supported by TDs,
>>     extend the macros to set the bit only in tdx_cpu_caps[].
>> So, tdx_cpu_caps[] could be used as the filter of configurable bits reported
>> to userspace.
> In some ways this is the simplest, but having to maintain a big list in KVM was
> not ideal.
Agree.

> The original solution started with KVM_GET_SUPPORTED_CPUID and then
> massaged the results to fit, so maybe just encoding the whole thing separately
> is enough to reconsider it.
>
> But what I was thinking is that we could most of that hardcoded list into the
> TDX module, and only keep a list of non-trivial features (i.e. not simple
> instruction CPUID bits) in KVM. The list of simple features (definition TBD)
> could be provided by the TDX module.
It sounds like a good idea.

Either a list of simple features, or the opposite version is OK.
TDX module already provided the interface to get directly configurable bits.
VMM can get the other part by masking.
But providing a list of non-trivial features may be more direct.

I think non-trivial features should cover both cases:
- a feature clobbers host state
- a feature that requires additional para-virtualization support in VMM. E.g,
   the feature related MSR(s) should be virtualized by VMM. Without proper
   para-virtualization support in VMM, the guest will experience functionality
   issue when using the feature


> So KVM could do the full filtering but only
> keep a list that today would just look like TSX and WAITPKG that we already
> have. So basically the same as what you are proposing, but just shrinks the size
> of list KVM has to keep.
>
>> Comparing to blacklist (i.e., tdx_clear_unsupported_cpuid()), there is no risk
>> that a feature not supported by TDX is forgotten to be added to the blacklist.
>> Also, tdx_cpu_caps[] could support a feature that not supported for non-TDX VMs.
> We definitely can't have TDX module adding any host affecting features that we
> would automatically allow. And having a separate opt-in interface that doesn't
> "speak" cpuid bits is going to just complicate the already complicated logic
> that is in QEMU.
With the list of non-trivial features, VMM can prevent userspace from setting
any bit in the list not supported by VMM.
So can KVM only enforce the consistency for non-trivial feature bits? After all,
these bits are really matters from KVM's view.

If letting userspace, KVM and TDX module have a consistent view of CPUIDs for a
TD is still a target. When a new fixed1 bit is added in a new TDX spec, it still
requires an opt-in interface to allow userspace to get the full picture. Also,
userspace doesn't know which opt-in options are available unless TDX module
provide another interface to report them... yeah, very complicated :(

Ideally, if TDX module never adds new fixed1 bit (including new defined and
converted from other types), or convert a fixed1 bit to fixed0 bit, then
userspace can calculate the right fixed1 bits based on the base spec and the
directly configurable bits without separate opt-in interface.

>
>> Then we don't need a host opt-in for these directly configurable bits not
>> clobbering host states.
>>
>> Of course, to prevent userspace from setting feature bit that would clobber host
>> state, but not included in tdx_cpu_caps[], I think a new feature that would
>> clobber host state should requires a host opt-in to TDX module.
> Yes, but if have some way to get the host clobbering type info programatically
> we could keep the host opt-in as part of the main CPUID bit configuration. What
> I think will be bad is if we grow a separate protocol of opt-ins. KVM and QEMU
> manage everything with CPUID, so it will be easier if we stick to that.
>
Agree.


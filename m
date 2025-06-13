Return-Path: <kvm+bounces-49361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 029C1AD8127
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 04:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C67187B1394
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE3C24886C;
	Fri, 13 Jun 2025 02:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S2eVGnWZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8C223F295;
	Fri, 13 Jun 2025 02:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749782501; cv=none; b=ZZwvIawxHMLAjN+E/oB5WsG0iHD0Rz4KEM6Tb1qGJ7mKZSz7vYDx0JLQnfP5VLfAMuY8TeeAOcfcnol74mTsbibeUj/tgMv+kFm/f5W/Za8KeKffKOwD2/QQq96WF3ovlEUfOLMzc2MILGNi1woHc+fRm251osoZdARMNFh5gio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749782501; c=relaxed/simple;
	bh=xxMW1F3z8YTMbeMxNGREpHep1LR4U/Fx58cvLnL+z8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=equphCih3msJw3yg6HWlWp53eJ3MPu3DVBPuinwDGA8lkmSn9GYgM91XSLBhWbeuGvo6vkc/3RlmC+nXnrj0D7nnGtCi0B0sZpoaRUM+JXyUBWlC7y9BkCw3oIs6MAyRr1xW50UHLJB87kyKj9JDkFjNNiChIsAvCrzTBWNc1zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S2eVGnWZ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749782500; x=1781318500;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xxMW1F3z8YTMbeMxNGREpHep1LR4U/Fx58cvLnL+z8w=;
  b=S2eVGnWZVQE796ppV/ZEynSaiIel3YSOzoxjt6dhnjxjmhzqAbxygvV/
   qX/k53j1awjp3AzPt07TnLDVoO3FV+xyQrGwlKRXkRUth1VYowvYaltuJ
   pzj+ccCy87w6dPa81AH/xsUISlI9PIKryo/g+pI5ZvsyRZy51ZRWvA3uU
   RV/MYi0dnHjJ6+Pa7e246BbAiHA/U2QaaIrhhNexeqH59XOGv8MTU+2Fs
   xmpeGZTPeaOS8eFQjoEN6nnvHotoJaASH4QTB5cKYMaXcp6MSqNsuG+OI
   eGmu/j23Fz/fLKsmPFycamRVyEpW8l+iW/bf1YP7WuZFtEsjMtC9zfO38
   w==;
X-CSE-ConnectionGUID: jbyxuoHaSnKYYMgzzCRPlA==
X-CSE-MsgGUID: Ql1IEAKYRFuvoyOu4jwc3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="69431806"
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="69431806"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 19:41:31 -0700
X-CSE-ConnectionGUID: sqDyY4HWSey42Ikpx0U4pA==
X-CSE-MsgGUID: agk3eGefSRub+qh/FKVIVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="147554400"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 19:41:24 -0700
Message-ID: <3a7e883a-440f-4bec-a592-ac3af4cb1677@intel.com>
Date: Fri, 13 Jun 2025 10:41:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
To: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>
Cc: Yan Y Zhao <yan.y.zhao@intel.com>,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 Kirill Shutemov <kirill.shutemov@intel.com>, Fan Du <fan.du@intel.com>,
 Dave Hansen <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
 Zhiquan Li <zhiquan1.li@intel.com>,
 "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "tabba@google.com" <tabba@google.com>,
 "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Ira Weiny <ira.weiny@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 "michael.roth@amd.com" <michael.roth@amd.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 Chao P Peng <chao.p.peng@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Vishal Annapurve <vannapurve@google.com>, "jroedel@suse.de"
 <jroedel@suse.de>, Jun Miao <jun.miao@intel.com>,
 "pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030618.352-1-yan.y.zhao@intel.com>
 <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
 <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
 <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
 <119e40ecb68a55bdf210377d98021683b7bda8e3.camel@intel.com>
 <aEmVa0YjUIRKvyNy@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aEmVa0YjUIRKvyNy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/2025 10:42 PM, Sean Christopherson wrote:
> On Tue, May 20, 2025, Kai Huang wrote:
>> On Tue, 2025-05-20 at 17:34 +0800, Zhao, Yan Y wrote:
>>> On Tue, May 20, 2025 at 12:53:33AM +0800, Edgecombe, Rick P wrote:
>>>> On Mon, 2025-05-19 at 16:32 +0800, Yan Zhao wrote:
>>>>>> On the opposite, if other non-Linux TDs don't follow 1G->2M->4K
>>>>>> accept order, e.g., they always accept 4K, there could be *endless
>>>>>> EPT violation* if I understand your words correctly.
>>>>>>
>>>>>> Isn't this yet-another reason we should choose to return PG_LEVEL_4K
>>>>>> instead of 2M if no accept level is provided in the fault?
>>>>> As I said, returning PG_LEVEL_4K would disallow huge pages for non-Linux TDs.
>>>>> TD's accept operations at size > 4KB will get TDACCEPT_SIZE_MISMATCH.
>>>>
>>>> TDX_PAGE_SIZE_MISMATCH is a valid error code that the guest should handle. The
>>>> docs say the VMM needs to demote *if* the mapping is large and the accept size
>>>> is small.
> 
> No thanks, fix the spec and the TDX Module.  Punting an error to the VMM is
> inconsistent, convoluted, and inefficient.
> 
> Per "Table 8.2: TDG.MEM.PAGE.ACCEPT SEPT Walk Cases":
> 
>    S-EPT state         ACCEPT vs. Mapping Size         Behavior
>    Leaf SEPT_PRESENT   Smaller                         TDACCEPT_SIZE_MISMATCH
>    Leaf !SEPT_PRESENT  Smaller                         EPT Violation <=========================|
>    Leaf DONT_CARE      Same                            Success                                 | => THESE TWO SHOULD MATCH!!!
>    !Leaf SEPT_FREE     Larger                          EPT Violation, BECAUSE THERE'S NO PAGE  |
>    !Leaf SEPT_FREE     Larger                          TDACCEPT_SIZE_MISMATCH <================|
> 
> 
> If ACCEPT is "too small", an EPT violation occurs.  But if ACCEPT is "too big",
> a TDACCEPT_SIZE_MISMATCH error occurs.  That's asinine.
> 
> The only reason that comes to mind for punting the "too small" case to the VMM
> is to try and keep the guest alive if the VMM is mapping more memory than has
> been enumerated to the guest.  E.g. if the guest suspects the VMM is malicious
> or buggy.  IMO, that's a terrible reason to push this much complexity into the
> host.  It also risks godawful boot times, e.g. if the guest kernel is buggy and
> accepts everything at 4KiB granularity.
> 
> The TDX Module should return TDACCEPT_SIZE_MISMATCH and force the guest to take
> action, not force the hypervisor to limp along in a degraded state.  If the guest
> doesn't want to ACCEPT at a larger granularity, e.g. because it doesn't think the
> entire 2MiB/1GiB region is available, then the guest can either log a warning and
> "poison" the page(s), or terminate and refuse to boot.
> 
> If for some reason the guest _can't_ ACCEPT at larger granularity, i.e. if the
> guest _knows_ that 2MiB or 1GiB is available/usable but refuses to ACCEPT at the
> appropriate granularity, then IMO that's firmly a guest bug.

It might just be guest doesn't want to accept a larger level instead of 
can't. Use case see below.

> If there's a *legitimate* use case where the guest wants to ACCEPT a subset of
> memory, then there should be an explicit TDCALL to request that the unwanted
> regions of memory be unmapped.  Smushing everything into implicit behavior has
> obvioulsy created a giant mess.

Isn't the ACCEPT with a specific level explicit? Note that ACCEPT is not 
only for the case that VMM has already mapped page and guest only needs 
to accept it to make it available, it also works for the case that guest 
requests VMM to map the page for a gpa (at specific level) then guest 
accepts it.

Even for the former case, it is understandable for behaving differently 
for the "too small" and "too big" case. If the requested accept level is 
"too small", VMM can handle it by demoting the page to satisfy guest. 
But when the level is "too big", usually the VMM cannot map the page at 
a higher level so that ept violation cannot help. I admit that it leads 
to the requirement that VMM should always try to map the page at the 
highest available level, if the EPT violation is not caused by ACCEPT 
which contains a desired mapping level.

As for the scenario, the one I can think of is, guest is trying to 
convert a 4K sized page between private and shared constantly, for 
testing purpose. Guest knows that if accepting the gpa at higher level, 
it takes more time. And when convert it to shared, it triggers DEMOTE 
and more time. So for better performance, guest just calls ACCEPT with 
4KB page. However, VMM returns PAGE_SIZE_MATCH and enforces guest to 
accept a bigger size. what a stupid VMM.

Anyway, I'm just expressing how I understand the current design and I 
think it's reasonable. And I don't object the idea to return 
ACCEPT_SIZE_MISMATCH for "too small" case, but it's needs to be guest 
opt-in, i.e., let guest itself chooses the behavior.


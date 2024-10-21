Return-Path: <kvm+bounces-29260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B2CF9A5EB9
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 10:35:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D6101C215D0
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29EDC1E22F9;
	Mon, 21 Oct 2024 08:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c2QvAeHg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1294F1D0F76;
	Mon, 21 Oct 2024 08:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729499732; cv=none; b=ZifGCRTtRuubqp6m6DoTRdoRlFHBjl7opZx1cynDhBEvg/E+gc/X+jPU1FHo2JWkYVwsyHKXnrbhKwTivG9PUpWbNbFRqg8B9abWVAbahutfwa3bWnHXu28ccmj9ymY1kDQP5UU8k08KQYu1IrVEjoJem5VqyUrTaIx663ikWlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729499732; c=relaxed/simple;
	bh=FkaMvQc080r/OnG8E8ERhiVl7thWGOwKq3t+EBfEcAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=msz017ELB+8d0ffZZD7BlE1oj5KE9F4N/GlD2tydGuViTZePVBix71r05l3s6xgGKsTNlWSjbFE8fLD0zTYBY6NS8tRN36zsRXKQgpHikjTmuO0okDgKLUizO1lX1QO7SwM5E3EHjIFy2na6SDgZej9zX4mxvsZjCjUsa66Qlqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c2QvAeHg; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729499730; x=1761035730;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FkaMvQc080r/OnG8E8ERhiVl7thWGOwKq3t+EBfEcAo=;
  b=c2QvAeHgMdk9OYrTkf3YMew3Z0totxTGqwapLiE8nzD0vdMXj7q7jgOB
   hwxr9QsYGey0ZvlK55zFwGpyadL9jdm0huK3+N37aZF+aMl/t8YoGyrJr
   HrFZH9Rq9C7lNJ+JozVIEUTfEDl73xapqEbj2VeIF2UPfOj0PKTILE2HG
   equSQHDfJHHoHw9V5W+a3XCV6MaWagyhNNWe1AhW/FhHb3ijo5sS0AZbu
   A0pa0PvQO4VBLHDYy4T06k8zGtiO2gr3PFDTz3kPbji0D8OoIcf39lxKm
   ABuHV69wA1ntIPRBqrIvPaSG/HlcZTpBn4dG5N8JUx6hfW/AemxBkg08H
   w==;
X-CSE-ConnectionGUID: N02P0MzoSi2TuYxEmMAy+w==
X-CSE-MsgGUID: lqshXKphT2SY1P2RPWDd4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11231"; a="28422947"
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="28422947"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 01:35:29 -0700
X-CSE-ConnectionGUID: bGz8EDNMQXKWVeo7/kBbLw==
X-CSE-MsgGUID: 0CtfNHd7SliWf5a92bBphw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="79461463"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.172]) ([10.124.227.172])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 01:35:27 -0700
Message-ID: <1cb07b5d-1e42-44a4-bc0f-adc03433eb90@intel.com>
Date: Mon, 21 Oct 2024 16:35:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
 <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
 <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-19-rick.p.edgecombe@intel.com>
 <20240813080009.zowu3woyffwlyazu@yy-desk-7060>
 <1a200cd3-ad73-4a53-bc48-661f7d022ac0@intel.com>
 <1be47d7f9d4b812c110572d8b413ecdbb537ceb7.camel@intel.com>
 <aa3d2db8-e72c-42e2-b08f-6a4c9ad78748@intel.com>
 <0136dbcb2712828859447bc7696974e643a76208.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <0136dbcb2712828859447bc7696974e643a76208.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/18/2024 10:20 PM, Edgecombe, Rick P wrote:
> On Fri, 2024-10-18 at 10:21 +0800, Xiaoyao Li wrote:
>>> KVM usually leaves it up to userspace to not create nonsensical VMs. So I
>>> think
>>> we can skip the check in KVM.
>>
>> It's not nonsensical unless KVM announces its own requirement for TD
>> guest that userspace VMM must provide valid CPUID leaf 0x1f value for
>> topology.
> 
> How about adding it to the docs?

OK for me.

>>
>> It's architectural valid that userspace VMM creates a TD with legacy
>> topology, i.e., topology enumerated via CPUID 0x1 and 0x4.
>>
>>> In that case, do you see a need for the vanilla tdh_vp_init() SEAMCALL
>>> wrapper?
>>>
>>> The TDX module version we need already supports enum_topology, so the code:
>>>   	if (modinfo->tdx_features0 & MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM)
>>>   		err = tdh_vp_init_apicid(tdx, vcpu_rcx, vcpu->vcpu_id);
>>>   	else
>>>   		err = tdh_vp_init(tdx, vcpu_rcx);
>>>
>>> The tdh_vp_init() branch shouldn't be hit.
>>
>> We cannot know what version of TDX module user might use thus we cannot
>> assume enum_topology is always there unless we make it a hard
>> requirement in KVM that TDX fails being enabled when
>>
>>     !(modinfo->tdx_features0 & MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM)
> 
> We will depend on bugs that are fixed in TDX Modules after enum topology, so it
> shouldn't be required in the normal case. So I think it would be simpler to add
> this tdx_features0 conditional. We can then export one less SEAMCALL and will
> have less configurations flows to worry about on the KVM side.

I'm a little bit confused. what does "add this tdx_feature0 conditional" 
mean?


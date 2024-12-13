Return-Path: <kvm+bounces-33739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A98059F1272
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 17:44:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E19581881976
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 16:44:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7EB01E377E;
	Fri, 13 Dec 2024 16:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dz4o4yG3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B281534F7;
	Fri, 13 Dec 2024 16:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734108261; cv=none; b=M0QOxOQ7xtu8fWyr4h1G/K4GDtNiAsO+ua9QFaAK2kMbIb0OYpNSbDhQxBBDpKFi4B1PH2OM4d6gWBhcIZufZlU3J2q5unD/Z/oO8H8jcBKvZUkiHm2jOgsztWbTlqkP84PEvsA96yGzcvlvSYYQ7SRmhLJpXMJQH8JfMLrGfUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734108261; c=relaxed/simple;
	bh=366EGQGlugHCRw82dXXSJxegN4J/XvsAoNdowBfIIWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R02TB12KBe9nMDoSuWDlNouchJklgjfIo87IAlttWO/ZJuwFzMQ63Y+f75Pl7GGj6XOD+DYtb9mwOkOV+DF1H5Yuix+RojW5vhlne3K/HgE53CFDoAp6HUbSM+UQkQKc8XF1l6C06fBwEvdw5lDxr7opxKhyiiZVIBNEIip/9rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dz4o4yG3; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734108260; x=1765644260;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=366EGQGlugHCRw82dXXSJxegN4J/XvsAoNdowBfIIWQ=;
  b=Dz4o4yG3hlFiP3E9b0eXf/HwaxQttlfRDE2b8hSnQtp4Qr43dVa9CR9R
   0VVPDW6O2di5N7CDpO3FGK4Ilabb7ydMBUsADw5V4nGvxN+5Lo5bBucx1
   evmTvYmLXNrbHPXuM58cTL3sQJf8wfv/QYDdDM91uzOJs3HVWl4PNNz9w
   YwzZ1qaDMgriJCBHMEZe5JMLg8YNjYG4hMfIyeWXdmMYkqcMNbRoBhx9C
   9h0NmR5q+6DXqszVwb6g8HoRBKuJEsZuRbN2WaLsh8JJCA1BaPJQzIgct
   L3ojBtbsmtwo5GICVOG5M/bgFz89Ltw8wVfICN089lE8KSVgif1hgtvZl
   w==;
X-CSE-ConnectionGUID: 82A/iagQR9m7SxPvvNp1aQ==
X-CSE-MsgGUID: reBlpuO5QTyKDnBXEg0QSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11285"; a="45258985"
X-IronPort-AV: E=Sophos;i="6.12,231,1728975600"; 
   d="scan'208";a="45258985"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2024 08:44:18 -0800
X-CSE-ConnectionGUID: Wly8Pup0TKSC6hOc/Yq/Iw==
X-CSE-MsgGUID: ZsuXyWofSRGT3Ll0k6EGQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,231,1728975600"; 
   d="scan'208";a="96465913"
Received: from philliph-desk.amr.corp.intel.com (HELO [10.124.223.121]) ([10.124.223.121])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2024 08:44:17 -0800
Message-ID: <91ebbd09-a02b-4287-a192-9259a6a78c4c@intel.com>
Date: Fri, 13 Dec 2024 08:44:16 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/7] x86/virt/tdx: Add SEAMCALL wrapper to enter/exit
 TDX guest
To: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org, dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-2-adrian.hunter@intel.com>
 <fa817f29-e3ba-4c54-8600-e28cf6ab1953@intel.com>
 <0226840c-a975-42a5-9ddf-a54da7ef8746@intel.com>
 <56db8257-6da2-400d-8306-6e21d9af81f8@intel.com>
 <d1952eb7-8eb0-441b-85fc-3075c7b11cb9@intel.com>
 <6af0f1c3-92eb-407e-bb19-6aeca9701e41@intel.com>
 <ff4d5877-52ad-4e12-94a0-dfbe01a7a8a0@intel.com>
 <d1b0323f-2458-420b-800e-a26ba6550de7@intel.com>
 <f7cd9af3-8b6a-4984-80ef-e9129d8d94bd@intel.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <f7cd9af3-8b6a-4984-80ef-e9129d8d94bd@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/13/24 08:30, Adrian Hunter wrote:
> On 13/12/24 18:16, Dave Hansen wrote:
>> On 12/11/24 10:43, Adrian Hunter wrote:
>> ...
>>> -	size = tdvmcall_a0_read(vcpu);
>>> -	write = tdvmcall_a1_read(vcpu);
>>> -	port = tdvmcall_a2_read(vcpu);
>>> +	size  = tdx->vp_enter_out.io_size;
>>> +	write = tdx->vp_enter_out.io_direction == TDX_WRITE;
>>> +	port  = tdx->vp_enter_out.io_port;
>> ...> +	case TDVMCALL_IO:
>>> +		out->io_size		= args.r12;
>>> +		out->io_direction	= args.r13 ? TDX_WRITE : TDX_READ;
>>> +		out->io_port		= args.r14;
>>> +		out->io_value		= args.r15;
>>> +		break;
>>
>> I honestly don't understand the need for the abstracted structure to sit
>> in the middle. It doesn't get stored or serialized or anything, right?
>> So why have _another_ structure?
>>
>> Why can't this just be (for instance):
>>
>> 	size = tdx->foo.r12;
>>
>> ?
>>
>> Basically, you hand around the raw arguments until you need to use them.
> 
> That sounds like what we have at present?  That is:
> 
> u64 tdh_vp_enter(u64 tdvpr, struct tdx_module_args *args)
> {
> 	args->rcx = tdvpr;
> 
> 	return __seamcall_saved_ret(TDH_VP_ENTER, args);
> }
> 
> And then either add Rick's struct tdx_vp?  Like so:
> 
> u64 tdh_vp_enter(struct tdx_vp *vp, struct tdx_module_args *args)
> {
> 	args->rcx = tdx_tdvpr_pa(vp);
> 
> 	return __seamcall_saved_ret(TDH_VP_ENTER, args);
> }
> 
> Or leave it to the caller:
> 
> u64 tdh_vp_enter(struct tdx_module_args *args)
> {
> 	return __seamcall_saved_ret(TDH_VP_ENTER, args);
> }
> 
> Or forget the wrapper altogether, and let KVM call
> __seamcall_saved_ret() ?

Rick's version, please.

I don't want __seamcall_saved_ret() exported to modules. I want to at
least have a clean boundary beyond which __seamcall_saved_ret() is not
exposed.

My nit with the "u64 tdvpr" version was that there's zero type safety.

The tdvp-less tdh_vp_enter() is even *less* safe of a calling convention
and also requires that each caller do tdx_tdvpr_pa() or equivalent.

But I feel like I'm repeating myself a bit at this point.


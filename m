Return-Path: <kvm+bounces-33045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 228409E3F1F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 17:05:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49FB4169C54
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 16:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB0F21C18C;
	Wed,  4 Dec 2024 15:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E2AhQQ5Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A30221C193;
	Wed,  4 Dec 2024 15:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733327916; cv=none; b=iMrnuj9a/Lc7dgvcvw1b1xYUjQcGVCWxXe+LwiJbO6sssnwZI1pw88oIVOoJx7dvGQF/zQ7RyHXSCXW4hQon3XUUjqFZ2ME9UqX7jbKGBv685xlnirHwnn8PvIGX/mUHh3ywen0IyilcxUgbV2rrZA8J21u/0yOD6yrf4/xaCUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733327916; c=relaxed/simple;
	bh=Wjc45Rb2IVzhKhPW5XAM48G8NCpmAqJOPRBFw2u/UMo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=pBzg5tGF/tw+DmT8B6bt1/FJn6SG3AKEw3xiTSCvPOYifIXbfERv5aeGCFOYks7Fau+ESC6ZD635PFea8pyyXOiMbxmR4CYTChSrXfaYOsWGo3giJ0Pgp5Wk1ymaAuumEpEHd0enIXGX8O7izIgs/1aPTRTcJZjdPb3jbd4NnB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E2AhQQ5Q; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733327914; x=1764863914;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=Wjc45Rb2IVzhKhPW5XAM48G8NCpmAqJOPRBFw2u/UMo=;
  b=E2AhQQ5QCx/5C89N78dvcPxUZ2hmwD6zWUmgWjx/+x1pDyxFko8V21gW
   DeWoOLGHggI3c2yi9wLBC1gEJO4A0Z0kWmGl8bP/9whKhWXOb5nHcpuoT
   pJMWLsy9LxRj0acmyxUSjZ+re/4bJVGnwSGF75CeEiPBFvxCgZyFYmRQV
   Hq9J2aVZPoKMhWZ2GnpK1yZ7vU6DPUS8Jxg/U+CcQxAupURSvuTXZ57SK
   9+BRLr3KMELQ2F1YqGxMl1yfZ6pmzIke+kxlqHs6yhml+S1WLSAfEk1al
   YdSfuqHHDyiSYbyXJy1LmDihjKrxlzZlHL9ndbfHI1V6DUeSvbPxap/p/
   A==;
X-CSE-ConnectionGUID: bEd+wTQYR36HgaEhFHH0KQ==
X-CSE-MsgGUID: NVfNunBKR3+J7CTE7VXjbQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="33850478"
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="33850478"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 07:58:34 -0800
X-CSE-ConnectionGUID: VRemptMpR9Gnry71kjDk6Q==
X-CSE-MsgGUID: 8xmFtLNHRkiA6p4rY6nuRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="98612789"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.89.141])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 07:58:28 -0800
Message-ID: <6af0f1c3-92eb-407e-bb19-6aeca9701e41@intel.com>
Date: Wed, 4 Dec 2024 17:58:20 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/7] x86/virt/tdx: Add SEAMCALL wrapper to enter/exit
 TDX guest
From: Adrian Hunter <adrian.hunter@intel.com>
To: Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
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
Content-Language: en-US
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <d1952eb7-8eb0-441b-85fc-3075c7b11cb9@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/11/24 13:13, Adrian Hunter wrote:
> On 25/11/24 15:40, Adrian Hunter wrote:
>> On 22/11/24 18:33, Dave Hansen wrote:
>>> On 11/22/24 03:10, Adrian Hunter wrote:
>>>> +struct tdh_vp_enter_tdcall {
>>>> +	u64	reg_mask	: 32,
>>>> +		vm_idx		:  2,
>>>> +		reserved_0	: 30;
>>>> +	u64	data[TDX_ERR_DATA_PART_2];
>>>> +	u64	fn;	/* Non-zero for hypercalls, zero otherwise */
>>>> +	u64	subfn;
>>>> +	union {
>>>> +		struct tdh_vp_enter_vmcall 		vmcall;
>>>> +		struct tdh_vp_enter_gettdvmcallinfo	gettdvmcallinfo;
>>>> +		struct tdh_vp_enter_mapgpa		mapgpa;
>>>> +		struct tdh_vp_enter_getquote		getquote;
>>>> +		struct tdh_vp_enter_reportfatalerror	reportfatalerror;
>>>> +		struct tdh_vp_enter_cpuid		cpuid;
>>>> +		struct tdh_vp_enter_mmio		mmio;
>>>> +		struct tdh_vp_enter_hlt			hlt;
>>>> +		struct tdh_vp_enter_io			io;
>>>> +		struct tdh_vp_enter_rd			rd;
>>>> +		struct tdh_vp_enter_wr			wr;
>>>> +	};
>>>> +};
>>>
>>> Let's say someone declares this:
>>>
>>> struct tdh_vp_enter_mmio {
>>> 	u64	size;
>>> 	u64	mmio_addr;
>>> 	u64	direction;
>>> 	u64	value;
>>> };
>>>
>>> How long is that going to take you to debug?
>>
>> When adding a new hardware definition, it would be sensible
>> to check the hardware definition first before checking anything
>> else.
>>
>> However, to stop existing members being accidentally moved,
>> could add:
>>
>> #define CHECK_OFFSETS_EQ(reg, member) \
>> 	BUILD_BUG_ON(offsetof(struct tdx_module_args, reg) != offsetof(union tdh_vp_enter_args, member));
>>
>> 	CHECK_OFFSETS_EQ(r12, tdcall.mmio.size);
>> 	CHECK_OFFSETS_EQ(r13, tdcall.mmio.direction);
>> 	CHECK_OFFSETS_EQ(r14, tdcall.mmio.mmio_addr);
>> 	CHECK_OFFSETS_EQ(r15, tdcall.mmio.value);
>>
> 
> Note, struct tdh_vp_enter_tdcall is an output format.  The tdcall
> arguments come directly from the guest with no validation by the
> TDX Module.  It could be rubbish, or even malicious rubbish.  The
> exit handlers validate the values before using them.
> 
> WRT the TDCALL input format (response by the host VMM), 'ret_code'
> and 'failed_gpa' could use types other than 'u64', but the other
> members are really 'u64'.
> 
> /* TDH.VP.ENTER Input Format #2 : Following a previous TDCALL(TDG.VP.VMCALL) */
> struct tdh_vp_enter_in {
> 	u64	__vcpu_handle_and_flags; /* Don't use. tdh_vp_enter() will take care of it */
> 	u64	unused[3];
> 	u64	ret_code;
> 	union {
> 		u64 gettdvmcallinfo[4];
> 		struct {
> 			u64	failed_gpa;
> 		} mapgpa;
> 		struct {
> 			u64	unused;
> 			u64	eax;
> 			u64	ebx;
> 			u64	ecx;
> 			u64	edx;
> 		} cpuid;
> 		/* Value read for IO, MMIO or RDMSR */
> 		struct {
> 			u64	value;
> 		} read;
> 	};
> };
> 
> Another different alternative could be to use an opaque structure,
> not visible to KVM, and then all accesses to it become helper
> functions like:
> 
> struct tdx_args;
> 
> int tdx_args_get_mmio(struct tdx_args *args,
> 		      enum tdx_access_size *size,
> 		      enum tdx_access_dir *direction,
> 		      gpa_t *addr,
> 		      u64 *value);
> 
> void tdx_args_set_failed_gpa(struct tdx_args *args, gpa_t gpa);
> void tdx_args_set_ret_code(struct tdx_args *args, enum tdx_ret_code ret_code);
> etc
> 
> For the 'get' functions, that would tend to imply the helpers
> would do some validation.
> 

IIRC Dave said something like, if the wrapper doesn't add any
value, then it is just as well not to have it at all.

So that option would be to drop patch "x86/virt/tdx: Add SEAMCALL
wrapper to enter/exit TDX guest" with tdh_vp_enter() and instead
just call __seamcall_saved_ret() directly, noting that:

 - __seamcall_saved_ret() is only used for TDH.VP.ENTER
 - KVM seems likely to be the only code that would ever
 need to use TDH.VP.ENTER



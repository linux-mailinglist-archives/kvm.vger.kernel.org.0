Return-Path: <kvm+bounces-31557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 612629C4F6C
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:27:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D402DB21BF0
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB63920B1EE;
	Tue, 12 Nov 2024 07:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aUPpV7lX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443DE20A5D9;
	Tue, 12 Nov 2024 07:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731396407; cv=none; b=YcbBfe++64SoJ+njTZ8cnrHPK9WydgO80i6ko1D8+JkdJek2DSQ1wsGAAkdaCi0PTXhvg52rYeHr1KX0xANMczv9peQ2MBGBG+WuDPd9Aj7fWsaNtT7r8iCj0eOCXQvn8NZDM3ramuA0P6M1uWQdFdFf+H7kmMUjyLXggUIqDRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731396407; c=relaxed/simple;
	bh=YJsH1UQXIIirb6MSlNGxTPuga9nwFttObzEgjwlA1Jo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=AZxjs3VYJc5KCrl/Oui5uJFXMyCuUJK01aVsUFv74PBzB2dOI6AXYhV0q+Mcfz96vUX+ZQY1+aitDGf53lkORPh8UCPbbBkYq6j1DzrUxgKIQ9Yj6V3AeQny9rSy2rJCGiStpmfj2FVUrIF/Ye9jYSl6NtO6RuiGsKLbzWp2ouw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aUPpV7lX; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731396405; x=1762932405;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=YJsH1UQXIIirb6MSlNGxTPuga9nwFttObzEgjwlA1Jo=;
  b=aUPpV7lXXySylBYbHzqGWKPmd3/spnvCC2NDZePXIbdeWX080GvPAVya
   plYBZCFnmCoN8dKndOdwMuqsG26X/ggR9EZkQvGuRwyNomJzf3HkZPEeS
   0W9MO+Jq2mYomijEJ6/AVsvwSqFm5ytRK4EXlKv5ShzDJ5ji8PvX+6di5
   5v/pYwFiTVGnxQA6hRtgFQGWOPnOKZeqJ103jaGxNoubkmneH9TwRy6kX
   ztu+cHEksTpEam2v0WwDuh6wfoBrub9az9yZvb7LymyZgTngWnJ1m1SI4
   yecL+vRyk63cavQNvH4S0bOtg4GSU8NMEiqRJSxWtpT+gqrZy0FVfhsXp
   Q==;
X-CSE-ConnectionGUID: rb+CayZFRjmf9IxeSYM43w==
X-CSE-MsgGUID: A+Y0JYOGSEWPVLptOu1RRg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31387944"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31387944"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:26:44 -0800
X-CSE-ConnectionGUID: jdiF8wiPRiS9f42x2Otuhw==
X-CSE-MsgGUID: 7CBICEEgSYOCByZkX2xrYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="87075068"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.16.81])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:26:41 -0800
Message-ID: <2f0b7e2c-2d1d-4390-8cc9-72a0c3d44370@intel.com>
Date: Tue, 12 Nov 2024 09:26:36 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v2 00/25] TDX vCPU/VM creation
To: Tony Lindgren <tony.lindgren@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
 seanjc@google.com, yan.y.zhao@intel.com, isaku.yamahata@gmail.com,
 kai.huang@intel.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 xiaoyao.li@intel.com, reinette.chatre@intel.com
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <d0cf8fb2-9cff-40d0-8ffb-5d0ba9c86539@intel.com>
 <ZzHTLO-TM_5_Q7U3@tlindgre-MOBL1>
Content-Language: en-US
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <ZzHTLO-TM_5_Q7U3@tlindgre-MOBL1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/11/24 11:49, Tony Lindgren wrote:
> On Thu, Oct 31, 2024 at 09:21:29PM +0200, Adrian Hunter wrote:
>> On 30/10/24 21:00, Rick Edgecombe wrote:
>>> Here is v2 of TDX VM/vCPU creation series. As discussed earlier, non-nits 
>>> from v1[0] have been applied and it’s ready to hand off to Paolo. A few 
>>> items remain that may be worth further discussion:
>>>  - Disable CET/PT in tdx_get_supported_xfam(), as these features haven’t 
>>>    been been tested.
>>
>> It seems for Intel PT we have no support for restoring host
>> state.  IA32_RTIT_* MSR preservation is Init(XFAM(8)) which means
>> the TDX Module sets the MSR to its RESET value after TD Enty/Exit.
>> So it seems to me XFAM(8) does need to be disabled until that is
>> supported.
> 
> So for now, we should remove the PT bit from tdx_get_supported_xfam(),
> but can still keep it in tdx_restore_host_xsave_state()?

Yes

> 
> Then for save/restore, maybe we can just use the pt_guest_enter() and
> pt_guest_exit() also for TDX. Some additional checks are needed for
> the pt_mode though as the TDX module always clears the state if PT is
> enabled. And the PT_MODE_SYSTEM will be missing TDX enter/exit data
> but might be otherwise usable.

pt_guest_enter() / pt_guest_exit() are not suitable for TDX.  pt_mode
is not relevant for TDX because the TDX guest is always hidden from the
host behind SEAM.  However, restoring host MSRs is not the only issue.

The TDX Module does not validate Intel PT CPUID leaf 0x14
(except it must be all zero if Intel PT is not supported
i.e. if XFAM bit 8 is zero).  For invalid MSR accesses by the guest,
the TDX Module will inject #GP.  Host VMM could provide valid CPUID
to avoid that, but it would also need to be valid for the destination
platform if migration was to be attempted.

Disabling Intel PT for TDX for now also avoids that issue.


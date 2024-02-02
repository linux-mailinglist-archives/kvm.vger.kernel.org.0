Return-Path: <kvm+bounces-7777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B2584657B
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 02:39:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 999FB1C2403E
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 01:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF38FC13E;
	Fri,  2 Feb 2024 01:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nfR9GklR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9C4BE59;
	Fri,  2 Feb 2024 01:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706837939; cv=none; b=WITuarFJbPwmGQipcC/kkM+9MbE/WAbga30XbZ2KLQwjSqcRT+GZm1v2sKcSlmOqvDiufcAF9hw4pWEQB/lKm+wc/yuDoRfYAjphMttkT9aI09/BFDLIiNzZbt1i209XOKJQQcT2Je8X2AzIh07JG5tSptChiyaQGFxd3KnWAs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706837939; c=relaxed/simple;
	bh=zyaP16MSd8gEad9hTG4ClUHQAbuKQXGyiMvFX29b+L8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lMYD6kvmGH3YgIOlith0ytRyro9QJ1IUulsNEIWFi1hgd09YeAw+ZY62m44rJU6Vv66bT7pEKELIWTvwUsX0xeGkWfU3lHOerrazF3lFCXIPHYu9BQkXH/XTpn7lYnYSLhbHeRkoKILm6DySQzeei7/zr4qEZGgomxalDL3Jao8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nfR9GklR; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706837937; x=1738373937;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zyaP16MSd8gEad9hTG4ClUHQAbuKQXGyiMvFX29b+L8=;
  b=nfR9GklR2lTe5KPWnJYaRzWdIflCskEV45RMe3lsmhS4hS2PpkpXVDMi
   hw+jiWo53MJFXYCBd6Qo3O4p72oFnS0pRSibF+tB0CA2tErsSP93icZ8q
   LK2Rj1TRX+keRa47U+LmuBNaY8QicOc8h4nZF4SEld29gRNpoUuBq5ffx
   W7dayxTOkoe/xVY067aU8WQMYTgFJeDQo8T3tb9twpG5fVX6Yf39XLnE6
   FfjmMD2Vu8LpjqcI16tpvIK7g0GRxL+3w6/9oFY7hCxyvcohVP7uQY+mL
   ONRnDBglxdm53xEGc8+jBILfF45qAflDDdEQL5PIVDJoZLZxPF20WUETE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="240135"
X-IronPort-AV: E=Sophos;i="6.05,236,1701158400"; 
   d="scan'208";a="240135"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 17:38:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,236,1701158400"; 
   d="scan'208";a="144139"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.9.228]) ([10.93.9.228])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 17:38:53 -0800
Message-ID: <95c3dc22-2d40-46fc-bc4d-8206b002e0a1@linux.intel.com>
Date: Fri, 2 Feb 2024 09:38:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: selftests: Test top-down slots event
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
 Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>,
 Aaron Lewis <aaronlewis@google.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20240201061505.2027804-1-dapeng1.mi@linux.intel.com>
 <Zbvcx0A-Ln2sP6XA@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zbvcx0A-Ln2sP6XA@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/2/2024 2:02 AM, Sean Christopherson wrote:
> On Thu, Feb 01, 2024, Dapeng Mi wrote:
>> Although the fixed counter 3 and the exclusive pseudo slots events is
>> not supported by KVM yet, the architectural slots event is supported by
>> KVM and can be programed on any GP counter. Thus add validation for this
>> architectural slots event.
>>
>> Top-down slots event "counts the total number of available slots for an
>> unhalted logical processor, and increments by machine-width of the
>> narrowest pipeline as employed by the Top-down Microarchitecture
>> Analysis method." So suppose the measured count of slots event would be
>> always larger than 0.
> Please translate that into something non-perf folks can understand.  I know what
> a pipeline slot is, and I know a dictionary's definition of "available" is, but I
> still have no idea what this event actually counts.  In other words, I want a
> precise definition of exactly what constitutes an "available slot", in verbiage
> that anyone with basic understanding of x86 architectures can follow after reading
> the whitepaper[*], which is helpful for understanding the concepts, but doesn't
> crisply explain what this event counts.
>
> Examples of when a slot is available vs. unavailable would be extremely helpful.
>
> [*] https://www.intel.com/content/www/us/en/docs/vtune-profiler/cookbook/2023-0/top-down-microarchitecture-analysis-method.html

Yeah, indeed, 'slots' is not easily understood from its literal meaning. 
I also took some time to understand it when I look at this event for the 
first time. Simply speaking, slots is an abstract concept which 
indicates how many uops (decoded from instructions) can be processed 
simultaneously (per cycle) on HW. we assume there is a classic 5-stage 
pipeline, fetch, decode, execute, memory access and register writeback. 
In topdown micro-architectural analysis method, the former two stages 
(fetch/decode) is called front-end and the last three stages are called 
back-end.

In modern Intel processors, a complicated instruction could be decoded 
into several uops (micro-operations) and so these uops can be processed 
simultaneously and then improve the performance. Thus, assume a 
processor can decode and dispatch 4 uops in front-end and execute 4 uops 
in back-end simultaneously (per-cycle), so we would say this processor 
has 4 topdown slots per-cycle. If a slot is spare and can be used to 
process new uop, we say it's available, but if a slot is occupied by a 
uop for several cycles and not retired (maybe blocked by memory access), 
we say this slot is stall and unavailable.

Ok, I would rewrite the commit description and add more explanation there.



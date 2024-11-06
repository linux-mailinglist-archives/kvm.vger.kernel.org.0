Return-Path: <kvm+bounces-31035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ED98C9BF807
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 21:33:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F6DB1F22A74
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 20:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E68820C464;
	Wed,  6 Nov 2024 20:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ytyxj6G6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B930020C325;
	Wed,  6 Nov 2024 20:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730925220; cv=none; b=e5hcLnl0UZMh61xCw0Tvs8lFSghXq6pyElXvWbfDlHZR1nl5/tTp6/NRJODUIJtLX5L9OsEhDfZVyyOKsYSQ1RJCXheo/P3hL0oPkoLHqtze11DPCini4xIrmutTzulvetp/Zsy+HxkHdj/BPVROPhlBbu3wu3bqr8kwWuDSlIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730925220; c=relaxed/simple;
	bh=zoRLMKW55o98JRmgTawjT4yCHMdI37JhvZnILfOLqRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OWGWHzXjBTuDUnv+nx9OPgC+yT5XoPeVxOwNhPA6OXf1x1qUIXwvYG5sRmsOfmvID6GOvAgkUu5KEQ+3ctxmurfj6zN89Y5CWp2BQH7r7zgjZZItETSAzD34L4P+28Vlc/wUx6jCR3/vyEWSk8FZ4axW3kKuroI/nF96L+q4tY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ytyxj6G6; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730925219; x=1762461219;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zoRLMKW55o98JRmgTawjT4yCHMdI37JhvZnILfOLqRQ=;
  b=Ytyxj6G6SsI495CioUmNHx7cRlyBFYFfPMdrwqQTs7kVLR52LzQ5yXFl
   2exwwxeL7MhRBiV/6Rdm8RKO8DWaoyZRS+h3hOj0sKs07xGziQVw4EMsc
   Fbvk7CnMHzRGVnAZbkkW8h/HOS1jYeIxr0v4Jyb7O0R1eOtx8z+rqYb9c
   xhwxObhbata6+Q/OVHoVBhsvu5GxP5DSov99i2y+dhTMa5C7+OxtpF1yQ
   pdLvtICoi/rKfvGMkXiX4O4vHa5yd0AaYEBH0R4CKPPpaM9ONm/ODdTPC
   YP0kPzwBPMtxRSL5zdQYOz5VNqCIGITEymcDudpW6o/0nQLNhBw0y6I8A
   A==;
X-CSE-ConnectionGUID: K0x+SE5ZQ+iFnKBipbx8tw==
X-CSE-MsgGUID: +nIijFSoRrmus9YYZpF2vg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30705990"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30705990"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 12:33:37 -0800
X-CSE-ConnectionGUID: V8XizmLPQ5C6WPxTiJI6TA==
X-CSE-MsgGUID: oNVXimYpTpmteoMQVxNatg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="84355097"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 12:33:37 -0800
Received: from [10.212.82.230] (kliang2-mobl1.ccr.corp.intel.com [10.212.82.230])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 560D920B5703;
	Wed,  6 Nov 2024 12:33:32 -0800 (PST)
Message-ID: <597dbcf6-8169-4084-881c-8942ed363189@linux.intel.com>
Date: Wed, 6 Nov 2024 15:33:30 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] x86: perf: Refactor misc flag assignments
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Will Deacon <will@kernel.org>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Naveen N Rao <naveen@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org
References: <20241105195603.2317483-1-coltonlewis@google.com>
 <20241105195603.2317483-5-coltonlewis@google.com>
 <65675ed8-e569-47f8-b1eb-40c853751bfb@linux.intel.com>
 <ZyvLOjy8Vfvai5cG@linux.dev>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <ZyvLOjy8Vfvai5cG@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-11-06 3:02 p.m., Oliver Upton wrote:
> On Wed, Nov 06, 2024 at 11:03:10AM -0500, Liang, Kan wrote:
>>> +static unsigned long common_misc_flags(struct pt_regs *regs)
>>> +{
>>> +	if (regs->flags & PERF_EFLAGS_EXACT)
>>> +		return PERF_RECORD_MISC_EXACT_IP;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
>>> +{
>>> +	unsigned long guest_state = perf_guest_state();
>>> +	unsigned long flags = common_misc_flags(regs);
>>> +
>>> +	if (guest_state & PERF_GUEST_USER)
>>> +		flags |= PERF_RECORD_MISC_GUEST_USER;
>>> +	else if (guest_state & PERF_GUEST_ACTIVE)
>>> +		flags |= PERF_RECORD_MISC_GUEST_KERNEL;
>>> +
>>
>> The logic of setting the GUEST_KERNEL flag is implicitly changed here.
>>
>> For the current code, the GUEST_KERNEL flag is set for !PERF_GUEST_USER,
>> which include both guest_in_kernel and guest_in_NMI.
> 
> Where is the "guest_in_NMI" state coming from? KVM only reports user v.
> kernel mode.

I may understand the kvm_arch_pmi_in_guest() wrong.
However, the kvm_guest_state() at least return 3 states.
0
PERF_GUEST_ACTIVE
PERF_GUEST_ACTIVE | PERF_GUEST_USER

The existing code indeed assumes two modes. If it's not user mode, it
must be kernel mode.
However, the proposed code behave differently, or at least implies there
are more modes.
If it's not user mode and sets PERF_GUEST_ACTIVE, it's kernel mode.

Thanks,
Kan




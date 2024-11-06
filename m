Return-Path: <kvm+bounces-31036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C2459BF815
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 21:38:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E26E71F23BFF
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 20:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B7220C473;
	Wed,  6 Nov 2024 20:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eIc2QBo5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D377A1D358C;
	Wed,  6 Nov 2024 20:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730925513; cv=none; b=I9aZt5JSntXK+W8MP8lx7ne4FZ8AvJusClqueA4NWeLdiqAttI85Kyl61INbc+06gTOKmk+bWEryzmp33W9fEdTSv66rXgoP4CGFVrW1Dlo16B7Up8orTHV8kjX+FUYKcYmPpkSLRJdropafA+JVyaoSsT2RaUDp+FESsixx1L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730925513; c=relaxed/simple;
	bh=t1T0JqltTt1br9rO+URcAmslVziWyZeSdcV2iKnx4V4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h5J06iVFkiZkICIf8ap1aEmyTtbz6dB/V9Mlj9rXFqsZP/3X0Qa/kg2N65GEhY5U7uHyihUT2/MBSgwdazZ8Z6rCrQ1A2X6lBnsB57+L5S5m/hWoahtV46V8yTowX/+gpLQl3Gv8AWpII+zQdSHxVVOv381d5cmMMB380J/HFYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eIc2QBo5; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730925512; x=1762461512;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t1T0JqltTt1br9rO+URcAmslVziWyZeSdcV2iKnx4V4=;
  b=eIc2QBo5LHAv7yeQxN0NNsNzg8CR9ZPijh1MCmsvm8Sh2iFs/RpnAU4J
   kVEkfLkJ4N3SKelTgWsP7OaUhvuXLbeBYCuzMC1Ao/JcamHlcpQRAJR0h
   ye0OQM8eC63r36JAzSMDKTaqT88OyZHCBFF63qwa4TxHTjFQks5NSTCIF
   aj4FUqiSHEl+c7yQH+sOi75F7PmrFPsp6R3V2y6dNe1X6aDi3ig1YS8+Q
   qP4xl6tP6rW/VBRaXo3kZd7VAMTKaNOaiihCSmTXGofpRsMy80N2j6a0e
   PXqGGK4m6rZRRxIemnBJ8C/X29cgoQItVg7iCGtg2JQUF/k8xfX5d2aWc
   g==;
X-CSE-ConnectionGUID: wuV0iq3STWqNvMWBuOq0kw==
X-CSE-MsgGUID: /Tn2Z6r7QTqgvL/FuE64cQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="41340839"
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="41340839"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 12:38:31 -0800
X-CSE-ConnectionGUID: d6sAQXYbTuCw0s8JjLqdMw==
X-CSE-MsgGUID: 0q6Tkfi4S2Wgas+639rTLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="108044520"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 12:38:30 -0800
Received: from [10.212.82.230] (kliang2-mobl1.ccr.corp.intel.com [10.212.82.230])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 2880520B5703;
	Wed,  6 Nov 2024 12:38:26 -0800 (PST)
Message-ID: <89b46b99-e9fc-4ce4-84b2-b24f565db8d5@linux.intel.com>
Date: Wed, 6 Nov 2024 15:38:25 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/5] perf: Correct perf sampling with guest VMs
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
 <20241105195603.2317483-6-coltonlewis@google.com>
 <007cfed1-111d-45aa-b873-24cca9d4af01@linux.intel.com>
 <ZyvJIx-UHXawnUYs@linux.dev>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <ZyvJIx-UHXawnUYs@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-11-06 2:53 p.m., Oliver Upton wrote:
> On Wed, Nov 06, 2024 at 11:07:53AM -0500, Liang, Kan wrote:
>>> +#ifndef perf_arch_guest_misc_flags
>>> +static inline unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
>>> +{
>>> +	unsigned long guest_state = perf_guest_state();
>>> +
>>> +	if (guest_state & PERF_GUEST_USER)
>>> +		return PERF_RECORD_MISC_GUEST_USER;
>>> +
>>> +	if (guest_state & PERF_GUEST_ACTIVE)
>>> +		return PERF_RECORD_MISC_GUEST_KERNEL;
>>
>> Is there by any chance to add a PERF_GUEST_KERNEL flag in KVM?
> 
> Why do we need another flag? As it stands today, the vCPU is either in
> user mode or kernel mode.
> 
>> The PERF_GUEST_ACTIVE flag check looks really confusing.
> 
> Perhaps instead:
> 
> static inline unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
> {
> 	unsigned long guest_state = perf_guest_state();
> 
> 	if (!(guest_state & PERF_GUEST_ACTIVE))
> 		return 0;
> 
> 	return (guest_state & PERF_GUEST_USER) ? PERF_RECORD_MISC_GUEST_USER :
> 						 PERF_RECORD_MISC_GUEST_KERNEL;
> }

Yes, this one is much clear.

Can a similar change be done for the x86 perf_arch_guest_misc_flags() in
the previous patch?

Thanks,
Kan



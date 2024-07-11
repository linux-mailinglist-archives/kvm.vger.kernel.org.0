Return-Path: <kvm+bounces-21439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EA0F92F08B
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 22:58:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2C721C22825
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 20:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A13A19EEC4;
	Thu, 11 Jul 2024 20:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IcKgSAiS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7140882D68;
	Thu, 11 Jul 2024 20:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720731516; cv=none; b=eyknlNwMMcYIr6rA2h1VJq+P0SmDtxDrG9g4O/wbJfl97B9EeKnT2ZCNSbyN8LB0ltTp1Th+X+ZAlbI2WG7E8WG4ijz8uXGTSucv09rcicL4WmNwzwZOdgLS7KLvuIOSRp/3aAiQSngvz/U/w2RtXTCs8ihDd504Y4qMxseRK38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720731516; c=relaxed/simple;
	bh=8U+AfVIFeyA7CmGX4UGBlcY7fyqzeuSiPVavOFWJQok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FKnfHKUxFZzSTmbWhwJAUaNr1W4Mfb+dTtQLyahTHu/TDg7ddpKij3ZpSSbpzRGWWmlBpNGH0NYeUWG16ebseL6Zts4qShoPkrLD9nJCU4D7zWgu288kTFNNHGUIo4N0Fd8DfiUNp/x7S+la5udMSwwVHCej5gwMZrW1zYwx+Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IcKgSAiS; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720731515; x=1752267515;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8U+AfVIFeyA7CmGX4UGBlcY7fyqzeuSiPVavOFWJQok=;
  b=IcKgSAiSOb79Bn9AuuBlTcxeGEbuOmBekxo0zSfTp54gSlp2OMssNoYe
   COZ9HKba/oadoKvL0q2AQQICPkHvxH+lZYWOTr1m2AeYwSXsPrG7bVC2Q
   vpFC07qXhKL3a2eCV/PJh43tgMzsAOL3bnCT/3Qt3kUO24vmgLvek1uSN
   tH1ezG8Je4QZDh4os0V6oVV1+SjCpjA3Z1Q3f/OiN+dNLTz7rNXVGVLoZ
   Hd1AijnjKyYf9EIxKJqkx/bsNsVRS4QeB0RcVDamOTY+yNOMjnIcQypuL
   T393q94ifOPfMbTNkL2toFget59UkkslkyQNdXnO2lILoRFqZ4D0+PcZ8
   A==;
X-CSE-ConnectionGUID: KjSrvFYaTsKvqHeFxK4drw==
X-CSE-MsgGUID: cLk4mYO9ROC/MbtGN9ZTWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11130"; a="17856040"
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="17856040"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2024 13:58:34 -0700
X-CSE-ConnectionGUID: otJWUUxcTO6T7RZeNMngxA==
X-CSE-MsgGUID: gvmJQ3vbTYCNWgp69xYBow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="48665160"
Received: from unknown (HELO [10.124.221.144]) ([10.124.221.144])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2024 13:58:32 -0700
Message-ID: <1c2fd06e-2e97-4724-80ab-8695aa4334e7@intel.com>
Date: Thu, 11 Jul 2024 13:58:30 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Introduce CET supervisor state support
To: "Yang, Weijiang" <weijiang.yang@intel.com>, tglx@linutronix.de,
 x86@kernel.org, seanjc@google.com, pbonzini@redhat.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com,
 mlevitsk@redhat.com, john.allen@amd.com
References: <20240531090331.13713-1-weijiang.yang@intel.com>
 <67c5a358-0e40-4b2f-b679-33dd0dfe73fb@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <67c5a358-0e40-4b2f-b679-33dd0dfe73fb@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/8/24 20:17, Yang, Weijiang wrote:
> So I'm not sure whether XFEATURE_MASK_KERNEL_DYNAMIC and related changes
> are worth or not for this series.
> 
> Could you share your thoughts?

First of all, I really do appreciate when folks make the effort to _try_
to draw their own conclusions before asking the maintainers to share
theirs.  Next time, OK? ;)

But here goes.  So we've basically got three cases.  Here's a fancy table:

> https://docs.google.com/spreadsheets/d/e/2PACX-1vROHIgrtHzUJmdlzT7D7tuVzgM8AMlK2XlorvFIJvk-I0NjD7A-T_qntjz7cUJlCScfWGtSfPK30Xtu/pubhtml

... and the same in ASCII

Case |IA32_XSS[12] | Space | RFBM[12] | Drop%	
-----+-------------+-------+----------+------
  1  |	   0	   | None  |	0     |  0.0%
  2  |	   1	   | None  |	0     |  0.2%
  3  |	   1	   | 24B?  |	1     |  0.2%

Case 1 is the baseline of course.  Case 2 avoids allocating space for
CET and also leans on the kernel to set RFBM[12]==0 and tell the
hardware not to write CET-S state.  Case 3 wastes the CET-S space in
each task and also leans on the hardware init optimization to avoid
writing out CET-S space on each XSAVES.

#1 is: 0 lines of code.
#2 is: 5 files changed, 90 insertions(+), 27 deletions(-)
#3 is: very few lines of code, nearing zero

#2 and #3 have the same performance.

So we're down to choosing between

 * $BYTES space in 'struct fpu' (on hardware supporting CET-S)

or

 * ~100 loc

$BYTES is 24, right?  Did I get anything wrong?

So, here's my stake in the ground: I think the 100 lines of code is
probably worth it.  But I also hate complicating the FPU code, so I'm
also somewhat drawn to just eating the 24 bytes and moving on.

But I'm still in the "case 2" camp.

Anybody disagree?



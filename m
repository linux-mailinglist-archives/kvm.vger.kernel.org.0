Return-Path: <kvm+bounces-42117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E105BA7322B
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 13:20:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7F9E3B6D3B
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 12:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EBD32139DC;
	Thu, 27 Mar 2025 12:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="vRSDSvgI";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="A95P0UUj"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A33D4A21;
	Thu, 27 Mar 2025 12:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743078036; cv=none; b=t9jiMg2kSFbuuJGnzSxQrg6IfVzW4P3KpCpYEe9ECxwChqnFT3nENyyOLZLUNrjcllc8zvWyv3eJUG/6iwi4KOW0rfHjfSytE7BCjbYXqpss5NNyj2FwgmMD8WZTd/Hmhcq3OG8ogJ5k+dtzS8ir/A1Sz8zS7Fgd2ThcT4sc0Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743078036; c=relaxed/simple;
	bh=+HCXqo9koMpPOoWwQN0dvLYuZy8a9fzvZSercyftZ74=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cMjfwLVgCJDXM8FrkkL5rnDONdWB/KjiqOilx3P3LLsE3l3iWwkDsGfhd13k9yc0XaE6P/Basex7CJG5ZmJjV4GhdH8SvyU5oqXLp0sEG+k1WqrbT+ZLqBhwJmqwvLi8SCk2Mg3KwSWKv8dBukTAH2vdHEleq8EKA9+M77EEz1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=vRSDSvgI; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=A95P0UUj; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1743078033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/DnPMCAwcf4dY2kEpsg8wWOa7bzjbM9t/8vsK+DMZl8=;
	b=vRSDSvgI4ANb2/q+uzofd22WJFKO9e00cLV4Ob8OBUP91rRg3+vkwKohA5agf6XqyO8tgv
	hSTFca7A8Fs9d4JdE6m39zLb1G+k4IbQqqJAXUgBXi9r0xoZvl01fYb8sTUMS6EOFy38QX
	tT3G/AwoEQqt4CKLuDjrtU4Snm69Cpmflr3tISELMIt8et6FGbv4ImvjAJ9syy67nDa5Li
	wqwAB/jlrqxlMHeVLeSmNWxSjMHWchVwBPgyT2tPq1/28bc2Xpo134t2CevJHLnckd8aTu
	XLvpH5djzIs8wdhfg3RkBOgy1QdGj8S64Cxgxhlv0f90MA9IQ3AShqfi4YGuLA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1743078033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/DnPMCAwcf4dY2kEpsg8wWOa7bzjbM9t/8vsK+DMZl8=;
	b=A95P0UUjZUln/sEl733bbjTvqR6KGNz9bVzngqCkn6fwu64JDfGroDU9MRfEzT4F2z+Qro
	LPAq0e8H7PfsRLCw==
To: Sean Christopherson <seanjc@google.com>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com,
 kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
 naveen.rao@amd.com
Subject: Re: [RFC v2 13/17] x86/apic: Handle EOI writes for SAVIC guests
In-Reply-To: <87y0wqycj8.ffs@tglx>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-14-Neeraj.Upadhyay@amd.com> <87cyea2xxi.ffs@tglx>
 <Z92dqEhfj1GG6Fxb@google.com> <87y0wqycj8.ffs@tglx>
Date: Thu, 27 Mar 2025 13:20:32 +0100
Message-ID: <87msd6y8a7.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Mar 27 2025 at 11:48, Thomas Gleixner wrote:

> On Fri, Mar 21 2025 at 10:11, Sean Christopherson wrote:
>> On Fri, Mar 21, 2025, Thomas Gleixner wrote:
>>> 
>>> Congrats. You managed to re-implement find_last_bit() in the most
>>> incomprehesible way.
>>
>> Heh, having burned myself quite badly by trying to use find_last_bit() to get
>> pending/in-service IRQs in KVM code...
>>
>> Using find_last_bit() doesn't work because the ISR chunks aren't contiguous,
>> they're 4-byte registers at 16-byte strides.
>
> Which is obvious to solve with trivial integer math:
>
>       bit = vector + 32 * (vector / 32);
>
> ergo
>
>      vector = bit - 16 * (bit / 32);
>
> No?

Actually no. As this is for 8 byte alignment. For 16 byte it's 

	bit = vector + 96 * (vector / 32);
ergo
        vector = bit - 24 * (bit / 32);

Which is still just shifts and add/sub.



Return-Path: <kvm+bounces-42116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B914CA73226
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 13:18:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 662501893DA1
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 12:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4CDD2139D7;
	Thu, 27 Mar 2025 12:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="jRs+xWSW";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="RVW6jVQ7"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963904A21;
	Thu, 27 Mar 2025 12:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743077896; cv=none; b=rvtdYQtlsuN2scZOr1amhJa/8MRk5bXvOsj4pP5rwH5KwZkDe76lfGrJsRsOQRysOFxSiD/zvEPLMHcr2qwED0R+jfe6VbL7dqz7767ZJIelbS2a2VRPWTnLR5XHHt4ztNXcQvdLEfhcQGUvCKZ7mdCoC6iCNc4R88yjRu92pvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743077896; c=relaxed/simple;
	bh=WxsHARii8GsTzJR6THPx6O7Iu0sCy1k2EI3clMdAiP4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JStGTPVHIe/xYk+jO0/PDDdqECF4mba/Qi0xn+ZN8Prn9/3p+xSTOLQcsqANwfcx4FepBflUZaywkinAeSr4CvauUX+3cbpBrPa6f6cLvz+t7OTkk0hNZxX8Gj6VRKA2pVzopAMNfqOEJAlgt4jOVglS5eQyB7ffobQGk2hNZnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=jRs+xWSW; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=RVW6jVQ7; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1743077892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Optn4nNhsBaPLrHiIfTj2SmYr1qloQJEkP0OeJQKIk=;
	b=jRs+xWSWtpk0P919/uUG2/yLg6LgMl6BCRdbXbDiWEApA1jm9MchwC00hfcw76nDeeWVxF
	wHzGkb1OfIXvVTPjykBsqoKXU7nOa55X/GnUWxf12M1iixxCyqSKDmdLHjdRinNnG3kSVU
	RQc64WFtb92XM+teYKiFD5m7hsmbBxvTnT0xy+c5zSnrk1O+rgpTkS0MBUItq8qvFDr6GT
	AncKOMNqEbvC8UpPggwpQM6FtDr2mGF/3lRWqFFaNPzZA/pG1aP8thBt3UbHH7eSrIgJej
	/fEntHPgcWpBUljNOR9z1u5FXfTv5R00R3kxnxehxLRPwUDwWy+rKdIMSYjRQQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1743077892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Optn4nNhsBaPLrHiIfTj2SmYr1qloQJEkP0OeJQKIk=;
	b=RVW6jVQ77nNCs+V1idJXIVmmCbpmlCLYRh6VkZAL3dnUPGWMGJQfLml9D4WJ7Xcw4/ZabR
	0TDLMUVXMqw+YLAw==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
Subject: Re: [RFC v2 05/17] x86/apic: Add update_vector callback for Secure
 AVIC
In-Reply-To: <fb4fb08d-1ea5-4888-8cfa-9e605e6dac34@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-6-Neeraj.Upadhyay@amd.com> <87jz8i31dv.ffs@tglx>
 <ecc20053-42ae-43ba-b1b3-748abe9d5b3b@amd.com>
 <e86f71ec-94f7-46be-87fe-79ca26fa91d7@amd.com> <871puizs2p.ffs@tglx>
 <fb4fb08d-1ea5-4888-8cfa-9e605e6dac34@amd.com>
Date: Thu, 27 Mar 2025 13:18:12 +0100
Message-ID: <87pli2y8e3.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Mar 27 2025 at 16:47, Neeraj Upadhyay wrote:
> On 3/27/2025 3:57 PM, Thomas Gleixner wrote:
>> The relevant registers are starting at regs[SAVIC_ALLOWED_IRR]. Due to
>> the 16-byte alignment the vector number obviously cannot be used for
>> linear bitmap addressing.
>> 
>> But the resulting bit number can be trivially calculated with:
>> 
>>    bit = vector + 32 * (vector / 32);
>> 
>
> Somehow, this math is not working for me. I will think more on how this
> works. From what I understand, bit number is:
>
> bit = vector % 32 +  (vector / 32) * 16 * 8
>
> So, for example, vector number 32, bit number need to be 128.
> With you formula, it comes as 64.

Duh. I did the math for 8 byte alignment. But for 16 byte it's obviously
exactly the same formula just with a different multiplicator:

	bit = vector +  96 * (vector / 32);

No?



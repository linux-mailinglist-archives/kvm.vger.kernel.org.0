Return-Path: <kvm+bounces-31316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E003E9C2546
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 20:01:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A428B2843EF
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 19:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4516A19C572;
	Fri,  8 Nov 2024 19:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GOrqArq6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC9E1AA1DC
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 19:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731092481; cv=none; b=rB333bVxmA7ZAgTPdgibj/cYKt8+XIvGg5HNQ5v/Sz9Ix/cCvsCUXrDVminpZy+NidCtHnF8PNCTSHBCyAfdtwDHLqXvzXkfMtUgIBDcv8xA7WbrqcZQQlFYBToDAff1a5gy76yeB1IolJD3jkm7hIIR06kfXejYpvnzHDIBjIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731092481; c=relaxed/simple;
	bh=osKkh8o/4ZEkyOIZVRVY+2aEgfDt/7qhPpuXstOv05g=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=EsscmSVARTbhr3mJY/mGZ6U8it7M/e9Q0gQeznsG+JUG+qUzztYCEXMUqjHQ9nZ5aE2IxJTYvCmIo56bPe3BU2cqsUHD7BUN2Etbu+U25fenaBZmiwzZ8n5eIeOHdzZY0FAU/6z7aMfQSOAYvlo51NJKCVQurohfeVdlWJnGyb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GOrqArq6; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea6aa3b68bso46485417b3.3
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 11:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731092477; x=1731697277; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=X/YH5u+uVD0X+IYthPhg6GmXA/jaE5JARCEDgbJjUV8=;
        b=GOrqArq6EMibI9fiJTyKYP0obQ4Opu9eIIK24AF6Ue/JgY3v0lLVD+hhK/UWiTT3sg
         tKqVQtNhIzPc0jPJjhwvtx//O35a7pEl9bPhBrlonNe+oYqkpohSszIACVeplMepVpEr
         ZXbCKlbuHsr5t2D5eLG8/LvYOM70b5J1wwyWR4MfPa3KEW/Nub/+BN4aIphVYi5kgu+s
         RyTXyX/pQ8a9wxcqTG0Q18uS0aNittHu0MUBQsTKoUwIfWVBFU4pSYPUEl3pp3MXbsoP
         Rr1vTwKNKDs3kh7r6oeVkQFfhGZJTjxKj88CQUod9EOq/1IMPtnp2oPqiP1scpHdIMl3
         YLew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731092477; x=1731697277;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X/YH5u+uVD0X+IYthPhg6GmXA/jaE5JARCEDgbJjUV8=;
        b=HujWnAGZs663saZIaDOueKonAVGAqliM88QvRC9/W+1pG8WYka0PrTmCw3jINP6LYD
         1vgRecCg+3hXJHhMP8IbJAN4A9aVm/L5OpkuS98VkA0GKk8afB+aEMEeYzQ0caWT4S9X
         zVnrkpMm04t3bOPKwoY16grT4v1r4oCF0+mc8+xHph1MmLlAvF0O4u5EFkrDI8Ys2FXB
         IucmmyEgVq34a//ng8mkgxzOLPmChXkfupnHdsJAsZDz/xh2bl2PzbcasO2vYvl+ldxb
         KcRvGtaAEAh+IhzdZBuMDhKugIT9+PtqnIKYG1/quk4dB6nmTtTrEYGKW3ZC1ZnhA8NN
         YfIg==
X-Gm-Message-State: AOJu0YzJO/3bkE98gl28VuArkAFvOR8aBMiamPtCGnfBcLwPzGoVJDp+
	2a9fUuie4iEIrHm3JBabTjYPDrU7u3o0okoBZAD9juTMEPsXbdAXpttIJQxxKCdid2h4QTQz5b3
	1MjokX8XFpIjv3WUGAt13dQ==
X-Google-Smtp-Source: AGHT+IHf5E46yE8Goi3JQ3NCwqhgizTTCCoxt5IIbUtqVWxYQ8qv+MmQFEFlUtd8c2orQuarK4c0d4RFcTxIc3XLxg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:25c3:b0:6e3:d670:f62a with
 SMTP id 00721157ae682-6eadde333e0mr258367b3.3.1731092477590; Fri, 08 Nov 2024
 11:01:17 -0800 (PST)
Date: Fri, 08 Nov 2024 19:01:16 +0000
In-Reply-To: <20241108153411.GF38786@noisy.programming.kicks-ass.net> (message
 from Peter Zijlstra on Fri, 8 Nov 2024 16:34:11 +0100)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntbjypft37.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v7 4/5] x86: perf: Refactor misc flag assignments
From: Colton Lewis <coltonlewis@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, oliver.upton@linux.dev, seanjc@google.com, 
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, 
	adrian.hunter@intel.com, kan.liang@linux.intel.com, will@kernel.org, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, christophe.leroy@csgroup.eu, naveen@kernel.org, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, tglx@linutronix.de, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Peter Zijlstra <peterz@infradead.org> writes:

> On Thu, Nov 07, 2024 at 07:03:35PM +0000, Colton Lewis wrote:
>> Break the assignment logic for misc flags into their own respective
>> functions to reduce the complexity of the nested logic.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
>> ---
>>   arch/x86/events/core.c            | 32 +++++++++++++++++++++++--------
>>   arch/x86/include/asm/perf_event.h |  2 ++
>>   2 files changed, 26 insertions(+), 8 deletions(-)

>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>> index d19e939f3998..9fdc5fa22c66 100644
>> --- a/arch/x86/events/core.c
>> +++ b/arch/x86/events/core.c
>> @@ -3011,16 +3011,35 @@ unsigned long  
>> perf_arch_instruction_pointer(struct pt_regs *regs)
>>   	return regs->ip + code_segment_base(regs);
>>   }

>> +static unsigned long common_misc_flags(struct pt_regs *regs)
>> +{
>> +	if (regs->flags & PERF_EFLAGS_EXACT)
>> +		return PERF_RECORD_MISC_EXACT_IP;
>> +
>> +	return 0;
>> +}
>> +
>> +unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
>> +{
>> +	unsigned long guest_state = perf_guest_state();
>> +	unsigned long flags = common_misc_flags(regs);

> This is double common_misc and makes no sense

I'm confused what you mean. Are you referring to starting with
common_misc_flags in both perf_arch_misc_flags and
perf_arch_guest_misc_flags so possibly the common_msic_flags are set
twice?

That seems like a good thing that common flags are set wherever they
apply. You can't guarantee where perf_arch_guest_misc_flags may be
called in the future.
>> +
>> +	if (!(guest_state & PERF_GUEST_ACTIVE))
>> +		return flags;
>> +
>> +	if (guest_state & PERF_GUEST_USER)
>> +		return flags & PERF_RECORD_MISC_GUEST_USER;
>> +	else
>> +		return flags & PERF_RECORD_MISC_GUEST_KERNEL;

> And this is just broken garbage, right?

>> +}

> Did you mean to write:

> unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
> {
> 	unsigned long guest_state = perf_guest_state();
> 	unsigned long flags = 0;

> 	if (guest_state & PERF_GUEST_ACTIVE) {
> 		if (guest_state & PERF_GUEST_USER)
> 			flags |= PERF_RECORD_MISC_GUEST_USER;
> 		else
> 			flags |= PERF_RECORD_MISC_GUEST_KERNEL;
> 	}

> 	return flags;
> }

Ok, my mistake was using & instead of |, but the branches are
functionally the same.

I'll use something closer to your suggestion.

>>   unsigned long perf_arch_misc_flags(struct pt_regs *regs)
>>   {
>>   	unsigned int guest_state = perf_guest_state();
>> -	int misc = 0;
>> +	unsigned long misc = common_misc_flags(regs);

> Because here you do the common thing..


>>   	if (guest_state) {
>> -		if (guest_state & PERF_GUEST_USER)
>> -			misc |= PERF_RECORD_MISC_GUEST_USER;
>> -		else
>> -			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
>> +		misc |= perf_arch_guest_misc_flags(regs);

> And here you mix in the guest things.

>>   	} else {
>>   		if (user_mode(regs))
>>   			misc |= PERF_RECORD_MISC_USER;


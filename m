Return-Path: <kvm+bounces-42128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3F90A73769
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 17:55:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B49F33BE269
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 16:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE5D218E9F;
	Thu, 27 Mar 2025 16:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="MRKVto5V";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="rfEmn8mN"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6052B20F08F;
	Thu, 27 Mar 2025 16:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743094469; cv=none; b=Ioh6e7MznZV0adwJqitTV0HAkQNUfwRGSmGYPdr8d7Rwpdde7DFLYZ8c0hB541tJ5sP6CA45XgvkSiriKHwDtR25WkDO87q6TL3LC1jFoOeISAamAloHPLaQ2BNdroBGZeSwTOf3Pbm7JyaCd2/FOdNSVBDGBMGjuCqv7qwRTyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743094469; c=relaxed/simple;
	bh=yFrOb8eMPn1WoypdICkaT+V9GJUCJhdw8B40GhbjSTE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tGkd/sfbMkH6Lwx2gVEf2RPWkXdfbwOwhKt/KTELyt8wdg6sOagqDUAEIMA6dAvSW/OQm4Knlbne+F2qxfmGK8Y2mvCYjWJ2gZInM0gSiL5bqNFjHcSn5AnMlH8bpzMVljtGefpozZ6qDlgFl37ZrJ88ZEGaa4ACc2Lsd8cyT/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=MRKVto5V; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=rfEmn8mN; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1743094463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mvmmSMDji6eqm6wByVqHVd/iVMKatGBNcOhBfpert1g=;
	b=MRKVto5VQo5AIi/17gmUKCtC3jbN7HrvI6COwvWafXYEjvXLjnUOgAtGv/8E7E87OcTkNP
	EoaJ0u+5QmBMNrQmYLMcd7+rJ38WOTeesaTCw/MzJ0kqBamrotxjXoLtIq4Nwq5i/Fjizq
	m4pSyRFU5Qfgex/tTOfou88EQCNwmyRJywKWVk32+rrAOEqp4X7JtpSRf4y6ekJ6EzRTTQ
	DgEeUTrLKey+TV8KAxgB4nP9viYM4sW7cTp9HtT1tgHhzouVCzsEIijUj6ZyvVRgFaKqV6
	KWNHZzJu98tfMf5XiihBDZ3qOyFowC0hb2fBm4c2t1MiZu2FqQSUSly/96s26Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1743094463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mvmmSMDji6eqm6wByVqHVd/iVMKatGBNcOhBfpert1g=;
	b=rfEmn8mNg0sKXnQflIayaQoPREuiePkR6rDb7OPgque/DmG9VsqrSGOvPilp/6yAEdPdKk
	z2CqHZ6bBe0diTAw==
To: Sean Christopherson <seanjc@google.com>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com,
 kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
 naveen.rao@amd.com
Subject: Re: [RFC v2 13/17] x86/apic: Handle EOI writes for SAVIC guests
In-Reply-To: <Z-VeW0IuqMI8dYlH@google.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-14-Neeraj.Upadhyay@amd.com> <87cyea2xxi.ffs@tglx>
 <Z92dqEhfj1GG6Fxb@google.com> <87y0wqycj8.ffs@tglx> <87msd6y8a7.ffs@tglx>
 <Z-VeW0IuqMI8dYlH@google.com>
Date: Thu, 27 Mar 2025 17:54:22 +0100
Message-ID: <87h63exvlt.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Mar 27 2025 at 07:19, Sean Christopherson wrote:
> On Thu, Mar 27, 2025, Thomas Gleixner wrote:
>> Actually no. As this is for 8 byte alignment. For 16 byte it's 
>> 
>> 	bit = vector + 96 * (vector / 32);
>> ergo
>>         vector = bit - 24 * (bit / 32);
>> 
>> Which is still just shifts and add/sub.
>
> IIUC, the suggestion is to use find_last_bit() to walk the entire 128-byte range
> covered by ISR registers, under the assumption that the holes are guaranteed to
> be zero.  I suppose that works for Secure AVIC, but I don't want to do that for
> KVM since KVM can't guarantee the holes are zero (userspace can stuff APIC state).

Fair enough. So yes, then making the current KVM function generic is the
right thing to do.

Thanks,

        tglx


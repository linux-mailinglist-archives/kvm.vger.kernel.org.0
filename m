Return-Path: <kvm+bounces-8915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C13985887B
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 23:29:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B26928A955
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 22:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C0D914830F;
	Fri, 16 Feb 2024 22:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="uBrqIOK5";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ApP0/N8I"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103511482FE;
	Fri, 16 Feb 2024 22:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708122550; cv=none; b=UQY0WWgBx18qTdnersGzOEibNUALdhKTrLKvz7gKIT4QUBdR3CYvt5RomKDL7w2z+/S6QZ67m7Fd+i4w+ihBzK90xi2Oq6QR12Udj8LatAXkCKcfEhsHp4j6rlxnpUpClvQPNmW8EBWmrlhSLbpsoHBCg+ZcJFGQJxZTGX3sbu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708122550; c=relaxed/simple;
	bh=Ahi79WbHwBHpuJcwYLh25x58Hq7/EYr7w+p8D+NrmOY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BBDlyTxuIQGaCmIkFDg3hmzxs1EeaASnmVTHnQrASML5SeUsXqb+3eaWSH9ia2fYRLXpsDIo2HpBgpD9mvi/OT01dCQcZznQzJkMSctku4otDWMXWx/Ew+Ial34DKfOHV5JaIY00nNJIiXGPU84/iI70CLGPc+74bI2zNvGkZ5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=uBrqIOK5; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ApP0/N8I; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1708122547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=niM6EJ1nlCzrpHZbXv4LQhRZqOh9ZTSscNJIL6EEJIA=;
	b=uBrqIOK54zCGcRIedje9EebshN9rcRmtKXFo75nPWo4y46MasBdLUmYZGsbHkG74FxIXm6
	mQmt6tXBMDeTGBKDVqxM9m9+sd7B+XCg3Zka5QVUhwBM7gas9cr6aXe1dtvNhQTpf91cuN
	Qdzb5gBazgHLKJkkn0wuX29apLQCsSypppzcWCxkx8OF6Zd1t1yBriIFDk5Bzca1+R/3tS
	eUEtDEOe/ZkZGF/yuk9cz5vHIslVIhfX0jQf5PxZft7X6UrpJodoOdAB06MV/MORwIYDzi
	ZvNNDNt0iZO3/FJoJX0V2qu86v8QYEwDvrFRICHb5kd7J1+jJExfcjiGvyrgEA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1708122547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=niM6EJ1nlCzrpHZbXv4LQhRZqOh9ZTSscNJIL6EEJIA=;
	b=ApP0/N8IAsEE8TuAB2/lNLgg6+Hs+VDT7eF7O4wgtLUx5pkWeX1Afaak/B1XJ6wl62aJQs
	S0FZAA057qwDucCA==
To: Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Xin Li <xin@zytor.com>, Sean Christopherson <seanjc@google.com>, Max
 Kellermann <max.kellermann@ionos.com>, hpa@zytor.com, x86@kernel.org,
 linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
 kvm@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH] arch/x86/entry_fred: don't set up KVM IRQs if KVM is
 disabled
In-Reply-To: <20240216214617.GBZc_XqVtMuY9_eWWG@fat_crate.local>
References: <20240215133631.136538-1-max.kellermann@ionos.com>
 <Zc5sMmT20kQmjYiq@google.com>
 <a61b113c-613c-41df-80a5-b061889edfdf@zytor.com>
 <5a332064-0a26-4bb9-8a3e-c99604d2d919@redhat.com>
 <20240216214617.GBZc_XqVtMuY9_eWWG@fat_crate.local>
Date: Fri, 16 Feb 2024 23:29:06 +0100
Message-ID: <87le7kavrh.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Feb 16 2024 at 22:46, Borislav Petkov wrote:
> On Fri, Feb 16, 2024 at 07:31:46AM +0100, Paolo Bonzini wrote:
>> and it seems to be a net improvement to me.  The #ifs match in
>> the .h and .c files, and there are no unnecessary initializers
>> in the sysvec_table.
>
> Ok, I'll pick up Max' patch tomorrow and we must remember to tell Linus
> during the merge window about this.

No. Don't.

This pointless #ifdeffery in the vector header needs to vanish from the
KVM tree.

Why would you take the #ifdef mess into tasteful code just because
someone decided that #ifdeffing out constants in a header which is
maintained by other people is a brilliant idea?

The #ifdeffery in the idtentry header is unavoidable and the extra NULL
defines are at the right place and not making the actual code
unreadable.

Thanks,

        tglx






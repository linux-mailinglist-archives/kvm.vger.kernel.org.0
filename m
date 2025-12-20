Return-Path: <kvm+bounces-66439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 377C8CD31AE
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 16:23:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E00CE30198D7
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 15:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 728562D47EA;
	Sat, 20 Dec 2025 15:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="xCiwepZO";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="15DBvIf8"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5867347DD;
	Sat, 20 Dec 2025 15:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766244146; cv=none; b=bX7o5DMImzHqV2xbt2PfO5GAmoBLQwCOKEm8vsv/3HzvruqThECFejhP2xMokV4x6Ap8o1+dmy9KAo6s6m4UjxLZhz/fCL2UJ1qp84aIcKkBWsoVfsYsOcRJCyVfKGYLl6SiKOcA4JgGKs6IfO5ibKwtssdSer9CDOynT7u2h9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766244146; c=relaxed/simple;
	bh=8C6evlCA9r9rgFrPyGCB/XCnkmDUiDA4XErnnyUe0S0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QRQrvuedQcBRhLcZWsVxdk2E8baDwIm3H9GKAWrHfN1VunzSW4xdWYT25AXAagZzLMX4Gin07QXoyCRvNsOMSCBNVpC8Pg63FJPhQvdTfsnIEn9MWq1318wx/bQBrgL0rtO3v8o58/8yEDxF6yvyuZmhkxV5/+6Wnc669GoH6qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=xCiwepZO; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=15DBvIf8; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1766244141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iSC5dC1xvaYRCUO3l4CkD8cm4hyN/yZ7o0xpaiSUKsA=;
	b=xCiwepZOHQITosAhQ1dZA/p+5dhqc/nTO71S2xf8k5DTEUbqE2mD9sUdhP2YDgICU+q3nT
	iFpiQhuCTdkU2HJYMaBDJkIojLxSGHJZaoHeyHs4lJdjdrav7EbDRF1zxdevh/9Vs+IVle
	VRUpraFZ/yVYALCPzzzbS9PAOtVng5L0LJEiOAnv02/OnQFbpOCW3Jg8BkKL0B3YGHqxWU
	A6KIAt9ZKyMfoQWz/mpVpohTfPtIBapm5sCjR9y+21Bnqg6XihCwZ9wIHaVz0WHyLl8Ftq
	bmHvnbWK9mlzU7yoCbiyNg1WEfys/QRiLLeLTXocg11Esx7z5L0oJTTax4+2Rg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1766244141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iSC5dC1xvaYRCUO3l4CkD8cm4hyN/yZ7o0xpaiSUKsA=;
	b=15DBvIf8QVMUUilPL9P1A1VhCyMUcV4cZRjGiQCUIOlwegD1TI67a7Qumc7sYsyzWRcyfW
	gfmdWLM2FvoKCWDw==
To: Xu Lu <luxu.kernel@bytedance.com>, anup@brainfault.org,
 atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip/riscv-imsic: Adjust vs irq files num according
 to MMIO resources
In-Reply-To: <CAPYmKFvE3ZnsbTFYHe8T2tkF10G08dnEQ5KEdied_6wGjztv7A@mail.gmail.com>
References: <20251220085550.42647-1-luxu.kernel@bytedance.com>
 <CAPYmKFvE3ZnsbTFYHe8T2tkF10G08dnEQ5KEdied_6wGjztv7A@mail.gmail.com>
Date: Sat, 20 Dec 2025 16:22:19 +0100
Message-ID: <87o6nt9o0k.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Sat, Dec 20 2025 at 17:03, Xu Lu wrote:
>>                 kvm_riscv_aia_nr_hgei = min((ulong)kvm_riscv_aia_nr_hgei,
>> -                                           BIT(gc->guest_index_bits) - 1);
>> +                                           BIT(gc->nr_guest_files) - 1);
>
> Typo here. I will resend this patch.

And please change the subject line to something comprehensible. 'vs irq
files num' says absolutely nothing.

Thanks,

        tglx



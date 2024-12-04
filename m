Return-Path: <kvm+bounces-33032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F15D59E3AFF
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 14:17:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E763166D45
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 663B51C07C1;
	Wed,  4 Dec 2024 13:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="WTf39HWb";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="UtAAFB7I"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3572C1B87E2;
	Wed,  4 Dec 2024 13:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733318214; cv=none; b=B1grxbminUpBBHY8rImEuL+8bpVd0BC4scFx3xQ0Zy5kddGY9swu1fggS/umtg+sbLlFWC2ZLes3QR+IWcvplE077IBsX2m/LHk/6U+Y13CHKN5+yIvHo1ffk6krPVzyhPlvujZCV1mwsqOzudy+12EUBQFBaonvMwDE6LvDLGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733318214; c=relaxed/simple;
	bh=c1OFIdWzHLxtGH4EHRQQjuiUkrmewW70tsRBbBB9sxM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=swuNvihMT41buIYs/P7RG+JiPv+NYnMAhBb1cUQSECNPfrlLzjg/Avrul6IFzQh+EY3ysgDUr7/OGdeqCI/OE0dCXfDtveaTJLMFC+qZreWf0T9G9BFyYrTmEFANsZ4rgA3MsNOgf3uxj9/fkp4fFzPyPKasqUKuD47MRvxxpUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=WTf39HWb; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=UtAAFB7I; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1733318211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c1OFIdWzHLxtGH4EHRQQjuiUkrmewW70tsRBbBB9sxM=;
	b=WTf39HWbPJFRM1Tx1C48bChXNL3E/zGE+PWZSPqiL8F9GXQA81CnxFB61pJW8sN+OfnD7s
	kLlUgYSQKuUXbXs+ssmzIaM8lsVi5DBC1K5F9cgSXCobmiwoQeuCMoMdasVfpkENBOjtWL
	Uk2G9Zq6QKbr6Njgp8K5sb0Q8U/mpzl5NJL/afisTyUp3PsRYjR0o+KKGTk9KQ53m0zgIv
	4xMtQWBM1IMyBZXPN8gSgJdRs2IW1BwStc8chwJiI7lfc8d+EITFkyjv7K5PrnxfbaOE6A
	xFiwH0kdtM7I8ke47c8tMmQgQdJIvlTqKO/nwkSkhFXcEzFY/OEOS/Wl94SA4w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1733318211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c1OFIdWzHLxtGH4EHRQQjuiUkrmewW70tsRBbBB9sxM=;
	b=UtAAFB7IaCZ/Fv2LmIGfarhRvzoLr2BnhwJDKg9Fh5ozlTnnKtCeF0f+3VqaOS09n0Cq6z
	h9MrkZUW2Qz60HBQ==
To: Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org,
 x86@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Linus Torvalds
 <torvalds@linux-foundation.org>, Andy Shevchenko <andy@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Sean Christopherson
 <seanjc@google.com>, Davide Ciminaghi <ciminaghi@gnudd.com>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 03/11] x86: Kconfig.cpu: split out 64-bit atom
In-Reply-To: <20241204103042.1904639-4-arnd@kernel.org>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-4-arnd@kernel.org>
Date: Wed, 04 Dec 2024 14:16:50 +0100
Message-ID: <87ed2nsi4d.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Dec 04 2024 at 11:30, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> Both 32-bit and 64-bit builds allow optimizing using "-march=atom", but
> this is somewhat suboptimal, as gcc and clang use this option to refer
> to the original in-order "Bonnell" microarchitecture used in the early
> "Diamondville" and "Silverthorne" processors that were mostly 32-bit only.
>
> The later 22nm "Silvermont" architecture saw a significant redesign to
> an out-of-order architecture that is reflected in the -mtune=silvermont
> flag in the compilers, and all of these are 64-bit capable.

In theory. There are quite some crippled variants of silvermont which
are 32-bit only (either fused or at least officially not-supported to
run 64-bit)...



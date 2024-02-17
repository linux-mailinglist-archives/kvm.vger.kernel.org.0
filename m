Return-Path: <kvm+bounces-8918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B8E6858BC6
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:28:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BD4E1C22FDC
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 00:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FE341D524;
	Sat, 17 Feb 2024 00:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="kM47tac2";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ccsuv/5J"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3761BDE2;
	Sat, 17 Feb 2024 00:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708128723; cv=none; b=kWJ0a1w3ZAZBwGZ4orz+VVx/ariyTGBIPZy9X/5CY+0IqnlKf3CmKyVYvvQ3fgCs1jGb2fApyHTMTMCebuwCOQ7XAd0X0KTmPo/JYsfifUbc4kyvdwmHKr2DfPk3qcXt6Kqzgoh/AgThqnAjmxiIUfg15yXbx+nZHyP6RdWQKms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708128723; c=relaxed/simple;
	bh=7TY4SOAXACsFpYBoNNjLUSxormDZl9LeJNgnCLp1+I0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=IoeA4v3kc1zAGP6PuSxXVi/1xmaE2ZALgdoQhSMHvUipAYVA2wik88CpPJRSJF/NkBSHej7bga+DZ7Az78vGKhHaUaHiRp1w8cgjqSMyVsrASulnyUPu4cfA51nKhnHFuphowVT7vurkKzRGdjZy+FcOUK5NWc/l6ZFNNA0Bhdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=kM47tac2; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ccsuv/5J; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1708128719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=65mpTtubsRd6s2h7zWbq5V8suzGVtnfFye4A7aeK54Y=;
	b=kM47tac2iW0fyKCkD6YGnFShxT51FkrUqhQSpn2eC17GCHRbN2OgRk9O/YKU4rrp+wbqFV
	xi4fqp3qdAI0GJc28crILf/PVSbu/pzJ2eavuU9ZTPr/+xjMyADX8GmLa3EouMWFqnPt4E
	PcxzHT+W9SMPKRNnCBy4zWmYO/Wjsz/BFY8NPuGSWEBCVpbuAtlgzhF86pFFAvZMgX43Sf
	i93jhWJ86ckh7lunc7/VK5q/RAqiUQnNM9VixQ6i/dM9nc0D8yvfriYAKnmkkf9o6NzcGA
	PeqkGc7wQ9upm8RLiCenlVBvVWtJK/rsn8B/0Zyg5SitaXyYN6j5QxNfomzLCA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1708128719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=65mpTtubsRd6s2h7zWbq5V8suzGVtnfFye4A7aeK54Y=;
	b=ccsuv/5J2436MlsTHh3uaZ7gPYWWE5Saexy/tQcGu/ZznHmz8NuRyvo1CipKE3d/5X46H0
	GUEY29ybsum0JQBA==
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xin Li <xin@zytor.com>, Sean
 Christopherson <seanjc@google.com>, hpa@zytor.com, x86@kernel.org,
 linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
 kvm@vger.kernel.org
Subject: Re: [PATCH] arch/x86/entry_fred: don't set up KVM IRQs if KVM is
 disabled
In-Reply-To: <CAKPOu+9sbWwZhbexQHwqZ6nMfg6dau7oYEzzgQ5qx+JiEcdmXQ@mail.gmail.com>
References: <20240215133631.136538-1-max.kellermann@ionos.com>
 <Zc5sMmT20kQmjYiq@google.com>
 <a61b113c-613c-41df-80a5-b061889edfdf@zytor.com>
 <5a332064-0a26-4bb9-8a3e-c99604d2d919@redhat.com> <87ttm8axrq.ffs@tglx>
 <CAKPOu+9sbWwZhbexQHwqZ6nMfg6dau7oYEzzgQ5qx+JiEcdmXQ@mail.gmail.com>
Date: Sat, 17 Feb 2024 01:11:58 +0100
Message-ID: <87il2oar01.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 17 2024 at 00:00, Max Kellermann wrote:
> On Fri, Feb 16, 2024 at 10:45=E2=80=AFPM Thomas Gleixner <tglx@linutronix=
.de> wrote:
>> #ifdeffing out the vector numbers is silly to begin with because these
>> vector numbers stay assigned to KVM whether KVM is enabled or not.
>
> There could be one non-silly use of this: if the macros are not
> defined in absence of the feature, any use of it will lead to a
> compiler error, which is good, because it may reveal certain kinds of
> bugs.

I generally agree with this sentiment, but for constants like those in
the case at hand I really draw the line.

> (Though I agree that this isn't worth the code ugliness. I prefer to
> avoid the preprocessor whenever possible. I hate how much the kernel
> uses macros instead of inline functions.)

No argument about that. I'm urging people to use inlines instead of
macros where ever possible, but there are things which can only solved
by macros.

I'm well aware that I wrote some of the more ugly ones myself. Though
the end justifies the means. If the ugly macro from hell which you
verify once safes you from the horrors of copy & pasta error hell then
they are making the code better and there are plenty of options to make
them reasonably (type) safe if done right.

Thanks,

        tglx


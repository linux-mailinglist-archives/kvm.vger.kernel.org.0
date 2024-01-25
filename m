Return-Path: <kvm+bounces-7029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D83583CD3B
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 21:13:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFCFC1C238DE
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 20:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1789F137C5C;
	Thu, 25 Jan 2024 20:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="refS9tKZ";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="/0aUNS7m"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A2C137C4F;
	Thu, 25 Jan 2024 20:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706213597; cv=none; b=SFuzRH+uYkzLaiIqjTcNrgBfW9UfKaROxuVCwphJOD0hHRBTQHkWzd7WlPW6xhZY2OmgWPHYOemRzCtnyDBHG47fJZKvLXlJltrcJ/atC09BzqxNKcRsnLxKG3WMStU2sdbl8IRttgEecc9OjDsQHz8UsAk8tdxHMn+F3GcoRx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706213597; c=relaxed/simple;
	bh=kjBeNGNqVDJc9FrnmImpOQIUdMHiixU4ZSE2URt8uJM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YQsSoNKqr7tAjcT7sgilbI6nZRIC9TU+FSW6El7UIGEQof6hnofXGF7qY8JOsU8PUUOnFcWO76GlwNBI+FcUzPk3ABg19eKisHxpbAIOgAh5HZUFd35wEykrPnu6NgVLXftIgBur9fk1h5f1juESHemy9CZR1Xg/ZV+uIXn0v3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=refS9tKZ; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=/0aUNS7m; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1706213591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PaIo5QJEoCWgfuIV2H0XngC0pt3mav+j7mul9cTp4+o=;
	b=refS9tKZshoR9HF/jitIxpdw4PBP0KN2fSJDL50TBNSSE4nLT1xt/CiU8WD/qIUovzHFTj
	Dc1+uMR0mM/KNlOw2Jvc33Eg2sUO4YQugup7mPrKBJK+oRlVqLAh7gD4b37QPoYmblM+XQ
	DQp3np2HM00y5lR8canjfuWqIcbVb1nBYsJdJgolXNBnHPesw+30bKJr2n+Fcxgg1LSpVZ
	TEHNSqlzaD3Xi0LltGlhaMWvOF/jHp7XMZbJ+eY+Da8jCC8l0vuxi35Ugn0Mu/WQktYAfX
	slvgSGHkC8u7+hGZkQxP3/6w39IISbYUt9i3xk04KUEEfRDoK8x5VWsuqSJnXQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1706213591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PaIo5QJEoCWgfuIV2H0XngC0pt3mav+j7mul9cTp4+o=;
	b=/0aUNS7maUI9XK8hviQ15XXGp7RCYbM88im65y6z+TXz1RgzScO+jbYOBdJsp5cGHutSS2
	MYHbkz2Agp+po5Ag==
To: Simon Horman <horms@kernel.org>, Peter Hilber
 <peter.hilber@opensynergy.com>
Cc: linux-kernel@vger.kernel.org, "D, Lakshmi Sowjanya"
 <lakshmi.sowjanya.d@intel.com>, jstultz@google.com, giometti@enneenne.com,
 corbet@lwn.net, andriy.shevchenko@linux.intel.com, "Dong, Eddie"
 <eddie.dong@intel.com>, "Hall, Christopher S"
 <christopher.s.hall@intel.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Wanpeng Li
 <wanpengli@tencent.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Mark
 Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, Daniel
 Lezcano <daniel.lezcano@linaro.org>, Richard Cochran
 <richardcochran@gmail.com>, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/7] x86/tsc: Add clocksource ID, set
 system_counterval_t.cs_id
In-Reply-To: <20231224162709.GA230301@kernel.org>
References: <20231215220612.173603-1-peter.hilber@opensynergy.com>
 <20231215220612.173603-3-peter.hilber@opensynergy.com>
 <20231224162709.GA230301@kernel.org>
Date: Thu, 25 Jan 2024 21:13:10 +0100
Message-ID: <87le8dgoix.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Sun, Dec 24 2023 at 16:27, Simon Horman wrote:
> On Fri, Dec 15, 2023 at 11:06:07PM +0100, Peter Hilber wrote:
>> @@ -1327,12 +1334,15 @@ EXPORT_SYMBOL(convert_art_to_tsc);
>>   * that this flag is set before conversion to TSC is attempted.
>>   *
>>   * Return:
>> - * struct system_counterval_t - system counter value with the pointer to the
>> + * struct system_counterval_t - system counter value with the ID of the
>>   *	corresponding clocksource
>>   *	@cycles:	System counter value
>>   *	@cs:		Clocksource corresponding to system counter value. Used
>>   *			by timekeeping code to verify comparability of two cycle
>>   *			values.
>> + *	@cs_id:		Clocksource ID corresponding to system counter value.
>> + *			Used by timekeeping code to verify comparability of two
>> + *			cycle values.
>
> None of the documented parameters to convert_art_ns_to_tsc() above
> correspond to the parameters of convert_art_ns_to_tsc() below.

Obviously not because they document the return value. The sole argument
of the function @art_ns is documented correctly.

> The same patch that corrects the kernel doc for convert_art_ns_to_tsc()
> could also correct the kernel doc for tsc_refine_calibration_work()
> by documenting it's work parameter.

That's a separate cleanup. Feel free to send a patch for that.

Thanks,

        tglx


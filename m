Return-Path: <kvm+bounces-17983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 643E58CC7A8
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 22:20:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95EC11C20E62
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 20:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E0FC146A67;
	Wed, 22 May 2024 20:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="v9fId9EF";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="U7cZLAkc"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215413D97F;
	Wed, 22 May 2024 20:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716409223; cv=none; b=diyoiT7rNOOHwp0H3WY7Eo2qOrzS5BkYOU/ntNdU6yxj6cRzeW0hwKpDP2YwQGFDvFhW/5imcaZQsVZbeLPbYye26Rs1at0d3EsfhtgwfbsVxqLukl7gV3MtuKFK05o50ugQ7Q4f1Ykzj1djhzr67rPWS2ftoOwB9AUaBgoYiXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716409223; c=relaxed/simple;
	bh=F2xmOV7bgrVkwiNtggsuXeIJFbpdRdBJcYc6gTTGxjQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JPTdCqLiTzmYtZr3YAWjWg/NynMoysDbaHQ7m/L+y34jCvSQeq9qAXs3xZMuYSz2r9Prp8Szay4KmZG4MaeM/GCY07T+ncrjUdkhcdw2WEdwmqE3q7jXcHDUUUXHP4W9way5JMYkcPLxJO5mxpy3e9lUM0Sol23u/6YWyM2W5AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=v9fId9EF; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=U7cZLAkc; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1716409214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2DMJSM7Oa5HYtwPggEvWY9KVgsO4BWl3ByYqO2+nYDw=;
	b=v9fId9EF1EI9dTrREN1vupIBY53gNyx8SuIfQITUmEel0Y3nRMRx0tdSzMwmE6R2dlA+lP
	GUKuS6JJDuBdbYpQHuacnZQJw5D0CxewJIZnkN3fQhPgm5m4VvQo8rI8gWRN5MCCk9TUMB
	rKKsbrhhV4R3jayzTDvay8iodficuYocWUpLGsXGVqt/IhIKFhWJncACq29TNm80VdnFgL
	sIlv69XeSUZHIsgKM+zHjtera42YlLZJJeaY8uJ0LR0c6R19yhQUkxfDO9ZDXLoknCrUVZ
	JKLmZ+F0RaXos5PAZf9OASy2IgJir97gJLwEsfpqgZrbSM38DFc8Wl12brjOmQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1716409214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2DMJSM7Oa5HYtwPggEvWY9KVgsO4BWl3ByYqO2+nYDw=;
	b=U7cZLAkcwWGoRzBFryEp0fGuiQbnBiKLDhkkMwypWFCIwrbgYx6ELPgOKdkej/zotInkb6
	93jllOkHPR4W76Aw==
To: Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Paolo Bonzini
 <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Marc
 Zyngier <maz@kernel.org>, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: RFC: NTP adjustments interfere with KVM emulation of TSC
 deadline timers
In-Reply-To: <CALMp9eSPXP-9u7Fd+QMmeKzO6+fbTfn3iAHUn83Og+F=SvcQ4A@mail.gmail.com>
References: <20c9c21619aa44363c2c7503db1581cb816a1c0f.camel@redhat.com>
 <CALMp9eSy2r+iUzqHV+V2mbPaPWfn=Y=a1aM+9C65PGtE0=nGqA@mail.gmail.com>
 <481be19e33915804c855a55181c310dd8071b546.camel@redhat.com>
 <CALMp9eQcRF_oS2rc_xF1H3=pfHB7ggts44obZgvh-K03UYJLSQ@mail.gmail.com>
 <7cb1aec718178ee9effe1017dad2ef7ab8b2a714.camel@redhat.com>
 <CALMp9eSPXP-9u7Fd+QMmeKzO6+fbTfn3iAHUn83Og+F=SvcQ4A@mail.gmail.com>
Date: Wed, 22 May 2024 22:20:13 +0200
Message-ID: <87cypdha4i.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, May 16 2024 at 09:53, Jim Mattson wrote:
> On Wed, May 15, 2024 at 2:03=E2=80=AFPM Maxim Levitsky <mlevitsk@redhat.c=
om> wrote:
>> > Today, I believe that we only use the hardware VMX-preemption timer to
>> > deliver the virtual local APIC timer. However, it shouldn't be that
>> > hard to pick the first deadline of {VMX-preemption timer, local APIC
>> > timer} at each emulated VM-entry to L2.
>>
>> I assume that this is possible but it might add some complexity.
>>
>> AFAIK the design choice here was that L1 uses the hardware VMX preemptio=
n timer always,
>> while L2 uses the software preemption timer which is relatively simple.
>>
>> I do agree that this might work and if it does work it might be even wor=
thwhile
>> change on its own.
>>
>> If you agree that this is a good idea, I can prepare a patch series for =
that.
>
> I do think it would be worthwhile to provide the infrastructure for
> multiple clients of the VMX-preemption timer.

That only solves the problem when the guests are on the CPU, but it does
not solve anything when they are off the CPU because they are waiting
for a timer to expire. In that case you are back at square one, no?

> (Better yet would be to provide a CLOCK_MONOTONIC_RAW hrtimer, but
> that's outwith our domain.)

That's a non-trivial exercise. I respond to that in a separate mail.

Thanks,

        tglx


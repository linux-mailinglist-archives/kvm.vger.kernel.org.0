Return-Path: <kvm+bounces-45714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D0A5AAE339
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 16:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A0771889572
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 14:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1554289375;
	Wed,  7 May 2025 14:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GGpJfSiD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6836288CBD
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 14:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746628594; cv=none; b=kllDncbsu1clSJaWlZgL4yW5Cs1l9yP47Bqfr6MgyFlKn1Q1/pIiKZmGiyGmB7S6GmpfWEzjo5YPaXfKCKzX8VCA/+amnmD0fEl3UqEsdu97D6HB6Hx/sLUWV/SzKLW0PUBtVI8A/FTh8YuUGlZukIC26mKKNZ27XmyC+bjJAgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746628594; c=relaxed/simple;
	bh=fVlSFbG3u628EYseVWSf4N6fNlIkvPxjlWaKQ+obPNo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:From:Subject:
	 References:In-Reply-To; b=ctY/zezNTm6PpOgdFiwj+JNGRom0Qkeyl3hcHkmHwOXUw4BGCzlMrpPO+byMghXThEbpEEYUkJLDB4A+bH8ToX3vqDpVDgVKTqYCMeDSzsm/QuJ4J5CFMbF0LI0AXPjBeKWMYiWBVP/WaLN3SHo6/JnsrwX0bSaBJBuOFKQTRnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=GGpJfSiD; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-39c2688e2bbso467853f8f.1
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 07:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1746628591; x=1747233391; darn=vger.kernel.org;
        h=in-reply-to:references:subject:from:to:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ziqHwwsRYBlnOytFFSvfeo7+WCPTNxHeZbIxMBlJdhs=;
        b=GGpJfSiDkF+av8Huk4dE9niZ99bCkYcYkCWrZbetJrdHyzZxjyLSN4DT6E1eJrTjAr
         EYvegDuqJtBtE/L2W+JIfJkA9r3eZPAi9OE4GsB0LdiUJapHnYU0drsD6Fh+/GwXrwJ6
         D+ZaDKxlf9vhbJApMTqwGQ7PeiUEtsBGaPd6DdHB0j8Z5HWPRqbYSQcJN1j2YV3yi/5l
         IXaIlKuL2qAas8IkLSfCuW0cHIH9KCIkD4AR90f0pA8O6p9rjIb9EoNjNVDsA5crd+54
         xgn7M30UZd0wsyQmLIKpb/Tm1VeLA20t0J8KyKrEBst1YeK86p7g4D80bTCn/eOltZkn
         ILEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746628591; x=1747233391;
        h=in-reply-to:references:subject:from:to:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ziqHwwsRYBlnOytFFSvfeo7+WCPTNxHeZbIxMBlJdhs=;
        b=rZJKad+g0I6fFL7Q/wbCFDkU+pkzT0SAj3YOA68oLay4wKfOjpQa3JcBQfdqnv88pV
         0PKWpKow3fRWBx0VKilIxrNBnGrfcU8R1Ou5WebQUsoLO7yebalYdAzbGdz1xIl1oMmP
         IAnEkkMUwCurHLoKnlCeQYtrJVzAVIOhlFELOQ+ObpKgKpWNw83Caftms0gXutVsY3li
         yaDahgzd+ZUCQk/Abpej8dhvSHvshUmZ61irF1npwmfY8+qgajIuF4zELQtsqOEzJqto
         q/kYAgbLN7LPvIrE2lL9a/yx/P/zzYRiaJV1k3Aa6Pbvc0dEUYY+eQX7AQWV9kFbhTuR
         R0+Q==
X-Gm-Message-State: AOJu0YyaPYt1CM4NyeUtSVcPZdQU4i8tUZdmgMiKHR8dhBaHWTVyh5wt
	NZuvjxBjAPruqCG1KOH0N+sb78uV2LcLes8hnw2KQKuZsNBv93qfZDM1v+efe8Q=
X-Gm-Gg: ASbGncuYarV/G5CLvXzLpKpnzbJ3T9Zh8IoFYI7pfls7oYuF8Dss1fpwY//QTTNV8ze
	GXOUutSLSbP3G4o47bmIzmrgqbj6g2mfY8WM8RwA7LoI+e7gUuVHhQa+8vuLYTFTSThOUEC9u56
	GwBTeifx5a3xdtxwSL8BaPxCD29lQHmUAWBuH8pjvGiXebG1U/TnENNJffwm46aOpGwPcR3Njyl
	UobnzpZ9ZGijAdfcKMCxbx7lXnv5/bedXm2Ip0GdMfdiSxgRW9UxrOLlxhOuxj8/36s4eppsf4v
	ESlkJYFcC0cV50JgcotHM7T++WR7ZBcjhnYjwFP3OUbX078c
X-Google-Smtp-Source: AGHT+IEajZZzNeyoeib2XsmQjInc2KEWeUmYjGy4p5Qc/30lHXvX26EPvLDj1a/b0VLqz2Zq6F2iCA==
X-Received: by 2002:a5d:64e2:0:b0:3a0:7e53:b52d with SMTP id ffacd0b85a97d-3a0b4a69bdamr1109869f8f.15.1746628590982;
        Wed, 07 May 2025 07:36:30 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:f39f:9517:bfc5:cd5e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099b0efbfsm17536249f8f.69.2025.05.07.07.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 07:36:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 07 May 2025 16:36:30 +0200
Message-Id: <D9Q05T702L8Y.3UTLG7VXIFXOK@ventanamicro.com>
Cc: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
To: "Atish Patra" <atish.patra@linux.dev>, "Anup Patel"
 <anup@brainfault.org>, "Atish Patra" <atishp@atishpatra.org>, "Paul
 Walmsley" <paul.walmsley@sifive.com>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Alexandre Ghiti" <alex@ghiti.fr>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [PATCH 0/5] Enable hstateen bits lazily for the KVM RISC-V
 Guests
References: <20250505-kvm_lazy_enable_stateen-v1-0-3bfc4008373c@rivosinc.com> <D9OYWFEXSA55.OUUXFPIGGBZV@ventanamicro.com> <bc0f1273-d596-47dd-bcc6-be9894157828@linux.dev>
In-Reply-To: <bc0f1273-d596-47dd-bcc6-be9894157828@linux.dev>

2025-05-06T11:24:41-07:00, Atish Patra <atish.patra@linux.dev>:
> On 5/6/25 2:24 AM, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
>> 2025-05-05T14:39:25-07:00, Atish Patra <atishp@rivosinc.com>:
>>> This series adds support for enabling hstateen bits lazily at runtime
>>> instead of statically at bootime. The boot time enabling happens for
>>> all the guests if the required extensions are present in the host and/o=
r
>>> guest. That may not be necessary if the guest never exercise that
>>> feature. We can enable the hstateen bits that controls the access lazil=
y
>>> upon first access. This providers KVM more granular control of which
>>> feature is enabled in the guest at runtime.
>>>
>>> Currently, the following hstateen bits are supported to control the acc=
ess
>>> from VS mode.
>>>
>>> 1. BIT(58): IMSIC     : STOPEI and IMSIC guest interrupt file
>>> 2. BIT(59): AIA       : SIPH/SIEH/STOPI
>>> 3. BIT(60): AIA_ISEL  : Indirect csr access via siselect/sireg
>>> 4. BIT(62): HSENVCFG  : SENVCFG access
>>> 5. BIT(63): SSTATEEN0 : SSTATEEN0 access
>>>
>>> KVM already support trap/enabling of BIT(58) and BIT(60) in order
>>> to support sw version of the guest interrupt file.
>> I don't think KVM toggles the hstateen bits at runtime, because that
>> would mean there is a bug even in current KVM.
>
> This was a typo. I meant to say trap/emulate BIT(58) and BIT(60).
> This patch series is trying to enable the toggling of the hstateen bits=
=20
> upon first access.
>
> Sorry for the confusion.

No worries, it's my fault for misreading.
I got confused, because the code looked like generic lazy enablement,
while it's really only for the upper 32 bits and this series is not lazy
toggling any VS-mode visible bits.

>>>                                                     This series extends
>>> those to enable to correpsonding hstateen bits in PATCH1. The remaining
>>> patches adds lazy enabling support of the other bits.
>> The ISA has a peculiar design for hstateen/sstateen interaction:
>>
>>    For every bit in an hstateen CSR that is zero (whether read-only zero
>>    or set to zero), the same bit appears as read-only zero in sstateen
>>    when accessed in VS-mode.
>
> Correct.
>
>> This means we must clear bit 63 in hstateen and trap on sstateen
>> accesses if any of the sstateen bits are not supposed to be read-only 0
>> to the guest while the hypervisor wants to have them as 0.
>
> Currently, there are two bits in sstateen. FCSR and ZVT which are not=20
> used anywhere in opensbi/Linux/KVM stack.

True, I guess we can just make sure the current code can't by mistake
lazily enable any of the bottom 32 hstateen bits and handle the case
properly later.

> In case, we need to enable one of the bits in the future, does hypevisor=
=20
> need to trap every sstateen access ?

We need to trap sstateen accesses if the guest is supposed to be able to
control a bit in sstateen, but the hypervisor wants to lazily enable
that feature and sets 0 in hstateen until the first trap.

If hstateen is 1 for all features that the guest could control through
sstateen, we can and should just set the SE bit (63) to 1 as well.

> As per my understanding, it should be handled in the hardware and any=20
> write access to to those bits should be masked
> with hstateen bit value so that it matches. That's what we do in Qemu as=
=20
> well.

Right, hardware will do the job most of the time.  It's really only for
the lazy masking, beause if we don't trap the stateen accesses, they
would differ from what the guest should see.


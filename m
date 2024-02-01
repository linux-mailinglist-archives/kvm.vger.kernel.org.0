Return-Path: <kvm+bounces-7762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA633846097
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 20:06:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 492B5289F10
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 19:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F83D85268;
	Thu,  1 Feb 2024 19:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="mqzZCNWw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9964B84FC7
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 19:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706814369; cv=none; b=qtSWf4h82WdX8JKfYeZASKS3OMmsWyfNRPHoIkD9kWrfhr0DM/Mh6phoXzYyUmRbpscWPhpABemihF1QI79B9U7qfb+EoxK+uFMYLidBnx6lfYg9Ff+UKq2/mb/22zrrLl+GFVeSBFMrLllKEG6N5WV+rfxHbCE8b2Bf4pvYuMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706814369; c=relaxed/simple;
	bh=PvjxRiqq/yG1xKM7s5NMwNZPwhZVkPuclPN/nftSfXk=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=Q5uBLe2lmRykfq6wRen5untsLHmCfSzwUqI99tXVO2XyFntS27UtZ1hmG0LihwP/aR/CiJfdeE3OYYRKfZbJ0VDFB4tiwybPxs8O5PKEjWNZXLn4aG9wYm6zJHZsToY3dlRttSo2Ta5nC2XQpChuFdSgLcz58p6Uh89KU3mZZ2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=mqzZCNWw; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5dbf050821fso620175a12.2
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 11:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1706814367; x=1707419167; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LOl1GDOBdFVJ/eBLhHv6vgMEpIuc6vWck2u88PUrQxw=;
        b=mqzZCNWw4QwZIUqSdqaf0huWz4MyqOMa7SGMpu6rsD1Rw032+BIzpcv9JL+GHRGUXo
         B1rdnRU5H3QtPbdbo/NSCnsZhP3POBfxel7NeP7ApbBv/0vCpOp91i5jmGM0s0oowVhH
         CMsivNCwj7oiEMSokz13JdGAJ7zQlbWXu/+3lDYI5NS5SKe445jvwmhFAXZ13zFCuXAE
         uGNEi4Tu68X6+yWM/8XGEVvOVzBLi+sdqGlNorvyu7UOnZ4qYN34582zxKRDNnaTKG2b
         U6k7bIwvcS/HdALDWlwsfy3s1g9A8vA2lYLM8a4SVbyc4xEB9HYb/MJX0YCu9DU8VJww
         hXpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706814367; x=1707419167;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LOl1GDOBdFVJ/eBLhHv6vgMEpIuc6vWck2u88PUrQxw=;
        b=l8bHdlTM9Lh6EG9ctxQr8rdZG37Wqi73XWyPHqmjsFeehCMlPpjw6b7cGKaIPGpANz
         JGOh7X7+5pa+0s4VuPSBs5qypBIdrBS8ftQq3TwFT84iZVuVl8pOD3F1o6qQE5zjdHWD
         sXXxVKqywqJmkuWXz6PaBS6UiH8L/SKy5+gZNDZ5zXPaP/DDQF5fhOWyUMjZVeSTJ+W8
         HFbDZCiQtGK7PLmFkqCZq6GYGcWHZjb9yBYCoBFRVwGbYUzEQCTB/xPUzjeFHbLZwjVD
         sef3YiN226HcIWdBWrVU+ay6tw53hctZeuscUgoTK37enzu2GyVG7NCR+qfU5j3Jkk+g
         wqPA==
X-Gm-Message-State: AOJu0YzCFex9Y0rdMdyStLjv2S5+5izEl0oZA863sL4IYRgZ1g9LOOZg
	t8QdSGrWdeq+3mGaO8psBZh+J3CeKZjVYd2XNzgM3yFVLhm1dsr2UgX2fQMtQds=
X-Google-Smtp-Source: AGHT+IFf5KWl4MM4iMU700NATkm4eGaTdPyEaerr5i7u0ggFrGcSV/BPO639CVsuOlp/DSW68DgUvA==
X-Received: by 2002:a05:6a20:8e29:b0:19c:a317:2e5e with SMTP id y41-20020a056a208e2900b0019ca3172e5emr6952412pzj.20.1706814366512;
        Thu, 01 Feb 2024 11:06:06 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUx75hSlP4vNqrKl8PKL8mVWxxl0Lzdj3eklfpiL7wH00NFFfN+MpUP1zF7g6OlYRaIZV/5oXecaf7SpmCcJSCOtsa86Ep7LyZjRIb6efiCW1CWFPREjoVxdx3lvDZo6S1+SCTRntFHWH7gPYOOBYOb816f3+80IovkWmvMmtDyrw4K2bkBbkbRMe3TyEHvoboWYxmAG19cxeSjd49BUYx/AOv8+L5RpTABxnm5fhSptZICs8Q0jwjAz1MgAHgN0vIY9inaed5p2NBpxp26lwEGSBuUu8aQgQjo/wpFTwpXdjZqyyfbe5exioigx6PV5fLVhxGR2T9VoDPUuMaIvE3sk7//r8H9aPfhuGFTxwJMPshNKapz12wwIaUmCBvsZfyG7zKOXyIQkZbGDMmjA5F1XYmhGa72XVkTUCrojgK/6CUjSAE6/wQOJVty53MY/cKBJlTFgOARLZL0cnDFfS1r9+Zxcu8Ryjz2AmYIHSlG/SmU7l7fAok3VTLz8OH9jhF7l4iNH23n8BS0Wr87CTND1YasgquhdtYWJnRI260Rsnzj4GDAAlD0ZLIMl4xfE+a2c2W+bBd4svBZ82AB2QLNK1reZWEAy0FuUjEuOK6ecPhaRsy0RkuVZ+Ju7AK9NBq13Z8ijGIgOedJAg==
Received: from localhost ([12.44.203.122])
        by smtp.gmail.com with ESMTPSA id u24-20020a63d358000000b005dbe22202fbsm179508pgi.42.2024.02.01.11.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 11:06:05 -0800 (PST)
Date: Thu, 01 Feb 2024 11:06:05 -0800 (PST)
X-Google-Original-Date: Thu, 01 Feb 2024 11:06:04 PST (-0800)
Subject:     Re: Call for GSoC/Outreachy internship project ideas
In-Reply-To: <87frycj9mr.fsf@draig.linaro.org>
CC: stefanha@gmail.com, Alistair Francis <Alistair.Francis@wdc.com>,
  dbarboza@ventanamicro.com, qemu-devel@nongnu.org, kvm@vger.kernel.org, afaria@redhat.com,
  eperezma@redhat.com, gmaglione@redhat.com, marcandre.lureau@redhat.com, rjones@redhat.com,
  sgarzare@redhat.com, imp@bsdimp.com, philmd@linaro.org, pbonzini@redhat.com, thuth@redhat.com,
  danielhb413@gmail.com, gaosong@loongson.cn, akihiko.odaki@daynix.com, shentey@gmail.com,
  npiggin@gmail.com, seanjc@google.com, Marc Zyngier <maz@kernel.org>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: alex.bennee@linaro.org
Message-ID: <mhng-6ed8e854-a853-4cd5-8a93-276031165f1a@palmer-ri-x1c9a>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Thu, 01 Feb 2024 10:57:00 PST (-0800), alex.bennee@linaro.org wrote:
> Palmer Dabbelt <palmer@dabbelt.com> writes:
>
>> On Thu, 01 Feb 2024 09:39:22 PST (-0800), alex.bennee@linaro.org wrote:
>>> Palmer Dabbelt <palmer@dabbelt.com> writes:
>>>
>>>> On Tue, 30 Jan 2024 12:28:27 PST (-0800), stefanha@gmail.com wrote:
>>>>> On Tue, 30 Jan 2024 at 14:40, Palmer Dabbelt <palmer@dabbelt.com> wrote:
>>>>>>
>>>>>> On Mon, 15 Jan 2024 08:32:59 PST (-0800), stefanha@gmail.com wrote:
>>>>>> > Dear QEMU and KVM communities,
>>>>>> > QEMU will apply for the Google Summer of Code and Outreachy internship
>>>>>> > programs again this year. Regular contributors can submit project
>>>>>> > ideas that they'd like to mentor by replying to this email before
>>>>>> > January 30th.
>>>>>>
>>>>>> It's the 30th, sorry if this is late but I just saw it today.  +Alistair
>>>>>> and Daniel, as I didn't sync up with anyone about this so not sure if
>>>>>> someone else is looking already (we're not internally).
>>> <snip>
>>>>> Hi Palmer,
>>>>> Performance optimization can be challenging for newcomers. I wouldn't
>>>>> recommend it for a GSoC project unless you have time to seed the
>>>>> project idea with specific optimizations to implement based on your
>>>>> experience and profiling. That way the intern has a solid starting
>>>>> point where they can have a few successes before venturing out to do
>>>>> their own performance analysis.
>>>>
>>>> Ya, I agree.  That's part of the reason why I wasn't sure if it's a
>>>> good idea.  At least for this one I think there should be some easy to
>>>> understand performance issue, as the loops that go very slowly consist
>>>> of a small number of instructions and go a lot slower.
>>>>
>>>> I'm actually more worried about this running into a rabbit hole of
>>>> adding new TCG operations or even just having no well defined mappings
>>>> between RVV and AVX, those might make the project really hard.
>>>
>>> You shouldn't have a hard guest-target mapping. But are you already
>>> using the TCGVec types and they are not expanding to AVX when its
>>> available?
>>
>> Ya, sorry, I guess that was an odd way to describe it.  IIUC we're
>> doing sane stuff, it's just that RISC-V has a very different vector
>> masking model than other ISAs.  I just said AVX there because I only
>> care about the performance on Intel servers, since that's what I run
>> QEMU on.  I'd asssume we have similar performance problems on other
>> targets, I just haven't looked.
>>
>> So my worry would be that the RVV things we're doing slowly just don't
>> have fast implementations via AVX and thus we run into some
>> intractable problems.  That sort of stuff can be really frusturating
>> for an intern, as everything's new to them so it can be hard to know
>> when something's an optimization dead end.
>>
>> That said, we're seeing 100x slowdows in microbenchmarks and 10x
>> slowdowns in real code, so I think there sholud be some way to do
>> better.
>
> It would be nice if you could convert that micro-benchmark to plain C
> for a tcg/multiarch test case. It would be a useful tool for testing
> changes.

Yep.  I actually gave it a shot before posting the C++ version and it 
seems kind of fragile, just poking it boring looknig ways changes the 
behavior.  Some of that was tied up in me trying to get GCC to generate 
similar code to clang, though, so hopefully that's all manageable.  I 
certainly wouldn't want to throw something that wacky at an intern for 
their first project, though.  So I don't have a good version yet.

I'm also hoping the fuzzer reproduces some nice small examples, but no 
luck yet...

>
>>
>>> Remember for anything float we will end up with softfloat anyway so we
>>> can't use SIMD on the backend.
>>
>> Yep, but we have a handful of integer slowdowns too so I think there's
>> some meat to chew on here.  The softfloat stuff should be equally slow
>> for scalar/vector, so we shouldn't be tripping false positives there.
>>
>>>>> Do you have the time to profile and add specifics to the project idea
>>>>> by Feb 21st? If that sounds good to you, I'll add it to the project
>>>>> ideas list and you can add more detailed tasks in the coming weeks.
>>>>
>>>> I can at least dig up some of the examples I ran into, there's been a
>>>> handful filtering in over the last year or so.
>>>>
>>>> This one
>>>> <https://gist.github.com/compnerd/daa7e68f7b4910cb6b27f856e6c2beba>
>>>> still has a much more than 10x slowdown (73ms -> 13s) with
>>>> vectorization, for example.
>>>>
>>>>> Thanks,
>>>>> Stefan
>>>
>>> -- Alex Bennée
>>> Virtualisation Tech Lead @ Linaro
>
> -- 
> Alex Bennée
> Virtualisation Tech Lead @ Linaro


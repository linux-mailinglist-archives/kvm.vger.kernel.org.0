Return-Path: <kvm+bounces-7761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 289C7846078
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 19:57:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EFC67B2565C
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 18:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9CAB84052;
	Thu,  1 Feb 2024 18:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XRoYaU9A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191D25CDFC
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 18:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706813825; cv=none; b=Ztj+P5x1sKQiDnhVJ0J3BI+HjRurbc1NJpkwHGaBi5c9tk+nfhtTxY+laEZtBV1DR8JXIbT/6OA4qBQYD8XO1RVgwgEFN0dlIXGSZJO+3D0RI8dMGlVN0IpGsbNoDConRFiwCw3wlkTXFyzb9Cos4pahzAC5Ksdq+3bg/Qyjj8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706813825; c=relaxed/simple;
	bh=6MGCXKksqq+8tm24SiAtOrJDmmNEqG0VDk7FBmT8MM0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=dFUlu2gEL4g8vJT6x5sn86C82yX5KwILKEUfclvFhe3708YcUOeqwtJ0YrmiLTS7oFHsrNqOEJGRqn69cjyoLqsGsrC9nT8rtHl0BA9oadeNtultiAX43sHgdJPmbOmvDPvnpicUGb+IBoFXc39kKfMXxS6fN1DrdGHs5Bdu2fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XRoYaU9A; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-40e72a567eeso11483275e9.0
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 10:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706813821; x=1707418621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OhLDjG81/ovcY8yRJE8mXgATcxNb7RC9wXi5FRI4Atw=;
        b=XRoYaU9AHtTldC4BrIH+SYlm/uJKRI4G61HsSkOetq/EjvKZ0XnGPhrW2823ghR3pC
         yDmKeByn9iON0Ygw4OFQchXNi9qe5Davsv60S9VrKiLea+SNAFCiGUcC8ccpz7VNmWgO
         K+lG61H8+kuKKpNWd5NYnXPKjT8kWSz9vTZZccbSeIs9Z5KtmCHSdl+O6AneEusEi6Wh
         GYsnaBPBVMK3UBWuAtdjXMqlv2+Zbp3whnT2OG3JU4DmOUBFnxhWf2uTBOF4KpWXLqW3
         DkEW4uQXYx8/FBbfYU8qhNBAtZ4xs0PSFk7QQ/qvv2PhXmhOLeyynAFGi5/aKFi1W+R2
         Pn7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706813821; x=1707418621;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OhLDjG81/ovcY8yRJE8mXgATcxNb7RC9wXi5FRI4Atw=;
        b=M8fI3ebD6U76MWbGE0sgMcPoaG0pNPGHKPdFEuh768VUd2pTBAIv7D3SDpax1W4WoQ
         9/qXRqCyt5amuypE2iyPwtrgc/wXpKUJ9ulo0k6wduGVBvrKJrKcuO1fSVDb6P9lY06I
         ywfXPiHIlMX7S3IoPsWEvWAWy7IxFQr8HOlHCwkybZ0TAH2SurElSSUxD4oLvWjf4KxD
         Dl5oNvahWq2gsCMALf1btVcSfC40RLqvH4Lcci8ly5yimxXqW7JvTL9qD/Xwjv/Ue2ur
         j6fAEp/+Z/coihvkZzYqRoiIBHGB02Dlu+HfDvmfZR6Xtly83lz/b6q6XA2XqMq7QHBG
         /5zg==
X-Gm-Message-State: AOJu0YwCmxP2oxYByyjRelpznn58edytffeZPOrziv+ov8cR5ZVeco9n
	3IB8zyGug6ySVYVLXhtWnuWfaj4HnJP8YQQL+lrwOnll67arXvI4il4dkw+jfeQ=
X-Google-Smtp-Source: AGHT+IH80KnwT5gxIbxzYss0X18Cpg6rCWGayEYNS/LRGEdnQGyT14Oh39/X0bp1JbAKToPQVs09ag==
X-Received: by 2002:a05:600c:1d09:b0:40e:61d4:5d3b with SMTP id l9-20020a05600c1d0900b0040e61d45d3bmr5584201wms.20.1706813821200;
        Thu, 01 Feb 2024 10:57:01 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXHChzsBOgQsj3Hcz1Olw+g2tJ62QjElptVbb5fn6zNv2cWbrh4nVsmH4GAZYH2rwbIhoPPjlMwjOfEBMNLcY9LPHpm6d6prtw8ZNfMgSFypBBAM1RL/2uwfrCD1mfpQyy2Av2+ZytQMgfnJDwWJ2+VHE2eTHvF5smvIgCY0M8j3H4Ngp0+WFgclUSOj9wuD5eI7/aUxlr61COegGRcRRi62e1EMMCMMoZC9j+KSEV32LeynmGWj2fEXW2+f0eVYO9Pjo5CqZrm6Lo+Qd0DLfSZAaNaynknzlJoh+mIL0zLX4fLrC9hn9qdWkeKODpx4pQ9rchUmBBK1uPXM1DnCNFIT8rvHf43rM5IsuDB4ESeQeV7MUyaoxGafBqJKIpJ2y0NPJXg1JkbmDSK0KmrvCC1FqqNGzdGOOqqYc45pbCzIchKme2NYfP3HT7POXoqgTRj2ikTdhYe11sizbA3jSS2gR8DwJVFgNwaZrBH9nngtB8rRpsOlHVtjSm0cFrCOIXjopLlDjjVOLkHisnwwsF9ESvOXTS204ORKZMzXTgbVdrXUUm10zpRivG97r2O8599w67KXKvFhYghnMC2lwm4WQJeDQ2Qj6FwjuMqJgCoou07JXdtslcK+Oe1oAESvcmAqGL/pKGvmMOwmA==
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id z12-20020a05600c220c00b0040fbe0ad3efsm328945wml.45.2024.02.01.10.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 10:57:00 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 7DEE75F7AF;
	Thu,  1 Feb 2024 18:57:00 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Palmer Dabbelt <palmer@dabbelt.com>
Cc: stefanha@gmail.com,  Alistair Francis <Alistair.Francis@wdc.com>,
  dbarboza@ventanamicro.com,  qemu-devel@nongnu.org,  kvm@vger.kernel.org,
  afaria@redhat.com,  eperezma@redhat.com,  gmaglione@redhat.com,
  marcandre.lureau@redhat.com,  rjones@redhat.com,  sgarzare@redhat.com,
  imp@bsdimp.com,  philmd@linaro.org,  pbonzini@redhat.com,
  thuth@redhat.com,  danielhb413@gmail.com,  gaosong@loongson.cn,
  akihiko.odaki@daynix.com,  shentey@gmail.com,  npiggin@gmail.com,
  seanjc@google.com,  Marc Zyngier <maz@kernel.org>
Subject: Re: Call for GSoC/Outreachy internship project ideas
In-Reply-To: <mhng-ec5f9ea7-e704-4302-8542-c8c36ea979d8@palmer-ri-x1c9a>
	(Palmer Dabbelt's message of "Thu, 01 Feb 2024 10:01:13 -0800 (PST)")
References: <mhng-ec5f9ea7-e704-4302-8542-c8c36ea979d8@palmer-ri-x1c9a>
User-Agent: mu4e 1.11.27; emacs 29.1
Date: Thu, 01 Feb 2024 18:57:00 +0000
Message-ID: <87frycj9mr.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Palmer Dabbelt <palmer@dabbelt.com> writes:

> On Thu, 01 Feb 2024 09:39:22 PST (-0800), alex.bennee@linaro.org wrote:
>> Palmer Dabbelt <palmer@dabbelt.com> writes:
>>
>>> On Tue, 30 Jan 2024 12:28:27 PST (-0800), stefanha@gmail.com wrote:
>>>> On Tue, 30 Jan 2024 at 14:40, Palmer Dabbelt <palmer@dabbelt.com> wrot=
e:
>>>>>
>>>>> On Mon, 15 Jan 2024 08:32:59 PST (-0800), stefanha@gmail.com wrote:
>>>>> > Dear QEMU and KVM communities,
>>>>> > QEMU will apply for the Google Summer of Code and Outreachy interns=
hip
>>>>> > programs again this year. Regular contributors can submit project
>>>>> > ideas that they'd like to mentor by replying to this email before
>>>>> > January 30th.
>>>>>
>>>>> It's the 30th, sorry if this is late but I just saw it today.  +Alist=
air
>>>>> and Daniel, as I didn't sync up with anyone about this so not sure if
>>>>> someone else is looking already (we're not internally).
>> <snip>
>>>> Hi Palmer,
>>>> Performance optimization can be challenging for newcomers. I wouldn't
>>>> recommend it for a GSoC project unless you have time to seed the
>>>> project idea with specific optimizations to implement based on your
>>>> experience and profiling. That way the intern has a solid starting
>>>> point where they can have a few successes before venturing out to do
>>>> their own performance analysis.
>>>
>>> Ya, I agree.  That's part of the reason why I wasn't sure if it's a
>>> good idea.  At least for this one I think there should be some easy to
>>> understand performance issue, as the loops that go very slowly consist
>>> of a small number of instructions and go a lot slower.
>>>
>>> I'm actually more worried about this running into a rabbit hole of
>>> adding new TCG operations or even just having no well defined mappings
>>> between RVV and AVX, those might make the project really hard.
>>
>> You shouldn't have a hard guest-target mapping. But are you already
>> using the TCGVec types and they are not expanding to AVX when its
>> available?
>
> Ya, sorry, I guess that was an odd way to describe it.  IIUC we're
> doing sane stuff, it's just that RISC-V has a very different vector
> masking model than other ISAs.  I just said AVX there because I only
> care about the performance on Intel servers, since that's what I run
> QEMU on.  I'd asssume we have similar performance problems on other
> targets, I just haven't looked.
>
> So my worry would be that the RVV things we're doing slowly just don't
> have fast implementations via AVX and thus we run into some
> intractable problems.  That sort of stuff can be really frusturating
> for an intern, as everything's new to them so it can be hard to know
> when something's an optimization dead end.
>
> That said, we're seeing 100x slowdows in microbenchmarks and 10x
> slowdowns in real code, so I think there sholud be some way to do
> better.

It would be nice if you could convert that micro-benchmark to plain C
for a tcg/multiarch test case. It would be a useful tool for testing
changes.

>
>> Remember for anything float we will end up with softfloat anyway so we
>> can't use SIMD on the backend.
>
> Yep, but we have a handful of integer slowdowns too so I think there's
> some meat to chew on here.  The softfloat stuff should be equally slow
> for scalar/vector, so we shouldn't be tripping false positives there.
>
>>>> Do you have the time to profile and add specifics to the project idea
>>>> by Feb 21st? If that sounds good to you, I'll add it to the project
>>>> ideas list and you can add more detailed tasks in the coming weeks.
>>>
>>> I can at least dig up some of the examples I ran into, there's been a
>>> handful filtering in over the last year or so.
>>>
>>> This one
>>> <https://gist.github.com/compnerd/daa7e68f7b4910cb6b27f856e6c2beba>
>>> still has a much more than 10x slowdown (73ms -> 13s) with
>>> vectorization, for example.
>>>
>>>> Thanks,
>>>> Stefan
>>
>> -- Alex Benn=C3=A9e
>> Virtualisation Tech Lead @ Linaro

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro


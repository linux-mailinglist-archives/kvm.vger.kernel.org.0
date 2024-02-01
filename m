Return-Path: <kvm+bounces-7752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D7C8845EB7
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 18:39:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12ACF1F20F4A
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 17:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8494684037;
	Thu,  1 Feb 2024 17:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ucRcnqQM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FB26FB80
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 17:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706809166; cv=none; b=DDSyPzVpxe+ZqhBb1Q3r+uv00MJZdgrUjTmXhfBqP6aXtqTTv6bkYtg8Ps91SAJlQNUsCi6mm85aQDaoD5OhkN7XU9qxVP6hJn3i2tzBo5sWQGDrApr4MNsaaXfexzoZUEPt8xA+HJ8ENCLw99E6Pp1PJ37QEZ4vKfbthJreNOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706809166; c=relaxed/simple;
	bh=cNYzf74IkkkykwrChcmSNmZf+xD4qBOuu79n6zi5ZR4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iqjb42mrr9jYkSva8LKbguM+N377PI+8RCzMvq6UhIlmNXBnHDYWvTmz5RJ3/bQs43bQZur7IrCdYDdOGNamoaRAT9Ibm/R0buPHLof1jYTam6/D6gszBJf2xXc5peXXey/hyFTUYKECfS2si3Pk6lNP3I0FbB91mNX5eLH9Qvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ucRcnqQM; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-40ef6da20feso7153055e9.0
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 09:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706809163; x=1707413963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RzoZDvDII/Op/k856KqiHsOD8jArS3pDpqkAcYGo0Nw=;
        b=ucRcnqQMvz+S0DxMedK2im+16xrbWb0/hbDne2NtDh+gpza69ii1OgwAxOJEMnLBID
         a2nisJmAV8vsvlbNSMlTY3tc2qfiFEkf75jMwQX7J1FXA8KFvsrv8ccbmeryHq8a/wSO
         v1k4kBay6MhasjVqp0TbpzCGHRJpKtP9kFpHgdl/oO6yus5E45nUOy1UIvXLuW7ce3XB
         xEMwN5ghJJ07S09CnU3d/1vlVzvC4qCd0EIqH6HW6S3QPQy9rzr7QzFjLYdfQjYtl0UP
         L1gmrcFR4lEJnq9xNrPTY3Hsl32FH6lbXVcvGkZXk5Kwi4+iyIb0EROFlA1K55hNDVVp
         WqRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706809163; x=1707413963;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RzoZDvDII/Op/k856KqiHsOD8jArS3pDpqkAcYGo0Nw=;
        b=KaN2unbWYkIkWHCcdCSPw0DIQQ5VgOQez1Z3kiPPXJVdyDNwizofmQ3b3Uldbk+xqL
         /6MKMtLjLt7N/qMzKRzDgPkIhIBrQUKo5IM78A+LL0z1LIoH/nb8f5nWB2dahDg2h960
         19wtx2Vz9iaOhYsEY0jdnbjPC48X2TNSuCu+PDMx1GeGsbFw3H85F1/bS2CuFbUs3LYv
         pHlfAOdH7jBO1jY1J8XzhJRPtWEUWLMzd6AsCiI5ZhlH4GoI9+zar5gaM8Xd/PhyCcyw
         sECKpeSiEtWOcKkJzTXMl50ThEpk/DMiKzuqYYFWkwM9GqZ0coJzEOViVScFabjfURJL
         nrOQ==
X-Gm-Message-State: AOJu0YweQAi60cEJj5uts9sj+Ej9Tp8T2dDuho+lSDdvzntvL/6wD0Rg
	tKQ2Y9wBNqar07jjgKF+XHjdy0j/4LGLrLFLR4qHZ2gZGYsB87f4l+nA3hNT0J4=
X-Google-Smtp-Source: AGHT+IEtGiborKIfQbJLWBuCUv3huaGcPbA7q0BWb9JZD3oxvCoNvcOtJRpS2hpUEL26RpAa9e6Xkw==
X-Received: by 2002:a05:600c:1c0a:b0:40e:e8e3:40c2 with SMTP id j10-20020a05600c1c0a00b0040ee8e340c2mr8118047wms.12.1706809163021;
        Thu, 01 Feb 2024 09:39:23 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVOcVhgl2NT50x2K+iQRLmWZxW6bkz8eMXCrH2OwknGbH9+8scUaFH+cL7tVOQm48Uf2NvmOwxUIKNn1dIsfgqPw8b2/vZZAVDYDLvoVmmKo3xv8LeZYL6jxy6ARvrkem9jVY3EPVCwFzEGHl4WBKK2SVWVRKFfv41N99SCs5i0SXqkBSUI+1e+Ewg/xtC3wRtBI3miu+abWrpvw8/nHHeqYKOG3NXSQsEgPPFAHzOJaRZv/tTGgO52v3Zu/XacebJd9xzgvm7Z3DwwOWiWYd35uQp/bqPYtOU4zzFK6LxucK7I3N+1QZypAVgJ408LmgRQ3iU4NwxlqH4B6+Z8n1ZbBYFIoz+AX0JTjl6v8n0n6rCKKr49WCZBKnhU93ngVwzqMnnJozvvHsHFXtiMMdYbmq1C+JwGHUKpEX7GIr1P8gB5PWtEGmvMO7t+tjTd71C7+rwZzdCMrQdEQIAs+C6nsh24NOWIqfQx6zEVup2jeaeUQXK2DZRijyLfsqumNFnFMQanhb44SRxDNuwj6I0Lv69SYccZLbPyBLC+SGH8uaBcViwNlJXewA5ybtYHCRurYNYU94jMq9EyuytWWl6QrV6pApWDllnpp+n3AzUiEVBJCorGnN3LisRKwbkeTNwC8nL2RyCq97/mPg==
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id o7-20020a05600c510700b0040e880ac6ecsm5096977wms.35.2024.02.01.09.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 09:39:22 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 50CBE5F7AF;
	Thu,  1 Feb 2024 17:39:22 +0000 (GMT)
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
In-Reply-To: <mhng-e7014372-2334-430e-b22e-17227af21bd9@palmer-ri-x1c9a>
	(Palmer Dabbelt's message of "Tue, 30 Jan 2024 16:29:34 -0800 (PST)")
References: <mhng-e7014372-2334-430e-b22e-17227af21bd9@palmer-ri-x1c9a>
User-Agent: mu4e 1.11.27; emacs 29.1
Date: Thu, 01 Feb 2024 17:39:22 +0000
Message-ID: <87le84jd85.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Palmer Dabbelt <palmer@dabbelt.com> writes:

> On Tue, 30 Jan 2024 12:28:27 PST (-0800), stefanha@gmail.com wrote:
>> On Tue, 30 Jan 2024 at 14:40, Palmer Dabbelt <palmer@dabbelt.com> wrote:
>>>
>>> On Mon, 15 Jan 2024 08:32:59 PST (-0800), stefanha@gmail.com wrote:
>>> > Dear QEMU and KVM communities,
>>> > QEMU will apply for the Google Summer of Code and Outreachy internship
>>> > programs again this year. Regular contributors can submit project
>>> > ideas that they'd like to mentor by replying to this email before
>>> > January 30th.
>>>
>>> It's the 30th, sorry if this is late but I just saw it today.  +Alistair
>>> and Daniel, as I didn't sync up with anyone about this so not sure if
>>> someone else is looking already (we're not internally).
<snip>
>> Hi Palmer,
>> Performance optimization can be challenging for newcomers. I wouldn't
>> recommend it for a GSoC project unless you have time to seed the
>> project idea with specific optimizations to implement based on your
>> experience and profiling. That way the intern has a solid starting
>> point where they can have a few successes before venturing out to do
>> their own performance analysis.
>
> Ya, I agree.  That's part of the reason why I wasn't sure if it's a
> good idea.  At least for this one I think there should be some easy to
> understand performance issue, as the loops that go very slowly consist
> of a small number of instructions and go a lot slower.
>
> I'm actually more worried about this running into a rabbit hole of
> adding new TCG operations or even just having no well defined mappings
> between RVV and AVX, those might make the project really hard.

You shouldn't have a hard guest-target mapping. But are you already
using the TCGVec types and they are not expanding to AVX when its
available?

Remember for anything float we will end up with softfloat anyway so we
can't use SIMD on the backend.

>
>> Do you have the time to profile and add specifics to the project idea
>> by Feb 21st? If that sounds good to you, I'll add it to the project
>> ideas list and you can add more detailed tasks in the coming weeks.
>
> I can at least dig up some of the examples I ran into, there's been a
> handful filtering in over the last year or so.
>
> This one
> <https://gist.github.com/compnerd/daa7e68f7b4910cb6b27f856e6c2beba>
> still has a much more than 10x slowdown (73ms -> 13s) with
> vectorization, for example.
>
>> Thanks,
>> Stefan

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro


Return-Path: <kvm+bounces-7510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E7088431E8
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 01:29:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 924081C253B9
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 00:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F2EA37B;
	Wed, 31 Jan 2024 00:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="zr/T/TDH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E049363
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 00:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660977; cv=none; b=mr0+8UeAFg/MqAramiFFG2c+FC4sUpuIQPjolH7CQh629lWPECxwqVt3Sb46EMjpyxxN5gcpUqCu6PYr0ug4tRgQiUAOABm+yf7UgqYuXzuXkpgA9ujnaYvEGnzSCBgNGmYbL59YvxGRJwQvzYqvaAMCKu9zZKs1Ewm8d3QHtzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660977; c=relaxed/simple;
	bh=5mowbIroZO20pwwDbs4jAweCIWBna8B+HnYvdPM8IYQ=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=py4We2qcN8iAAFK5QCrbxBhodgy/nGMKvf3XTBJGOiMCFIe9drrg/mChkKCLUexWopLDBqvN3kSVMJGQAP1UgjKyD8o3ULYOn2Ar5mwXKYjvdySe8OQW2f3Fsk8CsHEQiVpOHeUPQFvhUCAxQ64ZT52VxmUQuf4MiRW5tyTbCs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=zr/T/TDH; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d73066880eso36665355ad.3
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 16:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1706660975; x=1707265775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oRLEFUdWpThQfnH7eYE9k9scQwtpW7zudC4XUtfylHg=;
        b=zr/T/TDHHXmQZZd9u4bxfdyWp0K5Do0NA533iJvGylxvV/mZVsPwqdoHLW5I84AefT
         2YduGmdSd1AHl1MwcT1h1uZjGtGclY32UCo9OMc3JHRsFzd8MVAkjHPhdITYQBZfs4i5
         IZrRYGF1+CPWcJBUNaJb4y0kF/4fbwiBS0zIbKfQKDWHHOr8UZeg069wJ3wxbeH9pnlJ
         oPZfhygwG6hTX9Ud6ek59nbaRtv+fZO3P5C+3NdMdWa8XUI7uMNjwXGBMeETXC5Sv9EA
         1J4+ZWoIDUC2mcrI9bhJPHdfsgzWAAFAZtLx0OMZxvCyW5D0kX/4XEUJN5ViAfGKXiVi
         YL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660975; x=1707265775;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oRLEFUdWpThQfnH7eYE9k9scQwtpW7zudC4XUtfylHg=;
        b=tHwjTbsz0WeO/TnTANYKY0qabQEJM5MLnR+aWDw6dsgchLvKJYFCUq/x1fEw2O3Cvd
         W5Zr5CyjV+Am6gdNze03yG8ZmgpAvuL985OKAy8aD8cdpP7l5OnmIq2a5DsliQDh2OPV
         EFWYTyt0Q+8iYIXK8V7AWoUCipefBx7XbjX09GdCvXg3Hb6MtsuZoAvg8SwMjm2oT+i3
         CE8m/d0p5z1CMhJKs8nt9XcucBy78jWW7lwzrT98KVrUY/43bVE61vyTYC3ZhufQtj6Q
         IiGKReN08G/7tLIFZR7YjlUsOQt/bBpUyWRKlHfMQgVcSbqRUqkfvHLh7i6TPd0JctKH
         sRhQ==
X-Gm-Message-State: AOJu0YzCbOK7R7d2qGHv6zeVs4y/za7WmVWk88jCNSPGKSE+9bax4F77
	ZBfCX1T/qNh9wTXb1IWmPYyO0dfJMzBRPS+wD7a7GHvHy51rcdMncwRJlBcPT3Q=
X-Google-Smtp-Source: AGHT+IEffwLOD3IeGUvaEZuDZg/fNUq8KeMu5UCv1OS3W7G/LqKI6ZtHB8RVKmtvaa6YyYi9ygBI9w==
X-Received: by 2002:a17:903:1344:b0:1d6:f34c:35d9 with SMTP id jl4-20020a170903134400b001d6f34c35d9mr176144plb.58.1706660974561;
        Tue, 30 Jan 2024 16:29:34 -0800 (PST)
Received: from localhost ([12.44.203.122])
        by smtp.gmail.com with ESMTPSA id c3-20020a170902d90300b001d901e176afsm2267470plz.232.2024.01.30.16.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 16:29:34 -0800 (PST)
Date: Tue, 30 Jan 2024 16:29:34 -0800 (PST)
X-Google-Original-Date: Tue, 30 Jan 2024 16:29:29 PST (-0800)
Subject:     Re: Call for GSoC/Outreachy internship project ideas
In-Reply-To: <CAJSP0QU2M0e56M0S9ztMDO7eyqFB-p1KgwxJhzwkxt=CuS_PqA@mail.gmail.com>
CC: Alistair Francis <Alistair.Francis@wdc.com>, dbarboza@ventanamicro.com,
  qemu-devel@nongnu.org, kvm@vger.kernel.org, afaria@redhat.com, alex.bennee@linaro.org,
  eperezma@redhat.com, gmaglione@redhat.com, marcandre.lureau@redhat.com, rjones@redhat.com,
  sgarzare@redhat.com, imp@bsdimp.com, philmd@linaro.org, pbonzini@redhat.com, thuth@redhat.com,
  danielhb413@gmail.com, gaosong@loongson.cn, akihiko.odaki@daynix.com, shentey@gmail.com,
  npiggin@gmail.com, seanjc@google.com, Marc Zyngier <maz@kernel.org>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: stefanha@gmail.com
Message-ID: <mhng-e7014372-2334-430e-b22e-17227af21bd9@palmer-ri-x1c9a>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Tue, 30 Jan 2024 12:28:27 PST (-0800), stefanha@gmail.com wrote:
> On Tue, 30 Jan 2024 at 14:40, Palmer Dabbelt <palmer@dabbelt.com> wrote:
>>
>> On Mon, 15 Jan 2024 08:32:59 PST (-0800), stefanha@gmail.com wrote:
>> > Dear QEMU and KVM communities,
>> > QEMU will apply for the Google Summer of Code and Outreachy internship
>> > programs again this year. Regular contributors can submit project
>> > ideas that they'd like to mentor by replying to this email before
>> > January 30th.
>>
>> It's the 30th, sorry if this is late but I just saw it today.  +Alistair
>> and Daniel, as I didn't sync up with anyone about this so not sure if
>> someone else is looking already (we're not internally).
>>
>> > Internship programs
>> > ---------------------------
>> > GSoC (https://summerofcode.withgoogle.com/) and Outreachy
>> > (https://www.outreachy.org/) offer paid open source remote work
>> > internships to eligible people wishing to participate in open source
>> > development. QEMU has been part of these internship programs for many
>> > years. Our mentors have enjoyed helping talented interns make their
>> > first open source contributions and some former interns continue to
>> > participate today.
>> >
>> > Who can mentor
>> > ----------------------
>> > Regular contributors to QEMU and KVM can participate as mentors.
>> > Mentorship involves about 5 hours of time commitment per week to
>> > communicate with the intern, review their patches, etc. Time is also
>> > required during the intern selection phase to communicate with
>> > applicants. Being a mentor is an opportunity to help someone get
>> > started in open source development, will give you experience with
>> > managing a project in a low-stakes environment, and a chance to
>> > explore interesting technical ideas that you may not have time to
>> > develop yourself.
>> >
>> > How to propose your idea
>> > ----------------------------------
>> > Reply to this email with the following project idea template filled in:
>> >
>> > === TITLE ===
>> >
>> > '''Summary:''' Short description of the project
>> >
>> > Detailed description of the project that explains the general idea,
>> > including a list of high-level tasks that will be completed by the
>> > project, and provides enough background for someone unfamiliar with
>> > the codebase to do research. Typically 2 or 3 paragraphs.
>> >
>> > '''Links:'''
>> > * Wiki links to relevant material
>> > * External links to mailing lists or web sites
>> >
>> > '''Details:'''
>> > * Skill level: beginner or intermediate or advanced
>> > * Language: C/Python/Rust/etc
>>
>> I'm not 100% sure this is a sane GSoC idea, as it's a bit open ended and
>> might have some tricky parts.  That said it's tripping some people up
>> and as far as I know nobody's started looking at it, so I figrued I'd
>> write something up.
>>
>> I can try and dig up some more links if folks thing it's interesting,
>> IIRC there's been a handful of bug reports related to very small loops
>> that run ~10x slower when vectorized.  Large benchmarks like SPEC have
>> also shown slowdowns.
>
> Hi Palmer,
> Performance optimization can be challenging for newcomers. I wouldn't
> recommend it for a GSoC project unless you have time to seed the
> project idea with specific optimizations to implement based on your
> experience and profiling. That way the intern has a solid starting
> point where they can have a few successes before venturing out to do
> their own performance analysis.

Ya, I agree.  That's part of the reason why I wasn't sure if it's a 
good idea.  At least for this one I think there should be some easy to 
understand performance issue, as the loops that go very slowly consist 
of a small number of instructions and go a lot slower.

I'm actually more worried about this running into a rabbit hole of 
adding new TCG operations or even just having no well defined mappings 
between RVV and AVX, those might make the project really hard.

> Do you have the time to profile and add specifics to the project idea
> by Feb 21st? If that sounds good to you, I'll add it to the project
> ideas list and you can add more detailed tasks in the coming weeks.

I can at least dig up some of the examples I ran into, there's been a 
handful filtering in over the last year or so.

This one 
<https://gist.github.com/compnerd/daa7e68f7b4910cb6b27f856e6c2beba> 
still has a much more than 10x slowdown (73ms -> 13s) with 
vectorization, for example.

> Thanks,
> Stefan


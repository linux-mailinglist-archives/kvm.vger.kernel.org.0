Return-Path: <kvm+bounces-7525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB9D2843304
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 02:50:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 655BB1F2653D
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 01:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9142A5226;
	Wed, 31 Jan 2024 01:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="sGjjyLPW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F775681
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 01:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706665822; cv=none; b=oSdMIxs1eE1hsaeCvXjp3C3x8iH0K5XRggFucxsG6GFH6q4bUGawXsIlImj2z010v03VP9R6mutosjThF3ETK/P7Y/zYaybzlSOrHcq0Guz/f+WgrhEWZ+cF95sntnDboaUkxAd6Vpu5YhzSTO1rN63uxx7nUKUOtog+ifpL/Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706665822; c=relaxed/simple;
	bh=p4LRqhJIZ6k1bmr3nu4cArGhLqaamucP100FbpNRzlI=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=ctMiCHecbzS5gfLUyanmGVp1hZYO+jeOIry4rIq4nLFoRV8E50xFe1VCau3fR+r8jeVXPkjrJrnWkl4vVY3H5U+mZxkL9wED8tVgR7i8BTJNYtAvzQKRDNxaSfqY4MXimS8XfZIUu7rMXjp/DUgvHz9G4GXwpeD8fpE2xZmb7Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=sGjjyLPW; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1d71cb97937so27457625ad.3
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 17:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1706665817; x=1707270617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/kYJdJ0OmOFrp6DhbGNXAFfCBnvjcg1JoswxMFeCvkM=;
        b=sGjjyLPWuFUU6IJ2C9zMHd27DRhK1UPj4RcbQ0w0q984XVYxttIk8Iet1twDCTHEBj
         JTnFWYoCTTFUgyGap50lv4nmQSDADbvBF11zKDnJJOiJVJbAfR8TyeEjmrNFaOmu5+eX
         jk/Oj2fMsusaaVpcYa/skD60UHlqTk9D8BBYcdyX3+tptWcZL/cvw6zXPO6zMb0zc4fC
         v15XRTnl0WlKnCz+VEUUT/3DDYqR9u9hL7dFSH1LDck+wuw+1s71z2DvJ3u1SBiMw7Hs
         z2qA7RXnNqWdPsp0+zBpW6wUXJUcJIclBofjwDLJUHzFiUA772uCjoNeG1R+gv1zDVK4
         yRDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706665817; x=1707270617;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/kYJdJ0OmOFrp6DhbGNXAFfCBnvjcg1JoswxMFeCvkM=;
        b=r9G+BecJa5zCKFz6G0ovY0xZoHyQOskjIRx/GjEl0RPzlaf3Wj5jDeOhfmPQDWhAcp
         ya313o3xpbqd7L0r2VQyMDLQcZDhpzDP3w3ZBZo0aOmkOsgEkY6ykWxRxUUTkuK9+Pki
         gSqdCdPM2vmPsfQQ/p8k4Xhkl06viEvQ1kQCii0TDO6OLS7O05pvSS0iGSVLyz1Rn04L
         g1LLJXUOz8KywKK6/TeH4wNUBjEdRDQZ4J1Qla3etaBzAHqzxkmShl5Z7zR5N1ZeKy2M
         tgfuO/q10NP4zWUR8vVdetC39vLwZDeXv2bNn6BEYIYetBdTQ3dtlKgsE/GJrp0W+wUe
         HoAw==
X-Gm-Message-State: AOJu0Yx+h1N4Hc2lkL7fb85JBO9sDXUpJgpKynMPSf/84veguuMvHKtP
	ipShZQ6tEWs5wXNWa3X5tGNwh6ttc9+m38C47W+VmdUijwgFRBTEm9zPsiHGyeNEAYGk6dN62UP
	E
X-Google-Smtp-Source: AGHT+IH3j7ZZ8x+T/tjjx7aQcyGVM7Y3bc2tjampzOiiepQmi4ieofDEK2upvYP8R0gF54kHVhYuVQ==
X-Received: by 2002:a17:902:da8c:b0:1d3:4860:591b with SMTP id j12-20020a170902da8c00b001d34860591bmr364269plx.0.1706665816803;
        Tue, 30 Jan 2024 17:50:16 -0800 (PST)
Received: from localhost ([12.44.203.122])
        by smtp.gmail.com with ESMTPSA id y19-20020a170902ed5300b001d8b0750940sm6664266plb.175.2024.01.30.17.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 17:50:16 -0800 (PST)
Date: Tue, 30 Jan 2024 17:50:16 -0800 (PST)
X-Google-Original-Date: Tue, 30 Jan 2024 17:49:31 PST (-0800)
Subject:     Re: Call for GSoC/Outreachy internship project ideas
In-Reply-To: <CAKmqyKMAQ1vrf9QnCx17DbKgGTqgDd58y46RLwZvzW4Sk4zyjA@mail.gmail.com>
CC: stefanha@gmail.com, Alistair Francis <Alistair.Francis@wdc.com>,
  dbarboza@ventanamicro.com, qemu-devel@nongnu.org, kvm@vger.kernel.org, afaria@redhat.com,
  alex.bennee@linaro.org, eperezma@redhat.com, gmaglione@redhat.com, marcandre.lureau@redhat.com,
  rjones@redhat.com, sgarzare@redhat.com, imp@bsdimp.com, philmd@linaro.org, pbonzini@redhat.com,
  thuth@redhat.com, danielhb413@gmail.com, gaosong@loongson.cn, akihiko.odaki@daynix.com,
  shentey@gmail.com, npiggin@gmail.com, seanjc@google.com, Marc Zyngier <maz@kernel.org>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: alistair23@gmail.com
Message-ID: <mhng-3f05ad6b-53ef-4207-9592-625d794686e8@palmer-ri-x1c9a>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Tue, 30 Jan 2024 17:26:11 PST (-0800), alistair23@gmail.com wrote:
> On Wed, Jan 31, 2024 at 10:30 AM Palmer Dabbelt <palmer@dabbelt.com> wrote:
>>
>> On Tue, 30 Jan 2024 12:28:27 PST (-0800), stefanha@gmail.com wrote:
>> > On Tue, 30 Jan 2024 at 14:40, Palmer Dabbelt <palmer@dabbelt.com> wrote:
>> >>
>> >> On Mon, 15 Jan 2024 08:32:59 PST (-0800), stefanha@gmail.com wrote:
>> >> > Dear QEMU and KVM communities,
>> >> > QEMU will apply for the Google Summer of Code and Outreachy internship
>> >> > programs again this year. Regular contributors can submit project
>> >> > ideas that they'd like to mentor by replying to this email before
>> >> > January 30th.
>> >>
>> >> It's the 30th, sorry if this is late but I just saw it today.  +Alistair
>> >> and Daniel, as I didn't sync up with anyone about this so not sure if
>> >> someone else is looking already (we're not internally).
>> >>
>> >> > Internship programs
>> >> > ---------------------------
>> >> > GSoC (https://summerofcode.withgoogle.com/) and Outreachy
>> >> > (https://www.outreachy.org/) offer paid open source remote work
>> >> > internships to eligible people wishing to participate in open source
>> >> > development. QEMU has been part of these internship programs for many
>> >> > years. Our mentors have enjoyed helping talented interns make their
>> >> > first open source contributions and some former interns continue to
>> >> > participate today.
>> >> >
>> >> > Who can mentor
>> >> > ----------------------
>> >> > Regular contributors to QEMU and KVM can participate as mentors.
>> >> > Mentorship involves about 5 hours of time commitment per week to
>> >> > communicate with the intern, review their patches, etc. Time is also
>> >> > required during the intern selection phase to communicate with
>> >> > applicants. Being a mentor is an opportunity to help someone get
>> >> > started in open source development, will give you experience with
>> >> > managing a project in a low-stakes environment, and a chance to
>> >> > explore interesting technical ideas that you may not have time to
>> >> > develop yourself.
>> >> >
>> >> > How to propose your idea
>> >> > ----------------------------------
>> >> > Reply to this email with the following project idea template filled in:
>> >> >
>> >> > === TITLE ===
>> >> >
>> >> > '''Summary:''' Short description of the project
>> >> >
>> >> > Detailed description of the project that explains the general idea,
>> >> > including a list of high-level tasks that will be completed by the
>> >> > project, and provides enough background for someone unfamiliar with
>> >> > the codebase to do research. Typically 2 or 3 paragraphs.
>> >> >
>> >> > '''Links:'''
>> >> > * Wiki links to relevant material
>> >> > * External links to mailing lists or web sites
>> >> >
>> >> > '''Details:'''
>> >> > * Skill level: beginner or intermediate or advanced
>> >> > * Language: C/Python/Rust/etc
>> >>
>> >> I'm not 100% sure this is a sane GSoC idea, as it's a bit open ended and
>> >> might have some tricky parts.  That said it's tripping some people up
>> >> and as far as I know nobody's started looking at it, so I figrued I'd
>> >> write something up.
>> >>
>> >> I can try and dig up some more links if folks thing it's interesting,
>> >> IIRC there's been a handful of bug reports related to very small loops
>> >> that run ~10x slower when vectorized.  Large benchmarks like SPEC have
>> >> also shown slowdowns.
>> >
>> > Hi Palmer,
>> > Performance optimization can be challenging for newcomers. I wouldn't
>> > recommend it for a GSoC project unless you have time to seed the
>> > project idea with specific optimizations to implement based on your
>> > experience and profiling. That way the intern has a solid starting
>> > point where they can have a few successes before venturing out to do
>> > their own performance analysis.
>>
>> Ya, I agree.  That's part of the reason why I wasn't sure if it's a
>> good idea.  At least for this one I think there should be some easy to
>> understand performance issue, as the loops that go very slowly consist
>> of a small number of instructions and go a lot slower.
>>
>> I'm actually more worried about this running into a rabbit hole of
>> adding new TCG operations or even just having no well defined mappings
>> between RVV and AVX, those might make the project really hard.
>>
>> > Do you have the time to profile and add specifics to the project idea
>> > by Feb 21st? If that sounds good to you, I'll add it to the project
>> > ideas list and you can add more detailed tasks in the coming weeks.
>>
>> I can at least dig up some of the examples I ran into, there's been a
>> handful filtering in over the last year or so.
>>
>> This one
>> <https://gist.github.com/compnerd/daa7e68f7b4910cb6b27f856e6c2beba>
>> still has a much more than 10x slowdown (73ms -> 13s) with
>> vectorization, for example.
>
> It's probably worth creating a Gitlab issue for this and adding all of
> the examples there. That way we have a single place to store them all

Makes sense.  I think I'd been telling people to make bug reports for 
them, so there might be some in there already -- I just dug this one out 
of some history.

Here's a start: https://gitlab.com/qemu-project/qemu/-/issues/2137

>
> Alistair
>
>>
>> > Thanks,
>> > Stefan
>>


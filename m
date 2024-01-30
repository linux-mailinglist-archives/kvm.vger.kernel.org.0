Return-Path: <kvm+bounces-7504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B8E2842DDB
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 21:30:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 422BC28B6F0
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 20:30:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A496A79DCB;
	Tue, 30 Jan 2024 20:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mNIM4WeH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560FC79DBF
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 20:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706646521; cv=none; b=a9SgcN0kdfYZXTa07Ceht7o64f7P/pCp8SjiEXoW2JZKvMvWBjSwm/ZlBUwSJ1qWOTdLwIA3GfFq4cS6MdKaPYQvkay875RQkKodDw0OVo4DqBUSzoGwscFldRd8vCrhIT+rDGzhQf0Ysy8p36HiMFtdySm87G6/5rM7nyXPcQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706646521; c=relaxed/simple;
	bh=Cw+ZcenY7fmYnda7sUR4LsvN7SRkv4NhRAvj+cLVU5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c4+YZNHPE/IKJq4e4qNMB5E54huhwv+ZSSwEKrVQXW4PTFGhcDtJMJCFNuvlw6XgO54hx2MxG5SqxNTQOyMD2ZzjMY9j+d1+bpK5mEtBYa231E4kjZ5i+Gv+VVe34/XmlKynLmbJpwWNvhPVI6QBwV4kd2R0wUjyxopMWjUPhGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mNIM4WeH; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-59505514213so110342eaf.0
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 12:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706646519; x=1707251319; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TYjiL86j5niPhaSV5lYxgLBEBpuOrxJ2AjgyyF2AcnM=;
        b=mNIM4WeHlVYTeTG7Zcxse0wqddvLtVCAw2CEmCClYtLQA7CLszCBuzJI0Nso/aCh26
         iXfavyzwE5H2RhbEiEySG/44eyDWwre2hToZtKPlMdBO6iwhQnzLGTaHlqN7O2kc3x2s
         Eu+SkMS5Odle6EKhtG4yOvzCtmgSCZV3UCtBZGRmtJ8zDQTktAujyOgb66utPvwvXXuK
         h5NwU0IH/9UvDTesCHj7cGfOqMIJkE1EYMErMg4oOF9zyMSY5DWv1IGk02sDsH5ySvf/
         OSIkpQ7PmL/G+NNGoRq2kaDWscS+LKZr6p0DXtI92ZOwCu3X2YBpkUWm8u8fKy60ICjP
         6dhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706646519; x=1707251319;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TYjiL86j5niPhaSV5lYxgLBEBpuOrxJ2AjgyyF2AcnM=;
        b=uIAHe7+F0SVukMzg8STEwsDqWJzrDvoS5pJYAa1H3k7OQFbrIfNTFvk62yxpWenOL3
         am0sVhhSlLr3nk7KVmd+AoXaK2RdNdDP2sb6RowzX0TnCYBcwIYEhZxbCaRaprPQfYun
         glLn+5YM8CfpwktJWrAaC4DNFO9WDmfRcfuAy11APNEOPDIqqkhz5zgv0F6638h9W+Fj
         yBLKkGId3jyoWeu2N/n5sbcC41H7t3dMtsRd/vPg1k/bsm4pw14oHm0ltH/COHLm3rmq
         8p9oTLrdfb0TF3DC4uLgK5GxuzEzm7wbAmyHbwjGTwm/epK/wW/l9ILKx74WaLZus3Sw
         UKqw==
X-Gm-Message-State: AOJu0YyN4d3i4qHpmpTilF6sQif11d1+p/naWz6ptEHFNS8zwnM+kLqu
	m30Pllcf4OgpqzG3zXy5bUX5vcPrm0XFx3FXWJ7HoO6kKNbkMSjh+U3pvkALuhqDci1Zz0s0u25
	IZkYdfpnAOyA7AZ6RVJtIfvhTY4Q=
X-Google-Smtp-Source: AGHT+IEgAFHJcT5ZyOD5Gq6Oo0pP5q1NgjrVNlQcrKs3vwi5+IJ3NA6BQXRkLImoda378AAHNUgK7bJmlJQgj35fiWw=
X-Received: by 2002:a05:6820:167:b0:59a:8848:de64 with SMTP id
 k7-20020a056820016700b0059a8848de64mr271290ood.3.1706646519301; Tue, 30 Jan
 2024 12:28:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QX9TQ-=PD7apOamXvGW29VwJPfVNN2X5BsFLFoP2g6USg@mail.gmail.com>
 <mhng-bcb98ddd-c9a7-4bb9-b180-bf310a289eeb@palmer-ri-x1c9a>
In-Reply-To: <mhng-bcb98ddd-c9a7-4bb9-b180-bf310a289eeb@palmer-ri-x1c9a>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 30 Jan 2024 15:28:27 -0500
Message-ID: <CAJSP0QU2M0e56M0S9ztMDO7eyqFB-p1KgwxJhzwkxt=CuS_PqA@mail.gmail.com>
Subject: Re: Call for GSoC/Outreachy internship project ideas
To: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Alistair Francis <Alistair.Francis@wdc.com>, dbarboza@ventanamicro.com, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org, afaria@redhat.com, 
	alex.bennee@linaro.org, eperezma@redhat.com, gmaglione@redhat.com, 
	marcandre.lureau@redhat.com, rjones@redhat.com, sgarzare@redhat.com, 
	imp@bsdimp.com, philmd@linaro.org, pbonzini@redhat.com, thuth@redhat.com, 
	danielhb413@gmail.com, gaosong@loongson.cn, akihiko.odaki@daynix.com, 
	shentey@gmail.com, npiggin@gmail.com, seanjc@google.com, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 30 Jan 2024 at 14:40, Palmer Dabbelt <palmer@dabbelt.com> wrote:
>
> On Mon, 15 Jan 2024 08:32:59 PST (-0800), stefanha@gmail.com wrote:
> > Dear QEMU and KVM communities,
> > QEMU will apply for the Google Summer of Code and Outreachy internship
> > programs again this year. Regular contributors can submit project
> > ideas that they'd like to mentor by replying to this email before
> > January 30th.
>
> It's the 30th, sorry if this is late but I just saw it today.  +Alistair
> and Daniel, as I didn't sync up with anyone about this so not sure if
> someone else is looking already (we're not internally).
>
> > Internship programs
> > ---------------------------
> > GSoC (https://summerofcode.withgoogle.com/) and Outreachy
> > (https://www.outreachy.org/) offer paid open source remote work
> > internships to eligible people wishing to participate in open source
> > development. QEMU has been part of these internship programs for many
> > years. Our mentors have enjoyed helping talented interns make their
> > first open source contributions and some former interns continue to
> > participate today.
> >
> > Who can mentor
> > ----------------------
> > Regular contributors to QEMU and KVM can participate as mentors.
> > Mentorship involves about 5 hours of time commitment per week to
> > communicate with the intern, review their patches, etc. Time is also
> > required during the intern selection phase to communicate with
> > applicants. Being a mentor is an opportunity to help someone get
> > started in open source development, will give you experience with
> > managing a project in a low-stakes environment, and a chance to
> > explore interesting technical ideas that you may not have time to
> > develop yourself.
> >
> > How to propose your idea
> > ----------------------------------
> > Reply to this email with the following project idea template filled in:
> >
> > === TITLE ===
> >
> > '''Summary:''' Short description of the project
> >
> > Detailed description of the project that explains the general idea,
> > including a list of high-level tasks that will be completed by the
> > project, and provides enough background for someone unfamiliar with
> > the codebase to do research. Typically 2 or 3 paragraphs.
> >
> > '''Links:'''
> > * Wiki links to relevant material
> > * External links to mailing lists or web sites
> >
> > '''Details:'''
> > * Skill level: beginner or intermediate or advanced
> > * Language: C/Python/Rust/etc
>
> I'm not 100% sure this is a sane GSoC idea, as it's a bit open ended and
> might have some tricky parts.  That said it's tripping some people up
> and as far as I know nobody's started looking at it, so I figrued I'd
> write something up.
>
> I can try and dig up some more links if folks thing it's interesting,
> IIRC there's been a handful of bug reports related to very small loops
> that run ~10x slower when vectorized.  Large benchmarks like SPEC have
> also shown slowdowns.

Hi Palmer,
Performance optimization can be challenging for newcomers. I wouldn't
recommend it for a GSoC project unless you have time to seed the
project idea with specific optimizations to implement based on your
experience and profiling. That way the intern has a solid starting
point where they can have a few successes before venturing out to do
their own performance analysis.

Do you have the time to profile and add specifics to the project idea
by Feb 21st? If that sounds good to you, I'll add it to the project
ideas list and you can add more detailed tasks in the coming weeks.

Thanks,
Stefan


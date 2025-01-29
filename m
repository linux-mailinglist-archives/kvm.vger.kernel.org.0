Return-Path: <kvm+bounces-36883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69207A22341
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 18:44:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96A901674F3
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 17:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D662C1E0DB0;
	Wed, 29 Jan 2025 17:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="br/+EJxr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648C8372
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 17:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738172677; cv=none; b=Ncoco0f5IOdPgZVFJ1lGpRFzbPulqaMTt961RieERwXy1p4/K1QW1smeKaPuSAHc+AIBYowAUzbEI6F8rzLmPeAWD/riqIWNcIc83fDLJ+RAqOVBshGTUOzMZrv1K6rU44rQgNOlS2nmNceyTVUlMrbjODW20wtq/FgvLUovmcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738172677; c=relaxed/simple;
	bh=AvgUszk41nkDWz7o/qDLFKe7j0Xtk/wXXBraGwlaMug=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R7RDWXl190iuYHHUHe+fvRQBkCamILZp6atHcXfOpAYA/dPF9vdCiIa3OW7N03F5NuQvhKMiPRv7OuzP+ahpWxJcbaXkR4QQ+V1YL5JGmv8i2JvRyZGt/SoKWfC8cZ33Lo7BDrZhxT96vRnzT1vJZW6vsFbLMlZFqUw3vBELDUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=br/+EJxr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738172674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AvgUszk41nkDWz7o/qDLFKe7j0Xtk/wXXBraGwlaMug=;
	b=br/+EJxr7Y5Mu1ZkKYHW+0a0n68ZqS20OJ51iD4zpUBWlaEAqh/I9yPnNsiptqBlp1iRIb
	dLF0KqbpTv/7tDPMZ/Dmm2ucvCPznJ++T388+xWG+JrqbhA3bKc5q5CEIFsB2hTQ+Ci3GG
	glyqgr9UmsbqgP1ppScE1rRkIrJKK78=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-vPOW2uI9NVCJ7_eciZk6wQ-1; Wed, 29 Jan 2025 12:44:32 -0500
X-MC-Unique: vPOW2uI9NVCJ7_eciZk6wQ-1
X-Mimecast-MFC-AGG-ID: vPOW2uI9NVCJ7_eciZk6wQ
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-e586f6c6289so9670769276.1
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 09:44:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738172672; x=1738777472;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AvgUszk41nkDWz7o/qDLFKe7j0Xtk/wXXBraGwlaMug=;
        b=h+M7HJMABZ5r6+v0JLiPkW9FV7mI3/nGa2C59fQ0BfRmYxpE61Sqfva6YMlL0T9Edi
         qlk9gsF9S2ZyvJZr2iLMB2EOE3x4fsNMw2Z+uVcBmM+Pp3BQNYNWsiNP4I2PdFs1J78y
         fTB7zhfrSeTzU3ou3jdE9jeUlQM00OGh8YG7AIp3Zcy676phJEQ3cIuiyb0+Ijr/CToo
         7xXwZ5UbqAM7DjIUFT2XHDO9g5YCHpDyECdy+DlfYkrcqqULW15nN31+LNknEspDsVPE
         rRTD4bTvWuyBMVHafZEkk90dx06pyCoSvf9Fiv5+Y8fx6Bt3Mfi1JmTGKPtAnnzQmvan
         it9g==
X-Forwarded-Encrypted: i=1; AJvYcCWgieXLtnEmoK3G0fSGAjOQ3vqB33OrS3tOMeHsACZLFuztaoFM+Q1y4Gfg/MtTkeSIxeQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvqqdDlnUgQjPjgKV8N2f1dAxSli3w402UTSK8W/n5aCHwDbga
	zKmt9q0n7k5Ed3hs2L69B4G8iZfnqPf+mJjgzDPaQA9Av9DWnQPp7BzY3XqnQDJoS7tN3upNJRC
	47gBbNCuSSMmtNNBUt6Rez8XAyp5YmImP3vvAGRLLKyf7KOwCV4InYI/V2HPZ1aGX8DQz9XkRCz
	afCgpwYn81Al93UZ/bFMiAixmg
X-Gm-Gg: ASbGncsub8uheoaBIAJIIcXCdwiUDynDsXnHSbPUQ+zqqCzkS0VgChI6y2G718iHEf1
	6BdB8Un1vsJ4StI2sDjwVn/LR3gSJUJoOVTgx7IcovaGhGlsoKX0GdiOdzS1wZRc=
X-Received: by 2002:a05:690c:6f85:b0:6f5:3944:c726 with SMTP id 00721157ae682-6f7a834bbd3mr33241917b3.11.1738172672121;
        Wed, 29 Jan 2025 09:44:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE1ZgqO2ZYFZL0AUNRkowurFyg6L8O18hZ1EdDCylfT9QJU5trPnIGHCxiksuW62fCR2brpmmfhIDBezbc1nPY=
X-Received: by 2002:a05:690c:6f85:b0:6f5:3944:c726 with SMTP id
 00721157ae682-6f7a834bbd3mr33241397b3.11.1738172671648; Wed, 29 Jan 2025
 09:44:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVYE1Zcws=9hoO6+B+xB-hVWv38Dtu_LM8SysAmS4qRMw@mail.gmail.com>
In-Reply-To: <CAJSP0QVYE1Zcws=9hoO6+B+xB-hVWv38Dtu_LM8SysAmS4qRMw@mail.gmail.com>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Wed, 29 Jan 2025 18:44:20 +0100
X-Gm-Features: AWEUYZkcXPafEx1u8FOKvY918kij3TPHmMPR0ZoE_pAFlRUBOw1ltp8b0p_yirg
Message-ID: <CAGxU2F7oh+a7nZp9MLh67ghKtkwFvHRNqNvFqjgVhBhbe4HK2w@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: Rust-VMM Mailing List <rust-vmm@lists.opendev.org>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Richard Henderson <richard.henderson@linaro.org>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, "Daniel P. Berrange" <berrange@redhat.com>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, Alex Bennee <alex.bennee@linaro.org>, 
	Akihiko Odaki <akihiko.odaki@gmail.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Bibo Mao <maobibo@loongson.cn>, Jamin Lin <jamin_lin@aspeedtech.com>, 
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, 
	Fabiano Rosas <farosas@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Hanna Reitz <hreitz@redhat.com>
Content-Type: text/plain; charset="UTF-8"

+Cc rust-vmm ML, since in past years we have used QEMU as an umbrella
project for rust-vmm ideas for GSoC.

Thanks,
Stefano

On Tue, 28 Jan 2025 at 17:17, Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> Dear QEMU and KVM communities,
> QEMU will apply for the Google Summer of Code internship
> program again this year. Regular contributors can submit project
> ideas that they'd like to mentor by replying to this email by
> February 7th.
>
> About Google Summer of Code
> -----------------------------------------
> GSoC (https://summerofcode.withgoogle.com/) offers paid open
> source remote work internships to eligible people wishing to participate
> in open source development. QEMU has been doing internship for
> many years. Our mentors have enjoyed helping talented interns make
> their first open source contributions and some former interns continue
> to participate today.
>
> Who can mentor
> ----------------------
> Regular contributors to QEMU and KVM can participate as mentors.
> Mentorship involves about 5 hours of time commitment per week to
> communicate with the intern, review their patches, etc. Time is also
> required during the intern selection phase to communicate with
> applicants. Being a mentor is an opportunity to help someone get
> started in open source development, will give you experience with
> managing a project in a low-stakes environment, and a chance to
> explore interesting technical ideas that you may not have time to
> develop yourself.
>
> How to propose your idea
> ------------------------------
> Reply to this email with the following project idea template filled in:
>
> === TITLE ===
>
> '''Summary:''' Short description of the project
>
> Detailed description of the project that explains the general idea,
> including a list of high-level tasks that will be completed by the
> project, and provides enough background for someone unfamiliar with
> the code base to research the idea. Typically 2 or 3 paragraphs.
>
> '''Links:'''
> * Links to mailing lists threads, git repos, or web sites
>
> '''Details:'''
> * Skill level: beginner or intermediate or advanced
> * Language: C/Python/Rust/etc
>
> More information
> ----------------------
> You can find out about the process we follow here:
> Video: https://www.youtube.com/watch?v=xNVCX7YMUL8
> Slides (PDF): https://vmsplice.net/~stefan/stefanha-kvm-forum-2016.pdf
>
> The QEMU wiki page for GSoC 2024 is now available:
> https://wiki.qemu.org/Google_Summer_of_Code_2025
>
> What about Outreachy?
> -------------------------------
> We have struggled to find sponsors for the Outreachy internship
> program (https://www.outreachy.org/) in recent years. If you or your
> organization would like to sponsor an Outreachy internship, please get
> in touch.
>
> Thanks,
> Stefan
>



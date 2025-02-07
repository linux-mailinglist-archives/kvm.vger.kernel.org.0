Return-Path: <kvm+bounces-37586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE1B4A2C3F1
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 14:41:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E982516361A
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 13:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B4A71F4198;
	Fri,  7 Feb 2025 13:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J2ThI6xq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0621E98F4
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 13:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738935708; cv=none; b=ar4uLS/21CAOfEruktj+qrD7jg1R6lDT1rTRl8gfyzlCryx2hdwm0gM3XnKEYgnKFSRqjGmlinfrlmJN5Xc2jG8lWaYagJkRc/Pf4H/gbYnX7Ff4u3DMrCS0I1Q6VLk1Bh0OivfYtucNzww47cqgCPSnurccO7pmexooxrbyqeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738935708; c=relaxed/simple;
	bh=yevD9LZYnC7jtqiNZe+XKae1FcHbKwHVm4Z/4ibfqk4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rthl3BLMamz9WpQakKtaEsN//D9fep6OwUdZNBi/yVXTxykp3LH3mrS6B29OvXN5MxwG74jl7EywW7QUkx4O4izAR5lGZUpawxrh6N367OO3ANUTW/+SSa1udP9fJ1kIrUPPp5mY5EcDrD554x7Nw8Z5yyM3FKH5+Ww0TP7xSfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J2ThI6xq; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5d9837f201aso6085857a12.0
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 05:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738935705; x=1739540505; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yevD9LZYnC7jtqiNZe+XKae1FcHbKwHVm4Z/4ibfqk4=;
        b=J2ThI6xqYVFY6nu/ZrBN/SOfdylINlOFycYmmWxPjTIISL0J50nHhy+Nr72i9/xIN+
         WqAvYPHDqsnwFXg/JSQ86v0hHVHXboVcrtoux3R23nlpZ3KFWqqrIbopEbMbTMycvnTF
         mardT7uP3cKcF3qvrwvgB51yBjYETTt1v8hyTS1qeA4CUbHfTdUC4hQfeJdNTESU+LVG
         6UtTN0qAG3p9vD5Ejucix+CRsdixH54hijr7iWCCJlzeZHf84wv+8NtP87L9dMM9Ev1S
         Xxdj/qr9hbCQ++AwpT2vgkxES8eK5WMR1sL9I4/E7Evw0svRZ39hzY6zKi6W4Z0Oyjub
         zVeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738935705; x=1739540505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yevD9LZYnC7jtqiNZe+XKae1FcHbKwHVm4Z/4ibfqk4=;
        b=sQSuD7xkFTC79CemT3MeojIVONTMbYh9K4YBnnh9Mt1LzI7CKgdAMR0EJkztKcLtNq
         LEXJ4wkIXLZUkRb5bbIB0pzMU4h4W85iDRVhpg499lYu/jh4WsvXKY02lR9SJrkadLlN
         envojiccJNacyo2VanNgsOLXK2QDfkeCEzNRWz+MbjZKIjVjo993NruEV/6hHQkuN8pi
         hcFlF5qXE37ZIVlTrr1VgH4dIFSMGIhV2xd+pV/ejm9dKEz0iIhMYRV/h/W5JyJe7UeB
         WYLo9QuPpjPM4F2REyjRxvYaXy9rAA00uFHhXVAVDS5o9md5pz46rgTsM/OKiEcfeMXs
         PLpA==
X-Forwarded-Encrypted: i=1; AJvYcCUhYKDeL3DIprRNKNNtSNlZdD+FpW6TqSbAh2JlBCshazZEbFTUmExJj+vhwUoqGYmyggk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yylkwc55vIz1EQM8zSJjK8rgDWAQHHIlPWvY7HoFvKFH0WTJB+S
	b7WyJJFZrqfrrLjH9ArdKVXYOvUTtvnl/y0zAzbvYbNox5ItweMcnVD5kzKWksKOwnPOMwB3wpb
	L0ROx2hzKTxQuBc+m8VVHDjmMVQc=
X-Gm-Gg: ASbGncvFQi6+iiaJvj+f6Gilce+YDWsOujPnsEFv3x/wSE9obWjF+EDyQa4/gYztsDi
	3CbRPmNzoWzDa/sVnOAKbBC8NtBLk8xZUwGIXkUyet4+xlOp9hypJp5gKgq36nY8FwS4LfU4=
X-Google-Smtp-Source: AGHT+IH2B8/Fn6cb5AQQnDFCJMXfbJs5LBBUBoV7apHJflbGO/t6N9+a2MPeNrmbHXvaoogdv/LJnkWPUbqIbfqI2OA=
X-Received: by 2002:a05:6402:3491:b0:5d3:f1f7:c232 with SMTP id
 4fb4d7f45d1cf-5dcecd1703amr7897398a12.11.1738935704041; Fri, 07 Feb 2025
 05:41:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVYE1Zcws=9hoO6+B+xB-hVWv38Dtu_LM8SysAmS4qRMw@mail.gmail.com>
 <f3639df5-05cf-4aef-adfc-8a39ed7767ce@redhat.com>
In-Reply-To: <f3639df5-05cf-4aef-adfc-8a39ed7767ce@redhat.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Fri, 7 Feb 2025 08:41:31 -0500
X-Gm-Features: AWEUYZkawdYYeVMGzcyE7xtrfDTx0kuc1V3mY69xfNo6cCeH6NUX8nmwiAKSftM
Message-ID: <CAJSP0QUOzyqE16HL+QfXqQA3oZQ=4b=nt4_8JkoSSx5U_b7MsQ@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
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
	Stefano Garzarella <sgarzare@redhat.com>, German Maglione <gmaglione@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2025 at 7:35=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> w=
rote:
>
> On 28.01.25 17:16, Stefan Hajnoczi wrote:
> > Dear QEMU and KVM communities,
> > QEMU will apply for the Google Summer of Code internship
> > program again this year. Regular contributors can submit project
> > ideas that they'd like to mentor by replying to this email by
> > February 7th.
> >
> > About Google Summer of Code
> > -----------------------------------------
> > GSoC (https://summerofcode.withgoogle.com/) offers paid open
> > source remote work internships to eligible people wishing to participat=
e
> > in open source development. QEMU has been doing internship for
> > many years. Our mentors have enjoyed helping talented interns make
> > their first open source contributions and some former interns continue
> > to participate today.
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
> > ------------------------------
> > Reply to this email with the following project idea template filled in:
> >
> > =3D=3D=3D TITLE =3D=3D=3D
> >
> > '''Summary:''' Short description of the project
> >
> > Detailed description of the project that explains the general idea,
> > including a list of high-level tasks that will be completed by the
> > project, and provides enough background for someone unfamiliar with
> > the code base to research the idea. Typically 2 or 3 paragraphs.
> >
> > '''Links:'''
> > * Links to mailing lists threads, git repos, or web sites
> >
> > '''Details:'''
> > * Skill level: beginner or intermediate or advanced
> > * Language: C/Python/Rust/etc
>
> =3D=3D=3D Asynchronous request handling for virtiofsd =3D=3D=3D
>
> '''Summary:''' Make virtiofsd=E2=80=99s request handling asynchronous, al=
lowing
> single-threaded parallel request processing.
>
> virtiofsd is a virtio-fs device implementation, i.e. grants VM guests
> access to host directories. In its current state, it processes guest
> requests one by one, which means operations of long duration will block
> processing of others that could be processed more quickly.
>
> With asynchronous request processing, longer-lasting operations could
> continue in the background while other requests with lower latency are
> fetched and processed in parallel. This should improve performance
> especially for mixed workloads, i.e. one guest process executing
> longer-lasting filesystem operations, while another runs random small
> read requests on a single file.
>
> Your task is to:
> * Get familiar with a Linux AIO interface, preferably io_uring
> * Have virtiofsd make use of that interface for its operations
> * Make the virtiofsd request loop process requests asynchronously, so
> requests can be fetched and processed while others are continuing in the
> background
> * Evaluate the resulting performance with different workloads
>
> '''Links:'''
> * virtiofsd repository: https://gitlab.com/virtio-fs/virtiofsd
> * virtiofsd=E2=80=99s filesystem operations:
> https://gitlab.com/virtio-fs/virtiofsd/-/blob/main/src/passthrough/mod.rs=
#L1490
> * virtiofsd=E2=80=99s request processing loop:
> https://gitlab.com/virtio-fs/virtiofsd/-/blob/main/src/vhost_user.rs#L244
>
> '''Details:'''
> * Skill level: intermediate
> * Language: Rust
> * Mentors: Hanna Czenczek (hreitz@redhat.com), German Maglione
> (gmaglione@redhat.com)

Thanks, I have added your project idea to the list:
https://wiki.qemu.org/Google_Summer_of_Code_2025#Asynchronous_request_handl=
ing_for_virtiofsd

Do you want to give any guidance on which crate to use for
asynchronous I/O? Do you want async Rust (e.g. tokio) or not?

Stefan


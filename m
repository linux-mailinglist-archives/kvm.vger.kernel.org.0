Return-Path: <kvm+bounces-37588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9311FA2C422
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 14:53:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9283218898C2
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 13:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45AA71F55F8;
	Fri,  7 Feb 2025 13:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V/V42lt+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993AA2E64A
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 13:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738936419; cv=none; b=lmUZR9mbBcdhfX3N+7g5vwZmGIba+9N6C5Tv1eBeZiNg4rHquArXw7pbypcaZWj9DwizTxwQSeziqlO2rgUIgJGYTIws8cgdBrVx0KMn70W3T50Mej2nRnXI7mcLxCC+ulTr5c/Cxu+i0X4YaHyvMTuSO6FVMG4O/Pnmvq1ysj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738936419; c=relaxed/simple;
	bh=E/SQlSmR+u2yRmLwd3wbKD8romqX8XzsXvo5srL/sI4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a0M9HfzBPBA7pRhf2YIZpC6CoUVYkmbz+ZsStcQ/VVwlqgoMbqIlbJHmwacyL7n1LsGcj/7R9ypCrJBPLfeeuut0ejc4TZs/zVvleBbS5Jqm+ZcOHlp28xT5bxxT29VmLhSGNrghC70dd+HR6edf80w+KHOOevk86LCsHJNXdOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V/V42lt+; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5dce3c28889so4549634a12.0
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 05:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738936416; x=1739541216; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YtalgheXKmmwKmBzYHbvxnL6JBWnZc1Jj7kO28s2paA=;
        b=V/V42lt+1l9zCKBjA6p+rZ3ASnJBm8qnkrvak0hVRFk84avAA1WJnZOvE2qE3m1t3M
         44i4JFFCjlZk5k1xtZNlDhj4ue1RrBtR8tJPr4zeUfkHeUGTGZp6zkaU1DBbLFl67GaD
         ncbNHduOGPFt1f+Jq6gBSg1kuhHwujtwYgCov1ZQ/uw8PYQewRjaYVU7BqWhzUDMEi1s
         3XvyKrObqzNofCOCOFTySWoqv+6Te4iO+UOltourbQb3uUOEiWKCKC1dEUsgpAaLC+2R
         d4ONPnXTtMDLGeoRH5w+H7Rt/XUZiNYYZhoS6JyN6HEEkcw+JNN1j7pa5pBFfrYgnV9e
         s3uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738936416; x=1739541216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YtalgheXKmmwKmBzYHbvxnL6JBWnZc1Jj7kO28s2paA=;
        b=YXBnjUhoj7PnW0ltSqrUIVTSXHRwz2fzEFxixuHlAUBkJeXQQ+LHn/NqsegtF8QtCM
         XeBlNKEisIOC7yQk2QU3lXtbbxbK6M2rTiUGohGr7cnUF+AxFFR/Bz3FnejtnhS7NXeN
         nJEvh/r45FzopKzKwEGdxrEK8Lp3WzqqGQI5LmRlbG6aPbCHRIn3r1+P5gd/Z3Pk5rhp
         QWRCIeP1Ee91mrKyU5H0Lp1O9LXO2yGvN+wX1Wqpz3zWHQFBM9ZsTBxKDhdswXdQfvpv
         3mYZ9o47rSg/j+WStWz+136sDjfn2pvemDj8mwig6xpMJsAEqw/1RT0eAZnnk0hvb/NX
         gUeg==
X-Forwarded-Encrypted: i=1; AJvYcCWwSiTdpbQgD1JFTdMj32a2s72+JLO+vcdU1Sz0Hqc11RibouU020v9EtsuX6a5Fh6BpU4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLqj8XCXd6ogz/xyDizOy2kJi6/9cCMc2Fg0nAyGRQTW9lkxyb
	aH21Te8NdO/nYyFUbDgzMM6iV3Y+g+pGvuFPXiVDWr53OFDA05RxKS2JKnGke71aUWSWgF8jWSW
	N89ePJJwQp/ydhJxSg+m2uk17JMk=
X-Gm-Gg: ASbGnctR9Vm8loxkgE4R1YSzOmV/dEKlHfaYOxVBf+POw/TvV772EzMeyR0w39UIRuh
	4QSQncYSiBAtUL5BBxg1dh7zD81IPg60azcYAQD2+fGXJJ8Um6T/JDPfGpDj3u5ul2M8Zzwc=
X-Google-Smtp-Source: AGHT+IHhJ6EufNqZ9kksKQN32e85opCmp2dsk4tK7kNAAYdhEh4dZtkiAHMYtw76NJ5+s84Ws020zRy2m3FOAjkovQc=
X-Received: by 2002:a05:6402:27d1:b0:5de:4add:d52f with SMTP id
 4fb4d7f45d1cf-5de4adddbcemr2328072a12.32.1738936415541; Fri, 07 Feb 2025
 05:53:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVYE1Zcws=9hoO6+B+xB-hVWv38Dtu_LM8SysAmS4qRMw@mail.gmail.com>
 <f3639df5-05cf-4aef-adfc-8a39ed7767ce@redhat.com> <CAJSP0QUOzyqE16HL+QfXqQA3oZQ=4b=nt4_8JkoSSx5U_b7MsQ@mail.gmail.com>
 <0a85b381-35c4-424f-9052-7b321b1afe02@redhat.com>
In-Reply-To: <0a85b381-35c4-424f-9052-7b321b1afe02@redhat.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Fri, 7 Feb 2025 08:53:23 -0500
X-Gm-Features: AWEUYZmF04St9t2npau9CLpQvjQMuUNUa8P7KuOMPJcLIWtuOHWKqydUmhuez3A
Message-ID: <CAJSP0QWS5AVd=mDMqGkd__eNhh3pSaKu+_Hemc_Kis+b8E_veQ@mail.gmail.com>
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

On Fri, Feb 7, 2025 at 8:48=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> w=
rote:
>
> On 07.02.25 14:41, Stefan Hajnoczi wrote:
> > On Fri, Feb 7, 2025 at 7:35=E2=80=AFAM Hanna Czenczek <hreitz@redhat.co=
m> wrote:
> >> On 28.01.25 17:16, Stefan Hajnoczi wrote:
> >>> Dear QEMU and KVM communities,
> >>> QEMU will apply for the Google Summer of Code internship
> >>> program again this year. Regular contributors can submit project
> >>> ideas that they'd like to mentor by replying to this email by
> >>> February 7th.
> >>>
> >>> About Google Summer of Code
> >>> -----------------------------------------
> >>> GSoC (https://summerofcode.withgoogle.com/) offers paid open
> >>> source remote work internships to eligible people wishing to particip=
ate
> >>> in open source development. QEMU has been doing internship for
> >>> many years. Our mentors have enjoyed helping talented interns make
> >>> their first open source contributions and some former interns continu=
e
> >>> to participate today.
> >>>
> >>> Who can mentor
> >>> ----------------------
> >>> Regular contributors to QEMU and KVM can participate as mentors.
> >>> Mentorship involves about 5 hours of time commitment per week to
> >>> communicate with the intern, review their patches, etc. Time is also
> >>> required during the intern selection phase to communicate with
> >>> applicants. Being a mentor is an opportunity to help someone get
> >>> started in open source development, will give you experience with
> >>> managing a project in a low-stakes environment, and a chance to
> >>> explore interesting technical ideas that you may not have time to
> >>> develop yourself.
> >>>
> >>> How to propose your idea
> >>> ------------------------------
> >>> Reply to this email with the following project idea template filled i=
n:
> >>>
> >>> =3D=3D=3D TITLE =3D=3D=3D
> >>>
> >>> '''Summary:''' Short description of the project
> >>>
> >>> Detailed description of the project that explains the general idea,
> >>> including a list of high-level tasks that will be completed by the
> >>> project, and provides enough background for someone unfamiliar with
> >>> the code base to research the idea. Typically 2 or 3 paragraphs.
> >>>
> >>> '''Links:'''
> >>> * Links to mailing lists threads, git repos, or web sites
> >>>
> >>> '''Details:'''
> >>> * Skill level: beginner or intermediate or advanced
> >>> * Language: C/Python/Rust/etc
> >> =3D=3D=3D Asynchronous request handling for virtiofsd =3D=3D=3D
> >>
> >> '''Summary:''' Make virtiofsd=E2=80=99s request handling asynchronous,=
 allowing
> >> single-threaded parallel request processing.
> >>
> >> virtiofsd is a virtio-fs device implementation, i.e. grants VM guests
> >> access to host directories. In its current state, it processes guest
> >> requests one by one, which means operations of long duration will bloc=
k
> >> processing of others that could be processed more quickly.
> >>
> >> With asynchronous request processing, longer-lasting operations could
> >> continue in the background while other requests with lower latency are
> >> fetched and processed in parallel. This should improve performance
> >> especially for mixed workloads, i.e. one guest process executing
> >> longer-lasting filesystem operations, while another runs random small
> >> read requests on a single file.
> >>
> >> Your task is to:
> >> * Get familiar with a Linux AIO interface, preferably io_uring
> >> * Have virtiofsd make use of that interface for its operations
> >> * Make the virtiofsd request loop process requests asynchronously, so
> >> requests can be fetched and processed while others are continuing in t=
he
> >> background
> >> * Evaluate the resulting performance with different workloads
> >>
> >> '''Links:'''
> >> * virtiofsd repository: https://gitlab.com/virtio-fs/virtiofsd
> >> * virtiofsd=E2=80=99s filesystem operations:
> >> https://gitlab.com/virtio-fs/virtiofsd/-/blob/main/src/passthrough/mod=
.rs#L1490
> >> * virtiofsd=E2=80=99s request processing loop:
> >> https://gitlab.com/virtio-fs/virtiofsd/-/blob/main/src/vhost_user.rs#L=
244
> >>
> >> '''Details:'''
> >> * Skill level: intermediate
> >> * Language: Rust
> >> * Mentors: Hanna Czenczek (hreitz@redhat.com), German Maglione
> >> (gmaglione@redhat.com)
> > Thanks, I have added your project idea to the list:
> > https://wiki.qemu.org/Google_Summer_of_Code_2025#Asynchronous_request_h=
andling_for_virtiofsd
>
> Thanks!
>
> > Do you want to give any guidance on which crate to use for
> > asynchronous I/O? Do you want async Rust (e.g. tokio) or not?
>
> That would depend entirely on the student.  I=E2=80=99m open for async Ru=
st
> (tokio or even homegrown), but they could also decide they=E2=80=99d rath=
er do
> it in some different manner (e.g. with callbacks that would return
> descriptors to the guest).  I=E2=80=99ll add that info, if that=E2=80=99s=
 OK.

Sounds good.

Stefan


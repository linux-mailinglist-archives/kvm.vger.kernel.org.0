Return-Path: <kvm+bounces-37695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A2362A2F06B
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 15:56:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3DABB7A3398
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 14:54:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85C8E204867;
	Mon, 10 Feb 2025 14:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XO6TrwHS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3F91F8BC8
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 14:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739199321; cv=none; b=XoKS8yVvFdpZSQ/V1crzbS1yBy7VpHjsm6w9GIq5OpCJ3YnpvPeqt/4iqaUdDR77JaFxhZ6oExz/B4oqIphYglgbwg1FtxKpSm0/uoqf+w7dq78Ywp1dWYQmPX4iav3Ex4X6y55i8gPpncsJ5Yf/KCm+NsYYUwLwHDq/JsJoUuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739199321; c=relaxed/simple;
	bh=wGZLhGTmCwas2C4dLR9hGsz0EKJBCzBz4kRm8RQgZ2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ertfprbo52kSPSfRF7cNY73Wc/W4h2Bow4zEdCgMxlM602jXbSjhCFNyXlzJtyKcnu2Vivpu91d57tb386AjSAY8Zk4p/oS9MHxLQfJh3ceBcwOdF3jsSMrYFWmAdie/Xreibgwf/6yV6rxozzISEGOg/+PIzK0B4gtgHtesGXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XO6TrwHS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739199318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FpnWOWPEUPvBwbJvUaGay5WJ38UwPsGX1ZB/3JNKjuY=;
	b=XO6TrwHSry2eukz7IJ3FpLCOXSwpT9crnIFoD/jJfLm4sDHGxDpIUQAjt+3QkAInnASbsy
	q+RSmXzK2ts+QYUD0kEyL9DwMv49a2JU4JOTWUejs4kiV6OD7nK7BjB4XxvJMvhmi1g0Fm
	6Ex/nj0GNpBSaFZUXdPMb2zrMsvKkIY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-JPD9usqFP4SKFQlcHzZjpA-1; Mon, 10 Feb 2025 09:55:17 -0500
X-MC-Unique: JPD9usqFP4SKFQlcHzZjpA-1
X-Mimecast-MFC-AGG-ID: JPD9usqFP4SKFQlcHzZjpA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4392fc6bd21so8263155e9.1
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 06:55:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739199316; x=1739804116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FpnWOWPEUPvBwbJvUaGay5WJ38UwPsGX1ZB/3JNKjuY=;
        b=FimEeeeBpnGKykkrOKedLNbSQstnJuBlQaFIgai3QVEnmG/Iv9Szz0FR2/AEgK6i7A
         JUblWFn+bINatpV5EwVAJuiomBmwIE4pkeqzu5CAtsdZ9XSD6pC6WmzCqvzvEe/Jzfxf
         vO+OWi0pQSm5UghIE0kN2byrThkkqiQzuT1yHbch9EMuklqom0N864/9JTZvNdn3B710
         DO+vlQElsCmaKB+M+Ohom6cwRtK3u6CmMunCMGJJTPOCJYfWZ2V8318Tn43Zw/loAddE
         DzAQc1cl6Z9ZrHQLi90YnChDTTUuw1QPgyBaDFv3zzM2TIHfp0gX3TW7pGZe0M0ZoaVc
         U6JQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEkGriHwrhcRpNgCtXW7GZ818vdM62AN0quQzMrQjpo7t2a/vbQLizaGfTRQbH8FCgl70=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPnnUzvFRT0CLs2zDOfaJBAufEyZaoerwV+pl3ADxXjZlhmIZe
	x7CzJ9F++iZpbKyGbUypOUvEWH5e1eCBl92/0BUjbL1CXqw5WiY0cB8Ng12gCjOJf4IG6UrUJN2
	hr6XGOvSh9qQgtZHvIX2X0tP+q3SZfgp/8ena1CeQNPaZew+D3A==
X-Gm-Gg: ASbGncv4HLicpmCE4Q25b1tFRmlDy9qD4xOPKj7U0KS/dqkrKfeNjW7cSCmV+xBCJj6
	liGmPBc4AIuYRzQFHuy9YAewpKy/VITyRM2onGYZTTiIyPGP5WyHqj1r8/n4g17F0EAPJQtZSe3
	X8cA8Ge5pwgx0CKKx2LvI94ZHLt9dD5cw7kIEhfK6x29VEmN7u7YytHWpXeFcsoZTMpOEAcm1ET
	/DP+X+2iCn0kmoh3A4YzrouJmzqNE5a+CirFTC611uVzHjB1iw/nAcLkpUG5iy4SxLkHgzaWkEs
	y4vNF1C6KciJpjlFjwnzULhNtYHQpiXYac68bpSD7PvEfwxo5RIWrg==
X-Received: by 2002:a05:600c:468e:b0:439:47dc:e383 with SMTP id 5b1f17b1804b1-43947dce501mr26688265e9.12.1739199315994;
        Mon, 10 Feb 2025 06:55:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHye52RagamrPb2qBwPmsx0NeC9lhy00tq28FyXcEeKzgvbmb9HS4KAS2R6WgeVH+4xIt3mDQ==
X-Received: by 2002:a05:600c:468e:b0:439:47dc:e383 with SMTP id 5b1f17b1804b1-43947dce501mr26687745e9.12.1739199315220;
        Mon, 10 Feb 2025 06:55:15 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-29.retail.telecomitalia.it. [79.46.200.29])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4394328fcb8sm38662665e9.32.2025.02.10.06.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 06:55:14 -0800 (PST)
Date: Mon, 10 Feb 2025 15:55:09 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Stefan Hajnoczi <stefanha@gmail.com>, 
	German Maglione <gmaglione@redhat.com>
Cc: Rust-VMM Mailing List <rust-vmm@lists.opendev.org>, 
	qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Richard Henderson <richard.henderson@linaro.org>, Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, 
	Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, "Daniel P. Berrange" <berrange@redhat.com>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, Alex Bennee <alex.bennee@linaro.org>, 
	Akihiko Odaki <akihiko.odaki@gmail.com>, Zhao Liu <zhao1.liu@intel.com>, Bibo Mao <maobibo@loongson.cn>, 
	Jamin Lin <jamin_lin@aspeedtech.com>, =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>, 
	Fabiano Rosas <farosas@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Hanna Reitz <hreitz@redhat.com>
Subject: Re: Call for GSoC internship project ideas
Message-ID: <CAGxU2F6mP7KfytKUQSoqvbmLyR2DRDVdmT1Gtyq=gOFv69CDXw@mail.gmail.com>
References: <CAJSP0QVYE1Zcws=9hoO6+B+xB-hVWv38Dtu_LM8SysAmS4qRMw@mail.gmail.com>
 <CAGxU2F7oh+a7nZp9MLh67ghKtkwFvHRNqNvFqjgVhBhbe4HK2w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F7oh+a7nZp9MLh67ghKtkwFvHRNqNvFqjgVhBhbe4HK2w@mail.gmail.com>

Hi Stefan,
Sorry for the delay, I attach a proposal!

On Wed, 29 Jan 2025 at 18:44, Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> +Cc rust-vmm ML, since in past years we have used QEMU as an umbrella
> project for rust-vmm ideas for GSoC.
>
> Thanks,
> Stefano
>
> On Tue, 28 Jan 2025 at 17:17, Stefan Hajnoczi <stefanha@gmail.com> wrote:
> >
> > Dear QEMU and KVM communities,
> > QEMU will apply for the Google Summer of Code internship
> > program again this year. Regular contributors can submit project
> > ideas that they'd like to mentor by replying to this email by
> > February 7th.
> >
> > About Google Summer of Code
> > -----------------------------------------
> > GSoC (https://summerofcode.withgoogle.com/) offers paid open
> > source remote work internships to eligible people wishing to participate
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


=== vhost-user devices in Rust on macOS and *BSD ===

'''Summary:''' Extend rust-vmm crates to support vhost-user devices 
running on POSIX system like macOS and *BSD

VIRTIO devices can be emulated in an external process to QEMU thanks to 
the vhost-user protocol, which allows QEMU to offload the entire 
emulation to a daemon. This is done through an AF_UNIX socket used as a 
control path between the frontend (i.e. QEMU) and the backend (i.e. the 
vhost-user daemon). QEMU will share guest memory with the daemon, 
provide all the information for data path setup, and notification 
mechanisms.

Moving the emulation of VIRTIO devices to a separate process from QEMU 
offers significant advantages, primarily in terms of safety, if a device 
crashes, we can restart it without affecting QEMU. Additionally, this 
approach simplifies updating device implementations, allows development 
in other languages (such as Rust as we do in the rust-vmm community), 
and enhances isolation through seccomp, cgroups, and similar mechanisms.

The rust-vmm community already provides several crates (e.g. vhost, 
vhost-user-backend, etc.) to implement a vhost-user backend in an 
external daemon. For example, these crates are used by virtiofsd 
(virtio-fs vhost-user device) but also by all vhost-user devices 
maintained by the rust-vmm community in the rust-vmm/vhost-device 
workspace. These crates work great on Linux, but unfortunately they use 
some Linux-specific system calls such as epoll(7) and eventfd(2) that 
make them impossible to use on other POSIX systems.

The goal of this project is to make sure that we can use rust-vmm's 
vhost and vhost-user-backend crates on other POSIX systems besides 
Linux. If time permits, we could also fix up simple devices such as 
vhost-device-console or vhost-device-vsock to run on any POSIX systems.

'''Tasks:'''
* Becoming familiar with QEMU and vhost-user devices
* Run QEMU with a vhost-user device on macOS or FreeBSD/OpenBSD as 
covered in the FOSDEM 2025 talk
* Analyze rust-vmm crates (vmm-sys-util, vhost, vhost-user-backend) to 
understand which components are Linux-specific
* Replace epoll(7) with alternatives such as 
https://github.com/smol-rs/polling
* Automatic fallback to pipe()/pipe2() if eventfd(2) is not available as 
QEMU already does
* Handle any other cases discovered during the analysis
* Adapt a simple device such as vhost-device-console or 
vhost-device-vsock to test that everything works on macOS or 
FreeBSD/OpenBSD

'''Links:'''
* FOSDEM 2025 talk: [https://fosdem.org/2025/schedule/event/fosdem-2025-5100-can-qemu-and-vhost-user-devices-be-used-on-macos-and-bsd-/ Can QEMU and vhost-user devices be used on macOS and *BSD?]
* [https://qemu-project.gitlab.io/qemu/interop/vhost-user.html vhost-user spacification]
* [https://patchew.org/QEMU/20240618100043.144657-1-sgarzare@redhat.com/ QEMU series to support vhost-user on any POSIX]
* [https://gitlab.com/sgarzarella/qemu/-/tree/macos-vhost-user sgarzare's tree where to find some missing QEMU patches]
* [https://github.com/rust-vmm/vhost rust-vmm vhost & vhost-user-backend crates]
* [https://github.com/rust-vmm/vmm-sys-util rust-vmm vmm-sys-util crate]
* [https://github.com/rust-vmm/vhost-device rust-vmm vhost-device workspace]
* [https://gitlab.com/virtio-fs/virtiofsd virtio-fs vhost-user device]
* [https://github.com/rust-vmm/vhost/issues/110 Mac build support #110 - rust-vmm/vhost]
* [https://gitlab.com/virtio-fs/virtiofsd/-/issues/169 Add macOS support #169 - virtio-fs/virtiofsd]

'''Details:'''
* Project size: 350 hours
* Skill level: intermediate
* Language: Rust
* Mentors: Stefano Garzarella <sgarzare@redhat.com>, German Maglione 
<gmaglione@redhat.com>


Thanks,
Stefano



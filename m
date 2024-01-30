Return-Path: <kvm+bounces-7476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE4D684248A
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 13:11:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A45FFB290B3
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 12:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82E0867E6A;
	Tue, 30 Jan 2024 12:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zwt9gfZz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A656773D
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 12:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706616580; cv=none; b=a8z+uwYmatznLYAa5I8c1UIvwldtV96UWTR83XO/YMLQlF7al0OqzhULnE3zCxOfpQfy8SA6LlVtmMsvpqbNtVnRnQH+xUzvSz4Ocvl925gmTgm/CoVsXxSgi+8vFjpiAJkbEAQuar8PvXQdAybSEgjc6jS/w8ZgSXBiIzpzEzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706616580; c=relaxed/simple;
	bh=weD+the6P/YGsb581YptEdJXrN2BVcNlkR6AsE3kIes=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DJKLGuwRACfjHlOvZRqN62RSiRg0RwEHd+JRSRNkJJx0tkuqmoBC0fmeAKdo3tI5niBLei6koeFqguD92/dFIwOTkwbEoFCw9Q1v6M/MpdTqDd2E+8l1u/cFcayl1B5UIkek1RidjzEmjcg3xp2qxNvZyceS8ClVI11fu5fQBa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zwt9gfZz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706616577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=weD+the6P/YGsb581YptEdJXrN2BVcNlkR6AsE3kIes=;
	b=Zwt9gfZzM313+VCraSHyU0J6fRqEhvN2DePhQFeYNz87FaPi8xE+5rt1Rxqg9crssZm0w7
	wpE+f6dRvfjSMECW8Oh5jHjfgkLKNstiCpYbmB06Rdphz9m1CPTY3/JOvtVS1lJNnBs5Xl
	nrmQp8v6huBML0UuOnCDUXAx4xPPTLk=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-DwCymZJOOLqpz5jKYsZK_Q-1; Tue, 30 Jan 2024 07:09:36 -0500
X-MC-Unique: DwCymZJOOLqpz5jKYsZK_Q-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-5ff817c96a5so68284707b3.3
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 04:09:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706616575; x=1707221375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=weD+the6P/YGsb581YptEdJXrN2BVcNlkR6AsE3kIes=;
        b=KbAIq06HVFNHxGVGPkjcmaQ9glF+Q5Is8ZxogfXmywtChXDZPi1yRhn6eUwNAA8NVu
         DGDiV7TmqeHlo1OSXLGf8mT3CrUCKw+mgawV7fWrNd85XVuST3FQI0+mgxBjYT87BHIx
         +SWm7Hh4az0uy4Di84z1qiq8Z+84Kl0B5OZfpCp4UMYJ49cLN3zMS43F+TbL3G+Iqy10
         adR9PDQ8CljoUmpRQVusrB1D9UrrtRNqR/wWXeMJfwiiamxDf5CelB67CEkpMus8OD5v
         szLrv7NhBrrUzL8L4ZgBTBHQvF2ljecT00Qit85HCIWste7IVdNPwYhLV16DLI6gZNfH
         VybQ==
X-Gm-Message-State: AOJu0YxBeYS8gqIV3P76FhcaS5av9V/5yevoaCEa1nAP6X+efQCuZmbU
	Fa/NTBVgWIKExl+tm65TSKGJphPerMCu+cUVi0ZHe3t4Tq1pdI1gP42tzyXjUubNlSXPrLe9jLM
	/pwD6ITZ6KOjXJ8yH+3355JduZOsgLY1g9xiZ1bcP/RH6f9bwFWws2lsX12i9ltUyDK82YqMvg+
	7Pkz55UWtRoOzpk80fX6UNzzzo
X-Received: by 2002:a05:690c:448c:b0:5ff:af99:54f2 with SMTP id gr12-20020a05690c448c00b005ffaf9954f2mr7002659ywb.50.1706616575491;
        Tue, 30 Jan 2024 04:09:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEuvm/Fsb++wzRmvzrvL6YuxtDMI6YLt0w48tsCmlNHGEpn9QBEzXOXTK4aWDJa2FGczp87hgJ+53pkUnS7SN0=
X-Received: by 2002:a05:690c:448c:b0:5ff:af99:54f2 with SMTP id
 gr12-20020a05690c448c00b005ffaf9954f2mr7002633ywb.50.1706616575171; Tue, 30
 Jan 2024 04:09:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QX9TQ-=PD7apOamXvGW29VwJPfVNN2X5BsFLFoP2g6USg@mail.gmail.com>
 <CAJaqyWdMNP3V=JL6C8SSbXV5AP_2O9SNJLUS+Go7AjVsrT1FdQ@mail.gmail.com> <CAJSP0QXMJiRQFJh6383tnCOXyLwAbBYM7ff-mtregO3MKAEC1A@mail.gmail.com>
In-Reply-To: <CAJSP0QXMJiRQFJh6383tnCOXyLwAbBYM7ff-mtregO3MKAEC1A@mail.gmail.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 30 Jan 2024 13:08:59 +0100
Message-ID: <CAJaqyWeKrjjMyRXo1LK4_2Q=HYKqd=omjDJ+by_=do9ppdCk3w@mail.gmail.com>
Subject: Re: Call for GSoC/Outreachy internship project ideas
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Alberto Faria <afaria@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	German Maglione <gmaglione@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	"Richard W.M. Jones" <rjones@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Warner Losh <imp@bsdimp.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Daniel Henrique Barboza <danielhb413@gmail.com>, Song Gao <gaosong@loongson.cn>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>, Bernhard Beschow <shentey@gmail.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 29, 2024 at 8:40=E2=80=AFPM Stefan Hajnoczi <stefanha@gmail.com=
> wrote:
>
> On Mon, 29 Jan 2024 at 13:53, Eugenio Perez Martin <eperezma@redhat.com> =
wrote:
> >
> > On Mon, Jan 15, 2024 at 5:33=E2=80=AFPM Stefan Hajnoczi <stefanha@gmail=
.com> wrote:
> > >
> > > Dear QEMU and KVM communities,
> > > QEMU will apply for the Google Summer of Code and Outreachy internshi=
p
> > > programs again this year. Regular contributors can submit project
> > > ideas that they'd like to mentor by replying to this email before
> > > January 30th.
> > >
> >
> >
> > =3D=3D=3D Add packed virtqueue to Shadow Virtqueue =3D=3D=3D
>
> Yes! I'm a fan of packed virtqueues, so I'm excited to see this project i=
dea :).
>

It's about time! :).


> > Summary: Add the packed virtqueue format support to QEMU's Shadow Virtq=
ueue.
> >
> > To perform a virtual machine live migration with an external device to
> > qemu, qemu needs a way to know which memory the device modifies so it
> > is able to resend it. Otherwise the guest would resume with invalid /
> > outdated memory in the destination.
> >
> > This is especially hard with passthrough hardware devices, as
> > transports like PCI imposes a few security and performance challenges.
> > As a method to overcome this for virtio devices, qemu can offer an
> > emulated virtqueue to the device, called Shadow Virtqueue (SVQ),
> > instead of allowing the device to communicate directly with the guest.
> > SVQ will then forward the writes to the guest, being the effective
> > writer in the guest memory and knowing when a portion of it needs to
> > be resent.
> >
> > Compared with original Split Virtqueues, already supported by Shadow
> > Virtqueue, Packed virtqueue is a more compact representation that uses
> > less memory size and allows both devices and drivers to exchange the
> > same amount of information with less memory operations.
> >
> > The task is to complete the packed virtqueue support for SVQ, using
> > the kernel virtio ring driver as a reference. There is already a setup
> > that can be used to test the changes.
> >
> > Links:
> > * https://www.redhat.com/en/blog/virtio-devices-and-drivers-overview-he=
adjack-and-phone
> > * https://www.redhat.com/en/blog/virtqueues-and-virtio-ring-how-data-tr=
avels
> > * https://www.redhat.com/en/blog/packed-virtqueue-how-reduce-overhead-v=
irtio
> > * https://www.youtube.com/watch?v=3Dx9ARoNVzS04
> >
> > Details:
> > * Skill level: Intermediate
> > * Language: C
>
> I have added this project idea to the wiki. I made minor edits (e.g.
> consistently using "guest" instead of both "virtual machine" and
> "guest" to minimize the amount of terminology). I also added a link to
> the vhost-shadow-virtqueue.c source code so applicants have a starting
> point for researching the code.
>
> https://wiki.qemu.org/Internships/ProjectIdeas/PackedShadowVirtqueue
>

Good points, thank you very much!

> Please edit the page to clarify the following:
> - Project size: 90 (small), 175 (medium), or 350 (large) hours
> - A list of suggested tasks for the coding period that applicants can
> research and refine for their project plan
>
> Possible stretch goals if the intern completes packed svq support
> early or maybe you have your own ideas:
> - Split/rename vhost-shadow-virtqueue.c into a VIRTIO driver-side
> virtqueue API (which could be used by any other feature that acts as a
> VIRTIO driver, like vhost-user clients) and shadow virtqueue logic
> - Implement packed virtqueue support in other components where it is
> not yet supported (like kernel vhost)
>

Added, good ideas! Please let me know if you think something should be
further corrected or feel free to modify yourself.

Thanks!



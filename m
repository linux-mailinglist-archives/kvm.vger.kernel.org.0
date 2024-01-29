Return-Path: <kvm+bounces-7390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2CD18413A8
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 20:40:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52BAD1F22BE2
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 19:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E317D4CB3D;
	Mon, 29 Jan 2024 19:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MsqJbbCv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFF74CB24
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 19:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706557201; cv=none; b=afPlQZ/RbMgNANS4c45mLLAWdCZtv2jFmp+qybbS3Elrm3P9AvNvUrBgo/k/13BzDVa/XOeCHhDywFNKWANKAVWrz5pMZmQ0vkfnz01ETR6f45tBSHZBKO+JsYDo9PxLLm8an3SwQdd9gWn5rdfA0wkTIUjCdUMcvzgLAs4mbsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706557201; c=relaxed/simple;
	bh=zEICr1QmXRFmGfhgJTC8MTvyADukMO2VuiYXvG5FET8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IdBZKky2vJdlaGWMRtKejUiV48NkFLHVnhDpHcwpfTLvBk6Rc5EsEHfAqvqXrHLF+0Cs0d51XK2MSzQLyaoe2QPwK52MqRZ2kAh3qBdws+rrtW8wJ9NbGm18n+rtRKXbP0lF5dv1WYJ5qwKLfKtefgDUGqW7Qr++EM8JKMcrRgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MsqJbbCv; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-214dbe25f8aso1476231fac.3
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 11:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706557198; x=1707161998; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zEICr1QmXRFmGfhgJTC8MTvyADukMO2VuiYXvG5FET8=;
        b=MsqJbbCvHw737tS9uFAdDdyv2fB8PEJE0GlMS7bF8TAXPXLKpj5LbBoVlwsd8bDNQ8
         J+tKZKPshHIY9Y6mjuEJWkU3PJ6WvuHQC4JS6Kd+DQXqXBSl6bTXHUyLEoeb53DVMj9q
         V8g56BIg0tymVBw2KcC3Lq0h6ooxOnG1izY23Hdx61eCCs6Qft2avc33pFDFI7j8HsZC
         PRPeuTYg6JE5Lb0n7zCpMTmqMPN/7dNp4h0hNRj+odMXZP+8mdaq5T1wmTh6mR9a4aTF
         BicyuVbjghNCPpQ5hsQQka+FU0R6nRV6DBOjBrGQ9EbC3Mow4/VJVEcLh5bfpMxiUDmd
         80vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706557198; x=1707161998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zEICr1QmXRFmGfhgJTC8MTvyADukMO2VuiYXvG5FET8=;
        b=G8ckvTVWILXSOuLyS06Q+3NC7PQCtbV5zFK8/SZ6Z+K1Im4trC3kPL4Jyy1KFSBxlB
         BDq5ocukWvbt5Q4P+KkFzH8tMIAkid1f5ZgG0JpG1JpwSTWkOR9bcukWRGkQoJE9BYxR
         EEaMEF4VkWznk8JvYTcVWfYS4InlfsmwYKKjXqmOSTCUDB+CK2EI0kmdiLYmOJaDX/KX
         MBwWj65K3CzK+4FuTu/N6dNX0qrjxtwU11CMweCRSMGKHV3o3CxwZ+2uVNGTmGJWT0mN
         VyOlpBphump7f3peVzG2hDYxXzTL80R/FXal9bFdPjyjjLD0D7/vWKK2b7Y2EjJBvBeH
         9UJw==
X-Gm-Message-State: AOJu0YzfVCOEOUdgAcaqLABi7TP55lv7InX4+rz2WNqgL+b6a56iTabD
	1c/4Wg/w9IdgGymf779LsiTT8Vmw6AXi1K+Z3//uVjACLsUXMkiO5Gds07hFVYdbUgLoMXEADyK
	3X6blNxqCMxtv2a2B9gbRwsPAZJk=
X-Google-Smtp-Source: AGHT+IGrqlz3fxhPT8BNhS56XLZfowmZNWfb6WVzUXdMMpDIIupZxON6sLvwqAbUGsBHFsIUXDgnRRjBZyFAaFLq7Yo=
X-Received: by 2002:a05:6870:4341:b0:218:6ff5:a190 with SMTP id
 x1-20020a056870434100b002186ff5a190mr4369413oah.39.1706557198088; Mon, 29 Jan
 2024 11:39:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QX9TQ-=PD7apOamXvGW29VwJPfVNN2X5BsFLFoP2g6USg@mail.gmail.com>
 <CAJaqyWdMNP3V=JL6C8SSbXV5AP_2O9SNJLUS+Go7AjVsrT1FdQ@mail.gmail.com>
In-Reply-To: <CAJaqyWdMNP3V=JL6C8SSbXV5AP_2O9SNJLUS+Go7AjVsrT1FdQ@mail.gmail.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Mon, 29 Jan 2024 14:39:45 -0500
Message-ID: <CAJSP0QXMJiRQFJh6383tnCOXyLwAbBYM7ff-mtregO3MKAEC1A@mail.gmail.com>
Subject: Re: Call for GSoC/Outreachy internship project ideas
To: Eugenio Perez Martin <eperezma@redhat.com>
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

On Mon, 29 Jan 2024 at 13:53, Eugenio Perez Martin <eperezma@redhat.com> wr=
ote:
>
> On Mon, Jan 15, 2024 at 5:33=E2=80=AFPM Stefan Hajnoczi <stefanha@gmail.c=
om> wrote:
> >
> > Dear QEMU and KVM communities,
> > QEMU will apply for the Google Summer of Code and Outreachy internship
> > programs again this year. Regular contributors can submit project
> > ideas that they'd like to mentor by replying to this email before
> > January 30th.
> >
>
>
> =3D=3D=3D Add packed virtqueue to Shadow Virtqueue =3D=3D=3D

Yes! I'm a fan of packed virtqueues, so I'm excited to see this project ide=
a :).

> Summary: Add the packed virtqueue format support to QEMU's Shadow Virtque=
ue.
>
> To perform a virtual machine live migration with an external device to
> qemu, qemu needs a way to know which memory the device modifies so it
> is able to resend it. Otherwise the guest would resume with invalid /
> outdated memory in the destination.
>
> This is especially hard with passthrough hardware devices, as
> transports like PCI imposes a few security and performance challenges.
> As a method to overcome this for virtio devices, qemu can offer an
> emulated virtqueue to the device, called Shadow Virtqueue (SVQ),
> instead of allowing the device to communicate directly with the guest.
> SVQ will then forward the writes to the guest, being the effective
> writer in the guest memory and knowing when a portion of it needs to
> be resent.
>
> Compared with original Split Virtqueues, already supported by Shadow
> Virtqueue, Packed virtqueue is a more compact representation that uses
> less memory size and allows both devices and drivers to exchange the
> same amount of information with less memory operations.
>
> The task is to complete the packed virtqueue support for SVQ, using
> the kernel virtio ring driver as a reference. There is already a setup
> that can be used to test the changes.
>
> Links:
> * https://www.redhat.com/en/blog/virtio-devices-and-drivers-overview-head=
jack-and-phone
> * https://www.redhat.com/en/blog/virtqueues-and-virtio-ring-how-data-trav=
els
> * https://www.redhat.com/en/blog/packed-virtqueue-how-reduce-overhead-vir=
tio
> * https://www.youtube.com/watch?v=3Dx9ARoNVzS04
>
> Details:
> * Skill level: Intermediate
> * Language: C

I have added this project idea to the wiki. I made minor edits (e.g.
consistently using "guest" instead of both "virtual machine" and
"guest" to minimize the amount of terminology). I also added a link to
the vhost-shadow-virtqueue.c source code so applicants have a starting
point for researching the code.

https://wiki.qemu.org/Internships/ProjectIdeas/PackedShadowVirtqueue

Please edit the page to clarify the following:
- Project size: 90 (small), 175 (medium), or 350 (large) hours
- A list of suggested tasks for the coding period that applicants can
research and refine for their project plan

Possible stretch goals if the intern completes packed svq support
early or maybe you have your own ideas:
- Split/rename vhost-shadow-virtqueue.c into a VIRTIO driver-side
virtqueue API (which could be used by any other feature that acts as a
VIRTIO driver, like vhost-user clients) and shadow virtqueue logic
- Implement packed virtqueue support in other components where it is
not yet supported (like kernel vhost)

Stefan


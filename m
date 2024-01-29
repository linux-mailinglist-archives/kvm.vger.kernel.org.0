Return-Path: <kvm+bounces-7385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1148C8412C1
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 19:53:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD774286E72
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 18:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3576314AAA;
	Mon, 29 Jan 2024 18:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RjYs9mDv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BE446A0
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 18:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706554426; cv=none; b=H8oraFDC4ygPBfbYXXcDwfJyiaRm69FCh5fHo53W5Fgll+4PXv0bxyFfH/byUI/ze1G0Z/P2VwmraEJiU/tcVvRMRkbSpasEnNq8+WucHFod3XmmRZkQ8sTkzxCDsN7nC4kw5a/fND5WIowBsctzAk8AGMudQKPIJKjrfpKkC1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706554426; c=relaxed/simple;
	bh=CNWB/ajDc7ZxXIARdz0w+/Ja27yu2wtNUORHpJEA5kU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UKLOWVz51ViZKGK8BIeCduMvPEHAkufAF0EoSePrQPv0Sg8pEiLPCeF+hqQdVq0EN/2S4GeV9LYeo68/08d86RRAohcibfmoGZfVwsx/4QKfagH0qPNPLXpcCcGC9QV3zj7Sol4EgQhXaJ328gz97fNOBy7PRlMoXfbkceEcHbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RjYs9mDv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706554423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CNWB/ajDc7ZxXIARdz0w+/Ja27yu2wtNUORHpJEA5kU=;
	b=RjYs9mDvQmJmlFF4VxXI8iOo/4JjuCkM08oPSvAurgA4Oob8IaAIepCrajQb7Uxv7bDDV6
	s8CEDeviBl88a83aAWqLSqceDvfxrLCJq95NktzlLePznzHotzpaAQ+ag0x88vozggz8EF
	tMndyiKMlkrdEOl0Nry3iO+KgU4DiZU=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-NKBUuitlPEKkbR2K6zU-BA-1; Mon, 29 Jan 2024 13:53:41 -0500
X-MC-Unique: NKBUuitlPEKkbR2K6zU-BA-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-5efe82b835fso62720337b3.0
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 10:53:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706554419; x=1707159219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CNWB/ajDc7ZxXIARdz0w+/Ja27yu2wtNUORHpJEA5kU=;
        b=V/mzWQXWmTEDTTXQEIMSCePQ09yuEgp172TX7rBiFLdouzVQuCk/Pxg7AJwHyV7uxz
         8Ps8/GSy+WMCXVlCyiydHTcZCdT9av4r7+dNhHoVeGxevkGAk7CRq4MLlRA04t6dFqFo
         NlUwSnTer6TygheCwmuN+Gac8B+sdqUMY9BKjIDO6X122Aahxyefqmbh6yBX26Ph8vlN
         uWPO3I86V82aGQ9x0GB3b4j2gRKjF3LXMTeIFUjeMWHhwRApvHgSqG2fOMzz5+9WKc+v
         BFO+qJlE7XpkLiso8VWdhi1j+t7mYvrxn1KJ9N/woVQMcfpz/hGvkrKsjFt2vpoVZiQU
         ozKA==
X-Gm-Message-State: AOJu0Yxg0MXkm5+rSiTUH0fSEKRNHXPtqwx0wtQ6JZlrD++41kO4ulfU
	xBLCSGmezvGQhn1deZk5dJNYP+SfeKJalGJ2lKNT+3C+hLdEZK5KRVN1v6Mcjm9CAwxMEpeFslj
	5ab+WE937QqbrL2ex+zrK9HTrv9S8zag44CkGV4rtlujUDuvE0ME61N6buTADUFKHGp2jj5UkAZ
	kS2daEth1n6eC57/VuklwHEcCv
X-Received: by 2002:a0d:cb10:0:b0:5f8:9b55:98e6 with SMTP id n16-20020a0dcb10000000b005f89b5598e6mr5128331ywd.105.1706554419359;
        Mon, 29 Jan 2024 10:53:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG7RbUJu6LGvnDDP0G95gDqnmecPeCtTyTnmn3FAjoF8sMshgZEgFW3ejA/oSLugXuXfj3wFR52wT3NwVR/ylU=
X-Received: by 2002:a0d:cb10:0:b0:5f8:9b55:98e6 with SMTP id
 n16-20020a0dcb10000000b005f89b5598e6mr5128314ywd.105.1706554419122; Mon, 29
 Jan 2024 10:53:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QX9TQ-=PD7apOamXvGW29VwJPfVNN2X5BsFLFoP2g6USg@mail.gmail.com>
In-Reply-To: <CAJSP0QX9TQ-=PD7apOamXvGW29VwJPfVNN2X5BsFLFoP2g6USg@mail.gmail.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 29 Jan 2024 19:53:02 +0100
Message-ID: <CAJaqyWdMNP3V=JL6C8SSbXV5AP_2O9SNJLUS+Go7AjVsrT1FdQ@mail.gmail.com>
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

On Mon, Jan 15, 2024 at 5:33=E2=80=AFPM Stefan Hajnoczi <stefanha@gmail.com=
> wrote:
>
> Dear QEMU and KVM communities,
> QEMU will apply for the Google Summer of Code and Outreachy internship
> programs again this year. Regular contributors can submit project
> ideas that they'd like to mentor by replying to this email before
> January 30th.
>


=3D=3D=3D Add packed virtqueue to Shadow Virtqueue =3D=3D=3D
Summary: Add the packed virtqueue format support to QEMU's Shadow Virtqueue=
.

To perform a virtual machine live migration with an external device to
qemu, qemu needs a way to know which memory the device modifies so it
is able to resend it. Otherwise the guest would resume with invalid /
outdated memory in the destination.

This is especially hard with passthrough hardware devices, as
transports like PCI imposes a few security and performance challenges.
As a method to overcome this for virtio devices, qemu can offer an
emulated virtqueue to the device, called Shadow Virtqueue (SVQ),
instead of allowing the device to communicate directly with the guest.
SVQ will then forward the writes to the guest, being the effective
writer in the guest memory and knowing when a portion of it needs to
be resent.

Compared with original Split Virtqueues, already supported by Shadow
Virtqueue, Packed virtqueue is a more compact representation that uses
less memory size and allows both devices and drivers to exchange the
same amount of information with less memory operations.

The task is to complete the packed virtqueue support for SVQ, using
the kernel virtio ring driver as a reference. There is already a setup
that can be used to test the changes.

Links:
* https://www.redhat.com/en/blog/virtio-devices-and-drivers-overview-headja=
ck-and-phone
* https://www.redhat.com/en/blog/virtqueues-and-virtio-ring-how-data-travel=
s
* https://www.redhat.com/en/blog/packed-virtqueue-how-reduce-overhead-virti=
o
* https://www.youtube.com/watch?v=3Dx9ARoNVzS04

Details:
* Skill level: Intermediate
* Language: C



Return-Path: <kvm+bounces-7581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 872C5843CE8
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 11:37:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA5571C29E36
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 10:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7689869D39;
	Wed, 31 Jan 2024 10:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Llijptv/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066A869D05
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 10:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706697463; cv=none; b=PqbqXImrJfiHAev+s1D/qowpWL0yyT1o8VYTaXFdvn569aKACaF2WqqDSXCoKLwYpNpoal4F5WcwXkS9EOo/VG42OqZ8w5P9WoU2fmFZUfVWcwiKXiaJD3Uzdet3pubBNMJE8i0rj6i0HLzrBrBRZGZJwWCPrH3cnsLAk5qWMHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706697463; c=relaxed/simple;
	bh=BZ/5pXVh84yVqchUF8CdYzyQB86iKQFVoHBBNWzSgiI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WVO1Djq9YgGv0ZZTtFxl/ZOfE/RbXkgHQ8ObsxsL43J1vT/uywMPR5eo/5cMvaeAs9KwUVVTvkAfW0gZEw6dPzyrQTnuaPCIDED5EF4ABZysOhhB8AF9I74Zr7Gb2vzLRqvumkTIKSv0npVS9kwABqWrLcdKJep65peMZjNdDMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Llijptv/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706697460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BZ/5pXVh84yVqchUF8CdYzyQB86iKQFVoHBBNWzSgiI=;
	b=Llijptv/gMJgxceLCwi5v/t4AEZJgs83ZvVicUpV77jl6DYfdoKD0yZjZA8RycgP7D93zB
	KGdwMT4COQwVDPJnPRQN+llDb35nRkxOH9hroZXNzG8Zm0rOvtByPF9sE17x3Fhn86Bt16
	Ouryw4ulrDGGLt7S3X5b7tfA224hulY=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-yIVzf4RTNGyzDzYVvkCATQ-1; Wed, 31 Jan 2024 05:37:39 -0500
X-MC-Unique: yIVzf4RTNGyzDzYVvkCATQ-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-60413725f39so995717b3.2
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 02:37:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706697459; x=1707302259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BZ/5pXVh84yVqchUF8CdYzyQB86iKQFVoHBBNWzSgiI=;
        b=ZE1rpXwNUaCibDR2Y4zMyt4wm36wEqjK0O0YYyWShizaJBVpYqF6ZrgzB8Wds218nV
         YFqR8prYRUQ1Aw2wxeWmkNrQuvDvrtSe7xfBYUJfb8WsXC7eZNhZ6azgibH+b3Qhj0k+
         2ChWTtuV0mWxmkOMALqNhArH2p9C9n/EL5sHXGaECgHzXcv1aTmuLVSZrlLY4Ayitd2f
         IgsiJ682GXjSbM4cFdLAFHhOTmb2OTY/rK2ytuc/MrMXQ+7DV2TCjKpV1U182qyLyvN9
         EKi96lTstos11R6+G86fVIuYhxHLUVrfhCh7rHsUZqvfkl3InGBPr7bmlP0FcmjoejeQ
         QUFA==
X-Gm-Message-State: AOJu0YxHfSIsU8rbmXJJqzlzEp+EggwKQcUg0a8hZuAUoSitdG3KRNkw
	pBbpPcBbDJsXPYarrr2ulp8C9rfo4K2k4cFct8vzNvesArUhGEoFjJfptq6n0vPHRSZ4w8+sxWz
	FGAXWOOkvVwd2T1LluKvt255gygGahy/zAFp2mww1IPRr55csa5Pwa4ViGzgR6lh3FxBIg/eiPN
	U/OQPwudzspr2oS0INXYiKtRnE
X-Received: by 2002:a81:c545:0:b0:5ff:a52b:55ac with SMTP id o5-20020a81c545000000b005ffa52b55acmr880382ywj.34.1706697458842;
        Wed, 31 Jan 2024 02:37:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFshBQqoErbhHyr+Q5zY2LZvsx8RHksCLXSGgFJ0TPShcaDyG/Hw1jQof6Jm0l0MKneEtOr/J6LhaNERDvbBZw=
X-Received: by 2002:a81:c545:0:b0:5ff:a52b:55ac with SMTP id
 o5-20020a81c545000000b005ffa52b55acmr880376ywj.34.1706697458615; Wed, 31 Jan
 2024 02:37:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QX9TQ-=PD7apOamXvGW29VwJPfVNN2X5BsFLFoP2g6USg@mail.gmail.com>
 <CAJaqyWdMNP3V=JL6C8SSbXV5AP_2O9SNJLUS+Go7AjVsrT1FdQ@mail.gmail.com>
 <CAJSP0QXMJiRQFJh6383tnCOXyLwAbBYM7ff-mtregO3MKAEC1A@mail.gmail.com>
 <CAJaqyWeKrjjMyRXo1LK4_2Q=HYKqd=omjDJ+by_=do9ppdCk3w@mail.gmail.com> <CAJSP0QU09UCkV6Q6HfsB8ozaE0mMC1tCH02e5CEBMPC_=eyUOw@mail.gmail.com>
In-Reply-To: <CAJSP0QU09UCkV6Q6HfsB8ozaE0mMC1tCH02e5CEBMPC_=eyUOw@mail.gmail.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 31 Jan 2024 11:37:02 +0100
Message-ID: <CAJaqyWfy7io-F5LQKOWP8tWj8tsf8wa2MwUnOXzhYqF35g_LxA@mail.gmail.com>
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

On Tue, Jan 30, 2024 at 8:34=E2=80=AFPM Stefan Hajnoczi <stefanha@gmail.com=
> wrote:
>
> Hi Eugenio,
> Stefano Garzarella and I had a SVQ-related project idea that I have added=
:
> https://wiki.qemu.org/Google_Summer_of_Code_2024#vhost-user_memory_isolat=
ion
>
> We want to support vhost-user devices without exposing guest RAM. This
> is attractive for security reasons in vhost-user-vsock where a process
> that connects multiple guests should not give access to other guests'
> RAM in the case of a security bug. It is also useful on host platforms
> where guest RAM cannot be shared (we think this is the case on macOS
> Hypervisor.framework).
>
> Please let us know if you have any thoughts about sharing/refactoring
> the SVQ code.
>

I'm totally in, sure :).

Actually I've been thinking about adding multithreading to SVQ. Since
SVQ reuses a lot of code from the emulated devices in virtio.c, it
would be great to add multithread to net devices too.

On the other hand, I've not added indirect descriptor support because
SVQ does not copy buffer memory by default, and there was little
benefit because HW does not like indirections. It seems to me that
reuse for your proposal would enable a justification to finally add
it.

Looking forward to this project, and I'd be happy to help it for sure. Than=
ks!



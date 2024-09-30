Return-Path: <kvm+bounces-27676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94EEC98A267
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 14:28:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA84B1C21847
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 12:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD4F18E031;
	Mon, 30 Sep 2024 12:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="mfIvhc8G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0BF155312
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 12:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727699327; cv=none; b=dQYE4asruhhDsYSMFPKu8jaxil9PhQtiqTaCZ1Nujak1WH6WMYdsaED+/KCTmSjncmbr6Hh7guKrhmbqHtvzZHf7VjFJVmT+2M6nswP7vsGbB9uM9qg2UU8X8Duw6jIfEgcry5aeWwxiRTmY49AXA++dls3xrX6YDmmwr7N3h3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727699327; c=relaxed/simple;
	bh=Qs3Lx77ih1oGuQEQaE5Xr+rDDJ0+tfigyqRV7na0ym8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NQMxyzSeKKPcLekXbc7A5OsmSb2ARjzNL1Jw6GG2IWPo/Xm7EZteF+9zpAj9vQVGoJr20cq77Aqt7d4AsiIVDyUxQASLJ00yBV/E5a/npCmjZY5AR7kBkcw33Af2RUB6BLizueQdueIqFb1IQ5Pl0ykV3sfpa3RSX1Wfq18chpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=mfIvhc8G; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E4C1F3F20D
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 12:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1727699322;
	bh=ccmCiOQhZeUMRjWEGS0Si8fclp+XCrQMa0zBHhcdvp8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=mfIvhc8GBF64eCcfft+bfyiUjtacYn4jvlsuA0w0rC1I8nXpRMf5ShKQGu8oUktQG
	 WnX80X6LxEz5e3qzwbqIFZHzEsdtMFqcwtP2xAD6cU9u2RRrM+WMy+ugD8lEvOe3Bd
	 sNDITlBI51arGKdnomM5xmmQ9B+v5cCaN7CqgM7iMfZmG11Gujp6dONIezkhBigWCD
	 jk8wZ/K1f9h8pNEtyrGrWrGhnjTcRjF2jrVIA8N+CtrvCXFoaMUPu2kQIjnGUkVIl1
	 4s7L0gaJvXXfvkWQqjUFr562Afc26jMcQOsa8QYLhWSSYrruxSvIIdhXAopeJmHIiA
	 KvcQDM3XPZFPQ==
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-50abce42b80so199416e0c.3
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 05:28:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727699322; x=1728304122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ccmCiOQhZeUMRjWEGS0Si8fclp+XCrQMa0zBHhcdvp8=;
        b=mfu0OJ8J5iCgXCxN+hZ5mz5xl02/FB/ICJDedDE36dL9DoQWAl10k/lq/JbEZewSrf
         eBEbm/IkS39Hxwd2G+i8d4ME1orXdWaveTXZ4yDpKIa74IXbueN7RJ3KGmR87ePUPv+q
         LGkd6k+YKRfthUaDy2M+nV3dSD0SvQxqTFDFL+HigWWEXxqyZrA0Q06FWbdjNIxDy2+r
         enqPbxEQIFA95o8758wpin4rprHwyPbwYtOEGWFNWXx6bIJ5wJPaVQtGI0DUYFC0RaIM
         z3GCGnPMHpLWN/AtCJhDRK2WyOgsOPDOOStxeJzQPyMXxCWOmUDutB9WOYMxJyRHhCPt
         SPlA==
X-Forwarded-Encrypted: i=1; AJvYcCUwdzgxfH1BOAVhuaE6uYWuXNc35vdh13uKA1vcgdvPZLjyn0o0lsdwIgl61hAVnjJlO28=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCqjSUc+ySWLbBCoZh8RRsJZRaOR48kP/A70di84Qr1GV8IQKg
	3JB1aS2MM6jhRq9nKs/OdqsBGSagqAEOnxxlk2So6tzrmgqdKnbtZTzP3AJCellZ9F1jEDZqbPv
	DHIS/hMsJxooBSQ6lOC2EIo5oVFsTIB+GnWz9/FsUimSpKV8pIey8Ke7Nwhux2t7SRk905rIp3q
	3I3hiddHmd27CvjJ0LyBw/mfgpaMsslE7jXTUW2CXT
X-Received: by 2002:a05:6122:c9a:b0:50a:b7b5:30c6 with SMTP id 71dfb90a1353d-50ab7b5345dmr1653704e0c.8.1727699321589;
        Mon, 30 Sep 2024 05:28:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9iHSL869qB63t3MhxKcid/7j2ONP/nctW+LPfFUOmGxo8rYFIokQ+0UJMT9guM5Zj73BaD99bYvbkHrBiTJA=
X-Received: by 2002:a05:6122:c9a:b0:50a:b7b5:30c6 with SMTP id
 71dfb90a1353d-50ab7b5345dmr1653680e0c.8.1727699321135; Mon, 30 Sep 2024
 05:28:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240929182103.21882-1-aleksandr.mikhalitsyn@canonical.com> <20240929150147-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240929150147-mutt-send-email-mst@kernel.org>
From: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date: Mon, 30 Sep 2024 14:28:30 +0200
Message-ID: <CAEivzxcvokDUPWzj48aJX6a4RU_i+OdMOH=fyLQW+FObjKpZDQ@mail.gmail.com>
Subject: Re: [PATCH v2] vhost/vsock: specify module version
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: stefanha@redhat.com, Stefano Garzarella <sgarzare@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 29, 2024 at 9:03=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Sun, Sep 29, 2024 at 08:21:03PM +0200, Alexander Mikhalitsyn wrote:
> > Add an explicit MODULE_VERSION("0.0.1") specification for the vhost_vso=
ck module.
> >
> > It is useful because it allows userspace to check if vhost_vsock is the=
re when it is
> > configured as a built-in.
> >
> > This is what we have *without* this change and when vhost_vsock is conf=
igured
> > as a module and loaded:
> >
> > $ ls -la /sys/module/vhost_vsock
> > total 0
> > drwxr-xr-x   5 root root    0 Sep 29 19:00 .
> > drwxr-xr-x 337 root root    0 Sep 29 18:59 ..
> > -r--r--r--   1 root root 4096 Sep 29 20:05 coresize
> > drwxr-xr-x   2 root root    0 Sep 29 20:05 holders
> > -r--r--r--   1 root root 4096 Sep 29 20:05 initsize
> > -r--r--r--   1 root root 4096 Sep 29 20:05 initstate
> > drwxr-xr-x   2 root root    0 Sep 29 20:05 notes
> > -r--r--r--   1 root root 4096 Sep 29 20:05 refcnt
> > drwxr-xr-x   2 root root    0 Sep 29 20:05 sections
> > -r--r--r--   1 root root 4096 Sep 29 20:05 srcversion
> > -r--r--r--   1 root root 4096 Sep 29 20:05 taint
> > --w-------   1 root root 4096 Sep 29 19:00 uevent
> >
> > When vhost_vsock is configured as a built-in there is *no* /sys/module/=
vhost_vsock directory at all.
> > And this looks like an inconsistency.
>
> And that's expected.
>
> > With this change, when vhost_vsock is configured as a built-in we get:
> > $ ls -la /sys/module/vhost_vsock/
> > total 0
> > drwxr-xr-x   2 root root    0 Sep 26 15:59 .
> > drwxr-xr-x 100 root root    0 Sep 26 15:59 ..
> > --w-------   1 root root 4096 Sep 26 15:59 uevent
> > -r--r--r--   1 root root 4096 Sep 26 15:59 version
>

Hi Michael,

> Sorry, what I'd like to see is an explanation which userspace
> is broken without this change, and whether this patch fixes is.

Ok, let me try to write a proper commit message in this thread. I'll
send a v3 once we agree on it (don't want to spam busy
kvm developers with my one-liner fix in 10 different revisions :-) ).

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Add an explicit MODULE_VERSION("0.0.1") specification for the
vhost_vsock module.

It is useful because it allows userspace to check if vhost_vsock is
there when it is
configured as a built-in. We already have userspace consumers [1], [2]
who rely on the
assumption that if <any_linux_kernel_module> is loaded as a module OR confi=
gured
as a built-in then /sys/module/<any_linux_kernel_module> exists. While
this assumption
works well in most cases it is wrong in general. For a built-in module
X you get a /sys/module/<X>
only if the module declares MODULE_VERSION or if the module has any
parameter(s) declared.

Let's just declare MODULE_VERSION("0.0.1") for vhost_vsock to make
/sys/module/vhost_vsock
to exist in all possible configurations (loadable module or built-in).
Version 0.0.1 is chosen to align
with all other modules in drivers/vhost.

This is what we have *without* this change and when vhost_vsock is configur=
ed
as a module and loaded:

$ ls -la /sys/module/vhost_vsock
total 0
drwxr-xr-x   5 root root    0 Sep 29 19:00 .
drwxr-xr-x 337 root root    0 Sep 29 18:59 ..
-r--r--r--   1 root root 4096 Sep 29 20:05 coresize
drwxr-xr-x   2 root root    0 Sep 29 20:05 holders
-r--r--r--   1 root root 4096 Sep 29 20:05 initsize
-r--r--r--   1 root root 4096 Sep 29 20:05 initstate
drwxr-xr-x   2 root root    0 Sep 29 20:05 notes
-r--r--r--   1 root root 4096 Sep 29 20:05 refcnt
drwxr-xr-x   2 root root    0 Sep 29 20:05 sections
-r--r--r--   1 root root 4096 Sep 29 20:05 srcversion
-r--r--r--   1 root root 4096 Sep 29 20:05 taint
--w-------   1 root root 4096 Sep 29 19:00 uevent

When vhost_vsock is configured as a built-in there is *no*
/sys/module/vhost_vsock directory at all.
And this looks like an inconsistency.

With this change, when vhost_vsock is configured as a built-in we get:
$ ls -la /sys/module/vhost_vsock/
total 0
drwxr-xr-x   2 root root    0 Sep 26 15:59 .
drwxr-xr-x 100 root root    0 Sep 26 15:59 ..
--w-------   1 root root 4096 Sep 26 15:59 uevent
-r--r--r--   1 root root 4096 Sep 26 15:59 version

Link: https://github.com/canonical/lxd/blob/ef33aea98aec9778499e96302f26058=
82d8249d7/lxd/instance/drivers/driver_qemu.go#L8568
[1]
Link: https://github.com/lxc/incus/blob/cbebce1dcd5f15887967058c8f6fec27cf0=
da2a2/internal/server/instance/drivers/driver_qemu.go#L8723
[2]
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Does this sound fair enough?

Kind regards,
Alex

>
>
>
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.c=
om>
> > ---
> >  drivers/vhost/vsock.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > index 802153e23073..287ea8e480b5 100644
> > --- a/drivers/vhost/vsock.c
> > +++ b/drivers/vhost/vsock.c
> > @@ -956,6 +956,7 @@ static void __exit vhost_vsock_exit(void)
> >
> >  module_init(vhost_vsock_init);
> >  module_exit(vhost_vsock_exit);
> > +MODULE_VERSION("0.0.1");
> >  MODULE_LICENSE("GPL v2");
> >  MODULE_AUTHOR("Asias He");
> >  MODULE_DESCRIPTION("vhost transport for vsock ");
> > --
> > 2.34.1
>


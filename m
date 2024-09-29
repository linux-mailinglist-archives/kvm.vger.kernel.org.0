Return-Path: <kvm+bounces-27660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 863409896C2
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2024 20:23:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 23D9DB23298
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2024 18:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C0844375;
	Sun, 29 Sep 2024 18:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="fDpG0mqD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87D94317C
	for <kvm@vger.kernel.org>; Sun, 29 Sep 2024 18:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727634226; cv=none; b=E8sujiqkNy4hsfzD2YaWJPqKce+yNV0baaWtAPwkbAGYZ+sc8SEwi3hSAyWOiaSfsWfFUoj2evKMUwAj1jBVUIWHcqKGttZ2cZ8ExkJhyyt5hop9JJ5R+SkIqXbScMUcfgevkFBMzBs1StoD2Yz89HFNS3buwdh5Y8RXi+RJ9t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727634226; c=relaxed/simple;
	bh=EaeEbDkfqftHCixGBXyCEafafRodMqBM5hSAt75SEGo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QW36NVNOvy3/MmpMpMTmMd20t5OLS8UYSEw0lryK2JLEekV994b0LB96SbxNqtYEmVFOFKlR71+Ki07Kog1tdUU40eyCTjogRBkrnvOc+9GfVeen8Tw/Mq6OjbtoQI+6mXQKKReSGWLBIB3mIQTKzoG2qURyJfASn/ivb7e/xe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=fDpG0mqD; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com [209.85.217.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 8DA873F5BB
	for <kvm@vger.kernel.org>; Sun, 29 Sep 2024 18:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1727634221;
	bh=okf6FMMM+QSBRqpYSwuMmX++XMeaDITgAwFtVVXn02Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=fDpG0mqDLSfRmx3Uu72uXTvQqcS9F3sR3JR9kczFuIsZxwEUygU7qc5aY7leohfDp
	 dDMAl0mbwBHei5WzdaKn8Ij/SBI7+0XgcS2yLDANgg/qYUHSY63oniAa/AaVjRDZBX
	 CBlv8lC2W6TrDJFzXyiyctL4+KPCIfbmNrp8Zdbtbgz1UzKCPKRcyQBCBmG2bdrUHz
	 xQdF3ojINdOoFv/hkhi5u8RDyGOfOwPvjKsDHGelGLbxceYT8SgTwbFUgu+gg0RS9y
	 XmigwiEuAkmEotJvvWlJTqsEt5Ra9LCkRhAXpTtUspwN9lLl0DOCu9OcAKb8XzmHKu
	 4RnjHDGN5WH3g==
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-4a39ee3a8a6so776456137.0
        for <kvm@vger.kernel.org>; Sun, 29 Sep 2024 11:23:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727634220; x=1728239020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=okf6FMMM+QSBRqpYSwuMmX++XMeaDITgAwFtVVXn02Y=;
        b=I4xVnss88esPV+oUCxQwOICJJjTVZ6OoeKzZet4csCcj089dYf2e2gO6Kx5G1VZQ4y
         nRIYg+MIwiABeglaBzPha8kV1ku+KRwnt4nT+ExLv3rPgWkvRF+laSHIqcjp63On68yG
         pH81upkN5yq5RA/18pMdoe7/lMYhtSbEcQwYgCvvNPPv0M7b0E/e8uVQCSUr1Wxo2VWT
         pzUMAPVj5mH1Z28Le/nDUzyAWXj1RENNuOH9c/X8uyceU+sy1x9xekiMWZYkLgIHTIhU
         LFMR5ypta04g3CKd8xRGmkU7Jy9eADZ3VubO/ND+GgUlbj29+SffHCKMGt0CfNxFclwg
         TtIA==
X-Forwarded-Encrypted: i=1; AJvYcCVeb0f7R44WZdHEa4B24Bd7gUDruQ9r7bZD3+Fov6i9h9OYXPK5AmYG2GVX6PKge0Z5bWg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcjCwnfm8Uip620Hbvns9nqw8Tduk5dYQCGY0kFp2J02UV59Yp
	3pXCXqNtWvomqsWMTv3jEogh9SfjxL+yUIQ+73zvRa6BVp/8Rx3H8FIpnpoL70qo+coDFfAIPWN
	Zny+wEk+bWdLpyQouT3T2TTEGQy3yWCL+9DQqW0GBSOK8FddnLEnehYbPVJMu3tn/9kiKBl5G0L
	LA7vqHVzPQQzbMhNty5+6B7x95qxWf5dIOrFbp22Ha
X-Received: by 2002:a05:6102:3912:b0:4a3:bb4d:1965 with SMTP id ada2fe7eead31-4a3bb4d294dmr1008914137.28.1727634220311;
        Sun, 29 Sep 2024 11:23:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeieKktbBVAoln7mvsJyimo6C4kSg2QAt1DTPZnW60fFczXHi2RIRQWDMAhbz0rX/GbM/Gp7ua5YQ7uLAy6bE=
X-Received: by 2002:a05:6102:3912:b0:4a3:bb4d:1965 with SMTP id
 ada2fe7eead31-4a3bb4d294dmr1008911137.28.1727634219979; Sun, 29 Sep 2024
 11:23:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240926161641.189193-1-aleksandr.mikhalitsyn@canonical.com>
 <20240929125245-mutt-send-email-mst@kernel.org> <CAEivzxdiEu3Tzg7rK=TqDg4Ats-H+=JiPjvZRAnmqO7-jZv2Zw@mail.gmail.com>
 <20240929134815-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240929134815-mutt-send-email-mst@kernel.org>
From: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date: Sun, 29 Sep 2024 20:23:29 +0200
Message-ID: <CAEivzxfX-H15e6Lt78F0_Rkp=g5QnmDH4Z3m8z7imNFaKcL6TQ@mail.gmail.com>
Subject: Re: [PATCH] vhost/vsock: specify module version
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: stefanha@redhat.com, Stefano Garzarella <sgarzare@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 29, 2024 at 7:48=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Sun, Sep 29, 2024 at 07:35:35PM +0200, Aleksandr Mikhalitsyn wrote:
> > On Sun, Sep 29, 2024 at 6:56=E2=80=AFPM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > >
> > > On Thu, Sep 26, 2024 at 06:16:40PM +0200, Alexander Mikhalitsyn wrote=
:
> > > > Add an explicit MODULE_VERSION("0.0.1") specification
> > > > for a vhost_vsock module. It is useful because it allows
> > > > userspace to check if vhost_vsock is there when it is
> > > > configured as a built-in.
> > > >
> > > > Without this change, there is no /sys/module/vhost_vsock directory.
> > > >
> > > > With this change:
> > > > $ ls -la /sys/module/vhost_vsock/
> > > > total 0
> > > > drwxr-xr-x   2 root root    0 Sep 26 15:59 .
> > > > drwxr-xr-x 100 root root    0 Sep 26 15:59 ..
> > > > --w-------   1 root root 4096 Sep 26 15:59 uevent
> > > > -r--r--r--   1 root root 4096 Sep 26 15:59 version
> > > >
> > > > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonic=
al.com>
> > >
> > >
> >
> > Dear Michael,
> >
> > > Why not check that the misc device is registered?
> >
> > It is possible to read /proc/misc and check if "241 vhost-vsock" is
> > there, but it means that userspace
> > needs to have a specific logic for vsock. At the same time, it's quite
> > convenient to do something like:
> >     if [ ! -d /sys/modules/vhost_vsock ]; then
> >         modprobe vhost_vsock
> >     fi
> >
> > > I'd rather not add a new UAPI until actually necessary.
> >
> > I don't insist. I decided to send this patch because, while I was
> > debugging a non-related kernel issue
> > on my local dev environment I accidentally discovered that LXD
> > (containers and VM manager)
> > fails to run VMs because it fails to load the vhost_vsock module (but
> > it was built-in in my debug kernel
> > and the module file didn't exist). Then I discovered that before
> > trying to load a module we
> > check if /sys/module/<module name> exists. And found that, for some
> > reason /sys/module/vhost_vsock
> > does not exist when vhost_vsock is configured as a built-in, and
> > /sys/module/vhost_vsock *does* exist when
> > vhost_vsock is loaded as a module. It looks like an inconsistency and
> > I also checked that other modules in
> > drivers/vhost have MODULE_VERSION specified and version is 0.0.1. I
> > thought that this change looks legitimate
> > and convenient for userspace consumers.
> >
> > Kind regards,
> > Alex
>
>
> I'll ask you to put this explanation in the commit log,
> and I'll pick this up.

Have done:
https://lore.kernel.org/kvm/20240929182103.21882-1-aleksandr.mikhalitsyn@ca=
nonical.com

Thanks, Michael!

Kind regards,
Alex

>
> > >
> > > > ---
> > > >  drivers/vhost/vsock.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > > > index 802153e23073..287ea8e480b5 100644
> > > > --- a/drivers/vhost/vsock.c
> > > > +++ b/drivers/vhost/vsock.c
> > > > @@ -956,6 +956,7 @@ static void __exit vhost_vsock_exit(void)
> > > >
> > > >  module_init(vhost_vsock_init);
> > > >  module_exit(vhost_vsock_exit);
> > > > +MODULE_VERSION("0.0.1");
> > > >  MODULE_LICENSE("GPL v2");
> > > >  MODULE_AUTHOR("Asias He");
> > > >  MODULE_DESCRIPTION("vhost transport for vsock ");
> > > > --
> > > > 2.34.1
> > >
>


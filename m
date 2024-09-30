Return-Path: <kvm+bounces-27684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9148698A712
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 16:31:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34E10281514
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 14:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF981917F1;
	Mon, 30 Sep 2024 14:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="H66pUqoj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3D123D2
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 14:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727706702; cv=none; b=WCnvbb5NrT1Lifk5vUjv5QPIHcJJEwoMVx0pn1QQohb7Z9IqtnUWS5nM+sKZHSrAhBLHuTd9m6KtiyhuVVwRUYEO5iE54sBYq2VoEEKgYBEHfwLaQu4D4fvjVZMMjp4ZvRJVEnZHyx4miayF4lyaosBIz5b95n3GPy+DlXPnHGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727706702; c=relaxed/simple;
	bh=PV75RsCHFd9Set6408trF5b+jscrnWLWrq8vU1FBhhg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WPBTL6FJ++J6ALylipQkHAKHR/jC49MK2QTnuZmK3QETGsqjY7OH0naRWqsdrQRI4db2Y+EIoGOSSkZPWGQNjHe2ey7JM86ZwNcpKp9CxgdNLxiJONfT3RYrpgxtjgq564NL5eGBFS6+h+0kO2ui30/HB/fBFqgabvkm2hzzQsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=H66pUqoj; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com [209.85.221.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id CB8CB3F1F4
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 14:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1727706697;
	bh=VUmP4zgDk2FCqePA5hQ7O8LU3PwZfHmbS4Pals0CPPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=H66pUqojvG6IEUPSW7cW4e5AKIe6zcrXVdzQkiisQ7toWyhiYyVhHRIIqbP9Yq7XI
	 r91yLkut2xAQw39q6f9JWevEeimbPWu93gn8OdEJ2g2MCiTjv5B5mDtqsuAMRjAQZ9
	 W9Uj3WXmUL9Fo39OfW98YVtuD14Rz+vMPhX8RfVyk5zfw93atQg2/xghxWfdQJJ26t
	 pBy3IalFvQAIBtHpDQQe+0jPCOhw+qqZsPDidzZ19aWYx/GBWjJ1GnKS771mN1KcUu
	 bNIktUdqr3uSE9c2FY9XXxUyw9tCL0euGE6BOeyXtKhD/kvZsM9QGNHRWFl7K5T3n8
	 iX+Z7uc6p+SHQ==
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-50abce42b80so238477e0c.3
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 07:31:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727706696; x=1728311496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VUmP4zgDk2FCqePA5hQ7O8LU3PwZfHmbS4Pals0CPPE=;
        b=T6eht1U1tJxCIHkIaZZrPUzZsRfF5siP4udkM9fiDurzGepQZZmzq8HyGkKk8mojG2
         vOl68BEF/nIueh8O8IO7bE1FcsRv5DOhPQUelFind1govTI5Cz6+kU/Bifa84ZENPWiN
         K7mt+CnvIP4UGlV9vwa/LfTtCEiV1LgIBqsh3H9anEvTNTEPFMOt2WV8m6w3mI04MMYs
         vqUUHq7kJPQ96kXtYAaiaGUvldFeIC/JqrZ4O3hPuCBGpOJL4T2clPpxWPPcYlYLnt4y
         Zp8Zvh5GQ3iE7nZFdwclnKohEVF8LX6nsQ+GGvS6Wf2YdI/CnhozPK9ey0OE9ePqZ6He
         qLhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXoHY+yhLXKv5GzceqtN4ElwpsNTsXHsqmAENC6yJzI7sSI8Oz9dJ8eLdzix7Fd3r+1UHE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIGxAa730EbEYzXbcfOpWZ4+eJ+CGaaa6D/omfvqtsjVYMKBwW
	6K5Se3LsRs94eKia7u52Vajq/fvJ4MSibTt7uK1efCXs08+Ta+/ED6DxDXWSu67XUxPLvawsJ/2
	ZDVY75Bkne6o1brtUh9iltaXS/c+OyYm4A9zZYfyDbdWtoSk0FYh7fzWqbBM9hbaBLOfGF8ku9J
	AXIgeq2QA48FGwAB5hIjw5C9vxQlRaaMszRG/wDy/I
X-Received: by 2002:a05:6122:469f:b0:50a:c73e:b337 with SMTP id 71dfb90a1353d-50ac73eb866mr1132467e0c.6.1727706696624;
        Mon, 30 Sep 2024 07:31:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUm0HvUYsfb4b25izSbvZDphH102aNkELKCDsxbCwfS/CukKD+k5zVEfDIEJd2YZSQnWu62hWtUFb1+rs3YZQ=
X-Received: by 2002:a05:6122:469f:b0:50a:c73e:b337 with SMTP id
 71dfb90a1353d-50ac73eb866mr1132432e0c.6.1727706696263; Mon, 30 Sep 2024
 07:31:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240929182103.21882-1-aleksandr.mikhalitsyn@canonical.com>
 <20240929150147-mutt-send-email-mst@kernel.org> <CAEivzxcvokDUPWzj48aJX6a4RU_i+OdMOH=fyLQW+FObjKpZDQ@mail.gmail.com>
 <20240930100452-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240930100452-mutt-send-email-mst@kernel.org>
From: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date: Mon, 30 Sep 2024 16:31:25 +0200
Message-ID: <CAEivzxeBbRSgOKqDTkdxy2nyShD-Gq7+Go3+4Nm1DrwQ2-rGzA@mail.gmail.com>
Subject: Re: [PATCH v2] vhost/vsock: specify module version
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: stefanha@redhat.com, Stefano Garzarella <sgarzare@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2024 at 4:05=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Mon, Sep 30, 2024 at 02:28:30PM +0200, Aleksandr Mikhalitsyn wrote:
> > On Sun, Sep 29, 2024 at 9:03=E2=80=AFPM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > >
> > > On Sun, Sep 29, 2024 at 08:21:03PM +0200, Alexander Mikhalitsyn wrote=
:
> > > > Add an explicit MODULE_VERSION("0.0.1") specification for the vhost=
_vsock module.
> > > >
> > > > It is useful because it allows userspace to check if vhost_vsock is=
 there when it is
> > > > configured as a built-in.
> > > >
> > > > This is what we have *without* this change and when vhost_vsock is =
configured
> > > > as a module and loaded:
> > > >
> > > > $ ls -la /sys/module/vhost_vsock
> > > > total 0
> > > > drwxr-xr-x   5 root root    0 Sep 29 19:00 .
> > > > drwxr-xr-x 337 root root    0 Sep 29 18:59 ..
> > > > -r--r--r--   1 root root 4096 Sep 29 20:05 coresize
> > > > drwxr-xr-x   2 root root    0 Sep 29 20:05 holders
> > > > -r--r--r--   1 root root 4096 Sep 29 20:05 initsize
> > > > -r--r--r--   1 root root 4096 Sep 29 20:05 initstate
> > > > drwxr-xr-x   2 root root    0 Sep 29 20:05 notes
> > > > -r--r--r--   1 root root 4096 Sep 29 20:05 refcnt
> > > > drwxr-xr-x   2 root root    0 Sep 29 20:05 sections
> > > > -r--r--r--   1 root root 4096 Sep 29 20:05 srcversion
> > > > -r--r--r--   1 root root 4096 Sep 29 20:05 taint
> > > > --w-------   1 root root 4096 Sep 29 19:00 uevent
> > > >
> > > > When vhost_vsock is configured as a built-in there is *no* /sys/mod=
ule/vhost_vsock directory at all.
> > > > And this looks like an inconsistency.
> > >
> > > And that's expected.
> > >
> > > > With this change, when vhost_vsock is configured as a built-in we g=
et:
> > > > $ ls -la /sys/module/vhost_vsock/
> > > > total 0
> > > > drwxr-xr-x   2 root root    0 Sep 26 15:59 .
> > > > drwxr-xr-x 100 root root    0 Sep 26 15:59 ..
> > > > --w-------   1 root root 4096 Sep 26 15:59 uevent
> > > > -r--r--r--   1 root root 4096 Sep 26 15:59 version
> > >
> >
> > Hi Michael,
> >
> > > Sorry, what I'd like to see is an explanation which userspace
> > > is broken without this change, and whether this patch fixes is.
> >
> > Ok, let me try to write a proper commit message in this thread. I'll
> > send a v3 once we agree on it (don't want to spam busy
> > kvm developers with my one-liner fix in 10 different revisions :-) ).
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Add an explicit MODULE_VERSION("0.0.1") specification for the
> > vhost_vsock module.
> >
> > It is useful because it allows userspace to check if vhost_vsock is
> > there when it is
> > configured as a built-in. We already have userspace consumers [1], [2]
> > who rely on the
> > assumption that if <any_linux_kernel_module> is loaded as a module OR c=
onfigured
> > as a built-in then /sys/module/<any_linux_kernel_module> exists. While
> > this assumption
> > works well in most cases it is wrong in general. For a built-in module
> > X you get a /sys/module/<X>
> > only if the module declares MODULE_VERSION or if the module has any
> > parameter(s) declared.
> >
> > Let's just declare MODULE_VERSION("0.0.1") for vhost_vsock to make
> > /sys/module/vhost_vsock
> > to exist in all possible configurations (loadable module or built-in).
> > Version 0.0.1 is chosen to align
> > with all other modules in drivers/vhost.
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
> > When vhost_vsock is configured as a built-in there is *no*
> > /sys/module/vhost_vsock directory at all.
> > And this looks like an inconsistency.
> >
> > With this change, when vhost_vsock is configured as a built-in we get:
> > $ ls -la /sys/module/vhost_vsock/
> > total 0
> > drwxr-xr-x   2 root root    0 Sep 26 15:59 .
> > drwxr-xr-x 100 root root    0 Sep 26 15:59 ..
> > --w-------   1 root root 4096 Sep 26 15:59 uevent
> > -r--r--r--   1 root root 4096 Sep 26 15:59 version
> >
> > Link: https://github.com/canonical/lxd/blob/ef33aea98aec9778499e96302f2=
605882d8249d7/lxd/instance/drivers/driver_qemu.go#L8568
> > [1]
> > Link: https://github.com/lxc/incus/blob/cbebce1dcd5f15887967058c8f6fec2=
7cf0da2a2/internal/server/instance/drivers/driver_qemu.go#L8723
> > [2]
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.c=
om>
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Does this sound fair enough?
> >
> > Kind regards,
> > Alex
>
>
> Looks good, thanks!

Thanks, Michael! And I'm sorry for not being clear in my commit
messages from the beginning of our discussion ;-)

Then I'll send v3 a bit later as I see that Stefano reacted to this
proposal too, will see how it goes :-)

Kind regards,
Alex

>
> > >
> > >
> > >
> > > > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonic=
al.com>
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


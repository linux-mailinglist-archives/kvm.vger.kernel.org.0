Return-Path: <kvm+bounces-27658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 81ADE9896AC
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2024 19:49:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A6831F22845
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2024 17:49:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3F6B45948;
	Sun, 29 Sep 2024 17:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TdWDHJd9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F3E42070
	for <kvm@vger.kernel.org>; Sun, 29 Sep 2024 17:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727632128; cv=none; b=otmtdWrR/5d552wAaMO5BM35gxIUxAtNzHbl4BTSdOMzrQoNAXlEbB+QqYsnI9Zj0Me74edny7kqRyJXnptUJ0+WLa31ygYW5aNCkXX447ZM76QMriFvMIGj0hizGzUDh8CGwi3BxPhR+prm+vJs43t8OkcP1Yz9LslPwuCFWpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727632128; c=relaxed/simple;
	bh=do27kc5Fwyi6Kx7WwmJUxF9V16BLmQ7JLqwuhDUy4Yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=quAXd1f2f2XbMFlrDeCpERpBAnv3qeemyN8T5yd0QtJiatV+osQNf+8eZyaDDDaiZTbjBX0WItM28zZEt6MVfb7ifEJOdLExnHilT8YYDFcXfn9R2c4MjBCiWWRsK7gOLfxIPTQVRRg2FldAT3JNm6n1BWpGYX6O99DlnLc0+Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TdWDHJd9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727632126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wPatogrvfeQytgMf1DGOYNKKTCyiWPsjq+uNPqesLks=;
	b=TdWDHJd9BPPH2HTP4lnkPvCAjdjmWM6jZqnCaKxeXcMhsS/uvCF8XFUw65X3k9Poog3Ofm
	5xZfkf1wKjKMp5SKgY13J5HSbVqzbFT02aoD7siQeQvhKS5TsYTyfSNWaLj++4MLAPqCrz
	paxrOeD9H24r+NnplX06YSc6+/BM8pQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-ywBprEKdMISDISaxtlCt7g-1; Sun, 29 Sep 2024 13:48:44 -0400
X-MC-Unique: ywBprEKdMISDISaxtlCt7g-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a8d1a00e0beso20435166b.0
        for <kvm@vger.kernel.org>; Sun, 29 Sep 2024 10:48:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727632123; x=1728236923;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wPatogrvfeQytgMf1DGOYNKKTCyiWPsjq+uNPqesLks=;
        b=MKcdj2QrecDKLwZVW5uW/gi9jsqc7eUdCOPROipNoEv6/WOrNoDxPkmWGgHSwTcTni
         zCEdC5C0XOsD5ESMqs32j5QKK2dOD9RKUgmJEcXZMb/Ja3fY3Mup5UXrC/LAcn75GJiu
         wztfzMb6v1rCQU064F4uMKQlO8b1omUUz+Ox94sSjXHxiyCOashG3IJnqpVeKcF9AOHN
         hmdXunlsicqsH8Njl1t2TdC7AXBVTzVMoTgz9A/rpYIrFjiYQMmXlzIlek5B4AVXo9T6
         ts//6xYubpxohj/2xcm0T5BEXIXUYuBNQTH/N0cH8q2rJjxQR1HKWP3l8cL+SeK3Qtq8
         a2CQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpag5OVVjOTgCozbfpXk4mzq1jUSoxgq6shcVE7Tq1IesfAgW7OEFVbZ8xhPJZOif1foY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsOCeeub00SOlSFBwtTAUlrHnljFusCpLUFrbNNxv7dG9v/Tuo
	RAsNsGzq2+WacS5s/Q7IaG0LaxQDke3sBKMMpYMzvUP1PvfyQhR6l9/KCe65gxUCX49ShoPGLGT
	bQaC01g7bOkV6R1Yc2Uba4TRokffAH2/4Le29ncp4sEgpj4Ea/Q==
X-Received: by 2002:a17:907:8687:b0:a8d:4954:c209 with SMTP id a640c23a62f3a-a93b165dacamr1584445066b.22.1727632123590;
        Sun, 29 Sep 2024 10:48:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8yhcltAXNNOPlgdZbg2eX/lkfZ7eFhPOsGjV+HlVBPUltwDUsyTd38J3Fyn/QINeqZ/Q5XA==
X-Received: by 2002:a17:907:8687:b0:a8d:4954:c209 with SMTP id a640c23a62f3a-a93b165dacamr1584442566b.22.1727632122934;
        Sun, 29 Sep 2024 10:48:42 -0700 (PDT)
Received: from redhat.com ([2a02:14f:17b:822e:847c:4023:a734:1389])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c2948fc7sm404346366b.137.2024.09.29.10.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2024 10:48:42 -0700 (PDT)
Date: Sun, 29 Sep 2024 13:48:36 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: stefanha@redhat.com, Stefano Garzarella <sgarzare@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: specify module version
Message-ID: <20240929134815-mutt-send-email-mst@kernel.org>
References: <20240926161641.189193-1-aleksandr.mikhalitsyn@canonical.com>
 <20240929125245-mutt-send-email-mst@kernel.org>
 <CAEivzxdiEu3Tzg7rK=TqDg4Ats-H+=JiPjvZRAnmqO7-jZv2Zw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEivzxdiEu3Tzg7rK=TqDg4Ats-H+=JiPjvZRAnmqO7-jZv2Zw@mail.gmail.com>

On Sun, Sep 29, 2024 at 07:35:35PM +0200, Aleksandr Mikhalitsyn wrote:
> On Sun, Sep 29, 2024 at 6:56 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Thu, Sep 26, 2024 at 06:16:40PM +0200, Alexander Mikhalitsyn wrote:
> > > Add an explicit MODULE_VERSION("0.0.1") specification
> > > for a vhost_vsock module. It is useful because it allows
> > > userspace to check if vhost_vsock is there when it is
> > > configured as a built-in.
> > >
> > > Without this change, there is no /sys/module/vhost_vsock directory.
> > >
> > > With this change:
> > > $ ls -la /sys/module/vhost_vsock/
> > > total 0
> > > drwxr-xr-x   2 root root    0 Sep 26 15:59 .
> > > drwxr-xr-x 100 root root    0 Sep 26 15:59 ..
> > > --w-------   1 root root 4096 Sep 26 15:59 uevent
> > > -r--r--r--   1 root root 4096 Sep 26 15:59 version
> > >
> > > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> >
> >
> 
> Dear Michael,
> 
> > Why not check that the misc device is registered?
> 
> It is possible to read /proc/misc and check if "241 vhost-vsock" is
> there, but it means that userspace
> needs to have a specific logic for vsock. At the same time, it's quite
> convenient to do something like:
>     if [ ! -d /sys/modules/vhost_vsock ]; then
>         modprobe vhost_vsock
>     fi
> 
> > I'd rather not add a new UAPI until actually necessary.
> 
> I don't insist. I decided to send this patch because, while I was
> debugging a non-related kernel issue
> on my local dev environment I accidentally discovered that LXD
> (containers and VM manager)
> fails to run VMs because it fails to load the vhost_vsock module (but
> it was built-in in my debug kernel
> and the module file didn't exist). Then I discovered that before
> trying to load a module we
> check if /sys/module/<module name> exists. And found that, for some
> reason /sys/module/vhost_vsock
> does not exist when vhost_vsock is configured as a built-in, and
> /sys/module/vhost_vsock *does* exist when
> vhost_vsock is loaded as a module. It looks like an inconsistency and
> I also checked that other modules in
> drivers/vhost have MODULE_VERSION specified and version is 0.0.1. I
> thought that this change looks legitimate
> and convenient for userspace consumers.
> 
> Kind regards,
> Alex


I'll ask you to put this explanation in the commit log,
and I'll pick this up.

> >
> > > ---
> > >  drivers/vhost/vsock.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > > index 802153e23073..287ea8e480b5 100644
> > > --- a/drivers/vhost/vsock.c
> > > +++ b/drivers/vhost/vsock.c
> > > @@ -956,6 +956,7 @@ static void __exit vhost_vsock_exit(void)
> > >
> > >  module_init(vhost_vsock_init);
> > >  module_exit(vhost_vsock_exit);
> > > +MODULE_VERSION("0.0.1");
> > >  MODULE_LICENSE("GPL v2");
> > >  MODULE_AUTHOR("Asias He");
> > >  MODULE_DESCRIPTION("vhost transport for vsock ");
> > > --
> > > 2.34.1
> >



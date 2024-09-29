Return-Path: <kvm+bounces-27655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5531598969E
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2024 19:36:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C0BD28490E
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2024 17:36:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 739FE3BBC5;
	Sun, 29 Sep 2024 17:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="fYxSDrF7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386DE2D057
	for <kvm@vger.kernel.org>; Sun, 29 Sep 2024 17:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727631354; cv=none; b=VXrEq/C+yzagEu2WMdej2YXkVOsXc5mxDDBkkKbutTUYM9EXEHmgX2XwyU7s3AQUllNHwpbEXv9EkKqhf14N3dMi38pcA3+Sac1QtVLHY9ScrBGsZ7sBS/hg0HIXC4PHHqVK7Xb1gGIY5ZYYssE6qAhcpVlsohgNZdj8w6NM5wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727631354; c=relaxed/simple;
	bh=7FJYoAf4UNnJsGqA3YqqHhA0Hb//TkkxwczcqdaRjo8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I5WL0FPNEDNTA09AhTo8Pw0218xLG8URIZREfKfQUSOBypWxt4h/kpWChPudAOtCs5skESbSIJdydm2ulanr46CmTFSjTWbOfnvYPLVLcr4TGXtnr9penZvfYmIBIwZoJJG+L2De+1GRzG2eE5Fxj1JHQUSLGLILFhSS8VOK11M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=fYxSDrF7; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 3160C3F178
	for <kvm@vger.kernel.org>; Sun, 29 Sep 2024 17:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1727631349;
	bh=Rl/pS/wt7QkZsPdEO+ufS/ZfVUHdqAefjBl7pvxI0CY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=fYxSDrF7mpS9t1g7O6pChWQ0In0dCf+fRJGGGeFKWsrqlyFQEK0ASqj9vqlf9EKY2
	 s1wNoY66Z2DW8ax9x40Z9Y32FM06xoJyGalHJdVppmuQz4oxDF7pFHU3fM6cQdwZGp
	 5ARdAkxeGO4HqaV9Q3U5F0DdpNoGaykeha9bqZyPtGt2fnkqvamtZsmW4GJs+x81fa
	 tmNnXyPxpdfzJLrrGdsd42P4go5dxzEdsPLAgtpTzA878QSzou0wTeT7pLROZOH1Lu
	 XdbGOy0kBmwIHmixg0T7s28yUj+JX9fhRmZdggkQ+ZmZjN/oXNDELfMnT5dXEP84yw
	 rP6tLWbRzCTHg==
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-4a3c8b1356fso12684137.0
        for <kvm@vger.kernel.org>; Sun, 29 Sep 2024 10:35:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727631348; x=1728236148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rl/pS/wt7QkZsPdEO+ufS/ZfVUHdqAefjBl7pvxI0CY=;
        b=mb+hRnD18yn8ty/wEq+UolyMiRBNqzGXDKu/Wn2CE3izUL/aaK6qc2xyYUYxF8ZkOF
         TnYJxyW0dVO2C44m94UId/QgIer1HFIKApKWi70TW4thM1GZdcRd8QKIJQptqBsWZvRv
         w+ukykZBjpvN9vgLaUJFLk3UzLFZusp/KMyjIvW8e4YLdu7Hxi5Ax+2e9r8wQy0UBhkO
         K/lfGIWvzr9ivP8jajh+dMbNqcSNQM9KXInFB5c06X7H6n463M/EnjzMIsPrS/D8X+Hy
         eNe35v+HQCro7X+x1HNoMsPw5MlV/UU7950v/RYFkqF06Ui9YTnE/BQl4Axc8hZwLlPO
         Lo5w==
X-Forwarded-Encrypted: i=1; AJvYcCUs5DQLJlsASXfeHqKxRxT/gC8oEaFYEvb5vSdquDGPtv8V8U0drTNjbnmokXRvpCwJwHc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFF0l8ooky8Adk1rbCY+vR61EqyPSu8/2r1lxOahtwFI2uLSbQ
	Pcj6D1BoEQXGUlNUJTcOn/wnAdS0lGIbVV2Fc8k+h91vs64A1+bZhLbU5ddIn8FhkAfyC6OLtth
	wVFItztQyAYgmy6PKKPnOVmZL5TpgRKNXaJQxjHPfMN/tcEGT1TGUdgC3tvCQJfTSaVUepLoT76
	yottOxhZ8Pm0RzQBe9twJhDGAWOrVTVRe+hn29TIYi
X-Received: by 2002:a05:6102:3909:b0:4a3:c48a:6d with SMTP id ada2fe7eead31-4a3c48a072amr568327137.7.1727631347977;
        Sun, 29 Sep 2024 10:35:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGumyMX+ocvMCel4pVMoToxGxjM87jX1L3K8ElBWypvEO0i4r1+ozb3p2pk+hDYSgoZzgLzkpNtCwVQexZ4Wy8=
X-Received: by 2002:a05:6102:3909:b0:4a3:c48a:6d with SMTP id
 ada2fe7eead31-4a3c48a072amr568306137.7.1727631346626; Sun, 29 Sep 2024
 10:35:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240926161641.189193-1-aleksandr.mikhalitsyn@canonical.com> <20240929125245-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240929125245-mutt-send-email-mst@kernel.org>
From: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date: Sun, 29 Sep 2024 19:35:35 +0200
Message-ID: <CAEivzxdiEu3Tzg7rK=TqDg4Ats-H+=JiPjvZRAnmqO7-jZv2Zw@mail.gmail.com>
Subject: Re: [PATCH] vhost/vsock: specify module version
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: stefanha@redhat.com, Stefano Garzarella <sgarzare@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 29, 2024 at 6:56=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Thu, Sep 26, 2024 at 06:16:40PM +0200, Alexander Mikhalitsyn wrote:
> > Add an explicit MODULE_VERSION("0.0.1") specification
> > for a vhost_vsock module. It is useful because it allows
> > userspace to check if vhost_vsock is there when it is
> > configured as a built-in.
> >
> > Without this change, there is no /sys/module/vhost_vsock directory.
> >
> > With this change:
> > $ ls -la /sys/module/vhost_vsock/
> > total 0
> > drwxr-xr-x   2 root root    0 Sep 26 15:59 .
> > drwxr-xr-x 100 root root    0 Sep 26 15:59 ..
> > --w-------   1 root root 4096 Sep 26 15:59 uevent
> > -r--r--r--   1 root root 4096 Sep 26 15:59 version
> >
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.c=
om>
>
>

Dear Michael,

> Why not check that the misc device is registered?

It is possible to read /proc/misc and check if "241 vhost-vsock" is
there, but it means that userspace
needs to have a specific logic for vsock. At the same time, it's quite
convenient to do something like:
    if [ ! -d /sys/modules/vhost_vsock ]; then
        modprobe vhost_vsock
    fi

> I'd rather not add a new UAPI until actually necessary.

I don't insist. I decided to send this patch because, while I was
debugging a non-related kernel issue
on my local dev environment I accidentally discovered that LXD
(containers and VM manager)
fails to run VMs because it fails to load the vhost_vsock module (but
it was built-in in my debug kernel
and the module file didn't exist). Then I discovered that before
trying to load a module we
check if /sys/module/<module name> exists. And found that, for some
reason /sys/module/vhost_vsock
does not exist when vhost_vsock is configured as a built-in, and
/sys/module/vhost_vsock *does* exist when
vhost_vsock is loaded as a module. It looks like an inconsistency and
I also checked that other modules in
drivers/vhost have MODULE_VERSION specified and version is 0.0.1. I
thought that this change looks legitimate
and convenient for userspace consumers.

Kind regards,
Alex

>
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


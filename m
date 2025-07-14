Return-Path: <kvm+bounces-52282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E428FB03A5F
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:10:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A11E51893505
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 09:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7129923C4FF;
	Mon, 14 Jul 2025 09:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c/aBguOQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7866B23A989
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 09:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752484188; cv=none; b=ClUK6xg/j0GPO5c5y2YoH1lWeZ/UBWglU/SJqC7efl8WKdE125bga7BDrOgTGQ5wuiNlvo3rqaOUpCDV8s3nxt7xh45BxRI0WCet9bdDbSbN3cG522ExDRq5pSWDUVtlZxw/kb5vtyWSTpGgoJPllqeUn2vLEjrx8/j5GQauG8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752484188; c=relaxed/simple;
	bh=pLJpriejlPFSUDWi+hDX7FIAL7NAiHjWLbg/hoAggOU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jSa6w5ZbzI4iv7Xs1XKdgzP+qiZ26ZIm68ppJSQka0678KU8gu5D81h3g6S8mliKrXiXQxtNCHP2Eda2qbdqpKtjJyK+qtVs9swMtMR6VlGrc6HdZwH8C8TkBUkhd487dRpglb4XuEmq1FyoAE3Ak2q7nO4HZQzf7p+EqkR2JFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c/aBguOQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752484185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VYAahEFsu1YjaAsH0kAZkyaJ37ljMI1GGfFqPH8qPh4=;
	b=c/aBguOQEuoQ6WY8uBdi/cakWZZV9OLTgXWEiKepeciJilZNvvjeFFKW5AU00cxLosia64
	ymEYyOhTI8SE/FTGi5GkXV1sl/vSDAwoxfdTsnTLZXzuXHOko3n92OpNJ2ehqdCHsV6/WZ
	HAHggENqfEwsZ9FEgi03s90bXJmaoPA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-hbIESmnRNgud_McdPAht2g-1; Mon, 14 Jul 2025 05:09:42 -0400
X-MC-Unique: hbIESmnRNgud_McdPAht2g-1
X-Mimecast-MFC-AGG-ID: hbIESmnRNgud_McdPAht2g_1752484182
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ae6ee7602c7so343797166b.0
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 02:09:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752484181; x=1753088981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VYAahEFsu1YjaAsH0kAZkyaJ37ljMI1GGfFqPH8qPh4=;
        b=uIEU8qWOLLZ4NV//MEK1HbntJDl0aePk4lGBGZAyiMWpp3jmjfUxjmLDrEICNNSlWh
         609IRaVuP6BvPaQCA+Sz8fYyFpZ0EoxO3Lr3idNNS0O5Et/HilHL8hD8d0DE3GLapJSG
         hN/BSma/I3s8SokGzUSXRmmGycBsTzNDc1IzyZ+U32H7N+2KB83ivPMuLCgairu/Ty/i
         IYen774OYCZPw3qwgMtC6zrVO2wqvGxntwOzwcYFY9HQAOKJx+ph+aiN+sjDaKvJ+sXn
         YO+/MX8CAt7I7IwUs4aFD2VnKaGqNavyQNtB9BOa2n8UH6kAI33lF0hgDyff6cpb+00W
         MC+g==
X-Forwarded-Encrypted: i=1; AJvYcCW4+fqUEtqruZ+eUJRnZgRQ6udutJBsKrVGZJqr24x91+73jRZPr3xa/pbX6E0e6L+mVbc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjqVQwMzK93f4EeSFUiDw8prCd2lWKqbrvTlANB4HHKKVc3ddu
	agWI2eRUOtOXQ7T8Cb2PwYGR7l0cOJ5LFhrs7wDWvIQUVtvmUpTD6qa4sXpUweVMjTw6BW95x5b
	SWDs17g4JWShXsFp6CKUJYfDGlvy17l1ecTamYPld3cEYOJ0nqMiwBqmRqDV9+ytd2Q42mkChmQ
	9uspUtxVPL2la2xVgLaJlqvsZkbQDT
X-Gm-Gg: ASbGncvCjJU299eMK0UwPI7rE2HtgxRfR+yRTtmptWUOtRrXfRu3oBoLrza/bKkW5o2
	wJsKnqBRREm+xzqAJsfvdbbgRI4yWbubyjBlQeLl8fxe7KGiHPmX3mtKHJQHkkJFOHoAUy/Jwz9
	oWPNR+dfYoe1rn3WSDTwctwA==
X-Received: by 2002:a17:907:928c:b0:ae3:67c7:54a6 with SMTP id a640c23a62f3a-ae6fc1204bcmr1201989666b.34.1752484181409;
        Mon, 14 Jul 2025 02:09:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNGBUwv/aiEvCa1RxRFbJbCehc94t0sATx8zkIESSdwr5uhJxus3IYPQcvCzUWH2iVkLv5Hk9Ny0KHdI5O9f8=
X-Received: by 2002:a17:907:928c:b0:ae3:67c7:54a6 with SMTP id
 a640c23a62f3a-ae6fc1204bcmr1201986866b.34.1752484180940; Mon, 14 Jul 2025
 02:09:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1752229731.git.pabeni@redhat.com> <CAPpAL=y4e=+H2rxHwwgbGvU+x10aTDVZ7ix+2YqVC3e6hd6L7g@mail.gmail.com>
 <b745cfee-5e29-431a-8a3d-070c47e3f0a3@redhat.com>
In-Reply-To: <b745cfee-5e29-431a-8a3d-070c47e3f0a3@redhat.com>
From: Lei Yang <leiyang@redhat.com>
Date: Mon, 14 Jul 2025 17:09:03 +0800
X-Gm-Features: Ac12FXxhyQRKX4WxuMyNz5ss6U4wn9FTUq40s1TfdmsWZMa_uJqbL9A9zKVVstk
Message-ID: <CAPpAL=xBfCXgT13k+h4oLsuEdm-FQ0_VO47kcgx050B40-oVOw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 00/13] virtio: introduce support for GSO over UDP tunnel
To: Paolo Abeni <pabeni@redhat.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Dmitry Fleytman <dmitry.fleytman@gmail.com>, Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Jason Wang <jasowang@redhat.com>, Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
	Luigi Rizzo <lrizzo@google.com>, Giuseppe Lettieri <g.lettieri@iet.unipi.it>, 
	Vincenzo Maffione <v.maffione@gmail.com>, Eric Blake <eblake@redhat.com>, 
	Markus Armbruster <armbru@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2025 at 5:05=E2=80=AFPM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 7/14/25 10:43 AM, Lei Yang wrote:
> > Does the compile of this series of patches require support for a
> > special kernel environment? I hit a compile issue after applied you
> > patches:
> > [1440/2928] Compiling C object libsystem.a.p/hw_virtio_vhost.c.o
> > FAILED: libsystem.a.p/hw_virtio_vhost.c.o
> > cc -m64 -Ilibsystem.a.p -I. -I.. -Isubprojects/dtc/libfdt
> > -I../subprojects/dtc/libfdt -Isubprojects/libvduse
> > -I../subprojects/libvduse -Iui -Iqapi -Itrace -Iui/shader
> > -I/usr/include/pixman-1 -I/usr/include/glib-2.0
> > -I/usr/lib64/glib-2.0/include -I/usr/include/libmount
> > -I/usr/include/blkid -I/usr/include/sysprof-6
> > -I/usr/include/gio-unix-2.0 -I/usr/include/slirp
> > -fdiagnostics-color=3Dauto -Wall -Winvalid-pch -Werror -std=3Dgnu11 -O0=
 -g
> > -fstack-protector-strong -Wempty-body -Wendif-labels
> > -Wexpansion-to-defined -Wformat-security -Wformat-y2k
> > -Wignored-qualifiers -Wimplicit-fallthrough=3D2 -Winit-self
> > -Wmissing-format-attribute -Wmissing-prototypes -Wnested-externs
> > -Wold-style-declaration -Wold-style-definition -Wredundant-decls
> > -Wshadow=3Dlocal -Wstrict-prototypes -Wtype-limits -Wundef -Wvla
> > -Wwrite-strings -Wno-missing-include-dirs -Wno-psabi
> > -Wno-shift-negative-value -isystem
> > /mnt/tests/distribution/command/qemu/linux-headers -isystem
> > linux-headers -iquote . -iquote /mnt/tests/distribution/command/qemu
> > -iquote /mnt/tests/distribution/command/qemu/include -iquote
> > /mnt/tests/distribution/command/qemu/host/include/x86_64 -iquote
> > /mnt/tests/distribution/command/qemu/host/include/generic -iquote
> > /mnt/tests/distribution/command/qemu/tcg/i386 -pthread -mcx16 -msse2
> > -D_GNU_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_LARGEFILE_SOURCE
> > -fno-strict-aliasing -fno-common -fwrapv -ftrivial-auto-var-init=3Dzero
> > -fzero-call-used-regs=3Dused-gpr -fPIE -DWITH_GZFILEOP -DCONFIG_SOFTMMU
> > -DCOMPILING_SYSTEM_VS_USER -MD -MQ libsystem.a.p/hw_virtio_vhost.c.o
> > -MF libsystem.a.p/hw_virtio_vhost.c.o.d -o
> > libsystem.a.p/hw_virtio_vhost.c.o -c ../hw/virtio/vhost.c
> > ../hw/virtio/vhost.c: In function =E2=80=98vhost_dev_set_features=E2=80=
=99:
> > ../hw/virtio/vhost.c:38:9: error: =E2=80=98r=E2=80=99 may be used unini=
tialized
> > [-Werror=3Dmaybe-uninitialized]
> >    38 |         error_report(fmt ": %s (%d)", ## __VA_ARGS__, \
> >       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    39 |                      strerror(-retval), -retval); \
> >       |                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > ../hw/virtio/vhost.c:1006:9: note: in expansion of macro =E2=80=98VHOST=
_OPS_DEBUG=E2=80=99
> >  1006 |         VHOST_OPS_DEBUG(r, "extended features without device su=
pport");
> >       |         ^~~~~~~~~~~~~~~
> > ../hw/virtio/vhost.c:989:9: note: =E2=80=98r=E2=80=99 was declared here
> >   989 |     int r;
> >       |         ^
> > cc1: all warnings being treated as errors
> > ninja: build stopped: subcommand failed.
> > make[1]: *** [Makefile:168: run-ninja] Error 1
> > make[1]: Leaving directory '/mnt/tests/distribution/command/qemu/build'
> > make[1]: Entering directory '/mnt/tests/distribution/command/qemu/build=
'
> > [1/1493] Generating subprojects/dtc/version_gen.h with a custom command
> > [2/1493] Generating qemu-version.h with a custom command (wrapped by
> > meson to capture output)
> > [3/1492] Compiling C object libsystem.a.p/hw_virtio_vhost.c.o
> > FAILED: libsystem.a.p/hw_virtio_vhost.c.o
> > cc -m64 -Ilibsystem.a.p -I. -I.. -Isubprojects/dtc/libfdt
> > -I../subprojects/dtc/libfdt -Isubprojects/libvduse
> > -I../subprojects/libvduse -Iui -Iqapi -Itrace -Iui/shader
> > -I/usr/include/pixman-1 -I/usr/include/glib-2.0
> > -I/usr/lib64/glib-2.0/include -I/usr/include/libmount
> > -I/usr/include/blkid -I/usr/include/sysprof-6
> > -I/usr/include/gio-unix-2.0 -I/usr/include/slirp
> > -fdiagnostics-color=3Dauto -Wall -Winvalid-pch -Werror -std=3Dgnu11 -O0=
 -g
> > -fstack-protector-strong -Wempty-body -Wendif-labels
> > -Wexpansion-to-defined -Wformat-security -Wformat-y2k
> > -Wignored-qualifiers -Wimplicit-fallthrough=3D2 -Winit-self
> > -Wmissing-format-attribute -Wmissing-prototypes -Wnested-externs
> > -Wold-style-declaration -Wold-style-definition -Wredundant-decls
> > -Wshadow=3Dlocal -Wstrict-prototypes -Wtype-limits -Wundef -Wvla
> > -Wwrite-strings -Wno-missing-include-dirs -Wno-psabi
> > -Wno-shift-negative-value -isystem
> > /mnt/tests/distribution/command/qemu/linux-headers -isystem
> > linux-headers -iquote . -iquote /mnt/tests/distribution/command/qemu
> > -iquote /mnt/tests/distribution/command/qemu/include -iquote
> > /mnt/tests/distribution/command/qemu/host/include/x86_64 -iquote
> > /mnt/tests/distribution/command/qemu/host/include/generic -iquote
> > /mnt/tests/distribution/command/qemu/tcg/i386 -pthread -mcx16 -msse2
> > -D_GNU_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_LARGEFILE_SOURCE
> > -fno-strict-aliasing -fno-common -fwrapv -ftrivial-auto-var-init=3Dzero
> > -fzero-call-used-regs=3Dused-gpr -fPIE -DWITH_GZFILEOP -DCONFIG_SOFTMMU
> > -DCOMPILING_SYSTEM_VS_USER -MD -MQ libsystem.a.p/hw_virtio_vhost.c.o
> > -MF libsystem.a.p/hw_virtio_vhost.c.o.d -o
> > libsystem.a.p/hw_virtio_vhost.c.o -c ../hw/virtio/vhost.c
> > ../hw/virtio/vhost.c: In function =E2=80=98vhost_dev_set_features=E2=80=
=99:
> > ../hw/virtio/vhost.c:38:9: error: =E2=80=98r=E2=80=99 may be used unini=
tialized
> > [-Werror=3Dmaybe-uninitialized]
> >    38 |         error_report(fmt ": %s (%d)", ## __VA_ARGS__, \
> >       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    39 |                      strerror(-retval), -retval); \
> >       |                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > ../hw/virtio/vhost.c:1006:9: note: in expansion of macro =E2=80=98VHOST=
_OPS_DEBUG=E2=80=99
> >  1006 |         VHOST_OPS_DEBUG(r, "extended features without device su=
pport");
> >       |         ^~~~~~~~~~~~~~~
> > ../hw/virtio/vhost.c:989:9: note: =E2=80=98r=E2=80=99 was declared here
> >   989 |     int r;
> >       |         ^
> > cc1: all warnings being treated as errors
> > ninja: build stopped: subcommand failed.
> > make[1]: *** [Makefile:168: run-ninja] Error 1
> > make[1]: Leaving directory '/mnt/tests/distribution/command/qemu/build'
>
> Thank you for reporting the problem.
>
> No special kernel requirement to build the series, the above is just a
> gross mistake on my side in patch 7/13. If you want to test the series,
> please apply incrementally the following diff.
>
> What baffles me is that gcc 14.3.1 and 11.5.0 are not raising the
> warning (that looks legit/correct) here.
>
> I'll fix the above in the next revision.
>
> Note that you need a running kernel based on current net-next tree in
> both the hypervisor and the guest to actually leverage the new feature.

Ok, I will test this series again and update the test results.

Thanks
Lei
>
> Thanks,
>
> Paolo
> ---
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index 2eee9b0886..c4eab5ce08 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -1003,8 +1003,8 @@ static int vhost_dev_set_features(struct vhost_dev
> *dev,
>
>      if (virtio_features_use_extended(features) &&
>          !dev->vhost_ops->vhost_set_features_ex) {
> -        VHOST_OPS_DEBUG(r, "extended features without device support");
>          r =3D -EINVAL;
> +        VHOST_OPS_DEBUG(r, "extended features without device support");
>          goto out;
>      }
>



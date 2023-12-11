Return-Path: <kvm+bounces-4112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E67E480DD8A
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 22:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 927D41F21A8C
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 21:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA3254FB0;
	Mon, 11 Dec 2023 21:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="citPtmqo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777FDD2
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 13:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702331415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kfby9h2X+ETcxXvZQB4iewUtiQEuEDDiQNei7fOj1mg=;
	b=citPtmqoqE/ETLcxtridq+ZoKnWG3/EdcoR3oXNtJ5eXrnwZUTDw6UlWyscz0Wi3lFjfuZ
	DpyIUmGrLxnGv+gBlHJPiDDoRsicEnJFB2cRmY9m8Vdmi0f4PYYNgVjYT+TmPJzvBQkSZB
	N9ZENZJR66OPC4vsKRvja7ivNnjTUjg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-jb5SEQzzM3a1mRrTgOahzA-1; Mon, 11 Dec 2023 16:50:14 -0500
X-MC-Unique: jb5SEQzzM3a1mRrTgOahzA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-50be6eae316so3630804e87.0
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 13:50:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702331409; x=1702936209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kfby9h2X+ETcxXvZQB4iewUtiQEuEDDiQNei7fOj1mg=;
        b=gIJTNDcOr/6AAsQvJ/s9t5Hy9uI+2tgqZZ0fFTDuAdzeiVbW/R5lurwtRiGRWSn7kO
         yc74HxUt8t7POaSMfcw1tpGBx5MmFtdjPm+TqvYwWx4ljS3yxPuSERLaW7JKqs6o7bpJ
         TopRrCsWA9UCXZCDX0mp82gMAk+VCi6FpXo3InsNxXLl0+cNz7lUeqAkP0JK6QE/LLyt
         KRUhjB6arLJYL1l1HgVqxSv46zbYXn5LzzovYcD/0BbTxfZ4+mt7ZA3SKbUU6VzRdivg
         l+gM+5rVCJRz11CEt7rP0AuXip6uRNfTXFR2anVhz5xOXOJNULFvpbX5iEkKMxiktZD5
         p/XQ==
X-Gm-Message-State: AOJu0YzigGhhFYSl9pmOKwyFE98LKaJN/7peodom5t4UVgmyN2/KGH1w
	K/lRDklu33aHdlTmHAzMf5FHTuWfNI/N260ZVEEl557kMCS17HYhhhtVolPTIJYLLJ7exON1scs
	pNnAKpWySsPZnSPOJWsQx0sOgcGmZ
X-Received: by 2002:ac2:5f48:0:b0:50b:f88d:f83b with SMTP id 8-20020ac25f48000000b0050bf88df83bmr1296647lfz.78.1702331409039;
        Mon, 11 Dec 2023 13:50:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IELwYuI9z4Zk30LZyKvnG2Fl3l1hi1+7dZbZc9jqNmcKtEqcNd2qVVuZVPj4FvG18scDcekQF9FmbxlQPn/gME=
X-Received: by 2002:ac2:5f48:0:b0:50b:f88d:f83b with SMTP id
 8-20020ac25f48000000b0050bf88df83bmr1296631lfz.78.1702331408742; Mon, 11 Dec
 2023 13:50:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230420120948.436661-1-stefanha@redhat.com> <20230420120948.436661-21-stefanha@redhat.com>
 <CAC1VKkMadcEV4+UwXQQEONTBnw=xfmFC2MeUoruMRNkOLK0+qg@mail.gmail.com> <20231207111110.GA2132561@fedora>
In-Reply-To: <20231207111110.GA2132561@fedora>
From: Carlos Santos <casantos@redhat.com>
Date: Mon, 11 Dec 2023 18:49:57 -0300
Message-ID: <CAC1VKkP8HgFPnMjFYVGgSDCj6rStzMVS7VrD=bs43zddSsMCCw@mail.gmail.com>
Subject: Re: [PULL 20/20] tracing: install trace events file only if necessary
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, Raphael Norwitz <raphael.norwitz@nutanix.com>, 
	Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Julia Suvorova <jusual@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org, 
	Cornelia Huck <cohuck@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Peter Maydell <peter.maydell@linaro.org>, Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org, 
	Hanna Reitz <hreitz@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Aarushi Mehta <mehta.aaru20@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 11, 2023 at 4:58=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.co=
m> wrote:
>
> On Wed, Dec 06, 2023 at 07:26:01AM -0300, Carlos Santos wrote:
> > On Thu, Apr 20, 2023 at 9:10=E2=80=AFAM Stefan Hajnoczi <stefanha@redha=
t.com> wrote:
> > >
> > > From: Carlos Santos <casantos@redhat.com>
> > >
> > > It is not useful when configuring with --enable-trace-backends=3Dnop.
> > >
> > > Signed-off-by: Carlos Santos <casantos@redhat.com>
> > > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > Message-Id: <20230408010410.281263-1-casantos@redhat.com>
> > > ---
> > >  trace/meson.build | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/trace/meson.build b/trace/meson.build
> > > index 8e80be895c..30b1d942eb 100644
> > > --- a/trace/meson.build
> > > +++ b/trace/meson.build
> > > @@ -64,7 +64,7 @@ trace_events_all =3D custom_target('trace-events-al=
l',
> > >                                   input: trace_events_files,
> > >                                   command: [ 'cat', '@INPUT@' ],
> > >                                   capture: true,
> > > -                                 install: true,
> > > +                                 install: get_option('trace_backends=
') !=3D [ 'nop' ],
> > >                                   install_dir: qemu_datadir)
> > >
> > >  if 'ust' in get_option('trace_backends')
> > > --
> > > 2.39.2
> > >
> >
> > Hello,
> >
> > I still don't see this in the master branch. Is there something
> > preventing it from being applied?
>
> Hi Carlos,
> Apologies, I dropped this patch when respinning the pull request after
> the CI test failures caused by the zoned patches.
>
> Your patch has been merged on my tracing tree again and will make it
> into qemu.git/master when the development window opens again after the
> QEMU 8.2.0 release (hopefully next Tuesday).
>
> Stefan

Great. Thanks!

--=20
Carlos Santos
Senior Software Maintenance Engineer
Red Hat
casantos@redhat.com    T: +55-11-3534-6186



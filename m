Return-Path: <kvm+bounces-13981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C9FF89D985
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 14:57:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3353B24490
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 12:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 628B812E1D5;
	Tue,  9 Apr 2024 12:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e3Uv88LM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC24F12DDB8
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 12:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712667412; cv=none; b=snVL2DHmxvnn4IllngrulvMEoTXUZz0sZ+4fe5vazD7/mAzVODZCxZpzAIS15+oeyVFz5+v5H7vIHXoUIE2O+2BjWOxlsuvPUt2ox8ytnX3IKIKJSSDvUMPrF9Z+uVSzjFZi9xTr0TvhnPoGc4PMJRhHd07GCNCQbUpe1eAM0ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712667412; c=relaxed/simple;
	bh=qFjj8gprOyy5QG3PDpMwH5OS6JMEOPGugaUWv8+tRvg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l2h0NMOmfUQ+WWnNo1Qpkvq5djSrPNnknOrkmnqh5yeox3GMz57MpwtHwGPHkm462UVCva5oIHpI+K4N+RGoWFWPBAPskulchU3RjoCTUZeR3qCTCFpObrACO0VWqj7GMOarLNv7kGgVF3DkqEqiqioCDkrHP0JkLuU9F795ZqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e3Uv88LM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712667409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pt0N3bL5TJP0v672v3Z/C/6PTX4AkZIvzQAggKI+KTY=;
	b=e3Uv88LMLrS9jtBM97toKs+30gYaAmBjxL6VzwMKlk1DFI8nJM6d1b+yXlE8G+g23ylOmV
	RaYyepxn3ByTh35OHZMZtVjc32cenxG6GMGxiZDTmiXafRSecsfpcnQPEUybHzrC5jlnXO
	8myNzH9qZbajXnThrG20j07+jaevDqk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-d78jWVkjN4CU3Wiw8_kVGg-1; Tue, 09 Apr 2024 08:56:48 -0400
X-MC-Unique: d78jWVkjN4CU3Wiw8_kVGg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a51cb1feb23so101260266b.1
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 05:56:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712667407; x=1713272207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pt0N3bL5TJP0v672v3Z/C/6PTX4AkZIvzQAggKI+KTY=;
        b=aKob9Ne+Yw/E1HJLLsi94Q79R1sDDE4SrXm6Ff1SZySjbtTAydZg3p0cpc5WVxHaoP
         BFxsoxwXxeuOs4GjqgbyDt9kl6Bq/dYB6qOVnDeF2mPrDRw1cQ0DQBvM40sHlscjpYBW
         AR2Mg7TsHuafsRUGIiiDX4qxN+quzNL950UrBjis1jqHci+fUaZcJ+JlIfbOqmCAOfT3
         /t1c3z/oNgb2B1im/JVRaUuw7PizdfLuSM5f/Quc9jNYeWjz7+ZJD4KRi7zF9kES83lX
         kY7YXUPJ8GZmGznT46duJ4NGXEVCDn3nIIykJ7h9jI1ICc4riU4658Nsrn/dWY45N0+f
         HjeA==
X-Forwarded-Encrypted: i=1; AJvYcCXIID6hTLxVVLSPKhs0G8qwp164WN5A2C9H+rqYXFDbIqoxfA0bO6P976ZW1r8+pTqNaE18dHJoM1uPnTRUW+fzzTh0
X-Gm-Message-State: AOJu0YzTVu9EunEm6Dio7Skf/dDZzm/e5qlBBVgK9NveEAFuLDZh6jTn
	mpscPLYSBkfX88sWKUXGNz/WwvsgFXv/DuJetaDevLiR2ysvT6g33zQKLVUnJQSmUfToxm7lUra
	MkMCe1dX597/tkpo95ycexj9Xd70IoBZ4Xs8mwiJdCndV9ZekdMBhOvIzddi7bdLl1QgdZ9IfXT
	upktk+LALWQSe1hh9ms4YoydJrzc7w+21m
X-Received: by 2002:a17:906:6889:b0:a51:a688:3e9c with SMTP id n9-20020a170906688900b00a51a6883e9cmr6917742ejr.35.1712667406308;
        Tue, 09 Apr 2024 05:56:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoJWDaZk2RdQUZFsUUYdQeQjnpvYmMrAlJni0v8Qmi8hoHGlbaqGBCHz7xfsMA25ZelFLfveAk8CK5Iy6mxH0=
X-Received: by 2002:a17:906:6889:b0:a51:a688:3e9c with SMTP id
 n9-20020a170906688900b00a51a6883e9cmr6916714ejr.35.1712667365422; Tue, 09 Apr
 2024 05:56:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240404055635.316259-1-lulu@redhat.com> <20240408033804-mutt-send-email-mst@kernel.org>
 <CACLfguUL=Kteorvyn=wRUWFJFvhvgRyp+V7GNBp2R33hK1vnSw@mail.gmail.com> <20240408085008-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240408085008-mutt-send-email-mst@kernel.org>
From: Cindy Lu <lulu@redhat.com>
Date: Tue, 9 Apr 2024 20:55:23 +0800
Message-ID: <CACLfguWC3LruVfLndc4vzpzOuomEz-+nHY0KENZ6iiXNB728eg@mail.gmail.com>
Subject: Re: [PATCH v3] Documentation: Add reconnect process for VDUSE
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: jasowang@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 8, 2024 at 8:50=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> On Mon, Apr 08, 2024 at 08:39:21PM +0800, Cindy Lu wrote:
> > On Mon, Apr 8, 2024 at 3:40=E2=80=AFPM Michael S. Tsirkin <mst@redhat.c=
om> wrote:
> > >
> > > On Thu, Apr 04, 2024 at 01:56:31PM +0800, Cindy Lu wrote:
> > > > Add a document explaining the reconnect process, including what the
> > > > Userspace App needs to do and how it works with the kernel.
> > > >
> > > > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > > > ---
> > > >  Documentation/userspace-api/vduse.rst | 41 +++++++++++++++++++++++=
++++
> > > >  1 file changed, 41 insertions(+)
> > > >
> > > > diff --git a/Documentation/userspace-api/vduse.rst b/Documentation/=
userspace-api/vduse.rst
> > > > index bdb880e01132..7faa83462e78 100644
> > > > --- a/Documentation/userspace-api/vduse.rst
> > > > +++ b/Documentation/userspace-api/vduse.rst
> > > > @@ -231,3 +231,44 @@ able to start the dataplane processing as foll=
ows:
> > > >     after the used ring is filled.
> > > >
> > > >  For more details on the uAPI, please see include/uapi/linux/vduse.=
h.
> > > > +
> > > > +HOW VDUSE devices reconnection works
> > > > +------------------------------------
> > > > +1. What is reconnection?
> > > > +
> > > > +   When the userspace application loads, it should establish a con=
nection
> > > > +   to the vduse kernel device. Sometimes,the userspace application=
 exists,
> > > > +   and we want to support its restart and connect to the kernel de=
vice again
> > > > +
> > > > +2. How can I support reconnection in a userspace application?
> > > > +
> > > > +2.1 During initialization, the userspace application should first =
verify the
> > > > +    existence of the device "/dev/vduse/vduse_name".
> > > > +    If it doesn't exist, it means this is the first-time for conne=
ction. goto step 2.2
> > > > +    If it exists, it means this is a reconnection, and we should g=
oto step 2.3
> > > > +
> > > > +2.2 Create a new VDUSE instance with ioctl(VDUSE_CREATE_DEV) on
> > > > +    /dev/vduse/control.
> > > > +    When ioctl(VDUSE_CREATE_DEV) is called, kernel allocates memor=
y for
> > > > +    the reconnect information. The total memory size is PAGE_SIZE*=
vq_mumber.
> > >
> > > Confused. Where is that allocation, in code?
> > >
> > > Thanks!
> > >
> > this should allocated in function vduse_create_dev(),
>
> I mean, it's not allocated there ATM right? This is just doc patch
> to become part of a larger patchset?
>
Got it, thanks Michael I will send the whole patchset soon
thanks
Cindy

> > I will rewrite
> > this part  to make it more clearer
> > will send a new version soon
> > Thanks
> > cindy
> >
> > > > +2.3 Check if the information is suitable for reconnect
> > > > +    If this is reconnection :
> > > > +    Before attempting to reconnect, The userspace application need=
s to use the
> > > > +    ioctl(VDUSE_DEV_GET_CONFIG, VDUSE_DEV_GET_STATUS, VDUSE_DEV_GE=
T_FEATURES...)
> > > > +    to get the information from kernel.
> > > > +    Please review the information and confirm if it is suitable to=
 reconnect.
> > > > +
> > > > +2.4 Userspace application needs to mmap the memory to userspace
> > > > +    The userspace application requires mapping one page for every =
vq. These pages
> > > > +    should be used to save vq-related information during system ru=
nning. Additionally,
> > > > +    the application must define its own structure to store informa=
tion for reconnection.
> > > > +
> > > > +2.5 Completed the initialization and running the application.
> > > > +    While the application is running, it is important to store rel=
evant information
> > > > +    about reconnections in mapped pages. When calling the ioctl VD=
USE_VQ_GET_INFO to
> > > > +    get vq information, it's necessary to check whether it's a rec=
onnection. If it is
> > > > +    a reconnection, the vq-related information must be get from th=
e mapped pages.
> > > > +
> > > > +2.6 When the Userspace application exits, it is necessary to unmap=
 all the
> > > > +    pages for reconnection
> > > > --
> > > > 2.43.0
> > >
>



Return-Path: <kvm+bounces-17414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE448C5F43
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 04:49:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0AF91C21797
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 02:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49347374FA;
	Wed, 15 May 2024 02:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gy4k4Dy6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77139374C3
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 02:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715741341; cv=none; b=kVjC9Q7Ex3zt0ZkIx5lK3fU0lB0fXd2cA12qsx9SADg0DDDN27nd25XMEGqvbdZeOLg8tiLBBkxrniVExXgTL/HnPcQ0vXJFnYF+CDKl5zWBKSXEdSlj3ALzUVwYo1JsyozTF8I8AfY2rxfYWTGYXkUPQg1Ty8QUWGxRzdemA/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715741341; c=relaxed/simple;
	bh=3p9V5oslK4x8aMOhrMUROLRNJj4lh4gSrktdUCFGPes=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U88qY+thj474F0qG7CUs4NmrXRndsOf9KTLY8JwtJToG53GT5sUg4kdClg+e23PE4oi0XHKXhqinASyVxALJFPPi85bDxl8K9Niz1OwV9H6mMkUYyhBgXqCt//QTr6iv8GTrA01ZVhbzPfFzndx9GHw8JB0RxUOQP21Gj6y1rx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gy4k4Dy6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715741338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TtHI1Bhd9NWtrp+GeDGa3Emd+Y2AqBnGkmYsic8ZRZk=;
	b=Gy4k4Dy6sOwqf5iOPXpkWu5vuIQ+6BqxwmIcDHFXld5kfi4Y+8i58+MkbE9dmOX16/nZ4F
	6fFxUhJKTqYv6cTztwzT+2HMyiP4fidyAcFhc/ScsVHFe9mORzPY0oPVfwQtAW5K6ELP0+
	l+Na1KLQaYZJ4yZAJhTUCwikZRrz5XI=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-lN9uNsFfPjyWh7c-EOCf8w-1; Tue, 14 May 2024 22:48:56 -0400
X-MC-Unique: lN9uNsFfPjyWh7c-EOCf8w-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2b2d29dce36so5188998a91.2
        for <kvm@vger.kernel.org>; Tue, 14 May 2024 19:48:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715741335; x=1716346135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TtHI1Bhd9NWtrp+GeDGa3Emd+Y2AqBnGkmYsic8ZRZk=;
        b=KJq4nu9miqhnrMw7dOGLH+eOVDRWuWkUKL6ve0H702IM21tuC3NxZKx5kTLD6AyOaI
         Nbb5JPS1oTBeXyG9QaLgqfaiRDCdfuOHCbiiOFU3dLpWGWfMdLKEqF7TlF4gOo1gYRqm
         XCm8uQXaLFCuauRrKsd2jTIwyXGg0w2qDTaRV6zZuPensMzSr6lrfPZwJcfFFffCK/KZ
         4nlmxjYWFxhYoUVg4HOiW7klSsia2Obum7E5ZNptky4/dBSyqaB9suGNz8BgiXMxKjkx
         oNhvwF9Er4xeC1tWh/AAd6xzG6BhgNM4+0KCmVJJx6yT4MGoTtPGmK204Bh1s+RxGbtT
         MmSw==
X-Gm-Message-State: AOJu0YwhOa7yA0E3I/DCMbAg5tzalV3+YwCzIEc3RBYFUiNTslbtpSl8
	sxLgAMnWTU7KztZMdkZKC9qEn9fO7wqXaDH5UJFO2LEHi/O3pg/1JgyOjL+E5nRPfKeTaFcX8XD
	0/peakS8VhZWhEGC2EflQksQkJD7XEnlylflO5KMowfeUOMxEB1Ev7iKiAia+6+53kDA1TtcZJI
	W8N2sIZVt7jaen7zrrj+sAZ93O
X-Received: by 2002:a17:90a:5918:b0:2b5:90f8:d590 with SMTP id 98e67ed59e1d1-2b6cc44fa48mr11618122a91.18.1715741335311;
        Tue, 14 May 2024 19:48:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0Q9Ab5uuZ3wtyOBfo/FOaYePVZUxA0d5QS43POWx81aX4RbzZRg25sv2e9uxsCCKq9Ex0RiLo8UJbmdsTbLo=
X-Received: by 2002:a17:90a:5918:b0:2b5:90f8:d590 with SMTP id
 98e67ed59e1d1-2b6cc44fa48mr11618113a91.18.1715741334886; Tue, 14 May 2024
 19:48:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1710566754-3532-1-git-send-email-zhanglikernel@gmail.com>
 <CACGkMEs1t-ipP7TasHkKNKd=peVEES6Xdw1zSsJkb-bc9Etx9Q@mail.gmail.com> <CAAa-AGm1gYmeBG1QmZcdc0cPUeVGYU9UaFNdCdgu2+gG88A1Wg@mail.gmail.com>
In-Reply-To: <CAAa-AGm1gYmeBG1QmZcdc0cPUeVGYU9UaFNdCdgu2+gG88A1Wg@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 15 May 2024 10:48:43 +0800
Message-ID: <CACGkMEth_9Baewekq862YgZwuozwG96Z3G6oYqHzyCj2JPUZ3g@mail.gmail.com>
Subject: Re: [PATCH]virtio-pci: Check if is_avq is NULL
To: li zhang <zhanglikernel@gmail.com>
Cc: kvm@vger.kernel.org, 
	virtualization <virtualization@lists.linux-foundation.org>, 
	Michael Tsirkin <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 14, 2024 at 11:37=E2=80=AFPM li zhang <zhanglikernel@gmail.com>=
 wrote:
>
> Hi,
> Two months have passed and this bug seems to have not been fixed.
> Sincerely,
> Li Zhang

Adding Michael and virtualization-list.

Please use get_maintainer.pl to make sure the patch reaches the maintainer.

Thanks

>
> Jason Wang <jasowang@redhat.com> =E4=BA=8E2024=E5=B9=B43=E6=9C=8821=E6=97=
=A5=E5=91=A8=E5=9B=9B 14:19=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Sat, Mar 16, 2024 at 1:26=E2=80=AFPM Li Zhang <zhanglikernel@gmail.c=
om> wrote:
> > >
> > > [bug]
> > > In the virtio_pci_common.c function vp_del_vqs, vp_dev->is_avq is inv=
olved
> > > to determine whether it is admin virtqueue, but this function vp_dev-=
>is_avq
> > >  may be empty. For installations, virtio_pci_legacy does not assign a=
 value
> > >  to vp_dev->is_avq.
> > >
> > > [fix]
> > > Check whether it is vp_dev->is_avq before use.
> > >
> > > [test]
> > > Test with virsh Attach device
> > > Before this patch, the following command would crash the guest system
> > >
> > > After applying the patch, everything seems to be working fine.
> > >
> > > Signed-off-by: Li Zhang <zhanglikernel@gmail.com>
> >
> > Acked-by: Jason Wang <jasowang@redhat.com>
> >
> > Thanks
> >
> > > ---
> > >  drivers/virtio/virtio_pci_common.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virt=
io_pci_common.c
> > > index b655fcc..3c18fc1 100644
> > > --- a/drivers/virtio/virtio_pci_common.c
> > > +++ b/drivers/virtio/virtio_pci_common.c
> > > @@ -236,7 +236,7 @@ void vp_del_vqs(struct virtio_device *vdev)
> > >         int i;
> > >
> > >         list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
> > > -               if (vp_dev->is_avq(vdev, vq->index))
> > > +               if (vp_dev->is_avq && vp_dev->is_avq(vdev, vq->index)=
)
> > >                         continue;
> > >
> > >                 if (vp_dev->per_vq_vectors) {
> > > --
> > > 1.8.3.1
> > >
> > >
> >
> >
>



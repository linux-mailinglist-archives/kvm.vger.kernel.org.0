Return-Path: <kvm+bounces-11778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 310B687B6BA
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 04:12:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A79F1F238EF
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 03:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30530523C;
	Thu, 14 Mar 2024 03:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KjN35+a2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3880211C
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 03:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710385961; cv=none; b=JE2WZKg9bQv1tbVzyzR+5VvtEB5gcsGmBeLLRzuNG4kc65lYQ2nCtkffJvBqKO4vO1P2Sy5Rjtb/6ikOIjLxIHdfl4FKDgx3TLfXYZcB9IjDZkL+tA5lo0KX1WVoJLlVhV1+Kvn49Ep0SrNYL4vCvprc4upEAzjJsApahEHurCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710385961; c=relaxed/simple;
	bh=bXjlov1+xgNpyNB5/H0sUGt9aauzEi+JWNlLMri0PVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pgnxqUeLUljLALnGZM3OfEbCVKH9bmBd4n2hOB5Cb8t8Q8ethkDSgseghh6/LDPIO2kbsjN/+y2yv29fiB/qq7h3ZCSng0hgxoXUGVYlhPlhHjyNuL5l3KDQzDINZTiqjpMfZGK3br+jeoEUTZe12nPwOsK1tor+nUrqbvQiGyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KjN35+a2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710385958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ujVLStF8fNwjZHlFP85Jc/cq8HmkRWbLvyNFVb8jE2E=;
	b=KjN35+a24zDpXSCcAyy1CY5AgZV287zRJg/H26Qg+Wul8D3iJ/vAquhZihpc1wszHJykGy
	QTztO/fVtIvC3oSqp7WlYpjavbIp1OcISXCcp+40AQlqiPy4z/vrB50tOIQPVpoSynf/zV
	IGM490uDeJLP2sBci9uD0wa3zBlb2Ao=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-BdktoEp4NTKMe8MWBfqJ4Q-1; Wed, 13 Mar 2024 23:12:36 -0400
X-MC-Unique: BdktoEp4NTKMe8MWBfqJ4Q-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-29c367c23c6so538031a91.0
        for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 20:12:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710385955; x=1710990755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ujVLStF8fNwjZHlFP85Jc/cq8HmkRWbLvyNFVb8jE2E=;
        b=O5IHZW/GGwWDlPewOT6OCblrB1IM6xnFeCvUOHn6xE9R30YIN9CBo9iZtkuog6Rvs8
         zz3SvNNNd3GjJG627tgybep6N88uIs71j4CVxJC+sq0L5/9zSIxcWHlXTbakelpy4ImD
         BpqWG9DKu/Xlu/uKkc3VMLAFSpYs+vQJL7VeYSWjUGI1KhZLS4H/r7ai+hFtVmML3DpH
         UrDXkcIDKZKaIOgVORtUmC5sGI1quqvtPQ1LEdcOw8QblbvXvZ7R1ZzlGB3tcVSRT2P9
         YfiYMFvy9JzVlP8HypJws9I/M+id19V1Lyi6Mca3e3FQ6xM1gQ3WtNBERMy6QYyT4hD5
         h7+g==
X-Forwarded-Encrypted: i=1; AJvYcCWbfb25M/WUc/r5SR3dCEhZG1hvK3Gr5Xt9mW/qMs/S41UGcprZPiiSQUUq3jFCXZPpb8PCM8AfdbS6ofX9Gt5p5QPg
X-Gm-Message-State: AOJu0YybRBwceeaTfRGo7bhihkgmoCxHXFer7U8upRuGWSDtoJk2+2BP
	CVLROwJwTzoA5gB3w7KbvJB5nePsGoSesIpuxzbFi+tYEhVWvdOAZNgMhNAxdhziPMMaA6mV6Ph
	n6+FJ1N5EQxcq0+d52NtrSu7vu9aYoTOad+ZLJo4vjIcC5m364JN6mE8gSA4dNvH71HT5Pvna6M
	iD1APeWSIjSlZybCpndJ5LhHBY
X-Received: by 2002:a17:90b:1115:b0:29b:dc5c:d534 with SMTP id gi21-20020a17090b111500b0029bdc5cd534mr556795pjb.29.1710385955617;
        Wed, 13 Mar 2024 20:12:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgnFIYDkamcOx1cys2VlJt8HrQE2eq5Dv8Fg1l35A9jQKw+iznC+SY6FdtZSdCDKBufcIfbsUlkHcDHjjBuKE=
X-Received: by 2002:a17:90b:1115:b0:29b:dc5c:d534 with SMTP id
 gi21-20020a17090b111500b0029bdc5cd534mr556779pjb.29.1710385955375; Wed, 13
 Mar 2024 20:12:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240312021013.88656-1-xuanzhuo@linux.alibaba.com> <20240312021013.88656-2-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20240312021013.88656-2-xuanzhuo@linux.alibaba.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 14 Mar 2024 11:12:24 +0800
Message-ID: <CACGkMEvVgfgAxLoKeFTgy-1GR0W07ciPYFuqs6PiWtKCnXuWTw@mail.gmail.com>
Subject: Re: [PATCH vhost v3 1/4] virtio: find_vqs: pass struct instead of
 multi parameters
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Hans de Goede <hdegoede@redhat.com>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Vadim Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck <cohuck@redhat.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, linux-um@lists.infradead.org, 
	platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
	linux-s390@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 12, 2024 at 10:10=E2=80=AFAM Xuan Zhuo <xuanzhuo@linux.alibaba.=
com> wrote:
>
> Now, we pass multi parameters to find_vqs. These parameters
> may work for transport or work for vring.
>
> And find_vqs has multi implements in many places:
>
>  arch/um/drivers/virtio_uml.c
>  drivers/platform/mellanox/mlxbf-tmfifo.c
>  drivers/remoteproc/remoteproc_virtio.c
>  drivers/s390/virtio/virtio_ccw.c
>  drivers/virtio/virtio_mmio.c
>  drivers/virtio/virtio_pci_legacy.c
>  drivers/virtio/virtio_pci_modern.c
>  drivers/virtio/virtio_vdpa.c
>
> Every time, we try to add a new parameter, that is difficult.
> We must change every find_vqs implement.
>
> One the other side, if we want to pass a parameter to vring,
> we must change the call path from transport to vring.
> Too many functions need to be changed.
>
> So it is time to refactor the find_vqs. We pass a structure
> cfg to find_vqs(), that will be passed to vring by transport.
>
> Because the vp_modern_create_avq() use the "const char *names[]",
> and the virtio_uml.c changes the name in the subsequent commit, so
> change the "names" inside the virtio_vq_config from "const char *const
> *names" to "const char **names".
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> Reviewed-by: Ilpo J=3DE4rvinen <ilpo.jarvinen@linux.intel.com>

The name seems broken here.

[...]

>
>  typedef void vq_callback_t(struct virtqueue *);
>
> +/**
> + * struct virtio_vq_config - configure for find_vqs()
> + * @cfg_idx: Used by virtio core. The drivers should set this to 0.
> + *     During the initialization of each vq(vring setup), we need to kno=
w which
> + *     item in the array should be used at that time. But since the item=
 in
> + *     names can be null, which causes some item of array to be skipped,=
 we
> + *     cannot use vq.index as the current id. So add a cfg_idx to let vr=
ing
> + *     know how to get the current configuration from the array when
> + *     initializing vq.

So this design is not good. If it is not something that the driver
needs to care about, the core needs to hide it from the API.

Thanks



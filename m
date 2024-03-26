Return-Path: <kvm+bounces-12655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9032A88B970
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 05:28:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C20911C31B27
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 04:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C262512AACF;
	Tue, 26 Mar 2024 04:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bWnTGxt5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9FD12A17C
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 04:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711427330; cv=none; b=k01iIR6e9YzbXrFgJdgR7sBg2UYncBvtR38/GvIHc5ewetDU7sukExZU/ngzl5qjdvM1mu0LI1hB43o82xLOQ1GcumMVI45ixlqfenHXkyBKb4MlGoLT4fHFbe3L6/ecwzVx35YBwYUL7BJz8pPFn3Gy6YTWIUhX3UUeyL7ymGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711427330; c=relaxed/simple;
	bh=9ltv4DwYwWj7kB/fZ2mzOIYt06/xNjINGiA4oBElaQk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PHW5h9cmuDuycIbMdJFwyl7xWojAjIdFmAP//roLyu/++h82N3j16K/e914FdAYWvuYwWTPUcIJCFb9vOraKFs7OF0KH1CIzb6gQRn4SEy4fwBicBJr2Qc7sH1rALvQPjiqnMvzoGJMnf1rzfHN/uVtg9xRPOG61h50KT0Of3is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bWnTGxt5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711427328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VYJdaPfqxCLnNgCpNcotB2CUqnM+IpEVFvBowNr66ZI=;
	b=bWnTGxt57Jw68JSHBQApJ5MZD0yIG34J8ok39h5eny3Hk35cuG7Fg3fZmwO1ZVZS41aqsM
	Hw5Je5YaDvtn6sX1ru5TEiO7a+isbA4JqrG3Q/dSKSqfTfDnUjlQfRWg2NHTNG+YvpwGqG
	XKCWKXw//OSGFShdetQZ3T7QGqC6/EQ=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-gfQCRYNwNYWynrZ2-BEypw-1; Tue, 26 Mar 2024 00:28:46 -0400
X-MC-Unique: gfQCRYNwNYWynrZ2-BEypw-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5d1bffa322eso4600949a12.1
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 21:28:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711427325; x=1712032125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VYJdaPfqxCLnNgCpNcotB2CUqnM+IpEVFvBowNr66ZI=;
        b=gX11HiuBMQK7KMlj0U8JKPQ634dUoWOVSBRYgFLEqwarrSy0hHSZvdZpZc4p555KbC
         XLlipZNYOYPPSqBeEMYqOpKkcf/wxMSc3eZ/8DVDf2qNeDhRThRAcNozkash8WGKjyKB
         WHCqGKa51d5aLv+M5e22BgRCA6u83smJMFdIk9NamVoVQXXlkErct4NJTjagYvHJfs/M
         ImY1G54JQgKSDBcGXTYKgCb8W/1xHZir5yRR8jFpYweSh98vspUghWE7zH539rkaEOi1
         RRHMyw81qmRjzVNhIPnDzm1KTG6JV1UJJcicD+3DlGpIV7l0EgeudJy3Yi9xY+vQKG48
         5ZaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUadEFCl7RdIFAoDO96S/v/UxFExUQIfWUm+YPgGg1ZgqJ46/SJZPf3HXsuGH0L20vs02eq+mKIMhpaS9brXdb5f9Zo
X-Gm-Message-State: AOJu0Yz3h/OE7sBuq/vek4KQVYVu7UqdSSMLpHjfXlIFd4HyJQLUuspS
	vuvHpzFRY8f9lHAPm1R4Y65OEBWgbFUb0oT0AEWJbkhIObbGUE9UYKqjZ2/n1rFZj1c80sn342b
	3xW+UhFnk6RRfzl76boluQkytfrzWAG3wM7GNiwXXdNMW2IghOWkW342ys0Ji9Bw946KudIMDaC
	tO8669zR5MGc+kQhJL0qXckxye
X-Received: by 2002:a17:902:e541:b0:1e0:f550:82e2 with SMTP id n1-20020a170902e54100b001e0f55082e2mr154437plf.22.1711427325201;
        Mon, 25 Mar 2024 21:28:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYwbHtFo5NnweY6aiIQsz8qOqVwbBb5nB1OBSL78XFdIi+hU5TswumUMNoFDqt6TH1kJ3Y6QgJCf7jKybputQ=
X-Received: by 2002:a17:902:e541:b0:1e0:f550:82e2 with SMTP id
 n1-20020a170902e54100b001e0f55082e2mr154413plf.22.1711427324953; Mon, 25 Mar
 2024 21:28:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240325090419.33677-1-xuanzhuo@linux.alibaba.com> <20240325090419.33677-3-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20240325090419.33677-3-xuanzhuo@linux.alibaba.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 26 Mar 2024 12:28:34 +0800
Message-ID: <CACGkMEuuNrDkEUnnES-APDVag2=4wjyZi3aEg0+8vY+Bho=BRg@mail.gmail.com>
Subject: Re: [PATCH vhost v5 2/6] virtio: remove support for names array
 entries being null.
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Hans de Goede <hdegoede@redhat.com>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Vadim Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck <cohuck@redhat.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	David Hildenbrand <david@redhat.com>, linux-um@lists.infradead.org, 
	platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
	linux-s390@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 25, 2024 at 5:04=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> commit 6457f126c888 ("virtio: support reserved vqs") introduced this
> support. Multiqueue virtio-net use 2N as ctrl vq finally, so the logic
> doesn't apply. And not one uses this.
>
> On the other side, that makes some trouble for us to refactor the
> find_vqs() params.
>
> So I remove this support.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  arch/um/drivers/virtio_uml.c             | 5 -----
>  drivers/platform/mellanox/mlxbf-tmfifo.c | 4 ----
>  drivers/remoteproc/remoteproc_virtio.c   | 5 -----
>  drivers/s390/virtio/virtio_ccw.c         | 5 -----
>  drivers/virtio/virtio_mmio.c             | 5 -----
>  drivers/virtio/virtio_pci_common.c       | 9 ---------
>  drivers/virtio/virtio_vdpa.c             | 5 -----
>  include/linux/virtio_config.h            | 1 -
>  8 files changed, 39 deletions(-)
>
> diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> index 8adca2000e51..1d1e8654b7fc 100644
> --- a/arch/um/drivers/virtio_uml.c
> +++ b/arch/um/drivers/virtio_uml.c
> @@ -1031,11 +1031,6 @@ static int vu_find_vqs(struct virtio_device *vdev,=
 unsigned nvqs,
>                 return rc;
>
>         for (i =3D 0; i < nvqs; ++i) {
> -               if (!names[i]) {
> -                       vqs[i] =3D NULL;
> -                       continue;
> -               }

Does this mean names[i] must not be NULL? If yes, should we fail or
not? If not, do we need to change the doc?

[...]

> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -56,7 +56,6 @@ typedef void vq_callback_t(struct virtqueue *);
>   *     callbacks: array of callbacks, for each virtqueue
>   *             include a NULL entry for vqs that do not need a callback
>   *     names: array of virtqueue names (mainly for debugging)
> - *             include a NULL entry for vqs unused by driver
>   *     Returns 0 on success or error status
>   * @del_vqs: free virtqueues found by find_vqs().
>   * @synchronize_cbs: synchronize with the virtqueue callbacks (optional)


Since we had other check for names[i] like:

        if (per_vq_vectors) {
                /* Best option: one for change interrupt, one per vq. */
                nvectors =3D 1;
                for (i =3D 0; i < nvqs; ++i)
                        if (names[i] && callbacks[i])
                                ++nvectors;

in vp_find_vqs_msix() and maybe other places.

> --
> 2.32.0.3.g01195cf9f
>



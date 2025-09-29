Return-Path: <kvm+bounces-58955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6ADCBA80E2
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 08:06:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63DE6189711F
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 06:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F34023ED75;
	Mon, 29 Sep 2025 06:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cL048wyP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6AF22B8B5
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 06:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759125942; cv=none; b=noVM0ceDVa+5t4pcBbR+yIJTWODbSjKpeR/lzDj6ygj7sE8aflLobEflNfd4xA8WaZSZxFOOaAEXtjhT3EVTd6EhujXnmPUd83bNYIv9grGV/UVpBU9C51GQZjVL5J06VqN1PVldObW+ax91jahvQLHFx+6U3WSLoLSZ9QXGJ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759125942; c=relaxed/simple;
	bh=9WPqzjmiWMki4xWlLoYtm9WlKZ743i+2Jltc2U63LGU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lG97Xj9/vpKmvOV+m6EZErRY/DhXQzNHjQGN7EK+ZGQVxiIGxZ82IAoavDmKPUAxgvi2TuIIOPPee+hoPqhZktrAXslpnrj18DkDdKLYdfYEb73UHhx4Ys+YKSQrEoIUXAtePmRFubzVUDULQ+WdUQtlhix3I7ZSYhRFZ6c2eVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cL048wyP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759125938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aEnOtbURDkBn/yuAWcxy2EnBdqVr8YnzLqFxCwWilb8=;
	b=cL048wyPGBB/q1YBW5mK9HYGu2gbx3IO7g+XdSUVl+pr25+3Ll0+z53uMmrlFaf8+TfY+K
	24ck22LhNxhRvAThxSKdIl9bgMvsjEVi42wHLMUPZgRfqjytGx2m/X9vOqXrF+s33sNk/k
	Fhx1403HdWCcfRo69BISzXCoxJ8FEz4=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-j05bOWr7NdmbX6cUqd2BpQ-1; Mon, 29 Sep 2025 02:05:36 -0400
X-MC-Unique: j05bOWr7NdmbX6cUqd2BpQ-1
X-Mimecast-MFC-AGG-ID: j05bOWr7NdmbX6cUqd2BpQ_1759125936
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-738a7fc9901so58245307b3.0
        for <kvm@vger.kernel.org>; Sun, 28 Sep 2025 23:05:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759125936; x=1759730736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aEnOtbURDkBn/yuAWcxy2EnBdqVr8YnzLqFxCwWilb8=;
        b=hfDShd66l15Jmi9NF0WhVXVVcFEECA/ebcpqt6AOsGtxJT7GKHYnKTkrmKD6NNaXg5
         FcR85B0yGTIJXncJSexcFVLyadMNr5oZe2ri4O4hd8zeFOHSlIpUZpBuOPaaG5rtsdTP
         S3mubZahQYCl/0VLvjgl1vAn7fZwHctzX529zIUH7Knm6MLIy0e79r10qPzoVuHz+q72
         EGJ0Ug7ShvyzGbfAP7V7+IqS4rzojvhmpZnBSvlCg5naqRfjZNIq+h75+yVgJ8IgsEXL
         cyn9No0dUIUAYQxc0Ck+gCyaT0h3h/UdtHJKaa7uP8DpzGYBq+N8WhgpKfgrUMAEttP0
         5h3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWSNOSLhnb3DO2am1IhwHtAvSXxgS8VrpeQqwyACgEVn7sJzTHmERpObt3JXzAV4IgHQ6E=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc+6lm+yzRbCUexEsL2wqcU/UKS9p7CMWMfPJZwsCeO7B+qPvX
	8IfEYyUnl7HXZ1JSyRKEhv2pQnGpL35JeQmE54cP6PehJ/FRAtuI3P3x+o08FKuH11OSHQO4Sef
	pri7BJ+hCNBpbPfcIORV7eqdG754YBVK6R4HCbaC0ArCI5DAnd9FdUslQCB1GumaArCyALQUDDO
	UlpqSC/NNclZQklyz944vH+YCaqrly
X-Gm-Gg: ASbGncuP/Ngg/YhfA/8+cotMIPRk3pUquK29FJMLBie8TmMNuIgojEdJJExvi6/ZI5P
	frV7L2JpYvzqbKCQqlrxOot4kVod/c+ec1JjXpQ+o4Xmg4L5UIlKCNQDFmtr2MfRljtt7FdjYtN
	7nS65YhpWGaquQgKJLxluNNnwi/o0yQjKdz5q6xo0DhcVn1em8vilbn9UIsTAhUpm2jqTdI3n6v
	NTleJSa
X-Received: by 2002:a05:690e:2497:b0:62a:38ab:fc31 with SMTP id 956f58d0204a3-6361a70fbaamr12442136d50.14.1759125936010;
        Sun, 28 Sep 2025 23:05:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPkWT0XTYRzHEmtMC1RyCXLhMmcayEELVp/4odWdM3T+vaRsOTnuGwdr4KePk4Rygkx2XQiQoOU0Uftn//F5c=
X-Received: by 2002:a05:690e:2497:b0:62a:38ab:fc31 with SMTP id
 956f58d0204a3-6361a70fbaamr12442116d50.14.1759125935623; Sun, 28 Sep 2025
 23:05:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aNfXvrK5EWIL3avR@stanley.mountain> <20250927083043-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250927083043-mutt-send-email-mst@kernel.org>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 29 Sep 2025 08:04:59 +0200
X-Gm-Features: AS18NWCNnLHKyzg0qEsFQJWCKx1nz3MigsaubwNAQ8KOkZjUMutEQnjkPj3UxJw
Message-ID: <CAJaqyWcdQbt=PUG0GKQ8euXVBZMKEURURuHDijPNpzuf2e9xWg@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: Set s.num in GET_VRING_GROUP
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 27, 2025 at 2:32=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Sat, Sep 27, 2025 at 03:25:34PM +0300, Dan Carpenter wrote:
> > The group is supposed to be copied to the user, but it wasn't assigned
> > until after the copy_to_user().  Move the "s.num =3D group;" earlier.
> >
> > Fixes: ffc3634b6696 ("vduse: add vq group support")
> > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> > ---
> > This goes through the kvm tree I think.
>
>
> Thanks for the patch!
>
> IIUC this was in my tree for next, but more testing
> and review found issues (like this one) so I dropped it for now.
>

Yes, that's fixed in v5.

> >  drivers/vhost/vdpa.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 6305382eacbb..25ab4d06e559 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -667,9 +667,9 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdp=
a *v, unsigned int cmd,
> >               group =3D ops->get_vq_group(vdpa, idx);
> >               if (group >=3D vdpa->ngroups || group > U32_MAX || group =
< 0)
> >                       return -EIO;
> > -             else if (copy_to_user(argp, &s, sizeof(s)))
> > -                     return -EFAULT;
> >               s.num =3D group;
> > +             if (copy_to_user(argp, &s, sizeof(s)))
> > +                     return -EFAULT;
> >               return 0;
> >       }
> >       case VHOST_VDPA_GET_VRING_DESC_GROUP:
> > --
> > 2.51.0
>



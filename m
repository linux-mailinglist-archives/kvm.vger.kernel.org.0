Return-Path: <kvm+bounces-52869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7F82B09E1C
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 10:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A6EF16D1DD
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 08:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED35A294A1B;
	Fri, 18 Jul 2025 08:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="haoHkUvx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDC6293C6A
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 08:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752827556; cv=none; b=Ywr2AAq9nkF5oVuJopo5CTdPPmZl3XXRATQL/mrRWm5xwPhmVIHJlyMWIh9kUX8PpsWWE81SFQZtqCEEeBKFr8SfQ5LqxGOkGQEax4dw8DjKyBq6AfzTpxN0KbqSKMPf33kQmyt3MvzowMtuFvL8OmsbAB9JMCMDe2Xz2VeYs8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752827556; c=relaxed/simple;
	bh=u+hOpWXYGqQzlXztN0daxiDWMdTwEOshtpHvQqgxZTU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sycs8ZWvnZ4BTQDJGpFoxnZpsdLWy4EjYToFWEUTVMvzhHqXGMNqrCw8WeRmXgkegb02uXI5p6BBuiayRruXd208BRmdaF5KDz9DSIxlP0JjfGSs+Wxv0pruBUh6RT7WCLXAexsQIuF9KigqFR/7Ca5Xc4wyRxzUnMT7Y+kPKC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=haoHkUvx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752827553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ClO7vf6ZBePINFWsPRFr/+WGIgiWW+sfd60JVlzDBe8=;
	b=haoHkUvxI6bcfR/AWTtNCKE7sBZiqfoKHsHMI5UOT7ka6y3o4jsxNeZlIzTKdKDANCw1GP
	g5SQCH4lZOT9qK+5JItYdbahX2sRhkHbfHrbf8D9Enl20BV7sYK5MAMqjQuBEc4/X0d8zu
	6QyVV3G4RmwLBWQVddqfDCtuCfygDEU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-64vbc6fsOlq-gCB48pFqbQ-1; Fri, 18 Jul 2025 04:32:30 -0400
X-MC-Unique: 64vbc6fsOlq-gCB48pFqbQ-1
X-Mimecast-MFC-AGG-ID: 64vbc6fsOlq-gCB48pFqbQ_1752827550
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ae0c11adcd2so131444266b.3
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 01:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752827549; x=1753432349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ClO7vf6ZBePINFWsPRFr/+WGIgiWW+sfd60JVlzDBe8=;
        b=km8R8ue9WOhFbr0GGHCsahAhOnVy1qu8niqtNjVUZtaT/lSPxwHaCTRs/2KR3NFu/o
         GhMEQRaHXlviTHzBHDUpNiW8gmRgJ/+gH/XEyfweCvAI5Z1OkdSSA9VFnQVlJQ9E5+0c
         Pjth9U+6EmddxerG20NDWbyxBUNMAldAQDB01k18q8A1m7lzIDbf/2FjyqY57tiQGnBo
         eH7qnBtnOSD97VPFE0Zp2BV6SiIstNibN85QzBzBrNxlxRglJUJt+uV02uaRw0nEOdXP
         vC7V9x6blI2+FnTc1uV9M3i/s2YLICzlRTV7HIirBAF7JJHoMAZoJ8N1ozOmP7tkZuz7
         fOyw==
X-Forwarded-Encrypted: i=1; AJvYcCX1fW2v3JM7jY6Qzsoh4XLtyC6Dy76js1WaR5iwqOmSzjez+hBEaFxWdl3hUn+DJQZ1YRg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwdRsvNj/R6uRj94MqBWnK59y4D3nU5xTxbbciLghVZO68CW3j
	m/qLvLJbBiHmFpei2M3Tpelnz2XP8P0xErIYlab6Ey0wxqk6YQybSDrRaI6IG2/yYxlFCktE2Nv
	de1oPP/zZV87smrHzeGgSeUtnS5w9v5XY6prhQHojCk2qEwMH7HZ/9kXFnhHD57m1saD1WPk6J3
	NN5KR+HhhrtP2jcSOw8/0G0K1rHivq
X-Gm-Gg: ASbGncumcpdjluBm3Ocv6QKD8bMepBe7xdnLBQu1gPnqan4BaTl2OpeVl2O+ePMWN55
	wKUVb+26ZuJ3wuevdD4ZTs5QN1+TBysWTyCbs4pJUdkPZih4TxtY1WjaSVkhYADC9jV7n90hyO4
	193e8KStoGlTQVrUrYUg2Uhw==
X-Received: by 2002:a17:907:da4:b0:aec:5a33:1573 with SMTP id a640c23a62f3a-aec5a3354femr462488166b.41.1752827549548;
        Fri, 18 Jul 2025 01:32:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZRbZf1CSxDdcr2KaS1fw9e3BgI0jPEf8QS4qDJaocQ3CHMAkyjsYYe2SLqnUm1+1w/XSVLxztz/eFpNmyZDs=
X-Received: by 2002:a17:907:da4:b0:aec:5a33:1573 with SMTP id
 a640c23a62f3a-aec5a3354femr462485166b.41.1752827549130; Fri, 18 Jul 2025
 01:32:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250716162243.1401676-1-kniv@yandex-team.ru>
In-Reply-To: <20250716162243.1401676-1-kniv@yandex-team.ru>
From: Lei Yang <leiyang@redhat.com>
Date: Fri, 18 Jul 2025 16:31:52 +0800
X-Gm-Features: Ac12FXz3P7sVlSAVAM9be3FkuV1rX0FLSe-KqiVKeDU_xg3yE_St4sNLJJ0dYVg
Message-ID: <CAPpAL=xE4ZCyAhc+fkZwREo-cDHS4CG4fq4+sebazJgRzZoDHg@mail.gmail.com>
Subject: Re: [PATCH] vhost/net: Replace wait_queue with completion in ubufs reference
To: Nikolay Kuratov <kniv@yandex-team.ru>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, stable@vger.kernel.org, 
	Andrey Ryabinin <arbn@yandex-team.com>, Andrey Smetanin <asmetanin@yandex-team.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested this patch with virtio-net regression tests, everything works fine.

Tested-by: Lei Yang <leiyang@redhat.com>


On Thu, Jul 17, 2025 at 12:24=E2=80=AFAM Nikolay Kuratov <kniv@yandex-team.=
ru> wrote:
>
> When operating on struct vhost_net_ubuf_ref, the following execution
> sequence is theoretically possible:
> CPU0 is finalizing DMA operation                   CPU1 is doing VHOST_NE=
T_SET_BACKEND
>                              // &ubufs->refcount =3D=3D 2
> vhost_net_ubuf_put()                               vhost_net_ubuf_put_wai=
t_and_free(oldubufs)
>                                                      vhost_net_ubuf_put_a=
nd_wait()
>                                                        vhost_net_ubuf_put=
()
>                                                          int r =3D atomic=
_sub_return(1, &ubufs->refcount);
>                                                          // r =3D 1
> int r =3D atomic_sub_return(1, &ubufs->refcount);
> // r =3D 0
>                                                       wait_event(ubufs->w=
ait, !atomic_read(&ubufs->refcount));
>                                                       // no wait occurs h=
ere because condition is already true
>                                                     kfree(ubufs);
> if (unlikely(!r))
>   wake_up(&ubufs->wait);  // use-after-free
>
> This leads to use-after-free on ubufs access. This happens because CPU1
> skips waiting for wake_up() when refcount is already zero.
>
> To prevent that use a completion instead of wait_queue as the ubufs
> notification mechanism. wait_for_completion() guarantees that there will
> be complete() call prior to its return.
>
> We also need to reinit completion because refcnt =3D=3D 0 does not mean
> freeing in case of vhost_net_flush() - it then sets refcnt back to 1.
> AFAIK concurrent calls to vhost_net_ubuf_put_and_wait() with the same
> ubufs object aren't possible since those calls (through vhost_net_flush()
> or vhost_net_set_backend()) are protected by the device mutex.
> So reinit_completion() right after wait_for_completion() should be fine.
>
> Cc: stable@vger.kernel.org
> Fixes: 0ad8b480d6ee9 ("vhost: fix ref cnt checking deadlock")
> Reported-by: Andrey Ryabinin <arbn@yandex-team.com>
> Suggested-by: Andrey Smetanin <asmetanin@yandex-team.ru>
> Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
> ---
>  drivers/vhost/net.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 7cbfc7d718b3..454d179fffeb 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -94,7 +94,7 @@ struct vhost_net_ubuf_ref {
>          * >1: outstanding ubufs
>          */
>         atomic_t refcount;
> -       wait_queue_head_t wait;
> +       struct completion wait;
>         struct vhost_virtqueue *vq;
>  };
>
> @@ -240,7 +240,7 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool=
 zcopy)
>         if (!ubufs)
>                 return ERR_PTR(-ENOMEM);
>         atomic_set(&ubufs->refcount, 1);
> -       init_waitqueue_head(&ubufs->wait);
> +       init_completion(&ubufs->wait);
>         ubufs->vq =3D vq;
>         return ubufs;
>  }
> @@ -249,14 +249,15 @@ static int vhost_net_ubuf_put(struct vhost_net_ubuf=
_ref *ubufs)
>  {
>         int r =3D atomic_sub_return(1, &ubufs->refcount);
>         if (unlikely(!r))
> -               wake_up(&ubufs->wait);
> +               complete_all(&ubufs->wait);
>         return r;
>  }
>
>  static void vhost_net_ubuf_put_and_wait(struct vhost_net_ubuf_ref *ubufs=
)
>  {
>         vhost_net_ubuf_put(ubufs);
> -       wait_event(ubufs->wait, !atomic_read(&ubufs->refcount));
> +       wait_for_completion(&ubufs->wait);
> +       reinit_completion(&ubufs->wait);
>  }
>
>  static void vhost_net_ubuf_put_wait_and_free(struct vhost_net_ubuf_ref *=
ubufs)
> --
> 2.34.1
>
>



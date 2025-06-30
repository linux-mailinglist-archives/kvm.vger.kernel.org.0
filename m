Return-Path: <kvm+bounces-51055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B4F7AED2F5
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 05:37:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B18C1729EF
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 03:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5412B19F13F;
	Mon, 30 Jun 2025 03:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZNIkHAB8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B370C1DA55
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 03:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751254635; cv=none; b=NJp5yUOal7VLtFtduCpvhWZmnmRsHwaXOq5uu7mozyoCl2jfbUbXMibNYNS+gAaYLNhTigZ02edARbus3f6/hg4v2/5kVVEkTDMYJjQeqZsUY76gQHZibk22gHcq0pncwi55dZHZeTaPZJ3MrHM5J9Tox8ucRuanetsrczyT4uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751254635; c=relaxed/simple;
	bh=nHAXEaVkqOjEIQ+g+zG5hflRIdiMhOy/cbZJ03K4CfI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tkJP846r5c4XqVUfdzvVFcpwrPI3zOv9WeXJNPd3fPEMT/pWY6hcLPY7xr7F/Bhx9+0EqI1IsH+q257FVvuWGsDYRF10RFAfSH7V8JlC5UAAKezUhbrDeC17w9U1AnxGzDnDbrAlEgv39lQD1HFLQzhsigL/ztfiQX9VOrasMzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZNIkHAB8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751254632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rkwpDUZl+sZWek7ZXNsWkAYIEZO6e0RDLuiHFNjssRY=;
	b=ZNIkHAB8igYq+IXYkTkZlhBm94N1/Q9s1jFltrlQMXzZVEChdj/HYUiP5zALU+QJ9Zg2F5
	t3uVhexXbV0n5OnxT50XwO2eTbCRn6ZZ7uPHXvmVxrmJlCNajk+eWZcOhNBS5FSZ3nabPI
	qIoy0SEySVmessM53iGQz5LsrzUxV4o=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-VDycaikHN8ykB8ilrF5DJQ-1; Sun, 29 Jun 2025 23:37:11 -0400
X-MC-Unique: VDycaikHN8ykB8ilrF5DJQ-1
X-Mimecast-MFC-AGG-ID: VDycaikHN8ykB8ilrF5DJQ_1751254630
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-311ef4fb5eeso3105416a91.1
        for <kvm@vger.kernel.org>; Sun, 29 Jun 2025 20:37:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751254630; x=1751859430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rkwpDUZl+sZWek7ZXNsWkAYIEZO6e0RDLuiHFNjssRY=;
        b=BB83BzBdjjN6emm53GXUqnBOFFvVXb4M0dqTj+nn61fIHkUVfXD5dOiOMYVS7642Zg
         rMuXBLjdRaXupX+83ajFSxS+UOE1QgGuV7sQaUuck6T5bGJyq6TWaEZ4fSoJ7iR/cV6a
         OIrn6p3PXMhKP6UxZh1cegUrFFdhe5faKQyYSXAMCdIjdzYb3nu7XDI/Ii8guF+CQZd/
         ChlVTs7OUmVFcD4hov2BSlP19zBP9lK2D5uNIO2pZd2Q94yEjC25HCoy2bXZshcPKjiB
         aiKDjkguZ3zVvy4YgpAMGN9a5XZuTxnRHARazGTt/ANW6rIF+668PZL7Ol0UzMdzaCOi
         mLjw==
X-Forwarded-Encrypted: i=1; AJvYcCVQU7irX8i4zZthFGpm1hE0TUpKvMfye8McpCx5pBQDvGC89cQajgYH55JBwRSufKodbiE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHkBhosQoFqbhFskl3/AMnXcLlfYfkiusO4Z0sCsA6ZOk5ZjPo
	iou+TyZIe9Wx2YlN3ahletMMMbyPpcGPIWEz4gt8iawM3MZLUn7VS6IzxavwzjXN1Q0h7sm7h4V
	YzJdG7iJ5ejSkqBACVQyMgOcxn380wG9owNTbhJSQlVItETiZ46JsLRDeQNjyWWvQdrFpDreP/K
	XnDQhvQL5iaOyeVe1agaqPKN0tY2VX
X-Gm-Gg: ASbGncvmiHsk6NJV8QiPlC9WzJQRmrOuYrTW6Livc+/vzL592QDIp8787UQX6PJlXJa
	UZGneN3JVIi6DVKYqa3duUzec9ugw/D4kYxoJUk1NC+erc5KVS6bdnZ4D7OT3K/N8t4PS+jG5On
	P8Wtrs
X-Received: by 2002:a17:90b:380f:b0:313:f995:91cc with SMTP id 98e67ed59e1d1-316d69a9ebamr23854598a91.2.1751254630216;
        Sun, 29 Jun 2025 20:37:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFC/PxeY2zPgmoqHLa5NYsPNWTtefEChjOO7AtX/7ybsjX+NZLbIw2wSOZC+yvf746Z7vQ9ZeDBKqdlVvccnBo=
X-Received: by 2002:a17:90b:380f:b0:313:f995:91cc with SMTP id
 98e67ed59e1d1-316d69a9ebamr23854562a91.2.1751254629758; Sun, 29 Jun 2025
 20:37:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250626021445.49068-1-jasowang@redhat.com> <20250626021445.49068-2-jasowang@redhat.com>
 <20250627174825.667e1e5f@kernel.org>
In-Reply-To: <20250627174825.667e1e5f@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 30 Jun 2025 11:36:56 +0800
X-Gm-Features: Ac12FXwSsmp5J2RbQVOjDCPt8sIK9w2DQyUQ567Xil-xT9G4D8CIR57TUiVmXz8
Message-ID: <CACGkMEu6r66Jg3--eOCyMdd1WqKeP9Jvfv+DFmWk07oTJUKZyQ@mail.gmail.com>
Subject: Re: [PATCH V2 net-next 2/2] vhost-net: reduce one userspace copy when
 building XDP buff
To: Jakub Kicinski <kuba@kernel.org>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch, 
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com, mst@redhat.com, 
	eperezma@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 28, 2025 at 8:48=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Thu, 26 Jun 2025 10:14:45 +0800 Jason Wang wrote:
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -690,13 +690,13 @@ static int vhost_net_build_xdp(struct vhost_net_v=
irtqueue *nvq,
> >       if (unlikely(!buf))
> >               return -ENOMEM;
> >
> > -     copied =3D copy_from_iter(buf, sock_hlen, from);
> > -     if (copied !=3D sock_hlen) {
> > +     copied =3D copy_from_iter(buf + pad - sock_hlen, len, from);
> > +     if (copied !=3D len) {
> >               ret =3D -EFAULT;
> >               goto err;
> >       }
> >
> > -     gso =3D buf;
> > +     gso =3D buf + pad - sock_hlen;
> >
> >       if (!sock_hlen)
> >               memset(buf, 0, pad);
> > @@ -715,12 +715,8 @@ static int vhost_net_build_xdp(struct vhost_net_vi=
rtqueue *nvq,
> >               }
> >       }
> >
> > -     len -=3D sock_hlen;
>
> we used to adjust @len here, now we don't..
>
> > -     copied =3D copy_from_iter(buf + pad, len, from);
> > -     if (copied !=3D len) {
> > -             ret =3D -EFAULT;
> > -             goto err;
> > -     }
> > +     /* pad contains sock_hlen */
> > +     memcpy(buf, buf + pad - sock_hlen, sock_hlen);
> >
> >       xdp_init_buff(xdp, buflen, NULL);
> >       xdp_prepare_buff(xdp, buf, pad, len, true);
>
> .. yet we still use len as the packet size here.

Exactly, it should be len - sock_hlen here.

Thanks

> --
> pw-bot: cr
>



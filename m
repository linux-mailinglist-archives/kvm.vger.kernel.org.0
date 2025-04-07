Return-Path: <kvm+bounces-42790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A3555A7D212
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 04:15:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8952F7A3CC3
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 02:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3FDB179A7;
	Mon,  7 Apr 2025 02:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JwLcE8MQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37564212FAA
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 02:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743992107; cv=none; b=tbmOXaExGxSIlhD9kuVFRZ9CBy5qkIuWMsMgC7AfLYFjEAApDk+FEHIeeiRr0NSE+nPdPqsETSl8sV5m5Bt29ouzHxIeW97S1lNq1Mtrw4s3Dz+D0Iy6L+q/hbVfhC5ODgUOLIdza00sfihNtUDVzb51XyGGgZ1dYJQUrjXo5vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743992107; c=relaxed/simple;
	bh=5iGnaKTdh8qdUpTGBnIaXxXw7Npl7YWIGBbllmqoExE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ieZFo3EG30r2hF0YkxW0tXZIXDlJE/6Lb8Yq34Xfy6E6aWPuUjXwI9BZT06cEYKjdek1Kv0fu2re5JXb/KxD6+HO5jUjiwkjcrm0AcxSK9DswpRzbWGldx3LD8vyFf1fngQKK7qxrN0OUvAR39vDESoKvzeLobzwqUAofefNsVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JwLcE8MQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743992105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5iGnaKTdh8qdUpTGBnIaXxXw7Npl7YWIGBbllmqoExE=;
	b=JwLcE8MQsdv0WhuBZVzPSpW1luxfBlpUyqiMMZqIF/qQa3w40ziGZD4fTZTJJWYhccsJHo
	evyO5Nj7nE+TnglDmmiSf+QVfAtmKSm0HYxX9X+5B9twsenEj4xrrWKAb1xrk2bGSXRlqC
	Mk+GsYZI7xiKaie51GsWjMk3Y672tVo=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-YTfaZ3lbML2JBe29EOvJjg-1; Sun, 06 Apr 2025 22:15:03 -0400
X-MC-Unique: YTfaZ3lbML2JBe29EOvJjg-1
X-Mimecast-MFC-AGG-ID: YTfaZ3lbML2JBe29EOvJjg_1743992102
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-736abba8c5cso5044472b3a.2
        for <kvm@vger.kernel.org>; Sun, 06 Apr 2025 19:15:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743992102; x=1744596902;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5iGnaKTdh8qdUpTGBnIaXxXw7Npl7YWIGBbllmqoExE=;
        b=NqHGklVjKxigjfXY3uQHZpnxEyyS6XQ4p2sXlkjKHXPMzbaC/kZ+iiNpDp16vfUKvy
         dO4mCazEY8lxxMjT86qsaxzsmJjKKSHiSf44rInY9mxr8zR9jIqFCrbE3gGThpVYi8TV
         LS5UgTNvUopeSnxiZpfctqXXjzTMMhv6r+m6ewvNKVlpw3DsQY2xCUVNAKG+aLcCSaC+
         EwLVIeMo5ARcwiG5tBnkNZknBH5X/CgGcDTmNLjS90GEl+yLSW49+8PWhlRnnIGiNosO
         vj67xyisLwH0pTjJl+66I3Bx+Ho4rPKi7wYny2riIeTl4ngZxR0gE2pnvUQLJnoQuNA2
         awEw==
X-Forwarded-Encrypted: i=1; AJvYcCUIbHVAPGjGLTv2VB17Nc9jVh98unkRAwyOEZ6MC/Aljwlcnqvwsp3ZRmAhz3W+tHhri4Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxt1iAF9sFHkAgTowWVKvIGMUldfUsGyH/9MDpusyFzBq0Y/9Uk
	ybNoMHrYiZcQ2yzMVdz25uSSqm3eT/UFYAC2b92CWjbr3RPDu6hGplTGTSbMQ1do+8a3FjJdXGW
	hk9+ioygR7r1wPLYRDTmoTq4rQ36YqWNwmBs9dGt6MDu3MaBtntqY5w1xlmWlIq9/7zLzQcB45E
	dMh+61JmY8RasOrzNUrZVFSs07
X-Gm-Gg: ASbGncvA2B/e2pS8/eEcGZrXkfzIVfzJMSm16jtXpvhlMt3dL+vmxzI3T2u+ASzaW0H
	Qls45xooDLDkG30/EFM2H/N6GzeboJdNwanowJgmQ9QruOgFHVF5+iSX7WNf9+5Rffdke3A==
X-Received: by 2002:a05:6a21:6f01:b0:1f5:8655:3287 with SMTP id adf61e73a8af0-201081894f9mr15997598637.40.1743992102451;
        Sun, 06 Apr 2025 19:15:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2xrRUCjmDh8gU4TsrPWubO4RaHlHA1/mZMFsc3k0pvCi4jb3ExJetOAjK+ODkU/PKVNydcIKM1LkzsCQTKWs=
X-Received: by 2002:a05:6a21:6f01:b0:1f5:8655:3287 with SMTP id
 adf61e73a8af0-201081894f9mr15997577637.40.1743992102154; Sun, 06 Apr 2025
 19:15:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250404145241.1125078-1-jon@nutanix.com>
In-Reply-To: <20250404145241.1125078-1-jon@nutanix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 7 Apr 2025 10:14:51 +0800
X-Gm-Features: ATxdqUHS0zfr8JGoyzsGJ5km2ABwTqNENhD1uX4yKsHGytOkPk4bkII2gJMMLUM
Message-ID: <CACGkMEsFc-URhXBCGZ1=CTMZKcWPf57pYy1TcyKLL=N65u+F0Q@mail.gmail.com>
Subject: Re: [PATCH] vhost/net: remove zerocopy support
To: Jon Kohler <jon@nutanix.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 4, 2025 at 10:24=E2=80=AFPM Jon Kohler <jon@nutanix.com> wrote:
>
> Commit 098eadce3c62 ("vhost_net: disable zerocopy by default") disabled
> the module parameter for the handle_tx_zerocopy path back in 2019,
> nothing that many downstream distributions (e.g., RHEL7 and later) had
> already done the same.
>
> Both upstream and downstream disablement suggest this path is rarely
> used.
>
> Testing the module parameter shows that while the path allows packet
> forwarding, the zerocopy functionality itself is broken. On outbound
> traffic (guest TX -> external), zerocopy SKBs are orphaned by either
> skb_orphan_frags_rx() (used with the tun driver via tun_net_xmit())

This is by design to avoid DOS.

> or
> skb_orphan_frags() elsewhere in the stack,

Basically zerocopy is expected to work for guest -> remote case, so
could we still hit skb_orphan_frags() in this case?

> as vhost_net does not set
> SKBFL_DONT_ORPHAN.
>
> Orphaning enforces a memcpy and triggers the completion callback, which
> increments the failed TX counter, effectively disabling zerocopy again.
>
> Even after addressing these issues to prevent SKB orphaning and error
> counter increments, performance remains poor. By default, only 64
> messages can be zerocopied, which is immediately exhausted by workloads
> like iperf, resulting in most messages being memcpy'd anyhow.
>
> Additionally, memcpy'd messages do not benefit from the XDP batching
> optimizations present in the handle_tx_copy path.
>
> Given these limitations and the lack of any tangible benefits, remove
> zerocopy entirely to simplify the code base.
>
> Signed-off-by: Jon Kohler <jon@nutanix.com>

Any chance we can fix those issues? Actually, we had a plan to make
use of vhost-net and its tx zerocopy (or even implement the rx
zerocopy) in pasta.

Eugenio may explain more here.

Thanks



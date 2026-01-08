Return-Path: <kvm+bounces-67347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B97D00F09
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 04:52:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 20C8F30A73FF
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 03:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CDD82877ED;
	Thu,  8 Jan 2026 03:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XgqEFc7I";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="alvwLLpP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7759286D4E
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 03:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767843965; cv=none; b=Xtf7SLzJGrYsoaIMrqznNiAbOv46Hr/tbR3L1IJz4iFErSPGcLuQE+l+0hslyd89tmbMwqeoyASIMU5cUDV+HPc+I1TRppFrZjH1xdFUaqUoOrChiZ/swBeytkFtmDbq3DX424oxLluzToY1ExclUGsrVY4Bq02l6eaS6L2gOPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767843965; c=relaxed/simple;
	bh=08ZpgLtfSYqi4+i/U9XHqQzEVglXimSDYNawkficNd8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oD4t9QCFdThXCqV4mMoBpxATWAxrnurCWu6lfra6L0H+eHJ8HPIiyQxWLztsncoIbbwfh7ca9MqLpzfCwby662jcMTM2ZWYUDVwZgne8ivaiaOUk9FPW+S84t4N54yweSgATdctuMbTUAHOuXRpUNpS2lG3sqvX+jeihhDoxTik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XgqEFc7I; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=alvwLLpP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767843961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v58SV4sfp1KPqLP1VgpxZ6XDQOK5uoDM/ahl82LBf0w=;
	b=XgqEFc7I0vJ0NgnAPNNQkP8EUVE5iiqyqaHl3i7Qeav+v4clYptfSBtcJ65yxbEe8+k5l6
	9FSrBPfT4YjNVIqdGH9AQEQmbzMsXNddQ35x7PAHCzasbwednQ/8NTHrCNm36qUlyrp5Dg
	y+EeTcXSzXlCFhQ70uOx8h3DbplZ8oc=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-V1tOTGBROa-06zMWdEp7Pg-1; Wed, 07 Jan 2026 22:38:18 -0500
X-MC-Unique: V1tOTGBROa-06zMWdEp7Pg-1
X-Mimecast-MFC-AGG-ID: V1tOTGBROa-06zMWdEp7Pg_1767843497
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-bf06c3426b7so2710374a12.3
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 19:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767843496; x=1768448296; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v58SV4sfp1KPqLP1VgpxZ6XDQOK5uoDM/ahl82LBf0w=;
        b=alvwLLpPcpjziBsb4+U8q9Vw1Km2zMugspWA77mNR8e/ZG1wNe2Ve7C0a7wUx1HP6a
         LjmIsAlH4eQDs7VeDBJgCfkXRqz4MQIMEmxWQFG9Sk8Yb2VnFk0ti+bA/+j3NTAzsJUG
         LXt1yXW/SWZNDZHUQ6aGNskDbcBxlrQeV+htxd1N8/nqRrZYM+bfzOxxiwZiD73ApZF2
         1BUjdlZ4yn7UMsaKA8E24G5LzjoulBtunqK6JaBQ/DcormkGqkpXhnrd1N6MAvGFOGjR
         ln3aLNVIuz5y84alVLpMbgPa3z//yXaXzeLd5Dj7XOwqHEr0OXtPS7bRawYh6Sln5qie
         8KfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767843496; x=1768448296;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v58SV4sfp1KPqLP1VgpxZ6XDQOK5uoDM/ahl82LBf0w=;
        b=pKdVW0JVsz2jDxGQWYxAK3VxrHbAh8y51Ja90VH8JEtn+hHQPkvfhB0MppiKOUoCh0
         Y6wKo4m204tfgu0uJvWbtZ2q7nFqkI4D846UQ68EMR9D4OJeDRfTDW8Jb02qR/Dlq6py
         4Kyk11r8Fhf4JL5GdE8WTQbkn18hv/dmCGdHnDFV9YeNFNaIPgfszK5TQ/8zH9FigSSM
         JcJAPizMDlph3xMxa9Lb+fCxfCPyDQZox4NNZV608ToUljUKXVyPwjRer5pUPg7ZrGx2
         bbhvs81C+jSQqIJRuSF1tOWTZ8iDhSAtvBWVHLej1Lnpk3Fp7pmD9gfRQ+iwLDUS/A6H
         3P+g==
X-Forwarded-Encrypted: i=1; AJvYcCXKu9GmFKAN3vQyeYDNv4qUestBCgH5TF//8eBiCaf1tpW9hYhEM044NqHZxyxPMd7Cy9A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYVF0kJyVpf0dYuRxVt6wG2YJAasBdImNURZn0/eFlZTnB+8QT
	mKIR8SyF5lGOm4IHiKoC76Ig1fJZexP1rrO6NYXwzlrNT65YkZ3HVKGEC5zPoLlAMsESLH2ddcr
	+KWNI0XoJvCSRue8DBZyvO3suHM3exFDYQu5A9AJwekjY8d8WWFDngfKkPayPezdQChgF0xtLDT
	SJVcPKa0kouuL6CswV8wuMzqoJBUCs
X-Gm-Gg: AY/fxX78+zQ6BiZJTDGXhHBKvKDUtKwPW1IDsFYli4Yt/BuM1X1Cc0xKkokQvF+KGw2
	oXNs8ISl6Do7ufq2jQK/YzHKQCf/NAwVbpMnZcv6WA6fSpzI/7DjYv06AI1C3QxB8aB8WbfcNjF
	0ILwS/TheJmmmkKTGUJr2V91JnbQQ+s6EzQwIlmrRCJr56Rjy4F+iAnm85U+P3Ax4=
X-Received: by 2002:a05:6a21:116:b0:35e:11ff:45c0 with SMTP id adf61e73a8af0-3898fa226d1mr4400182637.55.1767843496434;
        Wed, 07 Jan 2026 19:38:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFrINQzJlx78fjSA9ruvmWJu0w8vOPujfDqFXxbDJsjPnMqr1tJkD5ak8/7tV8xdLw9u0H5oRpbFtVWYj1SfYw=
X-Received: by 2002:a05:6a21:116:b0:35e:11ff:45c0 with SMTP id
 adf61e73a8af0-3898fa226d1mr4400161637.55.1767843496025; Wed, 07 Jan 2026
 19:38:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de> <20260107210448.37851-4-simon.schippers@tu-dortmund.de>
In-Reply-To: <20260107210448.37851-4-simon.schippers@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 8 Jan 2026 11:38:02 +0800
X-Gm-Features: AQt7F2pYgxF0Jvdv3uPx8yLVba1YerHhPNETBcotNKOEiOav4ZMJyA2wFtENvzw
Message-ID: <CACGkMEuSiEcyaeFeZd0=RgNpviJgNvUDq_ctjeMLT5jZTgRkwQ@mail.gmail.com>
Subject: Re: [PATCH net-next v7 3/9] tun/tap: add ptr_ring consume helper with
 netdev queue wakeup
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	mst@redhat.com, eperezma@redhat.com, leiyang@redhat.com, 
	stephen@networkplumber.org, jon@nutanix.com, tim.gebauer@tu-dortmund.de, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> Introduce {tun,tap}_ring_consume() helpers that wrap __ptr_ring_consume()
> and wake the corresponding netdev subqueue when consuming an entry frees
> space in the underlying ptr_ring.
>
> Stopping of the netdev queue when the ptr_ring is full will be introduced
> in an upcoming commit.
>
> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> ---
>  drivers/net/tap.c | 23 ++++++++++++++++++++++-
>  drivers/net/tun.c | 25 +++++++++++++++++++++++--
>  2 files changed, 45 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index 1197f245e873..2442cf7ac385 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -753,6 +753,27 @@ static ssize_t tap_put_user(struct tap_queue *q,
>         return ret ? ret : total;
>  }
>
> +static void *tap_ring_consume(struct tap_queue *q)
> +{
> +       struct ptr_ring *ring =3D &q->ring;
> +       struct net_device *dev;
> +       void *ptr;
> +
> +       spin_lock(&ring->consumer_lock);
> +
> +       ptr =3D __ptr_ring_consume(ring);
> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1))) {
> +               rcu_read_lock();
> +               dev =3D rcu_dereference(q->tap)->dev;
> +               netif_wake_subqueue(dev, q->queue_index);
> +               rcu_read_unlock();
> +       }
> +
> +       spin_unlock(&ring->consumer_lock);
> +
> +       return ptr;
> +}
> +
>  static ssize_t tap_do_read(struct tap_queue *q,
>                            struct iov_iter *to,
>                            int noblock, struct sk_buff *skb)
> @@ -774,7 +795,7 @@ static ssize_t tap_do_read(struct tap_queue *q,
>                                         TASK_INTERRUPTIBLE);
>
>                 /* Read frames from the queue */
> -               skb =3D ptr_ring_consume(&q->ring);
> +               skb =3D tap_ring_consume(q);
>                 if (skb)
>                         break;
>                 if (noblock) {
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 8192740357a0..7148f9a844a4 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2113,13 +2113,34 @@ static ssize_t tun_put_user(struct tun_struct *tu=
n,
>         return total;
>  }
>
> +static void *tun_ring_consume(struct tun_file *tfile)
> +{
> +       struct ptr_ring *ring =3D &tfile->tx_ring;
> +       struct net_device *dev;
> +       void *ptr;
> +
> +       spin_lock(&ring->consumer_lock);
> +
> +       ptr =3D __ptr_ring_consume(ring);
> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1))) {

I guess it's the "bug" I mentioned in the previous patch that leads to
the check of __ptr_ring_consume_created_space() here. If it's true,
another call to tweak the current API.

> +               rcu_read_lock();
> +               dev =3D rcu_dereference(tfile->tun)->dev;
> +               netif_wake_subqueue(dev, tfile->queue_index);

This would cause the producer TX_SOFTIRQ to run on the same cpu which
I'm not sure is what we want.

> +               rcu_read_unlock();
> +       }

Btw, this function duplicates a lot of logic of tap_ring_consume() we
should consider to merge the logic.

> +
> +       spin_unlock(&ring->consumer_lock);
> +
> +       return ptr;
> +}
> +
>  static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err=
)
>  {
>         DECLARE_WAITQUEUE(wait, current);
>         void *ptr =3D NULL;
>         int error =3D 0;
>
> -       ptr =3D ptr_ring_consume(&tfile->tx_ring);
> +       ptr =3D tun_ring_consume(tfile);

I'm not sure having a separate patch like this may help. For example,
it will introduce performance regression.

>         if (ptr)
>                 goto out;
>         if (noblock) {
> @@ -2131,7 +2152,7 @@ static void *tun_ring_recv(struct tun_file *tfile, =
int noblock, int *err)
>
>         while (1) {
>                 set_current_state(TASK_INTERRUPTIBLE);
> -               ptr =3D ptr_ring_consume(&tfile->tx_ring);
> +               ptr =3D tun_ring_consume(tfile);
>                 if (ptr)
>                         break;
>                 if (signal_pending(current)) {
> --
> 2.43.0
>

Thanks



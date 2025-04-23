Return-Path: <kvm+bounces-44006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B537A997E0
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 20:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 607524A32DA
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 18:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185D728F502;
	Wed, 23 Apr 2025 18:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2gq+VKrr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B260128DEFD
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 18:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745432789; cv=none; b=DhBzdWFSPLL2F8IVy53KqFsVv30tVkl6Lj/eHSTtPJNWH41GeSExx2bLV0f7ZyHh0y/FfWz8FnZsOHkAiszGAFGJYmBKEv3nDtKnnwCHty/VEbueGaEz6xVgFE6p3quWjoHX3e7i6edEi6nmLEbYPD3qFwN2rNk4IerbsmTqIPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745432789; c=relaxed/simple;
	bh=PH84kld/sKE+RhISrTjG1cjFnL0yLAXB9xK4PwFZaMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vGZUpQDyoNXseNo1IRmc+tDnZrsh6cIOa0pWGRCz4jXpGvbsW3ebjHyd528ql7+LeFSNQX9w6WQhkedBD8pWmSzMDUvTAUbONzm/XKFCi3cqLS65p04S4HVKWMNvxEiKmxqdYHKtzEldFUSPNuRuchHjdE3s9Ge150nokHKwneA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2gq+VKrr; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2263428c8baso21255ad.1
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 11:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745432786; x=1746037586; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0kIM1GyroCk3zmwGLYPwDaNY7xBbvOnwGmlKqF+IzQ=;
        b=2gq+VKrrvYaucHZKTwwnsDTcguRUJEnVD9Vc+V+V+MMaMRFvued3L8zrmZcBRrQhmM
         3AQIXkghMRWBlDpmF3Y442RrEa/yOvEGpOXH7jvF2ImyjOhm7ldwlQpVsBBVnrbMBR32
         oxkxBsygVehWGacZv3UxJmwvCv8bQOs6VYYwjIT31stc15bCYMBoYmLXxFC4CJxX6ijX
         un5EOHJeYtHksDBCZLviXLlVLbxF+jjTZIB70cLEkBjcWWDUtXCQHSne9rRrpLVlVfXm
         TvbupkYn09GYXohrSzKoO8ejUQwj+0XW+4JQzbpUFtXTG2WA2y4toln7Vk5BwsR+pHxz
         m5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745432786; x=1746037586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l0kIM1GyroCk3zmwGLYPwDaNY7xBbvOnwGmlKqF+IzQ=;
        b=deeOI6z+d2405h8UVhCn9y45i6BRo46XwAWMOg0+41QNtdx9pEHt6YcOA4DsA4ewq2
         Zw40A68Yc0qIoNMqfstuj4x32uhk8XDWVpjtDwT9rZ1UQ5miU+mxhgtwXH4Q5Gpw6D9V
         O1GntqvpIIZLOb0PEuR53vo0xDXqWz+/IIPo0K545EeU5JUYDkBpEuKmddeyqe421jFN
         ICnq86q8Rag76xurKcWJGS4qLawjl9HeJDkSO/4p318EK6wRvOWA/EsKlgwKBpp1h373
         9WknnmsqXI4zK15PzCbDdglulmazP07dUvH2H8X41XTPnam7DU4iZk36Lo63BkpFppyl
         7Jew==
X-Forwarded-Encrypted: i=1; AJvYcCXlzh7BGyEk2Vp02mm6LoGl5JiNZKly5nOArxLRu4okejKRMLHW/sFnbHyGeQF1cw+9JMw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCr3gdztDwYX8yOSe0/8Kxmh+s/N86mMkyJwbB1zHOY2eZL1wo
	ltp38y7IqJZx9hD1dcehn9pavFJapixTVTRjppGiU40EJfZIbVq1sHWJRwGBj66ZhKIIv5YJfMw
	CO39/1TYIz+zMm847gSNmFFu9eUN8ydxjH2/e
X-Gm-Gg: ASbGncss8DA325zJTBxkYZJxeS7mAqVrlnS4y/Q0eepwnLYolP2vhWqiDaxT9/uBYcR
	OWTCT03f8HxQh1UfTIDGjQWWFUI2z7SRFRmhEe7elCT9AgVY6gem1NZKfjIiA3MFWeKH9GruLK1
	YgfzuTl+BUOq9QnifRawLlFrDA2hV5+bXzid7mU7z1kMSgleQPn46wqwg=
X-Google-Smtp-Source: AGHT+IFz1R1LxqWEGYRLYWO5W96XWnv2bqJz15jEINPSBmb87YsKZWzWOfr6fveduQ8KQij52ltnpYxHcWerkniTavs=
X-Received: by 2002:a17:903:3bce:b0:215:8232:5596 with SMTP id
 d9443c01a7336-22db218a627mr293845ad.16.1745432785574; Wed, 23 Apr 2025
 11:26:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250423031117.907681-1-almasrymina@google.com> <20250423031117.907681-8-almasrymina@google.com>
In-Reply-To: <20250423031117.907681-8-almasrymina@google.com>
From: Harshitha Ramamurthy <hramamurthy@google.com>
Date: Wed, 23 Apr 2025 11:26:14 -0700
X-Gm-Features: ATxdqUHnKDzCBYG80n4IAQ6Tqlf6P8u3mDu-47naFBmrHiwPtX2MRzVq-LrB7oQ
Message-ID: <CAEAWyHdYEzHLbW1Z=nS1yGdnbFA2HU7wb4nFZ1TmqGaUZoq9Tg@mail.gmail.com>
Subject: Re: [PATCH net-next v10 7/9] gve: add netmem TX support to GVE
 DQO-RDA mode
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Donald Hunter <donald.hunter@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 8:11=E2=80=AFPM Mina Almasry <almasrymina@google.co=
m> wrote:
>
> Use netmem_dma_*() helpers in gve_tx_dqo.c DQO-RDA paths to
> enable netmem TX support in that mode.
>
> Declare support for netmem TX in GVE DQO-RDA mode.
>
> Signed-off-by: Mina Almasry <almasrymina@google.com>
>
> ---
>
> v10:
> - Move setting dev->netmem_tx to right after priv is initialized
>   (Harshitha)
>
> v4:
> - New patch
> ---
>  drivers/net/ethernet/google/gve/gve_main.c   | 4 ++++
>  drivers/net/ethernet/google/gve/gve_tx_dqo.c | 8 +++++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/eth=
ernet/google/gve/gve_main.c
> index 8aaac91013777..b49c74620799e 100644
> --- a/drivers/net/ethernet/google/gve/gve_main.c
> +++ b/drivers/net/ethernet/google/gve/gve_main.c
> @@ -2659,12 +2659,16 @@ static int gve_probe(struct pci_dev *pdev, const =
struct pci_device_id *ent)
>         if (err)
>                 goto abort_with_wq;
>
> +       if (!gve_is_gqi(priv) && !gve_is_qpl(priv))
> +               dev->netmem_tx =3D true;
> +
>         err =3D register_netdev(dev);
>         if (err)
>                 goto abort_with_gve_init;
>
>         dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
>         dev_info(&pdev->dev, "GVE queue format %d\n", (int)priv->queue_fo=
rmat);
> +
nit: accidental extra empty line, but

Acked-by: Harshitha Ramamurthy <hramamurthy@google.com>

>         gve_clear_probe_in_progress(priv);
>         queue_work(priv->gve_wq, &priv->service_task);
>         return 0;
> diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/e=
thernet/google/gve/gve_tx_dqo.c
> index 2eba868d80370..a27f1574a7337 100644
> --- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
> +++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
> @@ -660,7 +660,8 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_r=
ing *tx,
>                         goto err;
>
>                 dma_unmap_len_set(pkt, len[pkt->num_bufs], len);
> -               dma_unmap_addr_set(pkt, dma[pkt->num_bufs], addr);
> +               netmem_dma_unmap_addr_set(skb_frag_netmem(frag), pkt,
> +                                         dma[pkt->num_bufs], addr);
>                 ++pkt->num_bufs;
>
>                 gve_tx_fill_pkt_desc_dqo(tx, desc_idx, skb, len, addr,
> @@ -1038,8 +1039,9 @@ static void gve_unmap_packet(struct device *dev,
>         dma_unmap_single(dev, dma_unmap_addr(pkt, dma[0]),
>                          dma_unmap_len(pkt, len[0]), DMA_TO_DEVICE);
>         for (i =3D 1; i < pkt->num_bufs; i++) {
> -               dma_unmap_page(dev, dma_unmap_addr(pkt, dma[i]),
> -                              dma_unmap_len(pkt, len[i]), DMA_TO_DEVICE)=
;
> +               netmem_dma_unmap_page_attrs(dev, dma_unmap_addr(pkt, dma[=
i]),
> +                                           dma_unmap_len(pkt, len[i]),
> +                                           DMA_TO_DEVICE, 0);
>         }
>         pkt->num_bufs =3D 0;
>  }
> --
> 2.49.0.805.g082f7c87e0-goog
>


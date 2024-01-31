Return-Path: <kvm+bounces-7550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1386D843AC1
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 10:17:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDF7628FCD3
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 09:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A85A7995C;
	Wed, 31 Jan 2024 09:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EyY4sPHw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C2A69D0C
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 09:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706692391; cv=none; b=Ahzq8xGHBHVQWMno4COTwuKEl00iQ2PZCvQB8CQjwn9paBkvQqNIz+F2X6ZxDvqFl2FINHm5skT/ucwcXvhVdKnY6E0yVnaUgxr2i96YI9R5DIXCW+IsfPF+jCfvJyM5StwmcwVZAmPqcptNePVQ3IA6knOlPALFuPoZ+K0J9fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706692391; c=relaxed/simple;
	bh=kgV9w/3r2N+l2XD1xKQ4N3OKQGrm1FtckgzvTrOPwHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DfP0CzHbjxuK7SnwIQesbf9doxo2OcgdaiFh76FpPpc1TZx5GHQzVRvFp5vmXU4X9v+vexw37LFKjeZIIWGF+RzIuuaeGXqAteEoCEdVXmuizbGmxjk+b81sp0QJOTCkDDmGc5tjvlFcNUqnpQcqSEEivNlmGWc50v0Zv7SxjHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EyY4sPHw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706692388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=60OE93oZxMpAy5PTfrRWb+NgmfRgxzqKxIV3hKWBwnk=;
	b=EyY4sPHwwwjfdZAhqkccdaKTnHYjCP8wnUPJQtLia/5qcHRciZCBifprTgA10XerC7J+ts
	B0GEAXwHpAAlLU38izQx5vW003vzR7FwaAFRjv1O48yHhhFayJf4z53ImVvPp8MX2QIcfx
	GR5zD7arPADipFDZDhClsQRgc+jvdzc=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-pXSlvKjtOuSqQazlwgvHAw-1; Wed, 31 Jan 2024 04:13:05 -0500
X-MC-Unique: pXSlvKjtOuSqQazlwgvHAw-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-7d5bbf0b3e3so1791198241.0
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 01:13:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706692385; x=1707297185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=60OE93oZxMpAy5PTfrRWb+NgmfRgxzqKxIV3hKWBwnk=;
        b=fn7J2lYD/mnrDPGhw1XV+Klqa7snxXgprehB8UfLsFXcxH4l+Mi5jdZu8QHrnjBwwV
         1CirGbcX7ImDva+c65qjBbT3vQo1EUooGw/pNiXOYpu6gNYODMjOHGBLVC75H3N2nLVg
         Jkox7Z4BueZ9rSZxE1R1d8v8SpeBvKSBB1j9UZUzN1nzMbNLIkyDhWuFJuv64kiPJW11
         e/TBIUunSCLbINEthWLDRtKNgkcS9f41flBUXqPXAvaT7USpWHlIsggnlNbmnGugLuqT
         fEPIuupYLEejtfWfteErgS+oN9fvGcyBLH6lT9Yx1XB1ri44AFxuuwI27x95VKYROvbG
         It0A==
X-Gm-Message-State: AOJu0YzJWBHhMGLI+bcypKTs/k/HWY7nFkNoqNNtdbDLEB+0/g1kUWCU
	v2rOUBX41Zgo2nRvVsIytcfu5Cfi4OYxFRqZrnPmgeOI8d17Z4dneU+U/p/LnqqTsakAfeWbxih
	UxW53TAobayW01ZQbFbltI6HyltsRNNSgiNaJmstHPpFnAteGhtxCdiywMvIuMKuXfFMMSIFue4
	z8/1WR2nbjZwDZEu0Ds5Xojst7
X-Received: by 2002:a05:6102:3a72:b0:46b:3515:e946 with SMTP id bf18-20020a0561023a7200b0046b3515e946mr689882vsb.26.1706692384885;
        Wed, 31 Jan 2024 01:13:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEgfhT0+kNvJvRq3b0MROwRjSrfE5RBznl53uEMT/GjL79yJlQ2dVHq4B1TZ1jfZQ3KLNrl4yziYblN9FfKH0U=
X-Received: by 2002:a05:6102:3a72:b0:46b:3515:e946 with SMTP id
 bf18-20020a0561023a7200b0046b3515e946mr689871vsb.26.1706692384618; Wed, 31
 Jan 2024 01:13:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com> <20240130114224.86536-18-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20240130114224.86536-18-xuanzhuo@linux.alibaba.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 31 Jan 2024 17:12:47 +0800
Message-ID: <CACGkMEv2cyuesaTx899hwZt7uDdqwmAwXJ8fZDv00W9FbVbTpw@mail.gmail.com>
Subject: Re: [PATCH vhost 17/17] virtio_net: sq support premapped mode
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	"Michael S. Tsirkin" <mst@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Hans de Goede <hdegoede@redhat.com>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Vadim Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck <cohuck@redhat.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Benjamin Berg <benjamin.berg@intel.com>, 
	Yang Li <yang.lee@linux.alibaba.com>, linux-um@lists.infradead.org, 
	netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30, 2024 at 7:43=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> If the xsk is enabling, the xsk tx will share the send queue.
> But the xsk requires that the send queue use the premapped mode.
> So the send queue must support premapped mode.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 167 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 163 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 226ab830870e..cf0c67380b07 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -46,6 +46,7 @@ module_param(napi_tx, bool, 0644);
>  #define VIRTIO_XDP_REDIR       BIT(1)
>
>  #define VIRTIO_XDP_FLAG        BIT(0)
> +#define VIRTIO_DMA_FLAG        BIT(1)
>
>  /* RX packet size EWMA. The average packet size is used to determine the=
 packet
>   * buffer size when refilling RX rings. As the entire RX ring may be ref=
illed
> @@ -140,6 +141,21 @@ struct virtnet_rq_dma {
>         u16 need_sync;
>  };
>
> +struct virtnet_sq_dma {
> +       union {
> +               struct virtnet_sq_dma *next;
> +               void *data;
> +       };
> +       dma_addr_t addr;
> +       u32 len;
> +       bool is_tail;
> +};
> +
> +struct virtnet_sq_dma_head {
> +       struct virtnet_sq_dma *free;
> +       struct virtnet_sq_dma *head;

Any reason the head must be a pointer instead of a simple index?

> +};
> +
>  /* Internal representation of a send virtqueue */
>  struct send_queue {
>         /* Virtqueue associated with this send _queue */
> @@ -159,6 +175,8 @@ struct send_queue {
>
>         /* Record whether sq is in reset state. */
>         bool reset;
> +
> +       struct virtnet_sq_dma_head dmainfo;
>  };
>
>  /* Internal representation of a receive virtqueue */
> @@ -348,6 +366,131 @@ static struct xdp_frame *ptr_to_xdp(void *ptr)
>         return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG=
);
>  }
>
> +static inline void *virtnet_sq_unmap(struct send_queue *sq, void *data)
> +{
> +       struct virtnet_sq_dma *head, *tail;
> +
> +       if (!((unsigned long)data & VIRTIO_DMA_FLAG))
> +               return data;
> +
> +       head =3D (void *)((unsigned long)data & ~VIRTIO_DMA_FLAG);
> +
> +       tail =3D head;
> +
> +       while (true) {
> +               virtqueue_dma_unmap_page_attrs(sq->vq, tail->addr, tail->=
len,
> +                                              DMA_TO_DEVICE, 0);
> +
> +               if (tail->is_tail)
> +                       break;
> +
> +               tail =3D tail->next;
> +       }
> +
> +       data =3D tail->data;
> +       tail->is_tail =3D false;
> +
> +       tail->next =3D sq->dmainfo.free;
> +       sq->dmainfo.free =3D head;
> +
> +       return data;
> +}
> +
> +static void *virtnet_sq_dma_splice(struct send_queue *sq,
> +                                  struct virtnet_sq_dma *head,
> +                                  struct virtnet_sq_dma *tail,
> +                                  void *data)
> +{
> +       sq->dmainfo.free =3D tail->next;
> +
> +       tail->is_tail =3D true;
> +       tail->data =3D data;
> +
> +       head =3D (void *)((unsigned long)head | VIRTIO_DMA_FLAG);
> +
> +       return head;
> +}
> +
> +static struct virtnet_sq_dma *virtnet_sq_map_sg(struct send_queue *sq, i=
nt nents, void *data)
> +{
> +       struct virtnet_sq_dma *head, *tail, *p;
> +       struct scatterlist *sg;
> +       dma_addr_t addr;
> +       int i;
> +
> +       head =3D sq->dmainfo.free;
> +       p =3D head;
> +
> +       tail =3D NULL;
> +
> +       for_each_sg(sq->sg, sg, nents, i) {
> +               addr =3D virtqueue_dma_map_page_attrs(sq->vq, sg_page(sg)=
,
> +                                                   sg->offset, sg->lengt=
h,
> +                                                   DMA_TO_DEVICE, 0);
> +               if (virtqueue_dma_mapping_error(sq->vq, addr))
> +                       goto err;
> +
> +               sg->dma_address =3D addr;
> +
> +               tail =3D p;
> +               tail->addr =3D sg->dma_address;
> +               tail->len =3D sg->length;
> +
> +               p =3D p->next;
> +       }
> +
> +       return virtnet_sq_dma_splice(sq, head, tail, data);
> +
> +err:
> +       if (tail)
> +               virtnet_sq_unmap(sq, virtnet_sq_dma_splice(sq, head, tail=
, data));
> +
> +       return NULL;
> +}
> +
> +static int virtnet_add_outbuf(struct send_queue *sq, u32 num, void *data=
)
> +{
> +       int ret;
> +
> +       if (sq->vq->premapped) {
> +               data =3D virtnet_sq_map_sg(sq, num, data);
> +               if (!data)
> +                       return -ENOMEM;
> +       }
> +
> +       ret =3D virtqueue_add_outbuf(sq->vq, sq->sg, num, data, GFP_ATOMI=
C);
> +       if (ret && sq->vq->premapped)
> +               virtnet_sq_unmap(sq, data);
> +
> +       return ret;
> +}
> +
> +static int virtnet_sq_init_dma_mate(struct send_queue *sq)
> +{
> +       struct virtnet_sq_dma *d;
> +       int size, i;
> +
> +       size =3D virtqueue_get_vring_size(sq->vq);
> +
> +       size +=3D MAX_SKB_FRAGS + 2;

Is this enough for the case where an indirect descriptor is used?

Thanks



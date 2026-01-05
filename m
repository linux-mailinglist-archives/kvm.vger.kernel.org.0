Return-Path: <kvm+bounces-67038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E1A8ACF2D52
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 10:49:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0C4CD3002B98
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 09:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E13337681;
	Mon,  5 Jan 2026 09:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IPumfYl0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A1D3370EB
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 09:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767606551; cv=none; b=V66LmLDHeiyG1dORWzXcLNqpFFm8vhDrrEPcJ+JRmdXhpq1rEJfcnAbsoj1ERvJlpmzbHS2cpXPxtKVPHuqTzynAvBCZGgNk1MDnyrxlK2aD9uHXmz+GXrzRdtG5dVfBlOOMJU/57AMOZfo7B5nVZ4zRRSIUPpnCqtE21j4X814=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767606551; c=relaxed/simple;
	bh=8CbJHVfpSbj65hHVB99d7ATe3Wwik903vzdQ5cEF6QE=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I4AGb0HcNLzkDz12TxRvyohnGH5jx9AmwLgYiK/9CrQlWG13BYITVuAzKDRRC7puYcklQme6LBrLyV4c5g+PWHwjC310sH4R1K0YnezNW/GhY9Ywssse7oKs8GZou8z2WrAqnVXZ+Hi5rGMB3wd6xtkLgtydkcW3ow/lWDFUsXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IPumfYl0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB10BC2BCF5
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 09:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767606550;
	bh=8CbJHVfpSbj65hHVB99d7ATe3Wwik903vzdQ5cEF6QE=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc:From;
	b=IPumfYl0DXkRZU/c+JLvVPmG8AV1wbKKZjIRViXKKkXCGIuj/1SAvu2iSLiN6vZZy
	 NFkZW6ip7ml0YSDmOqsoPCkDsH0HscXUlEJqCp+2rNrvMSmX4jyPEOqvC7Ivf3ge9p
	 hpLUZZuEB5QOGw3yDTFPHcoSpz9SqAGC2+Dg19w19xpLJeVqxJJfsExaMezUnfcIMj
	 Ci/7k0gAqwrwRRcO3dQTPzc/fOqMSqccQHqinLEFibAPtarCHdm5E3iFy7EBRoPxvN
	 BN9DsVUvRa89VYGHfF82SgEn93pXIyX3G7RE82waZQSamTR0D952A1iliAgjVpgvjZ
	 0bb4P5It2X4zA==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-37a3340391cso113269911fa.3
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 01:49:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWyzcO0KSeKGX/ApIUlHrLeFhi7AfDXXOKR38f/HCGmO+sHrfBCCf6ZwHWJlO3fDlW460c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2hLZLEZiCuBwJw5mi9kLEaqhrrohIPt6Q7DUFUHof6NcnLsNY
	sqREpcalVMqOz4APSxLeVlt8UV7+MmOCae9IymbAtkpIiesBItdxcl/RxYuYKBDffaXUkfA2uC5
	YRI7mXF6JvtRqaVFyHR+hgahYUielpBGP0l5zuzw/9g==
X-Google-Smtp-Source: AGHT+IFY1O0yqX2KFM5BXISLdft5QnkEvqK6J7qRpcO8YH+y7ocI2Ryp1czzENPI6ZvlJcXNSAZsGqkeSuJPLApNGk0=
X-Received: by 2002:a2e:bd16:0:b0:37b:b140:e512 with SMTP id
 38308e7fff4ca-3812155fe23mr120772921fa.10.1767606549336; Mon, 05 Jan 2026
 01:49:09 -0800 (PST)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 5 Jan 2026 09:49:06 +0000
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 5 Jan 2026 09:49:06 +0000
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <f1221bbc120df6adaba9006710a517f1e84a10b2.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1767601130.git.mst@redhat.com> <f1221bbc120df6adaba9006710a517f1e84a10b2.1767601130.git.mst@redhat.com>
Date: Mon, 5 Jan 2026 09:49:06 +0000
X-Gmail-Original-Message-ID: <CAMRc=MeTW7rTVBYBub5CL6-xSWKYOUtN7UN6cH12Or_K7PrAGQ@mail.gmail.com>
X-Gm-Features: AQt7F2rLja7Pdp6dL9tE5Odz4P7Ly_tad7MCwJDF4Imtz9X933YGdxrVzJYFsYc
Message-ID: <CAMRc=MeTW7rTVBYBub5CL6-xSWKYOUtN7UN6cH12Or_K7PrAGQ@mail.gmail.com>
Subject: Re: [PATCH v2 15/15] gpio: virtio: reorder fields to reduce struct padding
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Petr Tesarik <ptesarik@suse.com>, Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org, 
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	"Enrico Weigelt, metux IT consult" <info@metux.net>, Viresh Kumar <vireshk@kernel.org>, Linus Walleij <linusw@kernel.org>, 
	linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 5 Jan 2026 09:23:49 +0100, "Michael S. Tsirkin" <mst@redhat.com> said:
> Reorder struct virtio_gpio_line fields to place the DMA buffers
> (req/res) last.
>
> This eliminates the padding from aligning struct size on
> ARCH_DMA_MINALIGN.
>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/gpio/gpio-virtio.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpio/gpio-virtio.c b/drivers/gpio/gpio-virtio.c
> index b70294626770..ed6e0e90fa8a 100644
> --- a/drivers/gpio/gpio-virtio.c
> +++ b/drivers/gpio/gpio-virtio.c
> @@ -26,11 +26,12 @@ struct virtio_gpio_line {
>  	struct mutex lock; /* Protects line operation */
>  	struct completion completion;
>
> +	unsigned int rxlen;
> +
>  	__dma_from_device_group_begin();
>  	struct virtio_gpio_request req;
>  	struct virtio_gpio_response res;
>  	__dma_from_device_group_end();
> -	unsigned int rxlen;
>  };
>
>  struct vgpio_irq_line {
> --
> MST
>
>

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>


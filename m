Return-Path: <kvm+bounces-12963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AE5288F718
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 06:17:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47F4D1C2494B
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 05:17:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F75A4DA06;
	Thu, 28 Mar 2024 05:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gXPbjKTb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFE340867
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 05:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711602998; cv=none; b=gEbh05ziVV/Nb1slyjkDwUxAc5kizKdTO+tUQjJOH9pQouhVVrLGUZ3H4lHf4BYjNIqwblKTmKuVUf/+fG1JdUsF0cNAd1YL8x+XB9NTVhdJ8QkJgQnMN8BbtGlr2h8hYzzbCxKFyp4rHAzg1/1E1KBg1fE5rjZGL6UZQbBj6Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711602998; c=relaxed/simple;
	bh=sBPTJcGEYTbv3hcgUwqNauzYtskOKb+GWpnb7br0MOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lbSKhW5A/+hpvvIL1eV++hH/cbKIwU4PeM849tC0zZfq6YP6K2P0umvdJ7Y8mrcxfFNssLMcygGXHWjHYuVrC6tUtTEIVrSbv/eBR3RPtl2deNwZ8Th02pL7PhmFmOL4qpj7QckhwOeRaEZzH+4cQF9NhwwWtfLZ8LB6IaIUFd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gXPbjKTb; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5a58009fe88so308068eaf.0
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 22:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711602994; x=1712207794; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NCBBqATkrmhAqNvcc7V5yUc6Bj0MDD2J9Hd2vuTQUac=;
        b=gXPbjKTbrvtfpT6/qEmVUxns+A30LH6QOiAjT4F0xLZUPzUZg0ordNOvATabg2F/Wl
         kPv7rlwtWOxfgPm2w1j9yiVchrEqiifXfpuqKbM3c55rO+d/cQmcOVsJtdO/BdsefRN9
         RxOKLZQ8lQKHo0Up3S4+54dabwBIgvbFJlg0eTR2NGULCedimJYCVi8NEO/uINa2jv1N
         m9SrGDUqniaEzEwLDKjTqPO6IIW3ujVusL7p6WPrXVYciMFtPwv7L9mAU+/qpWitn5fr
         hH1CJycNEicAhv28MTJZUrDtXoqvUlSPCv54sDagwBcdt6nzOokgIGUCvI13cWlf71La
         jDOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711602994; x=1712207794;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NCBBqATkrmhAqNvcc7V5yUc6Bj0MDD2J9Hd2vuTQUac=;
        b=onNeyqN5lFaHIsxHkN79KoX4lK8ToLj/SASOCv/cnoM6mYS+1fZm1TzdeyJG/U6l5g
         ajm6SSCQ6FZYvOPdGxsTdGdgWLrFU3IQUbV2tCN3nj362UTJnZUvB7hX2QHUNZXZULnU
         D48hCs5yhcsnFIGp6bn9U1Q11S0AVFbSvumeLQhbRbPzf9jCrV6JWycfwRzIbIbjrVHP
         YzaaH01TnnOyy8iBc2v0JC4IiBTjeSdI0OWWcGyGnFhpy6BYKLTvG3eKC9uoV8BN41MI
         sne0B8HIIq6MRlMzVw+GGeVLqu3efIA7O9j2XHrfkSaXtNpH7ZkxXG9vXicx1JAFUt69
         WrSg==
X-Forwarded-Encrypted: i=1; AJvYcCVbYpBa361K4LNiM+2VzkH1msBgJ49EFUGYtJGilqD8/tV5wSN9+Y7VS3aGz98lbQS6uwmbuHn/FQileruI9bGjIC4a
X-Gm-Message-State: AOJu0YyPJbsAz9RpC/VgyhufrnlmMsFlyoqfd5KDHeo+0402cEkSGa/W
	iKv80zoSrTzbDDNmBCT+2X6kodgpJz/sE87DD4xWDkq6WSeTgtQPxy218D1+/mU=
X-Google-Smtp-Source: AGHT+IENjWm30W77Sho1F7STKjVDKRSghd/5qoLRwkalJNx2D7PN+W1+MnXgZZvq+TiwN/1tI/fojA==
X-Received: by 2002:a05:6358:5307:b0:17e:8f90:dd31 with SMTP id n7-20020a056358530700b0017e8f90dd31mr1555244rwf.32.1711602994298;
        Wed, 27 Mar 2024 22:16:34 -0700 (PDT)
Received: from localhost ([122.172.85.206])
        by smtp.gmail.com with ESMTPSA id u23-20020a63df17000000b005e857bba96csm433309pgg.10.2024.03.27.22.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 22:16:33 -0700 (PDT)
Date: Thu, 28 Mar 2024 10:46:31 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gonglei <arei.gonglei@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Viresh Kumar <vireshk@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	David Airlie <airlied@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>, Alexander Graf <graf@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Kalle Valo <kvalo@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
	Anton Yakovlev <anton.yakovlev@opensynergy.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	virtualization@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev, netdev@vger.kernel.org, v9fs@lists.linux.dev,
	kvm@vger.kernel.org, linux-wireless@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-remoteproc@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-sound@vger.kernel.org
Subject: Re: [PATCH 09/22] gpio: virtio: drop owner assignment
Message-ID: <20240328051631.c5eitp4mzaj4bh6i@vireshk-i7>
References: <20240327-module-owner-virtio-v1-0-0feffab77d99@linaro.org>
 <20240327-module-owner-virtio-v1-9-0feffab77d99@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327-module-owner-virtio-v1-9-0feffab77d99@linaro.org>

On 27-03-24, 13:41, Krzysztof Kozlowski wrote:
> virtio core already sets the .owner, so driver does not need to.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> Depends on the first patch.
> ---
>  drivers/gpio/gpio-virtio.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpio-virtio.c b/drivers/gpio/gpio-virtio.c
> index fcc5e8c08973..9fae8e396c58 100644
> --- a/drivers/gpio/gpio-virtio.c
> +++ b/drivers/gpio/gpio-virtio.c
> @@ -653,7 +653,6 @@ static struct virtio_driver virtio_gpio_driver = {
>  	.remove			= virtio_gpio_remove,
>  	.driver			= {
>  		.name		= KBUILD_MODNAME,
> -		.owner		= THIS_MODULE,
>  	},
>  };
>  module_virtio_driver(virtio_gpio_driver);

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh


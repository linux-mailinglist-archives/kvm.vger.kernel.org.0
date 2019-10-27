Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C3FE61F1
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2019 11:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfJ0KEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 06:04:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39070 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbfJ0KER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 06:04:17 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D3FADC049E10
        for <kvm@vger.kernel.org>; Sun, 27 Oct 2019 10:04:16 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id m189so7330327qkc.7
        for <kvm@vger.kernel.org>; Sun, 27 Oct 2019 03:04:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DIl+XjLva0/Mm7Hs+GCeYJOa+yDwPi8Nqp5nHz6nVLQ=;
        b=qXaZAom64KGuz6wwpBxw4v6oV/Q5JBQj4m0xjp8gdWs0WJ7xfJ5TBkpMcfksq98Pi9
         Jda8A+O+AzjOjIEqbsT8JPUMpLzQ4Q/aiK5UsYqN2tOsSjVsalve8q7PnWAWLbT3AHx/
         re4cbd309t3w/3wWuHN3NXKppTO9dxDMH+hPwJ7L2ufHhUmy2tRbhcCkCDuXuJfJHxuI
         1IwK/uv5YdYRObLPo1E6OFn+MDem+ANdCgtQpLKBz3mt553cB5vUUMK2cthL8Q1WDMsY
         ypL69V8DKQaSfncUeWFO7M9e6i00yZZP94gZXgv3cvfu35PnxumugWPVdq0MOz0hBXYK
         Dyaw==
X-Gm-Message-State: APjAAAUCBPTNKpgTMc54fbfG/PoLDdAjQuNFahr9YSOAVS0K4/QsQxbR
        kkzZk4pm9IeXz1I2cD1nS4ogVlfaFYw6smoQKvBlJCnnZUqOeiFASzU0HGMnr+obcmTdFIhvkUJ
        hTOvxBNXdhkre
X-Received: by 2002:ac8:18eb:: with SMTP id o40mr12230184qtk.304.1572170656208;
        Sun, 27 Oct 2019 03:04:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxGQTCutbRGwG/hqehf3CeyndAKewdMdeoJOADviHDVuig69eSpbDhlBsX3tnjDPNRXLTAZiA==
X-Received: by 2002:ac8:18eb:: with SMTP id o40mr12230171qtk.304.1572170655989;
        Sun, 27 Oct 2019 03:04:15 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id b185sm5051949qkg.45.2019.10.27.03.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 03:04:14 -0700 (PDT)
Date:   Sun, 27 Oct 2019 06:04:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] vringh: fix copy direction of
 vringh_iov_push_kern()
Message-ID: <20191027060328-mutt-send-email-mst@kernel.org>
References: <20191024035718.7690-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024035718.7690-1-jasowang@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 11:57:18AM +0800, Jason Wang wrote:
> We want to copy from iov to buf, so the direction was wrong.
> 
> Note: no real user for the helper, but it will be used by future
> features.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

I'm still inclined to merge it now, incorrect code tends to
proliferate.

> ---
>  drivers/vhost/vringh.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 08ad0d1f0476..a0a2d74967ef 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -852,6 +852,12 @@ static inline int xfer_kern(void *src, void *dst, size_t len)
>  	return 0;
>  }
>  
> +static inline int kern_xfer(void *dst, void *src, size_t len)
> +{
> +	memcpy(dst, src, len);
> +	return 0;
> +}
> +
>  /**
>   * vringh_init_kern - initialize a vringh for a kernelspace vring.
>   * @vrh: the vringh to initialize.
> @@ -958,7 +964,7 @@ EXPORT_SYMBOL(vringh_iov_pull_kern);
>  ssize_t vringh_iov_push_kern(struct vringh_kiov *wiov,
>  			     const void *src, size_t len)
>  {
> -	return vringh_iov_xfer(wiov, (void *)src, len, xfer_kern);
> +	return vringh_iov_xfer(wiov, (void *)src, len, kern_xfer);
>  }
>  EXPORT_SYMBOL(vringh_iov_push_kern);
>  
> -- 
> 2.19.1

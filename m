Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0C4B2CB7
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2019 21:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731246AbfINTis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Sep 2019 15:38:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51638 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729949AbfINTir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Sep 2019 15:38:47 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2CE2FC04B946
        for <kvm@vger.kernel.org>; Sat, 14 Sep 2019 19:38:47 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id o133so37265959qke.4
        for <kvm@vger.kernel.org>; Sat, 14 Sep 2019 12:38:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KIGHcmUUN4jMJWs2R7tAQdbVbc2v6AIe7xkdq87Pa2A=;
        b=cHYk7EIPV+c56//FcypFx9L1g0W1MyQuBQIESaRBv5E/hkAvhv5h+V8cp+4UFMYFwn
         DuiRycuchi8xM11KK95Tho+vqnGANOnSp+wXuDSD6T+BIp/BdJRsRFckY/VypZLDD23S
         lcgA8BxpsJTl3u47ZWYWwuE2bZfALn9aQ7VcVcGRZjxOEhEA+8j3M0Hd/vfb6Fo8K8FI
         r4/Mta2fQyt5M96p1EdkIrWeeIjxSyl/b6cXyEQnug6W3pbZTkJWHxv6jK9OqJhmjrIJ
         CyWGe5vuO5sT+DykVqcwmYpLneogTouhhF3M1LA2tlMT8hf6tmxHg8bxxT5NDjUlCf1H
         /WEg==
X-Gm-Message-State: APjAAAVAp5nJF3yDHAJeBNaNolJ3NZtR/QAxS0AaK/APW4yER2H5dF9M
        jFDXYMgyZlZCPTAQjcQoGUzTK4m3aFqLkZSGNDDoACxgfs6Bm1PMZ7B4FdUUJwifoeojZlwtk+m
        QIh1ALCSJ3W2p
X-Received: by 2002:a05:620a:c:: with SMTP id j12mr49368891qki.127.1568489926544;
        Sat, 14 Sep 2019 12:38:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw7wOJHQxLUm66la0qX4SPSRkPiO4NywNevPf0TnyLpnxGz/aWmk5UQ6mtqxs1zvRBm/WQW7Q==
X-Received: by 2002:a05:620a:c:: with SMTP id j12mr49368877qki.127.1568489926312;
        Sat, 14 Sep 2019 12:38:46 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id 60sm15837153qta.77.2019.09.14.12.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 12:38:45 -0700 (PDT)
Date:   Sat, 14 Sep 2019 15:38:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] vhost: Fix compile time error
Message-ID: <20190914153325-mutt-send-email-mst@kernel.org>
References: <1568450697-16775-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568450697-16775-1-git-send-email-linux@roeck-us.net>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 14, 2019 at 01:44:57AM -0700, Guenter Roeck wrote:
> Building vhost on 32-bit targets results in the following error.
> 
> drivers/vhost/vhost.c: In function 'translate_desc':
> include/linux/compiler.h:549:38: error:
> 	call to '__compiletime_assert_1879' declared with attribute error:
> 	BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
> 
> Fixes: a89db445fbd7 ("vhost: block speculation of translated descriptors")
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>



> ---
>  drivers/vhost/vhost.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index acabf20b069e..102a0c877007 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2074,7 +2074,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
>  		_iov->iov_base = (void __user *)
>  			((unsigned long)node->userspace_addr +
>  			 array_index_nospec((unsigned long)(addr - node->start),
> -					    node->size));
> +					    (unsigned long)node->size));

Unfortunately this does not fix the case where size is actually 64 bit,
e.g. a single node with VA 0, size 2^32 is how
you cover the whole virtual address space.

this is not how qemu uses it, but it's valid.

I think it's best to just revert the patch for now.

>  		s += size;
>  		addr += size;
>  		++ret;
> -- 
> 2.7.4

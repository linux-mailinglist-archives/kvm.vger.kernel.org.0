Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13B637A272
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 10:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhEKItT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 04:49:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230316AbhEKItQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 04:49:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620722890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PoB6tmhK0ojxZqg4RY27A1X/0CCVW4jvcBEro4rmZ2U=;
        b=DOPKK4oRwvrvoCYmx+JYC8HVRiAGWOfa+jnw2aKehisVd/ToQSG/EY5Vr4yU0l3kbQxbev
        QWXMNtH+PJy/I/+yVGvunNm4tEonUxIoTMdZ+9DrgU9ZhYNEPe6bGchNFT5cuG6COwQ/kr
        CHcHrWRJ4Ro9xdFEE2MVZX/fWVWZgx8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-GugpThWDPmm3AM5XtpGcxQ-1; Tue, 11 May 2021 04:48:08 -0400
X-MC-Unique: GugpThWDPmm3AM5XtpGcxQ-1
Received: by mail-wr1-f71.google.com with SMTP id a12-20020a5d6cac0000b0290109c3c8d66fso8482394wra.15
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 01:48:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PoB6tmhK0ojxZqg4RY27A1X/0CCVW4jvcBEro4rmZ2U=;
        b=N7LJGNGH/88SvBHd2JA8Iy9GW+0T2e8z2XJQa6EAqJao31WjmN+JkSZWc9oUNEY8C5
         +/xrofUqmQ6gKzipNPQKbEkNQb8OebmdSTxjdugNzl02/uqNF75Io+xzf5PwLj7oA+0n
         iiTekryaTIl+ZBCvt3viX9S3pA7N0dMi+1YjycvB8+hJYDf2WLvLRuHYa8I5S4ZpnnI0
         5MWxMJ0a4gOGx+qz7xQRaOYpf6BczyOmb2sYuN+GB5ElqGjOtH+SZMksz+A+mbcRL5gD
         jK/yBhC6Bu75EU2J06VCRM0nT3wcUe8oW93GNXI0FpGPVo7l9kZqlgByvYRKghlFOSDg
         52SA==
X-Gm-Message-State: AOAM530/nrL1sYeqW7qik/6G2M2HPvAiP3ENpHZH+HX6ygQ3jdWrIVNV
        8A3SaI6xLPlXgSzhzE8O76wuWNxQkpmocVErw7VUiMeDyyTo0Q7carMA9M/ExuI6JOQM8GnETNB
        G/uSARLh36a61
X-Received: by 2002:a1c:4d01:: with SMTP id o1mr31902623wmh.42.1620722887554;
        Tue, 11 May 2021 01:48:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSGeb9zeNJcEJc46A/MASJMpLh0cSVeptzLQX8/dyHTwjbhVOWjTy0K8ideXs9zrKhUkYH5w==
X-Received: by 2002:a1c:4d01:: with SMTP id o1mr31902599wmh.42.1620722887375;
        Tue, 11 May 2021 01:48:07 -0700 (PDT)
Received: from redhat.com ([2a10:8004:640e:0:d1db:1802:5043:7b85])
        by smtp.gmail.com with ESMTPSA id l18sm26972171wrt.97.2021.05.11.01.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 01:48:06 -0700 (PDT)
Date:   Tue, 11 May 2021 04:48:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, maz@kernel.org, alex.williamson@redhat.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, cohuck@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
Message-ID: <20210511044756-mutt-send-email-mst@kernel.org>
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508071152.722425-1-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 08, 2021 at 03:11:52PM +0800, Zhu Lingshan wrote:
> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
> 
> The reverted commit may cause VM freeze on arm64 platform.
> Because on arm64 platform, stop a consumer will suspend the VM,
> the VM will freeze without a start consumer
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  virt/lib/irqbypass.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
> index c9bb3957f58a..28fda42e471b 100644
> --- a/virt/lib/irqbypass.c
> +++ b/virt/lib/irqbypass.c
> @@ -40,21 +40,17 @@ static int __connect(struct irq_bypass_producer *prod,
>  	if (prod->add_consumer)
>  		ret = prod->add_consumer(prod, cons);
>  
> -	if (ret)
> -		goto err_add_consumer;
> -
> -	ret = cons->add_producer(cons, prod);
> -	if (ret)
> -		goto err_add_producer;
> +	if (!ret) {
> +		ret = cons->add_producer(cons, prod);
> +		if (ret && prod->del_consumer)
> +			prod->del_consumer(prod, cons);
> +	}
>  
>  	if (cons->start)
>  		cons->start(cons);
>  	if (prod->start)
>  		prod->start(prod);
> -err_add_producer:
> -	if (prod->del_consumer)
> -		prod->del_consumer(prod, cons);
> -err_add_consumer:
> +
>  	return ret;
>  }
>  
> -- 
> 2.27.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A82266640
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 19:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgIKRYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 13:24:12 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60420 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726283AbgIKRXr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 13:23:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599845025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6/o0YxxUXNU/wKu4OmvlwpD3hfIBQxLaL46/ODaoc/s=;
        b=hbYdd7xmJ1g8ksJTQMd9nDepyQZRW20YUvM0z6Dq1A30W6OSu+HmOo63LD7AdgMX7WKn+M
        EoclUvhccVU9gseknbhQ8kq088hrqdj2RT6J03ssqffJo0rgzEnDA3pC4K3JLNWf31pBe+
        yjoBho0fKcXAqJPDhmeqdqjNo35c9qY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-iOEqh9fPOAmEeZdfK1rV4w-1; Fri, 11 Sep 2020 13:23:44 -0400
X-MC-Unique: iOEqh9fPOAmEeZdfK1rV4w-1
Received: by mail-wm1-f71.google.com with SMTP id w3so1185412wmg.4
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 10:23:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6/o0YxxUXNU/wKu4OmvlwpD3hfIBQxLaL46/ODaoc/s=;
        b=Jv1B0u+3UT1LhmdbcdRSk+RUuNBbMhgmJ02C/OQdp+uthRu0oodKXYTJq/x8bFF7IP
         cbGv3EXk5ZBJiPxmQUs1CVl9FnmFLJj/lxjP/VpYf0W+I8hFxr2BeXgDsXp/5BAJq+6/
         PMnLN7bZqRlsJY1ZIDF+rw22Bcx6OAGooEemlp9Qx0/IORLhcUAyP5fQivnPHFhmdH8F
         xDa+Y51Xk64K1f6xWhd9iGGncmdAX36Yuh8SQdbXKBPHKoCMr2+Byu+NhFW1PRPuBIf8
         9zgRFxblniGqfEURiq+UOSbZMxBcqn5LS3ksHpaA705FgjaRQRqMWM4CXvkY5+7vu5ga
         jBSA==
X-Gm-Message-State: AOAM530fARCnxlBlLUzzn5A7D9fjtMAQWHd/jhOaSF/Tg8ahUDVz9iG/
        Clj7IGqZfFZxIfQ7McE7d9/TiIrm0JpaoIjK6SUjP77zM7i29c0l6ixBMqPYwwpgMisaVCYqPs0
        6DY3ewvFf+vDt
X-Received: by 2002:a7b:cc8f:: with SMTP id p15mr3243419wma.18.1599845022915;
        Fri, 11 Sep 2020 10:23:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvu60NsLfN4Uw7tAn/ZEYwhNh26zDKlFJq0QCEwb/uKMZajgERhJn044lBeKtqe43zjrt4OQ==
X-Received: by 2002:a7b:cc8f:: with SMTP id p15mr3243405wma.18.1599845022676;
        Fri, 11 Sep 2020 10:23:42 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id v6sm5589531wrt.90.2020.09.11.10.23.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 10:23:42 -0700 (PDT)
Subject: Re: [PATCH] kvm/eventfd:do wildcard calculation before
 list_for_each_entry_safe
To:     Yi Li <yili@winhong.com>
Cc:     yilikernel@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200911055652.3041762-1-yili@winhong.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20efe3ed-8efa-ed50-bd01-329db676ee86@redhat.com>
Date:   Fri, 11 Sep 2020 19:23:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200911055652.3041762-1-yili@winhong.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/09/20 07:56, Yi Li wrote:
> There is no need to calculate wildcard in each loop
> since wildcard is not changed.
> 
> Signed-off-by: Yi Li <yili@winhong.com>
> ---
>  virt/kvm/eventfd.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index d6408bb497dc..c2323c27a28b 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -853,15 +853,17 @@ kvm_deassign_ioeventfd_idx(struct kvm *kvm, enum kvm_bus bus_idx,
>  	struct eventfd_ctx       *eventfd;
>  	struct kvm_io_bus	 *bus;
>  	int                       ret = -ENOENT;
> +	bool                      wildcard;
>  
>  	eventfd = eventfd_ctx_fdget(args->fd);
>  	if (IS_ERR(eventfd))
>  		return PTR_ERR(eventfd);
>  
> +	wildcard = !(args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH);
> +
>  	mutex_lock(&kvm->slots_lock);
>  
>  	list_for_each_entry_safe(p, tmp, &kvm->ioeventfds, list) {
> -		bool wildcard = !(args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH);
>  
>  		if (p->bus_idx != bus_idx ||
>  		    p->eventfd != eventfd  ||
> 

Queued, thanks.

Paolo


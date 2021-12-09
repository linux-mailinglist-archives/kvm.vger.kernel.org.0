Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CE846E0C3
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 03:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhLICQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 21:16:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229835AbhLICQZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 21:16:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639015973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MEWVgWgffKxw4U2CvNG/Nz2R6p0InYBLy3bcY3R6wRg=;
        b=VAmx8YfYdFIoJkzi3E+aXeE+4Fkhvb2lUno+Nb4GNTpwcF9pHAXrM5xFP0EZxiFRNyQAfx
        Mpn/yvOy/86pvGsrucTCLCOzTiJwAo18ff+wmDrKaJEqQZ3UL8+L63X6Fy9bVLzE64gDio
        D+OpufV6sYjWqjU20Qt1VC5wadeqLyI=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-JGnNKuOkM8CeI2H31QXbMw-1; Wed, 08 Dec 2021 21:12:52 -0500
X-MC-Unique: JGnNKuOkM8CeI2H31QXbMw-1
Received: by mail-lj1-f198.google.com with SMTP id p21-20020a2e9ad5000000b00219ee503efeso1244201ljj.14
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 18:12:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MEWVgWgffKxw4U2CvNG/Nz2R6p0InYBLy3bcY3R6wRg=;
        b=ix/7VcALXMOjIY06ccm0R7fBWnvneZ1X6fl8GQfIyK/89dUtJjGf/VzNdJ7m15U8qt
         FIcQ04/Z8qIQEQ7FF62JrLNdq3OQnS0OgJaAHydkO8hHfZMaAFXHRr1WLXe5RTxTzQyn
         9VmV3PtjAeS6XmdZBoEJQ/4CmqfID6d3QqXcwXV91w+1F7cuo9UP2lv+jmd1BDpS6h9Y
         RBTsmYZ55ZNcMsGqpX5lJDtR1hkUnsB1ceAoj1D1Pp4rkDAPXHo4R5wBXEQXiAD9ppeU
         W1GuFiF4xHV0UJG5Lx8mGDcdU+POOooEguCUKYAbiMr+SOcAbxzoCjVVV6WuXQ1KW2uE
         ulTA==
X-Gm-Message-State: AOAM530xTkWPpSRmY94C/TdYlkP9Y7Pp+E518YSoOhAZ+Ncaw1kfLc8T
        9uno+02+RAUyX1GBjSkP3xPd9d+xToVk+fI8ZDa6niEyNPcvd3gwLxM7oV6LlwjAWc3U9zK5eCM
        P4kU8yvXgfp5ugoWvbR0wv9+RHot+
X-Received: by 2002:a05:6512:685:: with SMTP id t5mr3180193lfe.84.1639015970546;
        Wed, 08 Dec 2021 18:12:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwWSd19fYzNfzF0iKgDq8dz6O3KSiopO1bKJF9lx/YJwa4HcsU1ukxk7ZBqxihKr9YzOp/zGv6WN1NjNiAR38o=
X-Received: by 2002:a05:6512:685:: with SMTP id t5mr3180178lfe.84.1639015970369;
 Wed, 08 Dec 2021 18:12:50 -0800 (PST)
MIME-Version: 1.0
References: <20211208103307.GA3778@kili> <20211208103337.GA4047@kili>
In-Reply-To: <20211208103337.GA4047@kili>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 9 Dec 2021 10:12:39 +0800
Message-ID: <CACGkMEtp+29Y4zcUppakRmQLqKbkUfFN-dm6a70bvn9GUCrWRA@mail.gmail.com>
Subject: Re: [PATCH 2/2 v4] vdpa: check that offsets are within bounds
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 8, 2021 at 6:34 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> In this function "c->off" is a u32 and "size" is a long.  On 64bit systems
> if "c->off" is greater than "size" then "size - c->off" is a negative and
> we always return -E2BIG.  But on 32bit systems the subtraction is type
> promoted to a high positive u32 value and basically any "c->len" is
> accepted.
>
> Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> Reported-by: Xie Yongji <xieyongji@bytedance.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
> v4: split into a separate patch
>
>  drivers/vhost/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 29cced1cd277..e3c4f059b21a 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -197,7 +197,7 @@ static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
>         struct vdpa_device *vdpa = v->vdpa;
>         long size = vdpa->config->get_config_size(vdpa);
>
> -       if (c->len == 0)
> +       if (c->len == 0 || c->off > size)
>                 return -EINVAL;
>
>         if (c->len > size - c->off)
> --
> 2.20.1
>


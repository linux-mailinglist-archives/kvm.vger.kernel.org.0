Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECFB768874B
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 20:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjBBTDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 14:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbjBBTDK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 14:03:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A89445BE0
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 11:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675364544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4o2AJqH1LncKqMk2D1jCK1GtMJr5qHrJunic916Hg94=;
        b=UoQzixwJUtNozjBerjtq0Z3A5Kl05J98C4M+guqkx/Qu9z6Ves5Dj2Uw/C8U6ST0Xr5bT7
        +m3mYNZzDehDNZm9vmwSYFTTqIMEme4csN5TKN1G8jNFJEgd2/dqZ1RftfCUBBXiL/Ux9a
        XznGIXNwRJH6OV4NXfEmFEltHy2bS1g=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-155-A7rGto5sPy-ZfJFKvgCiiw-1; Thu, 02 Feb 2023 14:02:21 -0500
X-MC-Unique: A7rGto5sPy-ZfJFKvgCiiw-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-4c8e781bc0aso29293647b3.22
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 11:02:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4o2AJqH1LncKqMk2D1jCK1GtMJr5qHrJunic916Hg94=;
        b=AthzZ4/rdIw0IEY88+RVs3aRJyT7uAPsewvu1B4M3rAXzfmL7isMy8HiNqzQYh9GiL
         AbERPnrxQSK0ZRqNDvSCSTDnRPYqEY/O1gxDpHqgt14QhEkLIlWhpHmYVkQh1zGExkuQ
         BIXAAQsvn00YrYezqQpbU2sR7T5uwr1PhqNNnLGJZjnvT5nLO2cwU15RHguJ+JzBhbxi
         i2bAAJ79oRKfu4qMeK38M4f6QP4yhWQ0aR9J8VZGGyiDqLmRUHxqiWSFxPVF8Cp9tRvV
         MsCK4hdDJTSTlON9Z0kOomQakVYI8MLdQzxVWsgVdlp5OKBA2WXHtEdHYKB+Y7k7rKPp
         4h+Q==
X-Gm-Message-State: AO0yUKXHs+Ocw/AaYOUZ1fcCRfs2UVgz57yzD/bknzVITtfF7hDYHk8O
        1ABHLNvFsd6KpD1rgoYLejsLnJTOUz/UOYGkXweRrx1x93rhlzNcoBHQRbFMnQNf3oo1PJXSr8j
        dATOtf5wGjWzG17U3FsuVDDbbXQsc
X-Received: by 2002:a0d:d40e:0:b0:51b:64c0:3251 with SMTP id w14-20020a0dd40e000000b0051b64c03251mr958175ywd.266.1675364540775;
        Thu, 02 Feb 2023 11:02:20 -0800 (PST)
X-Google-Smtp-Source: AK7set/riZxYvQVJ3LC0NhNQqpRjygkYkpjD+BLDdbvtidfkPC0ROeO4nsgpqbwnaZyZ0ebQph7F3TISMNXl0y3nYCs=
X-Received: by 2002:a0d:d40e:0:b0:51b:64c0:3251 with SMTP id
 w14-20020a0dd40e000000b0051b64c03251mr958168ywd.266.1675364540565; Thu, 02
 Feb 2023 11:02:20 -0800 (PST)
MIME-Version: 1.0
References: <20230201152018.1270226-1-alvaro.karsz@solid-run.com> <20230202084212.1328530-1-alvaro.karsz@solid-run.com>
In-Reply-To: <20230202084212.1328530-1-alvaro.karsz@solid-run.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 2 Feb 2023 20:01:44 +0100
Message-ID: <CAJaqyWeQRcnZ45xHYjbOhcQpN4kpPWADAK2gTvmBVeMwp19H8Q@mail.gmail.com>
Subject: Re: [PATCH v2] vhost-vdpa: print warning when vhost_vdpa_alloc_domain fails
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 2, 2023 at 9:42 AM Alvaro Karsz <alvaro.karsz@solid-run.com> wr=
ote:
>
> Add a print explaining why vhost_vdpa_alloc_domain failed if the device
> is not IOMMU cache coherent capable.
>
> Without this print, we have no hint why the operation failed.
>
> For example:
>
> $ virsh start <domain>
>         error: Failed to start domain <domain>
>         error: Unable to open '/dev/vhost-vdpa-<idx>' for vdpa device:
>                Unknown error 524
>
> Suggested-by: Eugenio Perez Martin <eperezma@redhat.com>
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
>

Acked-by: Eugenio P=C3=A9rez Martin <eperezma@redhat.com>

Thanks!

> ---
> v2:
>         - replace dev_err with dev_warn_once.
>
>  drivers/vhost/vdpa.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 23db92388393..135f8aa70fb2 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1151,8 +1151,11 @@ static int vhost_vdpa_alloc_domain(struct vhost_vd=
pa *v)
>         if (!bus)
>                 return -EFAULT;
>
> -       if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY))
> +       if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY)) {
> +               dev_warn_once(&v->dev,
> +                             "Failed to allocate domain, device is not I=
OMMU cache coherent capable\n");
>                 return -ENOTSUPP;
> +       }
>
>         v->domain =3D iommu_domain_alloc(bus);
>         if (!v->domain)
> --
> 2.34.1
>


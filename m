Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A982564E752
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 07:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiLPGiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 01:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLPGis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 01:38:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F9D165A1
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 22:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671172681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cW+bMkU3xKEQP1YgUGCBEYHN1PIY0xAoXY4S8XVaLQU=;
        b=aQHQACtf9DyEFrLx3qbwm/2jY+DOf1e7kHkxTIsugnzYZyNPmILQsbJQG5f4nUknl3nbea
        mkUmxGg6KB/D8YFbDzYCaXHWuOaUdUsCUKEk7ww3pfman5umcpcIOReA7GOixcXBrsaKca
        gTq8ns+Y9G+Nkw4LniLkvxnV8WgDAPU=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-513-oLwxku3cNcaFrcAYYnFx3g-1; Fri, 16 Dec 2022 01:37:57 -0500
X-MC-Unique: oLwxku3cNcaFrcAYYnFx3g-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-144da30bb39so878805fac.10
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 22:37:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cW+bMkU3xKEQP1YgUGCBEYHN1PIY0xAoXY4S8XVaLQU=;
        b=xpI1eMfl98/EtD8tYBM54EHABPPEAaZP8zU670cf1xJuiZzELxnEeXdcuh/2pQRwiv
         d2mED4YZWPht37QVgVlfaDrVEQU0+RxymkZmzuJ5zG/F5S7JzkjnuoHbPCkPWmOrvG6X
         2lC9AiNziw3NTiKlfONwfiw579sPKkax7KcOjJl/Au/m1cgxWqDnFxrS7oiW3zmGAL+m
         vdB55qLGENmkuPZHza9S8+IUKoZHo0lo5Fq/e9JrohY7kp8IA4PK7RbtHT/lB3VOYTnU
         8e4D7UAp4X6AgvAjo9xPJbBur+W3lQW4y5AOnf+zVt+Y7Q6pQb8l+E29JAjPaUuO1MlD
         Xsiw==
X-Gm-Message-State: ANoB5pm4mLiEX1nzUVdk3fYogCTisjIswEKmkb+LUaomNvbvkqBq8mFj
        wnrrfrOXnFdkrARf8V8Vjp2SeSbrH7ztALfA8tK5bQ8bIkqNU2sMqCj+ITxy5Rgv8jYALWYuL2O
        yH17XJYtXU4bUFsomfSma09j5fOpd
X-Received: by 2002:a05:6830:6505:b0:66c:fb5b:4904 with SMTP id cm5-20020a056830650500b0066cfb5b4904mr49193584otb.237.1671172676960;
        Thu, 15 Dec 2022 22:37:56 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4PhTxuonWvI42K1r5SXMHOGp2WDwmjdYkpdHeokdA1/uGUJSSB1rwFi/vqD7g24urRxtB6k7iCChL5ArMsm2Q=
X-Received: by 2002:a05:6830:6505:b0:66c:fb5b:4904 with SMTP id
 cm5-20020a056830650500b0066cfb5b4904mr49193583otb.237.1671172676778; Thu, 15
 Dec 2022 22:37:56 -0800 (PST)
MIME-Version: 1.0
References: <20221214163025.103075-1-sgarzare@redhat.com> <20221214163025.103075-2-sgarzare@redhat.com>
In-Reply-To: <20221214163025.103075-2-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 16 Dec 2022 14:37:45 +0800
Message-ID: <CACGkMEtB6uQ_6fKU5F-D0vG+gQz9mMdYWUQwre-yp1sVpGvKPQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/6] vdpa: add bind_mm callback
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, eperezma@redhat.com,
        stefanha@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022 at 12:30 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> This new optional callback is used to bind the device to a specific
> address space so the vDPA framework can use VA when this callback
> is implemented.
>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  include/linux/vdpa.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 6d0f5e4e82c2..34388e21ef3f 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -282,6 +282,12 @@ struct vdpa_map_file {
>   *                             @iova: iova to be unmapped
>   *                             @size: size of the area
>   *                             Returns integer: success (0) or error (< 0)
> + * @bind_mm:                   Bind the device to a specific address space
> + *                             so the vDPA framework can use VA when this
> + *                             callback is implemented. (optional)
> + *                             @vdev: vdpa device
> + *                             @mm: address space to bind

Do we need an unbind or did a NULL mm mean unbind?

> + *                             @owner: process that owns the address space

Any reason we need the task_struct here?

Thanks

>   * @free:                      Free resources that belongs to vDPA (optional)
>   *                             @vdev: vdpa device
>   */
> @@ -341,6 +347,8 @@ struct vdpa_config_ops {
>                          u64 iova, u64 size);
>         int (*set_group_asid)(struct vdpa_device *vdev, unsigned int group,
>                               unsigned int asid);
> +       int (*bind_mm)(struct vdpa_device *vdev, struct mm_struct *mm,
> +                      struct task_struct *owner);
>
>         /* Free device resources */
>         void (*free)(struct vdpa_device *vdev);
> --
> 2.38.1
>


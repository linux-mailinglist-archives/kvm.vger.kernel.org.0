Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040856A7B96
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 08:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjCBHFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 02:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjCBHFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 02:05:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F1C3755E
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 23:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677740673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3I7fEWBSkBRmUqs/CW5rH4YweDzHXspjsekRmlHIHT0=;
        b=TiEZ8c6sRP4k+yW8co5kCGxfSS6fdm/6LMWXz9F6YM6ZVlXeUObwObKKiU1OuL6MwtndBu
        ZJ4le3qRKvxBy4xl8pkEx893KOJKLcrASXaZgZcAnakvxq/jCVXtIuhq0CM4JdBuaOeXCu
        420XztJPsXMrcCCmjDQ5Em/72PfRMpc=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-629-H9Q6JiPUNDOgQuAQCEhHlw-1; Thu, 02 Mar 2023 02:04:32 -0500
X-MC-Unique: H9Q6JiPUNDOgQuAQCEhHlw-1
Received: by mail-oo1-f69.google.com with SMTP id b21-20020a4ad895000000b005258ecbd618so1120142oov.0
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 23:04:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3I7fEWBSkBRmUqs/CW5rH4YweDzHXspjsekRmlHIHT0=;
        b=uU2pIoLGCB60r6jDJiPczvIhB/iiS5slWok9DfDerngKZbfc+++guLXPzvwdTaXOkH
         XTsQR6Yj2UuP/fLukpxEwYK4RIkTce4hb6jj19xsuxmKq4jPG+vA3mW6qJKwm/zA3KrN
         rlwgwKIXzPZ/+sUDhntNIfimZJtWe/3u5NKJ0HE5e/0rmEkrq3L5+IDcG52NUujhxitc
         gWg90A9N0C3mh39ghRo+5OcxlVCLlybKwySVmwG9lNptrGK1RZNUKPhUaA4aONwCCcwk
         I9QuBQBEqt7kMJe/qOFV97yTn5OQ0fpBN4Sf6uRWwZq2SxCpsXgcUvFq/6uV3hordjsi
         Az/w==
X-Gm-Message-State: AO0yUKUYo6tq6urI04BFD4r5e0iQcnbrXpc2Hn4wIbfHFgHeJhiWB9bI
        q66yiF9tKrAyD4BFrYkR3EYhGdV0TaoeNWSRgeUD2+C+K+SCJeA48mHkeoyiN0p+PatisgWQFk9
        Q5w3ya3IkRBCoHxJZM1847Cc7/92dTxQTlg5p
X-Received: by 2002:aca:f14:0:b0:384:63a:305c with SMTP id 20-20020aca0f14000000b00384063a305cmr406842oip.2.1677740666948;
        Wed, 01 Mar 2023 23:04:26 -0800 (PST)
X-Google-Smtp-Source: AK7set/GVk7xB4Dn9iyfjHunjJpsSyZ3FpxKMSMLNZPMiyP0X8CCm77l0gsVjvHVGOmNLjOn/IuoalCbJZmuM7ep4GQ=
X-Received: by 2002:aca:f14:0:b0:384:63a:305c with SMTP id 20-20020aca0f14000000b00384063a305cmr406838oip.2.1677740666774;
 Wed, 01 Mar 2023 23:04:26 -0800 (PST)
MIME-Version: 1.0
References: <20230301163203.29883-1-gautam.dawar@amd.com>
In-Reply-To: <20230301163203.29883-1-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 2 Mar 2023 15:04:15 +0800
Message-ID: <CACGkMEtSe3ho5D3Lsx2gf2xUSJq+fgWcb-zsE6Lw4jJgSuLVjA@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: free iommu domain after last use during cleanup
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-net-drivers@amd.com,
        harpreet.anand@amd.com, tanuj.kamde@amd.com,
        "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
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

On Thu, Mar 2, 2023 at 12:32=E2=80=AFAM Gautam Dawar <gautam.dawar@amd.com>=
 wrote:
>
> Currently vhost_vdpa_cleanup() unmaps the DMA mappings by calling
> `iommu_unmap(v->domain, map->start, map->size);`
> from vhost_vdpa_general_unmap() when the parent vDPA driver doesn't
> provide DMA config operations.
>
> However, the IOMMU domain referred to by `v->domain` is freed in
> vhost_vdpa_free_domain() before vhost_vdpa_cleanup() in
> vhost_vdpa_release() which results in NULL pointer de-reference.
> Accordingly, moving the call to vhost_vdpa_free_domain() in
> vhost_vdpa_cleanup() would makes sense. This will also help
> detaching the dma device in error handling of vhost_vdpa_alloc_domain().
>
> This issue was observed on terminating QEMU with SIGQUIT.
>
> Fixes: 037d4305569a ("vhost-vdpa: call vhost_vdpa_cleanup during the rele=
ase")
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vhost/vdpa.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index ec32f785dfde..b7657984dd8d 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1134,6 +1134,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdp=
a *v)
>
>  err_attach:
>         iommu_domain_free(v->domain);
> +       v->domain =3D NULL;
>         return ret;
>  }
>
> @@ -1178,6 +1179,7 @@ static void vhost_vdpa_cleanup(struct vhost_vdpa *v=
)
>                         vhost_vdpa_remove_as(v, asid);
>         }
>
> +       vhost_vdpa_free_domain(v);
>         vhost_dev_cleanup(&v->vdev);
>         kfree(v->vdev.vqs);
>  }
> @@ -1250,7 +1252,6 @@ static int vhost_vdpa_release(struct inode *inode, =
struct file *filep)
>         vhost_vdpa_clean_irq(v);
>         vhost_vdpa_reset(v);
>         vhost_dev_stop(&v->vdev);
> -       vhost_vdpa_free_domain(v);
>         vhost_vdpa_config_put(v);
>         vhost_vdpa_cleanup(v);
>         mutex_unlock(&d->mutex);
> --
> 2.30.1
>


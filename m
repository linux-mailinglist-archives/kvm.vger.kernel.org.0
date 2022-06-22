Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89755553BF
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 20:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359064AbiFVSx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 14:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377676AbiFVSxq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 14:53:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D9DE1AF2F
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 11:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655924024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NUxlW/j88Epc56MqOmmJqiwjv7RfINKqkJmwCtsv0gI=;
        b=QDaZ5P8DshskWRrjqcaX4KGnJwZLhHCMb8cX+ez7ORlSs1EV8n0GyrHOviAqif6wjOvFe7
        Whr69xdEjgnFq45fe/oF0YuEzE0gPIs0crBwR8B0TNOznhPIVXESEwRq+VWIn2NFd2NCsj
        1AvooyAC46vQgUjiP1XDDEVb0fqXJbA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-B4H59beFMi6IqG1N3aX6qg-1; Wed, 22 Jun 2022 14:53:43 -0400
X-MC-Unique: B4H59beFMi6IqG1N3aX6qg-1
Received: by mail-qv1-f71.google.com with SMTP id s11-20020a0562140cab00b0046e7d2b24b3so17455915qvs.16
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 11:53:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NUxlW/j88Epc56MqOmmJqiwjv7RfINKqkJmwCtsv0gI=;
        b=YwFD4s3tDudqZV4GrOrQDtrzuWLx4BSXXiaQ2VI8py6RLAY5xWxKDkbQcrfsijWczP
         /KjVsiLjSoXuyc0oBKnkScRa8ct7zFtcME9oyvDQ5V3AuRhFPn+K/yNwF+Q0XOf1eoq7
         kUPqDUUQKGcrTw7cDi5pTNrRRw+lok+ttw2aHIKgLJ5gWkHOX4frwKZ0Rsicnplvoi7B
         sey4niV3acsFiT67ie/vPGOyEfR8Js2wloK6RXgxNOw6KKwEgjSrl8ac8pRqnwWgZea7
         dryQc79NIk3kw/Otg8kESV9pxavPzVEkAHPVTYW+07P0ynCyWnXSMUmMvJ5ii7wnzhx6
         zHQQ==
X-Gm-Message-State: AJIora+cdsmLwC0PY43HcYmRNqpMGhV3ZFZTbeR0WsSc/0Ss38mH8hlH
        ofTq6Ghd92zJjlacBk7WIiA8mfCS/IZFvVuXiorqOuMB0dRLTDGsKG2qFBO0dTJek/8nXN0pM35
        3Wtph+iNix8isWQS0DPHcHkzhbgAi
X-Received: by 2002:ac8:598f:0:b0:305:8f8:2069 with SMTP id e15-20020ac8598f000000b0030508f82069mr4463235qte.370.1655924022281;
        Wed, 22 Jun 2022 11:53:42 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vito0RGMmoO0PY0tCMLhEJ3EtZsz9CJl1GiY/Z98Qu2Yy5UsxoSjB8deyHpN0/O8c0wv8vm/DAfiRMBO7J3Y4=
X-Received: by 2002:ac8:598f:0:b0:305:8f8:2069 with SMTP id
 e15-20020ac8598f000000b0030508f82069mr4463221qte.370.1655924022071; Wed, 22
 Jun 2022 11:53:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220622151407.51232-1-sgarzare@redhat.com>
In-Reply-To: <20220622151407.51232-1-sgarzare@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 22 Jun 2022 20:53:06 +0200
Message-ID: <CAJaqyWf6BKK1=KBwHufVY-eLt0JFz9V4-kK-pPLU0tuDc7uGgQ@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: call vhost_vdpa_cleanup during the release
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 5:14 PM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> Before commit 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
> we call vhost_vdpa_iotlb_free() during the release to clean all regions
> mapped in the iotlb.
>
> That commit removed vhost_vdpa_iotlb_free() and added vhost_vdpa_cleanup(=
)
> to do some cleanup, including deleting all mappings, but we forgot to cal=
l
> it in vhost_vdpa_release().
>
> This causes that if an application does not remove all mappings explicitl=
y
> (or it crashes), the mappings remain in the iotlb and subsequent
> applications may fail if they map the same addresses.
>

I tested this behavior even by sending SIGKILL to qemu. The failed map
is reproducible easily before applying this patch and applying it
fixes the issue properly.

> Calling vhost_vdpa_cleanup() also fixes a memory leak since we are not
> freeing `v->vdev.vqs` during the release from the same commit.
>
> Since vhost_vdpa_cleanup() calls vhost_dev_cleanup() we can remove its
> call from vhost_vdpa_release().
>

Tested-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> Fixes: 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
> Cc: gautam.dawar@xilinx.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  drivers/vhost/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 5ad2596c6e8a..23dcbfdfa13b 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1209,7 +1209,7 @@ static int vhost_vdpa_release(struct inode *inode, =
struct file *filep)
>         vhost_dev_stop(&v->vdev);
>         vhost_vdpa_free_domain(v);
>         vhost_vdpa_config_put(v);
> -       vhost_dev_cleanup(&v->vdev);
> +       vhost_vdpa_cleanup(v);
>         mutex_unlock(&d->mutex);
>
>         atomic_dec(&v->opened);
> --
> 2.36.1
>


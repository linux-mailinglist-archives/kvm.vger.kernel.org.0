Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB61A5991F7
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 02:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239648AbiHSAzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 20:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237024AbiHSAzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 20:55:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A2AD7418
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 17:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660870544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nAd/+cM4nZ9kiL+UQq/k1a1/NhUGZtyDcD6og5LvfI0=;
        b=YkXuRSRiDsknmVR7rbbnNyhzTaWJrjCyVKjTR2dk1lZGlXSUUhZRkpMwHCp0wKpI+j4D2r
        1ZmPHCWbObdWLY1AvcjcsY9lRS8pHiuSR5Vlr+ZUMF3Q6SJaFvLT/fz+ScpzKRPmksGurY
        AMAlHIUg5DKmzjM3g3l/o4RzKM73iuE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-625--au6BTTqM1yfof87k6ELgA-1; Thu, 18 Aug 2022 20:55:43 -0400
X-MC-Unique: -au6BTTqM1yfof87k6ELgA-1
Received: by mail-lj1-f197.google.com with SMTP id o19-20020a05651c051300b002605bf9706aso693698ljp.19
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 17:55:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=nAd/+cM4nZ9kiL+UQq/k1a1/NhUGZtyDcD6og5LvfI0=;
        b=eeSWfbmaQ7u85wq7hUgdSoIXzbQLHyb1SAq6toLBR111YEIvZqDMP9cHAv8wuIxNgn
         sHYCZW0IoQ8iKwYn3gGQpZKI2KYJUI6qjC0MU4RkURusL8phqaxt03WUHbLNY09PYGgc
         UzuZSCQwHwBi2vSIIDaLCjY1ZAudiFTI0ylfY3paHHgCUqISaXmnYuwj1DhxPedHHbKx
         QN1r8mUF3gnCCS5yxn2u4rIL+8uwi6QcqPE+o877WdzgteDlAa93kSHSmgtjrZumviyq
         5FoMnQaTp6Q7HJsBvRVbKKO2uPEqjwk46odczQyzIA/omnL8uHCgdquQJTLTZEgQ2UHQ
         W9pQ==
X-Gm-Message-State: ACgBeo0DgcwKVw6AuTXHBbacrthkroE7AT0Pvr6EHtZF+Ke4lTChKLk/
        YULnWLoi8QAX7IJzAOODkG89osLlz42cPiDkqdVteJ2X3jx2Wy+p7FJU4bSJPg1rcSwhCh4Nga8
        SIDh8ne9CgFG/NAhqoNbFe7I3Wc9P
X-Received: by 2002:a2e:a5c3:0:b0:261:ac2d:2820 with SMTP id n3-20020a2ea5c3000000b00261ac2d2820mr1575602ljp.243.1660870541934;
        Thu, 18 Aug 2022 17:55:41 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5yNZcX0ZYYl5wi2Ajj1Zn3BopMcLzRyHDmesw1YcQgFxMbsXTpyZrKS/KZ/n0mefgLfPKqM+qY83EfJJoPgEg=
X-Received: by 2002:a2e:a5c3:0:b0:261:ac2d:2820 with SMTP id
 n3-20020a2ea5c3000000b00261ac2d2820mr1575598ljp.243.1660870541756; Thu, 18
 Aug 2022 17:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220811135353.2549658-1-eperezma@redhat.com> <20220811135353.2549658-2-eperezma@redhat.com>
In-Reply-To: <20220811135353.2549658-2-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 19 Aug 2022 08:55:30 +0800
Message-ID: <CACGkMEvz3kKKhpnn6=P1BiSYgvDaSx_t_QuTAKo6yYC8UH_aAA@mail.gmail.com>
Subject: Re: [PATCH v8 1/3] vdpa: delete unreachable branch on vdpasim_suspend
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, ecree.xilinx@gmail.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Laurent Vivier <lvivier@redhat.com>,
        Martin Porter <martinpo@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Eli Cohen <elic@nvidia.com>, Cindy Lu <lulu@redhat.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Xie Yongji <xieyongji@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 11, 2022 at 9:54 PM Eugenio P=C3=A9rez <eperezma@redhat.com> wr=
ote:
>
> It was a leftover from previous versions.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdp=
a_sim.c
> index 213883487f9b..79a50edf8998 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -509,16 +509,9 @@ static int vdpasim_reset(struct vdpa_device *vdpa)
>  static int vdpasim_suspend(struct vdpa_device *vdpa)
>  {
>         struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> -       int i;
>
>         spin_lock(&vdpasim->lock);
>         vdpasim->running =3D false;
> -       if (vdpasim->running) {
> -               /* Check for missed buffers */
> -               for (i =3D 0; i < vdpasim->dev_attr.nvqs; ++i)
> -                       vdpasim_kick_vq(vdpa, i);
> -
> -       }
>         spin_unlock(&vdpasim->lock);
>
>         return 0;
> --
> 2.31.1
>


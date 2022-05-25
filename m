Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4ED533576
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 04:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243688AbiEYCvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 22:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241178AbiEYCvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 22:51:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3753965AD
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 19:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653447078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Tsl43vKOyakBAOjeNueNb9Uu0rxAb3Y9S+ROwk9uac=;
        b=PxrpwnNMmca9THgj1LIGlBbMa9/SylzGtfPVuxlmItqJIDDGgl3Yy7u/BRdCHFVKKLidyj
        osDzLMBVSyid6HfvIJxKibi2jbBgjcWdOn+I36NoU+/98VrCRz3PHs9DhhkxmdlmhpY4wr
        0wSo8sjhZkIf54XXatQhSDupxxMUeis=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-Xb08w3BWM7yPPpuH3C9U1A-1; Tue, 24 May 2022 22:51:16 -0400
X-MC-Unique: Xb08w3BWM7yPPpuH3C9U1A-1
Received: by mail-lf1-f72.google.com with SMTP id n3-20020ac242c3000000b00473d8af3a0cso10027269lfl.21
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 19:51:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2Tsl43vKOyakBAOjeNueNb9Uu0rxAb3Y9S+ROwk9uac=;
        b=BubtT+IznsnXseDtIg8vDLdzcaHwvRxbs9u2CUReeY3xE3HVNdTdOA8AZlgpAieHFz
         TYs7QXLSe15Ni+66COPoFlf4EEw7m6MD7r0sGol4tfGlUIJeJPbS0/UTdJpEcqHyFPRY
         TWOD49O/bSFwbMBArQ+iP3bCxrArcPkrr9bsDXwikFg8rpnlQUa/1/MY4lNLm2wnALEB
         0GfhuT2quAjyjE2/EqhVAYZpW/kfQol2X4Yxlh1BZlfmm0HlSnEbfOIhfHIhy6Mbpitq
         NTXVrAZ+HdFQ2JraaYi5k0AkSBV4oD3vIFAiLUhCKQUlaL4mYlidsJrT3psoUCIXbCjf
         e5/Q==
X-Gm-Message-State: AOAM532h7dEHixYdxNLKBpStVEO75suah76FJDWg8BRsAKlqzvHvgdA4
        8tipuxMc1bSiGwA318gWMiwpZ9uwj5CtESu+fjiGOKzvqPCqABV5+CBCGkLkUg3csNskd/gQwl/
        BWTvr9bWpWW2kr4B3ICxVbc3hDmZb
X-Received: by 2002:a05:6512:1588:b0:477:a556:4ab2 with SMTP id bp8-20020a056512158800b00477a5564ab2mr21566053lfb.376.1653447075321;
        Tue, 24 May 2022 19:51:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtJSo05GNByny047zFBzRM80HBxjhYV4+wk4PnaZNHQVflRy1NntKSrmKYUijvKrR3IvcwS4VX7V20tGdl8fc=
X-Received: by 2002:a05:6512:1588:b0:477:a556:4ab2 with SMTP id
 bp8-20020a056512158800b00477a5564ab2mr21566038lfb.376.1653447075136; Tue, 24
 May 2022 19:51:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220524170610.2255608-1-eperezma@redhat.com> <20220524170610.2255608-4-eperezma@redhat.com>
In-Reply-To: <20220524170610.2255608-4-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 25 May 2022 10:51:04 +0800
Message-ID: <CACGkMEsZSTgsgYkg5HhpJ62pKFTr6mtiNwYJa8E+r4RMTRuU8A@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] vhost-vdpa: uAPI to stop the device
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, tanuj.kamde@amd.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        habetsm.xilinx@gmail.com, Eli Cohen <elic@nvidia.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Cindy Lu <lulu@redhat.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        ecree.xilinx@gmail.com, "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        Martin Porter <martinpo@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Longpeng <longpeng2@huawei.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 25, 2022 at 1:06 AM Eugenio P=C3=A9rez <eperezma@redhat.com> wr=
ote:
>
> The ioctl adds support for stop the device from userspace.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> ---
>  drivers/vhost/vdpa.c       | 18 ++++++++++++++++++
>  include/uapi/linux/vhost.h |  3 +++
>  2 files changed, 21 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 32713db5831d..a5d33bad92f9 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -478,6 +478,21 @@ static long vhost_vdpa_get_vqs_count(struct vhost_vd=
pa *v, u32 __user *argp)
>         return 0;
>  }
>
> +static long vhost_vdpa_stop(struct vhost_vdpa *v, u32 __user *argp)
> +{
> +       struct vdpa_device *vdpa =3D v->vdpa;
> +       const struct vdpa_config_ops *ops =3D vdpa->config;
> +       int stop;
> +
> +       if (!ops->stop)
> +               return -EOPNOTSUPP;
> +
> +       if (copy_from_user(&stop, argp, sizeof(stop)))
> +               return -EFAULT;
> +
> +       return ops->stop(vdpa, stop);
> +}
> +
>  static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cm=
d,
>                                    void __user *argp)
>  {
> @@ -650,6 +665,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *fi=
lep,
>         case VHOST_VDPA_GET_VQS_COUNT:
>                 r =3D vhost_vdpa_get_vqs_count(v, argp);
>                 break;
> +       case VHOST_STOP:
> +               r =3D vhost_vdpa_stop(v, argp);
> +               break;
>         default:
>                 r =3D vhost_dev_ioctl(&v->vdev, cmd, argp);
>                 if (r =3D=3D -ENOIOCTLCMD)
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index cab645d4a645..e7526968ab0c 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -171,4 +171,7 @@
>  #define VHOST_VDPA_SET_GROUP_ASID      _IOW(VHOST_VIRTIO, 0x7C, \
>                                              struct vhost_vring_state)
>
> +/* Stop or resume a device so it does not process virtqueue requests any=
more */
> +#define VHOST_STOP                     _IOW(VHOST_VIRTIO, 0x7D, int)
> +

Unless we know it's a vhost general uAPI, let's use VHOST_VDPA_STOP here.

Thanks

>  #endif
> --
> 2.27.0
>


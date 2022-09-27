Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD93F5EB940
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 06:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiI0Eg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 00:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiI0Eg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 00:36:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2354F91D23
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 21:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664253385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cevU8AGgg8wT6F+JiTBLVu2Cozz4uni7iYpojx9WbgM=;
        b=cr1D1ZPv+WQxYMlyXbpSA0TVuag3BV1uocqdhgq30JTxOSIzqcYQdkI1S07z1ur/E4qCxu
        it96sm4OMhVYZ61bGZFRb7xhy68sYgn5uZTv4JBsIjg/GCz1B6a9nMAKIADTBtl0xd0ggV
        RUNzLHkfLNNrzliBTdM8oqQMHqEzIY0=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-624-qlxLS3IBPvGC_UAXHciW8g-1; Tue, 27 Sep 2022 00:36:21 -0400
X-MC-Unique: qlxLS3IBPvGC_UAXHciW8g-1
Received: by mail-ot1-f72.google.com with SMTP id r6-20020a05683001c600b00655af6217deso4224111ota.10
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 21:36:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=cevU8AGgg8wT6F+JiTBLVu2Cozz4uni7iYpojx9WbgM=;
        b=tF2VuUpElLlqKFOiKl/yfzwth+2ctfXXNkdMKFmUDduvHq+F8kRSgYWU+LehKSjpfU
         VAYzKUCz7bCh3smOcwREidLWwKhCsMZZzyJeLy64G/zdYZ+GqloG/DgcxDUejdwfrbzU
         PDPUuw+wgLa6Zp7V1VL+QOoXqrOULuyYnw7n3NG4XTD59u7BfpdKOZpdf3Xv1by53vpv
         tkQqErSFlqq4y6HdgD/04Z/rRAJsFKYx++qnrUEipy/2R3wgAtbE5gmPMY3nVrfbR1Zt
         M7Dwj4OHrHVrTnPYXqJNBQ+11gTGEw7GPePTBpKbLm3p0irub5VnA6GrdYEolzfkxPvr
         wUCA==
X-Gm-Message-State: ACrzQf2ieOCaJrGJWFuoMAGxx5NRtGrBUcjboNbe89dslxeFQuhwh3sO
        oLurV6aFft9/8A3r8ViPM/ADmN8ObZ6aJlX6zeRokAkFFqGYHMazEL9VrQ1do3Bgw/eov0t4GpB
        +l+srxCtRxGpJgnHClTnccJIeiulO
X-Received: by 2002:a05:6808:1304:b0:350:649b:f8a1 with SMTP id y4-20020a056808130400b00350649bf8a1mr925950oiv.280.1664253380019;
        Mon, 26 Sep 2022 21:36:20 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6eScg1+ZuTPxQSBddzJb4AcPvIc4CSkxqEX+Sr+/R6Jx4TE1Ey4SK8L/pA9rZ+wxr44DnmzkArFrc2KBjWw74=
X-Received: by 2002:a05:6808:1304:b0:350:649b:f8a1 with SMTP id
 y4-20020a056808130400b00350649bf8a1mr925940oiv.280.1664253379747; Mon, 26 Sep
 2022 21:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220927030117.5635-1-lingshan.zhu@intel.com> <20220927030117.5635-2-lingshan.zhu@intel.com>
In-Reply-To: <20220927030117.5635-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 27 Sep 2022 12:36:08 +0800
Message-ID: <CACGkMEtDmG=YvcVcvO1c371sk5wvz+UO1i4keZXA2f4PrXzXBg@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND 1/6] vDPA: allow userspace to query features of
 a vDPA device
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 27, 2022 at 11:09 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> This commit adds a new vDPA netlink attribution
> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
> features of vDPA devices through this new attr.
>
> This commit invokes vdpa_config_ops.get_config()
> rather than vdpa_get_config_unlocked() to read
> the device config spcae, so no races in
> vdpa_set_features_unlocked()
>
> Userspace tool iproute2 example:
> $ vdpa dev config show vdpa0
> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 4 mtu 1500
>   negotiated_features MRG_RXBUF CTRL_VQ MQ VERSION_1 ACCESS_PLATFORM
>   dev_features MTU MAC MRG_RXBUF CTRL_VQ MQ ANY_LAYOUT VERSION_1 ACCESS_PLATFORM
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/vdpa.c       | 17 ++++++++++++-----
>  include/uapi/linux/vdpa.h |  4 ++++
>  2 files changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index c06c02704461..2035700d6fc8 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -491,6 +491,7 @@ static int vdpa_mgmtdev_fill(const struct vdpa_mgmt_dev *mdev, struct sk_buff *m
>                 err = -EMSGSIZE;
>                 goto msg_err;
>         }
> +

Nit: Unnecessary changes.

>         if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_SUPPORTED_FEATURES,
>                               mdev->supported_features, VDPA_ATTR_PAD)) {
>                 err = -EMSGSIZE;
> @@ -815,10 +816,10 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>  static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
>  {
>         struct virtio_net_config config = {};
> -       u64 features;
> +       u64 features_device, features_driver;
>         u16 val_u16;
>
> -       vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> +       vdev->config->get_config(vdev, 0, &config, sizeof(config));
>
>         if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
>                     config.mac))
> @@ -832,12 +833,18 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>                 return -EMSGSIZE;
>
> -       features = vdev->config->get_driver_features(vdev);
> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
> +       features_driver = vdev->config->get_driver_features(vdev);
> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
> +                             VDPA_ATTR_PAD))
> +               return -EMSGSIZE;

It looks to me that those parts were removed in patch 2. I wonder if
it's better to reorder the patch to let patch 2 come first?

Thanks

> +
> +       features_device = vdev->config->get_device_features(vdev);
> +
> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
>                               VDPA_ATTR_PAD))
>                 return -EMSGSIZE;
>
> -       return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
> +       return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
>  }
>
>  static int
> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
> index 25c55cab3d7c..07474183fdb3 100644
> --- a/include/uapi/linux/vdpa.h
> +++ b/include/uapi/linux/vdpa.h
> @@ -46,12 +46,16 @@ enum vdpa_attr {
>
>         VDPA_ATTR_DEV_NEGOTIATED_FEATURES,      /* u64 */
>         VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
> +       /* virtio features that are supported by the vDPA management device */
>         VDPA_ATTR_DEV_SUPPORTED_FEATURES,       /* u64 */
>
>         VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>         VDPA_ATTR_DEV_VENDOR_ATTR_NAME,         /* string */
>         VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
>
> +       /* virtio features that are supported by the vDPA device */
> +       VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,  /* u64 */
> +
>         /* new attributes must be added above here */
>         VDPA_ATTR_MAX,
>  };
> --
> 2.31.1
>


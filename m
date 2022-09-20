Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656205BDA03
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 04:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiITCSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 22:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiITCSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 22:18:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08B02A277
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 19:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663640289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FEUHTADoR8KlD4DD+fhNieYTMG22Ao1FKlWpqZYIFa0=;
        b=GpcHLn1lkf9sDD7luF7/6UuKfCwYukD/iYIeEhhVxVq/TP7bixzmWg0mYCV/UkHstTkZp/
        076B2TyWPIKJ6LbJPcsd8rSaw4XP41NbdRmDD7m618hu/mRQ5Ig/MLD9O4EXGXSTZa7O18
        2iog7rasSXNZ7y7wovZdf0wMksYHESQ=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-435-jYkMiWmHOaO8F7L2GFORtw-1; Mon, 19 Sep 2022 22:18:07 -0400
X-MC-Unique: jYkMiWmHOaO8F7L2GFORtw-1
Received: by mail-vs1-f70.google.com with SMTP id p4-20020a05610223e400b00397f8045a3cso315939vsc.15
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 19:18:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=FEUHTADoR8KlD4DD+fhNieYTMG22Ao1FKlWpqZYIFa0=;
        b=Eu0HStKbtdyQ+ITUiOt3GjTTxGRqxnSNUXaj87o/YuG3yKpnjJu5VwY7uu/Wzo8+0x
         aYoZNIm/+WIZYuB+3cl33PXN8drjRYOEBlZU1rGcaUuW/Ztg8DLgRVWNq+mmqOT4059Y
         lktFfSIT4B3WNdDAPICsjJKs1Y+cK/dswr+1x/DvfdMxKOe6npLktftruKJLA5L1Mntt
         lMBAWGCm0tuIp/CHGpN+7/qy81diczY0XrCi42zVpUaKvDOMcVwr4/W+x1Uf3QYJmGBG
         bZQgGza6xaEKTDI7/2RuFw/QEBIQ8I0U//5Za/ej6Jp5qIMC1wFBdUCVbZQqtRz7luAY
         XdYA==
X-Gm-Message-State: ACrzQf0wasRxusx8iIJstPHj5FLhMB9Ejla9PLEz9QJfpjvBuS8i9BLR
        k2x33ndxX31RnXRFV0SqQygE8pz/fNFEcH9mz5AuOADHxkOTbqsbHCfbxuiVfe/QGdWno9fDjO6
        A6e5TclRCF4Ww4ookkBHUT4Pb+YWc
X-Received: by 2002:a05:6102:1341:b0:398:889e:7f28 with SMTP id j1-20020a056102134100b00398889e7f28mr7927483vsl.21.1663640286468;
        Mon, 19 Sep 2022 19:18:06 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4aFZxat3rBDo+ydZBqX3GNyuERyeXan0fOqLbRyeIGO/Vie0sDsAXF13Gh5Xuw8CK/4MrpmzAl1kTy+h7rnkM=
X-Received: by 2002:a05:6102:1341:b0:398:889e:7f28 with SMTP id
 j1-20020a056102134100b00398889e7f28mr7927479vsl.21.1663640286262; Mon, 19 Sep
 2022 19:18:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220909085712.46006-1-lingshan.zhu@intel.com> <20220909085712.46006-5-lingshan.zhu@intel.com>
In-Reply-To: <20220909085712.46006-5-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 20 Sep 2022 10:17:55 +0800
Message-ID: <CACGkMEtqi4AZ8ZOv=U9TjswOwVpr32mbi2S7Z6DcayaUrfUeyg@mail.gmail.com>
Subject: Re: [PATCH 4/4] vDPA: Conditionally read MTU and MAC in dev cfg space
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 9, 2022 at 5:05 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> The spec says:
> mtu only exists if VIRTIO_NET_F_MTU is set
> The mac address field always exists (though
> is only valid if VIRTIO_NET_F_MAC is set)
>
> So vdpa_dev_net_config_fill() should read MTU and MAC
> conditionally on the feature bits.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>  drivers/vdpa/vdpa.c | 37 +++++++++++++++++++++++++++++--------
>  1 file changed, 29 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index f8ff61232421..b332388d3375 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -815,6 +815,29 @@ static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
>         return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
>  }
>
> +static int vdpa_dev_net_mtu_config_fill(struct sk_buff *msg, u64 features,
> +                                       const struct virtio_net_config *config)
> +{
> +       u16 val_u16;
> +
> +       if ((features & BIT_ULL(VIRTIO_NET_F_MTU)) == 0)
> +               return 0;
> +
> +       val_u16 = __virtio16_to_cpu(true, config->mtu);
> +
> +       return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16);
> +}
> +
> +static int vdpa_dev_net_mac_config_fill(struct sk_buff *msg, u64 features,
> +                                       const struct virtio_net_config *config)
> +{
> +       if ((features & BIT_ULL(VIRTIO_NET_F_MAC)) == 0)
> +               return 0;
> +
> +       return  nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR,
> +                       sizeof(config->mac), config->mac);
> +}
> +
>  static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
>  {
>         struct virtio_net_config config = {};
> @@ -824,18 +847,10 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>
>         vdev->config->get_config(vdev, 0, &config, sizeof(config));
>
> -       if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
> -                   config.mac))
> -               return -EMSGSIZE;
> -
>         val_u16 = __virtio16_to_cpu(true, config.status);
>         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>                 return -EMSGSIZE;
>
> -       val_u16 = __virtio16_to_cpu(true, config.mtu);
> -       if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> -               return -EMSGSIZE;
> -
>         /* only read driver features after the feature negotiation is done */
>         status = vdev->config->get_status(vdev);
>         if (status & VIRTIO_CONFIG_S_FEATURES_OK) {
> @@ -852,6 +867,12 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>                               VDPA_ATTR_PAD))
>                 return -EMSGSIZE;
>
> +       if (vdpa_dev_net_mtu_config_fill(msg, features_device, &config))
> +               return -EMSGSIZE;
> +
> +       if (vdpa_dev_net_mac_config_fill(msg, features_device, &config))
> +               return -EMSGSIZE;
> +
>         return vdpa_dev_net_mq_config_fill(msg, features_device, &config);
>  }
>
> --
> 2.31.1
>


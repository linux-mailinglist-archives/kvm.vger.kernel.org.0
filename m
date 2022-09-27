Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB2A5EB943
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 06:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiI0Eht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 00:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiI0Ehr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 00:37:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED22DACA20
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 21:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664253466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sofFyJdbvbK1Y4hSW2SV/YKhYdmhwl/R+C1JaEp10aY=;
        b=F0CbopfaNczHbG/kH9uLL/kl8Dzr4+HewNn3dTkDxKySnXDHoDmGlTvHsOsBJEaLmIK7WD
        0dh5vR/Uwmr/jm4rm7GJi6DiqTU1e4OEh68eNIMl+Ru25qIGy6M0RSkJi8JaDwRnsdj5Q/
        mniXiQzGuJXK9T4H54RJZ7LX+LKZLDc=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-332--5jVU9QiOE-gNKV5yiVpWw-1; Tue, 27 Sep 2022 00:37:44 -0400
X-MC-Unique: -5jVU9QiOE-gNKV5yiVpWw-1
Received: by mail-oi1-f197.google.com with SMTP id z13-20020aca670d000000b00351430925e4so1714286oix.22
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 21:37:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=sofFyJdbvbK1Y4hSW2SV/YKhYdmhwl/R+C1JaEp10aY=;
        b=q9TiwJ6UZdTbOBL5lpL93q0gi/Dh1yz5Gcr3iDf+muFo1v8cRGw/EJ+JKOhBINBBIC
         rBY74qNQ6pfhMdz+AGmXvD1qjSJX/TQ4NDYp5oAbB5WbcoZeJDDJYA9eCGwf0Kz0XDFY
         mjVOXBNDrTGIvic+nAdrtGFZ5ip+1LYQL6oA+HNI85pMb/FZ0x847ThnlEsq2Tc/5n5j
         0n3Fgx4jelZ+urAzB0HRyWYpFvKqCzS/ar9oNEqCr7MinJfO+4yhtfS6UXBFQJTBS2mh
         70xHblcRlRLnfCYpoNRyEbUsbQHDMU3V4norV2mjsJ9DY0YaoumXA/mg3TkANwt+14nF
         /s4A==
X-Gm-Message-State: ACrzQf2y4ku5PVQud/Aq/riSOdsRyRrwKaJ/USvjhU3f6TyYhW0TRiVx
        KNuJ0bM4cuWUCgtECjFaiu4cc8rqn6lnv7pTJmid1jr+OKvv1xp4ipfndm4z+L7Y0f74boDdrl9
        Mfbw9xX+t/8UNtQVGduIZYAEK+WE9
X-Received: by 2002:a05:6808:1b22:b0:350:c0f6:70ff with SMTP id bx34-20020a0568081b2200b00350c0f670ffmr947205oib.35.1664253463347;
        Mon, 26 Sep 2022 21:37:43 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5NQ5K7xZtBDHnh4CyOgOgqK3Ra+fOLEtOeFx402OqNNCn9xWF7xqyeiAntmL+PTACBi+4aqvMfh1lSBTp+AsI=
X-Received: by 2002:a05:6808:1b22:b0:350:c0f6:70ff with SMTP id
 bx34-20020a0568081b2200b00350c0f670ffmr947197oib.35.1664253463161; Mon, 26
 Sep 2022 21:37:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220927030117.5635-1-lingshan.zhu@intel.com> <20220927030117.5635-3-lingshan.zhu@intel.com>
In-Reply-To: <20220927030117.5635-3-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 27 Sep 2022 12:37:32 +0800
Message-ID: <CACGkMEsioquc=hVe0D87UjZkaZ1m3B-g1hXAAyq6bHD=Fc0uFQ@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND 2/6] vDPA: only report driver features if
 FEATURES_OK is set
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 27, 2022 at 11:09 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> This commit reports driver features to user space
> only after FEATURES_OK is features negotiation is done.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/vdpa.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 2035700d6fc8..e7765953307f 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -816,7 +816,7 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>  static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
>  {
>         struct virtio_net_config config = {};
> -       u64 features_device, features_driver;
> +       u64 features_device;
>         u16 val_u16;
>
>         vdev->config->get_config(vdev, 0, &config, sizeof(config));
> @@ -833,11 +833,6 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>                 return -EMSGSIZE;
>
> -       features_driver = vdev->config->get_driver_features(vdev);
> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
> -                             VDPA_ATTR_PAD))
> -               return -EMSGSIZE;
> -
>         features_device = vdev->config->get_device_features(vdev);
>
>         if (nla_put_u64_64bit(msg, VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
> @@ -851,6 +846,8 @@ static int
>  vdpa_dev_config_fill(struct vdpa_device *vdev, struct sk_buff *msg, u32 portid, u32 seq,
>                      int flags, struct netlink_ext_ack *extack)
>  {
> +       u64 features_driver;
> +       u8 status = 0;
>         u32 device_id;
>         void *hdr;
>         int err;
> @@ -874,6 +871,19 @@ vdpa_dev_config_fill(struct vdpa_device *vdev, struct sk_buff *msg, u32 portid,
>                 goto msg_err;
>         }
>
> +       /* only read driver features after the feature negotiation is done */
> +       if (vdev->config->get_status)
> +               status = vdev->config->get_status(vdev);

get_status is mandatory, so I think we can remove this check.

Or if you want a strict check on the config operations, we need to do
that in __vdpa_alloc_device().

Thanks

> +
> +       if (status & VIRTIO_CONFIG_S_FEATURES_OK) {
> +               features_driver = vdev->config->get_driver_features(vdev);
> +               if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
> +                                     VDPA_ATTR_PAD)) {
> +                       err = -EMSGSIZE;
> +                       goto msg_err;
> +               }
> +       }
> +
>         switch (device_id) {
>         case VIRTIO_ID_NET:
>                 err = vdpa_dev_net_config_fill(vdev, msg);
> --
> 2.31.1
>


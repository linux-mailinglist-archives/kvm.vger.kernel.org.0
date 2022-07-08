Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2032056B88F
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 13:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbiGHLbA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 07:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237993AbiGHLa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 07:30:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19F3811835
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 04:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657279857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UAhm09EfssnFXCcdbsvbfvfsk3WrYS8DdytneLUevKI=;
        b=GT6aS34skfT8F5lPPnSnLGtlOYLicOddG/IZJTADFwrG+qUHbLMDQmw4AI9cn6B/HGJcEf
        yv9IZYeHPYLDsLYD80wnAhE+BgoQRVV5ZmlZIubIdjyayBx7qwF3Rel0i7yt6QTGOaV1WK
        ZfNsZvo6fLtIJOIWjQyR4ibq4MA8blM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-h4IxQX8nP96Mc6cKs8MDsw-1; Fri, 08 Jul 2022 07:30:56 -0400
X-MC-Unique: h4IxQX8nP96Mc6cKs8MDsw-1
Received: by mail-qt1-f198.google.com with SMTP id a7-20020ac84347000000b00319bb5d130eso18253893qtn.14
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 04:30:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UAhm09EfssnFXCcdbsvbfvfsk3WrYS8DdytneLUevKI=;
        b=iEfPKgd8iwAWuQ7PN5Uq3rKlRCZcnC+tV/ebuJ9NXwXw7DPhCKn17guA21BnZwuJHS
         6SylhY1u6mh3vCqNqFoXvIFE3IqNnjcNfgriH3/HIzBcFALYxKUl7PRavdrVbjdFLkoU
         BS2/r9v3zt4RFbP2urmjw75j7LzQ5qukmlyw2lY7X/7JOko4aBKpjxdb1vmWMqpN29nB
         NSHIPfwjai7PkWCv2J1HyV1Y+iaw5HxZOhyYrdlolPWflQrqmr4hEKJYLLOVxKHGohX+
         hrvloKNKdMHem8WahqKo9EWlO0ly1jS+XFQqwcHkdx8+vBlpN71edmNGvVc7J2nXgfjM
         z+sg==
X-Gm-Message-State: AJIora9l+aPoJba72eV7kEY1a8OZ4K0KD2wpw4B/CeYa7luN8P2KERAM
        IGR7wjOwXw8uEKdWzO0OLDnOyNXU0K3N4YXgmv79fmtJ541UCNHAiHNdBnYsSt5W5tWz02h2zIR
        365Z+lvFhWaKR9Xu3d1fWYZsmuwqE
X-Received: by 2002:a05:620a:1a28:b0:6b1:4d4d:c7c3 with SMTP id bk40-20020a05620a1a2800b006b14d4dc7c3mr1814615qkb.522.1657279855645;
        Fri, 08 Jul 2022 04:30:55 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v8+NK0ig5X6Bjadt6KK8FEJO3wlTzXuPkDiWOHFPeuAEaLG9/Cabys/udfnjWvsySslvzBdf92a3lY5t1vcR0=
X-Received: by 2002:a05:620a:1a28:b0:6b1:4d4d:c7c3 with SMTP id
 bk40-20020a05620a1a2800b006b14d4dc7c3mr1814565qkb.522.1657279855371; Fri, 08
 Jul 2022 04:30:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220623160738.632852-1-eperezma@redhat.com> <20220623160738.632852-2-eperezma@redhat.com>
 <CACGkMEv+yFLCzo-K7eSaVPJqLCa5SxfVCmB=piQ3+6R3=oDz-w@mail.gmail.com>
In-Reply-To: <CACGkMEv+yFLCzo-K7eSaVPJqLCa5SxfVCmB=piQ3+6R3=oDz-w@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 8 Jul 2022 13:30:19 +0200
Message-ID: <CAJaqyWcsesMV5DSs7sCrsJmZX=QED7p7UXa_7H=1UHfQTnKS6w@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] vdpa: Add suspend operation
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Cindy Lu <lulu@redhat.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        habetsm.xilinx@gmail.com, "Dawar, Gautam" <gautam.dawar@amd.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Martin Porter <martinpo@xilinx.com>,
        Eli Cohen <elic@nvidia.com>, ecree.xilinx@gmail.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022 at 6:10 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Fri, Jun 24, 2022 at 12:07 AM Eugenio P=C3=A9rez <eperezma@redhat.com>=
 wrote:
> >
> > This operation is optional: It it's not implemented, backend feature bi=
t
> > will not be exposed.
>
> A question, do we allow suspending a device without DRIVER_OK?
>

That should be invalid. In particular, vdpa_sim will resume in that
case, but I guess it would depend on the device.

Do you think it should be controlled in the vdpa frontend code?

Thanks!

> Thanks
>
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >  include/linux/vdpa.h | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> > index 7b4a13d3bd91..d282f464d2f1 100644
> > --- a/include/linux/vdpa.h
> > +++ b/include/linux/vdpa.h
> > @@ -218,6 +218,9 @@ struct vdpa_map_file {
> >   * @reset:                     Reset device
> >   *                             @vdev: vdpa device
> >   *                             Returns integer: success (0) or error (=
< 0)
> > + * @suspend:                   Suspend or resume the device (optional)
> > + *                             @vdev: vdpa device
> > + *                             Returns integer: success (0) or error (=
< 0)
> >   * @get_config_size:           Get the size of the configuration space=
 includes
> >   *                             fields that are conditional on feature =
bits.
> >   *                             @vdev: vdpa device
> > @@ -319,6 +322,7 @@ struct vdpa_config_ops {
> >         u8 (*get_status)(struct vdpa_device *vdev);
> >         void (*set_status)(struct vdpa_device *vdev, u8 status);
> >         int (*reset)(struct vdpa_device *vdev);
> > +       int (*suspend)(struct vdpa_device *vdev);
> >         size_t (*get_config_size)(struct vdpa_device *vdev);
> >         void (*get_config)(struct vdpa_device *vdev, unsigned int offse=
t,
> >                            void *buf, unsigned int len);
> > --
> > 2.31.1
> >
>


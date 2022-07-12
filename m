Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7CC5713EB
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 10:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbiGLIEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 04:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiGLIEr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 04:04:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9E06DF1C
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 01:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657613084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zk3S2xAdR/7hGTN3JMUGrzoWncg4Rn0Aa+mjreKRU3I=;
        b=GOnGazXFNv5PYDYjT5qn82BELBYNxZbVnTX3qIfldpLEVcUxeH61KwEITRuAuDvFmEJnwE
        vfFnqgDKMniiwyqm/wqhsSSi2KspnGYJiiG6xW7F05NsZluDX8s517jdFuP5AcO3WUqnUD
        0E53wAvfZZrVT5gYlZD/nkvJjmiOq30=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-S5Xxmon8Pm-xQtCa2bV1fg-1; Tue, 12 Jul 2022 04:04:36 -0400
X-MC-Unique: S5Xxmon8Pm-xQtCa2bV1fg-1
Received: by mail-lj1-f198.google.com with SMTP id bj24-20020a2eaa98000000b0025d50c169ccso1252754ljb.9
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 01:04:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Zk3S2xAdR/7hGTN3JMUGrzoWncg4Rn0Aa+mjreKRU3I=;
        b=P6mJ6rZiUK94x8xm2kfN98Qt2GYQx2zLY2UTaPkrN1lFUx2349YxBunqNaxsFlf1tL
         S229jEwNyYev9bzbMelzaP1dheUOMxrcfwUrs3dI5aGiw63rijo1QXuvt/I57GmitW6P
         NB7V5gjvf8ubvCPB4Ambf6vyavnzPnVnIDyhDQlfA7L56P8Kqv9n+szEIVGTu67swYqw
         4pkGsFHlqEXTGgVnuYHoEtNlY0VqBRkBeCtGTUZKm+tutFKbqBMx8SGCMYW+7blZX+IS
         rfiqjMj9H1L3tFT60nvcboR+/vWGRNBK6TSx4uHClT3tg7DTTSIfE8GSyeuOt/Mpt28+
         uueA==
X-Gm-Message-State: AJIora9t21EAF7HypZfGZjXvyp5GM+sSfajso6N5QO6u12TP33M1P4fO
        Wo6xN8hkZt387QZAujhVTu2ym8E+XWsotT+QXy+FDd68HO5oVAbbmZw9u4TuvLzZ2rtU890JJJR
        PvGQOTJCtm0am6igIwQrPURaK8GmV
X-Received: by 2002:a05:6512:3b8e:b0:481:1a75:452 with SMTP id g14-20020a0565123b8e00b004811a750452mr15293730lfv.238.1657613075130;
        Tue, 12 Jul 2022 01:04:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vFL+N9RzhXFr/ks5hqi5WjMGbUNrOhsaPrmrfRg/JxZpXDwQSu5M2XKsRZPR3L6Fkftxrqt8icOOXsoZFhCZE=
X-Received: by 2002:a05:6512:3b8e:b0:481:1a75:452 with SMTP id
 g14-20020a0565123b8e00b004811a750452mr15293702lfv.238.1657613074923; Tue, 12
 Jul 2022 01:04:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220623160738.632852-1-eperezma@redhat.com> <20220623160738.632852-2-eperezma@redhat.com>
 <CACGkMEv+yFLCzo-K7eSaVPJqLCa5SxfVCmB=piQ3+6R3=oDz-w@mail.gmail.com> <CAJaqyWcsesMV5DSs7sCrsJmZX=QED7p7UXa_7H=1UHfQTnKS6w@mail.gmail.com>
In-Reply-To: <CAJaqyWcsesMV5DSs7sCrsJmZX=QED7p7UXa_7H=1UHfQTnKS6w@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 12 Jul 2022 16:04:23 +0800
Message-ID: <CACGkMEsr=2LjU1-UDV1SF9vJPty2003YKORHZMSr1W-p9eNr+A@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] vdpa: Add suspend operation
To:     Eugenio Perez Martin <eperezma@redhat.com>
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
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 8, 2022 at 7:31 PM Eugenio Perez Martin <eperezma@redhat.com> w=
rote:
>
> On Wed, Jun 29, 2022 at 6:10 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Fri, Jun 24, 2022 at 12:07 AM Eugenio P=C3=A9rez <eperezma@redhat.co=
m> wrote:
> > >
> > > This operation is optional: It it's not implemented, backend feature =
bit
> > > will not be exposed.
> >
> > A question, do we allow suspending a device without DRIVER_OK?
> >
>
> That should be invalid. In particular, vdpa_sim will resume in that
> case, but I guess it would depend on the device.

Yes, and that will match our virtio spec patch (STOP bit).

>
> Do you think it should be controlled in the vdpa frontend code?

The vdpa bus should validate this at least.

Thanks

>
> Thanks!
>
> > Thanks
> >
> > >
> > > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > ---
> > >  include/linux/vdpa.h | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> > > index 7b4a13d3bd91..d282f464d2f1 100644
> > > --- a/include/linux/vdpa.h
> > > +++ b/include/linux/vdpa.h
> > > @@ -218,6 +218,9 @@ struct vdpa_map_file {
> > >   * @reset:                     Reset device
> > >   *                             @vdev: vdpa device
> > >   *                             Returns integer: success (0) or error=
 (< 0)
> > > + * @suspend:                   Suspend or resume the device (optiona=
l)
> > > + *                             @vdev: vdpa device
> > > + *                             Returns integer: success (0) or error=
 (< 0)
> > >   * @get_config_size:           Get the size of the configuration spa=
ce includes
> > >   *                             fields that are conditional on featur=
e bits.
> > >   *                             @vdev: vdpa device
> > > @@ -319,6 +322,7 @@ struct vdpa_config_ops {
> > >         u8 (*get_status)(struct vdpa_device *vdev);
> > >         void (*set_status)(struct vdpa_device *vdev, u8 status);
> > >         int (*reset)(struct vdpa_device *vdev);
> > > +       int (*suspend)(struct vdpa_device *vdev);
> > >         size_t (*get_config_size)(struct vdpa_device *vdev);
> > >         void (*get_config)(struct vdpa_device *vdev, unsigned int off=
set,
> > >                            void *buf, unsigned int len);
> > > --
> > > 2.31.1
> > >
> >
>


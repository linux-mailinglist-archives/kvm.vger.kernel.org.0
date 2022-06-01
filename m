Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F2553A143
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 11:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351491AbiFAJuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 05:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351527AbiFAJuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 05:50:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A880325597
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 02:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654077008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7yKbsAaRBxnFfxnHQsz2r5KMqANCbznDVvZ/VbavXuc=;
        b=AzbJ6r7pmEgyNENfqGkSh83YUq3/j+X/kK1OIEOQjFFtPsMLD40rVLh8pWunP6S/p/GDda
        NioX+dWMZ97lWwHQgE7O7YuPNtmtbvlnVoqq+ll5nLJG+mehdpWJokbWEszOzLZD/FWTkn
        1TBmzVqiA5Hk8fItlxjhiUG9j+OmaTM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-14BlX2lIMRCByRf9Gr4u8w-1; Wed, 01 Jun 2022 05:50:07 -0400
X-MC-Unique: 14BlX2lIMRCByRf9Gr4u8w-1
Received: by mail-qt1-f200.google.com with SMTP id c1-20020ac81101000000b002f9219952f0so875880qtj.15
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 02:50:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7yKbsAaRBxnFfxnHQsz2r5KMqANCbznDVvZ/VbavXuc=;
        b=CZGubifD6ASKFNCys0Yk2iJqOajAazspHF7VSMASldNI7G7pZW2cwpK+HzAED40Svs
         UUr1MtakSynmKhszv0QxubhdayB1fn5R4hog1aT0fuNNFfBBHGqHKZILsvVSU8X8Txx0
         hW+DsVu7xfWSxF949IzBprklOH+gCbrKsL7p3KcZ5ns3YzpHH6Tl0PY7bzZG+rvvTjD3
         GGtG0g1GQ62nqsX+6ZWxM/cZhVnLQMdJGhgKF5x3nfnv4Mbzole/jc1Drs1Ak7wYqS58
         v/yt5rgWMapViwYJelu9odfKV3ybcZF/G9qBySnYV2t38BIxPJ+qgOmtLW7uj+EgJnNr
         EK0w==
X-Gm-Message-State: AOAM532/0DLW64vQdrhjxIc+GRjw6VvOhINoAteQ2FgorbFlEbPo2tb7
        ppO/LKhcn732NLBFeNE3A6YfGwhpGi5n1dS1DU8YClXuz6ip37FwRHlY6/zOAxyaOfBatDUCI4r
        4iLCZPsqsf8uTkK8/QClZz+p21TBM
X-Received: by 2002:a05:620a:1a07:b0:6a5:dac2:6703 with SMTP id bk7-20020a05620a1a0700b006a5dac26703mr17515266qkb.522.1654077007235;
        Wed, 01 Jun 2022 02:50:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRCANxHMBICIyF7T/TATpYKUuPZE9sRo5w9g0aMKwREiJSGD74h1xPhQUOZXGeYlnmjSX1t48pqjcL8k7TFnM=
X-Received: by 2002:a05:620a:1a07:b0:6a5:dac2:6703 with SMTP id
 bk7-20020a05620a1a0700b006a5dac26703mr17515258qkb.522.1654077006995; Wed, 01
 Jun 2022 02:50:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220526124338.36247-1-eperezma@redhat.com> <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220527065442-mutt-send-email-mst@kernel.org> <CACGkMEubfv_OJOsJ_ROgei41Qx4mPO0Xz8rMVnO8aPFiEqr8rA@mail.gmail.com>
 <PH0PR12MB5481695930E7548BAAF1B0D9DCDC9@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB5481695930E7548BAAF1B0D9DCDC9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 1 Jun 2022 11:49:30 +0200
Message-ID: <CAJaqyWe7YFM0anKLJvvRja-EJW5bwmb1gMGXnC62LVMKrSn3sw@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Implement vdpasim stop operation
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "tanuj.kamde@amd.com" <tanuj.kamde@amd.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 31, 2022 at 10:19 PM Parav Pandit <parav@nvidia.com> wrote:
>
>
> > From: Jason Wang <jasowang@redhat.com>
> > Sent: Sunday, May 29, 2022 11:39 PM
> >
> > On Fri, May 27, 2022 at 6:56 PM Michael S. Tsirkin <mst@redhat.com> wro=
te:
> > >
> > > On Thu, May 26, 2022 at 12:54:32PM +0000, Parav Pandit wrote:
> > > >
> > > >
> > > > > From: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > > > Sent: Thursday, May 26, 2022 8:44 AM
> > > >
> > > > > Implement stop operation for vdpa_sim devices, so vhost-vdpa will
> > > > > offer
> > > > >
> > > > > that backend feature and userspace can effectively stop the devic=
e.
> > > > >
> > > > >
> > > > >
> > > > > This is a must before get virtqueue indexes (base) for live
> > > > > migration,
> > > > >
> > > > > since the device could modify them after userland gets them. Ther=
e
> > > > > are
> > > > >
> > > > > individual ways to perform that action for some devices
> > > > >
> > > > > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but
> > there
> > > > > was no
> > > > >
> > > > > way to perform it for any vhost device (and, in particular, vhost=
-vdpa).
> > > > >
> > > > >
> > > > >
> > > > > After the return of ioctl with stop !=3D 0, the device MUST finis=
h
> > > > > any
> > > > >
> > > > > pending operations like in flight requests. It must also preserve
> > > > > all
> > > > >
> > > > > the necessary state (the virtqueue vring base plus the possible
> > > > > device
> > > > >
> > > > > specific states) that is required for restoring in the future. Th=
e
> > > > >
> > > > > device must not change its configuration after that point.
> > > > >
> > > > >
> > > > >
> > > > > After the return of ioctl with stop =3D=3D 0, the device can cont=
inue
> > > > >
> > > > > processing buffers as long as typical conditions are met (vq is
> > > > > enabled,
> > > > >
> > > > > DRIVER_OK status bit is enabled, etc).
> > > >
> > > > Just to be clear, we are adding vdpa level new ioctl() that doesn=
=E2=80=99t map to
> > any mechanism in the virtio spec.
> > > >
> > > > Why can't we use this ioctl() to indicate driver to start/stop the =
device
> > instead of driving it through the driver_ok?
> > > > This is in the context of other discussion we had in the LM series.
> > >
> > > If there's something in the spec that does this then let's use that.
> >
> > Actually, we try to propose a independent feature here:
> >
> > https://lists.oasis-open.org/archives/virtio-dev/202111/msg00020.html
> >
> This will stop the device for all the operations.
> Once the device is stopped, its state cannot be queried further as device=
 won't respond.
> It has limited use case.
> What we need is to stop non admin queue related portion of the device.
>

Still don't follow this, sorry.

Adding the admin vq to the mix, this would stop a device of a device
group, but not the whole virtqueue group. If the admin VQ is offered
by the PF (since it's not exposed to the guest), it will continue
accepting requests as normal. If it's exposed in the VF, I think the
best bet is to shadow it, since guest and host requests could
conflict.

Since this is offered through vdpa, the device backend driver can
route it to whatever method works better for the hardware. For
example, to send an admin vq command to the PF. That's why it's
important to keep the feature as self-contained and orthogonal to
others as possible.

> > Does it make sense to you?
> >
> > Thanks
> >
> > > Unfortunately the LM series seems to be stuck on moving bits around
> > > with the admin virtqueue ...
> > >
> > > --
> > > MST
> > >
>

